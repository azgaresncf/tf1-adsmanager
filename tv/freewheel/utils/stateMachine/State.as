package tv.freewheel.utils.stateMachine
{
   public class State
   {
       
      
      public var exit:Function;
      
      public var _parent:State;
      
      public var from:Object;
      
      public var name:String;
      
      public var enter:Function;
      
      public var children:Array;
      
      public function State(param1:String, param2:Object = null, param3:Function = null, param4:Function = null, param5:State = null)
      {
         super();
         this.name = param1;
         if(!param2)
         {
            param2 = "*";
         }
         this.from = param2;
         this.enter = param3;
         this.exit = param4;
         this.children = [];
         if(param5)
         {
            this._parent = param5;
            this._parent.children.push(this);
         }
      }
      
      public function get parents() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:State = this._parent;
         if(_loc2_)
         {
            _loc1_.push(_loc2_);
            while(_loc2_.parent)
            {
               _loc2_ = _loc2_.parent;
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function get root() : State
      {
         var _loc1_:State = this._parent;
         if(_loc1_)
         {
            while(_loc1_.parent)
            {
               _loc1_ = _loc1_.parent;
            }
         }
         return _loc1_;
      }
      
      public function toString() : String
      {
         return this.name;
      }
      
      public function get parent() : State
      {
         return this._parent;
      }
      
      public function set parent(param1:State) : void
      {
         this._parent = param1;
         this._parent.children.push(this);
      }
   }
}
