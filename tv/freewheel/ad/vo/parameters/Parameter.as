package tv.freewheel.ad.vo.parameters
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.utils.basic.SuperString;
   
   public class Parameter
   {
       
      
      public var value:Object;
      
      public var name:String;
      
      public function Parameter(param1:String, param2:Object)
      {
         super();
         this.name = param1;
         this.value = param2;
      }
      
      public static function parseParametersToArray(param1:XMLNode, param2:Array) : void
      {
         var _loc4_:XMLNode = null;
         var _loc5_:String = null;
         if(!param2)
         {
            return;
         }
         var _loc3_:uint = 0;
         while(_loc3_ < param1.childNodes.length)
         {
            if((_loc4_ = param1.childNodes[_loc3_]).localName == InnerConstants.TAG_PARAMETER)
            {
               _loc5_ = null;
               if(_loc4_.firstChild)
               {
                  _loc5_ = _loc4_.firstChild.nodeValue;
               }
               Parameter.addParameterToArray(param2,_loc4_.attributes[InnerConstants.ATTR_PARAMETER_NAME],_loc5_);
            }
            _loc3_++;
         }
      }
      
      public static function getParameterFromArray(param1:Array, param2:String) : String
      {
         var _loc4_:Parameter = null;
         param2 = SuperString.trim(param2);
         if(SuperString.isNull(param2))
         {
            return null;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if((_loc4_ = param1[_loc3_]).name == param2)
            {
               if(_loc4_.value == null)
               {
                  return null;
               }
               return String(_loc4_.value);
            }
            _loc3_++;
         }
         return null;
      }
      
      public static function addParameterToArray(param1:Array, param2:String, param3:Object) : void
      {
         var _loc6_:Parameter = null;
         param2 = SuperString.trim(param2);
         if(SuperString.isNull(param2))
         {
            return;
         }
         var _loc4_:int = -1;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            if((_loc6_ = param1[_loc5_]).name == param2)
            {
               _loc4_ = _loc5_;
               break;
            }
            _loc5_++;
         }
         if(_loc4_ > -1)
         {
            if(param3 == null)
            {
               param1.splice(_loc4_,1);
            }
            else
            {
               Parameter(param1[_loc4_]).value = param3;
            }
         }
         else if(param3 != null)
         {
            param1.push(new Parameter(param2,param3));
         }
      }
      
      public function toObject() : Object
      {
         return {
            "name":this.name,
            "value":this.value
         };
      }
      
      public function clone() : Parameter
      {
         return new Parameter(this.name,this.value);
      }
   }
}
