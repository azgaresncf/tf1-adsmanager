package tv.freewheel.utils.stateMachine
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class StateMachine extends EventDispatcher
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.StateMachine");
       
      
      public var _states:Dictionary;
      
      public var path:Array;
      
      public var parentState:State;
      
      public var _outEvent:StateMachineEvent;
      
      public var parentStates:Array;
      
      public var _state:String;
      
      public var id:String;
      
      public function StateMachine()
      {
         super();
         this._states = new Dictionary();
      }
      
      public function changeState(param1:String) : void
      {
         var _loc3_:StateMachineEvent = null;
         var _loc4_:int = 0;
         var _loc5_:StateMachineEvent = null;
         var _loc6_:int = 0;
         if(!(param1 in this._states))
         {
            return;
         }
         if(!this.canChangeStateTo(param1))
         {
            this._outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_DENIED);
            this._outEvent.fromState = this._state;
            this._outEvent.toState = param1;
            this._outEvent.allowedStates = this._states[param1].from;
            dispatchEvent(this._outEvent);
            return;
         }
         this.path = this.findPath(this._state,param1);
         if(this.path[0] > 0)
         {
            _loc3_ = new StateMachineEvent(StateMachineEvent.EXIT_CALLBACK);
            _loc3_.toState = param1;
            _loc3_.fromState = this._state;
            if(this._states[this._state].exit)
            {
               _loc3_.currentState = this._state;
               this._states[this._state].exit.call(null,_loc3_);
            }
            this.parentState = this._states[this._state];
            _loc4_ = 0;
            while(_loc4_ < this.path[0] - 1)
            {
               this.parentState = this.parentState.parent;
               if(this.parentState.exit != null)
               {
                  _loc3_.currentState = this.parentState.name;
                  this.parentState.exit.call(null,_loc3_);
               }
               _loc4_++;
            }
         }
         var _loc2_:String = this._state;
         this._state = param1;
         if(this.path[1] > 0)
         {
            (_loc5_ = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK)).toState = param1;
            _loc5_.fromState = _loc2_;
            if(this._states[param1].root)
            {
               this.parentStates = this._states[param1].parents;
               _loc6_ = this.path[1] - 2;
               while(_loc6_ >= 0)
               {
                  if(Boolean(this.parentStates[_loc6_]) && Boolean(this.parentStates[_loc6_].enter))
                  {
                     _loc5_.currentState = this.parentStates[_loc6_].name;
                     this.parentStates[_loc6_].enter.call(null,_loc5_);
                  }
                  _loc6_--;
               }
            }
            if(this._states[this._state].enter)
            {
               _loc5_.currentState = this._state;
               this._states[this._state].enter.call(null,_loc5_);
            }
         }
         this._outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
         this._outEvent.fromState = _loc2_;
         this._outEvent.toState = param1;
         dispatchEvent(this._outEvent);
      }
      
      public function tryChangeStateTo(param1:String) : Boolean
      {
         if(param1 == this._state)
         {
            return true;
         }
         if(this.canChangeStateTo(param1))
         {
            this.changeState(param1);
            return true;
         }
         return false;
      }
      
      public function get states() : Dictionary
      {
         return this._states;
      }
      
      public function tryChangeStateToInOrder(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            if(this.tryChangeStateTo(_loc2_))
            {
               break;
            }
         }
      }
      
      public function addState(param1:String, param2:Object = null) : void
      {
         if(param2 == null)
         {
            param2 = {};
         }
         this._states[param1] = new State(param1,param2.from,param2.enter,param2.exit,this._states[param2.parent]);
      }
      
      public function get state() : String
      {
         return this._states[this._state];
      }
      
      public function getStateByName(param1:String) : State
      {
         var _loc2_:State = null;
         for each(_loc2_ in this._states)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function canChangeStateTo(param1:String) : Boolean
      {
         return param1 != this._state && (this._states[param1].from.indexOf(this._state) != -1 || this._states[param1].from == "*");
      }
      
      public function set initialState(param1:String) : void
      {
         var _loc2_:StateMachineEvent = null;
         var _loc3_:int = 0;
         if(this._state == null && param1 in this._states)
         {
            this._state = param1;
            _loc2_ = new StateMachineEvent(StateMachineEvent.ENTER_CALLBACK);
            _loc2_.toState = param1;
            if(this._states[this._state].root)
            {
               this.parentStates = this._states[this._state].parents;
               _loc3_ = this._states[this._state].parents.length - 1;
               while(_loc3_ >= 0)
               {
                  if(this.parentStates[_loc3_].enter)
                  {
                     _loc2_.currentState = this.parentStates[_loc3_].name;
                     this.parentStates[_loc3_].enter.call(null,_loc2_);
                  }
                  _loc3_--;
               }
            }
            if(this._states[this._state].enter)
            {
               _loc2_.currentState = this._state;
               this._states[this._state].enter.call(null,_loc2_);
            }
            this._outEvent = new StateMachineEvent(StateMachineEvent.TRANSITION_COMPLETE);
            this._outEvent.toState = param1;
            dispatchEvent(this._outEvent);
         }
      }
      
      public function findPath(param1:String, param2:String) : Array
      {
         var _loc6_:State = null;
         var _loc3_:State = this._states[param1];
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc3_)
         {
            _loc5_ = 0;
            _loc6_ = this._states[param2];
            while(_loc6_)
            {
               if(_loc3_ == _loc6_)
               {
                  return [_loc4_,_loc5_];
               }
               _loc5_++;
               _loc6_ = _loc6_.parent;
            }
            _loc4_++;
            _loc3_ = _loc3_.parent;
         }
         return [_loc4_,_loc5_];
      }
   }
}
