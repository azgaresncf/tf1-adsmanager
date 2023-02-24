package tv.freewheel.ad.xmlHandler
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequestMethod;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.AdManagerContext;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.vo.ad.Ad;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.ad.vo.slot.NonTemporalSlot;
   import tv.freewheel.ad.vo.slot.TemporalSlot;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.log.Logger;
   import tv.freewheel.utils.url.URLTools;
   import tv.freewheel.utils.xml.XMLHandler;
   
   public class ResponseHandler extends XMLHandler
   {
       
      
      private var retryDelay:uint = 2000;
      
      private var retryCount:uint = 0;
      
      private var lastData:XMLDocument;
      
      private var url:String;
      
      private var _context:Contexts;
      
      private var lastUrl:String;
      
      private var responseDataString:String;
      
      public function ResponseHandler(param1:Contexts)
      {
         super();
         this._context = param1;
      }
      
      private function parseDiagnostic(param1:XMLNode) : void
      {
         if(Boolean(param1.firstChild) && !SuperString.isNull(param1.firstChild.nodeValue))
         {
            this._context.requestContext.diagnostic.push(param1.firstChild.nodeValue);
         }
      }
      
      public function parseVideoAsset(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:XMLNode = null;
         var _loc5_:TemporalSlot = null;
         var _loc6_:String = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_AD_SLOTS:
                  for each(_loc4_ in _loc3_.childNodes)
                  {
                     if(_loc5_ = this.getSlotForNode(_loc4_,Constants.instance.SLOT_TYPE_TEMPORAL) as TemporalSlot)
                     {
                        if(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_TIME_POSITION_CLASS])
                        {
                           _loc5_.timePositionClass = String(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_TIME_POSITION_CLASS]).toUpperCase();
                           if(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_MAX_AD])
                           {
                              _loc6_ = String(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_MAX_AD]);
                              _loc5_.setParameter("maxAds",_loc6_);
                           }
                           if(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_MAX_DURATION])
                           {
                              _loc6_ = String(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_MAX_DURATION]);
                              _loc5_.setParameter("maxDuration",_loc6_);
                           }
                           if(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_MAX_AD_DURATION])
                           {
                              _loc6_ = String(_loc4_.attributes[InnerConstants.ATTR_TEMPORAL_AD_SLOT_MAX_AD_DURATION]);
                              _loc5_.setParameter("maxDurationPerAd",_loc6_);
                           }
                        }
                        _loc5_.parseXML(_loc4_);
                     }
                  }
                  break;
               case InnerConstants.TAG_EVENT_CALLBACKS:
                  this._context.adManagerContext.getStatusManager().parseVideoViewCallback(_loc3_);
                  break;
            }
            _loc2_++;
         }
      }
      
      public function parseVideoPlayer(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:XMLNode = null;
         var _loc5_:NonTemporalSlot = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_VIDEO_ASSET:
                  this.parseVideoAsset(_loc3_);
                  break;
               case InnerConstants.TAG_AD_SLOTS:
                  for each(_loc4_ in _loc3_.childNodes)
                  {
                     if(_loc5_ = this.getSlotForNode(_loc4_,Constants.instance.SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL) as NonTemporalSlot)
                     {
                        _loc5_.parseXML(_loc4_);
                     }
                  }
                  break;
            }
            _loc2_++;
         }
      }
      
      public function get responseData() : String
      {
         return this.responseDataString;
      }
      
      public function init(param1:String) : void
      {
         this.url = param1;
      }
      
      private function _processXMLData(param1:String) : void
      {
         var node:XMLDocument = null;
         var redirectServerURL:String = null;
         var xmlData:String = param1;
         this._context.adManagerContext.needResponseRenderers = false;
         try
         {
            node = new XMLDocument();
            node.ignoreWhite = true;
            try
            {
               node.parseXML(xmlData);
            }
            catch(err:Error)
            {
               Logger.instance.error("Invalid response XML!");
               this.notifyRequestCompleteEvent(false,err.message);
               return;
            }
            Logger.instance.info("lastXmlReceived=" + node);
            redirectServerURL = this.getRedirectServerURL(node.firstChild);
            if(!SuperString.isNull(redirectServerURL))
            {
               this.url = redirectServerURL;
               this.sendRequestToRedirectServer();
               return;
            }
            this.parseXML(node.firstChild);
            this._context.requestContext.restorePageSlots();
            this._context.requestContext.buildAdChains();
            this.notifyRequestCompleteEvent(true);
         }
         catch(err2:Error)
         {
            Logger.instance.error("ResponseHandler._processXMLData() error: " + err2.getStackTrace());
            this.notifyRequestCompleteEvent(false,err2.message);
         }
      }
      
      protected function _processDataURL() : void
      {
         var xmlData:String = null;
         try
         {
            xmlData = URLTools.getXMLDataFromURL(this.url);
         }
         catch(err:Error)
         {
            Logger.instance.error("Invalid XML data scheme url!");
            Logger.instance.error(err.message);
            this.notifyRequestCompleteEvent(false,err.message);
            return;
         }
         this._processXMLData(xmlData);
      }
      
      private function getSlotForNode(param1:XMLNode, param2:String) : BaseSlot
      {
         var _loc3_:BaseSlot = this._context.requestContext.findSlotById(param1.attributes[InnerConstants.ATTR_CUSTOM_ID]);
         if(_loc3_)
         {
            _loc3_.acceptance = Constants.instance.SLOT_ACCEPTANCE_ACCEPTED;
         }
         else if(param2 == Constants.instance.SLOT_TYPE_TEMPORAL)
         {
            _loc3_ = new TemporalSlot(this._context);
            _loc3_.acceptance = Constants.instance.SLOT_ACCEPTANCE_GENERATED;
            this._context.requestContext.temporalSlots.push(_loc3_);
         }
         return _loc3_;
      }
      
      override protected function completeHandler(param1:Event) : void
      {
         var node:XMLDocument = null;
         var dotMode:Boolean = false;
         var i:uint = 0;
         var delay:uint = 0;
         var rh:ResponseHandler = null;
         var _e:Event = param1;
         if(this.retryCount > 0)
         {
            try
            {
               node = new XMLDocument();
               dotMode = false;
               node.ignoreWhite = true;
               node.parseXML(_e.target.data);
               if(Boolean(node.firstChild) && Boolean(node.firstChild.childNodes))
               {
                  dotMode = true;
                  i = 0;
                  while(i < node.firstChild.childNodes.length)
                  {
                     if(node.firstChild.childNodes[i].localName == InnerConstants.TAG_EVENT_CALLBACKS)
                     {
                        dotMode = false;
                     }
                     i++;
                  }
               }
               if(dotMode)
               {
                  delay = this.retryDelay * (0.5 + Math.random() * 0.5);
                  Logger.instance.warn("ResponseHandler.completeHandler(): DOT detected, delay " + delay + "ms, retry " + this.retryCount);
                  --this.retryCount;
                  rh = this;
                  setTimeout(function():void
                  {
                     rh._submit();
                  },delay);
                  return;
               }
            }
            catch(err:Error)
            {
            }
         }
         try
         {
            this.responseDataString = _e.target.data;
            this._processXMLData(_e.target.data);
         }
         catch(err2:Error)
         {
            Logger.instance.error("Error occurred when processing XML data!");
            this.notifyRequestCompleteEvent(false,err2.message);
         }
      }
      
      override protected function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         Logger.instance.error("ResponseHandler.securityErrorHandler(): " + param1);
         if(this.cleaned)
         {
            return;
         }
         this.notifyRequestCompleteEvent(false,param1.toString());
      }
      
      public function submit(param1:XMLDocument = null) : void
      {
         var currentUrl:String = null;
         var flag:Object = null;
         var rh:ResponseHandler = null;
         var data:XMLDocument = param1;
         if(!SuperString.isNull(this.url) && this.url.indexOf(".xml") == this.url.length - 4)
         {
            this.lastUrl = this.url;
            this.lastData = null;
         }
         else if(!SuperString.isNull(this.url) && this.url.indexOf("fwvitest=") > 0)
         {
            this.lastUrl = this.url;
            this.lastData = data;
         }
         else
         {
            currentUrl = this.url;
            flag = this._context.requestContext.getParameter("disableServerURLAutoCorrection");
            if(!(flag == true || flag == "true") && URLTools.getDomain(currentUrl).toLowerCase().indexOf(".fwmrm.net") > 0)
            {
               if(URLTools.isHTTP(currentUrl))
               {
                  this._context.adManagerContext.adRequestBase = URLTools.getBaseURL(currentUrl);
               }
               else
               {
                  if(URLTools.isXMLData(currentUrl))
                  {
                     this._context.requestContext.submitRequestStartTime = getTimer();
                     rh = this;
                     setTimeout(function():void
                     {
                        rh._processDataURL();
                     },0);
                     return;
                  }
                  Logger.instance.error(currentUrl + " is not http or data, will fallback to default server url");
               }
               currentUrl = this._context.adManagerContext.adRequestBase + AdManagerContext.AD_REQUEST_LOCATION;
            }
            else
            {
               Logger.instance.info("player disable the server url auto correction or the url is not to the .fwmrm.net, just let it unchanged.");
            }
            this.lastUrl = currentUrl;
            this.lastData = data;
         }
         this._context.requestContext.submitRequestStartTime = getTimer();
         this._submit();
      }
      
      private function sendRequestToRedirectServer() : void
      {
         var rh:ResponseHandler = null;
         rh = this;
         setTimeout(function():void
         {
            rh.submit(lastData);
         },50);
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:Array = null;
         var _loc5_:Parameter = null;
         if(!param1 || param1.localName != InnerConstants.TAG_AD_RESPONSE)
         {
            throw new Error("ResponseHandler.parseXML(),unknown response, expected is adResponse");
         }
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_RENDERER_MANIFEST:
                  this.parseRendererManifest(_loc3_);
                  break;
               case InnerConstants.TAG_DIAGNOSTIC:
                  this.parseDiagnostic(_loc3_);
                  break;
               case InnerConstants.TAG_VISITOR:
                  this._context.adManagerContext.visitor.parseXML(_loc3_);
                  break;
               case InnerConstants.TAG_ADS:
                  this.parseAds(_loc3_);
                  break;
               case InnerConstants.TAG_SITE_SECTION:
                  this.parseSiteSection(_loc3_);
                  break;
               case InnerConstants.TAG_ERRORS:
                  this.parseErrors(_loc3_);
                  break;
               case InnerConstants.TAG_EVENT_CALLBACKS:
                  this._context.requestContext.eventCallbacks = EventCallback.parseEventCallbacks(_loc3_);
                  break;
               case InnerConstants.TAG_PARAMETERS:
                  _loc4_ = new Array();
                  Parameter.parseParametersToArray(_loc3_,_loc4_);
                  for each(_loc5_ in _loc4_)
                  {
                     this._context.requestContext.setParameter(_loc5_.name,_loc5_.value,Constants.instance.PARAMETER_PROFILE);
                  }
                  break;
            }
            _loc2_++;
         }
      }
      
      private function parseRendererManifest(param1:XMLNode) : void
      {
         var _loc2_:XMLDocument = null;
         if(Boolean(param1.firstChild) && !SuperString.isNull(param1.firstChild.nodeValue))
         {
            _loc2_ = new XMLDocument();
            _loc2_.ignoreWhite = true;
            _loc2_.parseXML(param1.firstChild.nodeValue);
            this._context.adManagerContext.adRendererSet.parseXML(_loc2_.firstChild);
         }
      }
      
      override protected function ioErrorHandler(param1:IOErrorEvent) : void
      {
         Logger.instance.error("ResponseHandler.ioErrorHandler(): " + param1);
         this.notifyRequestCompleteEvent(false,param1.toString());
      }
      
      public function loadResponseData(param1:String) : void
      {
         var dataStr:String = param1;
         try
         {
            this.responseDataString = dataStr;
            this._processXMLData(dataStr);
         }
         catch(err:Error)
         {
            Logger.instance.error("Error occurred when processing XML data!");
            this.notifyRequestCompleteEvent(false,err.message);
         }
      }
      
      public function parseSiteSection(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:XMLNode = null;
         var _loc5_:NonTemporalSlot = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_VIDEO_PLAYER:
                  this.parseVideoPlayer(_loc3_);
                  break;
               case InnerConstants.TAG_AD_SLOTS:
                  for each(_loc4_ in _loc3_.childNodes)
                  {
                     if(_loc5_ = this.getSlotForNode(_loc4_,Constants.instance.SLOT_TYPE_SITESECTION_NONTEMPORAL) as NonTemporalSlot)
                     {
                        _loc5_.parseXML(_loc4_);
                     }
                  }
                  break;
            }
            _loc2_++;
         }
      }
      
      protected function _submit() : void
      {
         if(!this.lastData)
         {
            this.process(this.lastUrl);
         }
         else
         {
            this.process(this.lastUrl,this.lastData,"text/xml",URLRequestMethod.POST);
         }
      }
      
      private function getRedirectServerURL(param1:XMLNode) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:XMLNode = null;
         var _loc4_:String = null;
         if(Boolean(param1) && Boolean(param1.childNodes))
         {
            _loc2_ = 0;
            while(_loc2_ < param1.childNodes.length)
            {
               _loc3_ = param1.childNodes[_loc2_];
               if(_loc3_.localName == InnerConstants.TAG_REDIRECT)
               {
                  _loc4_ = String(_loc3_.attributes[InnerConstants.ATTR_REDIRECT_SERVER]);
                  if(URLTools.isSecureHTTP(this.url))
                  {
                     return "https://" + _loc4_ + AdManagerContext.AD_REQUEST_LOCATION;
                  }
                  return "http://" + _loc4_ + AdManagerContext.AD_REQUEST_LOCATION;
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      private function notifyRequestCompleteEvent(param1:Boolean, param2:String = null) : void
      {
         this._context.requestContext.requestManager.setCompleted(true);
         this._context.requestContext.requestManager.setSucceeded(param1);
         this._context.requestContext.submitRequestEndTime = getTimer();
         this._context.requestContext.notifyRequestCompleteEvent(false,param2);
      }
      
      private function parseAds(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:Ad = null;
         this._context.requestContext.ads.splice(0);
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            if(_loc3_.localName == InnerConstants.TAG_AD)
            {
               _loc4_ = new Ad();
               this._context.requestContext.ads.push(_loc4_);
               _loc4_.parseXML(_loc3_);
            }
            _loc2_++;
         }
      }
      
      private function parseErrors(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         var _loc8_:XMLNode = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            if(_loc3_.localName == InnerConstants.TAG_ERROR)
            {
               _loc4_ = "";
               _loc5_ = "";
               _loc6_ = 0;
               while(_loc6_ < _loc3_.childNodes.length)
               {
                  _loc8_ = _loc3_.childNodes[_loc6_];
                  switch(_loc8_.localName)
                  {
                     case InnerConstants.TAG_ERROR_MESSAGE:
                        if(_loc8_.firstChild)
                        {
                           _loc4_ = _loc8_.firstChild.nodeValue;
                        }
                        break;
                     case InnerConstants.TAG_ERROR_CONTEXT:
                        if(_loc8_.firstChild)
                        {
                           _loc5_ = _loc8_.firstChild.nodeValue;
                        }
                        break;
                  }
                  _loc6_++;
               }
               (_loc7_ = new Object())[InnerConstants.TAG_ERROR_ID] = _loc3_.attributes[InnerConstants.TAG_ERROR_ID];
               _loc7_[InnerConstants.TAG_ERROR_SEVERITY] = _loc3_.attributes[InnerConstants.TAG_ERROR_SEVERITY];
               _loc7_[InnerConstants.TAG_ERROR_NAME] = _loc3_.attributes[InnerConstants.TAG_ERROR_NAME];
               _loc7_[InnerConstants.TAG_ERROR_CONTEXT] = _loc5_;
               _loc7_[InnerConstants.TAG_ERROR_MESSAGE] = _loc4_;
               this._context.requestContext.serverErrors.push(_loc7_);
            }
            _loc2_++;
         }
      }
   }
}
