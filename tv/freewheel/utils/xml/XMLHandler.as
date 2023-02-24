package tv.freewheel.utils.xml
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import tv.freewheel.utils.basic.SuperString;
   
   public class XMLHandler
   {
       
      
      protected var cleaned:Boolean;
      
      private var loader:URLLoader;
      
      private var request:URLRequest;
      
      public function XMLHandler()
      {
         super();
         this.cleaned = false;
         this.loader = new URLLoader();
         this.loader.addEventListener(Event.COMPLETE,this.completeHandler);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
         this.loader.addEventListener(Event.OPEN,this.openHandler);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
      }
      
      protected function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
      }
      
      protected function openHandler(param1:Event) : void
      {
      }
      
      protected function ioErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      protected function process(param1:String, param2:Object = null, param3:String = null, param4:String = null) : void
      {
         this.request = new URLRequest(param1);
         if(param2)
         {
            this.request.data = param2;
         }
         if(!SuperString.isNull(param3))
         {
            this.request.contentType = param3;
         }
         if(!SuperString.isNull(param4))
         {
            this.request.method = param4;
         }
         this.loader.load(this.request);
      }
      
      protected function completeHandler(param1:Event) : void
      {
      }
      
      protected function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
      }
      
      public function clearLoader() : void
      {
         this.cleaned = true;
         this.request = null;
         if(this.loader)
         {
            try
            {
               this.loader.close();
            }
            catch(e:Error)
            {
            }
            this.loader.removeEventListener(Event.COMPLETE,this.completeHandler);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
            this.loader.removeEventListener(Event.OPEN,this.openHandler);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            this.loader = null;
         }
      }
      
      protected function progressHandler(param1:ProgressEvent) : void
      {
      }
      
      public function dispose() : void
      {
         this.request = null;
         if(this.loader)
         {
            this.loader.removeEventListener(Event.COMPLETE,this.completeHandler);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
            this.loader.removeEventListener(Event.OPEN,this.openHandler);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.loader = null;
         }
      }
   }
}
