package tv.freewheel.ad.manager
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import tv.freewheel.ad.behavior.IExtension;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.events.FWEvent;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.log.Logger;
   import tv.freewheel.utils.url.URLTools;
   
   public class ExtensionManager
   {
      
      private static var __importIExtension:IExtension;
       
      
      public var loadingCounter:int = 0;
      
      private var _context:Contexts;
      
      private var extensions:HashMap;
      
      public function ExtensionManager(param1:Contexts)
      {
         super();
         this.extensions = new HashMap();
         this._context = param1;
      }
      
      private function loadFail(param1:String) : void
      {
         this.loadNotify(param1,false);
      }
      
      public function load(param1:String, param2:*, param3:Boolean = false) : void
      {
         var url:String = null;
         var em:ExtensionManager = null;
         var onError:Function = null;
         var loader:Loader = null;
         var req:URLRequest = null;
         var ctx:LoaderContext = null;
         var name:String = param1;
         var urlOrInstance:* = param2;
         var useInternalAdm:Boolean = param3;
         if(!AdManager.LoaderInstance)
         {
            Logger.instance.error("ExtensionManager: AdManager.LoaderInstance is not available, load extension in compatible mode.");
         }
         if(SuperString.isNull(name))
         {
            this.loadFail(name);
         }
         else if(urlOrInstance is String)
         {
            if(this.extensions.get(name))
            {
               Logger.instance.error("ExtensionManager failed to load, duplicated extension found:" + name);
               this.loadFail(name);
               return;
            }
            url = urlOrInstance;
            if(!URLTools.isHTTP(url) && Boolean(AdManager.AdManagerUrl))
            {
               url = AdManager.AdManagerUrl.substring(0,AdManager.AdManagerUrl.lastIndexOf("/") + 1) + url;
            }
            em = this;
            onError = function(param1:Event):void
            {
               Logger.instance.error("ExtensionManager failed to load " + name + " from " + url + ". " + param1);
               --em.loadingCounter;
               em.loadFail(name);
            };
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
            {
               var instance:Object = null;
               var e:Event = param1;
               --em.loadingCounter;
               try
               {
                  instance = loader.content;
                  em.loadDone(name,instance);
               }
               catch(e:Error)
               {
                  em.loadFail(name);
               }
            });
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onError);
            req = new URLRequest(url);
            ctx = new LoaderContext();
            ctx.applicationDomain = new ApplicationDomain(!!AdManager.LoaderInstance ? AdManager.LoaderInstance.getAppDomain() : ApplicationDomain.currentDomain);
            if(Security.sandboxType == Security.REMOTE)
            {
               ctx.securityDomain = SecurityDomain.currentDomain;
            }
            try
            {
               loader.load(req,ctx);
               ++this.loadingCounter;
            }
            catch(e:Error)
            {
               Logger.instance.error("ExtensionManager failed to load " + name + " from " + url + ". " + e);
            }
         }
         else
         {
            this.loadDone(name,urlOrInstance,useInternalAdm);
         }
      }
      
      public function get(param1:String) : Object
      {
         return this.extensions.get(param1);
      }
      
      private function loadDone(param1:String, param2:Object, param3:Boolean = false) : void
      {
         var name:String = param1;
         var instance:Object = param2;
         var useInternalAdm:Boolean = param3;
         try
         {
            if(!this.extensions)
            {
               return;
            }
            if(this.extensions.get(name))
            {
               throw new Error("duplicated extension found.");
            }
            instance.init(Boolean(AdManager.LoaderInstance) && !useInternalAdm ? AdManager.LoaderInstance.proxyAdManager(this._context.adManagerContext.adManager) : this._context.adManagerContext.adManager);
            this.extensions.put(name,instance);
            Logger.instance.info("ExtensionManager initialized " + name);
            this.loadNotify(name,true);
         }
         catch(e:*)
         {
            Logger.instance.error("ExtensionManager failed to initialize " + name + ". " + e.getStackTrace());
            this.loadFail(name);
         }
      }
      
      private function loadNotify(param1:String, param2:Boolean) : void
      {
         this._context.adManagerContext.dispatchEvent(new FWEvent(Constants.instance.EVENT_EXTENSION_LOADED,"",param2,false,false,null,0,0,"",null,"",false,false,"",0,0,param1));
      }
      
      public function dispose() : void
      {
         var keys:Array = null;
         var k:uint = 0;
         var v:Object = null;
         keys = this.extensions.getKeys();
         k = 0;
         while(k < keys.length)
         {
            v = this.extensions.get(keys[k]);
            if(v)
            {
               try
               {
                  v.dispose();
               }
               catch(e:*)
               {
                  Logger.instance.error("ExtensionManager failed to dispose " + keys[k] + ". " + e);
               }
            }
            k++;
         }
         this.extensions = null;
      }
   }
}
