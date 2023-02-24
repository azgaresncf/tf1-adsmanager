package tv.freewheel.utils.basic
{
   public class Delegate
   {
       
      
      public function Delegate()
      {
         super();
      }
      
      public static function create(param1:Function, ... rest) : Function
      {
         var func:Function = param1;
         var arg:Array = rest;
         var _f:Function = function(... rest):void
         {
            func.apply(null,rest.concat(arg));
         };
         return _f;
      }
   }
}
