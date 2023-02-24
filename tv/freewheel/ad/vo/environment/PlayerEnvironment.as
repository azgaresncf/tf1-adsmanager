package tv.freewheel.ad.vo.environment
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class PlayerEnvironment
   {
       
      
      public var temporalSlotHeight:uint = 0;
      
      public var videoPlaybackAreaX:int = 0;
      
      public var videoPlaybackAreaY:int = 0;
      
      public var temporalSlotX:int = 0;
      
      public var temporalSlotY:int = 0;
      
      public var adVolume:uint = 100;
      
      public var videoPlaybackAreaWidth:uint = 0;
      
      public var temporalSlotWidth:uint = 0;
      
      public var videoDuration:uint = 0;
      
      public var temporalSlotBase:Sprite;
      
      public var videoPlaybackAreaHeight:uint = 0;
      
      public function PlayerEnvironment()
      {
         super();
      }
      
      public function getTemporalSlotBounds() : Rectangle
      {
         return new Rectangle(this.temporalSlotX,this.temporalSlotY,this.temporalSlotWidth,this.temporalSlotHeight);
      }
      
      public function resize(param1:int, param2:int, param3:uint, param4:uint, param5:int, param6:int, param7:uint, param8:uint) : void
      {
         this.temporalSlotX = param1;
         this.temporalSlotY = param2;
         this.temporalSlotWidth = param3;
         this.temporalSlotHeight = param4;
         this.videoPlaybackAreaX = param5;
         this.videoPlaybackAreaY = param6;
         this.videoPlaybackAreaWidth = param7;
         this.videoPlaybackAreaHeight = param8;
      }
   }
}
