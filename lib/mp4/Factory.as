#if MP4

Room CreateManiaPlanetRoomFromJson(Json::Value room, int index) {
    if(room["zone"].GetType() != Json::Type::Null) {
        auto zoneSplited = string(room["zone"]).Split("|");
        if(zoneSplited.Length >= 3) {
            room["zone"] = zoneSplited[2];
        } else if(zoneSplited.Length >= 2) {
            room["zone"] = zoneSplited[1];
        }
    }
    return ManiaPlanetRoom(Json::Value(index), room["name"], room["player_count"], room["player_max"], room["zone"], room["script_name"], room["login"], room["title"], room["is_private"]);
}
#endif