Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3861747F2CA
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791200749; cv=none; b=IEpl1VoWoOStmOo0f7ncbsgTNN4Sw7sTHxOHg4RHQ2CprmD2iG9GPfxz8jj+9XOGcDMUVqo/86hfjHYX653DFNK1MgMLnNnG3urX3NvHQz5VwhdkOK/pKJe3BF0ham9xNCdPZlL0+MQ/MfPcIC6MWV2R6PMTzJzz1PWI14TwQiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791200749; c=relaxed/simple;
	bh=ZkH2ZoyFF8jXmocTrDGUE79ENJOStFm8UfOKX52vbLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j31jb9Oxik/4FkbT+3nPX0GWcE2id/k5ULyA8uwN3b/tDRB6T0Kd2fAHKoRkO4X6fpzD35jR7bxeFrapEzA3zEH7lrRswpqOkxq8lSjsPSrbxAsUnhVPrqES/iV97r7E0SJWyZzROgQsdhZCXlZ0dKT3StubqEXpsJtS/TYVLf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IrG9f4p9; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IrG9f4p9"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a022e9cbebso13766395e9.0
        for <dm-devel@lists.linux.dev>; Mon, 05 Oct 2026 04:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791200744; x=1791805544; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CiogbugpChE2nuDY1/c0G9NHgdsv6JGGhiKd4//mw4Q=;
        b=IrG9f4p9Q1IUymZowJyMU7lc6o8HJFOV+ieIMqqiuSIhhkN1Og/tJI4iqd362bo5nU
         w++ENFB+H8YgYakBtULi3qbCvlb83Mka6tOSMLEvPtkBv6ZhVnhPYgbnkTrxxRF0rQjZ
         gj8E9Im/YZMr4VOg/HvmnRO3gQKg29BXl2jXTVQw/xmuJ4cf49WgG3Jf2MJw6PpC4gQf
         UOTt8QlRm3zkHSoQUixT9HpyoKzg/XtIzK0sfQyC3F00rDHOb7K1QGch4ZK4zoEh6kph
         GsN9aCjayGwMGyaCYg3fT/gbgXNHmDfG2dH4rDY4iPk1qwuPf6fEdwqPJEELX+IyfMeV
         uJZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791200744; x=1791805544;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CiogbugpChE2nuDY1/c0G9NHgdsv6JGGhiKd4//mw4Q=;
        b=deRtwqc2y5SlekN978Im8yeSMMNwix/2vyk7wXFkb46fWFKXKoFTmfWZYHprPIyD/H
         +/39yuzvnCsYaVKjfjAbEigSz774EEEOhE2OpWCxQ03DogveygdlHD++TpCztY2JPoeW
         CjzV8Cp0aqx4dFRYxqNm/KV38F2JPaVS2NSDDIEMMRVEX11U7ni5XRFDBAgBYMNsrhjd
         x3xSVtZTvPTLj4Bx9uGFlNEf+3j6YTkLDOjFwGkkjtGeAA+RiTbQBLLduq9ZDUOtferN
         RzGBV61j1kwxpq2wl0z5HpV/UfOVRXw5ePKnD6xuCRTTWx9FwYQbd7sc5I9eeVlOuK4U
         eH4Q==
X-Forwarded-Encrypted: i=1; AKwUvBxvL+JF9xp5iMPTcVX5PzQqmTVgOA/nBKFeZsGfoprHJMdX+tnObZXJl76pyFEIdi9JcEwCvE7w5w==@lists.linux.dev
X-Gm-Message-State: AFuF++lHM3qh1TYQXoLo7Bw1h8n1bKtki7Ed1KRwk97OWG5dY5RoGq2B
	DGiydr5p2KLoXyy5SblhrRBa2oJfAyOUe1dDmPzXhD/P8E30V6ntty0A
X-Gm-Gg: AYBFou3enqyHv6UCk9Vc94jwHVTzIh7ReDlxjFrBhc/S9aIs3CscKFf7pev5QnRosni
	78oomKnNlBcPTKQZW/Y8k244gSSAZlhz7Q1koWlyWJJmXOuOP0u8ZW0DO6BJhJdMt7/7FiOCjXK
	1caUWLRoQv93cl+b3QXU9rlfKpg4Pye0+CtQaa4FiJtpjEE9OFAUDtZ1e/B0GQDxslqMIA047cA
	rWpQh5tNf5hXooVkzghYYq6utfg8mHStYTubj+eiE0UERsZR7u2skOdjLJ+EXMMEy5U9+UgQ87c
	08l7eK49kU9Nf2akp6OXpUwVIDghgDaKjCUIivP2JGKkjghck9xbdN4gPu72VriMjnViSDhywaa
	BSajfTTfPR5/2x2VcZTPiHFEHFLuYbfsLK7XY5TzyOcUHnnMdZ8VToCuXghX2DYJj3oj9di5EP5
	9Io+BqCpvyD5in8iv5BXSHc7EgDpuPPqH1axPypIlgqRtrhmPuFeQ5/V8NBMXju0eRy47x2Fx0r
	ir86WVIyHGDErw9RwCRmujIVZhfVJbAMf+9zDopKTuPnDns2PCzV/OpmhUaTPVjxywdIvVoFVw=
X-Received: by 2002:a05:600c:c165:b0:4a0:108:3b54 with SMTP id 5b1f17b1804b1-4a02758e674mr183842705e9.32.1791200744219;
        Mon, 05 Oct 2026 04:45:44 -0700 (PDT)
Received: from [10.41.30.1] ([161.12.45.16])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a027735be1sm472096485e9.11.2026.10.05.04.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 04:45:43 -0700 (PDT)
Message-ID: <cc7fb229-7e6f-4ccf-bea4-864ddbd36a02@gmail.com>
Date: Mon, 5 Oct 2026 12:45:40 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/13] nvme-pci: implement dma-buf backed requests
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
 <e99dd5221c71cbf9aafb5737468d814cb83b9174.1790602223.git.asml.silence@gmail.com>
 <20261005091554.GD10727@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261005091554.GD10727@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 10:15, Christoph Hellwig wrote:
> On Mon, Sep 28, 2026 at 02:32:22PM +0100, Pavel Begunkov wrote:
>> +static void nvme_dmabuf_map_sync_for_cpu(struct nvme_dev *nvme_dev,
>> +		struct request *req)
>> +{
>> +	struct device *dev = nvme_dev->dev;
>> +	enum dma_data_direction dma_dir;
>> +	struct bio *bio = req->bio;
>> +	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
>> +
>> +	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
>> +	dma_sync_sgtable_for_cpu(dev, map->sgt, dma_dir);
> 
> This can use rq_dma_dir in the argument.  Same for the other DMA API
> calls.

Will change

> Btw, given how larger the dmabuf code is now, have you considered
> splitting it into a new nvme-pci-dmabuf.c file?

Let me see

-- 
Pavel Begunkov

