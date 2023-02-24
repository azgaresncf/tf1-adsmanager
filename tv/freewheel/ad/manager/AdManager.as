package tv.freewheel.ad.manager
{
   import flash.display.Sprite;
   import flash.external.ExternalInterface;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import tv.freewheel.ad.UrlInstance.GlobalParams;
   import tv.freewheel.ad.UrlInstance.SlotParams;
   import tv.freewheel.ad.UrlInstance.TagGeneratorUrlInstance;
   import tv.freewheel.ad.behavior.IAdManager;
   import tv.freewheel.ad.behavior.IConstants;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.events.FWEvent;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.ad.CandidateAd;
   import tv.freewheel.ad.vo.adRenderer.AdRenderer;
   import tv.freewheel.ad.vo.capabilities.Capabilities;
   import tv.freewheel.ad.vo.environment.PlayerEnvironment;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.ad.vo.slot.NonTemporalSlot;
   import tv.freewheel.ad.vo.slot.TemporalSlot;
   import tv.freewheel.playerextension.DisplayRefreshMonitor;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.log.Logger;
   import tv.freewheel.utils.url.URLTools;
   
   public class AdManager implements IAdManager
   {
      
      public static var AdManagerInitialized:Boolean = AdManagerInitialize();
      
      public static var AdManagerUrl:String = null;
      
      public static var LoaderInstance:Object = null;
      
      public static var PageOptions:Object;
      
      private static const EnableDebug:Boolean = true;
      
      public static var StageUrl:String = null;
      
      public static var OutputFormat:String = "-STATIC";
      
      private static const Tag:String = "6.13.0.0";
      
      private static const Revision:String = "fd9632ef";
      
      private static const Timestamp:String = "201701132046";
      
      public static const Caller:String = "AS3-" + Tag + "-r" + Revision + "-" + Timestamp;
       
      
      public var _context:Contexts;
      
      public function AdManager(param1:Boolean = true)
      {
         super();
         this._context = new Contexts(this);
         if(param1)
         {
            this._context.adManagerContext.extensionManager.load("DisplayRefreshMonitor",new DisplayRefreshMonitor(),true);
         }
      }
      
      private static function getFWId(param1:String, param2:uint) : String
      {
         var _loc3_:String = null;
         switch(param2)
         {
            case Constants.instance.ID_TYPE_FWGROUP:
               if(!SuperString.isNull(param1))
               {
                  _loc3_ = "g" + param1;
               }
               break;
            case Constants.instance.ID_TYPE_FW:
               _loc3_ = param1;
         }
         return _loc3_;
      }
      
      private static function getCustomId(param1:String, param2:uint) : String
      {
         return param2 == Constants.instance.ID_TYPE_CUSTOM ? param1 : null;
      }
      
      public static function getLibraryVersion() : uint
      {
         var _loc1_:Array = Tag.toLowerCase().split("trunk").join("99").split("x").join("99").split("refactor").join("99").split(".");
         while(_loc1_.length < 4)
         {
            _loc1_.push("0");
         }
         return uint(256 * 256 * 256 * _loc1_[0] + 256 * 256 * _loc1_[1] + 256 * _loc1_[2] + 1 * _loc1_[3]);
      }
      
      private static function AdManagerInitialize() : Boolean
      {
         trace("FreeWheel Integration Runtime " + Caller);
         if(ExternalInterface.available)
         {
            try
            {
               PageOptions = ExternalInterface.call("function(){if (!window._fw_admanager) window._fw_admanager = {}; window._fw_admanager.version=\'" + Caller + "\'; window._fw_admanager.enableDebug=" + EnableDebug + "; return window._fw_admanager;}");
            }
            catch(e:Error)
            {
            }
         }
         if(!PageOptions)
         {
            PageOptions = new Object();
            return false;
         }
         return true;
      }
      
      public function setVisitorHttpHeader(param1:String, param2:String) : void
      {
         this._context.adManagerContext.visitor.setHttpHeader(param1,param2);
      }
      
      public function registerVideoDisplay(param1:Sprite) : void
      {
         this._context.adManagerContext.playerEnvironment.temporalSlotBase = param1;
      }
      
      public function setRequestMode(param1:String) : void
      {
         if(param1 != Constants.instance.REQUEST_MODE_LIVE && param1 != Constants.instance.REQUEST_MODE_ON_DEMAND)
         {
            Logger.instance.warn("AdManager.setRequestMode unknown mode: " + param1);
            return;
         }
         this._context.adManagerContext.requestMode = param1;
         if(param1 == Constants.instance.REQUEST_MODE_LIVE && this._context.adManagerContext.subsessionToken == 0)
         {
            this.startSubsession(Math.random() * 10000 + 1);
         }
      }
      
      public function getParameterObject(param1:String, param2:uint = 0) : Object
      {
         return this._context.requestContext.getParameter(param1,param2);
      }
      
      public function setAdPlayState(param1:Boolean) : void
      {
         var _loc2_:Array = this.getActiveSlots();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            ISlot(_loc2_[_loc3_]).pause(param1);
            _loc3_++;
         }
      }
      
      public function setCapability(param1:String, param2:*, param3:Object = null) : Boolean
      {
         if(Capabilities.DEFAULT_ON_FEATURES.indexOf(param1) >= 0 || Capabilities.DEFAULT_OFF_FEATURES.indexOf(param1) >= 0 || Capabilities.OVERRIDE_FEATURES.indexOf(param1) >= 0 || Capabilities.CANDIDATE_AD_DEFAULT_ON_FEATURES.indexOf(param1) >= 0 || Capabilities.CANDIDATE_AD_DEFAULT_OFF_FEATURES.indexOf(param1) >= 0)
         {
            this._context.adManagerContext.capabilities.setCapability(param1,param2);
            return true;
         }
         Logger.instance.warn("AdManager.setCapability(), unknown capability");
         return false;
      }
      
      public function getResponseData() : String
      {
         return this._context.requestContext.requestManager.getResponseData();
      }
      
      public function dispose() : void
      {
         setTimeout(this._context.dispose,0);
      }
      
      public function setEventCallbackKeyValue(param1:String, param2:String) : void
      {
         if(param2 == null)
         {
            this._context.requestContext.eventCallbackKeyValues.remove(param1);
         }
         else
         {
            this._context.requestContext.eventCallbackKeyValues.put(param1,param2);
         }
      }
      
      public function setLiveMode(param1:Boolean) : void
      {
         Logger.instance.warn("AdManager.setLiveMode(" + arguments.join(",") + ") DEPRECATED, use setRequestMode");
         this.setRequestMode(param1 ? Constants.instance.REQUEST_MODE_LIVE : Constants.instance.REQUEST_MODE_ON_DEMAND);
      }
      
      public function setVideoAsset(param1:String, param2:Number, param3:String = null, param4:Boolean = true, param5:Number = 0, param6:uint = 0, param7:uint = 0, param8:* = "", param9:String = null, param10:uint = 0) : void
      {
         this.setVideoAsset2(getFWId(param1,param7),getCustomId(param1,param7),param2,param3,param4,param5,param6,param8,param9,param10);
      }
      
      public function dispatchEvent(param1:Object) : void
      {
         var fwEvent:FWEvent;
         var i:String = null;
         var event:Object = param1;
         if(!event || !event.hasOwnProperty("type") || typeof event.type != "string" || SuperString.isNull(event.type))
         {
            Logger.instance.error("AdManager.dispatchEvent() event(" + event + ") is invalid or has no type property");
            return;
         }
         fwEvent = new FWEvent(event.type);
         for(i in event)
         {
            if(i != "type" && fwEvent.hasOwnProperty(i) && event[i] != null)
            {
               try
               {
                  fwEvent[i] = event[i];
               }
               catch(error:Error)
               {
                  Logger.instance.error("AdManager.dispatchEvent() property: " + i + ", convert error:" + error.message);
               }
            }
         }
         this._context.adManagerContext.dispatchEvent(fwEvent);
      }
      
      public function getVideoDisplay() : Sprite
      {
         return this._context.adManagerContext.playerEnvironment.temporalSlotBase;
      }
      
      public function setServer(param1:String = null) : void
      {
         if(!SuperString.isNull(param1))
         {
            this._context.adManagerContext.serverUrl = param1;
         }
      }
      
      public function debugInitialize(param1:Object) : void
      {
         if(param1.__magic_function_name == "reportGlobalError")
         {
            this.reportGlobalError(param1.errorCode,param1.msg);
            return;
         }
      }
      
      public function log(param1:String, param2:int) : void
      {
         Logger.instance.log(param2,param1);
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this._context.adManagerContext.addEventListener(param1,param2);
      }
      
      public function addVideoPlayerNonTemporalSlot(param1:String, param2:Sprite, param3:uint, param4:uint, param5:String = null, param6:int = 0, param7:int = 0, param8:Boolean = true, param9:String = null, param10:Object = null, param11:String = null, param12:String = null, param13:* = 0, param14:Array = null) : ISlot
      {
         if(SuperString.isNull(param1) || this._context.requestContext.hasSlotWithId(param1))
         {
            Logger.instance.error("AdManager.addTemporalSlot(): invalid or duplicated customId");
            return null;
         }
         var _loc15_:NonTemporalSlot;
         (_loc15_ = new NonTemporalSlot(this._context)).init(param5,param1,param2,param3,param4,param6,param7,param8,int(param13),param9,param10,param11,param12,param14);
         this._context.requestContext.playerNonTemporalSlots.push(_loc15_);
         return _loc15_;
      }
      
      public function submitRequest(param1:Number = 0, param2:Number = 0) : void
      {
         if(this._context.adManagerContext.getStatusManager().getIsVideoViewRequested())
         {
            this._context.adManagerContext.capabilities.setCapability(Constants.instance.CAPABILITY_REQUIRES_VIDEO_CALLBACK_URL,false);
            this._context.adManagerContext.capabilities.setCapability(Constants.instance.CAPABILITY_SKIP_AD_SELECTION,false);
         }
         else if((!SuperString.isNull(this._context.adManagerContext.va_id) || !SuperString.isNull(this._context.adManagerContext.va_customId)) && this._context.adManagerContext.networkId > 0)
         {
            this._context.adManagerContext.getStatusManager().setIsVideoViewRequested(true);
            this._context.adManagerContext.capabilities.setCapability(Constants.instance.CAPABILITY_REQUIRES_VIDEO_CALLBACK_URL,true);
         }
         if(URLTools.isSecureHTTP(this._context.adManagerContext.serverUrl))
         {
            this.setParameter("transformer.server.alternativeHost","https://m.feiwei.tv",Constants.instance.PARAMETER_OVERRIDE);
         }
         else
         {
            this.setParameter("transformer.server.alternativeHost","http://m2.feiwei.tv",Constants.instance.PARAMETER_OVERRIDE);
         }
         this._context.requestContext.requestManager.submitRequest(param1,param2);
         this._context.adManagerContext.isRequestSubmitted = true;
      }
      
      public function startSubsession(param1:uint) : void
      {
         this._context.adManagerContext.subsessionToken = param1;
         this.setCapability(Constants.instance.CAPABILITY_SYNC_MULTI_REQUESTS,true);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this._context.adManagerContext.removeEventListener(param1,param2);
      }
      
      public function setVideoPlayStatus(param1:uint) : void
      {
         var _loc4_:FWEvent = null;
         var _loc2_:uint = this.getVideoPlayStatus();
         var _loc3_:StatusManager = this._context.adManagerContext.getStatusManager();
         if(_loc3_)
         {
            _loc3_.setVideoPlayState(param1);
            _loc3_.init();
         }
         if(param1 == Constants.instance.VIDEO_STATUS_COMPLETED)
         {
            this._context.adManagerContext.resetStatusManager();
         }
         if(_loc2_ != this.getVideoPlayStatus())
         {
            (_loc4_ = new FWEvent(Constants.instance.EVENT_VIDEO_PLAY_STATUS_CHANGED)).videoPlayStatus = param1;
            this._context.adManagerContext.dispatchEvent(_loc4_);
         }
      }
      
      public function reportGlobalError(param1:Number, param2:String) : void
      {
         this._context.requestContext.reportGlobalError(param1,param2);
      }
      
      public function newAdManager() : AdManager
      {
         var _loc1_:AdManager = new AdManager(false);
         _loc1_._context.adManagerContext.copy(this._context.adManagerContext);
         return _loc1_;
      }
      
      public function getExtensionByName(param1:String) : Object
      {
         return this._context.adManagerContext.extensionManager.get(param1);
      }
      
      public function getSlotsByTimePositionClass(param1:String) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         param1 = param1.toUpperCase();
         var _loc2_:Array = new Array();
         if(param1 == Constants.instance.TIME_POSITION_CLASS_DISPLAY)
         {
            return this.getNonTemporalSlots();
         }
         _loc3_ = this._context.requestContext.temporalSlots;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1 == ISlot(_loc3_[_loc4_]).getTimePositionClass())
            {
               _loc2_.push(_loc3_[_loc4_]);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getVideoPlayheadTime() : Number
      {
         Logger.instance.warn("AdManager.getPlayheadTime()");
         return this._context.adManagerContext.getVideoPlayheadTime();
      }
      
      public function setParameter(param1:String, param2:String, param3:uint) : void
      {
         this.setParameterObject(param1,param2,param3);
      }
      
      public function setCustomDistributor(param1:String, param2:String, param3:String) : void
      {
         Logger.instance.warn("AdManager.setCustomDistributor is deprecated");
      }
      
      public function setVideoAssetCurrentTimePosition(param1:Number) : void
      {
         if(param1 < 0)
         {
            Logger.instance.warn("AdManager.setVideoAssetCurrentTimePosition: timePosition is negative, reset it to 0");
            param1 = 0;
         }
         this._context.adManagerContext.va_currentTimePosition = param1;
      }
      
      public function setVideoPlayer(param1:uint) : void
      {
         this._context.adManagerContext.vp_videoPlayerNetworkId = param1;
      }
      
      public function getSlotByCustomId(param1:String) : ISlot
      {
         return this._context.requestContext.findSlotById(param1);
      }
      
      public function setRequestDuration(param1:Number) : void
      {
         if(param1 < 0)
         {
            Logger.instance.warn("AdManager.setRequestDuration: requestDuration is negative, reset it to 0");
            param1 = 0;
         }
         this._context.adManagerContext.va_requestDuration = param1;
      }
      
      public function addRenderer(param1:String, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:Object = null, param7:String = null) : void
      {
         var _loc11_:Object = null;
         var _loc8_:String = "class:";
         param1 = SuperString.trim(param1);
         var _loc9_:String = null;
         if(param1.toLowerCase().indexOf(_loc8_) == 0)
         {
            _loc9_ = SuperString.trim(param1.substr(_loc8_.length));
            param1 = null;
         }
         var _loc10_:AdRenderer = this._context.adManagerContext.adRendererSet.addAdRenderer(param1,_loc9_,param2,param3,param4,param5,true,param7);
         for(_loc11_ in param6)
         {
            if(param6[_loc11_] != null)
            {
               _loc10_.addParameter(String(_loc11_),String(param6[_loc11_]));
            }
         }
      }
      
      public function finalizeRendererStateTransition(param1:Object) : void
      {
         Logger.instance.error("AdManager.finalizeRendererStateTransition(" + arguments.join(",") + "), deprecated");
      }
      
      public function setParameterObject(param1:String, param2:Object, param3:uint) : void
      {
         this._context.requestContext.setParameter(param1,param2,param3);
      }
      
      public function getVideoPlayerNonTemporalSlots() : Array
      {
         return this._context.requestContext.playerNonTemporalSlots.slice();
      }
      
      public function setNetwork(param1:uint) : void
      {
         if(this._context.adManagerContext.networkId <= 0)
         {
            this._context.adManagerContext.networkId = param1;
         }
      }
      
      public function addTemporalSlot(param1:String, param2:String, param3:Number, param4:String = null, param5:uint = 0, param6:Number = 0, param7:Object = null, param8:String = null, param9:String = null, param10:Number = 0, param11:uint = 0, param12:Sprite = null) : ISlot
      {
         if(param6 < 0)
         {
            param6 = 0;
         }
         if(param10 < 0)
         {
            param10 = 0;
         }
         if(SuperString.isNull(param1) || this._context.requestContext.hasSlotWithId(param1))
         {
            Logger.instance.error("AdManager.addTemporalSlot(): invalid or duplicated customId");
            return null;
         }
         var _loc13_:TemporalSlot;
         (_loc13_ = new TemporalSlot(this._context)).init(param4,param1,param3,param11,param6,param2,param7,param8,param9,param10,param12);
         this._context.requestContext.temporalSlots.push(_loc13_);
         return _loc13_;
      }
      
      public function getTemporalSlots() : Array
      {
         var _loc4_:ISlot = null;
         var _loc1_:Array = this._context.requestContext.temporalSlots;
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_.length)
         {
            if((_loc4_ = ISlot(_loc1_[_loc3_])).getTimePositionClass() != Constants.instance.TIME_POSITION_CLASS_PAUSE_MIDROLL)
            {
               _loc2_.push(_loc1_[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function loadResponseData(param1:String) : void
      {
         this._context.requestContext.isSlaveMode = true;
         this._context.requestContext.requestManager.parseResponse(param1);
      }
      
      public function getAdVolume() : uint
      {
         return this._context.adManagerContext.playerEnvironment.adVolume;
      }
      
      public function setVideoDisplayCompatibleSizes(param1:Array) : void
      {
         this._context.adManagerContext.setVideoDisplayCompatibleSizes(param1);
      }
      
      public function setAdVolume(param1:uint) : void
      {
         var _loc3_:AdInstance = null;
         var _loc2_:uint = param1;
         if(param1 > 100)
         {
            _loc2_ = 100;
         }
         else if(param1 < 0)
         {
            _loc2_ = 0;
         }
         this._context.adManagerContext.playerEnvironment.adVolume = _loc2_;
         for each(_loc3_ in this._context.requestContext.getActiveAdInstances())
         {
            _loc3_.setAdVolume();
         }
      }
      
      public function getConstants() : IConstants
      {
         return Constants.instance;
      }
      
      public function addCandidateAd(param1:uint) : void
      {
         if(param1 > 0 && this._context.requestContext.candidateAds.indexOf(param1) == -1)
         {
            this._context.requestContext.candidateAds.push(new CandidateAd(param1));
         }
      }
      
      public function getActiveSlots() : Array
      {
         var _loc2_:BaseSlot = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this._context.requestContext.getAllSlots())
         {
            if(_loc2_.isActive())
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function registerPlayheadTimeCallback(param1:Function) : void
      {
         this._context.adManagerContext.getPlayheadTimeCallback = param1;
      }
      
      public function setVisitor(param1:String, param2:String = null, param3:uint = 0, param4:String = null) : void
      {
         this._context.adManagerContext.visitor.init(param1,param2,param3,param4);
      }
      
      public function get context() : Contexts
      {
         return this._context;
      }
      
      public function setRendererConfiguration(param1:String, param2:String = null) : void
      {
         this._context.adManagerContext.adRendererSet.rendererPathPrefix = param2;
         if(SuperString.isNull(this._context.adManagerContext.rendererHandler.requestUrl))
         {
            if(!SuperString.isNull(param1))
            {
               if(!this._context.adManagerContext.isRequestSubmitted)
               {
                  this._context.adManagerContext.needResponseRenderers = false;
                  this._context.adManagerContext.rendererHandler.submit(param1);
               }
               else
               {
                  Logger.instance.warn("AdManager has been submitted, xmlUrl set will be ignored");
               }
            }
         }
         else
         {
            Logger.instance.warn("renderers xml had been requested, xmlUrl set will be ignored");
         }
      }
      
      public function addSiteSectionNonTemporalSlot(param1:String, param2:uint, param3:uint, param4:String = null, param5:Boolean = true, param6:* = 0, param7:String = null, param8:Object = null, param9:String = null, param10:String = null, param11:Sprite = null, param12:Array = null) : ISlot
      {
         if(SuperString.isNull(param1) || this._context.requestContext.hasSlotWithId(param1))
         {
            Logger.instance.error("AdManager.addTemporalSlot(): invalid or duplicated customId");
            return null;
         }
         var _loc13_:NonTemporalSlot;
         (_loc13_ = new NonTemporalSlot(this._context)).init(param4,param1,param11,param2,param3,0,0,param5,int(param6),param7,param8,param9,param10,param12);
         this._context.requestContext.pageNonTemporalSlots.push(_loc13_);
         return _loc13_;
      }
      
      public function getVersion() : uint
      {
         return getLibraryVersion();
      }
      
      public function registerRendererStateTransitionCallback(param1:uint, param2:Function) : void
      {
         Logger.instance.warn("AdManager.registerRendererStateTransitionCallback(" + arguments.join(",") + "), deprecated");
         if(param1 == Constants.instance.RENDERER_STATE_INITIALIZE_COMPLETE)
         {
            this._context.adManagerContext.rendererInitializedCallback = param2;
         }
      }
      
      public function setKeyValue(param1:String, param2:String) : void
      {
         if(param2 == null)
         {
            return;
         }
         this._context.requestContext.keyValues.put(param1,param2);
      }
      
      public function setSiteSection2(param1:String, param2:String, param3:Number = 0, param4:uint = 0, param5:* = "") : void
      {
         this._context.adManagerContext.ss_customId = param2;
         this._context.adManagerContext.ss_id = SuperString.trim(param1);
         this._context.adManagerContext.ss_pageViewRandom = param3;
         this._context.adManagerContext.ss_networkId = param4;
         if(typeof param5 === "number" && param5 > 0)
         {
            this._context.adManagerContext.ss_fallbackId = "" + param5;
         }
         else if(typeof param5 === "string")
         {
            this._context.adManagerContext.ss_fallbackId = SuperString.trim(param5);
         }
      }
      
      public function setVideoAsset2(param1:String, param2:String, param3:Number, param4:String = null, param5:Boolean = true, param6:Number = 0, param7:uint = 0, param8:* = "", param9:String = null, param10:uint = 0) : void
      {
         if(param3 < 0)
         {
            param3 = 0;
         }
         if(param2 != this._context.adManagerContext.va_customId || param1 != this._context.adManagerContext.va_id)
         {
            this._context.adManagerContext.resetStatusManager();
         }
         this._context.adManagerContext.va_customId = param2;
         this._context.adManagerContext.va_id = SuperString.trim(param1);
         this._context.adManagerContext.va_duration = param3;
         this._context.adManagerContext.va_durationType = param9;
         this._context.adManagerContext.va_videoAssetNetworkId = param7;
         this._context.adManagerContext.va_videoPlayRandom = param6;
         this._context.adManagerContext.va_autoPlay = param5;
         this._context.adManagerContext.va_autoPlayType = param10;
         if(typeof param8 === "number" && param8 > 0)
         {
            this._context.adManagerContext.va_fallbackId = "" + param8;
         }
         else if(typeof param8 === "string")
         {
            this._context.adManagerContext.va_fallbackId = SuperString.trim(param8);
         }
         this._context.adManagerContext.va_mediaLocation = SuperString.trim(param4);
         this._context.adManagerContext.startStatusManager();
      }
      
      public function getVideoDisplaySize() : Rectangle
      {
         var _loc1_:PlayerEnvironment = this._context.adManagerContext.playerEnvironment;
         return new Rectangle(_loc1_.videoPlaybackAreaX,_loc1_.videoPlaybackAreaY,_loc1_.videoPlaybackAreaWidth,_loc1_.videoPlaybackAreaHeight);
      }
      
      public function refresh() : void
      {
         this._context.refresh();
         this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_REFRESHED);
      }
      
      public function setSiteSection(param1:String, param2:Number = 0, param3:uint = 0, param4:uint = 0, param5:* = "") : void
      {
         this.setSiteSection2(getFWId(param1,param4),getCustomId(param1,param4),param2,param3,param5);
      }
      
      public function addSlotsByUrl(param1:String) : void
      {
         var _loc3_:GlobalParams = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:uint = 0;
         var _loc11_:SlotParams = null;
         var _loc12_:uint = 0;
         var _loc2_:TagGeneratorUrlInstance = TagGeneratorUrlInstance.instantiate(param1);
         if(_loc2_ == null)
         {
            Logger.instance.error("AdManager.addSlotsByUrl() -> Invalid url = " + param1);
            return;
         }
         if(_loc2_.globalParams)
         {
            _loc3_ = _loc2_.globalParams;
            if(!this._context.adManagerContext.networkId)
            {
               this._context.adManagerContext.networkId = _loc3_.networkId;
            }
            if(_loc3_.videoDefaultSlotProfile != null)
            {
               this._context.adManagerContext.defaultVideoPlayerSlotProfile = _loc3_.videoDefaultSlotProfile;
            }
            if(_loc3_.mode != null)
            {
               this.setRequestMode(_loc3_.mode.toUpperCase());
            }
            if(_loc3_.visitorCustomId != null)
            {
               this.setVisitor(_loc3_.visitorCustomId);
            }
            this.setSiteSection2(_loc3_.siteSectionId,_loc3_.customSiteSectionId,_loc3_.pageViewRandomNumber,_loc3_.siteSectionNetworkId,_loc3_.siteSectionFallbackId);
            _loc4_ = true;
            if(_loc3_.autoPlay == GlobalParams.FLAG_OFF)
            {
               _loc4_ = false;
            }
            _loc5_ = 0;
            if(_loc3_.autoPlayType == GlobalParams.FLAG_ON)
            {
               _loc5_ = 1;
            }
            this.setVideoAsset2(_loc3_.assetId,_loc3_.customAssetId,_loc3_.videoDuration,_loc3_.assetMediaLocation,_loc4_,_loc3_.videoPlayerRandomNumber,_loc3_.assetNetworkId,_loc3_.assetFallbackId,null,_loc5_);
            _loc6_ = 0;
            while(_loc6_ < _loc3_.candidateAds.length)
            {
               this.addCandidateAd(SuperString.convertToUint(_loc3_.candidateAds[_loc6_]));
               _loc6_++;
            }
            if(_loc3_.checkTargeting != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_CHECK_TARGETING,_loc3_.checkTargeting == GlobalParams.FLAG_ON);
            }
            if(_loc3_.checkCompanion != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_CHECK_COMPANION,_loc3_.checkCompanion == GlobalParams.FLAG_ON);
            }
            if(_loc3_.adUnitInMultiSlots != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_ADUNIT_IN_MULTIPLE_SLOTS,_loc3_.adUnitInMultiSlots == GlobalParams.FLAG_ON);
            }
            if(_loc3_.recordVideoView != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_RECORD_VIDEO_VIEW,_loc3_.recordVideoView == GlobalParams.FLAG_ON);
            }
            if(_loc3_.supportFallbackAds != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_FALLBACK_ADS,_loc3_.supportFallbackAds == GlobalParams.FLAG_ON);
            }
            if(_loc3_.syncMultiRequest != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_SYNC_MULTI_REQUESTS,_loc3_.syncMultiRequest == GlobalParams.FLAG_ON);
            }
            if(_loc3_.fallbackUnknownAsset != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_FALLBACK_UNKNOWN_ASSET,_loc3_.fallbackUnknownAsset == GlobalParams.FLAG_ON);
            }
            if(_loc3_.fallbackUnknownSiteSection != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_FALLBACK_UNKNOWN_SS,_loc3_.fallbackUnknownSiteSection == GlobalParams.FLAG_ON);
            }
            if(_loc3_.syncSiteSectionSlots != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_SYNC_SITESECTION_SLOTS,_loc3_.syncSiteSectionSlots == GlobalParams.FLAG_ON);
            }
            if(_loc3_.expectMultiCreativeRenditions != GlobalParams.FLAG_UNSET)
            {
               this.setCapability(Constants.instance.CAPABILITY_MULTIPLE_CREATIVE_RENDITIONS,_loc3_.expectMultiCreativeRenditions == GlobalParams.FLAG_ON);
            }
         }
         if(_loc2_.keyValues)
         {
            _loc7_ = _loc2_.keyValues.getList();
            _loc8_ = 0;
            while(_loc8_ < _loc7_.length)
            {
               _loc9_ = _loc7_[_loc8_];
               this.setKeyValue(_loc9_.key,_loc9_.value);
               _loc8_++;
            }
         }
         if(_loc2_.slots)
         {
            _loc10_ = 0;
            while(_loc10_ < _loc2_.slots.length)
            {
               _loc11_ = _loc2_.slots[_loc10_];
               _loc12_ = 0;
               while(_loc12_ < _loc11_.candidateAds.length)
               {
                  this.addCandidateAd(SuperString.convertToUint(_loc11_.candidateAds[_loc12_]));
                  _loc12_++;
               }
               if(_loc11_.ptgt == "a")
               {
                  if(!this._context.requestContext.hasSlotWithId(_loc11_.customId))
                  {
                     this.addTemporalSlot(_loc11_.customId,!!_loc11_.adUnit ? _loc11_.adUnit : _loc11_.timePositionClass,_loc11_.timePosition,_loc11_.slotProfile,0,_loc11_.maxDuration,null,null,null,0,_loc11_.cuePointSequence);
                  }
               }
               _loc10_++;
            }
         }
      }
      
      public function scanSlotsOnPage(param1:Number = 0, param2:Function = null, param3:Boolean = false, param4:String = null) : Array
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         return this._context.requestContext.requestManager.getExternalSlots(param1,param2,param3,param4);
      }
      
      public function setProfile(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         if(this._context.adManagerContext.playerProfile != param1 && SuperString.isNull(this._context.adManagerContext.rendererHandler.requestUrl))
         {
            this._context.adManagerContext.needResponseRenderers = true;
         }
         this._context.adManagerContext.playerProfile = param1;
         this._context.adManagerContext.defaultTemporalSlotProfile = SuperString.isNull(param2) ? param1 : param2;
         this._context.adManagerContext.defaultVideoPlayerSlotProfile = param3;
         this._context.adManagerContext.defaultSiteSectionSlotProfile = param4;
      }
      
      public function setVideoDisplaySize(param1:int, param2:int, param3:uint, param4:uint, param5:int, param6:int, param7:uint, param8:uint) : void
      {
         this._context.adManagerContext.playerEnvironment.resize(param1,param2,param3,param4,param5,param6,param7,param8);
         var _loc9_:Array = this._context.requestContext.temporalSlots;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc9_.length)
         {
            TemporalSlot(_loc9_[_loc10_]).resize();
            _loc10_++;
         }
      }
      
      public function getVideoPlayStatus() : uint
      {
         var _loc1_:StatusManager = this._context.adManagerContext.getStatusManager();
         if(_loc1_)
         {
            return _loc1_.playState;
         }
         return Constants.instance.VIDEO_STATUS_UNKNOWN;
      }
      
      public function getSiteSectionNonTemporalSlots() : Array
      {
         return this._context.requestContext.pageNonTemporalSlots.slice();
      }
      
      public function getNonTemporalSlots() : Array
      {
         return this._context.requestContext.getNonTemporalSlots();
      }
      
      public function loadExtension(param1:String, param2:*) : void
      {
         this._context.adManagerContext.extensionManager.load(param1,param2);
      }
      
      public function getParameter(param1:String, param2:uint = 0) : String
      {
         var _loc3_:Object = this.getParameterObject(param1,param2);
         if(_loc3_ == null)
         {
            return null;
         }
         return String(_loc3_);
      }
   }
}
