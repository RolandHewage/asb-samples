import ballerina/config;
import ballerina/log;
import ballerinax/asb;

public function main() {

    // Input values
    string stringContent = "This is My Message Body"; 
    byte[] byteContent = stringContent.toBytes();
    json jsonContent = {name: "apple", color: "red", price: 5.36};
    byte[] byteContentFromJson = jsonContent.toJsonString().toBytes();
    json[] jsonArrayContent = [{name: "apple", color: "red", price: 5.36}, {first: "John", last: "Pala"}];
    string[] stringArrayContent = ["apple", "mango", "lemon", "orange"];
    int[] integerArrayContent = [4, 5, 6];
    map<string> parameters = {contentType: "application/json", messageId: "one", to: "sanju", replyTo: "carol", 
        label: "a1", sessionId: "b1", correlationId: "c1", timeToLive: "2"};
    map<string> parameters1 = {contentType: "application/json", messageId: "one"};
    map<string> parameters2 = {contentType: "application/json", messageId: "two", to: "sanju", replyTo: "carol", 
        label: "a1", sessionId: "b1", correlationId: "c1", timeToLive: "2"};
    map<string> parameters3 = {contentType: "application/json"};
    map<string> parameters4 = {contentType: "application/text", timeToLive: "8"};
    map<string> properties = {a: "propertyValue1", b: "propertyValue2"};
    string asyncConsumerMessage = "";
    int maxMessageCount = 3;
    int maxMessageCount1 = 2;
    int serverWaitTime = 5;
    int prefetchCountDisabled = 0;
    int prefetchCountEnabled = 50;
    int messageCount = 100;
    int variableMessageCount = 1000;

    asb:ConnectionConfiguration senderConfig = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("TOPIC_PATH")
    };

    asb:ConnectionConfiguration receiverConfig1 = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("SUBSCRIPTION_PATH1")
    };

    asb:ConnectionConfiguration receiverConfig2 = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("SUBSCRIPTION_PATH2")
    };

    asb:ConnectionConfiguration receiverConfig3 = {
        connectionString: config:getAsString("CONNECTION_STRING"),
        entityPath: config:getAsString("SUBSCRIPTION_PATH3")
    };

    log:print("Creating Asb sender connection.");
    asb:SenderConnection? senderConnection = checkpanic new (senderConfig);

    log:print("Creating Asb receiver connection.");
    asb:ReceiverConnection? receiverConnection1 = checkpanic new (receiverConfig1);
    asb:ReceiverConnection? receiverConnection2 = checkpanic new (receiverConfig2);
    asb:ReceiverConnection? receiverConnection3 = checkpanic new (receiverConfig3);

    if (senderConnection is asb:SenderConnection) {
        log:print("Sending via Asb sender connection.");
        checkpanic senderConnection->sendBatchMessage(stringArrayContent, parameters3, properties, maxMessageCount);
    } else {
        log:printError("Asb sender connection creation failed.");
    }

    if (receiverConnection1 is asb:ReceiverConnection) {
        log:print("Receiving from Asb receiver connection 1.");
        var messagesReceived = receiverConnection1->receiveBatchMessage(maxMessageCount);
        if(messagesReceived is asb:Messages) {
            int val = messagesReceived.getMessageCount();
            log:print("No. of messages received : " + val.toString());
            asb:Message[] messages = messagesReceived.getMessages();
            string messageReceived1 =  checkpanic messages[0].getTextContent();
            log:print("Message1 content : " + messageReceived1);
            string messageReceived2 =  checkpanic messages[1].getTextContent();
            log:print("Message2 content : " + messageReceived2);
            string messageReceived3 =  checkpanic messages[2].getTextContent();
            log:print("Message3 content : " + messageReceived3);
        }else {
            log:printError("Receiving message via Asb receiver connection failed.");
        }
    } else {
        log:printError("Asb receiver connection creation failed.");
    }

    if (receiverConnection2 is asb:ReceiverConnection) {
        log:print("Receiving from Asb receiver connection 2.");
        var messagesReceived = receiverConnection2->receiveBatchMessage(maxMessageCount);
        if(messagesReceived is asb:Messages) {
            int val = messagesReceived.getMessageCount();
            log:print("No. of messages received : " + val.toString());
            asb:Message[] messages = messagesReceived.getMessages();
            string messageReceived1 =  checkpanic messages[0].getTextContent();
            log:print("Message1 content : " + messageReceived1);
            string messageReceived2 =  checkpanic messages[1].getTextContent();
            log:print("Message2 content : " + messageReceived2);
            string messageReceived3 =  checkpanic messages[2].getTextContent();
            log:print("Message3 content : " + messageReceived3);
        } else {
            log:printError("Receiving message via Asb receiver connection failed.");
        }
    } else {
        log:printError("Asb receiver connection creation failed.");
    }

    if (receiverConnection3 is asb:ReceiverConnection) {
        log:print("Receiving from Asb receiver connection 3.");
        var messagesReceived = receiverConnection3->receiveBatchMessage(maxMessageCount);
        if(messagesReceived is asb:Messages) {
            int val = messagesReceived.getMessageCount();
            log:print("No. of messages received : " + val.toString());
            asb:Message[] messages = messagesReceived.getMessages();
            string messageReceived1 =  checkpanic messages[0].getTextContent();
            log:print("Message1 content : " + messageReceived1);
            string messageReceived2 =  checkpanic messages[1].getTextContent();
            log:print("Message2 content : " + messageReceived2);
            string messageReceived3 =  checkpanic messages[2].getTextContent();
            log:print("Message3 content : " + messageReceived3);
        } else {
            log:printError("Receiving message via Asb receiver connection failed.");
        }
    } else {
        log:printError("Asb receiver connection creation failed.");
    }

    if (senderConnection is asb:SenderConnection) {
        log:print("Closing Asb sender connection.");
        checkpanic senderConnection.closeSenderConnection();
    }

    if (receiverConnection1 is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection 1.");
        checkpanic receiverConnection1.closeReceiverConnection();
    }

    if (receiverConnection2 is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection 2.");
        checkpanic receiverConnection2.closeReceiverConnection();
    }

    if (receiverConnection3 is asb:ReceiverConnection) {
        log:print("Closing Asb receiver connection 3.");
        checkpanic receiverConnection3.closeReceiverConnection();
    }
}    
