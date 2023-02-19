@isTest
public with sharing class WarehouseSyncScheduleTest {
    public static string CRON_EXP = '0 0 1 * * ?';
    // implement scheduled code here
    @isTest 
    
    public static void ScedulerTest(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        System.abortJob([SELECT Id, CronExpression,CronJobDetail.Name, TimesTriggered, NextFireTime FROM CronTrigger WHERE CronJobDetail.JobType = '7' LIMIT 1].Id);
        String jobId = System.schedule('WarehouseSyncScheduleJob',
                                       CRON_EXP, new WarehouseSyncSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, CronJobDetail.JobType, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
        
        System.assertEquals(0, ct.TimesTriggered);        
        System.assertEquals('7', ct.CronJobDetail.JobType); 
        Test.stopTest();
        
    }
}