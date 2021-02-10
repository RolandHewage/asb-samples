import ballerina/config;
import ballerina/log;
import ballerinax/asb;

public function main() {

    // Input values
    string stringContent = "This is My Message Body"; 
    byte[] byteContent = stringContent.toBytes();
    map<string> parameters = {contentType: "plain/text", messageId: "one"};
    map<string> properties = {a: "propertyValue1", b: "propertyValue2"};
    int maxMessageCount = 2;
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
        checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContent, parameters, properties);
        checkpanic senderConnection->sendMessageWithConfigurableParameters(byteContent, parameters, properties);
    } else {
        log:printError("Asb sender connection creation failed.");
    }

    if (receiverConnection is asb:ReceiverConnection) {
        log:print("Receiving from Asb receiver connection.");
        var messageReceived = receiverConnection->receiveMessages(serverWaitTime, maxMessageCount);
        if(messageReceived is asb:Messages) {
            int val = messageReceived.getMessageCount();
            log:print("No. of messages received : " + val.toString());
            asb:Message[] messages = messageReceived.getMessages();
            string messageReceived1 =  checkpanic messages[0].getTextContent();
            log:print("Message1 content : " +messageReceived1);
            string messageReceived2 =  checkpanic messages[1].getTextContent();
            log:print("Message2 content : " +messageReceived2.toString());
        } else {
            log:printError(messageReceived.message());
        }
    } else {
        log:printError("Asb receiver connection creation failed.");
    }

    if (senderConnection is asb:SenderConnection) {
        log:print("Closing Asb sender connection.");
        checkpanic senderConnection.closeSenderConnection();
    }

    if (receiverConnection is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection.");
        checkpanic receiverConnection.closeReceiverConnection();
    }
}    
