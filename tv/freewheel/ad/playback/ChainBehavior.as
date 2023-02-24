package tv.freewheel.ad.playback
{
   public class ChainBehavior
   {
      
      private static var playBehavior:ChainBehavior = null;
      
      private static var preloadBehavior:ChainBehavior = null;
       
      
      public function ChainBehavior()
      {
         super();
      }
      
      public static function getPlayBehavior() : ChainBehavior
      {
         if(playBehavior == null)
         {
            playBehavior = new PlayChainBehavior();
         }
         return playBehavior;
      }
      
      public static function getPreloadBehavior() : ChainBehavior
      {
         if(preloadBehavior == null)
         {
            preloadBehavior = new PreloadChainBehavior();
         }
         return preloadBehavior;
      }
      
      public function nextStateOnRendererPreloadComplete() : String
      {
         return null;
      }
      
      public function isChainStopper(param1:AdInstance) : Boolean
      {
         return true;
      }
      
      public function isDestState(param1:String) : Boolean
      {
         return false;
      }
      
      public function relatedSlotState() : String
      {
         return null;
      }
      
      protected function anyAdInChainSentImpr(param1:AdInstance) : Boolean
      {
         var _loc2_:AdInstance = null;
         for each(_loc2_ in param1.adChain.adInstances)
         {
            if(_loc2_.imprSent)
            {
               return true;
            }
         }
         return false;
      }
   }
}
