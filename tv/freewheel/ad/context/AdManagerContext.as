package tv.freewheel.ad.context
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.events.FWEvent;
   import tv.freewheel.ad.manager.AdManager;
   import tv.freewheel.ad.manager.ExtensionManager;
   import tv.freewheel.ad.manager.StatusManager;
   import tv.freewheel.ad.vo.adRenderer.AdRendererSet;
   import tv.freewheel.ad.vo.capabilities.Capabilities;
   import tv.freewheel.ad.vo.environment.PlayerEnvironment;
   import tv.freewheel.ad.vo.visitor.Visitor;
   import tv.freewheel.ad.xmlHandler.RenderersHandler;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.basic.SuperString;
   
   public class AdManagerContext
   {
      
      public static const AD_REQUEST_LOCATION:String = "/ad/p/1?";
       
      
      public var va_durationType:String = null;
      
      private var _subsessionToken:uint = 0;
      
      public var rendererHandler:RenderersHandler;
      
      public var adManager:AdManager;
      
      public var rendererLoadedCallback:Function = null;
      
      public var subsessionTokenSequence:uint = 0;
      
      public var va_mediaLocation:String;
      
      public var serverUrl:String;
      
      public var va_id:String;
      
      public var defaultTemporalSlotProfile:String = null;
      
      public var adManagerListeners:Array;
      
      public var ss_id:String;
      
      private var statusManager:StatusManager = null;
      
      public var ss_customId:String;
      
      public var va_videoPlayRandom:Number;
      
      public var visitor:Visitor;
      
      private var isDisposed:Boolean = false;
      
      public var va_autoPlayType:uint = 0;
      
      public var playerEnvironment:PlayerEnvironment;
      
      public var extensionManager:ExtensionManager;
      
      public var ss_pageViewRandom:Number;
      
      public var vp_videoPlayerNetworkId:uint;
      
      public var adRendererSet:AdRendererSet;
      
      public var rendererInitializedCallback:Function = null;
      
      public var va_customId:String;
      
      public var isRequestSubmitted:Boolean = false;
      
      public var playerProfile:String = null;
      
      public var rendererState:HashMap;
      
      public var va_autoPlay:Boolean = true;
      
      public var va_currentTimePosition:Number = 0;
      
      public var requireRendererManifest:Boolean = false;
      
      public var defaultVideoPlayerSlotProfile:String = null;
      
      public var va_videoAssetNetworkId:uint;
      
      public var va_duration:Number;
      
      public var va_requestDuration:Number = 0;
      
      public var va_fallbackId:String;
      
      public var capabilities:tv.freewheel.ad.vo.capabilities.Capabilities;
      
      public var compatibleDimensions:String;
      
      public var ss_networkId:uint;
      
      public var needResponseRenderers:Boolean = true;
      
      public var getPlayheadTimeCallback:Function = null;
      
      public var adRequestBase:String = "http://g1.v.fwmrm.net";
      
      private var eventDispatcher:EventDispatcher;
      
      public var networkId:uint = 0;
      
      public var requestMode:String = null;
      
      public var defaultSiteSectionSlotProfile:String = null;
      
      public var ss_fallbackId:String;
      
      public var selectedBundleId:String;
      
      public function AdManagerContext(param1:AdManager, param2:Contexts)
      {
         this.serverUrl = this.adRequestBase + AD_REQUEST_LOCATION;
         super();
         this.adManager = param1;
         this.adRendererSet = new AdRendererSet();
         this.rendererState = new HashMap();
         this.playerEnvironment = new PlayerEnvironment();
         this.rendererHandler = new RenderersHandler(param2);
         this.adManagerListeners = new Array();
         this.capabilities = new tv.freewheel.ad.vo.capabilities.Capabilities();
         this.visitor = new Visitor();
         var _loc3_:String = this.getContainingPageUrl();
         if(SuperString.isNull(_loc3_))
         {
            _loc3_ = AdManager.StageUrl;
         }
         this.visitor.setHttpHeader("Referer",_loc3_);
         this.visitor.setHttpHeader("x-flash-version",this.getFlashPlayerVersion());
         this.eventDispatcher = new EventDispatcher();
         this.statusManager = null;
         this.extensionManager = new ExtensionManager(param2);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.eventDispatcher.hasEventListener(param1);
      }
      
      public function startStatusManager() : void
      {
         if(this.statusManager)
         {
            if(this.statusManager.playState == Constants.instance.VIDEO_STATUS_PLAYING)
            {
               this.statusManager.init();
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc2_:Object = null;
         if(this.isDisposed)
         {
            return;
         }
         this.isDisposed = true;
         var _loc1_:uint = 0;
         while(_loc1_ < this.adManagerListeners.length)
         {
            _loc2_ = this.adManagerListeners[_loc1_];
            if(this.eventDispatcher.hasEventListener(_loc2_.type))
            {
               this.eventDispatcher.removeEventListener(_loc2_.type,_loc2_.listener,_loc2_.useCapture);
            }
            _loc1_++;
         }
         if(this.statusManager)
         {
            this.statusManager.dispose();
         }
         this.extensionManager.dispose();
         this.statusManager = null;
         this.rendererHandler.dispose();
         this.adRendererSet.dispose();
         this.getPlayheadTimeCallback = null;
         this.adManager = null;
         this.visitor = null;
      }
      
      public function broadcastCustomEvent(param1:String = null, param2:Object = null, param3:String = null, param4:int = 0) : void
      {
         this.dispatchEvent(new FWEvent(Constants.instance.EVENT_CUSTOM,param1,true,false,false,param2,0,0,"",null,"",false,false,param3,param4));
      }
      
      private function detectScreenDimension() : String
      {
         return flash.system.Capabilities.screenResolutionX + "," + flash.system.Capabilities.screenResolutionY;
      }
      
      private function getContainingPageUrl() : String
      {
         var containingPageUrl:String = "";
         var injectableJavaScript:XML = <script>
				<![CDATA[
				function(urlCallback) {
					function getLocationUrl() {
						var strLoc = String(document.location);
						return strLoc;
					}
					var strLocation = getLocationUrl(urlCallback);
					return strLocation;
				}
			]]>
				</script>;
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface["marshallExceptions"] = true;
               containingPageUrl = ExternalInterface.call(injectableJavaScript);
            }
            catch(e:Error)
            {
               return null;
            }
         }
         return containingPageUrl;
      }
      
      public function getCompatibleDimensions() : String
      {
         if(SuperString.isNull(this.compatibleDimensions))
         {
            return this.detectScreenDimension();
         }
         return this.compatibleDimensions;
      }
      
      public function get subsessionToken() : uint
      {
         return this._subsessionToken;
      }
      
      public function dispatchEvent(param1:Event) : void
      {
         this.eventDispatcher.dispatchEvent(param1);
      }
      
      public function resetStatusManager() : void
      {
         var _loc1_:Number = NaN;
         if(this.statusManager)
         {
            _loc1_ = this.statusManager.playState;
            this.statusManager.dispose();
            this.statusManager = null;
         }
         if(!this.statusManager)
         {
            this.statusManager = new StatusManager(this.adManager.context);
            if(!isNaN(_loc1_))
            {
               this.statusManager.playState = _loc1_;
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         this.eventDispatcher.addEventListener(param1,param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         this.eventDispatcher.removeEventListener(param1,param2);
      }
      
      public function broadcastRendererEvent(param1:String, param2:String, param3:int, param4:int, param5:String, param6:Object, param7:String = null, param8:int = 0, param9:String = "") : void
      {
         this.dispatchEvent(new FWEvent(Constants.instance.EVENT_RENDERER,param1,true,false,false,null,param8,0,param9,null,"",false,false,param2,param3,param4,param7,param5,param6));
      }
      
      public function broadcastEvent(param1:String, param2:String = null, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false, param6:String = null, param7:String = null, param8:Array = null) : void
      {
         this.dispatchEvent(new FWEvent(param1,param2,param3,param4,param5,null,0,0,param7,param8,param6));
      }
      
      public function getVideoPlayheadTime() : Number
      {
         var ret:Number = NaN;
         try
         {
            ret = this.getPlayheadTimeCallback();
         }
         catch(e:Error)
         {
            ret = -1;
         }
         return ret;
      }
      
      public function copy(param1:AdManagerContext) : void
      {
         this.adRequestBase = param1.adRequestBase;
         this.adRendererSet.copy(param1.adRendererSet);
         this.networkId = param1.networkId;
         this.serverUrl = param1.serverUrl;
         this.capabilities.copy(param1.capabilities);
         this.playerProfile = param1.playerProfile;
         this.defaultTemporalSlotProfile = param1.defaultTemporalSlotProfile;
         this.defaultVideoPlayerSlotProfile = param1.defaultVideoPlayerSlotProfile;
         this.defaultSiteSectionSlotProfile = param1.defaultSiteSectionSlotProfile;
         this.ss_customId = param1.ss_customId;
         this.ss_id = param1.ss_id;
         this.ss_pageViewRandom = param1.ss_pageViewRandom;
         this.ss_networkId = param1.ss_networkId;
         this.ss_fallbackId = param1.ss_fallbackId;
         this.vp_videoPlayerNetworkId = param1.vp_videoPlayerNetworkId;
         this.va_id = param1.va_id;
         this.va_customId = param1.va_customId;
         this.va_duration = param1.va_duration;
         this.va_durationType = param1.va_durationType;
         this.va_videoAssetNetworkId = param1.va_videoAssetNetworkId;
         this.va_videoPlayRandom = param1.va_videoPlayRandom;
         this.va_autoPlay = param1.va_autoPlay;
         this.va_autoPlayType = param1.va_autoPlayType;
         this.va_fallbackId = param1.va_fallbackId;
         this.va_mediaLocation = param1.va_mediaLocation;
         this.va_currentTimePosition = param1.va_currentTimePosition;
         this.va_requestDuration = param1.va_requestDuration;
         this.visitor.copy(param1.visitor);
      }
      
      public function set subsessionToken(param1:uint) : void
      {
         if(this._subsessionToken == param1)
         {
            return;
         }
         this._subsessionToken = param1;
         ++this.subsessionTokenSequence;
      }
      
      public function setVideoDisplayCompatibleSizes(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc2_:Array = [];
         var _loc3_:Object = {};
         if(param1 is Array)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if((Boolean(_loc5_ = param1[_loc4_])) && typeof _loc5_ == "object")
               {
                  _loc6_ = int(_loc5_["width"]);
                  _loc7_ = int(_loc5_["height"]);
                  if(_loc6_ > 0 && _loc7_ > 0)
                  {
                     _loc8_ = _loc6_ + "," + _loc7_;
                     if(_loc3_[_loc8_] == null)
                     {
                        _loc3_[_loc8_] = "";
                        _loc2_.push(_loc8_);
                     }
                  }
               }
               _loc4_++;
            }
         }
         if(_loc2_.length > 0)
         {
            this.compatibleDimensions = _loc2_.join("|");
         }
      }
      
      private function getFlashPlayerVersion() : String
      {
         var _loc1_:String = flash.system.Capabilities.version;
         var _loc2_:int = _loc1_.indexOf(" ");
         if(_loc2_ > 0)
         {
            _loc1_ = SuperString.trim(_loc1_.substring(_loc2_ + 1));
         }
         return _loc1_;
      }
      
      public function getStatusManager() : StatusManager
      {
         if(!this.statusManager)
         {
            this.statusManager = new StatusManager(this.adManager.context);
         }
         return this.statusManager;
      }
   }
}
