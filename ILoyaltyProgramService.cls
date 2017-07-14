public interface ILoyaltyProgramService {
	Boolean isThisContactPartOfLoyaltyProgram( Id contactId );
	void registerCheckInForContact( id contactId );
}