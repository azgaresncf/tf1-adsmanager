package tv.freewheel.ad.vo.adRenderer
{
   import flash.display.Sprite;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.utils.basic.Arrays;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class AdRenderer
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.AdRenderer");
      
      private static var SLOT_TYPE_NOT_MATCH:String = "an_invalid_slot_type";
      
      private static var SLOT_TYPE_MAP:Array = [{
         "key":"VIDEOPLAYERNONTEMPORAL",
         "value":[Constants.instance.SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL]
      },{
         "key":"NONTEMPORAL",
         "value":[Constants.instance.SLOT_TYPE_SITESECTION_NONTEMPORAL]
      },{
         "key":"PREROLL",
         "value":[Constants.instance.TIME_POSITION_CLASS_PREROLL]
      },{
         "key":"MIDROLL",
         "value":[Constants.instance.TIME_POSITION_CLASS_MIDROLL]
      },{
         "key":"PAUSE_MIDROLL",
         "value":[Constants.instance.TIME_POSITION_CLASS_PAUSE_MIDROLL]
      },{
         "key":"POSTROLL",
         "value":[Constants.instance.TIME_POSITION_CLASS_POSTROLL]
      },{
         "key":"OVERLAY",
         "value":[Constants.instance.TIME_POSITION_CLASS_OVERLAY]
      },{
         "key":"EXTERNAL_DISPLAY",
         "value":[Constants.instance.SLOT_TYPE_SITESECTION_NONTEMPORAL]
      },{
         "key":"INPLAYER_DISPLAY",
         "value":[Constants.instance.SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL]
      },{
         "key":"VIDEO",
         "value":[Constants.instance.TIME_POSITION_CLASS_PREROLL,Constants.instance.TIME_POSITION_CLASS_MIDROLL,Constants.instance.TIME_POSITION_CLASS_POSTROLL]
      },{
         "key":"DISPLAY",
         "value":[Constants.instance.SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL,Constants.instance.SLOT_TYPE_SITESECTION_NONTEMPORAL]
      },{
         "key":"TEMPORAL",
         "value":[Constants.instance.SLOT_TYPE_TEMPORAL]
      }];
       
      
      public var contentTypes:Array;
      
      public var adUnits:Array;
      
      public var soAdUnits:Array;
      
      public var slotTypes:Array;
      
      public var className:String;
      
      private var originUrl:String;
      
      public var parameters:Array;
      
      public var creativeAPIs:Array;
      
      private var adRendererSet:AdRendererSet;
      
      public function AdRenderer(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:AdRendererSet)
      {
         super();
         this.originUrl = SuperString.trim(param1);
         this.className = SuperString.trim(param2);
         this.adUnits = Arrays.splitWithTrim(param3);
         this.contentTypes = Arrays.splitWithTrim(param4);
         this.slotTypes = Arrays.trimStringArray(this.translateSlotType(param5));
         this.soAdUnits = Arrays.splitWithTrim(param6);
         this.creativeAPIs = Arrays.splitWithTrim(param7);
         this.adRendererSet = param8;
         this.parameters = new Array();
      }
      
      public function addParameter(param1:String, param2:String) : void
      {
         Parameter.addParameterToArray(this.parameters,param1,param2);
      }
      
      private function translateSlotType(param1:String) : Array
      {
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc2_:Array = new Array();
         var _loc3_:String = SuperString.trim(param1);
         if(SuperString.isNull(_loc3_))
         {
            return _loc2_;
         }
         var _loc4_:Array = _loc3_.split(",");
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = String(_loc4_[_loc5_]);
            _loc7_ = 0;
            while(_loc7_ < SLOT_TYPE_MAP.length)
            {
               if(SuperString.equals(SLOT_TYPE_MAP[_loc7_].key,_loc6_,false))
               {
                  _loc2_ = _loc2_.concat(SLOT_TYPE_MAP[_loc7_].value);
                  break;
               }
               _loc7_++;
            }
            _loc5_++;
         }
         if(_loc2_.length == 0)
         {
            _loc2_.push(SLOT_TYPE_NOT_MATCH);
         }
         return _loc2_;
      }
      
      private function checkIsMatchedByField(param1:String, param2:String) : Boolean
      {
         var _loc4_:int = 0;
         param1 = SuperString.trim(param1);
         var _loc3_:Array = this[param2];
         if(_loc3_ == null)
         {
            logger.error(this + ".checkIsMatchedByField, invalid field " + param2);
            return false;
         }
         if(_loc3_.length == 0)
         {
            return true;
         }
         if(SuperString.isNull(param1))
         {
            return false;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(SuperString.equalsIgnoreCase(param1,_loc3_[_loc4_]))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function get id() : String
      {
         return (this.url || "") + (this.className || "");
      }
      
      public function isTranslator() : Boolean
      {
         return !SuperString.isNull(this.originUrl) && this.originUrl.toLowerCase().indexOf("translator") > -1;
      }
      
      private function checkIsMatchLocation(param1:Sprite) : Boolean
      {
         var _loc2_:String = !!this.className ? this.className : "";
         var _loc3_:String = !!this.originUrl ? this.originUrl : "";
         if((_loc2_.search("ExternalHTML") > -1 || _loc3_.search("ExternalHTML") > -1) && Boolean(param1))
         {
            return false;
         }
         if((_loc2_.search("TraditionalFlash") > -1 || _loc3_.indexOf("TraditionalFlash") > -1) && !param1)
         {
            return false;
         }
         return true;
      }
      
      public function toString() : String
      {
         return "[AdRenderer originUrl:" + this.originUrl + ", className:" + this.className + ", contentTypes: " + this.contentTypes.join(",") + ", creativeAPIs: " + this.creativeAPIs.join(",") + "]";
      }
      
      public function checkIsMatched(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:Sprite) : Boolean
      {
         var _loc9_:Boolean;
         if(((_loc9_ = SuperString.isNull(param6)) || this.checkIsMatchedByField(param6,"contentTypes")) && (!_loc9_ || this.checkIsMatchedByField(param1,"contentTypes")) && (!_loc9_ || this.checkIsMatchedByField(param7,"creativeAPIs")) && this.checkIsMatchedByField(param2,"adUnits") && this.checkIsMatchedByField(param5,"soAdUnits") && this.checkIsMatchLocation(param8))
         {
            if(this.checkIsMatchedByField(param3,"slotTypes") || !SuperString.isNull(param4) && this.checkIsMatchedByField(param4,"slotTypes"))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getParameter(param1:String) : String
      {
         return Parameter.getParameterFromArray(this.parameters,param1);
      }
      
      public function get url() : String
      {
         var _loc1_:String = this.adRendererSet.rendererPathPrefix;
         return !SuperString.isNull(this.originUrl) && !SuperString.isNull(_loc1_) && !URLTools.isHTTP(this.originUrl) ? _loc1_ + this.originUrl : this.originUrl;
      }
   }
}
