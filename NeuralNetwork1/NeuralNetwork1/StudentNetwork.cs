using Accord.Math;
using Accord.Neuro;
using NeuralNetwork1;
using System;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;

namespace NeuralNetwork1
{
    public class StudentNetwork : BaseNetwork
    {
        public static Action<int> onGetBadNeuronsCount;

        private readonly Stopwatch _stopwatch = new Stopwatch();
        private static readonly Random _rand = new Random();

        public static int[] _structure;
        public static Layer[] newLayers;
        public static double SigmoidFunction(double input) => 1 / (1 + Math.Exp(-input));
        public static double LearningRate = 0.03;

        public static Layer[] layers;

        public class Layer
        {
            public Neuron[] Neurons;

            public Layer(int neuronsCount, Layer previousLayer = null)
            {
                Neurons = new Neuron[neuronsCount];
                for (int i = 0; i < neuronsCount; i++)
                {
                    Neurons[i] = new Neuron(previousLayer?.Neurons);
                }
            }
        }

        public class Neuron
        {
            public Neuron[] prevNeurons;
            public double output;
            public double[] weights;
            public double error;
            public double bias;
            public int badCount = 0;

            public void ResetBadCount()
            {
                badCount = 0;
            }

            public Neuron(Neuron[] previousLayerNeurones = null)
            {
                prevNeurons = previousLayerNeurones ?? Array.Empty<Neuron>();
                weights = new double[prevNeurons.Length];
                InitializeWeights();
            }

            private void InitializeWeights()
            {
                double deviation = 1.0 / Math.Sqrt(weights.Length);
                for (int i = 0; i < weights.Length; i++)
                {
                    weights[i] = _rand.NextDouble() * 2 * deviation - deviation;
                }
                bias = _rand.NextDouble() * 2 * deviation - deviation;
            }

            public void ComputeActivation()
            {
                double sum = bias;
                for (int i = 0; i < prevNeurons.Length; i++)
                {
                    sum += prevNeurons[i].output * weights[i];
                }
                output = SigmoidFunction(sum);
                if (Math.Abs(output) > 0.99) badCount++;
            }

            public void UpdWeightsAndBiases()
            {
                for (int i = 0; i < weights.Length; i++)
                {
                    weights[i] -= LearningRate * error * prevNeurons[i].output;
                }
                bias -= LearningRate * error;
            }
        }

        public StudentNetwork(int[] structure)
        {
            InitializeNetwork(structure);
            _structure = structure;
        }

        private void InitializeNetwork(int[] structure)
        {
            layers = new Layer[structure.Length];
            layers[0] = new Layer(structure[0]);

            for (int i = 1; i < structure.Length; i++)
            {
                layers[i] = new Layer(structure[i], layers[i - 1]);
            }
        }

        protected override double[] Compute(double[] inputValues)
        {
            for (int i = 0; i < layers[0].Neurons.Length; i++)
            {
                layers[0].Neurons[i].output = inputValues[i];
            }

            for (int i = 1; i < layers.Length; i++)
            {
                foreach (var neuron in layers[i].Neurons)
                {
                    neuron.ComputeActivation();
                }
            }
            //  пройти по всем нейронам сети, и посчитать два значения - кол-во нейронов всего и кол-во тех, у которых более 100 промахов

            return layers.Last().Neurons.Select(neuron => neuron.output).ToArray();
        }

        public double[] Run(Sample sample)
        {
            var newLayers = layers.RemoveAt(0);
            newLayers = newLayers.RemoveAt(newLayers.Count() - 1);

            foreach (var layer in newLayers)
            {
                foreach (var item in layer.Neurons)
                {
                    item.ResetBadCount();
                }
            }

            var output = Compute(sample.input);
            sample.ProcessPrediction(output);
            return output;
        }

        public override int Train(Sample sample, double acceptableError, bool parallel)
        {
            int iterations = 0;
            Run(sample);
            double currentError = sample.EstimatedError();

            while (currentError > acceptableError)
            {
                iterations++;
                Run(sample);
                currentError = sample.EstimatedError();
                if (!parallel)
                    BackpropagateError(sample);
                else
                    ParallelBackpropagateError(sample);
            }

            return iterations;
        }

        public override double TrainOnDataSet(SamplesSet sampleSet, int epochsCount, double acceptableError, bool parallel)
        {
            newLayers = layers.RemoveAt(0);
            newLayers = newLayers.RemoveAt(newLayers.Count() - 1);

            foreach (var layer in newLayers)
            {
                foreach (var item in layer.Neurons)
                {
                    item.ResetBadCount();
                }
            }

            _stopwatch.Restart();
            double totalError = 0;

            for (int epoch = 0; epoch < epochsCount; epoch++)
            {
                double epochError = 0;

                if (parallel)
                {
                    object lockObj = new object();

                    Parallel.ForEach(sampleSet.samples, sample =>
                    {
                        int result = Train(sample, acceptableError, parallel);
                        if (result == 0)
                        {
                            double sampleError = sample.EstimatedError();
                            lock (lockObj)
                            {
                                epochError += sampleError;
                            }
                        }
                    });
                }
                else
                {
                    foreach (var sample in sampleSet.samples)
                    {
                        int result = Train(sample, acceptableError, parallel);
                        if (result == 0) epochError += sample.EstimatedError();
                    }
                }

                totalError = epochError;
                OnTrainProgress(((epoch + 1) * 1.0) / epochsCount, totalError, _stopwatch.Elapsed);
            }

            _stopwatch.Stop();
            return totalError;
        }

        private void BackpropagateError(Sample sample)
        {
            for (int i = 0; i < layers.Last().Neurons.Length; i++)
            {
                layers.Last().Neurons[i].error = sample.error[i];
            }

            for (int layerIndex = layers.Length - 2; layerIndex > 0; layerIndex--)
            {
                foreach (var neuron in layers[layerIndex].Neurons)
                {
                    double errorSum = layers[layerIndex + 1].Neurons.Sum(nextNeuron =>
                        nextNeuron.error * nextNeuron.weights[Array.IndexOf(layers[layerIndex].Neurons, neuron)]
                    );
                    neuron.error = errorSum * neuron.output * (1 - neuron.output);
                }
            }

            foreach (var neuron in layers.Last().Neurons)
            {
                neuron.UpdWeightsAndBiases();
            }

            for (int layerIndex = layers.Length - 2; layerIndex > 0; layerIndex--)
            {
                foreach (var neuron in layers[layerIndex].Neurons)
                {
                    neuron.UpdWeightsAndBiases();
                }
            }
        }

        private void ParallelBackpropagateError(Sample sample)
        {
            Parallel.For(0, layers.Last().Neurons.Length, i =>
            {
                layers.Last().Neurons[i].error = sample.error[i];
            });

            for (int layerIndex = layers.Length - 2; layerIndex > 0; layerIndex--)
            {
                Parallel.ForEach(layers[layerIndex].Neurons, neuron =>
                {
                    double errorSum = layers[layerIndex + 1].Neurons.Sum(nextNeuron =>
                        nextNeuron.error * nextNeuron.weights[Array.IndexOf(layers[layerIndex].Neurons, neuron)]
                    );
                    neuron.error = errorSum * neuron.output * (1 - neuron.output);
                });
            }

            Parallel.ForEach(layers.Last().Neurons, neuron =>
            {
                neuron.UpdWeightsAndBiases();
            });

            for (int layerIndex = layers.Length - 2; layerIndex > 0; layerIndex--)
            {
                Parallel.ForEach(layers[layerIndex].Neurons, neuron =>
                {
                    neuron.UpdWeightsAndBiases();
                });
            }
        }
    }
}
