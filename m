Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872AC3C98BF
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 10:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790762897; cv=none; b=MzmHRS+fDDvLRkL0M/+45rVsudPoWG2jiMZ7h3N6prW8kyUm0jDhBIMr3lwiopd8UGVHieGJGt5XwUPBZjDd3adcYcto9XcQ1iQO7A8i6j8A8p72MbiiRgXV1ButhekxagdaYPuqClDUjlx53UqDcvdNITaDgU6axu3yUxR55XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790762897; c=relaxed/simple;
	bh=yFJZlb+iGZsfhNjOANXyz0l3Z8bjj8XhD2cNkl79VuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kf9R9m6grso+MTbvEHP/v09yPSSEDcsMrVzwTkxPUd40ISUGwWjxGec5WYEhZZkDUW/IqvGNNNJgfBxxN2lBLitiBPb3HalIkmzIe+YcshKtBS6jbBNNq4U0CLj1ZWN7/ajY/J0rF0p/zp7THxvMGz/VuZzzLqtAINkdujXkeoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evrvX43f; arc=none smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evrvX43f"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aaea1cb2e4so6422545a12.2
        for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 03:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790762892; x=1791367692; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L6C6Fqcl7JBjpTUHBHO+U+uYrchMJCAF5saUsMOGnSk=;
        b=evrvX43fhgwjR3KPu7XaRF1MchkPWOMzAuIle248NGey5CApM1GlDUNyDHbLEVlkcF
         1Zm7A2CM/MOY2Gv6/qrkVgLQWVZ4ZfZ2A+pkDdqIMODAAOji0qS4Tye7Ec/XhypI8ofE
         UfBtkzn5g87osAv3n5qxTQ0tZMqsGNqZfVB+7hBvlOsjSuMtJ36gH/VGPEmrompu6EMG
         QLr+b1fNpbz3aEbdhMoBU0V3pZBmSOztBHjUxzcfSFlVwx1FJ1pQblnr3fjzpT+KsElB
         a0PvZsYoQlQpuGvvvZWRxgFkwAqsOQnwjUH7o0MkI0F6Tex1koUlL3RyHJvyfW29vCel
         IwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790762892; x=1791367692;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L6C6Fqcl7JBjpTUHBHO+U+uYrchMJCAF5saUsMOGnSk=;
        b=RAy96OkAkYXsAVy4JX8yzeOLsJxkGJDP2pnCQCHOiZi+xr7NIw0Rm3ZjqzcAUayD1T
         aog/6eY9b0qk0D48mT8nzqY4inviV5QPtgQd2+wcTVacvNe7wWGzi4QOmtxxnC9shE7T
         Ud7RF7PB5ExTMLOygnpU/RL7L70D+IKQOYoVwjEJzbw4rsXBx/NUmPB21dnAPnf7SgNS
         h4wF13/2me/BcN9vK641wgHm2L6kZm3LRnq5PUPpLsuzF+Dx9LQRwLYrqVHHSihI4QX8
         SJy47ljIL73s3Q7CZt7ERpGktrhcv6oCw3GrniZcOWsZz5fDknyASf5zfF3OnfIpw35B
         6kUw==
X-Forwarded-Encrypted: i=1; AKwUvBxDW7Ap362sSPzJ0QCPCOtIjGe/5vdiedslwuazzCTEtzDxlQfUne63y57lSSrpSNKJ9amqvFBv7w==@lists.linux.dev
X-Gm-Message-State: AFq9FYKT64J4E+as8sHBDu7fRhpuxscvtrZgJSlHKhf7BZNoKBVgj8bR
	dsRRSZj5OpmU8ehO2AA6rNCLvS5pm8iGpsH6AEKCqPnoNljKxCgpgszE
X-Gm-Gg: AYBFou15TGRtwJ+N8d7YB0WQpek0M5Qf4GR7S+jhd7DIXgW9tB3qcghvTWmpXNvVDcE
	wkPDBPtrPYzZSqFg5MpBfO42QiuKjCUmoyM8t1VTSMKSrqzG0fcArjOCzLP++dG/SYpqZmsvaC3
	GmUnmN5tQApL47q6CZw1NT3xnLxxJfeulS8ys+0PFyLNd0YQ05rpshQ2PfHlX+nfHQ5+/QWtZeI
	xQGBfcEabzt2NuVToDdW9kwt4cx8NXhB0Yuqx2SA799mM+HmPOYlB8UeVqsRTNR1PEp7ql6MgYz
	kCNCyxR9Q9ZuG0+Olzqvoljf8MpMDYJjcWBDs7Aa2yqnmWxrPoKuNDIBR14gR8dHXun8gRCVfTk
	a/ED3RN9uHXLUq9V7+0aMgqvqeIAppah1Z3AUIMZ/6CUTc7mnRhexnGAJiiLgKysbIwHJ41s0Da
	rJonFH1nk43n+BfiC2FrXstkejzbYQX0A19DKj2kg5tFCR6blydtYa1AA7C1F1E/EnyRHClfOqC
	2Fbexf39L6Gq6SDfBBv/Wm0vZ1awoKW/Sy9OvhbBBREosQEd/H7RW9AkDgX5jIA2zXewlC98o4o
	qESR9Sz8x1C0tNUPqYtpIeMMUzutGtMTOrs9M6HuBnhck5tR
X-Received: by 2002:a05:6402:42c4:b0:6a9:a362:4646 with SMTP id 4fb4d7f45d1cf-6ae198f0fbfmr582772a12.14.1790762892209;
        Wed, 30 Sep 2026 03:08:12 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ae156adf4fsm527943a12.32.2026.09.30.03.08.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 03:08:11 -0700 (PDT)
Message-ID: <447c04dd-6bfa-4c45-99e7-37d25a7ab539@gmail.com>
Date: Wed, 30 Sep 2026 11:08:06 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/13] dma-buf: introduce initial file I/O
 infrastructure
To: Matthew Brost <matthew.brost@intel.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1789997898.git.asml.silence@gmail.com>
 <5490ee42c4452fd4198b245ead20fcf7438c066e.1789997898.git.asml.silence@gmail.com>
 <arx7ZQ8o9aeHsAqS@gsse-cloud1.jf.intel.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <arx7ZQ8o9aeHsAqS@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/26 04:00, Matthew Brost wrote:
> On Mon, Sep 21, 2026 at 02:38:45PM +0100, Pavel Begunkov wrote:
...>> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
>> +{
>> +	struct dma_buf *dmabuf = ctx->dmabuf;
>> +	struct dma_buf_io_map *map;
>> +	long ret;
>> +
>> +	guard(mutex)(&ctx->map_create_mutex);
>> +
>> +	scoped_guard(mutex, &ctx->map_mutex) {
>> +		if (ctx->maps_killed)
>> +			return ERR_PTR(-ENOENT);
>> +		/* recheck under the lock in case it has already been re-created */
>> +		map = __dma_buf_io_get_map(ctx);
>> +		if (map)
>> +			return map;
>> +	}
>> +
>> +	dma_buf_io_wait_active_maps(ctx);
>> +
>> +	ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
>> +	if (ret)
>> +		return ERR_PTR(ret);
>> +
>> +	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
>> +				    true, MAX_SCHEDULE_TIMEOUT);
>> +	if (ret <= 0) {
>> +		if (!ret)
>> +			ret = -EAGAIN;
>> +		dma_resv_unlock(dmabuf->resv);
>> +		return ERR_PTR(ret);
>> +	}
>> +
>> +	map = ctx->dev_ops->map(ctx);
> 
> I'm playing around this code now.
> 
> I think you need the dma_resv_wait_timeout after the 'map'?
> 
> If a device doesn't support p2p ->map() will typically trigger an async
> migrate to system memory and data will be moving but the map is valid -
> Xe 100% does this, I checked AMDGPU and fairly confident it has the same
> async behavior.

There is a wait right before because I read somewhere in dma-buf
comments that I need to do that, sounds a bit odd if I need to
wait on fences before and after. I can add it, just curious how
come that other dma_buf_map_attachment() callers don't need to do
that. Or maybe they wait somewhere else?

-- 
Pavel Begunkov

