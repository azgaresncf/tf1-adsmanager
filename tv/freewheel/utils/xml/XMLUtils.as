package tv.freewheel.utils.xml
{
   import flash.xml.XMLNode;
   import tv.freewheel.utils.basic.SuperString;
   
   public class XMLUtils
   {
       
      
      public function XMLUtils()
      {
         super();
      }
      
      public static function addBooleanAttribute(param1:String, param2:Boolean, param3:XMLNode) : void
      {
         XMLUtils.addAttribute(param1,String(param2),param3);
      }
      
      public static function addNumberAttribute(param1:String, param2:Number, param3:XMLNode, param4:Boolean = false, param5:Boolean = false) : void
      {
         if(isNaN(param2))
         {
            return;
         }
         if(param4)
         {
            if(param2 == 0 || !param5 && param2 < 0)
            {
               return;
            }
         }
         XMLUtils.addAttribute(param1,String(param2),param3);
      }
      
      public static function addStringAttribute(param1:String, param2:String, param3:XMLNode, param4:Boolean = false) : void
      {
         if(param4 && SuperString.isNull(param2))
         {
            return;
         }
         XMLUtils.addAttribute(param1,String(param2),param3);
      }
      
      private static function addAttribute(param1:String, param2:String, param3:XMLNode) : void
      {
         if(param3 == null || SuperString.isNull(param1))
         {
            return;
         }
         param3.attributes[param1] = param2;
      }
      
      public static function getDescendantNode(param1:XMLNode, param2:Array) : XMLNode
      {
         var _loc4_:String = null;
         var _loc5_:XMLNode = null;
         var _loc3_:XMLNode = param1;
         for each(_loc4_ in param2)
         {
            for each(_loc5_ in _loc3_.childNodes)
            {
               if(_loc5_.localName == _loc4_)
               {
                  if(param2.indexOf(_loc4_) == param2.length - 1)
                  {
                     return _loc5_;
                  }
                  _loc3_ = _loc5_;
                  break;
               }
            }
         }
         return null;
      }
      
      public static function addIntegerAttribute(param1:String, param2:int, param3:XMLNode) : void
      {
         XMLUtils.addAttribute(param1,String(param2),param3);
      }
   }
}
