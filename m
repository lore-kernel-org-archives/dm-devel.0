Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54422170F;
	Mon, 10 Mar 2025 23:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741649256; cv=none; b=YQ2vTO6z2a4BMeYQlAsYGQKR9gv+LlytEnwBPgfyhSZdQUnVG4kOPkdqKytLK0L0F7kHPP0b3Dm6VqdpsSxn6YgLUd4RjycqbSrWS+iJjo95JYaNdFqROuoiR/D8aMVXRLvGSWasJFGgocwj4yHtnKytOh8wccTjEF1SCMf+IfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741649256; c=relaxed/simple;
	bh=Nhfos4r2JyzaqDBHmpwbDUQG/Z4zLQP/uCRP2Hz8yVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dud6Pgjp89ZdKycjz5V4DAAooMUmQtPYQoI79H+Y2FzsGwtWm9QTQ/8/B5yz9ApmORhQm+w3UEoHMZZKeyO8DaqRLzMasinTm/32FuLEauzz+DWJlv7tFXEDKELMowWOffoHk9e9Qxqq5kYVrA7qkAxm5OSz67RPpoVjPkGqD2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9TD4Kg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9TD4Kg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA623C4CEE5;
	Mon, 10 Mar 2025 23:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741649255;
	bh=Nhfos4r2JyzaqDBHmpwbDUQG/Z4zLQP/uCRP2Hz8yVg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p9TD4Kg9KByfiH8pr264cFPuTjs56+W7Ko8WLCofagLG8rOAjV1XhmkkXm97v+UO/
	 bYxCiyjXeFJcKLoW/ShCMjLSaKpG2zrePILOO68UPQHbfRhpXYLuf1AfKJF8nYtw6U
	 fRMSNSx5ayROOp/FLaG3zOorwIpMNppCIsncTAGyqGhBrEVZcdZDJEFeA54kUGnvGO
	 8Ag3D5U3Eo1Nnofs/CpldDmQZyQ1zO8GG3iB3SdhiLs1H8jt0VHHf7fxwe9FuSsccq
	 orQi7c0OhDtfcvWHu/hPP9tMkqT+eR7K95/EbyCzg6DfxSbYDVsWWhaExwuxfAIDcg
	 KmJhvg23ejdtg==
Message-ID: <60f0f94c-3c80-4806-82aa-04ace428b4d4@kernel.org>
Date: Tue, 11 Mar 2025 08:27:34 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] dm: handle failures in dm_table_set_restrictions
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-4-bmarzins@redhat.com>
 <9b5ff861-964d-472c-9267-5e5b10186ed3@kernel.org>
 <Z88jTxQqoLitl4ee@redhat.com> <Z88sP2WyotRbTd2E@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z88sP2WyotRbTd2E@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 03:15, Benjamin Marzinski wrote:
>>>> @@ -1883,6 +1879,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>>>>  	if (dm_table_supports_atomic_writes(t))
>>>>  		limits->features |= BLK_FEAT_ATOMIC_WRITES;
>>>>  
>>>> +	old_limits = q->limits;
>>>
>>> I am not sure this is safe to do like this since the user may be simultaneously
>>> changing attributes, which would result in the old_limits struct being in an
>>> inconsistent state. So shouldn't we hold q->limits_lock here ? We probably want
>>> a queue_limits_get() helper for that though.
>>>
>>>>  	r = queue_limits_set(q, limits);
>>>
>>> ...Or, we could modify queue_limits_set() to also return the old limit struct
>>> under the q limits_lock. That maybe easier.
>>
>> If we disallow switching between zoned devices then this is unnecssary.
> 
> Err.. nevermind that last line. There are still multiple cases where we
> could still fail here and need to fail back to the earlier limits. But
> I'm less sure that it's really necessary to lock the limits before
> reading them. For DM devices, I don't see a place where a bunch of
> limits could be updated at the same time, while we are swapping tables.
> An individual limit could get updated by things like the sysfs
> interface. But since that could happen at any time, I don't see what
> locking gets us. And if it's not safe to simply read a limit without
> locking them, then there are lots of places where we have unsafe code.
> Am I missing something here?

Yes, for simple scalar limits, I do not think there is any issue. But there are
some cases where changing one limit implies a change to other limits when the
limits are committed (under the limits lock). So my concern was that if the
above runs simultaneously with a queue limits commit, we may endup with the
limits struct copy grabbing part of the new limits and thus resulting in an
inconsistent limits struct. Not entirely sure that can actually happen though.
But given that queue_limits_commit_update() does:

	q->limits = *lim;

and this code does:

	old_limits = q->limits;

we may endup depending on how the compiler handles the struct copy ?


-- 
Damien Le Moal
Western Digital Research
