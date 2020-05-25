public class EmailNotification {
    public static void sendMail(List<Id> ids){
        Account acc = [SELECT Email_Opt_Out__c FROM Account WHERE Id=:ids[1]];
        if(acc.Email_Opt_Out__c==false){
            List<Contact> cons = new List<Contact>();
            if(ids.size()==4)
                cons = [SELECT Id,Email_Opt_Out__c FROM Contact WHERE Id=:ids[2]];
			if(ids.size()==5)
            	cons = [SELECT Id,Email_Opt_Out__c FROM Contact WHERE Id IN (:ids[2],:ids[3])];
        	List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        	for(Contact con : cons){
            	if(con.Email_Opt_Out__c==false){
                	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    				mail.setTargetObjectId(con.Id);
    				mail.setWhatId(ids[0]);
    				mail.setSenderDisplayName('Enavate Support');
        			mail.setTemplateId(ids[ids.size()-1]);
                    mails.add(mail);
            	}
        	}
            Messaging.sendEmail(mails);
    	}
    }
}
