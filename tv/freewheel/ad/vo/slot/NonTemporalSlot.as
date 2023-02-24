package tv.freewheel.ad.vo.slot
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.context.Contexts;
   import tv.freewheel.ad.playback.AdChain;
   import tv.freewheel.ad.playback.AdInstance;
   import tv.freewheel.ad.playback.SlotState;
   import tv.freewheel.utils.basic.SuperString;
   import tv.freewheel.utils.logging.ILogger;
   import tv.freewheel.utils.logging.Log;
   import tv.freewheel.utils.xml.XMLUtils;
   
   public class NonTemporalSlot extends BaseSlot
   {
      
      private static const CLASSNAME:String = "NonTemporalSlot";
      
      private static var logger:ILogger = Log.getLogger("AdManager." + CLASSNAME);
       
      
      public var compatibleDimensions:String;
      
      private var _operationQueue:Array;
      
      public var initialAdOption:int;
      
      public var acceptCompanion:Boolean;
      
      public var _isVisible:Boolean = true;
      
      private var _holdsCompanionAd:Boolean = false;
      
      public function NonTemporalSlot(param1:Contexts)
      {
         this._operationQueue = new Array();
         super(param1);
      }
      
      override public function getTimePositionClass() : String
      {
         return Constants.instance.TIME_POSITION_CLASS_DISPLAY;
      }
      
      override public function stop(param1:Boolean = false) : void
      {
         super.stop(param1);
         this._operationQueue = new Array();
         this.sm.tryChangeStateTo(SlotState.STOPPING);
      }
      
      public function init(param1:String, param2:String, param3:Sprite, param4:uint, param5:uint, param6:int, param7:int, param8:Boolean, param9:int, param10:String, param11:Object, param12:String, param13:String, param14:Array) : void
      {
         var dim:Array;
         var j:int = 0;
         var k:Object = null;
         var slotProfile:String = param1;
         var customId:String = param2;
         var slotBase:Sprite = param3;
         var slotWidth:uint = param4;
         var slotHeight:uint = param5;
         var slotX:int = param6;
         var slotY:int = param7;
         var acceptCompanion:Boolean = param8;
         var initialAdOption:int = param9;
         var adUnit:String = param10;
         var slotParameters:Object = param11;
         var acceptPrimaryContentType:String = param12;
         var acceptContentType:String = param13;
         var compatibleDimensions:Array = param14;
         super._init(slotProfile,customId,slotBase,adUnit,slotParameters,acceptPrimaryContentType,acceptContentType);
         dim = [];
         if(compatibleDimensions is Array)
         {
            j = 0;
            for(; j < compatibleDimensions.length; j++)
            {
               k = compatibleDimensions[j];
               try
               {
                  if(int(k["width"]) > 0 && int(k["height"]) > 0)
                  {
                     dim.push("" + int(k.width) + "," + int(k.height));
                  }
               }
               catch(e:Error)
               {
                  continue;
               }
            }
         }
         if(dim.length)
         {
            this.compatibleDimensions = dim.join("|");
         }
         this.slotBounds = new Rectangle(slotX,slotY,slotWidth,slotHeight);
         this.acceptCompanion = acceptCompanion;
         this.initialAdOption = initialAdOption;
      }
      
      override public function preload() : void
      {
         if(this._isVisible)
         {
            super.preload();
         }
         else
         {
            this._operationQueue.push(this.preload);
         }
      }
      
      public function toXML() : XMLNode
      {
         var _loc2_:XMLNode = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:XMLNode = null;
         var _loc7_:String = null;
         var _loc8_:XMLNode = null;
         var _loc1_:XMLNode = new XMLNode(1,InnerConstants.TAG_NON_TEMPORAL_AD_SLOT_REQUEST);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_COMP_DIM,this.compatibleDimensions,_loc1_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_PROFILE,this.slotProfile,_loc1_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_CUSTOM_ID,this.customId,_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_WIDTH,this.getWidth(),_loc1_,true);
         XMLUtils.addNumberAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_HEIGHT,this.getHeight(),_loc1_,true);
         XMLUtils.addStringAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_AD_UNIT,this.adUnit,_loc1_,true);
         XMLUtils.addBooleanAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_ACCEPT_COMPANION,this.acceptCompanion,_loc1_);
         if(this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_KEEP_ORIGINAL || this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_ONLY)
         {
            XMLUtils.addBooleanAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_NO_INITIAL,true,_loc1_);
         }
         if(this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_ONLY || this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_STAND_ALONE || this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_THEN_STAND_ALONE || this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE || this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE_IF_TEMPORAL)
         {
            XMLUtils.addBooleanAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_FIRST_COMPANION_AS_INITIAL,true,_loc1_);
         }
         if(this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_THEN_STAND_ALONE)
         {
            XMLUtils.addBooleanAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_NO_INITIAL_IF_COMPANION,true,_loc1_);
         }
         if(this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_NO_STAND_ALONE || this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE)
         {
            XMLUtils.addBooleanAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_NO_STANDALONE,true,_loc1_);
         }
         if(this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_NO_STAND_ALONE_IF_TEMPORAL || this.initialAdOption == Constants.instance.SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE_IF_TEMPORAL)
         {
            XMLUtils.addBooleanAttribute(InnerConstants.ATTR_NON_TEMPORAL_AD_SLOT_NO_STANDALONE_IF_TEMPORAL,true,_loc1_);
         }
         if(this.acceptPrimaryContentType.length > 0 || this.acceptContentType.length > 0)
         {
            _loc2_ = new XMLNode(1,InnerConstants.TAG_CONTENT_TYPES);
            _loc3_ = 0;
            while(_loc3_ < this.acceptPrimaryContentType.length)
            {
               _loc5_ = SuperString.trim(this.acceptPrimaryContentType[_loc3_]);
               if(!SuperString.isNull(_loc5_))
               {
                  _loc6_ = new XMLNode(1,InnerConstants.TAG_ACCEPT_PRIMARY_CONTENT_TYPE);
                  XMLUtils.addStringAttribute(InnerConstants.ATTR_ACCEPT_PRIMARY_CONTENT_TYPE_ID,_loc5_,_loc6_,true);
                  _loc2_.appendChild(_loc6_);
               }
               _loc3_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.acceptContentType.length)
            {
               _loc7_ = SuperString.trim(this.acceptContentType[_loc4_]);
               if(!SuperString.isNull(_loc7_))
               {
                  _loc8_ = new XMLNode(1,InnerConstants.TAG_ACCEPT_CONTENT_TYPE);
                  XMLUtils.addStringAttribute(InnerConstants.ATTR_ACCEPT_CONTENT_TYPE_ID,_loc7_,_loc8_,true);
                  _loc2_.appendChild(_loc8_);
               }
               _loc4_++;
            }
            _loc1_.appendChild(_loc2_);
         }
         return _loc1_;
      }
      
      override protected function dispatchSlotEvent(param1:String) : void
      {
         if(!this._holdsCompanionAd)
         {
            super.dispatchSlotEvent(param1);
         }
      }
      
      override protected function initStateMachine() : void
      {
         super.initStateMachine();
         sm.addState(SlotState.STOPPING,{
            "enter":onStoppingEnter,
            "from":[SlotState.PRELOADING,SlotState.PLAYING]
         });
         sm.addState(SlotState.STOPPED,{
            "enter":onStoppedEnter,
            "from":[SlotState.PRELOADING,SlotState.PLAYING,SlotState.STOPPING]
         });
         sm.addState(SlotState.PRELOADING,{
            "enter":onPreloadingEnter,
            "from":SlotState.STOPPED
         });
         sm.addState(SlotState.PLAYING,{
            "enter":onPlayingEnter,
            "from":[SlotState.STOPPED,SlotState.PRELOADING]
         });
         sm.initialState = SlotState.STOPPED;
      }
      
      override public function getBounds() : Rectangle
      {
         return this.slotBounds;
      }
      
      override public function toString() : String
      {
         return "[NonTemporalSlot " + this.id + " " + sm.state + (this._isVisible ? "" : " invisible") + "]";
      }
      
      public function getAcceptCompanion() : Boolean
      {
         return this.acceptCompanion;
      }
      
      override public function getTotalDuration(param1:Boolean = false) : Number
      {
         return -1;
      }
      
      public function playCompanionAdInstance(param1:AdInstance) : void
      {
         this.stop();
         this.adChains.splice(0);
         this.addAdChain(new AdChain(param1));
         this._holdsCompanionAd = true;
         this.play();
      }
      
      override public function getType() : String
      {
         if(this._context.requestContext.pageNonTemporalSlots.indexOf(this) > -1)
         {
            return Constants.instance.SLOT_TYPE_SITESECTION_NONTEMPORAL;
         }
         if(this._context.requestContext.playerNonTemporalSlots.indexOf(this) > -1)
         {
            return Constants.instance.SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL;
         }
         return null;
      }
      
      override public function play(param1:String = null, param2:uint = 0) : void
      {
         if(this._isVisible)
         {
            this.sm.tryChangeStateTo(SlotState.PLAYING);
         }
         else
         {
            this._operationQueue.push(this.play);
         }
      }
      
      override public function getPlayheadTime(param1:Boolean = false) : Number
      {
         return -1;
      }
      
      override public function setVisible(param1:Boolean) : void
      {
         var _loc2_:Function = null;
         if(this._isVisible == param1)
         {
            return;
         }
         this._isVisible = param1;
         if(this._isVisible)
         {
            for each(_loc2_ in this._operationQueue)
            {
               _loc2_.call();
            }
         }
      }
   }
}
