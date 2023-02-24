package tv.freewheel.ad.behavior
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public interface IAdManager
   {
       
      
      function setVisitorHttpHeader(param1:String, param2:String) : void;
      
      function addRenderer(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:Object = null, param7:String = null) : void;
      
      function finalizeRendererStateTransition(param1:Object) : void;
      
      function setParameterObject(param1:String, param2:Object, param3:uint) : void;
      
      function setRequestDuration(param1:Number) : void;
      
      function registerVideoDisplay(param1:Sprite) : void;
      
      function getVideoPlayerNonTemporalSlots() : Array;
      
      function addTemporalSlot(param1:String, param2:String, param3:Number, param4:String = null, param5:uint = 0, param6:Number = 0, param7:Object = null, param8:String = null, param9:String = null, param10:Number = 0, param11:uint = 0, param12:Sprite = null) : ISlot;
      
      function loadResponseData(param1:String) : void;
      
      function getParameterObject(param1:String, param2:uint = 0) : Object;
      
      function getAdVolume() : uint;
      
      function setVideoDisplayCompatibleSizes(param1:Array) : void;
      
      function setRequestMode(param1:String) : void;
      
      function setAdPlayState(param1:Boolean) : void;
      
      function getConstants() : IConstants;
      
      function setCapability(param1:String, param2:*, param3:Object = null) : Boolean;
      
      function setAdVolume(param1:uint) : void;
      
      function getActiveSlots() : Array;
      
      function getVersion() : uint;
      
      function getResponseData() : String;
      
      function addCandidateAd(param1:uint) : void;
      
      function dispose() : void;
      
      function registerPlayheadTimeCallback(param1:Function) : void;
      
      function setVisitor(param1:String, param2:String = null, param3:uint = 0, param4:String = null) : void;
      
      function setEventCallbackKeyValue(param1:String, param2:String) : void;
      
      function addSiteSectionNonTemporalSlot(param1:String, param2:uint, param3:uint, param4:String = null, param5:Boolean = true, param6:* = 0, param7:String = null, param8:Object = null, param9:String = null, param10:String = null, param11:Sprite = null, param12:Array = null) : ISlot;
      
      function setRendererConfiguration(param1:String, param2:String = null) : void;
      
      function setVideoAsset(param1:String, param2:Number, param3:String = null, param4:Boolean = true, param5:Number = 0, param6:uint = 0, param7:uint = 0, param8:* = "", param9:String = null, param10:uint = 0) : void;
      
      function setLiveMode(param1:Boolean) : void;
      
      function getVideoDisplay() : Sprite;
      
      function dispatchEvent(param1:Object) : void;
      
      function debugInitialize(param1:Object) : void;
      
      function log(param1:String, param2:int) : void;
      
      function setServer(param1:String = null) : void;
      
      function removeEventListener(param1:String, param2:Function) : void;
      
      function registerRendererStateTransitionCallback(param1:uint, param2:Function) : void;
      
      function addEventListener(param1:String, param2:Function) : void;
      
      function addVideoPlayerNonTemporalSlot(param1:String, param2:Sprite, param3:uint, param4:uint, param5:String = null, param6:int = 0, param7:int = 0, param8:Boolean = true, param9:String = null, param10:Object = null, param11:String = null, param12:String = null, param13:* = null, param14:Array = null) : ISlot;
      
      function setKeyValue(param1:String, param2:String) : void;
      
      function submitRequest(param1:Number = 0, param2:Number = 0) : void;
      
      function startSubsession(param1:uint) : void;
      
      function refresh() : void;
      
      function setSiteSection(param1:String, param2:Number = 0, param3:uint = 0, param4:uint = 0, param5:* = "") : void;
      
      function getVideoDisplaySize() : Rectangle;
      
      function setVideoPlayStatus(param1:uint) : void;
      
      function addSlotsByUrl(param1:String) : void;
      
      function scanSlotsOnPage(param1:Number = 0, param2:Function = null, param3:Boolean = false, param4:String = null) : Array;
      
      function setProfile(param1:String, param2:String = null, param3:String = null, param4:String = null) : void;
      
      function setVideoDisplaySize(param1:int, param2:int, param3:uint, param4:uint, param5:int, param6:int, param7:uint, param8:uint) : void;
      
      function getVideoPlayStatus() : uint;
      
      function getSlotsByTimePositionClass(param1:String) : Array;
      
      function getVideoPlayheadTime() : Number;
      
      function getSiteSectionNonTemporalSlots() : Array;
      
      function getExtensionByName(param1:String) : Object;
      
      function getParameter(param1:String, param2:uint = 0) : String;
      
      function setCustomDistributor(param1:String, param2:String, param3:String) : void;
      
      function setParameter(param1:String, param2:String, param3:uint) : void;
      
      function getSlotByCustomId(param1:String) : ISlot;
      
      function setVideoAssetCurrentTimePosition(param1:Number) : void;
      
      function loadExtension(param1:String, param2:*) : void;
      
      function setVideoPlayer(param1:uint) : void;
      
      function setNetwork(param1:uint) : void;
      
      function getTemporalSlots() : Array;
   }
}
