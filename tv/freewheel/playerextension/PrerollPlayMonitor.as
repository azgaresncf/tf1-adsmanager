package tv.freewheel.playerextension
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PrerollPlayMonitor extends BaseMonitor
   {
       
      
      private var timeoutTimer:Timer = null;
      
      private var prerollSlotsPlayMap:Object;
      
      public function PrerollPlayMonitor()
      {
         this.prerollSlotsPlayMap = {};
         super();
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         this.log("onTimeout()");
         if(am.getVideoPlayStatus() == consts.VIDEO_STATUS_PLAYING)
         {
            this.assertAnyPlayed();
         }
         else
         {
            this.log("onTimeout: video play status is not playing, don\'t report error");
         }
      }
      
      private function onRequestComplete(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         this.log("onRequestComplete()");
         if(param1.success)
         {
            _loc2_ = false;
            _loc3_ = this.am.getTemporalSlots();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if((_loc5_ = _loc3_[_loc4_]).getTimePositionClass() == consts.TIME_POSITION_CLASS_PREROLL)
               {
                  this.log("onRequestComplete, got preroll slot " + _loc5_.getCustomId());
                  this.prerollSlotsPlayMap[_loc5_.getCustomId()] = false;
                  _loc2_ = true;
               }
               _loc4_++;
            }
            if(_loc2_)
            {
               this.log("onRequestComplete, start timer");
               this.timeoutTimer.start();
            }
            else
            {
               this.log("onRequestComplete, no preroll slots at all, won\'t start timer");
            }
         }
      }
      
      private function onSlotStarted(param1:Object) : void
      {
         this.log("onSlotStarted, slot " + param1.slotCustomId + " is played");
         if(this.prerollSlotsPlayMap[param1.slotCustomId] != undefined)
         {
            this.prerollSlotsPlayMap[param1.slotCustomId] = true;
         }
      }
      
      override public function init(param1:Object) : void
      {
         super.init(param1);
         this.log("init()");
         this.timeoutTimer = new Timer(5000,1);
         this.am.addEventListener(consts.EVENT_REQUEST_COMPLETE,this.onRequestComplete);
         this.am.addEventListener(consts.EVENT_SLOT_STARTED,this.onSlotStarted);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
      }
      
      override protected function reportError(param1:Number, param2:String) : void
      {
         this.log("reportError " + param2);
         super.reportError(param1,param2);
         this.refresh();
      }
      
      private function assertAnyPlayed() : void
      {
         var _loc2_:String = null;
         this.log("assertAnyPlayed()");
         var _loc1_:Array = [];
         for(_loc2_ in this.prerollSlotsPlayMap)
         {
            if(this.prerollSlotsPlayMap[_loc2_] != false)
            {
               this.log("assertAnyPlayed: preroll slot " + _loc2_ + " is played");
               return;
            }
            this.log("assertAnyPlayed: preroll slot " + _loc2_ + " is not played");
            _loc1_.push(_loc2_);
         }
         _loc1_.sort();
         this.reportError(consts.ERROR_UNKNOWN,"Preroll slots " + _loc1_.join(",") + " are not played");
      }
      
      override public function refresh() : void
      {
         this.log("refresh()");
         super.refresh();
         this.prerollSlotsPlayMap = {};
         if(this.timeoutTimer)
         {
            this.timeoutTimer.reset();
         }
      }
      
      private function log(param1:String) : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.am)
         {
            this.am.removeEventListener(consts.EVENT_REQUEST_COMPLETE,this.onRequestComplete);
            this.am.removeEventListener(consts.EVENT_SLOT_STARTED,this.onSlotStarted);
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
