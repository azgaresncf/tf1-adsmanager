package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class QuartileEventCallback extends AdEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.QuartileEventCallback");
       
      
      private var _isProcessed:Boolean = false;
      
      public function QuartileEventCallback(param1:uint, param2:AdInstance, param3:EventCallback)
      {
         super(param1,param2,param3);
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_QUARTILE;
      }
      
      override public function getUrl(param1:Boolean = true) : String
      {
         var _loc2_:String = super.getUrl();
         _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_CT,param1 ? this._adInstance.getMetricManager().getDeltaValue().toString() : "0",true);
         return URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_METR,this._adInstance.getMetricManager().getMetric().toString(),true);
      }
      
      override public function toString() : String
      {
         return "QuartileEventCallback(" + this._adInstance.id + ").";
      }
      
      override public function process() : void
      {
         if(this._isProcessed && !this._adInstance.slot.isPauseSlot())
         {
            return;
         }
         this._needProcessTrackingUrls = true;
         this._needDispatchRendererEvent = true;
         super.process();
         this._isProcessed = true;
      }
   }
}
