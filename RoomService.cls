global with sharing class RoomService {	
    global static void checkInRoom(ID roomId, ID guestId) {
		service().checkInRoom(roomId, guestId);
	}
    global static void checkOutRoom(ID roomId, ID guestId) {
		service().checkOutRoom(roomId, guestId);
	}
	private static IRoomService service() {
		return (IRoomService) Application.Service.newInstance(IRoomService.class);
	}	
}