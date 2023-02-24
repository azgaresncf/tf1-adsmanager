package tv.freewheel.ad.vo.reference
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.vo.ad.Ad;
   import tv.freewheel.ad.vo.creative.Creative;
   import tv.freewheel.ad.vo.creative.CreativeRendition;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class AdReference
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.AdInstance");
       
      
      public var creativeRenditionId:Number;
      
      public var fallbackAdRefs:Array;
      
      public var slotCustomId:String;
      
      public var eventCallbacks:Array;
      
      public var ad:Ad;
      
      public var creativeId:Number;
      
      public var companionAdRefs:Array;
      
      public var _context:Contexts;
      
      public var replicaId:String;
      
      public function AdReference(param1:Contexts)
      {
         this.eventCallbacks = new Array();
         this.companionAdRefs = new Array();
         this.fallbackAdRefs = new Array();
         super();
         this._context = param1;
      }
      
      public function get id() : String
      {
         return !!this.ad ? this.ad.id : null;
      }
      
      public function get creative() : Creative
      {
         if(this.ad)
         {
            if(this.creativeId)
            {
               return this.ad.getCreativeById(this.creativeId);
            }
            return this.ad.get1stCreative();
         }
         return null;
      }
      
      public function addEventCallback(param1:String, param2:String, param3:String, param4:String, param5:Boolean, param6:Array) : void
      {
         var _loc7_:EventCallback = new EventCallback(param1,param2,param3,param4,param5,param6);
         this.eventCallbacks.push(_loc7_);
      }
      
      public function dispose() : void
      {
         this.eventCallbacks = null;
         this.companionAdRefs = null;
         this.fallbackAdRefs = null;
      }
      
      public function findEvent(param1:String, param2:String, param3:Boolean) : EventCallback
      {
         return EventCallback.findEvent(this.eventCallbacks,param1,param2,param3);
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:XMLNode = null;
         var _loc5_:AdReference = null;
         var _loc6_:XMLNode = null;
         var _loc7_:AdReference = null;
         this.companionAdRefs.splice(0);
         this.fallbackAdRefs.splice(0);
         this.eventCallbacks.splice(0);
         if(param1.attributes[InnerConstants.ATTR_AD_REFERENCE_AD_SLOT_CUSTOM_ID])
         {
            this.slotCustomId = param1.attributes[InnerConstants.ATTR_AD_REFERENCE_AD_SLOT_CUSTOM_ID];
         }
         this.ad = this._context.requestContext.findAdById(Number(param1.attributes[InnerConstants.ATTR_AD_REFERENCE_AD_ID]));
         this.creativeId = param1.attributes[InnerConstants.ATTR_AD_REFERENCE_CREATIVE_ID];
         this.creativeRenditionId = param1.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_ID];
         this.replicaId = param1.attributes[InnerConstants.ATTR_AD_REFERENCE_REPLICA_ID];
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_EVENT_CALLBACKS:
                  this.eventCallbacks = EventCallback.parseEventCallbacks(_loc3_);
                  break;
               case InnerConstants.TAG_COMPANION_ADS:
                  for each(_loc4_ in _loc3_.childNodes)
                  {
                     if(_loc4_.localName == InnerConstants.TAG_AD_REFERENCE)
                     {
                        _loc5_ = new AdReference(this._context);
                        this.companionAdRefs.push(_loc5_);
                        _loc5_.parseXML(_loc4_);
                     }
                  }
                  break;
               case InnerConstants.TAG_FALLBACK_ADS:
                  for each(_loc6_ in _loc3_.childNodes)
                  {
                     if(_loc6_.localName == InnerConstants.TAG_AD_REFERENCE)
                     {
                        _loc7_ = new AdReference(this._context);
                        this.fallbackAdRefs.push(_loc7_);
                        _loc7_.parseXML(_loc6_);
                     }
                  }
                  break;
            }
            _loc2_++;
         }
      }
      
      public function isPlaceholder() : Boolean
      {
         return this.ad.noLoad || this.getCreativeRenditionsByPriority().length == 0;
      }
      
      public function toString() : String
      {
         return "[AdRef " + this.ad + (!!this.replicaId ? " replicaId " + this.replicaId : "") + "]";
      }
      
      public function cloneForTranslation(param1:CreativeRendition = null) : AdReference
      {
         var _loc2_:AdReference = new AdReference(this._context);
         _loc2_.ad = this.ad.cloneForTranslation(this.creativeId);
         _loc2_.creativeId = this.creativeId;
         _loc2_.creativeRenditionId = !!param1 ? param1.id : this.creativeRenditionId;
         _loc2_.slotCustomId = this.slotCustomId;
         _loc2_.replicaId = this.replicaId;
         _loc2_.eventCallbacks = this.eventCallbacks.slice();
         return _loc2_;
      }
      
      public function get context() : Contexts
      {
         return this._context;
      }
      
      public function getCreativeRenditionsByPriority() : Array
      {
         var _loc4_:CreativeRendition = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         if(this.creative)
         {
            for each(_loc4_ in this.creative.creativeRenditions)
            {
               if(_loc4_.id == this.creativeRenditionId && _loc4_.replicaId == this.replicaId)
               {
                  _loc1_.push(_loc4_);
               }
               if(SuperString.isNull(_loc4_.replicaId))
               {
                  _loc2_.push(_loc4_);
               }
            }
         }
         var _loc3_:Array = _loc1_.length == 0 ? _loc2_ : _loc1_;
         _loc3_.sort(CreativeRendition.sortOnPreference);
         return _loc3_;
      }
   }
}
