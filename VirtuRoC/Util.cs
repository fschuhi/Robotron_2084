using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Diagnostics;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Globalization;
using Jellyfish.Library;

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

        public static string DecimalToHexAddress( int addr, bool zeroPage = false ) {
            return zeroPage ? $"${addr:X02}" : $"${addr:X04}";
        }
        public static string DecimalToHexNum( int addr, bool zeroPage = false ) {
            return zeroPage ? $"{addr:X02}" : $"{addr:X04}";
        }

        public void TraceLine() {
            TraceLine( "" );
        }

        public void TraceLine( params object[] objects ) {
            Trace.WriteLine( string.Join( "\t", objects.Select( o => o.ToString() ).ToArray() ) );
        }

        public void TraceNewLine( params object[] objects ) {
            TraceLine();
            TraceLine( objects );
        }

        public void TraceObjectType( object obj ) {
            TraceLine( obj.ToString() );
        }
    }

    public enum AddressPart { NA, High, Low };

    public static class RobotronExtensions {
        public static int ToDecimal( this string hex ) {
            return RobotronObject.HexToDecimal( hex );
        }
        public static string ToHex( this int dec ) {
            return dec == -1 ? "N/A" : RobotronObject.DecimalToHexAddress( dec );
        }
        public static string ToHex( this int dec, bool zeroPage ) {
            return dec == -1 ? "N/A" : RobotronObject.DecimalToHexAddress( dec, zeroPage );
        }

        public static string To8BitHex( this int dec ) {
            return dec == -1 ? "N/A" : RobotronObject.DecimalToHexNum( dec, true );
        }

        public static int LowByte( this int address ) {
            return address & 0x00ff;
        }

        public static int HighByte( this int address ) {
            return address >> 8;
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
