import XCTest
@testable import Eventorias

final class ModelsTests: XCTestCase {
    func testEventInitialization() {
        let date = Date()
        let event = Event(name: "Test Event", date: date, imageUrl: "https://test.com", description: "Desc", location: "Paris")
        
        XCTAssertEqual(event.name, "Test Event")
        XCTAssertEqual(event.location, "Paris")
        XCTAssertEqual(event.description, "Desc")
    }
    
    func testUserProfileInitialization() {
        let profile = UserProfile(name: "Lina", email: "lina@test.com", avatarUrl: "https://avatar.com")
        
        XCTAssertEqual(profile.name, "Lina")
        XCTAssertEqual(profile.email, "lina@test.com")
    }
}
