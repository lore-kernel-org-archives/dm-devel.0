Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307CB1FDA94
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 12:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745324449; cv=none; b=kc6MRbm4Em64hBPc7RT/9GCb23S06nluJ8TUdBJK6G+Msg+IzAdMl17i+FtbfYxs5ZYrO/7M6g+gvpIBmp4JpgACMR+Cy4ICkE+gcq4Thr2+T9ev9xEQyI5wY8wRnPXgJnMWhct99n6f7ogBduATSMx05hz3QxHh1okW2ciIJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745324449; c=relaxed/simple;
	bh=tq4njeU/xWVTlR9ZAIvGapnbO0vbmpgPYUdvo9Qpwy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFfdlSzrx2VpzldK8QgSt7WgWYQFM+js9nalNF8jjBxCZ9rexejMQAKKhDRCCgJHKZEIAJXMGf9HMuvk4XVUAe5wR9ramY1N/efXOFE5xernUr0KFrhOgrX4UOGuA/tA0sVpp56f5rCHzTGFXBfc/RPkc0A9N+gRjyK5X1HxDIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAvVpymi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAvVpymi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4F5C4CEE9;
	Tue, 22 Apr 2025 12:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745324447;
	bh=tq4njeU/xWVTlR9ZAIvGapnbO0vbmpgPYUdvo9Qpwy4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aAvVpymilGdDjprPmh+vH3pu6V/g3culTLTJk93eAx04/AYFo0fEdCZXS7C5YRND3
	 fycLYwCKb1E9A4+65YWlcGGDh9AGNOElOEF7cbzzikPpoHM+b/0900B5Lr58E5nHmV
	 jBhswBcCF5YRxfM+heiKrQAK/js5JDrxATxKVgIcRBfYHa4f4IKnjBvDQ7He0/eD3k
	 enwNOb7Lkh85q+o8Oo87ovqBGb7c9sCCg3S0+kCIO1AcSrunDpzCrE6X/Ec+6C0JKa
	 JooAK7MqmaONPl9KWDjbKt52VTn4AroKgVU+fpQ+9yfssvbgdT7wTnwj9U5v5BG5Ji
	 xdgAn/9iRpCVA==
Message-ID: <6d4718f8-49c2-451f-8253-37a0ba039c80@kernel.org>
Date: Tue, 22 Apr 2025 21:20:45 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-delay: Prevent zoned write reordering on suspend
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Benjamin Marzinski <bmarzins@redhat.com>
References: <20250411000435.1007720-1-dlemoal@kernel.org>
 <81bd6eca-6d62-6934-9007-28eaef465bb7@redhat.com>
 <79733459-5674-4bd3-9a33-dd5fbd7ed651@kernel.org>
 <cadd3b0f-2eca-c8af-62e9-27dd528007bd@redhat.com>
 <222c2fac-ae6d-4b6a-8a83-a40eaf044d44@kernel.org>
 <d9c47917-0ff9-5d6a-01a3-cbb357ca6812@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <d9c47917-0ff9-5d6a-01a3-cbb357ca6812@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/22/25 20:27, Mikulas Patocka wrote:
> 
> 
> On Fri, 18 Apr 2025, Damien Le Moal wrote:
> 
>>> It seems that you want to send many small overlapping write bios - the 
>>> question is why? Why can't the application accumulate the content and send 
>>> it as one big bio?
>>
>> That is the application problem. On HDDs at least, small IOs will hurt
>> performance. SMR or not, same problem. Intellignet applications will try to
>> shape their workload to optimize performance. But that point is irrelevant here.
>> The kernel porvides a service: process write requests, regardless of how big
>> these requests are, if they are correct (i.e. for zoned devices, they must be
>> issued in order by the user), we must correctly execute the writes.
>>
>>> I'm a bit worried that supporting this ordering will just bloat the kernel 
>>> with marginal benefit.
>>
>> Bloat ?
> 
> We would need three states instead of two: normal, suspended, resuming (so 
> it would bloat all the device mapper logic with another state). There's 
> dm_wq_work using submit_bio_noacct, which wouldn't work, as it would 
> immediatelly enqueue the bio for suspend again, so we would need some 
> other path to submit the bio.
> 
> dm_wq_work would have to transition the device from the "resuming" state 
> to the "normal" state when it processes all the bios, but it is called for 
> various other reasons too.

It is not because you do not see a clean solution that there is not one. So
unless you have completely made up your mind already and are not willing to
accept any change in this area to improve things, I will dig into this and find
a solution that is not "bloat".

>> everything is already in place to preserve the order of write operations
>> to zoned devices, since a long time ago.
> 
> What if the controller doesn't preserve the order of writes? I think that 
> there was some bit for that, but I forgot its name. So we can simply not 
> set the bit for device mapper - and the applications will have to deal 
> with it by using write plugging.

I do not understand what you are talking about. A zoned DM device is zoned
because it is on top of a zoned device. That bottom zoned device may be another
DM target or a real zoned device. For the real zoned device, zone write plugging
is always used so it does not matter if the host controller does or does not
preserve command order. There will always be at most 1 in-flight write per zone,
which makes reordering of commands completely irrelevant for write commands success.

For DM, it is up to the target driver to determine if it is OK without zone
write plugging or if that will be needed, as the driver knows if it will
preserve (issue) writes in the same order it received them. E.g. dm-crypt does
not, so it sets the emulate zone append flag to use zone append emulation and
zone write plugging (note that these 2 aspects are aggregated into a single flag
because there was no need to control them separately for the existing DM targets
that support zones).

So I do not understand your point.

There are literally tens of millions of SMR drives running in production, a lot
of them using DM (e.g. dm-crypt). I would know if that was not working fine.

> 
>> What has not been covered are cases
>> like suspend/resume which may, depending on what they do, break the ordering
>> guarantees that we have for write requests. The only reason this has not been
>> fixed is because I completely overlooked these cases as zoned block devices were
>> in the past mostly used in enterprise systems where suspend/resume is not really
>> used at all. But we have zoned UFS devices these days (smart phones), so
>> properly supporting DM suspend/resume is important I think.
> 
> Do you mean zoned flash devices? I've never heard of them.

They exist and are gathering interest and use cases.


-- 
Damien Le Moal
Western Digital Research
