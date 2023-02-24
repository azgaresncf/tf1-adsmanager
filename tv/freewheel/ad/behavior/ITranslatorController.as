package tv.freewheel.ad.behavior
{
   public interface ITranslatorController
   {
       
      
      function scheduleAd(param1:Array) : Array;
      
      function log(param1:String, param2:int = 0, param3:uint = 0, param4:Object = null) : void;
      
      function handleStateTransition(param1:uint, param2:Object = null) : void;
      
      function dispatchCustomEvent(param1:String, param2:Object) : void;
   }
}
