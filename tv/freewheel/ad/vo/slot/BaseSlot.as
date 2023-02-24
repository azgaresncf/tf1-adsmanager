package tv.freewheel.ad.vo.slot
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.callback.SlotImpressionEventCallback;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.playback.AdChain;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.playback.AdState;
   import tv.freewheel.ad.playback.SlotState;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.ad.vo.reference.AdReference;
   import tv.freewheel.utils.basic.Arrays;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.stateMachine.StateMachine;
   import tv.freewheel.utils.stateMachine.StateMachineEvent;
   
   public class BaseSlot implements ISlot
   {
      
      public static const TIME_POSITION_CLASSES:Array = [Constants.instance.TIME_POSITION_CLASS_PREROLL,Constants.instance.TIME_POSITION_CLASS_MIDROLL,Constants.instance.TIME_POSITION_CLASS_POSTROLL,Constants.instance.TIME_POSITION_CLASS_OVERLAY,Constants.instance.TIME_POSITION_CLASS_DISPLAY];
      
      private static const CLASSNAME:String = "BaseSlot";
      
      private static var logger:ILogger = Log.getLogger("AdManager." + CLASSNAME);
       
      
      private var stateBeforeStopping:String = null;
      
      private var _acceptance:int;
      
      public var adReferences:Array;
      
      public var acceptPrimaryContentType:Array;
      
      public var acceptContentType:Array;
      
      public var adUnit:String;
      
      public var slotBounds:Rectangle;
      
      protected var immediateStop:Boolean = false;
      
      protected var sm:StateMachine;
      
      protected var _context:Contexts;
      
      private var _slotStartEventCallback:SlotImpressionEventCallback;
      
      public var isRendererEvent:Boolean = false;
      
      public var slotProfile:String;
      
      protected var _customId:String;
      
      public var adChains:Array;
      
      private var _slotEndEventCallback:SlotImpressionEventCallback;
      
      public var podScheduled:Boolean = false;
      
      public var parameters:Array;
      
      public var slotBase:Sprite;
      
      public function BaseSlot(param1:Contexts)
      {
         this.adReferences = new Array();
         this.acceptPrimaryContentType = new Array();
         this.acceptContentType = new Array();
         this.parameters = new Array();
         this._acceptance = Constants.instance.SLOT_ACCEPTANCE_UNKNOWN;
         this.adChains = new Array();
         super();
         this._context = param1;
         this.initStateMachine();
      }
      
      public function stop(param1:Boolean = false) : void
      {
         this.immediateStop = param1;
      }
      
      public function getAdInstancesInPlayPlan(param1:Boolean = false, param2:Boolean = true) : Array
      {
         var _loc4_:AdChain = null;
         var _loc5_:Boolean = false;
         var _loc6_:AdInstance = null;
         var _loc3_:Array = [];
         for each(_loc4_ in this.adChains)
         {
            _loc5_ = false;
            for each(_loc6_ in _loc4_.adInstances)
            {
               if(!_loc5_ && _loc6_.isPlayable() && (!_loc6_.isBumper() || param2))
               {
                  _loc3_.push(_loc6_);
                  _loc5_ = true;
               }
               if(param1 && _loc6_.scheduledDrivingAd)
               {
                  _loc3_.push(_loc6_);
               }
            }
            _loc5_ = false;
         }
         return _loc3_;
      }
      
      public function preload() : void
      {
         this.sm.tryChangeStateTo(SlotState.PRELOADING);
      }
      
      public function isPauseSlot() : Boolean
      {
         return this.getTimePositionClass() == Constants.instance.TIME_POSITION_CLASS_PAUSE_MIDROLL;
      }
      
      public function getWidth() : uint
      {
         return this.getBounds().width;
      }
      
      public function getParameterObject(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:AdInstance = this.getShowingAd();
         if(_loc3_)
         {
            _loc2_ = _loc3_.getParameterObject(param1);
         }
         else
         {
            _loc2_ = this._context.requestContext.getParameter(param1,Constants.instance.PARAMETER_OVERRIDE);
            if(_loc2_ == null)
            {
               _loc2_ = Parameter.getParameterFromArray(this.parameters,param1);
            }
            if(_loc2_ == null)
            {
               _loc2_ = this._context.requestContext.getParameter(param1);
            }
         }
         return _loc2_;
      }
      
      public function get id() : String
      {
         return this.customId;
      }
      
      public function isLinear() : Boolean
      {
         return this.getType() == Constants.instance.SLOT_TYPE_TEMPORAL && this.getTimePositionClass() != Constants.instance.TIME_POSITION_CLASS_OVERLAY;
      }
      
      public function getHeight() : uint
      {
         return this.getBounds().height;
      }
      
      private function processSlotEndEventCallback() : void
      {
         if(this._slotEndEventCallback != null)
         {
            this._slotEndEventCallback.process();
         }
      }
      
      public function getPhysicalLocation() : String
      {
         var _loc1_:String = null;
         if(this.getType() == Constants.instance.SLOT_TYPE_TEMPORAL || Boolean(this.slotBase))
         {
            _loc1_ = Constants.instance.SLOT_LOCATION_PLAYER;
         }
         else
         {
            _loc1_ = Constants.instance.SLOT_LOCATION_EXTERNAL;
         }
         return _loc1_;
      }
      
      protected function onStoppingEnter(param1:StateMachineEvent) : void
      {
         var _loc3_:AdChain = null;
         var _loc4_:AdInstance = null;
         var _loc2_:Boolean = false;
         if(param1.fromState != null)
         {
            this.stateBeforeStopping = param1.fromState;
            for each(_loc3_ in this.adChains)
            {
               for each(_loc4_ in _loc3_.adInstances)
               {
                  if(_loc4_.state != AdState.STOPPED && _loc4_.state != AdState.FAILED)
                  {
                     _loc4_.stop(this.immediateStop);
                     _loc2_ = true;
                  }
               }
            }
         }
         if(this.getTimePositionClass() == Constants.instance.TIME_POSITION_CLASS_DISPLAY)
         {
            _loc2_ = false;
         }
         if(!_loc2_)
         {
            this.sm.tryChangeStateTo(SlotState.STOPPED);
         }
      }
      
      public function getShowingAd() : AdInstance
      {
         var _loc2_:AdInstance = null;
         var _loc1_:AdInstance = null;
         for each(_loc2_ in this.getAdInstancesInPlayPlan(false))
         {
            if(_loc2_.isShowing())
            {
               _loc1_ = _loc2_;
               break;
            }
         }
         return _loc1_;
      }
      
      public function getAllAdInstances() : Array
      {
         var _loc2_:AdChain = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.adChains)
         {
            _loc1_ = _loc1_.concat(_loc2_.adInstances);
         }
         return _loc1_;
      }
      
      public function play(param1:String = null, param2:uint = 0) : void
      {
         logger.error(this + ".play(), override me");
      }
      
      public function drawSlotBackground() : void
      {
      }
      
      public function playCompanion() : void
      {
         logger.error(this + "playCompanion, do nothing");
      }
      
      public function getBytesLoaded(param1:Boolean = false) : int
      {
         return this.sumAdInstanceInfo("getBytesLoaded",param1);
      }
      
      protected function onPreloadingEnter(param1:StateMachineEvent) : void
      {
         var _loc2_:AdInstance = this.findNextAdToWork();
         if(_loc2_)
         {
            _loc2_.preload();
         }
         else
         {
            this.dispatchSlotEvent(Constants.instance.EVENT_SLOT_PRELOADED);
         }
      }
      
      protected function isShowingBumperAd() : Boolean
      {
         var _loc1_:AdInstance = this.getShowingAd();
         return Boolean(_loc1_) && _loc1_.isBumper();
      }
      
      public function isShowing() : Boolean
      {
         return this.sm.state == SlotState.PLAYING || this.sm.state == SlotState.PAUSED;
      }
      
      public function getEmbeddedAdsDuration() : Number
      {
         return -1;
      }
      
      public function getTotalDuration(param1:Boolean = false) : Number
      {
         return this.sumAdInstanceInfo("getTotalDuration",param1);
      }
      
      public function getAcceptance() : int
      {
         return this._acceptance;
      }
      
      public function getBase() : Sprite
      {
         return this.slotBase;
      }
      
      protected function onTransitionDenied(param1:StateMachineEvent) : void
      {
      }
      
      public function getEndTimePosition() : Number
      {
         return -1;
      }
      
      public function getTimePositionClass() : String
      {
         logger.error(this + ".getTimePositionClass(), Override Me!");
         return null;
      }
      
      public function getAdInstances(param1:Boolean = true) : Array
      {
         return this.getAdInstancesInPlayPlan(param1,false);
      }
      
      public function setParameter(param1:String, param2:String) : void
      {
         Parameter.addParameterToArray(this.parameters,param1,param2);
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:XMLNode = null;
         var _loc7_:AdReference = null;
         this.adReferences.splice(0);
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_EVENT_CALLBACKS:
                  _loc4_ = EventCallback.parseEventCallbacks(_loc3_);
                  this._slotStartEventCallback = SlotImpressionEventCallback.construct(_loc4_,Constants.instance.EVENTCALLBACK_SLOT_START,this);
                  this._slotEndEventCallback = SlotImpressionEventCallback.construct(_loc4_,Constants.instance.EVENTCALLBACK_SLOT_END,this);
                  break;
               case InnerConstants.TAG_AD_REFERENCES:
                  _loc5_ = 0;
                  while(_loc5_ < _loc3_.childNodes.length)
                  {
                     if((_loc6_ = _loc3_.childNodes[_loc5_]).localName == InnerConstants.TAG_AD_REFERENCE)
                     {
                        _loc7_ = new AdReference(this._context);
                        this.adReferences.push(_loc7_);
                        _loc7_.parseXML(_loc6_);
                     }
                     _loc5_++;
                  }
                  break;
               case InnerConstants.TAG_PARAMETERS:
                  Parameter.parseParametersToArray(_loc3_,this.parameters);
                  break;
            }
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         return "[" + CLASSNAME + " " + this.id + " " + this.sm.state + "]";
      }
      
      private function shouldRequestMainVideoPauseOrResume() : Boolean
      {
         return this.isLinear() && !this.isPauseSlot() && this.isMainVideoValidForPauseOrResume() && this.getAllAdInstances().length != 0;
      }
      
      public function get customId() : String
      {
         return this._customId;
      }
      
      public function setBase(param1:Sprite) : void
      {
         this.slotBase = param1;
      }
      
      public function getAdCount() : uint
      {
         return this.getAdInstancesInPlayPlan(true,false).length;
      }
      
      public function getPlayheadTime(param1:Boolean = false) : Number
      {
         return this.sumAdInstanceInfo("getPlayheadTime",param1,true);
      }
      
      public function addAdChain(param1:AdChain) : void
      {
         this.adChains.push(param1);
         param1.slot = this;
      }
      
      public function isMainVideoValidForPauseOrResume() : Boolean
      {
         return [Constants.instance.VIDEO_STATUS_PAUSED,Constants.instance.VIDEO_STATUS_PLAYING].indexOf(this._context.adManagerContext.adManager.getVideoPlayStatus()) > -1;
      }
      
      public function getTotalBytes(param1:Boolean = false) : int
      {
         return this.sumAdInstanceInfo("getTotalBytes",param1);
      }
      
      protected function onStoppedEnter(param1:StateMachineEvent) : void
      {
         var _loc2_:AdChain = null;
         var _loc3_:Boolean = false;
         var _loc4_:AdInstance = null;
         if(param1.fromState != null)
         {
            for each(_loc2_ in this.adChains)
            {
               for each(_loc4_ in _loc2_.adInstances)
               {
                  _loc4_.stop(this.immediateStop);
               }
            }
            _loc3_ = false;
            if(Boolean(this.stateBeforeStopping) && (this.stateBeforeStopping == SlotState.PLAYING || this.stateBeforeStopping == SlotState.PAUSED))
            {
               _loc3_ = true;
               this.stateBeforeStopping = null;
            }
            if(param1.fromState == SlotState.PLAYING || param1.fromState == SlotState.PAUSED || _loc3_)
            {
               if(this.shouldRequestMainVideoPauseOrResume())
               {
                  this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_PAUSESTATECHANGE_REQUEST,this.customId,true,false,false);
               }
               this.processSlotEndEventCallback();
               this.dispatchSlotEvent(Constants.instance.EVENT_SLOT_ENDED);
            }
         }
      }
      
      public function getTimePosition() : Number
      {
         return 0;
      }
      
      public function get state() : String
      {
         return this.sm.state;
      }
      
      public function hasCompanion() : Boolean
      {
         return false;
      }
      
      protected function findNextAdToWork(param1:AdInstance = null) : AdInstance
      {
         if(param1 == null)
         {
            return this.findNextPlayableAd();
         }
         if(param1.slot != this)
         {
            logger.error(this + "findNextAdToWork(" + param1 + "), adInstance does not belong to this slot");
            return null;
         }
         var _loc2_:AdInstance = null;
         if(this.state == param1.chainBehavior.relatedSlotState())
         {
            if(param1.chainBehavior.isChainStopper(param1))
            {
               param1 = param1.adChain.adInstances[param1.adChain.adInstances.length - 1];
            }
            _loc2_ = this.findNextPlayableAd(param1);
         }
         return _loc2_;
      }
      
      public function getBounds() : Rectangle
      {
         if(this.slotBounds == null)
         {
            if(this.slotBase != null)
            {
               logger.warn(this + " getBounds(), this slot has its own slotBase but not has its own slotBounds, return global temporal bounds instead");
            }
            return this._context.adManagerContext.playerEnvironment.getTemporalSlotBounds();
         }
         return this.slotBounds;
      }
      
      public function set acceptance(param1:int) : void
      {
         this._acceptance = param1;
      }
      
      public function get context() : Contexts
      {
         return this._context;
      }
      
      public function getType() : String
      {
         logger.error(this + ".getType(), Override Me!");
         return null;
      }
      
      private function processSlotStartEventCallback() : void
      {
         if(this._slotStartEventCallback != null)
         {
            this._slotStartEventCallback.process();
         }
      }
      
      protected function initStateMachine() : void
      {
         this.sm = new StateMachine();
         this.sm.addEventListener(StateMachineEvent.TRANSITION_COMPLETE,this.onTransitionComplete,false,0,true);
         this.sm.addEventListener(StateMachineEvent.TRANSITION_DENIED,this.onTransitionDenied,false,0,true);
      }
      
      public function setBounds(param1:int, param2:int, param3:uint, param4:uint) : void
      {
         this.slotBounds = new Rectangle(param1,param2,param3,param4);
      }
      
      public function setVisible(param1:Boolean) : void
      {
         logger.error(this + ".setVisible, Override Me");
      }
      
      protected function findNextPlayableAd(param1:AdInstance = null) : AdInstance
      {
         var _loc2_:AdInstance = null;
         var _loc3_:AdChain = null;
         if(param1)
         {
            _loc3_ = param1.adChain;
         }
         else
         {
            _loc3_ = this.adChains[0];
         }
         while(_loc3_)
         {
            _loc2_ = _loc3_.findNextPlayableAd(param1);
            if(_loc2_)
            {
               break;
            }
            _loc3_ = AdChain(Arrays.next(this.adChains,_loc3_));
         }
         return _loc2_;
      }
      
      protected function onPlayingEnter(param1:StateMachineEvent) : void
      {
         var _loc2_:AdInstance = this.findNextAdToWork();
         if(!(_loc2_ && _loc2_.isBumper()))
         {
            this.processSlotStartEventCallback();
         }
         this.dispatchSlotEvent(Constants.instance.EVENT_SLOT_STARTED);
         if(_loc2_)
         {
            _loc2_.play();
         }
         else
         {
            logger.warn(this + ".onPlayingEnter, no playable ad");
            this.sm.tryChangeStateTo(SlotState.STOPPED);
         }
      }
      
      public function skipCurrentAd() : void
      {
         var _loc1_:AdChain = null;
         var _loc2_:AdInstance = null;
         for each(_loc1_ in this.adChains)
         {
            for each(_loc2_ in _loc1_.adInstances)
            {
               if(_loc2_.isActive() && !_loc2_.isBumper())
               {
                  _loc2_.stop(true);
                  return;
               }
            }
         }
      }
      
      public function getEventCallbackURLs() : Array
      {
         var _loc1_:Array = new Array();
         if(this._slotStartEventCallback)
         {
            _loc1_.push(this._slotStartEventCallback.getUrl(false));
            _loc1_ = _loc1_.concat(this._slotStartEventCallback.getTrackingUrls());
         }
         return _loc1_;
      }
      
      protected function sumAdInstanceInfo(param1:String, param2:Boolean, param3:Boolean = false) : Number
      {
         var _loc6_:AdInstance = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc4_:Number = -1;
         var _loc5_:Array = this.getAdInstancesInPlayPlan(false,false);
         if(param3)
         {
            if(this.isShowing() && !this.isShowingBumperAd())
            {
               _loc7_ = 0;
               while(_loc7_ < _loc5_.length)
               {
                  if(Boolean(_loc5_[_loc7_].isActive()) && _loc7_ + 1 < _loc5_.length)
                  {
                     _loc5_.splice(_loc7_ + 1);
                  }
                  _loc7_++;
               }
            }
            else
            {
               _loc5_ = [];
            }
         }
         for each(_loc6_ in _loc5_)
         {
            if((_loc8_ = Number(_loc6_[param1](param2))) < 0)
            {
               _loc4_ = -1;
               break;
            }
            if(_loc4_ == -1)
            {
               _loc4_ = _loc8_;
            }
            else
            {
               _loc4_ += _loc8_;
            }
         }
         return _loc4_;
      }
      
      public function isActive() : Boolean
      {
         return this.isShowing() || this.state == SlotState.PRELOADING;
      }
      
      public function set customId(param1:String) : void
      {
         this._customId = param1;
         this.sm.id = "slot " + param1;
      }
      
      public function getCustomId() : String
      {
         return this.customId;
      }
      
      protected function onTransitionComplete(param1:StateMachineEvent) : void
      {
      }
      
      public function notifyAdDone(param1:AdInstance) : void
      {
         if(param1.isFrontBumper() && this.state == SlotState.PLAYING)
         {
            this.processSlotStartEventCallback();
         }
         var _loc2_:AdInstance = this.findNextAdToWork(param1);
         if(_loc2_)
         {
            if(this.state == SlotState.PRELOADING)
            {
               _loc2_.preload();
            }
            else if(this.state == SlotState.PLAYING)
            {
               _loc2_.play();
            }
         }
         else if(this.state == SlotState.PRELOADING)
         {
            this.dispatchSlotEvent(Constants.instance.EVENT_SLOT_PRELOADED);
         }
         else if((this.state == SlotState.PLAYING || this.state == SlotState.PAUSED || this.state == SlotState.STOPPING) && param1.chainBehavior.relatedSlotState() == SlotState.PLAYING)
         {
            this.sm.tryChangeStateTo(SlotState.STOPPED);
         }
      }
      
      protected function _init(param1:String, param2:String, param3:Sprite, param4:String, param5:Object, param6:String, param7:String) : void
      {
         var _loc8_:String = null;
         this.slotProfile = param1;
         this.customId = param2;
         this.slotBase = param3;
         this.adUnit = param4;
         if(!SuperString.isNull(param6))
         {
            this.acceptPrimaryContentType = param6.split(",");
         }
         if(!SuperString.isNull(param7))
         {
            this.acceptContentType = param7.split(",");
         }
         for(_loc8_ in param5)
         {
            this.setParameter(_loc8_,param5[_loc8_]);
         }
      }
      
      protected function dispatchSlotEvent(param1:String) : void
      {
         this._context.adManagerContext.broadcastEvent(param1,this.customId);
      }
      
      public function getParameter(param1:String) : String
      {
         return this.getParameterObject(param1) as String;
      }
      
      public function pause(param1:Boolean = true) : void
      {
      }
      
      public function isVisible() : Boolean
      {
         return true;
      }
   }
}
