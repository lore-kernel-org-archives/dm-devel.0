Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159733BE648
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 11:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774438079; cv=none; b=HmdP8dMX8bHsR5pu3lZuXJ+r9nIuKoWoCtrOQdv5RuhHasRnpbdvwVVG3LikzwB7HRvFrOCF+wsKLrc9fbD4JPMlwnaRYX6TaBztXo9shAG6w5V/9zeP8NjS3vHY50lM9r+d9ck/XzCoAoIGqUY5Rih8ZY0OGx5aH4gUQJ15OAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774438079; c=relaxed/simple;
	bh=DnZaBhzGFxXnqOxSGlpPY7ahaCmpo1GkrOsB1cg5jsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TzpQUyvzURwId0exNkBafIh3KZUSK4sRygO2Nb8c/D+CHHpHBQ1uUr2WR3nW4ZvTCgkdHlp4fo4KZYoc1RJJRn4kx9YvlMV6u0/YXXoU9dWpZOG3riGs9valal6BWYdQ3HcZfDKC4ohqjiJwSmbhWPkcQpve/xQajTn4EroHnmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mHIzDNE5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DivHH4Lx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mHIzDNE5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DivHH4Lx"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PBGeZh1897400
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 11:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gtphB0uT9yTG03QQZ4jwiVHKGdOTvs/YlaGJ19taHGs=; b=mHIzDNE5eoJlrJRE
	u3e1uqdKhUk3bBlKwkcGkrN7geKqnPqdjmAaUmKtfLqn3NZsVus89mJV5ISxRkUM
	9MP3CFsB2hj2WWJKxQGHZyG8F/K+WmaGOeJXL/2KPsL92VhL2WmaSU22avjPsSxS
	ReGkHM6JkoQhHoXN1MCY/s0bDlG8O4MFo3RwEvJ9uJu1e5WxQSoe9QZgA6UvNiZU
	NFAW7Krv0LZPOXRdBJrA6CC1kWJUCa7bO+yVGJjEoWJAGtYELsHDiOvPA1ybuQ+g
	QwNGK9BYc6dspTG8pf3NUCDMk5DC13U3VuYsTvYw3PcUfhzybm7Rrala3/67L1PI
	+PsydA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d489mhjbu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 11:27:56 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2c0bddb9196so1446696eec.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 04:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774438076; x=1775042876; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gtphB0uT9yTG03QQZ4jwiVHKGdOTvs/YlaGJ19taHGs=;
        b=DivHH4LxpiTTYoOodiRfqks9WMO1nCNc86fSAyRAGtMVxGA0N6iPywBRGTJKyIpi+b
         cIAjQhaMp7R+gDnY6WPUqFTiUe7Cq8LZftk6osQbHlARGcwocjAzm0caiNuVa7ehi7v+
         yNq0UGbv31VWpFUi/LMFxiXE/d4gPm1kYGXMsOW6281zvl4fIEjcVjHX2VSDQ2Y5rp6f
         XEQabQl4XtLZrflmU40zvBaU/fFh2PlV37KlG/EN3SYPCdEB5vSwa4HECk+QG1eVc7/M
         onyCpTwZZi+cuE8pP7Y3DQh0nTCGGgeB7lh+vhXJSwjp+fdCbanzBXpCs8BIUTD9SqtL
         XcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774438076; x=1775042876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gtphB0uT9yTG03QQZ4jwiVHKGdOTvs/YlaGJ19taHGs=;
        b=PnOR/kswhDcCWOzn6WM2bZYA9EkYyvR29vPwoRISMnpUWQlyKNjKZ0Pk2rOh+5uhZj
         9kpJh7RZad5mkt0V+f/XyPOIUUrCC+0W0jeQg4tkbT8l3XtXuCLFjdw/cQGFfhyUyubw
         +2+WFrloro3kYmsicWgjwUHzQ7P0CShkVT4Uu9UDFyeDIPStNS9R5tjLJt4yYnmOz2P9
         UJ5DIAOIgqV3qVvQvmQdZBk/SYF1S9YcBHLXyzyKh8nndwAZwQlzlANq+awJ8xjsMgRe
         9iWUSqZs0hBX4Zt9fRv8USPef9pXm9llnHadel6ejGgMdaUX7KAmK0REZiu34UkrXECx
         fjWg==
X-Forwarded-Encrypted: i=1; AJvYcCUSz14E95hfSImZfBBPxOqGGxLE7EYAEM+9N25IczruI6NKJ99+iU4p6YR0EJiGTz9CsjDLxCR3dA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1YTDtwyK/EbwrO4IggS+gl/ZirwQzcZHHxe4dx+wef5Wk6282
	dA4+Q1zng1O7eWyA7BVi05SMCkpYivEDY9GQu26DOBJqANvzCA7cQSNTGJgrV2cgoldNWG0CeIb
	TF7laJonK/p8BDYuGFqMryqj3FHcka81IIV45wuDvGULXOUQiVSI36pJympvapw==
X-Gm-Gg: ATEYQzy1CZxO2WC6HEQ8jMv78PxnP0HBMYfLhw5GXes092PnwhisQrYTy6yPPdOmYKr
	foo0lYKT9fc1dB/oySKnBKlRe2+8TB+60Ray0MTMl6wBn3PYu/knP0St1UmsS26or+BgUDmmt4A
	YNk6sK/PAxmepiTXwHN8a5EHw//DUJrfRQpdQYzxt7QhQXfCshDGRmldXGGQmAiB/ejJiWq6pTF
	PON1pBebln/NHfYUu/4MpiDh80mqbt27bX7fPOEq5c7MGwCv7ivXQd0kqYjZZuTbcvLwDarv75I
	6wtzaBTAiF0JGQW6tLx1CZXRIKSPMsH6f0S5yQlDh8W81Iwn9HQ7wrYyk7Iw3tj91SBV84LB4Aa
	/hvlAT2WVPLmConO0jGFmg6+uyJLe0TRtL7c/XoPefHf8UyH+goVzYbAnej4SbkxC9KnoXltvMb
	DIdl4=
X-Received: by 2002:a05:7300:dc05:b0:2c0:f424:b545 with SMTP id 5a478bee46e88-2c15d350374mr1758186eec.15.1774438075457;
        Wed, 25 Mar 2026 04:27:55 -0700 (PDT)
X-Received: by 2002:a05:7300:dc05:b0:2c0:f424:b545 with SMTP id 5a478bee46e88-2c15d350374mr1758162eec.15.1774438074661;
        Wed, 25 Mar 2026 04:27:54 -0700 (PDT)
Received: from [10.110.19.183] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c10b14caf3sm24298598eec.5.2026.03.25.04.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2026 04:27:54 -0700 (PDT)
Message-ID: <8bd50656-6b6d-41d3-8093-c97dd1bb3e91@oss.qualcomm.com>
Date: Wed, 25 Mar 2026 19:27:49 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] dm-inlinecrypt: add target for inline block device
 encryption
To: Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org,
        ebiggers@kernel.org
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        mpatocka@redhat.com
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com>
 <20260304121729.1532469-3-linlin.zhang@oss.qualcomm.com>
 <682506ea-c9c2-458b-8123-8d78fc53cc7f@gmail.com>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <682506ea-c9c2-458b-8123-8d78fc53cc7f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA4MSBTYWx0ZWRfX5CmupqvzZJld
 QALwkRekes9bUlHhDQLBt+CJhXrIBD2BFztijrjnG4xDSyjLuIGgIyAU5h9ueLA65Zg2sN2pgH5
 wpY6z64MX2GWgFTvXTI+qAq8OqkAb2BtInGeMcHt77i2Z6+D6yxZbISrg14eg7IDIB+iEZXrUZY
 1XVjf6/UMmj7qdQSN71ClW9fKodgUBpjY90HknRGh9Q4DoZ71wYlJpqOGRhsBVsIfZR4rseknzz
 v9Z7JmX3diH+Hs+qox0CFcFtwCoxJWlwKJ/KX9w4v0jm8C/8XpsEVZYEM6QqkssXCaxvNiMzwYM
 5JCvUzaXvlykRh47mfYe50oRUVqiLrjXXdjEtf1g2KPFXGiU1AJc9GB9aqCP+bwMJV8SBQ0fRz1
 4XwHmApQtqvW09ZPCYwPP6mHvkkXSY5+FbfQobCRVgONyUa28cIwSa8b+2NlrYnlcMwGpkuTCXo
 oi4fK2VMoFduD4nXzMw==
X-Proofpoint-GUID: LirE74yjuXm4AJq_9RFfKByqBOIWAfFL
X-Proofpoint-ORIG-GUID: LirE74yjuXm4AJq_9RFfKByqBOIWAfFL
X-Authority-Analysis: v=2.4 cv=AKSYvs3t c=1 sm=1 tr=0 ts=69c3c6bc cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=Oh2cFVv5AAAA:8 a=1XWaLZrsAAAA:8 a=EUspDBNiAAAA:8 a=F5rjXf0sUYbAb7_yClkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
 a=7KeoIwV6GZqOttXkcoxL:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_03,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250081



On 3/4/2026 9:11 PM, Milan Broz wrote:
> Hi,
> 
> just few comments below, but I am not DM maintainer so feel free to ignore it :)
> 
> On 3/4/26 1:17 PM, Linlin Zhang wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> Add a new device-mapper target "dm-inlinecrypt" that is similar to
>> dm-crypt but uses the blk-crypto API instead of the regular crypto API.
>> This allows it to take advantage of inline encryption hardware such as
>> that commonly built into UFS host controllers.
>>
>> The table syntax matches dm-crypt's, but for now only a stripped-down
>> set of parameters is supported.  For example, for now AES-256-XTS is the
>> only supported cipher.
>>
>> dm-inlinecrypt is based on Android's dm-default-key with the
>> controversial passthrough support removed.  Note that due to the removal
>> of passthrough support, use of dm-inlinecrypt in combination with
>> fscrypt causes double encryption of file contents (similar to dm-crypt +
>> fscrypt), with the fscrypt layer not being able to use the inline
>> encryption hardware.  This makes dm-inlinecrypt unusable on systems such
>> as Android that use fscrypt and where a more optimized approach is
>> needed.  It is however suitable as a replacement for dm-crypt.
>>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
>> ---
>>   drivers/md/Kconfig          |  10 +
>>   drivers/md/Makefile         |   1 +
>>   drivers/md/dm-inlinecrypt.c | 416 ++++++++++++++++++++++++++++++++++++
> 
> I think it should also add doc in
> Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst

Thanks for your review.
You're right. I'll add it in next patch.

> ...
> 
>> +#define DM_MSG_PREFIX    "inlinecrypt"
>> +
>> +static const struct dm_inlinecrypt_cipher {
>> +    const char *name;
>> +    enum blk_crypto_mode_num mode_num;
>> +    int key_size;
>> +} dm_inlinecrypt_ciphers[] = {
>> +    {
>> +        .name = "aes-xts-plain64",
>> +        .mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
>> +        .key_size = 64,
> 
> Hm. I can understand some translation table for this stupid
> dm-crypt notation to inline enum, but why you need key size here?
> 
> Shouldn't there be some helper for inline crypt returning
> keysize based on BLK_ENCRYPTION_MODE_AES_256_XTS?

Similar to dm-default-key in Android (https://android.googlesource.com/kernel/common/+/android-mainline/drivers/md/dm-default-key.c),
key_size 64 here is always corresponding to a raw key. For a HW wrapped key, the key
size differs from different manufacturers. Linux kernel only constraints that the max
key size of HW wrapped key isn't larger than BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE(128).
So we get the actual key size based on the input key parameter received in ctr functions.

> 
> I guess you have fixed cipher list already, but what about IV?
> Is it always little-endian, or someone already reinvented plain64be (big-endian)?
> 
> ...> +    while (opt_params--) {
> 
> ...> +/*

Same to dm-crypt, 'plain64' in "aes-xts-plain64" of cipher name is the IV mode. It uses
the 64‑bit little‑endian sector number as the IV.


>> + * Construct an inlinecrypt mapping:
>> + * <cipher> <key> <iv_offset> <dev_path> <start>
> 
> As above, it supports opt params, it should mention it here (or in doc).

ACK, refer to dm-crypt, I'll add it in doc.

> 
> 
> ...
>> +    /* <key> */
>> +    if (strlen(argv[1]) != 2 * cipher->key_size) {
>> +        ti->error = "Incorrect key size for cipher";
>> +        err = -EINVAL;
>> +        goto bad;
>> +    }
>> +    if (hex2bin(raw_key, argv[1], cipher->key_size) != 0) {
>> +        ti->error = "Malformed key string";
>> +        err = -EINVAL;
>> +        goto bad;
>> +    }
> 
> 
> Any reason it does not support keyring keys from the beginning?

No special reason. The implementation of `dm-inlinecrypt` was modeled after
'dm-default-key', which, in Android, does not support keyring keys.
I'll have a insight about keyring and dm-crypt, inspect how to add keyring support
in dm-inline-crypt.

> 
> ...
>> +static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
> 
>> +    /* Map the bio's sector to the underlying device. (512-byte sectors) */
>> +    sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
>> +    bio->bi_iter.bi_sector = ctx->start + sector_in_target;
>> +    /*
>> +     * If the bio doesn't have any data (e.g. if it's a DISCARD request),
>> +     * there's nothing more to do.
>> +     */
> 
> dmcrypt uses bio_set_dev() for REQ_PREFLUSH or REQ_OP_DISCARD, why this differs?

bio_has_data() is a payload‑based check that decides whether an encryption context
is needed, while REQ_PREFLUSH and REQ_OP_DISCARD are semantic checks that ensure
flush and discard requests bypass the dm‑crypt processing pipeline to maintain
correct I/O ordering. As a result, the two mechanisms address different concerns
and are not interchangeable.

In addition, bio_has_data is called in the beginning of inlinecrypt_map, rather
in the conditional branch like dm-crypt. But they have same effect.

> 
>> +
>> +    switch (type) {
>> +    case STATUSTYPE_INFO:
>> +    case STATUSTYPE_IMA:
>> +        result[0] = '\0';
> 
> This should really emit audit information similar to dm-crypt.
> 
>> +        break;
>> +
>> +    case STATUSTYPE_TABLE:
>> +        /*
>> +         * Warning: like dm-crypt, dm-inlinecrypt includes the key in
>> +         * the returned table.  Userspace is responsible for redacting
>> +         * the key when needed.
> 
> Again, why not support keyring format? LUKS2 uses it by default for dm-crypt table.

ACK. Need support keyring format.
I see both hex key and keyring-based keys are supported in dm-crypt. can both of them
be supported in dm-inlinecrypt?

> 
> Milan
> 

