using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Lab5_ProdMod.FactType;


namespace Lab5_ProdMod
{
    public enum FactType { A = 0, C, T }
    public class Fact
    {
        public string name;
        public string description;
        public FactType FT;
        public List<Product> AtoR;
        public List<Product> RtoP;
        public bool isTrue = false;
        public bool isAxiomTrue = false;
        public Fact(string name, string description, FactType ft)
        {
            this.name = name;
            this.description = description;
            this.FT = ft;
            AtoR = new List<Product>();
            RtoP = new List<Product>();
        }

        public void FindProd(List<Product> products)
        {
            foreach (Product product in products)
                if (product.inputFacts.Contains(this)) AtoR.Add(product);
                else if (product.result == this) RtoP.Add(product);
        }

        public bool IsUseless() => AtoR.Count == 0 && RtoP.Count == 0;

        public string FactInProducts()
        {
            string text = "";

            foreach (var item in AtoR)
                text += item.text + '\n';

            foreach (var item in RtoP)
                text += item.text + '\n';

            return text;
        }

        public override string ToString() => $"Fact Info: {name},{description},{FT.ToString()}";
        public override bool Equals(object obj) => name == (obj as Fact).name;
    }

    public class Product
    {
        public string text;
        public List<Fact> inputFacts;
        public Fact result;
        public string description;

        public Product(string text)
        {
            this.text = text;
            inputFacts = new List<Fact>();
            result = new Fact("f00", "Нет факта", C);
        }
    }

    public class Node
    {
        public Product p;
        public Fact f;
        public List<Fact> input = new List<Fact>();
        public List<Node> nextNodes = new List<Node>();
        public bool isT = false;

        public Node(Product p)
        {
            this.p = p;
            f = p.result;
            input = p.inputFacts;
            isT = f.isTrue;
        }

        public void SetT()
        {
            isT = true;
            f.isTrue = true;
        }
    }

    public class OrNode : Node
    {
        public OrNode(Product p) : base(p) { }

        public void TryProve(List<Fact> axioms, ref string text)
        {
            if (f.RtoP.Any(p => p.inputFacts.All(x => (axioms.Contains(x) || x.FT != A) && x.isTrue)))
                foreach (var item in input)
                    if (item.FT == A && item.isTrue && axioms.Contains(item))
                        if (!item.isAxiomTrue)
                        {
                            text += "+  A: " + item.description + '\r' + '\n';
                            item.isAxiomTrue = true;
                        }
        }
    }
    public class AndNode : Node
    {
        public AndNode(Product p) : base(p) { }

        public void TryProve(List<Fact> axioms, ref string text)
        {
            if (f.RtoP.All(p => p.inputFacts.All(x => (axioms.Contains(x) || x.FT != A) && x.isTrue)))
                foreach (var item in input)
                    if (item.FT == A && item.isTrue && axioms.Contains(item))
                        if (!item.isAxiomTrue)
                        {
                            text += "+  A: " + item.description + '\r' + '\n';
                            item.isAxiomTrue = true;
                        }
        }
    }
}
