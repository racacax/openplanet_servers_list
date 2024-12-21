#if TMNEXT
void GetClubRooms() {
    if(Permissions::PlayPublicClubRoom()) { // only allow on Standard and Club
        clientInUse = true;
        int perPage = serversPerPage;
        int offset = serversPerPage * page;
        int8 serversToSubstract = 0;
        if(searchString == "") {
            if(displayArcadeRoom) serversToSubstract += 1;
            if(displayCampaignRoom) serversToSubstract += 1;
            if(displayTotdRoom) serversToSubstract += 1;
            if(displayWeeklyShortsRoom) serversToSubstract += 1;
            if(page == 0) {
                perPage-=serversToSubstract;
            } else {
                offset-=serversToSubstract;
            }
        } 
        auto clubRooms = Client::GetClubRooms(searchString, offset, perPage);
        clientInUse = false;
        if(clubRooms.GetType() != Json::Type::Array && clubRooms.HasKey("clubRoomList")) {
            Client::clubRoomsLoaded = 1;
            maxPage = int((float(clubRooms["itemCount"]) + serversToSubstract) / serversPerPage);
            for(uint i=0; i< clubRooms["clubRoomList"].Length; i++) {
                Room room = CreateClubRoomFromJson(clubRooms["clubRoomList"][i]);
                servers.InsertLast(room);
            }
        } else {
            Client::clubRoomsLoaded = -1;
            Log::Error("Error while fetching club rooms.");
        }
    }
}

void GetTotdRoom() {
    if(Permissions::PlayTOTDChannel()) { // only allow on Standard and Club (also Starter on Free COTD ?)
        clientInUse = true;
        auto totdRoom = Client::GetTotdRoom();
        clientInUse = false;
        if(totdRoom.GetType() != Json::Type::Array && totdRoom.HasKey("uid")) {
            Client::totdRoomLoaded = 1;
            Room totdRoomInstance = CreateTotdRoomFromJson(totdRoom);
            servers.InsertLast(totdRoomInstance);
        } else {
            Client::totdRoomLoaded = -1;
            Log::Error("Error while fetching TOTD room.");
        }
    }
}

void GetCampaignRoom() {
    if(Permissions::PlayCurrentOfficialMonthlyCampaign()) { // technically everyone ?
        clientInUse = true;
        auto campaignRoom = Client::GetCampaignRoom();
        clientInUse = false;
        if(campaignRoom.GetType() != Json::Type::Array && campaignRoom.HasKey("uid")) {
            Client::campaignRoomLoaded = 1;
            Room campaignRoomInstance = CreateCampaignRoomFromJson(campaignRoom);
            servers.InsertLast(campaignRoomInstance);
        } else {
            Client::campaignRoomLoaded = -1;
            Log::Error("Error while fetching Campaign room.");
        }
    }
}



void GetArcadeRoom() {
    if(Permissions::PlayArcadeChannel()) { // technically everyone ?
        clientInUse = true;
        auto arcadeRoom = Client::GetArcadeRoom();
        clientInUse = false;
        if(arcadeRoom.GetType() != Json::Type::Array && arcadeRoom.HasKey("uid")) {
            Client::arcadeRoomLoaded = 1;
            Room arcadeRoomInstance = CreateArcadeRoomFromJson(arcadeRoom);
            servers.InsertLast(arcadeRoomInstance);
        } else {
            Client::arcadeRoomLoaded = -1;
            Log::Error("Error while fetching Arcade room.");
        }
    }
}

void GetWeeklyShortsRoom() {
    if(Permissions::PlayArcadeChannel()) { // technically everyone ?
        clientInUse = true;
        auto weeklyShortsRoom = Client::GetWeeklyShortsRoom();
        clientInUse = false;
        if(weeklyShortsRoom.GetType() != Json::Type::Array && weeklyShortsRoom.HasKey("uid")) {
            Client::weeklyShortsRoomLoaded = 1;
            Room weeklyShortsRoomInstance = CreateWeeklyShortsRoomFromJson(weeklyShortsRoom);
            servers.InsertLast(weeklyShortsRoomInstance);
        } else {
            Client::weeklyShortsRoomLoaded = -1;
            Log::Error("Error while fetching Weekly Shorts room.");
        }
    }
}

void GetReviewRooms() {
    if(Permissions::PlayPrivateActivity()) { // only allow Club
        clientInUse = true;
        int perPage = serversPerPage;
        int offset = serversPerPage * page;
        
        int8 serversToSubstract = 2;
        if(searchString == "") {
            if(page == 0) {
                perPage-=serversToSubstract;
                servers.InsertLast(CreateTotdReviewRoom());
                servers.InsertLast(CreateRoyalReviewRoom());
            } else {
                offset-=serversToSubstract;
            }
        } 
        auto reviewRooms = Client::GetReviewRooms(searchString, offset, perPage);
        clientInUse = false;
        if(reviewRooms.GetType() != Json::Type::Array && reviewRooms.HasKey("clubMapReviewList")) {
            Client::reviewRoomsLoaded = 1;
            maxPage = int((float(reviewRooms["itemCount"]) + serversToSubstract) / serversPerPage);
            for(uint i=0; i< reviewRooms["clubMapReviewList"].Length; i++) {
                Room room = CreateReviewRoomFromJson(reviewRooms["clubMapReviewList"][i]);
                servers.InsertLast(room);
            }
        } else {
            Client::reviewRoomsLoaded = -1;
            Log::Error("Error while fetching review rooms.");
        }
    }
}

void GetAllRooms() {
    Client::clubRoomsLoaded = 0;
    Client::totdRoomLoaded = 0;
    Client::campaignRoomLoaded = 0;
    Client::arcadeRoomLoaded = 0;
    Client::weeklyShortsRoomLoaded = 0;
    Client::reviewRoomsLoaded = 0;
    servers = {};
    if(roomType == "club") {
        if(page == 0 && searchString == "") {
            if(displayTotdRoom) GetTotdRoom();
            if(displayCampaignRoom) GetCampaignRoom();
            if(displayArcadeRoom) GetArcadeRoom();
            if(displayWeeklyShortsRoom) GetWeeklyShortsRoom();
        }
        GetClubRooms();
    } else {
        GetReviewRooms();
    }
}

void JoinRoom(string &in mode, bool firstLoop = true) {
    clientInUse = true;
    auto result = Json::Array();
    auto roomCopy = currentRoom;
    if(currentRoom.login != "") {
        JoinServer("#"+ mode + "=" + currentRoom.login + "@Trackmania");
        clientInUse = false;
    } else {
        if(currentRoom.type == "ReviewRoom") {
            if(currentRoom.id == -1) {
                result = Client::GetTotdReviewJoinLink();
            } else if(currentRoom.id == -2) {
                result = Client::GetRoyalReviewJoinLink();
            } else {
                result = Client::GetReviewRoomJoinLink(currentRoom.clubId, currentRoom.id);
            }
        } else if (currentRoom.type == "ClubRoom") {
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
        } else if(currentRoom.type == "WeeklyShortsRoom") {
            result = Client::GetWeeklyShortsRoomJoinLink();
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
                    if(currentRoom.type == "ReviewRoom" && bool(result["noMap"])) {
                        Log::Error("No map in the map pool, you cannot join the server.");
                        return;
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