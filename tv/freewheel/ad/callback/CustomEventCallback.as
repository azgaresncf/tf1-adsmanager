package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class CustomEventCallback extends AdEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.CustomEventCallback");
       
      
      public function CustomEventCallback(param1:uint, param2:AdInstance, param3:EventCallback)
      {
         super(param1,param2,param3);
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_CUSTOM_EVENT;
      }
      
      override public function process() : void
      {
         this._needProcessTrackingUrls = true;
         this._needDispatchRendererEvent = true;
         super.process();
      }
   }
}
