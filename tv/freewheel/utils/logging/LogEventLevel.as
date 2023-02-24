package tv.freewheel.utils.logging
{
   import tv.freewheel.ad.constant.Constants;
   
   public final class LogEventLevel
   {
      
      public static var ALL:int = -1;
      
      public static var FATAL:int = 1000;
      
      private static var _constants:Constants = Constants.instance;
      
      public static var INFO:int = _constants.LEVEL_INFO;
      
      public static var ERROR:int = _constants.LEVEL_ERROR;
      
      public static var WARN:int = _constants.LEVEL_WARNING;
      
      public static var DEBUG:int = _constants.LEVEL_DEBUG;
       
      
      public function LogEventLevel()
      {
         super();
      }
   }
}
