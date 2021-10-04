public with sharing class H_Meetup {
    public void handleBeforeInsert(List<Meetup__c> newMeetups) {
        generateRegistrationCode(newMeetups);
    }

    public void generateRegistrationCode(List<Meetup__c> meetupsToProcess) {
        for(Meetup__c meetup : meetupsToProcess) {
            meetup.Registration_Code__c = generateRandomString(8);
        }
    }

    //Method to generate a random string from Developer forums - https://salesforce.stackexchange.com/questions/43823/how-do-i-generate-a-random-string
    //This method does not explicitly check for a unique value among all registrations but has a large enough value set that collision is unlikely.
    public String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }
}
