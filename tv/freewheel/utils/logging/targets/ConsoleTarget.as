package tv.freewheel.utils.logging.targets
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.utils.console.ConsoleClient;
   
   public class ConsoleTarget extends LineFormattedTarget
   {
       
      
      private var consoleClient:ConsoleClient;
      
      public function ConsoleTarget()
      {
         super();
         this.filters = ["Renderer.*","AdManager"];
         this.level = Constants.instance.LEVEL_DEBUG;
         this.includeDate = false;
         this.includeTime = true;
         this.includeCategory = true;
         this.includeLevel = true;
         this.consoleClient = ConsoleClient.getInstance();
      }
      
      override protected function internalLog(param1:String) : void
      {
         this.consoleClient.writeLog(param1);
      }
   }
}
