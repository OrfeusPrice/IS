using DocumentFormat.OpenXml.Office2016.Drawing.ChartDrawing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Lab5_ProdMod.FactType;
using static Lab5_ProdMod.Form1;


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
        public bool isA = false;
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
                if (product.left.Contains(this)) AtoR.Add(product);
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

        public override string ToString() => $"Fact Info: {name},{description},{FT.ToString()},{isTrue.ToString()}";
        public override bool Equals(object obj) => name == (obj as Fact).name;
    }

    public class Product
    {
        public string text;
        public List<Fact> left;
        public Fact result;
        public string description;

        public Product(string text)
        {
            this.text = text;
            left = new List<Fact>();
            result = new Fact("f00", "Нет факта", C);
        }
    }

    public class Node
    {
        public Product p;
        public Fact f;
        public List<Fact> left = new List<Fact>();
        public List<Node> nextNodes = new List<Node>();
        public bool isT = false;
        public string d;

        public Node(Product p)
        {
            this.p = p;
            f = p.result;
            left = p.left;
            isT = f.isTrue;
            d = p.description;
        }

        public void SetT()
        {
            isT = true;
            f.isTrue = true;
        }

        public bool LeftIsTrue() => left.All(x => x.isTrue);
        public bool IsTrueAndSelected(List<Fact> l, Fact e) => (l.Contains(e) || e.FT != A) && e.isTrue;
        public bool IsTrueSelectedA(List<Fact> l, Fact e) => e.isTrue && l.Contains(e);
        public void SetAxIsTrue(List<Fact> l, ref string text)
        {
            foreach (var item in left)
                if (item.FT == A && item.isTrue && l.Contains(item))
                    if (!item.isA)
                    {
                        text += "+  A: " + item.description + endl;
                        item.isA = true;
                    }
        }
    }

    public class OrNode : Node
    {
        public OrNode(Product p) : base(p) { }

        public void TryProve(List<Fact> l, ref string text)
        {
            if (f.RtoP.Any(p => p.left.All(x => IsTrueAndSelected(l, x))))
                SetAxIsTrue(l, ref text);
        }
    }
    public class AndNode : Node
    {
        public AndNode(Product p) : base(p) { }

        public void TryProve(List<Fact> l, ref string text)
        {
            if (f.RtoP.All(p => p.left.All(x => IsTrueAndSelected(l, x))))
                SetAxIsTrue(l, ref text);
        }
    }
}
