Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B6926AA98
	for <dm-devel@lists.linux.dev>; Fri, 25 Jul 2025 05:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753422962; cv=none; b=QGSnsqxEwujAzS7pfXzsi9kASUAPq7a7yIEkTQy7paxWkQV9h39TW3g8s5jCSvU0LNLjZEUG/+91iWWrBipGIOXSA3U0kFEVNSGNe4r0X/m4W28rdB49ws60U9lWFrVUp1urkOmcJ1tGPQEljUpxJTEIMW26C9YzSkDGsGDJ1YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753422962; c=relaxed/simple;
	bh=L1C8Enk6jsn2GiYxdBY71YL1jqWNGcIL+m40b1cHneI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XBVcGJb1YOIAA0M5/dDEIcsyvU4UXGosykGCoqyMxrrM5jxXUaqpQGWMqJKXdCNYUHMFs8Q1kBMcBCuzjpiFsJFRBVfGtS0pnIYIBC8SbYP2AUcwuRg4vPIJpyXNjMvl7YC55ZbdsmAFSCAfaZ21+QhmDDeAfeCjQmh0I3nhf0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fs8vccX/; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fs8vccX/"
Message-ID: <f5cfbcd9-e1ac-4412-8ebf-801fb53fa46f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753422958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UuUN9mio4rOMr7s+P5dJ9fSQMSXb8V1h2tLmHBDR9s8=;
	b=Fs8vccX/sZKfVHOc00DHVb/e7gVqfp3O4ioC4JiE61JkKXhyQ+BENrNxxmaHxZAQOIUTWQ
	xEkR8lxq48Ek1Beul1GDhuSnEPlHrgxAy0ixXkAWG1qmOShwZswUQ+0dNVXikv3Y1fib4o
	TZowjfhIRD/UxXfZeUOQGM51eYXjlWc=
Date: Fri, 25 Jul 2025 13:55:37 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <af28999e-8002-0320-3aaf-f9eb0768884c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 7/25/2025 12:48 AM, Mikulas Patocka 写道:
>
> On Tue, 15 Jul 2025, Dongsheng Yang wrote:
>
>> Hi Mikulas,
>> 	This is V4 for dm-pcache, please help to review.
> Hi
>
> The mempool operations seem ok.
>
> Here are some comments:
>
> * backing_req_cache and backing_bvec_cache should be static
Thanx
>
> * get_n_vecs: what if "data" is not page-aligned? is that possible?
Yes, it's possible, so I am using DIV_ROUND_UP() to calculate the n_vecs.
>
> * cache_dev_get_empty_segment_id: change set_bit to __set_bit because it
>    doesn't have to be atomic - you already hold the lock
Okey
>
> * you usually hold seg_map_lock around modifications of seg_map bitmap,
>    but not in kset_replay and cache_replay - that seems like a bug. When
>    you hold the spinlock always, you can change set_bit/clear_bit to
>    __set_bit and __clear_bit

actually, that's intented, because there is no other accessor in 
replaying stage. So I dont hold the lock here, that would be faster.

But I am glad to add lock here, On the one hand, this change makes its 
use more consistent and switches it to `__set_bit`.
On the other hand, if we later add support for parallel replay, we’ll 
need a lock to handle the race conditions during this stage.


>
> * cache.c:     cache->seg_map = bitmap_zalloc(cache_dev->seg_num, GFP_KERNEL);
> * cache_dev.c: cache_dev->seg_bitmap = bitmap_zalloc(cache_dev->seg_num, GFP_KERNEL);
>    how big seg_num can be? allocating more than 32768 bytes with kmalloc
>    is unreliable (kvmalloc should be used in this case).

#define PCACHE_CACHE_SEGS_MAX              (1024 * 1024)   /* maximum 
cache size for each device is 16T */


kvcalloc(BITS_TO_LONGS(cache_dev->seg_num), sizeof(unsigned long), 
GFP_KERNEL);

>
> * cache->ksets = kcalloc(cache->n_ksets, PCACHE_KSET_SIZE, GFP_KERNEL);
`n_ksets` is equal to the number of online CPUs, so this allocation 
could exceed 32768 bytes; I’ll switch it to `kvcalloc`.

> * kset_onmedia = kzalloc(PCACHE_KSET_ONMEDIA_SIZE_MAX, GFP_KERNEL);
>    - could these allocations be larger than 32768 bytes?

The value is fixed—currently **5144**—and even if we extend it later, it 
shouldn’t exceed 32768 bytes for the time being.

>
> * There's cpu_to_le32 when you set sb->seg_num: sb->seg_num =
>    cpu_to_le32(nr_segs), but not le32_to_cpu when you read it: ret =
>    cache_dev_init(cache_dev, sb.seg_num); - it seems that this will not
>    work on big-endian machines.


Correct, it need le32_to_cpu(), I missed it here.

>
> Just a suggestion for performance improvement: when you hold a spinlock a
> you need to allocate some memory, you must drop the spinlock, allocate it
> with GFP_NOIO, reacquire the spinlock and recheck the state. You can
> improve this logic by allocating with mempool_alloc(GFP_NOWAIT) while you
> hold the spinlock (GFP_NOWAIT will not sleep, so it's allowed), and
> fallback to dropping the spinlock only if the GFP_NOWAIT allocation fails.


Sounds a good suggestion, I will try it in V5.


Thanx

>
> Mikulas
>
>
