Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE10D28C2AF
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 14:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751293020; cv=none; b=J5yLjYL5DCrCv8mPpcclPg9w/r2iPJPIt91W6cCwf3Pfae9KFtB7ZSdyVDSX5Mo/Dy9fO/9dVjrzou1HZtkXFTmxPrBj0o6QPL6Vvj/o/lEoJPnlCCJG7U7Vl0GucZAWBb+StcQO0U5PbTJi+zREROMTEklOT1+kGwUFwG0scoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751293020; c=relaxed/simple;
	bh=DsBq9tZtAD9KPVGyGRX1S8v30OuJNyMeLdB8EVJnnqs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DXV3RY2x8uRfhGHBp1U5rAuiLpM6WAsx3G19T88NGe54fGDgrubqKh0mLVEsPN7qtg0zSFBgb/3sxmzd4WOK8tdiHzZ7kdOHcngozo1Xf5YaaTi2O2WrTfJN9Cn+QnG/vQY9h5wBBfrC58Nb7fLRsr78dprLB5SMEtmeMcr4UII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HVAwiJv4; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HVAwiJv4"
Message-ID: <43e84a3e-f574-4c97-9f33-35fcb3751e01@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751293005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0iYONongsRME1HKcKR/MgEpiRBLSAhkg/xqodBzNJUQ=;
	b=HVAwiJv4C5Quke8pQpYZkngirfjh+NUNubClehgrHz7VhHs2nETxN1/2UCX/GNPx762l6v
	IV1tzGyIq3q3UFiR3YzNKvdo4fOm84j5fcn9pO3V2SulMaP1LBp1tHxsB6y6n+b5kRa71y
	hSS310Ju4kB3jtFDvh0smpd5TFUgf+w=
Date: Mon, 30 Jun 2025 22:16:37 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v1_00/11=5D_dm-pcache_=E2=80=93_persistent?=
 =?UTF-8?Q?-memory_cache_for_block_devices?=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
 <8d383dc6-819b-2c7f-bab5-2cd113ed9ece@redhat.com>
 <7ff7c4fc-d830-41c9-ab94-a198d3d9a3b5@linux.dev>
In-Reply-To: <7ff7c4fc-d830-41c9-ab94-a198d3d9a3b5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 6/30/2025 9:40 PM, Dongsheng Yang 写道:
>
> 在 6/30/2025 9:30 PM, Mikulas Patocka 写道:
>>
>> On Tue, 24 Jun 2025, Dongsheng Yang wrote:
>>
>>> Hi Mikulas,
>>>     This is V1 for dm-pcache, please take a look.
>>>
>>> Code:
>>>      https://github.com/DataTravelGuide/linux tags/pcache_v1
>>>
>>> Changelogs from RFC-V2:
>>>     - use crc32c to replace crc32
>>>     - only retry pcache_req when cache full, add pcache_req into 
>>> defer_list,
>>>       and wait cache invalidation happen.
>>>     - new format for pcache table, it is more easily extended with
>>>       new parameters later.
>>>     - remove __packed.
>>>     - use spin_lock_irq in req_complete_fn to replace
>>>       spin_lock_irqsave.
>>>     - fix bug in backing_dev_bio_end with spin_lock_irqsave.
>>>     - queue_work() inside spinlock.
>>>     - introduce inline_bvecs in backing_dev_req.
>>>     - use kmalloc_array for bvecs allocation.
>>>     - calculate ->off with dm_target_offset() before use it.
>> Hi
>>
>> The out-of-memory handling still doesn't seem right.
>>
>> If the GFP_NOWAIT allocation doesn't succeed (which may happen anytime,
>> for example it happens when the machine is receiving network packets
>> faster than the swapper is able to swap out data), create_cache_miss_req
>> returns NULL, the caller changes it to -ENOMEM, cache_read returns
>> -ENOMEM, -ENOMEM is propagated up to end_req and end_req will set the
>> status to BLK_STS_RESOURCE. So, it may randomly fail I/Os with an error.
>>
>> Properly, you should use mempools. The mempool allocation will wait 
>> until
>> some other process frees data into the mempool.
>>
>> If you need to allocate memory inside a spinlock, you can't do it 
>> reliably
>> (because you can't sleep inside a spinlock and non-sleepng memory
>> allocation may fail anytime). So, in this case, you should drop the
>> spinlock, allocate the memory from a mempool with GFP_NOIO and jump back
>> to grab the spinlock - and now you holding the allocated object, so you
>> can use it while you hold the spinlock.
>
>
> Hi Mikulas,
>
>     Thanx for your suggestion, I will cook a GFP_NOIO version for the 
> memory allocation for pcache data path.

Hi Mikulas,

     The reason why we don’t release the spinlock here is that if we do, 
the subtree could change.

For example, in the `fixup_overlap_contained()` function, we may need to 
split a certain `cache_key`, and that requires allocating a new 
`cache_key`.

If we drop the spinlock at this point and then re-acquire it after the 
allocation, the subtree might already have been modified, and we cannot 
safely continue with the split operation.

     In this case, we would have to restart the entire subtree search 
and walk. But the new walk might require more memory—or less,

so it's very difficult to know in advance how much memory will be needed 
before acquiring the spinlock.

     So allocating memory inside a spinlock is actually a more direct 
and feasible approach. `GFP_NOWAIT` fails too easily, maybe `GFP_ATOMIC` 
is more appropriate.


What do you think?

>
>>
>>
>> Another comment:
>> set_bit/clear_bit use atomic instructions which are slow. As you already
>> hold a spinlock when calling them, you don't need the atomicity, so you
>> can replace them with __set_bit and __clear_bit.
>
>
> Good idea.
>
>
> Thanx
>
> Dongsheng
>
>>
>> Mikulas
>>
>
