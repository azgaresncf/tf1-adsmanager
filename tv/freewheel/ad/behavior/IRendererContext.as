package tv.freewheel.ad.behavior
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public interface IRendererContext
   {
       
      
      function clearState() : void;
      
      function getEventCallbackNames(param1:String) : Array;
      
      function getEventCallbackURLs(param1:String, param2:String = null) : Array;
      
      function getAdInstance() : IAdInstance;
      
      function setState(param1:String, param2:Object) : void;
      
      function getVideoCustomId() : String;
      
      function getParameterObject(param1:String, param2:uint = 0) : Object;
      
      function getAdVolume() : uint;
      
      function getAllCreativeRenditions() : Array;
      
      function getState(param1:String) : Object;
      
      function getSlotBaseDisplay() : Sprite;
      
      function getVideoDisplaySize() : Rectangle;
      
      function getConstants() : IConstants;
      
      function getVersion() : uint;
      
      function setPrimaryCreativeRendition(param1:ICreativeRendition) : void;
      
      function getVideoPlayheadTime() : Number;
      
      function getPrimaryCreativeRendition() : ICreativeRendition;
      
      function getVideoPlayStatus() : uint;
      
      function setActiveBundleId(param1:String) : void;
      
      function getActiveBundleId() : String;
      
      function getParameter(param1:String, param2:uint = 0) : String;
      
      function getSlot() : ISlot;
      
      function getAllParameters() : Array;
      
      function getSlotByCustomId(param1:String) : ISlot;
      
      function getVideoDuration() : Number;
      
      function getCompanionAds() : Array;
      
      function getSlotBaseDisplaySize() : Rectangle;
      
      function getCompanionSlots() : Array;
   }
}
