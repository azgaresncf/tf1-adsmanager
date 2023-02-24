package tv.freewheel.ad.renderer
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.system.Security;
   import tv.freewheel.ad.behavior.IAdInstance;
   import tv.freewheel.ad.behavior.IConstants;
   import tv.freewheel.ad.behavior.ICreativeRendition;
   import tv.freewheel.ad.behavior.IRendererContext;
   import tv.freewheel.ad.behavior.IRendererController;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.behavior.ITranslatorContext;
   import tv.freewheel.ad.behavior.ITranslatorController;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.manager.AdManager;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.adRenderer.AdRenderer;
   import tv.freewheel.ad.vo.creative.CreativeRendition;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.ad.vo.reference.AdReference;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class RendererContext implements IRendererContext, IRendererController, ITranslatorContext, ITranslatorController
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.RendererContext");
       
      
      protected var rendererLogger:ILogger = null;
      
      public var _context:Contexts;
      
      protected var adInstance:AdInstance;
      
      public function RendererContext(param1:AdInstance)
      {
         super();
         this.adInstance = param1;
         this._context = param1.context;
      }
      
      public function getParameterObject(param1:String, param2:uint = 0) : Object
      {
         return this.adInstance.getParameterObject(param1,param2);
      }
      
      public function setCapability(param1:uint, param2:Boolean, param3:Object = null) : Boolean
      {
         return this.adInstance.getMetricManager().setCapability(param1,param2,param3);
      }
      
      public function getPrimaryCreativeRendition() : ICreativeRendition
      {
         return this.adInstance.getPrimaryCreativeRendition();
      }
      
      public function setPrimaryCreativeRendition(param1:ICreativeRendition) : void
      {
         this.adInstance.setPrimaryCreativeRendition(param1 as CreativeRendition);
      }
      
      public function getPlaceholderCompanionSlots() : Array
      {
         var _loc2_:AdInstance = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.adInstance.companionAdInstances)
         {
            if(Boolean(_loc2_.slot) && _loc2_.isPlaceholder())
            {
               _loc1_.push(_loc2_.slot);
            }
         }
         return _loc1_;
      }
      
      public function requestVideoPause(param1:Boolean) : void
      {
         if(!this.adInstance.getMetricManager().adManagerControlMainVideoPause() && this.adInstance.shouldRequestMainVideoPauseOrResume(param1,true))
         {
            this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_PAUSESTATECHANGE_REQUEST,this.slot.getCustomId(),true,false,param1);
         }
      }
      
      public function setEventCallbackKeyValue(param1:String, param2:String) : void
      {
         this.adInstance.getMetricManager().setEventCallbackKeyValue(param1,param2);
      }
      
      public function scheduleAd(param1:Array) : Array
      {
         return this.adInstance.translationHelper.scheduleAd(param1);
      }
      
      public function getSlotBaseDisplaySize() : Rectangle
      {
         return this.slot.getBounds();
      }
      
      public function setState(param1:String, param2:Object) : void
      {
         var _loc3_:HashMap = null;
         if(this.rendererEntry)
         {
            _loc3_ = HashMap(this._context.adManagerContext.rendererState.get(this.rendererEntry.id));
            if(!_loc3_)
            {
               _loc3_ = new HashMap();
               this._context.adManagerContext.rendererState.put(this.rendererEntry.id,_loc3_);
            }
            _loc3_.put(param1,param2,false);
         }
      }
      
      public function log(param1:String, param2:int = 0, param3:uint = 0, param4:Object = null) : void
      {
         var rendererClassName:String = null;
         var msg:String = param1;
         var level:int = param2;
         var code:uint = param3;
         var details:Object = param4;
         if(!this.adInstance.renderer)
         {
            return;
         }
         if(!this.rendererLogger)
         {
            rendererClassName = "";
            try
            {
               rendererClassName = String(this.rendererEntry.className || String(this.rendererEntry.url.split("/").pop().split(".")[0]));
            }
            catch(e:Error)
            {
            }
            this.rendererLogger = Log.getLogger("Renderer." + rendererClassName);
         }
         this.rendererLogger.log(level,"[ad " + this.adInstance.id + "] " + msg);
      }
      
      public function getVideoCustomId() : String
      {
         return this._context.adManagerContext.va_customId;
      }
      
      public function getAllCreativeRenditions() : Array
      {
         return this.getCreativeRenditionsForRenderer();
      }
      
      public function setActiveBundleId(param1:String) : void
      {
         if(this._context.adManagerContext.selectedBundleId == null)
         {
            this._context.adManagerContext.selectedBundleId = param1;
         }
      }
      
      public function getActiveBundleId() : String
      {
         return this._context.adManagerContext.selectedBundleId;
      }
      
      public function toString() : String
      {
         return "[RendererContext " + this.adInstance.id + "]";
      }
      
      public function get rendererEntry() : AdRenderer
      {
         return this.adInstance.rendererEntry;
      }
      
      public function addAllowedDomain(param1:String) : void
      {
         Security.allowDomain(param1);
         this._context.adManagerContext.broadcastEvent(Constants.instance.EVENT_ALLOWED_DOMAIN_REQUEST,this.slot.id,true,false,false,param1);
      }
      
      public function getSlot() : ISlot
      {
         return this.slot;
      }
      
      public function getCompanionAds() : Array
      {
         return this.adInstance.companionAdInstances.slice();
      }
      
      public function clearState() : void
      {
         if(this.rendererEntry)
         {
            this._context.adManagerContext.rendererState.put(this.rendererEntry.id,null);
         }
      }
      
      public function getEventCallbackNames(param1:String) : Array
      {
         return this.adInstance.getCallbackManager().getEventCallbackNames(param1);
      }
      
      public function processEvent(param1:uint, param2:Object = null) : void
      {
         this.adInstance.getMetricManager().processEvent(param1,param2);
      }
      
      public function handleStateTransition(param1:uint, param2:Object = null) : void
      {
         this.adInstance.handleRendererEvent(param1,param2);
      }
      
      public function getCreativeRenditionsForRenderer() : Array
      {
         var _loc2_:CreativeRendition = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.adInstance.getAllCreativeRenditions())
         {
            if(!this.rendererEntry || this.rendererEntry.checkIsMatched(_loc2_.getContentType(),_loc2_.getAdUnit(),this.slot.getType(),this.slot.getTimePositionClass(),!!this.adRef.ad ? this.adRef.ad.adUnit : null,_loc2_.getWrapperType(),_loc2_.getCreativeAPI(),this.slot.getBase()))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getAdBase() : Sprite
      {
         return this.adInstance.getBase();
      }
      
      public function getSlotByCustomId(param1:String) : ISlot
      {
         return this._context.requestContext.findSlotById(param1);
      }
      
      public function getVideoDuration() : Number
      {
         return this._context.adManagerContext.va_duration;
      }
      
      public function get adRef() : AdReference
      {
         return this.adInstance.adRef;
      }
      
      public function getCompanionSlots() : Array
      {
         return this.getPlaceholderCompanionSlots();
      }
      
      public function getConstants() : IConstants
      {
         return Constants.instance;
      }
      
      public function getAdVolume() : uint
      {
         return this._context.adManagerContext.playerEnvironment.adVolume;
      }
      
      public function getSlotBaseDisplay() : Sprite
      {
         return this.getAdBase();
      }
      
      public function getVideoPlayheadTime() : Number
      {
         return this._context.adManagerContext.getPlayheadTimeCallback != null ? this._context.adManagerContext.getPlayheadTimeCallback() : -1;
      }
      
      private function getParameterObjects(param1:uint, param2:Array) : Array
      {
         var _loc5_:Object = null;
         var _loc3_:Array = new Array();
         var _loc4_:Number = 0;
         while(_loc4_ < param2.length)
         {
            (_loc5_ = Parameter(param2[_loc4_]).toObject()).level = param1;
            _loc3_.push(_loc5_);
            _loc4_++;
         }
         _loc3_.sortOn("name");
         return _loc3_;
      }
      
      public function getVersion() : uint
      {
         return AdManager.getLibraryVersion();
      }
      
      public function getAllParameters() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat(this.getParameterObjects(Constants.instance.PARAMETER_OVERRIDE,this._context.requestContext.getParameters(Constants.instance.PARAMETER_OVERRIDE)));
         if(this.adInstance.getPrimaryCreativeRendition())
         {
            _loc1_ = _loc1_.concat(this.getParameterObjects(Constants.instance.PARAMETER_CREATIVERENDITION,CreativeRendition(this.adInstance.getPrimaryCreativeRendition()).parameters));
         }
         if(this.adInstance.creative)
         {
            _loc1_ = _loc1_.concat(this.getParameterObjects(Constants.instance.PARAMETER_CREATIVE,this.adInstance.creative.parameters));
         }
         _loc1_ = _loc1_.concat(this.getParameterObjects(Constants.instance.PARAMETER_SLOT,this.adInstance.slot.parameters));
         _loc1_ = _loc1_.concat(this.getParameterObjects(Constants.instance.PARAMETER_PROFILE,this._context.requestContext.getParameters(Constants.instance.PARAMETER_PROFILE)));
         _loc1_ = _loc1_.concat(this.getParameterObjects(Constants.instance.PARAMETER_GLOBAL,this._context.requestContext.getParameters(Constants.instance.PARAMETER_GLOBAL)));
         if(this.adInstance.rendererEntry)
         {
            _loc1_ = _loc1_.concat(this.getParameterObjects(Constants.instance.PARAMETER_RENDERER,this.adInstance.rendererEntry.parameters));
         }
         return _loc1_;
      }
      
      public function commitAd() : void
      {
         this.adInstance.translationHelper.commitAd();
      }
      
      public function getAdInstance() : IAdInstance
      {
         return this.adInstance;
      }
      
      public function dispatchCustomEvent(param1:String, param2:Object) : void
      {
         this._context.adManagerContext.broadcastCustomEvent(this.slot.id,param2,param1,uint(this.adInstance.adId));
      }
      
      public function getEventCallbackURLs(param1:String, param2:String = null) : Array
      {
         return this.adInstance.getEventCallbackURLs(param1,param2);
      }
      
      public function getState(param1:String) : Object
      {
         var _loc3_:HashMap = null;
         var _loc2_:Object = null;
         if(this.rendererEntry)
         {
            _loc3_ = HashMap(this._context.adManagerContext.rendererState.get(this.rendererEntry.id));
            if(_loc3_)
            {
               _loc2_ = _loc3_.get(param1,false);
            }
         }
         return _loc2_;
      }
      
      public function getVideoDisplaySize() : Rectangle
      {
         return this._context.adManagerContext.adManager.getVideoDisplaySize();
      }
      
      public function getVideoPlayStatus() : uint
      {
         return this._context.adManagerContext.adManager.getVideoPlayStatus();
      }
      
      public function getParameter(param1:String, param2:uint = 0) : String
      {
         var _loc3_:Object = this.getParameterObject(param1,param2);
         return _loc3_ == null ? null : String(_loc3_);
      }
      
      public function get slot() : BaseSlot
      {
         return this.adInstance.slot;
      }
   }
}
