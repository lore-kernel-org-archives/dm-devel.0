Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5FC1A3AAD
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737144753; cv=none; b=mPLcr3lfq+EKWA5ud3hj5CFNguZ8yy8l9sazjMbS/JUBhYIrTERoTQXrB33cigsjY7ljGOpV2p/J+FST5Zkdh0teiWICOMgQXcfGW8FdbgigihAXbpxcOHdLUoFnQpmrETPGZ7dMXMIQfO7KrsYl8GyVIMhxSZlOqS/pDvxDxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737144753; c=relaxed/simple;
	bh=PeeGUPJl2smRX6KHteAej2YYpAbICq/sJBn/TI61EJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQvRixfUX5qp9kGwqvE3x6KQpVlUwUDH282y5jqNxFvyea4/gSKYIRAdy2t/S4sY/lzo6iPP0Xi7ZXb931kuO+kmiPvg03vypzlZv9LFb9/3IzumyUp9ppW9Duda2B+6jM1ptpEycoPwcZPRnxJnpBxCjeU2Yvb/LA0jlMIkQO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nuxxBjeV; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nuxxBjeV"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-84a1ce51187so80445239f.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737144750; x=1737749550; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zMbCrPJzL8yTFIs1neOfn76l0nRWVY5b3AebkpdHLgM=;
        b=nuxxBjeVJDTlXzBSx/sYgWO8NG/xAIMF0OaYfx3y70XKxep1ISC2hcxaiPhM1nyk3I
         zztJRZrgbI7YEvocMpwGyluRPflYhyP9X+o+24u202KEYsp/Jd17cw+OgxeIk8bp5SW2
         tPzObWa1FYTdylLHqbEvazk61ChL51UqMJvKr/S4ehep+QtpaOCaurm/l85GG80HISNG
         GRBFtS/L2DLu/Hocq1loXUx2PD0TSLYTvjIGUbNAqfbv4R5SKEUhrexc8Zv2I0e6KXdo
         3Dc7iFx7/brHbtOUiiUeHoyy4E6fJCUvpo462TM5LVkA/kEH5OFNE0GWtMlxpI2uDj/9
         3mwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737144750; x=1737749550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zMbCrPJzL8yTFIs1neOfn76l0nRWVY5b3AebkpdHLgM=;
        b=QtPlRIHKkYSeMyWVnoJgQZs88l3S9IrIW8PUEvoxADqM1mPpKGJhhrukSsTOzM0faW
         LPab3V5X4Q7Bai4UVE9JeWRzjbMk42gtg+8LtmAbz9x3WB8n5T8AqbZT6Yuu3SqS9VwL
         /HuoKgAGSArhW70YNlCVzxkMYTyu8AavgFOKcQJ28hOkVrysTFo58y0N/WkhaGX7DUt5
         41ja+O4PFtqsc7DZ9V1/bSbcExjR1DfRBzJGUQ25Du0k933IJfKqky1Pof3BYRktUvJ0
         G1W4ljJDVx/uxjq/C7GnxNNXiOCkxDlV3gyFxBNo3tgkUVxC0i0sUi9DjD9kuow6vPwv
         Y2+A==
X-Forwarded-Encrypted: i=1; AJvYcCX4llOcdt+bYvzLu90PNNGnBWmP5R267I4NCWkA2XyrcZ+1H2FxaYZtzcVL6T+palu1h/DmhtMqkA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzZg7Q3MkTrEuxv/zd0If5kL9gG3DH5noIGNP2eTsCVuidTjlD4
	tT6NJu/mltaKMDEbzHMH8lLx6lpS7JeUACHktyI0Kf2CGlDD/U3/o1sI5pp5GM8=
X-Gm-Gg: ASbGnctPBY1UhprnzaM2aewfiMF1aEYr5a1PoPm3dEL7sfSXDaUzlH7Efg73VowpDwA
	p3AqlmAxHElb5gFliSb7Z0dZ+SzrfKvUOtLCwdJQMAuYBT0roxesp3NWpV6H1gFsDF7gxKGcN9L
	t28voLRAQVyA0znPi98lfEyMJW/tXFR+KmmfJ6LVwJM1DFp/t1OzlENQ4N1bdoMhYRt5RtDkCee
	ep+dkIAXXw2JG81JmSMev3vKO8dI55G+U6njLwArnEGwL7dFon3qw==
X-Google-Smtp-Source: AGHT+IH0zo8wsg4X+Ob1gtuGKlznRlHPjHWRlLXjUWO5neR5ZhhSCiPRfv9A+0zKwVoXupgXoXN8hw==
X-Received: by 2002:a05:6602:6402:b0:841:a678:de3f with SMTP id ca18e2360f4ac-851b602f359mr303626939f.0.1737144750350;
        Fri, 17 Jan 2025 12:12:30 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea754964basm810406173.59.2025.01.17.12.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:12:29 -0800 (PST)
Message-ID: <fe80050f-a887-452b-b8f1-86f2ea816228@kernel.dk>
Date: Fri, 17 Jan 2025 13:12:28 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 0/8] device mapper atomic write support
To: Mike Snitzer <snitzer@kernel.org>, John Garry <john.g.garry@oracle.com>,
 mpatocka@redhat.com
Cc: agk@redhat.com, hch@lst.de, song@kernel.org, yukuai3@huawei.com,
 kbusch@kernel.org, sagi@grimberg.me, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org
References: <20250116170301.474130-1-john.g.garry@oracle.com>
 <Z4q45sjEih8vIC-V@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z4q45sjEih8vIC-V@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/25 1:09 PM, Mike Snitzer wrote:
> On Thu, Jan 16, 2025 at 05:02:53PM +0000, John Garry wrote:
>> This series introduces initial device mapper atomic write support.
>>
>> Since we already support stacking atomic writes limits, it's quite
>> straightforward to support.
>>
>> Personalities dm-linear, dm-stripe, and dm-raid1 are supported here, and
>> more personalities could be supported in future.
>>
>> This is still an RFC as I would like to test further.
>>
>> Based on 3d9a9e9a77c5 (block/for-6.14/block) block: limit disk max
>> sectors to (LLONG_MAX >> 9)
>>
>> Changes to v1:
>> - Generic block layer atomic writes enable flag and dm-table rework
>> - Add dm-stripe and dm-raid1 support
>> - Add bio_trim() patch
> 
> This all looks good.
> 
> Mikulas, we need Jens to pick up patches 1 and 2.  I wouldn't be
> opposed to him taking the entire set but I did notice the DM core
> (ioctl) version and the 3 DM targets that have had atomic support
> added need their version numbers bumped.  Given that, likely best for
> you (Mikulas) to pick up patches 3-8 after rebasing on Jens' latest
> for-6.14/block branch (once Jens picks up patches 1 and 2).
> 
> Jens, you cool with picking up patches 1+2 for 6.14?  Or too late and
> we circle back to this for 6.15?

I can do 1+2 for 6.14, they are pretty trivial.

-- 
Jens Axboe
