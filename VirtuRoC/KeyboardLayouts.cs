using System;
using System.Runtime.InteropServices;
using System.Globalization;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;

// https://stackoverflow.com/questions/37291533/change-keyboard-layout-from-c-sharp-code-with-net-4-5-2

namespace Robotron {

    public static class SettingKeyboardLanguage {
        public static InputLanguage GetInputLanguageByName( string inputName ) {
            foreach (InputLanguage lang in InputLanguage.InstalledInputLanguages) {
                if (lang.Culture.EnglishName.ToLower().StartsWith( inputName.ToLower() )) {
                    return lang;
                }
            }
            return null;
        }

        public static void SetKeyboardLayout( InputLanguage layout ) {
            InputLanguage.CurrentInputLanguage = layout;
        }
    }

    internal sealed class KeyboardLayout {

        [DllImport( "user32.dll",
        CallingConvention = CallingConvention.StdCall,
        CharSet = CharSet.Unicode,
        EntryPoint = "LoadKeyboardLayout",
        SetLastError = true,
        ThrowOnUnmappableChar = false )]
        static extern uint LoadKeyboardLayout(
        StringBuilder pwszKLID,
        uint flags );

        [DllImport( "user32.dll",
            CallingConvention = CallingConvention.StdCall,
            CharSet = CharSet.Unicode,
            EntryPoint = "GetKeyboardLayout",
            SetLastError = true,
            ThrowOnUnmappableChar = false )]
        static extern uint GetKeyboardLayout(
            uint idThread );

        [DllImport( "user32.dll",
            CallingConvention = CallingConvention.StdCall,
            CharSet = CharSet.Unicode,
            EntryPoint = "ActivateKeyboardLayout",
            SetLastError = true,
            ThrowOnUnmappableChar = false )]
        static extern uint ActivateKeyboardLayout(
            uint hkl,
            uint Flags );

        static class KeyboardLayoutFlags {
            public const uint KLF_ACTIVATE = 0x00000001;
            public const uint KLF_SETFORPROCESS = 0x00000100;
        }

        private readonly uint hkl;

        private KeyboardLayout( CultureInfo cultureInfo ) {
            string layoutName = cultureInfo.LCID.ToString( "x8" );

            var pwszKlid = new StringBuilder( layoutName );
            this.hkl = LoadKeyboardLayout( pwszKlid, KeyboardLayoutFlags.KLF_ACTIVATE );
        }

        private KeyboardLayout( uint hkl ) {
            this.hkl = hkl;
        }

        public uint Handle {
            get {
                return this.hkl;
            }
        }

        public static KeyboardLayout GetCurrent() {
            uint hkl = GetKeyboardLayout( (uint)Thread.CurrentThread.ManagedThreadId );
            return new KeyboardLayout( hkl );
        }

        public static KeyboardLayout Load( CultureInfo culture ) {
            return new KeyboardLayout( culture );
        }

        public void Activate() {
            ActivateKeyboardLayout( this.hkl, KeyboardLayoutFlags.KLF_SETFORPROCESS );
        }
    }

    class KeyboardLayoutScope : IDisposable {
        private readonly KeyboardLayout currentLayout;

        public KeyboardLayoutScope( CultureInfo culture ) {
            this.currentLayout = KeyboardLayout.GetCurrent();
            var layout = KeyboardLayout.Load( culture );
            layout.Activate();
        }

        public void Dispose() {
            this.currentLayout.Activate();
        }
    }
}
