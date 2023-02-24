package tv.freewheel.ad.vo.adRenderer
{
   import flash.display.Sprite;
   import flash.xml.XMLNode;
   import tv.freewheel.ad.constant.Constants;
   import tv.freewheel.ad.constant.InnerConstants;
   import tv.freewheel.ad.renderer.DummyRenderer;
   import tv.freewheel.utils.basic.SuperString;
   
   public class AdRendererSet
   {
       
      
      private var completed:Boolean = true;
      
      private var _dummyAdRenderer:AdRenderer;
      
      private var _rendererPathPrefix:String = "";
      
      private var succeeded:Boolean = true;
      
      private var __dummyRenderer:DummyRenderer;
      
      private var _addedAdRenderers:Array;
      
      private var _responseAdRenderers:Array;
      
      public function AdRendererSet()
      {
         super();
         this._addedAdRenderers = new Array();
         this._responseAdRenderers = new Array();
         this._dummyAdRenderer = new AdRenderer(null,"tv.freewheel.ad.renderer.DummyRenderer",null,Constants.instance.FW_CONTENT_TYPE_NULL_RENDERER,null,null,null,this);
      }
      
      public function addAdRenderer(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Boolean = false, param8:String = null) : AdRenderer
      {
         var _loc9_:AdRenderer = new AdRenderer(param1,param2,param3,param4,param5,param6,param8,this);
         if(param7)
         {
            this._addedAdRenderers.unshift(_loc9_);
         }
         else
         {
            this._responseAdRenderers.push(_loc9_);
         }
         return _loc9_;
      }
      
      public function setCompleted(param1:Boolean) : void
      {
         this.completed = param1;
      }
      
      public function reset() : void
      {
         this._responseAdRenderers = new Array();
      }
      
      public function hasRenderersAvailable() : Boolean
      {
         return this.getAdRenderers().length > 0;
      }
      
      public function getCompleted() : Boolean
      {
         return this.completed;
      }
      
      public function findAdRenderer(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String = null, param7:String = null, param8:Sprite = null) : AdRenderer
      {
         var _loc11_:AdRenderer = null;
         var _loc9_:Array = this.getAdRenderers();
         var _loc10_:uint = 0;
         while(_loc10_ < _loc9_.length)
         {
            if((_loc11_ = _loc9_[_loc10_]).checkIsMatched(param1,param2,param3,param4,param5,param6,param7,param8))
            {
               return _loc11_;
            }
            _loc10_++;
         }
         return null;
      }
      
      public function parseXML(param1:XMLNode) : void
      {
         var _loc3_:XMLNode = null;
         var _loc4_:AdRenderer = null;
         var _loc5_:uint = 0;
         var _loc6_:XMLNode = null;
         if(param1.localName != InnerConstants.TAG_RENDERERS)
         {
            throw new Error("AdRendererSet.parseXML(),invalid renderers xml format, expected is adRenderers");
         }
         var _loc2_:uint = 0;
         while(_loc2_ < param1.childNodes.length)
         {
            _loc3_ = param1.childNodes[_loc2_];
            switch(_loc3_.localName)
            {
               case InnerConstants.TAG_RENDERER:
                  _loc4_ = this.addAdRenderer(_loc3_.attributes[InnerConstants.ATTR_RENDERER_URL],_loc3_.attributes[InnerConstants.ATTR_RENDERER_CLASS_NAME],_loc3_.attributes[InnerConstants.ATTR_RENDERER_AD_UNIT],_loc3_.attributes[InnerConstants.ATTR_RENDERER_CONTENT_TYPE],_loc3_.attributes[InnerConstants.ATTR_RENDERER_SLOT_TYPE],_loc3_.attributes[InnerConstants.ATTR_RENDERER_SLOT_SO_AD_UNIT],false,_loc3_.attributes[InnerConstants.ATTR_RENDERER_CREATIVE_API]);
                  _loc5_ = 0;
                  while(_loc5_ < _loc3_.childNodes.length)
                  {
                     if((_loc6_ = _loc3_.childNodes[_loc5_]).localName == InnerConstants.TAG_RENDERER_PARAMETER)
                     {
                        _loc4_.addParameter(_loc6_.attributes[InnerConstants.ATTR_RENDERER_PARAMETER_NAME],_loc6_.attributes[InnerConstants.ATTR_RENDERER_PARAMETER_VALUE]);
                     }
                     _loc5_++;
                  }
                  break;
            }
            _loc2_++;
         }
      }
      
      public function setSucceeded(param1:Boolean) : void
      {
         this.succeeded = param1;
      }
      
      public function dispose() : void
      {
         this._responseAdRenderers = null;
         this._addedAdRenderers = null;
         this._dummyAdRenderer = null;
      }
      
      public function getSucceeded() : Boolean
      {
         return this.succeeded;
      }
      
      public function set rendererPathPrefix(param1:String) : void
      {
         param1 = SuperString.trim(param1);
         if(!SuperString.isNull(param1) && param1.lastIndexOf("/") != param1.length - 1)
         {
            param1 += "/";
         }
         this._rendererPathPrefix = param1;
      }
      
      public function copy(param1:AdRendererSet) : void
      {
         this._rendererPathPrefix = param1._rendererPathPrefix;
         this._addedAdRenderers = param1._addedAdRenderers.slice();
      }
      
      private function getAdRenderers() : Array
      {
         var _loc1_:Array = this._addedAdRenderers.concat(this._responseAdRenderers);
         _loc1_.push(this._dummyAdRenderer);
         return _loc1_;
      }
      
      public function get rendererPathPrefix() : String
      {
         return this._rendererPathPrefix;
      }
   }
}
