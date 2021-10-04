@IsTest
public with sharing class H_Meetup_Test {
    /**
    * Test class covering the T_Meetup trigger and H_Meetup Apex class
    * Test covers insert of Meetup__c
    */
    @IsTest
    static void testMeetupInsert() {
        
        insert new Meetup__c(
            Name = 'Test Meetup',
            Status__c = 'Open',
            Registration_Limit__c = 500
        );

        //Assert to verify record was inserted
        List<Meetup__c> foundMeetups = [SELECT Id,Registration_Code__c FROM Meetup__c];
        System.assertEquals(foundMeetups.size(),1);

        //Assert to verify registration code was added by trigger/handler
        System.assertNotEquals(foundMeetups[0].Registration_Code__c, null);
    }
}
