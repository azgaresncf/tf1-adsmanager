package tv.freewheel.utils.timer
{
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   
   public class FWTimer extends EventDispatcher
   {
       
      
      private var _previousTime:Number;
      
      private var _delay:Number;
      
      private var _remainingIntervalTime:Number;
      
      private var _isPaused:Boolean = false;
      
      private var _intervalId:Number;
      
      private var _isEnded:Boolean = false;
      
      private var _repeatCount:Number;
      
      private var _isStarted:Boolean = false;
      
      private var _currentCount:uint = 0;
      
      public function FWTimer(param1:Number, param2:int = 0)
      {
         super();
         this._delay = param1;
         this._repeatCount = param2 > 0 ? param2 : 0;
      }
      
      public function stop() : void
      {
         this.reset();
      }
      
      private function startTimer(param1:Number) : void
      {
         if(!isNaN(param1) && param1 > 0)
         {
            this._intervalId = setInterval(this.handleTimerEvent,param1);
            this._previousTime = getTimer();
         }
      }
      
      public function reset() : void
      {
         this.stopTimer();
         this._isStarted = false;
         this._isPaused = false;
         this._isEnded = false;
         this._currentCount = 0;
      }
      
      public function get currentCount() : uint
      {
         return this._currentCount;
      }
      
      public function get delay() : Number
      {
         return this._delay;
      }
      
      private function handleTimerEvent() : void
      {
         ++this._currentCount;
         this._previousTime = getTimer();
         if(this._remainingIntervalTime < this._delay)
         {
            this._remainingIntervalTime = this._delay;
            this.stopTimer();
            this.startTimer(this._delay);
         }
         this.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
         if(this._currentCount == this._repeatCount)
         {
            this._isEnded = true;
            this.stopTimer();
            this.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
         }
      }
      
      private function stopTimer() : void
      {
         if(!isNaN(this._intervalId))
         {
            clearInterval(this._intervalId);
            this._intervalId = NaN;
         }
      }
      
      public function dispose() : void
      {
         this.stop();
      }
      
      public function start() : void
      {
         if(this._isEnded)
         {
            this.reset();
         }
         if(this._isStarted)
         {
            if(this._isPaused)
            {
               this.resume();
            }
            return;
         }
         this._isStarted = true;
         this._remainingIntervalTime = this._delay;
         this.startTimer(this._delay);
      }
      
      public function resume() : void
      {
         if(!this._isStarted || this._isEnded || !this._isPaused)
         {
            return;
         }
         this._isPaused = false;
         this._previousTime = getTimer();
         if(this._remainingIntervalTime > 0)
         {
            this.startTimer(this._remainingIntervalTime);
         }
         else
         {
            this.startTimer(this._delay);
         }
      }
      
      public function pause() : void
      {
         if(!this._isStarted || this._isEnded || this._isPaused)
         {
            return;
         }
         this._isPaused = true;
         this._remainingIntervalTime -= getTimer() - this._previousTime;
         this.stopTimer();
      }
      
      public function get running() : Boolean
      {
         return this._isStarted;
      }
   }
}
