package tv.freewheel.utils.logging
{
   import flash.events.EventDispatcher;
   
   public class LogLogger extends EventDispatcher implements ILogger
   {
       
      
      private var _category:String;
      
      public function LogLogger(param1:String)
      {
         super();
         this._category = param1;
      }
      
      public function log(param1:int, param2:String, ... rest) : void
      {
         var _loc4_:int = 0;
         if(param1 < LogEventLevel.DEBUG)
         {
            throw new ArgumentError("Level must be less than LogEventLevel.ALL.");
         }
         if(hasEventListener(LogEvent.LOG))
         {
            _loc4_ = 0;
            while(_loc4_ < rest.length)
            {
               param2 = param2.replace(new RegExp("\\{" + _loc4_ + "\\}","g"),rest[_loc4_]);
               _loc4_++;
            }
            dispatchEvent(new LogEvent(param2,param1));
         }
      }
      
      public function error(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.ERROR));
         }
      }
      
      public function warn(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.WARN));
         }
      }
      
      public function info(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.INFO));
         }
      }
      
      public function logStackTrace(param1:String) : void
      {
         var message:String = param1;
         try
         {
            throw new Error(message);
         }
         catch(e:Error)
         {
            debug("Debug " + e.getStackTrace());
            return;
         }
      }
      
      public function debug(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.DEBUG));
         }
      }
      
      public function fatal(param1:String, ... rest) : void
      {
         var _loc3_:int = 0;
         if(hasEventListener(LogEvent.LOG))
         {
            _loc3_ = 0;
            while(_loc3_ < rest.length)
            {
               param1 = param1.replace(new RegExp("\\{" + _loc3_ + "\\}","g"),rest[_loc3_]);
               _loc3_++;
            }
            dispatchEvent(new LogEvent(param1,LogEventLevel.FATAL));
         }
      }
      
      public function get category() : String
      {
         return this._category;
      }
   }
}
