public class Rooms extends fflib_SObjectDomain implements IRooms {
    
    public static IRooms newInstance(List<Room__c> sObjectList) {
		return (IRooms) Application.Domain.newInstance(sObjectList);
	}

	public Rooms(List<Room__c> sObjectList) {
		// Domain classes are initialised with lists to enforce bulkification throughout
		super(sObjectList);
	}

	public override void onBeforeInsert() {
		updateRoomOccupancy();		
	}
	
	public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		updateRoomOccupancy();
	}	          
    
	private void updateRoomOccupancy() {
		for(Room__c room : (List<Room__c>)Records) {
			room.put('Occupied__c', room.Guest__c != null);	
		}
	}    
    
    public void checkInRoom(ID roomId, ID guestId, fflib_ISObjectUnitOfWork uow) {
        Map<Id, Room__c> roomsRecords = new Map<Id, Room__c>((List<Room__c>)Records);
        Room__c roomToCheckIn = roomsRecords.get(roomId);
        if(roomToCheckIn.Occupied__c) {
            throw new RoomException('Room is already occupied');
        }
        
		roomToCheckIn.Guest__c = guestId;
        uow.registerDirty(roomToCheckIn);
    }
    
    public void checkOutRoom(ID roomId, ID guestId, fflib_ISObjectUnitOfWork uow) {
        Map<Id, Room__c> roomsRecords = new Map<Id, Room__c>((List<Room__c>)Records);
        Room__c roomToCheckOut = roomsRecords.get(roomId);
        if(roomToCheckOut.Guest__c != guestId) {
            throw new RoomException('Room is not occupied by Guest');
        }
        
        roomToCheckOut.Guest__c = null;
        uow.registerDirty(roomToCheckout);
    }
    
	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Rooms(sObjectList);
		}
	}	
}