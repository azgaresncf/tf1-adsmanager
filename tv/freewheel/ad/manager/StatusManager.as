package tv.freewheel.ad.manager
{
   import flash.events.TimerEvent;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.callback.VideoViewEventCallback;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.timer.FWTimer;
   
   public class StatusManager
   {
      
      public static const REPORT_INTERVAL:Array = [5,10,15,30,60,120,180,300];
      
      public static const PLAYING:Number = Constants.instance.VIDEO_STATUS_PLAYING;
      
      public static const COMPLETED:Number = Constants.instance.VIDEO_STATUS_COMPLETED;
      
      public static const STOPPED:Number = Constants.instance.VIDEO_STATUS_STOPPED;
      
      public static const PAUSED:Number = Constants.instance.VIDEO_STATUS_PAUSED;
       
      
      private var statusTimer:FWTimer;
      
      private var isPrepared:Boolean = false;
      
      private var callbackQueue:Array;
      
      private var _deltaValueManager:DeltaValueManager;
      
      private var interval_index:Number = -1;
      
      private var checkTimer:FWTimer;
      
      private var isVideoViewRequested:Boolean = false;
      
      private var _context:Contexts;
      
      private var isInited:Boolean = false;
      
      public var playState:uint;
      
      private var _videoViewEventCallback:VideoViewEventCallback;
      
      public function StatusManager(param1:Contexts)
      {
         super();
         this._context = param1;
         this.interval_index = -1;
         this.playState = Constants.instance.VIDEO_STATUS_UNKNOWN;
         this.callbackQueue = new Array();
         this._deltaValueManager = new DeltaValueManager();
      }
      
      public function setVideoPlayState(param1:uint) : void
      {
         if(Boolean(this.statusTimer) && this.playState != param1)
         {
            switch(param1)
            {
               case Constants.instance.VIDEO_STATUS_PLAYING:
                  this.statusTimer.resume();
                  this._deltaValueManager.play();
                  break;
               case Constants.instance.VIDEO_STATUS_PAUSED:
               case Constants.instance.VIDEO_STATUS_STOPPED:
                  this.sendStatus(true);
                  this.statusTimer.pause();
                  this._deltaValueManager.pause();
                  break;
               case Constants.instance.VIDEO_STATUS_COMPLETED:
                  if(this.playState == Constants.instance.VIDEO_STATUS_PLAYING)
                  {
                     this.sendStatus(true);
                  }
                  this.statusTimer.stop();
            }
         }
         this.playState = param1;
      }
      
      private function nextInterval() : void
      {
         ++this.interval_index;
         if(this.interval_index > REPORT_INTERVAL.length - 1)
         {
            this.interval_index = REPORT_INTERVAL.length - 1;
         }
         if(this.statusTimer)
         {
            this.playState = Constants.instance.VIDEO_STATUS_STOPPED;
            this.statusTimer.dispose();
            this.statusTimer.removeEventListener(TimerEvent.TIMER,this.updateStatus);
            this.statusTimer = null;
         }
         this.statusTimer = new FWTimer(this.getInterval());
         this.statusTimer.addEventListener(TimerEvent.TIMER,this.updateStatus);
         this.statusTimer.start();
         this.playState = Constants.instance.VIDEO_STATUS_PLAYING;
      }
      
      private function getInterval() : Number
      {
         return REPORT_INTERVAL[this.interval_index] * 1000;
      }
      
      public function init() : void
      {
         if(this.isInited || this.playState != Constants.instance.VIDEO_STATUS_PLAYING || this._context.requestContext.isSlaveMode)
         {
            return;
         }
         this.isInited = true;
         this.checkIsPrepared(null);
         this._deltaValueManager.play();
         if(!this.isPrepared)
         {
            this.checkTimer = new FWTimer(1000,0);
            this.checkTimer.addEventListener(TimerEvent.TIMER,this.checkIsPrepared);
            this.checkTimer.start();
         }
      }
      
      public function parseVideoViewCallback(param1:XMLNode) : void
      {
         var _loc2_:Array = EventCallback.parseEventCallbacks(param1);
         this._videoViewEventCallback = VideoViewEventCallback.construct(_loc2_,this._context);
      }
      
      public function setIsVideoViewRequested(param1:Boolean) : void
      {
         this.isVideoViewRequested = param1;
      }
      
      public function updateStatus(param1:TimerEvent) : void
      {
         this.sendStatus(true);
         this.nextInterval();
      }
      
      private function sendStatus(param1:Boolean) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc2_:uint = this._deltaValueManager.tick();
         if(param1 && _loc2_ <= 0)
         {
            return;
         }
         var _loc3_:Object = new Object();
         _loc3_.kv = this.getKeyValueParam();
         _loc3_.ct = _loc2_;
         if(this._videoViewEventCallback != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.callbackQueue.length)
            {
               _loc5_ = this.callbackQueue[_loc4_];
               this._videoViewEventCallback.deltaValue = _loc5_.ct;
               this._videoViewEventCallback.keyValues = _loc5_.kv;
               this._videoViewEventCallback.process();
               _loc4_++;
            }
            this.callbackQueue = new Array();
            this._videoViewEventCallback.deltaValue = _loc3_.ct;
            this._videoViewEventCallback.keyValues = _loc3_.kv;
            this._videoViewEventCallback.process();
         }
         else
         {
            this.callbackQueue.push(_loc3_);
         }
      }
      
      private function getKeyValueParam() : String
      {
         var _loc2_:String = null;
         if(this._context.requestContext.eventCallbackKeyValues.size() <= 0)
         {
            return "";
         }
         var _loc1_:Array = this._context.requestContext.eventCallbackKeyValues.getKeys();
         var _loc3_:String = "";
         _loc2_ = String(_loc1_[0]);
         _loc3_ += encodeURIComponent(_loc2_) + "=" + encodeURIComponent(String(this._context.requestContext.eventCallbackKeyValues.get(_loc2_)));
         var _loc4_:int = 1;
         while(_loc4_ < _loc1_.length)
         {
            _loc2_ = String(_loc1_[_loc4_]);
            _loc3_ += "&" + encodeURIComponent(_loc2_) + "=" + encodeURIComponent(String(this._context.requestContext.eventCallbackKeyValues.get(_loc2_)));
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function dispose() : void
      {
         if(this.checkTimer)
         {
            this.checkTimer.dispose();
            this.checkTimer.removeEventListener(TimerEvent.TIMER,this.checkIsPrepared);
            this.checkTimer = null;
         }
         if(this.statusTimer)
         {
            this.statusTimer.dispose();
            this.statusTimer.removeEventListener(TimerEvent.TIMER,this.updateStatus);
            this.statusTimer = null;
         }
         if(this._videoViewEventCallback != null)
         {
            this._videoViewEventCallback.dispose();
            this._videoViewEventCallback = null;
         }
         this.callbackQueue = null;
      }
      
      private function checkIsPrepared(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = false;
         if(!this.isPrepared)
         {
            _loc2_ = true;
            if(SuperString.isNull(this._context.adManagerContext.va_id) && SuperString.isNull(this._context.adManagerContext.va_customId))
            {
               _loc2_ = false;
            }
            if(this._context.adManagerContext.networkId <= 0)
            {
               _loc2_ = false;
            }
            if(_loc2_)
            {
               if(this.checkTimer)
               {
                  this.checkTimer.dispose();
                  this.checkTimer.removeEventListener(TimerEvent.TIMER,this.checkIsPrepared);
                  this.checkTimer = null;
               }
               this.videoViewRequest();
               this.sendStatus(false);
               this.nextInterval();
               this.isPrepared = true;
            }
         }
      }
      
      private function videoViewRequest() : void
      {
         if(!this.isVideoViewRequested)
         {
            this._context.adManagerContext.capabilities.setCapability(Constants.instance.CAPABILITY_SKIP_AD_SELECTION,true);
            this._context.adManagerContext.capabilities.setCapability(Constants.instance.CAPABILITY_REQUIRES_VIDEO_CALLBACK_URL,true);
            this.isVideoViewRequested = true;
            this._context.requestContext.requestManager.submitVideoViewRequest();
            this._context.adManagerContext.capabilities.setCapability(Constants.instance.CAPABILITY_SKIP_AD_SELECTION,false);
         }
      }
      
      public function getIsVideoViewRequested() : Boolean
      {
         return this.isVideoViewRequested;
      }
   }
}
