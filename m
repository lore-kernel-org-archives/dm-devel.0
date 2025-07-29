Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240CC1990B7
	for <dm-devel@lists.linux.dev>; Tue, 29 Jul 2025 08:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753776462; cv=none; b=SqIcaMbY3z1Fow53IBr8dwR0JoIFXNzcpRL8wyOyGkIyBFNEdhxygftWv4+gICbXOUEsZLXdy1LNE0qcrlSwpoYkCf75gO/6OY8qwwlJbyRcvwGaRlqdfeExCRMZD8x9JpI+HaPdnpiXLBk7WuZMLmL3NMqROL1UbmafOOqA6qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753776462; c=relaxed/simple;
	bh=jMTQT53VeocMqv0wcfS6A/4z5MYqOKtDMERCM58VzV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AiCr/lMofgTlpIThF7Wzv5997G0jdA2VFPnfCTfNMjFsqDfNsU4wWmrFjVvCPRVToZcG1TovydgJ7PWXFl10BZCBvM0awvAsD+Ss6zfspBFAzKGyzPhPuxxvnZ0/Fg9ImRVJIVBjQmdv0USCNwMV8Nh5m+dssagHTkU4Z/tjx6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d1ehVudg; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d1ehVudg"
Message-ID: <43fa642d-4eeb-4bd8-9d2d-31aaf6bd2486@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753776456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kkMq3iRSBXpdpAV22F4q52Phjc+d+Cit75dyOtBcP7s=;
	b=d1ehVudgdhECBvupvzC81ynAIB303cSyK4QD3jNOfVnfU38BZYmIF/IvX5poTE8mnMlQnm
	0bFoKn4IGEj3lh5EHiHgPDOJSQnT/7f5Nf2GCPQqTandXI1PM496uyM54bLdWjnVy04He/
	uH7KCwaSmUEnx6OCij52Bt8Ec/vERmY=
Date: Tue, 29 Jul 2025 16:07:28 +0800
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
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <28811c13-6b6b-593b-83ba-47747517988f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 7/29/2025 5:23 AM, Mikulas Patocka 写道:
> Hi
>
> On Fri, 25 Jul 2025, Dongsheng Yang wrote:
>
>>> * get_n_vecs: what if "data" is not page-aligned? is that possible?
>> Yes, it's possible, so I am using DIV_ROUND_UP() to calculate the n_vecs.
> DIV_ROUND_UP is not sufficient - suppose that "data" is 0xf00 and "len" is
> 0x200. DIV_ROUND_UP(len, PAGE_SIZE) returns "1", while you need two bio
> vector entries in fact.
>
> I'd change DIV_ROUND_UP(len, PAGE_SIZE) to
> DIV_ROUND_UP(offset_in_page(data) + len, PAGE_SIZE)


Yes, good point, you are right. I will call bio_add_max_vecs() from 
bio.h in next version, it works same as you mentioned above.


In addition, to expose this kind of bug in my testing environment, I 
will setup one of my testing machine

to use striped pmem as cache dev.

>
>>> * cache_dev_get_empty_segment_id: change set_bit to __set_bit because it
>>>     doesn't have to be atomic - you already hold the lock
>> Okey
>>> * you usually hold seg_map_lock around modifications of seg_map bitmap,
>>>     but not in kset_replay and cache_replay - that seems like a bug. When
>>>     you hold the spinlock always, you can change set_bit/clear_bit to
>>>     __set_bit and __clear_bit
>> actually, that's intented, because there is no other accessor in replaying
>> stage. So I dont hold the lock here, that would be faster.
> OK, so you don't have to hold the lock, you can just add a comment that
> the lock it not needed because the code is single-threaded.


okey , I will add comment here.

>
>>> Just a suggestion for performance improvement: when you hold a spinlock a
>>> you need to allocate some memory, you must drop the spinlock, allocate it
>>> with GFP_NOIO, reacquire the spinlock and recheck the state. You can
>>> improve this logic by allocating with mempool_alloc(GFP_NOWAIT) while you
>>> hold the spinlock (GFP_NOWAIT will not sleep, so it's allowed), and
>>> fallback to dropping the spinlock only if the GFP_NOWAIT allocation fails.
>>
>> Sounds a good suggestion, I will try it in V5.
> Yes. When you implement it, don't forget to test the code path that drops
> the spinlock and uses mempool_alloc(GFP_NOIO), so that it doesn't bitrot
> over time.


Sure, the failslab case can cover this path:

https://github.com/DataTravelGuide/dtg-tests/blob/main/pcache.py.data/pcache_failslab.sh


Dongsheng

>
> Mikulas
