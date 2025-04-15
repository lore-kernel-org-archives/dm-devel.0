Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCC327A135
	for <dm-devel@lists.linux.dev>; Tue, 15 Apr 2025 08:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744704548; cv=none; b=mGf9H3ivPqPFg+wuOKyU2PjVY0Mbjx2JCd/YTir35NNkHizzheCyC16Yog863f61mQm4ZdW6/fPKp81/FkjGoNOO0Q98X5RrQrTNshhXsXkE1f4BqYDmVI2buxUUh3lOFcRLu/X57NoVP+aunKdMieHDXHBcx/sXXeUeuFBRWd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744704548; c=relaxed/simple;
	bh=rooBHucPKIEoppmVDj+wpP5zhNm4lIedv0liUDOtmlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P+MjcEF9RaKBE6mjF6Lzlk5QMM2h5ZKTU3DZC6NC1B2wJ+6Tlgp9FLNHCIyJd3j8AgG2nRY44oMS03/BsxSAGDCJpNEa4oMir8kOWi/VTNYI0u4cwf0j5Os/lrDmMYTCmhxwUC+SQJFlJxYRRXw3VGxvjlpfjY0/BgLWL2fWubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3zdj7C0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3zdj7C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5464AC4CEDD;
	Tue, 15 Apr 2025 08:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744704548;
	bh=rooBHucPKIEoppmVDj+wpP5zhNm4lIedv0liUDOtmlM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B3zdj7C0r/4sNyJYO4yXxa7R8JkqKOg0VmxK5busXRY2B4n/NWLLiIPc7brrD6DRk
	 Ka6HDFZ2m4eZgamU8qkB/3bo09o0X3gq6XPAA8Bwh/xtPH5tr9j6NCuCRW3odth1Ee
	 CiOA3kJvCfiHHYtZEus3FEfPIXVzctsXds2lSYQmO86s+MEXkRCImyALDuvYDoNLRq
	 99n+34DfV5VtlhibJdE3K2063mdqeyd/pRG4Sif9lLHcGsGbyyyeztbSCsiqCN355a
	 s0ItvGgrxZ13EL4kBMzuLeClepmz38tVp6IQYQbsNwNmhOeat9OpFBYLqSUU0JddmF
	 Emg0IWo79TDBA==
Message-ID: <79733459-5674-4bd3-9a33-dd5fbd7ed651@kernel.org>
Date: Tue, 15 Apr 2025 17:08:20 +0900
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
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <81bd6eca-6d62-6934-9007-28eaef465bb7@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/14/25 10:19 PM, Mikulas Patocka wrote:
> 
> 
> On Fri, 11 Apr 2025, Damien Le Moal wrote:
> 
>> When a dm-delay device is being suspended, the .presuspend() operation
>> is first executed (delay_presuspend()) to immediately issue all the BIOs
>> present in the delayed list of the device and also sets the device
>> may_delay boolean to false. At the same time, if any new BIO is issued
>> to the device will not be delayed and immediately issued with
>> delay_bio() returning DM_MAPIO_REMAPPED. This creates a situation where
>> potentially 2 different contexts may be issuing write BIOs to the same
>> zone of a zone device without respecting the issuing order from the
>> user, that is, a newly issued write BIO may be issued before other write
>> BIOs for the same target zone that are in the device delayed list. If
>> such situation occurs, write BIOs may be failed by the underlying zoned
>> device due to an unaligned write error.
>>
>> Prevent this situation from happening by always handling newly issued
>> write BIOs using the delayed list of BIOs, even when the device is being
>> suspended. This is done by forcing the use of the worker kthread for
>> zoned devices, and by modifying flush_worker_fn() to always flush all
>> delayed BIOs if the device may_delay boolean is false.
>>
>> Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
>> Fixes: d43929ef65a6 ("dm-delay: support zoned devices")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>> Changes from v1:
>>  - Fixed typo in commit message
>>  - Added reported-by tag
>>
>>  drivers/md/dm-delay.c | 29 +++++++++++++++++++++--------
>>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> Hi
> 
> I looked at the generic device mapper code and it seems that ordering of 
> write bios is not guaranteed with any target in case of suspend/resume.
> 
> * we suspend the device:
> * received bios are added to md->deferred in queue_io
> 
> * we resume the device:
> * __dm_resume calls dm_queue_flush
> * dm_queue_flush clears DMF_BLOCK_IO_FOR_SUSPEND and submits work item 
>   &md->work (dm_wq_work)
> * dm_resume clears DMF_SUSPENDED
> * the device starts accepting new bios in dm_submit_bio
> * dm_wq_work runs concurrently with new bios that are received, so 
>   ordering of bios is not preserved
> 
> So it doesn't make much sense to try to fix it in dm-delay, if it isn't 
> supposed to work at all.

Just need to fix the generic DM resume code then. This patch fixing dm-delay is
still relevant even with DM generic resume fixes.

I can resend the dm-delay fix together with DM core resume fixes. And Benjamin
can re-send the dm-delay kthread timer cleanup independently (I will rebase) or
on top of that fix series. Does that work for you ?

> 
> Mikulas
> 


-- 
Damien Le Moal
Western Digital Research
