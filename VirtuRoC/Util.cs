using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Globalization;
    
namespace Robotron {

    public class RobotronObject {
        public static int StringToDecimal( string s ) {
            if (s == "") return -1;
            if (s.StartsWith( "$" ))
                return HexToDecimal( s );
            else if (s.StartsWith( "#$" ))
                return HexToDecimal( s.Substring( 2 ) );
            else if (s.StartsWith( "#" ))
                return Int32.Parse( s.Substring( 1 ) );
            else
                return Int32.Parse( s );
        }

        public static int HexToDecimal( string s ) {
            if (s == "") return -1;
            return int.Parse( s.StartsWith( "$" ) ? s.Substring( 2 ) : s, NumberStyles.HexNumber );
        }

        public static string DecimalToHexAddress( int addr ) {
            return $"${addr:X04}";
        }

        public void TraceLine( params object[] objects ) {
            foreach (object obj in objects) {
                Trace.Write( obj.ToString() );
                if (objects.Length > 1) Trace.Write( "\t" );
            }
            Trace.Write( "\n" );
        }

        public void TraceNewLine( params object[] objects ) {
            Trace.Write( "\n" );
            TraceLine( objects );
        }
    }

    public class RegexHelpers {
        public static void Transfer( object obj, Match match, params string[] values ) {
            Type type = obj.GetType();
            foreach (string value in values) {
                PropertyInfo prop = type.GetProperty( value );
                Debug.Assert( prop != null, $"unknown property {value}" );
                Debug.Assert( prop.GetValue( obj ) == null );
                prop.SetValue( obj, match.Groups[value].Value, null );
            }
        }

        public static string MatchValue( Regex regex, string target, string value ) {
            Match match = regex.Match( target );
            return match.Groups[value].Value;
        }
    }
}
