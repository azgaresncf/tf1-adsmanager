package tv.freewheel.ad.playback
{
   import flash.utils.Dictionary;
   import tv.freewheel.ad.behavior.ICreativeRendition;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.ad.vo.slot.NonTemporalSlot;
   import tv.freewheel.utils.basic.Arrays;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class TranslationHelper
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.TranslationHelper");
       
      
      private var clonedAdInstancesPending:Boolean = false;
      
      private var clonedAdInstances:Array = null;
      
      private var originalPlaceholderDict:Dictionary;
      
      private var adInstance:AdInstance;
      
      public function TranslationHelper(param1:AdInstance)
      {
         super();
         this.adInstance = param1;
      }
      
      public function commitAd() : void
      {
         var _loc1_:Object = null;
         if(this.clonedAdInstancesPending)
         {
            this.handleClonedAdInstances();
         }
         if(this.adInstance.isShowing())
         {
            for(_loc1_ in this.originalPlaceholderDict)
            {
               this.adInstance.playCompanion(AdInstance(_loc1_));
            }
         }
      }
      
      private function containsAd(param1:Array, param2:AdInstance) : Boolean
      {
         var _loc3_:AdInstance = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.adId == param2.adId)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isTranslator() : Boolean
      {
         return this.adInstance.rendererEntry.isTranslator();
      }
      
      private function getCompanionsToCarryOn() : Array
      {
         var _loc2_:AdInstance = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.adInstance.companionAdInstances)
         {
            if(!this.containsAd(this.clonedAdInstances,_loc2_))
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function autoCommitClonedAds(param1:uint) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc2_:Boolean = true;
         if(this.clonedAdInstancesPending)
         {
            _loc3_ = this.handleClonedAdInstances();
            if(this.isTranslator())
            {
               if(_loc3_)
               {
                  this.adInstance.cleanUpTranslator();
               }
               else
               {
                  this.adInstance.failWithError(Constants.instance.ERROR_ADINSTANCE_UNAVAILABLE,"translator scheduled ad but returned no ad instance");
               }
               _loc2_ = false;
            }
         }
         return _loc2_;
      }
      
      public function toString() : String
      {
         return "[TranslationHelper " + this.adInstance.id + "]";
      }
      
      private function createNullAdInstance() : AdInstance
      {
         var _loc1_:AdInstance = this.adInstance.cloneForTranslation();
         var _loc2_:ICreativeRendition = _loc1_.createCreativeRenditionForTranslation();
         _loc2_.setContentType(Constants.instance.FW_CONTENT_TYPE_NULL_RENDERER);
         return _loc1_;
      }
      
      public function restorePlaceholdersForHybrid() : void
      {
         var _loc1_:Array = null;
         var _loc2_:AdInstance = null;
         var _loc3_:AdInstance = null;
         if(Boolean(this.originalPlaceholderDict) && !this.isTranslator())
         {
            _loc1_ = [];
            for each(_loc2_ in this.adInstance.companionAdInstances)
            {
               _loc3_ = this.originalPlaceholderDict[_loc2_];
               if(_loc3_)
               {
                  _loc1_.push(_loc3_);
               }
               else
               {
                  _loc1_.push(_loc2_);
               }
            }
            this.adInstance.companionAdInstances = _loc1_;
         }
      }
      
      public function scheduleAd(param1:Array) : Array
      {
         var _loc3_:BaseSlot = null;
         var _loc4_:AdInstance = null;
         var _loc5_:AdInstance = null;
         var _loc6_:AdInstance = null;
         this.clonedAdInstancesPending = true;
         this.clonedAdInstances = [];
         this.originalPlaceholderDict = new Dictionary();
         var _loc2_:int = 0;
         for each(_loc3_ in param1)
         {
            if(this.slot.customId == _loc3_.customId)
            {
               if(_loc2_ >= 1 && this.slot.podScheduled)
               {
                  logger.warn(this + ".scheduleAd(): slot " + this.slot + " has already got a pod scheduled, no more pod allowed (only the first slot group will be eligible for scheduling ads this time).");
                  break;
               }
               if((Boolean(_loc4_ = this.adInstance.cloneForTranslation())) && _loc2_ == 0)
               {
                  _loc4_.isFirstAdInPod = true;
               }
               this.clonedAdInstances.push(_loc4_);
               _loc2_++;
            }
            else
            {
               for each(_loc5_ in this.adInstance.companionAdInstances)
               {
                  if(_loc5_.slot && _loc5_.isPlaceholder() && _loc5_.slot.customId == _loc3_.customId)
                  {
                     _loc6_ = _loc5_.cloneForTranslation();
                     this.clonedAdInstances.push(_loc6_);
                     this.originalPlaceholderDict[_loc6_] = _loc5_;
                  }
               }
            }
            if(this.clonedAdInstances.length <= param1.indexOf(_loc3_))
            {
               logger.error(this + ".scheduleAd: bad slot " + _loc3_.customId);
               this.clonedAdInstances.push(null);
            }
         }
         if(_loc2_ > 1)
         {
            this.slot.podScheduled = true;
         }
         return this.clonedAdInstances.slice();
      }
      
      private function handleClonedAdInstances() : Boolean
      {
         var _loc1_:* = true;
         this.clonedAdInstances = Arrays.compact(this.clonedAdInstances);
         if(Boolean(this.clonedAdInstances) && this.clonedAdInstances.length > 0)
         {
            _loc1_ = this.commitClonedAdInstances();
         }
         else
         {
            _loc1_ = !this.isTranslator();
         }
         this.clonedAdInstancesPending = false;
         this.clonedAdInstances = null;
         return _loc1_;
      }
      
      private function commitClonedAdInstances() : Boolean
      {
         var _loc3_:AdInstance = null;
         var _loc1_:Boolean = true;
         if(!this.containsAd(this.clonedAdInstances,this.adInstance))
         {
            if(this.isTranslator())
            {
               this.clonedAdInstances.unshift(this.createNullAdInstance());
            }
            else
            {
               this.clonedAdInstances.unshift(this.adInstance);
            }
         }
         var _loc2_:AdInstance = null;
         for each(_loc3_ in this.clonedAdInstances)
         {
            if(_loc3_.adId == this.adInstance.adId)
            {
               _loc2_ = _loc3_;
               if(this.isTranslator() && Boolean(this.adInstance.adChain))
               {
                  if(!this.adInstance.scheduledDrivingAd)
                  {
                     this.adInstance.scheduledDrivingAd = true;
                     this.adInstance.adChain.insertAfter(_loc2_,this.adInstance);
                  }
                  else
                  {
                     this.slot.addAdChain(new AdChain(_loc2_));
                  }
               }
               _loc2_.companionAdInstances = this.getCompanionsToCarryOn();
            }
            else if(_loc2_)
            {
               if(_loc3_.slot is NonTemporalSlot)
               {
                  if(Boolean(_loc3_.creative) && _loc3_.creative.creativeRenditions.length == 0)
                  {
                     _loc3_.ad.noLoad = true;
                  }
                  _loc2_.companionAdInstances.push(_loc3_);
               }
               else
               {
                  logger.error(this + ".commitClonedAdInstances, cannot handle this ad because its slot is not NonTemporalSlot: " + _loc3_);
               }
            }
            else
            {
               logger.error(this + ".commitClonedAdInstances, didn\'t get or create driving ad?");
               _loc1_ = false;
            }
         }
         return _loc1_;
      }
      
      public function get slot() : BaseSlot
      {
         return this.adInstance.slot;
      }
   }
}
