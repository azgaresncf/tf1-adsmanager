package tv.freewheel.utils.logging.targets
{
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   
   public class MiniDebugTarget extends LineFormattedTarget
   {
       
      
      private var _method:String;
      
      private var _lc:LocalConnection;
      
      private var _connection:String;
      
      public function MiniDebugTarget(param1:String = "_mdbtrace", param2:String = "trace")
      {
         super();
         this._lc = new LocalConnection();
         this._lc.addEventListener(StatusEvent.STATUS,this.onStatus);
         this._lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this._connection = param1;
         this._method = param2;
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         if(param1.level == "error")
         {
            trace("Warning: MiniDebugTarget send failed: " + param1.code);
         }
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         trace("Error: security error on MiniDebugTarget\'s local connection");
      }
   }
}
