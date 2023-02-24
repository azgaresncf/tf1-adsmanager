package tv.freewheel.playerextension
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class VideoResumeMonitor extends BaseMonitor
   {
       
      
      private var timeoutTimer:Timer = null;
      
      private var watching:Boolean = false;
      
      private var prerollSlotIds:Array;
      
      public function VideoResumeMonitor()
      {
         this.prerollSlotIds = [];
         super();
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         this.log("onTimeout()");
         if(am.getVideoPlayStatus() != consts.VIDEO_STATUS_PLAYING)
         {
            this.reportError(consts.ERROR_UNKNOWN,"Content video did NOT resume 5 seconds after all preroll slots end");
         }
      }
      
      private function onRequestComplete(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         this.log("onRequestComplete()");
         if(param1.success)
         {
            _loc2_ = this.am.getTemporalSlots();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if((_loc4_ = _loc2_[_loc3_]).getTimePositionClass() == consts.TIME_POSITION_CLASS_PREROLL)
               {
                  this.log("onRequestComplete, got preroll slot " + _loc4_.getCustomId());
                  this.prerollSlotIds.push(_loc4_.getCustomId());
               }
               _loc3_++;
            }
            this.watching = true;
         }
      }
      
      override public function refresh() : void
      {
         this.log("refresh()");
         super.refresh();
         this.prerollSlotIds = [];
         this.watching = false;
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
         }
      }
      
      private function log(param1:String) : void
      {
      }
      
      override public function init(param1:Object) : void
      {
         super.init(param1);
         this.log("init()");
         this.timeoutTimer = new Timer(5000,1);
         this.am.addEventListener(consts.EVENT_REQUEST_COMPLETE,this.onRequestComplete);
         this.am.addEventListener(consts.EVENT_SLOT_ENDED,this.onSlotEnded);
         this.am.addEventListener(consts.EVENT_VIDEO_PLAY_STATUS_CHANGED,this.onVideoPlayStatusChanged);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
      }
      
      private function onVideoPlayStatusChanged(param1:Object) : void
      {
         this.log("onVideoPlayStatusChanged, videoPlayStatus is " + param1.videoPlayStatus);
         if(param1.videoPlayStatus == consts.VIDEO_STATUS_PLAYING)
         {
            this.log("onVideoPlayStatusChanged, content video playing, refresh");
            this.refresh();
         }
      }
      
      override protected function reportError(param1:Number, param2:String) : void
      {
         this.log("reportError " + param2);
         super.reportError(param1,param2);
         this.refresh();
      }
      
      private function onSlotEnded(param1:Object) : void
      {
         var slot:Object = null;
         var e:Object = param1;
         this.log("onSlotEnded, slot " + e.slotCustomId + " ended");
         if(this.watching)
         {
            slot = this.am.getSlotByCustomId(e.slotCustomId);
            if(Boolean(slot) && slot.getTimePositionClass() == consts.TIME_POSITION_CLASS_PREROLL)
            {
               this.prerollSlotIds = this.prerollSlotIds.filter(function(param1:Object, param2:int, param3:Array):Boolean
               {
                  return e.slotCustomId != String(param1);
               },this);
               this.tryStartTimer();
            }
         }
      }
      
      private function tryStartTimer() : void
      {
         if(this.prerollSlotIds.length > 0)
         {
            this.log("tryStartTimer, don\'t start timer because there is still unplayed preroll slots " + this.prerollSlotIds.join(","));
         }
         else if(am.getVideoPlayStatus() == consts.VIDEO_STATUS_PLAYING)
         {
            this.log("tryStartTimer, don\'t start timer because video play status is playing");
         }
         else
         {
            this.log("tryStartTimer, start timer");
            this.timeoutTimer.start();
         }
      }
      
      override public function dispose() : void
      {
         this.log("dispose()");
         super.dispose();
         if(this.am)
         {
            this.am.removeEventListener(consts.EVENT_REQUEST_COMPLETE,this.onRequestComplete);
            this.am.removeEventListener(consts.EVENT_SLOT_STARTED,this.onSlotEnded);
            this.am.removeEventListener(consts.EVENT_VIDEO_PLAY_STATUS_CHANGED,this.onVideoPlayStatusChanged);
            this.am = null;
         }
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
            this.timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
            this.timeoutTimer = null;
         }
      }
   }
}
