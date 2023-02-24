package tv.freewheel.ad.playback
{
   internal class PreloadChainBehavior extends ChainBehavior
   {
       
      
      public function PreloadChainBehavior()
      {
         super();
      }
      
      override public function nextStateOnRendererPreloadComplete() : String
      {
         return AdState.LOADED;
      }
      
      override public function isChainStopper(param1:AdInstance) : Boolean
      {
         return anyAdInChainSentImpr(param1) || param1.state == AdState.LOADED && !param1.rendererEntry.isTranslator();
      }
      
      override public function isDestState(param1:String) : Boolean
      {
         return [AdState.STOPPED,AdState.LOADED,AdState.FAILED].indexOf(param1) > -1;
      }
      
      override public function relatedSlotState() : String
      {
         return SlotState.PRELOADING;
      }
      
      public function toString() : String
      {
         return "PreloadChainBehavior";
      }
   }
}
