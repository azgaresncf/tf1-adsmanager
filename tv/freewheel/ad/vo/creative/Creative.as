package tv.freewheel.ad.vo.creative
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.vo.parameters.Parameter;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   
   public class Creative
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.Creative");
       
      
      public var id:Number;
      
      public var adUnit:String;
      
      public var parameters:Array;
      
      public var creativeRenditions:Array;
      
      public var duration:Number;
      
      public function Creative()
      {
         this.creativeRenditions = new Array();
         this.parameters = new Array();
         super();
      }
      
      private function parseCreativeRenditions(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:CreativeRendition = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            if(_loc3_.localName == InnerConstants.TAG_CREATIVE_RENDITION)
            {
               _loc4_ = new CreativeRendition(_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_ID],_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_CONTENT_TYPE],_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_PREFERENCE],_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_HEIGHT],_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_WIDTH]);
               this.addCreativeRendition(_loc4_);
               _loc4_.setWrapperType(_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_WRAPPERTYPE]);
               _loc4_.setWrapperURL(_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_WRAPPERURL]);
               _loc4_.setCreativeAPI(_loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_CREATIVEAPI]);
               _loc4_.replicaId = _loc3_.attributes[InnerConstants.ATTR_CREATIVE_RENDITION_REPLICA_ID];
               _loc4_.parseXML(_loc3_);
            }
            _loc2_++;
         }
      }
      
      public function addCreativeRendition(param1:CreativeRendition) : void
      {
         this.creativeRenditions.push(param1);
         this.creativeRenditions.sort(CreativeRendition.sortOnPreference);
         param1.creative = this;
      }
      
      public function cloneForTranslation() : Creative
      {
         var _loc1_:Creative = new Creative();
         _loc1_.id = this.id;
         _loc1_.duration = this.duration;
         _loc1_.adUnit = this.adUnit;
         _loc1_.parameters = this.parameters.slice();
         return _loc1_;
      }
      
      public function createCreativeRendition() : CreativeRendition
      {
         var _loc1_:CreativeRendition = new CreativeRendition();
         this.addCreativeRendition(_loc1_);
         return _loc1_;
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         this.id = Number(param1.attributes[InnerConstants.ATTR_CREATIVE_ID]);
         this.duration = Number(param1.attributes[InnerConstants.ATTR_CREATIVE_DURATION]);
         this.adUnit = param1.attributes[InnerConstants.ATTR_CREATIVE_BASEUNIT];
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_CREATIVE_RENDITIONS:
                  this.parseCreativeRenditions(_loc3_);
                  break;
               case InnerConstants.TAG_PARAMETERS:
                  Parameter.parseParametersToArray(_loc3_,this.parameters);
                  break;
            }
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         return "[Creative " + this.id + "]";
      }
      
      public function getCreativeRenditionById(param1:Number) : Array
      {
         var _loc3_:CreativeRendition = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.creativeRenditions)
         {
            if(_loc3_.id == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getParameter(param1:String) : String
      {
         return Parameter.getParameterFromArray(this.parameters,param1);
      }
   }
}
