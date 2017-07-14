@IsTest
private with sharing class RoomSelectorTest {
	@IsTest
	private static void testSelectById()
	{	
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
		        
        Contact guest = new Contact(LastName = 'Guest 1');
        uow.registerNew(guest);        
		// Test data
		Room__c room1 = new Room__c ( Name = 'Room 1');
        uow.registerNew(room1, Room__c.Guest__c, guest);
        
        Room__c room2 = new Room__c ( Name = 'Room 2');
        uow.registerNew(room2);
                	
		uow.commitWork();
				
		// Query
		List<Room__c> rooms =  RoomSelector.newInstance().selectById(new Set<Id> { room1.Id, room2.Id });
        System.debug(rooms);
		// Assert
		System.assertEquals(2, rooms.size());
		System.assertEquals(room1.Name, rooms.get(0).Name);
		System.assertEquals(true, rooms.get(0).Occupied__c);
		
        System.assertEquals(room2.Name, rooms.get(1).Name);
		System.assertEquals(false, rooms.get(1).Occupied__c);
    }
}