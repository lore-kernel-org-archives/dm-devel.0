Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC1B27FB34
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764863966; cv=none; b=uxtIHW8Q08yj5EfAAsUF7j4NJqfWxU5dywX5gIb9z+iXueAzGAmW79yZfH1IsvorM7q8eKLeE4UgK+X47OU25c2wOrfMe38AA5RzvKe8Onf35cU3WGRB+oPKZvszhLq8ckZwiygaSZyJ7FXeM67j5ZSrn+nyj7lqif27QVlwT40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764863966; c=relaxed/simple;
	bh=se/FvOHS9+xToGljtc45TUVDYGksvzAnvNPZN94F4fw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nzc6Vr/CWlxBuxyfV6HP6uuNiq5Lh11jMJu6/LPWIGnfUI8hxauXFyFdmPgdjyQSLJlshsjRMqTCTeoFmz6fM3MHdgjtMNC5MvpK39JOcyuvdMsL9XaYScs8vd3QLNXSToUzmP4f8q7v2yPFA70AYiozFjNmtECofNOX/0ARuv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Io45+EpY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Io45+EpY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764863962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pG2dsZxaFH0NaMGZjAQEkCAkAqlXXDlNwz/GTuFSR48=;
	b=Io45+EpYJZ0o9MWRpMgtRl4eqjw7zMHuDEjkO/Vp3eh7SV2p1/NKhCodgRGEweAcFv2nU0
	eGT8Be8A4s+HOEmmGalLaX4zUaLMHhyJT557JkBYov3zGWMsru1iAbCq0uIXaLBiCeqj4U
	sAw3U+V8Ppcg7GgkkLV3GE14KwKKnrc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-696-sLkJ2TqbPCGAV1YkSFsZug-1; Thu,
 04 Dec 2025 10:59:19 -0500
X-MC-Unique: sLkJ2TqbPCGAV1YkSFsZug-1
X-Mimecast-MFC-AGG-ID: sLkJ2TqbPCGAV1YkSFsZug_1764863958
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97C72195605F;
	Thu,  4 Dec 2025 15:59:17 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78D461953986;
	Thu,  4 Dec 2025 15:59:15 +0000 (UTC)
Date: Thu, 4 Dec 2025 16:59:08 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: cengku@gmail.com, dm-devel@lists.linux.dev, chenl311@chinatelecom.cn
Subject: Re: [PATCH 3/3] dm pcache: fix segment info indexing
In-Reply-To: <20251204025323.2901775-3-dongsheng.yang@linux.dev>
Message-ID: <1f27a4db-929a-4271-6628-c2816f3d78fe@redhat.com>
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev> <20251204025323.2901775-3-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b7XmoV_zfl8wwccFyCZ7quZZrE3FHPy5SaLZ-Spgfxs_1764863958
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 4 Dec 2025, Dongsheng Yang wrote:

> From: Li Chen <chenl311@chinatelecom.cn>
> 
> Segment info indexing also used sizeof(struct) instead of the
> 4K metadata stride, so info_index could point between slots and
> subsequent writes would advance incorrectly. Derive info_index
> from the pointer returned by the segment meta search using
> PCACHE_SEG_INFO_SIZE and advance to the next slot for future
> updates.
> 
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache_segment.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
> index ae57cc261422..9d92e2b067ed 100644
> --- a/drivers/md/dm-pcache/cache_segment.c
> +++ b/drivers/md/dm-pcache/cache_segment.c
> @@ -56,7 +56,10 @@ static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
>  		ret = -EIO;
>  		goto out;
>  	}
> -	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
> +
> +	cache_seg->info_index =
> +		((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
> +		PCACHE_SEG_INFO_SIZE;
>  out:
>  	mutex_unlock(&cache_seg->info_lock);
>  

Hi

I already staged the patch below. Which patch is valid? Your new patch or 
the patch that I staged?

Mikulas



diff --git a/drivers/md/dm-pcache/cache_segment.c 
b/drivers/md/dm-pcache/cache_segment.c
index f0b58980806e..0b4bb08011ce 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -56,7 +56,11 @@ static int cache_seg_info_load(struct 
pcache_cache_segment *cache_seg)
                ret = -EIO;
                goto out;
        }
-       cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
+
+       cache_seg->info_index =
+               ((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
+               PCACHE_SEG_INFO_SIZE;
+       cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;
 out:
        mutex_unlock(&cache_seg->info_lock);


