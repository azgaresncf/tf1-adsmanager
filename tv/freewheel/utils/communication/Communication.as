package tv.freewheel.utils.communication
{
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.Security;
   import tv.freewheel.utils.log.Logger;
   import tv.freewheel.utils.url.URLTools;
   
   public class Communication
   {
      
      private static var communication:Communication;
       
      
      public function Communication()
      {
         super();
      }
      
      public static function getInstance() : Communication
      {
         if(!communication)
         {
            communication = new Communication();
         }
         return communication;
      }
      
      public function send(param1:String) : void
      {
         var requestUrl:String = param1;
         var serverPingRequest:URLRequest = new URLRequest(requestUrl);
         var serverPingLoader:URLLoader = new URLLoader();
         serverPingLoader.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler);
         serverPingLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         Security.allowDomain(URLTools.getDomain(requestUrl));
         try
         {
            serverPingLoader.load(serverPingRequest);
         }
         catch(e:SecurityError)
         {
         }
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         Logger.instance.error("Communication securityErrorHandler: " + param1.type);
      }
      
      private function errorHandler(param1:IOErrorEvent) : void
      {
         Logger.instance.error("Communication ping server failure: " + param1.type);
      }
   }
}
