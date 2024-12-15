using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace NeuralNetwork1
{
    /// <summary>
    /// Тип фигуры
    /// </summary>
    public enum FigureType : byte
    {
        Mercury = 0,
        Venus,
        Earth,
        Mars,
        Jupiter,
        Saturn,
        Uranus,
        Neptune,
        Sun,
        Moon,
        Undef
    };

    public class GenerateImage
    {
        string pathToDataset = "../../dataset/";
        string testDataSetPath = "../../test/";


        /// <summary>
        /// Бинарное представление образа
        /// </summary>
        public bool[,] img = new bool[100, 100];

        //  private int margin = 50;
        private Random rand = new Random();

        /// <summary>
        /// Текущая сгенерированная фигура
        /// </summary>
        public FigureType currentFigure = FigureType.Undef;

        /// <summary>
        /// Количество классов генерируемых фигур (4 - максимум)
        /// </summary>
        public int FigureCount { get; set; } = 10;

        /// <summary>
        /// Очистка образа
        /// </summary>
        public void ClearImage()
        {
            for (int i = 0; i < 100; ++i)
                for (int j = 0; j < 100; ++j)
                    img[i, j] = false;
        }

        public Sample GenerateFigure(PictureBox pb, bool isTest = false)
        {
            generate_figure(pb);
            double[] input = new double[200];
            for (int i = 0; i < 200; i++)
                input[i] = 0;

            FigureType type = currentFigure;

            for (int i = 0; i < 100; i++)
                for (int j = 0; j < 100; j++)
                    if (img[i, j])
                    {
                        input[i] += 1;
                        input[100 + j] += 1;
                    }
            return new Sample(input, FigureCount, type);
        }

        public Sample GenerateExtFigure(Bitmap bm, FigureType fg, PictureBox pb)
        {
            pb.Image = bm;
            bm = new Bitmap(pb.Image);
            double[] input = new double[200];
            for (int i = 0; i < 200; i++)
                input[i] = 0;

            FigureType type = fg;

            int R = Color.Black.R;
            int G = Color.Black.G;
            int B = Color.Black.B;
            int dif = 230;

            for (int i = 0; i < 100; i++)
            {
                for (int j = 0; j < 100; j++)
                {
                    if (Math.Abs(bm.GetPixel(i, j).R - R) < dif &&
                        Math.Abs(bm.GetPixel(i, j).B - B) < dif &&
                        Math.Abs(bm.GetPixel(i, j).G - G) < dif)
                        bm.SetPixel(i, j, Color.Black);
                    else
                        bm.SetPixel(i, j, Color.White);
                }
            }

            for (int i = 0; i < 100; i++)
            {
                for (int j = 0; j < 100; j++)
                {
                    if (bm.GetPixel(i, j).R != R && bm.GetPixel(i, j).B != B && bm.GetPixel(i, j).G != G)
                        img[i, j] = false;
                    else
                        img[i, j] = true;
                }
            }

            for (int i = 0; i < 100; i++)
                for (int j = 0; j < 100; j++)
                    if (img[i, j])
                    {
                        input[i] += 1;
                        input[100 + j] += 1;
                    }
            return new Sample(input, FigureCount, type);
        }


        public void CreateFig(FigureType fg, PictureBox pb, bool isTest = false)
        {
            Random random = new Random();
            string filePath = pathToDataset + "//" + fg.ToString();
            if (isTest)
                filePath = testDataSetPath + "//" + fg.ToString();

            List<String> imgs = new List<string>();
            foreach (var item in Directory.GetFiles(filePath))
            {
                imgs.Add(item.ToString());
            }

            int ind = rand.Next(0, imgs.Count);

            pb.Image = Image.FromFile(imgs[ind]);

            Bitmap bm = new Bitmap(pb.Image);

            int R = Color.Black.R;
            int G = Color.Black.G;
            int B = Color.Black.B;

            for (int i = 0; i < 100; i++)
            {
                for (int j = 0; j < 100; j++)
                {
                    if (bm.GetPixel(i, j).R != R && bm.GetPixel(i, j).B != B && bm.GetPixel(i, j).G != G)
                        img[i, j] = false;
                    else
                        img[i, j] = true;
                }
            }
            currentFigure = fg;

        }

        public void generate_figure(PictureBox pb, bool isTest = false,FigureType type = FigureType.Undef)
        {

            if (type == FigureType.Undef || (int)type >= FigureCount)
                type = (FigureType)rand.Next(FigureCount);
            ClearImage();
            switch (type)
            {
                case FigureType.Mercury: CreateFig(FigureType.Mercury, pb); break;
                case FigureType.Venus: CreateFig(FigureType.Venus, pb); break;
                case FigureType.Earth: CreateFig(FigureType.Earth, pb); break;
                case FigureType.Mars: CreateFig(FigureType.Mars, pb); break;
                case FigureType.Jupiter: CreateFig(FigureType.Jupiter, pb); break;
                case FigureType.Saturn: CreateFig(FigureType.Saturn, pb); break;
                case FigureType.Uranus: CreateFig(FigureType.Uranus, pb); break;
                case FigureType.Neptune: CreateFig(FigureType.Neptune, pb); break;
                case FigureType.Sun: CreateFig(FigureType.Sun, pb); break;
                case FigureType.Moon: CreateFig(FigureType.Moon, pb); break;


                default:
                    type = FigureType.Undef;
                    throw new Exception("WTF?!!! Не могу я создать такую фигуру!");
            }
        }

        /// <summary>
        /// Возвращает битовое изображение для вывода образа
        /// </summary>
        /// <returns></returns>
        public Bitmap GenBitmap()
        {
            Bitmap drawArea = new Bitmap(100, 100);
            for (int i = 0; i < 100; ++i)
                for (int j = 0; j < 100; ++j)
                    if (img[i, j])
                        drawArea.SetPixel(i, j, Color.Black);
            return drawArea;
        }
    }

}
