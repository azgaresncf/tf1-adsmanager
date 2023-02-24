package tv.freewheel.ad.xmlHandler
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.xml.XMLDocument;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.utils.log.Logger;
   import tv.freewheel.utils.xml.XMLHandler;
   
   public class RenderersHandler extends XMLHandler
   {
       
      
      public var requestUrl:String;
      
      private var _context:Contexts;
      
      public function RenderersHandler(param1:Contexts)
      {
         super();
         this._context = param1;
      }
      
      override protected function completeHandler(param1:Event) : void
      {
         var e:Event = param1;
         try
         {
            this.parseAdRendererXML(e.target.data);
            this.notifyRequestCompleteEvent(true);
         }
         catch(err:Error)
         {
            Logger.instance.error("RenderersHandler.completeHandler() -> error: " + err.message);
            this.notifyRequestCompleteEvent(false,err.message);
         }
      }
      
      public function submit(param1:String) : void
      {
         this.requestUrl = param1;
         this._context.adManagerContext.adRendererSet.setCompleted(false);
         this._context.adManagerContext.adRendererSet.setSucceeded(false);
         this.process(param1);
      }
      
      override protected function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         if(this.cleaned)
         {
            return;
         }
         this.notifyRequestCompleteEvent(false,param1.toString());
      }
      
      override protected function ioErrorHandler(param1:IOErrorEvent) : void
      {
         this.notifyRequestCompleteEvent(false,param1.toString());
      }
      
      private function notifyRequestCompleteEvent(param1:Boolean, param2:String = null) : void
      {
         this._context.adManagerContext.adRendererSet.setCompleted(true);
         this._context.adManagerContext.adRendererSet.setSucceeded(param1);
         this._context.requestContext.notifyRequestCompleteEvent(false,param2);
      }
      
      private function parseAdRendererXML(param1:String) : void
      {
         var _loc2_:XMLDocument = new XMLDocument();
         _loc2_.ignoreWhite = true;
         _loc2_.parseXML(param1);
         this._context.adManagerContext.adRendererSet.parseXML(_loc2_.firstChild);
      }
   }
}
