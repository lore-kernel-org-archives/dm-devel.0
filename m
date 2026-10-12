Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96024E56EB
	for <dm-devel@lists.linux.dev>; Mon, 12 Oct 2026 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791836509; cv=none; b=eHDZkwxC5dx95sRDbJCfTu3004jjuM05m4Vl5ZMDoNDCv+MSy3eAR7QKHsAhc42TCOQflrRyMcDGH2SsGN89ojW76cVjuiZXB92eHJj3NPv+/4kTXm4LmL7lolSn0xgFV4v5mI8hXu4l9OnFiA7P6sF7XwnSYbckVTGLwjplvjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791836509; c=relaxed/simple;
	bh=lli5ii/H/rCG9APVq9ZvpYJJiJuxiuQfHiO8zLh8fqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oRGo8sYY9PyZ/SZKuql2RVxK6uvEQy7zGV2YOz1HJGX5H+/z8hEZo3M59wu1b6Hu0ggUhVBM0fsV9E65Mf9HqXSEaERGF2fd/sjibKY+2lBJKwefuRZ635bO1AwYtBDswZLBk8EdLcIkEXiQJEZxL5YuTcCFFe6QGHsNa3kzZ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=FyjxMzY4; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="FyjxMzY4"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-8266c388b67so1981203a34.0
        for <dm-devel@lists.linux.dev>; Mon, 12 Oct 2026 13:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1791836507; x=1792441307; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z6hOwSLR8cfh8cDplIOaHfJc8wiTVy6P5jX2Jl3fTgI=;
        b=FyjxMzY4Jqk+hu3M7xA+qMqJoyzM1buNQTb1jxY7QKN5FBK1kRdXB33GOHCTgFPz9h
         +YJeP0JBhJSu1fVjOjiTDoh+RHk7Tou/AK2D8Udy5KDG47DkC54FDHuGSgQxM0g+T3Aa
         ZE+UL+F6gt/53rz2i7W+AwRTp+RoHSfPku9mAOxIT2OfdzUqSUSlzJrTNFIY8an6jyBr
         n9qZ8Ni6GTWt59Koqxmet4XczNZrDnSebumdEyvFbmGeaN4a5ZT/WtC5iiVtl6ZAoxP/
         bsVnggnI+thvyyln9p2r5UJYXTJlBM8tewLfgKwjXXbHw6CBfApN+85zvh+7bOPABEOS
         McXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791836507; x=1792441307;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z6hOwSLR8cfh8cDplIOaHfJc8wiTVy6P5jX2Jl3fTgI=;
        b=eKqkbhOD46XMIA34nl69DNvum1HvVb54SXRKAQADLKLYRFfEXcVtLeG1gT5GTo+K28
         3MH5a073OAC9CeAdoPHTJSl8eFKz9K8KOYsRkt+11iCyoQQvqVTScsiy3gFoOsN9Cgo1
         QOBkGb7lwAVNVd5hfn1FFECtxOgFOixjpDfVHha5WepmVDmBly3g1Od88xrVT6bn32NX
         iLsy7pvtrIj0zcE8AWKApF6JvGrNoOXMx1atftkT/9CLQ/OA04AAkVeQB6xV28TDRRFc
         BpJO4b7yZPnlD6Vl73vIPLR8V6AcPLWweluPxTXfMKJob6C/UDNxnEUtYoHaSak3kpDk
         a1xA==
X-Forwarded-Encrypted: i=1; AKwUvBz6xwdygnVYtxeIRJdTkE13Be2ER1cQkSyGaX4bRsq5hqE5Hn6L63Avjec4OfHmg1+X0pB4Bo+mTg==@lists.linux.dev
X-Gm-Message-State: AFq9FYLKTaCi23bxOncehEWJ/Nx2fU4eWw0ERyLbXSfKJfpb6CBs4XH9
	AtzZ94Dbk+DqapU6mSED07YgYhCdEJ8wCyGlO0G5J7DGfOeUYFo16mtMRXa0kPXXfBw=
X-Gm-Gg: AYBFou1oV5KjE5XLMO8GWyRFLaBH+2bxv/mHwEIpO5JWUEB34cz0hL4cD70BK0E4Zr6
	PXCnrwy0BF3skx0fg4ysd5GLtKVPMvQkAXVcPc/vmqwb0z9pjO0J8ZE7rA5x+Yp+bQWiOBHlEKg
	I4AVYQAVDuD757400ji8fhi4fe2LRJBhtXCGtNfD8dJnCRwuHIGf2geW6thcqwuaKcr8346S4xb
	xcSbhm7Uyg7ygEqdY5YDvjO8z8CqLWmjJsgms0fM4uA5UzXOKcmG2mDOqj6vwqfjymXPRk5fSBR
	eC3g7vU7ko//VimX40xH8JnKnVwmI9F9Gdne1NE4/iiCCKVDUbWodWpvzDJPOFMziipWr/uqvZ4
	+5fpVAjzmi/IQUWWZZpQTSuZDN08z9ofh/dfcuYimohMSvasA5mOiBSQnAjMIq4K3VEUH+U+wAA
	MIJVtjwDX8XaJugdt/81nEQxbrZBNHIMtsC5XiRpwMslb98QrDfHeFopXnbAnKtMnqy2Tn31r21
	exoeI3RgPBdQMmsb8daxYmCjgbZQazIwwtMWu1Iw2oL7GE1jehDFnJ+kA==
X-Received: by 2002:a05:6808:f88:b0:4d7:17d5:6c9b with SMTP id 5614622812f47-50c40a3e034mr9500602b6e.9.1791836506735;
        Mon, 12 Oct 2026 13:21:46 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-50c167544b5sm12396143b6e.3.2026.10.12.13.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2026 13:21:45 -0700 (PDT)
Message-ID: <d00e43fa-8f5b-4a8b-8b83-421d637ba519@kernel.dk>
Date: Mon, 12 Oct 2026 14:21:41 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] Add dmabuf read/write via io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>,
 Matthew Brost <matthew.brost@intel.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
References: <cover.1791336930.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1791336930.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/26 7:42 PM, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1],
> from where I borrowed a number of changes. Later it was brough back up
> to life by Tushar and Vishal.
> 
> It's an opt-in feature for files, and they need to implement a new
> file operation to use it. Only NVMe block devices are supported in this
> series. The user API is built on top of io_uring's "registered buffers",
> where a dmabuf is registered in a special way, but after it can be used
> as any other "registered buffer" with IORING_OP_{READ,WRITE}_FIXED
> requests. It's created via a new file operation and the resulted map is
> then passed through the I/O stack in a new iterator type. There is some
> additional infrastructure to glue it together, count requests, manage
> lifetime and implement invalidation.

I've queued this series up for some testing, in a separate branch. JFYI.

-- 
Jens Axboe
