using Stateless;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Input;
using AspectInjector.Broker;

/*
 * have a checkbox "sorted"
 */

namespace Robotron {
    /// <summary>
    /// Interaction logic for Window2.xaml
    /// </summary>

    #region aspects
    [Aspect( Scope.PerInstance )]
    [Injection( typeof( OnEntry2 ) )]
    public class OnEntry2 : Attribute {
        [Advice( Kind.Before )] // you can have also After (async-aware), and Around(Wrap/Instead) kinds
        public void LogEnter( [Argument( Source.Name )] string name ) {
            Console.WriteLine( $"OnEntry '{name}'" );   //you can debug it	
        }
    }

    [Aspect( Scope.PerInstance )]
    [Injection( typeof( OnExit2 ) )]
    public class OnExit2 : Attribute {
        [Advice( Kind.Before )]
        public void LogEnter( [Argument( Source.Name )] string name ) {
            Console.WriteLine( $"OnExit '{name}'" );   //you can debug it	
        }
    }
    #endregion


    public class NavigationTarget : IComparable<NavigationTarget> {
        public string Target { get; set; }

        public bool Grayed { get; set; }

        public int CompareTo( NavigationTarget other ) {
            return Target.CompareTo( other.Target );
        }
    }


    public partial class Window2 : Window {

        Action<string> _peekTarget;
        Action<string> _undoPeekTarget;

        public List<NavigationTarget> NavigationTargets { get; } = new List<NavigationTarget>();
        public string Search { get; set; }
        public string FindIndicator { get; set; }

        private List<NavigationTarget> _matchingTargets = new List<NavigationTarget>();

        public Window2( Action<string> peekTarget, Action<string> undoPeekTarget ) {
            InitializeComponent();
            this.DataContext = this;

            _peekTarget = peekTarget;
            _undoPeekTarget = undoPeekTarget;

            ConfigureStatemachine();
            CreateKeyboardShortcuts();

            Search = "";

            listBox2.Focus();
        }

        public void PopulateListbox( List<string> targets ) {
            foreach (string target in targets ) { 
                bool skip = Regex.IsMatch( target, "^(@|[LSB][0-9A-F][0-9A-F][0-9A-F][0-9A-F])" );
                if (!skip) NavigationTargets.Add( new NavigationTarget() { Target = target } );
            }
            SelectedTarget = NavigationTargets.First();
        }

        public NavigationTarget SelectedTarget {
            get { return (NavigationTarget)listBox2.SelectedItem; }
            set { listBox2.SelectedItem = value; }
        }

        #region statemachine
        private enum State { WaitingForKey, Restarting, Peeking, Done, Navigated, Cancelled }
        private enum Trigger { Start, Restart, Char, Backspace, Escape, Return }
        private StateMachine<State, Trigger> _sm;
        private StateMachine<State, Trigger>.TriggerWithParameters<char> _charTrigger;

        private void ConfigureStatemachine() {
            _sm = new StateMachine<State, Trigger>( State.WaitingForKey );
            _charTrigger = _sm.SetTriggerParameters<char>( Trigger.Char );

            _sm.Configure( State.WaitingForKey )
                .PermitReentry( Trigger.Char )
                .PermitReentry( Trigger.Backspace )
                .OnEntryFrom( _charTrigger, sm_WaitingForKey_OnEntryFrom_Char )
                .OnEntryFrom( Trigger.Backspace, sm_WaitingForKey_OnEntryFrom_Backspace )
                .Permit( Trigger.Return, State.Peeking )
                .PermitIf( Trigger.Escape, State.Cancelled, () => Search == "" )
                .PermitIf( Trigger.Escape, State.Restarting, () => Search != "" );

            _sm.Configure( State.Restarting )
                .OnEntry( sm_Restarting_OnEntry )
                .Permit( Trigger.Restart, State.WaitingForKey );

            _sm.Configure( State.Peeking )
                .Ignore( Trigger.Char )
                .Ignore( Trigger.Backspace )
                .OnEntry( sm_Peeking_OnEntry )
                .OnExit( sm_Peeking_OnExit )
                .Permit( Trigger.Escape, State.WaitingForKey )
                .Permit( Trigger.Return, State.Navigated );

            _sm.Configure( State.Done )
                .Ignore( Trigger.Char )
                .Ignore( Trigger.Backspace )
                .Ignore( Trigger.Return )
                .Ignore( Trigger.Escape );

                _sm.Configure( State.Navigated )
                    .SubstateOf( State.Done )
                    .OnEntry( sm_Navigated_OnEntry );

                _sm.Configure( State.Cancelled )
                    .SubstateOf( State.Done )
                    .OnEntry( sm_Cancelled_OnEntry );
        }

        private void Reset() {
            SelectedTarget = NavigationTargets.First();
            _matchingTargets.Clear();
            Search = "";
            FindIndicator = "";
            Refresh();
        }

        private void Refresh() {
            Console.WriteLine( "Refresh() " + listBox2.SelectedIndex.ToString() );
            listBox2.Refresh();
            listBox2.ScrollToCenterOfView( listBox2.SelectedItem );
            tbSearch.Text = Search.ToLower();
            if (_matchingTargets.Count == 0) {
                tbFindIndicator.Text = "";
            } else {
                int index = _matchingTargets.IndexOf( SelectedTarget ) + 1;
                int count = _matchingTargets.Count;
                tbFindIndicator.Text = index > 0 && count > 0 && !(index == 1 && count == 1)? $"{index}/{count}" : "";
            }
        }

        [OnEntry2]
        private void sm_WaitingForKey_OnEntryFrom_Char( char c ) {
            // add char to search string
            // find best match

            Console.WriteLine( "" );
            Console.WriteLine( "pressed " + c );
            _matchingTargets = NavigationTargets.FindAll( x => x.Target.ToUpper().StartsWith( Search + c ) );
            if (_matchingTargets.Count > 0) {
                NavigationTarget found = _matchingTargets.First();
                Console.WriteLine( "found " + found.Target );
                Search += c;
                SelectedTarget = found;
                Refresh();
            }

            Console.WriteLine( "sm_OnEntry_Char() exit: " + Search );
        }

        [OnEntry2]
        private void sm_WaitingForKey_OnEntryFrom_Backspace() {
            if (Search == "") return;

            // remove las char from search string
            Search = Search.Substring( 0, Search.Length - 1 );
            Console.WriteLine( Search );
            if (Search == "") {
                SelectedTarget = NavigationTargets.First();
                Refresh();
            } else {
                // find best match if we still have a search string
                _matchingTargets = NavigationTargets.FindAll( x => x.Target.ToUpper().StartsWith( Search ) );
                Debug.Assert( _matchingTargets.Count > 0 );
                SelectedTarget = _matchingTargets.First();
                Refresh();
            }
        }

        [OnEntry2]
        private void sm_Restarting_OnEntry() {
            Reset();
            _sm.Fire( Trigger.Restart );
        }

        [OnEntry2]
        private void sm_Peeking_OnEntry() {
            Console.WriteLine( "navigate to " + SelectedTarget.Target );
            _peekTarget?.Invoke( SelectedTarget.Target );
        }

        [OnExit2]
        private void sm_Peeking_OnExit( StateMachine<State, Trigger>.Transition transition ) {
            if (transition.Destination == State.WaitingForKey) {
                // restore position in Asmlines
                Console.WriteLine( "restore position" );
                _undoPeekTarget?.Invoke( SelectedTarget.Target );
                // Refresh();
            } else {
                Console.WriteLine( "end state reached" );
            }
        }

        [OnEntry2]
        private void sm_Navigated_OnEntry() {
            _peekTarget?.Invoke( SelectedTarget.Target );
            this.Close();
        }

        [OnEntry2]
        private void sm_Cancelled_OnEntry() {
            this.Close();
        }
        #endregion

        #region keyboard shortcuts
        private void RegisterGesture( Action executeDelegate, Key key, ModifierKeys modifiers ) {
            InputBindings.Add( new KeyBinding( new WindowCommand( this ) { ExecuteDelegate = executeDelegate }, new KeyGesture( key, modifiers ) ) );
        }

        public void CreateKeyboardShortcuts() {
            RegisterGesture( GotoNextFound, Key.Down, ModifierKeys.Alt );
            RegisterGesture( GotoPrevFound, Key.Up, ModifierKeys.Alt );
        }

        public void GotoNextFound() {
            int ixFound = _matchingTargets.IndexOf( SelectedTarget );
            if (ixFound >= 0 && ixFound + 1 < _matchingTargets.Count) {
                SelectedTarget = _matchingTargets[ixFound + 1];
                Refresh();
            }
        }
        #endregion

        public void GotoPrevFound() {
            int ixFound = _matchingTargets.IndexOf( SelectedTarget );
            if (ixFound > 0) {
                SelectedTarget = _matchingTargets[ixFound - 1];
                Refresh();
            }
        }

        private void listBox2_KeyDown( object sender, KeyEventArgs e ) {
            switch (e.Key) {
                case Key.Escape:
                    _sm.Fire( Trigger.Escape );
                    break;

                case Key.Return:
                    _sm.Fire( Trigger.Return );
                    break;

                case Key.Back:
                    _sm.Fire( Trigger.Backspace );
                    break;

                default:
                    string key = e.Key.ToString();
                    if (key.Length == 1) {
                        char c = key[0];
                        _sm.Fire( _charTrigger, c );
                        e.Handled = true;
                    }
                    break;
            }

            // easier than the whole PropertyChanged business
            //Components[0].Grayed = true;
            //listBox2.Refresh();
        }

        private void listBox2_PreviewKeyDown( object sender, KeyEventArgs e ) {
            switch (e.Key) {
                case Key.Up:
                case Key.Down:
                    e.Handled = Keyboard.IsKeyDown( Key.LeftCtrl );
                    break;
            }
        }

    }

}
