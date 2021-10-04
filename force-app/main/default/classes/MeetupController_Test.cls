@IsTest
public with sharing class MeetupController_Test {
    /**
    * Test class covering the MeetupController Apex class
    */
    @TestSetup
    static void setupMeetupData() {
        Meetup__c testMeetup = new Meetup__c(
            Name = 'Test Meetup',
            Status__c = 'Open',
            Registration_Limit__c = 1
        );
        insert testMeetup;
        
        Meetup_Registration__c testRegistration = new Meetup_Registration__c(
            First_Name__c = 'Test',
            Last_Name__c = 'Test',
            Email__c = 'Test@test.com',
            Meetup__c = testMeetup.Id
        );

        insert testRegistration;
    }

    @IsTest
    static void testNoMeetupFound() {
        try{
            Meetup__c returnedMeetup = MeetupController.getSingleMeetup('A bogus code');
        }catch(Exception e){
            System.assertNotEquals(e, null);
        }
    }
    @IsTest
    static void testExceededRegistrationLimit() {
        try {        
            Meetup__c meetup = [SELECT Status__c,Registration_Code__c FROM Meetup__c LIMIT 1];
            Meetup__c returnedMeetup = MeetupController.getSingleMeetup(meetup.Registration_Code__c);
        }catch(AuraHandledException e){
            System.assertNotEquals(e, null);
        }
    }
    @IsTest
    static void testNotOpenStatus() {
        try {    
            Meetup__c meetup = [SELECT Status__c,Registration_Code__c FROM Meetup__c LIMIT 1];
            meetup.Status__c = 'Closed';
            update meetup;
            
            Meetup__c returnedMeetup = MeetupController.getSingleMeetup(meetup.Registration_Code__c);
        }catch(AuraHandledException e){
            System.assertNotEquals(e, null);
        }
    }
}
