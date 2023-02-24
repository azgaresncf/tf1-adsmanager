package tv.freewheel.ad.playback
{
   import tv.freewheel.ad.vo.reference.AdReference;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class AdChain
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.AdChain");
       
      
      public var adInstances:Array;
      
      public var slot:BaseSlot;
      
      public function AdChain(param1:Object)
      {
         var _loc3_:AdReference = null;
         this.adInstances = new Array();
         super();
         var _loc2_:AdInstance = param1 as AdInstance;
         if(_loc2_ == null && param1 is AdReference)
         {
            _loc2_ = new AdInstance(param1 as AdReference);
         }
         if(_loc2_ != null)
         {
            this.append(_loc2_);
            if(_loc2_.adRef != null)
            {
               for each(_loc3_ in _loc2_.adRef.fallbackAdRefs)
               {
                  this.append(new AdInstance(_loc3_));
               }
            }
         }
      }
      
      public function append(param1:AdInstance) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.adInstances.push(param1);
         param1.adChain = this;
      }
      
      public function insertAfter(param1:AdInstance, param2:AdInstance) : void
      {
         var _loc3_:Number = this.adInstances.indexOf(param2);
         if(_loc3_ >= 0)
         {
            this.adInstances.splice(_loc3_ + 1,0,param1);
            param1.adChain = this;
         }
         else
         {
            logger.error("insertAfter: target " + param2 + " is not in this chain");
         }
      }
      
      public function get id() : String
      {
         return this.adInstances.join(",");
      }
      
      public function toString() : String
      {
         return "[AdChain " + this.id + "]";
      }
      
      public function findNextPlayableAd(param1:AdInstance = null) : AdInstance
      {
         var _loc5_:AdInstance = null;
         var _loc2_:Number = this.adInstances.indexOf(param1) + 1;
         var _loc3_:AdInstance = null;
         var _loc4_:Number = _loc2_;
         while(_loc4_ <= this.adInstances.length)
         {
            if((Boolean(_loc5_ = this.adInstances[_loc4_])) && _loc5_.isPlayable())
            {
               _loc3_ = _loc5_;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
   }
}
