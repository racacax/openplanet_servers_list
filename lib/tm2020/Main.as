#if TMNEXT
string BASE_URL = "https://live-services.trackmania.nadeo.live/api/token/";

Json::Value clubRooms = Json::Array();
Json::Value totdRoom = Json::Object();
Json::Value campaignRoom = Json::Object();
Json::Value arcadeRoom = Json::Object();

void RunGameSpecificMain() {
	NadeoServices::AddAudience("NadeoLiveServices");
	while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) {
		yield();
	}
}

void RenderGameSpecificHeader() {
}

void RenderGameSpecificUI() {
    if(page == 0) {
        if(displayTotdRoom && totdRoom.GetType() != Json::Type::Null && Client::totdRoomLoaded == 1) {
            Room totdRoomInstance = CreateTotdRoomFromJson(totdRoom);
            if(totdRoomInstance.name.ToLower().Contains(currentSearchString.ToLower())) {
                RenderRoom(totdRoomInstance, -1);
            }
        }
        if(displayArcadeRoom && arcadeRoom.GetType() != Json::Type::Null && Client::arcadeRoomLoaded == 1) {
            Room arcadeRoomInstance = CreateArcadeRoomFromJson(arcadeRoom);
            if(arcadeRoomInstance.name.ToLower().Contains(currentSearchString.ToLower())) {
                RenderRoom(arcadeRoomInstance, -3);
            }
        }
        if(displayCampaignRoom && campaignRoom.GetType() != Json::Type::Null && Client::campaignRoomLoaded == 1) {
            Room campaignRoomInstance = CreateCampaignRoomFromJson(campaignRoom);
            if(campaignRoomInstance.name.ToLower().Contains(currentSearchString.ToLower())) {
                RenderRoom(campaignRoomInstance, -2);
            }
        }
    }
    if(Client::clubRoomsLoaded == 1) {
        for(uint i=0; i< clubRooms["clubRoomList"].Length; i++) {
            Room room = CreateClubRoomFromJson(clubRooms["clubRoomList"][i]);
            RenderRoom(room, i);
        }
    }
}
#endif