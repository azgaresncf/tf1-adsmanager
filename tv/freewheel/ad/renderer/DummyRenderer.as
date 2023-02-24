package tv.freewheel.ad.renderer
{
   import flash.display.Sprite;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import tv.freewheel.ad.behavior.IConstants;
   import tv.freewheel.ad.behavior.IRenderer;
   import tv.freewheel.ad.behavior.IRendererContext;
   import tv.freewheel.ad.behavior.IRendererController;
   
   public class DummyRenderer extends Sprite implements IRenderer
   {
       
      
      private var constants:IConstants;
      
      private var timeoutId:uint = 0;
      
      private var ctrl:IRendererController;
      
      private var ctxt:IRendererContext;
      
      public function DummyRenderer()
      {
         super();
      }
      
      public function stop(param1:Boolean = false) : void
      {
         if(this.ctrl)
         {
            this.ctrl.handleStateTransition(this.constants.RENDERER_STATE_STOP_COMPLETE);
         }
      }
      
      public function getTotalBytes() : int
      {
         return 0;
      }
      
      public function getDuration() : Number
      {
         return 0;
      }
      
      public function preload() : void
      {
         this.ctrl.handleStateTransition(this.constants.RENDERER_STATE_PRELOAD_COMPLETE);
      }
      
      public function init(param1:IRendererContext, param2:IRendererController) : void
      {
         this.ctxt = param1;
         this.ctrl = param2;
         this.constants = this.ctxt.getConstants();
         this.ctrl.setCapability(this.constants.RENDERER_CAPABILITY_ADVOLUMECHANGE,false);
         this.ctrl.setCapability(this.constants.RENDERER_CAPABILITY_ADSIZECHANGE,false);
         this.ctrl.setCapability(this.constants.RENDERER_CAPABILITY_ADPLAYSTATECHANGE,false);
         this.ctrl.setCapability(this.constants.RENDERER_EVENT_CLICK,false);
         this.ctrl.setCapability(this.constants.RENDERER_CAPABILITY_VIDEOSTATUSCONTROL,true);
         this.ctrl.handleStateTransition(this.constants.RENDERER_STATE_INITIALIZE_COMPLETE);
      }
      
      public function setAdVolume(param1:uint) : void
      {
      }
      
      public function getBytesLoaded() : int
      {
         return 0;
      }
      
      public function start() : void
      {
         this.ctrl.handleStateTransition(this.constants.RENDERER_STATE_PLAYING);
         if(this.timeoutId > 0)
         {
            clearTimeout(this.timeoutId);
         }
         this.timeoutId = setTimeout(this.stop,1000);
      }
      
      public function getInfo() : Object
      {
         return {"moduleType":"Renderer"};
      }
      
      public function resume() : void
      {
      }
      
      public function getNewInstance(param1:int) : IRenderer
      {
         return this;
      }
      
      public function dispose() : void
      {
         clearTimeout(this.timeoutId);
         this.ctrl = null;
         this.ctxt = null;
         this.constants = null;
      }
      
      public function resize() : void
      {
      }
      
      public function pause() : void
      {
      }
      
      public function getPlayheadTime() : Number
      {
         return 0;
      }
   }
}
