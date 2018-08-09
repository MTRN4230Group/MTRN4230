namespace VisionDemo
{
    partial class VisionDemoForm
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
            this.takePictureButton = new System.Windows.Forms.Button();
            this.histogramPictureBox = new System.Windows.Forms.PictureBox();
            this.savePictureButton = new System.Windows.Forms.Button();
            this.histogramLabel = new System.Windows.Forms.Label();
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.imagePreviewPanel = new System.Windows.Forms.Panel();
            this.imagePreviewPictureBox = new System.Windows.Forms.PictureBox();
            this.imagePreviewLabel = new System.Windows.Forms.Label();
            this.histogramPanel = new System.Windows.Forms.Panel();
            this.inputOutputPanel = new System.Windows.Forms.Panel();
            this.writeOutputNumericUpDown = new System.Windows.Forms.NumericUpDown();
            this.readInputlabel = new System.Windows.Forms.Label();
            this.readInputButton = new System.Windows.Forms.Button();
            this.writeOutputButton = new System.Windows.Forms.Button();
            this.numPins = new System.Windows.Forms.Label();
            this.inputOutputLabel = new System.Windows.Forms.Label();
            this.livePreviewPanel = new System.Windows.Forms.Panel();
            this.displayLivePreviewCheckBox = new System.Windows.Forms.CheckBox();
            this.livePreviewPictureBox = new System.Windows.Forms.PictureBox();
            this.livePreviewLabel = new System.Windows.Forms.Label();
            this.PalletAnalysisLabel = new System.Windows.Forms.Label();
            this.TotalHighValuePixelsLabel = new System.Windows.Forms.Panel();
            this.PalletPosDefaultButton = new System.Windows.Forms.Button();
            this.CheckAllPinsButton = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.PinCheckBox25 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox24 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox23 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox22 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox21 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox20 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox19 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox18 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox17 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox16 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox15 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox14 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox13 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox12 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox11 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox10 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox9 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox8 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox7 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox6 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox5 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox4 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox3 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox2 = new System.Windows.Forms.CheckBox();
            this.PinCheckBox1 = new System.Windows.Forms.CheckBox();
            this.PinCheckResultLabel = new System.Windows.Forms.Label();
            this.PinCheckButton = new System.Windows.Forms.Button();
            this.PinCheckNumericUpDown = new System.Windows.Forms.NumericUpDown();
            this.PinCheckLabel = new System.Windows.Forms.Label();
            this.PalletYPosTextBox = new System.Windows.Forms.TextBox();
            this.PalletXPosTextBox = new System.Windows.Forms.TextBox();
            this.PalletYPosLabel = new System.Windows.Forms.Label();
            this.numHolesLabel = new System.Windows.Forms.Label();
            this.PalletXPosLabel = new System.Windows.Forms.Label();
            this.numHoles = new System.Windows.Forms.Label();
            this.isPalletPresent = new System.Windows.Forms.Label();
            this.NumberOfPinsLabel = new System.Windows.Forms.Label();
            this.isPalletPresentLabel = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.histogramPictureBox)).BeginInit();
            this.imagePreviewPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.imagePreviewPictureBox)).BeginInit();
            this.histogramPanel.SuspendLayout();
            this.inputOutputPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.writeOutputNumericUpDown)).BeginInit();
            this.livePreviewPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.livePreviewPictureBox)).BeginInit();
            this.TotalHighValuePixelsLabel.SuspendLayout();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.PinCheckNumericUpDown)).BeginInit();
            this.SuspendLayout();
            // 
            // takePictureButton
            // 
            this.takePictureButton.Location = new System.Drawing.Point(7, 596);
            this.takePictureButton.Name = "takePictureButton";
            this.takePictureButton.Size = new System.Drawing.Size(100, 23);
            this.takePictureButton.TabIndex = 0;
            this.takePictureButton.Text = "Take Picture";
            this.takePictureButton.UseVisualStyleBackColor = true;
            this.takePictureButton.Click += new System.EventHandler(this.takePictureButton_Click);
            // 
            // histogramPictureBox
            // 
            this.histogramPictureBox.BackColor = System.Drawing.Color.Black;
            this.histogramPictureBox.Location = new System.Drawing.Point(7, 8);
            this.histogramPictureBox.Name = "histogramPictureBox";
            this.histogramPictureBox.Size = new System.Drawing.Size(267, 213);
            this.histogramPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.histogramPictureBox.TabIndex = 2;
            this.histogramPictureBox.TabStop = false;
            this.histogramPictureBox.Paint += new System.Windows.Forms.PaintEventHandler(this.histogramPictureBox_Paint);
            // 
            // savePictureButton
            // 
            this.savePictureButton.Location = new System.Drawing.Point(113, 596);
            this.savePictureButton.Name = "savePictureButton";
            this.savePictureButton.Size = new System.Drawing.Size(97, 23);
            this.savePictureButton.TabIndex = 3;
            this.savePictureButton.Text = "Save";
            this.savePictureButton.UseVisualStyleBackColor = true;
            this.savePictureButton.Click += new System.EventHandler(this.savePictureButton_Click);
            // 
            // histogramLabel
            // 
            this.histogramLabel.AutoSize = true;
            this.histogramLabel.Location = new System.Drawing.Point(812, 11);
            this.histogramLabel.Name = "histogramLabel";
            this.histogramLabel.Size = new System.Drawing.Size(86, 13);
            this.histogramLabel.TabIndex = 5;
            this.histogramLabel.Text = "Image Histogram";
            // 
            // saveFileDialog1
            // 
            this.saveFileDialog1.FileName = "image1.jpg";
            this.saveFileDialog1.Filter = "JPG Image|*.jpg|All Files|*.*";
            // 
            // imagePreviewPanel
            // 
            this.imagePreviewPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.imagePreviewPanel.Controls.Add(this.imagePreviewPictureBox);
            this.imagePreviewPanel.Controls.Add(this.takePictureButton);
            this.imagePreviewPanel.Controls.Add(this.savePictureButton);
            this.imagePreviewPanel.Location = new System.Drawing.Point(8, 27);
            this.imagePreviewPanel.Name = "imagePreviewPanel";
            this.imagePreviewPanel.Size = new System.Drawing.Size(801, 630);
            this.imagePreviewPanel.TabIndex = 6;
            // 
            // imagePreviewPictureBox
            // 
            this.imagePreviewPictureBox.Cursor = System.Windows.Forms.Cursors.Cross;
            this.imagePreviewPictureBox.Location = new System.Drawing.Point(7, 8);
            this.imagePreviewPictureBox.Name = "imagePreviewPictureBox";
            this.imagePreviewPictureBox.Size = new System.Drawing.Size(780, 582);
            this.imagePreviewPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.imagePreviewPictureBox.TabIndex = 5;
            this.imagePreviewPictureBox.TabStop = false;
            this.imagePreviewPictureBox.Click += new System.EventHandler(this.imagePreviewPictureBox_Click);
            this.imagePreviewPictureBox.Paint += new System.Windows.Forms.PaintEventHandler(this.imagePreviewPictureBox_Paint);
            this.imagePreviewPictureBox.MouseClick += new System.Windows.Forms.MouseEventHandler(this.imagePreviewPictureBox_MouseClick);
            // 
            // imagePreviewLabel
            // 
            this.imagePreviewLabel.AutoSize = true;
            this.imagePreviewLabel.Location = new System.Drawing.Point(12, 10);
            this.imagePreviewLabel.Name = "imagePreviewLabel";
            this.imagePreviewLabel.Size = new System.Drawing.Size(77, 13);
            this.imagePreviewLabel.TabIndex = 6;
            this.imagePreviewLabel.Text = "Image Preview";
            // 
            // histogramPanel
            // 
            this.histogramPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.histogramPanel.Controls.Add(this.histogramPictureBox);
            this.histogramPanel.Location = new System.Drawing.Point(815, 27);
            this.histogramPanel.Name = "histogramPanel";
            this.histogramPanel.Size = new System.Drawing.Size(283, 235);
            this.histogramPanel.TabIndex = 7;
            // 
            // inputOutputPanel
            // 
            this.inputOutputPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.inputOutputPanel.Controls.Add(this.writeOutputNumericUpDown);
            this.inputOutputPanel.Controls.Add(this.readInputlabel);
            this.inputOutputPanel.Controls.Add(this.readInputButton);
            this.inputOutputPanel.Controls.Add(this.writeOutputButton);
            this.inputOutputPanel.Location = new System.Drawing.Point(815, 572);
            this.inputOutputPanel.Name = "inputOutputPanel";
            this.inputOutputPanel.Size = new System.Drawing.Size(283, 85);
            this.inputOutputPanel.TabIndex = 8;
            // 
            // writeOutputNumericUpDown
            // 
            this.writeOutputNumericUpDown.Location = new System.Drawing.Point(133, 16);
            this.writeOutputNumericUpDown.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.writeOutputNumericUpDown.Name = "writeOutputNumericUpDown";
            this.writeOutputNumericUpDown.Size = new System.Drawing.Size(46, 20);
            this.writeOutputNumericUpDown.TabIndex = 4;
            // 
            // readInputlabel
            // 
            this.readInputlabel.AutoSize = true;
            this.readInputlabel.Location = new System.Drawing.Point(130, 54);
            this.readInputlabel.Name = "readInputlabel";
            this.readInputlabel.Size = new System.Drawing.Size(13, 13);
            this.readInputlabel.TabIndex = 3;
            this.readInputlabel.Text = "0";
            // 
            // readInputButton
            // 
            this.readInputButton.Location = new System.Drawing.Point(16, 44);
            this.readInputButton.Name = "readInputButton";
            this.readInputButton.Size = new System.Drawing.Size(89, 23);
            this.readInputButton.TabIndex = 1;
            this.readInputButton.Text = "Read";
            this.readInputButton.UseVisualStyleBackColor = true;
            this.readInputButton.Click += new System.EventHandler(this.radInputButton_Click);
            // 
            // writeOutputButton
            // 
            this.writeOutputButton.Location = new System.Drawing.Point(16, 13);
            this.writeOutputButton.Name = "writeOutputButton";
            this.writeOutputButton.Size = new System.Drawing.Size(89, 23);
            this.writeOutputButton.TabIndex = 0;
            this.writeOutputButton.Text = "Write";
            this.writeOutputButton.UseVisualStyleBackColor = true;
            this.writeOutputButton.Click += new System.EventHandler(this.writeOutputButton_Click);
            // 
            // numPins
            // 
            this.numPins.AutoSize = true;
            this.numPins.Location = new System.Drawing.Point(132, 300);
            this.numPins.Name = "numPins";
            this.numPins.Size = new System.Drawing.Size(13, 13);
            this.numPins.TabIndex = 6;
            this.numPins.Text = "0";
            // 
            // inputOutputLabel
            // 
            this.inputOutputLabel.AutoSize = true;
            this.inputOutputLabel.Location = new System.Drawing.Point(815, 550);
            this.inputOutputLabel.Name = "inputOutputLabel";
            this.inputOutputLabel.Size = new System.Drawing.Size(68, 13);
            this.inputOutputLabel.TabIndex = 9;
            this.inputOutputLabel.Text = "Input/Output";
            // 
            // livePreviewPanel
            // 
            this.livePreviewPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.livePreviewPanel.Controls.Add(this.displayLivePreviewCheckBox);
            this.livePreviewPanel.Controls.Add(this.livePreviewPictureBox);
            this.livePreviewPanel.Location = new System.Drawing.Point(815, 288);
            this.livePreviewPanel.Name = "livePreviewPanel";
            this.livePreviewPanel.Size = new System.Drawing.Size(283, 255);
            this.livePreviewPanel.TabIndex = 8;
            // 
            // displayLivePreviewCheckBox
            // 
            this.displayLivePreviewCheckBox.AutoSize = true;
            this.displayLivePreviewCheckBox.Location = new System.Drawing.Point(7, 230);
            this.displayLivePreviewCheckBox.Name = "displayLivePreviewCheckBox";
            this.displayLivePreviewCheckBox.Size = new System.Drawing.Size(64, 17);
            this.displayLivePreviewCheckBox.TabIndex = 3;
            this.displayLivePreviewCheckBox.Text = "Preview";
            this.displayLivePreviewCheckBox.UseVisualStyleBackColor = true;
            this.displayLivePreviewCheckBox.CheckedChanged += new System.EventHandler(this.displayLivePreviewCheckBox_CheckedChanged);
            // 
            // livePreviewPictureBox
            // 
            this.livePreviewPictureBox.BackColor = System.Drawing.SystemColors.Control;
            this.livePreviewPictureBox.Location = new System.Drawing.Point(7, 8);
            this.livePreviewPictureBox.Name = "livePreviewPictureBox";
            this.livePreviewPictureBox.Size = new System.Drawing.Size(267, 212);
            this.livePreviewPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.livePreviewPictureBox.TabIndex = 2;
            this.livePreviewPictureBox.TabStop = false;
            // 
            // livePreviewLabel
            // 
            this.livePreviewLabel.AutoSize = true;
            this.livePreviewLabel.Location = new System.Drawing.Point(815, 270);
            this.livePreviewLabel.Name = "livePreviewLabel";
            this.livePreviewLabel.Size = new System.Drawing.Size(68, 13);
            this.livePreviewLabel.TabIndex = 10;
            this.livePreviewLabel.Text = "Live Preview";
            // 
            // PalletAnalysisLabel
            // 
            this.PalletAnalysisLabel.AutoSize = true;
            this.PalletAnalysisLabel.Location = new System.Drawing.Point(1101, 11);
            this.PalletAnalysisLabel.Name = "PalletAnalysisLabel";
            this.PalletAnalysisLabel.Size = new System.Drawing.Size(74, 13);
            this.PalletAnalysisLabel.TabIndex = 11;
            this.PalletAnalysisLabel.Text = "Pallet Analysis";
            // 
            // TotalHighValuePixelsLabel
            // 
            this.TotalHighValuePixelsLabel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.TotalHighValuePixelsLabel.Controls.Add(this.PalletPosDefaultButton);
            this.TotalHighValuePixelsLabel.Controls.Add(this.CheckAllPinsButton);
            this.TotalHighValuePixelsLabel.Controls.Add(this.panel1);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PinCheckResultLabel);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PinCheckButton);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PinCheckNumericUpDown);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PinCheckLabel);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PalletYPosTextBox);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PalletXPosTextBox);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PalletYPosLabel);
            this.TotalHighValuePixelsLabel.Controls.Add(this.numHolesLabel);
            this.TotalHighValuePixelsLabel.Controls.Add(this.PalletXPosLabel);
            this.TotalHighValuePixelsLabel.Controls.Add(this.numHoles);
            this.TotalHighValuePixelsLabel.Controls.Add(this.isPalletPresent);
            this.TotalHighValuePixelsLabel.Controls.Add(this.NumberOfPinsLabel);
            this.TotalHighValuePixelsLabel.Controls.Add(this.numPins);
            this.TotalHighValuePixelsLabel.Controls.Add(this.isPalletPresentLabel);
            this.TotalHighValuePixelsLabel.Location = new System.Drawing.Point(1104, 27);
            this.TotalHighValuePixelsLabel.Name = "TotalHighValuePixelsLabel";
            this.TotalHighValuePixelsLabel.Size = new System.Drawing.Size(182, 516);
            this.TotalHighValuePixelsLabel.TabIndex = 12;
            // 
            // PalletPosDefaultButton
            // 
            this.PalletPosDefaultButton.Location = new System.Drawing.Point(118, 80);
            this.PalletPosDefaultButton.Name = "PalletPosDefaultButton";
            this.PalletPosDefaultButton.Size = new System.Drawing.Size(51, 23);
            this.PalletPosDefaultButton.TabIndex = 49;
            this.PalletPosDefaultButton.Text = "Default";
            this.PalletPosDefaultButton.UseVisualStyleBackColor = true;
            this.PalletPosDefaultButton.Click += new System.EventHandler(this.PalletPosDefaultButton_Click);
            // 
            // CheckAllPinsButton
            // 
            this.CheckAllPinsButton.Location = new System.Drawing.Point(31, 260);
            this.CheckAllPinsButton.Name = "CheckAllPinsButton";
            this.CheckAllPinsButton.Size = new System.Drawing.Size(126, 26);
            this.CheckAllPinsButton.TabIndex = 48;
            this.CheckAllPinsButton.Text = "Check All Pins";
            this.CheckAllPinsButton.UseVisualStyleBackColor = true;
            this.CheckAllPinsButton.Click += new System.EventHandler(this.CheckAllPinsButton_Click);
            // 
            // panel1
            // 
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.PinCheckBox25);
            this.panel1.Controls.Add(this.PinCheckBox24);
            this.panel1.Controls.Add(this.PinCheckBox23);
            this.panel1.Controls.Add(this.PinCheckBox22);
            this.panel1.Controls.Add(this.PinCheckBox21);
            this.panel1.Controls.Add(this.PinCheckBox20);
            this.panel1.Controls.Add(this.PinCheckBox19);
            this.panel1.Controls.Add(this.PinCheckBox18);
            this.panel1.Controls.Add(this.PinCheckBox17);
            this.panel1.Controls.Add(this.PinCheckBox16);
            this.panel1.Controls.Add(this.PinCheckBox15);
            this.panel1.Controls.Add(this.PinCheckBox14);
            this.panel1.Controls.Add(this.PinCheckBox13);
            this.panel1.Controls.Add(this.PinCheckBox12);
            this.panel1.Controls.Add(this.PinCheckBox11);
            this.panel1.Controls.Add(this.PinCheckBox10);
            this.panel1.Controls.Add(this.PinCheckBox9);
            this.panel1.Controls.Add(this.PinCheckBox8);
            this.panel1.Controls.Add(this.PinCheckBox7);
            this.panel1.Controls.Add(this.PinCheckBox6);
            this.panel1.Controls.Add(this.PinCheckBox5);
            this.panel1.Controls.Add(this.PinCheckBox4);
            this.panel1.Controls.Add(this.PinCheckBox3);
            this.panel1.Controls.Add(this.PinCheckBox2);
            this.panel1.Controls.Add(this.PinCheckBox1);
            this.panel1.Location = new System.Drawing.Point(31, 133);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(124, 121);
            this.panel1.TabIndex = 47;
            // 
            // PinCheckBox25
            // 
            this.PinCheckBox25.AutoSize = true;
            this.PinCheckBox25.Location = new System.Drawing.Point(95, 91);
            this.PinCheckBox25.Name = "PinCheckBox25";
            this.PinCheckBox25.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox25.TabIndex = 24;
            this.PinCheckBox25.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox24
            // 
            this.PinCheckBox24.AutoSize = true;
            this.PinCheckBox24.Location = new System.Drawing.Point(74, 91);
            this.PinCheckBox24.Name = "PinCheckBox24";
            this.PinCheckBox24.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox24.TabIndex = 23;
            this.PinCheckBox24.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox23
            // 
            this.PinCheckBox23.AutoSize = true;
            this.PinCheckBox23.Location = new System.Drawing.Point(53, 91);
            this.PinCheckBox23.Name = "PinCheckBox23";
            this.PinCheckBox23.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox23.TabIndex = 22;
            this.PinCheckBox23.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox22
            // 
            this.PinCheckBox22.AutoSize = true;
            this.PinCheckBox22.Location = new System.Drawing.Point(32, 91);
            this.PinCheckBox22.Name = "PinCheckBox22";
            this.PinCheckBox22.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox22.TabIndex = 21;
            this.PinCheckBox22.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox21
            // 
            this.PinCheckBox21.AutoSize = true;
            this.PinCheckBox21.Location = new System.Drawing.Point(11, 91);
            this.PinCheckBox21.Name = "PinCheckBox21";
            this.PinCheckBox21.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox21.TabIndex = 20;
            this.PinCheckBox21.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox20
            // 
            this.PinCheckBox20.AutoSize = true;
            this.PinCheckBox20.Location = new System.Drawing.Point(95, 71);
            this.PinCheckBox20.Name = "PinCheckBox20";
            this.PinCheckBox20.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox20.TabIndex = 19;
            this.PinCheckBox20.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox19
            // 
            this.PinCheckBox19.AutoSize = true;
            this.PinCheckBox19.Location = new System.Drawing.Point(74, 71);
            this.PinCheckBox19.Name = "PinCheckBox19";
            this.PinCheckBox19.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox19.TabIndex = 18;
            this.PinCheckBox19.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox18
            // 
            this.PinCheckBox18.AutoSize = true;
            this.PinCheckBox18.Location = new System.Drawing.Point(53, 71);
            this.PinCheckBox18.Name = "PinCheckBox18";
            this.PinCheckBox18.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox18.TabIndex = 17;
            this.PinCheckBox18.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox17
            // 
            this.PinCheckBox17.AutoSize = true;
            this.PinCheckBox17.Location = new System.Drawing.Point(32, 71);
            this.PinCheckBox17.Name = "PinCheckBox17";
            this.PinCheckBox17.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox17.TabIndex = 16;
            this.PinCheckBox17.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox16
            // 
            this.PinCheckBox16.AutoSize = true;
            this.PinCheckBox16.Location = new System.Drawing.Point(11, 71);
            this.PinCheckBox16.Name = "PinCheckBox16";
            this.PinCheckBox16.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox16.TabIndex = 15;
            this.PinCheckBox16.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox15
            // 
            this.PinCheckBox15.AutoSize = true;
            this.PinCheckBox15.Location = new System.Drawing.Point(95, 51);
            this.PinCheckBox15.Name = "PinCheckBox15";
            this.PinCheckBox15.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox15.TabIndex = 14;
            this.PinCheckBox15.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox14
            // 
            this.PinCheckBox14.AutoSize = true;
            this.PinCheckBox14.Location = new System.Drawing.Point(74, 51);
            this.PinCheckBox14.Name = "PinCheckBox14";
            this.PinCheckBox14.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox14.TabIndex = 13;
            this.PinCheckBox14.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox13
            // 
            this.PinCheckBox13.AutoSize = true;
            this.PinCheckBox13.Location = new System.Drawing.Point(53, 51);
            this.PinCheckBox13.Name = "PinCheckBox13";
            this.PinCheckBox13.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox13.TabIndex = 12;
            this.PinCheckBox13.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox12
            // 
            this.PinCheckBox12.AutoSize = true;
            this.PinCheckBox12.Location = new System.Drawing.Point(32, 51);
            this.PinCheckBox12.Name = "PinCheckBox12";
            this.PinCheckBox12.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox12.TabIndex = 11;
            this.PinCheckBox12.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox11
            // 
            this.PinCheckBox11.AutoSize = true;
            this.PinCheckBox11.Location = new System.Drawing.Point(11, 51);
            this.PinCheckBox11.Name = "PinCheckBox11";
            this.PinCheckBox11.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox11.TabIndex = 10;
            this.PinCheckBox11.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox10
            // 
            this.PinCheckBox10.AutoSize = true;
            this.PinCheckBox10.Location = new System.Drawing.Point(95, 31);
            this.PinCheckBox10.Name = "PinCheckBox10";
            this.PinCheckBox10.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox10.TabIndex = 9;
            this.PinCheckBox10.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox9
            // 
            this.PinCheckBox9.AutoSize = true;
            this.PinCheckBox9.Location = new System.Drawing.Point(74, 31);
            this.PinCheckBox9.Name = "PinCheckBox9";
            this.PinCheckBox9.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox9.TabIndex = 8;
            this.PinCheckBox9.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox8
            // 
            this.PinCheckBox8.AutoSize = true;
            this.PinCheckBox8.Location = new System.Drawing.Point(53, 31);
            this.PinCheckBox8.Name = "PinCheckBox8";
            this.PinCheckBox8.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox8.TabIndex = 7;
            this.PinCheckBox8.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox7
            // 
            this.PinCheckBox7.AutoSize = true;
            this.PinCheckBox7.Location = new System.Drawing.Point(32, 31);
            this.PinCheckBox7.Name = "PinCheckBox7";
            this.PinCheckBox7.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox7.TabIndex = 6;
            this.PinCheckBox7.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox6
            // 
            this.PinCheckBox6.AutoSize = true;
            this.PinCheckBox6.Location = new System.Drawing.Point(11, 31);
            this.PinCheckBox6.Name = "PinCheckBox6";
            this.PinCheckBox6.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox6.TabIndex = 5;
            this.PinCheckBox6.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox5
            // 
            this.PinCheckBox5.AutoSize = true;
            this.PinCheckBox5.Location = new System.Drawing.Point(95, 11);
            this.PinCheckBox5.Name = "PinCheckBox5";
            this.PinCheckBox5.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox5.TabIndex = 4;
            this.PinCheckBox5.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox4
            // 
            this.PinCheckBox4.AutoSize = true;
            this.PinCheckBox4.Location = new System.Drawing.Point(74, 11);
            this.PinCheckBox4.Name = "PinCheckBox4";
            this.PinCheckBox4.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox4.TabIndex = 3;
            this.PinCheckBox4.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox3
            // 
            this.PinCheckBox3.AutoSize = true;
            this.PinCheckBox3.Location = new System.Drawing.Point(53, 11);
            this.PinCheckBox3.Name = "PinCheckBox3";
            this.PinCheckBox3.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox3.TabIndex = 2;
            this.PinCheckBox3.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox2
            // 
            this.PinCheckBox2.AutoSize = true;
            this.PinCheckBox2.Location = new System.Drawing.Point(32, 11);
            this.PinCheckBox2.Name = "PinCheckBox2";
            this.PinCheckBox2.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox2.TabIndex = 1;
            this.PinCheckBox2.UseVisualStyleBackColor = true;
            // 
            // PinCheckBox1
            // 
            this.PinCheckBox1.AutoSize = true;
            this.PinCheckBox1.Location = new System.Drawing.Point(11, 11);
            this.PinCheckBox1.Name = "PinCheckBox1";
            this.PinCheckBox1.Size = new System.Drawing.Size(15, 14);
            this.PinCheckBox1.TabIndex = 0;
            this.PinCheckBox1.UseVisualStyleBackColor = true;
            // 
            // PinCheckResultLabel
            // 
            this.PinCheckResultLabel.AutoSize = true;
            this.PinCheckResultLabel.Location = new System.Drawing.Point(22, 381);
            this.PinCheckResultLabel.Name = "PinCheckResultLabel";
            this.PinCheckResultLabel.Size = new System.Drawing.Size(124, 13);
            this.PinCheckResultLabel.TabIndex = 21;
            this.PinCheckResultLabel.Text = "No Pin Check Performed";
            // 
            // PinCheckButton
            // 
            this.PinCheckButton.Location = new System.Drawing.Point(118, 355);
            this.PinCheckButton.Name = "PinCheckButton";
            this.PinCheckButton.Size = new System.Drawing.Size(54, 23);
            this.PinCheckButton.TabIndex = 20;
            this.PinCheckButton.Text = "Check";
            this.PinCheckButton.UseVisualStyleBackColor = true;
            this.PinCheckButton.Click += new System.EventHandler(this.PinCheckButton_Click);
            // 
            // PinCheckNumericUpDown
            // 
            this.PinCheckNumericUpDown.Location = new System.Drawing.Point(74, 355);
            this.PinCheckNumericUpDown.Maximum = new decimal(new int[] {
            25,
            0,
            0,
            0});
            this.PinCheckNumericUpDown.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.PinCheckNumericUpDown.Name = "PinCheckNumericUpDown";
            this.PinCheckNumericUpDown.Size = new System.Drawing.Size(38, 20);
            this.PinCheckNumericUpDown.TabIndex = 19;
            this.PinCheckNumericUpDown.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // PinCheckLabel
            // 
            this.PinCheckLabel.AutoSize = true;
            this.PinCheckLabel.Location = new System.Drawing.Point(3, 357);
            this.PinCheckLabel.Name = "PinCheckLabel";
            this.PinCheckLabel.Size = new System.Drawing.Size(56, 13);
            this.PinCheckLabel.TabIndex = 18;
            this.PinCheckLabel.Text = "Pin Check";
            // 
            // PalletYPosTextBox
            // 
            this.PalletYPosTextBox.Location = new System.Drawing.Point(118, 54);
            this.PalletYPosTextBox.Name = "PalletYPosTextBox";
            this.PalletYPosTextBox.Size = new System.Drawing.Size(51, 20);
            this.PalletYPosTextBox.TabIndex = 17;
            this.PalletYPosTextBox.Text = "113";
            // 
            // PalletXPosTextBox
            // 
            this.PalletXPosTextBox.Location = new System.Drawing.Point(118, 28);
            this.PalletXPosTextBox.Name = "PalletXPosTextBox";
            this.PalletXPosTextBox.Size = new System.Drawing.Size(51, 20);
            this.PalletXPosTextBox.TabIndex = 16;
            this.PalletXPosTextBox.Text = "256";
            // 
            // PalletYPosLabel
            // 
            this.PalletYPosLabel.AutoSize = true;
            this.PalletYPosLabel.Location = new System.Drawing.Point(3, 57);
            this.PalletYPosLabel.Name = "PalletYPosLabel";
            this.PalletYPosLabel.Size = new System.Drawing.Size(86, 13);
            this.PalletYPosLabel.TabIndex = 15;
            this.PalletYPosLabel.Text = "Pallet Y Position:";
            // 
            // numHolesLabel
            // 
            this.numHolesLabel.AutoSize = true;
            this.numHolesLabel.Location = new System.Drawing.Point(7, 313);
            this.numHolesLabel.Name = "numHolesLabel";
            this.numHolesLabel.Size = new System.Drawing.Size(117, 13);
            this.numHolesLabel.TabIndex = 12;
            this.numHolesLabel.Text = "Number of Empty Slots:";
            // 
            // PalletXPosLabel
            // 
            this.PalletXPosLabel.AutoSize = true;
            this.PalletXPosLabel.Location = new System.Drawing.Point(3, 31);
            this.PalletXPosLabel.Name = "PalletXPosLabel";
            this.PalletXPosLabel.Size = new System.Drawing.Size(86, 13);
            this.PalletXPosLabel.TabIndex = 14;
            this.PalletXPosLabel.Text = "Pallet X Position:";
            // 
            // numHoles
            // 
            this.numHoles.AutoSize = true;
            this.numHoles.Location = new System.Drawing.Point(132, 313);
            this.numHoles.Name = "numHoles";
            this.numHoles.Size = new System.Drawing.Size(19, 13);
            this.numHoles.TabIndex = 13;
            this.numHoles.Text = "25";
            // 
            // isPalletPresent
            // 
            this.isPalletPresent.AutoSize = true;
            this.isPalletPresent.Location = new System.Drawing.Point(130, 8);
            this.isPalletPresent.Name = "isPalletPresent";
            this.isPalletPresent.Size = new System.Drawing.Size(21, 13);
            this.isPalletPresent.TabIndex = 11;
            this.isPalletPresent.Text = "No";
            // 
            // NumberOfPinsLabel
            // 
            this.NumberOfPinsLabel.AutoSize = true;
            this.NumberOfPinsLabel.Location = new System.Drawing.Point(7, 300);
            this.NumberOfPinsLabel.Name = "NumberOfPinsLabel";
            this.NumberOfPinsLabel.Size = new System.Drawing.Size(82, 13);
            this.NumberOfPinsLabel.TabIndex = 7;
            this.NumberOfPinsLabel.Text = "Number of Pins:";
            // 
            // isPalletPresentLabel
            // 
            this.isPalletPresentLabel.AutoSize = true;
            this.isPalletPresentLabel.Location = new System.Drawing.Point(3, 8);
            this.isPalletPresentLabel.Name = "isPalletPresentLabel";
            this.isPalletPresentLabel.Size = new System.Drawing.Size(75, 13);
            this.isPalletPresentLabel.TabIndex = 10;
            this.isPalletPresentLabel.Text = "Pallet Present:";
            // 
            // VisionDemoForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1295, 665);
            this.Controls.Add(this.TotalHighValuePixelsLabel);
            this.Controls.Add(this.PalletAnalysisLabel);
            this.Controls.Add(this.livePreviewLabel);
            this.Controls.Add(this.livePreviewPanel);
            this.Controls.Add(this.inputOutputLabel);
            this.Controls.Add(this.inputOutputPanel);
            this.Controls.Add(this.histogramLabel);
            this.Controls.Add(this.imagePreviewLabel);
            this.Controls.Add(this.histogramPanel);
            this.Controls.Add(this.imagePreviewPanel);
            this.DoubleBuffered = true;
            this.Name = "VisionDemoForm";
            this.Text = "Robotic Vision Group 1";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.visionDemoForm_FormClosing);
            ((System.ComponentModel.ISupportInitialize)(this.histogramPictureBox)).EndInit();
            this.imagePreviewPanel.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.imagePreviewPictureBox)).EndInit();
            this.histogramPanel.ResumeLayout(false);
            this.inputOutputPanel.ResumeLayout(false);
            this.inputOutputPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.writeOutputNumericUpDown)).EndInit();
            this.livePreviewPanel.ResumeLayout(false);
            this.livePreviewPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.livePreviewPictureBox)).EndInit();
            this.TotalHighValuePixelsLabel.ResumeLayout(false);
            this.TotalHighValuePixelsLabel.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.PinCheckNumericUpDown)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button takePictureButton;
        private System.Windows.Forms.PictureBox histogramPictureBox;
        private System.Windows.Forms.Button savePictureButton;
        private System.Windows.Forms.Label histogramLabel;
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.Panel imagePreviewPanel;
        private System.Windows.Forms.Label imagePreviewLabel;
        private System.Windows.Forms.PictureBox imagePreviewPictureBox;
        private System.Windows.Forms.Panel histogramPanel;
        private System.Windows.Forms.Panel inputOutputPanel;
        private System.Windows.Forms.Label inputOutputLabel;
        private System.Windows.Forms.NumericUpDown writeOutputNumericUpDown;
        private System.Windows.Forms.Label readInputlabel;
        private System.Windows.Forms.Button readInputButton;
        private System.Windows.Forms.Button writeOutputButton;
        private System.Windows.Forms.Panel livePreviewPanel;
        private System.Windows.Forms.PictureBox livePreviewPictureBox;
        private System.Windows.Forms.Label livePreviewLabel;
        private System.Windows.Forms.CheckBox displayLivePreviewCheckBox;
        private System.Windows.Forms.Label numPins;
        private System.Windows.Forms.Label PalletAnalysisLabel;
        private System.Windows.Forms.Panel TotalHighValuePixelsLabel;
        private System.Windows.Forms.Label NumberOfPinsLabel;
        private System.Windows.Forms.Label isPalletPresent;
        private System.Windows.Forms.Label isPalletPresentLabel;
        private System.Windows.Forms.Label numHoles;
        private System.Windows.Forms.Label numHolesLabel;
        private System.Windows.Forms.Label PalletYPosLabel;
        private System.Windows.Forms.Label PalletXPosLabel;
        private System.Windows.Forms.TextBox PalletYPosTextBox;
        private System.Windows.Forms.TextBox PalletXPosTextBox;
        private System.Windows.Forms.Label PinCheckResultLabel;
        private System.Windows.Forms.Button PinCheckButton;
        private System.Windows.Forms.NumericUpDown PinCheckNumericUpDown;
        private System.Windows.Forms.Label PinCheckLabel;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button CheckAllPinsButton;
        private System.Windows.Forms.CheckBox PinCheckBox25;
        private System.Windows.Forms.CheckBox PinCheckBox24;
        private System.Windows.Forms.CheckBox PinCheckBox23;
        private System.Windows.Forms.CheckBox PinCheckBox22;
        private System.Windows.Forms.CheckBox PinCheckBox21;
        private System.Windows.Forms.CheckBox PinCheckBox20;
        private System.Windows.Forms.CheckBox PinCheckBox19;
        private System.Windows.Forms.CheckBox PinCheckBox18;
        private System.Windows.Forms.CheckBox PinCheckBox17;
        private System.Windows.Forms.CheckBox PinCheckBox16;
        private System.Windows.Forms.CheckBox PinCheckBox15;
        private System.Windows.Forms.CheckBox PinCheckBox14;
        private System.Windows.Forms.CheckBox PinCheckBox13;
        private System.Windows.Forms.CheckBox PinCheckBox12;
        private System.Windows.Forms.CheckBox PinCheckBox11;
        private System.Windows.Forms.CheckBox PinCheckBox10;
        private System.Windows.Forms.CheckBox PinCheckBox9;
        private System.Windows.Forms.CheckBox PinCheckBox8;
        private System.Windows.Forms.CheckBox PinCheckBox7;
        private System.Windows.Forms.CheckBox PinCheckBox6;
        private System.Windows.Forms.CheckBox PinCheckBox5;
        private System.Windows.Forms.CheckBox PinCheckBox4;
        private System.Windows.Forms.CheckBox PinCheckBox3;
        private System.Windows.Forms.CheckBox PinCheckBox2;
        private System.Windows.Forms.CheckBox PinCheckBox1;
        private System.Windows.Forms.Button PalletPosDefaultButton;
    }
}

