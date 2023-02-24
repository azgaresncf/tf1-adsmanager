package tv.freewheel.utils.basic
{
   public class Arrays
   {
       
      
      public function Arrays()
      {
         super();
      }
      
      public static function splitWithTrim(param1:String) : Array
      {
         var _loc2_:String = SuperString.trim(param1);
         if(SuperString.isNull(_loc2_))
         {
            return new Array();
         }
         var _loc3_:Array = _loc2_.split(",");
         return Arrays.trimStringArray(_loc3_);
      }
      
      public static function getByProperty(param1:Array, param2:String, param3:*) : Number
      {
         var _loc4_:Number = param1.length;
         var _loc5_:Number = 0;
         while(_loc5_ < _loc4_)
         {
            if(param1[_loc5_][param2] != undefined && param1[_loc5_][param2] == param3)
            {
               return _loc5_;
            }
            _loc5_++;
         }
         return -1;
      }
      
      public static function next(param1:Array, param2:Object) : Object
      {
         var _loc3_:Number = param1.indexOf(param2);
         if(_loc3_ >= 0)
         {
            return param1[_loc3_ + 1];
         }
         return null;
      }
      
      public static function pushAt(param1:Array, param2:Number, param3:*) : void
      {
         if(param2 > param1.length)
         {
            param1.push(param3);
         }
         else if(param2 > -1)
         {
            param1.splice(param2,0,param3);
         }
      }
      
      public static function trimStringArray(param1:Array) : Array
      {
         var _loc4_:String = null;
         var _loc2_:Array = new Array();
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = SuperString.trim(param1[_loc3_]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function removeAt(param1:Array, param2:Number) : Array
      {
         if(param2 == 0)
         {
            param1.shift();
            return param1;
         }
         if(param2 == param1.length - 1)
         {
            param1.pop();
            return param1;
         }
         if(param2 > 0 && param2 < param1.length - 1)
         {
            param1.splice(param2,1);
            return param1;
         }
         return null;
      }
      
      public static function compact(param1:Array) : Array
      {
         var filterNull:Function;
         var a:Array = param1;
         if(!a)
         {
            return null;
         }
         filterNull = function(param1:Object, param2:int, param3:Array):Boolean
         {
            return param1 != null;
         };
         return a.filter(filterNull);
      }
      
      public static function clone(param1:Array) : Array
      {
         return param1.slice();
      }
   }
}
