/* Generated by apex-mocks-generator version 4.0.1 */
@isTest
public class Mocks {
	
	public class Rooms extends fflib_SObjectMocks.SObjectDomain implements IRooms {
		private fflib_ApexMocks mocks;

		public Rooms(fflib_ApexMocks mocks) {
			super(mocks);
			this.mocks = mocks;
		}  
        public void checkInRoom(ID roomId, ID guestId, fflib_ISObjectUnitOfWork uow) {
			mocks.mockNonVoidMethod(this, 'checkInRoom', new List<Type> {System.Type.forName('ID'), System.Type.forName('ID'), System.Type.forName('fflib_ISObjectUnitOfWork')}, new List<Object> {roomId, guestId, uow});
		}
        public void checkOutRoom(ID roomId, ID guestId, fflib_ISObjectUnitOfWork uow) {
			mocks.mockNonVoidMethod(this, 'checkOutRoom', new List<Type> {System.Type.forName('ID'), System.Type.forName('ID'), System.Type.forName('fflib_ISObjectUnitOfWork')}, new List<Object> {roomId, guestId, uow});
		}
	}
	
    public class RoomSelector extends fflib_SObjectMocks.SObjectSelector implements IRoomSelector {
		private fflib_ApexMocks mocks;

		public RoomSelector(fflib_ApexMocks mocks) {
			super(mocks);
			this.mocks = mocks;
		}

		public List<Room__c> selectById(Set<ID> idSet) {
			return (List<Room__c>) mocks.mockNonVoidMethod(this, 'selectById', new List<Type> {System.Type.forName('Set<ID>')}, new List<Object> {idSet});
		}
	}	

	public class RoomService implements IRoomService {
		private fflib_ApexMocks mocks;

		public RoomService(fflib_ApexMocks mocks) {
			this.mocks = mocks;
		}

		public void checkInRoom(ID roomId, ID guestId) {
			mocks.mockVoidMethod(this, 'checkInRoom', new List<Type> {System.Type.forName('ID'), System.Type.forName('ID')}, new List<Object> {roomId, guestId});
		}	
        
        public void checkOutRoom(ID roomId, ID guestId) {
			mocks.mockVoidMethod(this, 'checkOutRoom', new List<Type> {System.Type.forName('ID'), System.Type.forName('ID')}, new List<Object> {roomId, guestId});
		}	
	}
    
    public class LoyaltyProgramService implements ILoyaltyProgramService {
		private fflib_ApexMocks mocks;

		public LoyaltyProgramService(fflib_ApexMocks mocks) {
			this.mocks = mocks;
		}

		public Boolean isThisContactPartOfLoyaltyProgram(ID guestId) {
			return (Boolean)mocks.mockNonVoidMethod(this, 'isThisContactPartOfLoyaltyProgram', new List<Type> {System.Type.forName('ID')}, new List<Object> {guestId});
		}	
        
        public void registerCheckInForContact(ID guestId) {
			mocks.mockVoidMethod(this, 'registerCheckInForContact', new List<Type> {System.Type.forName('ID')}, new List<Object> {guestId});
		}	
	}
	
}