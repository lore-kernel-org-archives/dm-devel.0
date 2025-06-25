Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0EB26980C;
	Wed, 25 Jun 2025 14:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750862612; cv=none; b=r47/mzUoz7sM4Mzs4yV8Td9wD0qy8Mg6631U2W87rBVMOlV9XP8JXD7Cfau3O0ziTvnYEGuZA6OhkQQ64q7zSH17t56WFNk0Myk3t0gAevqFbXwwTPM0CgUkUkTSJ6a/jftN/b2WAJjnQ+Fl4eBs2M+vDIo6LatVyVuCQdSylh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750862612; c=relaxed/simple;
	bh=L8FnwvWzXJg7Zb5cl21tQ4VoScjAg5GYe1yFC+6Ye/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KAVCAZcVFj3UUZ+WB6DJcSmE8UBuGurol4zCG9pF9PT5FS2/lqjnbyYXdAl/eFXWR6vfMKp4IJrEQsnmhKA0AzVFvLU4Ztk2jipysilUE+epAv8rOEOzqqrZk8OdsLHclVn39C5f0SF+1AzT08alAwzjsLVkCJtCguHCsxDaXbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rbQb8qOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rbQb8qOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14F3C4CEEA;
	Wed, 25 Jun 2025 14:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750862610;
	bh=L8FnwvWzXJg7Zb5cl21tQ4VoScjAg5GYe1yFC+6Ye/8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rbQb8qOuMR57PDLUo8cpUMqwYJBX+zOQsf0/2PTqVj6P8BsvCnlOLvD98L+0oUPGl
	 YdeyBEWKl2BrWLlATnhs3SIL9XY1z8zsP2FyHOTCDXrZEZW75MYoyDtcHaC+QdsE1o
	 quwdTbPA/tUlZ4zliBDijE/6bPI+BM1qtDoj0jXIa++qyDkruHpXou9qWR2SyesDGX
	 kykyMYDU5WQZHZqvItVj5CwisPRDWBjrPXAyIFcCr/pTyEJ0g1ihRWATh5CCSOwsJg
	 q5UEfqNwTp9QAMQoOk9YtgSSXWu1cYXKQnu+HTUyj0Td52tM12kHtfDow79MfD6OT2
	 M1X2llWZvYzRw==
Message-ID: <40690cc0-e941-4db1-904c-a5d60718d852@kernel.org>
Date: Wed, 25 Jun 2025 23:43:28 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] dm: dm-crypt: Do not split write operations with
 zoned targets
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Bart Van Assche <bvanassche@acm.org>
References: <20250625055908.456235-1-dlemoal@kernel.org>
 <20250625055908.456235-4-dlemoal@kernel.org>
 <96831fd8-da1e-771f-7d19-8087d29f2af1@redhat.com>
 <07d71ad1-a6de-474b-bee4-a64180284802@kernel.org>
 <5c9898e1-3fae-d271-b0b8-a23371d22cb0@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5c9898e1-3fae-d271-b0b8-a23371d22cb0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/25 23:03, Mikulas Patocka wrote:
> 
> 
> On Wed, 25 Jun 2025, Damien Le Moal wrote:
> 
>> On 6/25/25 19:19, Mikulas Patocka wrote:
>>>
>>>
>>> On Wed, 25 Jun 2025, Damien Le Moal wrote:
>>>
>>>> +	bool wrt = op_is_write(bio_op(bio));
>>>> +
>>>> +	if (wrt) {
>>>> +		/*
>>>> +		 * For zoned devices, splitting write operations creates the
>>>> +		 * risk of deadlocking queue freeze operations with zone write
>>>> +		 * plugging BIO work when the reminder of a split BIO is
>>>> +		 * issued. So always allow the entire BIO to proceed.
>>>> +		 */
>>>> +		if (ti->emulate_zone_append)
>>>> +			return bio_sectors(bio);
>>>
>>> The overrun may still happen (if the user changes the dm table while some 
>>> bio is in progress) and if it happens, you should terminate the bio with 
>>> DM_MAPIO_KILL (like it was in my original patch).
>>
>> I am confused... Overrun against what ? We are now completely ignoring the
>> max_write_size limit so even if the user changes it, that will not affect the
>> BIO processing. If you are referring to an overrun against the zoned device
>> max_hw_sectors limit, it is not possible since changing limits is done with the
>> DM device queue frozen, so we are guaranteed that there will be no BIO in-flight.
>>
>> I am not sure about what kind of table change you are thinking of, but at the
>> very least,  dm_table_supports_size_change() ensure that there cannot be any
>> device size change for a zoned DM device. And given the above point about limits
>> changes, I do not see how a table change can affect the BIO execution.
>>
>> Do you have a specific example in mind ?
> 
> What happens if a bio that is larger than "BIO_MAX_VECS << PAGE_SHIFT" 
> enters dm_split_and_process_bio? Where will the bio be split? I don't see 
> it, but maybe I'm missing something.

See patch 3 of the v3 I sent: dm_zone_bio_needs_split() and
dm_split_and_process_bio() have been modified to always endup with need_split ==
true for zone write BIOs, and that causes a call to bio_split_to_limits(). So
dm-crypt will always see BIOs that are smaller than limits->max_hw_sectors,
which is set to BIO_MAX_VECS << PAGE_SECTORS_SHIFT in dm-crypt io_hint. So
dm-crypt can never see a write BIO that is larger than BIO_MAX_VECS << PAGE_SHIFT.


> 
> Mikulas
> 


-- 
Damien Le Moal
Western Digital Research
