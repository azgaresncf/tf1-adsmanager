package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class ClickEventCallback extends AdEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.ClickEventCallback");
       
      
      private var _urlOverride:String;
      
      private var _showBrowser:Boolean = false;
      
      public function ClickEventCallback(param1:uint, param2:AdInstance, param3:EventCallback)
      {
         super(param1,param2,param3);
         this._showBrowser = this._event.showBrowser;
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_CLICK;
      }
      
      public function get showBrowser() : Boolean
      {
         return this._showBrowser;
      }
      
      override public function toString() : String
      {
         return "ClickEventCallback(" + this._adInstance.id + ").";
      }
      
      public function set urlOverride(param1:String) : void
      {
         this._urlOverride = param1;
      }
      
      override public function getUrl(param1:Boolean = true) : String
      {
         var _loc2_:String = super.getUrl();
         if(this._urlOverride != null)
         {
            _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_CR,this._urlOverride,true);
         }
         return _loc2_;
      }
      
      public function set showBrowser(param1:Boolean) : void
      {
         this._showBrowser = param1;
      }
      
      override public function process() : void
      {
         var urlRequest:String = null;
         if(this._showBrowser)
         {
            urlRequest = null;
            try
            {
               urlRequest = this.getUrl();
            }
            catch(error:Error)
            {
               logger.warn(this + "process() error:" + error.message);
               return;
            }
            EventCallback.openNewWindow(urlRequest);
            this.processTrackingUrls();
            this.dispatchRendererEvent();
            return;
         }
         this._needProcessTrackingUrls = true;
         this._needDispatchRendererEvent = true;
         super.process();
      }
   }
}
