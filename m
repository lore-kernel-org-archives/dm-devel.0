Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EA336A01A
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 11:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791200703; cv=none; b=pCZLxIs5anNdPCINh8yf0/YTJ91s+Frdq+Kstwh0KC37PAMpItZUQBI+dpx+8AqLTb+vQj30jPzSE92ITISx2ZlJOi75jPQO0xYxGKjMkc+XQdTg9uO9zskx8Z2VriC0Ut0W2qG38fdvYxl7F0Wt9JBWr8C4kFZRouF80YkHjPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791200703; c=relaxed/simple;
	bh=AgYzF9zCDCjhvarDhGELV8SCCxmRmAduCDS+Ac4RoTo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lMkV9rGcpmT3l1staWLIe/PXRA8ya0MksDJvvlTLCT90yDHQz1iziI0X1TxaxTsZW7fmWnOO1RXNDKbuxyF8Ko63euz5b23CG/Mn4AbKzkAHuy6OTTxxaPSoagBpR5BA9JxU8AcCzPKEFPx/czSSFgWvt8kyLiJbIZaHRIlcc2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gT42so9t; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gT42so9t"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b0ef9c76eso1479462f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 05 Oct 2026 04:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791200699; x=1791805499; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZTSRnK/72f03OAFyRZNcD9D1Hs2QM4XwAkI8vZWB3T4=;
        b=gT42so9tF6lVfp5//jhr0cWv364cF3aGZ8Ug7V5aSYvyUbQZWSeCNeWsShSh2Bf1ru
         JsvVip5wfeBFjvGSmz/MriCCVNx9oEYQYXIEMj/rEB0MRns7sCPZxJmHNkk4hGxAeqGq
         ITgPdr98GldORhB9QqOAt/ssoUAZHdbfNnKcIoRlBqq37tXQhn5QX5HzujRr8slq2TU3
         tzYllxgzQy2g1H3rK+IdWWGlVAXkXlUL/c6De9ms4DFjZOCM2pu6ryOenW3VMBCQPd2p
         rdudMIiAXpWGtoSWgBow+drxUtbey9C/wWugmBZ/tw3TiwsWacYp1sJjIjLu/cM/k6Z+
         mGvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791200699; x=1791805499;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZTSRnK/72f03OAFyRZNcD9D1Hs2QM4XwAkI8vZWB3T4=;
        b=FcMpo8XvrbgQlr1mrMQ69pW8XHMK4srB58ol8AewyzmxbMyOliitN80ixwuJzcba7x
         VVmbQxOJ1fXROJqRCirTm202GHluK8PAJsWzcKZzAHZvvjJiw8xummmjf6zu87Y5Dq6W
         6YselCd9JDpxQlDWSowA+dHFEUOU2PdoJlQgKPfx3AEy0UGGcjI/etRKARtRQe3KnwwV
         Nx7KfW2uwSG6Z2rwHxjjxyEof33EFgQl6r1DiEGLW3doyXBgpbbDOIj+A5u1YAO0wCn5
         kZdMZrYN5/w5lVvMNJSC/dl2nJUGzRu+d12XMl847cja7cdHaxfRA1q5pDoWwHEq83Qv
         xoXw==
X-Forwarded-Encrypted: i=1; AKwUvBwvV73W6L2t4EW3eKU5cWjkmzMLynnFWvuDIRgvpB6zui28KBuKvYn6VLijWERuk21I+75A4vzYow==@lists.linux.dev
X-Gm-Message-State: AFq9FYKTto5TrkDPGDx6bqmUWz/znWiCt3Fs4gVngDLL+XaIFibBuVbC
	SoHpaKeXurKXrveV1AIfghfsYGCCsn1tVQ/wEm24qn06FXhDoTYci/LM
X-Gm-Gg: AYBFou2r5wzH5GI1DWLOytVTVzsGzeCpsq6T93FuRyO3a9OMVm3poHdg64FV5zi/xod
	fNlsEst0gmvCWdDGDP+vLc7D9Xx+3uGCQp2Xrd9H99AaL9yzBLNWA21tgNuQj7yN9WBaZaz2FwZ
	IX6Tox1aea46zrCvxLx5154ENoUVGIQ5csXX66dt+g94ZnH4ZloDVSLOVFI0xUjjCwwFovvDHL0
	k38EkP9cAibY0j7GpII4ipbewQinL5smC+0dsBH5FJMV63aPPe3T+KjQC+A9bXfKd6+sQD2TDnb
	+QkdUziiF0zhZPyKJnMlVUNocOBBGLE5SuRGn5Ll1BYmKGs+UZ4YTMowzBmCpmMHmM/2bSPcFmr
	nT8MdYmc2Sr/wC6BW1/Z+ccvQ26CiIhqVypLK+KWD26P1gkMXLdyh4psvacZOEDsa11PA8AJ9bF
	fENnmLdMiyDXVsuCziy5QKw7d/52hTlS+MVaQQVjjZkCL+mozfV/M9HpPWg2fVK5FkziLeWKjHO
	k64HXbaThOCpg/4gYnaJnji/qOo97rGBdtObAsv2iIY1meNWby6SO+7JhJWPmlQKyS+NXV2CK8=
X-Received: by 2002:a05:6000:186a:b0:48b:6bd:1af6 with SMTP id ffacd0b85a97d-48c48000099mr10478688f8f.40.1791200699411;
        Mon, 05 Oct 2026 04:44:59 -0700 (PDT)
Received: from [10.41.30.1] ([161.12.45.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c62270751sm3087877f8f.13.2026.10.05.04.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 04:44:58 -0700 (PDT)
Message-ID: <fb0ec34e-deca-4365-8802-23d5688612e6@gmail.com>
Date: Mon, 5 Oct 2026 12:44:55 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/13] iov_iter: add iterator type for dmabuf maps
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Matthew Brost <matthew.brost@intel.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1790602223.git.asml.silence@gmail.com>
 <74a9d65f5c4f9acce5f57ad5921a9fadc6eda712.1790602223.git.asml.silence@gmail.com>
 <20261005091008.GA10727@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261005091008.GA10727@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 10:10, Christoph Hellwig wrote:
> On Mon, Sep 28, 2026 at 02:32:18PM +0100, Pavel Begunkov wrote:
>> Introduce a new iterator type for dmabuf maps. The map in an opaque
>> object with internals and format specific to the subsystem / driver, and
>> only it can use that subsystem / driver for issuing IO. The task of the
>> middle layers is to pass the map / iterator further down, maybe doing
>> basic splitting and length checking. The iterator can only be used by
>> operations of the file the associated map was created for.
>>
>> Suggested-by: Keith Busch <kbusch@kernel.org>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> FYI, I think the Sashiko complaint about iterate_and_advance2
> is correct here.  We don't really hit that in the series, but leaving
> iov_iter methods partially implemented and fall through to others
> seems dangerous.  At minimum that needs a WARN_ON to catch that case.

v7 already covers iterate_and_advance2(). It complains about
iterate_and_advance_kernel() but there are many types this one
doesn't support.

-- 
Pavel Begunkov

