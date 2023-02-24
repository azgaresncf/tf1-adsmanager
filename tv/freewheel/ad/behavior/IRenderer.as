package tv.freewheel.ad.behavior
{
   public interface IRenderer
   {
       
      
      function stop(param1:Boolean = false) : void;
      
      function setAdVolume(param1:uint) : void;
      
      function start() : void;
      
      function getDuration() : Number;
      
      function resume() : void;
      
      function init(param1:IRendererContext, param2:IRendererController) : void;
      
      function resize() : void;
      
      function pause() : void;
      
      function getPlayheadTime() : Number;
      
      function preload() : void;
      
      function getBytesLoaded() : int;
      
      function getTotalBytes() : int;
      
      function dispose() : void;
   }
}
