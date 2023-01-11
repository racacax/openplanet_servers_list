array<string> events = {};

void AddEvent(const string &in a) {
	events.InsertAt(0, a);
}

void GetClubRooms() {
    if(Permissions::PlayPublicClubRoom()) { // only allow on Starter and Club
        clientInUse = true;
        int perPage = serversPerPage;
        int offset = serversPerPage * page;
        if(displaySpecialRooms) {
            if(page == 0) {
                perPage-=3;
            } else {
                offset-=3;
            }
        } 
        clubRooms = Client::GetClubRooms(searchString, offset, perPage);
        clientInUse = false;
        if(clubRooms.GetType() != Json::Type::Array && clubRooms.HasKey("clubRoomList")) {
            Client::clubRoomsLoaded = 1;
            maxPage = int(float(clubRooms["itemCount"]) / serversPerPage);
        } else {
            Client::clubRoomsLoaded = -1;
            Log::Error("Error while fetching club rooms.");
        }
    }
}

void GetTotdRoom() {
    if(Permissions::PlayTOTDChannel()) { // only allow on Starter and Club (also Starter on Free COTD ?)
        clientInUse = true;
        totdRoom = Client::GetTotdRoom();
        clientInUse = false;
        if(totdRoom.GetType() != Json::Type::Array && totdRoom.HasKey("uid")) {
            Client::totdRoomLoaded = 1;
        } else {
            Client::totdRoomLoaded = -1;
            Log::Error("Error while fetching TOTD room.");
        }
    }
}

void GetCampaignRoom() {
    if(Permissions::PlayCurrentOfficialMonthlyCampaign()) { // technically everyone ?
        clientInUse = true;
        campaignRoom = Client::GetCampaignRoom();
        clientInUse = false;
        if(campaignRoom.GetType() != Json::Type::Array && campaignRoom.HasKey("uid")) {
            Client::campaignRoomLoaded = 1;
        } else {
            Client::campaignRoomLoaded = -1;
            Log::Error("Error while fetching Campaign room.");
        }
    }
}



void GetArcadeRoom() {
    if(Permissions::PlayArcadeChannel()) { // technically everyone ?
        clientInUse = true;
        arcadeRoom = Client::GetArcadeRoom();
        clientInUse = false;
        if(campaignRoom.GetType() != Json::Type::Array && campaignRoom.HasKey("uid")) {
            Client::arcadeRoomLoaded = 1;
        } else {
            Client::arcadeRoomLoaded = -1;
            Log::Error("Error while fetching Arcade room.");
        }
    }
}

void GetAllRooms() {
    Client::clubRoomsLoaded = 0;
    Client::totdRoomLoaded = 0;
    Client::campaignRoomLoaded = 0;
    Client::arcadeRoomLoaded = 0;
    clubRooms = Json::Array();
    totdRoom = Json::Object();
    campaignRoom = Json::Object();
    arcadeRoom = Json::Object();
    if(page == 0 && displaySpecialRooms) {
        GetTotdRoom();
        GetCampaignRoom();
        GetArcadeRoom();
    }
    GetClubRooms();
}

void JoinRoom(string &in mode) {
    clientInUse = true;
    auto result = Json::Array();
    auto roomCopy = currentRoom;
    if(currentRoom.type == "ClubRoom") {
        if(currentRoom.isNadeo && currentRoom.hasPassword) {
            Client::GetClubRoomPassword(currentRoom.clubId, currentRoom.id);
        }
        result = Client::GetClubRoomJoinLink(currentRoom.clubId, currentRoom.id);
    } else if(currentRoom.type == "TotdRoom") {
        result = Client::GetTotdRoomJoinLink();
    } else if(currentRoom.type == "CampaignRoom") {
        result = Client::GetCampaignRoomJoinLink();
    } else if(currentRoom.type == "ArcadeRoom") {
        result = Client::GetArcadeRoomJoinLink();
    }
    if(roomCopy.id == currentRoom.id) { // In case user clicked another button
        if(result.GetType() != Json::Type::Array && result.HasKey("joinLink")) {
            if(result.HasKey("starting") && bool(result["starting"])) {
                sleep(2000);
                JoinRoom(mode);
            } else {
                clientInUse = false;
                string joinLink = string(result["joinLink"]).Replace("#qjoin", "#join").Replace("#join", "#" + mode);
                if(currentRoom.isNadeo) {
                    joinLink += "@Trackmania";
                }
                JoinServer(joinLink);
            }
        } else {
            Log::Error("Error while getting join link.");
            clientInUse = false;
        }
    }
}

void HandleEvents() {
    for(int n = events.Length -1; n >= 0; n-- ) {
        auto event = events[n];
        events.RemoveAt(n);
		if(event == "getAllRooms") {
            GetAllRooms();
        } else if(event == "getTotdRoom") {
            GetTotdRoom();
        } else if(event == "getCampaignRoom") {
            GetCampaignRoom();
        } else if(event == "getClubRooms") {
            GetClubRooms();
        } else if(event == "qjoinRoom") {
            JoinRoom("qjoin");
        } else if(event == "joinRoom") {
            JoinRoom("join");
        } else if(event == "qspectateRoom") {
            JoinRoom("qspectate");
        }
    }
    sleep(100);
}