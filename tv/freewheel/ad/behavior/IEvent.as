package tv.freewheel.ad.behavior
{
   public interface IEvent
   {
       
      
      function get subType() : String;
      
      function get details() : Object;
      
      function get success() : Boolean;
      
      function get level() : int;
      
      function get message() : String;
      
      function get videoPlayStatus() : int;
      
      function get adReferenceId() : String;
      
      function get domain() : String;
      
      function get code() : int;
      
      function get serverMessages() : Array;
      
      function get creativeId() : int;
      
      function get adPause() : Boolean;
      
      function get moduleName() : String;
      
      function get adInstance() : Object;
      
      function get slotCustomId() : String;
      
      function get type() : String;
      
      function get videoPause() : Boolean;
      
      function get adId() : int;
   }
}
