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
#import "MSIDTestIdTokenUtil.h"

@interface MSIDRefreshTokenIntegrationTests : XCTestCase

@end

@implementation MSIDRefreshTokenIntegrationTests

#pragma mark - Init with JSON

- (void)testInitWithJSONDictionary_whenFamilyIdProvided_shouldFillData
{
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    NSDictionary *jsonDict = @{@"credential_type" : @"RefreshToken",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": clientInfoString,
                               @"id_token": @"id token",
                               @"secret":@"refresh token",
                               @"family_id":@"family id",
                               @"username":@"test user"
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    XCTAssertNotNil(token);
    NSURL *authority = [NSURL URLWithString:@"https://login.microsoftonline.com/common"];
    XCTAssertEqualObjects(token.authority, authority);
    XCTAssertEqualObjects(token.uniqueUserId, @"user_unique_id");
    XCTAssertEqualObjects(token.clientId, @"test_client_id");
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.idToken, @"id token");
    XCTAssertEqualObjects(token.refreshToken, @"refresh token");
    XCTAssertEqualObjects(token.username, @"test user");
    XCTAssertEqualObjects(token.familyId, @"family id");
}

- (void)testInitWithJSONDictionary_whenNoFamilyIdProvided_shouldFillData
{
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    NSDictionary *jsonDict = @{@"credential_type" : @"RefreshToken",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": clientInfoString,
                               @"id_token": @"id token",
                               @"secret":@"refresh token",
                               @"username":@"test user"
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    XCTAssertNotNil(token);
    NSURL *authority = [NSURL URLWithString:@"https://login.microsoftonline.com/common"];
    XCTAssertEqualObjects(token.authority, authority);
    XCTAssertEqualObjects(token.uniqueUserId, @"user_unique_id");
    XCTAssertEqualObjects(token.clientId, @"test_client_id");
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.idToken, @"id token");
    XCTAssertEqualObjects(token.refreshToken, @"refresh token");
    XCTAssertEqualObjects(token.username, @"test user");
    XCTAssertNil(token.familyId);
}

#pragma mark - JSON dictionary

- (void)testSerializeToJSON_afterDeserialization_shouldReturnData
{
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    NSDictionary *jsonDict = @{@"credential_type" : @"RefreshToken",
                               @"unique_id" : @"user_unique_id",
                               @"environment" : @"login.microsoftonline.com",
                               @"client_id": @"test_client_id",
                               @"client_info": clientInfoString,
                               @"id_token": @"id token",
                               @"secret":@"refresh token",
                               @"family_id":@"family id",
                               @"username":@"test user"
                               };
    
    MSIDToken *token = [[MSIDToken alloc] initWithJSONDictionary:jsonDict error:nil];
    
    NSDictionary *serializedDict = [token jsonDictionary];
    XCTAssertEqualObjects(serializedDict, jsonDict);
}

@end
