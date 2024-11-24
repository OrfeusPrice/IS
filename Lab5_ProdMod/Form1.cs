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

namespace Lab5_ProdMod
{
    public partial class Form1 : Form
    {
        public List<Fact> facts = new List<Fact>();
        public List<Product> products = new List<Product>();

        public List<Fact> _axioms = new List<Fact>();
        public List<CheckBox> _axiomsCB = new List<CheckBox>();
        public List<Fact> _targets = new List<Fact>();
        public List<CheckBox> _targetsCB = new List<CheckBox>();
        public List<Node> nodes = new List<Node>();
        public Form1()
        {
            InitializeComponent();
            

            //Parse(ref facts, ref products);
            ParseC(ref facts, ref products);
            FillProduct(ref products, facts);
            FillProductDescription(products);
            //OutputDescriptionInFile(products);
            OutputDescriptionInFileC(products);

            List<string> productDescription = new List<string>();

            foreach (Product product in products) productDescription.Add(product.description);
            int count = 1;

            //Заполняем TextBox со всеми правилами для просмотра
            foreach (var item in productDescription)
            {
                RULES_TB.Text += $"{count++}: {item} \r\n\r\n";
            }

            //Просто вывод фактов в консоль для отладки
            foreach (var item in facts)
            {
                item.FindProd(products);
                Console.WriteLine(item.ToString() + '\n' + item.FactInProducts() + '\n');
            }

            //Проверка, есть ли бесполезные факты и какие
            foreach (var item in facts)
            {
                if (item.IsUseless())
                {
                    Console.WriteLine(item.ToString());
                }
            }

            foreach (var item in facts)
            {
                if (item.FT == FactType.Axioma)
                    _axioms.Add(item);
                if (item.FT == FactType.Target)
                    _targets.Add(item);
            }

            count = 1;
            foreach (var item in _axioms)
            {
                CheckBox cb = new CheckBox();
                cb.Text = item.description;
                cb.Location = new Point(15, 20 * count);
                cb.Size = new Size(130, 20);
                count++;
                _axiomsCB.Add(cb);
                Axiom_BOX.Controls.Add(cb);
            }

            count = 1;
            foreach (var item in _targets)
            {
                CheckBox cb = new CheckBox();
                cb.Text = item.description;
                cb.Location = new Point(15, 20 * count);
                cb.Size = new Size(230, 20);
                count++;
                _targetsCB.Add(cb);
                Target_BOX.Controls.Add(cb);
            }

            FillNodes(ref nodes, products);


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
            CheckFacts();
            string text = "";
            ForwardSearch(nodes, ref text);


            Res_TB.Text = text;
        }

        private void Back_B_Click(object sender, EventArgs e)
        {
            CheckFacts();
            string text = "";
            BackwardSearch(nodes, ref text);


            Res_TB.Text = text;

        }

        private void Clear_B_Click(object sender, EventArgs e)
        {
            Res_TB.Text = "";
            foreach (var item in facts)
            {
                item.isTrue = false;
                item.isAxiomTrue = false;
            }
        }
    }
}
