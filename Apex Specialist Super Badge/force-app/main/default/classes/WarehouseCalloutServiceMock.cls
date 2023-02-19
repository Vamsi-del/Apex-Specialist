@isTest
public class WarehouseCalloutServiceMock implements HttpCalloutMock{
    // implement http mock callout
    public static HttpResponse respond(HttpRequest request){
        Http http = new Http();
        HttpResponse respond = new HttpResponse();
        respond.setBody('[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Test Product","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"}]');
        respond.setStatus('OK');
        respond.setStatusCode(200);
        return respond;
    }
}