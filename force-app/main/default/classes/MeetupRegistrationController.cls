public with sharing class MeetupRegistrationController {
    @AuraEnabled
    public static Meetup_Registration__c createMeetupRegistration(Meetup_Registration__c meetupRegistrationObject){
        //Each email must be unique per Meetup.
        Meetup__c meetupToRegisterFor = [
            SELECT Id, (SELECT Email__c FROM Meetup_Registrations__r WHERE Email__c = :meetupRegistrationObject.Email__c)  
            FROM Meetup__c 
            WHERE Id = :meetupRegistrationObject.Meetup__c
        ];
        if(meetupToRegisterFor.Meetup_Registrations__r.size() > 0) {
            throw new AuraHandledException('A registration with an email of '+meetupToRegisterFor.Meetup_Registrations__r[0].Email__c+' already exists for this meetup. Please check the home page for a list of your existing registrations.');
        } else {
            try {
                insert meetupRegistrationObject;
                return meetupRegistrationObject;
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
    }
}