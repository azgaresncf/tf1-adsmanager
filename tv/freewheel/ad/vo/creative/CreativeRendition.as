package tv.freewheel.ad.vo.creative
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.behavior.ICreativeRendition;
   import tv.freewheel.ad.behavior.ICreativeRenditionAsset;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class CreativeRendition implements ICreativeRendition
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.CreativeRendition");
       
      
      public var replicaId:String;
      
      public var id:Number;
      
      public var height:uint;
      
      public var creative:Creative;
      
      public var otherAssets:Array;
      
      public var width:uint;
      
      public var contentType:String;
      
      public var preference:int = 0;
      
      public var wrapperUrl:String;
      
      public var parameters:Array;
      
      public var wrapperType:String;
      
      public var asset:CreativeRenditionAsset;
      
      public var creativeAPI:String;
      
      public function CreativeRendition(param1:Number = NaN, param2:String = null, param3:int = 0, param4:uint = 0, param5:uint = 0)
      {
         this.otherAssets = new Array();
         this.parameters = new Array();
         super();
         this.id = param1;
         this.contentType = param2;
         this.preference = param3;
         this.height = param4;
         this.width = param5;
      }
      
      public static function sortOnPreference(param1:ICreativeRendition, param2:ICreativeRendition) : Number
      {
         var _loc3_:int = param1.getPreference();
         var _loc4_:int = param2.getPreference();
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      private function parseOtherAssets(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:XMLNode = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            if(_loc3_.localName == InnerConstants.TAG_ASSET)
            {
               _loc4_ = null;
               _loc5_ = 0;
               while(_loc5_ < _loc3_.childNodes.length)
               {
                  if((_loc6_ = _loc3_.childNodes[_loc5_]).localName == InnerConstants.ATTR_ASSET_CONTENT && Boolean(_loc6_.firstChild))
                  {
                     _loc4_ = _loc6_.firstChild.nodeValue;
                  }
                  _loc5_++;
               }
               this.addOtherAssets(_loc3_.attributes[InnerConstants.ATTR_ASSET_ID],_loc3_.attributes[InnerConstants.ATTR_ASSET_CONTENT_TYPE],_loc3_.attributes[InnerConstants.ATTR_ASSET_MIME_TYPE],_loc3_.attributes[InnerConstants.ATTR_ASSET_NAME],_loc3_.attributes[InnerConstants.ATTR_ASSET_URL],_loc3_.attributes[InnerConstants.ATTR_ASSET_BYTES],_loc4_);
            }
            _loc2_++;
         }
      }
      
      public function setWidth(param1:uint) : void
      {
         this.width = param1;
      }
      
      public function getWidth() : uint
      {
         return this.width;
      }
      
      public function getDuration() : Number
      {
         return this.creative.duration;
      }
      
      private function parseAsset(param1:XMLNode) : void
      {
         var _loc4_:XMLNode = null;
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.childNodes.length)
         {
            if((_loc4_ = param1.childNodes[_loc3_]).localName == InnerConstants.ATTR_ASSET_CONTENT && Boolean(_loc4_.firstChild))
            {
               _loc2_ = _loc4_.firstChild.nodeValue;
            }
            _loc3_++;
         }
         this.setAsset(param1.attributes[InnerConstants.ATTR_ASSET_ID],param1.attributes[InnerConstants.ATTR_ASSET_CONTENT_TYPE],param1.attributes[InnerConstants.ATTR_ASSET_MIME_TYPE],param1.attributes[InnerConstants.ATTR_ASSET_NAME],param1.attributes[InnerConstants.ATTR_ASSET_URL],param1.attributes[InnerConstants.ATTR_ASSET_BYTES],_loc2_);
      }
      
      public function setDuration(param1:Number) : void
      {
         this.creative.duration = param1;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getContentType() : String
      {
         var _loc1_:String = null;
         if(this.contentType != null)
         {
            _loc1_ = this.contentType;
         }
         else if(this.asset != null)
         {
            _loc1_ = this.asset.contentType;
         }
         return _loc1_;
      }
      
      public function getTotalBytes() : int
      {
         var _loc2_:CreativeRenditionAsset = null;
         var _loc1_:int = -1;
         for each(_loc2_ in this.getAssets())
         {
            if(_loc2_.bytes > 0)
            {
               if(_loc1_ == -1)
               {
                  _loc1_ = _loc2_.bytes;
               }
               else
               {
                  _loc1_ += _loc2_.bytes;
               }
            }
         }
         return _loc1_;
      }
      
      public function setContentType(param1:String) : void
      {
         this.contentType = param1;
      }
      
      public function setWrapperType(param1:String) : void
      {
         this.wrapperType = param1;
      }
      
      public function getHeight() : uint
      {
         return this.height;
      }
      
      public function setAsset(param1:uint, param2:String, param3:String, param4:String, param5:String, param6:uint, param7:String) : void
      {
         this.asset = new CreativeRenditionAsset(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public function setCreativeAPI(param1:String) : void
      {
         this.creativeAPI = param1;
      }
      
      public function getCreativeAPI() : String
      {
         if(this.creativeAPI != null)
         {
            return this.creativeAPI;
         }
         return null;
      }
      
      public function findAsset(param1:String, param2:String) : CreativeRenditionAsset
      {
         var _loc3_:Array = this.getCreativeRenditionAssets(param1,param2);
         if(_loc3_.length > 0)
         {
            return _loc3_[0];
         }
         return null;
      }
      
      public function getCreativeRenditionAssets(param1:String, param2:String = "name") : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:Array = this.getAllCreativeRenditionAssets();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_][param2] == param1)
            {
               _loc3_.push(_loc4_[_loc5_]);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function getWrapperType() : String
      {
         return this.wrapperType;
      }
      
      public function getAdUnit() : String
      {
         return this.getBaseUnit();
      }
      
      public function setRendition(param1:Number, param2:Number, param3:String, param4:Number) : void
      {
         this.width = param1;
         this.height = param2;
         this.contentType = param3;
         this.preference = param4;
      }
      
      public function setHeight(param1:uint) : void
      {
         this.height = param1;
      }
      
      public function getPreference() : int
      {
         return this.preference;
      }
      
      public function addOtherAssets(param1:uint, param2:String, param3:String, param4:String, param5:String, param6:uint, param7:String) : void
      {
         var _loc8_:CreativeRenditionAsset = new CreativeRenditionAsset(param1,param2,param3,param4,param5,param6,param7);
         this.otherAssets.push(_loc8_);
      }
      
      public function getPrimaryCreativeRenditionAsset() : ICreativeRenditionAsset
      {
         return this.asset;
      }
      
      public function getWrapperURL() : String
      {
         return this.wrapperUrl;
      }
      
      public function setPreference(param1:int) : void
      {
         this.preference = param1;
         this.creative.creativeRenditions.sort(CreativeRendition.sortOnPreference);
      }
      
      public function getParameters() : Array
      {
         return this.parameters.slice();
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_PARAMETERS:
                  Parameter.parseParametersToArray(_loc3_,this.parameters);
                  break;
               case InnerConstants.TAG_ASSET:
                  this.parseAsset(_loc3_);
                  break;
               case InnerConstants.TAG_OTHER_ASSETS:
                  this.parseOtherAssets(_loc3_);
                  break;
            }
            _loc2_++;
         }
      }
      
      public function setWrapperURL(param1:String) : void
      {
         this.wrapperUrl = param1;
      }
      
      public function getBaseUnit() : String
      {
         return this.creative.adUnit;
      }
      
      public function toString() : String
      {
         return "[CreativeRendition " + this.id + (this.preference != 0 ? " pref " + this.preference : "") + (!!this.replicaId ? " replicaId " + this.replicaId : "") + "]";
      }
      
      public function setParameter(param1:String, param2:String) : void
      {
         Parameter.addParameterToArray(this.parameters,param1,param2);
      }
      
      public function getParameter(param1:String) : String
      {
         return Parameter.getParameterFromArray(this.parameters,param1);
      }
      
      public function getAssets() : Array
      {
         var _loc1_:Array = new Array();
         if(this.asset != null)
         {
            _loc1_.push(this.asset);
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.otherAssets.length)
         {
            _loc1_.push(this.otherAssets[_loc2_]);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function addCreativeRenditionAsset(param1:String, param2:Boolean = true) : ICreativeRenditionAsset
      {
         var _loc3_:CreativeRenditionAsset = new CreativeRenditionAsset(-1,"translated/null","null/translated",param1,"",-1,"");
         if(param2)
         {
            this.asset = _loc3_;
         }
         else
         {
            this.otherAssets.push(_loc3_);
         }
         return _loc3_;
      }
      
      public function getAllCreativeRenditionAssets() : Array
      {
         return this.getAssets();
      }
   }
}
