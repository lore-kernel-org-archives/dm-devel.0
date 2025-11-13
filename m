Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F92320A0B
	for <dm-devel@lists.linux.dev>; Thu, 13 Nov 2025 06:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763016030; cv=none; b=MezhqgN+LmqwewRH+R4sL4By72hKQfQva9345rtMFZd6qjGVFENRTDmTlQpAXAffEBB9O9dGSNruKIv+KvXcrEYl5i4OqwS+h9b2yN9pqP4k4xMSjNMbWG8q8AdLBPlpllWSkAo58/nnvLWOp6qUPnEuV7P7kb71csauIakTUnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763016030; c=relaxed/simple;
	bh=PnOwXnnatix/8AWt5mmmDTCVLz3zTti3ZrGQsbBEUUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fJSDhKR3qzrcShj6puoXJdUoo76M0/YSMFeczfYjr629FNV6mkns5YX61+dHgTKnzSNF3IOr5FKt7NMLh+mDpNLqOUTEQR04WylgFBmTfdFQXjalua2Cj4gDAlysyPv9iUV7oeVkuYkX8BgLotnAsffISketH0puWA+Nca18CGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fokAYdUP; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fokAYdUP"
Message-ID: <8c7c6147-f49d-425d-820f-dfe4f04623cb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763016026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+O6dAv/xDG5hivhz8JRs+mvDAT3U1ZiZhTr2vsbjAP4=;
	b=fokAYdUPbhGz8qnUYFntunXRpoETZ7dUuYxar1m9AvmdbTEeq3NGjHRDZL/sNolCluZueF
	bx141IrY/SCoLT320pnJopU+VUMRLHnyo+C+INR0L6Kzk9vqKpZz1wo8mddiMCkOd5l4b6
	j9BJ2vBM9RvTW/1DvBRLIPS54+u+zAI=
Date: Thu, 13 Nov 2025 14:40:02 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] dm-pcache: reuse meta_addr in
 pcache_meta_find_latest
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251111121337.1063443-1-me@linux.beauty>
 <20251111121337.1063443-3-me@linux.beauty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251111121337.1063443-3-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 11/11/2025 8:13 PM, Li Chen 写道:
> From: Li Chen <chenl311@chinatelecom.cn>
>
> pcache_meta_find_latest() already computes the metadata address as
> meta_addr. Reuse that instead of recomputing.
>
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>


Reviewed-by： Dongsheng Yang <dongsheng.yang@linux.dev


> ---
>   drivers/md/dm-pcache/pcache_internal.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-pcache/pcache_internal.h b/drivers/md/dm-pcache/pcache_internal.h
> index d427e534727c..b7a3319d2bd3 100644
> --- a/drivers/md/dm-pcache/pcache_internal.h
> +++ b/drivers/md/dm-pcache/pcache_internal.h
> @@ -99,7 +99,7 @@ static inline void __must_check *pcache_meta_find_latest(struct pcache_meta_head
>   		/* Update latest if a more recent sequence is found */
>   		if (!latest || pcache_meta_seq_after(meta->seq, seq_latest)) {
>   			seq_latest = meta->seq;
> -			latest = (void *)header + (i * meta_max_size);
> +			latest = meta_addr;
>   		}
>   	}
>   
