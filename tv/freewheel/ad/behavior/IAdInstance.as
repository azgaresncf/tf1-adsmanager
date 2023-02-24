package tv.freewheel.ad.behavior
{
   public interface IAdInstance
   {
       
      
      function getAllCreativeRenditions() : Array;
      
      function setEventCallbackURLs(param1:String, param2:String, param3:Array) : void;
      
      function getTotalDuration(param1:Boolean = false) : Number;
      
      function getCreativeParameter(param1:String) : String;
      
      function getCompanionAdInstances() : Array;
      
      function isRequiredToShow() : Boolean;
      
      function addCreativeRendition() : ICreativeRendition;
      
      function skipRendering(param1:Boolean) : void;
      
      function setEventCallbackKeyValue(param1:String, param2:String) : void;
      
      function getAdId() : int;
      
      function getRendererController() : IRendererController;
      
      function getPlayheadTime(param1:Boolean = false) : Number;
      
      function getPrimaryCreativeRendition() : ICreativeRendition;
      
      function getSlot() : ISlot;
      
      function getEventCallbackURLs(param1:String, param2:String = null, param3:Boolean = false) : Array;
   }
}
