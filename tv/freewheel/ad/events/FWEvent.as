package tv.freewheel.ad.events
{
   import flash.events.Event;
   import tv.freewheel.ad.behavior.IEvent;
   
   public class FWEvent extends Event implements IEvent
   {
       
      
      private var _details:Object = null;
      
      private var _level:int = 0;
      
      private var _referenceId:String = null;
      
      private var _moduleName:String = "";
      
      private var _success:Boolean = true;
      
      private var _message:String = "";
      
      private var _creativeId:int = 0;
      
      private var _code:int = 0;
      
      private var _serverMessages:Array = null;
      
      private var _adPause:Boolean = false;
      
      private var _videoPause:Boolean = false;
      
      private var _subType:String = null;
      
      private var _videoPlayStatus:int = 0;
      
      private var _domain:String = null;
      
      private var _slotCustomId:String = null;
      
      private var _adInstance:Object = null;
      
      private var _adId:int = 0;
      
      public function FWEvent(param1:String, param2:String = null, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false, param6:Object = null, param7:int = 0, param8:int = 0, param9:String = "", param10:Array = null, param11:String = null, param12:Boolean = false, param13:Boolean = false, param14:String = null, param15:int = 0, param16:int = 0, param17:String = null, param18:String = null, param19:Object = null)
      {
         super(param1,param12,param13);
         this._slotCustomId = param2;
         this._success = param3;
         this._code = param7;
         this._level = param8;
         this._message = param9;
         this._serverMessages = param10;
         this._adPause = param4;
         this._videoPause = param5;
         this._subType = param14;
         this._details = param6;
         this._domain = param11;
         this._adId = param15;
         this._creativeId = param16;
         this._moduleName = param17;
         this._referenceId = param18;
         this._adInstance = param19;
      }
      
      public function set creativeId(param1:int) : void
      {
         this._creativeId = param1;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set success(param1:Boolean) : void
      {
         this._success = param1;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get slotCustomId() : String
      {
         return this._slotCustomId;
      }
      
      public function get adPause() : Boolean
      {
         return this._adPause;
      }
      
      public function set slotCustomId(param1:String) : void
      {
         this._slotCustomId = param1;
      }
      
      public function set message(param1:String) : void
      {
         this._message = param1;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function set domain(param1:String) : void
      {
         this._domain = param1;
      }
      
      public function get success() : Boolean
      {
         return this._success;
      }
      
      public function get adId() : int
      {
         return this._adId;
      }
      
      public function get subType() : String
      {
         return this._subType;
      }
      
      public function get adReferenceId() : String
      {
         return this._referenceId;
      }
      
      public function set adPause(param1:Boolean) : void
      {
         this._adPause = param1;
      }
      
      public function set moduleName(param1:String) : void
      {
         this._moduleName = param1;
      }
      
      public function get serverMessages() : Array
      {
         return this._serverMessages;
      }
      
      public function get videoPlayStatus() : int
      {
         return this._videoPlayStatus;
      }
      
      public function set details(param1:Object) : void
      {
         this._details = param1;
      }
      
      public function dispose() : void
      {
         this._serverMessages = null;
      }
      
      public function get videoPause() : Boolean
      {
         return this._videoPause;
      }
      
      public function set adId(param1:int) : void
      {
         this._adId = param1;
      }
      
      public function set subType(param1:String) : void
      {
         this._subType = param1;
      }
      
      public function get moduleName() : String
      {
         return this._moduleName;
      }
      
      public function get details() : Object
      {
         return this._details;
      }
      
      public function get domain() : String
      {
         return this._domain;
      }
      
      public function get creativeId() : int
      {
         return this._creativeId;
      }
      
      public function get adInstance() : Object
      {
         return this._adInstance;
      }
      
      public function set serverMessages(param1:Array) : void
      {
         this._serverMessages = param1;
      }
      
      public function set code(param1:int) : void
      {
         this._code = param1;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function set videoPlayStatus(param1:int) : void
      {
         this._videoPlayStatus = param1;
      }
      
      public function set videoPause(param1:Boolean) : void
      {
         this._videoPause = param1;
      }
   }
}
