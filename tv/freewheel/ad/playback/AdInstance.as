package tv.freewheel.ad.playback
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import tv.freewheel.ad.behavior.IAdInstance;
   import tv.freewheel.ad.behavior.ICreativeRendition;
   import tv.freewheel.ad.behavior.IRenderer;
   import tv.freewheel.ad.behavior.IRendererController;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.callback.AdErrorEventCallback;
   import tv.freewheel.ad.callback.AdEventCallback;
   import tv.freewheel.ad.callback.BasicEventCallback;
   import tv.freewheel.ad.callback.ClickEventCallback;
   import tv.freewheel.ad.callback.CustomEventCallback;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.manager.CallbackManager;
   import tv.freewheel.ad.manager.MetricManager;
   import tv.freewheel.ad.renderer.RendererContext;
   import tv.freewheel.ad.renderer.RendererLoader;
   import tv.freewheel.ad.vo.ad.Ad;
   import tv.freewheel.ad.vo.adRenderer.AdRenderer;
   import tv.freewheel.ad.vo.creative.Creative;
   import tv.freewheel.ad.vo.creative.CreativeRendition;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.ad.vo.reference.AdReference;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.ad.vo.slot.NonTemporalSlot;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.stateMachine.StateMachine;
   import tv.freewheel.utils.stateMachine.StateMachineEvent;
   import tv.freewheel.utils.url.URLTools;
   
   public class AdInstance implements IAdInstance
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.AdInstance");
       
      
      protected var isExpanded:Boolean;
      
      protected var latestAccurateTotalDuration:Number = -1;
      
      protected var _renderer:IRenderer = null;
      
      public var scheduledDrivingAd:Boolean = false;
      
      protected var _chainBehavior:ChainBehavior = null;
      
      protected var _imprSent:Boolean = false;
      
      private var _isStartedSuccessfully:Boolean = false;
      
      private var immediateStop:Boolean = false;
      
      protected var cloneGeneration:int = 0;
      
      protected var sm:StateMachine;
      
      public var adChain:AdChain = null;
      
      protected var isMuted:Boolean;
      
      private var rendererContext:RendererContext = null;
      
      public var adRef:AdReference;
      
      protected var _additionalCallbackKeyValues:HashMap;
      
      protected var _rendererEntry:AdRenderer = null;
      
      public var _context:Contexts;
      
      protected var latestAccurateTotalBytes:int = -1;
      
      public var isCompanionAdOfPauseAd:Boolean = false;
      
      private var primaryCreativeRendition:CreativeRendition = null;
      
      protected var callbackManager:CallbackManager;
      
      protected var rendererLoader:RendererLoader = null;
      
      public var translationHelper:TranslationHelper;
      
      protected var _slot:BaseSlot;
      
      protected var metricManager:MetricManager;
      
      public var companionAdInstances:Array;
      
      public var isFirstAdInPod:Boolean = false;
      
      protected var baseSprite:Sprite;
      
      public function AdInstance(param1:AdReference)
      {
         var _loc2_:AdReference = null;
         this.companionAdInstances = new Array();
         this._additionalCallbackKeyValues = new HashMap();
         super();
         this.adRef = param1;
         this._context = param1.context;
         this.translationHelper = new TranslationHelper(this);
         for each(_loc2_ in param1.companionAdRefs)
         {
            this.companionAdInstances.push(new AdInstance(_loc2_));
         }
         this.initStateMachine();
      }
      
      public function stop(param1:Boolean = false) : void
      {
         this.immediateStop = param1;
         this.sm.tryChangeStateTo(AdState.STOPPING);
      }
      
      public function cleanUpTranslator() : void
      {
         if(this.state == AdState.LOADING)
         {
            this.callRendererMethod("start",false);
         }
         this.stop();
      }
      
      public function preload() : void
      {
         this._chainBehavior = ChainBehavior.getPreloadBehavior();
         this.sm.tryChangeStateTo(AdState.LOADING);
      }
      
      public function isPaddingAd() : Boolean
      {
         return this.ad.hasPaddingCreative() && this.slot.getAllAdInstances().pop() == this;
      }
      
      public function getCreativeParameter(param1:String) : String
      {
         if(this.adRef.creative)
         {
            return this.adRef.creative.getParameter(param1);
         }
         return null;
      }
      
      private function sendResellerNoAdErrorCallback(param1:int, param2:String = null) : void
      {
         var _loc4_:AdErrorEventCallback = null;
         var _loc3_:Boolean = [Constants.instance.ERROR_NO_AD_AVAILABLE,Constants.instance.ERROR_PARSE_ERROR].indexOf(param1) > -1 || Constants.instance.ERROR_UNKNOWN && this.rendererEntry && this.rendererEntry.url && (this.rendererEntry.url.indexOf("GoogleAFVAdRenderer.swf") > -1 || this.rendererEntry.url.indexOf("DFPInstreamAdRenderer.swf") > -1);
         if(_loc3_)
         {
            logger.error(this + ".sendResellerNoAdErrorCallback, send resellerNoAd impression");
            if((_loc4_ = this.getCallbackManager().getAdEventCallback(Constants.instance.RENDERER_EVENT_ERROR,Constants.instance.EVENTCALLBACK_RESELLER_NO_AD,Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION) as AdErrorEventCallback) != null)
            {
               _loc4_.errorMessage = param2;
               _loc4_.process();
            }
         }
      }
      
      public function get adReplicaId() : String
      {
         return this.adRef.replicaId;
      }
      
      public function getParameterObject(param1:String, param2:uint = 0) : Object
      {
         var _loc5_:CreativeRendition = null;
         var _loc3_:* = param2 == Constants.instance.PARAMETER_DEFAULT;
         var _loc4_:Object = null;
         if(_loc3_ || param2 == Constants.instance.PARAMETER_OVERRIDE)
         {
            _loc4_ = this._context.requestContext.getParameter(param1,Constants.instance.PARAMETER_OVERRIDE);
         }
         if(_loc4_ == null && (_loc3_ || param2 == Constants.instance.PARAMETER_CREATIVERENDITION))
         {
            if(_loc5_ = CreativeRendition(this.getPrimaryCreativeRendition()))
            {
               _loc4_ = _loc5_.getParameter(param1);
            }
         }
         if(_loc4_ == null && (_loc3_ || param2 == Constants.instance.PARAMETER_CREATIVE))
         {
            _loc4_ = this.getCreativeParameter(param1);
         }
         if(_loc4_ == null && (_loc3_ || param2 == Constants.instance.PARAMETER_SLOT))
         {
            _loc4_ = Parameter.getParameterFromArray(this.slot.parameters,param1);
         }
         if(_loc4_ == null && (_loc3_ || param2 == Constants.instance.PARAMETER_PROFILE))
         {
            _loc4_ = this._context.requestContext.getParameter(param1,Constants.instance.PARAMETER_PROFILE);
         }
         if(_loc4_ == null && (_loc3_ || param2 == Constants.instance.PARAMETER_GLOBAL))
         {
            _loc4_ = this._context.requestContext.getParameter(param1,Constants.instance.PARAMETER_GLOBAL);
         }
         if(_loc4_ == null && (_loc3_ || param2 == Constants.instance.PARAMETER_RENDERER) && Boolean(this.rendererEntry))
         {
            _loc4_ = this.rendererEntry.getParameter(param1);
         }
         return _loc4_;
      }
      
      public function getAdId() : int
      {
         return int(this.adRef.id);
      }
      
      protected function initRenderer() : void
      {
         this.callRendererMethod("init",true,[this.getRendererController(),this.getRendererController()]);
      }
      
      public function getPrimaryCreativeRendition() : ICreativeRendition
      {
         var _loc1_:CreativeRendition = null;
         if(this.primaryCreativeRendition)
         {
            _loc1_ = this.primaryCreativeRendition;
         }
         else
         {
            _loc1_ = this.getAllCreativeRenditions()[0];
         }
         return _loc1_;
      }
      
      public function getBytesLoaded(param1:Boolean = false) : int
      {
         return this.getProgressiveInfoFromRenderer("getBytesLoaded",this.getTotalBytes(param1));
      }
      
      public function get id() : String
      {
         return this.adRef.id + "(" + this.cloneGeneration + ")";
      }
      
      public function get ad() : Ad
      {
         return this.adRef.ad;
      }
      
      protected function onStoppingEnter(param1:StateMachineEvent) : void
      {
         if(Boolean(this.renderer) && (param1.fromState == AdState.LOADING || param1.fromState == AdState.LOADED || param1.fromState == AdState.STARTING || param1.fromState == AdState.STARTED || param1.fromState == AdState.PAUSED))
         {
            this.callRendererMethod("stop",true,[this.immediateStop]);
            if(this.slot.getTimePositionClass() == Constants.instance.TIME_POSITION_CLASS_DISPLAY && this.state == AdState.STOPPING)
            {
               this.handleRendererEvent(Constants.instance.RENDERER_STATE_STOP_COMPLETE);
            }
         }
         else
         {
            this.sm.tryChangeStateTo(AdState.STOPPED);
         }
      }
      
      public function getMetricManager() : MetricManager
      {
         if(!this.metricManager)
         {
            this.metricManager = new MetricManager(this);
         }
         return this.metricManager;
      }
      
      public function setPrimaryCreativeRendition(param1:CreativeRendition) : void
      {
         if(this.getAllCreativeRenditions().indexOf(param1) > -1)
         {
            this.primaryCreativeRendition = param1;
         }
         else
         {
            logger.warn(this + ".setPrimaryCreativeRendition(" + param1 + "), fail because it\'s not in creative " + this.creative);
         }
      }
      
      public function isBumper() : Boolean
      {
         return !!this.ad ? this.ad.isBumper() : false;
      }
      
      public function setEventCallbackKeyValue(param1:String, param2:String) : void
      {
         this.additionalCallbackKeyValues.put(param1,param2);
      }
      
      public function get additionalCallbackKeyValues() : HashMap
      {
         return this._additionalCallbackKeyValues;
      }
      
      public function playCompanion(param1:AdInstance) : void
      {
         if(this.slot.isPauseSlot())
         {
            param1.isCompanionAdOfPauseAd = true;
         }
         var _loc2_:NonTemporalSlot = this._context.requestContext.findSlotById(param1.adRef.slotCustomId) as NonTemporalSlot;
         if(_loc2_)
         {
            _loc2_.playCompanionAdInstance(param1);
         }
         else
         {
            logger.error(this + " can\'t find slot " + param1.adRef.slotCustomId + " for companion ad " + param1);
         }
      }
      
      public function isShowing() : Boolean
      {
         return this.sm.state == AdState.STARTED || this.sm.state == AdState.PAUSED;
      }
      
      protected function onFailedEnter(param1:StateMachineEvent) : void
      {
         var _loc2_:AdInstance = null;
         if(this.isFirstAdInPod)
         {
            for each(_loc2_ in this.slot.getAllAdInstances())
            {
               if(_loc2_.id == this.id && _loc2_.adRef.replicaId == this.adRef.replicaId && _loc2_.cloneGeneration > 0 && _loc2_ != this)
               {
                  _loc2_._chainBehavior = null;
                  _loc2_.sm.tryChangeStateTo(AdState.FAILED);
               }
            }
         }
         this.cleanUp();
      }
      
      public function isStartedSuccessfully() : Boolean
      {
         return this._isStartedSuccessfully;
      }
      
      protected function getInfoFromRendererOrRendition(param1:String, param2:String, param3:Boolean) : Number
      {
         var _loc6_:ICreativeRendition = null;
         var _loc4_:Number = -1;
         var _loc5_:Number = -1;
         if(this.renderer)
         {
            _loc5_ = this.callRendererMethod(param1,false);
         }
         if(_loc5_ >= 0)
         {
            _loc4_ = this[param2] = _loc5_;
         }
         else if(this[param2] >= 0)
         {
            _loc4_ = Number(this[param2]);
         }
         if(param3 && _loc4_ < 0)
         {
            if(_loc6_ = this.getPrimaryCreativeRendition())
            {
               _loc4_ = Number(_loc6_[param1]());
            }
         }
         return _loc4_;
      }
      
      public function get chainBehavior() : ChainBehavior
      {
         return this._chainBehavior;
      }
      
      public function play() : void
      {
         this._chainBehavior = ChainBehavior.getPlayBehavior();
         this.sm.tryChangeStateToInOrder([AdState.LOADING,AdState.STARTING,AdState.STARTED]);
      }
      
      public function setEventCallbackURLs(param1:String, param2:String, param3:Array) : void
      {
         if(!this.adRef || !param3 || param3.length < 1)
         {
            logger.error(this + ".setEventCallbackURLs(), urls is empty or reference is null ");
            return;
         }
         var _loc4_:Object;
         if((_loc4_ = CallbackManager.getEventCallbackInfo(param1,param2)) == null)
         {
            logger.error(this + ".setEventCallbackURLs(), invalid combination of eventName and eventType");
            return;
         }
         param2 = String(_loc4_.eventType);
         if(param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICK)
         {
            this.updateOrCreateClickWithCR(param1,param2,param3[0]);
         }
         else
         {
            this.getCallbackManager().appendURLs(param1,param2,param3);
         }
      }
      
      public function playCompanions() : void
      {
         var _loc1_:AdInstance = null;
         for each(_loc1_ in this.companionAdInstances)
         {
            this.playCompanion(_loc1_);
         }
      }
      
      public function getBase() : Sprite
      {
         if(!this.baseSprite && Boolean(this.slot.getBase()))
         {
            this.baseSprite = new Sprite();
            if(this.slot.getTimePositionClass() == Constants.instance.TIME_POSITION_CLASS_OVERLAY)
            {
               this.slot.getBase().addChild(this.baseSprite);
            }
            else
            {
               this.slot.getBase().addChildAt(this.baseSprite,0);
            }
         }
         return this.baseSprite;
      }
      
      protected function onTransitionDenied(param1:StateMachineEvent) : void
      {
         logger.error(this + " onTransitionDenied from " + param1.fromState + " to " + param1.toState);
      }
      
      public function getTotalDuration(param1:Boolean = false) : Number
      {
         return this.getInfoFromRendererOrRendition("getDuration","latestAccurateTotalDuration",param1);
      }
      
      protected function onRendererLoadFailed(param1:Event) : void
      {
         this.rendererLoader.removeEventListener(RendererLoader.LOAD_COMPLETE,this.onRendererLoaded,false);
         this.rendererLoader.removeEventListener(RendererLoader.LOAD_ERROR,this.onRendererLoadFailed,false);
         this.failWithError(InnerConstants.ERROR_RENDERER_LOAD,this.rendererLoader.errorMessage);
      }
      
      public function handleRendererEvent(param1:uint, param2:Object = null) : void
      {
         var stateEvent:uint = param1;
         var details:Object = param2;
         var rendererStateEventMap:Object = {
            101:"INIT_COMPLETE",
            103:"PRELOAD_COMPLETE",
            105:"PLAYING",
            107:"STOP_COMPLETE",
            108:"FAIL"
         };
         switch(stateEvent)
         {
            case Constants.instance.RENDERER_STATE_INITIALIZE_COMPLETE:
            case Constants.instance.TRANSLATOR_STATE_INITIALIZE_COMPLETE:
               this.isExpanded = this.calculateExpanded();
               this.isMuted = this._context.adManagerContext.playerEnvironment.adVolume <= 2;
               if(this._context.adManagerContext.rendererInitializedCallback != null)
               {
                  try
                  {
                     this._context.adManagerContext.rendererInitializedCallback(stateEvent,this);
                  }
                  catch(e:Error)
                  {
                     logger.error("Caught error when calling external registered renderer initialized callback " + e);
                  }
               }
               if(Boolean(this.ad) && this.ad.noPreload)
               {
                  this.sm.tryChangeStateTo(this.chainBehavior.nextStateOnRendererPreloadComplete());
               }
               else
               {
                  this.callRendererMethod("preload",true);
               }
               break;
            case Constants.instance.RENDERER_STATE_PRELOAD_COMPLETE:
            case Constants.instance.TRANSLATOR_STATE_PRELOAD_COMPLETE:
               if(this.translationHelper.autoCommitClonedAds(stateEvent))
               {
                  this.sm.tryChangeStateTo(this.chainBehavior.nextStateOnRendererPreloadComplete());
               }
               break;
            case Constants.instance.RENDERER_STATE_PLAYING:
            case Constants.instance.TRANSLATOR_STATE_TRANSLATING:
               this.sm.tryChangeStateTo(AdState.STARTED);
               break;
            case Constants.instance.RENDERER_STATE_STOP_COMPLETE:
            case Constants.instance.TRANSLATOR_STATE_TRANSLATE_COMPLETE:
               if(this.translationHelper.autoCommitClonedAds(stateEvent))
               {
                  this.sm.tryChangeStateTo(AdState.STOPPED);
               }
               break;
            case Constants.instance.RENDERER_STATE_FAIL:
            case Constants.instance.TRANSLATOR_STATE_FAIL:
               details = details || {};
               this.failWithError(details["error"],details["additional"]);
         }
      }
      
      private function calculateExpanded() : Boolean
      {
         var _loc1_:Rectangle = this.slot.getBounds();
         return _loc1_.width >= Capabilities.screenResolutionX * 0.98 || _loc1_.height >= Capabilities.screenResolutionY * 0.98;
      }
      
      public function getAllCreativeRenditions() : Array
      {
         var _loc2_:CreativeRendition = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.adRef.getCreativeRenditionsByPriority())
         {
            if(this.primaryCreativeRendition == _loc2_)
            {
               _loc1_.unshift(_loc2_);
            }
            else
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function isFrontBumper() : Boolean
      {
         return !!this.ad ? this.ad.isFrontBumper() : false;
      }
      
      public function getCompanionAdInstances() : Array
      {
         var _loc2_:AdInstance = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.companionAdInstances)
         {
            if(!_loc2_.isPlaceholder())
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function set chainBehavior(param1:ChainBehavior) : void
      {
         this._chainBehavior = param1;
      }
      
      protected function onRendererLoaded(param1:Event) : void
      {
         this.rendererLoader.removeEventListener(RendererLoader.LOAD_COMPLETE,this.onRendererLoaded,false);
         this.rendererLoader.removeEventListener(RendererLoader.LOAD_ERROR,this.onRendererLoadFailed,false);
         this._renderer = this.rendererLoader.getRendererInstance();
         if(this.renderer)
         {
            this.initRenderer();
         }
         else
         {
            this.failWithError(InnerConstants.ERROR_RENDERER_INIT,"failed to get renderer instance");
         }
      }
      
      public function markFailed() : void
      {
         this.storeAdMetaData();
         this.sm.tryChangeStateTo(AdState.FAILED);
      }
      
      public function failWithError(param1:int, param2:String = null) : void
      {
         logger.error(this + ".failWithError " + param2);
         var _loc3_:AdErrorEventCallback = this.getCallbackManager().getAdEventCallback(Constants.instance.RENDERER_EVENT_FAIL,EventCallback.getErrorNameByCode(param1),Constants.instance.EVENTCALLBACK_TYPE_ERROR) as AdErrorEventCallback;
         if(_loc3_)
         {
            _loc3_.errorCode = param1;
            _loc3_.errorMessage = param2;
            _loc3_.process();
         }
         this.sendResellerNoAdErrorCallback(param1,param2);
         this.sm.tryChangeStateTo(AdState.FAILED);
      }
      
      public function get rendererEntry() : AdRenderer
      {
         return this._rendererEntry;
      }
      
      public function getCallbackManager() : CallbackManager
      {
         if(!this.callbackManager)
         {
            this.callbackManager = new CallbackManager(this);
         }
         return this.callbackManager;
      }
      
      public function toString() : String
      {
         return "[AdInst " + this.adRef + "(" + this.cloneGeneration + ") " + this.sm.state + "]";
      }
      
      public function getSlot() : ISlot
      {
         return this.slot;
      }
      
      public function storeAdMetaData() : void
      {
         this.latestAccurateTotalDuration = this.getTotalDuration(true);
         this.latestAccurateTotalBytes = this.getTotalBytes(true);
      }
      
      public function createCreativeRenditionForTranslation() : ICreativeRendition
      {
         var _loc2_:Creative = null;
         var _loc1_:CreativeRendition = null;
         if(this.ad)
         {
            _loc2_ = this.ad.get1stCreative() || this.ad.createCreative();
            if(_loc2_.id != this.adRef.creativeId)
            {
               logger.error(this + ".createCreativeRenditionForTranslation(), creative id not matching, adRef.creativeId is " + this.adRef.creativeId + ", new creative id is " + _loc2_.id);
               if(!_loc2_.id)
               {
                  _loc2_.id = this.adRef.creativeId;
               }
            }
            _loc1_ = _loc2_.createCreativeRendition();
            _loc1_.id = this.adRef.creativeRenditionId;
         }
         return _loc1_;
      }
      
      public function isRequiredToShow() : Boolean
      {
         return this.adRef.ad.requiredToShow;
      }
      
      protected function onLoadingEnter(param1:StateMachineEvent) : void
      {
         var _loc2_:CreativeRendition = null;
         if(Boolean(this.ad) && this.ad.noLoad)
         {
            this.sm.tryChangeStateTo(AdState.STOPPED);
            return;
         }
         if(this.adRef.creative.creativeRenditions.length == 0)
         {
            this.failWithError(Constants.instance.ERROR_NULL_ASSET,"no creative renditions");
            return;
         }
         for each(_loc2_ in this.adRef.getCreativeRenditionsByPriority())
         {
            this._rendererEntry = this._context.adManagerContext.adRendererSet.findAdRenderer(_loc2_.getContentType(),_loc2_.getAdUnit(),this.slot.getType(),this.slot.getTimePositionClass(),!!this.ad ? this.ad.adUnit : null,_loc2_.getWrapperType(),_loc2_.getCreativeAPI(),this.slot.getBase());
            if(this.rendererEntry != null)
            {
               this.setPrimaryCreativeRendition(_loc2_ as CreativeRendition);
               break;
            }
         }
         if(this.rendererEntry)
         {
            this.rendererLoader = new RendererLoader(this.rendererEntry);
            this.rendererLoader.addEventListener(RendererLoader.LOAD_COMPLETE,this.onRendererLoaded,false,0,true);
            this.rendererLoader.addEventListener(RendererLoader.LOAD_ERROR,this.onRendererLoadFailed,false,0,true);
            this.rendererLoader.loadRenderer();
            return;
         }
         this.failWithError(InnerConstants.ERROR_NO_RENDERER);
      }
      
      public function getTotalBytes(param1:Boolean = false) : int
      {
         return this.getInfoFromRendererOrRendition("getTotalBytes","latestAccurateTotalBytes",param1);
      }
      
      public function getPlayheadTime(param1:Boolean = false) : Number
      {
         return this.getProgressiveInfoFromRenderer("getPlayheadTime",this.getTotalDuration(param1));
      }
      
      protected function callRendererMethod(param1:String, param2:Boolean = false, param3:Array = null) : *
      {
         var methodName:String = param1;
         var failOnRuntimeError:Boolean = param2;
         var argArray:Array = param3;
         if(this.renderer)
         {
            try
            {
               return this.renderer[methodName].apply(this.renderer,argArray);
            }
            catch(e:Error)
            {
               logger.error(this + ".callRendererMethod: got error when call renderer." + methodName + " : " + e.message + "\n" + e.getStackTrace());
               if(failOnRuntimeError)
               {
                  failWithError(Constants.instance.ERROR_UNKNOWN,"Got runtime error when call renderer method " + methodName + " " + e.message);
               }
            }
         }
         return null;
      }
      
      protected function onStoppedEnter(param1:StateMachineEvent) : void
      {
         if(param1.fromState != null)
         {
            if(this.imprSent)
            {
               this.getMetricManager().stop();
            }
            this.cleanUp();
         }
      }
      
      public function shouldRequestMainVideoPauseOrResume(param1:Boolean, param2:Boolean) : Boolean
      {
         if(!this.slot.isMainVideoValidForPauseOrResume())
         {
            return false;
         }
         var _loc3_:Array = this.slot.getAdInstancesInPlayPlan(false,true);
         var _loc4_:Boolean = _loc3_.indexOf(this) == 0 && param1;
         if(this.slot.isLinear() && _loc4_)
         {
            return true;
         }
         if(!this.slot.isLinear() && param2)
         {
            return true;
         }
         return false;
      }
      
      public function get state() : String
      {
         return this.sm.state;
      }
      
      private function updateOrCreateClickWithCR(param1:String, param2:String, param3:String) : void
      {
         var _loc5_:EventCallback = null;
         var _loc4_:EventCallback;
         if(!(_loc4_ = this.adRef.findEvent(param1,param2,true)))
         {
            logger.warn(this + ".updateCreateEventCallback(),can not find generic callback for template");
         }
         else if(_loc4_.type == Constants.instance.EVENTCALLBACK_TYPE_GENERIC)
         {
            (_loc5_ = _loc4_.clone()).type = param2;
            _loc5_.name = param1;
            _loc5_.url = URLTools.replaceUrlParam(_loc4_.url,BasicEventCallback.URL_KEY_CR,param3,true);
            _loc5_.url = URLTools.replaceUrlParam(_loc5_.url,BasicEventCallback.URL_KEY_EVENT_NAME,param1,true);
            _loc5_.url = URLTools.replaceUrlParam(_loc5_.url,BasicEventCallback.URL_KEY_EVENT_TYPE,BasicEventCallback.SHORT_EVENT_TYPE_CLICK,true);
            this.adRef.addEventCallback(_loc5_.usage,_loc5_.type,_loc5_.name,_loc5_.url,true,_loc5_.trackingUrlNodes);
         }
         else
         {
            _loc4_.url = URLTools.replaceUrlParam(_loc4_.url,BasicEventCallback.URL_KEY_CR,param3,true);
            _loc4_.showBrowser = true;
         }
      }
      
      public function get adId() : String
      {
         return this.adRef.id;
      }
      
      public function setAdVolume() : void
      {
         var _loc1_:Number = this._context.adManagerContext.playerEnvironment.adVolume;
         var _loc2_:* = _loc1_ <= 2;
         if(this.isShowing() && this.isMuted != _loc2_)
         {
            this.getMetricManager().processDefaultEvent(_loc2_ ? Constants.instance.RENDERER_EVENT_MUTE : Constants.instance.RENDERER_EVENT_UNMUTE);
         }
         if(this.isActive())
         {
            this.callRendererMethod("setAdVolume",false,[_loc1_]);
         }
         this.isMuted = _loc2_;
      }
      
      protected function initStateMachine() : void
      {
         this.sm = new StateMachine();
         this.sm.id = "ad " + this.id;
         this.sm.addState(AdState.LOADING,{
            "enter":this.onLoadingEnter,
            "from":[AdState.STOPPED,AdState.FAILED]
         });
         this.sm.addState(AdState.LOADED,{"from":[AdState.LOADING]});
         this.sm.addState(AdState.STARTING,{
            "enter":this.onStartingEnter,
            "from":[AdState.LOADED,AdState.LOADING]
         });
         this.sm.addState(AdState.STARTED,{"from":[AdState.STARTING,AdState.PAUSED]});
         this.sm.addState(AdState.PAUSED,{"from":AdState.STARTED});
         this.sm.addState(AdState.STOPPING,{
            "enter":this.onStoppingEnter,
            "from":[AdState.LOADING,AdState.LOADED,AdState.STARTING,AdState.STARTED,AdState.PAUSED]
         });
         this.sm.addState(AdState.STOPPED,{
            "enter":this.onStoppedEnter,
            "from":[AdState.STOPPING,AdState.STARTED,AdState.PAUSED,AdState.LOADING]
         });
         this.sm.addState(AdState.FAILED,{
            "enter":this.onFailedEnter,
            "from":"*"
         });
         this.sm.initialState = AdState.STOPPED;
         this.sm.addEventListener(StateMachineEvent.TRANSITION_COMPLETE,this.onTransitionComplete,false,0,true);
         this.sm.addEventListener(StateMachineEvent.TRANSITION_DENIED,this.onTransitionDenied,false,0,true);
      }
      
      public function get context() : Contexts
      {
         return this._context;
      }
      
      private function addURLToArray(param1:AdEventCallback, param2:Array) : void
      {
         var _loc3_:String = param1.getUrl(false);
         if(!SuperString.isNull(_loc3_))
         {
            param2.push(_loc3_);
         }
      }
      
      public function getRendererController() : IRendererController
      {
         if(!this.rendererContext)
         {
            this.rendererContext = new RendererContext(this);
         }
         return this.rendererContext;
      }
      
      private function getEventTrackerURLs(param1:String) : Array
      {
         var _loc4_:EventCallback = null;
         var _loc5_:AdEventCallback = null;
         var _loc6_:String = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < this.adRef.eventCallbacks.length)
         {
            if((_loc4_ = this.adRef.eventCallbacks[_loc3_]).type == Constants.instance.EVENTCALLBACK_TYPE_ACTION && _loc4_.name == param1)
            {
               _loc6_ = (_loc5_ = new CustomEventCallback(0,this,_loc4_)).getUrl(false);
               _loc2_.push(_loc6_);
               _loc2_.concat(_loc5_.getTrackingUrls());
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function resize() : void
      {
         var _loc1_:Boolean = this.calculateExpanded();
         if(this.isShowing() && this.isExpanded != _loc1_)
         {
            this.getMetricManager().processDefaultEvent(_loc1_ ? Constants.instance.RENDERER_EVENT_EXPAND : Constants.instance.RENDERER_EVENT_COLLAPSE);
         }
         if(this.isActive())
         {
            this.callRendererMethod("resize",false);
         }
         this.isExpanded = _loc1_;
      }
      
      public function get creative() : Creative
      {
         return this.adRef.creative;
      }
      
      public function get renderer() : IRenderer
      {
         return this._renderer;
      }
      
      public function sendErrorCallback(param1:int, param2:String = null) : void
      {
         var _loc3_:AdErrorEventCallback = this.getCallbackManager().getAdEventCallback(Constants.instance.RENDERER_EVENT_ERROR,EventCallback.getErrorNameByCode(param1),Constants.instance.EVENTCALLBACK_TYPE_ERROR) as AdErrorEventCallback;
         if(_loc3_)
         {
            _loc3_.errorMessage = param2;
            _loc3_.errorCode = param1;
            _loc3_.process();
         }
      }
      
      public function markImprSent() : void
      {
         var _loc1_:AdInstance = null;
         this._imprSent = true;
         this._isStartedSuccessfully = true;
         if(Boolean(this._context.adManagerContext.capabilities.getCapability(Constants.instance.CAPABILITY_SUPPORT_AD_BUNDLE)) && Boolean(this.ad.bundleId))
         {
            for each(_loc1_ in this.slot.getAllAdInstances())
            {
               if(Boolean(_loc1_.ad.bundleId) && _loc1_.ad.bundleId != this.ad.bundleId)
               {
                  _loc1_._chainBehavior = null;
                  _loc1_.sm.tryChangeStateTo(AdState.FAILED);
               }
            }
         }
      }
      
      public function isActive() : Boolean
      {
         return [AdState.LOADING,AdState.LOADED,AdState.STARTING,AdState.STARTED,AdState.PAUSED,AdState.STOPPING].indexOf(this.sm.state) > -1;
      }
      
      protected function cleanUp() : void
      {
         if(this._isStartedSuccessfully)
         {
            this.getMetricManager().processDefaultEvent(Constants.instance.RENDERER_EVENT_IMPRESSION_END);
         }
         this._isStartedSuccessfully = false;
         this.getTotalDuration();
         this.getTotalBytes();
         this.translationHelper.restorePlaceholdersForHybrid();
         this.callRendererMethod("dispose");
         if(this.rendererLoader)
         {
            this.rendererLoader.dispose();
            this.rendererLoader = null;
         }
         if(this.renderer)
         {
            this._renderer = null;
         }
         if(Boolean(this.baseSprite) && Boolean(this.slot.getBase()))
         {
            try
            {
               this.slot.getBase().removeChild(this.baseSprite);
            }
            catch(e:Error)
            {
               logger.warn(this + ".cleanUp, got error when removing ad baseSprite: " + e);
            }
            this.baseSprite = null;
         }
         if(this.metricManager)
         {
            this.metricManager.dispose();
            this.metricManager = null;
         }
      }
      
      public function skipRendering(param1:Boolean) : void
      {
         if(this.ad)
         {
            this.ad.noLoad = param1;
         }
      }
      
      protected function getProgressiveInfoFromRenderer(param1:String, param2:Number) : Number
      {
         var _loc3_:Number = -1;
         var _loc4_:Number = Number(this.callRendererMethod(param1,false) || -1);
         if(Boolean(this.renderer) && _loc4_ >= 0)
         {
            _loc3_ = _loc4_;
         }
         else if(param2 >= 0 && !this.isActive())
         {
            _loc3_ = param2;
         }
         else if(this.isActive())
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function isPlayable() : Boolean
      {
         var _loc1_:Boolean = true;
         _loc1_ = _loc1_ && !(this.sm.state == AdState.FAILED && !this.imprSent);
         if(!_loc1_)
         {
            return _loc1_;
         }
         _loc1_ = _loc1_ && !this.scheduledDrivingAd;
         if(!_loc1_)
         {
            return _loc1_;
         }
         _loc1_ = _loc1_ && (!this._context.adManagerContext.selectedBundleId || !this.ad.bundleId || this.ad.bundleId == this._context.adManagerContext.selectedBundleId);
         if(!_loc1_)
         {
            return _loc1_;
         }
         return _loc1_;
      }
      
      protected function onStartingEnter(param1:StateMachineEvent) : void
      {
         if(this.getMetricManager().adManagerControlMainVideoPause() && this.shouldRequestMainVideoPauseOrResume(true,false))
         {
            this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_PAUSESTATECHANGE_REQUEST,this.slot.customId,true,false,true);
         }
         this.resize();
         this.setAdVolume();
         this.callRendererMethod("start",true);
      }
      
      public function getEventCallbackURLs(param1:String, param2:String = null, param3:Boolean = false) : Array
      {
         var _loc6_:AdEventCallback = null;
         var _loc7_:Object = null;
         var _loc8_:uint = 0;
         var _loc9_:ClickEventCallback = null;
         var _loc10_:AdEventCallback = null;
         if(param3)
         {
            logger.warn(this + "Deprecated param externalCallbacks is used, return empty array");
            return [];
         }
         if(param2 == Constants.instance.EVENTCALLBACK_TYPE_ACTION)
         {
            return this.getEventTrackerURLs(param1);
         }
         var _loc4_:Array = new Array();
         var _loc5_:String = null;
         if(CallbackManager.VALID_EVENT_CALLBACK_ERROR_NAMES.indexOf(param1) > -1)
         {
            if((_loc6_ = this.getCallbackManager().getAdEventCallback(Constants.instance.RENDERER_EVENT_ERROR,param1,Constants.instance.EVENTCALLBACK_TYPE_ERROR)) != null)
            {
               this.addURLToArray(_loc6_,_loc4_);
            }
         }
         else
         {
            if((_loc7_ = CallbackManager.getEventCallbackInfo(param1,param2)) == null)
            {
               logger.error(this + ".getEventCallbackURLs(), invalid combination of eventName " + param1 + " and eventType " + param2);
               return [];
            }
            _loc8_ = uint(_loc7_.eventId);
            param1 = String(_loc7_.eventName);
            param2 = String(_loc7_.eventType);
            if(param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICK || param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICKTRACKING)
            {
               _loc9_ = null;
               if(param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICK)
               {
                  _loc9_ = this.getMetricManager().getCurrentClickEventCallback();
               }
               if(!_loc9_)
               {
                  _loc9_ = this.getCallbackManager().getAdEventCallback(_loc8_,param1,Constants.instance.EVENTCALLBACK_TYPE_CLICK,param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICKTRACKING) as ClickEventCallback;
               }
               if(_loc9_ != null)
               {
                  if(param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICK)
                  {
                     if(_loc9_.showBrowser)
                     {
                        this.addURLToArray(_loc9_,_loc4_);
                     }
                  }
                  else
                  {
                     if(!_loc9_.showBrowser)
                     {
                        this.addURLToArray(_loc9_,_loc4_);
                     }
                     _loc4_ = _loc4_.concat(_loc9_.getTrackingUrls());
                  }
               }
            }
            else if((_loc10_ = this.getCallbackManager().getAdEventCallback(_loc8_,param1,param2)) != null)
            {
               this.addURLToArray(_loc10_,_loc4_);
               _loc4_ = _loc4_.concat(_loc10_.getTrackingUrls());
            }
         }
         return _loc4_;
      }
      
      public function get imprSent() : Boolean
      {
         return this._imprSent;
      }
      
      public function isPlaceholder() : Boolean
      {
         return this.adRef.isPlaceholder();
      }
      
      public function addCreativeRendition() : ICreativeRendition
      {
         return this.createCreativeRenditionForTranslation();
      }
      
      protected function onTransitionComplete(param1:StateMachineEvent) : void
      {
         if(param1.fromState == AdState.STARTING && param1.toState == AdState.STARTED)
         {
            this.getMetricManager().start();
            if(!this.rendererEntry.isTranslator() && this.slot.isShowing())
            {
               this.slot.drawSlotBackground();
               this.playCompanions();
            }
         }
         else if(param1.fromState == AdState.STARTED && param1.toState == AdState.PAUSED)
         {
            if(this.slot.isRendererEvent)
            {
               this.slot.isRendererEvent = false;
            }
            else
            {
               this.callRendererMethod("pause");
               this.getMetricManager().processDefaultEvent(Constants.instance.RENDERER_EVENT_PAUSE);
            }
         }
         else if(param1.fromState == AdState.PAUSED && param1.toState == AdState.STARTED)
         {
            if(this.slot.isRendererEvent)
            {
               this.slot.isRendererEvent = false;
            }
            else
            {
               this.callRendererMethod("resume");
               this.getMetricManager().processDefaultEvent(Constants.instance.RENDERER_EVENT_RESUME);
            }
         }
         if(Boolean(this.chainBehavior) && this.chainBehavior.isDestState(param1.toState))
         {
            this.slot.notifyAdDone(this);
         }
      }
      
      public function cloneForTranslation() : AdInstance
      {
         if(this.cloneGeneration >= InnerConstants.AD_MAX_CLONE_GENERATION)
         {
            logger.warn(this + ".cloneForTranslation(): This ad has been cloned for more than " + InnerConstants.AD_MAX_CLONE_GENERATION + " times, abort.");
            return null;
         }
         var _loc1_:AdInstance = new AdInstance(this.adRef.cloneForTranslation(this.primaryCreativeRendition));
         _loc1_.cloneGeneration = this.cloneGeneration + 1;
         _loc1_._slot = this.slot;
         _loc1_._additionalCallbackKeyValues = this._additionalCallbackKeyValues.clone();
         _loc1_.callbackManager = this.getCallbackManager().cloneForTranslation(_loc1_);
         _loc1_.isFirstAdInPod = this.isFirstAdInPod;
         return _loc1_;
      }
      
      public function pause() : void
      {
         this.sm.tryChangeStateTo(AdState.PAUSED);
      }
      
      public function get slot() : BaseSlot
      {
         if(!this._slot)
         {
            this._slot = !!this.adChain ? this.adChain.slot : this._context.requestContext.findSlotById(this.adRef.slotCustomId);
         }
         return this._slot;
      }
   }
}
