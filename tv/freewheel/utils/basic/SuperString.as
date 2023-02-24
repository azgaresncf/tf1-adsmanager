package tv.freewheel.utils.basic
{
   public class SuperString
   {
       
      
      public function SuperString()
      {
         super();
      }
      
      public static function isNull(param1:String) : Boolean
      {
         if(!param1 || param1 == null || param1 == "")
         {
            return true;
         }
         return false;
      }
      
      public static function equals(param1:String, param2:String, param3:Boolean = true) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(SuperString.isNull(param1) || SuperString.isNull(param2))
         {
            return false;
         }
         if(!param3)
         {
            param1 = param1.toUpperCase();
            param2 = param2.toUpperCase();
         }
         if(param1 == param2)
         {
            return true;
         }
         if(param1.indexOf(param2) > -1 || param2.indexOf(param1) > -1)
         {
            _loc4_ = SuperString.trim(param1);
            _loc5_ = SuperString.trim(param2);
            if(_loc4_ == _loc5_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function equalsIgnoreCase(param1:String, param2:String) : Boolean
      {
         if(SuperString.isNull(param1) || SuperString.isNull(param2))
         {
            return false;
         }
         return SuperString.equals(param1.toLowerCase(),param2.toLowerCase());
      }
      
      public static function trim(param1:String) : String
      {
         var _loc2_:String = param1;
         while(!SuperString.isNull(_loc2_) && _loc2_.indexOf(" ") == 0)
         {
            _loc2_ = _loc2_.substring(1,_loc2_.length);
         }
         while(!SuperString.isNull(_loc2_) && _loc2_.lastIndexOf(" ") == _loc2_.length - 1)
         {
            _loc2_ = _loc2_.substring(0,_loc2_.lastIndexOf(" "));
         }
         return _loc2_;
      }
      
      public static function objectToString(param1:Object, param2:String = "", param3:int = 0) : String
      {
         var a:Array;
         var typ:String;
         var needBracket:Boolean;
         var i:String = null;
         var obj:Object = param1;
         var name:String = param2;
         var depth:int = param3;
         if(depth >= 5)
         {
            return "";
         }
         depth++;
         a = [];
         typ = typeof obj;
         needBracket = false;
         if(typ == "object")
         {
            if(obj == null)
            {
               needBracket = false;
               a.push("null");
            }
            else if(obj is Array)
            {
               a.push("[" + (obj as Array).map(function(param1:Object, param2:int, param3:Array):String
               {
                  return objectToString(param1,"",depth);
               }).join(", ") + "]");
            }
            else
            {
               needBracket = true;
               for(i in obj)
               {
                  a.push(i + " : " + objectToString(obj[i],"",depth));
               }
            }
         }
         else if(typ == "string")
         {
            a.push("\"" + obj + "\"");
         }
         else if(name.indexOf("Color") > -1 && obj is int)
         {
            a.push(obj.toString(16));
         }
         else
         {
            a.push(obj);
         }
         if(needBracket)
         {
            return (!!name ? name + " : " : "") + "{" + a.join(", ") + "}";
         }
         return (!!name ? name + " : " : "") + a.join(", ");
      }
      
      public static function convertToUint(param1:String) : Number
      {
         var _loc3_:String = null;
         param1 = SuperString.trim(param1);
         if(SuperString.isNull(param1))
         {
            return 0;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1.charAt(_loc2_);
            if(_loc3_ < "0" || _loc3_ > "9")
            {
               return 0;
            }
            _loc2_++;
         }
         return uint(param1);
      }
   }
}
