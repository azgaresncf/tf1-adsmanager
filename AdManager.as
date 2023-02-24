package
{
   import flash.display.MovieClip;
   import tv.freewheel.ad.behavior.IAdManager;
   import tv.freewheel.ad.manager.AdManager;
   import tv.freewheel.utils.log.Logger;
   
   public class AdManager extends MovieClip
   {
       
      
      public function AdManager()
      {
         super();
         tv.freewheel.ad.manager.AdManager.OutputFormat = "";
         var _loc1_:Boolean = tv.freewheel.ad.manager.AdManager.AdManagerInitialized;
         var _loc2_:String = String(this.loaderInfo.parameters["logLevel"]);
         var _loc3_:uint = 0;
         switch(_loc2_)
         {
            case "INFO":
               _loc3_ = 1;
               break;
            case "WARN":
               _loc3_ = 2;
               break;
            case "ERROR":
               _loc3_ = 3;
               break;
            case "QUIET":
               _loc3_ = 4;
               break;
            default:
               _loc3_ = 0;
         }
         Logger.getInstance().setLogLevel(_loc3_);
      }
      
      public function initialize(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         for(_loc2_ in param1)
         {
            _loc4_ = param1[_loc2_];
            switch(_loc2_)
            {
               case "logLevel":
                  if(_loc4_ != -1)
                  {
                     Logger.getInstance().setLogLevel(_loc4_);
                  }
                  break;
               case "stageUrl":
                  if(_loc4_)
                  {
                     tv.freewheel.ad.manager.AdManager.StageUrl = _loc4_;
                  }
                  break;
               case "loaderInstance":
                  if(_loc4_)
                  {
                     tv.freewheel.ad.manager.AdManager.LoaderInstance = _loc4_;
                  }
                  break;
               case "admURL":
                  if(_loc4_)
                  {
                     tv.freewheel.ad.manager.AdManager.AdManagerUrl = _loc4_;
                  }
                  break;
            }
         }
         _loc3_ = this.loaderInfo.url;
         if(Boolean(_loc3_) && !tv.freewheel.ad.manager.AdManager.AdManagerUrl)
         {
            _loc3_ = _loc3_.replace(/(\w+:\/\/).*\[\[IMPORT\]\]\/(.+)/i,"$1$2");
            Logger.instance.info("AdManagerMC.set AdManagerUrl:" + _loc3_);
            tv.freewheel.ad.manager.AdManager.AdManagerUrl = _loc3_;
         }
      }
      
      public function getNewInstance(param1:int) : IAdManager
      {
         Logger.instance.info("AdManagerMC.getNewInstance(interfaceVersion=0x" + param1.toString(16) + ")");
         return new tv.freewheel.ad.manager.AdManager();
      }
   }
}
