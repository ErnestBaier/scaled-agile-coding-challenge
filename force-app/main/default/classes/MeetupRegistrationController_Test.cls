@IsTest
public with sharing class MeetupRegistrationController_Test {
    /**
    * Test class covering the MeetupRegistrationController Apex class
    */
    @TestSetup
    static void setupMeetupRegistrationData() {
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
    static void testSameEmail() {
        Meetup__c testMeetup = [SELECT Id FROM Meetup__c LIMIT 1];
        try{
            Meetup_Registration__c testRegistration = new Meetup_Registration__c(
                First_Name__c = 'Test',
                Last_Name__c = 'Test',
                Email__c = 'Test@test.com',
                Meetup__c = testMeetup.Id
            );
            MeetupRegistrationController.createMeetupRegistration(testRegistration);
        }catch(AuraHandledException e){
            System.assertNotEquals(e, null);
        }
    }

    @IsTest
    static void testPositiveInsert() {
        Meetup__c testMeetup = [SELECT Id,Registration_Limit__c FROM Meetup__c LIMIT 1];
        testMeetup.Registration_Limit__c = 2;
        Meetup_Registration__c testRegistration = new Meetup_Registration__c(
                First_Name__c = 'Test',
                Last_Name__c = 'Test',
                Email__c = 'Test+2@test.com',
                Meetup__c = testMeetup.Id
        );
        
        Meetup_Registration__c returnedRegistration = MeetupRegistrationController.createMeetupRegistration(testRegistration);
        System.assertNotEquals(returnedRegistration, null);
    }
}
