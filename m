Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E74449B3B
	for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 10:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322193; cv=none; b=EyRQ4qXIFbyuGozvClENPnEqVW6wsT60fNiz8l4nb92GM1FpJEtTNZ0b+tSealnuNYncBht9A1bey3esTydS07UJgcpA4/3CzQ3y+viHlKXyRo0dOzgqoutSFow+fInbPRp8WCczB6KxhSSXwbSfr3TXEBsLiOGR1AQVkHMMeYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322193; c=relaxed/simple;
	bh=iNi2nFSA8g81W+/HnLXlWmnLlyUILEZvQTRGox6oYII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JfyYs83yCvq608GKmyxWqemunlJGfa9CxlVRGa36JHu5mZU05UDDvPh+dXIqVnrRiorHticHYf8/C+9XbfyTVBGQNaMdAMAlnSxZvMVbzUH5jMC7WYH2+cWhkLslwpIlVqafTBRROhSWICZCm9UaomRH6xMS/sxBmuQQY/kLO6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bpMvpbHM; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bpMvpbHM"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1c52d920b8so113189866b.2
        for <dm-devel@lists.linux.dev>; Wed, 29 Jul 2026 03:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785322187; x=1785926987; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3xVEH4RvIZup14rRYV4Zvxl83sd+HTGGj/jXhd9ySH0=;
        b=bpMvpbHM6fIQJk+mT29b3RgODD8UAO/tpKWP5yO5Ilp4ptxEI8jD5JjahXJuY86W8r
         f5FjNuRnHvLQOL7taH+ocux7Egv2XWjza0kqUq2Ptnb+PhtVmfhBvA+KKmS2gyFvxK7f
         u7B42cWpp3OISibLPXxH3HbY4Pn+qxC0+xrkJm6U5r2n8ScxzM5Y3ae/BZmrOcDyawpH
         wvxsW4qV5uLo7OfyBR4Fe6W1/7d6gkNFZW9DwqV46l+ckYRFTaLBMtGH1o6xjSlTx/w+
         yywY8PgUw2fuaO9LV96bIsypiIInHVR0X6XBy+KclvGvn2IfKs1WArFwTAYQwSKmbXH5
         fA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785322187; x=1785926987;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3xVEH4RvIZup14rRYV4Zvxl83sd+HTGGj/jXhd9ySH0=;
        b=guwfDTH7HFemS2R+iAu54bPXi5jEyIisAjn5xJT+i+mhDWzgi9fp0Ts5sgKzsv4H/C
         wgDWRLPDayb96G/BHCgADJD4HK0ilUQjdK9dWuKgIEfbBl20ruHs7QfjWs6oa2DfhhLV
         OU5du/x6VGJB75sz4nAhFwDchLfK5NeSO8Uz+DhHf3oUPoAkyuD6tyopCMeQNj2INf6I
         02csD87sEdTiEALptIcFRsJDad3FhgvucViGTmk6083VArFZ7K3VxTzv5YaLgc4V9GaC
         mW7hcg4wGa6jJAjmyUOChsLRiUPmGSPb8IEfDxOBqRQo7YP19Pwq4yg3JtiOW3bulen5
         RFAA==
X-Forwarded-Encrypted: i=1; AHgh+RqJ9wqbCFwv7TM6AS4mCe7BYb+HQ+G9/Uq8x3nT6P1+dHHAV0XLoPU1guyr3AbttnQ19MkO2+yqvA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwIFqMpeeWH+xvcebsanEkrSSLCMMoWFr79tKrCrHqWIoOlOwDb
	6I/I3bxKT37vbOwEArsOUD4PvXv0Yi6pbmmdkTFACPs+mN6ZTWkEz63J
X-Gm-Gg: AR+sD11vWQ0ckHVTxH8+Y0VF6AtAZS/BRyn8sedyVQsSd0fxSGCXm2CON/JrSl0OSaa
	ytakZ2DQcrA0jbfni/A1Fk9c+iRyGt1kkYjdld1INXmh5rW7MDdqhChlCa6n/zpBm4j9sz+RUy9
	Izj/h1+MfzAxTrre2qL+lNw9ll1VzuTH9DSWTwOFqSqGeBpm/R5wWMxroNwE3Dz6HOO5ZutCIyF
	Ku/hlk238WoaQh7nbzRo6Kh4bCnJRLQRbCOzPQeivkD5Q60ht32nHL0a3FhOI63FPBj/CJTPAhW
	HeauNr9J6NH9hhW32Tf21VXEAaZ0gsvWR4vHeg7G14wD+TV7nnTr1kcTEdNsM58tu1BJ0Iayky0
	CptpCTqqWrEAOh8f8m2im5m5O6YoIixqWFKrl/7T3WpSrC+1ptTfydaqxE8xka+hy+0S7CpemCS
	ebPxih+lWvjmms9HBlxRmKJ6Fdh8l7ycG0vy5NDdKPpIc7GCEqGfdEQ2LyaJhVyhXV/zzmojrke
	xd5hAr4KBxT2pPL0E4lE/GsOhqpxrc0G39KWvwQ2TFJvu3RMcw90qUI7iCMTg8ScZGjuZqHX0uG
	QxrGiO64yiwDCy/XDPmaGgHFFJ6BaQ==
X-Received: by 2002:a17:906:fe47:b0:c15:bea2:d209 with SMTP id a640c23a62f3a-c1f7215dee1mr299738366b.4.1785322187169;
        Wed, 29 Jul 2026 03:49:47 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83d27f47sm97965566b.26.2026.07.29.03.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 03:49:46 -0700 (PDT)
Message-ID: <c81be43c-2fe3-4403-b8a9-dd19855eeb58@gmail.com>
Date: Wed, 29 Jul 2026 11:49:36 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
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
 <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
 <20260729071048.GH9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729071048.GH9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 08:10, Christoph Hellwig wrote:
>> +static int nvme_init_dma_buf_io_ctx(struct block_device *bdev,
>> +				    struct dma_buf_io_ctx *ctx)
> 
> Please stick to two-tab indents for function declaration continuation
> for the nvme code to keep the code easy to maintain.
> 
>> +#if defined(CONFIG_DMA_SHARED_BUFFER)
> 
> This should be good old #ifdef.  Same in a few other places over
> the series.

Going to apply both for v5, thanks.

> Modulo these minor nits the patch looks good.

-- 
Pavel Begunkov

