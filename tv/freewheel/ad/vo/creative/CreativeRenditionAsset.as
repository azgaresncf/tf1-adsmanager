package tv.freewheel.ad.vo.creative
{
   import tv.freewheel.ad.behavior.ICreativeRenditionAsset;
   
   public class CreativeRenditionAsset implements ICreativeRenditionAsset
   {
       
      
      public var name:String;
      
      public var mimeType:String;
      
      public var contentType:String;
      
      public var id:Number;
      
      public var bytes:Number;
      
      public var url:String;
      
      public var content:String;
      
      public function CreativeRenditionAsset(param1:Number, param2:String, param3:String, param4:String, param5:String, param6:Number, param7:String)
      {
         super();
         this.id = param1;
         this.contentType = param2;
         this.mimeType = param3;
         this.name = param4;
         this.url = param5;
         this.bytes = param6;
         this.content = param7;
      }
      
      public function getURL() : String
      {
         return this.url;
      }
      
      public function getContent() : String
      {
         return this.content;
      }
      
      public function setMimeType(param1:String) : void
      {
         this.mimeType = param1;
      }
      
      public function getId() : Number
      {
         return this.id;
      }
      
      public function setContentType(param1:String) : void
      {
         this.contentType = param1;
      }
      
      public function get __content() : String
      {
         return this.content;
      }
      
      public function getMimeType() : String
      {
         return this.mimeType;
      }
      
      public function getContentType() : String
      {
         return this.contentType;
      }
      
      public function setBytes(param1:int) : void
      {
         this.bytes = param1;
      }
      
      public function setURL(param1:String) : void
      {
         this.url = param1;
      }
      
      public function get __mimeType() : String
      {
         return this.mimeType;
      }
      
      public function getBytes() : int
      {
         return this.bytes;
      }
      
      public function get __contentType() : String
      {
         return this.contentType;
      }
      
      public function setContent(param1:String) : void
      {
         this.content = param1;
      }
   }
}
