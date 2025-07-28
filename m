Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E8422FE11
	for <dm-devel@lists.linux.dev>; Mon, 28 Jul 2025 21:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753737802; cv=none; b=dS4Ww/OfppGfnzY+0EL26xsIugXotEnmtLSTzjjUUJ4nBDfoEUNw7hYEZlcaOj2N97x4x/YM82cNBe6DdkgQUm+NvmjdbeGbbX2uz7Ea32Uekzq67T1chpicuqL0AtjK+nznLHMWkciOdlyyuh4EIw7SITh4olIQmFeDVMNyHR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753737802; c=relaxed/simple;
	bh=dAQSf+XI6fSXZq/pD99pdNeMifhZlZj/fhFcecCBPuQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SjeRADp6x1kBlwaYdP2iTG3RKhCS+Y82/5FfuuYZeWBtbvq89PEmSgm0pATAzXeo9Fc8GrKZJyfRQ0npm44o7BIGje14T9QXySgX70nG3oZa2ZWJ+qK4zifn+qGyB84++JHeiMj8c2HOU4m4WbVgM9sY/Jt4o/jlEdnSwMyDArs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HpsBxsav; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpsBxsav"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753737797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5ptpFcx7JlHCsdJJmr9phSliSoCSBdG5uh8PeTnRYNs=;
	b=HpsBxsav8Hk4kXsTvdH4NCd0OJd9Sf7X+srLH9vsUWTf6Wmr7nkJDN2t6tvKP2ZZhKFL88
	4MKtj1nv7ja5yHy1EuTptj8W0ANjJTLOal6LPdq+KerBzNVtGpCKd0UVsRbIP4oZySuk5W
	GoJI7pYOdkp+2ODw9aQu8RPi88GCz+4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-9GkDEUSdO1ahrJaMVxqgLg-1; Mon,
 28 Jul 2025 17:23:13 -0400
X-MC-Unique: 9GkDEUSdO1ahrJaMVxqgLg-1
X-Mimecast-MFC-AGG-ID: 9GkDEUSdO1ahrJaMVxqgLg_1753737792
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84DC11956089;
	Mon, 28 Jul 2025 21:23:12 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4B0818001DD;
	Mon, 28 Jul 2025 21:23:10 +0000 (UTC)
Date: Mon, 28 Jul 2025 23:23:02 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    cengku@gmail.com
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v4_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <f5cfbcd9-e1ac-4412-8ebf-801fb53fa46f@linux.dev>
Message-ID: <28811c13-6b6b-593b-83ba-47747517988f@redhat.com>
References: <20250715133332.1764715-1-dongsheng.yang@linux.dev> <af28999e-8002-0320-3aaf-f9eb0768884c@redhat.com> <f5cfbcd9-e1ac-4412-8ebf-801fb53fa46f@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mZZYLLkJZ7m7sEVOtWEle23RAqKR3Eya8dtxh3oxBEY_1753737792
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-392299188-1753718279=:1054418"
Content-ID: <209b4a2a-2779-54c9-a9cd-56f8b3b2ca84@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-392299188-1753718279=:1054418
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <831f1f2b-96b7-f8b4-98ac-b97a23c91943@redhat.com>

Hi

On Fri, 25 Jul 2025, Dongsheng Yang wrote:

> > * get_n_vecs: what if "data" is not page-aligned? is that possible?
> Yes, it's possible, so I am using DIV_ROUND_UP() to calculate the n_vecs.

DIV_ROUND_UP is not sufficient - suppose that "data" is 0xf00 and "len" is 
0x200. DIV_ROUND_UP(len, PAGE_SIZE) returns "1", while you need two bio 
vector entries in fact.

I'd change DIV_ROUND_UP(len, PAGE_SIZE) to 
DIV_ROUND_UP(offset_in_page(data) + len, PAGE_SIZE)

> > * cache_dev_get_empty_segment_id: change set_bit to __set_bit because it
> >    doesn't have to be atomic - you already hold the lock
> Okey
> > 
> > * you usually hold seg_map_lock around modifications of seg_map bitmap,
> >    but not in kset_replay and cache_replay - that seems like a bug. When
> >    you hold the spinlock always, you can change set_bit/clear_bit to
> >    __set_bit and __clear_bit
> 
> actually, that's intented, because there is no other accessor in replaying
> stage. So I dont hold the lock here, that would be faster.

OK, so you don't have to hold the lock, you can just add a comment that 
the lock it not needed because the code is single-threaded.

> But I am glad to add lock here, On the one hand, this change makes its use
> more consistent and switches it to `__set_bit`.
> On the other hand, if we later add support for parallel replay, we’ll need a
> lock to handle the race conditions during this stage.
> 
> 
> > 
> > * cache.c:     cache->seg_map = bitmap_zalloc(cache_dev->seg_num,
> > GFP_KERNEL);
> > * cache_dev.c: cache_dev->seg_bitmap = bitmap_zalloc(cache_dev->seg_num,
> > GFP_KERNEL);
> >    how big seg_num can be? allocating more than 32768 bytes with kmalloc
> >    is unreliable (kvmalloc should be used in this case).
> 
> #define PCACHE_CACHE_SEGS_MAX              (1024 * 1024)   /* maximum cache
> size for each device is 16T */
> 
> 
> kvcalloc(BITS_TO_LONGS(cache_dev->seg_num), sizeof(unsigned long),
> GFP_KERNEL);

OK.

> > * cache->ksets = kcalloc(cache->n_ksets, PCACHE_KSET_SIZE, GFP_KERNEL);
> `n_ksets` is equal to the number of online CPUs, so this allocation could
> exceed 32768 bytes; I’ll switch it to `kvcalloc`.

OK.

BTW. how does it handle seting CPUs online or offline while the dm-pcache 
target is running?

> > * kset_onmedia = kzalloc(PCACHE_KSET_ONMEDIA_SIZE_MAX, GFP_KERNEL);
> >    - could these allocations be larger than 32768 bytes?
> 
> The value is fixed—currently **5144**—and even if we extend it later, it
> shouldn’t exceed 32768 bytes for the time being.

OK.

> > * There's cpu_to_le32 when you set sb->seg_num: sb->seg_num =
> >    cpu_to_le32(nr_segs), but not le32_to_cpu when you read it: ret =
> >    cache_dev_init(cache_dev, sb.seg_num); - it seems that this will not
> >    work on big-endian machines.
> 
> 
> Correct, it need le32_to_cpu(), I missed it here.
> 
> > 
> > Just a suggestion for performance improvement: when you hold a spinlock a
> > you need to allocate some memory, you must drop the spinlock, allocate it
> > with GFP_NOIO, reacquire the spinlock and recheck the state. You can
> > improve this logic by allocating with mempool_alloc(GFP_NOWAIT) while you
> > hold the spinlock (GFP_NOWAIT will not sleep, so it's allowed), and
> > fallback to dropping the spinlock only if the GFP_NOWAIT allocation fails.
> 
> 
> Sounds a good suggestion, I will try it in V5.

Yes. When you implement it, don't forget to test the code path that drops 
the spinlock and uses mempool_alloc(GFP_NOIO), so that it doesn't bitrot 
over time.

Mikulas
---1463811712-392299188-1753718279=:1054418--

