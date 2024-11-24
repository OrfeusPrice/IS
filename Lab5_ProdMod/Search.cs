using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab5_ProdMod
{
    internal class Search
    {
        public static void FillNodes(ref List<Node> nodes, List<Product> prods)
        {
            foreach (Product product in prods)
            {
                nodes.Add(new Node(product));
            }

            foreach (var node in nodes)
            {
                foreach (var n in nodes)
                {
                    if (n.prod.inputFacts.Contains(node.prod.result))
                    {
                        node.nextNodes.Add(n);
                    }
                }
            }
        }

        public static void ForwardSearch(List<Node> nodes, ref string text)
        {
            List<Fact> targets = new List<Fact>();

            foreach (var item in nodes)
            {
                if (item.prod.result.isTrue && item.prod.result.FT == FactType.Target)
                    targets.Add(item.prod.result);
            }

            List<Node> trueNodes = new List<Node>();
            foreach (Node node in nodes)
            {
                if (node.prod.inputFacts.All(x => x.isTrue))
                {
                    node.prod.result.isTrue = true;
                    trueNodes.Add(node);
                }
            }

            List<Node> closeList = new List<Node>();
            Queue<Node> queue = new Queue<Node>();

            foreach (var item in trueNodes)
            {
                queue.Enqueue(item);
            }

            while (queue.Count > 0)
            {
                var node = queue.Dequeue();

                if (!closeList.Contains(node))
                {
                    closeList.Add(node);
                    foreach (var item in node.nextNodes)
                    {
                        if (item.prod.inputFacts.All(x => x.isTrue))
                        {
                            item.prod.result.isTrue = true;
                        }
                        queue.Enqueue(item);
                    }

                    if (node.prod.result.isTrue && node.prod.result.FT == FactType.Сonsequence)
                        text += node.prod.description + '\r' + '\n';
                }
            }
            foreach (var item in targets)
            {
                foreach (var i in item.productsRes)
                {
                    if (i.inputFacts.All(x => x.isTrue))
                    {
                        text += "ДОКАЗАНО: " + i.description + '\r' + '\n';
                        break;
                    }
                    else
                    {
                        text += "НЕ ДОКАЗАНО: " + i.description + '\r' + '\n';
                        break;
                    }
                }
            }
        }

        public static void BackwardSearch(List<Node> nodes, ref string text)
        {
            Fact target = new Fact("f000", "null", FactType.Target);
            Node targetNode = nodes[0];
            List<Fact> axioms = new List<Fact>();
            int CountAxioms = 0;

            foreach (var item in nodes)
            {
                if (item.prod.result.isTrue && item.prod.result.FT == FactType.Target)
                {
                    target = item.prod.result;
                    targetNode = item;
                    break;
                }
            }

            foreach (var item in nodes)
            {
                foreach (var i in item.prod.inputFacts)
                {
                    if (i.FT == FactType.Axioma && i.isTrue && !axioms.Contains(i))
                        axioms.Add(i);
                }
            }

            List<Node> orNodes = new List<Node>();
            List<Node> andNodes = new List<Node>();

            foreach (Node item in nodes)
            {
                if (item.prod.result.productsRes.Count > 1)
                    orNodes.Add(item);
                else andNodes.Add(item);
            }

            Queue<Node> queue = new Queue<Node>();

            queue.Enqueue(targetNode);
            List<Node> closeList = new List<Node>();

            while (queue.Count > 0)
            {
                Node node = queue.Dequeue();
                if (!closeList.Contains(node))
                {
                    closeList.Add(node);
                    if (orNodes.Contains(node))
                    {
                        foreach (var item in nodes)
                        {
                            if (item.nextNodes.Contains(node))
                                queue.Enqueue(item);
                        }

                        if (node.prod.result.productsRes.Any(p => p.inputFacts.All(x => (axioms.Contains(x) || x.FT != FactType.Axioma) && x.isTrue)))
                        {
                            foreach (var item in node.prod.inputFacts)
                            {
                                if (item.FT == FactType.Axioma && item.isTrue && axioms.Contains(item))
                                {
                                    if (!item.isAxiomTrue)
                                    {
                                        text += "АКСИОМА ПОДТВЕРЖДЕНА: " + item.description + '\r' + '\n';
                                        CountAxioms++;
                                        item.isAxiomTrue = true;
                                    }
                                }
                            }
                        }

                    }

                    if (andNodes.Contains(node))
                    {
                        foreach (var item in nodes)
                        {
                            if (item.nextNodes.Contains(node))
                                queue.Enqueue(item);
                        }

                        if (node.prod.result.productsRes.All(p => p.inputFacts.All(x => (axioms.Contains(x) || x.FT != FactType.Axioma) && x.isTrue)))
                        {
                            foreach (var item in node.prod.inputFacts)
                            {
                                if (item.FT == FactType.Axioma && item.isTrue && axioms.Contains(item))
                                {
                                    if (!item.isAxiomTrue)
                                    {
                                        text += "АКСИОМА ПОДТВЕРЖДЕНА: " + item.description + '\r' + '\n';
                                        CountAxioms++;
                                        item.isAxiomTrue = true;
                                    }
                                }
                            }
                        }
                    }

                    List<Node> tempCloseList = new List<Node>();

                    foreach (var closeNode in closeList)
                    {
                        tempCloseList.Add(closeNode);
                        if (closeNode.prod.inputFacts.All(x => x.isTrue) && !closeNode.prod.result.isTrue)
                        {
                            closeNode.prod.result.isTrue = true;
                            tempCloseList.Remove(closeNode);
                            queue.Enqueue(closeNode);
                        }
                    }
                    closeList = tempCloseList;
                }
            }

            foreach (var a in axioms)
            {
                if (!a.isAxiomTrue)
                    text += "АКСИОМА НЕ ПОДТВЕРЖДЕНА: " + a.description + '\r' + '\n';
            }

            if (CountAxioms == axioms.Count)
            {
                foreach (var item in target.productsRes)
                {
                    text += "ДОКАЗАНО: " + item.description + '\r' + '\n';
                }
            }
            else
            {
                foreach (var item in target.productsRes)
                {
                    text += "НЕ ДОКАЗАНО: " + item.description + '\r' + '\n';
                }
            }
        }
    }
}
