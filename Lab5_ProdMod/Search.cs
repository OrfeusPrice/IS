using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using static Lab5_ProdMod.FactType;
using static Lab5_ProdMod.Form1;

namespace Lab5_ProdMod
{
    internal class Search
    {
        public static void FillNodes(ref List<Node> nodes, List<Product> prods)
        {
            foreach (Product product in prods)
                nodes.Add(new Node(product));

            List<Node> temp = new List<Node>();

            foreach (Node item in nodes)
                if (item.f.RtoP.Count > 1)
                    temp.Add(new OrNode(item.p));
                else
                    temp.Add(new AndNode(item.p));

            nodes = temp;

            foreach (var node in nodes)
                foreach (var n in nodes)
                    if (n.left.Contains(node.f))
                        node.nextNodes.Add(n);
        }

        public static void FS(List<Node> nodes, ref string text)
        {
            List<Fact> targets = new List<Fact>();

            foreach (var item in nodes)
                if (item.f.isTrue && item.f.FT == T)
                    targets.Add(item.f);

            List<Node> trueNodes = new List<Node>();
            foreach (Node node in nodes)
                if (node.LeftIsTrue())
                {
                    node.SetT();
                    trueNodes.Add(node);
                }

            List<Node> closed = new List<Node>();
            Queue<Node> queue = new Queue<Node>();

            foreach (var item in trueNodes)
                queue.Enqueue(item);

            while (queue.Count > 0)
            {
                var node = queue.Dequeue();

                if (!closed.Contains(node))
                {
                    closed.Add(node);
                    foreach (var item in node.nextNodes)
                    {
                        if (item.LeftIsTrue())
                            item.SetT();

                        queue.Enqueue(item);
                    }

                    if (node.f.isTrue && node.f.FT == C)
                        text += "+  A: " + node.p.description + endl;
                }
            }
            foreach (var item in targets)
            {
                foreach (var i in item.RtoP)
                {
                    if (i.left.All(x => x.isTrue))
                    {
                        text += "+  T: " + i.description + endl;
                        break;
                    }
                    else
                    {
                        text += "-  T: " + i.description + endl;
                        break;
                    }
                }
            }
        }

        public static void BS(List<Node> nodes, ref string text)
        {
            Fact target = new Fact("f000", "null", T);
            Node targetNode = nodes[0];
            List<Fact> axioms = new List<Fact>();

            foreach (var item in nodes)
            {
                if (item.f.isTrue && item.f.FT == T)
                {
                    target = item.f;
                    targetNode = item;
                    break;
                }
            }

            foreach (var item in nodes)
            {
                foreach (var i in item.left)
                {
                    if (i.FT == A && i.isTrue && !axioms.Contains(i))
                        axioms.Add(i);
                }
            }

            Queue<Node> queue = new Queue<Node>();

            queue.Enqueue(targetNode);
            List<Node> closed = new List<Node>();

            while (queue.Count > 0)
            {
                Node node = queue.Dequeue();
                if (!closed.Contains(node))
                {
                    closed.Add(node);

                    foreach (var item in nodes)
                    {
                        if (item.nextNodes.Contains(node))
                            queue.Enqueue(item);
                    }

                    if (node is OrNode) (node as OrNode).TryProve(axioms, ref text);
                    else if (node is AndNode) (node as AndNode).TryProve(axioms, ref text);

                    List<Node> temp = new List<Node>();
                    closed.ForEach(x => temp.Add(x));
                    
                    foreach (var cn in closed)
                        if (cn.LeftIsTrue() && !cn.isT)
                        {
                            cn.SetT();
                            queue.Enqueue(cn);
                            temp.Remove(cn);
                        }
                    closed = temp;
                }
            }

            foreach (var node in nodes)
            {
                if (node.isT && node.f.FT != T)
                {
                    text += $"{node.f.FT}: {node.d} {endl}";
                }
            }

            if (axioms.All(x => x.isA) && axioms.Count > 0)
            {
                foreach (var item in target.RtoP)
                {
                    text += "+  T: " + item.description + endl;
                }
            }
            else
            {
                foreach (var item in target.RtoP)
                {
                    text += "-  T: " + item.description + endl;
                }
            }
        }
    }
}
