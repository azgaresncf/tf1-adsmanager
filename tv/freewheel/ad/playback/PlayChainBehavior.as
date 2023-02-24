package tv.freewheel.ad.playback
{
   internal class PlayChainBehavior extends ChainBehavior
   {
       
      
      public function PlayChainBehavior()
      {
         super();
      }
      
      override public function nextStateOnRendererPreloadComplete() : String
      {
         return AdState.STARTING;
      }
      
      override public function isChainStopper(param1:AdInstance) : Boolean
      {
         return anyAdInChainSentImpr(param1);
      }
      
      override public function isDestState(param1:String) : Boolean
      {
         return [AdState.STOPPED,AdState.FAILED].indexOf(param1) > -1;
      }
      
      override public function relatedSlotState() : String
      {
         return SlotState.PLAYING;
      }
      
      public function toString() : String
      {
         return "PlayChainBehavior";
      }
   }
}
