package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   public class _1710125b211b8208d77acf23c0db4b194526f3382445009c03f6f9dac9c84de4_flash_display_Sprite extends Sprite
   {
       
      
      public function _1710125b211b8208d77acf23c0db4b194526f3382445009c03f6f9dac9c84de4_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain(rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain(rest);
      }
   }
}
