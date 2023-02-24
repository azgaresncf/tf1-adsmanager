package tv.freewheel.utils.basic
{
   import flash.display.Sprite;
   
   public class SuperObject
   {
       
      
      public function SuperObject()
      {
         super();
      }
      
      public static function getId(param1:*, param2:int, param3:Array) : String
      {
         return param1.id;
      }
      
      public static function convertAttributesToCaseInsensitive(param1:Object) : Object
      {
         var _loc3_:String = null;
         var _loc2_:Object = new Object();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_.toLowerCase()] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getSortedKeys(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         _loc2_.sort();
         return _loc2_;
      }
      
      public static function isSprite(param1:*) : Boolean
      {
         return typeof param1 == "sprite" || param1 is Sprite;
      }
   }
}
