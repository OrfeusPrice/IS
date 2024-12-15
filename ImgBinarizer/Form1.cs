using System.Drawing.Imaging;

namespace ImgBinarizer
{
    public partial class Form1 : Form
    {
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

        string pathToDataset = "../../../test/";
        string pathToDatasetNew = "../../../NewTest/test/";
        public Form1()
        {
            InitializeComponent();

            List<FigureType> fig = new List<FigureType> {
                FigureType.Mercury,
                FigureType.Venus,
                FigureType.Earth,
                FigureType.Mars,
                FigureType.Jupiter,
                FigureType.Saturn,
                FigureType.Uranus,
                FigureType.Neptune,
                FigureType.Sun,
                FigureType.Moon,
            };

            foreach (var fg in fig)
            {
                int count = 0;
                string filePath = pathToDataset + "//" + fg.ToString();
                List<String> imgs = new List<string>();
                foreach (var item in Directory.GetFiles(filePath))
                {
                    imgs.Add(item.ToString());
                }

                foreach (var item in imgs)
                {
                    pictureBox1.Image = Image.FromFile(item);

                    Bitmap bm = new Bitmap(pictureBox1.Image);

                    int R = Color.Black.R;
                    int G = Color.Black.G;
                    int B = Color.Black.B;
                    int dif = 200;

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

                    pictureBox1.Image = bm;

                    pictureBox1.Image.Save(pathToDatasetNew + "/" + fg.ToString() + "/" + fg.ToString() + count++.ToString() + ".png", ImageFormat.Png);
                }
            }
        }
    }
}
