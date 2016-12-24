<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<!--
Copyright (c) Microsoft Corporation.  All rights reserved.
-->
<instrumentationManifest
  xmlns="http://schemas.microsoft.com/win/2004/08/events"
  xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <instrumentation>
    <events>

      <provider name="Microsoft-WindowsMobile-WebSearch"
          guid="{E23FD6CE-7CF1-44d5-9D53-B30673788E68}"
          symbol="MICROSOFT_WINDOWSMOBILE_WEBSEARCH"
          messageFileName="WebSearch.exe"
          resourceFileName="WebSearch.exe">

        <!-- List of Channels to which this Provider writes data. -->
        <channels>

          <!--Pre-Existing channel can be imported, but not required. -->
          <!--<importChannel chid="APPLICATION" name="Application"/>-->

          <!-- Custom channel for this provider to write to. -->
          <channel name="Microsoft-WindowsMobile-WebSearchLog-Channel"
              chid="WebSearchLogChannel"
              type="Operational"
              symbol="WebSearchLog_DefaultChannel"
              enabled="true"
              value="30"/>
          <!--1E hex value for registry-->


          <channel name="Microsoft-WindowsMobile-WebSearch-Channel"
              chid="Default"
              type="Operational"
              symbol="MICROSOFT_WINDOWSMOBILE_WEBSEARCH_CHANNEL"
              enabled="true"
              value="36" />

        </channels>


        <!-- Keywords for Microsoft-WindowsMobile-WebSearch-Channel -->
        <keywords>
          <keyword mask="0x0000000000000001" name="Debug" />
          <keyword mask="0x0000000000000002" name="Performance" />
          <keyword mask="0x0000000000000004" name="WebService" />
          <keyword mask="0x0000000000000008" name="Navigation" />
          <keyword mask="0x0000000000000010" name="Location" />
        </keywords>

        <!-- Global opcodes -->
        <opcodes>
          <opcode name="Error"                  value="50" />
          <opcode name="Initialize"             value="51" />
          <opcode name="Uninitialize"           value="52" />
          <opcode name="Callback"               value="53" />
          <opcode name="Update"                 value="54" />
          <opcode name="ReverseGeocode"         value="55" />
        </opcodes>

        <!-- Tasks are used with opcodes win:Start and win:Stop to link start and stop events from
             the same task together. -->
        <tasks>

          <!-- The unused task ids should be marked or cleaned up with Bug# 79608  -->
          <!-- Search Specific Tasks -->
          <task name="SEARCH_HOME"                                  value="1"/>
          <task name="SEARCH_HOME_QUERYINFO"                        value="2"/>
          <task name="SEARCH_HOME_TODAYIMAGE_DOWNLOAD"              value="3"/>
          <task name="SEARCH_HOME_TODAYIMAGE_ANIMATION"             value="4"/>
          <task name="SEARCH_HOME_HOTSPOTS_ANIMATION"               value="5"/>
          <task name="SEARCH_QUERYRESULTS"                          value="6"/>
          <task name="SEARCH_LOCAL_PAGE"                            value="7"/>
          <task name="SEARCH_WEB_PAGE"                              value="8"/>
          <task name="SEARCH_NEWS_PAGE"                             value="9"/>
          <task name="SEARCH_RESULTS_PIVOTING"                      value="10"/>
          <task name="SEARCH_RESULTS_ONRESUME"                      value="11"/>
          <task name="SEARCH_LOCATIONNAME_UPDATED"                  value="12"/>
          <task name="SEARCH_HOTSPOT_REFRESHED"                     value="13"/>
          <task name="SEARCH_RESULTS_LIST_UPDATED"                  value="14"/>
          <task name="SEARCH_DATA_SERIALIZE"                        value="15"/>
          <task name="SEARCH_DATA_DESERIALIZE"                      value="16"/>
          <task name="SEARCH_IMAGE_PAGE"                            value="17"/>
          <task name="SEARCH_MORE_PAGE"                             value="18"/>
          <task name="SEARCH_MORE_QUERYRESULTS"                     value="19"/>
          <task name="SEARCH_IMAGE_PREVIEW"                         value="20"/>

          <!-- Hosted Search Tasks -->
          <task name="HOSE_SEARCH_QUERY"                            value="30"/>
          <task name="HOSE_QUERYRESULTS"                            value="31"/>
          <task name="HOSE_QUICKCARD"                               value="32"/>
          <task name="HOSE_MORERESULTS"                             value="33"/>
          <task name="HOSE_PAGE_DOWNLOADED"                         value="34"/>
          <task name="HOSE_PAGE_SHOWPIVOT"                          value="35"/>
          <task name="HOSE_PAGE_PANE"                               value="36"/>
          <task name="HOSE_SEARCH_APPCONNECT_PROCESSING"            value="37"/>
          <task name="HOSE_PAGE_ERROR"                              value="38"/>
          <task name="HOSE_GENRATE_PLACE_TILE"                      value="39"/>
          <task name="HOSE_DOWNLOAD_QC_TILE"                        value="40"/>
          <task name="HOSE_MAPS_ACQUIRE_MAP"                        value="41"/>
          <task name="HOSE_MAPS_OVERLAY_POIS"                       value="42"/>
          <task name="HOSE_ACTION_URI"                              value="43"/>
          <task name="HOSE_THEME_REFRESH"                           value="44"/>
          <!-- 50-59 reserved for global op codes up above -->

          <!-- AR Search Specific Tasks -->
          <task name="ARSEARCH_VIEWFINDERVM_STARTUP"                value="60"/>
          <task name="ARSEARCH_VIDEOSURFACEREADY"                   value="61"/>
          <task name="ARSEARCH_DETECTIONLOOP"                       value="62"/>
          <task name="ARSEARCH_CAMERA_FOCUS"                        value="63"/>
          <task name="ARSEARCH_STABILITY"                           value="64"/>
          <task name="ARSEARCH_SHUTDOWNBEGIN"                       value="65"/>
          <task name="ARSEARCH_UPC_DETECT"                          value="66"/>
          <task name="ARSEARCH_UPC_DETECTANDDECODE"                 value="67"/>
          <task name="ARSEARCH_QR_DETECT"                           value="68"/>
          <task name="ARSEARCH_QR_DETECTANDDECODE"                  value="69"/>
          <task name="ARSEARCH_MSTAG_DETECT"                        value="70"/>
          <task name="ARSEARCH_MSTAG_DETECTANDDECODE"               value="71"/>
          <task name="ARSEARCH_BINGIMAGEWORK"                       value="72"/>
          <task name="ARSEARCH_GETRECENTLOC"                        value="73"/>
          <task name="ARSEARCH_BINGIMAGEALLOC"                      value="74"/>
          <task name="ARSEARCH_TEXT_DETECT"                         value="75"/>
          <task name="ARSEARCH_OCR_RECOGNITION"                     value="76"/>
          <task name="ARSEARCH_AUDIO_RECORDING"                     value="77"/>
          <task name="ARSEARCH_AUDIO_RECORDING_TIMEOUT"             value="78"/>
          <task name="ARSEARCH_AUDIO_DETECTION"                     value="79"/>
          <task name="ARSEARCH_AUDIO_FINGERPRINT"                   value="80"/>
          <task name="AUDIOSEARCH_UX_LISTENING"                     value="81"/>
          <task name="AUDIOSEARCH_UX_RESULTFOUND"                   value="82"/>
          <task name="AUDIOSEARCH_UX_NORESULT"                      value="83"/>
          <task name="AUDIOSEARCH_UX_NOCONNECTION"                  value="84"/>
          <task name="AUDIOSEARCH_UX_FAILED"                        value="85"/>
          <task name="AUDIOSEARCH_UX_ACTIVEVOICECALLFAILURE"        value="86"/>
          <task name="ARSEARCH_RESULT_SERIALIZATION"                value="87"/>
          <task name="ARSEARCH_RESULT_DESERIALIZATION"              value="88"/>
          <task name="ARSEARCH_AUDIO_WAVE_OP"                       value="89"/>
          <task name="ARSEARCH_AUDIO_SERIALIZATION"                 value="90"/>
          <task name="ARSEARCH_AUDIO_DESERIALIZATION"               value="91"/>
          <task name="ARSEARCH_RESULT_PARSE"                        value="92"/>
          <task name="ARSEARCH_RAWUPLOAD_UPLOAD"                    value="93"/>
          <task name="ARSEARCH_RAWUPLOAD_READ_FILE"                 value="94"/>
          <task name="AUDIOSEARCH_UX_RAWUPLOAD_CONFIRMATION"        value="95"/>
          <task name="AUDIOSEARCH_UX_RAWUPLOAD_PROGRESS"            value="96"/>
          <task name="AUDIOSEARCH_UX_RAWUPLOAD_ERROR"               value="97"/>

          <!-- Common tasks -->
          <task name="MAPTEASE_DOWNLOAD"                            value="101"/>
          <task name="LOCATION_REQUEST"                             value="102"/>
          <task name="LOCATION_DATA_UPDATED"                        value="103"/>
          <task name="CSM_LOCATION_SHIFTED"                         value="104"/>

          <!-- PlaceCard Specific Tasks -->
          <task name="PLACECARD_INFO_PANE"                          value="201"/>
          <task name="PLACECARD_BUZZ_PANE"                          value="202"/>
          <task name="PLACECARD_EVENTS_PANE"                        value="203"/>
          <task name="PLACECARD_MOVIES_PANE"                        value="204"/>
          <task name="PLACECARD_EXTRAS_PANE"                        value="205"/>
          <task name="PLACECARD_PIVOTING"                           value="206"/>
          <task name="PLACECARD_NBHOOD_QUERYRESULTS"                value="207"/>
          <task name="PLACECARD_REVIEWS_QUERYRESULTS"               value="208"/>
          <task name="PLACECARD_EVENTS_QUERYRESULTS"                value="209"/>
          <task name="PLACECARD_MOVIES_QUERYRESULTS"                value="210"/>
          <task name="PLACECARD_MOVIEDETAILS_QUERYRESULTS"          value="211"/>
          <task name="PLACECARD_EXTRAS_QUERYRESULTS"                value="212"/>
          <task name="PLACECARD_NAVIGATION"                         value="213"/>

          <!-- Bing Configuration tasks -->
          <task name="CONFIGURATION_UPDATE"                         value="300"/>
          <task name="CONFIGURATION_DOWNLOAD"                       value="301"/>
          <task name="CONFIGURATION_PARSE"                          value="302"/>
          <task name="CONFIGURATION_SAVE"                           value="303"/>
          <task name="CONFIGURATION_SAVE_CATEGORIES"                value="304"/>
          <task name="CONFIGURATION_SAVE_LOCALES"                   value="305"/>
          <task name="CONFIGURATION_SAVE_LOCALE"                    value="306"/>
          <task name="CONFIGURATION_LOAD_CATEGORIES"                value="307"/>
          <task name="CONFIGURATION_LOAD_LOCALE"                    value="308"/>
          <task name="CONFIGURATION_LOAD"                           value="309"/>

          <task name="CONFIGURATION_LOAD_PROPERTY"                  value="310"/>
          <task name="CONFIGURATION_SAVE_PROPERTY"                  value="311"/>

          <task name="CONFIGURATION_LOAD_LOCALE_NONOSS_ENDPOINT"    value="312"/>
          <task name="CONFIGURATION_SAVE_LOCALE_NONOSS_ENDPOINT"    value="313"/>

          <task name="CONFIGURATION_LOAD_PREFIX_LIST"               value="314"/>
          <task name="CONFIGURATION_SAVE_PREFIX_LIST"               value="315"/>

          <task name="CONFIGURATION_LOAD_APP_LIST"                  value="316"/>
          <task name="CONFIGURATION_SAVE_APP_LIST"                  value="317"/>

          <task name="CONFIGURATION_SAVE_OSS_ENDPOINT"              value="318"/>
          <task name="CONFIGURATION_BACKGROUND_WORKER_RUN"          value="319"/>

          <!-- EventCard specific tasks -->
          <task name="EVENTCARD_NAVIGATION"                         value="350"/>
          <task name="EVENTCARD_ABOUT_PANE"                         value="351"/>
          <task name="EVENTCARD_EXTRAS_PANE"                        value="352"/>
          <task name="EVENTCARD_PIVOTING"                           value="353"/>
          <task name="EVENTCARD_TICKETPROVIDERS_NAVIGATION"         value="354"/>

          <!-- Map Specific Tasks -->
          <task name="MAPS_HOME"                                    value="400"/>
          <task name="MAPS_HOME_READY"                              value="401"/>
          <task name="MAPS_SEARCHBOX_UP"                            value="402"/>
          <task name="MAPS_SEARCH_QUERYRESULTS"                     value="403"/>
          <task name="MAPS_SEARCH_POIS_READY"                       value="404"/>
          <task name="MAPS_POI_DETAILS_OPEN"                        value="405"/>
          <task name="MAPS_INPUT_DIRECTIONS_UP"                     value="406"/>
          <task name="MAPS_DIRECTIONS_QUERYRESULTS"                 value="407"/>
          <task name="MAPS_ROUTE_READY"                             value="408"/>
          <task name="MAPS_DIRECTIONS_PAGE"                         value="409"/>
          <task name="MAPS_DIRECTIONS_MAPTEASE_UPDATE"              value="410"/>
          <task name="MAPS_LOCATE_ME"                               value="411"/>
          <task name="MAPS_LOCATE_ME_READY"                         value="412"/>
          <task name="MAPS_ZOOM_IN"                                 value="413"/>
          <task name="MAPS_ZOOM_OUT"                                value="414"/>
          <task name="MAPS_TRAFFIC"                                 value="416"/>
          <task name="MAPS_SEARCH_INVOKED"                          value="417"/>
          <task name="MAPS_SEARCH_SUGGESTIONBAR_DISPLAYED"          value="418"/>
          <task name="MAPS_SEARCH_AUTOSUGGEST_UPDATED"              value="419"/>
          <task name="MAPS_DATA_SERIALIZE"                          value="420"/>
          <task name="MAPS_DATA_DESERIALIZE"                        value="421"/>
          <task name="MAPS_DIRECTIONS_INVOKED"                      value="422"/>
          <task name="MAPS_DIRECTIONS_ZOOMADJUST_COMPLETE"          value="423"/>
          <task name="MAPS_ROUTE_GENERALIZATION"                    value="424"/>
          <task name="MAPS_ROUTE_SPATIAL_SORT"                      value="425"/>
          <task name="MAPS_MEPOI_REVERSE_GEOCODE"                   value="426"/>
          <task name="MAPS_ANIMATION"                               value="427">
            <opcodes>
              <opcode name="ZoomInfo"           value="100" />
              <opcode name="TimingInfo"         value="101" />
            </opcodes>
          </task>
          <task name="MAPS_PINCHSTRETCH"                            value="428">
            <opcodes>
              <opcode name="Scale"              value="100" />
              <opcode name="Drag"               value="101" />
            </opcodes>
          </task>
          <task name="MAPS_PAN"                                     value="429">
            <opcodes>
              <opcode name="Flick"              value="100" />
              <opcode name="OverScroll"         value="101" />
            </opcodes>
          </task>
          <task name="MAPS_DIRECTIONS_WARMUP_LOCATION_REQUEST"      value="430"/>
          <task name="MAPS_DIRECTIONS_QUERY_SUBMIT"                 value="431"/>
          <task name="MAPS_DIRECTIONS_SUBMIT_LOCATION_REQUEST"      value="432"/>
          <task name="MAPS_DIRECTIONS_ACCURATE_LOCATION_RESPONSE"   value="433"/>
          <task name="MAPS_GRAPHIC_RESOLVED"                        value="434"/>
          <task name="PLACESCENTER_NAVIGATION"                      value="435"/>
          <task name="MAPS_VENUE_METADATA_PROCESSING"               value="436"/>
          <task name="MAPS_VENUE_DIRECTORY_FILTERING"               value="437"/>
          <task name="MAPS_VENUE_HITTEST"                           value="438"/>
          <task name="NAVIGATIONENGINE_SET_ROUTE"                   value="439"/>
          <task name="NAVIGATIONENGINE_PROCESSING_LOCATION"         value="440"/>
          <task name="NAVIGATIONENGINE_SNAP_TO_ROUTE"               value="441"/>
          <task name="NAVIGATIONENGINE_CLASSIFY_NAV_STATUS"         value="442"/>
          <task name="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"      value="443">
            <opcodes>
              <opcode name="DrivingStart"              value="100" />
              <opcode name="DrivingEnd"                value="101" />
              <opcode name="DrivingAnnounce"           value="102" />
              <opcode name="DrivingReroute"            value="103" />
              <opcode name="DrivingOffroute"           value="104" />
              <opcode name="DrivingBackOnRoute"        value="105" />
              <opcode name="DrivingInaccurateLocation" value="106" />
              <opcode name="DrivingFlick"              value="107" />
              <opcode name="DrivingQueryInfo"          value="108" />
              <opcode name="DrivingHeading"            value="109" />
              <opcode name="DrivingDistanceBeforeTurn" value="110" />
            </opcodes>
          </task>
          <task name="MAPS_DIRECTIONS_SPEECH"                       value="444"/>
          <task name="MAPS_DIRECTIONS_AUDIO_CUE"                    value="445"/>
          <task name="MAPS_DEVICE_INTERACTIVITY"                    value="446"/>
          <task name="MAPS_DIRECTIONS_GETROUTE"                     value="447"/>
          <task name="MAPS_DIRECTIONS_GETUSERLOCATION"              value="448"/>
          <task name="MAPS_DIRECTIONS_RESOLVESTART"                 value="449"/>
          <task name="MAPS_DIRECTIONS_RESOLVEEND"                   value="450"/>
          <task name="MAPS_DIRECTIONS_ROUTINGQUERY"                 value="451"/>

          <!-- Instrumentation -->
          <task name="INSTRUMENTATION_USER_ID_RECEIVED"                           value="501"/>
          <task name="INSTRUMENTATION_ACTIVATION_SUCCESS_SENT"                    value="502"/>
          <task name="INSTRUMENTATION_LAYOUT_SENT"                                value="503"/>
          <task name="INSTRUMENTATION_PARTIAL_IMPRESSION_SENT"                    value="504"/>
          <task name="INSTRUMENTATION_CLICK_EVENT_SENT"                           value="505"/>
          <task name="INSTRUMENTATION_BATCHED_LAYOUT_SENT"                        value="506"/>
          <task name="INSTRUMENTATION_SEARCHHOME_COMMANDBAR_CLICK_SENT"           value="507"/>
          <task name="INSTRUMENTATION_HOSE_COMMANDBAR_CLICK_SENT"                 value="508"/>
          <task name="INSTRUMENTATION_PAGE_VIEW_QUERY"                            value="509"/>

          <!-- Product card -->
          <task name="PRODUCT_CARD_NAVIGATION"                      value="550"/>

          <!-- Location Service -->
          <task name="LOCATION_SERVICE"                             value="110" />
          <task name="LOCATION_CURRENT"                             value="111" />
          <task name="LOCATION_TRACKING"                            value="112" />

          <!-- Navigation -->
          <task name="PAGE_NAVIGATION"                              value="130">
            <opcodes>
              <opcode name="NavigatedTo"        value="100" />
              <opcode name="NavigatingAway"     value="101" />
              <opcode name="Closing"            value="102" />
              <opcode name="StartNavigation"    value="103" />
              <opcode name="PageInitialized"    value="104" />
            </opcodes>
          </task>
          <task name="PAGE_NAVIGATEDTO"                             value="131" />
          <task name="PAGE_NAVIGATINGAWAY"                          value="132" />
          <task name="PAGE_CLOSING"                                 value="133" />
          <task name="TASK_MODEL"                                   value="134">
            <opcodes>
              <opcode name="Rehydrate"          value="100" />
              <opcode name="Dehydrate"          value="101" />
              <opcode name="ActiveTaskCount"    value="102" />
            </opcodes>
          </task>
          <task name="TASK_PAUSING"                                 value="135" />
          <task name="TASK_RESUMING"                                value="136" />

          <!-- Neighborhood Tasks -->
          <task name="NEIGHBORHOOD_PANE_MODELS_LIST_READY"          value="137" />
          <task name="NEIGHBORHOOD_VISIBLE"                         value="138" />
          <task name="NEIGHBORHOOD_CORE_STATE_RETREIVED"            value="139" />
          <task name="NEIGHBORHOOD_RESULTS_STATE_RETREIVED"         value="140" />
          <task name="NEIGHBORHOOD_STATE_PUBLISHED"                 value="141" />
          <task name="NEIGHBORHOOD_FILTER_SET_RETREIVED"            value="142" />
          <task name="NEIGHBORHOOD_FILTER_SET_PUBLISHED"            value="143" />
          <task name="NEIGHBORHOOD_LAUNCHED_AS_TASK"                value="144" />
          <task name="NEIGHBORHOOD_PUBLISHED_MAP_POIS"              value="145" />
          <task name="NEIGHBORHOOD_FOWARD_NAVIGATE"                 value="146" />
          <task name="NEIGHBORHOOD_DESERIALIZE_DATA_STORE_QUERY"    value="148" />
          <task name="NEIGHBORHOOD_BUSINESSES_QUERY"                value="149" />
          <task name="NEIGHBORHOOD_ACTIVE_PANE"                     value="150" />

          <!-- Queries  -->
          <task name="POI_DATA_STORE_QUERY"                         value="200" />

          <!-- Generic data processing -->
          <task name="DATA_PROCESSING"                              value="600" />
          <task name="WORK_QUEUE"                                   value="601" />

          <!-- UIXSchemaState -->
          <task name="UIX_SCHEMA_STATE"                             value="650">
            <opcodes>
              <opcode name="Lock"               value="100" />
              <opcode name="Unlock"             value="101" />
              <opcode name="IsUnloaded"         value="102" />
              <opcode name="SetUnloaded"        value="103" />
            </opcodes>
          </task>

          <!-- POIDB operations-->
          <task name="POIDB_INITIALIZE"                             value="750" />
          <task name="POIDB_CLOSE"                                  value="751" />
          <task name="POIDB_INITIALIZING"                           value="752" />
          <task name="POIDB_ADDPOI"                                 value="753" />
          <task name="POIDB_UPDATING_ACCESSTIME"                    value="754" />
          <task name="POIMTF_INITIALIZE"                            value="760" />
          <task name="POIMTF_CLOSE"                                 value="761" />
          <task name="POIMTF_INITIALIZING"                          value="762" />
          <task name="POIMTF_GETCANDIDATE"                          value="763" />

          <!-- Generic tasks -->
          <task name="NON_BLOCKING_WAIT_CURSOR_VISIBLE"             value="997" />
          <task name="PERF_SCENARIO"                                value="998" />
          <task name="WEBSEARCH_GENERIC"                            value="999" />

          <!--  Explore and IOTD tasks  -->
          <task name="EXPLORE_QUERY"                          value="2000"/>
          <task name="EXPLORE_ADD_CATEGORY_CARDS"             value="2001"/>
          <task name="EXPLORE_LOADING_CARD"                   value="2002"/>
          <task name="EXPLORE_ERROR_CARD"                     value="2003"/>
          <task name="EXPLORE_SWIPE_TO_CATEGORY_CARD"         value="2004"/>
          <task name="EXPLORE_TAP_ON_QUICK_CARD"              value="2005"/>
          <task name="EXPLORE_TAP_ON_DEEP_DIVE"               value="2006"/>

          <task name="IOTD_QUERY"                             value="2050"/>
          <task name="PORTRAIT_IOTD_DOWNLOAD"                 value="2051"/>
          <task name="LANDSCAPE_IOTD_DOWNLOAD"                value="2052"/>
          <task name="IOTD_VISIBLE"                           value="2053"/>
          <task name="IOTD_FADE"                              value="2054"/>
          <task name="HOTSPOTS"                               value="2055"/>

          <!-- General  -->
          <task name="SEARCH_ENTERED_CONTENT_EDITBOX"           value="3000"/>
          <task name="SEARCH_SUBMIT_CONTENT_TO_SUGGESTIONS_BAR" value="3001"/>
          <task name="SEARCH_SETTINGS_PAGE_VISIBLE"             value="3002"/>

          <!-- Venue Maps -->
          <task name="VENUEMAP_METADATAQUERY"                 value="3500"/>
          <task name="VENUEMAP_TFEQUERY"                      value="3501"/>
          <task name="VENUEMAP_SHOWPOLYGONS"                  value="3502"/>
          <task name="VENUEMAP_HIDEPOLYGONS"                  value="3503"/>
          <task name="VENUEMAP_HITTESTING"                    value="3504"/>

          <!-- Landmarks -->
          <task name="LANDMARK_TFEQUERY"                      value="3600"/>
          <task name="LANDMARK_SHOWLANDMARKS"                 value="3601"/>
          <task name="LANDMARK_HIDELANDMARKS"                 value="3602"/>
          <task name="LANDMARK_HITTESTING"                    value="3603"/>

          <!-- OnlineLocationAutosuggest tasks -->
          <task name="ONLINELOCATIONAUTOSUGGEST_GETCANDIDATES"        value="3700"/>
          <task name="ONLINELOCATIONAUTOSUGGEST_CREATESUGGESTIONLIST" value="3701"/>
          <task name="ONLINELOCATIONAUTOSUGGEST_GETLOCATIONDATA"      value="3702"/>
          <task name="ONLINELOCATIONAUTOSUGGEST_DOWNLOADERTHREAD"     value="3703"/>
          <task name="ONLINELOCATIONAUTOSUGGEST_CREATEQUERY"          value="3704"/>
          <task name="ONLINELOCATIONAUTOSUGGEST_DOQUERY"              value="3705"/>
          <task name="ONLINELOCATIONAUTOSUGGEST_DOWNLOADQUERY"        value="3706"/>
          <task name="ONLINELOCATIONAUTOSUGGEST_PARSEQUERY"           value="3707"/>

          <!-- WinHttpDownloader tasks -->
          <task name="WINHTTPDOWNLOADER_CRACKURL"           value="3800"/>
          <task name="WINHTTPDOWNLOADER_CONNECT"            value="3801"/>
          <task name="WINHTTPDOWNLOADER_OPENREQUEST"        value="3802"/>
          <task name="WINHTTPDOWNLOADER_SENDREQUEST"        value="3803"/>
          <task name="WINHTTPDOWNLOADER_RECEIVERESPONSE"    value="3804"/>
          <task name="WINHTTPDOWNLOADER_READDATA"           value="3805"/>
          <task name="WINHTTPDOWNLOADER_STREAMCREATE"       value="3806"/>
          <task name="WINHTTPDOWNLOADER_STREAMWRITE"        value="3807"/> 
          <task name="WINHTTPDOWNLOADER_STREAMSEEK"         value="3808"/>
          
          <!--  Device search tasks -->
          <task name="DEVICE_SEARCH_QUERY_EXECUTE"            value="4000"/>
          <task name="DEVICE_SEARCH_QUERY_PROCESS"            value="4001"/>
          <task name="DEVICE_SEARCH_EMAIL_QUERY"              value="4002"/>
          <task name="DEVICE_SEARCH_CONTACTS_QUERY"           value="4003"/>
          <task name="DEVICE_SEARCH_APPS_QUERY"               value="4004"/>
          <task name="DEVICE_SEARCH_SETTINGS_QUERY"           value="4005"/>

          <!-- Speech tasks -->
          <task name="ACTION_HANDLER_RPC_SERVER"              value="4100"/>

          <!-- Cortana Profile tasks -->
          <task name="CORTANAPROFILE_INTEREST_LIST_LOAD"           value="4200"/>
          <task name="CORTANAPROFILE_INTEREST_PAGE_LOAD"           value="4201"/>
          <task name="CORTANAPROFILE_INTEREST_PAGE_SAVE"           value="4202"/>
          <task name="CORTANAPROFILE_ADD_INTEREST_PAGE_LOAD"       value="4203"/>

          <!-- AssistUx tasks -->
          <task name="ASSISTUX_LAUNCHED"                      value="4300"/>
          <task name="ASSISTUX_SCREENID_SET"                  value="4301"/>
          <task name="ASSISTUX_PROACTIVE"                     value="4302"/>
          <task name="ASSISTUX_REACTIVE"                      value="4303"/>
          <task name="ASSISTUX_REACTIVE_PREFETCH"             value="4304"/>
          
          <!-- InterestExtraction tasks -->
          <task name="INTERESTEXTRACTION_ENSURESYNCPARTNERS"             value="4400"/>
          <task name="INTERESTEXTRACTION_UPDATESTORE"                    value="4401"/>
          <task name="INTERESTEXTRACTION_UPDATEFOLDER"                   value="4402"/>
          <task name="INTERESTEXTRACTION_COLLECTFOLDERCHANGES"           value="4403"/>
          <task name="INTERESTEXTRACTION_PROCESSFOLDERCHANGES"           value="4404"/>
          <task name="INTERESTEXTRACTION_PROCESSITEMCHANGES"             value="4405"/>
          <task name="INTERESTEXTRACTION_SCHEMA_TEXTEXTRACTION"          value="4406"/>
          <task name="INTERESTEXTRACTION_SCHEMA_JSONLDEXTRACTION"        value="4407"/>
          <task name="INTERESTEXTRACTION_SCHEMA_MICRODATAEXTRACTION"     value="4408"/>

          <!-- AssistUX settings tasks -->
          <task name="ASSISTUX_SETTINGS_PAGE_VISIBLE" value="4500"/>
          <task name="ASSISTUX_SETTINGS_PAGE_INVOKEFROM_NOTEBOOK" value="4501"/>

          <!-- AssistUX GUIForm tasks -->
          <task name="ASSISTUX_GUIFORM_EDITBOX_SUBMIT" value="4502"/>
          <task name="ASSISTUX_ACTION_COMPLETED_CONFIRMATION" value="4503"/>

          <!-- DND settings tasks -->
          <task name="DND_SETTINGS_PAGE_VISIBLE" value="4600"/>
          <task name="DND_SETTINGS_PAGE_INVOKEFROM_NOTEBOOK" value="4601"/>

          <!-- SmartExtraction tasks -->
          <task name="SMARTEXTRACTION_TEXT_SNIFFING"      value="4700"/>
          <task name="SMARTEXTRACTION_TEXT_EXTRACTION"    value="4701"/>
        </tasks>

        <!-- Enumeration strings -->
        <maps>
          <valueMap name="LocationAccuracyType">
            <map value="1"    message="$(string.Enums.LocationAccuracy_High)" />
            <map value="2"    message="$(string.Enums.LocationAccuracy_PowerOptimized)" />
          </valueMap>
          <valueMap name="LocationGenerateType">
            <map value="1"    message="$(string.Enums.LocationGenerate_Last)" />
            <map value="2"    message="$(string.Enums.LocationGenerate_First)" />
            <map value="3"    message="$(string.Enums.LocationGenerate_Best)" />
          </valueMap>
          <valueMap name="PageIDs">
            <map value="1"    message="$(string.Enums.PageID_SearchHome)" />
            <map value="2"    message="$(string.Enums.PageID_SearchResults)" />
            <map value="3"    message="$(string.Enums.PageID_MapsHome)" />
            <map value="4"    message="$(string.Enums.PageID_LocalCard)" />
            <map value="5"    message="$(string.Enums.PageID_MapsSearch)" />
            <map value="6"    message="$(string.Enums.PageID_MapsSearchResultsList)" />
            <map value="7"    message="$(string.Enums.PageID_DirectionsOverlay)" />
            <map value="8"    message="$(string.Enums.PageID_DirectionsList)" />
            <map value="9"    message="$(string.Enums.PageID_DirectionsClarifyList)" />
            <map value="10"   message="$(string.Enums.PageID_ARViewfinder)" />
            <map value="11"   message="$(string.Enums.PageID_ReviewsCard)" />
            <map value="12"   message="$(string.Enums.PageID_ARImage)" />
            <map value="14"   message="$(string.Enums.PageID_MovieCard)" />
            <map value="16"   message="$(string.Enums.PageID_ProductCard)" />
            <map value="17"   message="$(string.Enums.PageID_OCRHome)" />
            <map value="18"   message="$(string.Enums.PageID_QrcodePage)" />
            <map value="22"   message="$(string.Enums.PageID_MoreResults)" />
            <map value="26"   message="$(string.Enums.PageID_ImagePreview)" />
          </valueMap>
          <valueMap name="NavigationStatusType">
            <map value="0"    message="$(string.Enums.NavigationStatus_Undetermined)" />
            <map value="1"    message="$(string.Enums.NavigationStatus_AwayFromStart)" />
            <map value="2"    message="$(string.Enums.NavigationStatus_ProceedingToStart)" />
            <map value="3"    message="$(string.Enums.NavigationStatus_MovingOnRoute)" />
            <map value="4"    message="$(string.Enums.NavigationStatus_StoppedOnRoute)" />
            <map value="5"    message="$(string.Enums.NavigationStatus_DriftingFromRoute)" />
            <map value="6"    message="$(string.Enums.NavigationStatus_OffRoute)" />
            <map value="7"    message="$(string.Enums.NavigationStatus_Arrived)" />
          </valueMap>
          <valueMap name="DeviceInteractivityType">
            <map value="0"    message="$(string.Enums.InteractivityType_Tracking)" />
            <map value="1"    message="$(string.Enums.InteractivityType_TrackingAndMoving)" />
            <map value="2"    message="$(string.Enums.InteractivityType_None)" />
          </valueMap>
        </maps>

        <!-- Event Templates -->
        <templates>

          <!-- Logging -->
          <template tid="WebSearchIFFAILTemplate">
            <data name="Prop_FUNC_AnsiString" inType="win:AnsiString" />
            <data name="Prop_LINE_UInt32" inType="win:UInt32" />
            <data name="Prop_UInt32" inType="win:UInt32" outType="win:HexInt32" />

            <UserData>
              <HREvent xmlns="WebSearchIFFAILEvent">
                <Prop_FUNC_AnsiString> %1</Prop_FUNC_AnsiString>
                <Prop_LINE_UInt32> %2 </Prop_LINE_UInt32>
                <Prop_UInt32> %3 </Prop_UInt32>
              </HREvent>
            </UserData>
          </template>

          <!-- Generic -->
          <template tid="String">
            <data name="Message"          inType="win:UnicodeString" />
          </template>
          <template tid="UInt32">
            <data name="Value"            inType="win:UInt32" />
          </template>
          <template tid="HResult">
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="HResultAndErrorCode">
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
            <data name="ErrorCode"        inType="win:UInt32" />
          </template>
          <template tid="TaggedHResult">
            <data name="Tag"              inType="win:UnicodeString" />
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="TaggedError">
            <data name="Tag"              inType="win:UnicodeString" />
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
            <data name="ErrorCode"        inType="win:UInt32" />
          </template>
          <template tid="Boolean">
            <data name="Value"            inType="win:Boolean" />
          </template>
          <template tid="Pointer">
            <data name="Value"            inType="win:Pointer" />
          </template>
          <template tid="Context">
            <data name="Context"          inType="win:Pointer" />
          </template>
          <template tid="StringKeyValuePair">
            <data name="Key"              inType="win:UnicodeString" />
            <data name="Value"            inType="win:UnicodeString" />
          </template>
          <template tid="Float">
            <data name="Value"            inType="win:Float" />
          </template>
          <template tid="Double">
            <data name="Value"            inType="win:Double" />
          </template>
          <template tid="Vector2">
            <data name="X"                inType="win:Float" />
            <data name="Y"                inType="win:Float" />
          </template>
          <template tid="DoubleVector2">
            <data name="X"                inType="win:Double" />
            <data name="Y"                inType="win:Double" />
          </template>

          <!-- Navigation -->
          <template tid="PageID">
            <data name="PageID"           inType="win:UInt32"   map="PageIDs" />
          </template>
          <template tid="TaskID">
            <data name="TaskID"           inType="win:UInt32" />
          </template>
          <template tid="TaskIDAndName">
            <data name="TaskID"           inType="win:UInt32" />
            <data name="Destination"      inType="win:UnicodeString" />
          </template>

          <template tid="ActiveTaskCount">
            <data name="ActiveTaskCount" inType="win:UInt32" />
          </template>

          <!-- Location -->
          <template tid="LocationCallback">
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
            <data name="Status"           inType="win:UInt32" />
            <data name="Context"          inType="win:Pointer" />
            <data name="Latitude"         inType="win:Double" />
            <data name="Longitude"        inType="win:Double" />
            <data name="AccuracyRadius"   inType="win:Double" />
            <data name="Accuracy"         inType="win:UInt32"   map="LocationAccuracyType" />
            <data name="Generate"         inType="win:UInt32"   map="LocationGenerateType" />
            <data name="CreationTime"     inType="win:FILETIME" />
            <data name="Heading"          inType="win:Double" />
            <data name="Velocity"         inType="win:Double" />
          </template>

          <!-- Map -->
          <template tid="MapZoomInInfo">
            <data name="X"                inType="win:Float" />
            <data name="Y"                inType="win:Float" />
            <data name="StartZoomLevel"   inType="win:Float" />
            <data name="EndZoomLevel"     inType="win:Float" />
          </template>
          <template tid="MapAnimationZoomInfo">
            <data name="StartPowerScale"  inType="win:Float" />
            <data name="MidPowerScale"    inType="win:Float" />
            <data name="EndPowerScale"    inType="win:Float" />
          </template>
          <template tid="MapAnimationTimingInfo">
            <data name="Scale1Time"       inType="win:Float" />
            <data name="TranslationTime"  inType="win:Float" />
            <data name="Scale2Time"       inType="win:Float" />
          </template>

          <!-- Navigation Engine -->
          <template tid="NavigationEngineInfo">
            <data name="Status"                    inType="win:UInt32"     map="NavigationStatusType" />
            <data name="CurrentInstructionIndex"   inType="win:Int32" />
            <data name="DistanceToNextInstruction" inType="win:Double" />
            <data name="IsLocationAccurate"        inType="win:Boolean" />
            <data name="NavigationStarted"         inType="win:Boolean" />
            <data name="BearingToDestination"      inType="win:Int32" />
          </template>
          <template tid="SnapInfo">
            <data name="SnapFound"        inType="win:Boolean" />
            <data name="SnapLatitude"     inType="win:Double" />
            <data name="SnapLongitude"    inType="win:Double" />
            <data name="SnapSegmentIndex" inType="win:Int32" />
            <data name="SnapDistance"     inType="win:Double" />
          </template>
          <template tid="NavigationStatusClassifierInfo">
            <data name="NavigationStatus"             inType="win:UInt32"    map="NavigationStatusType" />
            <data name="SnapToleranceExpanded"        inType="win:Boolean" />
            <data name="CurrentSnapToleranceDistance" inType="win:Float" />
            <data name="ConsecutiveNonSnapFixes"      inType="win:Int32" />
          </template>

          <!-- Driving Experience -->
          <template tid="DrivingFlickInfo">
            <data name="ItemIndex"   inType="win:Int32" />
          </template>
          <template tid="DrivingQueryInfo">
            <data name="StartLatitude"    inType="win:Double" />
            <data name="StartLongitude"   inType="win:Double" />
            <data name="EndLatitude"      inType="win:Double" />
            <data name="EndLongitude"     inType="win:Double" />
            <data name="ItineraryCount"   inType="win:Int32" />
            <data name="RouteLength"      inType="win:Float" />
          </template>

          <template tid="DeviceInteractivityInfo">
            <data name="Status"           inType="win:UInt32"               map="DeviceInteractivityType"/>
            <data name="TimeLeft"         inType="win:UInt32"/>
          </template>

          <template tid="NeighborhoodVisible">
            <data name="Visible"           inType="win:Boolean" />
            <data name="Latitude"          inType="win:Double"/>
            <data name="Longitude"         inType="win:Double"/>
          </template>

        </templates>

        <!-- WebSearch Events -->
        <events>

          <!-- WebSearchEventHRDebug is the default handling of IF_FAIL HR logging -->
          <event value="1"
              level="win:Error"
              template="WebSearchIFFAILTemplate"
              channel="WebSearchLogChannel"
              symbol="WebSearchEventHRDebug"
              keywords="Debug"
              message="$(string.WebSearch.WebSearchEventHRMessage)"/>

          <!-- Performance markers -->
          <event value="100"    symbol="SEARCH_HOME"                            channel="Default"       task="SEARCH_HOME"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchHome)" />
          <event value="101"    symbol="SEARCH_LOCAL_PAGE"                      channel="Default"       task="SEARCH_LOCAL_PAGE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchLocalPage)" />
          <event value="102"    symbol="SEARCH_WEB_PAGE"                        channel="Default"       task="SEARCH_WEB_PAGE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchWebPage)" />
          <event value="103"    symbol="SEARCH_NEWS_PAGE"                       channel="Default"       task="SEARCH_NEWS_PAGE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchNewsPage)" />
          <event value="104"    symbol="SEARCH_RESULTS_PIVOTING_START"          channel="Default"       task="SEARCH_RESULTS_PIVOTING"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.SearchResultsPivotingStart)" />
          <event value="105"    symbol="SEARCH_RESULTS_PIVOTING_STOP"           channel="Default"       task="SEARCH_RESULTS_PIVOTING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.SearchResultsPivotingStop)" />
          <event value="106"    symbol="SEARCH_HOME_QUERYINFO_START"            channel="Default"       task="SEARCH_HOME_QUERYINFO"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.SearchHomeQueryInfoStart)" />
          <event value="107"    symbol="SEARCH_HOME_QUERYINFO_STOP"             channel="Default"       task="SEARCH_HOME_QUERYINFO"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.SearchHomeQueryInfoStop)" />
          <event value="108"    symbol="SEARCH_HOME_TODAYIMAGE_DOWNLOAD_START"  channel="Default"       task="SEARCH_HOME_TODAYIMAGE_DOWNLOAD"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.TodayImageDownloadStart)" />
          <event value="109"    symbol="SEARCH_HOME_TODAYIMAGE_DOWNLOAD_STOP"   channel="Default"       task="SEARCH_HOME_TODAYIMAGE_DOWNLOAD"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.TodayImageDownloadStop)" />
          <event value="110"    symbol="SEARCH_QUERYRESULTS_START"              channel="Default"       task="SEARCH_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.SearchQueryResultsStart)" />
          <event value="111"    symbol="SEARCH_QUERYRESULTS_STOP"               channel="Default"       task="SEARCH_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.SearchQueryResultsStop)" />
          <event value="112"    symbol="MAPTEASE_DOWNLOAD_START"                channel="Default"       task="MAPTEASE_DOWNLOAD"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapteaseDownloadStart)" />
          <event value="113"    symbol="MAPTEASE_DOWNLOAD_STOP"                 channel="Default"       task="MAPTEASE_DOWNLOAD"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapteaseDownloadStop)" />
          <event value="114"    symbol="PLACECARD_INFO_PANE"                    channel="Default"       task="PLACECARD_INFO_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.PlaceCardInfoPane)" />
          <event value="115"    symbol="PLACECARD_BUZZ_PANE"                    channel="Default"       task="PLACECARD_BUZZ_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.PlaceCardBuzzPane)" />
          <event value="116"    symbol="PLACECARD_EVENTS_PANE"                  channel="Default"       task="PLACECARD_EVENTS_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.PlaceCardEventsPane)" />
          <event value="117"    symbol="PLACECARD_PIVOTING_START"               channel="Default"       task="PLACECARD_PIVOTING"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlaceCardPivotingStart)" />
          <event value="118"    symbol="PLACECARD_PIVOTING_STOP"                channel="Default"       task="PLACECARD_PIVOTING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardPivotingStop)" />
          <event value="119"    symbol="PLACECARD_NBHOOD_QUERYRESULTS_START"    channel="Default"       task="PLACECARD_NBHOOD_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlaceCardNbhoodQueryResultsStart)" />
          <event value="120"    symbol="PLACECARD_NBHOOD_QUERYRESULTS_STOP"     channel="Default"       task="PLACECARD_NBHOOD_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardNbhoodQueryResultsStop)" />
          <event value="121"    symbol="PLACECARD_REVIEWS_QUERYRESULTS_START"   channel="Default"       task="PLACECARD_REVIEWS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlaceCardReviewsQueryResultsStart)" />
          <event value="122"    symbol="PLACECARD_REVIEWS_QUERYRESULTS_STOP"    channel="Default"       task="PLACECARD_REVIEWS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardReviewsQueryResultsStop)"/>
          <event value="123"    symbol="MAPS_SEARCH_QUERYRESULTS_START"         channel="Default"       task="MAPS_SEARCH_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsSearchQueryResultsStart)" />
          <event value="124"    symbol="MAPS_SEARCH_QUERYRESULTS_STOP"          channel="Default"       task="MAPS_SEARCH_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsSearchQueryResultsStop)" />
          <event value="125"    symbol="MAPS_DIRECTIONS_QUERYRESULTS_START"     channel="Default"       task="MAPS_DIRECTIONS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsDirectionsQueryResultsStart)" />
          <event value="126"    symbol="MAPS_DIRECTIONS_QUERYRESULTS_STOP"      channel="Default"       task="MAPS_DIRECTIONS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsDirectionsQueryResultsStop)" />
          <event value="127"    symbol="MAPS_DIRECTIONS_PAGE"                   channel="Default"       task="MAPS_DIRECTIONS_PAGE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.MapsDirectionsPage)" />
          <event value="128"    symbol="MAPS_DIRECTIONS_MAPTEASE_UPDATE_START"  channel="Default"       task="MAPS_DIRECTIONS_MAPTEASE_UPDATE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsDirectionsMapteaseUpdateStart)" />
          <event value="129"    symbol="MAPS_DIRECTIONS_MAPTEASE_UPDATE_STOP"   channel="Default"       task="MAPS_DIRECTIONS_MAPTEASE_UPDATE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsDirectionsMapteaseUpdateStop)" />
          <event value="130"    symbol="MAPS_LOCATE_ME_START"                   channel="Default"       task="MAPS_LOCATE_ME"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsLocateMeStart)" />
          <event value="131"    symbol="MAPS_LOCATE_ME_STOP"                    channel="Default"       task="MAPS_LOCATE_ME"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsLocateMeStop)" />
          <event value="132"    symbol="MAPS_ZOOM_IN_START"                     channel="Default"       task="MAPS_ZOOM_IN"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsZoomInStart)" />
          <event value="133"    symbol="MAPS_ZOOM_IN_STOP"                      channel="Default"       task="MAPS_ZOOM_IN"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsZoomInStop)" />
          <event value="134"    symbol="MAPS_ZOOM_OUT_START"                    channel="Default"       task="MAPS_ZOOM_OUT"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsZoomOutStart)" />
          <event value="135"    symbol="MAPS_ZOOM_OUT_STOP"                     channel="Default"       task="MAPS_ZOOM_OUT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsZoomOutStop)" />
          <event value="138"    symbol="SEARCH_LOCATIONNAME_UPDATED"            channel="Default"       task="SEARCH_LOCATIONNAME_UPDATED"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.LocationNameUpdated)" />
          <event value="139"    symbol="SEARCH_HOTSPOT_REFRESHED"               channel="Default"       task="SEARCH_HOTSPOT_REFRESHED"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.HotSpotRefreshed)" />
          <event value="140"    symbol="PLACECARD_NAVIGATION_START"             channel="Default"       task="PLACECARD_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.PlaceCardNavigationStart)" />
          <event value="141"    symbol="PLACECARD_NAVIGATION_STOP"              channel="Default"       task="PLACECARD_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardNavigationStop)" />
          <event value="142"    symbol="SEARCH_RESULTS_LIST_UPDATED"            channel="Default"       task="SEARCH_RESULTS_LIST_UPDATED"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchResultsListUpdated)" />
          <event value="143"    symbol="MAPS_SEARCH_INVOKED"                    channel="Default"       task="MAPS_SEARCH_INVOKED"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.MapsSearchInvoked)" />
          <event value="144"    symbol="MAPS_SEARCH_SUGGESTIONBAR_DISPLAYED"    channel="Default"       task="MAPS_SEARCH_SUGGESTIONBAR_DISPLAYED"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.MapsSearchSuggestBarDisplayed)" />
          <event value="145"    symbol="MAPS_SEARCH_AUTOSUGGEST_UPDATED"        channel="Default"       task="MAPS_SEARCH_AUTOSUGGEST_UPDATED"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.MapsSearchAutoSuggestUpdated)" />
          <event value="146"    symbol="MAPS_DATA_SERIALIZE_START"              channel="Default"       task="MAPS_DATA_SERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsDataSerializeStart)" />
          <event value="147"    symbol="MAPS_DATA_SERIALIZE_STOP"               channel="Default"       task="MAPS_DATA_SERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsDataSerializeStop)" />
          <event value="148"    symbol="MAPS_DATA_DESERIALIZE_START"            channel="Default"       task="MAPS_DATA_DESERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsDataDeserializeStart)" />
          <event value="149"    symbol="MAPS_DATA_DESERIALIZE_STOP"             channel="Default"       task="MAPS_DATA_DESERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsDataDeserializeStop)" />
          <event value="150"    symbol="MAPS_DIRECTIONS_INVOKED"                channel="Default"       task="MAPS_DIRECTIONS_INVOKED"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.MapsDirectionsInvoked)" />
          <event value="151"    symbol="MAPS_DIRECTIONS_ZOOMADJUST_COMPLETE"    channel="Default"       task="MAPS_DIRECTIONS_ZOOMADJUST_COMPLETE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.MapsDirectionsZoomAdjustComplete)" />
          <event value="152"    symbol="LOCATION_REQUEST_START"                 channel="Default"       task="LOCATION_REQUEST"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.LocationRequestStart)" />
          <event value="153"    symbol="LOCATION_REQUEST_STOP"                  channel="Default"       task="LOCATION_REQUEST"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.LocationRequestStop)" />
          <event value="154"    symbol="LOCATION_DATA_UPDATED"                  channel="Default"       task="LOCATION_DATA_UPDATED"
              keywords="Performance" level="win:Informational" opcode="win:Info"         message="$(string.WebSearch.LocationDataUpdated)" />
          <event value="155"    symbol="PAGE_NAVIGATEDTO_START"                 channel="Default"       task="PAGE_NAVIGATEDTO"
              keywords="Performance" level="win:Verbose"       opcode="win:Start"       message="$(string.WebSearch.PageNavigatedToStart)" />
          <event value="156"    symbol="PAGE_NAVIGATEDTO_STOP"                  channel="Default"       task="PAGE_NAVIGATEDTO"
              keywords="Performance" level="win:Verbose"       opcode="win:Stop"        message="$(string.WebSearch.PageNavigatedToStop)" />
          <event value="157"    symbol="PAGE_NAVIGATINGAWAY_START"              channel="Default"       task="PAGE_NAVIGATINGAWAY"
              keywords="Performance" level="win:Verbose"       opcode="win:Start"       message="$(string.WebSearch.PageNavigatingAwayStart)" />
          <event value="158"    symbol="PAGE_NAVIGATINGAWAY_STOP"               channel="Default"       task="PAGE_NAVIGATINGAWAY"
              keywords="Performance" level="win:Verbose"       opcode="win:Stop"        message="$(string.WebSearch.PageNavigatingAwayStop)" />
          <event value="159"    symbol="TASK_PAUSING_START"                     channel="Default"       task="TASK_PAUSING"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.TaskPausingStart)" />
          <event value="160"    symbol="TASK_PAUSING_STOP"                      channel="Default"       task="TASK_PAUSING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.TaskPausingStop)" />
          <event value="161"    symbol="TASK_RESUMING_START"                    channel="Default"       task="TASK_RESUMING"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.TaskResumingStart)" />
          <event value="162"    symbol="TASK_RESUMING_STOP"                     channel="Default"       task="TASK_RESUMING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.TaskResumingStop)" />
          <event value="173"    symbol="SEARCH_DATA_SERIALIZE_START"            channel="Default"       task="SEARCH_DATA_SERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.SearchDataSerializeStart)" />
          <event value="174"    symbol="SEARCH_DATA_SERIALIZE_STOP"             channel="Default"       task="SEARCH_DATA_SERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.SearchDataSerializeStop)" />
          <event value="175"    symbol="SEARCH_DATA_DESERIALIZE_START"          channel="Default"       task="SEARCH_DATA_DESERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.SearchDataDeserializeStart)" />
          <event value="176"    symbol="SEARCH_DATA_DESERIALIZE_STOP"           channel="Default"       task="SEARCH_DATA_DESERIALIZE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.SearchDataDeserializeStop)" />
          <event value="177"    symbol="MAPS_ROUTE_GENERALIZATION_START"        channel="Default"       task="MAPS_ROUTE_GENERALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.RouteGeneralizationStart)" />
          <event value="178"    symbol="MAPS_ROUTE_GENERALIZATION_STOP"         channel="Default"       task="MAPS_ROUTE_GENERALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.RouteGeneralizationStop)" />
          <event value="179"    symbol="MAPS_ROUTE_SPATIAL_SORT_START"          channel="Default"       task="MAPS_ROUTE_SPATIAL_SORT"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.RouteSpatialSortStart)" />
          <event value="180"    symbol="MAPS_ROUTE_SPATIAL_SORT_STOP"           channel="Default"       task="MAPS_ROUTE_SPATIAL_SORT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.RouteSpatialSortStop)" />
          <event value="181"    symbol="MAPS_MEPOI_REVERSE_GEOCODE_KICKOFF"     channel="Default"       task="MAPS_MEPOI_REVERSE_GEOCODE"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.MapsMePOIReverseGeocode)" />
          <event value="182"    symbol="MAPS_DIRECTIONS_INITIAL_LOC_REQUEST"    channel="Default"       task="MAPS_DIRECTIONS_WARMUP_LOCATION_REQUEST"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.MapsDirectionsWarmupLocRequest)" />
          <event value="183"    symbol="MAPS_DIRECTIONS_GET_DIRECTIONS"         channel="Default"       task="MAPS_DIRECTIONS_QUERY_SUBMIT"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.MapsGetDirections)" />
          <event value="184"    symbol="MAPS_DIRECTIONS_SUBMIT_LOC_REQUEST"     channel="Default"       task="MAPS_DIRECTIONS_SUBMIT_LOCATION_REQUEST"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.MapsDirectionsLocRequestOnSubmit)" />
          <event value="185"    symbol="MAPS_DIRECTIONS_ACC_LOC_RESPONSE"       channel="Default"       task="MAPS_DIRECTIONS_ACCURATE_LOCATION_RESPONSE"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.MapsDirectionsAccurateLocationResponse)" />
          <event value="186"    symbol="PLACECARD_MOVIES_PANE"                  channel="Default"       task="PLACECARD_MOVIES_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.PlaceCardMoviesPane)" />
          <event value="187"    symbol="PLACECARD_EXTRAS_PANE"                  channel="Default"       task="PLACECARD_EXTRAS_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.PlaceCardExtrasPane)" />
          <event value="188"    symbol="PLACECARD_EVENTS_QUERYRESULTS_START"    channel="Default"       task="PLACECARD_EVENTS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlaceCardEventsQueryResultsStart)" />
          <event value="189"    symbol="PLACECARD_EVENTS_QUERYRESULTS_STOP"     channel="Default"       task="PLACECARD_EVENTS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardEventsQueryResultsStop)"/>
          <event value="190"    symbol="PLACECARD_MOVIES_QUERYRESULTS_START"    channel="Default"       task="PLACECARD_MOVIES_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlaceCardMoviesQueryResultsStart)" />
          <event value="191"    symbol="PLACECARD_MOVIES_QUERYRESULTS_STOP"     channel="Default"       task="PLACECARD_MOVIES_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardMoviesQueryResultsStop)"/>
          <event value="192"    symbol="PLACECARD_MOVIEDETAILS_QUERYRESULTS_START"   channel="Default"  task="PLACECARD_MOVIEDETAILS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlaceCardMovieDetailsQueryResultsStart)" />
          <event value="193"    symbol="PLACECARD_MOVIEDETAILS_QUERYRESULTS_STOP"    channel="Default"  task="PLACECARD_MOVIEDETAILS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardMovieDetailsQueryResultsStop)"/>
          <event value="194"    symbol="PLACECARD_EXTRAS_QUERYRESULTS_START"    channel="Default"       task="PLACECARD_EXTRAS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlaceCardExtrasQueryResultsStart)" />
          <event value="195"    symbol="PLACECARD_EXTRAS_QUERYRESULTS_STOP"     channel="Default"       task="PLACECARD_EXTRAS_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlaceCardExtrasQueryResultsStop)"/>
          <event value="196"    symbol="PLACESCENTER_NAVIGATION_START"             channel="Default"       task="PLACESCENTER_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PlacesCenterNavigationStart)" />
          <event value="197"    symbol="PLACESCENTER_NAVIGATION_STOP"              channel="Default"       task="PLACESCENTER_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PlacesCenterNavigationStop)" />

          <!-- Navigation events -->
          <event value="200"    symbol="PAGE_NAVIGATEDTO"
              task="PAGE_NAVIGATION"            opcode="NavigatedTo"
              template="PageID"                 message="$(string.WebSearch.PageNavigatedTo)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="201"    symbol="PAGE_NAVIGATINGAWAY"
              task="PAGE_NAVIGATION"            opcode="NavigatingAway"
              template="PageID"                 message="$(string.WebSearch.PageNavigatingAway)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="202"      symbol="PAGE_CLOSING"
              task="PAGE_NAVIGATION"            opcode="Closing"
              template="PageID"                 message="$(string.WebSearch.PageNavigatingAway)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="203"      symbol="PAGE_STARTNAVIGATION"
              task="PAGE_NAVIGATION"            opcode="StartNavigation"
              template="PageID"                 message="$(string.WebSearch.PageStartNavigation)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="209"      symbol="PAGE_INITIALIZED"
              task="PAGE_NAVIGATION"            opcode="PageInitialized"
              template="PageID"                 message="$(string.WebSearch.PageInitialized)"
              channel="Default"   level="win:Informational"   keywords="Performance"/>
          <event value="204"    symbol="TASK_STARTING"
              task="TASK_MODEL"                 opcode="win:Start"
              template="TaskIDAndName"          message="$(string.WebSearch.TaskStarting)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="205"    symbol="TASK_ENDING"
              task="TASK_MODEL"                 opcode="win:Stop"
              template="TaskID"                 message="$(string.WebSearch.TaskEnding)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="206"    symbol="TASK_PAUSING"
              task="TASK_MODEL"                 opcode="win:Suspend"
              template="TaskID"                 message="$(string.WebSearch.TaskPausing)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="207"    symbol="TASK_RESUMING"
              task="TASK_MODEL"                 opcode="win:Resume"
              template="TaskID"                 message="$(string.WebSearch.TaskResuming)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="208"    symbol="TASK_REHYDRATING"
              task="TASK_MODEL"                 opcode="Rehydrate"
              template="TaskIDAndName"          message="$(string.WebSearch.TaskHydrating)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="210"    symbol="TASK_DEHYDRATING"
              task="TASK_MODEL"                 opcode="Dehydrate"
              message="$(string.WebSearch.TaskDehydrating)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>
          <event value="211"    symbol="TASK_ACTIVECOUNT"
              task="TASK_MODEL"                 opcode="ActiveTaskCount"
              template="ActiveTaskCount" message="$(string.WebSearch.ActiveTaskCount)"
              channel="Default"   level="win:Informational"   keywords="Debug Navigation"/>

          <!-- Location service events -->
          <event value="220"    symbol="LOCATION_SERVICE_ERROR"
              task="LOCATION_SERVICE"           opcode="Error"
              template="HResultAndErrorCode"    message="$(string.WebSearch.LocationServiceError)"
              channel="Default"   level="win:Error"           keywords="Debug Location"/>
          <event value="221"    symbol="LOCATION_CURRENT_START"
              task="LOCATION_CURRENT"           opcode="win:Start"
              template="Context"                message="$(string.WebSearch.LocationCurrentStart)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="222"    symbol="LOCATION_CURRENT_DONE"
              task="LOCATION_CURRENT"           opcode="win:Stop"
              message="$(string.WebSearch.LocationCurrentDone)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="223"    symbol="LOCATION_CURRENT_CALLBACK"
              task="LOCATION_CURRENT"           opcode="Callback"
              template="LocationCallback"       message="$(string.WebSearch.LocationCurrentCallback)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="224"    symbol="LOCATION_CURRENT_REVERSEGEOCODE"
              task="LOCATION_CURRENT"           opcode="ReverseGeocode"
              template="String"                 message="$(string.WebSearch.LocationCurrentReverseGeocode)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="225"    symbol="LOCATION_CURRENT_UPDATE"
              task="LOCATION_CURRENT"           opcode="Update"
              template="Boolean"                message="$(string.WebSearch.LocationCurrentUpdate)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="226"    symbol="LOCATION_TRACKING_START"
              task="LOCATION_TRACKING"          opcode="win:Start"
              template="Context"                message="$(string.WebSearch.LocationTrackingStart)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="227"    symbol="LOCATION_TRACKING_STOP"
              task="LOCATION_TRACKING"          opcode="win:Stop"
              message="$(string.WebSearch.LocationTrackingStop)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="228"    symbol="LOCATION_TRACKING_CALLBACK"
              task="LOCATION_TRACKING"          opcode="Callback"
              template="LocationCallback"       message="$(string.WebSearch.LocationTrackingCallback)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>
          <event value="229"    symbol="LOCATION_TRACKING_UPDATE"
              task="LOCATION_TRACKING"          opcode="Update"
              message="$(string.WebSearch.LocationTrackingUpdate)"
              channel="Default"   level="win:Informational"   keywords="Debug Location"/>

          <!-- CSM event -->
          <event value="250"    symbol="CSM_LOCATION_SHIFTED"
              task="CSM_LOCATION_SHIFTED"          opcode="win:Info"
              message="$(string.WebSearch.CsmLocationShifted)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>

          <!-- Map events -->
          <event value="290"      symbol="MAPS_ZOOM_IN_INFO"
              task="MAPS_ZOOM_IN"               opcode="win:Info"
              template="MapZoomInInfo"          message="$(string.WebSearch.MapsZoomInInfo)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="136"      symbol="MAPS_PAN_START"
              task="MAPS_PAN"                   opcode="win:Start"
              message="$(string.WebSearch.MapsPanStart)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="137"      symbol="MAPS_PAN_STOP"
              task="MAPS_PAN"                   opcode="win:Stop"
              message="$(string.WebSearch.MapsPanStop)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="291"      symbol="MAPS_PAN_FLICK"
              task="MAPS_PAN"                   opcode="Flick"
              message="$(string.WebSearch.MapsPanFlick)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="292"      symbol="MAPS_PAN_OVERSCROLL"
              task="MAPS_PAN"                   opcode="OverScroll"
              message="$(string.WebSearch.MapsPanOverScroll)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="293"      symbol="MAPS_PINCHSTRETCH_START"
              task="MAPS_PINCHSTRETCH"          opcode="win:Start"
              template="Vector2"                message="$(string.WebSearch.MapsPinchStretchStart)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="294"      symbol="MAPS_PINCHSTRETCH_STOP"
              task="MAPS_PINCHSTRETCH"          opcode="win:Stop"
              message="$(string.WebSearch.MapsPinchStretchStop)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="295"      symbol="MAPS_PINCHSTRETCH_SCALE"
              task="MAPS_PINCHSTRETCH"          opcode="Scale"
              template="Float"                  message="$(string.WebSearch.MapsPinchStretchScale)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="296"      symbol="MAPS_PINCHSTRETCH_DRAG"
              task="MAPS_PINCHSTRETCH"          opcode="Drag"
              template="Vector2"                message="$(string.WebSearch.MapsPinchStretchDrag)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="297"      symbol="MAPS_ANIMATION_START"
              task="MAPS_ANIMATION"          opcode="win:Start"
              message="$(string.WebSearch.MapsAnimationStart)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="298"      symbol="MAPS_ANIMATION_STOP"
              task="MAPS_ANIMATION"          opcode="win:Stop"
              message="$(string.WebSearch.MapsAnimationStop)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="299"      symbol="MAPS_ANIMATION_ZOOMINFO"
              task="MAPS_ANIMATION"          opcode="ZoomInfo"
              template="MapAnimationZoomInfo"    message="$(string.WebSearch.MapsAnimationZoomInfo)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="300"      symbol="MAPS_ANIMATION_TIMINGINFO"
              task="MAPS_ANIMATION"          opcode="TimingInfo"
              template="MapAnimationTimingInfo"  message="$(string.WebSearch.MapsAnimationTimingInfo)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="301"      symbol="MAPS_GRAPHIC_RESOLVED"
              task="MAPS_GRAPHIC_RESOLVED"      opcode="win:Info"
              template="Boolean"                message="$(string.WebSearch.MapsGraphicResolved)"
              channel="Default"   level="win:Informational"   keywords="Debug Performance"/>

          <!-- Search events -->
          <event value="302"      symbol="SEARCH_DOMAIN_COUNT"
              task="SEARCH_QUERYRESULTS"         opcode="win:Info"
              template="StringKeyValuePair"      message="$(string.WebSearch.SearchDomainCount)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="303"      symbol="SEARCH_QUERY_TERM"
              task="SEARCH_QUERYRESULTS"         opcode="win:Info"
              template="String"                  message="$(string.WebSearch.SearchQuery)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="304"      symbol="SEARCH_QUERY_LOCATION"
              task="SEARCH_QUERYRESULTS"         opcode="win:Info"
              template="StringKeyValuePair"      message="$(string.WebSearch.SearchLocation)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="305"      symbol="SEARCH_QUERY_LOCALE"
              task="SEARCH_QUERYRESULTS"         opcode="win:Info"
              template="String"                  message="$(string.WebSearch.SearchLocale)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="306"      symbol="SEARCH_QUERY_SERVICE_PROVIDER_STATUS"
              task="SEARCH_QUERYRESULTS"         opcode="Update"
              template="String"                  message="$(string.WebSearch.SearchServiceProviderStatus)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>

          <!-- Search Performance Markers -->
          <event value="350"    symbol="SEARCH_IMAGE_PAGE"                      channel="Default"       task="SEARCH_IMAGE_PAGE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchImagePage)" />
          <event value="351"    symbol="SEARCH_MORE_PAGE"                       channel="Default"       task="SEARCH_MORE_PAGE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchMorePage)" />
          <event value="352"    symbol="SEARCH_MORE_QUERYRESULTS_START"         channel="Default"       task="SEARCH_MORE_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.SearchMoreQueryResultsStart)" />
          <event value="353"    symbol="SEARCH_MORE_QUERYRESULTS_STOP"          channel="Default"       task="SEARCH_MORE_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.SearchMoreQueryResultsStop)" />
          <event value="354"    symbol="SEARCH_IMAGE_PREVIEW"                   channel="Default"       task="SEARCH_IMAGE_PREVIEW"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.SearchImagePreview)" />

          <event value="360"    symbol="HOSE_SEARCH_QUERY_START"                channel="Default"       task="HOSE_SEARCH_QUERY"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HoseSearchQueryStart)"/>
          <event value="361"    symbol="HOSE_SEARCH_QUERY_STOP"                 channel="Default"       task="HOSE_SEARCH_QUERY"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HoseSearchQueryStop)"/>
          <event value="362"    symbol="HOSE_QUERYRESULTS"                      channel="Default"       task="HOSE_QUERYRESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.HoseQueryResults)"/>
          <event value="363"    symbol="HOSE_QUICKCARD"                         channel="Default"       task="HOSE_QUICKCARD"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.HoseQuickCard)"/>
          <event value="364"    symbol="HOSE_MORERESULTS"                       channel="Default"       task="HOSE_MORERESULTS"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.HoseMoreResults)"/>
          <event value="365"    symbol="HOSE_PAGE_DOWNLOADED_START"             channel="Default"       task="HOSE_PAGE_DOWNLOADED"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HosePageDownloadedStart)"
              template="String"/>
          <event value="366"    symbol="HOSE_PAGE_DOWNLOADED_STOP"              channel="Default"       task="HOSE_PAGE_DOWNLOADED"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HosePageDownloadedStop)"
              template="String"/>
          <event value="367"    symbol="HOSE_PAGE_SHOWPIVOT_START"              channel="Default"       task="HOSE_PAGE_SHOWPIVOT"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HosePageShowPivotStart)"
              template="String"/>
          <event value="368"    symbol="HOSE_PAGE_SHOWPIVOT_STOP"               channel="Default"       task="HOSE_PAGE_SHOWPIVOT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HosePageShowPivotStop)"
              template="String"/>
          <event value="369"    symbol="HOSE_PAGE_PANE"                        channel="Default"       task="HOSE_PAGE_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.HosePagePane)"
              template="String"/>
          <event value="370"    symbol="HOSE_SEARCH_APPCONNECT_PROCESSING_START" channel="Default"      task="HOSE_SEARCH_APPCONNECT_PROCESSING"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HoseSearchAppConnectProcessingStart)"/>
          <event value="371"    symbol="HOSE_SEARCH_APPCONNECT_PROCESSING_STOP"  channel="Default"      task="HOSE_SEARCH_APPCONNECT_PROCESSING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HoseSearchAppConnectProcessingStop)"/>
          <event value="372"    symbol="HOSE_PAGE_ERROR"                         channel="Default"       task="HOSE_PAGE_ERROR"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.HosePageError)"
              template="String"/>
          <event value="373"    symbol="HOSE_GENRATE_PLACE_TILE_START"           channel="Default"       task="HOSE_GENRATE_PLACE_TILE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HosePlaceTileStart)"
              template="String"/>
          <event value="374"    symbol="HOSE_GENRATE_PLACE_TILE_STOP"            channel="Default"       task="HOSE_GENRATE_PLACE_TILE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HosePlaceTileStop)"
              template="String"/>
          <event value="375"    symbol="HOSE_DOWNLOAD_QC_TILE_START"           channel="Default"       task="HOSE_DOWNLOAD_QC_TILE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HoseQuickCardTileDownloadStart)"
              template="String"/>
          <event value="376"    symbol="HOSE_DOWNLOAD_QC_TILE_STOP"            channel="Default"       task="HOSE_DOWNLOAD_QC_TILE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HoseQuickCardTileDownloadStop)"
              template="String"/>
          <event value="377"    symbol="HOSE_MAPS_ACQUIRE_MAP_START"           channel="Default"      task="HOSE_MAPS_ACQUIRE_MAP"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HoseSearchMapsAcquireMapStart)"/>
          <event value="378"    symbol="HOSE_MAPS_ACQUIRE_MAP_STOP"             channel="Default"      task="HOSE_MAPS_ACQUIRE_MAP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HoseSearchMapsAcquireMapStop)"/>
          <event value="379"    symbol="HOSE_MAPS_POI_OVERLAY_START"           channel="Default"      task="HOSE_MAPS_OVERLAY_POIS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HoseSearchMapsOverlayPoisStart)"/>
          <event value="380"    symbol="HOSE_MAPS_POI_OVERLAY_STOP"             channel="Default"     task="HOSE_MAPS_OVERLAY_POIS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HoseSearchMapsOverlayPoisStop)"/>

          <event value="381"    symbol="HOSE_ACTION_URI_INVOKED_START"           channel="Default"      task="HOSE_ACTION_URI"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.HoseActionUriInvokedStart)"
              template="String"/>
          <event value="382"    symbol="HOSE_ACTION_URI_INVOKED_STOP"             channel="Default"     task="HOSE_ACTION_URI"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.HoseActionUriInvokedStop)"
              template="String"/>
          <event value="383"    symbol="HOSE_THEME_REFRESH"             channel="Default"     task="HOSE_THEME_REFRESH"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.HoseThemeRefresh)"/>


          <!-- event card markers -->
          <event value="400"    symbol="EVENTCARD_ABOUT_PANE"                    channel="Default"       task="EVENTCARD_ABOUT_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.EventCardAboutPane)" />
          <event value="401"    symbol="EVENTCARD_EXTRAS_PANE"                  channel="Default"       task="EVENTCARD_EXTRAS_PANE"
              keywords="Performance" level="win:Informational" opcode="win:Info"        message="$(string.WebSearch.EventCardExtrasPane)" />
          <event value="402"    symbol="EVENTCARD_PIVOTING_START"               channel="Default"       task="EVENTCARD_PIVOTING"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.EventCardPivotingStart)" />
          <event value="403"    symbol="EVENTCARD_PIVOTING_STOP"                channel="Default"       task="EVENTCARD_PIVOTING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.EventCardPivotingStop)" />
          <event value="404"    symbol="EVENTCARD_NAVIGATION_START"             channel="Default"       task="EVENTCARD_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.EventCardNavigationStart)" />
          <event value="405"    symbol="EVENTCARD_NAVIGATION_STOP"              channel="Default"       task="EVENTCARD_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.EventCardNavigationStop)" />
          <event value="406"    symbol="EVENTCARD_TICKETPROVIDERS_NAVIGATION_START"             channel="Default"       task="EVENTCARD_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.EventCardTicketProvidersNavigationStart)" />
          <event value="407"    symbol="EVENTCARD_TICKETPROVIDERS_NAVIGATION_STOP"              channel="Default"       task="EVENTCARD_NAVIGATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.EventCardTicketProvidersNavigationStop)" />

          <!-- Bing Configuration Markers -->
          <event value="450"                        symbol="CONFIGURATION_UPDATE_START"
              task="CONFIGURATION_UPDATE"           opcode="win:Start"
              message="$(string.WebSearch.ConfigurationUpdateStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="451"                        symbol="CONFIGURATION_UPDATE_STOP"
              task="CONFIGURATION_UPDATE"           opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationUpdateStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="452"                        symbol="CONFIGURATION_DOWNLOAD_START"
              task="CONFIGURATION_DOWNLOAD"         opcode="win:Start"
              message="$(string.WebSearch.ConfigurationDownloadStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="453"                        symbol="CONFIGURATION_DOWNLOAD_STOP"
              task="CONFIGURATION_DOWNLOAD"         opcode="win:Stop"      template="HResultAndErrorCode"
              message="$(string.WebSearch.ConfigurationDownloadStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="454"                        symbol="CONFIGURATION_PARSE_START"
              task="CONFIGURATION_PARSE"            opcode="win:Start"
              message="$(string.WebSearch.ConfigurationParseStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="455"                        symbol="CONFIGURATION_PARSE_STOP"
              task="CONFIGURATION_PARSE"            opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationParseStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="456"                        symbol="CONFIGURATION_LOAD_CATEGORIES_START"
              task="CONFIGURATION_LOAD_CATEGORIES"  opcode="win:Start"
              message="$(string.WebSearch.ConfigurationLoadCategoriesStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="457"                        symbol="CONFIGURATION_LOAD_CATEGORIES_STOP"
              task="CONFIGURATION_LOAD_CATEGORIES"  opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationLoadCategoriesStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="458"                        symbol="CONFIGURATION_LOAD_LOCALE_START"
              task="CONFIGURATION_LOAD_LOCALE"      opcode="win:Start"      template="String"
              message="$(string.WebSearch.ConfigurationLoadLocaleStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="459"                        symbol="CONFIGURATION_LOAD_LOCALE_STOP"
              task="CONFIGURATION_LOAD_LOCALE"      opcode="win:Stop"      template="TaggedHResult"
              message="$(string.WebSearch.ConfigurationLoadLocaleStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="460"                        symbol="CONFIGURATION_SAVE_START"
              task="CONFIGURATION_SAVE"             opcode="win:Start"      template="String"
              message="$(string.WebSearch.ConfigurationSaveStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="461"                        symbol="CONFIGURATION_SAVE_STOP"
              task="CONFIGURATION_SAVE"             opcode="win:Stop"      template="TaggedHResult"
              message="$(string.WebSearch.ConfigurationSaveStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="462"                        symbol="CONFIGURATION_SAVE_CATEGORIES_START"
              task="CONFIGURATION_SAVE_CATEGORIES"  opcode="win:Start"
              message="$(string.WebSearch.ConfigurationSaveCategoriesStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="463"                        symbol="CONFIGURATION_SAVE_CATEGORIES_STOP"
              task="CONFIGURATION_SAVE_CATEGORIES"  opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationSaveCategoriesStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="464"                        symbol="CONFIGURATION_SAVE_LOCALES_START"
              task="CONFIGURATION_SAVE_LOCALES"     opcode="win:Start"
              message="$(string.WebSearch.ConfigurationSaveLocalesStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="465"                        symbol="CONFIGURATION_SAVE_LOCALES_STOP"
              task="CONFIGURATION_SAVE_LOCALES"     opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationSaveLocalesStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="466"                        symbol="CONFIGURATION_SAVE_LOCALE_START"
              task="CONFIGURATION_SAVE_LOCALE"      opcode="win:Start"      template="String"
              message="$(string.WebSearch.ConfigurationSaveLocaleStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="467"                        symbol="CONFIGURATION_SAVE_LOCALE_STOP"
              task="CONFIGURATION_SAVE_LOCALE"      opcode="win:Stop"      template="TaggedHResult"
              message="$(string.WebSearch.ConfigurationSaveLocaleStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="468"                        symbol="CONFIGURATION_LOAD_START"
              task="CONFIGURATION_LOAD"             opcode="win:Start"      template="String"
              message="$(string.WebSearch.ConfigurationLoadStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="469"                        symbol="CONFIGURATION_LOAD_STOP"
              task="CONFIGURATION_LOAD"             opcode="win:Stop"      template="TaggedHResult"
              message="$(string.WebSearch.ConfigurationLoadStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="470"                        symbol="CONFIGURATION_PARSE_ERROR"
              task="CONFIGURATION_PARSE"            opcode="Error"         template="TaggedHResult"
              message="$(string.WebSearch.ConfigurationParseError)"
              channel="Default"   level="win:Error"           keywords="Debug"/>

          <event value="471"                        symbol="CONFIGURATION_LOAD_PROPERTY_START"
              task="CONFIGURATION_LOAD_PROPERTY" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationLoadPropertyStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="472"                        symbol="CONFIGURATION_LOAD_PROPERTY_STOP"
              task="CONFIGURATION_LOAD_PROPERTY" opcode="win:Stop"      template="TaggedHResult"
              message="$(string.WebSearch.ConfigurationLoadPropertyStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="473"                        symbol="CONFIGURATION_SAVE_PROPERTY_START"
              task="CONFIGURATION_SAVE_PROPERTY" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationSavePropertyStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="474"                        symbol="CONFIGURATION_SAVE_PROPERTY_STOP"
              task="CONFIGURATION_SAVE_PROPERTY" opcode="win:Stop"      template="TaggedHResult"
              message="$(string.WebSearch.ConfigurationSavePropertyStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>


          <event value="475"                        symbol="CONFIGURATION_LOAD_LOCALE_NONOSS_ENDPOINT_START"
              task="CONFIGURATION_LOAD_LOCALE_NONOSS_ENDPOINT" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationLoadLocaleNonOssEndpointStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="476"                        symbol="CONFIGURATION_LOAD_LOCALE_NONOSS_ENDPOINT_STOP"
              task="CONFIGURATION_LOAD_LOCALE_NONOSS_ENDPOINT" opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationLoadLocaleNonOssEndpointStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="477"                        symbol="CONFIGURATION_SAVE_LOCALE_NONOSS_ENDPOINT_START"
              task="CONFIGURATION_SAVE_LOCALE_NONOSS_ENDPOINT" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationSaveLocaleNonOssEndpointStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="478"                        symbol="CONFIGURATION_SAVE_LOCALE_NONOSS_ENDPOINT_STOP"
              task="CONFIGURATION_SAVE_LOCALE_NONOSS_ENDPOINT" opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationSaveLocaleNonOssEndpointStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>


          <event value="479"                        symbol="CONFIGURATION_LOAD_PREFIX_LIST_START"
              task="CONFIGURATION_LOAD_PREFIX_LIST" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationLoadPrefixListStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="480"                        symbol="CONFIGURATION_LOAD_PREFIX_LIST_STOP"
              task="CONFIGURATION_LOAD_PREFIX_LIST" opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationLoadPrefixListStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="481"                        symbol="CONFIGURATION_SAVE_PREFIX_LIST_START"
              task="CONFIGURATION_SAVE_PREFIX_LIST" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationSavePrefixListStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="482"                        symbol="CONFIGURATION_SAVE_PREFIX_LIST_STOP"
              task="CONFIGURATION_SAVE_PREFIX_LIST" opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationSavePrefixListStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>

          <event value="483"                        symbol="CONFIGURATION_LOAD_APP_LIST_START"
              task="CONFIGURATION_LOAD_APP_LIST" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationLoadAppListStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="484"                        symbol="CONFIGURATION_LOAD_APP_LIST_STOP"
              task="CONFIGURATION_LOAD_APP_LIST" opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationLoadAppListStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="485"                        symbol="CONFIGURATION_SAVE_APP_LIST_START"
              task="CONFIGURATION_SAVE_APP_LIST" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationSaveAppListStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="486"                        symbol="CONFIGURATION_SAVE_APP_LIST_STOP"
              task="CONFIGURATION_SAVE_APP_LIST" opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationSaveAppListStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>


          <event value="487"                        symbol="CONFIGURATION_SAVE_OSS_ENDPOINT_START"
              task="CONFIGURATION_SAVE_OSS_ENDPOINT" opcode="win:Start"
              message="$(string.WebSearch.ConfigurationSaveOssEndpointStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="488"                        symbol="CONFIGURATION_SAVE_OSS_ENDPOINT_STOP"
              task="CONFIGURATION_SAVE_OSS_ENDPOINT" opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationSaveOssEndpointStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>

          <event value="489"                        symbol="CONFIGURATION_BACKGROUND_WORKER_RUN_START"
              task="CONFIGURATION_BACKGROUND_WORKER_RUN"           opcode="win:Start"
              message="$(string.WebSearch.ConfigurationBackgroundWorkerRunStart)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>
          <event value="490"                        symbol="CONFIGURATION_BACKGROUND_WORKER_RUN_STOP"
              task="CONFIGURATION_BACKGROUND_WORKER_RUN"           opcode="win:Stop"      template="HResult"
              message="$(string.WebSearch.ConfigurationBackgroundWorkerRunStop)"
              channel="Default"   level="win:Informational"   keywords="Performance Debug"/>

          <!-- Instruementation events -->
          <event value="501"    symbol="INSTRUMENTATION_USER_ID_RECEIVED"             channel="Default"       task="INSTRUMENTATION_USER_ID_RECEIVED"
              keywords="Debug"  level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.InstrumentationUserIdReceived)" />
          <event value="502"    symbol="INSTRUMENTATION_ACTIVATION_SUCCESS_SENT"      channel="Default"       task="INSTRUMENTATION_ACTIVATION_SUCCESS_SENT"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationActivationSuccessSent)" />
          <event value="503"    symbol="INSTRUMENTATION_LAYOUT_SENT"                  channel="Default"       task="INSTRUMENTATION_LAYOUT_SENT"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationLayoutSent)" />
          <event value="504"    symbol="INSTRUMENTATION_PARTIAL_IMPRESSION_SENT"      channel="Default"       task="INSTRUMENTATION_PARTIAL_IMPRESSION_SENT"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationPartialImpressionSent)" />
          <event value="505"    symbol="INSTRUMENTATION_CLICK_EVENT_SENT"             channel="Default"       task="INSTRUMENTATION_CLICK_EVENT_SENT"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationClickEventSent)" />
          <event value="506"    symbol="INSTRUMENTATION_BATCHED_LAYOUT_SENT"          channel="Default"       task="INSTRUMENTATION_BATCHED_LAYOUT_SENT"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationBatchedLayoutSent)" />
          <event value="507"    symbol="INSTRUMENTATION_SEARCHHOME_COMMANDBAR_CLICK_SENT"  channel="Default"   task="INSTRUMENTATION_SEARCHHOME_COMMANDBAR_CLICK_SENT"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationSearchHomeCommandBarClickSent)" />
          <event value="508"    symbol="INSTRUMENTATION_HOSE_COMMANDBAR_CLICK_SENT"  channel="Default"         task="INSTRUMENTATION_HOSE_COMMANDBAR_CLICK_SENT"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationHoseCommandBarClickSent)" />
          <event value="509"    symbol="INSTRUMENTATION_PAGE_VIEW_QUERY"             channel="Default"         task="INSTRUMENTATION_PAGE_VIEW_QUERY"
              keywords="Debug"  level="win:Informational" opcode="win:Info"  message="$(string.WebSearch.InstrumentationPageViewQuerySent)" />



          <!-- Neighborhood events -->
          <event value="600"      symbol="NEIGHBORHOOD_PANE_MODELS_LIST_READY"
              task="NEIGHBORHOOD_PANE_MODELS_LIST_READY"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodPaneModelsListReady)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="601"      symbol="NEIGHBORHOOD_VISIBLE"
              task="NEIGHBORHOOD_VISIBLE"          opcode="win:Info"
              template="NeighborhoodVisible"    message="$(string.WebSearch.NeighborhoodVisible)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="602"      symbol="NEIGHBORHOOD_CORE_STATE_RETREIVED"
              task="NEIGHBORHOOD_CORE_STATE_RETREIVED"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodCoreStateRetreived)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="603"      symbol="NEIGHBORHOOD_RESULTS_STATE_RETREIVED"
              task="NEIGHBORHOOD_RESULTS_STATE_RETREIVED"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodResultsStateRetreived)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="604"      symbol="NEIGHBORHOOD_STATE_PUBLISHED"
              task="NEIGHBORHOOD_STATE_PUBLISHED"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodStatePublished)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="605"      symbol="NEIGHBORHOOD_FILTER_SET_RETREIVED"
              task="NEIGHBORHOOD_FILTER_SET_RETREIVED"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodFilterSetRetreived)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="606"      symbol="NEIGHBORHOOD_FILTER_SET_PUBLISHED"
              task="NEIGHBORHOOD_FILTER_SET_PUBLISHED"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodFilterSetPublished)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="607"      symbol="NEIGHBORHOOD_LAUNCHED_AS_TASK"
              task="NEIGHBORHOOD_LAUNCHED_AS_TASK"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodLaunchedAsTask)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="608"      symbol="NEIGHBORHOOD_PUBLISHED_MAP_POIS"
              task="NEIGHBORHOOD_PUBLISHED_MAP_POIS"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodPublishedMapPOIs)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="609"      symbol="NEIGHBORHOOD_FOWARD_NAVIGATE"
              task="NEIGHBORHOOD_FOWARD_NAVIGATE"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodFowardNavigate)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="610"    symbol="NEIGHBORHOOD_DESERIALIZE_DATA_STORE_QUERY_START"             channel="Default"       task="NEIGHBORHOOD_DESERIALIZE_DATA_STORE_QUERY" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.NeighborhoodDeserializeDataStoreQueryStart)" />
          <event value="611"    symbol="NEIGHBORHOOD_DESERIALIZE_DATA_STORE_QUERY_STOP"             channel="Default"       task="NEIGHBORHOOD_DESERIALIZE_DATA_STORE_QUERY" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.NeighborhoodDeserializeDataStoreQueryStop)" />
          <event value="612"    symbol="NEIGHBORHOOD_BUSINESSES_QUERY_START"             channel="Default"       task="NEIGHBORHOOD_BUSINESSES_QUERY" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.NeighborhoodBusinessesQueryStart)" />
          <event value="613"    symbol="NEIGHBORHOOD_BUSINESSES_QUERY_STOP"             channel="Default"       task="NEIGHBORHOOD_BUSINESSES_QUERY" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.NeighborhoodBusinessesQueryStop)" />
          <event value="614"      symbol="NEIGHBORHOOD_ACTIVE_PANE"
              task="NEIGHBORHOOD_ACTIVE_PANE"          opcode="win:Info"
              template="String"    message="$(string.WebSearch.NeighborhoodActivePane)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>

          <!-- UIXSchemaState events -->
          <event value="650"    symbol="UIX_SCHEMA_STATE_LOCK"
              task="UIX_SCHEMA_STATE"           opcode="Lock"
              message="$(string.WebSearch.UIXSchemaStateLock)"
              channel="Default"   level="win:Verbose"   keywords="Debug"/>
          <event value="651"    symbol="UIX_SCHEMA_STATE_UNLOCK"
              task="UIX_SCHEMA_STATE"           opcode="Unlock"
              message="$(string.WebSearch.UIXSchemaStateUnlock)"
              channel="Default"   level="win:Verbose"   keywords="Debug"/>
          <event value="652"    symbol="UIX_SCHEMA_STATE_ISUNLOADED"
              task="UIX_SCHEMA_STATE"           opcode="IsUnloaded"
              template="Boolean"                message="$(string.WebSearch.UIXSchemaStateIsUnloaded)"
              channel="Default"   level="win:Verbose"   keywords="Debug"/>
          <event value="653"    symbol="UIX_SCHEMA_STATE_SETUNLOADED"
              task="UIX_SCHEMA_STATE"           opcode="SetUnloaded"
              message="$(string.WebSearch.UIXSchemaStateSetUnloaded)"
              channel="Default"   level="win:Verbose"   keywords="Debug"/>

          <!-- GENERIC DATA PROCESSING-->
          <event value="700"    symbol="DATA_PROCESSING_START"             channel="Default"       task="DATA_PROCESSING" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.DataProcessingStart)" />
          <event value="701"    symbol="DATA_PROCESSING_STOP"             channel="Default"       task="DATA_PROCESSING" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.DataProcessingStop)" />
          <event value="702"    symbol="WORK_QUEUE_START"             channel="Default"       task="WORK_QUEUE" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.WorkQueueStart)" />
          <event value="703"    symbol="WORK_QUEUE_STOP"             channel="Default"       task="WORK_QUEUE" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.WorkQueueStop)" />

          <!-- POI DB -->
          <event value="750"    symbol="POIDB_INITIALIZE" channel="Default"         task="POIDB_INITIALIZE"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.PoidbInitialize)"/>
          <event value="751"    symbol="POIDB_CLOSE" channel="Default"              task="POIDB_CLOSE"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.PoidbClose)"/>
          <event value="752"    symbol="POIDB_INITIALIZING_START" channel="Default" task="POIDB_INITIALIZING"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PoidbInitializingStart)"/>
          <event value="753"    symbol="POIDB_INITIALIZING_STOP"  channel="Default" task="POIDB_INITIALIZING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PoidbInitializingStop)"/>
          <event value="754"    symbol="POIDB_ADDPOI_START" channel="Default"       task="POIDB_ADDPOI"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PoidbAddpoiStart)"/>
          <event value="755"    symbol="POIDB_ADDPOI_STOP"  channel="Default"       task="POIDB_ADDPOI"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PoidbAddpoiStop)"/>
          <event value="756"    symbol="POIDB_UPDATING_ACCESSTIME_START" channel="Default"       task="POIDB_UPDATING_ACCESSTIME"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PoidbUpdatingAccesstimeStart)"/>
          <event value="757"    symbol="POIDB_UPDATING_ACCESSTIME_STOP"  channel="Default"       task="POIDB_UPDATING_ACCESSTIME"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PoidbUpdatingAccesstimeStop)"/>

          <event value="770"    symbol="POIMTF_INITIALIZE" channel="Default"        task="POIMTF_INITIALIZE"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.PoimtfInitialize)"/>
          <event value="771"    symbol="POIMTF_CLOSE" channel="Default"             task="POIMTF_CLOSE"
              keywords="Debug" level="win:Informational" opcode="win:Info"              message="$(string.WebSearch.PoimtfClose)"/>
          <event value="772"    symbol="POIMTF_GETCANDIDATE_START" channel="Default" task="POIMTF_GETCANDIDATE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.PoimtfGetcandidateStart)"/>
          <event value="773"    symbol="POIMTF_GETCANDIDATE_STOP"  channel="Default" task="POIMTF_GETCANDIDATE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.PoimtfGetcandidateStop)"/>


          <!-- GENERIC QUERIES -->
          <event value="800"    symbol="POI_DATA_STORE_QUERY_START"             channel="Default"       task="POI_DATA_STORE_QUERY" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Start"        message="$(string.WebSearch.POIDataStoreQueryStart)" />
          <event value="801"    symbol="POI_DATA_STORE_QUERY_STOP"             channel="Default"       task="POI_DATA_STORE_QUERY" template="String"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.POIDataStoreQueryStop)" />

          <!-- GENERIC UI -->
          <event value="900"      symbol="NON_BLOCKING_WAIT_CURSOR_VISIBLE"
              task="NON_BLOCKING_WAIT_CURSOR_VISIBLE"         opcode="win:Info"
              template="Boolean"  message="$(string.WebSearch.NonBlockingWaitCursorVisible)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>

          <!-- GENERIC EVENTS -->
          <event value="1000"   symbol="GENERIC_INFO"
              task="WEBSEARCH_GENERIC"          opcode="win:Info"
              template="String"                 message="$(string.WebSearch.GenericInfo)"
              channel="Default"   level="win:Informational"   keywords="Debug"/>
          <event value="1001"   symbol="PERF_SCENARIO_START"
              task="PERF_SCENARIO"              opcode="win:Start"
              message="$(string.WebSearch.PerfScenarioStart)"
              channel="Default"   level="win:Informational"   keywords="Performance"/>
          <event value="1002"   symbol="PERF_SCENARIO_STOP"
              task="PERF_SCENARIO"              opcode="win:Stop"
              message="$(string.WebSearch.PerfScenarioStop)"
              channel="Default"   level="win:Informational"   keywords="Performance"/>

          <!-- AR Search Performance Markers -->
          <event value="2000"    symbol="ARSEARCH_VIEWFINDERVM_STARTUP"   channel="Default"       task="ARSEARCH_VIEWFINDERVM_STARTUP"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.LiveViewfinderStart)" />
          <event value="2001"    symbol="ARSEARCH_VIDEOSURFACEREADY"   channel="Default"       task="ARSEARCH_VIDEOSURFACEREADY"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.OnVideoSurfaceReady)" />
          <event value="2002"    symbol="ARSEARCH_DETECTIONLOOP_Start"   channel="Default"       task="ARSEARCH_DETECTIONLOOP"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_DETECTIONLOOPStart)" />
          <event value="2003"    symbol="ARSEARCH_DETECTIONLOOP_Stop"   channel="Default"       task="ARSEARCH_DETECTIONLOOP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_DETECTIONLOOPStop)" />
          <event value="2004"    symbol="ARSEARCH_CAMERA_FOCUS_Start"   channel="Default"       task="ARSEARCH_CAMERA_FOCUS"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_CAMERA_FOCUSStart)" />
          <event value="2005"    symbol="ARSEARCH_CAMERA_FOCUS_Stop"   channel="Default"       task="ARSEARCH_CAMERA_FOCUS"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_CAMERA_FOCUSStop)" />
          <event value="2006"    symbol="ARSEARCH_STABILITY_Start"   channel="Default"       task="ARSEARCH_STABILITY"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_STABILITYStart)" />
          <event value="2007"    symbol="ARSEARCH_STABILITY_Stop"   channel="Default"       task="ARSEARCH_STABILITY"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_STABILITYStop)" />
          <event value="2008"    symbol="ARSEARCH_UPC_DETECT_Start"   channel="Default"       task="ARSEARCH_UPC_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_UPC_DETECTStart)" />
          <event value="2009"    symbol="ARSEARCH_UPC_DETECT_Stop"   channel="Default"       task="ARSEARCH_UPC_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_UPC_DETECTStop)" />
          <event value="2010"    symbol="ARSEARCH_UPC_DETECTANDDECODE_Start"   channel="Default"       task="ARSEARCH_UPC_DETECTANDDECODE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_UPC_DETECTANDDECODEStart)" />
          <event value="2011"    symbol="ARSEARCH_UPC_DETECTANDDECODE_Stop"   channel="Default"       task="ARSEARCH_UPC_DETECTANDDECODE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_UPC_DETECTANDDECODEStop)" />
          <event value="2012"    symbol="ARSEARCH_QR_DETECT_Start"   channel="Default"       task="ARSEARCH_QR_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_QR_DETECTStart)" />
          <event value="2013"    symbol="ARSEARCH_QR_DETECT_Stop"   channel="Default"       task="ARSEARCH_QR_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_QR_DETECTStop)" />
          <event value="2014"    symbol="ARSEARCH_QR_DETECTANDDECODE_Start"   channel="Default"       task="ARSEARCH_QR_DETECTANDDECODE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_QR_DETECTANDDECODEStart)" />
          <event value="2015"    symbol="ARSEARCH_QR_DETECTANDDECODE_Stop"   channel="Default"       task="ARSEARCH_QR_DETECTANDDECODE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_QR_DETECTANDDECODEStop)" />
          <event value="2016"    symbol="ARSEARCH_MSTAG_DETECT_Start"   channel="Default"       task="ARSEARCH_MSTAG_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_MSTAG_DETECTStart)" />
          <event value="2017"    symbol="ARSEARCH_MSTAG_DETECT_Stop"   channel="Default"       task="ARSEARCH_MSTAG_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_MSTAG_DETECTStop)" />
          <event value="2018"    symbol="ARSEARCH_MSTAG_DETECTANDDECODE_Start"   channel="Default"       task="ARSEARCH_MSTAG_DETECTANDDECODE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_MSTAG_DETECTANDDECODEStart)" />
          <event value="2019"    symbol="ARSEARCH_MSTAG_DETECTANDDECODE_Stop"   channel="Default"       task="ARSEARCH_MSTAG_DETECTANDDECODE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_MSTAG_DETECTANDDECODEStop)" />
          <event value="2020"    symbol="ARSEARCH_SHUTDOWNBEGIN"   channel="Default"       task="ARSEARCH_SHUTDOWNBEGIN"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.ShutdownBegin)" />
          <event value="2021"    symbol="ARSEARCH_BINGIMAGEWORK_Start"   channel="Default"       task="ARSEARCH_BINGIMAGEWORK"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_BINGIMAGEWORKStart)" />
          <event value="2022"    symbol="ARSEARCH_BINGIMAGEWORK_Stop"   channel="Default"       task="ARSEARCH_BINGIMAGEWORK"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_BINGIMAGEWORKStop)" />
          <event value="2023"    symbol="ARSEARCH_GETRECENTLOC_Start"   channel="Default"       task="ARSEARCH_GETRECENTLOC"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_GETRECENTLOCStart)" />
          <event value="2024"    symbol="ARSEARCH_GETRECENTLOC_Stop"   channel="Default"       task="ARSEARCH_GETRECENTLOC"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_GETRECENTLOCStop)" />
          <event value="2025"    symbol="ARSEARCH_BINGIMAGEALLOC_Start"   channel="Default"       task="ARSEARCH_BINGIMAGEALLOC"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_BINGIMAGEALLOCStart)" />
          <event value="2026"    symbol="ARSEARCH_BINGIMAGEALLOC_Stop"   channel="Default"       task="ARSEARCH_BINGIMAGEALLOC"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_BINGIMAGEALLOCStop)" />
          <event value="2027"    symbol="ARSEARCH_TEXT_DETECT_Start"   channel="Default"       task="ARSEARCH_TEXT_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Start"      message="$(string.WebSearch.ARSEARCH_TEXT_DETECTStart)" />
          <event value="2028"    symbol="ARSEARCH_TEXT_DETECT_Stop"   channel="Default"       task="ARSEARCH_TEXT_DETECT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_TEXT_DETECTStop)" />
          <event value="2029"    symbol="ARSEARCH_OCR_RECOGNITION_Start"   channel="Default"       task="ARSEARCH_OCR_RECOGNITION"
              keywords="Performance" level="win:Informational" opcode="win:Start"      message="$(string.WebSearch.ARSEARCH_OCR_RECOGNITIONStart)" />
          <event value="2030"    symbol="ARSEARCH_OCR_RECOGNITION_Stop"    channel="Default"       task="ARSEARCH_OCR_RECOGNITION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_OCR_RECOGNITIONStop)" />
          <event value="2031"    symbol="ARSEARCH_AUDIO_RECORDING_Start"   channel="Default"       task="ARSEARCH_AUDIO_RECORDING"
              keywords="Performance" level="win:Informational" opcode="win:Start"      message="$(string.WebSearch.ARSEARCH_AUDIO_RECORDINGStart)" />
          <event value="2032"    symbol="ARSEARCH_AUDIO_RECORDING_Stop"    channel="Default"       task="ARSEARCH_AUDIO_RECORDING"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_RECORDINGStop)" />
          <event value="2033"    symbol="ARSEARCH_AUDIO_RECORDING_TIMEOUT" channel="Default"       task="ARSEARCH_AUDIO_RECORDING_TIMEOUT"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.ARSEARCH_AUDIO_RECORDINGTimeout)" />
          <event value="2034"    symbol="ARSEARCH_AUDIO_DETECTION_Start"   channel="Default"       task="ARSEARCH_AUDIO_DETECTION"
              keywords="Performance" level="win:Informational" opcode="win:Start"      message="$(string.WebSearch.ARSEARCH_AUDIO_DETECTIONStart)" />
          <event value="2035"    symbol="ARSEARCH_AUDIO_DETECTION_Stop"    channel="Default"       task="ARSEARCH_AUDIO_DETECTION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_DETECTIONStop)" />
          <event value="2036"    symbol="ARSEARCH_AUDIO_FINGERPRINT_Start" channel="Default"       task="ARSEARCH_AUDIO_FINGERPRINT"
              keywords="Performance" level="win:Informational" opcode="win:Start"      message="$(string.WebSearch.ARSEARCH_AUDIO_FINGERPRINTStart)" />
          <event value="2037"    symbol="ARSEARCH_AUDIO_FINGERPRINT_Stop"  channel="Default"       task="ARSEARCH_AUDIO_FINGERPRINT"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_FINGERPRINTStop)" />
          <event value="2038"    symbol="ARSEARCH_AUDIO_UX_LISTENING"      channel="Default"       task="AUDIOSEARCH_UX_LISTENING"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXListening)" />
          <event value="2039"    symbol="ARSEARCH_AUDIO_UX_RESULTFOUND"    channel="Default"       task="AUDIOSEARCH_UX_RESULTFOUND"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXResultFound)" />
          <event value="2040"    symbol="ARSEARCH_AUDIO_UX_NORESULT"       channel="Default"       task="AUDIOSEARCH_UX_NORESULT"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXNoResult)" />
          <event value="2041"    symbol="ARSEARCH_AUDIO_UX_NOCONNECTION"   channel="Default"       task="AUDIOSEARCH_UX_NOCONNECTION"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXNoConnection)" />
          <event value="2042"    symbol="ARSEARCH_AUDIO_UX_FAILED"         channel="Default"       task="AUDIOSEARCH_UX_FAILED"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXFailed)" />
          <event value="2043"    symbol="ARSEARCH_AUDIO_UX_ACTIVEVOICECALLFAILURE" channel="Default" task="AUDIOSEARCH_UX_ACTIVEVOICECALLFAILURE"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXActiveVoiceCallFailure)" />
          <event value="2044"    symbol="ARSEARCH_RESULT_SERIALIZATION_Start"   channel="Default"    task="ARSEARCH_RESULT_SERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_RESULT_SERIALIZATIONStart)" />
          <event value="2045"    symbol="ARSEARCH_RESULT_SERIALIZATION_Stop"   channel="Default"     task="ARSEARCH_RESULT_SERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_RESULT_SERIALIZATIONStop)" />
          <event value="2046"    symbol="ARSEARCH_RESULT_DESERIALIZATION_Start"   channel="Default"  task="ARSEARCH_RESULT_DESERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_RESULT_DESERIALIZATIONStart)" />
          <event value="2047"    symbol="ARSEARCH_RESULT_DESERIALIZATION_Stop"   channel="Default"   task="ARSEARCH_RESULT_DESERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_RESULT_DESERIALIZATIONStop)" />
          <event value="2048"    symbol="ARSEARCH_AUDIO_WAVEIN_OPEN_Start"   channel="Default"         task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_OPENStart)" />
          <event value="2049"    symbol="ARSEARCH_AUDIO_WAVEIN_OPEN_Stop"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_OPENStop)" />
          <event value="2050"    symbol="ARSEARCH_AUDIO_WAVEIN_START_Start"   channel="Default"         task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_STARTStart)" />
          <event value="2051"    symbol="ARSEARCH_AUDIO_WAVEIN_START_Stop"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_STARTStop)" />
          <event value="2052"    symbol="ARSEARCH_AUDIO_WAVEIN_ADDBUF_Start"   channel="Default"         task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_ADDBUFStart)" />
          <event value="2053"    symbol="ARSEARCH_AUDIO_WAVEIN_ADDBUF_Stop"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_ADDBUFStop)" />
          <event value="2054"    symbol="ARSEARCH_AUDIO_WAVEIN_PREPHEADER_Stop"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_PREPHEADERStop)" />
          <event value="2055"    symbol="ARSEARCH_AUDIO_WAVEIN_UNPREPHEADER_Stop"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_UNPREPHEADERStop)" />
          <event value="2056"    symbol="ARSEARCH_AUDIO_WAVEIN_RESET_Start"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_RESETStart)" />
          <event value="2057"    symbol="ARSEARCH_AUDIO_WAVEIN_RESET_Stop"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_RESETStop)" />
          <event value="2058"    symbol="ARSEARCH_AUDIO_WAVEIN_CLOSE_Stop"   channel="Default"          task="ARSEARCH_AUDIO_WAVE_OP"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_WAVEIN_CLOSEStop)" />
          <event value="2059"    symbol="ARSEARCH_AUDIO_RECORDING_Cancel"   channel="Default"       task="ARSEARCH_AUDIO_RECORDING"
              keywords="Performance" level="win:Informational" opcode="win:Info"      message="$(string.WebSearch.ARSEARCH_AUDIO_RECORDINGCancel)" />
          <event value="2060"    symbol="ARSEARCH_AUDIO_SERIALIZATION_Start"   channel="Default"    task="ARSEARCH_AUDIO_SERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_AUDIO_SERIALIZATIONStart)" />
          <event value="2061"    symbol="ARSEARCH_AUDIO_SERIALIZATION_Stop"   channel="Default"     task="ARSEARCH_AUDIO_SERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_SERIALIZATIONStop)" />
          <event value="2062"    symbol="ARSEARCH_AUDIO_DESERIALIZATION_Start"   channel="Default"  task="ARSEARCH_AUDIO_DESERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_AUDIO_DESERIALIZATIONStart)" />
          <event value="2063"    symbol="ARSEARCH_AUDIO_DESERIALIZATION_Stop"   channel="Default"   task="ARSEARCH_AUDIO_DESERIALIZATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_AUDIO_DESERIALIZATIONStop)" />

          <event value="2064"    symbol="ARSEARCH_RESULT_BARCODE_PARSE_Start"   channel="Default"  task="ARSEARCH_RESULT_PARSE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_RESULT_BARCODE_PARSEStart)" />
          <event value="2065"    symbol="ARSEARCH_RESULT_BARCODE_PARSE_Stop"   channel="Default"   task="ARSEARCH_RESULT_PARSE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_RESULT_BARCODE_PARSEStop)" />

          <event value="2066"    symbol="ARSEARCH_RESULT_IMAGE_PARSE_Start"   channel="Default"  task="ARSEARCH_RESULT_PARSE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_RESULT_IMAGE_PARSEStart)" />
          <event value="2067"    symbol="ARSEARCH_RESULT_IMAGE_PARSE_Stop"   channel="Default"   task="ARSEARCH_RESULT_PARSE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_RESULT_IMAGE_PARSEStop)" />

          <event value="2068"    symbol="ARSEARCH_RESULT_OCR_PARSE_Start"   channel="Default"  task="ARSEARCH_RESULT_PARSE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_RESULT_OCR_PARSEStart)" />
          <event value="2069"    symbol="ARSEARCH_RESULT_OCR_PARSE_Stop"   channel="Default"   task="ARSEARCH_RESULT_PARSE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_RESULT_OCR_PARSEStop)" />

          <!-- Events 2070-2076 were used previously but have been deprecated. -->
          <event value="2070"    symbol="ARSEARCH_RAWUPLOAD_UPLOAD_Start"   channel="Default"   task="ARSEARCH_RAWUPLOAD_UPLOAD"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_RAWUPLOAD_UPLOADStart)" />
          <event value="2071"    symbol="ARSEARCH_RAWUPLOAD_UPLOAD_Stop"   channel="Default"   task="ARSEARCH_RAWUPLOAD_UPLOAD"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_RAWUPLOAD_UPLOADStop)" />
          <event value="2072"    symbol="ARSEARCH_RAWUPLOAD_READ_FILE_Start"   channel="Default"   task="ARSEARCH_RAWUPLOAD_READ_FILE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.ARSEARCH_RAWUPLOAD_READ_FILEStart)" />
          <event value="2073"    symbol="ARSEARCH_RAWUPLOAD_READ_FILE_Stop"   channel="Default"   task="ARSEARCH_RAWUPLOAD_READ_FILE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.WebSearch.ARSEARCH_RAWUPLOAD_READ_FILEStop)" />
          <event value="2074"    symbol="ARSEARCH_AUDIO_UX_RAWUPLOAD_CONFIRMATION"   channel="Default"  task="AUDIOSEARCH_UX_RAWUPLOAD_CONFIRMATION"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXRawUploadConfirmation)" />
          <event value="2075"    symbol="ARSEARCH_AUDIO_UX_RAWUPLOAD_PROGRESS"   channel="Default"  task="AUDIOSEARCH_UX_RAWUPLOAD_PROGRESS"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXRawUploadProgress)" />
          <event value="2076"    symbol="ARSEARCH_AUDIO_UX_RAWUPLOAD_ERROR"   channel="Default"  task="AUDIOSEARCH_UX_RAWUPLOAD_ERROR"
              keywords="Performance" level="win:Informational" opcode="win:Info"       message="$(string.WebSearch.AudioSearchUXRawUploadError)" />

          <!-- Venue Maps Performance Markers -->
          <event value="4000"     symbol="MAPS_VENUE_METADATA_PROCESSING_START"   channel="Default"       task="MAPS_VENUE_METADATA_PROCESSING"    template="String"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.MapsVenueMetadataProcessingStart)" />
          <event value="4001"     symbol="MAPS_VENUE_METADATA_PROCESSING_STOP"    channel="Default"       task="MAPS_VENUE_METADATA_PROCESSING"    template="String"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.MapsVenueMetadataProcessingStop)" />
          <event value="4002"     symbol="MAPS_VENUE_DIRECTORY_FILTERING_START"   channel="Default"       task="MAPS_VENUE_DIRECTORY_FILTERING"
              keywords="Performance" level="win:Verbose" opcode="win:Start"             message="$(string.WebSearch.MapsVenueDirectoryFilteringStart)" />
          <event value="4003"     symbol="MAPS_VENUE_DIRECTORY_FILTERING_STOP"    channel="Default"       task="MAPS_VENUE_DIRECTORY_FILTERING"
              keywords="Performance" level="win:Verbose" opcode="win:Stop"              message="$(string.WebSearch.MapsVenueDirectoryFilteringStop)" />
          <event value="4004"     symbol="MAPS_VENUE_HITTEST_START"               channel="Default"       task="MAPS_VENUE_HITTEST"  template="String"
              keywords="Performance" level="win:Verbose" opcode="win:Start"             message="$(string.WebSearch.MapsVenueHitTestStart)" />
          <event value="4005"     symbol="MAPS_VENUE_HITTEST_STOP"                channel="Default"       task="MAPS_VENUE_HITTEST"  template="Boolean"
              keywords="Performance" level="win:Verbose" opcode="win:Stop"              message="$(string.WebSearch.MapsVenueHitTestStop)" />
          <event value="4012"     symbol="MAPS_VENUE_METADATA_PROCESSING_ERROR"   channel="Default"       task="MAPS_VENUE_METADATA_PROCESSING"    template="String"
              keywords="Debug"       level="win:Informational" opcode="Error"           message="$(string.WebSearch.MapsVenueMetadataProcessingError)" />

          <!-- Navigation Engine Performance Markers -->
          <event value="4006"     symbol="NAVIGATIONENGINE_SETROUTE_START"              channel="Default"       task="NAVIGATIONENGINE_SET_ROUTE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.NavigationEngineSetRouteStart)" />
          <event value="4007"     symbol="NAVIGATIONENGINE_SETROUTE_STOP"               channel="Default"       task="NAVIGATIONENGINE_SET_ROUTE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.NavigationEngineSetRouteStop)" />
          <event value="4008"     symbol="NAVIGATIONENGINE_PROCESSINGLOCATION_START"    channel="Default"       task="NAVIGATIONENGINE_PROCESSING_LOCATION"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.NavigationEngineProcessingLocationStart)" />
          <event value="4009"     symbol="NAVIGATIONENGINE_PROCESSINGLOCATION_STOP"     channel="Default"       task="NAVIGATIONENGINE_PROCESSING_LOCATION"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.NavigationEngineProcessingLocationStop)" />
          <event value="4010"     symbol="NAVIGATIONENGINE_SNAPTOROUTE_START"           channel="Default"       task="NAVIGATIONENGINE_SNAP_TO_ROUTE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.WebSearch.NavigationEngineSnapToRouteStart)" />
          <event value="4011"     symbol="NAVIGATIONENGINE_SNAPTOROUTE_STOP"            channel="Default"       task="NAVIGATIONENGINE_SNAP_TO_ROUTE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"        message="$(string.WebSearch.NavigationEngineSnapToRouteStop)" />

          <event value="4013"     symbol="MAPS_DIRECTIONS_SPEECH_QUEUE_PLAY"            channel="Default"       task="MAPS_DIRECTIONS_SPEECH"
              keywords="Debug"    level="win:Informational" opcode="win:Info"           message="$(string.WebSearch.DirectionsSpeechQueuePlay)" />
          <event value="4014"     symbol="MAPS_DIRECTIONS_AUDIO_CUE_QUEUE_PLAY"         channel="Default"       task="MAPS_DIRECTIONS_AUDIO_CUE"
              keywords="Debug"    level="win:Informational" opcode="win:Info"           message="$(string.WebSearch.DirectionsAudioCueQueuePlay)" />

          <!-- Navigation Engine Events -->
          <event value="4050"     symbol="NAVIGATIONENGINE_INFO"                        channel="Default"       task="NAVIGATIONENGINE_PROCESSING_LOCATION"
              keywords="Debug"    level="win:Informational"    opcode="win:Info"        message="$(string.WebSearch.NavigationEngineInfo)"
              template="NavigationEngineInfo" />
          <event value="4051"     symbol="NAVIGATIONENGINE_SNAPINFO"                    channel="Default"       task="NAVIGATIONENGINE_SNAP_TO_ROUTE"
              keywords="Debug"    level="win:Informational"    opcode="win:Info"        message="$(string.WebSearch.NavigationEngineSnapInfo)"
              template="SnapInfo" />
          <event value="4052"     symbol="NAVIGATIONENGINE_STATUSCLASSIFIERINFO"        channel="Default"       task="NAVIGATIONENGINE_CLASSIFY_NAV_STATUS"
              keywords="Debug"    level="win:Informational"    opcode="win:Info"        message="$(string.WebSearch.NavigationEngineStatusClassifierInfo)"
              template="NavigationStatusClassifierInfo" />
          <event value="4053"     symbol="NAVIGATIONENGINE_SHRINKSNAPTOLERANCE"         channel="Default"       task="NAVIGATIONENGINE_CLASSIFY_NAV_STATUS"
              keywords="Debug"    level="win:Informational"    opcode="win:Info"        message="$(string.WebSearch.NavigationEngineShrinkSnapTolerance)" />
          <event value="4054"     symbol="NAVIGATIONENGINE_EXPANDSNAPTOLERANCE"         channel="Default"       task="NAVIGATIONENGINE_CLASSIFY_NAV_STATUS"
              keywords="Debug"    level="win:Informational"    opcode="win:Info"        message="$(string.WebSearch.NavigationEngineExpandSnapTolerance)" />

          <!-- Directions Navigation Interaction Events -->
          <event value="4100"     symbol="MAPS_DIRECTIONS_NAVIGATION_START"             channel="Default"              task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingStart"          message="$(string.WebSearch.DrivingStart)"
              template="DoubleVector2" />
          <event value="4101"     symbol="MAPS_DIRECTIONS_NAVIGATION_END"               channel="Default"              task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingEnd"            message="$(string.WebSearch.DrivingEnd)"
              template="DoubleVector2" />
          <event value="4102"     symbol="MAPS_DIRECTIONS_NAVIGATION_ANNOUNCE"          channel="Default"              task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingAnnounce"       message="$(string.WebSearch.DrivingAnnounce)" />
          <event value="4103"     symbol="MAPS_DIRECTIONS_NAVIGATION_REROUTE"           channel="Default"              task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingReroute"        message="$(string.WebSearch.DrivingReroute)" />
          <event value="4104"     symbol="MAPS_DIRECTIONS_NAVIGATION_OFFROUTE"          channel="Default"              task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingOffroute"       message="$(string.WebSearch.DrivingOffroute)" />
          <event value="4105"     symbol="MAPS_DIRECTIONS_NAVIGATION_BACK_ON_ROUTE"     channel="Default"              task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingBackOnRoute"    message="$(string.WebSearch.DrivingBackOnRoute)" />
          <event value="4106"     symbol="MAPS_DIRECTIONS_NAVIGATION_INACCURATE_LOCATION"     channel="Default"                     task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                                   opcode="DrivingInaccurateLocation"    message="$(string.WebSearch.DrivingInaccurateLocation)" />
          <event value="4107"     symbol="MAPS_DIRECTIONS_NAVIGATION_FLICK"             channel="Default"       task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingFlick"   message="$(string.WebSearch.DrivingFlick)"
              template="DrivingFlickInfo" />
          <event value="4108"     symbol="MAPS_DIRECTIONS_NAVIGATION_QUERY_INFO"        channel="Default"            task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingQueryInfo"    message="$(string.WebSearch.DrivingQueryInfo)"
              template="DrivingQueryInfo" />
          <event value="4109"     symbol="MAPS_DEVICE_INTERACTIVITY_INFO"               channel="Default"               task="MAPS_DEVICE_INTERACTIVITY"
              keywords="Debug"    level="win:Informational"                             opcode="win:Info"               message="$(string.WebSearch.MapsDeviceInteractivityInfo)"
              template="DeviceInteractivityInfo"/>
          <event value="4110"     symbol="MAPS_DIRECTIONS_NAVIGATION_HEADING"           channel="Default"               task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                             opcode="DrivingHeading"         message="$(string.WebSearch.DrivingHeading)"
              template="Double" />
          <event value="4111"     symbol="MAPS_DIRECTIONS_NAVIGATION_DISTANCE_BEFORE_TURN"    channel="Default"                   task="MAPS_DIRECTIONS_NAVIGATION_INTERACTIONS"
              keywords="Debug"    level="win:Informational"                                   opcode="DrivingDistanceBeforeTurn"  message="$(string.WebSearch.DrivingDistanceBeforeTurn)"
              template="String" />

          <!-- New Directions performance markers -->
          <event value="4120"     symbol="MAPS_DIRECTIONS_GETROUTE_START"               channel="Default"           task="MAPS_DIRECTIONS_GETROUTE"
              keywords="Performance"  level="win:Informational"                         opcode="win:Start"/>
          <event value="4121"     symbol="MAPS_DIRECTIONS_GETROUTE_STOP"                channel="Default"           task="MAPS_DIRECTIONS_GETROUTE"
              keywords="Performance"  level="win:Informational"                         opcode="win:Stop"/>
          <event value="4122"     symbol="MAPS_DIRECTIONS_GETUSERLOCATION_START"        channel="Default"           task="MAPS_DIRECTIONS_GETUSERLOCATION"
              keywords="Performance"  level="win:Informational"                         opcode="win:Start"/>
          <event value="4123"     symbol="MAPS_DIRECTIONS_GETUSERLOCATION_STOP"         channel="Default"           task="MAPS_DIRECTIONS_GETUSERLOCATION"
              keywords="Performance"  level="win:Informational"                         opcode="win:Stop"/>
          <event value="4124"     symbol="MAPS_DIRECTIONS_RESOLVESTART_START"           channel="Default"           task="MAPS_DIRECTIONS_RESOLVESTART"
              keywords="Performance"  level="win:Informational"                         opcode="win:Start"/>
          <event value="4125"     symbol="MAPS_DIRECTIONS_RESOLVESTART_STOP"            channel="Default"           task="MAPS_DIRECTIONS_RESOLVESTART"
              keywords="Performance"  level="win:Informational"                         opcode="win:Stop"/>
          <event value="4126"     symbol="MAPS_DIRECTIONS_RESOLVEEND_START"             channel="Default"           task="MAPS_DIRECTIONS_RESOLVEEND"
              keywords="Performance"  level="win:Informational"                         opcode="win:Start"/>
          <event value="4127"     symbol="MAPS_DIRECTIONS_RESOLVEEND_STOP"              channel="Default"           task="MAPS_DIRECTIONS_RESOLVEEND"
              keywords="Performance"  level="win:Informational"                         opcode="win:Stop"/>
          <event value="4128"     symbol="MAPS_DIRECTIONS_ROUTINGQUERY_START"           channel="Default"           task="MAPS_DIRECTIONS_ROUTINGQUERY"
              keywords="Performance"  level="win:Informational"                         opcode="win:Start"/>
          <event value="4129"     symbol="MAPS_DIRECTIONS_ROUTINGQUERY_STOP"            channel="Default"           task="MAPS_DIRECTIONS_ROUTINGQUERY"
              keywords="Performance"  level="win:Informational"                         opcode="win:Stop"/>

          <!-- Product card events -->
          <event value="4200"     symbol="PRODUCT_CARD_NAVIGATE_BY_ID"                  channel="Default"            task="PRODUCT_CARD_NAVIGATION"
              keywords="Debug"    level="win:Informational"                             opcode="win:Info"            message="$(string.WebSearch.ProductCardNavigateById)"
              template="StringKeyValuePair" />
          <event value="4201"     symbol="PRODUCT_CARD_NAVIGATE_BY_PRODUCT_RESULT"      channel="Default"            task="PRODUCT_CARD_NAVIGATION"
              keywords="Debug"    level="win:Informational"                             opcode="win:Info"            message="$(string.WebSearch.ProductCardNavigateByProductResult)"
              template="StringKeyValuePair" />

          <!-- Explore and image of the day events -->
          <event value="5000"    symbol="EXPLORE_QUERY_START"                           channel="Default"       task="EXPLORE_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.ExploreQueryStart)"
              template="String"/>
          <event value="5001"    symbol="EXPLORE_QUERY_STOP"                            channel="Default"       task="EXPLORE_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.ExploreQueryStop)"
              template="String"/>
          <event value="5002"    symbol="EXPLORE_ADD_CATEGORY_CARDS_START"              channel="Default"       task="EXPLORE_ADD_CATEGORY_CARDS"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.ExploreAddCategoryCardsStart)"
              template="String"/>
          <event value="5003"    symbol="EXPLORE_ADD_CATEGORY_CARDS_STOP"               channel="Default"       task="EXPLORE_ADD_CATEGORY_CARDS"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.ExploreAddCategoryCardsStop)"
              template="String"/>
          <event value="5004"    symbol="EXPLORE_LOADING_CARD"                          channel="Default"       task="EXPLORE_LOADING_CARD"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.ExploreLoadingCard)"
              template="String"/>
          <event value="5005"    symbol="EXPLORE_ERROR_CARD"                            channel="Default"       task="EXPLORE_ERROR_CARD"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.ExploreErrorCard)"
              template="String"/>
          <event value="5006"    symbol="EXPLORE_SWIPE_TO_CATEGORY_CARD"                channel="Default"       task="EXPLORE_SWIPE_TO_CATEGORY_CARD"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.ExploreSwipeToCategoryCard)"
              template="String"/>
          <event value="5007"    symbol="EXPLORE_TAP_TO_LAUNCH_QUICK_CARD"              channel="Default"       task="EXPLORE_TAP_ON_QUICK_CARD"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.ExploreTapToLaunchQuickCard)"
              template="String"/>
          <event value="5008"    symbol="EXPLORE_TAP_TO_LAUNCH_DEEP_DIVE"               channel="Default"       task="EXPLORE_TAP_ON_DEEP_DIVE"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.ExploreTapToLaunchDeepDive)"
              template="String"/>
          <event value="5009"    symbol="IOTD_QUERY_START"                              channel="Default"       task="IOTD_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.IOTDQueryStart)"
              template="String"/>
          <event value="5010"    symbol="IOTD_QUERY_STOP"                               channel="Default"       task="IOTD_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.IOTDQueryStop)"
              template="String"/>
          <event value="5011"    symbol="PORTRAIT_IOTD_DOWNLOAD_START"                  channel="Default"       task="PORTRAIT_IOTD_DOWNLOAD"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.PortraitIOTDDownloadStart)"
              template="String"/>
          <event value="5012"    symbol="PORTRAIT_IOTD_DOWNLOAD_STOP"                   channel="Default"       task="PORTRAIT_IOTD_DOWNLOAD"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.PortraitIOTDDownloadStop)"
              template="String"/>
          <event value="5013"    symbol="LANDSCAPE_IOTD_DOWNLOAD_START"                 channel="Default"       task="LANDSCAPE_IOTD_DOWNLOAD"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.LandscapeIOTDDownloadStart)"
              template="String"/>
          <event value="5014"    symbol="LANDSCAPE_IOTD_DOWNLOAD_STOP"                  channel="Default"       task="LANDSCAPE_IOTD_DOWNLOAD"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.LandscapeIOTDDownloadStop)"
              template="String"/>
          <event value="5015"    symbol="IOTD_VISIBLE"                                  channel="Default"       task="IOTD_VISIBLE"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.IOTDVisible)"
              template="String"/>
          <event value="5016"    symbol="IOTD_FADE"                                     channel="Default"       task="IOTD_FADE"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.IOTDFaded)"
              template="String"/>
          <event value="5017"    symbol="HOTSPOTS_START"                                channel="Default"       task="HOTSPOTS"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.HotspotsStart)"
              template="String"/>
          <event value="5018"    symbol="HOTSPOTS_STOP"                                 channel="Default"       task="HOTSPOTS"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.HotspotsStop)"
              template="String"/>

          <!--   General -->
          <event value="5050"    symbol="SEARCH_ENTERED_CONTENT_EDITBOX"                channel="Default"       task="SEARCH_ENTERED_CONTENT_EDITBOX"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.EnteredContentIntoEditBox)"
              template="String"/>
          <event value="5051"    symbol="SEARCH_SUBMIT_CONTENT_TO_SUGGESTIONS_BAR"      channel="Default"       task="SEARCH_SUBMIT_CONTENT_TO_SUGGESTIONS_BAR"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.SearchSubmitContentToSuggestionsBar)"
              template="String"/>
          <event value="5052"    symbol="SEARCH_SETTINGS_PAGE_VISIBLE"                  channel="Default"       task="SEARCH_SETTINGS_PAGE_VISIBLE"
              keywords="Performance" level="win:Informational"                          opcode="win:Info"       message="$(string.WebSearch.SearchSettingsPageVisible)"
              template="String"/>

          <!-- Venue map events -->
          <event value="5500"    symbol="VENUEMAP_METADATAQUERY_START"                  channel="Default"       task="VENUEMAP_METADATAQUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.VenueMapMetadataQueryStart)"
              template="String"/>
          <event value="5501"    symbol="VENUEMAP_METADATAQUERY_STOP"                   channel="Default"       task="VENUEMAP_METADATAQUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.VenueMapMetadataQueryStop)"
              template="String"/>
          <event value="5502"    symbol="VENUEMAP_TFEQUERY_START"                       channel="Default"       task="VENUEMAP_TFEQUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.VenueMapTFEQueryStart)"
              template="String"/>
          <event value="5503"    symbol="VENUEMAP_TFEQUERY_STOP"                        channel="Default"       task="VENUEMAP_TFEQUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.VenueMapTFEQueryStop)"
              template="String"/>
          <event value="5504"    symbol="VENUEMAP_SHOWPOLYGONS_START"                   channel="Default"       task="VENUEMAP_SHOWPOLYGONS"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.VenueMapShowPolygonsStart)"
              template="String"/>
          <event value="5505"    symbol="VENUEMAP_SHOWPOLYGONS_STOP"                    channel="Default"       task="VENUEMAP_SHOWPOLYGONS"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.VenueMapShowPolygonsStop)"
              template="String"/>
          <event value="5506"    symbol="VENUEMAP_HIDEPOLYGONS_START"                   channel="Default"       task="VENUEMAP_HIDEPOLYGONS"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.VenueMapHidePolygonsStart)"
              template="String"/>
          <event value="5507"    symbol="VENUEMAP_HIDEPOLYGONS_STOP"                    channel="Default"       task="VENUEMAP_HIDEPOLYGONS"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.VenueMapHidePolygonsStop)"
              template="String"/>
          <event value="5508"    symbol="VENUEMAP_HITTESTING_START"                     channel="Default"       task="VENUEMAP_HITTESTING"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.VenueMapHitTestingStart)"
              template="String"/>
          <event value="5509"    symbol="VENUEMAP_HITTESTING_STOP"                     channel="Default"       task="VENUEMAP_HITTESTING"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.VenueMapHitTestingStop)"
              template="String"/>

          <!-- Landmark events -->
          <event value="5600"    symbol="LANDMARK_TFEQUERY_START"                       channel="Default"       task="LANDMARK_TFEQUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.LandmarkTFEQueryStart)"
              template="String"/>
          <event value="5601"    symbol="LANDMARK_TFEQUERY_STOP"                        channel="Default"       task="LANDMARK_TFEQUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.LandmarkTFEQueryStop)"
              template="String"/>
          <event value="5602"    symbol="LANDMARK_SHOWLANDMARKS_START"                   channel="Default"       task="LANDMARK_SHOWLANDMARKS"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.LandmarkShowLandmarksStart)"
              template="String"/>
          <event value="5603"    symbol="LANDMARK_SHOWLANDMARKS_STOP"                    channel="Default"       task="LANDMARK_SHOWLANDMARKS"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.LandmarkShowLandmarksStop)"
              template="String"/>
          <event value="5604"    symbol="LANDMARK_HIDELANDMARKS_START"                   channel="Default"       task="LANDMARK_HIDELANDMARKS"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.LandmarkHideLandmarksStart)"
              template="String"/>
          <event value="5605"    symbol="LANDMARK_HIDELANDMARKS_STOP"                    channel="Default"       task="LANDMARK_HIDELANDMARKS"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.LandmarkHideLandmarksStop)"
              template="String"/>
          <event value="5606"    symbol="LANDMARK_HITTESTING_START"                     channel="Default"       task="LANDMARK_HITTESTING"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.WebSearch.LandmarkHitTestingStart)"
              template="String"/>
          <event value="5607"    symbol="LANDMARK_HITTESTING_STOP"                     channel="Default"       task="LANDMARK_HITTESTING"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.WebSearch.LandmarkHitTestingStop)"
              template="String"/>

          <!-- OnlineLocationAutosuggest events -->
          <event value="5700" symbol="ONLINELOCATIONAUTOSUGGEST_GETCANDIDATES_START"        channel="Default" task="ONLINELOCATIONAUTOSUGGEST_GETCANDIDATES"        keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestGetCandidatesStart)"        template="String"/>
          <event value="5701" symbol="ONLINELOCATIONAUTOSUGGEST_GETCANDIDATES_STOP"         channel="Default" task="ONLINELOCATIONAUTOSUGGEST_GETCANDIDATES"        keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestGetCandidatesStop)"         template="String"/>
          <event value="5702" symbol="ONLINELOCATIONAUTOSUGGEST_CREATESUGGESTIONLIST_START" channel="Default" task="ONLINELOCATIONAUTOSUGGEST_CREATESUGGESTIONLIST" keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestCreateSuggestionListStart)" template="String"/>
          <event value="5703" symbol="ONLINELOCATIONAUTOSUGGEST_CREATESUGGESTIONLIST_STOP"  channel="Default" task="ONLINELOCATIONAUTOSUGGEST_CREATESUGGESTIONLIST" keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestCreateSuggestionListStop)"  template="String"/>
          <event value="5704" symbol="ONLINELOCATIONAUTOSUGGEST_GETLOCATIONDATA_START"      channel="Default" task="ONLINELOCATIONAUTOSUGGEST_GETLOCATIONDATA"      keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestGetLocationDataStart)"      template="String"/>
          <event value="5705" symbol="ONLINELOCATIONAUTOSUGGEST_GETLOCATIONDATA_STOP"       channel="Default" task="ONLINELOCATIONAUTOSUGGEST_GETLOCATIONDATA"      keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestGetLocationDataStop)"       template="String"/>
          <event value="5706" symbol="ONLINELOCATIONAUTOSUGGEST_DOWNLOADERTHREAD_START"     channel="Default" task="ONLINELOCATIONAUTOSUGGEST_DOWNLOADERTHREAD"     keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestDownloaderThreadStart)"     template="String"/>
          <event value="5707" symbol="ONLINELOCATIONAUTOSUGGEST_DOWNLOADERTHREAD_STOP"      channel="Default" task="ONLINELOCATIONAUTOSUGGEST_DOWNLOADERTHREAD"     keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestDownloaderThreadStop)"      template="String"/>
          <event value="5708" symbol="ONLINELOCATIONAUTOSUGGEST_CREATEQUERY_START"          channel="Default" task="ONLINELOCATIONAUTOSUGGEST_CREATEQUERY"          keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestCreateQueryStart)"          template="String"/>
          <event value="5709" symbol="ONLINELOCATIONAUTOSUGGEST_CREATEQUERY_STOP"           channel="Default" task="ONLINELOCATIONAUTOSUGGEST_CREATEQUERY"          keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestCreateQueryStop)"           template="String"/>
          <event value="5710" symbol="ONLINELOCATIONAUTOSUGGEST_DOQUERY_START"              channel="Default" task="ONLINELOCATIONAUTOSUGGEST_DOQUERY"              keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestDoQueryStart)"              template="String"/>
          <event value="5711" symbol="ONLINELOCATIONAUTOSUGGEST_DOQUERY_STOP"               channel="Default" task="ONLINELOCATIONAUTOSUGGEST_DOQUERY"              keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestDoQueryStop)"               template="String"/>
          <event value="5712" symbol="ONLINELOCATIONAUTOSUGGEST_DOWNLOADQUERY_START"        channel="Default" task="ONLINELOCATIONAUTOSUGGEST_DOWNLOADQUERY"        keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestDownloadQueryStart)"        template="String"/>
          <event value="5713" symbol="ONLINELOCATIONAUTOSUGGEST_DOWNLOADQUERY_STOP"         channel="Default" task="ONLINELOCATIONAUTOSUGGEST_DOWNLOADQUERY"        keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestDownloadQueryStop)"         template="String"/>
          <event value="5714" symbol="ONLINELOCATIONAUTOSUGGEST_PARSEQUERY_START"           channel="Default" task="ONLINELOCATIONAUTOSUGGEST_PARSEQUERY"           keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.OnlineLocationAutosuggestParseQueryStart)"           template="String"/>
          <event value="5715" symbol="ONLINELOCATIONAUTOSUGGEST_PARSEQUERY_STOP"            channel="Default" task="ONLINELOCATIONAUTOSUGGEST_PARSEQUERY"           keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.OnlineLocationAutosuggestParseQueryStop)"            template="String"/>

          <!-- WinHttpDownloader events -->  
          <event value="5800" symbol="WINHTTPDOWNLOADER_CRACKURL_START"        channel="Default" task="WINHTTPDOWNLOADER_CRACKURL"        keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderCrackUrlStart)"        template="String"/>
          <event value="5801" symbol="WINHTTPDOWNLOADER_CRACKURL_STOP"         channel="Default" task="WINHTTPDOWNLOADER_CRACKURL"        keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderCrackUrlStop)"         template="String"/>
          <event value="5802" symbol="WINHTTPDOWNLOADER_CONNECT_START"         channel="Default" task="WINHTTPDOWNLOADER_CONNECT"         keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderConnectStart)"         template="String"/>
          <event value="5803" symbol="WINHTTPDOWNLOADER_CONNECT_STOP"          channel="Default" task="WINHTTPDOWNLOADER_CONNECT"         keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderConnectStop)"          template="String"/>
          <event value="5804" symbol="WINHTTPDOWNLOADER_OPENREQUEST_START"     channel="Default" task="WINHTTPDOWNLOADER_OPENREQUEST"     keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderOpenRequestStart)"     template="String"/>
          <event value="5805" symbol="WINHTTPDOWNLOADER_OPENREQUEST_STOP"      channel="Default" task="WINHTTPDOWNLOADER_OPENREQUEST"     keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderOpenRequestStop)"      template="String"/>
          <event value="5806" symbol="WINHTTPDOWNLOADER_SENDREQUEST_START"     channel="Default" task="WINHTTPDOWNLOADER_SENDREQUEST"     keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderSendRequestStart)"     template="String"/>
          <event value="5807" symbol="WINHTTPDOWNLOADER_SENDREQUEST_STOP"      channel="Default" task="WINHTTPDOWNLOADER_SENDREQUEST"     keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderSendRequestStop)"      template="String"/>
          <event value="5808" symbol="WINHTTPDOWNLOADER_RECEIVERESPONSE_START" channel="Default" task="WINHTTPDOWNLOADER_RECEIVERESPONSE" keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderReceiveResponseStart)" template="String"/>
          <event value="5809" symbol="WINHTTPDOWNLOADER_RECEIVERESPONSE_STOP"  channel="Default" task="WINHTTPDOWNLOADER_RECEIVERESPONSE" keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderReceiveResponseStop)"  template="String"/>
          <event value="5810" symbol="WINHTTPDOWNLOADER_READDATA_START"        channel="Default" task="WINHTTPDOWNLOADER_READDATA"        keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderReadDataStart)"        template="String"/>
          <event value="5811" symbol="WINHTTPDOWNLOADER_READDATA_STOP"         channel="Default" task="WINHTTPDOWNLOADER_READDATA"        keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderReadDataStop)"         template="String"/>
          <event value="5812" symbol="WINHTTPDOWNLOADER_STREAMCREATE_START"    channel="Default" task="WINHTTPDOWNLOADER_STREAMCREATE"    keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderStreamCreateStart)"    template="String"/>
          <event value="5813" symbol="WINHTTPDOWNLOADER_STREAMCREATE_STOP"     channel="Default" task="WINHTTPDOWNLOADER_STREAMCREATE"    keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderStreamCreateStop)"     template="String"/>
          <event value="5814" symbol="WINHTTPDOWNLOADER_STREAMWRITE_START"     channel="Default" task="WINHTTPDOWNLOADER_STREAMWRITE"     keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderStreamWriteStart)"     template="String"/>
          <event value="5815" symbol="WINHTTPDOWNLOADER_STREAMWRITE_STOP"      channel="Default" task="WINHTTPDOWNLOADER_STREAMWRITE"     keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderStreamWriteStop)"      template="String"/>
          <event value="5816" symbol="WINHTTPDOWNLOADER_STREAMSEEK_START"      channel="Default" task="WINHTTPDOWNLOADER_STREAMSEEK"      keywords="Performance" level="win:Informational" opcode="win:Start" message="$(string.Maps.WinHttpDownloaderStreamSeekStart)"      template="String"/>
          <event value="5817" symbol="WINHTTPDOWNLOADER_STREAMSEEK_STOP"       channel="Default" task="WINHTTPDOWNLOADER_STREAMSEEK"      keywords="Performance" level="win:Informational" opcode="win:Stop"  message="$(string.Maps.WinHttpDownloaderStreamSeekStop)"       template="String"/>
          
          <!-- Device search events -->
          <event value="6000"    symbol="DEVICE_SEARCH_QUERY_EXECUTE_START"             channel="Default"       task="DEVICE_SEARCH_QUERY_EXECUTE"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.DeviceSearch.QueryExecuteStart)"
              template="String"/>
          <event value="6001"    symbol="DEVICE_SEARCH_QUERY_EXECUTE_STOP"              channel="Default"       task="DEVICE_SEARCH_QUERY_EXECUTE"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.DeviceSearch.QueryExecuteStop)"
              template="String"/>
          <event value="6002"    symbol="DEVICE_SEARCH_QUERY_PROCESS_START"             channel="Default"       task="DEVICE_SEARCH_QUERY_PROCESS"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.DeviceSearch.QueryProcessStart)"
              template="String"/>
          <event value="6003"    symbol="DEVICE_SEARCH_QUERY_PROCESS_STOP"              channel="Default"       task="DEVICE_SEARCH_QUERY_PROCESS"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.DeviceSearch.QueryProcessStop)"
              template="String"/>
          <event value="6004"    symbol="DEVICE_SEARCH_EMAIL_QUERY_START"               channel="Default"       task="DEVICE_SEARCH_EMAIL_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.DeviceSearch.EmailQueryStart)"
              template="String"/>
          <event value="6005"    symbol="DEVICE_SEARCH_EMAIL_QUERY_STOP"                channel="Default"       task="DEVICE_SEARCH_EMAIL_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.DeviceSearch.EmailQueryStop)"
              template="String"/>
          <event value="6006"    symbol="DEVICE_SEARCH_CONTACTS_QUERY_START"            channel="Default"       task="DEVICE_SEARCH_CONTACTS_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.DeviceSearch.ContactsQueryStart)"
              template="String"/>
          <event value="6007"    symbol="DEVICE_SEARCH_CONTACTS_QUERY_STOP"             channel="Default"       task="DEVICE_SEARCH_CONTACTS_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.DeviceSearch.ContactsQueryStop)"
              template="String"/>
          <event value="6008"    symbol="DEVICE_SEARCH_APPS_QUERY_START"                channel="Default"       task="DEVICE_SEARCH_APPS_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.DeviceSearch.AppsQueryStart)"
              template="String"/>
          <event value="6009"    symbol="DEVICE_SEARCH_APPS_QUERY_STOP"                 channel="Default"       task="DEVICE_SEARCH_APPS_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.DeviceSearch.AppsQueryStop)"
              template="String"/>
          <event value="6010"    symbol="DEVICE_SEARCH_SETTINGS_QUERY_START"            channel="Default"       task="DEVICE_SEARCH_SETTINGS_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Start"      message="$(string.DeviceSearch.SettingsQueryStart)"
              template="String"/>
          <event value="6011"    symbol="DEVICE_SEARCH_SETTINGS_QUERY_STOP"             channel="Default"       task="DEVICE_SEARCH_SETTINGS_QUERY"
              keywords="Performance" level="win:Informational"                          opcode="win:Stop"       message="$(string.DeviceSearch.SettingsQueryStop)"
              template="String"/>

          <!-- Speech events -->
          <event value="6100"    symbol="SPEECH_CANVAS_RPCSERVERSTART"                    channel="Default"       task="ACTION_HANDLER_RPC_SERVER"
                keywords="Debug"       level="win:Informational"                          opcode="win:Start"      message="$(string.SpeechUX.RpcServerStart)"
                template="HResult"/>
          <event value="6101"    symbol="SPEECH_CANVAS_RPCSERVERSTOP"                     channel="Default"       task="ACTION_HANDLER_RPC_SERVER"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Stop"       message="$(string.SpeechUX.RpcServerStop)"/>

          <!-- Cortana Profile events -->
          <event value="6200"    symbol="CORTANAPROFILE_INTEREST_LIST_LOAD_START"   channel="Default"         task="CORTANAPROFILE_INTEREST_LIST_LOAD"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.CortanaProfile.InterestListLoadStart)" />
          <event value="6201"    symbol="CORTANAPROFILE_INTEREST_LIST_LOAD_STOP"   channel="Default"          task="CORTANAPROFILE_INTEREST_LIST_LOAD"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.CortanaProfile.InterestListLoadStop)" />
          <event value="6202"    symbol="CORTANAPROFILE_INTEREST_PAGE_LOAD_START"   channel="Default"         task="CORTANAPROFILE_INTEREST_PAGE_LOAD"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.CortanaProfile.InterestPageLoadStart)" />
          <event value="6203"    symbol="CORTANAPROFILE_INTEREST_PAGE_LOAD_STOP"   channel="Default"          task="CORTANAPROFILE_INTEREST_PAGE_LOAD"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.CortanaProfile.InterestPageLoadStop)" />
          <event value="6204"    symbol="CORTANAPROFILE_INTEREST_PAGE_SAVE_START"   channel="Default"         task="CORTANAPROFILE_INTEREST_PAGE_SAVE"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.CortanaProfile.InterestPageSaveStart)" />
          <event value="6205"    symbol="CORTANAPROFILE_INTEREST_PAGE_SAVE_STOP"   channel="Default"          task="CORTANAPROFILE_INTEREST_PAGE_SAVE"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.CortanaProfile.InterestPageSaveStop)" />
          <event value="6206"    symbol="CORTANAPROFILE_ADD_INTEREST_PAGE_LOAD_START"   channel="Default"         task="CORTANAPROFILE_ADD_INTEREST_PAGE_LOAD"
              keywords="Performance" level="win:Informational" opcode="win:Start"       message="$(string.CortanaProfile.AddInterestPageLoadStart)" />
          <event value="6207"    symbol="CORTANAPROFILE_ADD_INTEREST_PAGE_LOAD_STOP"   channel="Default"          task="CORTANAPROFILE_ADD_INTEREST_PAGE_LOAD"
              keywords="Performance" level="win:Informational" opcode="win:Stop"       message="$(string.CortanaProfile.AddInterestPageLoadStop)" />

          <!-- AssistUX Events -->
          <event value="6300"    symbol="ASSISTUX_SPEECH_LAUNCHED"                        channel="Default"       task="ASSISTUX_LAUNCHED"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Info"       message="$(string.AssistUX.Launched)"/>
          <!-- **ATTENTION**. The Id below is used by a Published test API and consumed by external tests. -->
          <!--   Make sure the Id in the file Etw_WebSearch.cs is also fixed before submitting your change -->
          <event value="6301"    symbol="ASSISTUX_SPEECH_SCREENID_SET"                    channel="Default"       task="ASSISTUX_SCREENID_SET"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Info"       message="$(string.AssistUX.ScreenIdSet)"
                template="UInt32"/>
          <event value="6302"    symbol="ASSISTUX_PROACTIVE_PAGELOAD_START"               channel="Default"       task="ASSISTUX_PROACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Start"      message="$(string.AssistUX.ProactivePageLoadStart)"/>
          <event value="6303"    symbol="ASSISTUX_PROACTIVE_PAGELOAD_STOP"                channel="Default"       task="ASSISTUX_PROACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Stop"       message="$(string.AssistUX.ProactivePageLoadStop)"/>
          <event value="6304"    symbol="ASSISTUX_PROACTIVE_PEEK_DISPLAYED"               channel="Default"       task="ASSISTUX_PROACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Info"       message="$(string.AssistUX.ProactivePeekDisplayed)"/>
          <event value="6305"    symbol="ASSISTUX_PROACTIVE_PROACTIVE_DISPLAYED"          channel="Default"       task="ASSISTUX_PROACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Info"       message="$(string.AssistUX.ProactiveDisplayed)"/>
          <event value="6306"    symbol="ASSISTUX_REACTIVE_PAGELOAD_START"                channel="Default"       task="ASSISTUX_REACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Start"      message="$(string.AssistUX.ReactivePageLoadStart)"/>
          <event value="6307"    symbol="ASSISTUX_REACTIVE_PAGELOAD_STOP"                 channel="Default"       task="ASSISTUX_REACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Stop"       message="$(string.AssistUX.ReactivePageLoadStop)"/>
          <event value="6308"    symbol="ASSISTUX_REACTIVE_INSERTANSWER_START"            channel="Default"       task="ASSISTUX_REACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Start"      message="$(string.AssistUX.ReactiveInsertAnswerStart)"/>
          <event value="6309"    symbol="ASSISTUX_REACTIVE_INSERTANSWER_STOP"             channel="Default"       task="ASSISTUX_REACTIVE"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Stop"       message="$(string.AssistUX.ReactiveInsertAnswerStop)"/>
          <event value="6310"    symbol="ASSISTUX_REACTIVE_PREFETCH_START"                channel="Default"       task="ASSISTUX_REACTIVE_PREFETCH"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Start"      message="$(string.AssistUX.ReactivePagePrefetchStart)"/>
          <event value="6311"    symbol="ASSISTUX_REACTIVE_PREFETCH_STOP"                 channel="Default"       task="ASSISTUX_REACTIVE_PREFETCH"
                keywords="Debug Performance" level="win:Informational"                    opcode="win:Stop"       message="$(string.AssistUX.ReactivePagePrefetchStop)"/>

          <!-- InterestExtraction events -->
          <event value="6400" symbol="INTERESTEXTRACTION_ENSURESYNCPARTNERS_START"       channel="Default" task="INTERESTEXTRACTION_ENSURESYNCPARTNERS"      keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.EnsureSyncPartnersStart)"/>
          <event value="6401" symbol="INTERESTEXTRACTION_ENSURESYNCPARTNERS_STOP"        channel="Default" task="INTERESTEXTRACTION_ENSURESYNCPARTNERS"      keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.EnsureSyncPartnersStop)"/>
          <event value="6402" symbol="INTERESTEXTRACTION_UPDATESTORE_START"              channel="Default" task="INTERESTEXTRACTION_UPDATESTORE"             keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.UpdateStoreStart)"          template="StringKeyValuePair"/>
          <event value="6403" symbol="INTERESTEXTRACTION_UPDATESTORE_STOP"               channel="Default" task="INTERESTEXTRACTION_UPDATESTORE"             keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.UpdateStoreStop)"           template="StringKeyValuePair"/>
          <event value="6404" symbol="INTERESTEXTRACTION_UPDATEFOLDER_START"             channel="Default" task="INTERESTEXTRACTION_UPDATEFOLDER"            keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.UpdateFolderStart)"         template="StringKeyValuePair"/>
          <event value="6405" symbol="INTERESTEXTRACTION_UPDATEFOLDER_STOP"              channel="Default" task="INTERESTEXTRACTION_UPDATEFOLDER"            keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.UpdateFolderStop)"          template="StringKeyValuePair"/>
          <event value="6406" symbol="INTERESTEXTRACTION_COLLECTFOLDERCHANGES_START"     channel="Default" task="INTERESTEXTRACTION_COLLECTFOLDERCHANGES"    keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.CollectFolderChangesStart)" template="StringKeyValuePair"/>
          <event value="6407" symbol="INTERESTEXTRACTION_COLLECTFOLDERCHANGES_STOP"      channel="Default" task="INTERESTEXTRACTION_COLLECTFOLDERCHANGES"    keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.CollectFolderChangesStop)"  template="StringKeyValuePair"/>
          <event value="6408" symbol="INTERESTEXTRACTION_PROCESSFOLDERCHANGES_START"     channel="Default" task="INTERESTEXTRACTION_PROCESSFOLDERCHANGES"    keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.ProcessFolderChangesStart)" template="StringKeyValuePair"/>
          <event value="6409" symbol="INTERESTEXTRACTION_PROCESSFOLDERCHANGES_STOP"      channel="Default" task="INTERESTEXTRACTION_PROCESSFOLDERCHANGES"    keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.ProcessFolderChangesStop)"  template="StringKeyValuePair"/>
          <event value="6410" symbol="INTERESTEXTRACTION_PROCESSITEMCHANGES_START"       channel="Default" task="INTERESTEXTRACTION_PROCESSITEMCHANGES"      keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.ProcessItemChangesStart)"   template="StringKeyValuePair"/>
          <event value="6411" symbol="INTERESTEXTRACTION_PROCESSITEMCHANGES_STOP"        channel="Default" task="INTERESTEXTRACTION_PROCESSITEMCHANGES"      keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.ProcessItemChangesStop)"    template="StringKeyValuePair"/>
          <event value="6412" symbol="INTERESTEXTRACTION_SCHEMA_TEXTEXTRACTION_START"    channel="Default" task="INTERESTEXTRACTION_SCHEMA_TEXTEXTRACTION"   keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.Schema.TextExtractionStart)"/>
          <event value="6413" symbol="INTERESTEXTRACTION_SCHEMA_TEXTEXTRACTION_STOP"     channel="Default" task="INTERESTEXTRACTION_SCHEMA_TEXTEXTRACTION"   keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.Schema.TextExtractionStop)"                template="HResult"/>
          <event value="6414" symbol="INTERESTEXTRACTION_SCHEMA_JSONLDEXTRACTION_START"  channel="Default" task="INTERESTEXTRACTION_SCHEMA_JSONLDEXTRACTION" keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.Schema.JsonLdExtractionStart)"/>
          <event value="6415" symbol="INTERESTEXTRACTION_SCHEMA_JSONLDEXTRACTION_STOP"   channel="Default" task="INTERESTEXTRACTION_SCHEMA_JSONLDEXTRACTION" keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.Schema.JsonLdExtractionStop)"              template="HResult"/>
          <event value="6416" symbol="INTERESTEXTRACTION_SCHEMA_MICRODATAEXTRACTION_START"    channel="Default" task="INTERESTEXTRACTION_SCHEMA_MICRODATAEXTRACTION"   keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.InterestExtraction.Schema.MicrodataExtractionStart)"/>
          <event value="6417" symbol="INTERESTEXTRACTION_SCHEMA_MICRODATAEXTRACTION_STOP"     channel="Default" task="INTERESTEXTRACTION_SCHEMA_MICRODATAEXTRACTION"   keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.InterestExtraction.Schema.MicrodataExtractionStop)" template="HResult"/>

          <!-- AssistUX settings events -->
          <event value="6500" symbol="ASSISTUX_SETTINGS_PAGE_VISIBLE"                    channel="Default"  task="ASSISTUX_SETTINGS_PAGE_VISIBLE" 
                 keywords="Performance"   level="win:Informational"                       opcode="win:Info" message="$(string.AssistUXSettings.AssistUXSettingsPageVisible)" template="String"/>
          <event value="6501" symbol="ASSISTUX_SETTINGS_PAGE_INVOKEFROM_NOTEBOOK"        channel="Default" task="ASSISTUX_SETTINGS_PAGE_INVOKEFROM_NOTEBOOK" 
                 keywords="Performance"   level="win:Informational"                       opcode="win:Info" message="$(string.AssistUXSettings.AssistUXSettingsPageInvokeFromNotebook)" template="String"/>

          <!-- AssistUX GUI Form events -->
          <event value="6502" symbol="ASSISTUX_GUIFORM_EDITBOX_SUBMIT"                    channel="Default" task="ASSISTUX_GUIFORM_EDITBOX_SUBMIT" 
                 keywords="Performance" level="win:Informational"                         opcode="win:Info" message="$(string.AssistUX.AssistUXGUIFormEditBoxSubmit)" template="String"/>
          <event value="6503" symbol="ASSISTUX_ACTION_COMPLETED_CONFIRMATION"                    channel="Default" task="ASSISTUX_ACTION_COMPLETED_CONFIRMATION"
                keywords="Performance" level="win:Informational"                         opcode="win:Info" message="$(string.AssistUX.AssistUXActionCompletedConfirmation)" template="String"/>

          <!-- DND settings events -->
          <event value="6600" symbol="DND_SETTINGS_PAGE_VISIBLE" channel="Default" task="DND_SETTINGS_PAGE_VISIBLE" keywords="Performance" level="win:Informational" opcode="win:Info" message="$(string.DndSettings.DndSettingsPageVisible)" template="String"/>
          <event value="6601" symbol="DND_SETTINGS_PAGE_INVOKEFROM_NOTEBOOK" channel="Default" task="DND_SETTINGS_PAGE_INVOKEFROM_NOTEBOOK" keywords="Performance" level="win:Informational" opcode="win:Info" message="$(string.DndSettings.DndSettingsPageInvokeFromNotebook)" template="String"/>

          <!-- SmartExtraction events -->
          <event value="6700" symbol="SMARTEXTRACTION_TEXT_SNIFFING_START"   channel="Default" task="SMARTEXTRACTION_TEXT_SNIFFING"   keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.SmartExtraction.SniffingInTextStart)"/>
          <event value="6701" symbol="SMARTEXTRACTION_TEXT_SNIFFING_STOP"    channel="Default" task="SMARTEXTRACTION_TEXT_SNIFFING"   keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.SmartExtraction.SniffingInTextStop)"/>
          <event value="6702" symbol="SMARTEXTRACTION_TEXT_EXTRACTION_START" channel="Default" task="SMARTEXTRACTION_TEXT_EXTRACTION" keywords="Performance" level="win:Informational" opcode="win:Start"  message="$(string.SmartExtraction.ExtractionInTextStart)"/>
          <event value="6703" symbol="SMARTEXTRACTION_TEXT_EXTRACTION_STOP"  channel="Default" task="SMARTEXTRACTION_TEXT_EXTRACTION" keywords="Performance" level="win:Informational" opcode="win:Stop"   message="$(string.SmartExtraction.ExtractionInTextStop)"/>
        </events>

      </provider>
    </events>
  </instrumentation>

  <!-- Localizable strings for the WebSearch Events -->
  <localization>
    <resources culture="en-US">
      <stringTable>

        <!-- These definitions describe how to print each event in a user-friendly way.  -->
        <string id="WebSearch.WebSearchEventHRMessage"                  value="[WebSearch-Err] HRESULT(%3) in function %1 on line %2"/>

        <string id="WebSearch.GenericInfo"                              value="[WebSearch] %1" />
        <string id="WebSearch.SearchHome"                               value="[WebSearch] SearchHome" />
        <string id="WebSearch.SearchLocalPage"                          value="[WebSearch] SearchLocalPage" />
        <string id="WebSearch.SearchWebPage"                            value="[WebSearch] SearchWebPage" />
        <string id="WebSearch.SearchNewsPage"                           value="[WebSearch] SearchNewsPage" />
        <string id="WebSearch.SearchResultsPivotingStart"               value="[WebSearch] SearchResultsPivoting Start" />
        <string id="WebSearch.SearchResultsPivotingStop"                value="[WebSearch] SearchResultsPivoting Stop" />
        <string id="WebSearch.SearchHomeQueryInfoStart"                 value="[WebSearch] SearchHomeQueryInfo Start" />
        <string id="WebSearch.SearchHomeQueryInfoStop"                  value="[WebSearch] SearchHomeQueryInfo Stop" />
        <string id="WebSearch.TodayImageDownloadStart"                  value="[WebSearch] TodayImageDownload Start" />
        <string id="WebSearch.TodayImageDownloadStop"                   value="[WebSearch] TodayImageDownload Stop" />
        <string id="WebSearch.SearchQueryResultsStart"                  value="[WebSearch] SearchQueryResults Start" />
        <string id="WebSearch.SearchQueryResultsStop"                   value="[WebSearch] SearchQueryResults Stop" />
        <string id="WebSearch.MapteaseDownloadStart"                    value="[WebSearch] MapteaseDownload Start" />
        <string id="WebSearch.MapteaseDownloadStop"                     value="[WebSearch] MapteaseDownload Stop" />
        <string id="WebSearch.PlaceCardInfoPane"                        value="[WebSearch] PlaceCardInfoPane" />
        <string id="WebSearch.PlaceCardBuzzPane"                        value="[WebSearch] PlaceCardBuzzPane" />
        <string id="WebSearch.PlaceCardEventsPane"                      value="[WebSearch] PlaceCardEventsPane" />
        <string id="WebSearch.PlaceCardPivotingStart"                   value="[WebSearch] PlaceCardPivoting Start" />
        <string id="WebSearch.PlaceCardPivotingStop"                    value="[WebSearch] PlaceCardPivoting Stop" />
        <string id="WebSearch.PlaceCardNbhoodQueryResultsStart"         value="[WebSearch] PlaceCardNbhoodQueryResults Start" />
        <string id="WebSearch.PlaceCardNbhoodQueryResultsStop"          value="[WebSearch] PlaceCardNbhoodQueryResults Stop" />
        <string id="WebSearch.PlaceCardReviewsQueryResultsStart"        value="[WebSearch] PlaceCardReviewsQueryResults Start" />
        <string id="WebSearch.PlaceCardReviewsQueryResultsStop"         value="[WebSearch] PlaceCardReviewsQueryResults Stop" />
        <string id="WebSearch.MapsSearchQueryResultsStart"              value="[WebSearch] MapsSearchQueryResults Start" />
        <string id="WebSearch.MapsSearchQueryResultsStop"               value="[WebSearch] MapsSearchQueryResults Stop" />
        <string id="WebSearch.MapsDirectionsQueryResultsStart"          value="[WebSearch] MapsDirectionsQueryResults Start" />
        <string id="WebSearch.MapsDirectionsQueryResultsStop"           value="[WebSearch] MapsDirectionsQueryResults Stop" />
        <string id="WebSearch.MapsDirectionsPage"                       value="[WebSearch] MapsDirectionsPage" />
        <string id="WebSearch.MapsDirectionsMapteaseUpdateStart"        value="[WebSearch] MapsDirectionsMapteaseUpdate Start" />
        <string id="WebSearch.MapsDirectionsMapteaseUpdateStop"         value="[WebSearch] MapsDirectionsMapteaseUpdate Stop" />
        <string id="WebSearch.MapsLocateMeStart"                        value="[WebSearch] MapsLocateMe Start" />
        <string id="WebSearch.MapsLocateMeStop"                         value="[WebSearch] MapsLocateMe Stop" />
        <string id="WebSearch.MapsZoomInStart"                          value="[WebSearch] MapsZoomIn Start" />
        <string id="WebSearch.MapsZoomInStop"                           value="[WebSearch] MapsZoomIn Stop" />
        <string id="WebSearch.MapsZoomOutStart"                         value="[WebSearch] MapsZoomOut Start" />
        <string id="WebSearch.MapsZoomOutStop"                          value="[WebSearch] MapsZoomOut Stop" />
        <string id="WebSearch.MapsPanStart"                             value="[WebSearch] MapsPan Start" />
        <string id="WebSearch.MapsPanStop"                              value="[WebSearch] MapsPan Stop" />
        <string id="WebSearch.LocationNameUpdated"                      value="[WebSearch] LocationName Updated" />
        <string id="WebSearch.HotSpotRefreshed"                         value="[WebSearch] HotSpot Refreshed" />
        <string id="WebSearch.PlaceCardNavigationStart"                 value="[WebSearch] PlaceCardNavigation Start" />
        <string id="WebSearch.PlaceCardNavigationStop"                  value="[WebSearch] PlaceCardNavigation Stop" />
        <string id="WebSearch.SearchResultsListUpdated"                 value="[WebSearch] SearchResultsList Updated" />
        <string id="WebSearch.MapsSearchInvoked"                        value="[WebSearch] MapsSearchInvoked" />
        <string id="WebSearch.MapsSearchSuggestBarDisplayed"            value="[WebSearch] MapsSearchSuggestBarDisplayed " />
        <string id="WebSearch.MapsSearchAutoSuggestUpdated"             value="[WebSearch] MapsSearchAutoSuggest Updated" />
        <string id="WebSearch.MapsDataSerializeStart"                   value="[WebSearch] MapsDataSerialize Start" />
        <string id="WebSearch.MapsDataSerializeStop"                    value="[WebSearch] MapsDataSerialize Stop" />
        <string id="WebSearch.MapsDataDeserializeStart"                 value="[WebSearch] MapsDataDeserialize Start" />
        <string id="WebSearch.MapsDataDeserializeStop"                  value="[WebSearch] MapsDataDeserialize Stop" />
        <string id="WebSearch.MapsDirectionsInvoked"                    value="[WebSearch] MapsDirections Invoked" />
        <string id="WebSearch.MapsDirectionsZoomAdjustComplete"         value="[WebSearch] MapsDirections ZoomAdjustment Complete" />
        <string id="WebSearch.LocationRequestStart"                     value="[WebSearch] LocationRequest Start" />
        <string id="WebSearch.LocationRequestStop"                      value="[WebSearch] LocationRequest Stop" />
        <string id="WebSearch.LocationDataUpdated"                      value="[WebSearch] LocationData Updated" />
        <string id="WebSearch.SearchDataSerializeStart"                 value="[WebSearch] SearchDataSerialize Start" />
        <string id="WebSearch.SearchDataSerializeStop"                  value="[WebSearch] SearchDataSerialize Stop" />
        <string id="WebSearch.SearchDataDeserializeStart"               value="[WebSearch] SearchDataDeserialize Start" />
        <string id="WebSearch.SearchDataDeserializeStop"                value="[WebSearch] SearchDataDeserialize Stop" />
        <string id="WebSearch.PageNavigatedTo"                          value="[WebSearch] Navigating to %1" />
        <string id="WebSearch.PageNavigatingAway"                       value="[WebSearch] Navigating away from %1" />
        <string id="WebSearch.PageClosing"                              value="[WebSearch] Closing %1" />
        <string id="WebSearch.PageStartNavigation"                      value="[WebSearch] Navigating to new page %1" />
        <string id="WebSearch.PageInitialized"                          value="[WebSearch] Done initializing page %1" />
        <string id="WebSearch.TaskStarting"                             value="[WebSearch] Starting task %1 (%2)" />
        <string id="WebSearch.TaskEnding"                               value="[WebSearch] Ending task %1" />
        <string id="WebSearch.TaskPausing"                              value="[WebSearch] Pausing task %1" />
        <string id="WebSearch.TaskResuming"                             value="[WebSearch] Resuming task %1" />
        <string id="WebSearch.TaskHydrating"                            value="[WebSearch] Hydrating task %1" />
        <string id="WebSearch.TaskDehydrating"                          value="[WebSearch] Requesting Process Dehydration" />
        <string id="WebSearch.ActiveTaskCount"                          value="[WebSearch] Number of Active Tasks = %1" />
        <string id="WebSearch.PageNavigatedToStart"                     value="[WebSearch] Page NavigatedTo Start" />
        <string id="WebSearch.PageNavigatedToStop"                      value="[WebSearch] Page NavigatedTo Stop" />
        <string id="WebSearch.PageNavigatingAwayStart"                  value="[WebSearch] Page NavigatingAway Start" />
        <string id="WebSearch.PageNavigatingAwayStop"                   value="[WebSearch] Page NavigatingAway Stop" />
        <string id="WebSearch.TaskPausingStart"                         value="[WebSearch] Task Pausing Start" />
        <string id="WebSearch.TaskPausingStop"                          value="[WebSearch] Task Pausing Stop" />
        <string id="WebSearch.TaskResumingStart"                        value="[WebSearch] Task Resuming Start" />
        <string id="WebSearch.TaskResumingStop"                         value="[WebSearch] Task Resuming Stop" />
        <string id="WebSearch.LocationServiceError"                     value="[WebSearch] LocationService Error hr=%1 status=%2" />
        <string id="WebSearch.LocationCurrentStart"                     value="[WebSearch] Location Current Start" />
        <string id="WebSearch.LocationCurrentDone"                      value="[WebSearch] Location Current Done" />
        <string id="WebSearch.LocationCurrentCallback"                  value="[WebSearch] Location Current Callback hr=%1 status=%2 (%4, %5) h=%10 v=%11 (%6 m) %9 [ctx=%3 acc=%7 gen=%8]" />
        <string id="WebSearch.LocationCurrentUpdate"                    value="[WebSearch] Location Current Update script" />
        <string id="WebSearch.LocationCurrentReverseGeocode"            value="[WebSearch] Location Reverse Geocode '%1'" />
        <string id="WebSearch.LocationTrackingStart"                    value="[WebSearch] Location Tracking Start" />
        <string id="WebSearch.LocationTrackingStop"                     value="[WebSearch] Location Tracking Stop" />
        <string id="WebSearch.LocationTrackingCallback"                 value="[WebSearch] Location Tracking Callback hr=%1 status=%2 (%4, %5) h=%10 v=%11 (%6 m) %9 [ctx=%3 acc=%7 gen=%8]" />
        <string id="WebSearch.LocationTrackingUpdate"                   value="[WebSearch] Location Tracking LocationChanged" />
        <string id="WebSearch.CsmLocationShifted"                       value="[WebSearch] Csm LocationShifted" />
        <string id="WebSearch.PerfScenarioStart"                        value="[WebSearch] Perf Scenario Started" />
        <string id="WebSearch.PerfScenarioStop"                         value="[WebSearch] Perf Scenario Ended" />
        <string id="WebSearch.RouteGeneralizationStart"                 value="[WebSearch] Route Generalization Start" />
        <string id="WebSearch.RouteGeneralizationStop"                  value="[WebSearch] Route Generalization Stop" />
        <string id="WebSearch.RouteSpatialSortStart"                    value="[WebSearch] Route Spatial Sort Start" />
        <string id="WebSearch.RouteSpatialSortStop"                     value="[WebSearch] Route Spatial Sort Stop" />
        <string id="WebSearch.MapsMePOIReverseGeocode"                  value="[WebSearch] Maps mepoi reverse geocode kicked off" />
        <string id="WebSearch.MapsAnimationStart"                       value="[WebSearch] Map Animation Start" />
        <string id="WebSearch.MapsAnimationStop"                        value="[WebSearch] Map Animation Stop" />
        <string id="WebSearch.MapsAnimationZoomInfo"                    value="[WebSearch] Map Animation PowerScale %1 -> %2 -> %3" />
        <string id="WebSearch.MapsAnimationTimingInfo"                  value="[WebSearch] Map Animation Timing out=%1 trans=%2 in=%3" />
        <string id="WebSearch.MapsZoomInInfo"                           value="[WebSearch] Map ZoomIn (%1, %2) %3 -> %4" />
        <string id="WebSearch.MapsPanFlick"                             value="[WebSearch] Map Flicked" />
        <string id="WebSearch.MapsPanOverScroll"                        value="[WebSearch] Map Overscrolled, correcting" />
        <string id="WebSearch.MapsPinchStretchStart"                    value="[WebSearch] Map Pinch/Stretch Start @ (%1, %2)" />
        <string id="WebSearch.MapsPinchStretchStop"                     value="[WebSearch] Map Pinch/Stretch Stop" />
        <string id="WebSearch.MapsPinchStretchScale"                    value="[WebSearch] Map Pinch/Stretch Scale by %1" />
        <string id="WebSearch.MapsPinchStretchDrag"                     value="[WebSearch] Map Pinch/Stretch Drag by (%1, %2)" />
        <string id="WebSearch.MapsDirectionsWarmupLocRequest"           value="[WebSearch] Maps directions warmup location request kicked off" />
        <string id="WebSearch.MapsGetDirections"                        value="[WebSearch] Maps directions call to GetDirections()" />
        <string id="WebSearch.MapsDirectionsLocRequestOnSubmit"         value="[WebSearch] Maps directions on submit location request kicked off" />
        <string id="WebSearch.MapsDirectionsAccurateLocationResponse"   value="[WebSearch] Maps directions accurate location response recieved" />
        <string id="WebSearch.MapsGraphicResolved"                      value="[WebSearch] Maps Graphic Resolved %1" />
        <string id="WebSearch.SearchDomainCount"                        value="[WebSearch] Search Domain=%1 ItemCount=%2" />
        <string id="WebSearch.SearchQuery"                              value="[WebSearch] SearchQuery Keyword=%1" />
        <string id="WebSearch.SearchLocation"                           value="[WebSearch] Search Location Latitude=%1 Longitude=%2" />
        <string id="WebSearch.SearchLocale"                             value="[WebSearch] Search Locale=%1" />
        <string id="WebSearch.SearchServiceProviderStatus"              value="[WebSearch] Search ServiceProviderStatus=%1" />
        <string id="WebSearch.SearchImagePage"                          value="[WebSearch] SearchImagePage" />
        <string id="WebSearch.SearchMorePage"                           value="[WebSearch] SearchMorePage" />
        <string id="WebSearch.SearchMoreQueryResultsStart"              value="[WebSearch] SearchMoreQueryResults Start" />
        <string id="WebSearch.SearchMoreQueryResultsStop"               value="[WebSearch] SearchMoreQueryResults Stop" />
        <string id="WebSearch.SearchImagePreview"                       value="[WebSearch] Search ImagePreview" />

        <string id="WebSearch.HoseSearchQueryStart"                     value="[WebSearch] HostedSearch Query Start"/>
        <string id="WebSearch.HoseSearchQueryStop"                      value="[WebSearch] HostedSearch Query Stop"/>
        <string id="WebSearch.HoseQueryResults"                         value="[WebSearch] HostedSearch Search Results Page"/>
        <string id="WebSearch.HoseQuickCard"                            value="[WebSearch] HostedSearch Quick Card Page"/>
        <string id="WebSearch.HoseMoreResults"                          value="[WebSearch] HostedSearch More Results Page"/>
        <string id="WebSearch.HosePageDownloadedStart"                  value="[WebSearch] HostedSearch Page Download Start %1"/>
        <string id="WebSearch.HosePageDownloadedStop"                   value="[WebSearch] HostedSearch Page Download Stop %1"/>
        <string id="WebSearch.HosePageShowPivotStart"                   value="[WebSearch] HostedSearch Page Show Pivot Start: %1"/>
        <string id="WebSearch.HosePageShowPivotStop"                    value="[WebSearch] HostedSearch Page Show Pivot Stop: %1"/>
        <string id="WebSearch.HosePagePane"                             value="[WebSearch] HostedSearch Page Navigated To Pane %1"/>
        <string id="WebSearch.HoseSearchAppConnectProcessingStart"      value="[WebSearch] HostedSearch AppConnect Processing Start"/>
        <string id="WebSearch.HoseSearchAppConnectProcessingStop"       value="[WebSearch] HostedSearch AppConnect Processing Stop"/>
        <string id="WebSearch.HosePageError"                            value="[WebSearch] HostedSearch Page Error Displayed"/>
        <string id="WebSearch.HosePlaceTileStart"                       value="[WebSearch] HostedSearch Place Card Tile Download Start"/>
        <string id="WebSearch.HosePlaceTileStop"                        value="[WebSearch] HostedSearch Place Card Tile Download Stop"/>
        <string id="WebSearch.HoseQuickCardTileDownloadStart"           value="[WebSearch] HostedSearch Quick Card Tile Download Start"/>
        <string id="WebSearch.HoseQuickCardTileDownloadStop"            value="[WebSearch] HostedSearch Quick Card Tile Download Stop"/>
        <string id="WebSearch.HoseSearchMapsAcquireMapStart"            value="[WebSearch] HostedSearch Maps Aquire Map Start"/>
        <string id="WebSearch.HoseSearchMapsAcquireMapStop"             value="[WebSearch] HostedSearch Maps Aquire Map Stop"/>
        <string id="WebSearch.HoseSearchMapsOverlayPoisStart"           value="[WebSearch] HostedSearch Maps Overlay POIs Start"/>
        <string id="WebSearch.HoseSearchMapsOverlayPoisStop"            value="[WebSearch] HostedSearch Maps Overlay POIs Stop"/>
        <string id="WebSearch.HoseActionUriInvokedStart"                value="[WebSearch] HostedSearch Action Uri Invoke Start: %1"/>
        <string id="WebSearch.HoseActionUriInvokedStop"                 value="[WebSearch] HostedSearch Action Uri Invoke Stop: %1"/>
        <string id="WebSearch.HoseThemeRefresh"                         value="[WebSearch] HostedSearch page refreshed due to theme change"/>

        <string id="WebSearch.LiveViewfinderStart"                      value="[WebSearch] ARSEARCH_VIEWFINDERVM_STARTUP" />
        <string id="WebSearch.OnVideoSurfaceReady"                      value="[WebSearch] ARSEARCH_VIDEOSURFACEREADY" />
        <string id="WebSearch.ShutdownBegin"                            value="[WebSearch] ARSEARCH_SHUTDOWNBEGIN" />
        <string id="WebSearch.ARSEARCH_DETECTIONLOOPStart"              value="[WebSearch] ARSEARCH_DETECTIONLOOPStart" />
        <string id="WebSearch.ARSEARCH_DETECTIONLOOPStop"               value="[WebSearch] ARSEARCH_DETECTIONLOOPStop" />
        <string id="WebSearch.ARSEARCH_CAMERA_FOCUSStart"               value="[WebSearch] ARSEARCH_CAMERA_FOCUSStart" />
        <string id="WebSearch.ARSEARCH_CAMERA_FOCUSStop"                value="[WebSearch] ARSEARCH_CAMERA_FOCUSStop" />
        <string id="WebSearch.ARSEARCH_STABILITYStart"                  value="[WebSearch] ARSEARCH_STABILITYStart" />
        <string id="WebSearch.ARSEARCH_STABILITYStop"                   value="[WebSearch] ARSEARCH_STABILITYStop" />
        <string id="WebSearch.ARSEARCH_UPC_DETECTStart"                 value="[WebSearch] ARSEARCH_UPC_DETECTStart" />
        <string id="WebSearch.ARSEARCH_UPC_DETECTStop"                  value="[WebSearch] ARSEARCH_UPC_DETECTStop" />
        <string id="WebSearch.ARSEARCH_UPC_DETECTANDDECODEStart"        value="[WebSearch] ARSEARCH_UPC_DETECTANDDECODEStart" />
        <string id="WebSearch.ARSEARCH_UPC_DETECTANDDECODEStop"         value="[WebSearch] ARSEARCH_UPC_DETECTANDDECODEStop" />
        <string id="WebSearch.ARSEARCH_QR_DETECTStart"                  value="[WebSearch] ARSEARCH_QR_DETECTStart" />
        <string id="WebSearch.ARSEARCH_QR_DETECTStop"                   value="[WebSearch] ARSEARCH_QR_DETECTStop" />
        <string id="WebSearch.ARSEARCH_QR_DETECTANDDECODEStart"         value="[WebSearch] ARSEARCH_QR_DETECTANDDECODEStart" />
        <string id="WebSearch.ARSEARCH_QR_DETECTANDDECODEStop"          value="[WebSearch] ARSEARCH_QR_DETECTANDDECODEStop" />
        <string id="WebSearch.ARSEARCH_MSTAG_DETECTStart"               value="[WebSearch] ARSEARCH_MSTAG_DETECTStart" />
        <string id="WebSearch.ARSEARCH_MSTAG_DETECTStop"                value="[WebSearch] ARSEARCH_MSTAG_DETECTStop" />
        <string id="WebSearch.ARSEARCH_MSTAG_DETECTANDDECODEStart"      value="[WebSearch] ARSEARCH_MSTAG_DETECTANDDECODEStart" />
        <string id="WebSearch.ARSEARCH_MSTAG_DETECTANDDECODEStop"       value="[WebSearch] ARSEARCH_MSTAG_DETECTANDDECODEStop" />
        <string id="WebSearch.ARSEARCH_BINGIMAGEWORKStart"              value="[WebSearch] ARSEARCH_BINGIMAGEWORKStart" />
        <string id="WebSearch.ARSEARCH_BINGIMAGEWORKStop"               value="[WebSearch] ARSEARCH_BINGIMAGEWORKStop" />
        <string id="WebSearch.ARSEARCH_GETRECENTLOCStart"               value="[WebSearch] ARSEARCH_GETRECENTLOCStart" />
        <string id="WebSearch.ARSEARCH_GETRECENTLOCStop"                value="[WebSearch] ARSEARCH_GETRECENTLOCStop" />
        <string id="WebSearch.ARSEARCH_BINGIMAGEALLOCStart"             value="[WebSearch] ARSEARCH_BINGIMAGEALLOCStart" />
        <string id="WebSearch.ARSEARCH_BINGIMAGEALLOCStop"              value="[WebSearch] ARSEARCH_BINGIMAGEALLOCStop" />
        <string id="WebSearch.ARSEARCH_TEXT_DETECTStart"                value="[WebSearch] ARSEARCH_TEXT_DETECTStart" />
        <string id="WebSearch.ARSEARCH_TEXT_DETECTStop"                 value="[WebSearch] ARSEARCH_TEXT_DETECTStop" />
        <string id="WebSearch.ARSEARCH_OCR_RECOGNITIONStart"            value="[WebSearch] ARSEARCH_OCR_RECOGNITIONStart" />
        <string id="WebSearch.ARSEARCH_OCR_RECOGNITIONStop"             value="[WebSearch] ARSEARCH_OCR_RECOGNITIONStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_RECORDINGStart"            value="[WebSearch] ARSEARCH_AUDIO_RECORDINGStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_RECORDINGStop"             value="[WebSearch] ARSEARCH_AUDIO_RECORDINGStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_RECORDINGTimeout"          value="[WebSearch] ARSEARCH_AUDIO_RECORDINGTimeout" />
        <string id="WebSearch.ARSEARCH_AUDIO_DETECTIONStart"            value="[WebSearch] ARSEARCH_AUDIO_DETECTIONStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_DETECTIONStop"             value="[WebSearch] ARSEARCH_AUDIO_DETECTIONStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_FINGERPRINTStart"          value="[WebSearch] ARSEARCH_AUDIO_FINGERPRINTStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_FINGERPRINTStop"           value="[WebSearch] ARSEARCH_AUDIO_FINGERPRINTStop" />
        <string id="WebSearch.AudioSearchUXListening"                   value="[WebSearch] AudioSearchUXListening" />
        <string id="WebSearch.AudioSearchUXResultFound"                 value="[WebSearch] AudioSearchUXResultFound" />
        <string id="WebSearch.AudioSearchUXNoResult"                    value="[WebSearch] AudioSearchUXNoResult" />
        <string id="WebSearch.AudioSearchUXNoConnection"                value="[WebSearch] AudioSearchUXNoConnection" />
        <string id="WebSearch.AudioSearchUXFailed"                      value="[WebSearch] AudioSearchUXFailed" />
        <string id="WebSearch.AudioSearchUXActiveVoiceCallFailure"      value="[WebSearch] AudioSearchUXActiveVoiceCallFailure" />
        <string id="WebSearch.ARSEARCH_RESULT_SERIALIZATIONStart"       value="[WebSearch] ARSEARCH_RESULT_SERIALIZATIONStart" />
        <string id="WebSearch.ARSEARCH_RESULT_SERIALIZATIONStop"        value="[WebSearch] ARSEARCH_RESULT_SERIALIZATIONStop" />
        <string id="WebSearch.ARSEARCH_RESULT_DESERIALIZATIONStart"     value="[WebSearch] ARSEARCH_RESULT_DESERIALIZATIONStart" />
        <string id="WebSearch.ARSEARCH_RESULT_DESERIALIZATIONStop"      value="[WebSearch] ARSEARCH_RESULT_DESERIALIZATIONStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_OPENStart"          value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_OPENStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_OPENStop"           value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_OPENStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_STARTStart"         value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_STARTStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_STARTStop"          value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_STARTStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_ADDBUFStart"        value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_ADDBUFStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_ADDBUFStop"         value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_ADDBUFStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_PREPHEADERStop"     value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_PREPHEADERStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_UNPREPHEADERStop"   value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_UNPREPHEADERStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_RESETStart"         value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_RESETStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_RESETStop"          value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_RESETStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_WAVEIN_CLOSEStop"          value="[WebSearch] ARSEARCH_AUDIO_WAVEIN_CLOSEStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_RECORDINGCancel"           value="[WebSearch] ARSEARCH_AUDIO_RECORDINGCancel" />
        <string id="WebSearch.ARSEARCH_AUDIO_SERIALIZATIONStart"        value="[WebSearch] ARSEARCH_AUDIO_SERIALIZATIONStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_SERIALIZATIONStop"         value="[WebSearch] ARSEARCH_AUDIO_SERIALIZATIONStop" />
        <string id="WebSearch.ARSEARCH_AUDIO_DESERIALIZATIONStart"      value="[WebSearch] ARSEARCH_AUDIO_DESERIALIZATIONStart" />
        <string id="WebSearch.ARSEARCH_AUDIO_DESERIALIZATIONStop"       value="[WebSearch] ARSEARCH_AUDIO_DESERIALIZATIONStop" />

        <string id="WebSearch.ARSEARCH_RESULT_BARCODE_PARSEStart"       value="[WebSearch] ARSEARCH_RESULT_BARCODE_PARSEStart" />
        <string id="WebSearch.ARSEARCH_RESULT_BARCODE_PARSEStop"        value="[WebSearch] ARSEARCH_RESULT_BARCODE_PARSEStop" />
        <string id="WebSearch.ARSEARCH_RESULT_IMAGE_PARSEStart"         value="[WebSearch] ARSEARCH_RESULT_IMAGE_PARSEStart" />
        <string id="WebSearch.ARSEARCH_RESULT_IMAGE_PARSEStop"          value="[WebSearch] ARSEARCH_RESULT_IMAGE_PARSEStop" />
        <string id="WebSearch.ARSEARCH_RESULT_OCR_PARSEStart"           value="[WebSearch] ARSEARCH_RESULT_OCR_PARSEStart" />
        <string id="WebSearch.ARSEARCH_RESULT_OCR_PARSEStop"            value="[WebSearch] ARSEARCH_RESULT_OCR_PARSEStop" />

        <string id="WebSearch.ARSEARCH_RAWUPLOAD_UPLOADStart"           value="[WebSearch] ARSEARCH_RAWUPLOAD_UPLOADStart" />
        <string id="WebSearch.ARSEARCH_RAWUPLOAD_UPLOADStop"            value="[WebSearch] ARSEARCH_RAWUPLOAD_UPLOADStop" />
        <string id="WebSearch.ARSEARCH_RAWUPLOAD_READ_FILEStart"        value="[WebSearch] ARSEARCH_RAWUPLOAD_READ_FILEStart" />
        <string id="WebSearch.ARSEARCH_RAWUPLOAD_READ_FILEStop"         value="[WebSearch] ARSEARCH_RAWUPLOAD_READ_FILEStop" />
        <string id="WebSearch.AudioSearchUXRawUploadConfirmation"       value="[WebSearch] AudioSearchUXRawUploadConfirmation" />
        <string id="WebSearch.AudioSearchUXRawUploadProgress"           value="[WebSearch] AudioSearchUXRawUploadProgress" />
        <string id="WebSearch.AudioSearchUXRawUploadError"              value="[WebSearch] AudioSearchUXRawUploadError" />

        <string id="WebSearch.PlaceCardMoviesPane"                      value="[WebSearch] PlaceCardMoviesPane"/>
        <string id="WebSearch.PlaceCardExtrasPane"                      value="[WebSearch] PlaceCardExtrasPane"/>
        <string id="WebSearch.PlaceCardEventsQueryResultsStart"         value="[WebSearch] PlaceCardEventsQueryResults Start" />
        <string id="WebSearch.PlaceCardEventsQueryResultsStop"          value="[WebSearch] PlaceCardEventsQueryResults Stop" />
        <string id="WebSearch.PlaceCardMoviesQueryResultsStart"         value="[WebSearch] PlaceCardMoviesQueryResults Start" />
        <string id="WebSearch.PlaceCardMoviesQueryResultsStop"          value="[WebSearch] PlaceCardMoviesQueryResults Stop" />
        <string id="WebSearch.PlaceCardMovieDetailsQueryResultsStart"   value="[WebSearch] PlaceCardMovieDetailsQueryResults Start" />
        <string id="WebSearch.PlaceCardMovieDetailsQueryResultsStop"    value="[WebSearch] PlaceCardMovieDetailsQueryResults Stop" />
        <string id="WebSearch.PlaceCardExtrasQueryResultsStart"         value="[WebSearch] PlaceCardExtrasQueryResults Start" />
        <string id="WebSearch.PlaceCardExtrasQueryResultsStop"          value="[WebSearch] PlaceCardExtrasQueryResults Stop" />
        <string id="WebSearch.PlacesCenterNavigationStart"              value="[WebSearch] PlacesCenterNavigation Start" />
        <string id="WebSearch.PlacesCenterNavigationStop"               value="[WebSearch] PlacesCenterNavigation Stop" />
        <string id="WebSearch.InstrumentationUserIdReceived"            value="[WebSearch] Instrumentation User Id Received" />
        <string id="WebSearch.InstrumentationActivationSuccessSent"     value="[WebSearch] Instrumentation Activation Success Sent" />
        <string id="WebSearch.InstrumentationLayoutSent"                value="[WebSearch] Instrumentation Layout Sent" />
        <string id="WebSearch.InstrumentationPartialImpressionSent"     value="[WebSearch] Instrumentation Partial Impression Sent" />
        <string id="WebSearch.InstrumentationClickEventSent"            value="[WebSearch] Instrumentation Click event Sent" />
        <string id="WebSearch.InstrumentationBatchedLayoutSent"         value="[WebSearch] Instrumentation Batched layout event Sent" />
        <string id="WebSearch.InstrumentationSearchHomeCommandBarClickSent"  value="[WebSearch] Instrumentation Search home command bar click event sent" />
        <string id="WebSearch.InstrumentationHoseCommandBarClickSent"        value="[WebSearch] Instrumentation Hose command bar click event sent" />
        <string id="WebSearch.InstrumentationPageViewQuerySent"              value="[WebSearch] Instrumentation Page view query sent"/>

        <string id="WebSearch.MapsVenueMetadataProcessingStart"         value="[WebSearch] Venue metadata parsing (%1) Start" />
        <string id="WebSearch.MapsVenueMetadataProcessingStop"          value="[WebSearch] Venue metadata parsing (%1) Stop" />
        <string id="WebSearch.MapsVenueMetadataProcessingError"         value="[WebSearch] Venue metadata parsing (%1) Error" />
        <string id="WebSearch.MapsVenueDirectoryFilteringStart"         value="[WebSearch] Venue directory filtering Start" />
        <string id="WebSearch.MapsVenueDirectoryFilteringStop"          value="[WebSearch] Venue directory filtering Stop" />
        <string id="WebSearch.MapsVenueHitTestStart"                    value="[WebSearch] Venue hit testing (%1) Start" />
        <string id="WebSearch.MapsVenueHitTestStop"                     value="[WebSearch] Venue hit testing (%1) Stop" />

        <string id="WebSearch.NavigationEngineSetRouteStart"            value="[WebSearch] NavigationEngine set route Start" />
        <string id="WebSearch.NavigationEngineSetRouteStop"             value="[WebSearch] NavigationEngine set route Stop" />
        <string id="WebSearch.NavigationEngineProcessingLocationStart"  value="[WebSearch] NavigationEngine processing location Start" />
        <string id="WebSearch.NavigationEngineProcessingLocationStop"   value="[WebSearch] NavigationEngine processing location Stop" />
        <string id="WebSearch.NavigationEngineSnapToRouteStart"         value="[WebSearch] NavigationEngine snap to route Start" />
        <string id="WebSearch.NavigationEngineSnapToRouteStop"          value="[WebSearch] NavigationEngine snap to route Stop" />
        <string id="WebSearch.NavigationEngineInfo"                     value="[WebSearch] NavigationEngine Info: Status=%1  CurrentInstructionIndex=%2 DistanceToNextInstruction=%3 IsLocationAccurate=%4 NavigationStarted=%5 Bearing=%6" />
        <string id="WebSearch.NavigationEngineSnapInfo"                 value="[WebSearch] NavigationEngine SnapInfo: SnapFound=%1  SnapPoint=[%2, %3] SnapSegmentIndex=%4 SnapDistance=%5" />
        <string id="WebSearch.NavigationEngineStatusClassifierInfo"     value="[WebSearch] NavigationEngine StatusClassifierInfo: NavigationStatus=%1  fSnapToleranceExpanded=%2  CurrentSnapToleranceDistance=%3 meters  ConsecutiveNonSnapFixes=%4 " />
        <string id="WebSearch.NavigationEngineShrinkSnapTolerance"      value="[WebSearch] NavigationEngine ShrinkSnapTolerance" />
        <string id="WebSearch.NavigationEngineExpandSnapTolerance"      value="[WebSearch] NavigationEngine ExpandSnapTolerance" />

        <string id="WebSearch.DrivingStart"                             value="[WebSearch] Driving start (%1, %2)" />
        <string id="WebSearch.DrivingEnd"                               value="[WebSearch] Driving end (%1, %2)" />
        <string id="WebSearch.DrivingAnnounce"                          value="[WebSearch] Driving announce" />
        <string id="WebSearch.DrivingReroute"                           value="[WebSearch] Driving reroute" />
        <string id="WebSearch.DrivingOffroute"                          value="[WebSearch] Driving offroute" />
        <string id="WebSearch.DrivingBackOnRoute"                       value="[WebSearch] Driving back on route" />
        <string id="WebSearch.DrivingInaccurateLocation"                value="[WebSearch] Driving inaccurate location" />
        <string id="WebSearch.DrivingFlick"                             value="[WebSearch] Driving flick to %1" />
        <string id="WebSearch.DrivingQueryInfo"                         value="[WebSearch] Driving query result start=(%1, %2) end=(%3, %4) n=%5 l=%6" />
        <string id="WebSearch.DrivingHeading"                           value="[WebSearch] Driving heading %1" />
        <string id="WebSearch.DrivingDistanceBeforeTurn"                value="[WebSearch] Driving distance before turn %1" />

        <string id="WebSearch.DirectionsSpeechQueuePlay"                value="[WebSearch] Directions Speech Queue Play" />
        <string id="WebSearch.DirectionsAudioCueQueuePlay"              value="[WebSearch] Directions Audio Cue Queue Play" />

        <string id="WebSearch.EventCardAboutPane"                       value="[WebSearch] EventCard about pane" />
        <string id="WebSearch.EventCardExtrasPane"                      value="[WebSearch] EventCard extras pane" />
        <string id="WebSearch.EventCardPivotingStart"                   value="[WebSearch] EventCard pivoting Start" />
        <string id="WebSearch.EventCardPivotingStop"                    value="[WebSearch] EventCard pivoting Stop" />
        <string id="WebSearch.EventCardNavigationStart"                 value="[WebSearch] EventCardNavigation Start" />
        <string id="WebSearch.EventCardNavigationStop"                  value="[WebSearch] EventCardNavigation Stop" />
        <string id="WebSearch.EventCardTicketProvidersNavigationStart"  value="[WebSearch] EventCardTicketProvidersNavigation Start" />
        <string id="WebSearch.EventCardTicketProvidersNavigationStop"   value="[WebSearch] EventCardTicketProvidersNavigation Stop" />

        <string id="WebSearch.ConfigurationUpdateStart"                 value="[WebSearch] Configuration update start" />
        <string id="WebSearch.ConfigurationUpdateStop"                  value="[WebSearch] Configuration update stop: hr=%1" />
        <string id="WebSearch.ConfigurationDownloadStart"               value="[WebSearch] Configuration download start" />
        <string id="WebSearch.ConfigurationDownloadStop"                value="[WebSearch] Configuration download stop: hr=%1 http=%2" />
        <string id="WebSearch.ConfigurationParseStart"                  value="[WebSearch] Configuration parse start" />
        <string id="WebSearch.ConfigurationParseStop"                   value="[WebSearch] Configuration parse stop: hr=%1" />
        <string id="WebSearch.ConfigurationLoadCategoriesStart"         value="[WebSearch] Configuration load categories start" />
        <string id="WebSearch.ConfigurationLoadCategoriesStop"          value="[WebSearch] Configuration load categories stop: hr=%1" />
        <string id="WebSearch.ConfigurationLoadLocaleStart"             value="[WebSearch] Configuration load locale start: locale=%1" />
        <string id="WebSearch.ConfigurationLoadLocaleStop"              value="[WebSearch] Configuration load locale stop: locale=%1 hr=%2" />
        <string id="WebSearch.ConfigurationSaveStart"                   value="[WebSearch] Configuration save start: old=%1" />
        <string id="WebSearch.ConfigurationSaveStop"                    value="[WebSearch] Configuration save stop: new=%1 hr=%2" />
        <string id="WebSearch.ConfigurationSaveCategoriesStart"         value="[WebSearch] Configuration save categories start" />
        <string id="WebSearch.ConfigurationSaveCategoriesStop"          value="[WebSearch] Configuration save categories stop: hr=%1" />
        <string id="WebSearch.ConfigurationSaveLocalesStart"            value="[WebSearch] Configuration save locales start" />
        <string id="WebSearch.ConfigurationSaveLocalesStop"             value="[WebSearch] Configuration save locales stop: hr=%1" />
        <string id="WebSearch.ConfigurationSaveLocaleStart"             value="[WebSearch] Configuration save locale start: locale=%1" />
        <string id="WebSearch.ConfigurationSaveLocaleStop"              value="[WebSearch] Configuration save locale stop: locale=%1 hr=%2" />
        <string id="WebSearch.ConfigurationLoadStart"                   value="[WebSearch] Configuration load start: version=%1" />
        <string id="WebSearch.ConfigurationLoadStop"                    value="[WebSearch] Configuration load stop: version=%1 hr=%2" />
        <string id="WebSearch.ConfigurationParseError"                  value="[WebSearch] Configuration parse error: %1 hr=%2" />

        <string id="WebSearch.ConfigurationLoadPropertyStart"           value="[WebSearch] Configuration load property start" />
        <string id="WebSearch.ConfigurationLoadPropertyStop"            value="[WebSearch] Configuration load property stop: path=%1, hr=%2" />
        <string id="WebSearch.ConfigurationLoadLocaleNonOssEndpointStart" value="[WebSearch] Configuration load locale non oss endpoint start" />
        <string id="WebSearch.ConfigurationLoadLocaleNonOssEndpointStop"  value="[WebSearch] Configuration load locale non oss endpoint stop: hr=%1" />
        <string id="WebSearch.ConfigurationLoadPrefixListStart"         value="[WebSearch] Configuration load prefix list start" />
        <string id="WebSearch.ConfigurationLoadPrefixListStop"          value="[WebSearch] Configuration load prefix list stop: hr=%1" />
        <string id="WebSearch.ConfigurationLoadAppListStart"            value="[WebSearch] Configuration load app list start" />
        <string id="WebSearch.ConfigurationLoadAppListStop"             value="[WebSearch] Configuration load app list stop: hr=%1" />

        <string id="WebSearch.ConfigurationSavePropertyStart"           value="[WebSearch] Configuration save property start" />
        <string id="WebSearch.ConfigurationSavePropertyStop"            value="[WebSearch] Configuration save property stop: path=%1, hr=%2" />
        <string id="WebSearch.ConfigurationSaveLocaleNonOssEndpointStart" value="[WebSearch] Configuration save locale non oss endpoint start" />
        <string id="WebSearch.ConfigurationSaveLocaleNonOssEndpointStop"  value="[WebSearch] Configuration save locale non oss endpoint stop: hr=%1" />
        <string id="WebSearch.ConfigurationSavePrefixListStart"         value="[WebSearch] Configuration save prefix list start" />
        <string id="WebSearch.ConfigurationSavePrefixListStop"          value="[WebSearch] Configuration save prefix list: hr=%1" />
        <string id="WebSearch.ConfigurationSaveAppListStart"            value="[WebSearch] Configuration save app list start" />
        <string id="WebSearch.ConfigurationSaveAppListStop"             value="[WebSearch] Configuration save app list stop: hr=%1" />

        <string id="WebSearch.ConfigurationSaveOssEndpointStart"        value="[WebSearch] Configuration save oss endpoint start" />
        <string id="WebSearch.ConfigurationSaveOssEndpointStop"         value="[WebSearch] Configuration save oss endpoint stop: hr=%1" />

        <string id="WebSearch.ConfigurationBackgroundWorkerRunStart"    value="[WebSearch] Configuration background worker start" />
        <string id="WebSearch.ConfigurationBackgroundWorkerRunStop"     value="[WebSearch] Configuration background worker stop: hr=%1" />

        <string id="WebSearch.MapsDeviceInteractivityInfo"              value="[WebSearch] DeviceInteractivity Report (status=%1, PM timer=%2)" />

        <string id="WebSearch.NeighborhoodPaneModelsListReady"          value="[WebSearch] Neighborhood Pane Models List Ready: %1" />
        <string id="WebSearch.NeighborhoodVisible"                      value="[WebSearch] Neighborhood Visible: %1 %2 %3" />
        <string id="WebSearch.NeighborhoodCoreStateRetreived"           value="[WebSearch] Neighborhood core state retreived" />
        <string id="WebSearch.NeighborhoodResultsStateRetreived"        value="[WebSearch] Neighborhood results state retreived" />
        <string id="WebSearch.NeighborhoodStatePublished"               value="[WebSearch] Neighborhood state published" />
        <string id="WebSearch.NeighborhoodFilterSetRetreived"           value="[WebSearch] Neighborhood filter set retreived from filtering page: %1" />
        <string id="WebSearch.NeighborhoodFilterSetPublished"           value="[WebSearch] Neighborhood filter set published for filtering page: %1" />
        <string id="WebSearch.NeighborhoodLaunchedAsTask"               value="[WebSearch] Neighborhood was launched as a task from: %1" />
        <string id="WebSearch.NeighborhoodPublishedMapPOIs"             value="[WebSearch] Neighborhood published map POI's" />
        <string id="WebSearch.NeighborhoodFowardNavigate"               value="[WebSearch] Neighborhood foward navigate" />
        <string id="WebSearch.NeighborhoodDeserializeDataStoreQueryStart" value="[WebSearch] Neighborhood deserialize data store query start" />
        <string id="WebSearch.NeighborhoodDeserializeDataStoreQueryStop"  value="[WebSearch] Neighborhood deserialize data store query stop" />
        <string id="WebSearch.NeighborhoodBusinessesQueryStart"         value="[WebSearch] Neighborhood businesses query start" />
        <string id="WebSearch.NeighborhoodBusinessesQueryStop"          value="[WebSearch] Neighborhood businesses query stop" />
        <string id="WebSearch.NeighborhoodActivePane"                   value="[WebSearch] Neighborhood active pane is %1" />

        <string id="WebSearch.ProductCardNavigateById"                  value="[WebSearch] Navigating to product card by ID=%1, query string=%2" />
        <string id="WebSearch.ProductCardNavigateByProductResult"       value="[WebSearch] Navigating to product card by product result - ID=%1, product name=%2" />

        <string id="WebSearch.POIDataStoreQueryStart"                   value="[WebSearch] POIDataStoreQuery start" />
        <string id="WebSearch.POIDataStoreQueryStop"                    value="[WebSearch] POIDataStoreQuery stop" />

        <!-- UIXSchemaState strings -->
        <string id="WebSearch.UIXSchemaStateLock"                       value="[WebSearch] UIXSchemaState Lock" />
        <string id="WebSearch.UIXSchemaStateUnlock"                     value="[WebSearch] UIXSchemaState Unlock" />
        <string id="WebSearch.UIXSchemaStateIsUnloaded"                 value="[WebSearch] UIXSchemaState IsUnloaded %1" />
        <string id="WebSearch.UIXSchemaStateSetUnloaded"                value="[WebSearch] UIXSchemaState SetUnloaded" />

        <string id="WebSearch.DataProcessingStart"                      value="[WebSearch] Data processing start: %1" />
        <string id="WebSearch.DataProcessingStop"                       value="[WebSearch] Data processing stop: %1" />
        <string id="WebSearch.WorkQueueStart"                           value="[WebSearch] Work queue start: %1" />
        <string id="WebSearch.WorkQueueStop"                            value="[WebSearch] Work queue stop: %1" />

        <string id="WebSearch.NonBlockingWaitCursorVisible"             value="[WebSearch] Non Blocking Wait Cursor Visible: %1" />

        <string id="WebSearch.PoidbInitializingStart"                   value="[WebSearch] POIFileDataStore Initializing Start"/>
        <string id="WebSearch.PoidbInitializingStop"                    value="[WebSearch] POIFileDataStore Initializing Stop"/>
        <string id="WebSearch.PoidbInitialize"                          value="[WebSearch] POIFileDataStore Initialize"/>
        <string id="WebSearch.PoidbClose"                               value="[WebSearch] POIFileDataStore Close"/>
        <string id="WebSearch.PoidbAddpoiStart"                         value="[WebSearch] POIFileDataStore Add POI Start"/>
        <string id="WebSearch.PoidbAddpoiStop"                          value="[WebSearch] POIFileDataStore Add POI Stop"/>
        <string id="WebSearch.PoidbUpdatingAccesstimeStart"             value="[WebSearch] POIFileDataStore Updating Access Time Start"/>
        <string id="WebSearch.PoidbUpdatingAccesstimeStop"              value="[WebSearch] POIFileDataStore Updating Access Time Stop"/>
        <string id="WebSearch.PoimtfInitialize"                         value="[WebSearch] POIMTFDataStore Initialize"/>
        <string id="WebSearch.PoimtfClose"                              value="[WebSearch] POIMTFDataStore Close"/>
        <string id="WebSearch.PoimtfGetcandidateStart"                  value="[WebSearch] POIMTFDataStore Get Candidate Start"/>
        <string id="WebSearch.PoimtfGetcandidateStop"                   value="[WebSearch] POIMTFDataStore Get Candidate Stop"/>

        <!-- Enum strings -->
        <string id="Enums.LocationAccuracy_High"                        value="High" />
        <string id="Enums.LocationAccuracy_PowerOptimized"              value="Power optimzied" />
        <string id="Enums.LocationGenerate_Last"                        value="Last" />
        <string id="Enums.LocationGenerate_First"                       value="First" />
        <string id="Enums.LocationGenerate_Best"                        value="Best" />
        <string id="Enums.PageID_SearchHome"                            value="SearchHome" />
        <string id="Enums.PageID_SearchResults"                         value="SearchResults" />
        <string id="Enums.PageID_MapsHome"                              value="MapsHome" />
        <string id="Enums.PageID_LocalCard"                             value="LocalCard" />
        <string id="Enums.PageID_MapsSearch"                            value="MapsSearch" />
        <string id="Enums.PageID_MapsSearchResultsList"                 value="MapsSearchResultsList" />
        <string id="Enums.PageID_DirectionsOverlay"                     value="DirectionsOverlay" />
        <string id="Enums.PageID_DirectionsList"                        value="DirectionsList" />
        <string id="Enums.PageID_DirectionsClarifyList"                 value="DirectionsClarifyList" />
        <string id="Enums.PageID_ARViewfinder"                          value="ARViewfinder" />
        <string id="Enums.PageID_ReviewsCard"                           value="ReviewsCard" />
        <string id="Enums.PageID_ARImage"                               value="ARImage" />
        <string id="Enums.PageID_MovieCard"                             value="MovieCard" />
        <string id="Enums.PageID_ProductCard"                           value="ProductCard" />
        <string id="Enums.PageID_OCRHome"                               value="OCRHome" />
        <string id="Enums.PageID_QrcodePage"                            value="QrcodePage" />
        <string id="Enums.PageID_MoreResults"                           value="MoreResults" />
        <string id="Enums.PageID_ImagePreview"                          value="ImagePreview" />
        <string id="Enums.NavigationStatus_Undetermined"                value="Undetermined" />
        <string id="Enums.NavigationStatus_AwayFromStart"               value="AwayFromStart" />
        <string id="Enums.NavigationStatus_ProceedingToStart"           value="ProceedingToStart" />
        <string id="Enums.NavigationStatus_MovingOnRoute"               value="MovingOnRoute" />
        <string id="Enums.NavigationStatus_StoppedOnRoute"              value="StoppedOnRoute" />
        <string id="Enums.NavigationStatus_DriftingFromRoute"           value="DriftingFromRoute" />
        <string id="Enums.NavigationStatus_OffRoute"                    value="OffRoute" />
        <string id="Enums.NavigationStatus_Arrived"                     value="Arrived" />
        <string id="Enums.InteractivityType_Tracking"                   value="Tracking" />
        <string id="Enums.InteractivityType_TrackingAndMoving"          value="TrackingAndMoving" />
        <string id="Enums.InteractivityType_None"                       value="None" />

        <!-- Explore and image of the day strings  -->
        <string id="WebSearch.ExploreQueryStart"                        value="[WebSearch] Explore query start"/>
        <string id="WebSearch.ExploreQueryStop"                         value="[WebSearch] Explore query stop"/>
        <string id="WebSearch.ExploreAddCategoryCardsStart"             value="[WebSearch] Explore - Start adding category cards"/>
        <string id="WebSearch.ExploreAddCategoryCardsStop"              value="[WebSearch] Explore - Stop adding category cards"/>
        <string id="WebSearch.ExploreLoadingCard"                       value="[WebSearch] Explore - Show loading card"/>
        <string id="WebSearch.ExploreErrorCard"                         value="[WebSearch] Explore- Show error card"/>
        <string id="WebSearch.ExploreSwipeToCategoryCard"               value="[WebSearch] Explore - Swipe to a category card"/>
        <string id="WebSearch.ExploreTapToLaunchQuickCard"              value="[WebSearch] Explore - Tap to launch quick card"/>
        <string id="WebSearch.ExploreTapToLaunchDeepDive"               value="[WebSearch] Explore - Tap to launch deep dive"/>
        <string id="WebSearch.IOTDQueryStart"                           value="[WebSearch] IOTD - Query started"/>
        <string id="WebSearch.IOTDQueryStop"                            value="[WebSearch] IOTD- Query done"/>
        <string id="WebSearch.PortraitIOTDDownloadStart"                value="[WebSearch] Start download of portrait image"/>
        <string id="WebSearch.PortraitIOTDDownloadStop"                 value="[WebSearch] Stop download of portrait image"/>
        <string id="WebSearch.LandscapeIOTDDownloadStart"               value="[WebSearch] Start download of landscape image"/>
        <string id="WebSearch.LandscapeIOTDDownloadStop"                value="[WebSearch] Stop download of landscape image"/>
        <string id="WebSearch.IOTDVisible"                              value="[WebSearch] IOTD - Image is visible"/>
        <string id="WebSearch.IOTDFaded"                                value="[WebSearch] IOTD - Image is faded out"/>
        <string id="WebSearch.HotspotsStart"                            value="[WebSearch] IOTD - Start displaying hotspots"/>
        <string id="WebSearch.HotspotsStop"                             value="[WebSearch] IOTD - Done displaying hotspost"/>

        <!-- General -->
        <string id="WebSearch.EnteredContentIntoEditBox"                  value="[WebSearch] Entered content into edit box"/>
        <string id="WebSearch.SearchSubmitContentToSuggestionsBar"        value="[WebSearch] Content submitted to suggestions bar"/>
        <string id="WebSearch.SearchSettingsPageVisible"                  value="[WebSearch] Search settings page is visible"/>

        <!-- Venue Maps -->
        <string id="WebSearch.VenueMapMetadataQueryStart"                 value="[WebSearch] VenueMap - VenueMapMetadataQueryStart"/>
        <string id="WebSearch.VenueMapMetadataQueryStop"                  value="[WebSearch] VenueMap - VenueMapMetadataQueryStop"/>
        <string id="WebSearch.VenueMapTFEQueryStart"                      value="[WebSearch] VenueMap - VenueMapTFEQueryStart"/>
        <string id="WebSearch.VenueMapTFEQueryStop"                       value="[WebSearch] VenueMap - VenueMapTFEQueryStop"/>
        <string id="WebSearch.VenueMapShowPolygonsStart"                  value="[WebSearch] VenueMap - VenueMapShowPolygonsStart"/>
        <string id="WebSearch.VenueMapShowPolygonsStop"                   value="[WebSearch] VenueMap - VenueMapShowPolygonsStop"/>
        <string id="WebSearch.VenueMapHidePolygonsStart"                  value="[WebSearch] VenueMap - VenueMapHidePolygonsStart"/>
        <string id="WebSearch.VenueMapHidePolygonsStop"                   value="[WebSearch] VenueMap - VenueMapHidePolygonsStop"/>
        <string id="WebSearch.VenueMapHitTestingStart"                    value="[WebSearch] VenueMap - VenueMapHitTestingStart"/>
        <string id="WebSearch.VenueMapHitTestingStop"                     value="[WebSearch] VenueMap - VenueMapHitTestingStop"/>

        <!-- Landmarks -->
        <string id="WebSearch.LandmarkTFEQueryStart"                      value="[WebSearch] Landmark - LandmarkTFEQueryStart"/>
        <string id="WebSearch.LandmarkTFEQueryStop"                       value="[WebSearch] Landmark - LandmarkTFEQueryStop"/>
        <string id="WebSearch.LandmarkShowLandmarksStart"                 value="[WebSearch] Landmark - LandmarkShowLandmarksStart"/>
        <string id="WebSearch.LandmarkShowLandmarksStop"                  value="[WebSearch] Landmark - LandmarkShowLandmarksStop"/>
        <string id="WebSearch.LandmarkHideLandmarksStart"                 value="[WebSearch] Landmark - LandmarkHideLandmarksStart"/>
        <string id="WebSearch.LandmarkHideLandmarksStop"                  value="[WebSearch] Landmark - LandmarkHideLandmarksStop"/>
        <string id="WebSearch.LandmarkHitTestingStart"                    value="[WebSearch] Landmark - LandmarkHitTestingStart"/>
        <string id="WebSearch.LandmarkHitTestingStop"                     value="[WebSearch] Landmark - LandmarkHitTestingStop"/>

        <string id="Maps.OnlineLocationAutosuggestGetCandidatesStart"         value="[Maps] OnlineLocationAutosuggest GetCandidates Start"/>
        <string id="Maps.OnlineLocationAutosuggestGetCandidatesStop"          value="[Maps] OnlineLocationAutosuggest GetCandidates Stop"/>
        <string id="Maps.OnlineLocationAutosuggestCreateSuggestionListStart"  value="[Maps] OnlineLocationAutosuggest CreateSuggestionList Start"/>
        <string id="Maps.OnlineLocationAutosuggestCreateSuggestionListStop"   value="[Maps] OnlineLocationAutosuggest CreateSuggestionList Stop"/>
        <string id="Maps.OnlineLocationAutosuggestGetLocationDataStart"       value="[Maps] OnlineLocationAutosuggest GetLocationData Start"/>
        <string id="Maps.OnlineLocationAutosuggestGetLocationDataStop"        value="[Maps] OnlineLocationAutosuggest GetLocationData Stop"/>
        <string id="Maps.OnlineLocationAutosuggestDownloaderThreadStart"      value="[Maps] OnlineLocationAutosuggest DownloaderThread Start"/>
        <string id="Maps.OnlineLocationAutosuggestDownloaderThreadStop"       value="[Maps] OnlineLocationAutosuggest DownloaderThread Stop"/>
        <string id="Maps.OnlineLocationAutosuggestCreateQueryStart"           value="[Maps] OnlineLocationAutosuggest CreateQuery Start"/>
        <string id="Maps.OnlineLocationAutosuggestCreateQueryStop"            value="[Maps] OnlineLocationAutosuggest CreateQuery Stop"/>
        <string id="Maps.OnlineLocationAutosuggestDoQueryStart"               value="[Maps] OnlineLocationAutosuggest DoQuery Start"/>
        <string id="Maps.OnlineLocationAutosuggestDoQueryStop"                value="[Maps] OnlineLocationAutosuggest DoQuery Stop"/>
        <string id="Maps.OnlineLocationAutosuggestDownloadQueryStart"         value="[Maps] OnlineLocationAutosuggest DownloadQuery Start"/>
        <string id="Maps.OnlineLocationAutosuggestDownloadQueryStop"          value="[Maps] OnlineLocationAutosuggest DownloadQuery Stop"/>
        <string id="Maps.OnlineLocationAutosuggestParseQueryStart"            value="[Maps] OnlineLocationAutosuggest ParseQuery Start"/>
        <string id="Maps.OnlineLocationAutosuggestParseQueryStop"             value="[Maps] OnlineLocationAutosuggest ParseQuery Stop"/>

        <string id="Maps.WinHttpDownloaderCrackUrlStart"        value="[Maps] WinHttpDownloader CrackUrl Start"/>
        <string id="Maps.WinHttpDownloaderCrackUrlStop"         value="[Maps] WinHttpDownloader CrackUrl Stop"/>
        <string id="Maps.WinHttpDownloaderConnectStart"         value="[Maps] WinHttpDownloader Connect Start"/>
        <string id="Maps.WinHttpDownloaderConnectStop"          value="[Maps] WinHttpDownloader Connect Stop"/>
        <string id="Maps.WinHttpDownloaderOpenRequestStart"     value="[Maps] WinHttpDownloader OpenRequest Start"/>
        <string id="Maps.WinHttpDownloaderOpenRequestStop"      value="[Maps] WinHttpDownloader OpenRequest Stop"/>
        <string id="Maps.WinHttpDownloaderSendRequestStart"     value="[Maps] WinHttpDownloader SendRequest Start"/>
        <string id="Maps.WinHttpDownloaderSendRequestStop"      value="[Maps] WinHttpDownloader SendRequest Stop"/>
        <string id="Maps.WinHttpDownloaderReceiveResponseStart" value="[Maps] WinHttpDownloader ReceiveResponse Start"/>
        <string id="Maps.WinHttpDownloaderReceiveResponseStop"  value="[Maps] WinHttpDownloader ReceiveResponse Stop"/>
        <string id="Maps.WinHttpDownloaderReadDataStart"        value="[Maps] WinHttpDownloader ReadData Start"/>
        <string id="Maps.WinHttpDownloaderReadDataStop"         value="[Maps] WinHttpDownloader ReadData Stop"/>
        <string id="Maps.WinHttpDownloaderStreamCreateStart"    value="[Maps] WinHttpDownloader StreamCreate Start"/>
        <string id="Maps.WinHttpDownloaderStreamCreateStop"     value="[Maps] WinHttpDownloader StreamCreate Stop"/>
        <string id="Maps.WinHttpDownloaderStreamWriteStart"     value="[Maps] WinHttpDownloader StreamWrite Start"/>
        <string id="Maps.WinHttpDownloaderStreamWriteStop"      value="[Maps] WinHttpDownloader StreamWrite Stop"/>
        <string id="Maps.WinHttpDownloaderStreamSeekStart"      value="[Maps] WinHttpDownloader StreamSeek Start"/>
        <string id="Maps.WinHttpDownloaderStreamSeekStop"       value="[Maps] WinHttpDownloader StreamSeek Stop"/>       
        
        <string id="DeviceSearch.QueryExecuteStart"                     value="[DeviceSearch] Device Search Query Execte Start"/>
        <string id="DeviceSearch.QueryExecuteStop"                      value="[DeviceSearch] Device Search Query Execute Stopped"/>
        <string id="DeviceSearch.QueryProcessStart"                     value="[DeviceSearch] Device Search Query Process Start"/>
        <string id="DeviceSearch.QueryProcessStop"                      value="[DeviceSearch] Device Search Query Process Stopped"/>
        <string id="DeviceSearch.EmailQueryStart"                       value="[DeviceSearch] Email Search Start"/>
        <string id="DeviceSearch.EmailQueryStop"                        value="[DeviceSearch] Email Search Stopped"/>
        <string id="DeviceSearch.ContactsQueryStart"                    value="[DeviceSearch] Contacts Search Start"/>
        <string id="DeviceSearch.ContactsQueryStop"                     value="[DeviceSearch] Contacts Search Stopped"/>
        <string id="DeviceSearch.AppsQueryStart"                        value="[DeviceSearch] Apps Search Start"/>
        <string id="DeviceSearch.AppsQueryStop"                         value="[DeviceSearch] Apps Search Stopped"/>
        <string id="DeviceSearch.SettingsQueryStart"                    value="[DeviceSearch] Settings Search Start"/>
        <string id="DeviceSearch.SettingsQueryStop"                     value="[DeviceSearch] Settings Search Stopped"/>

        <string id="SpeechUX.RpcServerStart"                            value="SpeechCanvas RPC server started: (%1)" />
        <string id="SpeechUX.RpcServerStop"                             value="SpeechCanvas RPC Server stopped." />

        <string id="CortanaProfile.InterestListLoadStart"             value="[Profile] Interest List Load Start" />
        <string id="CortanaProfile.InterestListLoadStop"              value="[Profile] Interest List Load Stop" />
        <string id="CortanaProfile.InterestPageLoadStart"             value="[Profile] Interest Page Load Start" />
        <string id="CortanaProfile.InterestPageLoadStop"              value="[Profile] Interest Page Load Stop" />
        <string id="CortanaProfile.InterestPageSaveStart"             value="[Profile] Interest Page Save Start" />
        <string id="CortanaProfile.InterestPageSaveStop"              value="[Profile] Interest Page Save Stop" />
        <string id="CortanaProfile.AddInterestPageLoadStart"          value="[Profile] Add Interest Page Load Start" />
        <string id="CortanaProfile.AddInterestPageLoadStop"           value="[Profile] Add Interest Page Load Stop" />

        <string id="AssistUX.Launched"                                value="[AssistUX] Launched" />
        <string id="AssistUX.ScreenIdSet"                             value="[AssistUX] ScreenId Set: (%1)" />
        <string id="AssistUX.ProactivePageLoadStart"                  value="[AssistUX] Proactive HTTP page load Start" />
        <string id="AssistUX.ProactivePageLoadStop"                   value="[AssistUX] Proactive HTTP page load Stop" />
        <string id="AssistUX.ProactivePeekDisplayed"                  value="[AssistUX] Proactive Content Displayed (Peek Mode)" />
        <string id="AssistUX.ProactiveDisplayed"                      value="[AssistUX] Proacitve Content Displayed (Full Screen)" />
        <string id="AssistUX.ReactivePageLoadStart"                   value="[AssistUX] Reactive HTTP page load Start" />
        <string id="AssistUX.ReactivePageLoadStop"                    value="[AssistUX] Reactive HTTP page load Stop" />
        <string id="AssistUX.ReactiveInsertAnswerStart"               value="[AssistUX] Reactive InsertAnswer Start" />
        <string id="AssistUX.ReactiveInsertAnswerStop"                value="[AssistUX] Reactive InsertAnswer Stop" />
        <string id="AssistUX.ReactivePagePrefetchStart"               value="[AssistUX] Reactive HTTP page prefetch Start" />
        <string id="AssistUX.ReactivePagePrefetchStop"                value="[AssistUX] Reactive HTTP page prefetch Stop" />
        
        <string id="InterestExtraction.EnsureSyncPartnersStart"        value="[InterestExtraction] EnsureSyncPartners Start" />
        <string id="InterestExtraction.EnsureSyncPartnersStop"         value="[InterestExtraction] EnsureSyncPartners Stop" />
        <string id="InterestExtraction.UpdateStoreStart"               value="[InterestExtraction] UpdateStore Start: (%1), type: (%2)" />
        <string id="InterestExtraction.UpdateStoreStop"                value="[InterestExtraction] UpdateStore Stop: (%1), type: (%2)" />
        <string id="InterestExtraction.UpdateFolderStart"              value="[InterestExtraction] UpdateFolder Start: (%1), type: (%2)" />
        <string id="InterestExtraction.UpdateFolderStop"               value="[InterestExtraction] UpdateFolder Stop: (%1), type: (%2)" />
        <string id="InterestExtraction.CollectFolderChangesStart"      value="[InterestExtraction] CollectFolderChanges Start: (%1), type: (%2)" />
        <string id="InterestExtraction.CollectFolderChangesStop"       value="[InterestExtraction] CollectFolderChanges Stop: (%1), type: (%2)" />
        <string id="InterestExtraction.ProcessFolderChangesStart"      value="[InterestExtraction] ProcessFolderChanges Start: (%1), type: (%2)" />
        <string id="InterestExtraction.ProcessFolderChangesStop"       value="[InterestExtraction] ProcessFolderChanges Stop: (%1), type: (%2)" />
        <string id="InterestExtraction.ProcessItemChangesStart"        value="[InterestExtraction] ProcessItemChanges Start: (%1), type: (%2)" />
        <string id="InterestExtraction.ProcessItemChangesStop"         value="[InterestExtraction] ProcessItemChanges Stop: (%1), type: (%2)" />
        
        <string id="InterestExtraction.Schema.TextExtractionStart"             value="[InterestExtraction] SchemaTextExtraction Start" />
        <string id="InterestExtraction.Schema.TextExtractionStop"              value="[InterestExtraction] SchemaTextExtraction Stop: hr=%1" />
        <string id="InterestExtraction.Schema.JsonLdExtractionStart"           value="[InterestExtraction] SchemaJsonLdExtraction Start" />
        <string id="InterestExtraction.Schema.JsonLdExtractionStop"            value="[InterestExtraction] SchemaJsonLdExtraction Stop: hr=%1" />
        <string id="InterestExtraction.Schema.MicrodataExtractionStart"        value="[InterestExtraction] SchemaMicrodataExtraction Start" />
        <string id="InterestExtraction.Schema.MicrodataExtractionStop"         value="[InterestExtraction] SchemaMicrodataExtraction Stop: hr=%1" />

        <!--AssistUX settings strings-->
        <string id="AssistUXSettings.AssistUXSettingsPageVisible" value="[AssistUXSettings] AssistUX settings page is visible"/>
        <string id="AssistUXSettings.AssistUXSettingsPageInvokeFromNotebook" value="[AssistUXSettings] AssistUX settings page invoked from Notebook"/>

        <!-- AssistUX GUI Form events -->
        <string id="AssistUX.AssistUXGUIFormEditBoxSubmit"        value="[AssistUX] GUI Form Edit box submitted"/>
        <string id="AssistUX.AssistUXActionCompletedConfirmation" value="[AssistUX] Action completed confirmation and UI restored"/>

        <!--DND settings strings-->
        <string id="DndSettings.DndSettingsPageVisible" value="[DndSettings] DND settings page is visible."/>
        <string id="DndSettings.DndSettingsPageInvokeFromNotebook" value="[DndSettings] DND settings page invoked from Notebook"/>

        <!--SmartExtraction strings-->
        <string id="SmartExtraction.SniffingInTextStart"        value="[SmartExtraction] Sniffing in text Start" />
        <string id="SmartExtraction.SniffingInTextStop"         value="[SmartExtraction] Sniffing in text Stop" />
        <string id="SmartExtraction.ExtractionInTextStart"      value="[SmartExtraction] Extraction in text Start" />
        <string id="SmartExtraction.ExtractionInTextStop"       value="[SmartExtraction] Extraction in text Stop" />
      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>
