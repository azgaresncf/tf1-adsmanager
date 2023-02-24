package tv.freewheel.utils.js
{
   import flash.external.ExternalInterface;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class JSInterface
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.JSInterface");
       
      
      public function JSInterface()
      {
         super();
      }
      
      public static function replacePageSlot(param1:String, param2:String) : Boolean
      {
         var safeId:String = param1;
         var adContent:String = param2;
         try
         {
            ExternalInterface.marshallExceptions = true;
            if(ExternalInterface.call("window._fw_renderer.isInjectedSuccess"))
            {
               ExternalInterface.call("window._fw_renderer.replacePageSlot",safeId,adContent);
               return true;
            }
            logger.error("Failed to inject renderer javascript");
            return false;
         }
         catch(err:Error)
         {
            trace(err.message);
            logger.error("replacePageSlot: " + err.message + "\n" + err.getStackTrace());
            return false;
         }
      }
   }
}
