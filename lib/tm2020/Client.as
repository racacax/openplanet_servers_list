#if TMNEXT
namespace Client {

    int8 clubRoomsLoaded = 0;
    Json::Value GetClubRooms(string &in name = "", const int &in offset = 0, const int &in perPage = serversPerPage) {
        if(name == "") name = "_";
        return Get(BASE_URL + "club/room?offset=" + tostring(offset) + "&length=" + tostring(perPage) + "&name=" + Net::UrlEncode(name));
    }

    
    int8 totdRoomLoaded = 0;
    Json::Value GetTotdRoom() {
        return Get(BASE_URL + "channel/daily");
    }
    
    int8 arcadeRoomLoaded = 0;
    Json::Value GetArcadeRoom() {
        return Get(BASE_URL + "channel/arcade");
    }

    int8 weeklyShortsRoomLoaded = 0;
    Json::Value GetWeeklyShortsRoom() {
        return Get(BASE_URL + "channel/weekly-shorts");
    }
    
    int8 campaignRoomLoaded = 0;
    Json::Value GetCampaignRoom() {
        return Get(BASE_URL + "channel/officialhard");
    }

    
    int8 reviewRoomsLoaded = 0;
    Json::Value GetReviewRooms(string &in name = "", const int &in offset = 0, const int &in perPage = serversPerPage) {
        if(name == "") name = "_";
        return Get(BASE_URL + "club/map-review?offset=" + tostring(offset) + "&length=" + tostring(perPage) + "&name=" + Net::UrlEncode(name));
    }

    Json::Value GetClubRoomJoinLink(int clubId, int id) {
        return Post(BASE_URL + "club/" + tostring(clubId) + "/room/" + tostring(id) + "/join");
    }


    Json::Value GetReviewRoomJoinLink(int clubId, int id) {
        return Post(BASE_URL + "club/" + tostring(clubId) + "/map-review/" + tostring(id) + "/join");
    }


    Json::Value GetTotdReviewJoinLink() {
        return Get(BASE_URL + "map-review/totd/connect");
    }

    Json::Value GetRoyalReviewJoinLink() {
        return Get(BASE_URL + "map-review/royal/connect");
    }

    /*
        Method to request a password protected Nadeo server.
    */
    Json::Value GetClubRoomPassword(int clubId, int id) {
        return Get(BASE_URL + "club/" + tostring(clubId) + "/room/" + tostring(id) + "/get-password");
    }

    Json::Value GetTotdRoomJoinLink() {
        return Post(BASE_URL + "channel/daily/join");
    }

    Json::Value GetArcadeRoomJoinLink() {
        return Post(BASE_URL + "channel/arcade/join");
    }

    Json::Value GetWeeklyShortsRoomJoinLink() {
        return Post(BASE_URL + "channel/weekly-shorts/join");
    }
    
    Json::Value GetCampaignRoomJoinLink() {
        return Post(BASE_URL + "channel/officialhard/join");
    }

}
#endif