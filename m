Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2272E399039
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 12:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292442; cv=none; b=mXcu3tsEhw9vFx6hmkqyOCYHMSeKaICfPVmwYn3g1Jrlmmxgk6UjV4z1xJ4RHQvj9km7EWpVgKNF5RZIPZP4jDC3AgPdGW/dI/86gKd/Z80oZYytGJZJQdmmihS4cnvTkyWijiNi3XcJGFkB6bwtpVF2euEj6Bj+JE7S+1/xO50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292442; c=relaxed/simple;
	bh=7lbec7Uyzzi2wl9dUyyhNIE0MOLvSUF8BVdfuaSIDT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HiZdNWhQUaZRwaMCdWQsiKwsdOS0mofbLg1DRL/Yu+hoK0875yfOVxBtrAL6BaTH01zZqezAX7iA+MmstTkKkOvpxQ4O8LB+gQOHtmzS0sUuoI5Jtapkf9HNHtj68BMFRjV76fyeF7MoWX0z+r+hczD2ogaT5ie3u2Up8qmcIbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HcUmXotA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YThsONtA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HcUmXotA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YThsONtA"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63R8THq73682754
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 12:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1BRzY5u757mlXHrnjUDNbAuhb+CX9Uaa46RquOR2J2A=; b=HcUmXotAIooSggrn
	LuJefR70fUyKBLcrorZrmKLsTs9aVjprwUbLDI0OE+7+NCFRynJgTUBkxLDH56l8
	ZN0BO86LBQIBTgzImD1W34O2qNVBzjgXhMPVgwBpSWk7H6tCeAAIWBzwMf5xwfTo
	4PIbDLp0+x8rzxDyeHKxi5g3pJOFV2/fOFstDmy0eJfGZ0BJpiljwLuxkZDC4E2K
	exFJjIMDyWSigXuf/qM8vRanThniO6MGX76gvMbS4xbFbRp+eLW+6l9CE80zJvFS
	WVs7NqgzprNCkF1zpgQVNlYWUm1w4UyZzZWpLzH0HyrAjpNuFuWtzDvhXDqs9fdw
	5SkbPA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drnmr61nb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 12:20:38 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2da19227bc1so24314773eec.1
        for <dm-devel@lists.linux.dev>; Mon, 27 Apr 2026 05:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777292438; x=1777897238; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1BRzY5u757mlXHrnjUDNbAuhb+CX9Uaa46RquOR2J2A=;
        b=YThsONtAiggFTyd2KUJ88FnTs2V2iWuYnizhv61dIqzaRgaPGbRMUj5zskamkLRrNA
         70BH0/2zu9gVscW1MQY9IWC55TyWoU49h+d9FRT+zmbC3XHQ+qtZ9/ZVXTTbonOtMJYR
         X9OIBjSZgfTGlD3/uhg26MoF536VMDm8fQlrn+L4P1J72Ed+lI2NoGx3fMBD31IkuwPW
         AfQV5nYwkqwvMvmTrEagtk0bw0Xpn4dPQ6ZS4rltNnoC+DUIcm9mlgjFOTzD4AS6w6JG
         2m0V8/TPTPyHl9s5FQnbNpJO2DKrfoDlkSjbPA1ovjagksfEGYq8UYWqFOrjjQ5B2US5
         +2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777292438; x=1777897238;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1BRzY5u757mlXHrnjUDNbAuhb+CX9Uaa46RquOR2J2A=;
        b=BDahyN8M7AoA6XkOsG3Wfpc+iex1jf1A/GbUrOrfieLTtRf6zvSZgsVxuk/sXfX33/
         X6Ki9L149zE/P1YdhkYVKX1uSsi2Ayx5gM9o+ZRGkR2aM+RANvZw4TU/D4tiUpCePAQl
         nJ0xo5ee69FzVDKz97UWM5A4LGSdBBqKuEKLALFB46Wm1o5eyz1wBxWdjZ+lsrcxMzkx
         yv47HTXCDAoOk6zfurTOoV65B9P4mOkg9lMnH73dDvG+xB4kPlgT5G/73ulhVzdYYE5i
         3RJ7uNlnoAtlG22IUUfALlp7Bmul2ehACEj+9FCqeEX5GSxSRlWm8YfGXcW3IukbTLhe
         D4GQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Jk3qzgMXh5RNr6TOZCpKhGGZ5R1YQswKeq/XqN1fGeDAL8JaAvJDSefCqTclez44COfvPqlKAUA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyBbVuZ4YhTp8NC9I6vEMyZ8xrON3QJ8c+Jrik1XZZMvD+XtKRd
	yM2KV8d/WZ2Q6PPgghgK1h2rssVXYLpPZ0GxzAp91VqIEkZbAprI5/AP94JAhv3hJAuhgYRGd6s
	neQE38kxX+dajmc6fnQOd37ZXv59cFjCiOn+bxaw1veTjczzgW3vo13C3pOl8Pg==
X-Gm-Gg: AeBDies4Q1cnBF2i0fbz7Is5S1m4ZltWcW85vvpQoNM1heSuhG/Sk/L8uZh6cxljVyV
	rMhUh3SMXCk28laXR9Ms8D6QkeJHhUJk6Km11nQoQSrVRZQ+87JOuzTphOABGhnjmOQOJgSqWjK
	T2JeCQI3vhYtVCNK1sBQLeEgzajbFKNSrbkzhUN/ypktRlpBEybLAHdtjzL0vvzWb5iAmHW0L7m
	CHqElWyR34AUaUEQXskekcXtPYwgAHvWLjJk9wrzWWJmILVlzmqgnx9KTM2iqZiG9JiZMWyzYVn
	Xbp9WyqTpxbWzj9msCu8vJV2c1bDJepnFUmUQHdZtNvq1lNNvAUJ20O/7mJc4xpJEN5107crcsc
	zJhOwFQ4usp/IpglSxEdLHaYax4mTePy++bUnwY1FJdSM7dvKexoI31it32igTqFOl6ry7We4SC
	nxW3oiirvgxMDJxw==
X-Received: by 2002:a05:7301:3f07:b0:2da:b77a:d7a0 with SMTP id 5a478bee46e88-2e46519e391mr23744845eec.9.1777292437478;
        Mon, 27 Apr 2026 05:20:37 -0700 (PDT)
X-Received: by 2002:a05:7301:3f07:b0:2da:b77a:d7a0 with SMTP id 5a478bee46e88-2e46519e391mr23744804eec.9.1777292436688;
        Mon, 27 Apr 2026 05:20:36 -0700 (PDT)
Received: from [10.110.45.159] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53ccd2564sm44033609eec.18.2026.04.27.05.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 05:20:36 -0700 (PDT)
Message-ID: <af84cfb7-b673-404a-a7f9-6efd9d23a08f@oss.qualcomm.com>
Date: Mon, 27 Apr 2026 20:20:31 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com, hch@infradead.org,
        axboe@kernel.dk
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
 <ae65vfakVKg2aGcp@redhat.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <ae65vfakVKg2aGcp@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=aqCCzyZV c=1 sm=1 tr=0 ts=69ef5496 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=1XWaLZrsAAAA:8 a=EUspDBNiAAAA:8 a=FnpqCFmtQ5PB4EqzvNsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: -Yp6pR88py2Cep96M2C4hyDZrEU9hs4a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDEzMCBTYWx0ZWRfX/OpJ/1aCE0du
 wcAxIswAEjL9i+oNl9UlxKp7isCwpSDrO3f62+9cWskS2SkN1wfusLsZxva0Xq4kBqkMUULQC9O
 k5ZFB2CItFtp4xJxUWxeMCtva34QlmdYMCpN5eAePtjWFbi4ROPiIeipu25SegGWULf8YWCpbxd
 80cgVGlU9KItwt3jYdvCAbHndcc3TWsK83DQKzSKFC3jCHoDmRqB90H9U3W0Ne0q5GykxziTETZ
 XrxjzXHGBba+EMtQSdcYAaBNXFXL98KnyW+Aevl2WjhHCEr13kY1RPDzy34cMdNiqbmsPGyHCqC
 rmoqWP6fv+e31oIImuhOGI9CcbuhMdQs9pxmv7vzWTmRoZ+o+K9i8ltvaabxXh8qAL1iGLYVXhb
 AZsbtso1fQ2p705iMhz0SIAVj1UQcoks+JN7o5n9OzbSfFrYuGpdnzLy8JMC8EQa9Whjc/9kuRb
 fd0ih0nf1rUjh09Yc8g==
X-Proofpoint-ORIG-GUID: -Yp6pR88py2Cep96M2C4hyDZrEU9hs4a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270130



On 4/27/2026 9:19 AM, Benjamin Marzinski wrote:
> On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> Add a new device-mapper target "dm-inlinecrypt" that is similar to
>> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
>> This allows it to take advantage of inline encryption hardware such as
>> that commonly built into UFS host controllers.
>>
>> The table syntax matches dm-crypt's, but for now only a stripped-down
>> set of parameters is supported.  For example, for now AES-256-XTS is the
>> only supported cipher.
>>
>> dm-inlinecrypt is based on Android's dm-default-key with the
>> controversial passthrough support removed.  Note that due to the removal
>> of passthrough support, use of dm-inlinecrypt in combination with
>> fscrypt causes double encryption of file contents (similar to dm-crypt +
>> fscrypt), with the fscrypt layer not being able to use the inline
>> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
>> as Android that use fscrypt and where a more optimized approach is
>> needed.  It is however suitable as a replacement for dm-crypt.
>>
>> dm-inlinecrypt supports both keyring key and hex key, the former avoids
>> the key to be exposed in dm-table message. Similar to dm-default-key in
>> Android, it will fallabck to the software block crypto once the inline
>> crypto hardware cannot support the expected cipher.
>>
>> Test:
>> dmsetup create inlinecrypt_logon --table "0 `blockdev --getsz $1` \
>> inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0"
>>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/md/Kconfig          |  10 +
>>  drivers/md/Makefile         |   1 +
>>  drivers/md/dm-inlinecrypt.c | 559 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 570 insertions(+)
>>  create mode 100644 drivers/md/dm-inlinecrypt.c
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index c58a9a8ea54e..aa541cc22ecc 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -313,6 +313,16 @@ config DM_CRYPT
>>  
>>  	  If unsure, say N.
>>  
>> +config DM_INLINECRYPT
>> +	tristate "Inline encryption target support"
>> +	depends on BLK_DEV_DM
>> +	depends on BLK_INLINE_ENCRYPTION
>> +	help
>> +	  This device-mapper target is similar to dm-crypt, but it uses the
>> +	  blk-crypto API instead of the regular crypto API. This allows it to
>> +	  take advantage of inline encryption hardware such as that commonly
>> +	  built into UFS host controllers.
>> +
>>  config DM_SNAPSHOT
>>         tristate "Snapshot target"
>>         depends on BLK_DEV_DM
>> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
>> index c338cc6fbe2e..517d1f7d8288 100644
>> --- a/drivers/md/Makefile
>> +++ b/drivers/md/Makefile
>> @@ -55,6 +55,7 @@ obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
>>  obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
>>  obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
>>  obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
>> +obj-$(CONFIG_DM_INLINECRYPT)	+= dm-inlinecrypt.o
>>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>>  obj-$(CONFIG_DM_DUST)		+= dm-dust.o
>>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
>> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
>> new file mode 100644
>> index 000000000000..b6e98fdf8af1
>> --- /dev/null
>> +++ b/drivers/md/dm-inlinecrypt.c
>> @@ -0,0 +1,559 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright 2024 Google LLC
>> + */
>> +
>> +#include <linux/blk-crypto.h>
>> +#include <linux/ctype.h>
>> +#include <linux/device-mapper.h>
>> +#include <linux/hex.h>
>> +#include <linux/module.h>
>> +#include <keys/user-type.h>
>> +
>> +#define DM_MSG_PREFIX	"inlinecrypt"
>> +
>> +static const struct dm_inlinecrypt_cipher {
>> +	const char *name;
>> +	enum blk_crypto_mode_num mode_num;
>> +} dm_inlinecrypt_ciphers[] = {
>> +	{
>> +		.name = "aes-xts-plain64",
>> +		.mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
>> +	},
>> +};
>> +
>> +/**
>> + * struct inlinecrypt_ctx - private data of an inlinecrypt target
>> + * @dev: the underlying device
>> + * @start: starting sector of the range of @dev which this target actually maps.
>> + *	   For this purpose a "sector" is 512 bytes.
>> + * @cipher_string: the name of the encryption algorithm being used
>> + * @iv_offset: starting offset for IVs.  IVs are generated as if the target were
>> + *	       preceded by @iv_offset 512-byte sectors.
>> + * @sector_size: crypto sector size in bytes (usually 4096)
>> + * @sector_bits: log2(sector_size)
>> + * @key: the encryption key to use
>> + * @max_dun: the maximum DUN that may be used (computed from other params)
>> + */
>> +struct inlinecrypt_ctx {
>> +	struct dm_dev *dev;
>> +	sector_t start;
>> +	const char *cipher_string;
>> +	unsigned int key_size;
>> +	u64 iv_offset;
>> +	unsigned int sector_size;
>> +	unsigned int sector_bits;
>> +	struct blk_crypto_key key;
>> +	u64 max_dun;
>> +};
>> +
>> +static const struct dm_inlinecrypt_cipher *
>> +lookup_cipher(const char *cipher_string)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(dm_inlinecrypt_ciphers); i++) {
>> +		if (strcmp(cipher_string, dm_inlinecrypt_ciphers[i].name) == 0)
>> +			return &dm_inlinecrypt_ciphers[i];
>> +	}
>> +	return NULL;
>> +}
>> +
>> +static void inlinecrypt_dtr(struct dm_target *ti)
>> +{
>> +	struct inlinecrypt_ctx *ctx = ti->private;
>> +
>> +	if (ctx->dev) {
>> +		if (ctx->key.size)
>> +			blk_crypto_evict_key(ctx->dev->bdev, &ctx->key);
>> +		dm_put_device(ti, ctx->dev);
>> +	}
>> +	kfree_sensitive(ctx->cipher_string);
>> +	kfree_sensitive(ctx);
>> +}
>> +
>> +static bool contains_whitespace(const char *str)
>> +{
>> +	while (*str)
>> +		if (isspace(*str++))
>> +			return true;
>> +	return false;
>> +}
>> +
>> +static int set_key_user(struct key *key, char *bin_key,
>> +			const unsigned int bin_key_size)
>> +{
>> +	const struct user_key_payload *ukp;
>> +
>> +	ukp = user_key_payload_locked(key);
>> +	if (!ukp)
>> +		return -EKEYREVOKED;
>> +
>> +	if (bin_key_size != ukp->datalen)
>> +		return -EINVAL;
>> +
>> +	memcpy(bin_key, ukp->data, bin_key_size);
>> +
>> +	return 0;
>> +}
>> +
>> +static int inlinecrypt_get_keyring_key(const char *key_string, u8 *bin_key,
>> +					const unsigned int bin_key_size)
>> +{
>> +	char *key_desc;
>> +	int ret;
>> +	struct key_type *type;
>> +	struct key *key;
> 
> There's nothing forcing CONFIG_KEYS to be set when CONFIG_DM_INLINECRYPT
> is, and without it, struct key won't be defined and this won't compile.

Thanks for your review!

ACK. I'll add 'depends on' in kconfig file for CONFIG_DM_INLINECRYPT and
corresponding '#ifdef CONFIG_KEYS' in this code.

> 
>> +	int (*set_key)(struct key *key, char *bin_key,
>> +				   const unsigned int bin_key_size);
>> +
>> +	/*
>> +	 * Reject key_string with whitespace. dm core currently lacks code for
>> +	 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
>> +	 */
>> +	if (contains_whitespace(key_string)) {
>> +		DMERR("whitespace chars not allowed in key string");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* look for next ':' separating key_type from key_description */
>> +	key_desc = strchr(key_string, ':');
>> +	if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
>> +		return -EINVAL;
>> +
>> +	if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {
>> +		type = &key_type_logon;
>> +		set_key = set_key_user;
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	key = request_key(type, key_desc + 1, NULL);
>> +	if (IS_ERR(key))
>> +		return PTR_ERR(key);
>> +
>> +	down_read(&key->sem);
>> +
>> +	ret = set_key(key, (char *)bin_key, bin_key_size);
>> +	if (ret < 0) {
> 
> This does the same commands regardless of whether it takes this branch.

ACK. Need remove 'if' code block here.

> 
>> +		up_read(&key->sem);
>> +		key_put(key);
>> +		return ret;
>> +	}
>> +
>> +	up_read(&key->sem);
>> +	key_put(key);
>> +
>> +	return ret;
>> +}
>> +
>> +static int inlinecrypt_get_key(const char *key_string,
>> +				u8 key[BLK_CRYPTO_MAX_ANY_KEY_SIZE],
>> +				const unsigned int key_size)
>> +{
>> +	int ret = 0;
>> +
>> +	/* ':' means the key is in kernel keyring, short-circuit normal key processing */
>> +	if (key_string[0] == ':') {
>> +		if (key_size > BLK_CRYPTO_MAX_ANY_KEY_SIZE) {
>> +			DMERR("Invalid keysize");
>> +			return -EINVAL;
>> +		}
>> +		/* key string should be :<logon|user>:<key_desc> */
>> +		ret = inlinecrypt_get_keyring_key(key_string + 1, key, key_size);
>> +		goto out;
>> +	}
>> +
>> +	if (key_size > 2 * BLK_CRYPTO_MAX_ANY_KEY_SIZE
> 
> get_key_size() returns the size of the binary key in this case, so
> shouldn't this check for "key_size > BLK_CRYPTO_MAX_ANY_KEY_SIZE", and
> it seems like the check if the key_size is odd would make more sense in
> get_key_size().

Thanks for your insight!

ACK. Move the check if the key_size is odd into get_key_size() and only remains
this check for "key_size > BLK_CRYPTO_MAX_ANY_KEY_SIZE" here in this case.

> 
>> +		|| key_size  % 2
>> +		|| !key_size) {
>> +		DMERR("Invalid keysize");
>> +		return -EINVAL;
>> +	}
>> +	if (hex2bin(key, key_string, key_size) != 0)
>> +		ret = -EINVAL;
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int get_key_size(char **key_string)
>> +{
>> +	char *colon, dummy;
>> +	int ret;
>> +
>> +	if (*key_string[0] != ':')
>> +		return strlen(*key_string) >> 1;
>> +
>> +	/* look for next ':' in key string */
>> +	colon = strpbrk(*key_string + 1, ":");
>> +	if (!colon)
>> +		return -EINVAL;
>> +
>> +	if (sscanf(*key_string + 1, "%u%c", &ret, &dummy) != 2 || dummy != ':')
>> +		return -EINVAL;
>> +
>> +	/* remaining key string should be :<logon|user>:<key_desc> */
>> +	*key_string = colon;
>> +
>> +	return ret;
>> +}
>> +
>> +static int inlinecrypt_ctr_optional(struct dm_target *ti,
>> +				    unsigned int argc, char **argv)
>> +{
>> +	struct inlinecrypt_ctx *ctx = ti->private;
>> +	struct dm_arg_set as;
>> +	static const struct dm_arg _args[] = {
>> +		{0, 3, "Invalid number of feature args"},
>> +	};
>> +	unsigned int opt_params;
>> +	const char *opt_string;
>> +	bool iv_large_sectors = false;
>> +	char dummy;
>> +	int err;
>> +
>> +	as.argc = argc;
>> +	as.argv = argv;
>> +
>> +	err = dm_read_arg_group(_args, &as, &opt_params, &ti->error);
>> +	if (err)
>> +		return err;
>> +
>> +	while (opt_params--) {
>> +		opt_string = dm_shift_arg(&as);
>> +		if (!opt_string) {
>> +			ti->error = "Not enough feature arguments";
>> +			return -EINVAL;
>> +		}
>> +		if (!strcmp(opt_string, "allow_discards")) {
>> +			ti->num_discard_bios = 1;
>> +		} else if (sscanf(opt_string, "sector_size:%u%c",
>> +				  &ctx->sector_size, &dummy) == 1) {
>> +			if (ctx->sector_size < SECTOR_SIZE ||
>> +			    ctx->sector_size > 4096 ||
>> +			    !is_power_of_2(ctx->sector_size)) {
>> +				ti->error = "Invalid sector_size";
>> +				return -EINVAL;
>> +			}
>> +		} else if (!strcmp(opt_string, "iv_large_sectors")) {
>> +			iv_large_sectors = true;
>> +		} else {
>> +			ti->error = "Invalid feature arguments";
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> +	/* dm-inlinecrypt doesn't implement iv_large_sectors=false. */
>> +	if (ctx->sector_size != SECTOR_SIZE && !iv_large_sectors) {
>> +		ti->error = "iv_large_sectors must be specified";
> 
> Since setting sector_size forces setting iv_large_sectors, does it
> really need to be a separate parameter? Can't it just be implied by
> setting a non-512 sector_size. Is this here to futureproof the table
> line?

Thanks for your question!
Although a non-512 sector_size effectively requires large-sector IV semantics
for dm-inlinecrypt, iv_large_sectors is intentionally kept as an explicit table
parameter.

iv_large_sectors affects IV generation and the on-disk encryption format.
Inferring it from sector_size would silently change encryption semantics and
could break compatibility with existing data. Requiring it to be explicitly
specified forces userspace to consciously opt into the correct IV behavior,
rather than having it implied or overridden internally.

> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Construct an inlinecrypt mapping:
>> + * <cipher> [<key>|:<key_size>:<logon>:<key_description>] <iv_offset> <dev_path> <start>
>> + *
>> + * This syntax matches dm-crypt's, but the set of supported functionality has
>> + * been stripped down.
>> + */
>> +static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>> +{
>> +	struct inlinecrypt_ctx *ctx;
>> +	const struct dm_inlinecrypt_cipher *cipher;
>> +	u8 raw_key[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
>> +	unsigned int dun_bytes;
>> +	unsigned long long tmpll;
>> +	char dummy;
>> +	int err;
>> +
>> +	if (argc < 5) {
>> +		ti->error = "Not enough arguments";
>> +		return -EINVAL;
>> +	}
>> +
>> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>> +	if (!ctx) {
>> +		ti->error = "Out of memory";
>> +		return -ENOMEM;
>> +	}
>> +	ti->private = ctx;
>> +
>> +	/* <cipher> */
>> +	ctx->cipher_string = kstrdup(argv[0], GFP_KERNEL);
>> +	if (!ctx->cipher_string) {
>> +		ti->error = "Out of memory";
>> +		err = -ENOMEM;
>> +		goto bad;
>> +	}
>> +	cipher = lookup_cipher(ctx->cipher_string);
>> +	if (!cipher) {
>> +		ti->error = "Unsupported cipher";
>> +		err = -EINVAL;
>> +		goto bad;
>> +	}
>> +
>> +	/* <key> */
>> +	ctx->key_size = get_key_size(&argv[1]);
>> +	if (ctx->key_size < 0) {
>> +		ti->error = "Cannot parse key size";
>> +		return -EINVAL;
>> +	}
>> +	err = inlinecrypt_get_key(argv[1], raw_key, ctx->key_size);
>> +	if (err) {
>> +		ti->error = "Malformed key string";
>> +		goto bad;
>> +	}
>> +
>> +	/* <iv_offset> */
>> +	if (sscanf(argv[2], "%llu%c", &ctx->iv_offset, &dummy) != 1) {
>> +		ti->error = "Invalid iv_offset sector";
>> +		err = -EINVAL;
>> +		goto bad;
>> +	}
>> +
>> +	/* <dev_path> */
>> +	err = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
>> +			    &ctx->dev);
>> +	if (err) {
>> +		ti->error = "Device lookup failed";
>> +		goto bad;
>> +	}
>> +
>> +	/* <start> */
>> +	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
>> +	    tmpll != (sector_t)tmpll) {
>> +		ti->error = "Invalid start sector";
>> +		err = -EINVAL;
>> +		goto bad;
>> +	}
>> +	ctx->start = tmpll;
>> +
>> +	/* optional arguments */
>> +	ctx->sector_size = SECTOR_SIZE;
>> +	if (argc > 5) {
>> +		err = inlinecrypt_ctr_optional(ti, argc - 5, &argv[5]);
>> +		if (err)
>> +			goto bad;
>> +	}
>> +	ctx->sector_bits = ilog2(ctx->sector_size);
>> +	if (ti->len & ((ctx->sector_size >> SECTOR_SHIFT) - 1)) {
>> +		ti->error = "Device size is not a multiple of sector_size";
>> +		err = -EINVAL;
>> +		goto bad;
>> +	}
>> +
>> +	ctx->max_dun = (ctx->iv_offset + ti->len - 1) >>
>> +		       (ctx->sector_bits - SECTOR_SHIFT);
>> +	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
>> +
>> +	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
>> +				  BLK_CRYPTO_KEY_TYPE_RAW,
>> +				  cipher->mode_num, dun_bytes,
>> +				  ctx->sector_size);
>> +	if (err) {
>> +		ti->error = "Error initializing blk-crypto key";
>> +		goto bad;
>> +	}
>> +
>> +	err = blk_crypto_start_using_key(ctx->dev->bdev, &ctx->key);
>> +	if (err) {
>> +		ti->error = "Error starting to use blk-crypto";
>> +		goto bad;
>> +	}
>> +
>> +	ti->num_flush_bios = 1;
>> +
>> +	err = 0;
>> +	goto out;
>> +
>> +bad:
>> +	inlinecrypt_dtr(ti);
>> +out:
>> +	memzero_explicit(raw_key, sizeof(raw_key));
>> +	return err;
>> +}
>> +
>> +static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
>> +{
>> +	const struct inlinecrypt_ctx *ctx = ti->private;
>> +	sector_t sector_in_target;
>> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
>> +
>> +	bio_set_dev(bio, ctx->dev->bdev);
>> +
>> +	/*
>> +	 * If the bio is a device-level request which doesn't target a specific
>> +	 * sector, there's nothing more to do.
>> +	 */
>> +	if (bio_sectors(bio) == 0)
>> +		return DM_MAPIO_REMAPPED;
>> +
>> +	/*
>> +	 * The bio should never have an encryption context already, since
>> +	 * dm-inlinecrypt doesn't pass through any inline encryption
>> +	 * capabilities to the layer above it.
>> +	 */
>> +	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
>> +		return DM_MAPIO_KILL;
>> +
>> +	/* Map the bio's sector to the underlying device. (512-byte sectors) */
>> +	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
>> +	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
>> +	/*
>> +	 * If the bio doesn't have any data (e.g. if it's a DISCARD request),
>> +	 * there's nothing more to do.
>> +	 */
>> +	if (!bio_has_data(bio))
>> +		return DM_MAPIO_REMAPPED;
>> +
>> +	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
>> +	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
>> +	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
>> +		return DM_MAPIO_KILL;
> 
> If ctx->iv_offset is not a multiple of ctx->sector_size, this will
> always fail. ctx->iv_offset should probably get validated in
> inlinecrypt_ctr()

ACK

Yes, this assumes iv_offset is aligned to sector_size when large crypto
sectors are used. That’s a requirement of dm-inlinecrypt semantics, and
adding an explicit check in inlinecrypt_ctr() would make this fail earlier
and more clearly.

> 
> -Ben
> 
>> +	dun[0] >>= ctx->sector_bits - SECTOR_SHIFT; /* crypto sectors */
>> +
>> +	/*
>> +	 * This check isn't necessary as we should have calculated max_dun
>> +	 * correctly, but be safe.
>> +	 */
>> +	if (WARN_ON_ONCE(dun[0] > ctx->max_dun))
>> +		return DM_MAPIO_KILL;
>> +
>> +	bio_crypt_set_ctx(bio, &ctx->key, dun, GFP_NOIO);
>> +
>> +	/*
>> +	 * Since we've added an encryption context to the bio and
>> +	 * blk-crypto-fallback may be needed to process it, it's necessary to
>> +	 * use the fallback-aware bio submission code rather than
>> +	 * unconditionally returning DM_MAPIO_REMAPPED.
>> +	 *
>> +	 * To get the correct accounting for a dm target in the case where
>> +	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
>> +	 * true), call __blk_crypto_submit_bio() directly and return
>> +	 * DM_MAPIO_REMAPPED in that case, rather than relying on
>> +	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
>> +	 */
>> +	if (__blk_crypto_submit_bio(bio))
>> +		return DM_MAPIO_REMAPPED;
>> +	return DM_MAPIO_SUBMITTED;
>> +}
>> +
>> +static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
>> +			       unsigned int status_flags, char *result,
>> +			       unsigned int maxlen)
>> +{
>> +	const struct inlinecrypt_ctx *ctx = ti->private;
>> +	unsigned int sz = 0;
>> +	int num_feature_args = 0;
>> +
>> +	switch (type) {
>> +	case STATUSTYPE_INFO:
>> +	case STATUSTYPE_IMA:
>> +		result[0] = '\0';
>> +		break;
>> +
>> +	case STATUSTYPE_TABLE:
>> +		/*
>> +		 * Warning: like dm-crypt, dm-inlinecrypt includes the key in
>> +		 * the returned table.  Userspace is responsible for redacting
>> +		 * the key when needed.
>> +		 */
>> +		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
>> +		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
>> +		       ctx->dev->name, ctx->start);
>> +		num_feature_args += !!ti->num_discard_bios;
>> +		if (ctx->sector_size != SECTOR_SIZE)
>> +			num_feature_args += 2;
>> +		if (num_feature_args != 0) {
>> +			DMEMIT(" %d", num_feature_args);
>> +			if (ti->num_discard_bios)
>> +				DMEMIT(" allow_discards");
>> +			if (ctx->sector_size != SECTOR_SIZE) {
>> +				DMEMIT(" sector_size:%u", ctx->sector_size);
>> +				DMEMIT(" iv_large_sectors");
>> +			}
>> +		}
>> +		break;
>> +	}
>> +}
>> +
>> +static int inlinecrypt_prepare_ioctl(struct dm_target *ti,
>> +				     struct block_device **bdev, unsigned int cmd,
>> +				     unsigned long arg, bool *forward)
>> +{
>> +	const struct inlinecrypt_ctx *ctx = ti->private;
>> +	const struct dm_dev *dev = ctx->dev;
>> +
>> +	*bdev = dev->bdev;
>> +
>> +	/* Only pass ioctls through if the device sizes match exactly. */
>> +	return ctx->start != 0 || ti->len != bdev_nr_sectors(dev->bdev);
>> +}
>> +
>> +static int inlinecrypt_iterate_devices(struct dm_target *ti,
>> +				       iterate_devices_callout_fn fn,
>> +				       void *data)
>> +{
>> +	const struct inlinecrypt_ctx *ctx = ti->private;
>> +
>> +	return fn(ti, ctx->dev, ctx->start, ti->len, data);
>> +}
>> +
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +static int inlinecrypt_report_zones(struct dm_target *ti,
>> +				    struct dm_report_zones_args *args,
>> +				    unsigned int nr_zones)
>> +{
>> +	const struct inlinecrypt_ctx *ctx = ti->private;
>> +
>> +	return dm_report_zones(ctx->dev->bdev, ctx->start,
>> +			ctx->start + dm_target_offset(ti, args->next_sector),
>> +			args, nr_zones);
>> +}
>> +#else
>> +#define inlinecrypt_report_zones NULL
>> +#endif
>> +
>> +static void inlinecrypt_io_hints(struct dm_target *ti,
>> +				 struct queue_limits *limits)
>> +{
>> +	const struct inlinecrypt_ctx *ctx = ti->private;
>> +	const unsigned int sector_size = ctx->sector_size;
>> +
>> +	limits->logical_block_size =
>> +		max_t(unsigned int, limits->logical_block_size, sector_size);
>> +	limits->physical_block_size =
>> +		max_t(unsigned int, limits->physical_block_size, sector_size);
>> +	limits->io_min = max_t(unsigned int, limits->io_min, sector_size);
>> +	limits->dma_alignment = limits->logical_block_size - 1;
>> +}
>> +
>> +static struct target_type inlinecrypt_target = {
>> +	.name			= "inlinecrypt",
>> +	.version		= {1, 0, 0},
>> +	/*
>> +	 * Do not set DM_TARGET_PASSES_CRYPTO, since dm-inlinecrypt consumes the
>> +	 * crypto capability itself.
>> +	 */
>> +	.features		= DM_TARGET_ZONED_HM,
>> +	.module			= THIS_MODULE,
>> +	.ctr			= inlinecrypt_ctr,
>> +	.dtr			= inlinecrypt_dtr,
>> +	.map			= inlinecrypt_map,
>> +	.status			= inlinecrypt_status,
>> +	.prepare_ioctl		= inlinecrypt_prepare_ioctl,
>> +	.iterate_devices	= inlinecrypt_iterate_devices,
>> +	.report_zones		= inlinecrypt_report_zones,
>> +	.io_hints		= inlinecrypt_io_hints,
>> +};
>> +
>> +module_dm(inlinecrypt);
>> +
>> +MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
>> +MODULE_AUTHOR("Linlin Zhang <linlin.zhang@oss.qualcomm.com>");
>> +MODULE_DESCRIPTION(DM_NAME " target for inline encryption");
>> +MODULE_LICENSE("GPL");
>> -- 
>> 2.34.1
>>
> 

