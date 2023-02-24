package tv.freewheel.ad.context
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.behavior.IEvent;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.callback.GlobalErrorEventCallback;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.manager.RequestManager;
   import tv.freewheel.ad.playback.AdChain;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.ad.Ad;
   import tv.freewheel.ad.vo.ad.CandidateAd;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.ad.vo.reference.AdReference;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.ad.vo.slot.NonTemporalSlot;
   import tv.freewheel.ad.vo.slot.TemporalSlot;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.basic.KeyValues;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.xml.XMLUtils;
   
   public class RequestContext
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.RequestContext");
      
      private static const PARAMETER_LEVELS:Array = [Constants.instance.PARAMETER_OVERRIDE,Constants.instance.PARAMETER_PROFILE,Constants.instance.PARAMETER_GLOBAL];
       
      
      public var externalSlotsInfo:Array;
      
      public var serverErrors:Array;
      
      public var isSlaveMode:Boolean = false;
      
      public var pageNonTemporalSlots:Array;
      
      public var requestManager:RequestManager;
      
      public var diagnostic:Array;
      
      public var eventCallbackKeyValues:HashMap;
      
      public var candidateAds:Array;
      
      public var ads:Array;
      
      public var temporalSlots:Array;
      
      public var submitRequestStartTime:int = 0;
      
      public var timeOutId:int = -1;
      
      public var eventCallbacks:Array;
      
      public var keyValues:KeyValues;
      
      private var parameters:HashMap;
      
      public var playerNonTemporalSlots:Array;
      
      private var isDisposed:Boolean = false;
      
      public var submitRequestEndTime:int = 0;
      
      private var _context:Contexts;
      
      public function RequestContext(param1:Contexts)
      {
         this.serverErrors = new Array();
         this.externalSlotsInfo = new Array();
         this.eventCallbacks = new Array();
         this.keyValues = new KeyValues();
         this.ads = new Array();
         this.candidateAds = new Array();
         this.diagnostic = new Array();
         this.temporalSlots = new Array();
         this.playerNonTemporalSlots = new Array();
         this.pageNonTemporalSlots = new Array();
         super();
         this._context = param1;
         this.eventCallbackKeyValues = new HashMap();
         this.requestManager = new RequestManager(param1);
         this.parameters = new HashMap();
         var _loc2_:int = 0;
         while(_loc2_ < PARAMETER_LEVELS.length)
         {
            this.parameters.put(String(PARAMETER_LEVELS[_loc2_]),new HashMap());
            _loc2_++;
         }
      }
      
      public function dispatchRequestInitiatedEvent() : void
      {
         this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_REQUEST_INITIATED,"",true,false,false,null,"",this.serverErrors);
      }
      
      public function getActiveAdInstances() : Array
      {
         return this.getAdInstances("isActive");
      }
      
      public function getAllSlots() : Array
      {
         return this.temporalSlots.concat(this.pageNonTemporalSlots).concat(this.playerNonTemporalSlots);
      }
      
      public function getShowingAdInstances() : Array
      {
         return this.getAdInstances("isShowing");
      }
      
      private function siteSectionXML() : XMLNode
      {
         var _loc2_:XMLNode = null;
         var _loc3_:NonTemporalSlot = null;
         var _loc1_:XMLNode = new XMLNode(1,InnerConstants.TAG_SITE_SECTION);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_CUSTOM_ID,this._context.adManagerContext.ss_customId,_loc1_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_SITE_SECTION_ID,this._context.adManagerContext.ss_id,_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_SITE_SECTION_PAGE_VIEW_RANDOM,this._context.adManagerContext.ss_pageViewRandom,_loc1_,true,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_SITE_SECTION_NET_WORK_ID,this._context.adManagerContext.ss_networkId,_loc1_,true);
         if(this._context.adManagerContext.ss_fallbackId != null && this._context.adManagerContext.ss_fallbackId.length > 0)
         {
            XMLUtils.addStringAttribute(InnerConstants.ATTR_SITE_SECTION_FALL_BACK_ID,this._context.adManagerContext.ss_fallbackId,_loc1_,true);
         }
         _loc1_.appendChild(this.videoPlayerXML());
         if(!this._context.adManagerContext.capabilities.getCapability(Constants.instance.CAPABILITY_SKIP_AD_SELECTION))
         {
            _loc2_ = new XMLNode(1,InnerConstants.TAG_AD_SLOTS);
            XMLUtils.addStringAttribute(InnerConstants.ATTR_AD_SLOTS_DEFAULT_PROFILE,this._context.adManagerContext.defaultSiteSectionSlotProfile,_loc2_,true);
            _loc1_.appendChild(_loc2_);
            for each(_loc3_ in this.pageNonTemporalSlots)
            {
               _loc2_.appendChild(_loc3_.toXML());
            }
         }
         return _loc1_;
      }
      
      private function getAutoLoadExtensions(param1:String) : HashMap
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:String = ",";
         var _loc3_:HashMap = new HashMap();
         var _loc4_:Object;
         if(_loc4_ = this.getParameter(param1))
         {
            _loc5_ = _loc4_.toString().split(_loc2_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc7_ = SuperString.trim(_loc5_[_loc6_]);
               if(!SuperString.isNull(_loc7_))
               {
                  _loc8_ = null;
                  if(_loc7_.lastIndexOf(".") > -1)
                  {
                     _loc8_ = _loc7_.substring(_loc7_.lastIndexOf("/") + 1,_loc7_.lastIndexOf("."));
                  }
                  if(!SuperString.isNull(_loc8_))
                  {
                     _loc3_.put(_loc8_,_loc7_);
                  }
               }
               _loc6_++;
            }
         }
         return _loc3_;
      }
      
      public function videoAssetXML() : XMLNode
      {
         var _loc2_:XMLNode = null;
         var _loc3_:TemporalSlot = null;
         var _loc1_:XMLNode = new XMLNode(1,InnerConstants.TAG_VIDEO_ASSET);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_CUSTOM_ID,this._context.adManagerContext.va_customId,_loc1_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_VIDEO_ASSET_ID,this._context.adManagerContext.va_id,_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_VIDEO_ASSET_DURATION,this._context.adManagerContext.va_duration,_loc1_,true);
         if(this._context.adManagerContext.va_durationType != null)
         {
            XMLUtils.addStringAttribute(InnerConstants.ATTR_VIDEO_ASSET_VIDEO_ASSET_DURATION_TYPE,this._context.adManagerContext.va_durationType,_loc1_,true);
         }
         if(this._context.adManagerContext.va_currentTimePosition > 0)
         {
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_VIDEO_ASSET_CURRENT_TIME_POSITION,this._context.adManagerContext.va_currentTimePosition,_loc1_,true);
         }
         if(this._context.adManagerContext.va_requestDuration > 0)
         {
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_VIDEO_ASSET_REQUEST_DURATION,this._context.adManagerContext.va_requestDuration,_loc1_,true);
         }
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_VIDEO_ASSET_NET_WORK_ID,this._context.adManagerContext.va_videoAssetNetworkId,_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_VIDEO_ASSET_VIDEO_PLAY_RANDOM,this._context.adManagerContext.va_videoPlayRandom,_loc1_,true,true);
         XMLUtils.addBooleanAttribute(InnerConstants.ATTR_VIDEO_ASSET_AUTO_PLAY,this._context.adManagerContext.va_autoPlay,_loc1_);
         if(this._context.adManagerContext.va_autoPlayType == Constants.instance.VIDEO_ASSET_AUTO_PLAY_TYPE_UNATTENDED)
         {
            XMLUtils.addBooleanAttribute(InnerConstants.ATTR_VIDEO_ASSET_UNATTENDED_PLAY,true,_loc1_);
         }
         if(this._context.adManagerContext.va_fallbackId != null && this._context.adManagerContext.va_fallbackId.length > 0)
         {
            XMLUtils.addStringAttribute(InnerConstants.ATTR_VIDEO_ASSET_FALL_BACK_ID,this._context.adManagerContext.va_fallbackId,_loc1_,true);
         }
         XMLUtils.addStringAttribute(InnerConstants.ATTR_VIDEO_ASSET_MEDIA_LOCATION,this._context.adManagerContext.va_mediaLocation,_loc1_,true);
         if(!this._context.adManagerContext.capabilities.getCapability(Constants.instance.CAPABILITY_SKIP_AD_SELECTION))
         {
            _loc2_ = new XMLNode(1,InnerConstants.TAG_AD_SLOTS);
            XMLUtils.addStringAttribute(InnerConstants.ATTR_AD_SLOTS_DEFAULT_PROFILE,this._context.adManagerContext.defaultTemporalSlotProfile,_loc2_,true);
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOTS_WIDTH,this._context.adManagerContext.playerEnvironment.temporalSlotWidth,_loc2_,true);
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOTS_HEIGHT,this._context.adManagerContext.playerEnvironment.temporalSlotHeight,_loc2_,true);
            XMLUtils.addStringAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_COMP_DIM,this._context.adManagerContext.getCompatibleDimensions(),_loc2_,true);
            _loc1_.appendChild(_loc2_);
            for each(_loc3_ in this.temporalSlots)
            {
               _loc2_.appendChild(_loc3_.toXML());
            }
         }
         return _loc1_;
      }
      
      public function toXML() : XMLDocument
      {
         var _loc6_:XMLNode = null;
         var _loc7_:CandidateAd = null;
         var _loc8_:Object = null;
         var _loc9_:XMLNode = null;
         var _loc1_:XMLDocument = new XMLDocument();
         var _loc2_:XMLNode = _loc1_.createElement(InnerConstants.TAG_AD_REQUEST);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_NET_WORK_ID,this._context.adManagerContext.networkId,_loc2_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_VERSION,InnerConstants.XML_REQUEST_VERSION,_loc2_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_PROFILE,this._context.adManagerContext.playerProfile,_loc2_,true);
         if(this._context.adManagerContext.requestMode == Constants.instance.REQUEST_MODE_LIVE || this._context.adManagerContext.requestMode == Constants.instance.REQUEST_MODE_ON_DEMAND)
         {
            XMLUtils.addStringAttribute(InnerConstants.ATTR_MODE,this._context.adManagerContext.requestMode,_loc2_,true);
         }
         if(this._context.adManagerContext.subsessionToken > 0)
         {
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_SUBSESSION_TOKEN,this._context.adManagerContext.subsessionToken,_loc2_,true);
         }
         _loc1_.appendChild(_loc2_);
         if(this.candidateAds.length > 0)
         {
            _loc6_ = new XMLNode(1,InnerConstants.TAG_CANDIDATE_ADS);
            this._context.adManagerContext.capabilities.candidateCapabilityToXML(_loc6_);
            for each(_loc7_ in this.candidateAds)
            {
               _loc6_.appendChild(_loc7_.toXML());
            }
            _loc2_.appendChild(_loc6_);
         }
         _loc2_.appendChild(this._context.adManagerContext.capabilities.toXML());
         _loc2_.appendChild(this._context.adManagerContext.visitor.toXML(this));
         var _loc3_:XMLNode = _loc1_.createElement(InnerConstants.TAG_KEY_VALUES);
         var _loc4_:Array = this.keyValues.getList();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc8_ = _loc4_[_loc5_];
            (_loc9_ = new XMLNode(1,InnerConstants.TAG_KEY_VALUE)).attributes[InnerConstants.TAG_KEY_VALUES_KEY] = _loc8_.key;
            _loc9_.attributes[InnerConstants.TAG_KEY_VALUES_VALUE] = _loc8_.value;
            _loc3_.appendChild(_loc9_);
            _loc5_++;
         }
         _loc2_.appendChild(_loc3_);
         _loc2_.appendChild(this.siteSectionXML());
         return _loc1_;
      }
      
      private function getNeedLoadedExtensions() : HashMap
      {
         var _loc4_:String = null;
         var _loc1_:HashMap = new HashMap();
         _loc1_.merge(this.getAutoLoadExtensions("autoloadExtensionsInternal"));
         _loc1_.merge(this.getAutoLoadExtensions("autoloadExtensions"));
         var _loc2_:Array = _loc1_.getKeys();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = String(_loc2_[_loc3_]);
            if(this._context.adManagerContext.extensionManager.get(_loc4_))
            {
               _loc1_.remove(_loc4_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         var _loc1_:BaseSlot = null;
         if(!this.isDisposed)
         {
            this.isDisposed = true;
            clearTimeout(this.timeOutId);
            for each(_loc1_ in this.getAllSlots())
            {
               _loc1_.stop(true);
            }
            this.requestManager.dispose();
            this.parameters = null;
            this.serverErrors = null;
            return;
         }
      }
      
      private function dispatchRequestCompleteEvent(param1:Boolean, param2:String) : void
      {
         if(!this.isDisposed)
         {
            this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_REQUEST_COMPLETE,"",param1,false,false,null,param2,this.serverErrors);
         }
      }
      
      public function findAdById(param1:uint) : Ad
      {
         var _loc2_:Ad = null;
         for each(_loc2_ in this.ads)
         {
            if(uint(_loc2_.id) == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function restorePageSlots() : void
      {
         var _loc3_:BaseSlot = null;
         var _loc4_:Number = NaN;
         var _loc5_:BaseSlot = null;
         var _loc1_:Array = [];
         var _loc2_:Number = 0;
         while(_loc2_ < this.playerNonTemporalSlots.length)
         {
            _loc4_ = 0;
            while(_loc4_ < this.externalSlotsInfo.length)
            {
               if((_loc5_ = this.playerNonTemporalSlots[_loc2_]).customId == this.externalSlotsInfo[_loc4_].customId)
               {
                  _loc1_.push(_loc5_);
               }
               _loc4_++;
            }
            _loc2_++;
         }
         for each(_loc3_ in _loc1_)
         {
            this.playerNonTemporalSlots.splice(this.playerNonTemporalSlots.indexOf(_loc3_),1);
            this.pageNonTemporalSlots.push(_loc3_);
         }
      }
      
      private function videoPlayerXML() : XMLNode
      {
         var _loc2_:XMLNode = null;
         var _loc3_:NonTemporalSlot = null;
         var _loc1_:XMLNode = new XMLNode(1,InnerConstants.TAG_VIDEO_PLAYER);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_VIDEO_PLAYER_NET_WORK_ID,this._context.adManagerContext.vp_videoPlayerNetworkId,_loc1_,true);
         _loc1_.appendChild(this.videoAssetXML());
         if(!this._context.adManagerContext.capabilities.getCapability(Constants.instance.CAPABILITY_SKIP_AD_SELECTION))
         {
            _loc2_ = new XMLNode(1,InnerConstants.TAG_AD_SLOTS);
            XMLUtils.addStringAttribute(InnerConstants.ATTR_AD_SLOTS_DEFAULT_PROFILE,this._context.adManagerContext.defaultVideoPlayerSlotProfile,_loc2_,true);
            _loc1_.appendChild(_loc2_);
            for each(_loc3_ in this.playerNonTemporalSlots)
            {
               _loc2_.appendChild(_loc3_.toXML());
            }
         }
         return _loc1_;
      }
      
      public function findSlotById(param1:String, param2:String = null) : BaseSlot
      {
         var _loc4_:Array = null;
         var _loc5_:BaseSlot = null;
         if(!param1)
         {
            return null;
         }
         var _loc3_:Array = [];
         if(param2 == null)
         {
            _loc3_ = [this.temporalSlots,this.pageNonTemporalSlots,this.playerNonTemporalSlots];
         }
         else if(param2 == Constants.instance.SLOT_TYPE_TEMPORAL)
         {
            _loc3_ = [this.temporalSlots];
         }
         else if(param2 == Constants.instance.SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL)
         {
            _loc3_ = [this.playerNonTemporalSlots];
         }
         else if(param2 == Constants.instance.SLOT_TYPE_SITESECTION_NONTEMPORAL)
         {
            _loc3_ = [this.pageNonTemporalSlots];
         }
         for each(_loc4_ in _loc3_)
         {
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.customId == param1)
               {
                  return _loc5_;
               }
            }
         }
         return null;
      }
      
      public function reportGlobalError(param1:Number, param2:String) : void
      {
         var _loc3_:HashMap = new HashMap();
         if(param2)
         {
            _loc3_.put("additional",param2);
         }
         var _loc4_:GlobalErrorEventCallback;
         if(_loc4_ = GlobalErrorEventCallback.construct(this.eventCallbacks,EventCallback.getErrorNameByCode(param1),_loc3_,this._context))
         {
            _loc4_.process();
         }
         else
         {
            logger.error("reportGlobalError: can\'t find global error callback, won\'t send");
         }
      }
      
      public function hasSlotWithId(param1:String) : Boolean
      {
         var _loc2_:ISlot = this.findSlotById(param1);
         return !!_loc2_ ? true : false;
      }
      
      public function getNonTemporalSlots() : Array
      {
         return this.pageNonTemporalSlots.concat(this.playerNonTemporalSlots);
      }
      
      public function buildAdChains() : void
      {
         var _loc1_:BaseSlot = null;
         var _loc2_:AdReference = null;
         for each(_loc1_ in this.getAllSlots())
         {
            _loc1_.adChains.splice(0);
            for each(_loc2_ in _loc1_.adReferences)
            {
               _loc1_.addAdChain(new AdChain(_loc2_));
            }
         }
      }
      
      private function getAdInstances(param1:String) : Array
      {
         var _loc3_:BaseSlot = null;
         var _loc4_:AdInstance = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.getAllSlots())
         {
            if(_loc3_[param1]())
            {
               for each(_loc4_ in _loc3_.getAdInstancesInPlayPlan(false))
               {
                  if(_loc4_[param1]())
                  {
                     _loc2_.push(_loc4_);
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function handleRequestCompleteEvent(param1:Boolean, param2:String) : void
      {
         var onExtensionsLoadTimeout:Function;
         var clear:Function;
         var i:int;
         var obj:Object;
         var autoloadExtensionNames:Array;
         var autoloadExtensions:HashMap = null;
         var owner:RequestContext = null;
         var extensionsLoadTimeoutId:int = 0;
         var onExtensionLoaded:Function = null;
         var str:String = null;
         var leftTimeout:int = 0;
         var extensionName:String = null;
         var succeeded:Boolean = param1;
         var message:String = param2;
         if(!succeeded)
         {
            this.dispatchRequestCompleteEvent(succeeded,message);
            return;
         }
         obj = this.getParameter("requireRendererManifest");
         if(obj)
         {
            str = SuperString.trim(String(obj));
            if(str != null)
            {
               str = str.toLowerCase();
               if(str == "true" || str == "on" || str == "yes")
               {
                  this._context.adManagerContext.requireRendererManifest = true;
               }
               else if(str == "false" || str == "off" || str == "no")
               {
                  this._context.adManagerContext.requireRendererManifest = false;
               }
            }
         }
         if(this._context.adManagerContext.requireRendererManifest)
         {
            this._context.adManagerContext.needResponseRenderers = true;
         }
         autoloadExtensions = this.getNeedLoadedExtensions();
         autoloadExtensionNames = autoloadExtensions.getKeys();
         if(autoloadExtensionNames.length == 0)
         {
            this.dispatchRequestCompleteEvent(succeeded,message);
            return;
         }
         owner = this;
         extensionsLoadTimeoutId = -1;
         onExtensionLoaded = function(param1:IEvent):void
         {
            autoloadExtensions.remove(param1.moduleName);
            if(autoloadExtensions.getKeys().length == 0)
            {
               clear();
               owner.dispatchRequestCompleteEvent(succeeded,message);
            }
         };
         onExtensionsLoadTimeout = function():void
         {
            clear();
            owner.dispatchRequestCompleteEvent(succeeded,message);
         };
         clear = function():void
         {
            if(extensionsLoadTimeoutId > -1)
            {
               clearTimeout(extensionsLoadTimeoutId);
            }
            owner._context.adManagerContext.removeEventListener(Constants.instance.EVENT_EXTENSION_LOADED,onExtensionLoaded);
            autoloadExtensions = null;
         };
         this._context.adManagerContext.addEventListener(Constants.instance.EVENT_EXTENSION_LOADED,onExtensionLoaded);
         if(this.requestManager.submitRequestTimeoutSeconds > 0)
         {
            leftTimeout = this.requestManager.submitRequestTimeoutSeconds * 1000 - (this.submitRequestEndTime - this.submitRequestStartTime);
            if(leftTimeout > 0)
            {
               extensionsLoadTimeoutId = int(setTimeout(onExtensionsLoadTimeout,leftTimeout));
            }
            else
            {
               onExtensionsLoadTimeout();
            }
         }
         i = 0;
         while(i < autoloadExtensionNames.length)
         {
            extensionName = String(autoloadExtensionNames[i]);
            this._context.adManagerContext.extensionManager.load(extensionName,autoloadExtensions.get(extensionName));
            i++;
         }
      }
      
      public function getParameter(param1:String, param2:uint = 0) : Object
      {
         var _loc3_:uint = 0;
         var _loc4_:HashMap = null;
         var _loc5_:Object = null;
         var _loc6_:HashMap = null;
         if(param2 == Constants.instance.PARAMETER_DEFAULT)
         {
            _loc3_ = 0;
            while(_loc3_ < PARAMETER_LEVELS.length)
            {
               if((_loc5_ = (_loc4_ = this.parameters.get(String(PARAMETER_LEVELS[_loc3_]))).get(param1)) != null)
               {
                  return _loc5_;
               }
               _loc3_++;
            }
         }
         else if(_loc6_ = this.parameters.get(param2.toString()))
         {
            return _loc6_.get(param1);
         }
         return null;
      }
      
      public function setParameter(param1:String, param2:Object, param3:uint) : void
      {
         var _loc4_:HashMap;
         if(_loc4_ = this.parameters.get(param3.toString()))
         {
            if(param2 == null)
            {
               _loc4_.remove(param1);
            }
            else
            {
               _loc4_.put(param1,param2);
            }
         }
         else
         {
            logger.warn("unknown parameter level");
         }
      }
      
      public function getParameters(param1:uint) : Array
      {
         var _loc2_:HashMap = this.parameters.get(param1.toString());
         return !!_loc2_ ? _loc2_.toArray() : new Array();
      }
      
      public function notifyRequestCompleteEvent(param1:Boolean = false, param2:String = null) : void
      {
         var _loc3_:Boolean = this._context.adManagerContext.adRendererSet.getSucceeded() && this.requestManager.getSucceeded();
         var _loc4_:Boolean = false;
         if(this._context.adManagerContext.adRendererSet.getCompleted() && this.requestManager.getCompleted())
         {
            _loc4_ = true;
         }
         var _loc5_:* = param2;
         if(param1)
         {
            _loc4_ = true;
            if(!this._context.adManagerContext.adRendererSet.getCompleted())
            {
               _loc5_ += " renderer request timeout ";
            }
            if(!this.requestManager.getCompleted())
            {
               _loc5_ += " response request timeout ";
            }
            this._context.adManagerContext.rendererHandler.clearLoader();
            this.requestManager.clearLoader();
         }
         if(_loc4_)
         {
            if(this.timeOutId >= 0)
            {
               clearTimeout(this.timeOutId);
            }
            this.handleRequestCompleteEvent(_loc3_,_loc5_);
         }
      }
   }
}
