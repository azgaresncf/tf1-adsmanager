package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class AdImpressionEventCallback extends AdEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.AdImpressionEventCallback");
       
      
      protected var _concreteEventId:String = null;
      
      private var _isProcessed:Boolean = false;
      
      public function AdImpressionEventCallback(param1:uint, param2:AdInstance, param3:EventCallback, param4:String = null)
      {
         super(param1,param2,param3);
         this._concreteEventId = param4;
         this._moduleName = param4;
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_DEFAULT_IMPRESSION;
      }
      
      override public function getUrl(param1:Boolean = true) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = super.getUrl();
         if(this._event.name == Constants.instance.EVENTCALLBACK_MEASUREMENT)
         {
            _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_CONCRETE_EVENT_ID,this._concreteEventId);
         }
         else
         {
            _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_METR,this._adInstance.getMetricManager().getMetric().toString());
            _loc3_ = param1 ? this._adInstance.getMetricManager().getDeltaValue().toString() : "0";
            if(this._event.name == Constants.instance.EVENTCALLBACK_AD_END)
            {
               _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_CT,_loc3_);
            }
            _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_INIT,this.getInitValue());
         }
         return _loc2_;
      }
      
      private function getInitValue() : String
      {
         var _loc1_:String = null;
         if(this._adInstance.slot.isPauseSlot() || !this._isProcessed || this._adInstance.isCompanionAdOfPauseAd)
         {
            _loc1_ = BasicEventCallback.INIT_VALUE_ONE;
         }
         else
         {
            _loc1_ = BasicEventCallback.INIT_VALUE_TWO;
         }
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return "AdImpressionEventCallback(" + this._adInstance.id + ").";
      }
      
      override public function process() : void
      {
         this._needProcessTrackingUrls = this.getInitValue() == BasicEventCallback.INIT_VALUE_ONE;
         if(this._event.name == Constants.instance.EVENTCALLBACK_DEFAULTIMPRESSION)
         {
            if(this._adInstance.isStartedSuccessfully())
            {
               this._adInstance.sendErrorCallback(Constants.instance.ERROR_UNKNOWN,"defaultImpression is dispatched from renderer multiple times");
               return;
            }
            this._adInstance.markImprSent();
         }
         super.process();
         this._isProcessed = true;
      }
   }
}
