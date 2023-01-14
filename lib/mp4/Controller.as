#if MP4

void GetAllRooms() {
    Client::serversLoaded = 0;
    servers = Json::Array();
    clientInUse = true;
    int offset = serversPerPage * page;
    servers = Client::GetServers(searchString, offset, serversPerPage);
    clientInUse = false;
    if(servers.GetType() == Json::Type::Array) {
        Client::serversLoaded = 1;
        maxPage = 256;
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