public interface IRoomService {
	void checkInRoom(ID roomId, ID guestId);
	void checkOutRoom(ID roomId, ID guestId);
}