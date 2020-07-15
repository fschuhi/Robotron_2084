﻿using System;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Windows.Controls;
using System.Windows.Input;
using Jellyfish.Virtu;
using Jellyfish.Virtu.Services;

namespace Robotron {
    public sealed class VirtuRoCWpfKeyboardService : KeyboardService {

        MachineOperator _operator;
        private bool _resetKeyDown;

        public VirtuRoCWpfKeyboardService( MachineOperator mop, Machine machine, UserControl page ) :
            base( machine ) {
            if (page == null) {
                throw new ArgumentNullException( "page" );
            }

            _operator = mop;

            page.KeyDown += OnPageKeyDown;
            page.KeyUp += OnPageKeyUp;
            page.GotKeyboardFocus += ( sender, e ) => _updateAnyKeyDown = true;
        }

        public override bool IsKeyDown( int key ) {
            return IsKeyDown( (Key)key );
        }

        public override void Update() {
            var keyboard = System.Windows.Input.Keyboard.PrimaryDevice;

            // check if reentrant?
            if (_updateAnyKeyDown) {
                _updateAnyKeyDown = false;
                IsAnyKeyDown = false;
                for (int i = 0; i < KeyValues.Length; i++) {
                    var key = KeyValues[i];
                    bool isKeyDown = keyboard.IsKeyDown( key );
                    _states[(int)key] = isKeyDown;
                    if (isKeyDown) {
                        IsAnyKeyDown = true;
                    }
                }
            }

            IsControlKeyDown = ((keyboard.Modifiers & ModifierKeys.Control) != 0);
            IsShiftKeyDown = ((keyboard.Modifiers & ModifierKeys.Shift) != 0);

            IsOpenAppleKeyDown = keyboard.IsKeyDown( Key.LeftAlt ) || IsKeyDown( Key.NumPad0 );
            IsCloseAppleKeyDown = keyboard.IsKeyDown( Key.RightAlt ) || IsKeyDown( Key.Decimal );
            IsResetKeyDown = IsControlKeyDown && keyboard.IsKeyDown( Key.Back );

            if (IsResetKeyDown && !Machine.Keyboard.DisableResetKey) {
                if (!_resetKeyDown) {
                    _resetKeyDown = true; // entering reset; pause until key released
                    _operator.mo_Suspend();
                    Machine.Reset( null );
                }
            } else if (_resetKeyDown) {
                _resetKeyDown = false; // leaving reset
                _operator.mo_Resume();
            }
        }


        private bool IsKeyDown( Key key ) {
            return _states[(int)key];
        }

        private void OnPageKeyDown( object sender, KeyEventArgs e ) {
            //DebugService.WriteLine(string.Concat("OnPageKeyDn: Key=", e.Key));

            if (e.Key != Key.System) {
                Trace.WriteLine( string.Concat( "OnPageKeyDn: Key=", e.Key ) );
            }

            _states[(int)((e.Key == Key.System) ? e.SystemKey : e.Key)] = true;
            _updateAnyKeyDown = false;
            IsAnyKeyDown = true;

            int asciiKey = GetAsciiKey( e.Key, e.KeyboardDevice );
            if (asciiKey >= 0) {
                Machine.Keyboard.Latch = asciiKey;
                e.Handled = true;
            }

            Update();
        }

        private void OnPageKeyUp( object sender, KeyEventArgs e ) {
            //DebugService.WriteLine(string.Concat("OnPageKeyUp: Key=", e.Key));

            _states[(int)((e.Key == Key.System) ? e.SystemKey : e.Key)] = false;
            _updateAnyKeyDown = true;

            /*
            bool control = ((e.KeyboardDevice.Modifiers & ModifierKeys.Control) != 0);
            if (control && (e.Key == Key.Divide)) {
                Machine.Cpu.IsThrottled ^= true;
            } else if (control && (e.Key == Key.Multiply)) {
                Machine.Video.IsMonochrome ^= true;
            } else if (control && (e.Key == Key.Subtract)) {
                Machine.Video.IsFullScreen ^= true;
            }
            */

            bool alt = ((e.KeyboardDevice.Modifiers & ModifierKeys.Alt) != 0);

            if (alt && (e.SystemKey == Key.T)) {
                Machine.Cpu.IsThrottled ^= true;
            } else if (alt && (e.SystemKey == Key.M)) {
                Machine.Video.IsMonochrome ^= true;
            } else if (alt && (e.SystemKey == Key.F)) {
                Machine.Video.IsFullScreen ^= true;
            } else if (alt && (e.SystemKey == Key.P)) {
                //Machine.Pause();
                _operator.mo_Pause();
            } else if (alt && (e.SystemKey == Key.U)) {
                //Machine.Unpause();
                _operator.mo_Unpause();
            }

            Update();
        }

        [SuppressMessage( "Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity" )]
        [SuppressMessage( "Microsoft.Maintainability", "CA1505:AvoidUnmaintainableCode" )]
        private static int GetAsciiKey( Key key, KeyboardDevice keyboard ) {
            bool control = ((keyboard.Modifiers & ModifierKeys.Control) != 0);
            bool shift = ((keyboard.Modifiers & ModifierKeys.Shift) != 0);
            bool capsLock = shift ^ keyboard.IsKeyToggled( Key.CapsLock );

            // FS
            capsLock = true;

            switch (key) {
                case Key.Left:
                    return 0x08;

                case Key.Tab:
                    return 0x09;

                case Key.Down:
                    return 0x0A;

                case Key.Up:
                    return 0x0B;

                case Key.Enter:
                    return 0x0D;

                case Key.Right:
                    return 0x15;

                case Key.Escape:
                    return 0x1B;

                case Key.Back:
                    return control ? -1 : 0x7F;

                case Key.Space:
                    return ' ';

                case Key.D1:
                    return shift ? '!' : '1';

                case Key.D2:
                    return control ? 0x00 : shift ? '@' : '2';

                case Key.D3:
                    return shift ? '#' : '3';

                case Key.D4:
                    return shift ? '$' : '4';

                case Key.D5:
                    return shift ? '%' : '5';

                case Key.D6:
                    return control ? 0x1E : shift ? '^' : '6';

                case Key.D7:
                    return shift ? '&' : '7';

                case Key.D8:
                    return shift ? '*' : '8';

                case Key.D9:
                    return shift ? '(' : '9';

                case Key.D0:
                    return shift ? ')' : '0';

                case Key.A:
                    return control ? 0x01 : capsLock ? 'A' : 'a';

                case Key.B:
                    return control ? 0x02 : capsLock ? 'B' : 'b';

                case Key.C:
                    return control ? 0x03 : capsLock ? 'C' : 'c';

                case Key.D:
                    return control ? 0x04 : capsLock ? 'D' : 'd';

                case Key.E:
                    return control ? 0x05 : capsLock ? 'E' : 'e';

                case Key.F:
                    return control ? 0x06 : capsLock ? 'F' : 'f';

                case Key.G:
                    return control ? 0x07 : capsLock ? 'G' : 'g';

                case Key.H:
                    return control ? 0x08 : capsLock ? 'H' : 'h';

                case Key.I:
                    return control ? 0x09 : capsLock ? 'I' : 'i';

                case Key.J:
                    return control ? 0x0A : capsLock ? 'J' : 'j';

                case Key.K:
                    return control ? 0x0B : capsLock ? 'K' : 'k';

                case Key.L:
                    return control ? 0x0C : capsLock ? 'L' : 'l';

                case Key.M:
                    return control ? 0x0D : capsLock ? 'M' : 'm';

                case Key.N:
                    return control ? 0x0E : capsLock ? 'N' : 'n';

                case Key.O:
                    return control ? 0x0F : capsLock ? 'O' : 'o';

                case Key.P:
                    return control ? 0x10 : capsLock ? 'P' : 'p';

                case Key.Q:
                    return control ? 0x11 : capsLock ? 'Q' : 'q';

                case Key.R:
                    return control ? 0x12 : capsLock ? 'R' : 'r';

                case Key.S:
                    return control ? 0x13 : capsLock ? 'S' : 's';

                case Key.T:
                    return control ? 0x14 : capsLock ? 'T' : 't';

                case Key.U:
                    return control ? 0x15 : capsLock ? 'U' : 'u';

                case Key.V:
                    return control ? 0x16 : capsLock ? 'V' : 'v';

                case Key.W:
                    return control ? 0x17 : capsLock ? 'W' : 'w';

                case Key.X:
                    return control ? 0x18 : capsLock ? 'X' : 'x';

                case Key.Y:
                    return control ? 0x19 : capsLock ? 'Y' : 'y';

                case Key.Z:
                    return control ? 0x1A : capsLock ? 'Z' : 'z';

                case Key.Oem1:
                    return shift ? ':' : ';';

                case Key.Oem2:
                    return shift ? '?' : '/';

                case Key.Oem3:
                    return shift ? '~' : '`';

                case Key.Oem4:
                    return shift ? '{' : '[';

                case Key.Oem5:
                    return control ? 0x1C : shift ? '|' : '\\';

                case Key.Oem6:
                    return control ? 0x1D : shift ? '}' : ']';

                case Key.Oem7:
                    return shift ? '"' : '\'';

                case Key.OemMinus:
                    return control ? 0x1F : shift ? '_' : '-';

                case Key.OemPlus:
                    return shift ? '+' : '=';

                case Key.OemComma:
                    return shift ? '<' : ',';

                case Key.OemPeriod:
                    return shift ? '>' : '.';
            }

            return -1;
        }

        private static readonly Key[] KeyValues =
            (from key in (Key[])Enum.GetValues( typeof( Key ) )
             where (key != Key.None) // filter Key.None; avoids validation exception
             select key).ToArray();

        private static readonly int KeyCount = (int)(KeyValues.Max()) + 1;

        private bool[] _states = new bool[KeyCount];
        private bool _updateAnyKeyDown;
    }
}
