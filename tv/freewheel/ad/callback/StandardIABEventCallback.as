package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   
   public class StandardIABEventCallback extends AdEventCallback
   {
       
      
      public function StandardIABEventCallback(param1:uint, param2:AdInstance, param3:EventCallback)
      {
         super(param1,param2,param3);
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_STANDARD_IAB;
      }
      
      override public function process() : void
      {
         this._needProcessTrackingUrls = true;
         this._needDispatchRendererEvent = true;
         super.process();
      }
   }
}
