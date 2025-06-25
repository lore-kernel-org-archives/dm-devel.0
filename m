Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E252D3EC5;
	Wed, 25 Jun 2025 23:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750894726; cv=none; b=tp60s5fmhuIs/L5+fPInBeiBAETEK12q0iRLFY6GHP+A+K+CxYFCcen7ZnIE6+Gcy74urBYDXZREVJSD02oDG9dd+Ubr/IjQmBu7nZd2CVkkPdm4jNx42wc7G4MxPPhepXF0PgGN44djsqsoSUKsOk4OB8RY3dB9+hu1f7kCu2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750894726; c=relaxed/simple;
	bh=yoP7rliJAMnc9KH20FCuVDkCsV/SFjr3V2ZB62VeL3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=C68Ws+UCAwYO/aEZUVS27D9yvP1Bc68n6WxTia9MpsJVRF6/z+mdnglqFwIOrS0yYb5lX9AG2dYQxEnh0IjDgwHOFEXEOOwy8jD4oqwDZFvkIVFzzTfVuRph9rKslP8+nlF+Xs0K0IKF7k9vC78tpvGNtrJOs7rBg9l0W7jvRxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JE8EwAJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JE8EwAJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0201C4CEEA;
	Wed, 25 Jun 2025 23:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750894725;
	bh=yoP7rliJAMnc9KH20FCuVDkCsV/SFjr3V2ZB62VeL3o=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=JE8EwAJLVAPBPLdCtv0ZpFG0wW8C2UgGJbRINY/vlmCtxZgIkXADuIlIsC51ldMs8
	 P4TGV9shYPeNoa77lCSG+nI1vL5A6d95/sVBCHJC+j+Nwa1KSlE8nV5DrOkkwID5h5
	 0OMNYdiwFrxnsVhxBIHodfLVtflb3jgKf6Gdxxvb2BDBU0sxPnCB+B2NCqu2tp0taP
	 1go+C5u1J1ATWLATgFJxI13QIXN5BqJjXpSQ0/fGtIRexiXAUssoJ68JTNxbBlAHoj
	 rsSyomTCJdzFBI3kZyge7wURioUaFVq9dBP28OK2plx+ySSaU41hPvFSS52pzvnjtQ
	 pqr0omVmYg40g==
Message-ID: <0a3b97e5-ba1e-4f4e-90c5-07cb2dfeee07@kernel.org>
Date: Thu, 26 Jun 2025 08:38:43 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] block: Introduce bio_needs_zone_write_plugging()
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250625093327.548866-1-dlemoal@kernel.org>
 <20250625093327.548866-3-dlemoal@kernel.org>
 <38ddf5f9-80e4-4909-b5cc-cef0ffce19dd@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <38ddf5f9-80e4-4909-b5cc-cef0ffce19dd@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/26/25 00:48, Bart Van Assche wrote:
> On 6/25/25 2:33 AM, Damien Le Moal wrote:
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 4806b867e37d..0c61492724d2 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -3169,8 +3169,10 @@ void blk_mq_submit_bio(struct bio *bio)
>>   	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
>>   		goto queue_exit;
>>   
>> -	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs))
>> -		goto queue_exit;
>> +	if (bio_needs_zone_write_plugging(bio)) {
>> +		if (blk_zone_plug_bio(bio, nr_segs))
>> +			goto queue_exit;
>> +	}
> 
> Why nested if-statements instead of keeping "&&"? I prefer "&&".

I did this because bio_needs_zone_write_plugging() is inline and
blk_zone_plug_bio() is not, so this ensures that we do not have the function
call for nothing. Though I may be overthinking this since normally, the
generated assembler will not test the second part of a && condition if the first
part is false already.


-- 
Damien Le Moal
Western Digital Research
