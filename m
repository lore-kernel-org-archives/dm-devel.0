Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3785C451996
	for <dm-devel@lists.linux.dev>; Fri,  2 Oct 2026 09:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932355; cv=none; b=OPuiZ2d91vNg4wnvr0/VTCV3ND/7IcGlz4v/bSchMCmAWe8DiJKcZtvUF+17t3ktiD96n1Utx2FK/9i2zoelKfUxHQ2oLxJo0eB7eftHnlW0juiozZRjJNWwN1/sgw7A/qlaFzpunzQw8M16SWaM7BppDsVTEGotiNPFIkrEQAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932355; c=relaxed/simple;
	bh=NAOboTaYrcSwirCjL0XCo5Ao701k/7Iehb6qsDJ4QuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g5NF44+hUot+ZbMPM3HuAd+TG3mBWjLvcW9xZBmOt6O0UXuH6w6+R1IUPHgFdayyzCqlSXwJ2U42q1K9+9paqMY2hA20deEFl6FbyFuxjuoAg6UZCfHvCTc09c++pEE3F0m7NRFnk1mNZNRLzxxskoRMrpCtb6uF30kNBL8pZ7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=UrQs+BCT; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="UrQs+BCT"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a006bb267eso29978405e9.0
        for <dm-devel@lists.linux.dev>; Fri, 02 Oct 2026 02:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1790932350; x=1791537150; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8QwkJ0mCOjc23gtVTVhvkKJTWEHzHSZ3y0YNs5ztVZE=;
        b=UrQs+BCTQhxfKd/VzBVCrSx+XTsfEDVpNGXcaR1HoC0GttO54papECa9q72gm0ERGo
         T1i1TtoL9d41V594Mh/yGbXdoavEoe3rmtGjWy1PvirH+Z7Iic2+eFuTnhBYUQE0GIU0
         zAlW/0ZBm88jTwp/l0XBVfqqW14yujgTxQToGg+DF6zAeP/GFSi1jjG9Q/hAafDhyXkw
         sjLGGTt82rd3MwbP1U2j8l021AgbQANXstGKEwxzMcwvRHZUUCPmCsEcRLOBG6dxuf6P
         2oHzxgJ7LBf/xN1z4APuS43RvPUUHDFnO2L5WTRVTw0BZ8ZEaPbWGedLvXk0Il1TSzyI
         OV7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932350; x=1791537150;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8QwkJ0mCOjc23gtVTVhvkKJTWEHzHSZ3y0YNs5ztVZE=;
        b=vZYbGByryjO+aQi92j6RC+CEuGs2GoLbWeclNK11IkKAtzXT+FKD/ZyjK3p1AqakS3
         M4LmhxipAYQbjlW4yAZIzz4nut29/KpKeHzSEc/PKHCk5v9naEmovU9gqVFBt48CCi0P
         e9h3268y4uEuEmxvTR1xT/8TzbnP0shRVQXDABcaGMRahj/Fa0+A5Ll+dsnoq9XdVUhX
         xz5WRt/KCgv24BjMpX6d4fEAp6GuH0jXt9Twjz5u6c2BkoqelW5E181jcdmm9F9KVWgJ
         9U52Oz7WLRM+VHFc3+OItE2mhq0Rxeu9S6/dFBbwVfTrHWBodNcv4MaNCBNOme7a0LZC
         xomw==
X-Forwarded-Encrypted: i=1; AKwUvBwCeY1xDcp/NROYam+H/TVBaFp0TyRyd3zgG6D8tUgkDTO9QJveAnDO+mFhThn1nzUtX7i6SYDHJg==@lists.linux.dev
X-Gm-Message-State: AFuF++kUzHoU+phKYZWEyWSh4NrYjV5idJ6XFxV0JZOmAbilWKBvzaP4
	vQbQJHsSVr/tb1L4Vn5Be+c9WSv4l8+dOyrrmARUHwyi0jmveMLFxHOFHA/0BuX+gRs=
X-Gm-Gg: AYBFou2Tv+BCE9CYOYw8NAHm0gxtztvmVslCUeTjTP8uu3lDuhnHXD22/BFRQhw1LfQ
	BB78N5RKFQs1OaFExi911rpv34quvUhUUVneUQRLTJPAAo1JLRaDvXYtPzMQHOUj/yPzCVo+zWU
	V5JKJ0JumMwrSe6YERaoypdi4CcfvzRtaAysWs64ht9EQqnr7vRl7tAgoFEqnZ/5XDfIVhtfjlc
	DqmPv+EHekDJ1nL9KhY0AKH7TFfEraA8ukbD9YVlKqUCm518523SttJ4rnYzYK0YrzAQDGDC/7b
	Ba6JLpLLe2JC2c+PTVY4purrbc4cQ0jdHz1mdpx1i46DdYh6YnrYyr5GB0Qt2hPTB1/tUpt7uXa
	IfPxQvgvPzq27ljx4dS0WWtaSZ5nrVbSId8rNvSTFp6LwAw3Rk55+HH+NPEa/H8tyJsOqwXF+o5
	ZOUtfXjP/GO4zh5QcvH+knAU/o3DPYrYIgYP8rYNDE4UwHr9Dt1EeL3JQxlsjZVC1KodH5twash
	bIpEuvED9x5ick8RZ7+VlGigrFkAl7POGZ6yHYTxbEtWR8NPgo=
X-Received: by 2002:a05:600c:468b:b0:49d:1df8:156d with SMTP id 5b1f17b1804b1-4a0276bfcc8mr37457875e9.18.1790932349959;
        Fri, 02 Oct 2026 02:12:29 -0700 (PDT)
Received: from ?IPV6:2a04:9546:1c54:8601:c375:8df8:9c4c:d013? ([2a04:9546:1c54:8601:c375:8df8:9c4c:d013])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027698f13sm65230985e9.1.2026.10.02.02.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 02:12:28 -0700 (PDT)
Message-ID: <b0f8f47a-beb0-426e-bdee-5d0d80ade8ad@sigma-star.at>
Date: Fri, 2 Oct 2026 11:12:27 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/1] dm-integrity: support keys in the kernel keyring
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>,
 Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 upstream+dm@sigma-star.at
References: <20260928062734.3805458-1-lorenz@sigma-star.at>
 <20260928062734.3805458-2-lorenz@sigma-star.at>
 <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com>
Content-Language: en-US
From: Lorenz Kofler <lorenz@sigma-star.at>
Autocrypt: addr=lorenz@sigma-star.at; keydata=
 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
 5OAWJ7yLRAI7WigUCHhbizN5NSso5ztVJWx89g==
In-Reply-To: <6e7bd72b-6f1a-211d-16a8-a35a530af408@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mikulas,

thank you for the review!

Some notes below.

On 9/30/26 5:00 PM, Mikulas Patocka wrote:
> Hi
> 
> Generally, the approach in this patch is OK.
> 
> Here I have some comments for the patch:
> 
> Mikulas
> 
> 
> 
> The patch should increase target version - from "{1, 15, 0}" to "{1, 16,
> 0}".
> 
> 
> On Mon, 28 Sep 2026, Lorenz Kofler wrote:
> 
>> The keys of internal_hash, journal_crypt and journal_mac can only be
>> given as hex strings in the table. Keys that never leave the kernel,
>> such as trusted keys, cannot be used.
>>
>> In addition to hex strings, accept keys from the kernel keyring in the
>> same format as dm-crypt: ":<key_size>:<key_type>:<key_description>".
>> The lookup is the same as in dm-crypt.
>>
>> Like DM_CRYPT, DM_INTEGRITY must not be built in when the encrypted or
>> trusted key types are modules.
>>
>> Signed-off-by: Lorenz Kofler <lorenz@sigma-star.at>
>> ---
>>   .../device-mapper/dm-integrity.rst            |  25 +++
>>   drivers/md/Kconfig                            |   2 +
>>   drivers/md/dm-integrity.c                     | 164 ++++++++++++++++++
>>   3 files changed, 191 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/device-mapper/dm-integrity.rst b/Documentation/admin-guide/device-mapper/dm-integrity.rst
>> index 9c21301423c9..2b7f82912962 100644
>> --- a/Documentation/admin-guide/device-mapper/dm-integrity.rst
>> +++ b/Documentation/admin-guide/device-mapper/dm-integrity.rst
>> @@ -146,6 +146,8 @@ internal_hash:algorithm(:key)	(the key is optional)
>>   	from an upper layer target, such as dm-crypt. The upper layer
>>   	target should check the validity of the integrity tags.
>>   
>> +	The format of the key is described below the list of arguments.
>> +
>>   recalculate
>>   	Recalculate the integrity tags automatically. It is only valid
>>   	when using internal hash.
>> @@ -162,6 +164,8 @@ journal_crypt:algorithm(:key)	(the key is optional)
>>   	the size of files that were written. To protect against this
>>   	situation, you can encrypt the journal.
>>   
>> +	The format of the key is described below the list of arguments.
>> +
>>   journal_mac:algorithm(:key)	(the key is optional)
>>   	Protect sector numbers in the journal from accidental or malicious
>>   	modification. To protect against accidental modification, use a
>> @@ -173,6 +177,8 @@ journal_mac:algorithm(:key)	(the key is optional)
>>   	the journal. Thus, modified sector number would be detected at
>>   	this stage.
>>   
>> +	The format of the key is described below the list of arguments.
>> +
>>   block_size:number (default 512)
>>   	The size of a data block in bytes. The larger the block size the
>>   	less overhead there is for per-block integrity metadata.
>> @@ -225,6 +231,25 @@ legacy_recalculate
>>   	set recalc_sector to zero, and the kernel would not detect the
>>   	modification.
>>   
>> +The key of internal_hash, journal_crypt and journal_mac is encoded either as
>> +a hexadecimal number or it can be passed as <key_string> prefixed with single
>> +colon character (':') for keys residing in kernel keyring service.
> 
> The documentation omits the fact that you need double colon "::" - one
> colon to end the argument name and one colon as the key prefix.
> 
>> +
>> +<key_string>
>> +	The kernel keyring key is identified by string in following format:
>> +	<key_size>:<key_type>:<key_description>.
>> +
>> +<key_size>
>> +	The key size in bytes. The kernel key payload size must match
>> +	the value passed in <key_size>.
>> +
>> +<key_type>
>> +	Either 'logon', 'user', 'encrypted' or 'trusted' kernel key type.
>> +
>> +<key_description>
>> +	The kernel keyring key description integrity target should look for
>> +	when loading key of <key_type>.
>> +
>>   The journal mode (D/J), buffer_sectors, journal_watermark, commit_time and
>>   allow_discards can be changed when reloading the target (load an inactive
>>   table and swap the tables with suspend and resume). The other arguments
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index df27c7d066d2..e93bf0c3119d 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -653,6 +653,8 @@ config DM_LOG_WRITES
>>   config DM_INTEGRITY
>>   	tristate "Integrity target support"
>>   	depends on BLK_DEV_DM
>> +	depends on (ENCRYPTED_KEYS || ENCRYPTED_KEYS=n)
>> +	depends on (TRUSTED_KEYS || TRUSTED_KEYS=n)
>>   	select BLK_DEV_INTEGRITY
>>   	select DM_BUFIO
>>   	select CRYPTO
>> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
>> index 92970e12267a..6995c870cbf5 100644
>> --- a/drivers/md/dm-integrity.c
>> +++ b/drivers/md/dm-integrity.c
>> @@ -25,6 +25,11 @@
>>   #include <crypto/utils.h>
>>   #include <linux/async_tx.h>
>>   #include <linux/dm-bufio.h>
>> +#include <linux/ctype.h>
>> +#include <linux/key.h>
>> +#include <keys/user-type.h>
>> +#include <keys/encrypted-type.h>
>> +#include <keys/trusted-type.h>
>>   
>>   #include "dm-audit.h"
>>   
>> @@ -4415,6 +4420,152 @@ static void free_alg(struct alg_spec *a)
>>   	memset(a, 0, sizeof(*a));
>>   }
>>   
>> +#ifdef CONFIG_KEYS
>> +
>> +static bool contains_whitespace(const char *str)
>> +{
>> +	while (*str)
>> +		if (isspace(*str++))
>> +			return true;
>> +	return false;
>> +}
>> +
>> +static int set_key_user(struct alg_spec *a, struct key *key)
>> +{
>> +	const struct user_key_payload *ukp;
>> +
>> +	ukp = user_key_payload_locked(key);
>> +	if (!ukp)
>> +		return -EKEYREVOKED;
>> +
>> +	if (a->key_size != ukp->datalen)
>> +		return -EINVAL;
>> +
>> +	memcpy(a->key, ukp->data, a->key_size);
>> +
>> +	return 0;
>> +}
>> +
>> +static int set_key_encrypted(struct alg_spec *a, struct key *key)
>> +{
>> +	const struct encrypted_key_payload *ekp;
>> +
>> +	ekp = key->payload.data[0];
>> +	if (!ekp)
>> +		return -EKEYREVOKED;
>> +
>> +	if (a->key_size != ekp->decrypted_datalen)
>> +		return -EINVAL;
>> +
>> +	memcpy(a->key, ekp->decrypted_data, a->key_size);
>> +
>> +	return 0;
>> +}
>> +
>> +static int set_key_trusted(struct alg_spec *a, struct key *key)
>> +{
>> +	const struct trusted_key_payload *tkp;
>> +
>> +	tkp = key->payload.data[0];
>> +	if (!tkp)
>> +		return -EKEYREVOKED;
>> +
>> +	if (a->key_size != tkp->key_len)
>> +		return -EINVAL;
>> +
>> +	memcpy(a->key, tkp->key, a->key_size);
>> +
>> +	return 0;
>> +}
> 
> These four functions are copied from dm-crypt.c and dm-inlinecrypt.c.
> Copying code is generally malpattern, they should be unified and moved to
> an include file (that would be included in all three targets) or to the
> key management code (that would be called from all three targets).
> 

Yes that is the issue I described in the cover letters. But I don't
actually know which way is the preferred one. Afaik there are now
three options:

1. static inline helpers in a drivers/md header, so dm-crypt and
    dm-integrity each compile their own copy
2. a small library module, similar to dm-bufio, so there is one copy
    that follows the value (y/m) of dm-crypt and dm-integrity
3. integration into key management code

Please tell me which option you prefer.

>> +/*
>> + * Load the key from the kernel keyring. a->key_string has the format
>> + * ":<key_size>:<key_type>:<key_description>".
>> + */
>> +static int get_alg_key_from_keyring(struct alg_spec *a)
>> +{
>> +	int (*set_key)(struct alg_spec *a, struct key *key);
>> +	const char *key_type_desc, *key_desc;
>> +	struct key_type *type;
>> +	unsigned int key_size;
>> +	struct key *key;
>> +	char dummy;
>> +	int r;
>> +
>> +	/*
>> +	 * Reject key_string with whitespace. dm core currently lacks code for
>> +	 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
>> +	 */
>> +	if (contains_whitespace(a->key_string))
>> +		return -EINVAL;
>> +
>> +	if (sscanf(a->key_string, ":%u%c", &key_size, &dummy) != 2 || dummy != ':')
>> +		return -EINVAL;
>> +	if (!key_size || key_size > KMALLOC_MAX_SIZE)
>> +		return -EINVAL;
> 
> KMALLOC_MAX_SIZE allocations are unreliable, they may fail randomly
> anytime.
> 
> You should use "PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER" as the limit (I
> assume that this is enough for the key) - this is the reliability
> threshold for kmalloc.
> 
> If you really need larger allocation, you should use vmalloc or kvmalloc.
> 
>> +	/* skip ":<key_size>:", the sscanf() above guarantees the second ':' */
>> +	key_type_desc = strchr(a->key_string + 1, ':') + 1;
>> +
>> +	/* look for next ':' separating key_type from key_description */
>> +	key_desc = strchr(key_type_desc, ':');
>> +	if (!key_desc || key_desc == key_type_desc || !strlen(key_desc + 1))
>> +		return -EINVAL;
>> +
>> +	if (!strncmp(key_type_desc, "logon:", key_desc - key_type_desc + 1)) {
>> +		type = &key_type_logon;
>> +		set_key = set_key_user;
>> +	} else if (!strncmp(key_type_desc, "user:", key_desc - key_type_desc + 1)) {
>> +		type = &key_type_user;
>> +		set_key = set_key_user;
>> +	} else if (IS_ENABLED(CONFIG_ENCRYPTED_KEYS) &&
>> +		   !strncmp(key_type_desc, "encrypted:", key_desc - key_type_desc + 1)) {
>> +		type = &key_type_encrypted;
>> +		set_key = set_key_encrypted;
>> +	} else if (IS_ENABLED(CONFIG_TRUSTED_KEYS) &&
>> +		   !strncmp(key_type_desc, "trusted:", key_desc - key_type_desc + 1)) {
>> +		type = &key_type_trusted;
>> +		set_key = set_key_trusted;
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	a->key = kmalloc(key_size, GFP_KERNEL);
>> +	if (!a->key)
>> +		return -ENOMEM;
>> +	a->key_size = key_size;
>> +
>> +	key = request_key(type, key_desc + 1, NULL);
>> +	if (IS_ERR(key)) {
>> +		r = PTR_ERR(key);
>> +		goto free_key;
>> +	}
>> +
>> +	down_read(&key->sem);
>> +	r = set_key(a, key);
>> +	up_read(&key->sem);
>> +	key_put(key);
>> +	if (r < 0)
>> +		goto free_key;
>> +
>> +	return 0;
>> +
>> +free_key:
>> +	kfree_sensitive(a->key);
>> +	a->key = NULL;
>> +	a->key_size = 0;
>> +	return r;
>> +}
>> +
>> +#else
>> +
>> +static int get_alg_key_from_keyring(struct alg_spec *a)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +#endif /* CONFIG_KEYS */
>> +
>>   static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, char *error_inval)
>>   {
>>   	char *k;
>> @@ -4429,6 +4580,19 @@ static int get_alg_and_key(const char *arg, struct alg_spec *a, char **error, ch
>>   	if (k) {
>>   		*k = 0;
>>   		a->key_string = k + 1;
>> +
>> +		if (a->key_string[0] == ':') {
>> +			int r = get_alg_key_from_keyring(a);
>> +
>> +			if (r == -ENOMEM)
>> +				goto nomem;
>> +			if (r == -EINVAL)
>> +				goto inval;
>> +			if (r)
>> +				*error = "Cannot get key from the kernel keyring";
>> +			return r;
>> +		}
>> +
>>   		if (strlen(a->key_string) & 1)
>>   			goto inval;
>>   
>> -- 
>> 2.55.0
>>
> 

-- 
sigma star gmbh | Eduard-Bodem-Gasse 6, 6020 Innsbruck, Austria
UID/VAT Nr: ATU 66964118 | FN: 374287y

