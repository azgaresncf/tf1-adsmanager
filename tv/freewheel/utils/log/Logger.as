package tv.freewheel.utils.log
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.ILoggingTarget;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.logging.targets.TraceTarget;
   
   public class Logger
   {
      
      private static var logger:Logger = null;
       
      
      private var _currentTarget:ILoggingTarget = null;
      
      private var _adManagerLogger:ILogger = null;
      
      public function Logger()
      {
         super();
      }
      
      public static function getInstance() : Logger
      {
         if(!logger)
         {
            trace("--FreeWheel-- Initializing Logging Framework");
            logger = new Logger();
            logger.addTraceTarget(Constants.instance.LEVEL_QUIET);
            logger._adManagerLogger = Log.getLogger("AdManager");
         }
         return logger;
      }
      
      public static function get instance() : Logger
      {
         return getInstance();
      }
      
      public function setLogLevel(param1:Number) : void
      {
         trace("--FreeWheel-- Set log level to " + param1);
         Logger.getInstance();
         this._currentTarget.level = param1;
      }
      
      public function log(... rest) : void
      {
         this._adManagerLogger.log.apply(this._adManagerLogger,rest);
      }
      
      public function warn(... rest) : void
      {
         this._adManagerLogger.warn.apply(this._adManagerLogger,rest);
      }
      
      public function error(... rest) : void
      {
         this._adManagerLogger.error.apply(this._adManagerLogger,rest);
      }
      
      public function notify(... rest) : void
      {
         this._adManagerLogger.debug.apply(this._adManagerLogger,rest);
      }
      
      public function info(... rest) : void
      {
         this._adManagerLogger.info.apply(this._adManagerLogger,rest);
      }
      
      private function addTraceTarget(param1:Number) : TraceTarget
      {
         var _loc2_:TraceTarget = null;
         _loc2_ = new TraceTarget();
         _loc2_.filters = ["Renderer.*","AdManager*"];
         _loc2_.level = param1;
         _loc2_.includeDate = false;
         _loc2_.includeTime = true;
         _loc2_.includeCategory = true;
         _loc2_.includeLevel = true;
         _loc2_.prefix = "--FreeWheel-- ";
         Log.addTarget(_loc2_);
         this._currentTarget = _loc2_;
         return _loc2_;
      }
      
      public function debug(... rest) : void
      {
         this._adManagerLogger.debug.apply(this._adManagerLogger,rest);
      }
   }
}
