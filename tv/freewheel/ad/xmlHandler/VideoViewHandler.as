package tv.freewheel.ad.xmlHandler
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequestMethod;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.AdManagerContext;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.log.Logger;
   import tv.freewheel.utils.url.URLTools;
   import tv.freewheel.utils.xml.XMLHandler;
   import tv.freewheel.utils.xml.XMLUtils;
   
   public class VideoViewHandler extends XMLHandler
   {
       
      
      private var _context:Contexts;
      
      private var url:String;
      
      public function VideoViewHandler(param1:Contexts)
      {
         super();
         this._context = param1;
      }
      
      override protected function completeHandler(param1:Event) : void
      {
         var _e:Event = param1;
         try
         {
            this.parseASVUrlXML(_e.target.data);
         }
         catch(err:Error)
         {
            Logger.instance.error("VideoViewHandler.completeHandler() error: " + err.message);
         }
      }
      
      override protected function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         Logger.instance.error("VideoViewHandler.securityErrorHandler(): " + param1);
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         if(param1.localName != InnerConstants.TAG_AD_RESPONSE)
         {
            throw new Error("unknown response, expected is adResponse");
         }
         this._context.adManagerContext.getStatusManager().parseVideoViewCallback(XMLUtils.getDescendantNode(param1,[InnerConstants.TAG_SITE_SECTION,InnerConstants.TAG_VIDEO_PLAYER,InnerConstants.TAG_VIDEO_ASSET,InnerConstants.TAG_EVENT_CALLBACKS]));
      }
      
      public function submit(param1:Object = null) : void
      {
         var _loc2_:String = null;
         if(!SuperString.isNull(this.url) && this.url.indexOf(".xml") == this.url.length - 4)
         {
            super.process(this.url);
         }
         else
         {
            _loc2_ = this.url;
            if(URLTools.isHTTP(_loc2_))
            {
               this._context.adManagerContext.adRequestBase = URLTools.getBaseURL(_loc2_);
            }
            else
            {
               Logger.instance.error("url is not http " + _loc2_);
            }
            _loc2_ = this._context.adManagerContext.adRequestBase + AdManagerContext.AD_REQUEST_LOCATION;
            super.process(_loc2_,param1,"text/xml",URLRequestMethod.POST);
         }
      }
      
      private function parseASVUrlXML(param1:String) : void
      {
         var _strXML:String = param1;
         var node:XMLDocument = new XMLDocument();
         node.ignoreWhite = true;
         try
         {
            node.parseXML(_strXML);
            this.parseXML(node.firstChild);
         }
         catch(_e:Error)
         {
            Logger.instance.error("VideoViewHandler.parseASVUrlXML(): " + _e);
         }
      }
      
      override protected function ioErrorHandler(param1:IOErrorEvent) : void
      {
         Logger.instance.error("VideoViewHandler.errorHandler(): " + param1);
      }
      
      public function init(param1:String) : void
      {
         this.url = param1;
      }
   }
}
