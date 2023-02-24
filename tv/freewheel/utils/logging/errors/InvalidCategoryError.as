package tv.freewheel.utils.logging.errors
{
   public class InvalidCategoryError extends Error
   {
       
      
      public function InvalidCategoryError(param1:String)
      {
         super(param1);
      }
      
      public function toString() : String
      {
         return String(message);
      }
   }
}
