package tv.freewheel.utils.basic
{
   public class KeyValues extends HashMap
   {
       
      
      public function KeyValues()
      {
         super();
      }
      
      public function getList() : Array
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = super.getKeys();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = String(_loc2_[_loc3_]);
            _loc5_ = super.get(_loc4_) as Array;
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc7_ = _loc5_[_loc6_];
               (_loc8_ = new Object()).key = _loc4_;
               _loc8_.value = !!_loc7_ ? _loc7_ : "";
               _loc1_.push(_loc8_);
               _loc6_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      override public function put(param1:String, param2:Object, param3:Boolean = true) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         param1 = SuperString.trim(param1);
         if(SuperString.isNull(param1))
         {
            return;
         }
         if(!param3)
         {
            param1 = param1.toLowerCase();
         }
         var _loc4_:Array;
         if((_loc4_ = super.get(param1) as Array) == null)
         {
            _loc4_ = new Array(param2);
            super.put(param1,_loc4_);
         }
         else
         {
            _loc5_ = false;
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               if(param2 == _loc4_[_loc6_])
               {
                  _loc5_ = true;
                  break;
               }
               _loc6_++;
            }
            if(!_loc5_)
            {
               _loc4_.push(param2);
            }
         }
      }
   }
}
