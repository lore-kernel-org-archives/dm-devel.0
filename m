Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FFD545DAF
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791921771; cv=none; b=Jm2Q5T9umWGWIgnztlXzEZGz43E+PqToljGXBIEYtLAsdk3lM0bniAYmKmGWMCxi2ll2kubqvsHdSGlzL1Y7Nntdv4c1h3TXXfiFUIaQE8zXkZl1laSO/joyFpUhYCpWJzig9hg1dWpHsUgRmkEmzpLc+BjQ5sUaJ6QQmIOAulM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791921771; c=relaxed/simple;
	bh=5OmzUIP8dmoGXLqtWjV2SDzvrm+zBkTDLpjN5AcCB6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jYjxtGjF0+JdIGUBuxey9YhuiP0PYuM5UZewm2joOABlQwHD1VcgffBNyyPtWRHmvztdwEISHS0OFALq+omTd0xSxoDaWi7EPnvsT3icKBpCttFYhCd24mflLMQALJUe/Q37i/M28YsZr+nTgcHrAqZhISqE0DVqZcevtyb6CSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fx99af7U; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fx99af7U"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a02718da81so27108245e9.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791921768; x=1792526568; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ht3KL+dVHT63kyImKLUa9SErnOvImt82gs/Vf44c6SY=;
        b=Fx99af7U0FkG0KlIzlXLmW6aQe2WP5wxP05HNc4mxvG9Ea3AzsVecJzcMm0xivNxqj
         KYQbTWnsdZrOdyQXOzAG4KLEDvnI4GG3WEtraQ8iDoSygZwkZ039Tea1VTnhEmA57z7A
         Jd8Xu1C4XhQc2lTXxv3td5NbZIknYFsYpEWsivRFjDMAM5W+m3geNZz6EH1PClE/jZIJ
         Moalj8pSXlExeeRfN39+X5TmGXpO1SL8iUvxvP3wsf7raZj0qTj6tZf5+oIEh45MRjiL
         xJKuvLeRbfXMWK2OcLhVwfgSG+NS5xO4fXc9jAcpZp2oCc1Et034uyMZQbtSJ39w4Mmu
         Rjjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791921768; x=1792526568;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ht3KL+dVHT63kyImKLUa9SErnOvImt82gs/Vf44c6SY=;
        b=NgKOOhPeWOBK7Ivr2PtQYeSNQWdH6mOALNrxGoggkEHncQgQK0yxLN08Hg35X2YJ0i
         +utPJZ+f6YHQoVDt0pklUwKRvfacgkzrt2JqaDwU0TLkWIFYapSONx5Mq8iZy4hFLIkB
         +pJlSlq+BHM0BJa3NOMIUJ4xaAKlBXR0CcZQPGA7k7CBIC1B1+vN+vbdQltdPgzkV0NF
         rvd3JrJZJdwVo0F5HO6EylHWo9efsTxq35b3WvuwRmpjj7jmKN4CwKf5MzDwyssmMM50
         TZS90GWRWLOcV8ngGhSAk/EM/KYAZ9JP0Unpr96EjS9XBujMZvQLRQuLg1uu3ttJCOHP
         L9+A==
X-Forwarded-Encrypted: i=1; AKwUvByjJNCySCHUDn0Uw9S3Y2L+Cxk58sCd7CFbvdH84zKg2rKXsn97H+t60fnRFyAymdIZ+s7kPA14qg==@lists.linux.dev
X-Gm-Message-State: AFq9FYIq1J4o4BSurFrk5pJgbMKkD+Dy63lYMZ7YhQDfkhv0RbiHP72f
	Ky2s2Au85SM62vF2wX18Rrl4W0WLtFH8cQMrfYAsR5Sk0Ao/WsbbAh3K
X-Gm-Gg: AYBFou2p+X3AoD9PGkaIbbQdZoTyvAMOdnXEvO3l0DOW58VEd75WO20l0CKkM/hfiGD
	XI7vFTZx0vM3ZOU9e6q6yKNAX/5XDUHF0u1LbjBNPnhC5GpoxYsuD1p/Va0DX9qUWX9jE2JIg/h
	O+FCJRgyNqH7JfrfQJGnUAy/1tU0wMFpIoF+lfLLH2egPAuoKBXvT9sa5e5OF3ce0nThCvsghNp
	K3/c2209sZi04Gufy/0aqq49fqyXolMI1DzGAzZWgqfe26w/5QzWHgOSiQn7dNdasTZxroKosaf
	hQtV9uj/YOr7LsuzWVIvb9VjP2ldMdj9SU2JQ15B6UnNb0S43qT47u1vjZu0xY070Sl3QW822te
	voKtp46DBc/SWUPzsFYH4mkDuoOyqIhW1U8c+/5V40E6iUFU5whWvzh8LH7A6Uzy5HAbJn95lM3
	gdwODNO47Gs3AkFEGU3b3ufMqUqV3YPwhHV/L8SMSw/c9ti1eEyNVLayexHSEMgs2rrYD818EKk
	cX3wDyO2L7E9XC/ixCslRfWvWHy+FReQutQBHGll+IJ5ZUOD7Gcvg3AVFBcnYC/LtEewQhvfQ+Q
	bBJsFUyKNZK8Iq1w6taZqkRdmCcqlESikFf17HIcbBwbxs9d1wCxHmWAaIc=
X-Received: by 2002:a05:600c:46cc:b0:4a0:8b1:f5c with SMTP id 5b1f17b1804b1-4a18e4b583fmr268480065e9.22.1791921767928;
        Tue, 13 Oct 2026 13:02:47 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bead84esm384426465e9.13.2026.10.13.13.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 13:02:47 -0700 (PDT)
Message-ID: <63fa3e64-44a8-4539-960c-946cebc8fce5@gmail.com>
Date: Tue, 13 Oct 2026 21:02:39 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/13] dma-buf: introduce initial file I/O
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
 William Power <william.power@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336930.git.asml.silence@gmail.com>
 <b44df9fed6e346110c504ee312bb0083c7e75574.1791336930.git.asml.silence@gmail.com>
 <aszbv7TgDOPHBEem@gsse-cloud1.jf.intel.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aszbv7TgDOPHBEem@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/12/26 14:08, Matthew Brost wrote:
> On Wed, Oct 07, 2026 at 02:42:44AM +0100, Pavel Begunkov wrote:
>> The goal is to be able to natively use dma-buf in the read-write / IO
>> path. This patch adds basic building blocks serving as a glue and API
>> between drivers and upper layer subsystems providing the uAPI. Later
>> patches implement it for NVMe raw block devices and expose it to the
>> user space via io_uring.
>>
>> There are two main objects. struct dma_buf_io_ctx and struct
>> dma_buf_io_map. The ctx is used during initial registration and serves
>> as an interface between the upper layer user like io_uring and to the
>> importer subsystem / driver. The map represents the actual dma map
>> established for the target device[s] with dma_buf_map_attachment() and
>> stored in a device specific format. The context is created via a new
>> file operation ->init_dma_buf_io_ctx.
>>
>> The ctx-map separation exists to facilitate map invalidation (see
>> dma_buf_io_invalidate_mappings()). A ctx can create
>> multiple maps during its lifetime, but there can only be no more than
>> one (active) map attached to it. Invalidation drops the active map
>> if present, and any new I/O request will try to create a new one.
>>
>> The primary task of dma_buf_io_map is to count requests using it
>> and wait for their completion when we want to destroy the DMA map.
>>
>> [un]mapping and any work with dma addresses is delegated to the
>> importer driver via an ops table stored in the ctx, see struct
>> dma_buf_io_ops. Only the target driver / subsystem knows about devices
>> it wants to use the dma-buf with, especially in case of multi-device
>> filesystems or stacking in the future.
>>
> 
> Full disclosure Pavel incorporated some of my ideas wrt to locking
> cleanup which I shared off the list.
> 
> So I can't in fairness give an RB but:
> Acked-by: Matthew Brost <matthew.brost@intel.com>
> 
> For the series - I can give this and I have pulled to code + have Xe
> nvme + IGT setup showing this working:
> 
> Tested-by: Matthew Brost <matthew.brost@intel.com>

Thanks for the suggestions and testing!

-- 
Pavel Begunkov

