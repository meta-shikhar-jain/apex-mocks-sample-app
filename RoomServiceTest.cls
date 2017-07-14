@IsTest
private class RoomServiceTest {
	@IsTest
	private static void testRoomCheckInForAlreadyOccupied() {
		// Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IRoomSelector selectorMock = new Mocks.RoomSelector(mocks);
        Id roomId = fflib_IDGenerator.generate(Room__c.SObjectType);
        
		// Given
		mocks.startStubbing();
		List<Room__c> testRoomsList = new List<Room__c> { 
			new Room__c(
				Id = roomId,
				Name = 'Test Room',
				Guest__c = fflib_IDGenerator.generate(Contact.SObjectType),
                Occupied__c = true
            )};
                
		Set<Id> testRoomsSet = new Map<Id, Room__c>(testRoomsList).keySet();
		mocks.when(selectorMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.selectById(testRoomsSet)).thenReturn(testRoomsList);
		mocks.stopStubbing();

       	Application.Selector.setMock(selectorMock);
       
        try {
            RoomService.checkInRoom(roomId, fflib_IDGenerator.generate(Contact.SObjectType));
            System.assert(false, 'Room already occupied, but no exception on checkin');
        } catch(RoomException e) {
            System.assertEquals('Room is already occupied', e.getMessage());
        }		
	}
    
    @IsTest
	private static void testRoomCheckIn() {
		// Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);		
        IRoomSelector selectorMock = new Mocks.RoomSelector(mocks);
		
        Id roomId = fflib_IDGenerator.generate(Room__c.SObjectType);
        Id guestId = fflib_IDGenerator.generate(Room__c.SObjectType);
        
		// Given
		mocks.startStubbing();
		List<Room__c> testRoomsList = new List<Room__c> { 
			new Room__c(
				Id = roomId,
				Name = 'Test Room'
            )};
                
		Set<Id> testRoomsSet = new Map<Id, Room__c>(testRoomsList).keySet();
		mocks.when(selectorMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.selectById(testRoomsSet)).thenReturn(testRoomsList);
		mocks.stopStubbing();

		Application.UnitOfWork.setMock(uowMock);
		Application.Selector.setMock(selectorMock);
       
        // When
		RoomService.checkInRoom(roomId, guestId);	
		// Then
		((IRoomSelector) 
			mocks.verify(selectorMock)).selectById(testRoomsSet);
        ((fflib_ISObjectUnitOfWork) 
			mocks.verify(uowMock, 1)).registerDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object>{
                        Room__c.Id => roomId,
                        Room__c.Guest__c => guestId} ));                
        ((fflib_ISObjectUnitOfWork) 
			mocks.verify(uowMock, 1)).commitWork();       
	}
    
    @IsTest
	private static void testRoomCheckOutForNotOccupiedByGuest() {
		// Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		IRoomSelector selectorMock = new Mocks.RoomSelector(mocks);
		
        Id roomId = fflib_IDGenerator.generate(Room__c.SObjectType);
        
		// Given
		mocks.startStubbing();
		List<Room__c> testRoomsList = new List<Room__c> { 
			new Room__c(
				Id = roomId,
				Name = 'Test Room',
				Guest__c = fflib_IDGenerator.generate(Contact.SObjectType),
                Occupied__c = true
            )};
                
		Set<Id> testRoomsSet = new Map<Id, Room__c>(testRoomsList).keySet();
		mocks.when(selectorMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.selectById(testRoomsSet)).thenReturn(testRoomsList);
		mocks.stopStubbing();

		Application.Selector.setMock(selectorMock);
       
        try {
            RoomService.checkOutRoom(roomId, fflib_IDGenerator.generate(Contact.SObjectType));
            System.assert(false, 'Room is not occupied by Guest, but no exception on checkout');
        } catch(RoomException e) {
            System.assertEquals('Room is not occupied by Guest', e.getMessage());
        }		
	}
    
   	@IsTest
	private static void testRoomCheckOut() {
		// Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);		
        IRoomSelector selectorMock = new Mocks.RoomSelector(mocks);
		        
        Id roomId = fflib_IDGenerator.generate(Room__c.SObjectType);
        Id guestId = fflib_IDGenerator.generate(Contact.SObjectType);
        
		// Given
		mocks.startStubbing();
		List<Room__c> testRoomsList = new List<Room__c> { 
			new Room__c(
				Id = roomId,
				Name = 'Test Room',
                Guest__c = guestId,
                Occupied__c = true
            )};
                
		Set<Id> testRoomsSet = new Map<Id, Room__c>(testRoomsList).keySet();
		mocks.when(selectorMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.selectById(testRoomsSet)).thenReturn(testRoomsList);
		mocks.stopStubbing();

		Application.UnitOfWork.setMock(uowMock);
		Application.Selector.setMock(selectorMock);
       
        // When
		RoomService.checkOutRoom(roomId, guestId);	
		// Then
		((IRoomSelector) 
			mocks.verify(selectorMock)).selectById(testRoomsSet);
        ((fflib_ISObjectUnitOfWork) 
			mocks.verify(uowMock, 1)).registerDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object>{
                        Room__c.Id => roomId,
                        Room__c.Guest__c => null
                    } ));                
        ((fflib_ISObjectUnitOfWork) 
			mocks.verify(uowMock, 1)).commitWork();           
	} 
    
    @IsTest
	private static void testRoomCheckinForNonLoyaltyMember() {
		// Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);		
        IRoomSelector selectorMock = new Mocks.RoomSelector(mocks);
		IRooms domainMock = new Mocks.Rooms(mocks);
		ILoyaltyProgramService loyaltyServiceMock = new Mocks.LoyaltyProgramService(mocks);
        
        Id roomId = fflib_IDGenerator.generate(Room__c.SObjectType);
        Id guestId = fflib_IDGenerator.generate(Room__c.SObjectType);
        
		// Given
		mocks.startStubbing();
		List<Room__c> testRoomsList = new List<Room__c> { 
			new Room__c(
				Id = roomId,
				Name = 'Test Room'
            )};
                
		Set<Id> testRoomsSet = new Map<Id, Room__c>(testRoomsList).keySet();
		mocks.when(domainMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.selectById(testRoomsSet)).thenReturn(testRoomsList);
		mocks.when(loyaltyServiceMock.isThisContactPartOfLoyaltyProgram(guestId)).thenReturn(false);
		mocks.stopStubbing();

		Application.UnitOfWork.setMock(uowMock);
		Application.Selector.setMock(selectorMock);
       	Application.Domain.setMock(domainMock);
       	Application.Service.setMock(ILoyaltyProgramService.class, loyaltyServiceMock);
       
        // When
		RoomService.checkInRoom(roomId, guestId);	
		// Then
		((IRoomSelector) 
			mocks.verify(selectorMock)).selectById(testRoomsSet);
        ((IRooms) 
			mocks.verify(domainMock)).checkInRoom(roomId, guestId, uowMock);

        ((ILoyaltyProgramService) 
			mocks.verify(loyaltyServiceMock, 1)).isThisContactPartOfLoyaltyProgram(guestId); 
        ((ILoyaltyProgramService) 
			mocks.verify(loyaltyServiceMock, fflib_ApexMocks.NEVER)).registerCheckInForContact(guestId); 
        ((fflib_ISObjectUnitOfWork) 
			mocks.verify(uowMock, 1)).commitWork();       
	}
    
    @IsTest
	private static void testRoomCheckinForLoyaltyMember() {
		// Create mocks
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);		
        IRoomSelector selectorMock = new Mocks.RoomSelector(mocks);
		IRooms domainMock = new Mocks.Rooms(mocks);
		ILoyaltyProgramService loyaltyServiceMock = new Mocks.LoyaltyProgramService(mocks);
        
        Id roomId = fflib_IDGenerator.generate(Room__c.SObjectType);
        Id guestId = fflib_IDGenerator.generate(Room__c.SObjectType);
        
		// Given
		mocks.startStubbing();
		List<Room__c> testRoomsList = new List<Room__c> { 
			new Room__c(
				Id = roomId,
				Name = 'Test Room'
            )};
                
		Set<Id> testRoomsSet = new Map<Id, Room__c>(testRoomsList).keySet();
		mocks.when(domainMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.sObjectType()).thenReturn(Room__c.SObjectType);
		mocks.when(selectorMock.selectById(testRoomsSet)).thenReturn(testRoomsList);
		mocks.when(loyaltyServiceMock.isThisContactPartOfLoyaltyProgram(guestId)).thenReturn(true);
		mocks.stopStubbing();

		Application.UnitOfWork.setMock(uowMock);
		Application.Selector.setMock(selectorMock);
       	Application.Domain.setMock(domainMock);
       	Application.Service.setMock(ILoyaltyProgramService.class, loyaltyServiceMock);
       
        // When
		RoomService.checkInRoom(roomId, guestId);	
		// Then
		((IRoomSelector) 
			mocks.verify(selectorMock)).selectById(testRoomsSet);
        ((ILoyaltyProgramService) 
			mocks.verify(loyaltyServiceMock, 1)).isThisContactPartOfLoyaltyProgram(guestId); 
        ((ILoyaltyProgramService) 
			mocks.verify(loyaltyServiceMock, 1)).registerCheckInForContact(guestId); 
        ((IRooms) 
			mocks.verify(domainMock)).checkInRoom(roomId, guestId, uowMock);

        ((fflib_ISObjectUnitOfWork) 
			mocks.verify(uowMock, 1)).commitWork();       
	}
}