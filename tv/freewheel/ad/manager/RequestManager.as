package tv.freewheel.ad.manager
{
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import flash.xml.XMLDocument;
   import tv.freewheel.ad.UrlInstance.SlotParams;
   import tv.freewheel.ad.UrlInstance.TagGeneratorUrlInstance;
   import tv.freewheel.ad.behavior.ISlot;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.xmlHandler.ResponseHandler;
   import tv.freewheel.ad.xmlHandler.VideoViewHandler;
   import tv.freewheel.utils.basic.Delegate;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.log.Logger;
   
   public class RequestManager
   {
      
      private static const EXTERNAL_SLOT_WAIT_TIMEOUT:uint = 250;
      
      private static const INIT_FW_PAGE_SCAN_STATE:String = "function(){if (window._fw_admanager) window._fw_admanager.pageScanState = true;}";
      
      private static const INIT_FWOBJ_SCRIPT:String = "if (!this.fwObject)" + "{" + "  var fwObject = {};" + "  fwObject.knownSlots = [];" + "}";
      
      private static const IS_DUPLICATE:String = "if (!fwObject.isDuplicate)" + "{" + "  fwObject.isDuplicate = function(id)" + "  {" + "    for (var j = 0; j < fwObject.knownSlots.length; ++j)" + "    {" + "      if (fwObject.knownSlots[j] == id)" + "      {" + "        return true;" + "      }" + "    }" + "    return false;" + "  };" + "}";
      
      private static const GET_PAGE_SLOT_STR:String = "if (!fwObject.findPageSlot)" + "{" + "  fwObject.findPageSlot =" + "    function(regExpFilter)" + "    {" + "      fwObject.knownSlots = [];" + "      var ret = [];" + "      for (var s = 0; s < window.frames.length; ++s)" + "      {" + "        try {" + "        \tfwObject.getPageSlotByScope(window.frames[s].document, ret);" + "        }" + "        catch(e) {}" + "      }" + "      try {" + "      \t fwObject.getPageSlotByScope(parent.document, ret);" + "      } catch(e) {}" + "      try {" + "      \t fwObject.getPageSlotByScope(document, ret);" + "      } catch(e) {}" + "      if (regExpFilter){" + "        var RegExpCustomId = new RegExp(regExpFilter);" + "        var filteredRet = [];" + "        for (var idx = 0; idx < ret.length-1; idx=idx+2){" + "          if (RegExpCustomId.test(ret[idx])){" + "            filteredRet.push(ret[idx]);" + "\t\t\t filteredRet.push(ret[idx+1]);" + "          }" + "        }" + "        return filteredRet;" + "      }" + "      else" + "        return ret;" + "    };" + "}";
      
      private static const GET_PAGE_SLOT_BY_SCOPE_STR:String = "if (!fwObject.getPageSlotByScope)" + "{" + "  fwObject.getPageSlotByScope =" + "    function(startNode, ret)" + "    {" + "      var id;" + "      var RegExpClassName = new RegExp(\"(^|\\\\s)_fwph(\\\\s|$)\");" + "      var arrElms = startNode.getElementsByTagName(\'span\');" + "      for (var i = 0; i < arrElms.length; ++i)" + "      {" + "  \t     var input;" + "        var element = arrElms[i];" + "        if (RegExpClassName.test(element.className))" + "        {" + "          id = element.getAttribute(\"id\");" + "          input = startNode.getElementById(\"_fw_input_\"+id);" + "          if (input && !fwObject.isDuplicate(id))" + "          {" + "            ret[ret.length] = id;" + "            ret[ret.length] = input.getAttribute(\"value\");" + "            fwObject.knownSlots[fwObject.knownSlots.length] = id;" + "          }" + "        }" + "      }" + "    };" + "}";
      
      private static const EVAL_REGEXP_STR:String = "if (!fwObject.evalRegExp){" + "  fwObject.evalRegExp = function(regExpFilter){" + "    try{ var regexp = new RegExp(regExpFilter); return 1;}" + "    catch(e){ return 0; }" + "  }" + "}";
       
      
      private var delayTimer:Timer;
      
      private var completed:Boolean = false;
      
      private var externalSlotMaxWaitSeconds:uint;
      
      private var responseHandler:ResponseHandler;
      
      public var submitRequestTimeoutSeconds:Number = 0;
      
      private var succeeded:Boolean = false;
      
      private var onExternalSlotCompletion:Function;
      
      private var pageLoadTimer:Timer;
      
      private var videoViewHandler:VideoViewHandler;
      
      private var triedToSubmitRequest:Boolean = false;
      
      private var _context:Contexts;
      
      private var submitRequestMaxDelayBeforeRequest:Number = 0;
      
      private var waitingOnExternalSlots:Boolean = false;
      
      public function RequestManager(param1:Contexts)
      {
         super();
         this._context = param1;
         this.responseHandler = new ResponseHandler(param1);
         this.videoViewHandler = new VideoViewHandler(param1);
      }
      
      private function pageLoadCallback(param1:TimerEvent = null, param2:Boolean = false) : Boolean
      {
         var error:Error = null;
         var slots:Array = null;
         var _e:TimerEvent = param1;
         var _isForcesNoInitial:Boolean = param2;
         var success:Boolean = false;
         if(this.isPageReady())
         {
            success = true;
         }
         else if(this.pageLoadTimer != null && this.pageLoadTimer.currentCount * EXTERNAL_SLOT_WAIT_TIMEOUT >= this.externalSlotMaxWaitSeconds)
         {
            success = true;
         }
         if(success)
         {
            if(this.pageLoadTimer != null && this.pageLoadTimer.running)
            {
               this.pageLoadTimer.stop();
            }
            slots = new Array();
            slots = this.processExternalSlots(_isForcesNoInitial);
            if(this.onExternalSlotCompletion != null)
            {
               try
               {
                  this.onExternalSlotCompletion(slots);
               }
               catch(_err:Error)
               {
                  error = _err;
               }
            }
            this.waitingOnExternalSlots = false;
            if(this.triedToSubmitRequest)
            {
               this.submitRequestWithoutWaitOnExternalSlots(this.submitRequestTimeoutSeconds,this.submitRequestMaxDelayBeforeRequest);
            }
         }
         if(error)
         {
            setTimeout(function():void
            {
               throw error;
            },100);
         }
         return success;
      }
      
      private function onDelayTimer(param1:TimerEvent) : void
      {
         Logger.instance.info("onDelayTimer()");
         var _loc2_:XMLDocument = this._context.requestContext.toXML();
         Logger.instance.info("adRequest= " + _loc2_.toString());
         if(this.submitRequestTimeoutSeconds > 0)
         {
            if(this._context.requestContext.timeOutId >= 0)
            {
               clearTimeout(this._context.requestContext.timeOutId);
            }
            this._context.requestContext.timeOutId = setTimeout(this._context.requestContext.notifyRequestCompleteEvent,this.submitRequestTimeoutSeconds * 1000,true);
         }
         this.responseHandler.submit(_loc2_);
      }
      
      public function getSucceeded() : Boolean
      {
         return this.succeeded;
      }
      
      public function clearLoader() : void
      {
         this.responseHandler.clearLoader();
      }
      
      private function processExternalSlots(param1:Boolean = false, param2:String = null) : Array
      {
         var i:Number;
         var slots:Array;
         var externalSlots:Array = null;
         var regExpFilterParameter:String = null;
         var regExpIsValid:int = 0;
         var typeBVals:SlotParams = null;
         var k:Number = NaN;
         var externalSlot:ISlot = null;
         var _isForcesNoInitial:Boolean = param1;
         var _regExpFilter:String = param2;
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface["marshallExceptions"] = true;
               ExternalInterface.call(INIT_FW_PAGE_SCAN_STATE);
            }
            catch(e:Error)
            {
               Logger.instance.error("RequestManager.injectPageScanState, error:" + e.message);
            }
            try
            {
               ExternalInterface["marshallExceptions"] = true;
               this.initFwObj();
               if(_regExpFilter == null)
               {
                  externalSlots = ExternalInterface.call("fwObject.findPageSlot");
               }
               else
               {
                  regExpFilterParameter = _regExpFilter.replace(/\\/g,"\\\\");
                  regExpIsValid = ExternalInterface.call("fwObject.evalRegExp",regExpFilterParameter);
                  if(regExpIsValid)
                  {
                     externalSlots = ExternalInterface.call("fwObject.findPageSlot",regExpFilterParameter);
                  }
                  else
                  {
                     Logger.instance.warn(_regExpFilter + " was passed to IAdManager.scanSlotsOnPage(), which is not a valid regular expression.");
                     externalSlots = ExternalInterface.call("fwObject.findPageSlot");
                  }
               }
               if(externalSlots == null)
               {
                  return new Array();
               }
            }
            catch(e:Error)
            {
               Logger.instance.error("RequestManager.processExternalSlots: ExternalInterface exception! " + e.message);
               return new Array();
            }
         }
         else
         {
            Logger.instance.warn("RequestManager.processExternalSlots: ExternalInterface is not available");
         }
         if(externalSlots == null)
         {
            return new Array();
         }
         if(externalSlots.length % 2 != 0)
         {
            Logger.instance.error("Error: Mismatched number of external slot IDs and typeBInfo strings");
            return new Array();
         }
         slots = new Array();
         i = 0;
         while(i < externalSlots.length)
         {
            typeBVals = TagGeneratorUrlInstance.parseSlotParams(externalSlots[i + 1]);
            if(typeBVals != null)
            {
               typeBVals.customId = externalSlots[i];
               if(!typeBVals.acceptPrimaryContentType)
               {
                  typeBVals.acceptPrimaryContentType = "text/html_lit_js_wc_nw";
               }
               if(_isForcesNoInitial)
               {
                  typeBVals.initialOption = true;
               }
               if(typeBVals.candidateAds)
               {
                  k = 0;
                  while(k < typeBVals.candidateAds.length)
                  {
                     this._context.adManagerContext.adManager.addCandidateAd(SuperString.convertToUint(typeBVals.candidateAds[k]));
                     k++;
                  }
               }
               if(!this._context.requestContext.hasSlotWithId(typeBVals.customId))
               {
                  this._context.requestContext.externalSlotsInfo.push(typeBVals);
                  externalSlot = null;
                  if(typeBVals.ptgt == "p")
                  {
                     externalSlot = this._context.adManagerContext.adManager.addVideoPlayerNonTemporalSlot(typeBVals.customId,null,typeBVals.width,typeBVals.height,typeBVals.slotProfile,0,0,typeBVals.acceptCompanion,typeBVals.adUnit,null,typeBVals.acceptPrimaryContentType,null,typeBVals.initialOption,typeBVals.compatibleDimensions);
                  }
                  else
                  {
                     externalSlot = this._context.adManagerContext.adManager.addSiteSectionNonTemporalSlot(typeBVals.customId,typeBVals.width,typeBVals.height,typeBVals.slotProfile,typeBVals.acceptCompanion,typeBVals.initialOption,typeBVals.adUnit,null,typeBVals.acceptPrimaryContentType,null,null,typeBVals.compatibleDimensions);
                  }
                  if(externalSlot != null)
                  {
                     slots.push(externalSlot);
                  }
               }
            }
            i += 2;
         }
         return slots;
      }
      
      private function isPageReady() : Boolean
      {
         var jsStr:String = null;
         var flag:Boolean = false;
         try
         {
            jsStr = "(function ()" + "{" + "  if (document.readyState == undefined || document.readyState == \'complete\')" + "  {" + "    return true;" + "  }" + "  return false;" + "})();";
            flag = ExternalInterface.call("eval",jsStr);
         }
         catch(e:Error)
         {
            Logger.instance.error("RequestManager.isPageReady when test page load ready occur exception: " + e.message);
         }
         return flag;
      }
      
      public function submitRequest(param1:Number, param2:Number) : void
      {
         this.responseHandler.init(this._context.adManagerContext.serverUrl);
         this._context.requestContext.dispatchRequestInitiatedEvent();
         if(!this.waitingOnExternalSlots)
         {
            this.submitRequestWithoutWaitOnExternalSlots(param1,param2);
         }
         else
         {
            this.triedToSubmitRequest = true;
            this.submitRequestTimeoutSeconds = param1;
            this.submitRequestMaxDelayBeforeRequest = param2;
         }
      }
      
      public function setCompleted(param1:Boolean) : void
      {
         this.completed = param1;
      }
      
      public function getResponseData() : String
      {
         return this.responseHandler.responseData;
      }
      
      public function parseResponse(param1:String) : void
      {
         this.responseHandler.loadResponseData(param1);
      }
      
      public function getCompleted() : Boolean
      {
         return this.completed;
      }
      
      public function setSucceeded(param1:Boolean) : void
      {
         this.succeeded = param1;
      }
      
      private function submitRequestWithoutWaitOnExternalSlots(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         this._context.adManagerContext.capabilities.setCapability(Constants.instance.CAPABILITY_REQUIRES_RENDERER_MANIFEST,this._context.adManagerContext.needResponseRenderers);
         if(this._context.adManagerContext.needResponseRenderers)
         {
            this._context.adManagerContext.adRendererSet.reset();
         }
         this.submitRequestTimeoutSeconds = param1;
         if(param2 > 0)
         {
            _loc3_ = Math.random() * param2;
            if(_loc3_ <= 0.01)
            {
               _loc3_ = 0.01;
            }
            Logger.instance.info("Delay " + _loc3_ + " seconds to send the request");
            this.delayTimer = new Timer(_loc3_ * 1000,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.onDelayTimer);
            this.delayTimer.start();
         }
         else
         {
            this.onDelayTimer(null);
         }
      }
      
      public function dispose() : void
      {
         if(this.pageLoadTimer)
         {
            this.pageLoadTimer.stop();
            this.pageLoadTimer = null;
         }
         if(this.delayTimer)
         {
            this.delayTimer.stop();
            this.delayTimer.removeEventListener(TimerEvent.TIMER,this.onDelayTimer);
            this.delayTimer = null;
         }
         this.responseHandler.dispose();
      }
      
      public function submitVideoViewRequest() : void
      {
         this.videoViewHandler.init(this._context.adManagerContext.serverUrl);
         var _loc1_:XMLDocument = this._context.requestContext.toXML();
         this.videoViewHandler.submit(_loc1_);
      }
      
      private function initFwObj() : void
      {
         var fwJsObjStr:String = null;
         try
         {
            fwJsObjStr = INIT_FWOBJ_SCRIPT + IS_DUPLICATE + GET_PAGE_SLOT_BY_SCOPE_STR.replace(/\\/g,"\\\\") + GET_PAGE_SLOT_STR + EVAL_REGEXP_STR;
            ExternalInterface.call("eval",fwJsObjStr);
         }
         catch(e:Error)
         {
            Logger.instance.error("RequestManager.initFwObj inject js code occur an exception: " + e.message);
         }
      }
      
      public function getExternalSlots(param1:Number, param2:Function, param3:Boolean, param4:String = null) : Array
      {
         this.onExternalSlotCompletion = param2;
         this.externalSlotMaxWaitSeconds = param1 * 1000;
         if(param1)
         {
            if(!this.pageLoadCallback(null,param3))
            {
               this.waitingOnExternalSlots = true;
               this.pageLoadTimer = new Timer(EXTERNAL_SLOT_WAIT_TIMEOUT);
               this.pageLoadTimer.start();
               this.pageLoadTimer.addEventListener(TimerEvent.TIMER,Delegate.create(this.pageLoadCallback,param3));
            }
            return new Array();
         }
         return this.processExternalSlots(param3,param4);
      }
   }
}
