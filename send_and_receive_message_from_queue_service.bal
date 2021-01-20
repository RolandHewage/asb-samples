import ballerina/config;
import ballerina/log;
import ballerina/http;
import ballerinax/asb;

service /asb on new http:Listener(9090) {

    resource function get sendAndReceive(http:Caller caller, http:Request req)
            returns error? {

        string stringContent = "This is My Message Body"; 
        byte[] byteContent = stringContent.toBytes();
        json jsonContent = {name: "apple", color: "red", price: 5.36};
        byte[] byteContentFromJson = jsonContent.toJsonString().toBytes();
        map<string> parameters1 = {contentType: "application/json", messageId: "one"};
        map<string> parameters2 = {contentType: "application/json", messageId: "two", to: "sanju", replyTo: "carol", 
        label: "a1", sessionId: "b1", correlationId: "c1", timeToLive: "2"};
        map<string> parameters = {contentType: "application/json", messageId: "one", to: "sanju", replyTo: "carol", 
        label: "a1", sessionId: "b1", correlationId: "c1", timeToLive: "2"};
        map<string> properties = {a: "propertyValue1", b: "propertyValue2"};
        int serverWaitTime = 5;

        asb:ConnectionConfiguration config = {
            connectionString: config:getAsString("CONNECTION_STRING"),
            entityPath: config:getAsString("QUEUE_PATH")
        };

        log:print("Creating Asb sender connection.");
        asb:SenderConnection? senderConnection = checkpanic new (config);

        log:print("Creating Asb receiver connection.");
        asb:ReceiverConnection? receiverConnection = checkpanic new (config);

        if (senderConnection is asb:SenderConnection) {
            log:print("Sending via Asb sender connection.");
            checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContent, parameters1, properties);
            checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContentFromJson, parameters2, properties);
        }

        if (receiverConnection is asb:ReceiverConnection) {
            log:print("Receiving from Asb receiver connection.");
            asb:Message|asb:Error? messageReceived = receiverConnection->receiveMessage(serverWaitTime);
            asb:Message|asb:Error? jsonMessageReceived = receiverConnection->receiveMessage(serverWaitTime);
            if (messageReceived is asb:Message && jsonMessageReceived is asb:Message) {
                string messageRead = checkpanic messageReceived.getTextContent();
                log:print("Reading Received Message : " + messageRead);
                json jsonMessageRead = checkpanic jsonMessageReceived.getJSONContent();
                log:print("Reading Received Message : " + jsonMessageRead.toString());
            } 
        }

        if (senderConnection is asb:SenderConnection) {
            log:print("Closing Asb sender connection.");
            checkpanic senderConnection.closeSenderConnection();
        }

        if (receiverConnection is asb:ReceiverConnection) {
            log:print("Closing Asb receiver connection.");
            checkpanic receiverConnection.closeReceiverConnection();
        }

        check caller->respond("Successful!");
    }
}
