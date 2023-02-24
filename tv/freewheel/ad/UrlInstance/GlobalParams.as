package tv.freewheel.ad.UrlInstance
{
   public class GlobalParams
   {
      
      public static const FLAG_ON:int = 1;
      
      public static const FLAG_UNSET:int = -1;
      
      public static const FLAG_OFF:int = 0;
       
      
      public var customAssetId:String;
      
      public var autoPlay:int = -1;
      
      public var checkTargeting:int = -1;
      
      public var expectMultiCreativeRenditions:int = -1;
      
      public var supportFallbackAds:int = -1;
      
      public var mode:String;
      
      public var videoDefaultSlotProfile:String;
      
      public var assetMediaLocation:String;
      
      public var assetId:String;
      
      public var candidateAds:Array;
      
      public var videoDuration:Number;
      
      public var assetFallbackId:Number;
      
      public var videoPlayerRandomNumber:Number;
      
      public var syncMultiRequest:int = -1;
      
      public var siteSectionId:String;
      
      public var siteSectionFallbackId:Number;
      
      public var pageViewRandomNumber:Number;
      
      public var checkCompanion:int = -1;
      
      public var customSiteSectionId:String;
      
      public var networkId:Number;
      
      public var siteSectionNetworkId:Number;
      
      public var adUnitInMultiSlots:int = -1;
      
      public var assetNetworkId:Number;
      
      public var syncSiteSectionSlots:int = -1;
      
      public var fallbackUnknownAsset:int = -1;
      
      public var fallbackUnknownSiteSection:int = -1;
      
      public var visitorCustomId:String;
      
      public var recordVideoView:int = -1;
      
      public var autoPlayType:int = -1;
      
      public function GlobalParams()
      {
         super();
         this.candidateAds = new Array();
      }
   }
}
