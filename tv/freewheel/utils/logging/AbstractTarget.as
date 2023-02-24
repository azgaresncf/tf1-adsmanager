package tv.freewheel.utils.logging
{
   import tv.freewheel.utils.logging.errors.InvalidFilterError;
   
   public class AbstractTarget implements ILoggingTarget
   {
       
      
      private var _loggerCount:uint = 0;
      
      private var _level:int;
      
      private var _id:String;
      
      private var _filters:Array;
      
      public function AbstractTarget()
      {
         this._filters = ["*"];
         this._level = LogEventLevel.ALL;
         super();
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         this._id = param2;
         Log.addTarget(this);
      }
      
      public function removeLogger(param1:ILogger) : void
      {
         if(param1)
         {
            --this._loggerCount;
            param1.removeEventListener(LogEvent.LOG,this.logHandler);
         }
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      private function logHandler(param1:LogEvent) : void
      {
         if(param1.level >= this.level)
         {
            this.logEvent(param1);
         }
      }
      
      public function set level(param1:int) : void
      {
         Log.removeTarget(this);
         this._level = param1;
         Log.addTarget(this);
      }
      
      public function addLogger(param1:ILogger) : void
      {
         if(param1)
         {
            ++this._loggerCount;
            param1.addEventListener(LogEvent.LOG,this.logHandler);
         }
      }
      
      public function get filters() : Array
      {
         return this._filters;
      }
      
      public function logEvent(param1:LogEvent) : void
      {
      }
      
      public function set filters(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc2_ = String(param1[_loc5_]);
               if(Log.hasIllegalCharacters(_loc2_))
               {
                  throw new InvalidFilterError("Error for filter \'" + _loc2_ + "\': The following characters are not valid: []~$^&/(){}<>+=_-`!@#%?,:;\'");
               }
               _loc3_ = _loc2_.indexOf("*");
               if(_loc3_ >= 0 && _loc3_ != _loc2_.length - 1)
               {
                  throw new InvalidFilterError("Error for filter \'" + _loc2_ + "\': \'*\' must be the right most character.");
               }
               _loc5_++;
            }
         }
         else
         {
            param1 = ["*"];
         }
         if(this._loggerCount > 0)
         {
            Log.removeTarget(this);
            this._filters = param1;
            Log.addTarget(this);
         }
         else
         {
            this._filters = param1;
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}
