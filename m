Received: from mail-wr2-f31.google.com (mail-wr2-f31.google.com [74.125.225.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9427A36A01A
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791200601; cv=none; b=ShpM8W12auVFkRnnqpgkm4hWcWW7nXQ3sar6d2lFa9mIX7SQxclzkeQgDIBwYFPXEr/uWH/8MVteRZkYBOFSSB8aceE/zH2Y5I6liyQw+GBfZBYtLAqvuZEuV77ZeYKmHzX/vT6YvrtujI7yEagmWpbV6eh6ZcdoLH5pqAIt8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791200601; c=relaxed/simple;
	bh=GDkG/OW+aHwhFfekfJ1LFx1PPwGsHQVlhAiMqfGU5IE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P1h+fzTIS3efl5uRFOTRU69LlEnK9alWVRD3bOtKgC5Bo4mkCAiSK4g1hzx2jnnBRd9ovWN9PNcNVMsGuolw4qYoEcFxzdxXjYXgqAAL7bh5ITgL705Q/qwNIWfex72zyxSCTMe10AD5U5WMkjQZmmCNgDQ0CDCtIc3/6rDK1n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ltI5c8gl; arc=none smtp.client-ip=74.125.225.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltI5c8gl"
Received: by mail-wr2-f31.google.com with SMTP id ffacd0b85a97d-488811c9ebaso838958f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 05 Oct 2026 04:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791200598; x=1791805398; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=25uBlo4GDqcGkj4VAPKdolkwb50w3Is4u8TLMjz2GGs=;
        b=ltI5c8glOnum7WR2qFR4zfp+VGk89SR6+A85c+rMjM0727Cm0zyVMBrWjXs338li0C
         6gqJ/RC55VuCbCF9O2XOsvm2olrUjqkThmkMJhIaW9PUIxhHouUJ2A2fr6LE0sN3hyD5
         fs7G+mTYdjQpd4m74cUE6hmZKg1VdT0qkYWPR9BNNYCcJnQg7FYAPHtitKRvdTi4C3iK
         hVzIOcLUh1phAzHfH2Wt9KrEqQUpDb9fmmpAUDhHMMRNDGBWrF2bawLTfI0BdYsmuukC
         E+JS2rgjsMJYyuqzvwT3EFZCmJiHzEA9E22sf2hAg5f5YEmR32iHNVTuJ7VbJONPLE2T
         BqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791200598; x=1791805398;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=25uBlo4GDqcGkj4VAPKdolkwb50w3Is4u8TLMjz2GGs=;
        b=ES41JBY5CO3ZJxHNIgU4NUeW0SY2kPBss8xVvh0ZfPt5BzM3tCjnAZ/9CTBtYSIeeh
         a0K/w9MfF5OkMrP3Dkyg/4SyO0CVgp/IeXdlC/RU0MBpY1ERDSg8AADHq4HQetmVrtYS
         U0ot0iNcVwYBfTHuKFcMoC0syiSXtYq2iTTfGrFwbJVgQOsnk1ms6l7KoAYXKa21eSu0
         fPZ/SDNBHSkH6rQP7sEYrly0+k0rrdAiBzE7Vp0GxT9yNCoMPvKYQRoructArPaALt4u
         bDRdmItHg+/EQNWtMNcEEloZEwO0nlYLfzgySlepVUmhX5MxK/+ll5g55R0MCCHIZq4f
         FoUg==
X-Forwarded-Encrypted: i=1; AKwUvBwKlXeyDDU1A3I+sj4VTDSsMlDA9gXAEig6z76iTMHBSqq8Gmlma9ea4qyjZIZ7DkYsP8dsnPQnAw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJKpkzTxo3P/eQNe9rEqtQFhFQETigrc2awT9egm4AAYiAGR3uR
	yR4M4C6b4GPo49vBpNvCk1GEF7kTOhcawMjq1nCLO4e2MB2Yew8xSBIn
X-Gm-Gg: AYBFou3Le6bLZdsqxSUZSbDu1+PttoyCvyzr4CfkSNEcW6z1LQlabNU+lovmU0bfL5N
	aQ8MQp9JbXfxAYU0WBSr2lJEolzJzQZ752EkBKiqLzmXbyopNo80trCVE62suTMUQqiDFHHfYgV
	a4pKrGdCyInJL1z5cvnHPfC95+KFvl+OxXDFtbWNyxt/DSY0//L1ONNZLy8Je9Nd0KDHg94Jf6n
	PAFJF4idhpGSa65zp23FUVwlavHOKFKh9Ensfj5D+PTvBIJxj+/0K6O/DQeDIZ60zjqu3B08pqq
	3mH6yxN5DaGA9PkjM1Sripk/gHcNL6aAbsDbqH6AlG5YMFvBAPQSmgC9hxP4vq9u0TJ3Vt/cxPh
	3hmJbgEYZ6ySWadLwh60dmyRWSoIX/pt2qjxOQRvNfbY3rENaedxbd2MMI3d7+53vOBfZw3ZrXS
	3uTXSn/aHpv0kmgdooTuaVg4t7YByEc733X0vyklEC8qrIPZuKLQLu54Pt0MF0KxmFw043xAo6c
	1zBXd/AA9o7+5PZHGOgEakPfOWarvJtXZMeBb1KQAgM2sAgDibKNziheudR8FCL8A2B8m5RQ98=
X-Received: by 2002:a05:6000:40de:b0:48b:d2d:2fcc with SMTP id ffacd0b85a97d-48b1272d0c6mr17543670f8f.9.1791200597696;
        Mon, 05 Oct 2026 04:43:17 -0700 (PDT)
Received: from [10.41.30.1] ([161.12.45.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c622704a5sm6943895f8f.15.2026.10.05.04.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 04:43:17 -0700 (PDT)
Message-ID: <be0012e5-872f-42f3-bace-5066a09cd9e6@gmail.com>
Date: Mon, 5 Oct 2026 12:43:14 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/13] block: add dma-buf support for raw bdev
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
 <a6b81e65b1f09b6ed1f71f294e5a94896ea1ead7.1790602223.git.asml.silence@gmail.com>
 <20261005091111.GB10727@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261005091111.GB10727@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 10:11, Christoph Hellwig wrote:
> On Mon, Sep 28, 2026 at 02:32:21PM +0100, Pavel Begunkov wrote:
>> Add a simple proxy implementation of init_dma_buf_io_ctx() forwarding
>> the call to a new struct block_device_operations operation. Also reject
>> dma-buf backed iterators for buffered IO.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> [pavel: reject dma-buf without O_DIRECT]
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> The Sashiko report about the errno on fallback here looks real,
> and is probably easily fixed by setting a proper errno.

I'm going to move the check into blkdev_buffered_write(),
this should cover both paths. direct_write_fallback() will
see -EOPNOTSUPP and fail appropriately.

-- 
Pavel Begunkov

