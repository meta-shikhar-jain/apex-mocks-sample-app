public class RoomServiceImpl implements IRoomService {
    public void checkInRoom(ID roomId, ID guestId){
        // Create unit of work to capture work and commit it under one transaction
	    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
	    										
		// Query Rooms
		List<Room__c> roomList = RoomSelector.newInstance().selectById(new Set<Id>{roomId});
		
		// CheckOut room via Rooms domain class behaviour
		IRooms roomDomain = Rooms.newInstance(roomList);	
		roomDomain.checkInRoom(roomId, guestId, uow);
		registerContactCheckinForLoyalty(guestId);
		// Commit updates to rooms		
		uow.commitWork();	        
    }    

    public void checkOutRoom(ID roomId, ID guestId) {
        // Create unit of work to capture work and commit it under one transaction
	    fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
	    										
		// Query Rooms
		List<Room__c> roomList = RoomSelector.newInstance().selectById(new Set<Id>{roomId});
		
		// CheckOut room via Rooms domain class behaviour
		IRooms roomDomain = Rooms.newInstance(roomList);	
		roomDomain.checkOutRoom(roomId, guestId, uow);
        
		// Commit updates to rooms		
		uow.commitWork();
    }
    
    private void registerContactCheckinForLoyalty(ID guestId) {
        if(LoyaltyProgramService.isThisContactPartOfLoyaltyProgram(guestId)) {
            LoyaltyProgramService.registerCheckInForContact(guestId);
        }
    }
}