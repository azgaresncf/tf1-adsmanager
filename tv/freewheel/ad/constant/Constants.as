package tv.freewheel.ad.constant
{
   import tv.freewheel.ad.behavior.IConstants;
   
   public class Constants implements IConstants
   {
      
      private static var __constants:Constants;
       
      
      public function Constants()
      {
         super();
      }
      
      public static function get instance() : Constants
      {
         if(!__constants)
         {
            __constants = new Constants();
         }
         return __constants;
      }
      
      public function get CAPABILITY_BYPASS_COMMERCIAL_RATIO_RESTRICTION() : String
      {
         return "bypassCommercialRatioRestriction";
      }
      
      public function get FW_ADUNIT_FRONT_BUMPER() : String
      {
         return "_fw_front_bumper";
      }
      
      public function get EVENT_SLOT_ENDED() : String
      {
         return "slotEnded";
      }
      
      public function get PARAM_KEY_ADUNIT_SEQUENCE() : String
      {
         return "_fw_aus";
      }
      
      public function get RENDERER_STATE_STOP_COMPLETE() : uint
      {
         return 107;
      }
      
      public function get ADUNIT_UNKNOWN() : String
      {
         return "unknown";
      }
      
      public function get DEMOGRAPHIC_ID() : String
      {
         return "id";
      }
      
      public function get ADUNIT_OVERLAY() : String
      {
         return "overlay";
      }
      
      public function get RENDERER_EVENT_REWIND() : uint
      {
         return 216;
      }
      
      public function get EVENT_PAUSESTATECHANGE_REQUEST() : String
      {
         return "pauseStateChangeRequest";
      }
      
      public function get CAPABILITY_VIDEO_TRACKING() : String
      {
         return "explicitVideoTracking";
      }
      
      public function get DEMOGRAPHIC_ETHNICITY() : String
      {
         return "ethnicity";
      }
      
      public function get CAPABILITY_SUPPORT_AD_BUNDLE() : String
      {
         return "supportAdBundle";
      }
      
      public function get UNKNOWN() : String
      {
         return this.ADUNIT_UNKNOWN;
      }
      
      public function get EVENTCALLBACK_MEASUREMENT() : String
      {
         return "concreteEvent";
      }
      
      public function get OVERLAY() : String
      {
         return this.ADUNIT_OVERLAY;
      }
      
      public function get EVENTCALLBACK_TYPE_ERROR() : String
      {
         return "ERROR";
      }
      
      public function get SLOT_OPTION_INITIAL_AD_KEEP_ORIGINAL() : uint
      {
         return 1;
      }
      
      public function get EVENT_REQUEST_COMPLETE() : String
      {
         return "requestComplete";
      }
      
      public function get REQUEST_MODE_LIVE() : String
      {
         return "LIVE";
      }
      
      public function get EVENTCALLBACK_REWIND() : String
      {
         return "_rewind";
      }
      
      public function get CAPABILITY_STATUS_UNSET() : int
      {
         return -1;
      }
      
      public function get RENDERER_STATE_STOP_PENDING() : uint
      {
         return 106;
      }
      
      public function get CREATIVE_API_CLICKTAG() : String
      {
         return "clickTag";
      }
      
      public function get EVENT_VIDEO_PLAY_STATUS_CHANGED() : String
      {
         return "videoPlayStatusChanged";
      }
      
      public function get SLOT_TYPE_SITESECTION_NONTEMPORAL() : String
      {
         return "siteSectionNonTemporal";
      }
      
      public function get EVENTCALLBACK_ERROR_NULL_ASSET() : String
      {
         return "_e_null-asset";
      }
      
      public function get EVENTCALLBACK_THIRDQUARTILE() : String
      {
         return "thirdQuartile";
      }
      
      public function get RENDERER_EVENT_COMPLETE() : uint
      {
         return 209;
      }
      
      public function get ERROR_INVALID_SLOT() : int
      {
         return 412;
      }
      
      public function get ERROR_ADINSTANCE_UNAVAILABLE() : int
      {
         return 413;
      }
      
      public function get EVENTCALLBACK_ERROR_SLOT_UNAVAILABLE() : String
      {
         return "_e_slot-unavail";
      }
      
      public function get RENDERER_EVENT_PACKAGE_START() : uint
      {
         return 220;
      }
      
      public function get EVENT_REQUEST_INITIATED() : String
      {
         return "requestInitiated";
      }
      
      public function get RENDERER_CAPABILITY_ADVOLUMECHANGE() : uint
      {
         return 224;
      }
      
      public function get DATA_EXCLUDED_INDUSTRIES() : String
      {
         return "_fw_excluded_industries";
      }
      
      public function get CAPABILITY_NULL_CREATIVE() : String
      {
         return "supportNullCreative";
      }
      
      public function get RENDERER_CAPABILITY_ADPLAYBACKTRACK() : uint
      {
         return 502;
      }
      
      public function get EVENTCALLBACK_FIRSTQUARTILE() : String
      {
         return "firstQuartile";
      }
      
      public function get RENDERER_CAPABILITY_VIDEOSTATUSCONTROL() : uint
      {
         return 501;
      }
      
      public function get EVENTCALLBACK_CLICKTRACKING() : String
      {
         return "e";
      }
      
      public function get TRANSLATOR_STATE_PRELOAD_COMPLETE() : uint
      {
         return this.RENDERER_STATE_PRELOAD_COMPLETE;
      }
      
      public function get RENDERER_EVENT_QUARTILE() : uint
      {
         return this.RENDERER_CAPABILITY_QUARTILE;
      }
      
      public function get CAPABILITY_SYNC_MULTI_REQUESTS() : String
      {
         return "synchronizeMultipleRequests";
      }
      
      public function get SLOT_TYPE_VIDEOPLAYER_NONTEMPORAL() : String
      {
         return "videoPlayerNonTemporal";
      }
      
      public function get LEVEL_INFO() : uint
      {
         return 1;
      }
      
      public function get DEMOGRAPHIC_RELATIONSHIP() : String
      {
         return "relationship";
      }
      
      public function get EVENTCALLBACK_TYPE_IMPRESSION() : String
      {
         return "IMPRESSION";
      }
      
      public function get CAPABILITY_ADUNIT_IN_MULTIPLE_SLOTS() : String
      {
         return "supportsAdUnitInMultipleSlots";
      }
      
      public function get TRANSLATOR_STATE_TRANSLATING() : uint
      {
         return this.RENDERER_STATE_PLAYING;
      }
      
      public function get PARAMETER_RENDERER() : uint
      {
         return 1;
      }
      
      public function get DEMOGRAPHIC_GENDER() : String
      {
         return "gender";
      }
      
      public function get RENDERER_EVENT_START() : uint
      {
         return this.RENDERER_EVENT_PACKAGE_START;
      }
      
      public function get EVENT_SLOT_STARTED() : String
      {
         return "slotStarted";
      }
      
      public function get EVENTCALLBACK_COMPLETE() : String
      {
         return "complete";
      }
      
      public function get RENDERER_EVENT_ACCEPTINVITATION() : uint
      {
         return 217;
      }
      
      public function get CAPABILITY_SECURE_MODE() : String
      {
         return "requiresSecureMode";
      }
      
      public function get SLOT_ACCEPTANCE_ACCEPTED() : int
      {
         return 1;
      }
      
      public function get ERROR_NULL_ASSET() : int
      {
         return 411;
      }
      
      public function get EVENT_DEBUG_INITIALIZATION() : String
      {
         return "debugInitialization";
      }
      
      public function get ID_TYPE_FW() : uint
      {
         return 1;
      }
      
      public function get CAPABILITY_CHECK_TARGETING() : String
      {
         return "checkTargeting";
      }
      
      public function get ID_TYPE_FWGROUP() : uint
      {
         return 2;
      }
      
      public function get EVENTCALLBACK_ERROR_EXTERNAL_INTERFACE() : String
      {
         return "_e_external-interface";
      }
      
      public function get EVENT_CUSTOM() : String
      {
         return "custom";
      }
      
      public function get REQUEST_MODE_ON_DEMAND() : String
      {
         return "ON_DEMAND";
      }
      
      public function get RENDERER_EVENT_MEASUREMENT() : uint
      {
         return 228;
      }
      
      public function get ERROR_SLOT_UNAVAILABLE() : int
      {
         return 417;
      }
      
      public function get RENDERER_EVENT_IMPRESSION() : uint
      {
         return 201;
      }
      
      public function get ERROR_UNKNOWN() : int
      {
         return 499;
      }
      
      public function get EVENT_ALLOWED_DOMAIN_REQUEST() : String
      {
         return "allowedDomainRequest";
      }
      
      public function get PARAMETER_SLOT() : uint
      {
         return 4;
      }
      
      public function get EVENT_RENDERER() : String
      {
         return "renderer";
      }
      
      public function get CAPABILITY_STATUS_OFF() : int
      {
         return 0;
      }
      
      public function get SLOT_OPTION_INITIAL_AD_NO_STAND_ALONE() : uint
      {
         return 6;
      }
      
      public function get CREATIVE_API_VPAID() : String
      {
         return "VPAID";
      }
      
      public function get AD_COMPLETED() : uint
      {
         return 1;
      }
      
      public function get SLOT_LOCATION_EXTERNAL() : String
      {
         return "external";
      }
      
      public function get EVENT_REFRESHED() : String
      {
         return "refreshed";
      }
      
      public function get PARAMETER_GLOBAL() : uint
      {
         return 2;
      }
      
      public function get POSTROLL() : String
      {
         return this.ADUNIT_POSTROLL;
      }
      
      public function get VIDEO_STATUS_PLAYING() : uint
      {
         return 1;
      }
      
      public function get CAPABILITY_MULTIPLE_CREATIVE_RENDITIONS() : String
      {
         return "expectMultipleCreativeRenditions";
      }
      
      public function get SLOT_ACCEPTANCE_GENERATED() : int
      {
         return 2;
      }
      
      public function get EVENTCALLBACK_TYPE_GENERIC() : String
      {
         return "GENERIC";
      }
      
      public function get DEMOGRAPHIC_AGE() : String
      {
         return "age";
      }
      
      public function get CREATIVE_API_YOUTUBE() : String
      {
         return "youTube";
      }
      
      public function get VIDEO_STATUS_PAUSED() : uint
      {
         return 2;
      }
      
      public function get ERROR_MISSING_PARAMETER() : int
      {
         return 408;
      }
      
      public function get SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE_IF_TEMPORAL() : uint
      {
         return 8;
      }
      
      public function get VIDEO_STATUS_UNKNOWN() : uint
      {
         return 0;
      }
      
      public function get CAPABILITY_REQUIRES_VIDEO_CALLBACK_URL() : String
      {
         return "requiresVideoCallbackUrl";
      }
      
      public function get DEMOGRAPHIC_GROUP() : String
      {
         return "group";
      }
      
      public function get RENDERER_EVENT_THIRDQUARTILE() : uint
      {
         return 207;
      }
      
      public function get TRANSLATOR_STATE_PRELOADING() : uint
      {
         return this.RENDERER_STATE_PRELOADING;
      }
      
      public function get LEVEL_ERROR() : uint
      {
         return 3;
      }
      
      public function get CAPABILITY_RECORD_VIDEO_VIEW() : String
      {
         return "recordVideoView";
      }
      
      public function get SLOT_OPTION_INITIAL_AD_NO_STAND_ALONE_IF_TEMPORAL() : uint
      {
         return 7;
      }
      
      public function get SLOT_OPTION_INITIAL_AD_STAND_ALONE() : uint
      {
         return 0;
      }
      
      public function get ERROR_EXTERNAL_INTERFACE() : int
      {
         return 409;
      }
      
      public function get EVENTCALLBACK_ERROR_UNKNOWN() : String
      {
         return "_e_unknown";
      }
      
      public function get ADUNIT_PREROLL() : String
      {
         return "preroll";
      }
      
      public function get VIDEO_ASSET_AUTO_PLAY_TYPE_UNATTENDED() : uint
      {
         return 1;
      }
      
      public function get SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_THEN_STAND_ALONE() : uint
      {
         return 4;
      }
      
      public function get TIME_POSITION_CLASS_OVERLAY() : String
      {
         return "OVERLAY";
      }
      
      public function get TRANSLATOR_STATE_FAIL() : uint
      {
         return this.RENDERER_STATE_FAIL;
      }
      
      public function get ERROR_PARSE_ERROR() : int
      {
         return 414;
      }
      
      public function get RENDERER_STATE_PLAY_PENDING() : uint
      {
         return 104;
      }
      
      public function get ERROR_NOERROR() : int
      {
         return 401;
      }
      
      public function get LEVEL_QUIET() : uint
      {
         return 4;
      }
      
      public function get CAPABILITY_FALLBACK_ADS() : String
      {
         return "supportsFallbackAds";
      }
      
      public function get PREROLL() : String
      {
         return this.ADUNIT_PREROLL;
      }
      
      public function get VIDEO_STATUS_COMPLETED() : uint
      {
         return 4;
      }
      
      public function get CREATIVE_API_NOAPI() : String
      {
         return "None";
      }
      
      public function get TRANSLATOR_STATE_STOP_PENDING() : uint
      {
         return this.RENDERER_STATE_STOP_PENDING;
      }
      
      public function get CAPABILITY_RESPONSE_CONTINUATION() : String
      {
         return "responseContinuation";
      }
      
      public function get VIDEO_ASSET_AUTO_PLAY_TYPE_ATTENDED() : uint
      {
         return 0;
      }
      
      public function get RENDERER_EVENT_FIRSTQUARTILE() : uint
      {
         return 206;
      }
      
      public function get LEVEL_DEBUG() : uint
      {
         return 0;
      }
      
      public function get EVENTCALLBACK_MUTE() : String
      {
         return "_mute";
      }
      
      public function get LEVEL_WARNING() : uint
      {
         return 2;
      }
      
      public function get CREATIVE_API_FWOVERLAY() : String
      {
         return "fwoverlay";
      }
      
      public function get ADUNIT_SUBSESSION_PREROLL() : String
      {
         return this.ADUNIT_STREAM_PREROLL;
      }
      
      public function get EVENTCALLBACK_ERROR_MISSING_PARAMETER() : String
      {
         return "_e_missing-param";
      }
      
      public function get RENDERER_EVENT_MUTE() : uint
      {
         return 210;
      }
      
      public function get PARAM_KEY_DESIRED_BITRATE() : String
      {
         return "desiredBitrate";
      }
      
      public function get RENDERER_EVENT_MINIMIZE() : uint
      {
         return 219;
      }
      
      public function get RENDERER_STATE_PRELOADING() : uint
      {
         return 102;
      }
      
      public function get CAPABILITY_AUTO_EVENT_TRACKING() : String
      {
         return "autoEventTracking";
      }
      
      public function get TIME_POSITION_CLASS_DISPLAY() : String
      {
         return "DISPLAY";
      }
      
      public function get EVENTCALLBACK_ERROR_PARSE_ERROR() : String
      {
         return "_e_parse";
      }
      
      public function get ERROR_UNMATCHED_SLOT_SIZE() : int
      {
         return 416;
      }
      
      public function get RENDERER_EVENT_CLICK() : uint
      {
         return 203;
      }
      
      public function get ERROR_TIMEOUT() : int
      {
         return 406;
      }
      
      public function get DATA_AD_CUSTOM_ID() : String
      {
         return "_fw_ad_custom_id";
      }
      
      public function get EVENT_PLAYING_SLOT_RESIZED() : String
      {
         return "playingSlotResized";
      }
      
      public function get RENDERER_EVENT_EXPAND() : uint
      {
         return 213;
      }
      
      public function get SLOT_TYPE_TEMPORAL() : String
      {
         return "temporal";
      }
      
      public function get CAPABILITY_RESET_EXCLUSIVITY() : String
      {
         return "resetExclusivity";
      }
      
      public function get FW_CONTENT_TYPE_NULL_RENDERER() : String
      {
         return "null/null";
      }
      
      public function get EVENTCALLBACK_ERROR_3P_COMPONENT() : String
      {
         return "_e_3p-comp";
      }
      
      public function get EVENTCALLBACK_EXPAND() : String
      {
         return "_expand";
      }
      
      public function get EVENTCALLBACK_MINIMIZE() : String
      {
         return "_minimize";
      }
      
      public function get EVENTCALLBACK_AD_END() : String
      {
         return "adEnd";
      }
      
      public function get SLOT_ACCEPTANCE_UNKNOWN() : int
      {
         return 0;
      }
      
      public function get EVENTCALLBACK_ACCEPTINVITATION() : String
      {
         return "_accept-invitation";
      }
      
      public function get VIDEO_ASSET_DURATION_TYPE_VARIABLE() : String
      {
         return "VARIABLE";
      }
      
      public function get ADUNIT_POSTROLL() : String
      {
         return "postroll";
      }
      
      public function get TRANSLATOR_STATE_TRANSLATE_COMPLETE() : uint
      {
         return this.RENDERER_STATE_STOP_COMPLETE;
      }
      
      public function get CAPABILITY_PACKAGE_HANDOFF() : String
      {
         return "supportsPackageHandoff";
      }
      
      public function get EVENTCALLBACK_SLOT_START() : String
      {
         return "slotImpression";
      }
      
      public function get VIDEO_ASSET_DURATION_TYPE_EXACT() : String
      {
         return "EXACT";
      }
      
      public function get TRANSLATOR_STATE_INITIALIZE_COMPLETE() : uint
      {
         return this.RENDERER_STATE_INITIALIZE_COMPLETE;
      }
      
      public function get EVENTCALLBACK_PAUSE() : String
      {
         return "_pause";
      }
      
      public function get RENDERER_STATE_INITIALIZING() : uint
      {
         return 1;
      }
      
      public function get CAPABILITY_SUPPORT_SLOT_INFO() : String
      {
         return "supportSlotInfo";
      }
      
      public function get EVENTCALLBACK_CLOSE() : String
      {
         return "_close";
      }
      
      public function get RENDERER_EVENT_PACKAGE_END() : uint
      {
         return 222;
      }
      
      public function get RENDERER_EVENT_PAUSE() : uint
      {
         return 214;
      }
      
      public function get RENDERER_EVENT_CLOSE() : uint
      {
         return 218;
      }
      
      public function get RENDERER_EVENT_ERROR() : uint
      {
         return 227;
      }
      
      public function get SLOT_LOCATION_PLAYER() : String
      {
         return "player";
      }
      
      public function get CAPABILITY_FALLBACK_UNKNOWN_SS() : String
      {
         return "fallbackUnknownSiteSection";
      }
      
      public function get RENDERER_EVENT_ADPLAYBACKTRACK() : uint
      {
         return this.RENDERER_CAPABILITY_ADPLAYBACKTRACK;
      }
      
      public function get PARAM_KEY_SLOT_CONFIGURATION() : String
      {
         return "_fw_asset_type";
      }
      
      public function get EVENTCALLBACK_ERROR_IO() : String
      {
         return "_e_io";
      }
      
      public function get EVENTCALLBACK_ERROR_TIMEOUT() : String
      {
         return "_e_timeout";
      }
      
      public function get EVENTCALLBACK_SLOT_END() : String
      {
         return "slotEnd";
      }
      
      public function get EVENTCALLBACK_ERROR_UNMATCHED_SLOT_SIZE() : String
      {
         return "_e_slot-size-unmatch";
      }
      
      public function get CAPABILITY_SLOT_CALLBACK() : String
      {
         return "supportsSlotCallback";
      }
      
      public function get TIME_POSITION_CLASS_POSTROLL() : String
      {
         return "POSTROLL";
      }
      
      public function get ADUNIT_MIDROLL() : String
      {
         return "midroll";
      }
      
      public function get EVENT_NOTIFICATION() : String
      {
         return "notification";
      }
      
      public function get ERROR_3P_COMPONENT() : int
      {
         return 410;
      }
      
      public function get CAPABILITY_SYNC_SITESECTION_SLOTS() : String
      {
         return "synchronizeSiteSectionSlots";
      }
      
      public function get CREATIVE_API_SCRIPPS() : String
      {
         return "scripps";
      }
      
      public function get EVENTCALLBACK_TYPE_STANDARD() : String
      {
         return "STANDARD";
      }
      
      public function get DEMOGRAPHIC_INTEREST() : String
      {
         return "interest";
      }
      
      public function get MIDROLL() : String
      {
         return this.ADUNIT_MIDROLL;
      }
      
      public function get SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_STAND_ALONE() : uint
      {
         return 3;
      }
      
      public function get CAPABILITY_SLOT_TEMPLATE() : String
      {
         return "supportsSlotTemplate";
      }
      
      public function get TIME_POSITION_CLASS_PAUSE_MIDROLL() : String
      {
         return "PAUSE_MIDROLL";
      }
      
      public function get RENDERER_EVENT_RESELLER_NO_AD() : uint
      {
         return 227;
      }
      
      public function get ERROR_NETWORK() : int
      {
         return 402;
      }
      
      public function get SLOT_TYPE_REDIRECT() : String
      {
         return "redirect";
      }
      
      public function get TIME_POSITION_CLASS_PREROLL() : String
      {
         return "PREROLL";
      }
      
      public function get RENDERER_EVENT_FAIL() : uint
      {
         return 226;
      }
      
      public function get VIDEO_STATUS_STOPPED() : uint
      {
         return 3;
      }
      
      public function get PARAMETER_PROFILE() : uint
      {
         return 3;
      }
      
      public function get ADUNIT_SUBSESSION_POSTROLL() : String
      {
         return this.ADUNIT_STREAM_POSTROLL;
      }
      
      public function get RENDERER_EVENT_COLLAPSE() : uint
      {
         return 212;
      }
      
      public function get SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_ONLY() : uint
      {
         return 2;
      }
      
      public function get ADUNIT_STREAM_PREROLL() : String
      {
         return "stream_preroll";
      }
      
      public function get RENDERER_EVENT_CUSTOM() : uint
      {
         return 221;
      }
      
      public function get ADUNIT_STREAM_POSTROLL() : String
      {
         return "stream_postroll";
      }
      
      public function get CAPABILITY_STATUS_ON() : int
      {
         return 1;
      }
      
      public function get ERROR_INVALID_VALUE() : int
      {
         return 407;
      }
      
      public function get CAPABILITY_FALLBACK_UNKNOWN_ASSET() : String
      {
         return "fallbackUnknownAsset";
      }
      
      public function get PARAM_KEY_FLASH_FRAME_RATE() : String
      {
         return "flashFrameRate";
      }
      
      public function get ERROR_NO_AD_AVAILABLE() : int
      {
         return 404;
      }
      
      public function get ERROR_IO() : int
      {
         return 405;
      }
      
      public function get CAPABILITY_DISPLAY_REFRESH() : String
      {
         return "refreshDisplaySlots";
      }
      
      public function get ID_TYPE_CUSTOM() : uint
      {
         return 0;
      }
      
      public function get DATA_AD_PRICE() : String
      {
         return "_fw_ad_price";
      }
      
      public function get DEMOGRAPHIC_LANGUAGE() : String
      {
         return "language";
      }
      
      public function get RENDERER_STATE_FAIL() : uint
      {
         return 108;
      }
      
      public function get ADUNIT_PAUSE_MIDROLL() : String
      {
         return "pause_midroll";
      }
      
      public function get EVENTCALLBACK_COLLAPSE() : String
      {
         return "_collapse";
      }
      
      public function get CAPABILITY_CHECK_COMPANION() : String
      {
         return "checkCompanion";
      }
      
      public function get EVENTCALLBACK_ERROR_SECURITY() : String
      {
         return "_e_security";
      }
      
      public function get EVENTCALLBACK_ERROR_UNSUPPORTED_3P_FEATURE() : String
      {
         return "_e_unsupp-3p-feature";
      }
      
      public function get EVENTCALLBACK_ERROR_NETWORK() : String
      {
         return "_e_network";
      }
      
      public function get EVENT_EXTENSION_LOADED() : String
      {
         return "extensionLoaded";
      }
      
      public function get RENDERER_CAPABILITY_QUARTILE() : uint
      {
         return 503;
      }
      
      public function get PARAMETER_CREATIVERENDITION() : uint
      {
         return 6;
      }
      
      public function get EVENTCALLBACK_ERROR_INVALID_VALUE() : String
      {
         return "_e_invalid-value";
      }
      
      public function get EVENTCALLBACK_TYPE_CLICKTRACKING() : String
      {
         return "CLICKTRACKING";
      }
      
      public function get EVENTCALLBACK_TYPE_ACTION() : String
      {
         return "ACTION";
      }
      
      public function get DEMOGRAPHIC_EDUCATION() : String
      {
         return "education";
      }
      
      public function get CAPABILITY_REQUIRES_RENDERER_MANIFEST() : String
      {
         return "requiresRendererManifest";
      }
      
      public function get EVENTCALLBACK_DEFAULTCLICK() : String
      {
         return "defaultClick";
      }
      
      public function get RENDERER_EVENT_MIDPOINT() : uint
      {
         return 208;
      }
      
      public function get EVENTCALLBACK_DEFAULTIMPRESSION() : String
      {
         return "defaultImpression";
      }
      
      public function get PARAMETER_DEFAULT() : uint
      {
         return 0;
      }
      
      public function get EVENTCALLBACK_ERROR_NO_AD_AVAILABLE() : String
      {
         return "_e_no-ad";
      }
      
      public function get EVENTCALLBACK_VIDEO_VIEW() : String
      {
         return "videoView";
      }
      
      public function get RENDERER_EVENT_RESUME() : uint
      {
         return 215;
      }
      
      public function get FW_ADUNIT_END_BUMPER() : String
      {
         return "_fw_end_bumper";
      }
      
      public function get RENDERER_EVENT_UNMUTE() : uint
      {
         return 211;
      }
      
      public function get RENDERER_CAPABILITY_ADSIZECHANGE() : uint
      {
         return 225;
      }
      
      public function get TRANSLATOR_STATE_INITIALIZING() : uint
      {
         return this.RENDERER_STATE_INITIALIZING;
      }
      
      public function get EVENTCALLBACK_TYPE_PACKAGE() : String
      {
         return "PACKAGE";
      }
      
      public function get DEMOGRAPHIC_INCOME() : String
      {
         return "income";
      }
      
      public function get PARAMETER_CREATIVE() : uint
      {
         return 5;
      }
      
      public function get CAPABILITY_SKIP_AD_SELECTION() : String
      {
         return "skipsAdSelection";
      }
      
      public function get EVENTCALLBACK_RESUME() : String
      {
         return "_resume";
      }
      
      public function get EVENTCALLBACK_UNMUTE() : String
      {
         return "_un-mute";
      }
      
      public function get EVENT_SLOT_PRELOADED() : String
      {
         return "slotPreloaded";
      }
      
      public function get ERROR_UNSUPPORTED_3P_FEATURE() : int
      {
         return 415;
      }
      
      public function get ERROR_SECURITY() : int
      {
         return 403;
      }
      
      public function get RENDERER_CAPABILITY_ADPLAYSTATECHANGE() : uint
      {
         return 223;
      }
      
      public function get PARAMETER_OVERRIDE() : uint
      {
         return 7;
      }
      
      public function get RENDERER_STATE_PLAYING() : uint
      {
         return 105;
      }
      
      public function get RENDERER_STATE_INITIALIZE_COMPLETE() : uint
      {
         return 101;
      }
      
      public function get EVENTCALLBACK_MIDPOINT() : String
      {
         return "midPoint";
      }
      
      public function get EVENT_SLOT_PAUSESTATE_CHANGED() : String
      {
         return "pauseStateChanged";
      }
      
      public function get EVENTCALLBACK_TYPE_CLICK() : String
      {
         return "CLICK";
      }
      
      public function get EVENTCALLBACK_RESELLER_NO_AD() : String
      {
         return "resellerNoAd";
      }
      
      public function get RENDERER_STATE_PRELOAD_COMPLETE() : uint
      {
         return 103;
      }
      
      public function get TIME_POSITION_CLASS_MIDROLL() : String
      {
         return "MIDROLL";
      }
      
      public function get EVENTCALLBACK_ERROR_INVALID_SLOT() : String
      {
         return "_e_invalid-slot";
      }
      
      public function get RENDERER_EVENT_IMPRESSION_END() : uint
      {
         return 202;
      }
      
      public function get EVENTCALLBACK_ERROR_ADINSTANCE_UNAVAILABLE() : String
      {
         return "_e_adinst-unavail";
      }
      
      public function get AD_FAILED() : uint
      {
         return 2;
      }
      
      public function get AD_PLAYING() : uint
      {
         return 0;
      }
      
      public function get SLOT_OPTION_INITIAL_AD_FIRST_COMPANION_OR_NO_STAND_ALONE() : uint
      {
         return 5;
      }
      
      public function get TRANSLATOR_STATE_TRANSLATE_PENDING() : uint
      {
         return this.RENDERER_STATE_PLAY_PENDING;
      }
   }
}
