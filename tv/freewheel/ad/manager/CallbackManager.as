package tv.freewheel.ad.manager
{
   import tv.freewheel.ad.callback.AdEventCallback;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class CallbackManager
   {
      
      private static const EVENTCALLBACKS_NEED_STORED:Array = [Constants.instance.RENDERER_EVENT_IMPRESSION,Constants.instance.RENDERER_EVENT_IMPRESSION_END,Constants.instance.RENDERER_EVENT_FIRSTQUARTILE,Constants.instance.RENDERER_EVENT_MIDPOINT,Constants.instance.RENDERER_EVENT_THIRDQUARTILE,Constants.instance.RENDERER_EVENT_COMPLETE];
      
      private static var SEPARATOR:String = ":";
      
      private static const VALID_EVENTCALLBACK_NAME_TYPES:Array = [[Constants.instance.EVENTCALLBACK_DEFAULTIMPRESSION,Constants.instance.EVENTCALLBACK_FIRSTQUARTILE,Constants.instance.EVENTCALLBACK_MIDPOINT,Constants.instance.EVENTCALLBACK_THIRDQUARTILE,Constants.instance.EVENTCALLBACK_COMPLETE,Constants.instance.EVENTCALLBACK_PAUSE,Constants.instance.EVENTCALLBACK_RESUME,Constants.instance.EVENTCALLBACK_REWIND,Constants.instance.EVENTCALLBACK_MUTE,Constants.instance.EVENTCALLBACK_UNMUTE,Constants.instance.EVENTCALLBACK_COLLAPSE,Constants.instance.EVENTCALLBACK_EXPAND,Constants.instance.EVENTCALLBACK_MINIMIZE,Constants.instance.EVENTCALLBACK_CLOSE,Constants.instance.EVENTCALLBACK_ACCEPTINVITATION,Constants.instance.EVENTCALLBACK_ERROR_UNKNOWN],[Constants.instance.RENDERER_EVENT_IMPRESSION,Constants.instance.RENDERER_EVENT_FIRSTQUARTILE,Constants.instance.RENDERER_EVENT_MIDPOINT,Constants.instance.RENDERER_EVENT_THIRDQUARTILE,Constants.instance.RENDERER_EVENT_COMPLETE,Constants.instance.RENDERER_EVENT_PAUSE,Constants.instance.RENDERER_EVENT_RESUME,Constants.instance.RENDERER_EVENT_REWIND,Constants.instance.RENDERER_EVENT_MUTE,Constants.instance.RENDERER_EVENT_UNMUTE,Constants.instance.RENDERER_EVENT_COLLAPSE,Constants.instance.RENDERER_EVENT_EXPAND,Constants.instance.RENDERER_EVENT_MINIMIZE,Constants.instance.RENDERER_EVENT_CLOSE,Constants.instance.RENDERER_EVENT_ACCEPTINVITATION,Constants.instance.RENDERER_EVENT_FAIL],[Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_ERROR]];
      
      private static var logger:ILogger = Log.getLogger("AdManager.CallbackManager");
      
      public static const VALID_EVENT_CALLBACK_ERROR_NAMES:Array = [Constants.instance.EVENTCALLBACK_ERROR_NETWORK,Constants.instance.EVENTCALLBACK_ERROR_SECURITY,Constants.instance.EVENTCALLBACK_ERROR_NO_AD_AVAILABLE,Constants.instance.EVENTCALLBACK_ERROR_IO,Constants.instance.EVENTCALLBACK_ERROR_TIMEOUT,Constants.instance.EVENTCALLBACK_ERROR_INVALID_VALUE,Constants.instance.EVENTCALLBACK_ERROR_MISSING_PARAMETER,Constants.instance.EVENTCALLBACK_ERROR_EXTERNAL_INTERFACE,Constants.instance.EVENTCALLBACK_ERROR_3P_COMPONENT,Constants.instance.EVENTCALLBACK_ERROR_NULL_ASSET,Constants.instance.EVENTCALLBACK_ERROR_INVALID_SLOT,Constants.instance.EVENTCALLBACK_ERROR_ADINSTANCE_UNAVAILABLE,Constants.instance.EVENTCALLBACK_ERROR_PARSE_ERROR,Constants.instance.EVENTCALLBACK_ERROR_UNSUPPORTED_3P_FEATURE,Constants.instance.EVENTCALLBACK_ERROR_UNMATCHED_SLOT_SIZE,Constants.instance.EVENTCALLBACK_ERROR_SLOT_UNAVAILABLE,Constants.instance.EVENTCALLBACK_ERROR_UNKNOWN];
       
      
      private var _additionalCallbackUrls:HashMap;
      
      private var _storedEventCallbacks:HashMap;
      
      private var _adInstance:AdInstance;
      
      public function CallbackManager(param1:AdInstance)
      {
         this._additionalCallbackUrls = new HashMap();
         this._storedEventCallbacks = new HashMap();
         super();
         this._adInstance = param1;
      }
      
      private static function findEventIdByNameAndType(param1:String, param2:String) : int
      {
         var _loc3_:int = int(VALID_EVENTCALLBACK_NAME_TYPES[0].indexOf(param1));
         if(_loc3_ >= 0 && VALID_EVENTCALLBACK_NAME_TYPES[2][_loc3_] == param2)
         {
            return VALID_EVENTCALLBACK_NAME_TYPES[1][_loc3_];
         }
         return -1;
      }
      
      public static function getEventCallbackInfo(param1:String, param2:String) : Object
      {
         var _loc4_:int = 0;
         var _loc3_:Object = null;
         if(!SuperString.isNull(param1))
         {
            if(SuperString.isNull(param2))
            {
               switch(param1)
               {
                  case Constants.instance.EVENTCALLBACK_DEFAULTIMPRESSION:
                     param2 = Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION;
                     break;
                  case Constants.instance.EVENTCALLBACK_DEFAULTCLICK:
                     param2 = Constants.instance.EVENTCALLBACK_TYPE_CLICK;
               }
            }
            _loc3_ = {
               "eventName":param1,
               "eventType":param2
            };
            if(param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICK || param2 == Constants.instance.EVENTCALLBACK_TYPE_CLICKTRACKING)
            {
               _loc3_.eventId = Constants.instance.RENDERER_EVENT_CLICK;
            }
            else if((_loc4_ = findEventIdByNameAndType(param1,param2)) > 0)
            {
               _loc3_.eventId = _loc4_;
            }
         }
         return _loc3_;
      }
      
      private function getUniqueId(param1:String, param2:String) : String
      {
         return escape(param1) + SEPARATOR + escape(param2);
      }
      
      public function appendURLs(param1:String, param2:String, param3:Array) : void
      {
         var _loc6_:String = null;
         var _loc4_:String = this.getUniqueId(param1,param2);
         var _loc5_:Array = this._additionalCallbackUrls.get(_loc4_) || new Array();
         for each(_loc6_ in param3)
         {
            if(_loc5_.indexOf(_loc6_) <= -1)
            {
               _loc5_.push(_loc6_);
            }
         }
         this._additionalCallbackUrls.put(_loc4_,_loc5_);
      }
      
      public function getAdEventCallback(param1:uint, param2:String, param3:String, param4:Object = null, param5:Boolean = true) : AdEventCallback
      {
         var _loc6_:AdEventCallback = null;
         if(EVENTCALLBACKS_NEED_STORED.indexOf(param1) > -1)
         {
            _loc6_ = this._storedEventCallbacks.get(param1.toString());
         }
         if(!_loc6_)
         {
            _loc6_ = AdEventCallback.construct(this._adInstance.adRef.eventCallbacks,param1,param2,param3,this._adInstance,param5,param4);
            this._storedEventCallbacks.put(param1.toString(),_loc6_);
         }
         return _loc6_;
      }
      
      public function cloneForTranslation(param1:AdInstance) : CallbackManager
      {
         var _loc2_:CallbackManager = new CallbackManager(param1);
         _loc2_._additionalCallbackUrls = this._additionalCallbackUrls.clone();
         return _loc2_;
      }
      
      public function getURLs(param1:String, param2:String) : Array
      {
         if(param2 == Constants.instance.EVENTCALLBACK_TYPE_ERROR)
         {
            param1 = Constants.instance.EVENTCALLBACK_ERROR_UNKNOWN;
         }
         var _loc3_:String = this.getUniqueId(param1,param2);
         if(this._additionalCallbackUrls.get(_loc3_) != null)
         {
            return this._additionalCallbackUrls.get(_loc3_);
         }
         return new Array();
      }
      
      public function toString() : String
      {
         return "CallbackManager(" + this._adInstance.id + ")";
      }
      
      public function getEventCallbackNames(param1:String) : Array
      {
         var _loc3_:EventCallback = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this._adInstance.adRef.eventCallbacks)
         {
            if(_loc3_.type == param1 && _loc3_.name && _loc2_.indexOf(_loc3_.name) == -1)
            {
               _loc2_.push(_loc3_.name);
            }
         }
         for each(_loc4_ in this._additionalCallbackUrls.getKeys())
         {
            if((_loc5_ = this._additionalCallbackUrls.get(_loc4_)) != null && _loc5_.length > 0)
            {
               _loc6_ = _loc4_.split(SEPARATOR);
               _loc7_ = unescape(_loc6_[0]);
               if((_loc8_ = unescape(_loc6_[1])) == param1 && _loc7_ && _loc2_.indexOf(_loc7_) < 0)
               {
                  _loc2_.push(_loc7_);
               }
            }
         }
         return _loc2_;
      }
   }
}
