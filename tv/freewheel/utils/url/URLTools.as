package tv.freewheel.utils.url
{
   import tv.freewheel.utils.basic.Base64;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.basic.SuperString;
   
   public class URLTools
   {
      
      public static const DATA_URL_XML_BASE64_PREFIX:String = "data:text/xml;base64,";
      
      public static const DATA_URL_XML_PREFIX:String = "data:text/xml;";
       
      
      public function URLTools()
      {
         super();
      }
      
      public static function getXMLDataFromURL(param1:String) : String
      {
         var _loc2_:Number = NaN;
         if(SuperString.isNull(param1) || !isXMLData(param1))
         {
            return param1;
         }
         if(param1.toLowerCase().indexOf(DATA_URL_XML_BASE64_PREFIX) == 0)
         {
            _loc2_ = DATA_URL_XML_BASE64_PREFIX.length;
            return Base64.decode(param1.substr(_loc2_,param1.length - _loc2_));
         }
         _loc2_ = DATA_URL_XML_PREFIX.length;
         return param1.substr(_loc2_,param1.length - _loc2_);
      }
      
      public static function hasValueInQueryString(param1:String, param2:String) : Boolean
      {
         var _loc6_:Array = null;
         if(SuperString.isNull(param1) || SuperString.isNull(param2))
         {
            return false;
         }
         var _loc3_:String = String(param1.split("?")[1]);
         if(SuperString.isNull(_loc3_))
         {
            return false;
         }
         var _loc4_:Array = _loc3_.split("&");
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_].split("=");
            if(SuperString.trim(decodeURI(_loc6_[0])) == param2 && !SuperString.isNull(SuperString.trim(decodeURI(_loc6_[1]))))
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function decodeURI(param1:String) : String
      {
         var uri:String = param1;
         if(SuperString.isNull(uri))
         {
            return uri;
         }
         try
         {
            uri = decodeURIComponent(uri);
         }
         catch(e:Error)
         {
         }
         return uri;
      }
      
      public static function hasQueryString(param1:String, param2:String) : Boolean
      {
         var _loc6_:Array = null;
         if(SuperString.isNull(param1) || SuperString.isNull(param2))
         {
            return false;
         }
         var _loc3_:String = String(param1.split("?")[1]);
         if(SuperString.isNull(_loc3_))
         {
            return false;
         }
         var _loc4_:Array = _loc3_.split("&");
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_].split("=");
            if(SuperString.trim(decodeURI(_loc6_[0])) == param2)
            {
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public static function getBaseURL(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:String = SuperString.trim(param1);
         if(_loc2_.lastIndexOf("/") > 8)
         {
            _loc2_ = _loc2_.substr(0,_loc2_.indexOf("/",8));
         }
         return _loc2_;
      }
      
      public static function isSecureHTTP(param1:String) : Boolean
      {
         if(SuperString.isNull(param1))
         {
            return false;
         }
         return param1.toLowerCase().indexOf("https://") == 0;
      }
      
      public static function getURLField(param1:String, param2:String) : String
      {
         var _loc6_:Array = null;
         if(param1 == null || param2 == null)
         {
            return null;
         }
         var _loc3_:String = String(param1.split("?")[1]);
         if(SuperString.isNull(_loc3_))
         {
            return null;
         }
         var _loc4_:Array = _loc3_.split("&");
         var _loc5_:Number = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_].split("=");
            if(decodeURI(_loc6_[0]) == param2 && !SuperString.isNull(_loc6_[1]))
            {
               return SuperString.trim(decodeURI(_loc6_[1]));
            }
            _loc5_++;
         }
         return null;
      }
      
      public static function addKeyValuesInUrl(param1:String, param2:HashMap) : String
      {
         var _loc4_:String = null;
         if(param2 == null || param1 == "" || param1 == null || param2.size() == 0)
         {
            return param1;
         }
         var _loc3_:Array = param2.getKeys();
         var _loc5_:String = "";
         _loc4_ = String(_loc3_[0]);
         _loc5_ += encodeURIComponent(_loc4_) + "=" + encodeURIComponent(String(param2.get(_loc4_)));
         var _loc6_:int = 1;
         while(_loc6_ < _loc3_.length)
         {
            _loc4_ = String(_loc3_[_loc6_]);
            _loc5_ += "&" + encodeURIComponent(_loc4_) + "=" + encodeURIComponent(String(param2.get(_loc4_)));
            _loc6_++;
         }
         var _loc7_:Array;
         return (_loc7_ = param1.split("?"))[0] + "?" + "kv=" + encodeURIComponent(_loc5_) + (!!_loc7_[1] ? "&" + _loc7_[1] : "");
      }
      
      public static function isHTTP(param1:String) : Boolean
      {
         if(SuperString.isNull(param1))
         {
            return false;
         }
         return param1.toLowerCase().indexOf("http://") == 0 || param1.toLowerCase().indexOf("https://") == 0;
      }
      
      public static function isSameDomain(param1:String, param2:String) : Boolean
      {
         var _loc3_:String = URLTools.getDomain(param1).toLowerCase();
         var _loc4_:String = URLTools.getDomain(param2).toLowerCase();
         return _loc3_ == _loc4_;
      }
      
      public static function isXMLData(param1:String) : Boolean
      {
         if(SuperString.isNull(param1))
         {
            return false;
         }
         return param1.toLowerCase().indexOf(DATA_URL_XML_PREFIX) == 0;
      }
      
      public static function replaceUrlParam(param1:String, param2:String, param3:String, param4:Boolean = true) : String
      {
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         param2 = SuperString.trim(param2);
         if(SuperString.isNull(param1) || SuperString.isNull(param2) || param3 == null)
         {
            return param1;
         }
         var _loc5_:String;
         if(!(_loc5_ = String(param1.split("?")[1])))
         {
            _loc5_ = "";
         }
         var _loc6_:Array = _loc5_.split("&");
         var _loc7_:Array = new Array();
         var _loc8_:Boolean = false;
         var _loc9_:uint = 0;
         while(_loc9_ < _loc6_.length)
         {
            _loc10_ = _loc6_[_loc9_].split("=");
            if(SuperString.trim(decodeURI(_loc10_[0])) == param2)
            {
               _loc8_ = true;
               _loc10_[0] = encodeURIComponent(param2);
               _loc10_[1] = encodeURIComponent(param3);
            }
            _loc7_.push(_loc10_.join("="));
            _loc9_++;
         }
         if(_loc8_)
         {
            return param1.split("?")[0] + "?" + _loc7_.join("&");
         }
         if(param4)
         {
            _loc11_ = param1.split("?");
            if(SuperString.equals(param2,"cr"))
            {
               _loc12_ = String(!!_loc11_[1] ? _loc11_[1] + "&" : "");
               return _loc11_[0] + "?" + _loc12_ + encodeURIComponent(param2) + "=" + encodeURIComponent(param3);
            }
            _loc12_ = String(!!_loc11_[1] ? "&" + _loc11_[1] : "");
            return _loc11_[0] + "?" + encodeURIComponent(param2) + "=" + encodeURIComponent(param3) + _loc12_;
         }
         return param1;
      }
      
      public static function getDomain(param1:String) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:String = URLTools.getBaseURL(param1);
         if(_loc2_.indexOf("/") > -1)
         {
            _loc2_ = _loc2_.substr(_loc2_.lastIndexOf("/") + 1);
         }
         if(_loc2_.indexOf(":") > -1)
         {
            _loc2_ = _loc2_.substr(0,_loc2_.lastIndexOf(":"));
         }
         return _loc2_;
      }
      
      public static function isValidUrl(param1:String) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         var _loc2_:String = getDomain(param1);
         if(_loc2_.split(".").length > 2)
         {
            return true;
         }
         return false;
      }
   }
}
