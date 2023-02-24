package tv.freewheel.ad.renderer
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import flash.utils.getDefinitionByName;
   import tv.freewheel.ad.behavior.IRenderer;
   import tv.freewheel.ad.behavior.ITranslator;
   import tv.freewheel.ad.manager.AdManager;
   import tv.freewheel.ad.vo.adRenderer.AdRenderer;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class RendererLoader extends EventDispatcher
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.RendererLoader");
      
      public static var LOAD_COMPLETE:String = "loadComplete";
      
      public static var LOAD_ERROR:String = "loadError";
       
      
      private var renderer:Object;
      
      private var entry:AdRenderer;
      
      private var loader:Loader;
      
      public var errorMessage:String;
      
      public function RendererLoader(param1:AdRenderer)
      {
         super();
         this.entry = param1;
      }
      
      protected function errorHandler(param1:Event) : void
      {
         logger.error(this + ".errorHandler(" + param1 + ")");
         this.reportLoadError("Failed to load renderer from " + this.entry.url);
      }
      
      public function loadRenderer() : void
      {
         var rendererRequest:URLRequest = null;
         var loaderContext:LoaderContext = null;
         if(this.renderer != null)
         {
            this.completeHandler();
            return;
         }
         if(!SuperString.isNull(this.entry.url))
         {
            rendererRequest = new URLRequest(this.entry.url);
            this.loader = new Loader();
            loaderContext = new LoaderContext();
            loaderContext.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            switch(Security.sandboxType)
            {
               case Security.LOCAL_TRUSTED:
               case Security.LOCAL_WITH_FILE:
               case Security.LOCAL_WITH_NETWORK:
                  this.loader.load(rendererRequest,loaderContext);
                  break;
               case Security.REMOTE:
                  loaderContext.securityDomain = SecurityDomain.currentDomain;
                  this.loader.load(rendererRequest,loaderContext);
            }
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.completeHandler,false,0,true);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.errorHandler,false,0,true);
            this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler,false,0,true);
         }
         else if(!SuperString.isNull(this.entry.className))
         {
            try
            {
               this.renderer = new (getDefinitionByName(this.entry.className) as Class)();
               this.completeHandler();
            }
            catch(e:Error)
            {
               logger.error(this + ".loadRenderer(): error in new class " + entry.className + " " + e);
               reportLoadError("Error when loading renderer from class " + entry.className);
            }
         }
         else
         {
            this.reportLoadError("Renderer class name and url are both blank");
         }
      }
      
      override public function toString() : String
      {
         return "[RendererLoader url:" + this.entry.url + ", className:" + this.entry.className + "]";
      }
      
      public function getRendererInstance() : IRenderer
      {
         var ret:IRenderer;
         var rendererOrTranslator:Object = null;
         if(this.renderer == null)
         {
            return null;
         }
         ret = null;
         try
         {
            rendererOrTranslator = this.renderer.getNewInstance(AdManager.getLibraryVersion());
            if(rendererOrTranslator is ITranslator && this.entry.isTranslator())
            {
               ret = new TranslatorWrapper(rendererOrTranslator as ITranslator);
            }
            else
            {
               ret = rendererOrTranslator as IRenderer;
            }
         }
         catch(e:Error)
         {
            logger.error(this + ".getRendererInstance: got error when call getNewInstance of renderer " + e.message + "\n" + e.getStackTrace());
         }
         return ret;
      }
      
      protected function completeHandler(param1:Event = null) : void
      {
         if(param1)
         {
            this.renderer = param1.target.content;
         }
         if(Boolean(this.renderer) && this.renderer.hasOwnProperty("getNewInstance"))
         {
            this.dispatchEvent(new Event(LOAD_COMPLETE));
         }
         else
         {
            this.reportLoadError("Renderer binary doesn\'t have getNewInstance method, version incompatible");
         }
      }
      
      protected function reportLoadError(param1:String) : void
      {
         this.errorMessage = param1;
         this.dispatchEvent(new Event(LOAD_ERROR));
      }
      
      public function dispose() : void
      {
         if(this.loader)
         {
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.completeHandler,false);
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.errorHandler,false);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.errorHandler,false);
            try
            {
               this.loader.unload();
            }
            catch(e:Error)
            {
               logger.warn(this + ".releaseRendererInstance, got error when unloading loader: " + e);
            }
            this.loader = null;
         }
         if(this.renderer)
         {
            this.renderer = null;
         }
      }
   }
}
