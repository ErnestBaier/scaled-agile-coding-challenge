trigger T_Meetup on Meetup__c (before insert) {
    H_Meetup meetupHandler = new H_Meetup();
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            meetupHandler.handleBeforeInsert(Trigger.new);
        }
    }
}