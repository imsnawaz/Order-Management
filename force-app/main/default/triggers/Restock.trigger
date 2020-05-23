trigger Restock on Order (before delete,after update,after insert) {
    if(Trigger.isDelete){
        if(Trigger.old[0].Stage__c!='Cancelled'){
            List<Product2> products= new List<Product2>();
            List<OrderItem> oi = [SELECT Product2Id,Quantity FROM OrderItem WHERE OrderId =:Trigger.old[0].Id];
            for(OrderItem item: oi){
                Product2 p = [SELECT Id,Stock_Quantity__c FROM Product2 WHERE Id =:item.Product2Id];
                p.Stock_Quantity__c=p.Stock_Quantity__c+item.Quantity;
                products.add(p);
            }
            update(products);
        }
    }
    else{
    	Order ord = Trigger.new[0];
    	List<Id> mailinglist = new List<Id>();
    	mailinglist.add(ord.Id);
		mailinglist.add(ord.AccountId);

    	EmailTemplate et1=[Select id from EmailTemplate where DeveloperName=:'Order_Confirmation'];
    	EmailTemplate et2=[Select id from EmailTemplate where DeveloperName=:'Order_Processing'];
    	EmailTemplate et3=[Select id from EmailTemplate where DeveloperName=:'Order_Cancelled'];

    	if(Trigger.isUpdate){
        	if(ord.Stage__c=='Cancelled'){
            	List<Product2> products= new List<Product2>();
            	List<OrderItem> oi = [SELECT Product2Id,Quantity FROM OrderItem WHERE OrderId =: ord.Id];
            	for(OrderItem item: oi){
                	Product2 p = [SELECT Id,Stock_Quantity__c FROM Product2 WHERE Id =:item.Product2Id];
                	p.Stock_Quantity__c=p.Stock_Quantity__c+item.Quantity;
                	products.add(p);
            	}
            	update(products);
            	mailinglist.add(et3.id);
        	}
        	if(ord.Approval_Status__c=='Approved'&&ord.Stage__c=='In Process'){
            	insert new Invoice__c(Order_Reference__c=ord.Id,Account_Reference__c=ord.AccountId);
            	mailinglist.add(et2.id);
        	}
    	}
    	else if(Trigger.isInsert){
        	mailinglist.add(et1.id);
    	}
        if(ord.ShipToContactId!=null)
            mailinglist.add(ord.ShipToContactId);
		if(ord.BillToContactId!=null)
            mailinglist.add(ord.BillToContactId);
        EmailNotification.sendMail(mailinglist);
    }
}