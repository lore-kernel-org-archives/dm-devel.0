Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1FEAD4B
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 05:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754026924; cv=none; b=WZGfTd2beMN3X2n9iCHnim7or4T7qAkGQpyMtbSONsVppoTyTtzpV3gQU5DX1qsLqhLAH+S3PlRoIO1ZSK+B/N2tINIcb1dnnqgdbVGtWgS+ndjQZAI7unydwmEQT5wxxtl8Mi6OU91A7VpGiNRtN7YZCZUFEzS+omFldnkO1jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754026924; c=relaxed/simple;
	bh=QtNMJzR8+E+gN4yagg145cDiFICgfOEwTqoLilWz+Q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1VAw9nPbX2oHKMYZ7OJ1zpiRvpXfas7fZJPkzc7qfgQeznpm2w2I46j6r3isFFpGjl47CqqQEBCAQaZ1CLMUVrP1mxkKCUygDiUhwB2OwnF5e1w2pp2pBmRCD0HE0d7wedZL8lmknqbCqgF5Vci2f7/DFKKmrR0sLSI4oO73Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O30NkWE/; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O30NkWE/"
Message-ID: <f3f46ed0-7f03-4fc7-a9a7-676cfa6bb0db@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754026920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RjANslNMpJUtHlBZ534AVKc13ShWwk4s3Z8TjHLkN+Q=;
	b=O30NkWE/xKgr7RlgL3EuxMR/hT0OBKF1y6yqY6pDkJj4ojxKVTnNXlko7t83qk5aDbXg4A
	OlqZPuBhGyTLHzvCCjZMCADWeP9V8/BzMxyM8DaQY8dak3TOtdMpFalHkMHalKlSRSlUzi
	jsryEv4qzebwwUSeQRHGXXZoz3eyOGc=
Date: Fri, 1 Aug 2025 13:41:54 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v4_00/11=5D_dm-pcache_=E2=80=93_persistent?=
 =?UTF-8?Q?-memory_cache_for_block_devices?=
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 cengku@gmail.com
References: <20250715133332.1764715-1-dongsheng.yang@linux.dev>
 <af28999e-8002-0320-3aaf-f9eb0768884c@redhat.com>
 <f5cfbcd9-e1ac-4412-8ebf-801fb53fa46f@linux.dev>
 <28811c13-6b6b-593b-83ba-47747517988f@redhat.com>
 <43fa642d-4eeb-4bd8-9d2d-31aaf6bd2486@linux.dev>
 <5792087a-e70f-d03a-9f9e-3d4107fa3b12@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <5792087a-e70f-d03a-9f9e-3d4107fa3b12@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/1/2025 12:17 AM, Mikulas Patocka 写道:
>
> On Tue, 29 Jul 2025, Dongsheng Yang wrote:
>
>>>>> Just a suggestion for performance improvement: when you hold a
>>>>> spinlock a you need to allocate some memory, you must drop the
>>>>> spinlock, allocate it with GFP_NOIO, reacquire the spinlock and
>>>>> recheck the state. You can improve this logic by allocating with
>>>>> mempool_alloc(GFP_NOWAIT) while you hold the spinlock (GFP_NOWAIT
>>>>> will not sleep, so it's allowed), and fallback to dropping the
>>>>> spinlock only if the GFP_NOWAIT allocation fails.
>>>> Sounds a good suggestion, I will try it in V5.
>>> Yes. When you implement it, don't forget to test the code path that drops
>>> the spinlock and uses mempool_alloc(GFP_NOIO), so that it doesn't bitrot
>>> over time.
>>
>> Sure, the failslab case can cover this path:
>>
>> https://github.com/DataTravelGuide/dtg-tests/blob/main/pcache.py.data/pcache_failslab.sh
>>
>>
>> Dongsheng
> failslab doesn't test mempool allocation failures - see the function
> mempool_alloc_noprof:
>
> it tries to allocate using
> 	element = pool->alloc(gfp_temp, pool->pool_data);
> if it fails (the failure may be caused by failslab), it goes down this
> path
>          spin_lock_irqsave(&pool->lock, flags);
>          if (likely(pool->curr_nr)) {
>                  element = remove_element(pool);
>                  spin_unlock_irqrestore(&pool->lock, flags);
>                  /* paired with rmb in mempool_free(), read comment there */
>                  smp_wmb();
>                  /*
>                   * Update the allocation stack trace as this is more useful
>                   * for debugging.
>                   */
>                  kmemleak_update_trace(element);
>                  return element;
>          }
>
> so, it will not simulate a situation where the mempool is depleted.


Yes. During my manual testing, I set mempool's min_nr to 0, triggered 
the `GFP_NOIO` path with `failslab`, and inserted some debug messages to 
confirm that the execution really went through that path.

I then automated the same procedure in dtg-tests: before failslab test 
it applies a patch to change `min_nr`, runs the test and checks `dmesg` 
for the expected debug output, and finally reverts the patch.

>
> It may be worthwhile to extend failslab, so that it makes mempool_alloc
> randomly return NULL for non-sleeping allocations (i.e. allocations
> without __GFP_DIRECT_RECLAIM) and submit the patch to failslab
> maintainers.

Indeed, if `mempool` were to support the `fault_inject` feature, the 
whole process would be much simpler.

If I come up with a good way to add that support, I’ll send out a patch.


Thanx

>
> Mikulas
>
