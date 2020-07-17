using System.Drawing;
using System.Windows.Forms;

namespace VirtuRoC {
    partial class Form1 {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose( bool disposing ) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose( disposing );
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.SuspendLayout();
            // 
            // listBox1
            // 
            this.listBox1.Font = new System.Drawing.Font("Consolas", 11F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.listBox1.FormattingEnabled = true;
            this.listBox1.HorizontalScrollbar = true;
            this.listBox1.ItemHeight = 18;
            this.listBox1.Location = new System.Drawing.Point(50, 37);
            this.listBox1.Name = "listBox1";
            this.listBox1.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.listBox1.Size = new System.Drawing.Size(193, 94);
            this.listBox1.TabIndex = 0;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1298, 450);
            this.Controls.Add(this.listBox1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListBox listBox1;

        public void Populate() {
            listBox1.DrawMode = DrawMode.OwnerDrawVariable;
            listBox1.DrawItem += new DrawItemEventHandler( DrawItem );
            listBox1.MeasureItem += new MeasureItemEventHandler( MeasureItem );

            // Make sure no items are displayed partially.
            listBox1.IntegralHeight = true;

            // Display a horizontal scroll bar.
            listBox1.HorizontalScrollbar = true;

            listBox1.Items.Add( "asdf  2h22h" );
            listBox1.Items.Add( "asdf wert2182 wqj  qw 2222222222" );
            listBox1.Items.Add( "asdf 3j3j  4 4 4" );
            listBox1.SelectedIndex = 0;
        }

        private void DrawItem( object sender, DrawItemEventArgs e ) {
            if (e.Index < 0) return;
            //if the item state is selected them change the back color 
            if ((e.State & DrawItemState.Selected) == DrawItemState.Selected)
                e = new DrawItemEventArgs( e.Graphics,
                                          e.Font,
                                          e.Bounds,
                                          e.Index,
                                          e.State ^ DrawItemState.Selected,
                                          e.ForeColor,
                                          Color.Yellow );//Choose the color


            // Draw the background of the ListBox control for each item.
            e.DrawBackground();
            // Draw the current item text

            e.Graphics.DrawString( listBox1.Items[e.Index].ToString(), e.Font, Brushes.Black, e.Bounds, StringFormat.GenericDefault );
            // If the ListBox has focus, draw a focus rectangle around the selected item.
            e.DrawFocusRectangle();
            
            //e.DrawBackground();
            //e.DrawFocusRectangle();

            // You'll change the font size here. Notice the 20
            // data[e.Index]

            //SolidBrush scb = new SolidBrush( Color.MediumBlue );
            //e.Graphics.DrawString( "wertwert", new Font( FontFamily.GenericSansSerif, 8, FontStyle.Regular ), scb, e.Bounds );
        }

        private void MeasureItem( object sender, MeasureItemEventArgs e ) {
            // You may need to experiment with the ItemHeight here..
            e.ItemHeight = 17;

            /*
            // Create a Graphics object to use when determining the size of the largest item in the ListBox.
            Graphics g = listBox1.CreateGraphics();

            // Determine the size for HorizontalExtent using the MeasureString method using the last item in the list.
            //int hzSize = (int)g.MeasureString( listBox1.Items[listBox1.Items.Count - 1].ToString(), listBox1.Font ).Width;
            int hzSize = (int)g.MeasureString( listBox1.Items[e.Index].ToString(), listBox1.Font ).Width;
            // Set the HorizontalExtent property.
            listBox1.HorizontalExtent = hzSize;
            */
        }
    }
}