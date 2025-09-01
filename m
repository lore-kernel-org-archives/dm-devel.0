Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEA81E9B3F
	for <dm-devel@lists.linux.dev>; Mon,  1 Sep 2025 06:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756707919; cv=none; b=VslFfP3S+kQuEmzevKdy/uzMrKoDkI5TDEdzLBIvZfNM0aBRDFoGqIEGVUpK+/K4BQgatsqsW6W4B+gViKLfV/sj6Vja8yP2nqkwmcNeI8on8dHKzmP7TztxQRrG8EA2/7SBHVsSJJF6TOnqD8iBFLEUxBaV0adNwz2Zu4tu2K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756707919; c=relaxed/simple;
	bh=jI9CKQB8DDMeM+unhLN0OWUkR8ka844WoswqOiks8oY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=G7DSa2e7r+iQqcDg8YzysjCUq1yBC86150LZCFjFa2bSWA1+Hi4IHyRrSob2XpA3PQf5oktH0uYQ2zVQG6Kk17Lwhdu2nDzGR1Su7+XXofK48TxEAfP8IUJu5/JTLJEu7MZeIKMBQgMWRErsQOkBzX3OueJfQZH0YYG43tXQVyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RB/+3aVh; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RB/+3aVh"
Message-ID: <eae2404f-1244-44a3-b0a2-c5393a508765@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756707915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOnv63QjSjHPCjFRfUrvkssYp2uqZNRCr8swyPDNqYM=;
	b=RB/+3aVh7OPnHwVSqw6gIAgQnLty3S/V04KeZ13/8Yx8seVLagHzzVZovDal9H5q9vrjnz
	beR/blaBywUfzvSDfeivAR+AHswPQ7qXoljLyqKcO5/2KtMdszswZ56VAZdLHJ3/3j7OkL
	ZeMBkkKRYgAXhaJdqtMhofzGMdL6LNQ=
Date: Mon, 1 Sep 2025 14:25:08 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] dm-pcache: use int type to store negative error codes
To: Qianfeng Rong <rongqianfeng@vivo.com>, Zheng Gu <cengku@gmail.com>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250829133748.104119-1-rongqianfeng@vivo.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20250829133748.104119-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/29/2025 9:37 PM, Qianfeng Rong 写道:
> Change the 'ret' variable from u32 to int to store negative error codes or
> zero returned by cache_kset_close().
>
> Storing the negative error codes in unsigned type, doesn't cause an issue
> at runtime but it's ugly. Additionally, assigning negative error codes to
> unsigned type may trigger a GCC warning when the -Wsign-conversion flag
> is enabled.
>
> No effect on runtime.
>
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>


Looks good to me.


Thanx

> ---
>   drivers/md/dm-pcache/cache_req.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
> index bd5cace7de71..27f94c1fa968 100644
> --- a/drivers/md/dm-pcache/cache_req.c
> +++ b/drivers/md/dm-pcache/cache_req.c
> @@ -805,7 +805,8 @@ static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache
>   int cache_flush(struct pcache_cache *cache)
>   {
>   	struct pcache_cache_kset *kset;
> -	u32 i, ret;
> +	int ret;
> +	u32 i;
>   
>   	for (i = 0; i < cache->n_ksets; i++) {
>   		kset = get_kset(cache, i);
