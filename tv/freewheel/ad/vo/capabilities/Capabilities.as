package tv.freewheel.ad.vo.capabilities
{
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.utils.basic.HashMap;
   import tv.freewheel.utils.xml.XMLUtils;
   
   public class Capabilities
   {
      
      public static const OVERRIDE_FEATURES:Array = [Constants.instance.CAPABILITY_RECORD_VIDEO_VIEW];
      
      public static const DEFAULT_ON_FEATURES:Array = [Constants.instance.CAPABILITY_SLOT_TEMPLATE,Constants.instance.CAPABILITY_MULTIPLE_CREATIVE_RENDITIONS,Constants.instance.CAPABILITY_ADUNIT_IN_MULTIPLE_SLOTS,Constants.instance.CAPABILITY_SLOT_CALLBACK,Constants.instance.CAPABILITY_NULL_CREATIVE,Constants.instance.CAPABILITY_SUPPORT_AD_BUNDLE,Constants.instance.CAPABILITY_FALLBACK_ADS,Constants.instance.CAPABILITY_AUTO_EVENT_TRACKING,Constants.instance.CAPABILITY_SUPPORT_SLOT_INFO];
      
      public static const CANDIDATE_AD_DEFAULT_OFF_FEATURES:Array = [Constants.instance.CAPABILITY_CHECK_TARGETING];
      
      public static const DEFAULT_OFF_FEATURES:Array = [Constants.instance.CAPABILITY_BYPASS_COMMERCIAL_RATIO_RESTRICTION,Constants.instance.CAPABILITY_REQUIRES_RENDERER_MANIFEST,Constants.instance.CAPABILITY_REQUIRES_VIDEO_CALLBACK_URL,Constants.instance.CAPABILITY_SKIP_AD_SELECTION,Constants.instance.CAPABILITY_SYNC_MULTI_REQUESTS,Constants.instance.CAPABILITY_RESET_EXCLUSIVITY,Constants.instance.CAPABILITY_SYNC_SITESECTION_SLOTS,Constants.instance.CAPABILITY_FALLBACK_UNKNOWN_ASSET,Constants.instance.CAPABILITY_FALLBACK_UNKNOWN_SS,Constants.instance.CAPABILITY_SECURE_MODE,Constants.instance.CAPABILITY_DISPLAY_REFRESH];
      
      public static const CANDIDATE_AD_DEFAULT_ON_FEATURES:Array = [Constants.instance.CAPABILITY_CHECK_COMPANION];
       
      
      private var supported:HashMap;
      
      public function Capabilities()
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         super();
         this.supported = new HashMap();
         _loc1_ = 0;
         while(_loc1_ < DEFAULT_OFF_FEATURES.length)
         {
            _loc2_ = String(DEFAULT_OFF_FEATURES[_loc1_]);
            this.setCapability(_loc2_,0);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < DEFAULT_ON_FEATURES.length)
         {
            _loc2_ = String(DEFAULT_ON_FEATURES[_loc1_]);
            this.setCapability(_loc2_,1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CANDIDATE_AD_DEFAULT_OFF_FEATURES.length)
         {
            _loc2_ = String(CANDIDATE_AD_DEFAULT_OFF_FEATURES[_loc1_]);
            this.setCapability(_loc2_,0);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CANDIDATE_AD_DEFAULT_ON_FEATURES.length)
         {
            _loc2_ = String(CANDIDATE_AD_DEFAULT_ON_FEATURES[_loc1_]);
            this.setCapability(_loc2_,1);
            _loc1_++;
         }
         this.setCapability(Constants.instance.CAPABILITY_RECORD_VIDEO_VIEW,-1);
      }
      
      public function candidateCapabilityToXML(param1:XMLNode) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = false;
         var _loc2_:Array = CANDIDATE_AD_DEFAULT_ON_FEATURES.concat(CANDIDATE_AD_DEFAULT_OFF_FEATURES);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = String(_loc2_[_loc3_]);
            _loc5_ = this.supported.get(_loc4_) == 1;
            XMLUtils.addBooleanAttribute(_loc4_,_loc5_,param1);
            _loc3_++;
         }
      }
      
      public function copy(param1:Capabilities) : void
      {
         this.supported = param1.supported.clone();
      }
      
      public function setCapability(param1:String, param2:*) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         if(param2 != null && !isNaN(param2))
         {
            if(param2 == -1)
            {
               _loc3_ = false;
               _loc4_ = 0;
               while(_loc4_ < OVERRIDE_FEATURES.length)
               {
                  if(param1 == OVERRIDE_FEATURES[_loc4_])
                  {
                     _loc3_ = true;
                  }
                  _loc4_++;
               }
               if(!_loc3_)
               {
                  _loc5_ = DEFAULT_ON_FEATURES.concat(CANDIDATE_AD_DEFAULT_ON_FEATURES);
                  _loc6_ = false;
                  _loc7_ = 0;
                  while(_loc7_ < _loc5_.length)
                  {
                     if(param1 == _loc5_[_loc7_])
                     {
                        _loc6_ = true;
                     }
                     _loc7_++;
                  }
                  if(_loc6_)
                  {
                     param2 = 1;
                  }
                  else
                  {
                     param2 = 0;
                  }
               }
            }
            this.supported.put(param1,Number(param2));
         }
      }
      
      public function toXML() : XMLNode
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:XMLNode = null;
         var _loc1_:XMLNode = new XMLNode(1,InnerConstants.TAG_CAPABILITIES);
         var _loc2_:Array = DEFAULT_ON_FEATURES.concat(DEFAULT_OFF_FEATURES);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = String(_loc2_[_loc3_]);
            if(this.supported.get(_loc5_) == 1)
            {
               _loc1_.appendChild(new XMLNode(1,_loc5_));
            }
            _loc3_++;
         }
         var _loc4_:int = 0;
         while(_loc4_ < OVERRIDE_FEATURES.length)
         {
            _loc6_ = String(OVERRIDE_FEATURES[_loc4_]);
            _loc7_ = null;
            if(this.supported.get(_loc6_) == 0 || this.supported.get(_loc6_) == 1)
            {
               (_loc7_ = new XMLNode(1,_loc6_)).appendChild(new XMLNode(4,String(this.supported.get(_loc6_) == 1 ? "true" : "false")));
               _loc1_.appendChild(_loc7_);
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getCapability(param1:String) : int
      {
         return this.supported.get(param1);
      }
   }
}
