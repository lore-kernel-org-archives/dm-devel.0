Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2F7426EAA
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 10:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777373001; cv=none; b=dUdbLS6vAYLcpW7FHX2a/KNv8Ob+HQBku9KnYapsfS8xdWhqnWTyC/PcG4u4aMfQKoeyrr4wHKqkOCtsdftKS+TRps7CbVj5ZTwebKO1tJkfWtRPvCJrU5TLifq2OGsgJaerXKdPIWBBEifCDTV29uZ5jz4FLojNFT6O7QmGPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777373001; c=relaxed/simple;
	bh=D84N/KUvgGLLkb6ue7eX5V9qeV2gwsd7cxmMuguzGNc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=pVPItb9bzRHnomsszZw94Kxs+f76WNxxJHIS6lp51Gb/7mT0AQa2o2bRgCPKb9zTJIGOgPL8EEMen5+JrUu4iFwZY9zIyiHUR4e9mbSFjDculDRPlwNOsLYu/5yCT6UDCth8hPvuhnWnqBSklnnV6GofV7ZvwRaS2t15q/1zJM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Vuo2/vJK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CiSrDVJb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Vuo2/vJK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CiSrDVJb"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63S7UBvn440498
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 10:43:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PIxcKhZ7J5p7muppYgPV9govSvoDNSjvHD1kzMfuUEk=; b=Vuo2/vJKJxvT/msW
	IjyTCf5jj6U4408fvQVojQQBOAZNkGDzXEOv2ds7nFrZc2g7HHb/e1yMOQIWyaEV
	ALALYgKZe1lUZFl+Al4YaKOf26wC0g+JRzxcQoTfei+CAsIVCVFoE/e+wHHID9HH
	fy+QqcctuAU4y2qZl0XAYZd0blsFu2KklI4z8wTYVQqUTv+2wqH2dCuONaHBLHse
	QseO1jCRhFoL/mOeTPs/8UkjjZfO2qNzny1SEdI9z75SHSAxXHnvopRIBzIuDt4n
	0FhGqMjDpIpW6CfrOfCbrsXcKl86jrM5MnKx9ZzFdNyxJm8rpUJG5Ixf07W45C6j
	uQdonA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dtac440bw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 10:43:14 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2ddd8ef5343so11133289eec.1
        for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 03:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777372994; x=1777977794; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PIxcKhZ7J5p7muppYgPV9govSvoDNSjvHD1kzMfuUEk=;
        b=CiSrDVJbvkvOodWDJk6cRquywQu0tofGMJgSjSk4iW60zG1luddfUA2txfFo3IT0ut
         ZedX9BqZ5hdgIflCYt71JcEGKfzitqjoH8lit6rq3LvrBe2ijt2yLmHl6qQHgiHpjMlw
         P3MfYJ6468YbCyRwmR1NeHFVFeAW+dsQO2GBZ/Gaw76hgzna65c28HK/dMGgMhCHqUW0
         07+Yl8AFtLQDHpsB42CYLT2P4wS8bxPnzrUPbeddF+vKNyRH4NOjA1wqZfIqnO+uPMRs
         wkpaF0dIoRnDRjTysTvN7dy3Uggujl2EqXcTxfzLegSe7BjxYjFxJljcotD/tEY/y3ab
         9heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777372994; x=1777977794;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PIxcKhZ7J5p7muppYgPV9govSvoDNSjvHD1kzMfuUEk=;
        b=CJAVTKY6AaFCYY6NnHUZWsgc0q39rdPZbqJqqC96hJYgmfgLr0GuHykPZ5SVbTDNKN
         KfAMRKwfOWxvTIsGYgAzy1e1TB0tXNLOJ5JytBhWPjJIPaxXFA+kPXKMGdPoMmbAvJ5N
         45Ybj1ngbjMXqLe27DKd3hAIWwynaUvdtdoN0STUfBZw2ACLfR1YB3wIr1CyQSoOWnlR
         D5f5ryYGdqBZz77NfmFqFDDDwLZx/QfXxLtj5wKzGLqvCaZxSKyj0azfwnl3EZUmZBaL
         BvGRh2ovjczJgdKIu7+zhuB8sZuvhWaFoyEAe8Ri9VuL5vG5EuWvms9NNhjillTsew0V
         7UUQ==
X-Forwarded-Encrypted: i=1; AFNElJ8n+YaSYnz3X4QqRTgpX+eJe7EL1k6RTKwlwxKUouswFHA/XOAeX/1v6qJwq+82zWEg8nRHRNTpKQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YzFVDsd63bGJEgPnfAFGtVHVInzBre99xHC6eVG8ngYaxm71DrK
	mxC4NCAF1OYM27XcEQRK/vINmwKlqbNZZyvK5141rM0Wz5EDMXhnoN5lz77epBi3rNqHNRdU8Ry
	8Oo1/oeAdF5rrobiqZ3Stz8P4aSpw+hV9CuiiiZ4uQyJ/s7EZAY1KqE8ZWmIsUg==
X-Gm-Gg: AeBDies4Rrr8jG9BkiUpAgf8wopPwx0h8YWbCaVkXmfXSAOobMshFsJ4/3z7HoSUGIJ
	wg0sbdOg/GfoTavSaCUksxp/q4WfmKkKe/e3mr81nJP2yM5wqDq2uDJPgGUhFBJuxsnvWy5xG4q
	4TRJeCELjCING4PKCawzTj23Dq42LpYfXHD8mSlOhjWOtofETseohrxnDueKhOloa6nPvzrv6uX
	YRMgzOoWynQl0O+JZd3+IIZP5GjUCXRuAksU8f1MVWSEAjPu2pJv4QWn7sc/meWFc64VtVP3W8x
	hi/+/VZoIGdghmO4l5VQ3YQPUhVS0SL36naDl5ifoaCESJeuR605eMORYydMqa3fAb7jEr4hh+r
	SUlRWRZKf4Xzo8TnmEkajguGdibpKXi46hoBWRZJVQP836h3skG0KjUTcZw6usePmA2Vleeyf0Y
	ePBruSRAP+q+RwqA==
X-Received: by 2002:a05:7300:dc98:b0:2d3:f3fc:bb6b with SMTP id 5a478bee46e88-2ed09fde238mr1159780eec.1.1777372993817;
        Tue, 28 Apr 2026 03:43:13 -0700 (PDT)
X-Received: by 2002:a05:7300:dc98:b0:2d3:f3fc:bb6b with SMTP id 5a478bee46e88-2ed09fde238mr1159764eec.1.1777372993185;
        Tue, 28 Apr 2026 03:43:13 -0700 (PDT)
Received: from [10.110.45.159] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed0a106524sm1987174eec.23.2026.04.28.03.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 03:43:12 -0700 (PDT)
Message-ID: <f92f318b-5c99-4880-906c-136aa180d58c@oss.qualcomm.com>
Date: Tue, 28 Apr 2026 18:43:08 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block device
 encryption
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com, hch@infradead.org,
        axboe@kernel.dk
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
 <ae65vfakVKg2aGcp@redhat.com>
 <af84cfb7-b673-404a-a7f9-6efd9d23a08f@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <af84cfb7-b673-404a-a7f9-6efd9d23a08f@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: mJ-GKOhTM7uYbFOdr9qkbAWDBb7ltwrU
X-Authority-Analysis: v=2.4 cv=D7J37PRj c=1 sm=1 tr=0 ts=69f08f42 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=1XWaLZrsAAAA:8 a=EUspDBNiAAAA:8 a=zAVYknurB8viCDo1gd4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: mJ-GKOhTM7uYbFOdr9qkbAWDBb7ltwrU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDA5NiBTYWx0ZWRfXxAOyLXfC5dYz
 yNctD3kp/CsVM2tmUAWCYqrrKXe3i/R4k9v1DCnOC0iQKWAJdRx1gCoo0EmQtPXLVDWb3c7CHAq
 17evM57sIIfJEinBtrYcmF1vLmUsffpH9VlUBLEUfuO8vFlhh0KyPtzWAYtTTQhV7SdRZAqVSsQ
 pghzn/ZvYesboVlT1aB6/kijB/e0DblwfFzVvmpNumdW9rWtAAN9qERdiBicTyLq0I/KJzgfRBS
 tLYuVu5qxmfERXDkYNR1DWIRO2Btv96e31qGBH1A5ij1r71IOzXIMxNZB8DYuFrXi+OWubx8Ek8
 H2UpQXepetROnIZK8kZjTUbciPT++kw3VVOPHchAs/q58Xgq2TWhLJMOmLox98rc+FL8WfGCM0x
 YbLai5VyjtXCU7J4qxtaokZC2+uSmMJ2Qy7BC807dwPuWmGiNH/0480YArpndr2UkWbsDQU+BDU
 NGCMNGrOmXHCOjzWB+A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-28_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604280096

Correct the response to Benjamin's comments.

On 4/27/2026 8:20 PM, Linlin Zhang wrote:
> 
> 
> On 4/27/2026 9:19 AM, Benjamin Marzinski wrote:
>> On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
>>> From: Eric Biggers <ebiggers@google.com>
>>> +
>>> +static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
>>> +{
>>> +	const struct inlinecrypt_ctx *ctx = ti->private;
>>> +	sector_t sector_in_target;
>>> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
>>> +
>>> +	bio_set_dev(bio, ctx->dev->bdev);
>>> +
>>> +	/*
>>> +	 * If the bio is a device-level request which doesn't target a specific
>>> +	 * sector, there's nothing more to do.
>>> +	 */
>>> +	if (bio_sectors(bio) == 0)
>>> +		return DM_MAPIO_REMAPPED;
>>> +
>>> +	/*
>>> +	 * The bio should never have an encryption context already, since
>>> +	 * dm-inlinecrypt doesn't pass through any inline encryption
>>> +	 * capabilities to the layer above it.
>>> +	 */
>>> +	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
>>> +		return DM_MAPIO_KILL;
>>> +
>>> +	/* Map the bio's sector to the underlying device. (512-byte sectors) */
>>> +	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
>>> +	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
>>> +	/*
>>> +	 * If the bio doesn't have any data (e.g. if it's a DISCARD request),
>>> +	 * there's nothing more to do.
>>> +	 */
>>> +	if (!bio_has_data(bio))
>>> +		return DM_MAPIO_REMAPPED;
>>> +
>>> +	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
>>> +	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
>>> +	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
>>> +		return DM_MAPIO_KILL;
>>
>> If ctx->iv_offset is not a multiple of ctx->sector_size, this will
>> always fail. ctx->iv_offset should probably get validated in
>> inlinecrypt_ctr()
> 
> ACK
> 
> Yes, this assumes iv_offset is aligned to sector_size when large crypto
> sectors are used. That’s a requirement of dm-inlinecrypt semantics, and
> adding an explicit check in inlinecrypt_ctr() would make this fail earlier
> and more clearly.

Sorry, the last response is wrong. No need to add check in inlinecrypt_ctr().

iv_offset is the starting offset for IVs that are generated as if the target were
preceded by iv_offset 512-byte sectors.

I think this concern is based on an implicit assumption that
sector_in_target is always data-unit (crypto sector) aligned. In this
target, however, sector_in_target is derived from dm_target_offset() and
is in 512-byte sectors, so it is not guaranteed to be a multiple of
(sector_size >> SECTOR_SHIFT).

The intended alignment requirement is on the *final* DUN, i.e. on
(iv_offset + sector_in_target) in 512-byte sector units, before it gets
shifted down to crypto-sector units. That's why the code checks alignment
on the sum (iv_offset + sector_in_target).

With this definition, iv_offset itself does not need to be aligned to the
data-unit size; any non-negative value is valid as long as the resulting
DUN for a given bio is data-unit aligned. For example, iv_offset = 1 can
still be valid when sector_in_target is 7 (4096-byte sector case), since
their sum is aligned. Validating iv_offset alone in inlinecrypt_ctr()
would therefore reject configurations that are otherwise correct per the
(sum-based) DUN definition.

So I believe the runtime check in ->map() is the right place to enforce
the data-unit alignment constraint, as it has the actual bio offset
(sector_in_target) needed to evaluate the constraint.

Let me know if you'd prefer we document this more explicitly in the map()
argument description; I'm fine adding a short note about the
iv_offset units and the sum-based alignment rule.

> 
>>
>> -Ben
>>
>>> +	dun[0] >>= ctx->sector_bits - SECTOR_SHIFT; /* crypto sectors */
>>> +
>>> +	/*
>>> +	 * This check isn't necessary as we should have calculated max_dun
>>> +	 * correctly, but be safe.
>>> +	 */
>>> +	if (WARN_ON_ONCE(dun[0] > ctx->max_dun))
>>> +		return DM_MAPIO_KILL;
>>> +
>>> +	bio_crypt_set_ctx(bio, &ctx->key, dun, GFP_NOIO);
>>> +
>>> +	/*
>>> +	 * Since we've added an encryption context to the bio and
>>> +	 * blk-crypto-fallback may be needed to process it, it's necessary to
>>> +	 * use the fallback-aware bio submission code rather than
>>> +	 * unconditionally returning DM_MAPIO_REMAPPED.
>>> +	 *
>>> +	 * To get the correct accounting for a dm target in the case where
>>> +	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
>>> +	 * true), call __blk_crypto_submit_bio() directly and return
>>> +	 * DM_MAPIO_REMAPPED in that case, rather than relying on
>>> +	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
>>> +	 */
>>> +	if (__blk_crypto_submit_bio(bio))
>>> +		return DM_MAPIO_REMAPPED;
>>> +	return DM_MAPIO_SUBMITTED;
>>> +}
>>> +
<snip> 
>>> +MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
>>> +MODULE_AUTHOR("Linlin Zhang <linlin.zhang@oss.qualcomm.com>");
>>> +MODULE_DESCRIPTION(DM_NAME " target for inline encryption");
>>> +MODULE_LICENSE("GPL");
>>> -- 
>>> 2.34.1
>>>
>>
> 

