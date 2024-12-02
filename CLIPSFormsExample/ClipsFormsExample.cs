using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CLIPSNET;


namespace ClipsFormsExample
{
    public partial class ClipsFormsExample : Form
    {
        private CLIPSNET.Environment clips = new CLIPSNET.Environment();
        /// <summary>
        /// Распознаватель речи
        /// </summary>
        private Microsoft.Speech.Synthesis.SpeechSynthesizer synth;

        /// <summary>
        /// Распознавалка
        /// </summary>
        private Microsoft.Speech.Recognition.SpeechRecognitionEngine recogn;

        private List<Button> buttonList;
        private List<string> axiomList;
        private string codeText;

        public ClipsFormsExample()
        {
            InitializeComponent();
            buttonList = new List<Button>();
            axiomList = new List<string>();
            codeText = "";



            //synth = new Microsoft.Speech.Synthesis.SpeechSynthesizer();
            //synth.SetOutputToDefaultAudioDevice();

            //var voices = synth.GetInstalledVoices(System.Globalization.CultureInfo.GetCultureInfoByIetfLanguageTag("ru-RU"));
            //foreach (var v in voices)
            //    voicesBox.Items.Add(v.VoiceInfo.Name);
            //if (voicesBox.Items.Count > 0)
            //{
            //    voicesBox.SelectedIndex = 0;
            //    synth.SelectVoice(voices[0].VoiceInfo.Name);
            //}

            //var RecognizerInfo = Microsoft.Speech.Recognition.SpeechRecognitionEngine.InstalledRecognizers().Where(ri => ri.Culture.Name == "ru-RU").FirstOrDefault();
            //recogn = new Microsoft.Speech.Recognition.SpeechRecognitionEngine(RecognizerInfo);
            //recogn.SpeechRecognized += Recogn_SpeechRecognized;
            //recogn.SetInputToDefaultAudioDevice();
        }

        private void FindAx()
        {
            axiomList.Clear();
            buttonList.Clear();
            groupBox1.Controls.Clear();
            foreach (var item in codeBox.Lines)
            {
                string temp = item;
                if (temp.Count() > 2)
                    if (temp[0] == '(' && temp[1] == 'A')
                    {
                        temp = temp.Substring(14);
                        temp = temp.Remove(temp.Length - 3);
                        axiomList.Add(temp);
                    }
            }
            FillButtons();
        }

        private void FillButtons()
        {
            for (int i = 0; i < axiomList.Count; i++)
            {
                buttonList.Add(new Button());
                buttonList[i].Size = new Size(150, 30);
                buttonList[i].Click += AddAxInTextBox;
                groupBox1.Controls.Add(buttonList[i]);
                if (i < (int)Math.Round((double)axiomList.Count / 2 + 0.1f))
                    buttonList[i].Location = new Point(10, 30 * i + 30);
                else
                    buttonList[i].Location = new Point(buttonList[i].Size.Width + 5, 30 * (i - (int)Math.Round((double)axiomList.Count / 2 + 0.1f)) + 30);

                buttonList[i].Text = axiomList[i];
            }
        }

        public void AddAxInTextBox(object sender, EventArgs e)
        {
            outputBox.Text += (sender as Button).Text + "\r\n";
        }

        private void NewRecognPhrases(List<string> phrases)
        {
            outputBox.Text += "Стартуем распознавание" + System.Environment.NewLine;
            var Choises = new Microsoft.Speech.Recognition.Choices();
            Choises.Add(phrases.ToArray());

            var gb = new Microsoft.Speech.Recognition.GrammarBuilder();
            var RecognizerInfo = Microsoft.Speech.Recognition.SpeechRecognitionEngine.InstalledRecognizers().Where(ri => ri.Culture.Name == "ru-RU").FirstOrDefault();
            gb.Culture = RecognizerInfo.Culture;
            gb.Append(Choises);

            var gr = new Microsoft.Speech.Recognition.Grammar(gb);
            recogn.LoadGrammar(gr);
            recogn.RequestRecognizerUpdate();
            recogn.RecognizeAsync(Microsoft.Speech.Recognition.RecognizeMode.Multiple);
        }

        private void Recogn_SpeechRecognized(object sender, Microsoft.Speech.Recognition.SpeechRecognizedEventArgs e)
        {
            recogn.RecognizeAsyncStop();
            recogn.RecognizeAsyncCancel();
            outputBox.Text += "Ваш голос распознан!" + System.Environment.NewLine;
            clips.Eval("(assert (answer " + e.Result.Text + "))");
            clips.Eval("(assert (clearmessage))");
            outputBox.Text += "Продолжаю выполнение!" + System.Environment.NewLine;
            clips.Run();
            HandleResponse();
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
        }

        private void HandleResponse()
        {
            //  Вытаскиаваем факт из ЭС
            String evalStr = "(find-fact ((?f ioproxy)) TRUE)";
            FactAddressValue fv = (FactAddressValue)((MultifieldValue)clips.Eval(evalStr))[0];

            MultifieldValue damf = (MultifieldValue)fv["messages"];
            MultifieldValue vamf = (MultifieldValue)fv["answers"];

            outputBox.Text += System.Environment.NewLine + "Новая итерация : " + System.Environment.NewLine;
            for (int i = 0; i < damf.Count; i++)
            {
                LexemeValue da = (LexemeValue)damf[i];
                byte[] bytes = Encoding.Default.GetBytes(da.Value);
                string message = Encoding.UTF8.GetString(bytes);
                //synth.SpeakAsync(message);
                outputBox.Text += message + System.Environment.NewLine;
            }

            var phrases = new List<string>();
            if (vamf.Count > 0)
            {
                outputBox.Text += "----------------------------------------------------" + System.Environment.NewLine;
                for (int i = 0; i < vamf.Count; i++)
                {
                    //  Варианты !!!!!
                    LexemeValue va = (LexemeValue)vamf[i];
                    byte[] bytes = Encoding.Default.GetBytes(va.Value);
                    string message = Encoding.UTF8.GetString(bytes);
                    phrases.Add(message);
                    outputBox.Text += "Добавлен вариант для распознавания " + message + System.Environment.NewLine;
                }
            }

            if (vamf.Count == 0)
                clips.Eval("(assert (clearmessage))");
            else
                NewRecognPhrases(phrases);
        }

        private void nextBtn_Click(object sender, EventArgs e)
        {
            foreach (var line in outputBox.Lines)
                clips.Eval($"(assert (Input (name \"{line}\")))");
            
            clips.Run();
            HandleResponse();
        }

        private void resetBtn_Click(object sender, EventArgs e)
        {
            outputBox.Text = "Выполнены команды Clear и Reset." + System.Environment.NewLine;
            //  Здесь сохранение в файл, и потом инициализация через него
            clips.Clear();

            /*string stroka = codeBox.Text;
            System.IO.File.WriteAllText("tmp.clp", codeBox.Text);
            clips.Load("tmp.clp");*/

            //  Так тоже можно - без промежуточного вывода в файл
            clips.LoadFromString(codeBox.Text);

            clips.Reset();
        }

        private void openFile_Click(object sender, EventArgs e)
        {
            if (clipsOpenFileDialog.ShowDialog() == DialogResult.OK)
            {
                if (codeBox.Lines.Count() > 0)
                {
                    string temp = System.IO.File.ReadAllText(clipsOpenFileDialog.FileName);
                    List<string> lines = temp.Split('\n').ToList();

                    int count = 0;
                    foreach (var item in lines)
                    {
                        if (item[0] == ';' && item[1] == 'A' && item[2] == 'X')
                        {
                            break;
                        }
                        count++;
                    }

                    string tempLines = "";
                    for (int i = count; i < lines.Count; i++)
                    {
                        tempLines += lines[i].ToString() + "\r\n";
                    }

                    codeBox.Text += tempLines;
                }
                else codeBox.Text += System.IO.File.ReadAllText(clipsOpenFileDialog.FileName);
                Text = "Экспертная система \"Сериалы\" – " + clipsOpenFileDialog.FileName;


                clips.Clear();
                clips.LoadFromString(codeBox.Text);

                clips.Reset();

                FindAx();
            }
        }

        private void fontSelect_Click(object sender, EventArgs e)
        {
            if (fontDialog1.ShowDialog() == DialogResult.OK)
            {
                codeBox.Font = fontDialog1.Font;
                outputBox.Font = fontDialog1.Font;
            }
        }

        private void saveAsButton_Click(object sender, EventArgs e)
        {
            clipsSaveFileDialog.FileName = clipsOpenFileDialog.FileName;
            if (clipsSaveFileDialog.ShowDialog() == DialogResult.OK)
            {
                System.IO.File.WriteAllText(clipsSaveFileDialog.FileName, codeBox.Text);
            }
        }

        private void ClearCB_B_Click(object sender, EventArgs e)
        {
            codeBox.Text = "";
            FindAx();
        }
    }
}
