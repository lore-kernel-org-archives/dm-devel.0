Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0833307498;
	Wed, 25 Jun 2025 06:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750832264; cv=none; b=Ma7mt2sX7aCVWwqhn5yZaQXQILNXGxXh8QZ8nHB0ujkFgRLb0I56GKmZjq8Ti08VEgtel6rG4GJozeIwp1NyjSUYBGDFUOdr+YhSdcUfbwa7g+xKGsG5Qe5g41zvAEVu8fU44rFxA3YPLeutZTBrj03UZCsmwF0qTuQ9OVTi4bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750832264; c=relaxed/simple;
	bh=n7QaiHu9HqfZ6NlbIgVKBfzgepFUcUlELNtjXtJqMUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AV3oo1BZZ7lnd3HSes0/VELskdynVsGkbs4xnnx8PvIR+JfHf9+9DfU8i3E7mdzZu7gaXHwZ9qubDYyVUdKWo02iN2ZF90nzqt6eycY1Z+nIwxWdz0jmvmvCXwWxaVH8FP5ZdmMKxJMn6BbaeBW8BwYTW7/NCjyxqxUxm8aHww4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvwguelY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvwguelY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B54C4CEEA;
	Wed, 25 Jun 2025 06:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750832264;
	bh=n7QaiHu9HqfZ6NlbIgVKBfzgepFUcUlELNtjXtJqMUw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XvwguelYHfu+9XfpqPhpmY8bQxrrVI2XT1fjbgb132SGqVvqxG0KoFtOARf8IYyUT
	 Yd2rFADdeJN3fw8cMBhItvCBlhDUgp7qjMiiNE0T96xideqlFkCUt8zdriH68pueOn
	 PbrEk/2VY/c1sbFtE91IGFUTCwbZGuQKAj5g+3TfxFNLj06bC/KZT04AH5DU9pqX9q
	 AQK+mAU89WgvtNxHDcqd6Vxxb7+9L5tbaLygLqDekYBXT54/NJFrDlRpzts0ommJ+g
	 AZ/sQWPek+cLFcMNN5yOBCQxz2OcyfmqGyPjItZTKoj758PaFEhmE8+6542DepJeEP
	 SICZ4ZDxg2vQQ==
Message-ID: <0e94af0a-3a85-49ba-a7fa-bbbf9f29ec51@kernel.org>
Date: Wed, 25 Jun 2025 15:15:39 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] dm: Always split write BIOs to zoned device limits
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Bart Van Assche <bvanassche@acm.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
 <20250625055908.456235-3-dlemoal@kernel.org> <aFuT_X8GdNwRU9AF@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aFuT_X8GdNwRU9AF@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 3:15 PM, Christoph Hellwig wrote:
> On Wed, Jun 25, 2025 at 02:59:06PM +0900, Damien Le Moal wrote:
>> Any zoned DM target that requires zone append emulation will use the
>> block layer zone write plugging. In such case, DM target drivers must
>> not split BIOs using dm_accept_partial_bio() as doing so can potentially
>> lead to deadlocks with queue freeze operations. Regular write operations
>> used to emulate zone append operations also cannot be split by the
>> target driver as that would result in an invalid writen sector value
>> return using the BIO sector.
>>
>> In order for zoned DM target drivers to avoid such incorrect BIO
>> splitting, we must ensure that large BIOs are split before being passed
>> to the map() function of the target, thus guaranteeing that the
>> limits for the mapped device are not exceeded.
>>
>> dm-crypt and dm-flakey are the only target drivers supporting zoned
>> devices and using dm_accept_partial_bio().
> 
> Is there any good way to catch usage dm_accept_partial_bio on zone
> devices so that issues like this don't get reintroduced later?

patch 4 does that. Though with the heavy BUG_ON() hammer. That can be cleaned
up later though.


-- 
Damien Le Moal
Western Digital Research
