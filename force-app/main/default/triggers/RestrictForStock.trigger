trigger RestrictForStock on OrderItem (before insert,before update,after delete) {
    if(Trigger.isInsert){
            for(OrderItem item : Trigger.New){
                Product2 p = [SELECT Id,Name,Stock_Quantity__c FROM Product2 WHERE Id=:item.Product2Id];
                if(item.Quantity >10){
                    item.Quantity = item.Quantity +1;
                    item.UnitPrice = (item.UnitPrice*(item.Quantity-1)/item.Quantity);
                }
                if(item.Quantity>p.Stock_Quantity__c){
                    item.addError('Quantity can\'t be greater than stock!');
                }
                else{
                    p.Stock_Quantity__c=p.Stock_Quantity__c-item.Quantity;
                    update p;
                }
            }
    }    
    else if(Trigger.isUpdate){
        for(Integer i=0;i<Trigger.new.size();i++){
            Product2 q = [SELECT Id,Name,Stock_Quantity__c FROM Product2 WHERE Id=:Trigger.new[i].Product2Id];
            if(Trigger.new[i].Quantity >10&&Trigger.new[i].Invoice__c==null){
                Trigger.new[i].Quantity = Trigger.new[i].Quantity +1;
                Trigger.new[i].UnitPrice = (Trigger.new[i].UnitPrice*(Trigger.new[i].Quantity-1)/Trigger.new[i].Quantity);
            }
            if(Trigger.new[i].Quantity>(q.Stock_Quantity__c+Trigger.old[i].Quantity)){
                Trigger.new[i].addError('Quantity can\'t be greater than stock!');
            }
            else{
                q.Stock_Quantity__c=q.Stock_Quantity__c+Trigger.old[i].Quantity-Trigger.new[i].Quantity;
                update q;
            }
        }
    }
    else if(Trigger.isDelete){
        for(Integer i=0;i<Trigger.old.size();i++){
            Product2 r = [SELECT Id,Name,Stock_Quantity__c FROM Product2 WHERE Id=:Trigger.old[i].Product2Id];
            r.Stock_Quantity__c=r.Stock_Quantity__c+Trigger.old[i].Quantity;
            update r;
        }
    }
}