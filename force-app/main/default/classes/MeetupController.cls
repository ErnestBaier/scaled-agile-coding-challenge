public with sharing class MeetupController {
    @AuraEnabled(cacheable=true)
    public static Meetup__c getSingleMeetup(String registrationCode) {
        //Performing field value validation in Apex controller to satisfy requirements 
        // ● All business rules must be reinforced in apex for security reasons.
        //● The user can only register if the Meetup status is Open.
        //● The user cannot register when the total # of registrations exceed the registration limit for this Meetup.
        Meetup__c meetupToReturn = [
            SELECT Id, Name, Status__c,Registration_Limit__c, (SELECT Id FROM Meetup_Registrations__r)  
            FROM Meetup__c
            WHERE Registration_Code__c = :registrationCode
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
        if(meetupToReturn == null) {
            throw new AuraHandledException('No meetup was found with that registration code. Please verify the code and try again!');      
        } else if(meetupToReturn.Meetup_Registrations__r.size() >= meetupToReturn.Registration_Limit__c) {
            throw new AuraHandledException('The number of registrations for this meetup have met or exceeded the registration limit. Your registration can not be added at this time.');      
        } else if(meetupToReturn.Status__c != 'Open') {
            throw new AuraHandledException('The meetup is not in the Open status. Your registration can not be added at this time.');      
        } else {
            return meetupToReturn;
        }
    }
}