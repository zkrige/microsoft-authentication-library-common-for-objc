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
#import "MSIDToken.h"
#import "NSDictionary+MSIDTestUtil.h"
#import "MSIDToken.h"
#import "MSIDToken.h"
#import "MSIDToken.h"
#import "MSIDToken.h"

@interface MSIDTokenTests : XCTestCase

@end

@implementation MSIDTokenTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - MSIDToken

- (void)testBaseTokenIsEqual_whenAllPropertiesAreEqual_shouldReturnTrue
{
    MSIDToken *lhs = [self createToken];
    MSIDToken *rhs = [self createToken];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenClientInfoIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[self createClientInfo:@{@"key1" : @"value1"}] forKey:@"clientInfo"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[self createClientInfo:@{@"key2" : @"value2"}] forKey:@"clientInfo"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenClientInfoIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[self createClientInfo:@{@"key1" : @"value1"}] forKey:@"clientInfo"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[self createClientInfo:@{@"key1" : @"value1"}] forKey:@"clientInfo"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenAdditionalInfoIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@{@"key1" : @"value1"} forKey:@"additionalInfo"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@{@"key2" : @"value2"} forKey:@"additionalInfo"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenAdditionalInfoIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@{@"key" : @"value"} forKey:@"additionalInfo"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@{@"key" : @"value"} forKey:@"additionalInfo"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenTokenTypeIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@0 forKey:@"tokenType"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@0 forKey:@"tokenType"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenAuthorityIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[NSURL URLWithString:@"https://contoso.com"] forKey:@"authority"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[NSURL URLWithString:@"https://contoso2.com"] forKey:@"authority"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenAuthorityIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[NSURL URLWithString:@"https://contoso.com"] forKey:@"authority"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[NSURL URLWithString:@"https://contoso.com"] forKey:@"authority"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenClientIdIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"clientId"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"clientId"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testBaseTokenIsEqual_whenClientIdIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"clientId"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"clientId"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

#pragma mark - MSIDToken

- (void)testAccessTokenIsEqual_whenTokenIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"token 1" forKey:@"idToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"token 2" forKey:@"idToken"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenTokenIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"token 1" forKey:@"idToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"token 1" forKey:@"idToken"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenIdTokenIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"idToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"idToken"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenIdTokenIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"idToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"idToken"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenExpiresOnIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[NSDate dateWithTimeIntervalSince1970:1500000000] forKey:@"expiresOn"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[NSDate dateWithTimeIntervalSince1970:2000000000] forKey:@"expiresOn"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenExpiresOnIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[NSDate dateWithTimeIntervalSince1970:1500000000] forKey:@"expiresOn"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[NSDate dateWithTimeIntervalSince1970:1500000000] forKey:@"expiresOn"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenCachedAtIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[NSDate dateWithTimeIntervalSince1970:1500000000] forKey:@"cachedAt"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[NSDate dateWithTimeIntervalSince1970:2000000000] forKey:@"cachedAt"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenCachedAtExpiresOnIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:[NSDate dateWithTimeIntervalSince1970:1500000000] forKey:@"cachedAt"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:[NSDate dateWithTimeIntervalSince1970:1500000000] forKey:@"cachedAt"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenScopesIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"1 2" forKey:@"target"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"1 3" forKey:@"target"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenScopesIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"1 2" forKey:@"target"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"1 2" forKey:@"target"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenResourceIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"target"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"target"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testAccessTokenIsEqual_whenResourceIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"target"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"target"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

#pragma mark - MSIDToken

- (void)testRefreshTokenIsEqual_whenFamilyIdIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"familyId"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"familyId"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testRefreshTokenIsEqual_whenFamilyIdIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"familyId"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"familyId"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testRefreshTokenIsEqual_whenTokenIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"refreshToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"refreshToken"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testRefreshTokenIsEqual_whenTokenIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"refreshToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"refreshToken"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testRefreshTokenIsEqual_whenIdTokenIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"idToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"idToken"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testRefreshTokenIsEqual_whenIdTokenIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"idToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"idToken"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

- (void)testRefreshTokenIsEqual_whenUsernameIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"username"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"username"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testRefreshTokenIsEqual_whenUsernameIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"username"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"username"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

#pragma mark - MSIDToken

- (void)testAdfsTokenIsEqual_whenRefreshTokenIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"refreshToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"refreshToken"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testAdfsTokenIsEqual_whenRefreshTokenIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"refreshToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"refreshToken"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

#pragma mark - MSIDToken

- (void)testIDTokenIsEqual_whenRefreshTokenIsNotEqual_shouldReturnFalse
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"rawIdToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 2" forKey:@"rawIdToken"];
    
    XCTAssertNotEqualObjects(lhs, rhs);
}

- (void)testIDTokenIsEqual_whenRefreshTokenIsEqual_shouldReturnTrue
{
    MSIDToken *lhs = [MSIDToken new];
    [lhs setValue:@"value 1" forKey:@"rawIdToken"];
    MSIDToken *rhs = [MSIDToken new];
    [rhs setValue:@"value 1" forKey:@"rawIdToken"];
    
    XCTAssertEqualObjects(lhs, rhs);
}

#pragma mark - Private

- (MSIDToken *)createToken
{
    MSIDToken *token = [MSIDToken new];
    [token setValue:[self createClientInfo:@{@"key" : @"value"}] forKey:@"clientInfo"];
    [token setValue:@{@"spe_info" : @"value2"} forKey:@"additionalInfo"];
    [token setValue:[NSURL URLWithString:@"https://contoso.com/common"] forKey:@"authority"];
    [token setValue:@"some clientId" forKey:@"clientId"];
    [token setValue:@"uid.utid" forKey:@"uniqueUserId"];
    
    return token;
}

- (MSIDClientInfo *)createClientInfo:(NSDictionary *)clientInfoDict
{
    NSString *base64String = [clientInfoDict msidBase64UrlJson];
    return [[MSIDClientInfo alloc] initWithRawClientInfo:base64String error:nil];
}

@end
