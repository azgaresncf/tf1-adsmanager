package tv.freewheel.ad.vo.ad
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.utils.xml.XMLUtils;
   
   public class CandidateAd
   {
       
      
      private var adId:uint;
      
      public function CandidateAd(param1:uint)
      {
         super();
         this.adId = param1;
      }
      
      public function toXML() : XMLNode
      {
         var _loc1_:XMLNode = new XMLNode(1,InnerConstants.TAG_CANDIDATE_AD);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_CANDIDATE_AD_ID,this.adId,_loc1_,true);
         return _loc1_;
      }
   }
}
