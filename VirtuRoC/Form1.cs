using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Robotron {

    public partial class Form1 : Form {
        public Form1() {
            InitializeComponent();

            //this.SetStyle( ControlStyles.OptimizedDoubleBuffer | ControlStyles.UserPaint | ControlStyles.AllPaintingInWmPaint, true );
            //this.DoubleBuffered = true;

            StringBuilder sb = new StringBuilder();
            listBox1.BeginUpdate();
            for (int i=0; i<1000; i++ ) {
                sb.Clear();
                for (int j=0; j<20; j++) {
                    sb.Append( i.ToString() + " " );
                }
                listBox1.Items.Add( sb.ToString() );
            }
            listBox1.EndUpdate();
        }

    }

    internal class FlickerFreeListBox : System.Windows.Forms.ListBox {
        public FlickerFreeListBox() {
            this.SetStyle(
                ControlStyles.OptimizedDoubleBuffer |
                ControlStyles.ResizeRedraw |
                ControlStyles.UserPaint,
                true );
            this.DrawMode = DrawMode.OwnerDrawFixed;
        }
        protected override void OnDrawItem( DrawItemEventArgs e ) {
            if (this.Items.Count > 0) {
                Graphics g = e.Graphics;
                g.FillRectangle( new SolidBrush( Color.Beige ), e.Bounds );
                //e.DrawBackground();
                //e.Graphics.DrawString( this.Items[e.Index].ToString(), e.Font, new SolidBrush( this.ForeColor ), new PointF( e.Bounds.X, e.Bounds.Y ) );

                // Define the default color of the brush as black.
                Brush myBrush = Brushes.Black;

                // Determine the color of the brush to draw each item based 
                // on the index of the item to draw.
                switch (e.Index) {
                    case 0:
                        myBrush = Brushes.Red;
                        break;
                    case 1:
                        myBrush = Brushes.Orange;
                        break;
                    case 2:
                        myBrush = Brushes.Purple;
                        break;
                }

                // Draw the current item text based on the current Font 
                // and the custom brush settings.
                g.DrawString( Items[e.Index].ToString(), e.Font, myBrush, e.Bounds, StringFormat.GenericDefault );
                // If the ListBox has focus, draw a focus rectangle around the selected item.
                e.DrawFocusRectangle();
            }
            base.OnDrawItem( e );
        }
        protected override void OnPaint( PaintEventArgs e ) {
            Region iRegion = new Region( e.ClipRectangle );
            e.Graphics.FillRegion( new SolidBrush( this.BackColor ), iRegion );
            if (this.Items.Count > 0) {
                for (int i = 0; i < this.Items.Count; ++i) {
                    System.Drawing.Rectangle irect = this.GetItemRectangle( i );
                    if (e.ClipRectangle.IntersectsWith( irect )) {
                        if ((this.SelectionMode == SelectionMode.One && this.SelectedIndex == i)
                        || (this.SelectionMode == SelectionMode.MultiSimple && this.SelectedIndices.Contains( i ))
                        || (this.SelectionMode == SelectionMode.MultiExtended && this.SelectedIndices.Contains( i ))) {
                            OnDrawItem( new DrawItemEventArgs( e.Graphics, this.Font,
                                irect, i,
                                DrawItemState.Selected, this.ForeColor,
                                this.BackColor ) );
                        } else {
                            OnDrawItem( new DrawItemEventArgs( e.Graphics, this.Font,
                                irect, i,
                                DrawItemState.Default, this.ForeColor,
                                this.BackColor ) );
                        }
                        iRegion.Complement( irect );
                    }
                }
            }
            base.OnPaint( e );
        }
    }

}
