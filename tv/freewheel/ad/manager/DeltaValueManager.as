package tv.freewheel.ad.manager
{
   import flash.utils.getTimer;
   
   public class DeltaValueManager
   {
       
      
      private var _lastTime:Number = NaN;
      
      private var _pauseTime:Number = NaN;
      
      private var _isStarted:Boolean = false;
      
      private var _id:String;
      
      public function DeltaValueManager(param1:String = null)
      {
         super();
         this._id = param1 || String(int(Math.random() * 1000));
      }
      
      public function stop() : void
      {
         this._isStarted = false;
      }
      
      public function toString() : String
      {
         return "DeltaValueManager(" + this._id + ").";
      }
      
      public function pause() : void
      {
         if(!this._isStarted)
         {
            return;
         }
         if(isNaN(this._pauseTime))
         {
            this._pauseTime = getTimer();
         }
      }
      
      public function play() : void
      {
         if(!this._isStarted)
         {
            this._isStarted = true;
            this._lastTime = getTimer();
         }
         else if(!isNaN(this._pauseTime))
         {
            this._lastTime += getTimer() - this._pauseTime;
            this._pauseTime = NaN;
         }
      }
      
      public function tick() : uint
      {
         var _loc2_:Number = NaN;
         if(!this._isStarted)
         {
            this.play();
            return 0;
         }
         var _loc1_:uint = 0;
         if(!isNaN(this._pauseTime))
         {
            _loc1_ = (this._pauseTime - this._lastTime) / 1000;
            this._lastTime = this._pauseTime;
         }
         else
         {
            _loc2_ = getTimer();
            _loc1_ = (_loc2_ - this._lastTime) / 1000;
            this._lastTime = _loc2_;
         }
         return _loc1_;
      }
   }
}
