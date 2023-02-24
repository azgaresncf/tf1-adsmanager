package tv.freewheel.ad.behavior
{
   public interface ITranslator
   {
       
      
      function init(param1:ITranslatorContext, param2:ITranslatorController) : void;
      
      function preload() : void;
      
      function translate() : void;
      
      function dispose() : void;
   }
}
