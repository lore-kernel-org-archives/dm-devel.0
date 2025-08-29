Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37F81F4634
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 06:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756447429; cv=none; b=rnaCX/jB79EnmHTKnlW8mwjvwexJpGlAz7um31IjvMAxuWzhhDRbR7Azz6U90Wo7RuKE7W72MJ/LZsdsMV5e1QLvthk1ffIkgCr6aTKvxzQpcGSxsLILQqwJFa1L5Y+OoVpQKaEECs0ZOWknHik590/mXllYNtZll4VeXtvsTzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756447429; c=relaxed/simple;
	bh=029E0Fo6ZH52zoCZcB8yfOdxjnJjcdrvEf8RNbWQ6XQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s5+TwvZeZbo9nVa5JkfhQ9xwujjQ65F16Sv0Ri1f0BDDyV4ZzpMTLcIvBtlaa8xak8SoZQ6rjNpWDvpZpl9Uq3OGvplyXvHo178Vv03BB8EwDSCtu23ICOcIczB6OLrVNZDSkUOouXutwi2bVzA10cnUFCvC6QIQadVJ3xATdZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WZLZWKjs; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WZLZWKjs"
Message-ID: <824ba1cc-be92-47ae-9b81-a7e94f600010@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756447424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Letk+6wIjh5gBaqQhrcv9hxT1C9+z+j+26d0j854AUs=;
	b=WZLZWKjsTrLC3qk7vqraECocG3dWg0hU09l2bjMAQU8FhCBYI7NxKt61hdtpBF/9vLAyDp
	sTLIto9SHbaq8um1DBZaZgEG/hNSx5WXOJpIYghdMuF9fb47Xy3eZkK5rCvBoI4etqGo4s
	kgZQ0XNtBdSgPpr4k9ckZj+XZH8arO4=
Date: Fri, 29 Aug 2025 14:03:36 +0800
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
References: <aLE9JjiTzKmeKzsN@stanley.mountain>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <aLE9JjiTzKmeKzsN@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/29/2025 1:39 PM, Dan Carpenter 写道:
> Hello Dongsheng Yang,
>
> Commit 1d57628ff95b ("dm-pcache: add persistent cache target in
> device-mapper") from Aug 12, 2025 (linux-next), leads to the
> following Smatch static checker warning:
>
> 	drivers/md/dm-pcache/cache_segment.c:263 cache_seg_gen_increase()
> 	warn: sleeping in atomic context


Hi Dan,

     Thanx for your report, I will send out the patch after my testing 
finished.

BTW, can you share the Smatch checking command or script? I want to add

Smatch check in my testing suit if possible, I did not found this kind 
of problem with simple:

make CHECK="smatch -p=kernel" C=1 M=drivers/md/dm-pcache


Thanx a lot

>
> drivers/md/dm-pcache/cache_segment.c
>      257 static void cache_seg_gen_increase(struct pcache_cache_segment *cache_seg)
>      258 {
>      259         spin_lock(&cache_seg->gen_lock);
>      260         cache_seg->gen++;
>      261         spin_unlock(&cache_seg->gen_lock);
>      262
> --> 263         cache_seg_ctrl_write(cache_seg);
>
> cache_seg_ctrl_write() takes a mutex so it can't be called with
> preemption disabled.
>
>      264 }
>
> There are a few callers which Smatch says have preemption disabled:
> The call tree is kind of messy but the point is that there are four
> callers which Smatch says disable preemption.
>
> miss_read_end_req() <- disables preempt
> -> cache_data_alloc() <- disables preempt
> miss_read_end_req() <- disables preempt <duplicate>
> cache_write() <- disables preempt
>     -> cache_seg_put()
>        -> cache_seg_invalidate()
>           -> cache_seg_gen_increase()
>
> drivers/md/dm-pcache/cache_req.c
>      36  static int cache_data_alloc(struct pcache_cache *cache, struct pcache_cache_key *key)
>      37  {
>      38          struct pcache_cache_data_head *data_head;
>      39          struct pcache_cache_pos *head_pos;
>      40          struct pcache_cache_segment *cache_seg;
>      41          u32 seg_remain;
>      42          u32 allocated = 0, to_alloc;
>      43          int ret = 0;
>      44
>      45          preempt_disable();
>                  ^^^^^^^^^^^^^^^^^^
>
>      46          data_head = get_data_head(cache);
>      47  again:
>      48          to_alloc = key->len - allocated;
>      49          if (!data_head->head_pos.cache_seg) {
>      50                  seg_remain = 0;
>      51          } else {
>      52                  cache_pos_copy(&key->cache_pos, &data_head->head_pos);
>      53                  key->seg_gen = key->cache_pos.cache_seg->gen;
>      54
>      55                  head_pos = &data_head->head_pos;
>      56                  cache_seg = head_pos->cache_seg;
>      57                  seg_remain = cache_seg_remain(head_pos);
>      58          }
>      59
>      60          if (seg_remain > to_alloc) {
>      61                  /* If remaining space in segment is sufficient for the cache key, allocate it. */
>      62                  cache_pos_advance(head_pos, to_alloc);
>      63                  allocated += to_alloc;
>      64                  cache_seg_get(cache_seg);
>      65          } else if (seg_remain) {
>      66                  /* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
>      67                  cache_pos_advance(head_pos, seg_remain);
>      68                  key->len = seg_remain;
>      69
>      70                  /* Get for key: obtain a reference to the cache segment for the key. */
>      71                  cache_seg_get(cache_seg);
>      72                  /* Put for head_pos->cache_seg: release the reference for the current head's segment. */
>      73                  cache_seg_put(head_pos->cache_seg);
>                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> If we still are holding a second reference, then this warning is a false
> positive, but the commen suggests that we might actually free it.
>
>      74                  head_pos->cache_seg = NULL;
>      75          } else {
>      76                  /* Initialize a new data head if no segment is available. */
>      77                  ret = cache_data_head_init(cache);
>      78                  if (ret)
>      79                          goto out;
>      80
>      81                  goto again;
>      82          }
>      83
>      84  out:
>      85          preempt_enable();
>      86
>      87          return ret;
>      88  }
>
> regards,
> dan carpenter
