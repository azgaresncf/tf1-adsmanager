package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class AdErrorEventCallback extends AdEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.AdErrorEventCallback");
       
      
      public function AdErrorEventCallback(param1:uint, param2:AdInstance, param3:EventCallback)
      {
         super(param1,param2,param3);
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_ERROR;
      }
      
      override protected function initParameters() : void
      {
         super.initParameters();
         if(this._adInstance.rendererEntry != null)
         {
            this._keyValues.put(BasicEventCallback.URL_KEY_RENDERER,this._adInstance.rendererEntry.id);
         }
      }
      
      override public function toString() : String
      {
         return "AdErrorEventCallback(" + this._adInstance.id + ").";
      }
      
      public function set errorMessage(param1:String) : void
      {
         this._keyValues.put(BasicEventCallback.URL_KEY_ADDITIONAL,param1);
         this._keyValues.clean();
      }
      
      override public function process() : void
      {
         this._needDispatchRendererEvent = this._eventId == Constants.instance.RENDERER_EVENT_FAIL || this._event.name == Constants.instance.EVENTCALLBACK_RESELLER_NO_AD;
         super.process();
      }
   }
}
