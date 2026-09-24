Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2334A5EC6
	for <dm-devel@lists.linux.dev>; Thu, 24 Sep 2026 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265232; cv=none; b=FXI3A1NPc66O/lmQrfXLLJQpCShdNqSkmDbslNZ2FgIiUbAJL8FuaGCcZGv8swtX300SOX6EYKpTlwwKzaKrsw8c0335haX3RWrGKEJA0fNYDGHAwvy57wN5ftOuMVbK2JvmyqP2c65OVxas1cRjugQt4hX1cSth0NsFctobJ3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265232; c=relaxed/simple;
	bh=wMUbxl5vt/9aakHALUb0wzH/L2TqRFPYLffnV8Cgl4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kwndrKopoTJjAXi1a8yXiAbzzKBM1iH/S/ocoq9wplhCwRbiSawPXXzOMVF5ARvK8rtrWfBNa/tDrOsxjhi+9zla0urQAIDMjmJ89443mqlgbLns5lGSNcTKf+sj9SHzrfpR5nhficPvfe5f2EpWX3tS+CE5RoNMoR+nS2kO9tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rrEkbl8s; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrEkbl8s"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6aa8d04fcddso1978676a12.0
        for <dm-devel@lists.linux.dev>; Thu, 24 Sep 2026 08:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790265228; x=1790870028; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GNmm9vpoKogbEkGqMdf9XAhWMEnJbsDsb3NN6zmWdWA=;
        b=rrEkbl8sUMTZYJy9/Qi3kwL0qR9FvoHSnl0q8CXiHNo01JzfxZlnDpey0JbsbzUhVH
         5JtjAF8mjyS0BOBVdCk1tUteTFSeKYfgKMRfgEJRym3IN8Qpw3sfuirrZ8V1cBslsfPt
         4ZDgtDLYAsk0KITgxp3qmvmuLr1zhj727olkXUR70byVvP69fcJv2qy22uUOmbxN6YSi
         4hQTO8jdRtmPaFXMoMRMIRbzpi6HjoyO4RZqhx5MpZaxTmGsT9ti/6OneqHUwkHnT7g4
         SnCydi2nR5d6Dm7i7VOt9DYoN+gvW33yt7ED7c6TdCsEpRTZ3hcmWPlZ9hgj/6hPPmn3
         jdvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790265228; x=1790870028;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GNmm9vpoKogbEkGqMdf9XAhWMEnJbsDsb3NN6zmWdWA=;
        b=UID8PwiDWqUKs/wb9ifm+nT8jwhRx4osfcpDfYLtMGk4QxYskLrg8/VjegiwN0Sn/7
         yOrcV2NP1x/8AvZ+CA1hO3riRsBuAXW0HylUg0KXrmw3LqDP7Lz8tldKPmU+oHCMzr8B
         PCb0X+MZ+oEIxkRmND25dN2i4+on4QUoVpgPEBb8Q1XSO+NUyUi09ilmtQp1q5ltHrUk
         Y1qkHgfA7glrIGuHTz6c/AmCmBhvumq841+F/jR2OKpw/guzRqP3phkO+LzoVWP0VqNE
         z03fSYzHwGS4nn9Q5mevMWVTnPdm2SvViYHZ9NK5k50HorPmaGV4jInbfFOW+E8iqKaN
         EvPg==
X-Forwarded-Encrypted: i=1; AKwUvBzlAY2PEzpOPYE5TNsdcrFzYrPjvb1Yx91GNeCm/YtRZG/40G7UZ/BXAcVYpKORAVGS+z3Lb6SBVg==@lists.linux.dev
X-Gm-Message-State: AFuF++ls6Ox+weQHTzdzyZ8HKGmjqZAkdTK++GgdhnlzVl3dSVCH202i
	SPsYqNHwIYCHXLlXqcsSsjIFyPZvUI8TlZVBNID5hskWM4NjsfP/W9GY
X-Gm-Gg: AYBFou3KlSfBpUBddLyfX46kYJt+ZhRXS8ACCTd/pdeG+zE2mO8Bsu48JAsZ2sUIR3E
	iQAm/LyRyaLZ24m6l5pTk/x5xLTB+w5aJuiYa6I1Mp7+5jsIe/QX9Zqm534eHABJaGOrkCLBvcG
	XyWbQrWYN4R3wfHdm8a76hqdKixTgsdUFKwkMy5DOTCaJnv7ffF1ocPOEbuQcGOkhUKWQd7LhZS
	wZI50c7xiiNan3PcK7OyF8SAvtvRbl3Q5CElF5IQu+QDp0/P+t6gKMbr4Dv/tUZ3upE+rdQ1biX
	lxnO7OtW52tzu+ffF1AIz6RfLXnO2iXxva3ZZxJs7enWcz7jEiJ5FLXrPTowmWNK4y6HxL/QJtc
	8ySZ7FttDBQgTUgoZg5UN0IJcEjfLzYHxszEcBRIty+KV42gApLk2ZPxoCrRWWrT7mnQikyQoho
	Tu3QY9/GW6C/pwi9LEOO40QsjZCjLfVtVGe8Ao5gAIqJk+Y0i4nq9WhxPuIo9WCGNt2lBUlYKvK
	S6zvD3rK8hZYiNMywgz8tTS2jAgWe8YBGNmJUYAtS+42UXjOw7UTEe4OpSQEZj7tTzNvPlyqDhG
	2xup8+Tm74cc5DdYFgE4s0VhCwpud1QnNyB8uO1tNDAJXFUQww==
X-Received: by 2002:aa7:d94b:0:b0:6a9:c9d8:b3b6 with SMTP id 4fb4d7f45d1cf-6aac8f0ae7emr1949690a12.6.1790265228473;
        Thu, 24 Sep 2026 08:53:48 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aab38b2fc5sm3815784a12.27.2026.09.24.08.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 08:53:45 -0700 (PDT)
Message-ID: <6d538f3d-dd83-4dfb-b091-9b84acf47c62@gmail.com>
Date: Thu, 24 Sep 2026 16:53:40 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/13] nvme-pci: implement dma-buf backed requests
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
References: <cover.1789997898.git.asml.silence@gmail.com>
 <e80c3b1e0de004eaca6c51a2a86115ac9ed36381.1789997898.git.asml.silence@gmail.com>
 <20260922132016.GA30684@lst.de>
 <d39a6dd7-cb5a-43d6-8dcb-16eb9fc95b4d@gmail.com>
 <20260923045505.GB26231@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260923045505.GB26231@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/26 05:55, Christoph Hellwig wrote:
> On Tue, Sep 22, 2026 at 02:37:08PM +0100, Pavel Begunkov wrote:
>>> Sashiko had a few comments, which I think are correct - if we use
>>> dma_map_sg to map the data, we need to use the sync_sg APIs to
>>> transfer ownership.  That only matters on non-coherent architectures
>>> with MMU, but we need to get it right.
>>
>> I've seen that and fixed everything locally that should be fixed,
>> apart from the sync. I wonder what we can do about that? I can
>> somehow replace it with the sg variant for now, but sync'ing the
>> entire possibly multi-GB mapping for, let's say, a 512B I/O, sounds
>> not wise.
> 
> If we'd want to fix this for real we'd need to add an offset to the
> sync by sg methods.  Or move away from scatterlists in dma-buf, given
> that they are a horrible API.  All of these are bigger projects,
> though.  So for now I think you'd want to do the sync all, and have
> the people who run high-performance io_uring code on non-coherent
> platforms suffer.
> 
>> And I can think of another place that does mix sync_single
>> with sgs.
> 
> Which one?

All the recent networking zero-copy / dma-buf apis.

-- 
Pavel Begunkov

