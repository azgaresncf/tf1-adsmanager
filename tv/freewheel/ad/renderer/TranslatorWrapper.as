package tv.freewheel.ad.renderer
{
   import tv.freewheel.ad.behavior.IConstants;
   import tv.freewheel.ad.behavior.IRenderer;
   import tv.freewheel.ad.behavior.IRendererContext;
   import tv.freewheel.ad.behavior.IRendererController;
   import tv.freewheel.ad.behavior.ITranslator;
   import tv.freewheel.ad.behavior.ITranslatorContext;
   import tv.freewheel.ad.behavior.ITranslatorController;
   import tv.freewheel.ad.constant.Constants;
   
   public class TranslatorWrapper implements IRenderer
   {
       
      
      private var translator:ITranslator;
      
      private var ctx;
      
      private var ctrl;
      
      private var consts:IConstants;
      
      public function TranslatorWrapper(param1:ITranslator)
      {
         super();
         this.translator = param1;
         this.consts = Constants.instance;
      }
      
      public function stop(param1:Boolean = false) : void
      {
         this.ctrl.handleStateTransition(this.consts.TRANSLATOR_STATE_TRANSLATE_COMPLETE);
      }
      
      public function resize() : void
      {
      }
      
      public function getTotalBytes() : int
      {
         return -1;
      }
      
      public function preload() : void
      {
         this.translator.preload();
      }
      
      public function getDuration() : Number
      {
         return -1;
      }
      
      public function init(param1:IRendererContext, param2:IRendererController) : void
      {
         this.ctx = param1;
         this.ctrl = param2;
         this.consts = param1.getConstants();
         this.ctrl.setCapability(this.consts.RENDERER_EVENT_IMPRESSION,true);
         this.ctrl.setCapability(this.consts.RENDERER_EVENT_MUTE,true);
         this.ctrl.setCapability(this.consts.RENDERER_EVENT_UNMUTE,true);
         this.ctrl.setCapability(this.consts.RENDERER_EVENT_COLLAPSE,true);
         this.ctrl.setCapability(this.consts.RENDERER_EVENT_EXPAND,true);
         this.ctrl.setCapability(this.consts.RENDERER_EVENT_PAUSE,true);
         this.ctrl.setCapability(this.consts.RENDERER_EVENT_RESUME,true);
         this.ctx.getAdInstance().getMetricManager().setCapability(Constants.instance.RENDERER_CAPABILITY_VIDEOSTATUSCONTROL,true);
         this.translator.init(ITranslatorContext(param1),ITranslatorController(param2));
      }
      
      public function setAdVolume(param1:uint) : void
      {
      }
      
      public function getBytesLoaded() : int
      {
         return -1;
      }
      
      public function start() : void
      {
         this.ctrl.handleStateTransition(this.consts.TRANSLATOR_STATE_TRANSLATING);
         this.translator.translate();
      }
      
      public function resume() : void
      {
      }
      
      public function dispose() : void
      {
         this.translator.dispose();
         this.translator = null;
         this.consts = null;
         this.ctrl = null;
         this.ctx = null;
      }
      
      public function getPlayheadTime() : Number
      {
         return -1;
      }
      
      public function pause() : void
      {
      }
   }
}
