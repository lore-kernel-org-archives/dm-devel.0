Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC862F83BC
	for <dm-devel@lists.linux.dev>; Wed, 26 Nov 2025 09:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764150517; cv=none; b=CnkGmEStWiDYdm12BPyhePkrpZUAjQprUHVP+Ckjg5giulu1akIsX2FgBuUVVqmumxz+c53fO2ShV7z7UKqEZEqHvGcSrIcP8C1WJ+LUmN8Ru2X6KrEWZITbF5EQ+qyZqR5jaG8n2MjOf3zGrGUH+db9W86h5Y6sbQWnPbyjQQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764150517; c=relaxed/simple;
	bh=k2LUdK6FS+XQMc9tndp/vVbp22kgK8zFNc0r41qaOW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DcK6/KsfrjVvGmdfNEt7Am+JAY0fG//WGHrUHN/DuxWUKTyTA6odhwWSW/6IK1I78yFQKxQPJucMb4ohNoE3xc+De0lLUlVehiDJT7sNJQORprmp7BxnXM0/aQWXP7leXfVfRUvdIpaq+geMLBlSXvxr7vX/petRIVvPNMZTiLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TT7zO865; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TT7zO865"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2956d816c10so75788695ad.1
        for <dm-devel@lists.linux.dev>; Wed, 26 Nov 2025 01:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764150515; x=1764755315; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8uMB3N5rvsdxpxdbhQ4/rwp3UTr0eB1Bcl9iSw80eIw=;
        b=TT7zO865HMxsYYyxWAiIQyMbPnZM+UILBMiBA63lb1gsQzteCD0YSlPAu6MGy4ZyNq
         0ji495/Md1oPkTaSe8Zp663Qwla2bq9EMRIGtmcG/Gb0fT9UF3ocKIK1vMVB4ULruTUK
         0/NNopCjTh5ASvrQIvVAzX3VvKc4MUsyc4paqgQ3FVIza8z/FGNZ00peR/mchzK9Cdye
         /dd9MibRTH7z/QtbF0ZImeUg9S3lHOmFiwmWRxf7B6ybm5m7h0wGUOVV2WndiBoBKTdk
         p7IV7ezYq3ERFeTBFIX6VH+J5y/6fyFXzBQ63C7oFgoaTHT20yHQtSBUPS0rvExiYG9n
         i2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764150515; x=1764755315;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8uMB3N5rvsdxpxdbhQ4/rwp3UTr0eB1Bcl9iSw80eIw=;
        b=F0yvQEO2eRZkI9cVm+H1lD5nAnsMh1Q2iF7pHJdjr+5VexBWwAh/sAf2ctegTXLazV
         qkJnThqy1nbph1ZX1Q7aHIZeOWxNOjUosN7aM8qnyfDymv29zAiZaQOsrdkV3bB1kMEE
         RLoEKmS2+Bm0zgIsnO1pSDjvpUWPWj1lXI9+OQTmhqkOUlEUOv7pt6UHvkoOttuP6DFT
         SBGJ7b8fbmnxIZt2DK+jRda8qIkoGhTK2vdmZ0pTTJNgUcn2zWWPpmU7y30topwTm5OO
         CdnOeF+ahiEZNeXNu6gw+AgslVDOrcRlTSv4HybbX7hzbhrKNFSQE4bOhTLJ4rT9Jop3
         WLOw==
X-Gm-Message-State: AOJu0Yz/oPzKJE2lRPwEpAamvUUtdorDb/WAF4pLMcXk6bvy1tYkyY/8
	gW+LANk/t8WmZmBMPWyrVvqOzJlhI45ruOBXoW11SSjqUAN8CHQopoAd
X-Gm-Gg: ASbGncuUF0uDpWWFg+nJxcdAQGbyvqP1B8gS8ZrQ0I5KiWBFPRAkDkDR2UN73uEas1U
	19xYCvAW9+WV8zLG5aepdbqVY1N3Orb8t/KsvLzElPDJw5ZXFC4+CSet877eRSCMg4ZZ7nUVWMJ
	qPTqdsWyz1E/DYXP3J3eo0uW68i0jR1o0mOzmi/wEv4Ai0psoDYWRjJyoQLptp0zaln2YnzyEql
	l99QrDuMHbXlobQe3y/VoMVnnWSLmuh0WqII1YuFiRPrcR75yx5cWLmGrKKxWl03sezTcaRZxk6
	NLri9ZC/D1j5Z7rTeQNRcug/NPsomnP43jC3Xabs6056D7uzC7QBBJYXHO59BDTjxD7FbHE6LZZ
	Nof7SxfTMvglHXEc4LxD4n4EYM29xOj548XF0ed+unrLuoC5a40XwK/RNpp0ZVVFpY0WWde0ItY
	QLcaynuxHyUh9EP5bKJpR0YG8Xs4pxKVfsKxFfmwqN
X-Google-Smtp-Source: AGHT+IF+9FtF7ayQC3G69Yp8vRWGltdYla+KBkYnRAEC4rmaUkKIhqBtAVHy/WEEjGIFeEh9j7Z8hw==
X-Received: by 2002:a17:90b:2ccc:b0:340:299f:130d with SMTP id 98e67ed59e1d1-34733e60971mr18027499a91.13.1764150514677;
        Wed, 26 Nov 2025 01:48:34 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476004dc3dsm1931007a91.9.2025.11.26.01.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 01:48:34 -0800 (PST)
Message-ID: <5a1387fd-4952-42e0-b7a9-e614f7b20325@gmail.com>
Date: Wed, 26 Nov 2025 17:48:28 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH V3 6/6] xfs: ignore discard return value
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>, "agk@redhat.com" <agk@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "mpatocka@redhat.com" <mpatocka@redhat.com>,
 "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com" <yukuai@fnnas.com>,
 "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "chao@kernel.org"
 <chao@kernel.org>, "cem@kernel.org" <cem@kernel.org>
Cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Yongpeng Yang <yangyongpeng@xiaomi.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-7-ckulkarnilinux@gmail.com>
 <b18c489f-d6ee-4986-94be-a9aade7d3a47@gmail.com>
 <218f0cd0-61bf-4afa-afb0-a559cd085d4a@nvidia.com>
 <2da95607-9b21-4d21-8926-9463021a6f33@gmail.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <2da95607-9b21-4d21-8926-9463021a6f33@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/26/25 17:14, Yongpeng Yang wrote:
> On 11/26/25 16:07, Chaitanya Kulkarni via Linux-f2fs-devel wrote:
>> On 11/25/25 18:37, Yongpeng Yang wrote:
>>>> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
>>>> index 6917de832191..b6ffe4807a11 100644
>>>> --- a/fs/xfs/xfs_discard.c
>>>> +++ b/fs/xfs/xfs_discard.c
>>>> @@ -108,7 +108,7 @@ xfs_discard_endio(
>>>>     * list. We plug and chain the bios so that we only need a single
>>>> completion
>>>>     * call to clear all the busy extents once the discards are 
>>>> complete.
>>>>     */
>>>> -int
>>>> +void
>>>>    xfs_discard_extents(
>>>>        struct xfs_mount    *mp,
>>>>        struct xfs_busy_extents    *extents)
>>>> @@ -116,7 +116,6 @@ xfs_discard_extents(
>>>>        struct xfs_extent_busy    *busyp;
>>>>        struct bio        *bio = NULL;
>>>>        struct blk_plug        plug;
>>>> -    int            error = 0;
>>>>          blk_start_plug(&plug);
>>>>        list_for_each_entry(busyp, &extents->extent_list, list) {
>>>> @@ -126,18 +125,10 @@ xfs_discard_extents(
>>>>              trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
>>>>    -        error = __blkdev_issue_discard(btp->bt_bdev,
>>>> +        __blkdev_issue_discard(btp->bt_bdev,
>>>>                    xfs_gbno_to_daddr(xg, busyp->bno),
>>>>                    XFS_FSB_TO_BB(mp, busyp->length),
>>>>                    GFP_KERNEL, &bio);
>>>
>>> If blk_alloc_discard_bio() fails to allocate a bio inside
>>> __blkdev_issue_discard(), this may lead to an invalid loop in
>>> list_for_each_entry{}. Instead of using __blkdev_issue_discard(), how
>>> about allocate and submit the discard bios explicitly in
>>> list_for_each_entry{}?
>>>
>>> Yongpeng,
>>
>>
>> Calling __blkdev_issue_discard() keeps managing all the bio with the
>> appropriate GFP mask, so the semantics stay the same. You are just
>> moving memory allocation to the caller and potentially looking at
>> implementing retry on bio allocation failure.
>>
>> The retry for discard bio memory allocation is not desired I think,
>> since it's only a hint to the controller.
> 
> Agreed. I'm not trying to retry bio allocation inside the
> list_for_each_entry{} loop. Instead, since blk_alloc_discard_bio()
> returning NULL cannot reliably indicate whether the failure is due to
> bio allocation failure, it could also be caused by 'bio_sects == 0', I'd
> like to allocate the bio explicitly.
> 
>>
>> This patch is simply cleaning up dead error-handling branches at the
>> callers no behavioral changes intended.
>>
>> What maybe useful is to stop iterating once we fail to allocate the
>> bio [1].
>>
>> -ck
>>
>> [1] Potential addition on the top of this to exit early in discard loop
>>       on bio allocation failure.
>>
>> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
>> index b6ffe4807a11..1519f708bb79 100644
>> --- a/fs/xfs/xfs_discard.c
>> +++ b/fs/xfs/xfs_discard.c
>> @@ -129,6 +129,13 @@ xfs_discard_extents(
>>                                   xfs_gbno_to_daddr(xg, busyp->bno),
>>                                   XFS_FSB_TO_BB(mp, busyp->length),
>>                                   GFP_KERNEL, &bio);
>> +               /*
>> +                * We failed to allocate bio instead of continuing the 
>> loop
>> +                * so it will lead to inconsistent discards to the disk
>> +                * exit early and jump into xfs_discard_busy_clear().
>> +                */
>> +               if (!bio)
>> +                       break;
> 
> I noticed that as long as XFS_FSB_TO_BB(mp, busyp->length) is greater
> than 0 and there is no bio allocation failure, __blkdev_issue_discard()
> will never return NULL. I'm not familiar with this part of the xfs, so
> I'm not sure whether there are cases where 'XFS_FSB_TO_BB(mp,
> busyp->length)' could be 0. If such cases do not exist, then
> checking whether the bio is NULL should be sufficient.
> 
> Yongpeng,

If __blkdev_issue_discard() requires multiple calls to
blk_alloc_discard_bio(), once the first bio allocation succeeds, it will
never result in bio == NULL, meaning that any subsequent bio allocation
failures cannot be detected.

Yongpeng,

> 
>>           }
>>           if (bio) {
>> > If we keep looping after the first bio == NULL, the rest of the 
>> range is
>> guaranteed to be inconsistent anyways, because every subsequent iteration
>> will fall into one of three cases:
>>
>> - The allocator keeps returning NULL, so none of the remaining LBAs 
>> receive
>>     discard.
>> - Rest of the allocator succeeds, but we’ve already skipped a chunk, 
>> leaving
>>     a hole in the discard range.
>> - We get intermittent successes, which produces alternating chunks of
>>     discarded and undiscarded blocks.
>>
>> In each of those scenarios, the disk ends up with a partially discarded
>> range, so the correct fix is to break out of the loop immediately and
>> proceed to xfs_discard_busy_clear() once the very first allocation fails.
