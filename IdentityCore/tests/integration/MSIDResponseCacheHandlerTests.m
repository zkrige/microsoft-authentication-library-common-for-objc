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
#import "MSIDResponseCacheHandler.h"
#import "MSIDTestTokenResponse.h"
#import "MSIDTestRequestParams.h"
#import "MSIDAADV1TokenResponse.h"
#import "MSIDAADV2TokenResponse.h"
#import "MSIDAADV1RequestParameters.h"
#import "MSIDAADV2RequestParameters.h"
#import "MSIDToken.h"
#import "MSIDTestCacheIdentifiers.h"
#import "MSIDTestIdTokenUtil.h"
#import "NSDictionary+MSIDTestUtil.h"

@interface MSIDResponseCacheHandlerTests : XCTestCase

@end

@implementation MSIDResponseCacheHandlerTests

#pragma mark - ID tokens

- (void)testIDTokenFromTokenResponse_whenOIDCTokenResponse_shouldFillToken
{
    MSIDTokenResponse *response = [MSIDTestTokenResponse defaultTokenResponseWithAT:DEFAULT_TEST_ACCESS_TOKEN
                                                                                 RT:DEFAULT_TEST_REFRESH_TOKEN
                                                                             scopes:[NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil]
                                                                           username:DEFAULT_TEST_ID_TOKEN_USERNAME
                                                                            subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    MSIDRequestParameters *params = [MSIDTestRequestParams defaultParams];
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler idToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    XCTAssertEqualObjects(token.uniqueUserId, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertNil(token.clientInfo);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithPreferredUsername:DEFAULT_TEST_ID_TOKEN_USERNAME subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.genericToken, idToken);
}

- (void)testIDTokenFromTokenResponse_whenAADV1TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler idToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.genericToken, idToken);
}

- (void)testIDTokenFromTokenResponse_whenAADV1TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler idToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.genericToken, idToken);
}

- (void)testIDTokenFromTokenResponse_whenAADV2TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler idToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.genericToken, idToken);
}

- (void)testIDTokenFromTokenResponse_whenAADV2TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler idToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.genericToken, idToken);
}

#pragma mark - ADFS tokens

- (void)testADFSTokenFromTokenResponse_whenOIDCTokenResponse_shouldFillToken
{
    MSIDTokenResponse *response = [MSIDTestTokenResponse defaultTokenResponseWithAT:DEFAULT_TEST_ACCESS_TOKEN
                                                                                 RT:DEFAULT_TEST_REFRESH_TOKEN
                                                                             scopes:[NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil]
                                                                           username:DEFAULT_TEST_ID_TOKEN_USERNAME
                                                                            subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    MSIDRequestParameters *params = [MSIDTestRequestParams defaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler adfsToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    XCTAssertEqualObjects(token.uniqueUserId, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertNil(token.clientInfo);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithPreferredUsername:DEFAULT_TEST_ID_TOKEN_USERNAME subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    NSOrderedSet *scopes = [NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil];
    
    XCTAssertEqualObjects(token.scopes, scopes);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testADFSTokenFromTokenResponse_whenAADV1TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler adfsToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.resource, DEFAULT_TEST_RESOURCE);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testADFSTokenFromTokenResponse_whenAADV1TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler adfsToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.resource, DEFAULT_TEST_RESOURCE);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testADFSTokenFromTokenResponse_whenAADV2TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler adfsToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    NSOrderedSet *scopes = [NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil];
    
    XCTAssertEqualObjects(token.scopes, scopes);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testADFSTokenFromTokenResponse_whenAADV2TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler adfsToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    NSOrderedSet *scopes = [NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil];
    
    XCTAssertEqualObjects(token.scopes, scopes);
    XCTAssertNotNil(token.expiresOn);
}

#pragma mark - Refresh tokens

- (void)testRefreshTokenFromTokenResponse_whenOIDCTokenResponse_shouldFillToken
{
    MSIDTokenResponse *response = [MSIDTestTokenResponse defaultTokenResponseWithAT:DEFAULT_TEST_ACCESS_TOKEN
                                                                                 RT:DEFAULT_TEST_REFRESH_TOKEN
                                                                             scopes:[NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil]
                                                                           username:DEFAULT_TEST_ID_TOKEN_USERNAME
                                                                            subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    MSIDRequestParameters *params = [MSIDTestRequestParams defaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler refreshToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    XCTAssertEqualObjects(token.uniqueUserId, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertNil(token.clientInfo);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithPreferredUsername:DEFAULT_TEST_ID_TOKEN_USERNAME subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    XCTAssertEqualObjects(token.idToken, idToken);
    
    XCTAssertEqualObjects(token.username, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertNil(token.familyId);
}

- (void)testRefreshTokenFromTokenResponse_whenAADV1TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler refreshToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    XCTAssertEqualObjects(token.username, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertNil(token.familyId);
}

- (void)testRefreshTokenFromTokenResponse_whenAADV1TokenResponse_v1RequestParams_withFamilyId_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponseWithFamilyId:DEFAULT_TEST_FAMILY_ID];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler refreshToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    XCTAssertEqualObjects(token.username, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertEqualObjects(token.familyId, DEFAULT_TEST_FAMILY_ID);
}

- (void)testRefreshTokenFromTokenResponse_whenAADV1TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler refreshToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    XCTAssertEqualObjects(token.username, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertNil(token.familyId);
}

- (void)testRefreshTokenFromTokenResponse_whenAADV2TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler refreshToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    XCTAssertEqualObjects(token.username, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertNil(token.familyId);
}

- (void)testRefreshTokenFromTokenResponse_whenAADV2TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler refreshToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(token.refreshToken, DEFAULT_TEST_REFRESH_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_REFRESH_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    XCTAssertEqualObjects(token.username, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertNil(token.familyId);
}

#pragma mark - Access tokens

- (void)testAccessTokenFromTokenResponse_whenOIDCTokenResponse_shouldFillToken
{
    MSIDTokenResponse *response = [MSIDTestTokenResponse defaultTokenResponseWithAT:DEFAULT_TEST_ACCESS_TOKEN
                                                                                 RT:DEFAULT_TEST_REFRESH_TOKEN
                                                                             scopes:[NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil]
                                                                           username:DEFAULT_TEST_ID_TOKEN_USERNAME
                                                                            subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    MSIDRequestParameters *params = [MSIDTestRequestParams defaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler accessToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    XCTAssertEqualObjects(token.uniqueUserId, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertNil(token.clientInfo);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_ACCESS_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithPreferredUsername:DEFAULT_TEST_ID_TOKEN_USERNAME subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    NSOrderedSet *scopes = [NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil];
    
    XCTAssertEqualObjects(token.scopes, scopes);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testAccessTokenFromTokenResponse_whenAADV1TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler accessToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_ACCESS_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.resource, DEFAULT_TEST_RESOURCE);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testAccessTokenFromTokenResponse_whenAADV1TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler accessToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_ACCESS_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil idTokenWithName:DEFAULT_TEST_ID_TOKEN_NAME upn:DEFAULT_TEST_ID_TOKEN_USERNAME tenantId:DEFAULT_TEST_UTID];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    XCTAssertEqualObjects(token.resource, DEFAULT_TEST_RESOURCE);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testAccessTokenFromTokenResponse_whenAADV2TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler accessToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_ACCESS_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    NSOrderedSet *scopes = [NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil];
    
    XCTAssertEqualObjects(token.scopes, scopes);
    XCTAssertNotNil(token.expiresOn);
}

- (void)testAccessTokenFromTokenResponse_whenAADV2TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDToken *token = [responseHandler accessToken];
    
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_ACCESS_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    NSOrderedSet *scopes = [NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil];
    
    XCTAssertEqualObjects(token.scopes, scopes);
    XCTAssertNotNil(token.expiresOn);
}

#pragma mark - Account

- (void)testAccountTokenFromTokenResponse_whenOIDCTokenResponse_shouldFillToken
{
    MSIDTokenResponse *response = [MSIDTestTokenResponse defaultTokenResponseWithAT:DEFAULT_TEST_ACCESS_TOKEN
                                                                                 RT:DEFAULT_TEST_REFRESH_TOKEN
                                                                             scopes:[NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil]
                                                                           username:DEFAULT_TEST_ID_TOKEN_USERNAME
                                                                            subject:DEFAULT_TEST_ID_TOKEN_SUBJECT];
    
    MSIDRequestParameters *params = [MSIDTestRequestParams defaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDAccount *account = [responseHandler account];
    
    XCTAssertEqualObjects(account.authority, params.authority);
    XCTAssertEqualObjects(account.clientId, params.clientId);
    XCTAssertEqualObjects(account.uniqueUserId, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertNil(account.clientInfo);
    XCTAssertEqualObjects(account.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(account.legacyUserId, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertEqualObjects(account.uid, DEFAULT_TEST_ID_TOKEN_SUBJECT);
    XCTAssertEqualObjects(account.utid, @"");
}

- (void)testAccountTokenFromTokenResponse_whenAADV1TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDAccount *account = [responseHandler account];
    
    XCTAssertEqualObjects(account.authority, params.authority);
    XCTAssertEqualObjects(account.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(account.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(account.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(account.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(account.legacyUserId, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertEqualObjects(account.uid, DEFAULT_TEST_UID);
    XCTAssertEqualObjects(account.utid, DEFAULT_TEST_UTID);
}

- (void)testAccountTokenFromTokenResponse_whenAADV1TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV1TokenResponse *response = [MSIDTestTokenResponse v1DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDAccount *account = [responseHandler account];
    
    XCTAssertEqualObjects(account.authority, params.authority);
    XCTAssertEqualObjects(account.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(account.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(account.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(account.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(account.legacyUserId, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertEqualObjects(account.uid, DEFAULT_TEST_UID);
    XCTAssertEqualObjects(account.utid, DEFAULT_TEST_UTID);
}

- (void)testAccountTokenFromTokenResponse_whenAADV2TokenResponse_v1RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV1RequestParameters *params = [MSIDTestRequestParams v1DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDAccount *account = [responseHandler account];
    
    XCTAssertEqualObjects(account.authority, params.authority);
    XCTAssertEqualObjects(account.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(account.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(account.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(account.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(account.legacyUserId, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertEqualObjects(account.uid, DEFAULT_TEST_UID);
    XCTAssertEqualObjects(account.utid, DEFAULT_TEST_UTID);
}

- (void)testAccountTokenFromTokenResponse_whenAADV2TokenResponse_v2RequestParams_shouldFillToken
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    MSIDAccount *account = [responseHandler account];
    
    XCTAssertEqualObjects(account.authority, params.authority);
    XCTAssertEqualObjects(account.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(account.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(account.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(account.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(account.legacyUserId, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertEqualObjects(account.uid, DEFAULT_TEST_UID);
    XCTAssertEqualObjects(account.utid, DEFAULT_TEST_UTID);
}

#pragma mark - Multiple

- (void)testResponseCacheHandler_whenRequestingMultipleItems_shouldReturnAll
{
    MSIDAADV2TokenResponse *response = [MSIDTestTokenResponse v2DefaultTokenResponse];
    MSIDAADV2RequestParameters *params = [MSIDTestRequestParams v2DefaultParams];
    
    MSIDResponseCacheHandler *responseHandler = [[MSIDResponseCacheHandler alloc] initWithTokenResponse:response request:params];
    
    // Verify access token
    MSIDToken *token = [responseHandler accessToken];
    XCTAssertEqualObjects(token.authority, params.authority);
    XCTAssertEqualObjects(token.clientId, params.clientId);
    
    NSString *uniqueUserId = [NSString stringWithFormat:@"%@.%@", DEFAULT_TEST_UID, DEFAULT_TEST_UTID];
    XCTAssertEqualObjects(token.uniqueUserId, uniqueUserId);
    
    NSString *clientInfoString = [@{ @"uid" : DEFAULT_TEST_UID, @"utid" : DEFAULT_TEST_UTID} msidBase64UrlJson];
    
    XCTAssertEqualObjects(token.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(token.additionalInfo, [NSMutableDictionary dictionary]);
    
    XCTAssertNotNil(token.cachedAt);
    XCTAssertEqualObjects(token.accessToken, DEFAULT_TEST_ACCESS_TOKEN);
    XCTAssertEqualObjects(token.genericToken, DEFAULT_TEST_ACCESS_TOKEN);
    
    NSString *idToken = [MSIDTestIdTokenUtil defaultV2IdToken];
    
    XCTAssertEqualObjects(token.idToken, idToken);
    
    NSOrderedSet *scopes = [NSOrderedSet orderedSetWithObjects:DEFAULT_TEST_SCOPE, nil];
    
    XCTAssertEqualObjects(token.scopes, scopes);
    XCTAssertNotNil(token.expiresOn);
    
    // Now verify account
    MSIDAccount *account = [responseHandler account];
    
    XCTAssertEqualObjects(account.authority, params.authority);
    XCTAssertEqualObjects(account.clientId, params.clientId);
    XCTAssertEqualObjects(account.uniqueUserId, uniqueUserId);
    
    XCTAssertEqualObjects(account.clientInfo.rawClientInfo, clientInfoString);
    XCTAssertEqualObjects(account.additionalInfo, [NSMutableDictionary dictionary]);
    XCTAssertEqualObjects(account.legacyUserId, DEFAULT_TEST_ID_TOKEN_USERNAME);
    XCTAssertEqualObjects(account.uid, DEFAULT_TEST_UID);
    XCTAssertEqualObjects(account.utid, DEFAULT_TEST_UTID);
}

@end
