#if MP4

void GetAllRooms() {
    Client::serversLoaded = 0;
    servers = {};
    clientInUse = true;
    int offset = serversPerPage * page;
    auto serversJson = Client::GetServers(searchString, offset, serversPerPage);
    clientInUse = false;
    if(serversJson.GetType() == Json::Type::Array) {
        Client::serversLoaded = 1;
        maxPage = page + 1;
        for(uint i=0; i< serversJson.Length; i++) {
            Room room = CreateManiaPlanetRoomFromJson(serversJson[i], i);
            servers.InsertLast(room);
        }
        if(servers.Length < serversPerPage) {
            maxPage = page;
        }
    } else {
        Client::serversLoaded = -1;
        Log::Error("Error while fetching servers.");
    }
}

void JoinRoom(const string &in mode) {
    string joinLink = "#" + mode + "=" + currentRoom.login + "@" + currentRoom.titlepack;
    JoinServer(joinLink);
}

void HandleGameSpecificEvent(const string &in event) {
    
}
#endif