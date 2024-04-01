#if TMNEXT
const Json::Value ROOM_TYPES = Json::Parse('{"club": "Club Rooms", "review": "Review Rooms"}');
const Json::Value ROOM_TYPES_KEYS = ROOM_TYPES.GetKeys();
string BASE_URL = "https://live-services.trackmania.nadeo.live/api/token/";
uint nbColumnsHeader = 2;

void RunGameSpecificMain() {
	NadeoServices::AddAudience("NadeoLiveServices");
	while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) {
		yield();
	}
}

void RenderGameSpecificHeader() {
	UI::TableNextColumn();
	if(UI::BeginCombo("Room type", string(ROOM_TYPES[roomType]))) {
		for(uint i=0; i<ROOM_TYPES_KEYS.Length; i++) {
			string key = ROOM_TYPES_KEYS[i];
			if(UI::Selectable(string(ROOM_TYPES[key]), roomType == key)) {
				roomType = key;
				page = 0;
				AddEvent("getAllRooms");
			}
		}
		UI::EndCombo();
	}
}
#endif