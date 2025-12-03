Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98322882D6
	for <dm-devel@lists.linux.dev>; Wed,  3 Dec 2025 05:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764741446; cv=none; b=P795eiiDYjmGOOWkXJarty0F0iN2NiUoTk6xLnH2xrvFzbZ99TkBn0ZGSXsW7nXxMDfLMPFX9nS9864AshOFxECqMJVmG90O5DLxMS/A/DwngP1CbudpTkg5CxVHEM0l+HTAJ5GhWaK389e9T7D2gl5lm4mBxbI7vmNadKVf4So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764741446; c=relaxed/simple;
	bh=4GCIQG+lt8jY6ue6xWQEXgFjzW+jzKcsDapCJ+7QPKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DpQZJj6KTrVOq+qaO5HjYbg1dvPJ3+U+5VMpTXg3O1XjZg3QRRIEnqMqg7DFs9peh31m5eCyF51q8JhWSLt8jiREgSr02Hgn6wKaQyGA32Bk2+1+nOldXbFyOlCt6zodBfeDJdd0uyIB9S6hAEEhyO5EX7dhd2+9NdlVGtmK+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lZ/dsYrh; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lZ/dsYrh"
Message-ID: <8794c32c-790c-4503-a657-3e66bc541cda@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764741441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eCvkkXbg15ThEGqxvsHecDKTzDwXwzoFR00iY8d3ftA=;
	b=lZ/dsYrhRAySm5L7njT09eYtk9mjaneMPMpkwtND+2JVVKmB/KrzEiEOrI1se7ljwN9niR
	tMhCpaZBRkI1WDb/83solKtUj+uG8+9PKXgVxeBkJZbgfFGDWoxkDKGxqVUWcs7CmoVhld
	MDumetCX+TUNHdiJ0wHssPBWFuJkpCA=
Date: Wed, 3 Dec 2025 13:57:15 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] dm pcache: fix segment info indexing
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251202121158.111092-1-me@linux.beauty>
 <20251202121158.111092-3-me@linux.beauty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251202121158.111092-3-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/2/2025 8:11 PM, Li Chen 写道:
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
> ---
>   drivers/md/dm-pcache/cache_segment.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
> index f0b58980806e..0b4bb08011ce 100644
> --- a/drivers/md/dm-pcache/cache_segment.c
> +++ b/drivers/md/dm-pcache/cache_segment.c
> @@ -56,7 +56,11 @@ static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
>   		ret = -EIO;
>   		goto out;
>   	}
> -	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
> +
> +	cache_seg->info_index =
> +		((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
> +		PCACHE_SEG_INFO_SIZE;
> +	cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;


Don't advance info_index at init stage.

>   out:
>   	mutex_unlock(&cache_seg->info_lock);
>   
