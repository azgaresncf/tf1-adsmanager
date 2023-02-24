package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.communication.Communication;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class BasicEventCallback
   {
      
      public static const URL_KEY_METR:String = "metr";
      
      public static const URL_KEY_INIT:String = "init";
      
      public static const URL_KEY_CONCRETE_EVENT_ID:String = "creid";
      
      public static const SHORT_EVENT_TYPE_CLICK:String = "c";
      
      public static const URL_KEY_CREATIVE_RENDITION_ID:String = "reid";
      
      private static var logger:ILogger = Log.getLogger("AdManager.BasicEventCallback");
      
      public static const TYPE_CUSTOM_EVENT:uint = 3;
      
      public static const URL_KEY_KEY_VALUES:String = "kv";
      
      public static const URL_KEY_LAST:String = "last";
      
      public static const URL_KEY_ADDITIONAL:String = "additional";
      
      public static const SHORT_EVENT_TYPE_ERROR:String = "e";
      
      public static const TYPE_STANDARD_IAB:uint = 5;
      
      public static const URL_KEY_EVENT_NAME:String = "cn";
      
      public static const TYPE_CLICK:uint = 2;
      
      public static const URL_KEY_ABSTRACT_EVNET_ID:String = "absid";
      
      public static const TYPE_UNKNOWN:uint = 0;
      
      public static const TYPE_GLOBAL_ERROR:uint = 9;
      
      public static const TYPE_ERROR:uint = 7;
      
      public static const URL_KEY_RENDERER:String = "renderer";
      
      public static const TYPE_VIDEO_VIEW:uint = 10;
      
      public static const URL_KEY_TRIGGER_EVENT_ID:String = "trigid";
      
      public static const SHORT_EVENT_TYPE_STANDARD:String = "s";
      
      private static const MACRO_PARAMETER:String = "parameter.";
      
      public static const TYPE_DEFAULT_IMPRESSION:uint = 1;
      
      public static const SHORT_EVENT_TYPE_IMPRESSION:String = "i";
      
      public static const URL_KEY_EVENT_TYPE:String = "et";
      
      public static const INIT_VALUE_TWO:String = "2";
      
      public static const URL_KEY_CR:String = "cr";
      
      public static const URL_KEY_CT:String = "ct";
      
      private static const CLASSNAME:String = "BasicEventCallback";
      
      private static const MACRO_CE:String = "ce";
      
      public static const INIT_VALUE_ZERO:String = "0";
      
      public static const TYPE_QUARTILE:uint = 4;
      
      public static const INIT_VALUE_ONE:String = "1";
      
      public static const TYPE_SLOT_IMPRESSION:uint = 8;
      
      public static const SHORT_EVENT_TYPE_ACTION:String = "a";
      
      private static const TABLE_FULL_SHORT_EVENT_TYPE:Array = [[SHORT_EVENT_TYPE_IMPRESSION,SHORT_EVENT_TYPE_ACTION,SHORT_EVENT_TYPE_CLICK,SHORT_EVENT_TYPE_STANDARD,SHORT_EVENT_TYPE_ERROR],[Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,Constants.instance.EVENTCALLBACK_TYPE_ACTION,Constants.instance.EVENTCALLBACK_TYPE_CLICK,Constants.instance.EVENTCALLBACK_TYPE_STANDARD,Constants.instance.EVENTCALLBACK_TYPE_ERROR]];
       
      
      protected var _context:Contexts;
      
      protected var _needProcessTrackingUrls:Boolean = true;
      
      protected var _event:EventCallback;
      
      public function BasicEventCallback(param1:EventCallback, param2:Contexts)
      {
         super();
         this._event = param1;
         this._context = param2;
      }
      
      public static function getShortEventTypeByEventType(param1:String) : String
      {
         var _loc2_:int = int(TABLE_FULL_SHORT_EVENT_TYPE[1].indexOf(param1));
         if(_loc2_ > -1)
         {
            return TABLE_FULL_SHORT_EVENT_TYPE[0][_loc2_];
         }
         return null;
      }
      
      protected static function getEvent(param1:Array, param2:String, param3:String, param4:Boolean) : EventCallback
      {
         var _loc5_:EventCallback = null;
         if(param3 == Constants.instance.EVENTCALLBACK_TYPE_ERROR)
         {
            _loc5_ = EventCallback.findEvent(param1,null,Constants.instance.EVENTCALLBACK_TYPE_GENERIC,false);
         }
         else
         {
            _loc5_ = EventCallback.findEvent(param1,param2,param3,param4);
         }
         if(_loc5_)
         {
            (_loc5_ = _loc5_.clone()).name = param2;
            _loc5_.type = param3;
         }
         return _loc5_;
      }
      
      public static function getEventTypeByShortEventType(param1:String) : String
      {
         var _loc2_:int = int(TABLE_FULL_SHORT_EVENT_TYPE[0].indexOf(param1));
         if(_loc2_ > -1)
         {
            return TABLE_FULL_SHORT_EVENT_TYPE[1][_loc2_];
         }
         return null;
      }
      
      protected function getAdPlayheadTime() : int
      {
         return -1;
      }
      
      public function toString() : String
      {
         return "BasicEventCallback.";
      }
      
      protected function getCreativeAssetLocation() : String
      {
         return null;
      }
      
      private function getVastContentPlayhead(param1:Number) : String
      {
         var _loc2_:int = int(param1);
         var _loc3_:int = param1 % 60;
         var _loc5_:int;
         var _loc4_:int;
         return ((_loc5_ = (_loc4_ = param1 / 60 % 60) / 3600) < 10 ? "0" : "") + _loc5_.toString() + ":" + (_loc4_ < 10 ? "0" : "") + _loc4_.toString() + ":" + (_loc3_ < 10 ? "0" : "") + _loc3_.toString() + ".000";
      }
      
      protected function processTrackingUrls() : void
      {
         if(!this._needProcessTrackingUrls)
         {
            return;
         }
         var _loc1_:Array = this.getTrackingUrls();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            Communication.getInstance().send(_loc1_[_loc2_]);
            _loc2_++;
         }
      }
      
      protected function getRawTrackingUrls() : Array
      {
         return this._event.getTrackingUrls();
      }
      
      private function replaceMacrosInUrl(param1:String) : String
      {
         var crValue:String;
         var owner:BasicEventCallback = null;
         var url:String = param1;
         if(SuperString.isNull(url))
         {
            return url;
         }
         owner = this;
         url = url.replace(/#(ce?)\{([^\}]+)\}/g,function(param1:String, param2:String, param3:String, param4:int, param5:String):String
         {
            var _loc8_:* = undefined;
            var _loc9_:* = undefined;
            var _loc10_:* = undefined;
            var _loc11_:* = undefined;
            var _loc6_:* = param2 == MACRO_CE;
            var _loc7_:* = null;
            switch(param3)
            {
               case "ad.playheadTime":
                  _loc7_ = (_loc8_ = owner.getAdPlayheadTime()) >= 0 ? _loc8_.toString() : "";
                  break;
               case "content.playheadTime":
                  _loc7_ = (_loc9_ = owner._context.adManagerContext.getVideoPlayheadTime()) >= 0 ? int(_loc9_).toString() : "";
                  break;
               case "content.playheadTime.vast":
                  _loc7_ = (_loc10_ = owner._context.adManagerContext.getVideoPlayheadTime()) >= 0 ? int(_loc10_).toString() : "";
                  _loc7_ = getVastContentPlayhead(_loc7_);
                  break;
               case "creative.assetLocation":
                  _loc7_ = owner.getCreativeAssetLocation();
                  break;
               default:
                  if((_loc11_ = param3.indexOf(MACRO_PARAMETER)) == 0)
                  {
                     _loc7_ = owner.getParameter(param3.substr(MACRO_PARAMETER.length));
                  }
            }
            if(SuperString.isNull(_loc7_))
            {
               _loc7_ = "";
            }
            return !!_loc6_ ? encodeURIComponent(_loc7_) : _loc7_;
         });
         crValue = URLTools.getURLField(url,URL_KEY_CR);
         if(!SuperString.isNull(crValue))
         {
            url = URLTools.replaceUrlParam(url,URL_KEY_CR,this.replaceMacrosInUrl(crValue));
         }
         return url;
      }
      
      public function getTrackingUrls() : Array
      {
         var _loc4_:String = null;
         var _loc1_:Array = this.getRawTrackingUrls();
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = SuperString.trim(this.replaceMacrosInUrl(_loc1_[_loc3_]));
            if(!SuperString.isNull(_loc4_))
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      protected function getParameter(param1:String) : Object
      {
         return this._context.requestContext.getParameter(param1);
      }
      
      public function getType() : uint
      {
         return BasicEventCallback.TYPE_UNKNOWN;
      }
      
      public function getUrl(param1:Boolean = true) : String
      {
         this.initParameters();
         return this.replaceMacrosInUrl(this._event.url);
      }
      
      protected function initParameters() : void
      {
      }
      
      public function process() : void
      {
         var _loc1_:String = this.getUrl();
         this.processTrackingUrls();
         if(!SuperString.isNull(_loc1_))
         {
            Communication.getInstance().send(_loc1_);
         }
      }
      
      public function dispose() : void
      {
         this._event = null;
      }
   }
}
