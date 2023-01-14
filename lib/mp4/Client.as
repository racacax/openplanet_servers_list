#if MP4
namespace Client {
    int8 serversLoaded = 0;
    Json::Value GetServers(const string &in name = "", const int &in offset = 0, const int &in perPage = serversPerPage, const string env = "") {
        Log::Trace(GetEnvironments());
        return Get(BASE_URL + "servers/online?" + GetEnvironments() + "zone=World&orderBy=playerCount&offset=" + tostring(offset) + "&length=" + tostring(perPage) + "&excludeLobby=0&search=" + Net::UrlEncode(name));
    }
}
#endif