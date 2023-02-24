package tv.freewheel.utils.console
{
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.XMLSocket;
   import flash.utils.setTimeout;
   
   public class ConsoleClient
   {
      
      private static var SOCKET_CONNECTION_MAX_TRY_TIME:uint = 3;
      
      private static var singleton:ConsoleClient;
      
      private static var PROCESS_OUTGOING_MESSAGE_QUEUE_INTERVAL:uint = 1000;
      
      private static var SOCKET_SERVER_PORT:uint = 4524;
      
      private static var SOCKET_SERVER_HOST:String = "localhost";
      
      private static var SOCKET_CONNECTION_TRY_INTERVAL:uint = 3000;
       
      
      private var location:String;
      
      private var outgoingMessageQueue:Array;
      
      private var socketConnectionTryTime:uint = 0;
      
      private var socket:XMLSocket;
      
      private var pemURL:String;
      
      public function ConsoleClient()
      {
         this.outgoingMessageQueue = [];
         super();
         try
         {
            this.location = String(ExternalInterface.call("function(){ return document.location.toString();}"));
         }
         catch(e:Error)
         {
            this.location = "Unknown";
         }
         this.socket = new XMLSocket();
         this.socket.addEventListener(Event.CONNECT,this.onSocketConnect);
         this.socket.addEventListener(Event.CLOSE,this.onSocketClose);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketIoError);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         this.socket.addEventListener(DataEvent.DATA,this.onDataEvent);
         this.connectSocket();
      }
      
      public static function getInstance() : ConsoleClient
      {
         if(singleton == null)
         {
            singleton = new ConsoleClient();
         }
         return singleton;
      }
      
      private function enOutgoingMessageQueue(param1:String) : void
      {
         this.outgoingMessageQueue.push(param1);
      }
      
      private function onSocketSecurityError(param1:SecurityErrorEvent) : void
      {
      }
      
      private function connectSocket() : void
      {
         if(!this.socketConnectionTryTime)
         {
            trace("--FreeWheel-- Debug Console is connecting to " + SOCKET_SERVER_HOST + ":" + SOCKET_SERVER_PORT);
         }
         ++this.socketConnectionTryTime;
         this.socket.connect(SOCKET_SERVER_HOST,SOCKET_SERVER_PORT);
      }
      
      public function writeLog(param1:String) : void
      {
         this.sendLogMessage(param1);
      }
      
      private function onSocketClose(param1:Event) : void
      {
         trace("--FreeWheel-- Debug Console socket closed");
      }
      
      private function onSocketData(param1:ProgressEvent) : void
      {
      }
      
      private function sendLogMessage(param1:String) : void
      {
         this.enOutgoingMessageQueue(ConsoleMessageHelper.createLogMessage(this.location,param1));
      }
      
      internal function sendValidationMessage(param1:String) : void
      {
         this.enOutgoingMessageQueue(ConsoleMessageHelper.createValidationMessage(this.location,param1));
      }
      
      private function onSocketIoError(param1:IOErrorEvent) : void
      {
         this.retryConnectSocket();
      }
      
      private function onDataEvent(param1:DataEvent) : void
      {
         var _loc2_:XML = new XML(param1.data);
         if(_loc2_.name() == "pemURL")
         {
            this.pemURL = _loc2_.toString();
         }
         this.sendLogMessage("onDataReceived, pemURL: " + this.pemURL);
      }
      
      private function processOutgoingMessageQueue() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = null;
         if(!this.socket.connected)
         {
            return;
         }
         while(this.outgoingMessageQueue.length > 0)
         {
            _loc1_ = this.outgoingMessageQueue.shift();
            _loc2_ = "<data><![CDATA[" + _loc1_.replace(/]]>/g,"]]>]]<![CDATA[>") + "]]></data>";
            this.socket.send(_loc2_);
         }
      }
      
      private function onSocketConnect(param1:Event) : void
      {
         this.processOutgoingMessageQueueAtInterval();
      }
      
      private function retryConnectSocket() : void
      {
         if(!this.socket.connected && this.socketConnectionTryTime <= SOCKET_CONNECTION_MAX_TRY_TIME)
         {
            setTimeout(this.connectSocket,SOCKET_CONNECTION_TRY_INTERVAL);
         }
         else
         {
            trace("--FreeWheel-- Debug Console aborted connecting after max trial of " + SOCKET_CONNECTION_MAX_TRY_TIME);
         }
      }
      
      private function processOutgoingMessageQueueAtInterval() : void
      {
         this.processOutgoingMessageQueue();
         setTimeout(this.processOutgoingMessageQueueAtInterval,PROCESS_OUTGOING_MESSAGE_QUEUE_INTERVAL);
      }
   }
}
