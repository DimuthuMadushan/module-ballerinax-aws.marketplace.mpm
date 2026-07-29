// Copyright (c) 2026 WSO2 LLC. (http://www.wso2.com).
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
import ballerina/test;
import ballerina/time;

final time:Utc testTimestamp = [1753488000, 0];

@test:Config {}
isolated function testUsageRecordWithCustomerIdentifier() {
    UsageRecord usageRecord = {
        customerIdentifier: "customer-1",
        dimension: "units",
        timestamp: testTimestamp,
        quantity: 5
    };
    UsageRecord|constraint:Error validated = constraint:validate(usageRecord);
    test:assertTrue(validated is UsageRecord, "a record identified by customerIdentifier must be accepted");
}

@test:Config {}
isolated function testUsageRecordWithCustomerAwsAccountId() {
    UsageRecord usageRecord = {
        customerAWSAccountId: "123456789012",
        dimension: "units",
        timestamp: testTimestamp
    };
    UsageRecord|constraint:Error validated = constraint:validate(usageRecord);
    test:assertTrue(validated is UsageRecord, "a record identified by customerAWSAccountId must be accepted");
}

@test:Config {}
isolated function testUsageRecordWithNonNumericAwsAccountId() {
    UsageRecord usageRecord = {
        customerAWSAccountId: "1234-not-an-account",
        dimension: "units",
        timestamp: testTimestamp
    };
    UsageRecord|constraint:Error validated = constraint:validate(usageRecord);
    test:assertTrue(validated is constraint:Error, "customerAWSAccountId must be all digits");
}

@test:Config {}
isolated function testTagAcceptsServiceSupportedCharacters() {
    Tag tag = {'key: "cost centre/dept+1", value: "a.b_c:d/e@f"};
    Tag|constraint:Error validated = constraint:validate(tag);
    test:assertTrue(validated is Tag, "tags must accept the character set the service accepts");
}

@test:Config {}
isolated function testTagRejectsBackslash() {
    Tag tag = {'key: "cost\\centre", value: "value"};
    Tag|constraint:Error validated = constraint:validate(tag);
    test:assertTrue(validated is constraint:Error, "a backslash is not in the service-supported tag character set");
}

@test:Config {}
isolated function testMinimalMeterUsageRequest() {
    MeterUsageRequest request = {
        productCode: "cqcvf9f0ugw8rkbgmf1c9dxyz",
        timestamp: testTimestamp,
        usageDimension: "units"
    };
    MeterUsageRequest|constraint:Error validated = constraint:validate(request);
    test:assertTrue(validated is MeterUsageRequest, "productCode, timestamp and usageDimension must suffice");
}

@test:Config {}
isolated function testMeterUsageRequestWithOversizedClientToken() {
    MeterUsageRequest request = {
        productCode: "cqcvf9f0ugw8rkbgmf1c9dxyz",
        timestamp: testTimestamp,
        usageDimension: "units",
        clientToken: "a".padZero(65)
    };
    MeterUsageRequest|constraint:Error validated = constraint:validate(request);
    test:assertTrue(validated is constraint:Error, "clientToken is capped at 64 characters");
}

@test:Config {}
isolated function testRegisterUsageRequestRejectsZeroPublicKeyVersion() {
    RegisterUsageRequest request = {productCode: "cqcvf9f0ugw8rkbgmf1c9dxyz", publicKeyVersion: 0};
    RegisterUsageRequest|constraint:Error validated = constraint:validate(request);
    test:assertTrue(validated is constraint:Error, "publicKeyVersion starts at 1");
}

@test:Config {}
isolated function testRegisterUsageRequest() {
    RegisterUsageRequest request = {
        productCode: "cqcvf9f0ugw8rkbgmf1c9dxyz",
        publicKeyVersion: 1,
        nonce: "2ead20e4-3e6d-42cd-8f56-24f02d1cc4e1"
    };
    RegisterUsageRequest|constraint:Error validated = constraint:validate(request);
    test:assertTrue(validated is RegisterUsageRequest, "a nonce-scoped registration must be accepted");
}
