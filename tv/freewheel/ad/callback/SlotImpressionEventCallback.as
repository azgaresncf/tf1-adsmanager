package tv.freewheel.ad.callback
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.vo.eventCallback.EventCallback;
   import tv.freewheel.ad.vo.slot.BaseSlot;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.url.URLTools;
   
   public class SlotImpressionEventCallback extends BasicEventCallback
   {
      
      private static var logger:ILogger = Log.getLogger("AdManager.SlotImpressionEventCallback");
       
      
      private var _isProcessed:Boolean = false;
      
      private var _slot:BaseSlot;
      
      public function SlotImpressionEventCallback(param1:EventCallback, param2:BaseSlot)
      {
         this._slot = param2;
         super(param1,param2.context);
      }
      
      public static function construct(param1:Array, param2:String, param3:BaseSlot) : SlotImpressionEventCallback
      {
         var _loc4_:SlotImpressionEventCallback = null;
         var _loc5_:EventCallback;
         if(_loc5_ = getEvent(param1,param2,Constants.instance.EVENTCALLBACK_TYPE_IMPRESSION,true))
         {
            _loc4_ = new SlotImpressionEventCallback(_loc5_,param3);
         }
         return _loc4_;
      }
      
      override public function getType() : uint
      {
         return BasicEventCallback.TYPE_SLOT_IMPRESSION;
      }
      
      override protected function getParameter(param1:String) : Object
      {
         return this._slot.getParameter(param1);
      }
      
      override public function getUrl(param1:Boolean = true) : String
      {
         var _loc2_:String = super.getUrl();
         return URLTools.replaceUrlParam(_loc2_,BasicEventCallback.URL_KEY_INIT,this.getInitValue(),true);
      }
      
      private function getInitValue() : String
      {
         var _loc1_:String = null;
         if(this._slot.isPauseSlot() || !this._isProcessed)
         {
            _loc1_ = BasicEventCallback.INIT_VALUE_ONE;
         }
         else
         {
            _loc1_ = BasicEventCallback.INIT_VALUE_TWO;
         }
         return _loc1_;
      }
      
      override public function toString() : String
      {
         return "SlotImpressionEventCallback(" + this._slot.getCustomId() + ")";
      }
      
      override public function process() : void
      {
         this._needProcessTrackingUrls = this.getInitValue() == BasicEventCallback.INIT_VALUE_ONE;
         super.process();
         this._isProcessed = true;
      }
   }
}
