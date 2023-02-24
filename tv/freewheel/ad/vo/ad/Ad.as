package tv.freewheel.ad.vo.ad
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.vo.creative.Creative;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class Ad
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.Ad");
       
      
      private var _hasPaddingCreative:Boolean = false;
      
      public var noLoad:Boolean = false;
      
      public var noPreload:Boolean = false;
      
      public var adUnit:String;
      
      public var requiredToShow:Boolean = false;
      
      public var creatives:Array;
      
      public var adId:uint;
      
      public var bundleId:String;
      
      public function Ad()
      {
         this.creatives = new Array();
         super();
      }
      
      public function createCreative() : Creative
      {
         var _loc1_:Creative = new Creative();
         this.creatives.push(_loc1_);
         return _loc1_;
      }
      
      public function get1stCreative() : Creative
      {
         if(this.creatives != null)
         {
            return this.creatives[0];
         }
         return null;
      }
      
      public function get id() : String
      {
         return String(this.adId);
      }
      
      public function getCreativeById(param1:uint) : Creative
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.creatives.length)
         {
            if(this.creatives[_loc2_].id == param1)
            {
               return this.creatives[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function isFrontBumper() : Boolean
      {
         return this.adUnit == Constants.instance.FW_ADUNIT_FRONT_BUMPER;
      }
      
      public function hasPaddingCreative() : Boolean
      {
         this._hasPaddingCreative = this._hasPaddingCreative || Boolean(this.get1stCreative()) && this.get1stCreative().duration == -1;
         return this._hasPaddingCreative;
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:uint = 0;
         var _loc5_:XMLNode = null;
         var _loc6_:Creative = null;
         this.adId = param1.attributes[InnerConstants.ATTR_AD_ID];
         this.adUnit = param1.attributes[InnerConstants.ATTR_AD_ADUNIT];
         this.noLoad = param1.attributes[InnerConstants.ATTR_AD_NO_LOAD] == "true";
         this.noPreload = param1.attributes[InnerConstants.ATTR_AD_NO_PRELOAD] == "true";
         this.bundleId = param1.attributes[InnerConstants.ATTR_AD_BUNDLE_ID];
         if(param1.attributes[InnerConstants.ATTR_AD_REFERENCE_REQUIRED])
         {
            this.requiredToShow = param1.attributes[InnerConstants.ATTR_AD_REFERENCE_REQUIRED] == "true";
         }
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            if(_loc3_.localName == InnerConstants.TAG_CREATIVES)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.childNodes.length)
               {
                  if((_loc5_ = _loc3_.childNodes[_loc4_]).localName == InnerConstants.TAG_CREATIVE)
                  {
                     (_loc6_ = this.createCreative()).parseXML(_loc5_);
                  }
                  _loc4_++;
               }
            }
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         return "[Ad " + this.id + "]";
      }
      
      public function isBumper() : Boolean
      {
         return this.adUnit == Constants.instance.FW_ADUNIT_END_BUMPER || this.isFrontBumper();
      }
      
      public function cloneForTranslation(param1:Number) : Ad
      {
         var _loc3_:Creative = null;
         var _loc2_:Ad = new Ad();
         _loc2_.adId = this.adId;
         _loc2_.adUnit = this.adUnit;
         _loc2_.bundleId = this.bundleId;
         _loc2_.requiredToShow = this.requiredToShow;
         for each(_loc3_ in this.creatives)
         {
            if(!param1 || _loc3_.id == param1)
            {
               _loc2_.creatives.push(_loc3_.cloneForTranslation());
            }
         }
         return _loc2_;
      }
   }
}
