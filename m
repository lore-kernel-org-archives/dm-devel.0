Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C471F340DA9
	for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525841; cv=none; b=oZzB9Wbc1Ed/a6Q1KGx4U6UTADNiiByC7SXfsKmVcAKMJhTKTHDFH2sZ6ZcJ/+n1K7vFtTKGyiWAleJMSc/56bdyBlzpYyUQ7hJLQtCE8bpjZ1apIprzXyuHAsVpZrATG9s5fXEMyZ3ezI+QQ5AJEg+occDaaSM1IoalUJX0grk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525841; c=relaxed/simple;
	bh=+DfxPZ1R/zjM5fIhmIiWa0k5drJdSvtQ7HDrwBKT9kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozVoVPU5tHjWkX+SxI+hBxFnZUDNv/vihnEJ+EqShwefAhbfhq5wEmK/trvoBF47HhzLOOHG1oVoja3+AP/f8sBLUKqOFsXRQ2Ur7JAp6sYofYxZgM3gleX2N+ZQMBUh94xBbES+PJ9CENhPK4Y4IN/t+4xRyzYm2V9tyT1Vjec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CxdHcVe8; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CxdHcVe8"
Message-ID: <bc4e1712-7993-4c40-9fae-dc2f4f22d01d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755525836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ww3sE7KkuWqqLnURQZy+bp1BepXGDe/GmdOTj4U5UeA=;
	b=CxdHcVe8rsVOn1LcbJ2E0Dee7pT6mZhSaIV75ew2pRTRnsQLtj8DQgNyeMPKKKj3uDrL7F
	BEaAF7iN1I9LOLFs+oW+fPT6YG9aPxZPDi5STl7abJF0xVKIDULvY1Ps4qFJ1iqUe+D63o
	Bc3YynM0BWKdQC/0rabmnQ2cUyBUrXM=
Date: Mon, 18 Aug 2025 22:03:52 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [bug report] dm-pcache: add persistent cache target in
 device-mapper
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: dm-devel@lists.linux.dev
References: <aKL33O_yChKJ-4_G@stanley.mountain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <aKL33O_yChKJ-4_G@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/18/2025 5:52 PM, Dan Carpenter 写道:
> Hello Dongsheng Yang,
>
> Commit 6fb8fbbaf147 ("dm-pcache: add persistent cache target in
> device-mapper") from Aug 12, 2025 (linux-next), leads to the
> following Smatch static checker warning:
>
> 	drivers/md/dm-pcache/cache_req.c:60 cache_data_alloc()
> 	error: uninitialized symbol 'to_alloc'.


Hi Dan,

     Thanx for your report, I did fix it in my local tree, and testing 
is running now. If all tests pass, I will send the patch out tomorrow.


Thanx

Dongsheng

>
> drivers/md/dm-pcache/cache_req.c
>      36 static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key *key)
>      37 {
>      38         struct pcache_cache_data_head *data_head;
>      39         struct pcache_cache_pos *head_pos;
>      40         struct pcache_cache_segment *cache_seg;
>      41         u32 seg_remain;
>      42         u32 allocated = 0, to_alloc;
>      43         int ret = 0;
>      44
>      45         preempt_disable();
>      46         data_head = get_data_head(cache);
>      47 again:
>      48         if (!data_head->head_pos.cache_seg) {
>      49                 seg_remain = 0;
>
> to_alloc isn't initialized on this path.
>
>      50         } else {
>      51                 cache_pos_copy(&key->cache_pos, &data_head->head_pos);
>      52                 key->seg_gen = key->cache_pos.cache_seg->gen;
>      53
>      54                 head_pos = &data_head->head_pos;
>      55                 cache_seg = head_pos->cache_seg;
>      56                 seg_remain = cache_seg_remain(head_pos);
>      57                 to_alloc = key->len - allocated;
>      58         }
>      59
> --> 60         if (seg_remain > to_alloc) {
>                                  ^^^^^^^^
>
>      61                 /* If remaining space in segment is sufficient for the cache key, allocate it. */
>      62                 cache_pos_advance(head_pos, to_alloc);
>      63                 allocated += to_alloc;
>      64                 cache_seg_get(cache_seg);
>      65         } else if (seg_remain) {
>      66                 /* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
>      67                 cache_pos_advance(head_pos, seg_remain);
>      68                 key->len = seg_remain;
>      69
>      70                 /* Get for key: obtain a reference to the cache segment for the key. */
>      71                 cache_seg_get(cache_seg);
>      72                 /* Put for head_pos->cache_seg: release the reference for the current head's segment. */
>      73                 cache_seg_put(head_pos->cache_seg);
>      74                 head_pos->cache_seg = NULL;
>      75         } else {
>      76                 /* Initialize a new data head if no segment is available. */
>      77                 ret = cache_data_head_init(cache);
>      78                 if (ret)
>      79                         goto out;
>      80
>      81                 goto again;
>      82         }
>      83
>      84 out:
>      85         preempt_enable();
>      86
>      87         return ret;
>      88 }
>
> regards,
> dan carpenter
