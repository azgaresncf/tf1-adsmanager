package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class GlobalErrorEventCallback extends BasicEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.GlobalErrorEventCallback");
       
      
      private var _keyValues:HashMap;
      
      public function GlobalErrorEventCallback(param1:EventCallback, param2:HashMap, param3:Contexts)
      {
         super(param1,param3);
         this._keyValues = param2;
      }
      
      public static function construct(param1:Array, param2:String, param3:HashMap, param4:Contexts) : GlobalErrorEventCallback
      {
         var _loc5_:GlobalErrorEventCallback = null;
         var _loc6_:EventCallback;
         if(_loc6_ = getEvent(param1,param2,Constants.instance.EVENTCALLBACK_TYPE_ERROR,true))
         {
            _loc5_ = new GlobalErrorEventCallback(_loc6_,param3,param4);
         }
         return _loc5_;
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_GLOBAL_ERROR;
      }
      
      override public function getUrl(param1:Boolean = true) : String
      {
         var _loc2_:String = super.getUrl();
         _loc2_ = URLTools.replaceUrlParam(_loc2_,URL_KEY_EVENT_NAME,this._event.name,true);
         _loc2_ = URLTools.replaceUrlParam(_loc2_,URL_KEY_EVENT_TYPE,getShortEventTypeByEventType(this._event.type),true);
         return URLTools.addKeyValuesInUrl(_loc2_,this._keyValues);
      }
      
      override public function toString() : String
      {
         return "GlobalErrorEventCallback.";
      }
      
      override public function process() : void
      {
         this._needProcessTrackingUrls = false;
         super.process();
      }
   }
}
