package tv.freewheel.ad.vo.slot
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.playback.AdChain;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.playback.ChainBehavior;
   import tv.freewheel.ad.playback.SlotState;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.stateMachine.StateMachineEvent;
   import tv.freewheel.utils.xml.XMLUtils;
   
   public class TemporalSlot extends BaseSlot
   {
      
      public static const DEFAULT_PADDING_AD_MIN_DURATION:Number = 3;
      
      private static const CLASSNAME:String = "TemporalSlot";
      
      private static var logger:ILogger = Log.getLogger("AdManager." + CLASSNAME);
       
      
      protected var _timePositionClass:String;
      
      public var endTimePosition:Number;
      
      public var timePosition:Number;
      
      private var slaveMode:Boolean = false;
      
      public var minSlotDuration:Number;
      
      private var background:Shape;
      
      private var paddingAdStopTimer:Timer;
      
      public var maxSlotDuration:Number;
      
      private var startTime:Date = null;
      
      public var embeddedAdsDuration:Number;
      
      public var cuePointSequence:uint;
      
      public function TemporalSlot(param1:Contexts)
      {
         this.paddingAdStopTimer = new Timer(0,1);
         super(param1);
         this.paddingAdStopTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.stopActivePaddingAd,false,0,true);
         this.embeddedAdsDuration = -1;
         this.endTimePosition = -1;
         this.context.adManagerContext.addEventListener(Constants.instance.EVENT_RENDERER,this.rendererEvent);
      }
      
      public function get timePositionClass() : String
      {
         return this._timePositionClass;
      }
      
      public function set timePositionClass(param1:String) : void
      {
         this._timePositionClass = param1;
      }
      
      override public function stop(param1:Boolean = false) : void
      {
         super.stop(param1);
         sm.tryChangeStateTo(SlotState.STOPPING);
      }
      
      override protected function onStoppedEnter(param1:StateMachineEvent) : void
      {
         this.startTime = null;
         this.paddingAdStopTimer.reset();
         this.removeSlotBackground();
         this.slaveMode = false;
         super.onStoppedEnter(param1);
      }
      
      override public function getTimePosition() : Number
      {
         return this.timePosition;
      }
      
      public function init(param1:String, param2:String, param3:Number, param4:uint, param5:Number = 0, param6:String = null, param7:Object = null, param8:String = null, param9:String = null, param10:Number = 0, param11:Sprite = null) : void
      {
         var _loc12_:String = null;
         super._init(param1,param2,param11,param6,param7,param8,param9);
         this.timePosition = param3;
         this.cuePointSequence = param4;
         this.maxSlotDuration = param5;
         this.minSlotDuration = param10;
         this._timePositionClass = this.getTPCByAdUnit(param6);
         for(_loc12_ in param7)
         {
            this.setParameter(_loc12_,param7[_loc12_]);
         }
         if(!SuperString.isNull(param8))
         {
            this.acceptPrimaryContentType = param8.split(",");
         }
         if(!SuperString.isNull(param9))
         {
            this.acceptContentType = param9.split(",");
         }
      }
      
      override public function hasCompanion() : Boolean
      {
         var _loc2_:AdInstance = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in getAdInstancesInPlayPlan(false,false))
         {
            if(_loc2_.companionAdInstances.length > 0)
            {
               _loc1_ = true;
               break;
            }
         }
         return _loc1_;
      }
      
      private function playFromFirstAd() : void
      {
         var _loc1_:AdInstance = this.findNextAdToWork();
         if(_loc1_)
         {
            _loc1_.play();
         }
         else
         {
            logger.warn(this + ".onPlayingEnter, no playable ad");
            this.sm.tryChangeStateTo(SlotState.STOPPED);
         }
      }
      
      private function rendererEvent(param1:Object) : void
      {
         if(param1.subType == Constants.instance.RENDERER_EVENT_PAUSE)
         {
            if(this.state == SlotState.PLAYING)
            {
               isRendererEvent = true;
               this.sm.tryChangeStateTo(SlotState.PAUSED);
            }
         }
         else if(param1.subType == Constants.instance.RENDERER_EVENT_RESUME)
         {
            if(this.state == SlotState.PAUSED)
            {
               isRendererEvent = true;
               this.sm.tryChangeStateTo(SlotState.PLAYING);
            }
         }
      }
      
      override protected function findNextAdToWork(param1:AdInstance = null) : AdInstance
      {
         var _loc2_:AdInstance = super.findNextAdToWork(param1);
         var _loc3_:Number = this.getRemainingTime();
         _loc2_ = this.skipOverflowAd(param1,_loc2_,_loc3_);
         return this.checkPaddingAd(_loc2_,_loc3_);
      }
      
      public function toXML() : XMLNode
      {
         var _loc2_:XMLNode = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:XMLNode = null;
         var _loc7_:String = null;
         var _loc8_:XMLNode = null;
         var _loc1_:XMLNode = new XMLNode(1,InnerConstants.TAG_TEMPORAL_AD_SLOT);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_PROFILE,this.slotProfile,_loc1_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_CUSTOM_ID,this.customId,_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_WIDTH,this._context.adManagerContext.playerEnvironment.temporalSlotWidth,_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_HEIGHT,this._context.adManagerContext.playerEnvironment.temporalSlotHeight,_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_TIME_POSITION,this.timePosition,_loc1_);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_AD_UNIT,this.adUnit,_loc1_,true);
         if(this.maxSlotDuration > 0)
         {
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_MAX_SLOT_DURATION,this.maxSlotDuration,_loc1_);
         }
         if(this.minSlotDuration > 0)
         {
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_MIN_SLOT_DURATION,this.minSlotDuration,_loc1_);
         }
         if(this.cuePointSequence > 0)
         {
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_TEMPORAL_AD_SLOT_CUE_POINT_SEQUENCE,this.cuePointSequence,_loc1_,true);
         }
         if(this.acceptPrimaryContentType.length > 0 || this.acceptContentType.length > 0)
         {
            _loc2_ = new XMLNode(1,InnerConstants.TAG_CONTENT_TYPES);
            _loc3_ = 0;
            while(_loc3_ < this.acceptPrimaryContentType.length)
            {
               _loc5_ = SuperString.trim(this.acceptPrimaryContentType[_loc3_]);
               if(!SuperString.isNull(_loc5_))
               {
                  _loc6_ = new XMLNode(1,InnerConstants.TAG_ACCEPT_PRIMARY_CONTENT_TYPE);
                  XMLUtils.addStringAttribute(InnerConstants.ATTR_ACCEPT_PRIMARY_CONTENT_TYPE_ID,_loc5_,_loc6_,true);
                  _loc2_.appendChild(_loc6_);
               }
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.acceptContentType.length)
            {
               _loc7_ = SuperString.trim(this.acceptContentType[_loc4_]);
               if(!SuperString.isNull(_loc7_))
               {
                  _loc8_ = new XMLNode(1,InnerConstants.TAG_ACCEPT_CONTENT_TYPE);
                  XMLUtils.addStringAttribute(InnerConstants.ATTR_ACCEPT_CONTENT_TYPE_ID,_loc7_,_loc8_,true);
                  _loc2_.appendChild(_loc8_);
               }
               _loc4_++;
            }
            _loc1_.appendChild(_loc2_);
         }
         return _loc1_;
      }
      
      override protected function initStateMachine() : void
      {
         super.initStateMachine();
         sm.addState(SlotState.STOPPING,{
            "enter":onStoppingEnter,
            "from":[SlotState.PRELOADING,SlotState.PLAYING,SlotState.PAUSED]
         });
         sm.addState(SlotState.STOPPED,{
            "enter":this.onStoppedEnter,
            "from":"*"
         });
         sm.addState(SlotState.PRELOADING,{
            "enter":onPreloadingEnter,
            "from":SlotState.STOPPED
         });
         sm.addState(SlotState.PLAYING,{
            "enter":this.onPlayingEnter,
            "from":"*"
         });
         sm.addState(SlotState.PAUSED,{
            "enter":this.onPausedEnter,
            "from":SlotState.PLAYING
         });
         sm.initialState = SlotState.STOPPED;
      }
      
      private function skipOverflowAd(param1:AdInstance, param2:AdInstance, param3:Number) : AdInstance
      {
         if(this.state == SlotState.PLAYING && (!param1 || param1.chainBehavior && param1.chainBehavior.relatedSlotState() == SlotState.PLAYING) && this._context.adManagerContext.requestMode == Constants.instance.REQUEST_MODE_LIVE && this.timePositionClass != Constants.instance.TIME_POSITION_CLASS_OVERLAY && this._context.requestContext.getParameter(InnerConstants.PARAM_SKIP_OVERFLOW_AD_IN_LIVE) == "true")
         {
            while(param2 && !param2.isPaddingAd() && !isNaN(param3) && param2.getTotalDuration(true) > param3)
            {
               param2.sendErrorCallback(InnerConstants.ERROR_OVERFLOW_SKIPPED,"skipped as overflow ad, slot remaining time " + param3 + ", ad duration " + param2.getTotalDuration(true));
               param2 = this.findNextPlayableAd(param2);
            }
         }
         return param2;
      }
      
      public function getRemainingTime() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = !!this.startTime ? (new Date().getTime() - this.startTime.getTime()) / 1000 : NaN;
         if(!isNaN(_loc2_) && this.maxSlotDuration > 0)
         {
            _loc1_ = this.maxSlotDuration - _loc2_;
         }
         return _loc1_;
      }
      
      override public function play(param1:String = null, param2:uint = 0) : void
      {
         if(param1 != null)
         {
            this.playFromAd(param1,param2);
         }
         else
         {
            sm.tryChangeStateToInOrder([SlotState.PLAYING]);
         }
      }
      
      override public function getType() : String
      {
         return Constants.instance.SLOT_TYPE_TEMPORAL;
      }
      
      override public function setBounds(param1:int, param2:int, param3:uint, param4:uint) : void
      {
         super.setBounds(param1,param2,param3,param4);
         this.resize();
      }
      
      private function playFromAd(param1:String, param2:uint) : void
      {
         var _loc5_:AdChain = null;
         var _loc6_:AdInstance = null;
         var _loc7_:String = null;
         var _loc8_:AdInstance = null;
         this.slaveMode = true;
         var _loc3_:AdInstance = null;
         var _loc4_:AdInstance = null;
         this.play();
         for each(_loc5_ in this.adChains)
         {
            for each(_loc6_ in _loc5_.adInstances)
            {
               if((_loc7_ = _loc6_.adId + "_" + _loc6_.adReplicaId) == param1)
               {
                  _loc4_ = _loc6_;
                  break;
               }
               _loc6_.storeAdMetaData();
            }
            if(_loc4_)
            {
               if(param2 != Constants.instance.AD_COMPLETED)
               {
                  for each(_loc8_ in _loc5_.adInstances)
                  {
                     if(_loc8_ == _loc4_)
                     {
                        break;
                     }
                     _loc8_.markFailed();
                  }
               }
               break;
            }
            _loc3_ = _loc5_.adInstances[_loc5_.adInstances.length - 1];
         }
         if(_loc4_)
         {
            this.playNextAdBasedOnTargetAdState(_loc4_,_loc3_,param2);
         }
         else
         {
            this.playFromFirstAd();
         }
      }
      
      override public function getEmbeddedAdsDuration() : Number
      {
         return this.embeddedAdsDuration;
      }
      
      override public function getBase() : Sprite
      {
         if(this.slotBase)
         {
            return this.slotBase;
         }
         return this._context.adManagerContext.playerEnvironment.temporalSlotBase;
      }
      
      override protected function onPlayingEnter(param1:StateMachineEvent) : void
      {
         var _loc2_:AdInstance = null;
         if(param1.fromState != SlotState.PAUSED)
         {
            if(this.slaveMode)
            {
               dispatchSlotEvent(Constants.instance.EVENT_SLOT_STARTED);
               return;
            }
            this.startTime = new Date();
            super.onPlayingEnter(param1);
         }
         else
         {
            _loc2_ = getShowingAd();
            if(_loc2_)
            {
               _loc2_.play();
            }
         }
      }
      
      override public function getTimePositionClass() : String
      {
         return this._timePositionClass;
      }
      
      override public function setVisible(param1:Boolean) : void
      {
      }
      
      protected function getTPCByAdUnit(param1:String) : String
      {
         var _loc6_:Number = NaN;
         var _loc2_:Array = [Constants.instance.ADUNIT_SUBSESSION_PREROLL,Constants.instance.ADUNIT_SUBSESSION_POSTROLL,Constants.instance.ADUNIT_PAUSE_MIDROLL];
         var _loc3_:Array = [Constants.instance.TIME_POSITION_CLASS_PREROLL,Constants.instance.TIME_POSITION_CLASS_POSTROLL,Constants.instance.TIME_POSITION_CLASS_PAUSE_MIDROLL];
         var _loc4_:String = null;
         var _loc5_:Number = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(SuperString.equalsIgnoreCase(_loc2_[_loc5_],param1))
            {
               _loc4_ = String(_loc3_[_loc5_]);
            }
            _loc5_++;
         }
         if(_loc4_ == null)
         {
            _loc6_ = 0;
            while(_loc6_ < BaseSlot.TIME_POSITION_CLASSES.length)
            {
               if(SuperString.equalsIgnoreCase(BaseSlot.TIME_POSITION_CLASSES[_loc6_],param1))
               {
                  _loc4_ = String(BaseSlot.TIME_POSITION_CLASSES[_loc6_]);
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      override public function getEndTimePosition() : Number
      {
         return this.endTimePosition;
      }
      
      override public function drawSlotBackground() : void
      {
         if(this._timePositionClass != Constants.instance.TIME_POSITION_CLASS_OVERLAY && this._timePositionClass != Constants.instance.TIME_POSITION_CLASS_PAUSE_MIDROLL && Boolean(this.getBase()))
         {
            if(this.background == null)
            {
               this.background = new Shape();
               this.background.graphics.beginFill(0);
               this.background.graphics.drawRect(this.getBounds().x,this.getBounds().y,this.getBounds().width,this.getBounds().height);
               this.background.graphics.endFill();
               this.getBase().addChildAt(this.background,0);
            }
            else
            {
               this.getBase().setChildIndex(this.background,0);
            }
         }
      }
      
      public function resize() : void
      {
         if(this.isShowing())
         {
            this.removeSlotBackground();
            this.drawSlotBackground();
         }
         var _loc1_:AdInstance = getShowingAd();
         if(_loc1_)
         {
            _loc1_.resize();
         }
         if(this.isShowing())
         {
            this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_PLAYING_SLOT_RESIZED,this.customId);
         }
      }
      
      override public function parseXML(param1:XMLNode) : void
      {
         if(this.getAcceptance() == Constants.instance.SLOT_ACCEPTANCE_GENERATED)
         {
            this.customId = param1.attributes[InnerConstants.ATTR_CUSTOM_ID];
            this.adUnit = param1.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_AD_UNIT];
            this.timePosition = param1.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_TIME_POSITION];
         }
         var _loc2_:String = String(param1.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_EMBEDDED_ADS_DURATION]);
         this.embeddedAdsDuration = _loc2_ && _loc2_ != "" && Number(_loc2_) >= 0 ? Number(_loc2_) : -1;
         var _loc3_:String = String(param1.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_END_TIME_POSITION]);
         this.endTimePosition = _loc3_ && _loc3_ != "" && Number(_loc3_) >= this.timePosition ? Number(_loc3_) : -1;
         super.parseXML(param1);
      }
      
      protected function onPausedEnter(param1:StateMachineEvent) : void
      {
         var _loc2_:AdInstance = getShowingAd();
         if(_loc2_)
         {
            _loc2_.pause();
         }
      }
      
      private function stopActivePaddingAd(param1:TimerEvent = null) : void
      {
         var _loc2_:AdInstance = this.getAllAdInstances().pop();
         if(_loc2_.isPaddingAd() && _loc2_.isActive())
         {
            _loc2_.stop();
         }
      }
      
      public function removeSlotBackground() : void
      {
         if(Boolean(this.background) && Boolean(this.getBase()))
         {
            this.getBase().removeChild(this.background);
            this.background = null;
         }
      }
      
      private function checkPaddingAd(param1:AdInstance, param2:Number) : AdInstance
      {
         var _loc3_:Number = NaN;
         if(param1 && param1.isPaddingAd() && this.state == SlotState.PLAYING)
         {
            _loc3_ = Number(Number(this._context.requestContext.getParameter(InnerConstants.PARAM_PADDING_AD_MIN_DURATION)) || DEFAULT_PADDING_AD_MIN_DURATION);
            if(!isNaN(param2) && param2 >= _loc3_)
            {
               this.paddingAdStopTimer.reset();
               this.paddingAdStopTimer.delay = param2 * 1000;
               this.paddingAdStopTimer.start();
               param1.creative.duration = param2;
            }
            else
            {
               param1 = null;
            }
         }
         return param1;
      }
      
      private function playNextAdBasedOnTargetAdState(param1:AdInstance, param2:AdInstance, param3:uint) : void
      {
         if(param3 == Constants.instance.AD_COMPLETED)
         {
            param1.chainBehavior = ChainBehavior.getPlayBehavior();
            param1.markImprSent();
            param1.storeAdMetaData();
            this.notifyAdDone(param1);
         }
         else if(param3 == Constants.instance.AD_FAILED)
         {
            param1.chainBehavior = ChainBehavior.getPlayBehavior();
            param1.markFailed();
            this.notifyAdDone(param1);
         }
         else if(param2)
         {
            param2.chainBehavior = ChainBehavior.getPlayBehavior();
            this.notifyAdDone(param2);
         }
         else
         {
            this.playFromFirstAd();
         }
      }
      
      override public function pause(param1:Boolean = true) : void
      {
         var _loc2_:AdInstance = null;
         if(param1)
         {
            _loc2_ = getShowingAd();
            if(_loc2_)
            {
               if(!_loc2_.isBumper())
               {
                  sm.tryChangeStateTo(SlotState.PAUSED);
               }
            }
         }
         else if(sm.state == SlotState.PAUSED)
         {
            sm.tryChangeStateTo(SlotState.PLAYING);
         }
      }
   }
}
