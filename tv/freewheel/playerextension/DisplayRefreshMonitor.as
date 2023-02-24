package tv.freewheel.playerextension
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import tv.freewheel.ad.manager.AdManager;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.ad.vo.slot.NonTemporalSlot;
   import tv.freewheel.utils.js.JSInterface;
   
   public class DisplayRefreshMonitor extends BaseMonitor
   {
      
      private static const REPLACE_TYPE_NONE:uint = 0;
      
      private static const REFRESH_TYPE_AD:uint = 1;
      
      private static const REFRESH_TYPE_TIME:uint = 2;
      
      private static const REFRESH_TYPE_NONE:uint = 0;
      
      private static const REPLACE_TYPE_BLANK:uint = 1;
      
      private static const REPLACE_TYPE_AD:uint = 2;
       
      
      private var refreshInterval:uint = 0;
      
      private var subAdManager:AdManager = null;
      
      private var companionSlots:Array = null;
      
      private var replaceType:uint = 0;
      
      private var keyValueList:Array = null;
      
      private var displaySlots:Array = null;
      
      private var overrideParameters:Array = null;
      
      private var globalParameters:Array = null;
      
      private var refreshTimer:Timer = null;
      
      private var firstTemporalAd:Boolean = true;
      
      private var refreshType:uint = 0;
      
      public function DisplayRefreshMonitor()
      {
         super();
      }
      
      private function log(param1:String) : void
      {
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         this.log("onTimeout()");
         this.resetSubAdManager();
         this.refreshSlots(this.displaySlots);
      }
      
      override public function init(param1:Object) : void
      {
         super.init(param1);
         this.log("init()");
         this.am.addEventListener(this.consts.EVENT_REQUEST_COMPLETE,this.onRequestComplete);
      }
      
      private function onRequestComplete(param1:Object) : void
      {
         var e:Object = param1;
         this.log("onRequestComplete()");
         if(e.success)
         {
            switch(this.am.getParameter("refreshType"))
            {
               case "ad":
                  this.refreshType = REFRESH_TYPE_AD;
                  break;
               case "time":
                  this.refreshInterval = this.am.getParameter("refreshInterval");
                  if(this.refreshInterval > 0)
                  {
                     this.refreshType = REFRESH_TYPE_TIME;
                  }
                  else
                  {
                     this.log("invalid refreshInterval " + this.refreshInterval + ", will not refresh display ads");
                     this.refreshType = REFRESH_TYPE_NONE;
                  }
                  break;
               case "none":
               default:
                  this.refreshType = REFRESH_TYPE_NONE;
            }
            switch(this.am.getParameter("replaceMissingCompanion"))
            {
               case "blank":
                  this.replaceType = REPLACE_TYPE_BLANK;
                  break;
               case "ad":
                  this.replaceType = REPLACE_TYPE_AD;
                  break;
               case "none":
               default:
                  this.replaceType = REPLACE_TYPE_NONE;
            }
            this.log("refreshType: " + this.refreshType + ", refreshInterval: " + this.refreshInterval + ", replaceType: " + this.replaceType);
            if(this.refreshType != REFRESH_TYPE_NONE || this.replaceType != REPLACE_TYPE_NONE)
            {
               this.displaySlots = this.am.getSlotsByTimePositionClass(this.consts.TIME_POSITION_CLASS_DISPLAY);
               this.companionSlots = this.displaySlots.filter(function(param1:NonTemporalSlot, param2:int, param3:Array):Boolean
               {
                  return param1.getAcceptCompanion();
               });
               this.keyValueList = this.am.context.requestContext.keyValues.getList();
               this.globalParameters = this.am.context.requestContext.getParameters(this.consts.PARAMETER_GLOBAL);
               this.overrideParameters = this.am.context.requestContext.getParameters(this.consts.PARAMETER_OVERRIDE);
               this.firstTemporalAd = true;
               this.am.addEventListener(this.consts.EVENT_RENDERER,this.onRendererEvent);
               this.am.addEventListener(this.consts.EVENT_SLOT_ENDED,this.onSlotEnded);
               if(this.refreshType == REFRESH_TYPE_TIME)
               {
                  this.refreshTimer = new Timer(this.refreshInterval * 1000);
                  this.refreshTimer.addEventListener(TimerEvent.TIMER,this.onTimeout);
                  this.refreshTimer.start();
               }
            }
            else
            {
               this.log("do nothing for this requestContext");
            }
         }
      }
      
      private function resetSubAdManager() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Parameter = null;
         var _loc3_:Parameter = null;
         this.log("resetSubAdManager()");
         if(this.subAdManager)
         {
            this.subAdManager.refresh();
         }
         else
         {
            this.subAdManager = this.am.newAdManager();
            this.subAdManager.setCapability(this.consts.CAPABILITY_SLOT_TEMPLATE,this.consts.CAPABILITY_STATUS_OFF);
            this.subAdManager.setCapability(this.consts.CAPABILITY_DISPLAY_REFRESH,this.consts.CAPABILITY_STATUS_ON);
            this.subAdManager.addEventListener(this.consts.EVENT_REQUEST_COMPLETE,this.playRefreshedSlots);
         }
         for each(_loc1_ in this.keyValueList)
         {
            this.subAdManager.setKeyValue(_loc1_.key,_loc1_.value);
         }
         for each(_loc2_ in this.globalParameters)
         {
            this.subAdManager.setParameterObject(_loc2_.name,_loc2_.value,this.consts.PARAMETER_GLOBAL);
         }
         for each(_loc3_ in this.overrideParameters)
         {
            this.subAdManager.setParameterObject(_loc3_.name,_loc3_.value,this.consts.PARAMETER_OVERRIDE);
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.refresh();
         if(this.am)
         {
            this.am.removeEventListener(consts.EVENT_REQUEST_COMPLETE,this.onRequestComplete);
            this.am = null;
         }
      }
      
      private function refreshSlots(param1:Array) : void
      {
         var _loc2_:NonTemporalSlot = null;
         var _loc3_:NonTemporalSlot = null;
         this.log("refreshSlots(" + param1 + ")");
         if(param1 == null || param1.length == 0)
         {
            this.log("no slot to refresh");
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc2_.stop();
            if(_loc2_.getPhysicalLocation() == this.consts.SLOT_LOCATION_PLAYER)
            {
               this.log("addVideoPlayerNonTemporalSlot " + _loc2_.getCustomId());
               this.subAdManager.addVideoPlayerNonTemporalSlot(_loc2_.getCustomId(),_loc2_.getBase(),_loc2_.getWidth(),_loc2_.getHeight(),_loc2_.slotProfile,_loc2_.getBounds().x,_loc2_.getBounds().y,false,_loc2_.adUnit);
            }
            else
            {
               this.log("addSiteSectionNonTemporalSlot " + _loc2_.getCustomId());
               this.subAdManager.addSiteSectionNonTemporalSlot(_loc2_.getCustomId(),_loc2_.getWidth(),_loc2_.getHeight(),_loc2_.slotProfile,false,null,_loc2_.adUnit,null,null,null,_loc2_.getBase(),null);
            }
            _loc3_ = NonTemporalSlot(this.subAdManager.getSlotByCustomId(_loc2_.getCustomId()));
            _loc3_.parameters = _loc2_.parameters;
            _loc3_.acceptPrimaryContentType = _loc2_.acceptPrimaryContentType;
            _loc3_.acceptContentType = _loc2_.acceptContentType;
            _loc3_.compatibleDimensions = _loc2_.compatibleDimensions;
            _loc3_._isVisible = _loc2_._isVisible;
         }
         this.subAdManager.submitRequest(5,0);
      }
      
      override public function refresh() : void
      {
         this.log("refresh()");
         super.refresh();
         if(this.am)
         {
            this.am.removeEventListener(this.consts.EVENT_RENDERER,this.onRendererEvent);
            this.am.removeEventListener(this.consts.EVENT_SLOT_ENDED,this.onSlotEnded);
         }
         if(this.refreshTimer)
         {
            this.refreshTimer.reset();
            this.refreshTimer.removeEventListener(TimerEvent.TIMER,this.onTimeout);
            this.refreshTimer = null;
         }
         if(this.subAdManager)
         {
            this.subAdManager.removeEventListener(this.consts.EVENT_REQUEST_COMPLETE,this.playRefreshedSlots);
            this.subAdManager.dispose();
            this.subAdManager = null;
         }
         this.keyValueList = null;
         this.globalParameters = null;
         this.overrideParameters = null;
         this.refreshType = REFRESH_TYPE_NONE;
         this.refreshInterval = 0;
         this.replaceType = REPLACE_TYPE_NONE;
         this.displaySlots = null;
         this.companionSlots = null;
      }
      
      private function playRefreshedSlots(param1:Object) : void
      {
         var _loc2_:NonTemporalSlot = null;
         this.log("playRefreshedSlots()");
         if(param1.success)
         {
            for each(_loc2_ in this.subAdManager.getSlotsByTimePositionClass(this.consts.TIME_POSITION_CLASS_DISPLAY))
            {
               this.log("play refreshed slot " + _loc2_.getCustomId());
               _loc2_.play();
            }
         }
         else
         {
            this.log("refresh request error " + param1);
         }
      }
      
      private function onRendererEvent(param1:Object) : void
      {
         if(param1.subType == this.consts.RENDERER_EVENT_IMPRESSION)
         {
            this.onAdStarted(param1);
         }
      }
      
      private function onSlotEnded(param1:Object) : void
      {
         this.log("onSlotEnded, slot " + param1.slotCustomId);
         var _loc2_:Object = this.am.getSlotByCustomId(param1.slotCustomId);
         if(_loc2_ == null || _loc2_.getTimePositionClass() == this.consts.TIME_POSITION_CLASS_DISPLAY)
         {
            return;
         }
         if(_loc2_.getAdInstancesInPlayPlan(false,false).length == 0)
         {
            this.log("empty slot " + param1.slotCustomId + " or all ads failed, ignore");
            return;
         }
         if(this.refreshType == REFRESH_TYPE_AD)
         {
            this.resetSubAdManager();
            this.refreshSlots(this.displaySlots);
         }
         else if(this.refreshType == REFRESH_TYPE_TIME)
         {
            this.resetSubAdManager();
            this.refreshSlots(this.displaySlots);
            this.refreshTimer.start();
         }
      }
      
      private function checkMissingCompanionForAd(param1:AdInstance) : void
      {
         var missingCompanionSlots:Array;
         var companionAd:AdInstance = null;
         var i:int = 0;
         var slot:NonTemporalSlot = null;
         var adInstance:AdInstance = param1;
         this.log("checkMissingCompanionForAd(" + adInstance.getAdId() + ")");
         missingCompanionSlots = this.companionSlots.slice();
         this.log("all companion slots " + missingCompanionSlots);
         for each(companionAd in adInstance.getCompanionAdInstances())
         {
            i = missingCompanionSlots.indexOf(companionAd.getSlot());
            if(i > -1)
            {
               missingCompanionSlots.splice(i,1);
            }
         }
         this.log("missing companion slots " + missingCompanionSlots);
         if(this.firstTemporalAd)
         {
            this.firstTemporalAd = false;
            missingCompanionSlots = missingCompanionSlots.filter(function(param1:NonTemporalSlot, param2:int, param3:Array):Boolean
            {
               var _loc4_:* = undefined;
               if(!(param1.initialAdOption == this.consts.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_ONLY || param1.initialAdOption == this.consts.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_STAND_ALONE || param1.initialAdOption == this.consts.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_THEN_STAND_ALONE || param1.initialAdOption == this.consts.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE || param1.initialAdOption == this.consts.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE_IF_TEMPORAL))
               {
                  this.log("firstCompanionAsInitial false in slot " + param1.getCustomId());
                  return true;
               }
               for each(_loc4_ in param1.getAdInstancesInPlayPlan(false,false))
               {
                  if(!_loc4_.isPlaceholder())
                  {
                     this.log("first companion found in slot " + param1.getCustomId());
                     return false;
                  }
               }
               this.log("firstCompanionAsInitial true, no ad in slot " + param1.getCustomId());
               return true;
            },this);
         }
         if(this.replaceType == REPLACE_TYPE_BLANK)
         {
            this.log("blank slots " + missingCompanionSlots);
            for each(slot in missingCompanionSlots)
            {
               slot.stop();
               JSInterface.replacePageSlot(slot.customId,"");
            }
         }
         else if(this.replaceType == REPLACE_TYPE_AD)
         {
            this.refreshSlots(missingCompanionSlots);
         }
      }
      
      private function onAdStarted(param1:Object) : void
      {
         var _loc3_:AdInstance = null;
         this.log("onAdStarted(), slot " + param1.slotCustomId + ", ad " + param1.adId);
         var _loc2_:Object = this.am.getSlotByCustomId(param1.slotCustomId);
         if(_loc2_ == null || _loc2_.getTimePositionClass() == this.consts.TIME_POSITION_CLASS_DISPLAY)
         {
            return;
         }
         this.resetSubAdManager();
         if(this.refreshTimer)
         {
            this.refreshTimer.reset();
         }
         if(this.replaceType == REPLACE_TYPE_NONE)
         {
            return;
         }
         for each(_loc3_ in _loc2_.getAdInstancesInPlayPlan(false,false))
         {
            if(_loc3_.getAdId() == param1.adId)
            {
               return this.checkMissingCompanionForAd(_loc3_);
            }
         }
      }
   }
}
