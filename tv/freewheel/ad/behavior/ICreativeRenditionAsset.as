package tv.freewheel.ad.behavior
{
   public interface ICreativeRenditionAsset
   {
       
      
      function setMimeType(param1:String) : void;
      
      function setContentType(param1:String) : void;
      
      function getContent() : String;
      
      function getMimeType() : String;
      
      function getBytes() : int;
      
      function setContent(param1:String) : void;
      
      function setBytes(param1:int) : void;
      
      function getURL() : String;
      
      function getContentType() : String;
      
      function setURL(param1:String) : void;
   }
}
