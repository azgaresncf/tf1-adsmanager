package tv.freewheel.ad.vo.visitor
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.RequestContext;
   import tv.freewheel.ad.manager.AdManager;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.xml.XMLUtils;
   
   public class Visitor
   {
       
      
      public var httpHeaders:HashMap;
      
      public var customId:String;
      
      public var ipV4Address:String;
      
      public var bandwidth:uint;
      
      public var bandwidthSource:String;
      
      public function Visitor()
      {
         super();
         this.httpHeaders = new HashMap();
      }
      
      public function toXML(param1:RequestContext) : XMLNode
      {
         var _loc4_:XMLNode = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:XMLNode = null;
         var _loc9_:XMLNode = null;
         var _loc2_:XMLNode = new XMLNode(1,InnerConstants.TAG_VISITOR);
         var _loc3_:Object = param1.getParameter("wrapperVersion");
         XMLUtils.addStringAttribute(InnerConstants.ATTR_VISITOR_CALLER,AdManager.Caller + AdManager.OutputFormat + (!!_loc3_ ? "," + _loc3_ : ""),_loc2_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_CUSTOM_ID,this.customId,_loc2_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_VISITOR_IPV4_ADDRESS,this.ipV4Address,_loc2_,true);
         if(this.httpHeaders != null)
         {
            _loc4_ = new XMLNode(1,InnerConstants.TAG_HTTP_HEADERS);
            _loc2_.appendChild(_loc4_);
            _loc5_ = this.httpHeaders.getKeys();
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc7_ = String(_loc5_[_loc6_]);
               (_loc8_ = new XMLNode(1,InnerConstants.TAG_HTTP_HEADER)).attributes[InnerConstants.ATTR_HTTP_HEADER_VALUE] = this.httpHeaders.get(_loc7_);
               _loc8_.attributes[InnerConstants.ATTR_HTTP_HEADER_NAME] = _loc7_;
               _loc4_.appendChild(_loc8_);
               _loc6_++;
            }
         }
         if(this.bandwidth > 0)
         {
            _loc9_ = new XMLNode(1,InnerConstants.TAG_BAND_WIDTH_INFO);
            XMLUtils.addNumberAttribute(InnerConstants.ATTR_BAND_WIDTH_INFO_BAND_WIDTH,this.bandwidth,_loc9_,true);
            XMLUtils.addStringAttribute(InnerConstants.ATTR_BAND_WIDTH_INFO_SOURCE,this.bandwidthSource,_loc9_,true);
            _loc2_.appendChild(_loc9_);
         }
         return _loc2_;
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:uint = 0;
         var _loc5_:XMLNode = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_VISITOR_HTTP_HEADERS:
                  _loc4_ = 0;
                  while(_loc4_ < _loc3_.childNodes.length)
                  {
                     if((_loc5_ = _loc3_.childNodes[_loc4_]).localName == InnerConstants.TAG_HTTP_HEADER)
                     {
                        this.setHttpHeader(_loc5_.attributes[InnerConstants.ATTR_HTTP_HEADER_NAME],_loc5_.attributes[InnerConstants.ATTR_HTTP_HEADER_VALUE]);
                     }
                     _loc4_++;
                  }
                  break;
            }
            _loc2_++;
         }
      }
      
      public function init(param1:String, param2:String, param3:uint, param4:String) : void
      {
         this.customId = param1;
         this.ipV4Address = param2;
         this.bandwidth = param3;
         this.bandwidthSource = param4;
      }
      
      public function copy(param1:Visitor) : void
      {
         this.customId = param1.customId;
         this.ipV4Address = param1.ipV4Address;
         this.httpHeaders = param1.httpHeaders.clone();
         this.bandwidth = param1.bandwidth;
         this.bandwidthSource = param1.bandwidthSource;
      }
      
      public function setHttpHeader(param1:String, param2:String) : void
      {
         this.httpHeaders.put(param1,param2,false);
         this.httpHeaders.clean();
      }
   }
}
