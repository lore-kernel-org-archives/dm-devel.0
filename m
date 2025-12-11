Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A118C31
	for <dm-devel@lists.linux.dev>; Thu, 11 Dec 2025 08:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765441210; cv=none; b=BSwtiZhuMb9F2CQ8mksUGkZXguXzoAH7NOT4p+jIn7x9GWSESV211l5Vqlz763AnWq5aXsuFToA5BIRUYMLsasLnnTudc5huxBSZAmqVbO+wgk5/3Nc9RBuL5QWYkK/1pmBDGPQx9/JSt0cAbvV7D3GqMcFfDBXEbmhHdYqp+4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765441210; c=relaxed/simple;
	bh=JlUzvek7pJ1IYrQehzCnHkYOM+ve9q2kbzXXqtDu02c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KB6pMJK/fLO4SuMqFyrSxj195ZsFtu8cAHH7X5N5S86zxJUlAQBb8WVtlaiLjKXuJrHrIY58BzlO/TFWImSdeoXGkI/K6tAwtVIvimAYHCqEuou7eKEDWmyi7dZ/0jsvFBcJ4HmC5rQwrqR371De9p6BGXs2wE6wuLI1wNGDW5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M7VxHgMV; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M7VxHgMV"
Message-ID: <ef533f19-96a9-4e14-be1d-2290677cbfd2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765441205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vJ4zuwMQqnU4tQweN72pNdXq/0pKXB2ff8NgiuFKJ74=;
	b=M7VxHgMVL6x36uIdMO1VKIAt4D+gOfqPD1A/HvvqIeXrb1Y+PSFjI860f946pS2mD73zB+
	5EoeSmuuqzdZaqKgASDOEqeL88q4Fs03BbOksKeB6925Je/yq0Wt1oC8dHKOeUyJVsUj3v
	0ZsSsvSNfkGiDZCqAsBFlZeeoznqO5w=
Date: Thu, 11 Dec 2025 16:19:56 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] dm init: ensure block device is ready before creating
 mapped device
To: jaeyuel.im@lge.com, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251211073426.123026-1-jaeyuel.im@lge.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251211073426.123026-1-jaeyuel.im@lge.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/11/2025 3:34 PM, jaeyuel.im@lge.com 写道:
> From: "jaeyuel.im" <jaeyuel.im@lge.com>
>
> The current implementation of dm_init_init() uses early_lookup_bdev() to
> wait for the device node to appear. However, early_lookup_bdev() only
> verifies that the device node exists and returns the dev_t. It does not
> guarantee that the underlying block device structure is fully initialized
> and ready for I/O operations or to be opened.
>
> On certain platforms (e.g., embedded systems with specific storage
> drivers), this can lead to a race condition where dm_early_create()
> attempts to open the device immediately after early_lookup_bdev() returns,
> but fails because the device is not yet fully ready. This results in boot
> failures as the mapped device cannot be created.
>
> This patch adds an additional check using blkdev_get_no_open() after
> early_lookup_bdev() returns. This ensures that the struct block_device is
> actually available and the device is ready to be opened, effectively
> preventing the race condition.
>
> Signed-off-by: jaeyuel.im <jaeyuel.im@lge.com>
> ---
>   drivers/md/dm-init.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> index ff9420f06483..76b84ca39906 100644
> --- a/drivers/md/dm-init.c
> +++ b/drivers/md/dm-init.c
> @@ -299,10 +299,24 @@ static int __init dm_init_init(void)
>   	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
>   		if (waitfor[i]) {
>   			dev_t dev;
> +			struct block_device *bdev;
>   
>   			DMINFO("waiting for device %s ...", waitfor[i]);
>   			while (early_lookup_bdev(waitfor[i], &dev))
>   				fsleep(5000);
> +
> +			/*
> +			 * early_lookup_bdev() only checks if the device node exists and
> +			 * returns the dev_t. It does not guarantee that the underlying
> +			 * block device is fully initialized and ready to be opened. On
> +			 * some platforms, this can lead to a race condition where
> +			 * dm_early_create() fails because the device is not yet ready.
> +			 * Ensure the block device is truly available by attempting to
> +			 * get it.
> +			 */
> +			while (!(bdev = blkdev_get_no_open(dev)))

You need to pass autoload parameter for new blkdev_get_no_open()

"struct block_device *blkdev_get_no_open(dev_t dev, bool autoload)"


Thanx

> +				fsleep(5000);
> +			blkdev_put_no_open(bdev);
>   		}
>   	}
>   
