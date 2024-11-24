namespace Lab5_ProdMod
{
    partial class Form1
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.Target_BOX = new System.Windows.Forms.Panel();
            this.Axiom_BOX = new System.Windows.Forms.Panel();
            this.Res_TB = new System.Windows.Forms.TextBox();
            this.Forward_B = new System.Windows.Forms.Button();
            this.Back_B = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.HELP_BT = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // Target_BOX
            // 
            this.Target_BOX.AutoScroll = true;
            this.Target_BOX.BackColor = System.Drawing.Color.AliceBlue;
            this.Target_BOX.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.Target_BOX.Location = new System.Drawing.Point(210, 46);
            this.Target_BOX.Name = "Target_BOX";
            this.Target_BOX.Size = new System.Drawing.Size(384, 748);
            this.Target_BOX.TabIndex = 2;
            // 
            // Axiom_BOX
            // 
            this.Axiom_BOX.BackColor = System.Drawing.Color.AliceBlue;
            this.Axiom_BOX.Location = new System.Drawing.Point(5, 46);
            this.Axiom_BOX.Name = "Axiom_BOX";
            this.Axiom_BOX.Size = new System.Drawing.Size(200, 748);
            this.Axiom_BOX.TabIndex = 3;
            // 
            // Res_TB
            // 
            this.Res_TB.BackColor = System.Drawing.Color.AliceBlue;
            this.Res_TB.Font = new System.Drawing.Font("Microsoft Sans Serif", 8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Res_TB.Location = new System.Drawing.Point(600, 46);
            this.Res_TB.Multiline = true;
            this.Res_TB.Name = "Res_TB";
            this.Res_TB.ReadOnly = true;
            this.Res_TB.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.Res_TB.Size = new System.Drawing.Size(590, 692);
            this.Res_TB.TabIndex = 6;
            // 
            // Forward_B
            // 
            this.Forward_B.BackColor = System.Drawing.Color.MediumSpringGreen;
            this.Forward_B.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Forward_B.Location = new System.Drawing.Point(600, 744);
            this.Forward_B.Name = "Forward_B";
            this.Forward_B.Size = new System.Drawing.Size(250, 50);
            this.Forward_B.TabIndex = 8;
            this.Forward_B.Text = "Прямой вывод";
            this.Forward_B.UseVisualStyleBackColor = false;
            this.Forward_B.Click += new System.EventHandler(this.Forward_B_Click);
            // 
            // Back_B
            // 
            this.Back_B.BackColor = System.Drawing.Color.MediumSpringGreen;
            this.Back_B.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.Back_B.Location = new System.Drawing.Point(856, 744);
            this.Back_B.Name = "Back_B";
            this.Back_B.Size = new System.Drawing.Size(250, 50);
            this.Back_B.TabIndex = 9;
            this.Back_B.Text = "Обратный вывод";
            this.Back_B.UseVisualStyleBackColor = false;
            this.Back_B.Click += new System.EventHandler(this.Back_B_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label3.Location = new System.Drawing.Point(8, 12);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(180, 31);
            this.label3.TabIndex = 10;
            this.label3.Text = " АКСИОМЫ ";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label1.Location = new System.Drawing.Point(600, 12);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(513, 31);
            this.label1.TabIndex = 11;
            this.label1.Text = "                        ВЫВОД                         ";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.label2.Location = new System.Drawing.Point(211, 12);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(335, 31);
            this.label2.TabIndex = 12;
            this.label2.Text = "               ЦЕЛИ               ";
            // 
            // HELP_BT
            // 
            this.HELP_BT.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(128)))));
            this.HELP_BT.Font = new System.Drawing.Font("Microsoft Sans Serif", 22F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.HELP_BT.Location = new System.Drawing.Point(1110, 744);
            this.HELP_BT.Name = "HELP_BT";
            this.HELP_BT.Size = new System.Drawing.Size(75, 50);
            this.HELP_BT.TabIndex = 13;
            this.HELP_BT.Text = "?";
            this.HELP_BT.UseVisualStyleBackColor = false;
            this.HELP_BT.Click += new System.EventHandler(this.HELP_BT_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.BackColor = System.Drawing.Color.LightSteelBlue;
            this.ClientSize = new System.Drawing.Size(1202, 803);
            this.Controls.Add(this.HELP_BT);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.Back_B);
            this.Controls.Add(this.Forward_B);
            this.Controls.Add(this.Res_TB);
            this.Controls.Add(this.Axiom_BOX);
            this.Controls.Add(this.Target_BOX);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Panel Target_BOX;
        private System.Windows.Forms.Panel Axiom_BOX;
        private System.Windows.Forms.TextBox Res_TB;
        private System.Windows.Forms.Button Forward_B;
        private System.Windows.Forms.Button Back_B;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button HELP_BT;
    }
}

