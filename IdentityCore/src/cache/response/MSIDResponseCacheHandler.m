//------------------------------------------------------------------------------
//
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
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "MSIDResponseCacheHandler.h"
#import "MSIDAADTokenResponse.h"
#import "MSIDToken.h"
#import "MSIDAADV1TokenResponse.h"
#import "MSIDAADV1RequestParameters.h"

@interface MSIDResponseCacheHandler()
{
    MSIDTokenResponse *_tokenResponse;
    MSIDRequestParameters *_params;
    
    NSURL *_authority;
    NSString *_clientId;
    NSString *_username;
    NSString *_uniqueUserId;
    MSIDClientInfo *_clientInfo;
    NSDictionary *_additionalInfo;
}

@end

@implementation MSIDResponseCacheHandler

#pragma mark - Init

- (instancetype)initWithTokenResponse:(MSIDTokenResponse *)response
                              request:(MSIDRequestParameters *)requestParams
{
    self = [super init];
    
    if (self)
    {
        _tokenResponse = response;
        _params = requestParams;
        
        [self fillDefaultProperties];
    }
    
    return self;
}

- (void)fillDefaultProperties
{
    // TODO: fix this
    _authority = _params.authority;
    _clientId = _params.clientId;
    
    NSString *preferredUsername = _tokenResponse.idTokenObj.preferredUsername;
    _username = preferredUsername ? preferredUsername : _tokenResponse.idTokenObj.userId;
    
    _uniqueUserId = _tokenResponse.idTokenObj.userId;
    
    _additionalInfo = [NSMutableDictionary dictionary];
    
    // Fill in client info and spe info
    if ([_tokenResponse isKindOfClass:[MSIDAADTokenResponse class]])
    {
        MSIDAADTokenResponse *aadTokenResponse = (MSIDAADTokenResponse *)_tokenResponse;
        _clientInfo = aadTokenResponse.clientInfo;
        _uniqueUserId = _clientInfo.userIdentifier;
        [_additionalInfo setValue:aadTokenResponse.speInfo
                           forKey:MSID_SPE_INFO_CACHE_KEY];
    }
}

#pragma mark - Accounts

- (MSIDAccount *)account
{
    MSIDAccount *account = [[MSIDAccount alloc] initWithAuthority:_authority
                                                         clientId:_clientId
                                                     uniqueUserId:_uniqueUserId
                                                         username:_username
                                                       clientInfo:_clientInfo
                                                   additionalInfo:_additionalInfo];
    
    NSString *uid = nil;
    NSString *utid = nil;
    
    if ([_tokenResponse isKindOfClass:[MSIDAADTokenResponse class]])
    {
        MSIDAADTokenResponse *aadTokenResponse = (MSIDAADTokenResponse *)_tokenResponse;
        uid = aadTokenResponse.clientInfo.uid;
        utid = aadTokenResponse.clientInfo.utid;
    }
    else
    {
        uid = _tokenResponse.idTokenObj.subject;
        utid = @"";
    }
    
    NSString *userId = _tokenResponse.idTokenObj.userId;
    
    // TODO: make all other fields writable in token too?
    account.legacyUserId = userId;
    account.utid = utid;
    account.uid = uid;
    
    return account;
}

#pragma mark - Helpers

- (MSIDToken *)baseTokenWithType:(MSIDTokenType)tokenType
{
    return [[MSIDToken alloc] initWithAuthority:_authority
                                       clientId:_clientId
                                   uniqueUserId:_uniqueUserId
                                       username:_username
                                     clientInfo:_clientInfo
                                 additionalInfo:_additionalInfo
                                      tokenType:tokenType];
}

#pragma mark - Refresh token

- (MSIDToken *)refreshToken
{
    MSIDToken *token = [self baseTokenWithType:MSIDTokenTypeRefreshToken];
    
    NSString *familyId = nil;
    
    if ([_tokenResponse isKindOfClass:[MSIDAADTokenResponse class]])
    {
        MSIDAADTokenResponse *aadTokenResponse = (MSIDAADTokenResponse *)_tokenResponse;
        familyId = aadTokenResponse.familyId;
    }
    
    [token updateRefreshTokenWithToken:_tokenResponse.refreshToken
                               idToken:_tokenResponse.idToken
                              familyId:familyId];
    
    
    return token;
}

#pragma mark - Access token

- (MSIDToken *)accessToken
{
    MSIDToken *token = [self baseTokenWithType:MSIDTokenTypeAccessToken];
    
    NSString *resource = nil;
    
    if ([_tokenResponse isKindOfClass:[MSIDAADV1TokenResponse class]])
    {
        NSString *fallbackResource = nil;
        
        if ([_params isKindOfClass:[MSIDAADV1RequestParameters class]])
        {
            MSIDAADV1RequestParameters *v1RequestParams = (MSIDAADV1RequestParameters *)_params;
            fallbackResource = v1RequestParams.resource;
        }
        
        MSIDAADV1TokenResponse *aadV1TokenResponse = (MSIDAADV1TokenResponse *)_tokenResponse;
        // Because resource is not always returned in the token response, we rely on the input resource as a fallback
        resource = aadV1TokenResponse.resource ? aadV1TokenResponse.resource : fallbackResource;
    }
    
    NSString *target = resource ? resource : _tokenResponse.scope;
    
    [token updateAccessTokenWithToken:_tokenResponse.accessToken
                              idToken:_tokenResponse.idToken
                            expiresOn:[self expiryDate]
                             cachedAt:[self cachedAtDate]
                         extExpiresOn:[self extendedExpiryDate]
                               target:target];
    
    return token;
}

- (NSDate *)expiryDate
{
    NSDate *expiresOn = _tokenResponse.expiryDate;
    
    if (!expiresOn)
    {
        MSID_LOG_WARN(nil, @"The server did not return the expiration time for the access token.");
        expiresOn = [NSDate dateWithTimeIntervalSinceNow:3600.0]; //Assume 1hr expiration
    }
    
    return [NSDate dateWithTimeIntervalSince1970:(uint64_t)[expiresOn timeIntervalSince1970]];
}

- (NSDate *)cachedAtDate
{
    return [NSDate dateWithTimeIntervalSince1970:(uint64_t)[[NSDate date] timeIntervalSince1970]];
}

- (NSDate *)extendedExpiryDate
{
    if ([_tokenResponse isKindOfClass:[MSIDAADTokenResponse class]])
    {
        MSIDAADTokenResponse *aadTokenResponse = (MSIDAADTokenResponse *)_tokenResponse;
        return aadTokenResponse.extendedExpiresOnDate;
    }
    
    return nil;
}

#pragma mark - ID token

- (MSIDToken *)idToken
{
    MSIDToken *token = [self baseTokenWithType:MSIDTokenTypeIDToken];
    [token updateIDTokenWithToken:_tokenResponse.idToken];
    return token;
}

#pragma mark - ADFS token

- (MSIDToken *)adfsToken
{
    MSIDToken *token = [self accessToken];
    [token updateADFSTokenWithRefreshToken:_tokenResponse.refreshToken];
    return token;
}

@end
