trigger RestrictAccount on Account (before insert) {
    Account acc = Trigger.new[0];
    Integer rc = [SELECT count() FROM Account WHERE OwnerId =:acc.OwnerId];
    User u1 = [SELECT ProfileId FROM User WHERE Id =:acc.OwnerId];
    if(rc>4 && u1.ProfileId=='00e2w000000pY4sAAE'){
        acc.addError('Current Sales user already manages 5 accounts.');
    }
    if(acc.Ship_To__c==null){
        acc.Ship_To__c = acc.Sold_To__c;
    }
}