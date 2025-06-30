Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1969F28DEE8
	for <dm-devel@lists.linux.dev>; Mon, 30 Jun 2025 16:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751301045; cv=none; b=k8e49Xm8+zeMZf7TgI2f22tmhJIapurh96js0qII2TiwpISmEVnisgHKISjJtdsceFtX7Fpo50b+HAbQ4e516Yd3JD9gDhmQMaXz4Mq9st8hfqJzAzAuXHBdkpL7v0OnjOoYPvqpeuxArN4Acrg/boMIBG27VDUGbyZF6wHzgw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751301045; c=relaxed/simple;
	bh=t586Zow7oyJp/0l1/+706waxRLAJ+MmFrMUNSW2uTfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YKJU4OAeeltFwNvsp5brTb7Mto7zTuI10Fb6Kn9HHkWI8LXz5djn1tSrno+u1Sbx11Jz2VVMnPvIHvvDlW6wTortG/B18MXlTEnRvEO3s8MgugZ2a1qElH+eC67pjRWK5ybi+9zMjqDhCzQLtqpyF2xyrGwEc6VHhXX59oMFww0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sm4ATIqH; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sm4ATIqH"
Message-ID: <0953f766-48bc-416f-9089-7403e938569c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751301041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M4R8oQGNb+HE/xFlfDbpHkdOJMrhCQEK8kzkuPBr+Vw=;
	b=Sm4ATIqHZO7EQ4eOrkwhzACDmmLcDHhu4/Bi2TrdRfOGejIcvyPP94wqzui5yH8/PEQWRJ
	b0WuiLxErzMi5+Q3OuU7KchbcOP4nZFBD4eHHLDwLqiF4zjeyjA8Emel0lkZeOG+0APRNc
	t1GYKUNYmAihRfsKB+4332RStm6+suE=
Date: Tue, 1 Jul 2025 00:30:32 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v1_00/11=5D_dm-pcache_=E2=80=93_persistent?=
 =?UTF-8?Q?-memory_cache_for_block_devices?=
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
 <8d383dc6-819b-2c7f-bab5-2cd113ed9ece@redhat.com>
 <7ff7c4fc-d830-41c9-ab94-a198d3d9a3b5@linux.dev>
 <43e84a3e-f574-4c97-9f33-35fcb3751e01@linux.dev>
 <f0c46aba-9756-5f05-a843-51bc4898a313@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <f0c46aba-9756-5f05-a843-51bc4898a313@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 6/30/2025 11:45 PM, Mikulas Patocka 写道:
>
> On Mon, 30 Jun 2025, Dongsheng Yang wrote:
>
>> Hi Mikulas,
>>
>>      The reason why we don’t release the spinlock here is that if we do, the
>> subtree could change.
>>
>> For example, in the `fixup_overlap_contained()` function, we may need to split
>> a certain `cache_key`, and that requires allocating a new `cache_key`.
>>
>> If we drop the spinlock at this point and then re-acquire it after the
>> allocation, the subtree might already have been modified, and we cannot safely
>> continue with the split operation.
> Yes, I understand this.
>
>>      In this case, we would have to restart the entire subtree search and walk.
>> But the new walk might require more memory—or less,
>>
>> so it's very difficult to know in advance how much memory will be needed
>> before acquiring the spinlock.
>>
>>      So allocating memory inside a spinlock is actually a more direct and
>> feasible approach. `GFP_NOWAIT` fails too easily, maybe `GFP_ATOMIC` is more
>> appropriate.
> Even GFP_ATOMIC can fail. And it is not appropriate to return error and
> corrupt data when GFP_ATOMIC fails.
>
>> What do you think?
> If you need memory, you should drop the spinlock, allocate the memory
> (with mempool_alloc(GFP_NOIO)), attach the allocated memory to "struct
> pcache_request" and retry the request (call pcache_cache_handle_req
> again).
>
> When you retry the request, there are these possibilities:
> * you don't need the memory anymore - then, you just free it
> * you need the amount of memory that was allocated - you just proceed
>    while holding the spinlock
> * you need more memory than what you allocated - you drop the spinlock,
>    free the memory, allocate a larger memory block and retry again


Yes, that was exactly my initial idea when I first came up with this 
solution—it just seemed a bit convoluted. That’s why I wondered if using 
GFP_ATOMIC might be a more straightforward approach.

Okay, compared to simply returning an error to the upper-level user, I 
think implementing this mechanism is well worth it.

Dongsheng

>
> Mikulas
