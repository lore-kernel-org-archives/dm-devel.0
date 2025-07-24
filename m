Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722D417A318
	for <dm-devel@lists.linux.dev>; Thu, 24 Jul 2025 16:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753375697; cv=none; b=SZDm+zU5LrEheJMRyf5YmxWlZ3NNR8CWyjashxEmZ5Lm0zjpL9I8jgw8425PtMP5RuAeb/R9/nCgSyfh0fZZB12uLTxiodnbTxqpAi4a47Hn83g4FNxV05A/unN7b5wnd9E2ktAbrU+DJ78KSHCfwMj1tjzgzvpEH/1KCFBqRT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753375697; c=relaxed/simple;
	bh=aLZdDzl3N3obt0G4RgBUTUKGAzeNbkyZaW45cRrGkqg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CBYjZFU2qw40SyThFPRW8A+xL5QuiOO7d5K9ucBOFU1RAv9egnTihfpPz7EgpXIvVK7QURKUmpoMTzZygfU7iWJGyEpxZbxtYve+k1B9cF0yMkkKT+lMe7cJGs8r+OA/O6BGOyblJIUnHJOGR6JulUqvLCx20OOEbR6w48B6aS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L5Gp9cj9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L5Gp9cj9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753375694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UJcSKlyYtiw18ze5YciIcaHoS5nkVIJEDLmxWPpQLTY=;
	b=L5Gp9cj937JH+Pehv8dR2Tve+Kv0kzSUGk0tATJWfzaXpjbFRzM45WeCrKayzr/P9WA67j
	u1JN/T9le9tX2GuDoNFB6K4hlLEpwQWivM+YHAU0klNHhgbuZBtgKAkMmMefBJMSuPHJL2
	8pOHdJ8zh0+wMoA2Wu6f6Zu5iR5vZD4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-261-7ID4DokNOM-ScHqJiTyFmA-1; Thu,
 24 Jul 2025 12:48:11 -0400
X-MC-Unique: 7ID4DokNOM-ScHqJiTyFmA-1
X-Mimecast-MFC-AGG-ID: 7ID4DokNOM-ScHqJiTyFmA_1753375690
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1914A180048E;
	Thu, 24 Jul 2025 16:48:10 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5515E300018D;
	Thu, 24 Jul 2025 16:48:08 +0000 (UTC)
Date: Thu, 24 Jul 2025 18:48:02 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    cengku@gmail.com
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v4_00=2F11=5D_dm-pcache_=E2=80=93_pe?=
 =?UTF-8?Q?rsistent-memory_cache_for_block_devices?=
In-Reply-To: <20250715133332.1764715-1-dongsheng.yang@linux.dev>
Message-ID: <af28999e-8002-0320-3aaf-f9eb0768884c@redhat.com>
References: <20250715133332.1764715-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cOBnNE34zG3M3IDFPKlV7M0X5SguEfHJBTDy4lBRCfg_1753375690
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 15 Jul 2025, Dongsheng Yang wrote:

> Hi Mikulas,
> 	This is V4 for dm-pcache, please help to review.

Hi

The mempool operations seem ok.

Here are some comments:

* backing_req_cache and backing_bvec_cache should be static

* get_n_vecs: what if "data" is not page-aligned? is that possible?

* cache_dev_get_empty_segment_id: change set_bit to __set_bit because it
  doesn't have to be atomic - you already hold the lock

* you usually hold seg_map_lock around modifications of seg_map bitmap,
  but not in kset_replay and cache_replay - that seems like a bug. When
  you hold the spinlock always, you can change set_bit/clear_bit to
  __set_bit and __clear_bit

* cache.c:     cache->seg_map = bitmap_zalloc(cache_dev->seg_num, GFP_KERNEL);
* cache_dev.c: cache_dev->seg_bitmap = bitmap_zalloc(cache_dev->seg_num, GFP_KERNEL);
  how big seg_num can be? allocating more than 32768 bytes with kmalloc
  is unreliable (kvmalloc should be used in this case).

* cache->ksets = kcalloc(cache->n_ksets, PCACHE_KSET_SIZE, GFP_KERNEL);
* kset_onmedia = kzalloc(PCACHE_KSET_ONMEDIA_SIZE_MAX, GFP_KERNEL);
  - could these allocations be larger than 32768 bytes?

* There's cpu_to_le32 when you set sb->seg_num: sb->seg_num =
  cpu_to_le32(nr_segs), but not le32_to_cpu when you read it: ret =
  cache_dev_init(cache_dev, sb.seg_num); - it seems that this will not
  work on big-endian machines.

Just a suggestion for performance improvement: when you hold a spinlock a 
you need to allocate some memory, you must drop the spinlock, allocate it 
with GFP_NOIO, reacquire the spinlock and recheck the state. You can 
improve this logic by allocating with mempool_alloc(GFP_NOWAIT) while you 
hold the spinlock (GFP_NOWAIT will not sleep, so it's allowed), and 
fallback to dropping the spinlock only if the GFP_NOWAIT allocation fails.

Mikulas

