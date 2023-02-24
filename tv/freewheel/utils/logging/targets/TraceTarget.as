package tv.freewheel.utils.logging.targets
{
   public class TraceTarget extends LineFormattedTarget
   {
       
      
      public function TraceTarget()
      {
         super();
      }
      
      override protected function internalLog(param1:String) : void
      {
         trace(param1);
      }
   }
}
