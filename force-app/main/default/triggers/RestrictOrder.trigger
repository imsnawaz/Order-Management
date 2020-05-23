trigger RestrictOrder on Order (before insert) {
    Order ord = Trigger.new[0];
    User u1 = [SELECT ProfileId FROM User WHERE Id=:ord.OwnerId];
    Account acc = [SELECT Ship_To__c,Sold_To__c FROM Account WHERE Id=:ord.AccountId];
    if(u1.ProfileId!='00e2w000000pY4sAAE'){
        ord.addError('Only Sales Users can create Orders.');
    }
    if(ord.ShippingStreet==null||ord.ShippingCity==null||ord.ShippingState==null||ord.ShippingPostalCode==null||ord.ShippingCountry==null){
        ord.addError('Enter shipping details properly.');
    }
    ord.BillToContactId=acc.Sold_To__c;
    ord.ShipToContactId=acc.Ship_To__c;
    ord.Pricebook2Id='01s2w000005otEMAAY';
    ord.BillingStreet=ord.ShippingStreet;
    ord.BillingCity=ord.ShippingCity;
    ord.BillingState=ord.ShippingState;
    ord.BillingPostalCode=ord.ShippingPostalCode;
    ord.BillingCountry=ord.ShippingCountry;
}