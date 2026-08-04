Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A8248550E
	for <dm-devel@lists.linux.dev>; Tue,  4 Aug 2026 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785863962; cv=none; b=eWuI4CPYUxnGc7DZGjduYwtXPZM2DRTMEVvb3nM7IYT7hriGu9+z9r/z7JhccSon8wNocjg9HnL9k84HuubK3eP6PDcNo0w1ZNQVC7cvrBSrawO0vsAVRmQxq9b+97qLuur5oxtzrHzhJjJLUNNHN8wAmWujaYykAHPmGoMJKw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785863962; c=relaxed/simple;
	bh=fiynAW9WpUzgt3N4BHN/WeqgVQsTYwv6Egh7edSdGZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L5r/bBYfgIAXf9jV8ir/uQJ8JbenbruvTsZYYPQNXZZzk/p0jnwB7bF2WtQfdof0YccdZsD9QKENPh0MuGHa0Qfzpoay4+cDOp+4Kk2W/M0QfDH8owDQ2FWD6QO7fnnBBc9k5sJ+0MepwHYpCtuwC8IyUtNsPR2Iayo96YGwASw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AGxGwy4d; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AGxGwy4d"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so31627f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 04 Aug 2026 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785863949; x=1786468749; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJpsobbV6cDtzB2hYIU7sj8yXmkuFvAex2Z4hVps0ns=;
        b=AGxGwy4dfrI1cN+ezzNAe+E7ix9SVbKzUWy+ec2YqukczbXL85mSrjwNB8CnqjW2xO
         bvd7n2C9g0/Y615hXolwx62WJye7SiwAkpGdJkORfR4xZbYx9tl4VMHa0wkLHD1LbGBe
         /ik+9bWUG3J+eEaJLAD8CCh3jfPyHNym96dRz3Zanc7D012kJPuMCwOUCWBQdGE9Gxgw
         Ym+sGPCia7l9GDl8iO7Bj/Tx+V76Eskb6UIu4WAT2MmQ49fi9pz/OxSeuKtGqse4f2N4
         gIv8jtV6fy+pc607uQPG7UMm4MO7c3Cy5BVHWbfM83AUfyGsCqEalu/Ogvajp0VJySu1
         YR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785863949; x=1786468749;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kJpsobbV6cDtzB2hYIU7sj8yXmkuFvAex2Z4hVps0ns=;
        b=eTqAkppy6kHFMIdn0L8g7dJrq++s54cx9ZAbSQYeohhn9deR6eB8Rl78m0KEFZtBfL
         eSxUT3F2A7lGLYuZhmlK9x2knNB8p47UfdZVcviJP4V4C59ZfH0hSPTq/zjiv8980u8E
         EPSrZjRUQ+yr0vkgIkUbGRbTfgLmiBA8TV1DSWeJqjIRRmzOo5jrqNGPOPz2lurLAcC0
         n4sYJk1wVvkQVjas+FcSN0gQhrbWuOcQtwVjzNeJVFWxKa5/dv3I6ysmbmq1AYaYK7TQ
         V+Lf7KZ7AUkEIinEpXqrIW3WSjYXfL1kKoStK35q+Z5ht9kvO96lmsrNeWv0HO8NaNgZ
         wRhA==
X-Forwarded-Encrypted: i=1; AHgh+RoPvflYxFUYGNW3R7QY5/vl1onVMXBNHJ0br7rISb7y6Z0izPiRr/XF7+5gDIirHp+rLOmCHTh2bA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyL8JlbWfYAMSw4GFwQrgMCAHxgWa2NPLfNLI9k3tgp47SFKaZW
	6CZShPsp+wFfHQgnuXmb4yF0ED+m+xInFhRtk60lsrOhSJ7/ncoGowaQ
X-Gm-Gg: AR+sD10HPOD5Al3yFtp+gM081k6/X9QGyyV4oJWpk5cRBLjxHiK4aa/B58KOt0cf47j
	CWAnMNWyTO9sUoOn29IC8jdk1YS3C/EaLO56YBE57TP71k893LVr7d12EAHMDDaSaOI30oHUiij
	xCNSRbSBcP6YWWaTjoZbZ2NtsJfG/+SyOXs9Pjvc+uX7GkaoVK/PiXUpwzGzvZjO2RawjT9+M3i
	o9ezsa3YYQZXJR55JGzb7XC0ZsW9NgJUwNz/2DmOYy/+7yvKOMPzQbBmMe6Ts8/62XyGfyZcGbe
	KkEBNTNdKqWPQHDJUR6drHyNIlW+XonAIinvnny/KHxr/4iPKxYg/w29o2TaZV3kPSC0dU0mDNR
	TANMLnlS02QbX6mr0pgkzaQ90g5zaxHmJ6cOXcPGENQIULp6YT6VSNrwgwPoS840BiqTWptsLRP
	mcyQKA91MrrRBARQSdqgXFFoHs1dt+0AspqrWJoEaqF7HXeLhR9ki1/UY4prepcx5h4ZGVJdqfo
	QWg4h7ZZuyNS8Z/4Mm2dCmSMFgJXZdCFirV6vWgYztWewgGgJNEdS2YgG7xb8L5G3V2Gq/5txsR
	A9sY/mvqu+JzB9t5NpSjM9ZccJsu08akBkZRur4=
X-Received: by 2002:adf:fe49:0:b0:47f:941a:796d with SMTP id ffacd0b85a97d-47fec4fa3admr1381301f8f.12.1785863948785;
        Tue, 04 Aug 2026 10:19:08 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfda6afsm1357370f8f.3.2026.08.04.10.19.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 10:19:07 -0700 (PDT)
Message-ID: <38163009-770f-4596-abe2-249efc113f59@gmail.com>
Date: Tue, 4 Aug 2026 18:19:02 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/16] block: introduce dma map backed bio type
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785596451.git.asml.silence@gmail.com>
 <e26aefbcb383be7092dc76343ce745013e671334.1785596451.git.asml.silence@gmail.com>
 <20260804162440.GB12292@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260804162440.GB12292@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/26 17:24, Christoph Hellwig wrote:
> On Sat, Aug 01, 2026 at 04:46:19PM +0100, Pavel Begunkov wrote:
>> Premapped buffers don't require a generic bio_vec since these have
>> already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
>> maps as they are mutually exclusive.
>>
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
...>>   
>> +static inline int bio_split_io_at_dmabuf(struct bio *bio,
>> +		const struct queue_limits *lim, unsigned *segs,
>> +		unsigned max_bytes, unsigned len_align_mask,
>> +		unsigned start_align_mask)
>> +{
>> +	unsigned bytes = min(bio->bi_iter.bi_size, max_bytes);
>> +	unsigned seg_shift = bio->bi_dmabuf_map->seg_shift;
>> +	unsigned offset = bio->bi_iter.bi_offset & ((1U << seg_shift) - 1);
>> +
>> +	if ((bio->bi_iter.bi_offset & start_align_mask) ||
>> +	    (bio->bi_iter.bi_size & len_align_mask))
>> +		return -EINVAL;
>> +
>> +	/* single contiguous range into the dma-buf */
>> +	*segs = 1;
>> +
>> +	bytes = min(bytes, ((unsigned)lim->max_segments << seg_shift) - offset);
> 
> I guess ->seg_shift is some sort of encoding of a max
> segment size?

I'll add a comment.

We rather need the minimum segment size, you can always split large
ones. I calculated it even stricter as the least common multiple
pow2 to avoid divs here.

If the device supports N segments and we know that each segment is
at least M bytes, then we should be able to issue IO of size N*M
of full segments. The line above truncates the bio size using
that + offset adjustments.

I guess it might be more straightforward to calculate the worst
case number of segments and then adjust the splitting size, but
since we don't return the number of segments it's more
computations. E.g.

seg_size = 1U << seg_shift;
nsegs = (bio->bi_iter.bi_size + offset + seg_size - 1) / seg_size;

if (nsegs > lim->max_segments) {
	nsegs = lim->max_segments; // unused after the block
	bytes = seg_size * nsegs - offset;
}

-- 
Pavel Begunkov

