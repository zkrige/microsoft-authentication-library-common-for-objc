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

#import "MSIDToken.h"
#import "NSDate+MSIDExtensions.h"
#import "MSIDUserInformation.h"

//in seconds, ensures catching of clock differences between the server and the device
static uint64_t s_expirationBuffer = 300;

@interface MSIDToken()
{
    NSString *_target;
}

@end

@implementation MSIDToken

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MSIDToken *item = [super copyWithZone:zone];
    item->_tokenType = _tokenType;
    item->_accessToken = _accessToken;
    item->_refreshToken = _refreshToken;
    item->_idToken = _idToken;
    item->_target = _target;
    item->_familyId = _familyId;
    item->_genericToken = _genericToken;
    item->_cachedAt = _cachedAt;
    item->_expiresOn = _expiresOn;
    return item;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (!(self = [super initWithCoder:coder]))
    {
        return nil;
    }
    
    NSString *refreshToken = [coder decodeObjectOfClass:[NSString class] forKey:@"refreshToken"];
    NSString *accessToken = [coder decodeObjectOfClass:[NSString class] forKey:@"accessToken"];
    NSString *genericToken = [coder decodeObjectOfClass:[NSString class] forKey:@"genericToken"];
    
    if (![NSString msidIsStringNilOrBlank:refreshToken]
        && ![NSString msidIsStringNilOrBlank:accessToken])
    {
        _tokenType = MSIDTokenTypeLegacyADFSToken;
    }
    else if (![NSString msidIsStringNilOrBlank:refreshToken])
    {
        _tokenType = MSIDTokenTypeRefreshToken;
    }
    else if (![NSString msidIsStringNilOrBlank:accessToken])
    {
        _tokenType = MSIDTokenTypeAccessToken;
    }
    else if (![NSString msidIsStringNilOrBlank:genericToken])
    {
        _tokenType = MSIDTokenTypeOther;
    }
    
    _refreshToken = refreshToken;
    _accessToken = accessToken;
    _genericToken = genericToken;
    
    _familyId = [coder decodeObjectOfClass:[NSString class] forKey:@"familyId"];
    
    _expiresOn = [coder decodeObjectOfClass:[NSDate class] forKey:@"expiresOn"];
    _target = [coder decodeObjectOfClass:[NSString class] forKey:@"resource"];
    _cachedAt = [coder decodeObjectOfClass:[NSDate class] forKey:@"cachedAt"];
    
    // Decode id_token from a backward compatible way
    _idToken = [[coder decodeObjectOfClass:[MSIDUserInformation class] forKey:@"userInformation"] rawIdToken];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.familyId forKey:@"familyId"];
    [coder encodeObject:self.refreshToken forKey:@"refreshToken"];
    
    [coder encodeObject:self.expiresOn forKey:@"expiresOn"];
    [coder encodeObject:self.accessToken forKey:@"accessToken"];
    [coder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [coder encodeObject:self.resource forKey:@"resource"];
    [coder encodeObject:self.cachedAt forKey:@"cachedAt"];
    
    // Backward compatibility with ADAL.
    [coder encodeObject:@"Bearer" forKey:@"accessTokenType"];
    [coder encodeObject:[NSMutableDictionary dictionary] forKey:@"additionalClient"];
    
    // Encode id_token in backward compatible way with ADAL
    MSIDUserInformation *userInformation = [[MSIDUserInformation alloc] initWithRawIdToken:self.idToken];
    [coder encodeObject:userInformation forKey:@"userInformation"];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (![object isKindOfClass:self.class])
    {
        return NO;
    }
    
    return [self isEqualToItem:(MSIDToken *)object];
}

- (NSUInteger)hash
{
    NSUInteger hash = [super hash];
    hash = hash * 31 + self.tokenType;
    hash = hash * 31 + self.accessToken.hash;
    hash = hash * 31 + self.refreshToken.hash;
    hash = hash * 31 + self.idToken.hash;
    hash = hash * 31 + self.resource.hash;
    hash = hash * 31 + self.scopes.hash;
    hash = hash * 31 + self.familyId.hash;
    hash = hash * 31 + self.genericToken.hash;
    hash = hash * 31 + self.expiresOn.hash;
    hash = hash * 31 + self.cachedAt.hash;
    return hash;
}

- (BOOL)isEqualToItem:(MSIDToken *)item
{
    if (!item)
    {
        return NO;
    }
    
    BOOL result = [super isEqualToItem:item];
    result &= self.tokenType == item.tokenType;
    result &= (!self.accessToken && !item.accessToken) || [self.accessToken isEqualToString:item.accessToken];
    result &= (!self.refreshToken && !item.refreshToken) || [self.refreshToken isEqualToString:item.refreshToken];
    result &= (!self.idToken && !item.idToken) || [self.idToken isEqualToString:item.idToken];
    result &= (!self.resource && !item.resource) || [self.resource isEqualToString:item.resource];
    result &= (!self.scopes && !item.scopes) || [self.scopes isEqualToOrderedSet:item.scopes];
    result &= (!self.familyId && !item.familyId) || [self.familyId isEqualToString:item.familyId];
    result &= (!self.genericToken && !item.genericToken) || [self.genericToken isEqualToString:item.genericToken];
    result &= (!self.cachedAt && !item.cachedAt) || [self.cachedAt isEqualToDate:item.cachedAt];
    result &= (!self.expiresOn && !item.expiresOn) || [self.expiresOn isEqualToDate:item.expiresOn];
    
    return result;
}

#pragma mark - JSON

- (instancetype)initWithJSONDictionary:(NSDictionary *)json error:(NSError **)error
{
    if (!(self = [super initWithJSONDictionary:json error:error]))
    {
        return nil;
    }
    
    /* Mandatory fields */
    
    // Credential type
    NSString *credentialType = json[MSID_CREDENTIAL_TYPE_CACHE_KEY];
    _tokenType = [MSIDTokenTypeHelpers tokenTypeFromString:credentialType];
    
    switch (_tokenType) {
        case MSIDTokenTypeRefreshToken:
        {
            [self fillRefreshTokenFromJSON:json];
            break;
        }
        case MSIDTokenTypeIDToken:
        {
            [self fillIDTokenFromJSON:json];
            break;
        }
        case MSIDTokenTypeAccessToken:
        case MSIDTokenTypeLegacyADFSToken:
        {
            [self fillAccessTokenFromJSON:json];
            
            if (_tokenType == MSIDTokenTypeLegacyADFSToken)
            {
                [self fillADFSTokenFromJSON:json];
            }
            
            break;
        }
            
        default:
        {
            _genericToken = json[MSID_TOKEN_CACHE_KEY];
            break;
        }
    }
    
    /* Optional fields */
    
    // ID token
    _idToken = json[MSID_ID_TOKEN_CACHE_KEY];
    
    return self;
}

- (NSDictionary *)jsonDictionary
{
    NSMutableDictionary *dictionary = [[super jsonDictionary] mutableCopy];
    
    /* Mandatory fields */
    
    // Credential type
    NSString *credentialType = [MSIDTokenTypeHelpers tokenTypeAsString:self.tokenType];
    [dictionary setValue:credentialType
                  forKey:MSID_CREDENTIAL_TYPE_CACHE_KEY];
    
    switch (self.tokenType) {
        case MSIDTokenTypeRefreshToken:
        {
            [dictionary addEntriesFromDictionary:[self refreshTokenAsDictionary]];
            break;
        }
        case MSIDTokenTypeIDToken:
        {
            /* Mandatory fields */
            [dictionary setValue:_idToken forKey:MSID_TOKEN_CACHE_KEY];
            
            break;
        }
        case MSIDTokenTypeAccessToken:
        case MSIDTokenTypeLegacyADFSToken:
        {
            [dictionary addEntriesFromDictionary:[self accessTokenAsDictionary]];
            
            if (_tokenType == MSIDTokenTypeLegacyADFSToken)
            {
               [dictionary setValue:_refreshToken forKey:MSID_RESOURCE_RT_CACHE_KEY];
            }
            
            break;
        }
            
        default:
        {
            [dictionary setValue:_genericToken forKey:MSID_TOKEN_CACHE_KEY];
            break;
        }
    }
    
    /* Optional fields */
    
    // ID token
    [dictionary setValue:_idToken forKey:MSID_ID_TOKEN_CACHE_KEY];
    
    return dictionary;
}

#pragma mark - Refresh tokens

- (void)fillRefreshTokenFromJSON:(NSDictionary *)json
{
    /* Mandatory fields */
    
    // Refresh token
    _refreshToken = json[MSID_TOKEN_CACHE_KEY];
    _genericToken = json[MSID_TOKEN_CACHE_KEY];
    
    // Family ID
    _familyId = json[MSID_FAMILY_ID_CACHE_KEY];
}

- (NSDictionary *)refreshTokenAsDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    /* Mandatory fields */
    [dictionary setValue:_refreshToken forKey:MSID_TOKEN_CACHE_KEY];
    [dictionary setValue:_familyId forKey:MSID_FAMILY_ID_CACHE_KEY];
    
    return dictionary;
}

#pragma mark - ID tokens

- (void)fillIDTokenFromJSON:(NSDictionary *)json
{
    /* Mandatory fields */
    
    // ID token
    _idToken = json[MSID_TOKEN_CACHE_KEY];
    _genericToken = json[MSID_TOKEN_CACHE_KEY];
}

#pragma mark - Access token

- (void)fillAccessTokenFromJSON:(NSDictionary *)json
{
    /* Mandatory fields */
    
    // Realm
    if (json[MSID_AUTHORITY_CACHE_KEY])
    {
        _authority = [NSURL URLWithString:json[MSID_AUTHORITY_CACHE_KEY]];
    }
    else if (json[MSID_REALM_CACHE_KEY])
    {
        NSString *authorityString = [NSString stringWithFormat:@"https://%@/%@", json[MSID_ENVIRONMENT_CACHE_KEY], json[MSID_REALM_CACHE_KEY]];
        _authority = [NSURL URLWithString:authorityString];
    }
    
    // Target
    _target = json[MSID_TARGET_CACHE_KEY];
    
    // Cached at
    _cachedAt = [NSDate msidDateFromTimeStamp:json[MSID_CACHED_AT_CACHE_KEY]];
    
    // Expires on
    _expiresOn = [NSDate msidDateFromTimeStamp:json[MSID_EXPIRES_ON_CACHE_KEY]];
    
    // Token
    _accessToken = json[MSID_TOKEN_CACHE_KEY];
    _genericToken = json[MSID_TOKEN_CACHE_KEY];
    
    /* Optional fields */
    
    NSDate *extExpiresOn = [NSDate msidDateFromTimeStamp:json[MSID_EXTENDED_EXPIRES_ON_CACHE_KEY]];
    [_additionalInfo setValue:extExpiresOn
                       forKey:MSID_EXTENDED_EXPIRES_ON_LEGACY_CACHE_KEY];
}

- (NSDictionary *)accessTokenAsDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    // Realm
    [dictionary setValue:_authority.msidTenant
                  forKey:MSID_REALM_CACHE_KEY];
    // Target
    [dictionary setValue:_target forKey:MSID_TARGET_CACHE_KEY];
    
    // Cached at
    [dictionary setValue:_cachedAt.msidDateToTimestamp forKey:MSID_CACHED_AT_CACHE_KEY];
    
    // Expires On
    [dictionary setValue:_expiresOn.msidDateToTimestamp forKey:MSID_EXPIRES_ON_CACHE_KEY];
    
    // Token
    [dictionary setValue:_accessToken forKey:MSID_TOKEN_CACHE_KEY];
    
    /* Optional fields */
    
    // Authority
    [dictionary setValue:_authority.absoluteString forKey:MSID_AUTHORITY_CACHE_KEY];
    
    // Extended expires on
    [dictionary setValue:[self extendedExpireTime].msidDateToTimestamp
                  forKey:MSID_EXTENDED_EXPIRES_ON_CACHE_KEY];
    
    return dictionary;
}

#pragma mark - ADFS tokens

- (void)fillADFSTokenFromJSON:(NSDictionary *)json
{
    _refreshToken = json[MSID_RESOURCE_RT_CACHE_KEY];
}

#pragma mark - Expiry

- (BOOL)isExpired;
{
    NSDate *nowPlusBuffer = [NSDate dateWithTimeIntervalSinceNow:s_expirationBuffer];
    return [self.expiresOn compare:nowPlusBuffer] == NSOrderedAscending;
}

- (NSDate *)extendedExpireTime
{
    return _additionalInfo[MSID_EXTENDED_EXPIRES_ON_LEGACY_CACHE_KEY];
}

#pragma mark - Resource/scopes

- (NSString *)resource
{
    return _target;
}

- (NSOrderedSet<NSString *> *)scopes
{
    return [_target scopeSet];
}

#pragma mark - Init

- (instancetype)initWithAuthority:(NSURL *)authority
                         clientId:(NSString *)clientId
                     uniqueUserId:(NSString *)uniqueUserId
                         username:(NSString *)username
                       clientInfo:(MSIDClientInfo *)clientInfo
                   additionalInfo:(NSDictionary *)additionalInfo
                        tokenType:(MSIDTokenType)tokenType
{
    self = [super initWithAuthority:authority
                           clientId:clientId
                       uniqueUserId:uniqueUserId
                           username:username
                         clientInfo:clientInfo
                     additionalInfo:additionalInfo];
    
    if (self)
    {
        _tokenType = tokenType;
    }
    
    return self;
}

- (void)updateRefreshTokenWithToken:(NSString *)refreshToken
                            idToken:(NSString *)idToken
                           familyId:(NSString *)familyId
{
    _refreshToken = refreshToken;
    _genericToken = refreshToken;
    _idToken = idToken;
    _familyId = familyId;
}

- (void)updateAccessTokenWithToken:(NSString *)accessToken
                           idToken:(NSString *)idToken
                         expiresOn:(NSDate *)expiresOn
                          cachedAt:(NSDate *)cachedAt
                      extExpiresOn:(NSDate *)extExpiresOnDate
                            target:(NSString *)target
{
    _accessToken = accessToken;
    _genericToken = accessToken;
    _idToken = idToken;
    _expiresOn = expiresOn;
    _cachedAt = cachedAt;
    _target = target;
    
    if (extExpiresOnDate)
    {
        NSMutableDictionary *additionalInfo = [_additionalInfo mutableCopy];
        [additionalInfo setObject:extExpiresOnDate
                           forKey:MSID_EXTENDED_EXPIRES_ON_LEGACY_CACHE_KEY];
        _additionalInfo = additionalInfo;
    }
}

- (void)updateIDTokenWithToken:(NSString *)idToken
{
    _idToken = idToken;
    _genericToken = idToken;
}

- (void)updateADFSTokenWithRefreshToken:(NSString *)refreshToken
{
    _refreshToken = refreshToken;
}

@end
