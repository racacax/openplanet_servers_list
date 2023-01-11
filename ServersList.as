
bool isOpened = false;
string PLUGIN_NAME = "Servers List";
string BASE_URL = "https://live-services.trackmania.nadeo.live/api/token/";

Json::Value clubRooms = Json::Array();
Json::Value totdRoom = Json::Object();
Json::Value campaignRoom = Json::Object();
Json::Value arcadeRoom = Json::Object();

string searchString = "";
string currentSearchString = "";
int page = 0;
int maxPage = 0;
Room@ currentRoom = null;
bool clientInUse = false;
bool inputFocused = false;

void Main()
{
	isOpened = firstStart || automaticallyDisplay;
	firstStart = false;
	NadeoServices::AddAudience("NadeoLiveServices");
	while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) {
		yield();
	}
	while(!isOpened) {
		yield();
	}
	AddEvent("getAllRooms");
	while(true) {
		HandleEvents();
	}
}

UI::InputBlocking OnKeyPress(bool down, VirtualKey key)
{
	if(enableShortcut && key == shortcutKey && down) {
		isOpened = !isOpened;
	}
	return UI::InputBlocking::DoNothing;
}

void RenderMenu()
{
	if (UI::MenuItem("\\$9cf" + Icons::Server + "\\$z Servers list", "", isOpened)) {
		isOpened = !isOpened;
	}
}

void Render() {
    UI::SetNextWindowSize(800, 480, UI::Cond::FirstUseEver);
	if(isOpened) {
		if (UI::Begin("Servers list", isOpened)){
			int currentPage = page;
			UI::BeginTable("searchTable", 3, UI::TableFlags::SizingStretchProp);
			UI::TableNextRow();
			UI::TableNextColumn();
			if(UI::Button(Icons::Search + " Search") || (inputFocused && UI::IsKeyPressed(UI::Key::Enter))) {
				page = 0;
				currentSearchString = searchString;
				AddEvent("getAllRooms");
			}
			UI::TableNextColumn();
			searchString = UI::InputText("Room name", searchString);
			inputFocused = UI::IsItemActive();
			UI::TableNextColumn();
			if(UI::Button(" Refresh")) {
				AddEvent("getAllRooms");
			}
			UI::EndTable();
			UI::BeginTable("pageTable", 6, UI::TableFlags::SizingFixedFit);
			UI::TableNextRow();
			UI::TableNextColumn();
			if(currentPage == 0) { UI::BeginDisabled(); }
			if(UI::Button(" First")) {
				page = 0;
				AddEvent("getAllRooms");
			}
			UI::TableNextColumn();
			if(UI::Button(" Previous")) {
				page--;
				AddEvent("getAllRooms");
			}
			if(currentPage == 0) { UI::EndDisabled(); }
			UI::TableNextColumn();
			UI::Text("Page "+ tostring(page + 1));
			UI::TableNextColumn();
			
			if(currentPage == maxPage) { UI::BeginDisabled(); }
			if(UI::Button(" Next")) {
				page++;
				AddEvent("getAllRooms");
			}
			UI::TableNextColumn();
			if(UI::Button(" Last")) {
				page = maxPage;
				AddEvent("getAllRooms");
			}
			if(currentPage == maxPage) { UI::EndDisabled(); }
			if(clientInUse) {
				UI::TableNextColumn();
				UI::Text("Loading...");
			}
			UI::EndTable();

			int8 columns = 6;
			if(displayRegion) columns++;
			UI::BeginTable("serversTable", columns, UI::TableFlags::SizingStretchProp);
			UI::TableNextRow();
			UI::TableNextColumn();
			UI::Text("Name");
			UI::TableNextColumn();
			UI::Text("Club");
			UI::TableNextColumn();
			UI::Text("Players");
			UI::TableNextColumn();
			UI::Text("Mode");
			UI::TableNextColumn();
			if(displayRegion) {
				UI::Text("Region");
				UI::TableNextColumn();
			}
			UI::Text("Actions");
			if(page == 0 && displaySpecialRooms) {
				if(totdRoom.GetType() != Json::Type::Null && Client::totdRoomLoaded == 1) {
					Room totdRoomInstance = CreateTotdRoomFromJson(totdRoom);
					if(totdRoomInstance.name.ToLower().Contains(currentSearchString.ToLower())) {
						RenderRoom(totdRoomInstance, -1);
					}
				}
				if(arcadeRoom.GetType() != Json::Type::Null && Client::arcadeRoomLoaded == 1) {
					Room arcadeRoomInstance = CreateArcadeRoomFromJson(arcadeRoom);
					if(arcadeRoomInstance.name.ToLower().Contains(currentSearchString.ToLower())) {
						RenderRoom(arcadeRoomInstance, -3);
					}
				}
				if(campaignRoom.GetType() != Json::Type::Null && Client::campaignRoomLoaded == 1) {
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
			UI::EndTable();
		}
		UI::End();
	}
}


void RenderRoom(Room room, int i) {
	UI::TableNextRow();
	UI::TableNextColumn();
	UI::Text(ColoredString(room.name));
	UI::TableNextColumn();
	UI::Text(ColoredString(room.clubName));
	UI::TableNextColumn();
	UI::Text(tostring(room.playerCount) + " / " + room.GetMaxPlayers());
	UI::TableNextColumn();
	UI::Text(room.gameMode);
	UI::TableNextColumn();
	if(displayRegion) {
		UI::Text(room.region);
		UI::TableNextColumn();
	}
	if(currentRoom !is null && currentRoom.id == room.id && clientInUse) {
		UI::PushStyleColor(UI::Col::Button, vec4(0,0,0,0));
		UI::BeginDisabled();
		UI::Button("Loading...");
		UI::EndDisabled();
		UI::PopStyleColor(1);
	} else {
		UI::BeginTable("actions##"+ tostring(i), 3, UI::TableFlags::SizingFixedFit);
		UI::TableNextRow();

		UI::PushStyleColor(UI::Col::Button, vec4(0,0.8,0,1));
		UI::TableNextColumn();
		if(UI::Button("##" + tostring(i))){ // Play
			@currentRoom = room;
			AddEvent("qjoinRoom");
		}
		UI::PopStyleColor(1);

		UI::TableNextColumn();
		if(UI::Button("##" + tostring(i))){ // Spectate
			@currentRoom = room;
			AddEvent("qspectateRoom");
		}

		UI::PushStyleColor(UI::Col::Button, vec4(1,0.8,0,1));
		UI::TableNextColumn();
		if(UI::Button("##" + tostring(i))){ // Details
			@currentRoom = room;
			AddEvent("joinRoom");
		}
		UI::PopStyleColor(1);
		
		UI::EndTable();
	}
}