package tv.freewheel.ad.UrlInstance
{
   public class SlotParams
   {
      
      public static const OPTION_FCAI:uint = 2;
      
      public static const OPTION_NOSA:uint = 8;
      
      public static const OPTION_INIT:uint = 1;
      
      public static const OPTION_NSIT:uint = 16;
      
      public static const OPTION_NIIC:uint = 4;
       
      
      public var compatibleDimensions:Array;
      
      public var timePositionClass:String;
      
      public var width:int;
      
      public var adUnit:String;
      
      public var slotProfile:String;
      
      public var clickThroughUrl:String;
      
      public var acceptPrimaryContentType:String;
      
      public var timePosition:Number = -1;
      
      public var initialOption;
      
      public var height:int;
      
      public var acceptCompanion:Boolean;
      
      public var customId:String;
      
      public var candidateAds:Array;
      
      public var ptgt:String;
      
      public var maxAds:int;
      
      public var maxDuration:Number;
      
      public var cuePointSequence:Number = 0;
      
      public function SlotParams()
      {
         super();
         this.candidateAds = new Array();
         this.compatibleDimensions = new Array();
         this.acceptCompanion = true;
         this.initialOption = 0;
      }
   }
}
