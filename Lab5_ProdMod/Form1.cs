using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static Lab5_ProdMod.Program;
using static Lab5_ProdMod.Parser;
using static Lab5_ProdMod.Search;
using static Lab5_ProdMod.FactType;

namespace Lab5_ProdMod
{
    public partial class Form1 : Form
    {
        public List<Fact> facts = new List<Fact>();
        public static List<Product> PROD = new List<Product>();
        public List<Fact> _axioms = new List<Fact>();
        public List<CheckBox> _axiomsCB = new List<CheckBox>();
        public List<Fact> _targets = new List<Fact>();
        public List<CheckBox> _targetsCB = new List<CheckBox>();
        public List<Node> nodes = new List<Node>();

        public static string endl = "\r\n";

        public Form1()
        {
            InitializeComponent();

            //Parse(ref facts, ref PROD);
            ParseC(ref facts, ref PROD);
            FillProduct(ref PROD, facts);
            FillProductDescription(PROD);
            //OutputDescriptionInFile(PROD);
            OutputDescriptionInFileC(PROD);

            foreach (var item in facts)
            {
                item.FindProd(PROD);
                Console.WriteLine(item.ToString() + '\n' + item.FactInProducts() + '\n');
            }

            foreach (var item in facts)
            {
                if (item.IsUseless())
                {
                    Console.WriteLine(item.ToString());
                }
            }

            foreach (var item in facts)
            {
                if (item.FT == A)
                    _axioms.Add(item);
                if (item.FT == T)
                    _targets.Add(item);
            }

            int count = 0;
            foreach (var item in _axioms)
            {
                CheckBox cb = new CheckBox();
                cb.Text = item.description;
                cb.Location = new Point(15, 5 + 20 * count);
                cb.Size = new Size(130, 20);
                count++;
                _axiomsCB.Add(cb);
                Axiom_BOX.Controls.Add(cb);
            }

            count = 0;
            foreach (var item in _targets)
            {
                CheckBox cb = new CheckBox();
                cb.Text = item.description;
                cb.Location = new Point(15, 5 + 20 * count);
                cb.Size = new Size(230, 20);
                count++;
                _targetsCB.Add(cb);
                Target_BOX.Controls.Add(cb);
            }



        }

        public void CheckFacts()
        {
            for (int i = 0; i < _axiomsCB.Count; i++)
            {
                if (_axiomsCB[i].Checked) _axioms[i].isTrue = true;
            }

            for (int i = 0; i < _targetsCB.Count; i++)
            {
                if (_targetsCB[i].Checked) _targets[i].isTrue = true;
            }
        }

        private void Forward_B_Click(object sender, EventArgs e)
        {
            Clear();
            CheckFacts();
            FillNodes(ref nodes, PROD);

            string text = "";
            FS(nodes, ref text);


            Res_TB.Text = text;
        }

        private void Back_B_Click(object sender, EventArgs e)
        {
            Clear();
            CheckFacts();
            FillNodes(ref nodes, PROD);

            string text = "";
            BS(nodes, ref text);


            Res_TB.Text = text;

        }

        public void Clear()
        {
            Res_TB.Text = "";
            foreach (var item in facts)
            {
                nodes.Clear();
                item.isTrue = false;
                item.isA = false;
            }
        }

        private void HELP_BT_Click(object sender, EventArgs e)
        {
            List<string> productDescription = new List<string>();
            Form2 f2 = new Form2();

            foreach (Product product in PROD) productDescription.Add(product.description);
            int count = 1;
            foreach (var item in productDescription)
            {
                f2.RULES_TB.Text += $"{count++}: {item} {endl}";
            }
            f2.Show();
        }
    }
}
