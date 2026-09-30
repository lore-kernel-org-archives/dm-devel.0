Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B7B4E4C4A
	for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 12:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790772571; cv=none; b=EZqmmmABOwPWBEcMcK9MCWdZJa/QTsqG6oWPMCjwaEsA9mYQRgxgSwK9/ZBdVnWTGOUwyDTUNdPSGY0o8kOvCop3xLPGyvUBXXviFJ6LQ05NjIXwQQRufbzOVhP4Fh9X7acA4nxkc+v+53qkcAqXxPvoEgLzk4dHgpGhyzsgIW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790772571; c=relaxed/simple;
	bh=TdyzSTHL7WYOVSGbZvbctK9FEuEdU7OX2Rp7WBlcsZU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=M3UqA4iFLCrEnW4DQL8sQuK0QzXe4F8eAL7yFnrlVn3VPMVh2lwYhmS7NDNRLfubCAS4Oxqy0eVlHCOSeBeGrcyz2pf188ClJgEfR4GWWSrtXGVZmjEtF+3AwKRt1tyka4c+E6IRCWtqsK5BfDKlCrmhj9DfGZF7q0/xsEGx0sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H7NQpMS8; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H7NQpMS8"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffde3cec6so22696695e9.3
        for <dm-devel@lists.linux.dev>; Wed, 30 Sep 2026 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790772554; x=1791377354; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/dhWIKwIs8lapn2MMhEevzHPS2BYYvsR1AqGmdi+y+4=;
        b=H7NQpMS8esZMcp7CzScT3yI4L4XyIIjsMMZ5kOUi559ir8CfJgxblVRtxzCiW/D5JF
         UYijY6j/fnmbFSdNvy9nDBfo/Kyv/rJSdCWW6WayaHIVydce9AeuxT62n4IfiKL9OPwn
         IG2Ni+Gst3XSaJUAjojgTvxua+qZ2xgCUZj0RHUmATGHYA8TSdwUnk7sprRtp2GgOHpm
         6L9wcl0G0GB3tDtqS21JfQbLby+fRMLNav6JtSsmzt5aZuHzTGacpAT1HfHPlgEIJYWD
         YLaL8xwouYLY2UUf31RA8iZ3bDN8Z1z7oj/JquIfjSHmKPVKANOWV6Sjb/SAi1fhr5cE
         FIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790772554; x=1791377354;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/dhWIKwIs8lapn2MMhEevzHPS2BYYvsR1AqGmdi+y+4=;
        b=DTg1SGLZwzhqGcsT//tsZHE33s6F7zvAhdoQl9jaYIw9lKs6kxnzb/F3zkV/0QY3YB
         CZEkccO+RxAN36L3+viJM9b40SvTLTctTWVfntKObMzhg2jOBp1fio4YYxq6zSgF6KjO
         jUtckXg9XEiZKpWtGjTijcgTZ2CTmYzu3nj5ikp9jbQYBYpBy9DcVptLOXhq8QmKaNMv
         lqUSm9H81X8zzVjoVcoQCSulWoAyexeShNLNn2KIXl7H1zecJgn7MgcnJ6RqC1mhScLT
         HLp/rIU/6Wt4fPYFUn7PwCy0WavWqArtNZE7HPY6qCF+8vD0iiC5lFOZyfRRvpRlTMKk
         hDGw==
X-Forwarded-Encrypted: i=1; AKwUvBx6tGrTGJ4+vLUBG49QhwNpmJiz3cuYCxOj+uPix+L+UC46UUsdQR53aV/5c9NR116ET7lhvM6igw==@lists.linux.dev
X-Gm-Message-State: AFuF++lJ1bAMTsVqObb5TqXasxEB8ICAYYw7wDF2W0fbyF/ZTrLACqbo
	ZfWTTPmiYS6TGggrogZyxJmS7spMJNtQw1zl3656EX7/nIPDIY0llDnK
X-Gm-Gg: AYBFou3cX8VSprOTDVn+c/i0+JMqkOBMxZgwfLJEsa8HLBmBSPeeHDe0zu8MMW/bygn
	x+eP2dMxIH22DAu6Gj7RQKOPbwuy0FMJVsFnJIXAMnrgroSNQymnxl5WXocMdBnzl6GRUHNC5Vs
	E7RCIxPVZFJf2GpeSXE25+crUCoUCcM6K9Z97TseLX2I/qkV3MLobMjM3WdPiv97eKfOiL5LENv
	gyn4Mg6ChUnpNWEJD1ZW0GjN+Pl0Zct/sulPj5LOoaXJwTCtHVI6bhu6k07RS1JMT+WsOMl7tVz
	pOiAL3PDuGF0uWI7lfIXUOSl9fr40LlTuPp4HkbXn+gzOWrETtiQyx8j3hnJzytjl8rQcADadFb
	yupEbQcnbnS/dXzTn/+mV+29ld7DfhLkw2QY0n79eitu43npev6JAI2XIbTQRPVsy6XSUMIkr8f
	wGjcNJrZxBFOYPAgzzutiedU8hIpP195nrG7LQFYWOfcN7qcJubGG8hj1XeoCjH2x5pS6rfRdmS
	M0Cnr3wHz/uGtdUPd9HBLabkvh+VYO1hhgDDZ1oZ4/mrPdj3RH1IA7JzhZ4U9opieOiTnjoJagU
	H9I7w1PoBlMs9iAIHDc47iy+Hzl/2b+qqIyK
X-Received: by 2002:a05:600d:864b:10b0:4a0:2dd:7573 with SMTP id 5b1f17b1804b1-4a01b12b666mr16604625e9.33.1790772554145;
        Wed, 30 Sep 2026 05:49:14 -0700 (PDT)
Received: from [10.54.182.141] (82-132-212-25.dab.02.net. [82.132.212.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01cb8abc1sm3766935e9.0.2026.09.30.05.48.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 05:48:57 -0700 (PDT)
Message-ID: <c07404e0-33f6-4e5f-a80a-e1901b42dc39@gmail.com>
Date: Wed, 30 Sep 2026 13:48:49 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/13] dma-buf: introduce initial file I/O
 infrastructure
From: Pavel Begunkov <asml.silence@gmail.com>
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
Content-Language: en-US
In-Reply-To: <447c04dd-6bfa-4c45-99e7-37d25a7ab539@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/30/26 11:08, Pavel Begunkov wrote:
> On 9/30/26 04:00, Matthew Brost wrote:
>> On Mon, Sep 21, 2026 at 02:38:45PM +0100, Pavel Begunkov wrote:
> ...>> +struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
>>> +{
>>> +    struct dma_buf *dmabuf = ctx->dmabuf;
>>> +    struct dma_buf_io_map *map;
>>> +    long ret;
>>> +
>>> +    guard(mutex)(&ctx->map_create_mutex);
>>> +
>>> +    scoped_guard(mutex, &ctx->map_mutex) {
>>> +        if (ctx->maps_killed)
>>> +            return ERR_PTR(-ENOENT);
>>> +        /* recheck under the lock in case it has already been re-created */
>>> +        map = __dma_buf_io_get_map(ctx);
>>> +        if (map)
>>> +            return map;
>>> +    }
>>> +
>>> +    dma_buf_io_wait_active_maps(ctx);
>>> +
>>> +    ret = dma_resv_lock_interruptible(dmabuf->resv, NULL);
>>> +    if (ret)
>>> +        return ERR_PTR(ret);
>>> +
>>> +    ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
>>> +                    true, MAX_SCHEDULE_TIMEOUT);
>>> +    if (ret <= 0) {
>>> +        if (!ret)
>>> +            ret = -EAGAIN;
>>> +        dma_resv_unlock(dmabuf->resv);
>>> +        return ERR_PTR(ret);
>>> +    }
>>> +
>>> +    map = ctx->dev_ops->map(ctx);
>>
>> I'm playing around this code now.
>>
>> I think you need the dma_resv_wait_timeout after the 'map'?
>>
>> If a device doesn't support p2p ->map() will typically trigger an async
>> migrate to system memory and data will be moving but the map is valid -
>> Xe 100% does this, I checked AMDGPU and fairly confident it has the same
>> async behavior.
> 
> There is a wait right before because I read somewhere in dma-buf
> comments that I need to do that, sounds a bit odd if I need to
> wait on fences before and after. I can add it, just curious how
> come that other dma_buf_map_attachment() callers don't need to do
> that. Or maybe they wait somewhere else?

I can't find it, so maybe it was the comment below and I mixed
sth up back then. I'll move it after ->map().


* Note that for non-dynamic exporters the driver must guarantee that
* that the memory is available for use and cleared of any old data by
* the time this function returns.  Drivers which pipeline their buffer
* moves internally must wait for all moves and clears to complete.
* Dynamic exporters do not need to follow this rule: For non-dynamic
* importers the buffer is already pinned through @pin, which has the
* same requirements. Dynamic importers otoh are required to obey the
* dma_resv fences.
*

-- 
Pavel Begunkov

