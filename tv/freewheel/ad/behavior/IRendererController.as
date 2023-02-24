package tv.freewheel.ad.behavior
{
   public interface IRendererController
   {
       
      
      function requestVideoPause(param1:Boolean) : void;
      
      function processEvent(param1:uint, param2:Object = null) : void;
      
      function log(param1:String, param2:int = 0, param3:uint = 0, param4:Object = null) : void;
      
      function dispatchCustomEvent(param1:String, param2:Object) : void;
      
      function scheduleAd(param1:Array) : Array;
      
      function setCapability(param1:uint, param2:Boolean, param3:Object = null) : Boolean;
      
      function addAllowedDomain(param1:String) : void;
      
      function commitAd() : void;
      
      function handleStateTransition(param1:uint, param2:Object = null) : void;
      
      function setEventCallbackKeyValue(param1:String, param2:String) : void;
   }
}
