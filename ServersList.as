
bool isOpened = false;
string PLUGIN_NAME = "Servers List";

string searchString = "";
string currentSearchString = "";
int page = 0;
int maxPage = 0;
Room@ currentRoom = null;
bool clientInUse = false;
bool inputFocused = false;
array<Room> servers = {};

void Main()
{
	isOpened = firstStart || automaticallyDisplay;
	firstStart = false;
	RunGameSpecificMain();
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
			if(UI::Button(Icons::Refresh + " Refresh")) {
				AddEvent("getAllRooms");
			}
			UI::EndTable();
			UI::BeginTable("pageTable", 6, UI::TableFlags::SizingFixedFit);
			UI::TableNextRow();
			UI::TableNextColumn();
			if(currentPage == 0) { UI::BeginDisabled(); }
			if(UI::Button(Icons::FastBackward + " First")) {
				page = 0;
				AddEvent("getAllRooms");
			}
			UI::TableNextColumn();
			if(UI::Button(Icons::Backward + " Previous")) {
				page--;
				AddEvent("getAllRooms");
			}
			if(currentPage == 0) { UI::EndDisabled(); }
			UI::TableNextColumn();
			UI::Text("Page "+ tostring(page + 1));
			UI::TableNextColumn();
			
			if(currentPage == maxPage) { UI::BeginDisabled(); }
			if(UI::Button(Icons::Forward + " Next")) {
				page++;
				AddEvent("getAllRooms");
			}
			UI::TableNextColumn();
			if(!lastButtonEnabled) UI::BeginDisabled();
			if(UI::Button(Icons::FastForward + " Last")) {
				page = maxPage;
				AddEvent("getAllRooms");
			}
			if(!lastButtonEnabled) UI::EndDisabled();
			if(currentPage == maxPage) { UI::EndDisabled(); }
			if(clientInUse) {
				UI::TableNextColumn();
				UI::Text("Loading...");
			}
			UI::EndTable();
			RenderGameSpecificHeader();
			int8 columns = 5;
			if(displayRegion) columns++;
			if(displayClubName) columns++;
			UI::BeginTable("serversTable", columns, UI::TableFlags::SizingStretchProp);
			UI::TableNextRow();
			UI::TableNextColumn();
			UI::Text("Name");
			UI::TableNextColumn();
			if(displayClubName) {
				UI::Text("Club");
				UI::TableNextColumn();
			}
			UI::Text("Players");
			UI::TableNextColumn();
			UI::Text("Mode");
			UI::TableNextColumn();
			if(displayRegion) {
				UI::Text("Region");
				UI::TableNextColumn();
			}
			if(displayTitlepack) {
				UI::Text("Title");
				UI::TableNextColumn();
			}
			UI::Text("Actions");
			for(uint i=0; i< servers.Length; i++) {
				RenderRoom(servers[i], i);
			}
			UI::EndTable();
		}
		UI::End();
	}
}


void RenderRoom(Room room, int i) {
	UI::TableNextRow();
	UI::TableNextColumn();
	string name = room.name;
	if(room.hasPassword) {
		name = Icons::Lock + " " + name;
	}
	UI::Text(ColoredString(name));
	UI::TableNextColumn();
	if(displayClubName) {
		UI::Text(ColoredString(room.clubName));
		UI::TableNextColumn();
	}
	UI::Text(tostring(room.playerCount) + " / " + room.GetMaxPlayers());
	UI::TableNextColumn();
	UI::Text(room.gameMode);
	UI::TableNextColumn();
	if(displayRegion) {
		UI::Text(room.region);
		UI::TableNextColumn();
	}
	if(displayTitlepack) {
		UI::Text(room.titlepack);
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
		if(UI::Button(Icons::Play + "##" + tostring(i))){ // Play
			@currentRoom = room;
			AddEvent("qjoinRoom");
		}
		UI::PopStyleColor(1);

		UI::TableNextColumn();
		if(UI::Button(Icons::Eye + "##" + tostring(i))){ // Spectate
			@currentRoom = room;
			AddEvent("qspectateRoom");
		}

		UI::PushStyleColor(UI::Col::Button, vec4(1,0.8,0,1));
		UI::TableNextColumn();
		if(UI::Button(Icons::List + "##" + tostring(i))){ // Details
			@currentRoom = room;
			AddEvent("joinRoom");
		}
		UI::PopStyleColor(1);
		
		UI::EndTable();
	}
}