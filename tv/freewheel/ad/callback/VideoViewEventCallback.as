package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class VideoViewEventCallback extends BasicEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.VideoViewEventCallback");
       
      
      private var _isProcessed:Boolean = false;
      
      private var _keyValues:String;
      
      private var _deltaValue:uint;
      
      public function VideoViewEventCallback(param1:EventCallback, param2:Contexts)
      {
         super(param1,param2);
      }
      
      public static function construct(param1:Array, param2:Contexts) : VideoViewEventCallback
      {
         var _loc3_:VideoViewEventCallback = null;
         var _loc4_:EventCallback;
         if(_loc4_ = getEvent(param1,Constants.instance.EVENTCALLBACK_VIDEO_VIEW,Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,true))
         {
            _loc3_ = new VideoViewEventCallback(_loc4_,param2);
         }
         return _loc3_;
      }
      
      public function set keyValues(param1:String) : void
      {
         this._keyValues = param1;
      }
      
      private function getInitValue() : String
      {
         return this._isProcessed ? BasicEventCallback.INIT_VALUE_ZERO : BasicEventCallback.INIT_VALUE_ONE;
      }
      
      override public function toString() : String
      {
         return "VideoViewEventCallback.";
      }
      
      override public function process() : void
      {
         this._needProcessTrackingUrls = !this._isProcessed;
         super.process();
         this._isProcessed = true;
      }
      
      public function set deltaValue(param1:uint) : void
      {
         this._deltaValue = param1;
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_VIDEO_VIEW;
      }
      
      override public function getUrl(param1:Boolean = true) : String
      {
         var _loc2_:String = super.getUrl();
         _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_INIT,this.getInitValue(),true);
         _loc2_ = URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_CT,this._deltaValue.toString(),true);
         return URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_KEY_VALUES,this._keyValues,true);
      }
   }
}
