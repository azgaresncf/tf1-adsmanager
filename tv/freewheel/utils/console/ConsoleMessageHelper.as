package tv.freewheel.utils.console
{
   public class ConsoleMessageHelper
   {
      
      private static var MESSAGE_TYPE_VALIDATION:String = "VLD";
      
      private static var MESSAGE_TAIL:String = "\n";
      
      private static var MESSAGE_DELIMITER:String = "\x1d";
      
      private static var MESSAGE_HEAD:String = "FWAMC";
      
      private static var MESSAGE_TYPE_ACK:String = "ACK";
      
      private static var MESSAGE_TYPE_LOG:String = "LOG";
       
      
      public function ConsoleMessageHelper()
      {
         super();
      }
      
      public static function createLogMessage(param1:String, param2:String) : String
      {
         return createMessage(MESSAGE_TYPE_LOG,param1,param2);
      }
      
      private static function createMessage(param1:String, param2:String, param3:String) : String
      {
         return [MESSAGE_HEAD,MESSAGE_DELIMITER,param1,MESSAGE_DELIMITER,param2,MESSAGE_DELIMITER,param3 == null ? "" : param3.replace(/\n/g,"\t"),MESSAGE_TAIL].join("");
      }
      
      public static function createValidationMessage(param1:String, param2:String) : String
      {
         return createMessage(MESSAGE_TYPE_VALIDATION,param1,param2);
      }
      
      public static function createAckMessage(param1:String) : String
      {
         return createMessage(MESSAGE_TYPE_ACK,param1,"");
      }
   }
}
