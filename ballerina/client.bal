// Copyright (c) 2024 WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/constraint;
import ballerina/jballerina.java;

# AWS Marketplace metering client.
public isolated client class Client {

    # Initialize the Ballerina AWS MPM client.
    # ```ballerina
    # mpm:Client mpm = check new(region = aws:US_EAST_1, auth = {
    #   accessKeyId: "<aws-access-key>",
    #   secretAccessKey: "<aws-secret-key>"
    # });
    # ```
    #
    # + configs - The AWS MPM client configurations
    # + return - The `mpm:Client` or an `mpm:Error` if the initialization failed
    public isolated function init(*ConnectionConfig configs) returns Error? {
        return self.externInit(configs);
    }

    isolated function externInit(ConnectionConfig configs) returns Error? =
    @java:Method {
        name: "init",
        'class: "io.ballerina.lib.aws.mpm.NativeClientAdaptor"
    } external;

    # Retrieves customer details mapped to a registration token.
    # ```ballerina
    # mpm:ResolveCustomerResponse response = check mpm->resolveCustomer("<registration-token>");
    # ```
    # 
    # + registrationToken - The registration-token provided by the customer
    # + return - A Ballerina `mpm:Error` if there was an error while executing the operation or else `mpm:ResolveCustomerResponse`
    isolated remote function resolveCustomer(string registrationToken) returns ResolveCustomerResponse|Error =
    @java:Method {
        'class: "io.ballerina.lib.aws.mpm.NativeClientAdaptor"
    } external;

    # Retrieves the post-metering records for a set of customers.
    # ```ballerina
    # mpm:BatchMeterUsageResponse response = check mpm->batchMeterUsage(productCode = "<aws-product-code>");
    # ```
    # 
    # + request - The request parameters for the `BatchMeterUsage` operation
    # + return - A Ballerina `mpm:Error` if there was an error while executing the operation or else `mpm:BatchMeterUsageResponse`
    isolated remote function batchMeterUsage(*BatchMeterUsageRequest request) returns BatchMeterUsageResponse|Error {
        BatchMeterUsageRequest|constraint:Error validated = constraint:validate(request);
        if validated is constraint:Error {
            return error Error(string `Request validation failed: ${validated.message()}`);
        }
        return self.externBatchMeterUsage(validated);
    }

    isolated function externBatchMeterUsage(BatchMeterUsageRequest request) returns BatchMeterUsageResponse|Error =
    @java:Method {
        name: "batchMeterUsage",
        'class: "io.ballerina.lib.aws.mpm.NativeClientAdaptor"
    } external;

    # Emits a metering record for the software running in the buyer's AWS account. Unlike `batchMeterUsage`, this
    # operation is invoked by the running software itself (AMI, Amazon ECS, or Amazon EKS products) and is signed
    # with the buyer's instance, task, or pod credentials, so the client must be configured with
    # `auth:DEFAULT_CREDENTIALS`. Usage can be reported only once per hour per dimension.
    # ```ballerina
    # mpm:MeterUsageResponse response = check mpm->meterUsage(
    #     productCode = "<aws-product-code>",
    #     timestamp = time:utcNow(),
    #     usageDimension = "<dimension>",
    #     usageQuantity = 1
    # );
    # ```
    #
    # + request - The request parameters for the `MeterUsage` operation
    # + return - A Ballerina `mpm:Error` if there was an error while executing the operation or else `mpm:MeterUsageResponse`
    isolated remote function meterUsage(*MeterUsageRequest request) returns MeterUsageResponse|Error {
        MeterUsageRequest|constraint:Error validated = constraint:validate(request);
        if validated is constraint:Error {
            return error Error(string `Request validation failed: ${validated.message()}`);
        }
        return self.externMeterUsage(validated);
    }

    isolated function externMeterUsage(MeterUsageRequest request) returns MeterUsageResponse|Error =
    @java:Method {
        name: "meterUsage",
        'class: "io.ballerina.lib.aws.mpm.NativeClientAdaptor"
    } external;

    # Verifies that the buyer running a paid container product is entitled to it, and commences metering. Paid
    # container products on Amazon ECS or Amazon EKS must call this operation at container startup.
    # ```ballerina
    # mpm:RegisterUsageResponse response = check mpm->registerUsage(
    #     productCode = "<aws-product-code>",
    #     publicKeyVersion = 1
    # );
    # ```
    #
    # + request - The request parameters for the `RegisterUsage` operation
    # + return - A Ballerina `mpm:Error` if there was an error while executing the operation or else `mpm:RegisterUsageResponse`
    isolated remote function registerUsage(*RegisterUsageRequest request) returns RegisterUsageResponse|Error {
        RegisterUsageRequest|constraint:Error validated = constraint:validate(request);
        if validated is constraint:Error {
            return error Error(string `Request validation failed: ${validated.message()}`);
        }
        return self.externRegisterUsage(validated);
    }

    isolated function externRegisterUsage(RegisterUsageRequest request) returns RegisterUsageResponse|Error =
    @java:Method {
        name: "registerUsage",
        'class: "io.ballerina.lib.aws.mpm.NativeClientAdaptor"
    } external;

    # Closes the AWS MPM client resources.
    # ```ballerina
    # check mpm->close();
    # ```
    # 
    # + return - A `mpm:Error` if there is an error while closing the client resources or else nil.
    remote function close() returns Error? =
    @java:Method {
        'class: "io.ballerina.lib.aws.mpm.NativeClientAdaptor"
    } external;
}
