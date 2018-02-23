// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <XCTest/XCTest.h>
#import "MSIDTestTokenResponse.h"
#import "MSIDToken.h"
#import "MSIDTestCacheIdentifiers.h"
#import "MSIDTestRequestParams.h"
#import "MSIDAADV1TokenResponse.h"
#import "MSIDAADV1RequestParameters.h"
#import "MSIDAADV2TokenResponse.h"
#import "MSIDAADV2RequestParameters.h"
#import "NSDictionary+MSIDTestUtil.h"

@interface MSIDBaseTokenIntegrationTests : XCTestCase

@end

@implementation MSIDBaseTokenIntegrationTests

#pragma mark - Init with JSON

- (void)testInitWithJSONDictionary_whenWrongCredentialType_shouldReturnNil
{
    NSDictionary *jsonDict = @{@"credential_type" : @"RefreshToken"};
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    XCTAssertNil(token);
}

- (void)testInitWithJSONDictionary_whenNoSPEInfo_shouldFillData
{
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    NSDictionary *jsonDict = @{@"credential_type" : @"Token",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": clientInfoString
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    XCTAssertNotNil(token);
    NSURL *authority = [NSURL URLWithString:@"https://login.microsoftonline.com/common"];
    XCTAssertEqualObjects(token.authority, authority);
    XCTAssertEqualObjects(token.uniqueUserId, @"user_unique_id");
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSDictionary dictionary]);
}

- (void)testInitWithJSONDictionary_whenSPEInfo_shouldFillDataAndSPEInfo
{
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    NSDictionary *jsonDict = @{@"credential_type" : @"Token",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": clientInfoString,
                               @"spe_info": @"I"
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    XCTAssertNotNil(token);
    NSURL *authority = [NSURL URLWithString:@"https://login.microsoftonline.com/common"];
    XCTAssertEqualObjects(token.authority, authority);
    XCTAssertEqualObjects(token.uniqueUserId, @"user_unique_id");
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    NSDictionary *additionalInfo = @{@"spe_info": @"I"};
    XCTAssertEqualObjects(token.additionalInfo, additionalInfo);
}

- (void)testInitWithJSONDictionary_whenCorruptedClientInfo_shouldFillData
{
    NSDictionary *jsonDict = @{@"credential_type" : @"Token",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": @"test"
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    XCTAssertNotNil(token);
    NSURL *authority = [NSURL URLWithString:@"https://login.microsoftonline.com/common"];
    XCTAssertEqualObjects(token.authority, authority);
    XCTAssertEqualObjects(token.uniqueUserId, @"user_unique_id");
    XCTAssertNil(token.clientInfo.rawClientInfo);
    XCTAssertEqualObjects(token.additionalInfo, [NSDictionary dictionary]);
}

- (void)testInitWithJSONDictionary_whenNoClientInfo_shouldFillData
{
    NSDictionary *jsonDict = @{@"credential_type" : @"Token",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    XCTAssertNotNil(token);
    NSURL *authority = [NSURL URLWithString:@"https://login.microsoftonline.com/common"];
    XCTAssertEqualObjects(token.authority, authority);
    XCTAssertEqualObjects(token.uniqueUserId, @"user_unique_id");
    XCTAssertNil(token.clientInfo.rawClientInfo);
    XCTAssertEqualObjects(token.additionalInfo, [NSDictionary dictionary]);
}

#pragma mark - JSON dictionary

- (void)testSerializeToJSON_afterDeserialization_shouldReturnData
{
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    NSDictionary *jsonDict = @{@"credential_type" : @"Token",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": clientInfoString,
                               @"spe_info": @"I"
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    NSDictionary *serializedDict = [token jsonDictionary];
    XCTAssertEqualObjects(jsonDict, serializedDict);
}

- (void)testSerializeToJSON_afterDeserialization_noUniqueId_shouldReturnData
{
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    NSDictionary *jsonDict = @{@"credential_type" : @"Token",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": clientInfoString,
                               @"spe_info": @"I"
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    NSDictionary *serializedDict = [token jsonDictionary];
    XCTAssertEqualObjects(serializedDict[@"credential_type"], @"Token");
    XCTAssertEqualObjects(serializedDict[@"environment"], @"login.microsoftonline.com");
    XCTAssertEqualObjects(serializedDict[@"client_id"], @"test_client_id");
    XCTAssertEqualObjects(serializedDict[@"client_info"], clientInfoString);
    XCTAssertEqualObjects(serializedDict[@"spe_info"], @"I");
    XCTAssertEqualObjects(serializedDict[@"unique_id"], @"1.1234-5678-90abcdefg");
}

@end
