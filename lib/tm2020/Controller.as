#if TMNEXT
void GetClubRooms() {
    if(Permissions::PlayPublicClubRoom()) { // only allow on Starter and Club
        clientInUse = true;
        int perPage = serversPerPage;
        int offset = serversPerPage * page;
        int8 serversToSubstract = 0;
        if(displayArcadeRoom) serversToSubstract += 1;
        if(displayCampaignRoom) serversToSubstract += 1;
        if(displayTotdRoom) serversToSubstract += 1;
        if(page == 0) {
            perPage-=serversToSubstract;
        } else {
            offset-=serversToSubstract;
        } 
        clubRooms = Client::GetClubRooms(searchString, offset, perPage);
        clientInUse = false;
        if(clubRooms.GetType() != Json::Type::Array && clubRooms.HasKey("clubRoomList")) {
            Client::clubRoomsLoaded = 1;
            maxPage = int((float(clubRooms["itemCount"]) + serversToSubstract) / serversPerPage);
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
    if(page == 0) {
        if(displayTotdRoom) GetTotdRoom();
        if(displayCampaignRoom) GetCampaignRoom();
        if(displayArcadeRoom) GetArcadeRoom();
    }
    GetClubRooms();
}

void JoinRoom(string &in mode, bool firstLoop = true) {
    clientInUse = true;
    auto result = Json::Array();
    auto roomCopy = currentRoom;
    if(currentRoom.login != "") {
        JoinServer("#"+ mode + "=" + currentRoom.login + "@Trackmania");
        clientInUse = false;
    } else {
        if(currentRoom.type == "ClubRoom") {
            if(currentRoom.isNadeo && currentRoom.hasPassword && firstLoop) { // No need to call it more than once
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
                    JoinRoom(mode, false);
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
}

void HandleGameSpecificEvent(const string &in event) {
    if(event == "getTotdRoom") {
        GetTotdRoom();
    } else if(event == "getCampaignRoom") {
        GetCampaignRoom();
    } else if(event == "getClubRooms") {
        GetClubRooms();
    }
}
#endif