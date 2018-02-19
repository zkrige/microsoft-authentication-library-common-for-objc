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

#import "MSIDADFSUserToken.h"
#import "NSDate+MSIDExtensions.h"
#import "MSIDAADV1RequestParameters.h"
#import "MSIDAADV1TokenResponse.h"

@implementation MSIDADFSUserToken

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    MSIDADFSUserToken *item = [super copyWithZone:zone];
    item->_expiresOn = [_expiresOn copyWithZone:zone];
    item->_cachedAt = [_cachedAt copyWithZone:zone];
    item->_accessToken = [_accessToken copyWithZone:zone];
    
    return item;
}

#pragma mark - NSSecureCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (!(self = [super initWithCoder:coder]))
    {
        return nil;
    }
    
    _expiresOn = [coder decodeObjectOfClass:[NSDate class] forKey:@"expiresOn"];
    _accessToken = [coder decodeObjectOfClass:[NSString class] forKey:@"accessToken"];
    _cachedAt = [coder decodeObjectOfClass:[NSDate class] forKey:@"cachedAt"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.expiresOn forKey:@"expiresOn"];
    [coder encodeObject:self.accessToken forKey:@"accessToken"];
    [coder encodeObject:self.cachedAt forKey:@"cachedAt"];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object)
    {
        return YES;
    }
    
    if (![object isKindOfClass:MSIDADFSUserToken.class])
    {
        return NO;
    }
    
    return [self isEqualToToken:(MSIDADFSUserToken *)object];
}

- (NSUInteger)hash
{
    NSUInteger hash = [super hash];
    hash = hash * 31 + self.expiresOn.hash;
    hash = hash * 31 + self.accessToken.hash;
    hash = hash * 31 + self.resource.hash;
    hash = hash * 31 + self.cachedAt.hash;
    return hash;
}

- (BOOL)isEqualToToken:(MSIDADFSUserToken *)token
{
    if (!token)
    {
        return NO;
    }
    
    BOOL result = [super isEqualToToken:token];
    result &= (!self.expiresOn && !token.expiresOn) || [self.expiresOn isEqualToDate:token.expiresOn];
    result &= (!self.accessToken && !token.accessToken) || [self.accessToken isEqualToString:token.accessToken];
    result &= (!self.resource && !token.resource) || [self.resource isEqualToString:token.resource];
    result &= (!self.cachedAt && !token.cachedAt) || [self.cachedAt isEqualToDate:token.cachedAt];
    
    return result;
}

#pragma mark - JSON

/*! Legacy ADFS tokens are not supported in JSON format.
 Legacy ADFS tokens are only meant for compatibility purposes for ADAL, because ADAL cache saved both access and refresh token together for those tokens and new cache formats separates them */

- (instancetype)initWithJSONDictionary:(NSDictionary *)json error:(NSError **)error
{
    return nil;
}

- (NSDictionary *)jsonDictionary
{
    return nil;
}

#pragma mark - Init

- (instancetype)initWithTokenResponse:(MSIDTokenResponse *)response
                              request:(MSIDRequestParameters *)requestParams
{
    if (!(self = [super initWithTokenResponse:response request:requestParams]))
    {
        return nil;
    }
    
    if ([response isKindOfClass:[MSIDAADV1TokenResponse class]])
    {
        NSString *fallbackResource = nil;
        
        if ([requestParams isKindOfClass:[MSIDAADV1RequestParameters class]])
        {
            MSIDAADV1RequestParameters *v1RequestParams = (MSIDAADV1RequestParameters *)requestParams;
            fallbackResource = v1RequestParams.resource;
        }
        
        MSIDAADV1TokenResponse *aadV1TokenResponse = (MSIDAADV1TokenResponse *)response;
        // Because resource is not always returned in the token response, we rely on the input resource as a fallback
        _resource = aadV1TokenResponse.resource ? aadV1TokenResponse.resource : fallbackResource;
    }
    
    return self;
}

#pragma mark - Token type

- (MSIDTokenType)tokenType
{
    return MSIDTokenTypeLegacyADFSToken;
}

@end
