package tv.freewheel.ad.behavior
{
   public interface ITranslatorContext
   {
       
      
      function getVideoDuration() : Number;
      
      function getVersion() : uint;
      
      function clearState() : void;
      
      function getVideoPlayheadTime() : Number;
      
      function getConstants() : IConstants;
      
      function setState(param1:String, param2:Object) : void;
      
      function getVideoCustomId() : String;
      
      function getParameterObject(param1:String, param2:uint = 0) : Object;
      
      function getParameter(param1:String, param2:uint = 0) : String;
      
      function getSlot() : ISlot;
      
      function getAllParameters() : Array;
      
      function getPrimaryCreativeRendition() : ICreativeRendition;
      
      function getCompanionAds() : Array;
      
      function getState(param1:String) : Object;
      
      function getCompanionSlots() : Array;
   }
}
