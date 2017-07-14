global with sharing class LoyaltyProgramService {	
    global static Boolean isThisContactPartOfLoyaltyProgram( Id contactId ) {
        return service().isThisContactPartOfLoyaltyProgram(contactId);
    }    
    global static void registerCheckInForContact( id contactId ) {
        service().registerCheckInForContact(contactId);
    }
	private static ILoyaltyProgramService service() {
		return (ILoyaltyProgramService) Application.Service.newInstance(ILoyaltyProgramService.class);
	}	
}