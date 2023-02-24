package tv.freewheel.utils.stateMachine
{
   import flash.events.Event;
   
   public class StateMachineEvent extends Event
   {
      
      public static const TRANSITION_DENIED:String = "transition denied";
      
      public static const EXIT_CALLBACK:String = "exit";
      
      public static const TRANSITION_COMPLETE:String = "transition complete";
      
      public static const ENTER_CALLBACK:String = "enter";
       
      
      public var toState:String;
      
      public var fromState:String;
      
      public var currentState:String;
      
      public var allowedStates:Object;
      
      public function StateMachineEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
