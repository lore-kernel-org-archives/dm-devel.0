Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA19EA927
	for <dm-devel@lists.linux.dev>; Thu, 17 Apr 2025 22:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744928116; cv=none; b=F/7x811ZRP5MHAcRDxRk6ceWD/nNFhOGITBg/zyieIJ507xGrKgr4gpn6v63pndWhCQ4LCFuVV1qsZ6NJfOfEhsoGaY0D3Z1nrj4eC6PSGupBmdgEsustCZm1Cg9K0Ps68LGYXblNX4PLFzMowza9WrU0GmQC0OZeRjSXFaHqHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744928116; c=relaxed/simple;
	bh=K89eLpU4Q0S95+tu0uniWzDyptRANuz2u7YWp9QpGPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s2nNGMnp+3JGwRQX/ZUEQlQqsU7FFeYKw/5rnMnEM/jdkFZluRbi2aAhj3iAjVtX3GCxDriD/iLsrj+eN5MpYde3q+ChLfDDdb0nvBNFhrXErU97zr2pTwcQ5qubiuxEq4KRYS8oylorXbXFRJjGcENwmjFcew9GrZJ8riPrkgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qoZzLbsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qoZzLbsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C92C4CEE4;
	Thu, 17 Apr 2025 22:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744928116;
	bh=K89eLpU4Q0S95+tu0uniWzDyptRANuz2u7YWp9QpGPk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qoZzLbsQm1UJFtc4DDF7427uIpC9F8L4q4vaH07HVru4nwVSdr5G5pdEBsAiwVkAg
	 hS19IbA1CAoEPu/NsqMJUbP+eJfji+RxX+UQpWC3EzYhFtZ/rt0Fhph0X1H+qHhlN3
	 sgZmbj15vkOiekkq0UGMEG/03wnsV0L9zJBo9hKhg1hqTTB1Uxc73bwzuYL7PA5Tbb
	 zi6on91Tat8ihcCuwyti+nhODYnQg5TSrJhcBqoPhUn92gqtHQEdA8SN26A/P+4VDI
	 kh6gmoW3iDshebfEGfgGnn+CBCxGvUtjW6+rBAoQO0kXY32hmKOgFY+wz0Hfh9GoZ9
	 KG3tLl/eSOW1g==
Message-ID: <222c2fac-ae6d-4b6a-8a83-a40eaf044d44@kernel.org>
Date: Fri, 18 Apr 2025 07:15:14 +0900
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
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <cadd3b0f-2eca-c8af-62e9-27dd528007bd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 21:45, Mikulas Patocka wrote:
> 
> 
> On Tue, 15 Apr 2025, Damien Le Moal wrote:
> 
>>> Hi
>>>
>>> I looked at the generic device mapper code and it seems that ordering of 
>>> write bios is not guaranteed with any target in case of suspend/resume.
>>>
>>> * we suspend the device:
>>> * received bios are added to md->deferred in queue_io
>>>
>>> * we resume the device:
>>> * __dm_resume calls dm_queue_flush
>>> * dm_queue_flush clears DMF_BLOCK_IO_FOR_SUSPEND and submits work item 
>>>   &md->work (dm_wq_work)
>>> * dm_resume clears DMF_SUSPENDED
>>> * the device starts accepting new bios in dm_submit_bio
>>> * dm_wq_work runs concurrently with new bios that are received, so 
>>>   ordering of bios is not preserved
>>>
>>> So it doesn't make much sense to try to fix it in dm-delay, if it isn't 
>>> supposed to work at all.
>>
>> Just need to fix the generic DM resume code then. This patch fixing dm-delay is
>> still relevant even with DM generic resume fixes.
>>
>> I can resend the dm-delay fix together with DM core resume fixes. And Benjamin
>> can re-send the dm-delay kthread timer cleanup independently (I will rebase) or
>> on top of that fix series. Does that work for you ?
> 
> I would like to know why is this needed. If you have a zoned device, you 
> can send one big write bio, wait for the big bio to finish, send another 
> big write bio, wait for it to finish and so on. Then, there will be at 
> most one write bio oustanding and you don't have to care about kernel 
> reordering in-flight bios.

Except for the "big" adjective in you remark, what you are describing is zone
write plugging, which will limit the number of in-flight write commands to at
most 1 per zone. That is already done for all zoned block devices at the low
level. For DM, we enable zone write plugging if and only if the DM target driver
ask for zone append emulation because the target driver cannot support native
zone append operations. E.g. dm-crypt does that so that all zone append
operations are turned into regular writes so that we can have the usual IV for
encryption be set to the written sector.

As for "send one big write bio", the "big" here completely depends on the device
user. We can only process what the user issues (FS or userland). The block layer
does not do write buffering.

> It seems that you want to send many small overlapping write bios - the 
> question is why? Why can't the application accumulate the content and send 
> it as one big bio?

That is the application problem. On HDDs at least, small IOs will hurt
performance. SMR or not, same problem. Intellignet applications will try to
shape their workload to optimize performance. But that point is irrelevant here.
The kernel porvides a service: process write requests, regardless of how big
these requests are, if they are correct (i.e. for zoned devices, they must be
issued in order by the user), we must correctly execute the writes.

> I'm a bit worried that supporting this ordering will just bloat the kernel 
> with marginal benefit.

Bloat ? everything is already in place to preserve the order of write operations
to zoned devices, since a long time ago. What has not been covered are cases
like suspend/resume which may, depending on what they do, break the ordering
guarantees that we have for write requests. The only reason this has not been
fixed is because I completely overlooked these cases as zoned block devices were
in the past mostly used in enterprise systems where suspend/resume is not really
used at all. But we have zoned UFS devices these days (smart phones), so
properly supporting DM suspend/resume is important I think.



-- 
Damien Le Moal
Western Digital Research
