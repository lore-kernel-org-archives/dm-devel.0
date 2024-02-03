Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9485C8F8
	for <dm-devel@lists.linux.dev>; Sat,  3 Feb 2024 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706962313; cv=none; b=XFp/f/nXmZtK2YzARkr0tylF4KSEzXj+Hu9W0fiOQQd2wfpTNIHo1Gu71HiitDpBb04fSqMwHhRvYaStyBoZ96tXhxTsSpU7AvJqkYZ7rZRUEoa4gZbZP6/QNqSCu9khgh7CijiZqSxqnuP8VdIlnSFgJyIqPXi9JwKULGRpSRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706962313; c=relaxed/simple;
	bh=NKqKivxBa1UrOQdEFxuztVX+NR+bchaWhMeL9Kg6RHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmZexVshHHh41Yvz8BoX4dt68OG9Eiu4hQ8B0Aou8rT8x5lzzhCCLPcYHbVlXkcAs8ofynsc6tvKWOJWRwGUtbmxrROI8xfvAVLhaYv9s1Xlj/P7PKR4v9yhzILbRAeemhBgATD+Cquxs8jeJ8Cq15dnA2dSJK3rdd/MeqM+HBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FHzPMyrW; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FHzPMyrW"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3bc21303a35so912744b6e.0
        for <dm-devel@lists.linux.dev>; Sat, 03 Feb 2024 04:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706962310; x=1707567110; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W6At8w3BY+bHriEibzEnUgO2+DI0oRR4cvw0MljHLkA=;
        b=FHzPMyrWJ6gNVLNW14HEUiV4JsLoWSZfsnr1EHpHD2L6EkpbBv8S5uH7Hb5uXHVj9U
         XXYHHFXQIiZszDu82Y8oEfsYBmv//Xe7AD8xVLrHjB/6k3uHlA4LPWIgU7uJfRHbXdTZ
         WuFBYb3aggjwswOGDl563P1A4/69RpnCxnO+Sbfq4buj1J4yI+W8tQi/E9x8AAp9c3gX
         /WXwvtS+4O8YfGfiJ5fTWesPBiAewyN8Ob4oUcPbszJtis41ENzYZDpmob6pWzDfYnuc
         Iy4NcYDgVO/RHgWVu764mJtjlZZ9C8ClSvHt444vzR5EEtSN7W4TXHllwXaDGxipQu5l
         AVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706962310; x=1707567110;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W6At8w3BY+bHriEibzEnUgO2+DI0oRR4cvw0MljHLkA=;
        b=hhqsRy4dj26iilz84FLvFf2Y6y9ZzO3o1WQeQNN1G+75bP6N6g3YSWXxdAsEqDHh73
         lPB6eOS3BXMDUV1WXO1PziE7mNJQp1ggZu6RufSL4uwbVF/3IvimscYDhPIRTo6NRj65
         6H1HYapYNCivWE+yS8HSEOdigiSMI0kGq21GS5uodjSNgwIiiLLvvKnupyflfv3Nqr8R
         ATGzh0bMK/0pLl1GNNZ9RaYB4tyw6tC9hggesS/iAXSBu4N36lukSlYxpmPN+AMw3FcK
         bZl1kGciwdJzXAN+TR56CXxazW0YjHdh3Br1mySTkUZxduMFV4dgmxa6ufC6Obvyn8Hi
         cmnQ==
X-Forwarded-Encrypted: i=0; AJvYcCXilbUMgFBmmx77A0zZE5zPYEYIH03K6iyLTngnhAeCF7y86HiQ3Cx2y9dnX24yl3gofpg0+d3k7ePdS5EKbGeC8F6zM8FXzV0=
X-Gm-Message-State: AOJu0Yw5d3sjclWke73vAicpZVhBZ9Vt/eMsAaPEsryGoM/E0TmPpKm5
	fuP6UAWYjAU8z1OOvEwnMD2fs6X6n2rJLcsXY2luywRfUOp4/bSKp9OiMA8l3Es=
X-Google-Smtp-Source: AGHT+IHqU4+fGOqr+6hwk36/z50UDpr7B1lwfquHREOClNc/Ohn+gEBSJJY/qwk/nminNs/414tyZA==
X-Received: by 2002:a4a:a787:0:b0:59c:7c63:928f with SMTP id l7-20020a4aa787000000b0059c7c63928fmr8736332oom.0.1706962310299;
        Sat, 03 Feb 2024 04:11:50 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWw+Y7AW9dyMB0A0M0XJRjY7ktYhP9Rs6oOd4pjM3Nn23QgvIv2kdSR8OtCYTZbFONZNotZbS/djXmBPiB5wK8MshAwqwVzOHXqYP3QikyM9c5lEiOO9fkF9xPMfdQ8gKSpyPao5UBzBEKLARyyNp9OGzklmYmjlsJC5duJwSmlDhvH7tEAGdm52Cs1CVEXwgwEL8GgSSx7foRnA0CQU/6FpNZedtv8nWbAM/0cIzgWin8=
Received: from ?IPV6:2600:380:9b5a:c5dd:b564:550c:8958:e9dc? ([2600:380:9b5a:c5dd:b564:550c:8958:e9dc])
        by smtp.gmail.com with ESMTPSA id y6-20020a4ab406000000b0059a9652eee4sm814630oon.25.2024.02.03.04.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 04:11:49 -0800 (PST)
Message-ID: <a387f08c-05c1-4c47-8ba1-27493b7853ef@kernel.dk>
Date: Sat, 3 Feb 2024 05:11:47 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <147de7c4-7050-4b1d-a48c-c0316a81baee@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <147de7c4-7050-4b1d-a48c-c0316a81baee@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/24 12:37 AM, Damien Le Moal wrote:
> On 2/2/24 16:30, Damien Le Moal wrote:
>> The patch series introduces zone write plugging (ZWP) as the new
>> mechanism to control the ordering of writes to zoned block devices.
>> ZWP replaces zone write locking (ZWL) which is implemented only by
>> mq-deadline today. ZWP also allows emulating zone append operations
>> using regular writes for zoned devices that do not natively support this
>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>> driver and device mapper zone append emulation to use ZWP emulation.
>>
>> Unlike ZWL which operates on requests, ZWP operates on BIOs. A zone
>> write plug is simply a BIO list that is atomically manipulated using a
>> spinlock and a kblockd submission work. A write BIO to a zone is
>> "plugged" to delay its execution if a write BIO for the same zone was
>> already issued, that is, if a write request for the same zone is being
>> executed. The next plugged BIO is unplugged and issued once the write
>> request completes.
>>
>> This mechanism allows to:
>>  - Untangle zone write ordering from the block IO schedulers. This
>>    allows removing the restriction on using only mq-deadline for zoned
>>    block devices. Any block IO scheduler, including "none" can be used.
>>  - Zone write plugging operates on BIOs instead of requests. Plugged
>>    BIOs waiting for execution thus do not hold scheduling tags and thus
>>    do not prevent other BIOs from being submitted to the device (reads
>>    or writes to other zones). Depending on the workload, this can
>>    significantly improve the device use and the performance.
>>  - Both blk-mq (request) based zoned devices and BIO-based devices (e.g.
>>    device mapper) can use ZWP. It is mandatory for the
>>    former but optional for the latter: BIO-based driver can use zone
>>    write plugging to implement write ordering guarantees, or the drivers
>>    can implement their own if needed.
>>  - The code is less invasive in the block layer and in device drivers.
>>    ZWP implementation is mostly limited to blk-zoned.c, with some small
>>    changes in blk-mq.c, blk-merge.c and bio.c.
>>
>> Performance evaluation results are shown below.
>>
>> The series is organized as follows:
> 
> I forgot to mention that the patches are against Jens block/for-next
> branch with the addition of Christoph's "clean up blk_mq_submit_bio"
> patches [1] and my patch "null_blk: Always split BIOs to respect queue
> limits" [2].

I figured that was the case, I'll get both of these properly setup in a
for-6.9/block branch, just wanted -rc3 to get cut first. JFYI that they
are coming tomorrow.

-- 
Jens Axboe

