using DocumentFormat.OpenXml.Wordprocessing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using static Lab5_ProdMod.FactType;

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
                    if (n.input.Contains(node.f))
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
                if (node.input.All(x => x.isTrue))
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
                        if (item.input.All(x => x.isTrue))
                            item.SetT();
                        
                        queue.Enqueue(item);
                    }

                    if (node.f.isTrue && node.f.FT == C)
                        text += "+  A: " + node.p.description + '\r' + '\n';
                }
            }
            foreach (var item in targets)
            {
                foreach (var i in item.RtoP)
                {
                    if (i.inputFacts.All(x => x.isTrue))
                    {
                        text += "+  T: " + i.description + '\r' + '\n';
                        break;
                    }
                    else
                    {
                        text += "-  T: " + i.description + '\r' + '\n';
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
                foreach (var i in item.input)
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
                    foreach (var item in closed)
                        temp.Add(item);

                    foreach (var cn in closed)
                    {
                        if (cn.input.All(x => x.isTrue) && !cn.f.isTrue)
                        {
                            cn.SetT();
                            temp.Remove(cn);
                            queue.Enqueue(cn);
                        }
                    }
                    closed = temp;
                }
            }

            foreach (var a in axioms)
            {
                if (!a.isAxiomTrue)
                    text += "-  A: " + a.description + '\r' + '\n';
            }

            if (axioms.All(x => x.isAxiomTrue))
            {
                foreach (var item in target.RtoP)
                {
                    text += "+  T: " + item.description + '\r' + '\n';
                }
            }
            else
            {
                foreach (var item in target.RtoP)
                {
                    text += "-  T: " + item.description + '\r' + '\n';
                }
            }
        }
    }
}
