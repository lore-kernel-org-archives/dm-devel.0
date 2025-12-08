Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEEB313E13
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765194305; cv=none; b=kedVl/kxycYtKoK/b8aRuvMiSo/RSGgh41o3w7fTK2n5St73AeOeT70wZvnwhJbUT5PjLx3rFA79Xx9SuG29dZpWfs2AugWMqsPyk9vX2uS7TVhxVaJyVIeC1Xn0wyxTRvLcLN3ur6Z/zfcoEbc5bjGhAvuhMhpt8sobhaIUz/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765194305; c=relaxed/simple;
	bh=B5Z/LWA66KUQAgA9+ADggQpyr8rLcggyGMYqA0K/8os=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tqzSwZ18NgSaLvmV4cFY55RgM1jB7EgJZOLnpA5OjqpY3QjRHETjyPpQYFqLA6JUt5Mo4+OcZbP9mFSpsO1feJSo6WhPjp/++304011uqAiDsAhTDurmLg2B6DAD5qlrrt4Uc1k2aiDc2iDQ5LPP6yyML+2C5RWn/rluLqwb6B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NvLqXKyw; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NvLqXKyw"
Message-ID: <562c7d90-7c8b-46ef-b01f-561d86c722b4@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765194290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQOnZQNSjH3DDLTAQc1pI6icakUIYM6RrLvZTLiToEs=;
	b=NvLqXKywZCIzFS9ZnwFbiiDjZcsSFVr2ICiERlVfdqBQXFzIP9h0abDFoiTwbZnpDDbNK6
	R3f9GVnM79lgU2v+DJKt8NDcJYB86plLCYb5ofYwV12zf2DUXEKDhgei0fkjvEbLfiUZc1
	Tv0aealkEd+nUhPknfTXa/QDCA7GTs4=
Date: Mon, 8 Dec 2025 19:44:40 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] dm pcache: reject mappings larger than backing
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20251208112552.147756-1-me@linux.beauty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251208112552.147756-1-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/8/2025 7:25 PM, Li Chen 写道:
> Reject pcache targets whose logical size exceeds the backing device.
> Prevent oversized tables from issuing IO past the end of the backing,
> which may corrupt memory and cause kernel crash.
>
> Signed-off-by: Li Chen <me@linux.beauty>
> ---
>   drivers/md/dm-pcache/dm_pcache.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
> index e5f5936fa6f0..f72d1ba4b740 100644
> --- a/drivers/md/dm-pcache/dm_pcache.c
> +++ b/drivers/md/dm-pcache/dm_pcache.c
> @@ -199,6 +199,8 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
>   static int pcache_start(struct dm_pcache *pcache, char **error)
>   {
>   	int ret;
> +	struct dm_target *ti = pcache->ti;
> +	struct pcache_backing_dev *backing_dev;
>   
>   	ret = cache_dev_start(pcache);
>   	if (ret) {
> @@ -212,6 +214,19 @@ static int pcache_start(struct dm_pcache *pcache, char **error)
>   		goto stop_cache;
>   	}
>   
> +	/* Sanity-check: logical size must not exceed backing device size */
> +	backing_dev = &pcache->backing_dev;
> +	if (ti->len > backing_dev->dev_size) {
> +		pcache_dev_err(
> +			pcache,
> +			"backing device too small: logical=%llu sectors, backing=%llu sectors",
> +			(unsigned long long)ti->len,
> +			(unsigned long long)backing_dev->dev_size);
> +		*error = "Requested mapping exceeds backing device size";
> +		ret = -EINVAL;
> +		goto stop_backing;
> +	}
> +


Thanx for your patch, When developing dm-pcache, I considered whether to 
add a check there (for target size vs backing device size). But after 
looking at other existing targets, it seems none of them implement such 
a check, so I wasn't sure there is a requirement; hence I didn't add it 
at that time.

On the other hand, given that the “target size” parameter in the mapping 
table is a generic parameter, if we want such a check, it would be 
better to implement a generic mechanism in the Device-Mapper core 
construction path — provide a hook that allows every target to return a 
“maximum creatable target size”, and then in the core path validate the 
user-provided target size against that max size before creation.

That is just my personal idea; I hope Mikulas can provide more 
information about it.


Thanx

>   	ret = pcache_cache_start(pcache);
>   	if (ret) {
>   		*error = "Failed to start pcache";
