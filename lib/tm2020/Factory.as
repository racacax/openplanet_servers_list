#if TMNEXT
Room CreateClubRoomFromJson(Json::Value room) {
    string login = "";
    if(!bool(room["nadeo"]) && room["room"]["serverAccountId"] != "") {
        login = GetLoginFromAccountId(string(room["room"]["serverAccountId"]));
    }
    return Room(room["id"], room["clubId"], room["clubName"], room["name"], room["room"]["playerCount"], room["room"]["maxPlayers"], room["room"]["region"], room["room"]["script"], room["nadeo"], room["password"], login);
}


Room CreateReviewRoomFromJson(Json::Value room) {
    return ReviewRoom(room["id"], room["clubId"], room["clubName"], room["name"], room["maxPlayer"]);
}

Room CreateTotdReviewRoom() {
    return ReviewRoom(Json::Value(-1), Json::Value(-1), Json::Value("Ubisoft Nadeo"), Json::Value("TOTD Review"), Json::Value(-1));
}
Room CreateRoyalReviewRoom() {
    return ReviewRoom(Json::Value(-2), Json::Value(-2), Json::Value("Ubisoft Nadeo"), Json::Value("Royal Review"), Json::Value(-1));
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