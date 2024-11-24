namespace Lab5_ProdMod
{
    partial class Form2
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.RULES_TB = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // RULES_TB
            // 
            this.RULES_TB.BackColor = System.Drawing.Color.LemonChiffon;
            this.RULES_TB.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.RULES_TB.Font = new System.Drawing.Font("Rockwell", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.RULES_TB.Location = new System.Drawing.Point(12, 12);
            this.RULES_TB.Multiline = true;
            this.RULES_TB.Name = "RULES_TB";
            this.RULES_TB.ReadOnly = true;
            this.RULES_TB.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.RULES_TB.Size = new System.Drawing.Size(806, 779);
            this.RULES_TB.TabIndex = 6;
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(832, 803);
            this.Controls.Add(this.RULES_TB);
            this.Location = new System.Drawing.Point(900, 0);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Form2";
            this.StartPosition = System.Windows.Forms.FormStartPosition.Manual;
            this.Text = "Form2";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        public System.Windows.Forms.TextBox RULES_TB;
    }
}