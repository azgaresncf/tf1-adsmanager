package tv.freewheel.utils.logging
{
   import tv.freewheel.utils.logging.errors.InvalidCategoryError;
   
   public class Log
   {
      
      private static var _targets:Array = [];
      
      private static var _loggers:Array;
      
      private static var NONE:int = int.MAX_VALUE;
      
      private static var _targetLevel:int = NONE;
       
      
      public function Log()
      {
         super();
      }
      
      public static function isDebug() : Boolean
      {
         return _targetLevel <= LogEventLevel.DEBUG ? true : false;
      }
      
      public static function flush() : void
      {
         _loggers = [];
         _targets = [];
         _targetLevel = NONE;
      }
      
      private static function checkCategory(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 == null || param1.length == 0)
         {
            throw new InvalidCategoryError("Categories must be at least one character in length.");
         }
         if(hasIllegalCharacters(param1) || param1.indexOf("*") != -1)
         {
            throw new InvalidCategoryError("Categories can not contain any of the following characters: []`~,!@#$%*^&()]{}+=|\';?><./\"");
         }
      }
      
      public static function getLogger(param1:String) : ILogger
      {
         var _loc3_:ILoggingTarget = null;
         checkCategory(param1);
         if(!_loggers)
         {
            _loggers = [];
         }
         var _loc2_:ILogger = _loggers[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new LogLogger(param1);
            _loggers[param1] = _loc2_;
         }
         var _loc4_:int = 0;
         while(_loc4_ < _targets.length)
         {
            _loc3_ = ILoggingTarget(_targets[_loc4_]);
            if(categoryMatchInFilterList(param1,_loc3_.filters))
            {
               _loc3_.addLogger(_loc2_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function categoryMatchInFilterList(param1:String, param2:Array) : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:Boolean = false;
         var _loc5_:int = -1;
         var _loc6_:uint = 0;
         while(_loc6_ < param2.length)
         {
            if((_loc5_ = (_loc4_ = String(param2[_loc6_])).indexOf("*")) == 0)
            {
               return true;
            }
            _loc5_ = _loc5_ < 0 ? (_loc5_ = param1.length) : _loc5_ - 1;
            if(param1.substring(0,_loc5_) == _loc4_.substring(0,_loc5_))
            {
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      public static function addTarget(param1:ILoggingTarget) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ILogger = null;
         var _loc4_:String = null;
         if(param1)
         {
            _loc2_ = param1.filters;
            for(_loc4_ in _loggers)
            {
               if(categoryMatchInFilterList(_loc4_,_loc2_))
               {
                  param1.addLogger(ILogger(_loggers[_loc4_]));
               }
            }
            _targets.push(param1);
            if(_targetLevel == NONE)
            {
               _targetLevel = param1.level;
            }
            else if(param1.level < _targetLevel)
            {
               _targetLevel = param1.level;
            }
            return;
         }
         throw new ArgumentError("Invalid target specified.");
      }
      
      public static function hasIllegalCharacters(param1:String) : Boolean
      {
         return param1.search(/[\[\]\~\$\^\&\\(\)\{\}\+\?\/=`!@#%,:;'"<>\s]/) != -1;
      }
      
      public static function removeTarget(param1:ILoggingTarget) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ILogger = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param1)
         {
            _loc2_ = param1.filters;
            for(_loc4_ in _loggers)
            {
               if(categoryMatchInFilterList(_loc4_,_loc2_))
               {
                  param1.removeLogger(ILogger(_loggers[_loc4_]));
               }
            }
            _loc5_ = 0;
            while(_loc5_ < _targets.length)
            {
               if(param1 == _targets[_loc5_])
               {
                  _targets.splice(_loc5_,1);
                  _loc5_--;
               }
               _loc5_++;
            }
            resetTargetLevel();
            return;
         }
         throw new ArgumentError("Invalid target specified.");
      }
      
      public static function isWarn() : Boolean
      {
         return _targetLevel <= LogEventLevel.WARN ? true : false;
      }
      
      public static function isFatal() : Boolean
      {
         return _targetLevel <= LogEventLevel.FATAL ? true : false;
      }
      
      private static function resetTargetLevel() : void
      {
         var _loc1_:int = NONE;
         var _loc2_:int = 0;
         while(_loc2_ < _targets.length)
         {
            if(_loc1_ == NONE || _targets[_loc2_].level < _loc1_)
            {
               _loc1_ = int(_targets[_loc2_].level);
            }
            _loc2_++;
         }
         _targetLevel = _loc1_;
      }
      
      public static function isError() : Boolean
      {
         return _targetLevel <= LogEventLevel.ERROR ? true : false;
      }
      
      public static function isInfo() : Boolean
      {
         return _targetLevel <= LogEventLevel.INFO ? true : false;
      }
   }
}
