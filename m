Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1941BA61
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 11:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791200962; cv=none; b=fuhAP08aT4yz794AtYnmwRN6kQexn9MmnVL9zXBSSDiPefEPHNsM+VWwiuSlM9ctg+Wg2xuxURmNvg4rP5dqxoR274cCxECxGNPq5eFPLS5wssHjMMH6hhEVpxrX8W/Ho9alGse+jQviPGFaLrfVa9JNOdUNPaJqHYGE3nrx7RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791200962; c=relaxed/simple;
	bh=C4rWPxAM+gG+nBkU+Lpq5+tCLNPh5lzEfMeHsRf0DPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dtpPpUeh37ze4Zi+t/OIdayKRbyJ8PtDIzQ2j2Qn+BDM4i8jdXdLgiiwhy3I96vcgwkDru4bJMZ7Vvz6sZ2oFq+VmEkJJqg8VjLYDGhQ/yVvZj0VnF3D4CKqQk3C2veP1OoRq/NOtKoSaHUm0kzETeFLtCIGnRRnxani43E8a8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMAtTjpC; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMAtTjpC"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a11603310fso15601635e9.1
        for <dm-devel@lists.linux.dev>; Mon, 05 Oct 2026 04:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791200959; x=1791805759; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tN32JBtkwvrpOHkqPOwCz1peQMff+9nW+9FnKuTc/9Y=;
        b=VMAtTjpCgp3oyOce0v2uh7KGuZ6iitDuyesTHvkjNFLsoB7wmlojY6N54voqyvmSWB
         lKUSzxzPK2NWuk7YSLrFg7LRBYkYZKR8rYI1TiQpy2ksQz7KPguHWzRCAVguslTcUSv+
         o2OtisIp63FSKPCCKMaacucGWI+Va8+TpY6n2l5l6YqPJV4J2tGfLWLm++k/vTwU2Esl
         5P6vJ4E7I1lALHjpmvFHboA21Aqh2y5y9Oa6iDkD5lHDV7pxc5A5Ulwl6PbZ+Df9Mwje
         3+38IrHWswg08ZfZSIN0h4f+tBrILm8WNOobMBHgUEXvptrGK/yREBIw4g5VO3IlF4bb
         qjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791200959; x=1791805759;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tN32JBtkwvrpOHkqPOwCz1peQMff+9nW+9FnKuTc/9Y=;
        b=ZalXhB7yQvOfafGPzAEK6r63yu4oBzZgIcBjnIn8l+4ZmsvVw17/K5f0cxTBwwESni
         Gnz92aq4gW2sX+UPc96WB3BhVWnE6H4VMSB9a0NTXxmwai7rCmnSLbOV6KN7IgQR8if6
         iIN5M4tAFnD4ZAR8R8++vhfODOG8oezZHOAuaaqgFN0m5sVQOyPtcvfiQ22MvDLwtghI
         4YGj/uF7WvLJ68sNieOUDX7MJv4jBjsavkieVr7P6Zr9ivCqKw395VJSGnT/pIiwzUAU
         UzckLjHS/6zES+yxHEMuw34MZaCO4NOoxBCXN+j1qa2W2dCsQIRJvb3vkGEvRyAxclfo
         R7pQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlDKha/tuARAJQDJ6ytMuJnT85wHTc+qJdzc9V13a0d8RPCtX2R8X/Iye+4RDrHmRSujXQiKozsQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lc74L16u2SuwWl+X/B+sc3Im6sMenNQnWqpiyPkcELPD6Rqhhx
	p2JT/IEs/53rn3S/I3r44aS/xbHl5cXCeSnhJVuAH3d0EJxKe4jd26bC
X-Gm-Gg: AYBFou2yjS/bEXsYEvBlgXKDqFDJRdJXGmFDOxtTGvV7GgpEcn1x2FrTwzOVr/kL6X7
	y0UQvivXnuON32aLNvWnHhO8hiJOaM2ZtVDBUCn5ORdVgoyaW8X1A0FevznejV12JT1SwQDJKTJ
	IUcQho/Wj9wN+uG76PUal10Fj2jkSnJoxoHFOLGxo2Rh/GKKsC6NvNcANF6Rgmm8UEqJs0/5bW5
	Pu7uRVDLh1OQRYJvipbP6un3gz/cF2a6u2hVWt7aXBRvDzj9UUaBWX2c5XsHE5UnCq1uHDLUp3Y
	APUiDfk0nzDS1vnSU2z+/2c3IPWDSNhiwulQdsYIXj3C3sqP48zvekJoIQpz2n5W50ViJ5Lfybc
	qWshPn5clrWhyebkEzgO5DZXpeFhOkSsZNOyw6jkgZl5ZAWefQcsOimaMpKEZujZoxG/0uu23wP
	fdf7vJxRUqfPKiVYs+9qAyrXfVZz7y+vfCZsjlsmyGXOfluNho2U8+2dSULzkKuxpktsiz3rk1x
	lj5QRIsAl4Sbh03FMUm4Pxnvgr6fTG9Q7JzbeEMiiD1LDkPBmniq9diqPuyZwNAxt6Z3hCUnFI=
X-Received: by 2002:a05:600c:1c08:b0:4a1:722a:d2a3 with SMTP id 5b1f17b1804b1-4a1722ad405mr52583605e9.23.1791200959268;
        Mon, 05 Oct 2026 04:49:19 -0700 (PDT)
Received: from [10.41.30.1] ([161.12.45.16])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027727cecsm346670305e9.9.2026.10.05.04.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 04:49:18 -0700 (PDT)
Message-ID: <c15a7ff3-121e-481b-93e4-466f89520ae4@gmail.com>
Date: Mon, 5 Oct 2026 12:49:15 +0100
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
 <447c04dd-6bfa-4c45-99e7-37d25a7ab539@gmail.com>
 <c07404e0-33f6-4e5f-a80a-e1901b42dc39@gmail.com>
 <ar1md2N4PkoXSE/N@gsse-cloud1.jf.intel.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ar1md2N4PkoXSE/N@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/30/26 20:43, Matthew Brost wrote:
> On Wed, Sep 30, 2026 at 01:48:49PM +0100, Pavel Begunkov wrote:
>> On 9/30/26 11:08, Pavel Begunkov wrote:
>>> On 9/30/26 04:00, Matthew Brost wrote:
>>>> On Mon, Sep 21, 2026 at 02:38:45PM +0100, Pavel Begunkov wrote:
>>> ...>> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
>>>>> +{
>>>>> +    struct dma_buf *dmabuf = ctx->dmabuf;
>>>>> +    struct dma_buf_io_map *map;
>>>>> +    long ret;
>>>>> +
>>>>> +    guard(mutex)(&ctx->map_create_mutex);
>>>>> +
>>>>> +    scoped_guard(mutex, &ctx->map_mutex) {
>>>>> +        if (ctx->maps_killed)
>>>>> +            return ERR_PTR(-ENOENT);
>>>>> +        /* recheck under the lock in case it has already been re-created */
>>>>> +        map = __dma_buf_io_get_map(ctx);
>>>>> +        if (map)
>>>>> +            return map;
>>>>> +    }
>>>>> +
>>>>> +    dma_buf_io_wait_active_maps(ctx);
>>>>> +
>>>>> +    ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
>>>>> +    if (ret)
>>>>> +        return ERR_PTR(ret);
>>>>> +
>>>>> +    ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
>>>>> +                    true, MAX_SCHEDULE_TIMEOUT);
>>>>> +    if (ret <= 0) {
>>>>> +        if (!ret)
>>>>> +            ret = -EAGAIN;
>>>>> +        dma_resv_unlock(dmabuf->resv);
>>>>> +        return ERR_PTR(ret);
>>>>> +    }
>>>>> +
>>>>> +    map = ctx->dev_ops->map(ctx);
>>>>
>>>> I'm playing around this code now.
>>>>
>>>> I think you need the dma_resv_wait_timeout after the 'map'?
>>>>
>>>> If a device doesn't support p2p ->map() will typically trigger an async
>>>> migrate to system memory and data will be moving but the map is valid -
>>>> Xe 100% does this, I checked AMDGPU and fairly confident it has the same
>>>> async behavior.
>>>
>>> There is a wait right before because I read somewhere in dma-buf
>>> comments that I need to do that, sounds a bit odd if I need to
>>> wait on fences before and after. I can add it, just curious how
>>> come that other dma_buf_map_attachment() callers don't need to do
>>> that. Or maybe they wait somewhere else?
> 
> In GPU drivers, when we receive a foreign object and map it in Xe or
> AMDGPU, this logic sits deep in the stack. However, the top-level call
> is typically ttm_bo_validate(), which in both drivers eventually
> resolves to the TTM ->move() vfunc. That path calls
> dma_buf_map_attachment(), which in turn invokes the dma-buf's ->map()
> callback.
> 
> That ->map() callback can trigger a asynchronous move on a different
> device, where the top-level call is again ttm_bo_validate().
> We then end up back in the TTM ->move() vfunc, where kernel fences are
> installed. I realize that's a lot of layers, but the call chain can end
> up looking like this.
> 
> Now we have a mapping and an object with kernel fences attached. Before
> the object can be used by either the exec IOCTL (batch buffer
> submission), the VM bind IOCTL (mapping into the GPU address space), or
> a CPU page fault (not relevant for dma-bufs since they cannot be
> CPU-mapped, but a useful example of a normal BO move), we wait on those
> kernel fences.
>   
> In the case of the exec IOCTL or VM bind IOCTL, the kernel fences are
> added as dependencies to a drm_sched job, delaying its execution until
> the fences signal. That is where the wait occurs. In the case of a CPU
> page fault, the kernel waits directly on the fences before installing
> the CPU page mappings.
> 
> So the TL;DR is if you want to immediately hand back a valid mapping,
> the kernel fences must be waited on before returning after ->map() call.

Thanks for the overview! I'll add the wait after ->map in v8

>> I can't find it, so maybe it was the comment below and I mixed
>> sth up back then. I'll move it after ->map().
>>
>>
>> * Note that for non-dynamic exporters the driver must guarantee that
>> * that the memory is available for use and cleared of any old data by
>> * the time this function returns.  Drivers which pipeline their buffer
>> * moves internally must wait for all moves and clears to complete.
>> * Dynamic exporters do not need to follow this rule: For non-dynamic
>> * importers the buffer is already pinned through @pin, which has the
>> * same requirements. Dynamic importers otoh are required to obey the
>> * dma_resv fences.
>> *
-- 
Pavel Begunkov

