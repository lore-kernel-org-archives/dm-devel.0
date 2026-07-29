Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795794314BD
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 13:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330693; cv=none; b=jZwesdIjJ8Kfo9GOcJy8dIKOuGXq9062ELo+OCQwfGPjwFkmloFVlGVe9QIdmo3aUM6Nw3gu5v+hQxgzuCELXSTOnnnddYX/2N3qbtj+3pfthHS5G3UDWmuf8FySSV3jM7W9woT8disxSZ7/9Mtv5+lKLpWK6xfQmTQa3rks1hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330693; c=relaxed/simple;
	bh=iCKby9e1qhvE8ns2sICVS+CCbRWmXfOjz3bB7l8ahOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SHH13oW/JYlPRPwIp2gZ1ZJK48JRYN45pWc6O1l6c+Brk4zyuil8C2USDWYqrlS6Bl4vER4LXX0k8kR+37CJxqIgbdaQHXw+v88fUkZAiuaQV6cnDugQ8a9EJ3O5HnpvLb/bjYww7CayVRLYDO8rDKPqSt7igK16lH3DTsVHuhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pZrLflBw; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pZrLflBw"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49557167508so8120195e9.1
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 06:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785330690; x=1785935490; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QlPatibx3g8XfK6S5eprVRseiFbSJCNNQ3hXCye36cc=;
        b=pZrLflBwuBYmiDCpBsPNEewBKqXo8EIbrPYHFKsMY9HSjUyHT1XiHxQC0+0OqqnsHU
         SIeNOO9nVgH2NYZwO2A2QQm0ABRet2h6AJ1zE959cGfaHD0b98E7AmPHBVMZL9WRaEpz
         Q2uROfuM70a8+Irgu48ZC6G5BGaPcJh9gnvR5LhUzd4YKwF55XZgYZGOU7WSmT2p0V7e
         5Fv3Co2ZtCCGNmO4yGu/9AvxzpAqSyMJKoqTCx5spuHTftQHX8lUM4U1KpKifsKR0hmP
         hDgl7+KnpWOjUfeflsU50TKoHEKOfrpKhcrq2ixa/FcYcQRYdO2rISIrckN2AbgVfOTS
         /HaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785330690; x=1785935490;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QlPatibx3g8XfK6S5eprVRseiFbSJCNNQ3hXCye36cc=;
        b=QMX+P8mCMZx1y65aG6w3uDGgMAnK33r7quKJBI/FHNBIjpeCcIXMsdCEw41Wb+Xzqg
         L5UUJI0wa9UnyBT7Z1cPdYGHx9ocaoT+dv5zA0mRQFpVaJ/9V90dw996ShmaaYfmscmZ
         r3AD1Av+ROqy6kwuFFO0bwKCGWuhaZyfJamyoSApJOpb89qrX+h7cLXpsdyKnKkag7lG
         lrkdDF3qctcCSVFhuWEoFjvv3xz/UYSHF+fubUg1+QyE3Z+kj1xbQDmcZt6AJmV9KHA9
         emusG5cRfvt49zghcpkFcKDjni+b3kKg7j8uW/sQx5NMdYsX7U9T6nwyePGCEYnMkdnl
         RZsg==
X-Forwarded-Encrypted: i=1; AHgh+Rq5pPDekIcufV/HjirqavD3xX4QV4Jzw7rJFr9lMsO+BSNJ34jwsqsAy7lkJflG2ccGVEOxFkCgXQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxI8kLJhDKxzv93IUtXcp+MA5MQFahmPi2G//VYvtNdYMQ+Ekij
	ztlIYfSHYKxHtICF09sU4SbbnwgbYI7m9OT5x161yMuKY0rnxKJ+eWzJ
X-Gm-Gg: AR+sD12LvWNu+acoZG2HN5so80eaOQWjDjDxYIv/Wj8N6dLBtlPBapmG9i8wIUsq5Sy
	Dxh1gN8Masp07gVp9oVsslrhtPEhHekJJLWXaG1nuLG4+WpazPwp7eoO7OuX5h4wh64aLRH5KN6
	P7DJfw+HIfnFYjG1Pr+0mbKG1Cxbaateqvmx4+qdZRsbJxgRkrbjOr+dWE4srlhnYivsKXtT78V
	C5U3olaBYZTc0+FbfT5GEiV0i+WE3DznEEfEANetyETYcYwJlELuLxxvyf4c1YQntum/kytriYo
	AlDob6WmmhU1CoWFhu+mXDvIw2/2opymz1EwbZzkXyoxh1SpIIksoLcB/OXN1RFWkHmK0dYDS8G
	4q7a0cjiEpzdobAt9PhUl+oDfdrzPpFDh+6qU4I8kFvkP2pq0ZzMu/xKwnEy3L6eGtG5awXzuEq
	jj0qL+xMKw188AHpE9OzgG8KYeY9ru/c4ppU+vDXuKGxic+X4x2h2rMoEaWH+QQOBLSWiFHFnnX
	uAZ88V+fuO03sw+oFkluiT+OBPK4WYwaueQSyPplUHCiV9TgQqu6TwnmODiM80egKh8kljrXr63
	XJw3xQB5IkED8vcyHyQ=
X-Received: by 2002:a05:600c:3485:b0:493:b243:8ffc with SMTP id 5b1f17b1804b1-496c6586bbcmr69846215e9.35.1785330689440;
        Wed, 29 Jul 2026 06:11:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45c338fsm157280305e9.8.2026.07.29.06.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 06:11:28 -0700 (PDT)
Message-ID: <60df6af0-3bf0-4954-8181-a0acca7c21c4@gmail.com>
Date: Wed, 29 Jul 2026 14:11:16 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
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
References: <cover.1785274111.git.asml.silence@gmail.com>
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
 <20260729065927.GA9534@lst.de>
 <340dd033-2a45-49e7-afd6-95dbbbf624da@gmail.com>
 <20260729112808.GA30851@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729112808.GA30851@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 12:28, Christoph Hellwig wrote:
> On Wed, Jul 29, 2026 at 11:37:19AM +0100, Pavel Begunkov wrote:
>> On 7/29/26 07:59, Christoph Hellwig wrote:
>>> The method name feels a bit convoluted, but given all the
>>> previous discussions I don't care too strongly.  I'll leave
>>> the dma-buf side review to those who understand it.
>>
>> I assume you mean this:
> 
> Yes.
> 
>>
>> +	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
>>
>> I agree, and all dma_buf_io_[ctx,map] look clunky, but I don't
>> see what I can drop out of the name. Suggestions? Maybe I at least
>> should make the fs op sth like "register_dma_buf".
> 
> I just remember scares from the last discussion :)
> 
> register_dma_buf sounds fine to be, but unless I misremember there
> were objections to that before.
I'm going to respin the set in a couple of days, just going to
leave it as is unless we find better options.

-- 
Pavel Begunkov

