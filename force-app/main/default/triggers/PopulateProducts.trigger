trigger PopulateProducts on Invoice__c (before insert, after insert, after update) {
        if(Trigger.isInsert){
            if(Trigger.isBefore){
                for(Invoice__c inv : Trigger.New){
                    Decimal qty = 0.0;
                    Decimal disc = 0.0;
                    List<OrderItem> li = [SELECT ListPrice,UnitPrice,Quantity FROM OrderItem WHERE OrderId =:inv.Order_Reference__c];
                    for(OrderItem oi: li){
                        qty+=oi.Quantity;
                        disc+=(oi.ListPrice-oi.UnitPrice)*oi.Quantity;
                    }
                    inv.Invoice_Quantity__c=qty;
                    inv.Discount__c=disc;
                }
            }
            else if(Trigger.isAfter){
                for(Invoice__c inv : Trigger.New){
                    List<OrderItem> li = [SELECT Id,Invoice__c FROM OrderItem WHERE OrderId =:inv.Order_Reference__c];
                    List<Product_Invoice__c> pi = new List<Product_Invoice__c>();
                    for(OrderItem oi: li){
                        oi.Invoice__c=inv.Id;
                        pi.add(new Product_Invoice__c(Order_Line_Item_Number__c=oi.Id));
                    }
                    update li;
                    insert pi;
                    Order ord = [SELECT Id,Stage__c FROM Order WHERE Id=:inv.Order_Reference__c];
                    ord.Stage__c='Invoice Generated';
                    update ord;
                }
            }
        }
        else if(Trigger.isUpdate){
            for(Invoice__c inv:Trigger.New){
                Invoice__c oldinv = Trigger.oldMap.get(inv.Id);
                if((inv.Account_Reference__c!=oldinv.Account_Reference__c) || (inv.Order_Reference__c!=oldinv.Order_Reference__c) || (inv.Invoice_Quantity__c!=oldinv.Invoice_Quantity__c) || (inv.Invoice_Currency__c!=oldinv.Invoice_Currency__c)|| (inv.Discount__c!=oldinv.Discount__c) || oldinv.Invoice_Payment_Received__c==true){
                    inv.addError('Can\'t alter invoice data after creation.');
                }
                if(inv.Invoice_Payment_Received__c==true && oldinv.Invoice_Payment_Received__c==false){
                    Order ord = [SELECT Id,Stage__c FROM Order WHERE Id=:inv.Order_Reference__c];
                    ord.Stage__c='Payment Received';
                    update ord;
                }
            }
        }
}