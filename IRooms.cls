public interface IRooms extends fflib_ISObjectDomain {
    void checkInRoom(ID roomId, ID guestId, fflib_ISObjectUnitOfWork uow);
    void checkOutRoom(ID roomId, ID guestId, fflib_ISObjectUnitOfWork uow);
}