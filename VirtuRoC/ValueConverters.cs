using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Data;

// do not use this, nur als Referenz aufgehoben

namespace Robotron {

    public abstract class AsmListBoxItemConverter : IValueConverter {

        public virtual object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            throw new NotImplementedException();
        }

        public object ConvertBack( object value, Type targetType, object parameter, CultureInfo culture ) {
            return value;
        }
    }


    public class PaddingConverter : AsmListBoxItemConverter {
        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            string str = (string)value ?? "";
            int padding;
            return int.TryParse( parameter.ToString(), out padding )
                ? (str.Length < padding ? str.PadRight( padding ) : str.Substring( 0, padding - 1 ) + "…")
                : str;
        }
    }


    public class IndentConverter : AsmListBoxItemConverter {
        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            string str = (string)value ?? "";
            int padding;
            return int.TryParse( parameter.ToString(), out padding )
                ? (new String( ' ', padding )) + str
                : str;
        }
    }


    public class OperandConverter : AsmListBoxItemConverter {

        public override object Convert( object value, Type targetType, object parameter, CultureInfo culture ) {
            var lbi = (ListBoxItem)value;
            AsmListBoxItem item = (AsmListBoxItem)lbi.Content;

            AddressItem addressItem = item as AddressItem;
            string operand = addressItem.Operand ?? "";

            Console.WriteLine( operand );

            int padding;
            operand = int.TryParse( parameter.ToString(), out padding ) ? operand.PadRight( padding ) : operand;

            AsmLine asmLine = item.AsmLine;
            if (asmLine.HasOperandArgument()) {
                if (asmLine.OperandArgument.HasLabel()) {
                    if (!(asmLine.IsJumpOperation() || asmLine.IsBranchOperation() || asmLine.Opcode == "rts")) {
                        string label = asmLine.OperandArgument.Label;
                        operand = operand.Replace( label, "<Run Foreground=\"DarkOrange\">" + label + "</Run>" );
                    }
                }
            }


            return operand.Replace( "&", "&amp;" );
        }
    }
}
