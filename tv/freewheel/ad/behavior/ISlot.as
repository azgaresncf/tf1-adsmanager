package tv.freewheel.ad.behavior
{
   import flash.display.Sprite;
   
   public interface ISlot
   {
       
      
      function getTotalDuration(param1:Boolean = false) : Number;
      
      function getEmbeddedAdsDuration() : Number;
      
      function pause(param1:Boolean = true) : void;
      
      function getBase() : Sprite;
      
      function preload() : void;
      
      function getTimePosition() : Number;
      
      function getEventCallbackURLs() : Array;
      
      function getWidth() : uint;
      
      function stop(param1:Boolean = false) : void;
      
      function hasCompanion() : Boolean;
      
      function getTimePositionClass() : String;
      
      function getAcceptance() : int;
      
      function skipCurrentAd() : void;
      
      function isActive() : Boolean;
      
      function getParameterObject(param1:String) : Object;
      
      function getBytesLoaded(param1:Boolean = false) : int;
      
      function getEndTimePosition() : Number;
      
      function getHeight() : uint;
      
      function getPhysicalLocation() : String;
      
      function getAdInstances(param1:Boolean = true) : Array;
      
      function setParameter(param1:String, param2:String) : void;
      
      function getCustomId() : String;
      
      function setBase(param1:Sprite) : void;
      
      function getType() : String;
      
      function getParameter(param1:String) : String;
      
      function play(param1:String = null, param2:uint = 0) : void;
      
      function getAdCount() : uint;
      
      function getPlayheadTime(param1:Boolean = false) : Number;
      
      function playCompanion() : void;
      
      function getTotalBytes(param1:Boolean = false) : int;
      
      function setBounds(param1:int, param2:int, param3:uint, param4:uint) : void;
      
      function setVisible(param1:Boolean) : void;
   }
}
