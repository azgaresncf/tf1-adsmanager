package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.behavior.ICreativeRendition;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.creative.CreativeRendition;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class AdEventCallback extends BasicEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.AdEventCallback");
       
      
      protected var _needDispatchRendererEvent:Boolean = true;
      
      private var _creativeId:int;
      
      public var errorCode:int = 0;
      
      protected var _eventId:uint;
      
      protected var _keyValues:HashMap;
      
      private var _slotCustomId:String;
      
      protected var _moduleName:String = null;
      
      protected var _adInstance:AdInstance;
      
      private var _adId:int;
      
      public function AdEventCallback(param1:uint, param2:AdInstance, param3:EventCallback)
      {
         this._keyValues = new HashMap();
         this._eventId = param1;
         this._adInstance = param2;
         super(param3,param2.context);
      }
      
      public static function construct(param1:Array, param2:uint, param3:String, param4:String, param5:AdInstance, param6:Boolean, param7:Object = null) : AdEventCallback
      {
         var _loc8_:AdEventCallback = null;
         var _loc9_:EventCallback;
         if(_loc9_ = getEvent(param1,param3,param4,param6))
         {
            switch(param2)
            {
               case Constants.instance.RENDERER_EVENT_IMPRESSION:
               case Constants.instance.RENDERER_EVENT_IMPRESSION_END:
                  _loc8_ = new AdImpressionEventCallback(param2,param5,_loc9_);
                  break;
               case Constants.instance.RENDERER_EVENT_MEASUREMENT:
                  _loc8_ = new AdImpressionEventCallback(param2,param5,_loc9_,param7.concreteeventid);
                  break;
               case Constants.instance.RENDERER_EVENT_CUSTOM:
                  _loc8_ = new CustomEventCallback(param2,param5,_loc9_);
                  break;
               case Constants.instance.RENDERER_EVENT_CLICK:
                  _loc8_ = new ClickEventCallback(param2,param5,_loc9_);
                  break;
               case Constants.instance.RENDERER_EVENT_FIRSTQUARTILE:
               case Constants.instance.RENDERER_EVENT_MIDPOINT:
               case Constants.instance.RENDERER_EVENT_THIRDQUARTILE:
               case Constants.instance.RENDERER_EVENT_COMPLETE:
                  _loc8_ = new QuartileEventCallback(param2,param5,_loc9_);
                  break;
               case Constants.instance.RENDERER_EVENT_MUTE:
               case Constants.instance.RENDERER_EVENT_UNMUTE:
               case Constants.instance.RENDERER_EVENT_COLLAPSE:
               case Constants.instance.RENDERER_EVENT_EXPAND:
               case Constants.instance.RENDERER_EVENT_PAUSE:
               case Constants.instance.RENDERER_EVENT_RESUME:
               case Constants.instance.RENDERER_EVENT_REWIND:
               case Constants.instance.RENDERER_EVENT_ACCEPTINVITATION:
               case Constants.instance.RENDERER_EVENT_CLOSE:
               case Constants.instance.RENDERER_EVENT_MINIMIZE:
                  _loc8_ = new StandardIABEventCallback(param2,param5,_loc9_);
                  break;
               case Constants.instance.RENDERER_EVENT_ERROR:
               case Constants.instance.RENDERER_EVENT_FAIL:
                  _loc8_ = new AdErrorEventCallback(param2,param5,_loc9_);
            }
         }
         return _loc8_;
      }
      
      protected function dispatchRendererEvent() : void
      {
         if(!this._needDispatchRendererEvent)
         {
            return;
         }
         var _loc1_:String = this._adInstance.adId + "_" + this._adInstance.adReplicaId;
         var _loc2_:uint = this._eventId;
         if(this._event.name == Constants.instance.EVENTCALLBACK_RESELLER_NO_AD)
         {
            _loc2_ = Constants.instance.RENDERER_EVENT_RESELLER_NO_AD;
         }
         this._context.adManagerContext.broadcastRendererEvent(this._slotCustomId,_loc2_.toString(),this._adId,this._creativeId,_loc1_,this._adInstance,this._moduleName,this.errorCode,this._keyValues.get(BasicEventCallback.URL_KEY_ADDITIONAL));
      }
      
      override protected function getRawTrackingUrls() : Array
      {
         var _loc1_:Array = super.getRawTrackingUrls();
         var _loc2_:String = this._event.type;
         if(_loc2_ == Constants.instance.EVENTCALLBACK_TYPE_CLICK)
         {
            _loc2_ = Constants.instance.EVENTCALLBACK_TYPE_CLICKTRACKING;
         }
         return _loc1_.concat(this._adInstance.getCallbackManager().getURLs(this._event.name,_loc2_));
      }
      
      override public function toString() : String
      {
         return "AdEventCallback(" + this._adInstance.id + ").";
      }
      
      override protected function initParameters() : void
      {
         super.initParameters();
         this._keyValues.merge(this._adInstance.getMetricManager().getEventCallbackKeyValues()).merge(this._adInstance.additionalCallbackKeyValues);
         this._adId = uint(this._adInstance.adId);
         this._creativeId = this._adInstance.creative.id;
         this._slotCustomId = this._adInstance.getSlot().getCustomId();
      }
      
      override protected function getAdPlayheadTime() : int
      {
         return this._adInstance.getPlayheadTime();
      }
      
      override public function dispose() : void
      {
         this._adInstance = null;
         super.dispose();
      }
      
      override protected function getCreativeAssetLocation() : String
      {
         var _loc1_:String = null;
         var _loc2_:ICreativeRendition = this._adInstance.getPrimaryCreativeRendition();
         if(Boolean(_loc2_) && Boolean(_loc2_.getPrimaryCreativeRenditionAsset()))
         {
            _loc1_ = _loc2_.getPrimaryCreativeRenditionAsset().getURL();
         }
         return _loc1_;
      }
      
      override public function process() : void
      {
         super.process();
         this.dispatchRendererEvent();
      }
      
      override protected function getParameter(param1:String) : Object
      {
         return this._adInstance.getParameterObject(param1);
      }
      
      override public function getUrl(param1:Boolean = true) : String
      {
         var _loc2_:String = super.getUrl();
         if(!URLTools.hasValueInQueryString(_loc2_,URL_KEY_EVENT_NAME))
         {
            _loc2_ = URLTools.replaceUrlParam(_loc2_,URL_KEY_EVENT_NAME,this._event.name);
         }
         if(!URLTools.hasValueInQueryString(_loc2_,URL_KEY_EVENT_TYPE))
         {
            _loc2_ = URLTools.replaceUrlParam(_loc2_,URL_KEY_EVENT_TYPE,getShortEventTypeByEventType(this._event.type));
         }
         var _loc3_:CreativeRendition = CreativeRendition(this._adInstance.getPrimaryCreativeRendition());
         if(_loc3_)
         {
            _loc2_ = URLTools.replaceUrlParam(_loc2_,URL_KEY_CREATIVE_RENDITION_ID,_loc3_.id.toString());
         }
         return URLTools.addKeyValuesInUrl(_loc2_,this._keyValues);
      }
   }
}
