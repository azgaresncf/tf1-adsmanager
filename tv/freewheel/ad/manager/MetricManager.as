package tv.freewheel.ad.manager
{
   import flash.events.TimerEvent;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.callback.AdEventCallback;
   import tv.freewheel.ad.callback.BasicEventCallback;
   import tv.freewheel.ad.callback.ClickEventCallback;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.basic.SuperObject;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.timer.FWTimer;
   
   public class MetricManager
   {
      
      private static const CAPABILITY_DEFAULTIMPRESSION:int = -3;
      
      private static const CAPABILITY_ADPLAYBACKTRACK:int = -2;
      
      private static const CAPABILITY_ADPLAYSTATECHANGE:int = -5;
      
      private static var logger:ILogger = Log.getLogger("AdManager.MetricManager");
      
      private static const CAPABILITY_IMPRESSION_END:int = -8;
      
      private static var __defaultPlayStateCapability:uint = 32;
      
      private static const CAPABILITY_VIDEOSTATUSCONTROL:int = -1;
      
      private static var __defaultVolumeCapability:uint = 8;
      
      private static const CAPABILITY_ADSIZECHANGE:int = -7;
      
      private static var NEGATIVE_CLICK_METR:uint = 1024;
      
      private static const CAPABILITY_DEFAULTCLICK:int = -4;
      
      private static var __quartileCapability:uint = 1 | 2 | 4 | 64;
      
      private static const CAPABILITY_ADVOLUMECHANGE:int = -6;
      
      private static const CAPABILITY_MEASUREMENT:int = -9;
      
      private static var __constants:Array = [[Constants.instance.RENDERER_CAPABILITY_ADPLAYSTATECHANGE,Constants.instance.RENDERER_CAPABILITY_ADVOLUMECHANGE,Constants.instance.RENDERER_CAPABILITY_ADSIZECHANGE,Constants.instance.RENDERER_CAPABILITY_VIDEOSTATUSCONTROL,Constants.instance.RENDERER_CAPABILITY_ADPLAYBACKTRACK,Constants.instance.RENDERER_EVENT_IMPRESSION,Constants.instance.RENDERER_EVENT_IMPRESSION_END,Constants.instance.RENDERER_EVENT_CLICK,Constants.instance.RENDERER_EVENT_MEASUREMENT,Constants.instance.RENDERER_CAPABILITY_QUARTILE,Constants.instance.RENDERER_EVENT_FIRSTQUARTILE,Constants.instance.RENDERER_EVENT_THIRDQUARTILE,Constants.instance.RENDERER_EVENT_MIDPOINT,Constants.instance.RENDERER_EVENT_COMPLETE,Constants.instance.RENDERER_EVENT_MUTE,Constants.instance.RENDERER_EVENT_UNMUTE,Constants.instance.RENDERER_EVENT_COLLAPSE,Constants.instance.RENDERER_EVENT_EXPAND,Constants.instance.RENDERER_EVENT_PAUSE,Constants.instance.RENDERER_EVENT_RESUME,Constants.instance.RENDERER_EVENT_REWIND,Constants.instance.RENDERER_EVENT_ACCEPTINVITATION,Constants.instance.RENDERER_EVENT_CLOSE,Constants.instance.RENDERER_EVENT_MINIMIZE],[CAPABILITY_ADPLAYSTATECHANGE.toString(),CAPABILITY_ADVOLUMECHANGE.toString(),CAPABILITY_ADSIZECHANGE.toString(),CAPABILITY_VIDEOSTATUSCONTROL.toString(),CAPABILITY_ADPLAYBACKTRACK.toString(),CAPABILITY_DEFAULTIMPRESSION + ",defaultImpression:i:-1",CAPABILITY_IMPRESSION_END + ",adEnd:i:-1",CAPABILITY_DEFAULTCLICK + ",defaultClick:c:-1",CAPABILITY_MEASUREMENT + ",concreteEvent:i:-1","1|2|4","1|2|4,firstQuartile:i:1","1|2|4,thirdQuartile:i:1","2|4,midPoint:i:2","4,complete:i:4","8,_mute:s:8","8,_un-mute:s:8","16,_collapse:s:16","16,_expand:s:16","32,_pause:s:32","32,_resume:s:32","64,_rewind:s:64","128,_accept-invitation:s:128","256,_close:s:256","512,_minimize:s:512"]];
      
      private static var __events:HashMap = new HashMap(__constants[0],__constants[1]);
      
      private static var __defaultSizeCapability:uint = 16;
      
      private static var __defaultEventMetricMap:HashMap = new HashMap([CAPABILITY_ADPLAYBACKTRACK,CAPABILITY_ADPLAYSTATECHANGE,CAPABILITY_ADVOLUMECHANGE,CAPABILITY_ADSIZECHANGE],[__quartileCapability,__defaultPlayStateCapability,__defaultVolumeCapability,__defaultSizeCapability]);
       
      
      private var _quartileTimer:FWTimer;
      
      private var _defaultMetricCapability:uint = 0;
      
      private var _currentClickEventCallback:ClickEventCallback;
      
      private var _eventCallbackKeyValues:HashMap;
      
      private var _metricCapability:uint = 0;
      
      private var _previousAdPlayheadTime:Number = 0;
      
      private var _hasPlaybackCapability:Boolean = false;
      
      private var _deltaValueManager:DeltaValueManager;
      
      private var _quartileStatus:Object;
      
      private var _hasImpressionEndCapability:Boolean = false;
      
      private var _hasImpressionCapability:Boolean = false;
      
      private var _adInstance:AdInstance;
      
      private var _hasRendererVideoControlCapability:Boolean = false;
      
      public function MetricManager(param1:AdInstance)
      {
         super();
         this._adInstance = param1;
         this._quartileStatus = new Object();
         this._eventCallbackKeyValues = new HashMap();
         this.setDefaultChangeCapabilities(this._adInstance.slot);
         this._deltaValueManager = new DeltaValueManager(this._adInstance.id);
      }
      
      private function updateClickEventCallback(param1:ClickEventCallback, param2:Boolean, param3:Object) : void
      {
         if(!param2)
         {
            if(param3.urloverride != null && String(param3.urloverride).indexOf("://") > -1)
            {
               param1.urlOverride = param3.urloverride;
            }
            if(param3.showbrowser != null)
            {
               param1.showBrowser = param3.showbrowser;
            }
         }
      }
      
      public function stop() : void
      {
         if(this._quartileTimer != null)
         {
            this.sendMissingQuartiles();
            this.disposeTimer();
         }
      }
      
      public function getDeltaValue() : uint
      {
         return this._deltaValueManager.tick();
      }
      
      public function getEventCallbackKeyValues() : HashMap
      {
         return this._eventCallbackKeyValues;
      }
      
      public function setCapability(param1:uint, param2:Boolean, param3:Object = null) : Boolean
      {
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         if(!__events.get(param1.toString()))
         {
            logger.warn(this + "setCapability(): Your metric is not valid");
            return false;
         }
         var _loc4_:Array;
         if((_loc4_ = String(__events.get(param1.toString())).split(","))[1] != null)
         {
            if((_loc7_ = SuperObject.convertAttributesToCaseInsensitive(param3)).callbackurls == null || _loc7_.callbackurls is Array)
            {
               _loc9_ = String((_loc8_ = _loc4_[1].split(":"))[0]);
               _loc10_ = BasicEventCallback.getEventTypeByShortEventType(_loc8_[1]);
               if(param1 == Constants.instance.RENDERER_EVENT_CLICK)
               {
                  _loc10_ = Constants.instance.EVENTCALLBACK_TYPE_CLICKTRACKING;
               }
               this.callbackManager.appendURLs(_loc9_,_loc10_,_loc7_.callbackurls);
            }
         }
         var _loc5_:Array = String(_loc4_[0]).split("|");
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_.length)
         {
            if((_loc11_ = int(_loc5_[_loc6_])) > 0)
            {
               this.updateCapability(param2,_loc11_);
            }
            else if(_loc11_ == CAPABILITY_VIDEOSTATUSCONTROL)
            {
               this._hasRendererVideoControlCapability = param2;
            }
            else if(_loc11_ == CAPABILITY_ADPLAYBACKTRACK)
            {
               this._hasPlaybackCapability = param2;
               this.updateDefaultCapability(_loc11_,param2);
            }
            else if(_loc11_ == CAPABILITY_DEFAULTIMPRESSION)
            {
               this._hasImpressionCapability = param2;
            }
            else if(_loc11_ == CAPABILITY_IMPRESSION_END)
            {
               this._hasImpressionEndCapability = param2;
            }
            else if(_loc11_ == CAPABILITY_DEFAULTCLICK)
            {
               this.updateCapability(!param2,NEGATIVE_CLICK_METR);
            }
            else if(_loc11_ == CAPABILITY_ADPLAYSTATECHANGE || _loc11_ == CAPABILITY_ADVOLUMECHANGE || _loc11_ == CAPABILITY_ADSIZECHANGE)
            {
               this.updateDefaultCapability(_loc11_,param2);
            }
            _loc6_++;
         }
         return true;
      }
      
      public function dispose() : void
      {
         this.disposeTimer();
         this._deltaValueManager = null;
         this._eventCallbackKeyValues = null;
         this._currentClickEventCallback = null;
      }
      
      private function listenQuartileEvents(param1:TimerEvent) : void
      {
         var _loc2_:Number = this.getAdPlayheadTime();
         if(_loc2_ < 0)
         {
            return;
         }
         if(_loc2_ < this._previousAdPlayheadTime)
         {
            this.processDefaultEvent(Constants.instance.RENDERER_EVENT_REWIND);
         }
         this._previousAdPlayheadTime = _loc2_;
         var _loc3_:Number = _loc2_ / this.getAdDuration();
         this.sendQuartiles(_loc3_);
      }
      
      public function getMetric() : uint
      {
         var _loc1_:uint = this._metricCapability;
         switch(this._adInstance.getSlot().getType())
         {
            case Constants.instance.SLOT_TYPE_SITESECTION_NONTEMPORAL:
            case Constants.instance.SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL:
            case Constants.instance.SLOT_TYPE_TEMPORAL:
               _loc1_ |= this._defaultMetricCapability;
         }
         return _loc1_;
      }
      
      public function adManagerControlMainVideoPause() : Boolean
      {
         return !this.getHasRendererVideoControlCapability();
      }
      
      public function get callbackManager() : CallbackManager
      {
         return this._adInstance.getCallbackManager();
      }
      
      private function sendQuartiles(param1:Number) : void
      {
         if(param1 >= 0.25 && !this._quartileStatus.firstQuartile)
         {
            this._quartileStatus.firstQuartile = true;
            this.processDefaultEvent(Constants.instance.RENDERER_EVENT_FIRSTQUARTILE);
         }
         if(param1 >= 0.5 && !this._quartileStatus.midPoint)
         {
            this._quartileStatus.midPoint = true;
            this.processDefaultEvent(Constants.instance.RENDERER_EVENT_MIDPOINT);
         }
         if(param1 >= 0.75 && !this._quartileStatus.thirdQuartile)
         {
            this._quartileStatus.thirdQuartile = true;
            this.processDefaultEvent(Constants.instance.RENDERER_EVENT_THIRDQUARTILE);
         }
         if(param1 >= 0.99 && !this._quartileStatus.complete)
         {
            this._quartileStatus.complete = true;
            this.processDefaultEvent(Constants.instance.RENDERER_EVENT_COMPLETE);
            this.disposeTimer();
         }
      }
      
      private function sendMissingQuartiles() : void
      {
         var _loc1_:Number = this.getAdDuration() * 0.1;
         if(_loc1_ > 5)
         {
            _loc1_ = 5;
         }
         var _loc2_:Number = this.getAdPlayheadTime();
         if(_loc2_ < 0)
         {
            _loc2_ = this._previousAdPlayheadTime;
         }
         if(this._hasPlaybackCapability && this.getAdDuration() - _loc2_ < _loc1_)
         {
            this.sendQuartiles(1);
         }
      }
      
      public function setEventCallbackKeyValue(param1:String, param2:String) : void
      {
         if(param2 == null)
         {
            this._eventCallbackKeyValues.remove(param1);
         }
         else
         {
            this._eventCallbackKeyValues.put(param1,param2);
         }
      }
      
      private function getAdPlayheadTime() : Number
      {
         var value:Number = -1;
         try
         {
            value = this._adInstance.renderer.getPlayheadTime();
         }
         catch(e:Error)
         {
            logger.error("Renderer.getAdPlayheadTime got an error: " + e.message);
         }
         return value;
      }
      
      private function callback(param1:uint, param2:Boolean, param3:Object = null) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc7_:Object = null;
         param3 = SuperObject.convertAttributesToCaseInsensitive(param3);
         if(param1 == Constants.instance.RENDERER_EVENT_CUSTOM)
         {
            if(SuperString.isNull(param3.customeventname))
            {
               return;
            }
            _loc4_ = String(param3.customeventname);
            _loc5_ = Constants.instance.EVENTCALLBACK_TYPE_ACTION;
         }
         else
         {
            if((_loc7_ = this.getEventNameAndFullType(param1,param2)) == null)
            {
               return;
            }
            if(param1 == Constants.instance.RENDERER_EVENT_MEASUREMENT)
            {
               if(!param3 || !param3.hasOwnProperty("concreteeventid") || typeof param3.concreteeventid != "string" || SuperString.isNull(param3.concreteeventid))
               {
                  return;
               }
            }
            _loc4_ = String(_loc7_.eventName);
            _loc5_ = String(_loc7_.eventFullType);
            if(!SuperString.isNull(param3.customeventname))
            {
               if(param1 == Constants.instance.RENDERER_EVENT_CLICK)
               {
                  _loc4_ = String(param3.customeventname);
               }
            }
         }
         if(param1 == Constants.instance.RENDERER_EVENT_PAUSE)
         {
            this._deltaValueManager.pause();
         }
         if(param1 == Constants.instance.RENDERER_EVENT_RESUME)
         {
            this._deltaValueManager.play();
         }
         var _loc6_:AdEventCallback;
         if((_loc6_ = this._adInstance.getCallbackManager().getAdEventCallback(param1,_loc4_,_loc5_,param3)) == null)
         {
            logger.error(this + "callback() " + "cannot get AdEventCallback");
            return;
         }
         if(_loc6_.getType() == BasicEventCallback.TYPE_CLICK)
         {
            this._currentClickEventCallback = ClickEventCallback(_loc6_);
            this.updateClickEventCallback(ClickEventCallback(_loc6_),param2,param3);
         }
         _loc6_.process();
      }
      
      private function updateCapability(param1:Boolean, param2:uint) : void
      {
         this._metricCapability = param1 ? uint(this._metricCapability | param2) : uint(this._metricCapability & ~param2);
      }
      
      private function getAdDuration() : Number
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = this._adInstance.getTotalDuration(true);
         if(_loc1_ <= 0)
         {
            _loc1_ = 1;
         }
         if(this._hasPlaybackCapability && this._adInstance.slot.getType() == Constants.instance.SLOT_TYPE_TEMPORAL)
         {
            _loc2_ = _loc1_ * 50;
            if(_loc2_ > 1000 || _loc2_ <= 0)
            {
               _loc2_ = 1000;
            }
            if(this._quartileTimer != null)
            {
               this._quartileTimer.removeEventListener(TimerEvent.TIMER,this.listenQuartileEvents);
               this._quartileTimer.stop();
               this._quartileTimer = null;
            }
            this._quartileTimer = new FWTimer(_loc2_,0);
            this._quartileTimer.addEventListener(TimerEvent.TIMER,this.listenQuartileEvents);
            this._quartileTimer.start();
         }
         return _loc1_;
      }
      
      public function getHasRendererVideoControlCapability() : Boolean
      {
         return this._hasRendererVideoControlCapability;
      }
      
      private function getEventNameAndFullType(param1:uint, param2:Boolean) : Object
      {
         if(__events.get(param1.toString()) == null)
         {
            logger.warn(this + "getEventNameAndFullType(" + param1 + "). Event is invalid");
            return null;
         }
         var _loc3_:String = String(String(__events.get(param1.toString())).split(",")[1]);
         if(_loc3_ == null)
         {
            logger.warn(this + "getEventNameAndFullType(" + param1 + "). Event is invalid");
            return null;
         }
         var _loc4_:Array;
         var _loc5_:int = int((_loc4_ = _loc3_.split(":"))[2]);
         if(param2)
         {
            if(_loc5_ < 0)
            {
               if(param1 == Constants.instance.RENDERER_EVENT_IMPRESSION && this._hasImpressionCapability)
               {
                  return null;
               }
               if(param1 == Constants.instance.RENDERER_EVENT_IMPRESSION_END && this._hasImpressionEndCapability)
               {
                  return null;
               }
            }
            else
            {
               if(this._metricCapability & _loc5_)
               {
                  return null;
               }
               if(!(this._defaultMetricCapability & _loc5_))
               {
                  return null;
               }
            }
         }
         else if(_loc5_ < 0)
         {
            if(param1 == Constants.instance.RENDERER_EVENT_IMPRESSION && !this._hasImpressionCapability)
            {
               logger.warn(this + "getEventNameAndFullType() " + _loc4_[0] + " capability is set to false");
            }
            if(param1 == Constants.instance.RENDERER_EVENT_CLICK && Boolean(this._metricCapability & NEGATIVE_CLICK_METR))
            {
               logger.warn(this + "getEventNameAndFullType() " + _loc4_[0] + " capability is set to false");
            }
         }
         else if(!(this._metricCapability & _loc5_))
         {
            logger.warn(this + "getEventNameAndFullType() " + _loc4_[0] + " capability is set to false");
         }
         return {
            "eventName":_loc4_[0],
            "eventFullType":BasicEventCallback.getEventTypeByShortEventType(_loc4_[1])
         };
      }
      
      private function setDefaultChangeCapabilities(param1:ISlot) : void
      {
         if(param1.getType() == Constants.instance.SLOT_TYPE_TEMPORAL)
         {
            this.updateDefaultCapability(CAPABILITY_ADPLAYSTATECHANGE,true);
            if(param1.getTimePositionClass() != Constants.instance.TIME_POSITION_CLASS_OVERLAY)
            {
               this.updateDefaultCapability(CAPABILITY_ADVOLUMECHANGE,true);
               this.updateDefaultCapability(CAPABILITY_ADSIZECHANGE,true);
            }
         }
      }
      
      private function disposeTimer() : void
      {
         if(this._quartileTimer != null)
         {
            this._quartileTimer.removeEventListener(TimerEvent.TIMER,this.listenQuartileEvents);
            this._quartileTimer.stop();
            this._quartileTimer = null;
         }
      }
      
      public function processDefaultEvent(param1:uint) : void
      {
         this.callback(param1,true);
      }
      
      public function start() : void
      {
         this.getAdDuration();
         this.processDefaultEvent(Constants.instance.RENDERER_EVENT_IMPRESSION);
      }
      
      public function processEvent(param1:uint, param2:Object = null) : void
      {
         this.callback(param1,false,param2);
      }
      
      public function toString() : String
      {
         return "MetricManager(" + this._adInstance.id + ") ";
      }
      
      private function updateDefaultCapability(param1:int, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         if(__defaultEventMetricMap.get(param1.toString()))
         {
            _loc3_ = __defaultEventMetricMap.get(param1.toString());
            this._defaultMetricCapability = param2 ? uint(this._defaultMetricCapability | _loc3_) : uint(this._defaultMetricCapability & ~_loc3_);
         }
      }
      
      public function getCurrentClickEventCallback() : ClickEventCallback
      {
         return this._currentClickEventCallback;
      }
   }
}
