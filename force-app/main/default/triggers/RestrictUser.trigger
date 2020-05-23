trigger RestrictUser on User (before insert) {
    User u1 = Trigger.New[0];
    ID profid = u1.ProfileId;
    ID manid = u1.ManagerId;
    
    /*if(manid==null){
        u1.addError('Please choose a manager.');
    }
    
    User m1 = [SELECT ProfileId FROM User WHERE Id=:manid];
    if(m1.ProfileId!='00e2w000000pYUGAA2'){
        u1.addError('Selected manager is not a Business User');
    }
    else{*/
    
    Integer rc = [SELECT count() FROM User WHERE ManagerId=:manid];
    if(profid =='00e2w000000pY4sAAE' && rc>1){
        u1.addError('Two Sales users already report to this manager.');
    //}
    }
    
}