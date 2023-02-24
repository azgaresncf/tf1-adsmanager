package tv.freewheel.utils.basic
{
   import tv.freewheel.ad.vo.parameters.Parameter;
   
   public class HashMap
   {
       
      
      private var hash:Object;
      
      public function HashMap(param1:Array = null, param2:Array = null)
      {
         var _loc3_:uint = 0;
         super();
         this.hash = new Object();
         if(Boolean(param1) && Boolean(param2))
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               this.put(param1[_loc3_],param2[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function size() : Number
      {
         var _loc2_:String = null;
         var _loc1_:Number = 0;
         for(_loc2_ in this.hash)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function remove(param1:String, param2:Boolean = true) : void
      {
         param1 = SuperString.trim(param1);
         if(SuperString.isNull(param1))
         {
            return;
         }
         if(!param2)
         {
            param1 = param1.toLowerCase();
         }
         this.hash[param1] = null;
         this.clean();
      }
      
      public function clean() : void
      {
         var _loc2_:String = null;
         var _loc1_:Object = new Object();
         for(_loc2_ in this.hash)
         {
            if(this.hash[_loc2_] != null)
            {
               _loc1_[_loc2_] = this.hash[_loc2_];
            }
         }
         this.hash = _loc1_;
      }
      
      public function getKeys() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.hash)
         {
            _loc1_.push(_loc2_);
         }
         _loc1_.sort();
         return _loc1_;
      }
      
      public function toString() : String
      {
         var _loc2_:Object = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.hash)
         {
            _loc1_.push(_loc2_ + ":" + this.hash[_loc2_]);
         }
         return "{" + _loc1_.join(", ") + "}";
      }
      
      public function clear() : void
      {
         this.hash = new Object();
      }
      
      public function put(param1:String, param2:Object, param3:Boolean = true) : void
      {
         param1 = SuperString.trim(param1);
         if(SuperString.isNull(param1))
         {
            return;
         }
         if(!param3)
         {
            param1 = param1.toLowerCase();
         }
         this.hash[param1] = param2;
      }
      
      public function get(param1:String, param2:Boolean = true) : *
      {
         param1 = SuperString.trim(param1);
         if(SuperString.isNull(param1))
         {
            return null;
         }
         if(!param2)
         {
            param1 = param1.toLowerCase();
         }
         return this.hash[param1];
      }
      
      public function merge(param1:HashMap) : HashMap
      {
         var _loc2_:String = null;
         if(param1)
         {
            for each(_loc2_ in param1.getKeys())
            {
               this.put(_loc2_,param1.get(_loc2_));
            }
         }
         return this;
      }
      
      public function clone() : HashMap
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:HashMap = new HashMap();
         for(_loc2_ in this.hash)
         {
            _loc3_ = this.hash[_loc2_];
            if(_loc3_ is Array)
            {
               _loc1_.put(_loc2_,_loc3_.slice());
            }
            else
            {
               _loc1_.put(_loc2_,_loc3_);
            }
         }
         return _loc1_;
      }
      
      public function toArray() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.hash)
         {
            _loc1_.push(new Parameter(_loc2_,this.hash[_loc2_]));
         }
         return _loc1_;
      }
   }
}
