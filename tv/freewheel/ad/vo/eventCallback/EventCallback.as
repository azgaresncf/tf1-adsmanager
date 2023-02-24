package tv.freewheel.ad.vo.eventCallback
{
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.log.Logger;
   
   public class EventCallback
   {
      
      private static var _useJSToOpenNewWindow:Number = -1;
       
      
      public var usage:String;
      
      public var name:String;
      
      public var showBrowser:Boolean;
      
      public var url:String;
      
      public var trackingUrlNodes:Array;
      
      public var type:String;
      
      public function EventCallback(param1:String, param2:String, param3:String, param4:String, param5:Boolean, param6:Array)
      {
         super();
         this.usage = param1;
         this.type = param2;
         this.name = param3;
         this.url = param4;
         this.showBrowser = param5;
         this.trackingUrlNodes = param6;
         if(this.trackingUrlNodes == null)
         {
            this.trackingUrlNodes = new Array();
         }
      }
      
      public static function findEvent(param1:Array, param2:String, param3:String, param4:Boolean) : EventCallback
      {
         var _loc7_:EventCallback = null;
         var _loc5_:EventCallback = null;
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            _loc7_ = param1[_loc6_];
            if(param3 == null)
            {
               if(SuperString.equalsIgnoreCase(_loc7_.name,param2))
               {
                  _loc5_ = _loc7_;
                  break;
               }
            }
            else if(SuperString.equalsIgnoreCase(_loc7_.type,param3))
            {
               if(param2 == null && param3 == Constants.instance.EVENTCALLBACK_TYPE_GENERIC)
               {
                  _loc5_ = _loc7_;
                  break;
               }
               if(SuperString.equalsIgnoreCase(_loc7_.name,param2))
               {
                  _loc5_ = _loc7_;
                  break;
               }
            }
            _loc6_++;
         }
         if(_loc5_ == null && param4)
         {
            _loc5_ = getGenericCallback(param1);
         }
         return _loc5_;
      }
      
      public static function openNewWindow(param1:String) : Boolean
      {
         var url:String = param1;
         if(!SuperString.isNull(url))
         {
            try
            {
               if(useJSToOpenNewWindow())
               {
                  ExternalInterface.call("window.open",url,"_blank");
               }
               else
               {
                  navigateToURL(new URLRequest(url),"_blank");
               }
               return true;
            }
            catch(e:*)
            {
               Logger.instance.error("Error in opening new window for " + url + " . " + e);
               return false;
            }
         }
         else
         {
            return false;
         }
      }
      
      public static function parseEventCallbacks(param1:XMLNode) : Array
      {
         var _loc4_:XMLNode = null;
         var _loc5_:Array = null;
         var _loc6_:EventCallback = null;
         var _loc2_:Array = [];
         if(!param1)
         {
            return _loc2_;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < param1.childNodes.length)
         {
            if((_loc4_ = param1.childNodes[_loc3_]).localName == InnerConstants.TAG_EVENT_CALL_BACK)
            {
               _loc5_ = parseTrackingUrlNodes(_loc4_);
               _loc6_ = new EventCallback(_loc4_.attributes[InnerConstants.ATTR_EVENT_CALL_BACK_USE],_loc4_.attributes[InnerConstants.ATTR_EVENT_CALL_BACK_TYPE],_loc4_.attributes[InnerConstants.ATTR_EVENT_CALL_BACK_NAME],_loc4_.attributes[InnerConstants.ATTR_EVENT_CALL_BACK_URL],_loc4_.attributes[InnerConstants.ATTR_EVENT_CALL_BACK_SHOW_BROWSER] == "true",_loc5_);
               _loc2_.push(_loc6_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getErrorNameByCode(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case Constants.instance.ERROR_IO:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_IO;
               break;
            case Constants.instance.ERROR_NETWORK:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_NETWORK;
               break;
            case Constants.instance.ERROR_NO_AD_AVAILABLE:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_NO_AD_AVAILABLE;
               break;
            case Constants.instance.ERROR_SECURITY:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_SECURITY;
               break;
            case Constants.instance.ERROR_TIMEOUT:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_TIMEOUT;
               break;
            case Constants.instance.ERROR_INVALID_VALUE:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_INVALID_VALUE;
               break;
            case Constants.instance.ERROR_MISSING_PARAMETER:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_MISSING_PARAMETER;
               break;
            case Constants.instance.ERROR_EXTERNAL_INTERFACE:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_EXTERNAL_INTERFACE;
               break;
            case Constants.instance.ERROR_3P_COMPONENT:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_3P_COMPONENT;
               break;
            case Constants.instance.ERROR_NULL_ASSET:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_NULL_ASSET;
               break;
            case Constants.instance.ERROR_INVALID_SLOT:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_INVALID_SLOT;
               break;
            case Constants.instance.ERROR_ADINSTANCE_UNAVAILABLE:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_ADINSTANCE_UNAVAILABLE;
               break;
            case Constants.instance.ERROR_PARSE_ERROR:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_PARSE_ERROR;
               break;
            case Constants.instance.ERROR_UNSUPPORTED_3P_FEATURE:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_UNSUPPORTED_3P_FEATURE;
               break;
            case Constants.instance.ERROR_UNMATCHED_SLOT_SIZE:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_UNMATCHED_SLOT_SIZE;
               break;
            case Constants.instance.ERROR_SLOT_UNAVAILABLE:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_SLOT_UNAVAILABLE;
               break;
            case InnerConstants.ERROR_NO_RENDERER:
               _loc2_ = "_e_no-renderer";
               break;
            case InnerConstants.ERROR_RENDERER_LOAD:
               _loc2_ = "_e_renderer-load";
               break;
            case InnerConstants.ERROR_RENDERER_INIT:
               _loc2_ = "_e_renderer-init";
               break;
            case InnerConstants.ERROR_RENDERER_INVALID_STATE_REQUEST:
               _loc2_ = "_e_renderer-invalid-state-request";
               break;
            case InnerConstants.ERROR_OVERFLOW_SKIPPED:
               _loc2_ = "_e_overflow-skipped";
               break;
            default:
               _loc2_ = Constants.instance.EVENTCALLBACK_ERROR_UNKNOWN;
         }
         return _loc2_;
      }
      
      public static function useJSToOpenNewWindow() : Boolean
      {
         if(_useJSToOpenNewWindow == -1)
         {
            _useJSToOpenNewWindow = 0;
            try
            {
               if(ExternalInterface.available && ExternalInterface.call("function(){ return navigator.appVersion.match(/\\bMSIE\\b/)!=null || navigator.appVersion.match(/\\bTrident\\b/)!=null;}"))
               {
                  _useJSToOpenNewWindow = 1;
               }
            }
            catch(e:Error)
            {
            }
         }
         return _useJSToOpenNewWindow == 1;
      }
      
      private static function parseTrackingUrlNodes(param1:XMLNode) : Array
      {
         var _loc4_:XMLNode = null;
         var _loc5_:int = 0;
         var _loc6_:XMLNode = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.childNodes.length)
         {
            if((_loc4_ = param1.childNodes[_loc3_]).localName == InnerConstants.TAG_TRACKING_URLS)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.childNodes.length)
               {
                  if((_loc6_ = _loc4_.childNodes[_loc5_]).localName == InnerConstants.TAG_TRACKING_URL)
                  {
                     _loc2_.push({
                        "name":_loc6_.attributes[InnerConstants.ATTR_TRACKING_URL_NAME],
                        "value":_loc6_.attributes[InnerConstants.ATTR_TRACKING_URL_VALUE]
                     });
                  }
                  _loc5_++;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getGenericCallback(param1:Array) : EventCallback
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            if(EventCallback(param1[_loc2_]).type == Constants.instance.EVENTCALLBACK_TYPE_GENERIC)
            {
               return EventCallback(param1[_loc2_]);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function clone() : EventCallback
      {
         return new EventCallback(this.usage,this.type,this.name,this.url,this.showBrowser,this.trackingUrlNodes.slice());
      }
      
      public function toString() : String
      {
         return "[EventCallback " + this.name + ", " + this.type + "]";
      }
      
      public function getTrackingUrls() : Array
      {
         var _loc3_:String = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.trackingUrlNodes.length)
         {
            _loc3_ = SuperString.trim(this.trackingUrlNodes[_loc2_].value);
            if(!SuperString.isNull(_loc3_))
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
