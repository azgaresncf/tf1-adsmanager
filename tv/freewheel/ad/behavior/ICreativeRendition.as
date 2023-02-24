package tv.freewheel.ad.behavior
{
   public interface ICreativeRendition
   {
       
      
      function setHeight(param1:uint) : void;
      
      function getAllCreativeRenditionAssets() : Array;
      
      function setWidth(param1:uint) : void;
      
      function setWrapperURL(param1:String) : void;
      
      function getWrapperURL() : String;
      
      function setParameter(param1:String, param2:String) : void;
      
      function setCreativeAPI(param1:String) : void;
      
      function getHeight() : uint;
      
      function getBaseUnit() : String;
      
      function setPreference(param1:int) : void;
      
      function getWidth() : uint;
      
      function setContentType(param1:String) : void;
      
      function setWrapperType(param1:String) : void;
      
      function addCreativeRenditionAsset(param1:String, param2:Boolean = true) : ICreativeRenditionAsset;
      
      function getCreativeRenditionAssets(param1:String, param2:String = "name") : Array;
      
      function getCreativeAPI() : String;
      
      function setDuration(param1:Number) : void;
      
      function getWrapperType() : String;
      
      function getPreference() : int;
      
      function getDuration() : Number;
      
      function getAdUnit() : String;
      
      function getPrimaryCreativeRenditionAsset() : ICreativeRenditionAsset;
      
      function getContentType() : String;
   }
}
