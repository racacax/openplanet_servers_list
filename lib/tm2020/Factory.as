#if TMNEXT
Room CreateClubRoomFromJson(Json::Value room) {
    string login = "";
    if(!bool(room["nadeo"]) && room["room"]["serverAccountId"] != "") {
        login = GetLoginFromAccountId(string(room["room"]["serverAccountId"]));
    }
    return Room(room["id"], room["clubId"], room["clubName"], room["name"], room["room"]["playerCount"], room["room"]["maxPlayers"], room["room"]["region"], room["room"]["script"], room["nadeo"], room["password"], login);
}

Room CreateTotdRoomFromJson(Json::Value room) {
    return TotdRoom(room["playerCount"]);
}

Room CreateCampaignRoomFromJson(Json::Value room) {
    return CampaignRoom(room["playerCount"]);
}
Room CreateArcadeRoomFromJson(Json::Value room) {
    room["currentTimeSlot"]["name"] = "Arcade - " + string(room["currentTimeSlot"]["name"]);
    return ArcadeRoom(room["currentTimeSlot"]["name"], room["playerCount"]);
}
#endif