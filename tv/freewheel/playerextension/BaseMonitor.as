package tv.freewheel.playerextension
{
   public class BaseMonitor
   {
       
      
      protected var am:Object = null;
      
      protected var consts:Object = null;
      
      public function BaseMonitor()
      {
         super();
      }
      
      public function refresh() : void
      {
         this.log("refresh()");
      }
      
      private function log(param1:String) : void
      {
      }
      
      protected function reportError(param1:Number, param2:String) : void
      {
         this.log("reportError " + param2);
         this.am.debugInitialize({
            "__magic_function_name":"reportGlobalError",
            "errorCode":param1,
            "msg":param2
         });
         this.refresh();
      }
      
      public function dispose() : void
      {
         if(this.am)
         {
            this.am.removeEventListener(this.consts.EVENT_REFRESHED,this.onRefreshed);
         }
      }
      
      public function init(param1:Object) : void
      {
         this.log("init()");
         this.am = param1;
         this.consts = param1.getConstants();
         this.am.addEventListener(this.consts.EVENT_REFRESHED,this.onRefreshed);
      }
      
      protected function onRefreshed(param1:Object) : void
      {
         this.log("onRefreshed()");
         this.refresh();
      }
   }
}
