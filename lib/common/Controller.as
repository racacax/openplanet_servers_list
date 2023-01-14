array<string> events = {};

void AddEvent(const string &in a) {
	events.InsertAt(0, a);
}

void HandleEvents() {
    for(int n = events.Length -1; n >= 0; n-- ) {
        auto event = events[n];
        events.RemoveAt(n);
		if(event == "getAllRooms") {
            GetAllRooms();
        } else if(event == "qjoinRoom") {
            JoinRoom("qjoin");
        } else if(event == "joinRoom") {
            JoinRoom("join");
        } else if(event == "qspectateRoom") {
            JoinRoom("qspectate");
        } else {
            HandleGameSpecificEvent(event);
        }
    }
    sleep(100);
}