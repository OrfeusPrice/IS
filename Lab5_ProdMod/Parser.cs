using ClosedXML.Excel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClosedXML.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using static Lab5_ProdMod.FactType;


namespace Lab5_ProdMod
{
    internal class Parser
    {
        public static void Parse(ref List<Fact> facts, ref List<Product> products)
        {
            string filePath = "../../PM.xlsx";

            var workbook = new XLWorkbook(filePath);
            var worksheet = workbook.Worksheet(1);

            for (int row = 1; row <= 139; row++)
            {
                FactType ft = T;

                if (row >= 1 && row <= 28 || row == 108) ft = A;
                if (row >= 29 && row <= 51 || row >= 83 && row <= 86) ft = C;


                facts.Add(new Fact(worksheet.Cell(row, 1).Value.ToString(), worksheet.Cell(row, 2).Value.ToString(), ft));
            }

            Random random = new Random();

            for (int row = 1; row <= 122; row++)
            {
                products.Add(new Product(worksheet.Cell(row, 3).Value.ToString(),(float)((float)random.Next(55 - row/7,100) / 100)));
            }
        }

        public static void ParseC(ref List<Fact> facts, ref List<Product> products)
        {
            string filePath = "../../Test.xlsx";

            var workbook = new XLWorkbook(filePath);
            var worksheet = workbook.Worksheet(1);

            for (int row = 1; row <= 15; row++)
            {
                FactType ft = T;

                if (row >= 1 && row <= 7) ft = A;
                if (row >= 9 && row <= 15) ft = C;


                facts.Add(new Fact(worksheet.Cell(row, 1).Value.ToString(), worksheet.Cell(row, 2).Value.ToString(), ft));
            }
            Random random = new Random();

            for (int row = 1; row <= 13; row++)
            {
                products.Add(new Product(worksheet.Cell(row, 3).Value.ToString(), (float)((float)random.Next(55 - row / 7, 100) / 100)));
            }
        }
        //public static void ParseP(ref List<Fact> facts, ref List<Product> products)
        //{
        //    string filePath = "../../Pas.xlsx";

        //    var workbook = new XLWorkbook(filePath);
        //    var worksheet = workbook.Worksheet(1);

        //    for (int row = 1; row <= 201; row++)
        //    {
        //        FactType ft = T;
        //        if (row == 1)
        //            ft = T;
        //        else if (row == 121) ft = A;
        //        else ft = C;


        //        facts.Add(new Fact(worksheet.Cell(row, 1).Value.ToString(), worksheet.Cell(row, 2).Value.ToString(), ft));
        //    }


        //    for (int row = 1; row <= 1910; row++)
        //    {
        //        products.Add(new Product(worksheet.Cell(row, 3).Value.ToString()));
        //    }
        //}

        public static void ParseProductText(Product prod, List<Fact> facts)
        {
            string text = prod.text;
            int length = text.Length;

            for (int i = 0; i < length; i++)
            {
                if (text[i] == 'f')
                {
                    i++;
                    if (char.IsDigit(text[i]))
                    {
                        string temp = "f" + text[i];

                        if (i + 1 < length)
                            if (char.IsDigit(text[i + 1]))
                            {
                                i++;
                                temp += text[i];
                                if (i + 1 < length)
                                    if (char.IsDigit(text[i + 1]))
                                    {
                                        i++;
                                        temp += text[i];
                                    }
                            }
                        prod.left.Add(facts.Find(x => x.name == temp));
                    }
                }

                else if (text[i] == '&') continue;

                else if (text[i] == '=')
                {
                    i++;
                    if (text[i] == 'f')
                    {
                        i++;
                        if (char.IsDigit(text[i]))
                        {
                            string temp = "f" + text[i];

                            if (i + 1 < length)
                                if (char.IsDigit(text[i + 1]))
                                {
                                    i++;
                                    temp += text[i];
                                    if (i + 1 < length)
                                        if (char.IsDigit(text[i + 1]))
                                        {
                                            i++;
                                            temp += text[i];
                                        }
                                }
                            prod.result = facts.Find(x => x.name == temp);
                            if (prod.result == null) prod.result = new Fact("f00", "Нет факта", C); ;
                        }
                    }
                }

            }
        }

        public static void FillProduct(ref List<Product> products, List<Fact> facts)
        {
            foreach (var item in products)
            {
                ParseProductText(item, facts);
            }
        }

        public static void FillProductDescription(List<Product> products)
        {
            foreach (Product product in products)
            {
                string descText = "";
                foreach (Fact fact in product.left)
                {
                    descText += fact.description + ", ";
                }
                descText = descText.Remove(descText.Length - 2);
                descText += " -> " + product.result.description;

                product.description = descText;
            }
        }
        public static void OutputDescriptionInFile(List<Product> products)
        {
            string filePath = "../../PM.xlsx";

            var workbook = new XLWorkbook(filePath);
            var worksheet = workbook.Worksheet(1);

            int count = 1;
            foreach (Product product in products)
            {
                worksheet.Cell(count++, 4).Value = product.description;
            }
            workbook.SaveAs(filePath);
        }
        public static void OutputDescriptionInFileC(List<Product> products)
        {
            string filePath = "../../Test.xlsx";

            var workbook = new XLWorkbook(filePath);
            var worksheet = workbook.Worksheet(1);

            int count = 1;
            foreach (Product product in products)
            {
                worksheet.Cell(count++, 4).Value = product.description;
            }
            workbook.SaveAs(filePath);
        }
        public static void OutputDescriptionInFileP(List<Product> products)
        {
            string filePath = "../../Pas.xlsx";

            var workbook = new XLWorkbook(filePath);
            var worksheet = workbook.Worksheet(1);

            int count = 1;
            foreach (Product product in products)
            {
                worksheet.Cell(count++, 4).Value = product.description;
            }
            workbook.SaveAs(filePath);
        }
    }
}
