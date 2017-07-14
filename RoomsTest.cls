@IsTest
private class RoomsTest {
	@IsTest
	private static void testInsertRoomWithoutDML() {
		Room__c room = new Room__c ( Name = 'Room 1', Guest__c=fflib_IDGenerator.generate(Contact.SobjectType) );
		fflib_SObjectDomain.Test.Database.onInsert(new Room__c[] { room } );		
		fflib_SObjectDomain.triggerHandler(Rooms.class);
		System.assertEquals(fflib_SObjectDomain.Errors.getAll().size(), 0);		
	}
}