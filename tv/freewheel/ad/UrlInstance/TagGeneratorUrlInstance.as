package tv.freewheel.ad.UrlInstance
{
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.utils.basic.KeyValues;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.url.URLTools;
   
   public class TagGeneratorUrlInstance
   {
       
      
      public var keyValues:KeyValues;
      
      public var clickThroughUrl:String;
      
      public var slots:Array;
      
      public var globalParams:GlobalParams;
      
      public function TagGeneratorUrlInstance()
      {
         super();
         this.slots = new Array();
      }
      
      private static function parseKeyValuePrams(param1:String) : KeyValues
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(SuperString.isNull(param1))
         {
            return null;
         }
         var _loc2_:KeyValues = new KeyValues();
         var _loc3_:Array = param1.split("&");
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = String(_loc3_[_loc4_]).split("=");
            _loc6_ = SuperString.trim(_loc5_[0]);
            _loc7_ = String(_loc5_[1]);
            _loc2_.put(_loc6_,_loc7_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function parseCompatibleDimensions(param1:String) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc2_:Array = new Array();
         if(param1 != null)
         {
            _loc3_ = param1.split("|");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if((_loc5_ = String(_loc3_[_loc4_]).split(",")).length == 2)
               {
                  _loc6_ = new Number(_loc5_[0]);
                  _loc7_ = new Number(_loc5_[1]);
                  if(!(isNaN(_loc6_) || _loc6_ <= 0 || isNaN(_loc7_) || _loc7_ <= 0))
                  {
                     _loc2_.push({
                        "width":_loc6_,
                        "height":_loc7_
                     });
                  }
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public static function parseSlotParams(param1:String) : SlotParams
      {
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:* = 0;
         var _loc13_:Array = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         if(SuperString.isNull(param1))
         {
            return null;
         }
         var _loc2_:SlotParams = new SlotParams();
         var _loc3_:Boolean = false;
         var _loc4_:Array = new Array();
         var _loc5_:Array = param1.split(";");
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc8_ = _loc5_[_loc6_].split("&");
            _loc4_ = _loc4_.concat(_loc8_);
            _loc6_++;
         }
         var _loc7_:uint = 0;
         for(; _loc7_ < _loc4_.length; _loc7_++)
         {
            _loc9_ = String(_loc4_[_loc7_]).split("=");
            _loc10_ = SuperString.trim(_loc9_[0]);
            _loc11_ = SuperString.trim(_loc9_[1]);
            if(SuperString.isNull(_loc10_) || SuperString.isNull(_loc11_))
            {
               continue;
            }
            switch(_loc10_)
            {
               case "cd":
                  _loc2_.compatibleDimensions = parseCompatibleDimensions(_loc11_);
                  break;
               case "flag":
               case "sflg":
                  _loc12_ = 0;
                  _loc13_ = parseFlags(_loc11_);
                  _loc14_ = 0;
                  while(_loc14_ < 2)
                  {
                     _loc15_ = 0;
                     while(_loc15_ < _loc13_[_loc14_].length)
                     {
                        switch(_loc13_[_loc14_][_loc15_].toString().toLowerCase())
                        {
                           case "cmpn":
                              _loc2_.acceptCompanion = _loc14_ == 0;
                              break;
                           case "nrpl":
                              _loc2_.acceptCompanion = _loc14_ != 0;
                              break;
                           case "init":
                              if(_loc14_ == 0)
                              {
                                 _loc12_ &= ~SlotParams.OPTION_INIT;
                              }
                              else
                              {
                                 _loc12_ |= SlotParams.OPTION_INIT;
                              }
                              _loc3_ = true;
                              break;
                           case "fcai":
                              if(_loc14_ == 0)
                              {
                                 _loc12_ |= SlotParams.OPTION_FCAI;
                              }
                              else
                              {
                                 _loc12_ &= ~SlotParams.OPTION_FCAI;
                              }
                              _loc3_ = true;
                              break;
                           case "niic":
                              if(_loc14_ == 0)
                              {
                                 _loc12_ |= SlotParams.OPTION_NIIC;
                              }
                              else
                              {
                                 _loc12_ &= ~SlotParams.OPTION_NIIC;
                              }
                              _loc3_ = true;
                              break;
                           case "nosa":
                              if(_loc14_ == 0)
                              {
                                 _loc12_ |= SlotParams.OPTION_NOSA;
                              }
                              else
                              {
                                 _loc12_ &= ~SlotParams.OPTION_NOSA;
                              }
                              _loc3_ = true;
                              break;
                           case "nsit":
                              if(_loc14_ == 0)
                              {
                                 _loc12_ |= SlotParams.OPTION_NSIT;
                              }
                              else
                              {
                                 _loc12_ &= ~SlotParams.OPTION_NSIT;
                              }
                              _loc3_ = true;
                              break;
                        }
                        _loc15_++;
                     }
                     _loc14_++;
                  }
                  switch(_loc12_)
                  {
                     case 0:
                        if(_loc3_)
                        {
                           _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_STAND_ALONE;
                        }
                        break;
                     case 1:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_KEEP_ORIGINAL;
                        break;
                     case 3:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_ONLY;
                        break;
                     case 2:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_STAND_ALONE;
                        break;
                     case 6:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_THEN_STAND_ALONE;
                        break;
                     case 8:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_NO_STAND_ALONE;
                        break;
                     case 10:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE;
                        break;
                     case 16:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_NO_STAND_ALONE_IF_TEMPORAL;
                        break;
                     case 18:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE_IF_TEMPORAL;
                        break;
                     default:
                        _loc2_.initialOption = Constants.instance.SLOT_OPTION_INITIAL_AD_STAND_ALONE;
                  }
                  break;
               case "lo":
                  if(!_loc3_)
                  {
                     _loc2_.initialOption = _loc11_ == "i" ? Constants.instance.SLOT_OPTION_INITIAL_AD_KEEP_ORIGINAL : Constants.instance.SLOT_OPTION_INITIAL_AD_STAND_ALONE;
                  }
                  break;
               case "ptgt":
                  _loc2_.ptgt = _loc11_;
                  break;
               case "slau":
                  _loc2_.adUnit = _loc11_;
                  break;
               case "tpcl":
                  _loc2_.timePositionClass = _loc11_;
                  break;
               case "h":
                  _loc2_.height = Number(_loc11_);
                  break;
               case "w":
                  _loc2_.width = Number(_loc11_);
                  break;
               case "slid":
                  _loc2_.customId = _loc11_;
                  break;
               case "tpos":
                  _loc2_.timePosition = Number(_loc11_);
                  break;
               case "maxd":
                  _loc2_.maxDuration = Number(_loc11_);
                  break;
               case "maxa":
                  _loc2_.maxAds = Number(_loc11_);
                  break;
               case "envp":
                  _loc2_.slotProfile = _loc11_;
                  break;
               case "cpsq":
                  _loc2_.cuePointSequence = Number(_loc11_);
                  break;
               case "cana":
                  _loc2_.candidateAds = String(_loc11_).split(",");
                  break;
               case "ssct":
                  _loc2_.acceptPrimaryContentType = _loc11_;
                  break;
            }
         }
         return _loc2_;
      }
      
      private static function setGlobalFlags(param1:GlobalParams, param2:String) : void
      {
         var _loc5_:uint = 0;
         var _loc3_:Array = parseFlags(param2);
         var _loc4_:uint = 0;
         while(_loc4_ < 2)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_[_loc4_].length)
            {
               switch(_loc3_[_loc4_][_loc5_].toString().toLowerCase())
               {
                  case "targ":
                     param1.checkTargeting = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "cmpn":
                     param1.checkCompanion = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "amsl":
                     param1.adUnitInMultiSlots = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "exvt":
                     param1.recordVideoView = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "fbad":
                     param1.supportFallbackAds = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "sync":
                     param1.syncMultiRequest = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "unka":
                     param1.fallbackUnknownAsset = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "unks":
                     param1.fallbackUnknownSiteSection = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "ssss":
                     param1.syncSiteSectionSlots = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "emcr":
                     param1.expectMultiCreativeRenditions = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "play":
                     param1.autoPlay = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
                  case "uapl":
                     param1.autoPlayType = _loc4_ == 0 ? GlobalParams.FLAG_ON : GlobalParams.FLAG_OFF;
                     break;
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      public static function instantiate(param1:String) : TagGeneratorUrlInstance
      {
         var _loc9_:String = null;
         var _loc10_:SlotParams = null;
         if(SuperString.isNull(param1))
         {
            return null;
         }
         var _loc2_:TagGeneratorUrlInstance = new TagGeneratorUrlInstance();
         var _loc3_:String = String(param1.split("?")[1]);
         if(SuperString.isNull(_loc3_))
         {
            return null;
         }
         var _loc4_:Array;
         var _loc5_:String = String((_loc4_ = _loc3_.split(";~;"))[0]);
         var _loc6_:String;
         if(_loc6_ = String(_loc4_[1]))
         {
            if(_loc9_ = String(_loc6_.split("=")[1]))
            {
               _loc2_.clickThroughUrl = URLTools.decodeURI(_loc9_);
            }
         }
         if(SuperString.isNull(_loc5_))
         {
            return null;
         }
         var _loc7_:Array;
         if((_loc7_ = _loc5_.split(";")).length < 2)
         {
            return null;
         }
         _loc2_.globalParams = TagGeneratorUrlInstance.parseGlobalParams(_loc7_[0]);
         _loc2_.keyValues = TagGeneratorUrlInstance.parseKeyValuePrams(_loc7_[1]);
         var _loc8_:uint = 2;
         while(_loc8_ < _loc7_.length)
         {
            if((_loc10_ = TagGeneratorUrlInstance.parseSlotParams(_loc7_[_loc8_])) != null)
            {
               _loc10_.clickThroughUrl = _loc2_.clickThroughUrl;
               _loc2_.slots.push(_loc10_);
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      private static function parseFlags(param1:String) : Array
      {
         var _loc7_:String = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:String = "";
         var _loc5_:* = true;
         param1 += "+";
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            _loc7_ = param1.charAt(_loc6_);
            switch(_loc7_)
            {
               case "+":
               case "-":
                  if(_loc4_ != "")
                  {
                     if(_loc5_)
                     {
                        _loc2_.push(_loc4_);
                     }
                     else
                     {
                        _loc3_.push(_loc4_);
                     }
                     _loc4_ = "";
                  }
                  _loc5_ = _loc7_ == "+";
                  break;
               default:
                  _loc4_ += _loc7_;
                  break;
            }
            _loc6_++;
         }
         return [_loc2_,_loc3_];
      }
      
      private static function parseGlobalParams(param1:String) : GlobalParams
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(SuperString.isNull(param1))
         {
            return null;
         }
         var _loc2_:GlobalParams = new GlobalParams();
         var _loc3_:Array = param1.split("&");
         var _loc4_:uint = 0;
         for(; _loc4_ < _loc3_.length; _loc4_++)
         {
            _loc5_ = String(_loc3_[_loc4_]).split("=");
            _loc6_ = SuperString.trim(_loc5_[0]);
            _loc7_ = SuperString.trim(_loc5_[1]);
            if(SuperString.isNull(_loc6_) || SuperString.isNull(_loc7_))
            {
               continue;
            }
            switch(_loc6_)
            {
               case "mode":
                  _loc2_.mode = _loc7_;
                  break;
               case "asml":
                  _loc2_.assetMediaLocation = _loc7_;
                  break;
               case "afid":
                  _loc2_.assetFallbackId = Number(_loc7_);
                  break;
               case "sfid":
                  _loc2_.siteSectionFallbackId = Number(_loc7_);
                  break;
               case "vdsp":
                  _loc2_.videoDefaultSlotProfile = _loc7_;
                  break;
               case "vdur":
                  _loc2_.videoDuration = Number(_loc7_);
                  break;
               case "vcid":
                  _loc2_.visitorCustomId = _loc7_;
                  break;
               case "nw":
                  _loc2_.networkId = Number(_loc7_);
                  break;
               case "asid":
                  _loc2_.assetId = _loc7_;
                  break;
               case "caid":
                  _loc2_.customAssetId = _loc7_;
                  break;
               case "asnw":
                  _loc2_.assetNetworkId = Number(_loc7_);
                  break;
               case "ssid":
                  _loc2_.siteSectionId = _loc7_;
                  break;
               case "csid":
                  _loc2_.customSiteSectionId = _loc7_;
                  break;
               case "ssnw":
                  _loc2_.siteSectionNetworkId = Number(_loc7_);
                  break;
               case "cana":
                  _loc2_.candidateAds = String(_loc7_).split(",");
                  break;
               case "pvrn":
                  _loc2_.pageViewRandomNumber = Number(_loc7_);
                  break;
               case "vprn":
                  _loc2_.videoPlayerRandomNumber = Number(_loc7_);
                  break;
               case "flag":
                  setGlobalFlags(_loc2_,_loc7_);
                  break;
            }
         }
         return _loc2_;
      }
   }
}
