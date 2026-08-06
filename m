Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03BA25B09E
	for <dm-devel@lists.linux.dev>; Thu,  6 Aug 2026 11:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786016902; cv=none; b=J8lMySrHDiQhwt2tzCpa2tXsV6IQH+JQAFupSwG391tjk5Mb9k2U+Bx97MmIRUptSIlqenTCYPGlHW2mVZKRIC6tNEaNgtXbNurTvd7AE8z+2z2Yrdl/SnXk6t72IzvvsBXC2gSS7odXf+is8Xmh9YdBFBaOjFY9Wd0C6XuTXgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786016902; c=relaxed/simple;
	bh=YqFsA07hVIl4NcBt/RO4Dk3UaJmJwtsSno5SPnMn368=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Y92DO9VwdLO6SzpaS4XIzq7K4q2wCSWFu9Uittb6h6Ky+Ft+Bhhr30l3DcI/1G2YuClBtnZVZi8e0K+Bgl+otQbE7TYfjKtFVcOweUg1lk+VA9516tb8f4KhPcM8HY+5SJNQRlQ8SqEMoIBhqSQGnk6lNtZYbgSgcR4A5LPx2rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TEdvW2yc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TEdvW2yc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786016899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b293LM+NiAkQUB6S7RQqQH7BsMLZv9Yq6nXYWKiJxMY=;
	b=TEdvW2ycSl9cUnUCOS/QKygYo6C/RdGenITs9GW2Z/VowvJr7FZahyjCzOxgtjNC9q9zUV
	V6A2CUz/yh1Ngu4p3sqPQAtNCJna4kJv0b2vF1UqQiCYjlgKJhlDxnXClvxnUuLeLadj/Q
	AXfW/v1d992PSTkQ1RyrgX0ouK1Duyo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449-xvBeH5DgMoqHvW7Xha2KcA-1; Thu,
 06 Aug 2026 07:48:18 -0400
X-MC-Unique: xvBeH5DgMoqHvW7Xha2KcA-1
X-Mimecast-MFC-AGG-ID: xvBeH5DgMoqHvW7Xha2KcA_1786016897
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB34F18001DE;
	Thu,  6 Aug 2026 11:48:16 +0000 (UTC)
Received: from [10.44.32.79] (unknown [10.44.32.79])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D77DC195DF92;
	Thu,  6 Aug 2026 11:48:14 +0000 (UTC)
Date: Thu, 6 Aug 2026 13:48:08 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
cc: Dongsheng Yang <dongsheng.yang@linux.dev>, 
    Jianyun Gao <jianyungao89@gmail.com>, Zheng Gu <cengku@gmail.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-pcache: fix use-after-free during cache replay
In-Reply-To: <20260805171637.3557122-1-shuangpeng.kernel@gmail.com>
Message-ID: <d96c9146-430f-c89e-949b-b8c4189b0b17@redhat.com>
References: <20260805171637.3557122-1-shuangpeng.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: BxAacEI0Ystbt30Yf2z4RknaDc9Li8dF-uI6PcDXwz4_1786016897
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

This patch doesn't apply to the current device mapper working tree because 
another patch was already committed there: c2e894eac398 ("dm-pcache: fix 
use-after-free and invalid seg operations in kset_replay()").

Please, download the current device mapper repository from 
git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git

Checkout the branch for-next.

Verify that the bug is still present there.

If yes, send the patch against the "for-next" branch.

Mikulas



On Wed, 5 Aug 2026, Shuangpeng Bai wrote:

> kset_replay() drops the last reference to a stale cache key before
> using key->cache_pos to acquire a reference to its cache segment. This
> can dereference the freed key.
> 
> Segment references account for key records that have not yet been
> consumed by key-log garbage collection. A reference is acquired for
> every successfully recorded key, and the GC path drops one for every
> record, including records whose segment generation has become stale.
> Replay therefore has to restore the segment reference before deciding
> whether the decoded key should be inserted into the request-key tree.
> 
> Move cache_seg_get() before the generation check. This preserves the
> get/put accounting for stale records while ensuring that the key is not
> accessed after cache_key_put().
> 
> Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
> 
> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
> ---
>  drivers/md/dm-pcache/cache_key.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
> index e068e878231b..b37d899f2d3c 100644
> --- a/drivers/md/dm-pcache/cache_key.c
> +++ b/drivers/md/dm-pcache/cache_key.c
> @@ -729,6 +729,7 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
>  		}
>  
>  		__set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
> +		cache_seg_get(key->cache_pos.cache_seg);
>  
>  		/* Check if the segment generation is valid for insertion. */
>  		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
> @@ -739,8 +740,6 @@ static int kset_replay(struct pcache_cache *cache, struct pcache_cache_kset_onme
>  			cache_key_insert(&cache->req_key_tree, key, true);
>  			spin_unlock(&cache_subtree->tree_lock);
>  		}
> -
> -		cache_seg_get(key->cache_pos.cache_seg);
>  	}
>  
>  	return 0;
> -- 
> 2.43.0
> 

