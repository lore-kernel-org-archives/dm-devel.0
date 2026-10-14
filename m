Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5D150EC17
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 13:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985403; cv=none; b=mT+PSTgbpR+96ERLeHd0uSJg6tmq9WPNzV+wD5kcUEacnJhxzI5ot4f4+CspZgz2smnQbK1chCk53xfPrk/v8i/dA+xgnL0gcgx13LCV36KmLq+gdzqC9Aswb0R2cXPgRm0gjp+/dPpZN7nU0deWx+YGiuVj2UARUGuFx9giUxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985403; c=relaxed/simple;
	bh=W4/9IswMV+nhf+i4xgS+WWcxFQT9qKFQQYu/KCal4N4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fQXvJX5Xr+m6dph7z65HYrJDxeYYUMLLtHjSWtVSYG+n1JspSmgL9Q5rE6kzpSGHyoPLGGyhzjXYCV+uA3DuhXw/iHzwRwlY8obdD1e9kOyvxd9WH7yWYyhqjKYj1fjn8L+MtQuS7N9Cu3NE4xNW7xAgVGqfM0cJPBlxZP0UBDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Pg/HBdFs; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Pg/HBdFs"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6d290b10a35so1619654eaf.2
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 06:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1791985400; x=1792590200; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/UfknVFgwY+ADn2+7Gfp8pJoPMV5PqQ31vPcFrLztQY=;
        b=Pg/HBdFsGcQioaH65SnOXeUbrHHoJcROEwJh3FEV5H8JlpUvssaSCOSe5mu2Q0nhnQ
         hDiNFayjIPJJLf/mRG5LUv/riLVtI/OYroMZnSxJ6CahAvbp8uqJiU6wF11k996qChHD
         V4fXWfPQNvkrmRcxeAmtaoNAdtoGC6DzcV8QjSZNIole+e9NloTfLo+/UKG5dRPIhClS
         myjuUMlRAanCL3lrhDEx8YZbd7qboRhyjHDgvwwnKaYtgSPKQjumSw5f9EwJGTew8Kff
         7085i4NC9kfylbAU1zl5y6VY9dYE/8BP3WtlXpviGw1Vnf7Cy29FLyqYsAqqjLWnmJr7
         HUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791985400; x=1792590200;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/UfknVFgwY+ADn2+7Gfp8pJoPMV5PqQ31vPcFrLztQY=;
        b=SQXHRVMRYNdZ6yIZpU9W1MxLzZZ0FNched+lR3ldcbyireBff6bFfp9kTkFugJ/tsJ
         hDcsizJjc6u+UjUOHzHG/yepY/0cL4VyHbhW2XDa5akEkLECmzooBoG+6rssFxddG6UX
         O7Wv9bITarMFz+Kds86+T7kg/9jOxAawxWrakvc6gM93tcrOYYA8BHTXUO14fDb+6p22
         jLOLIeWahXnM7cwZZnm9CCC0B36aaT+ZMxCudJGUrniANFhxiyMpkcNPLxB3L9aiqzmA
         5dLT1jiSf3eLkuY5fC/UJuHcigpQusIyqLRyjmWQLJv9VKTtCwNoKclpvvVcODOkotG8
         TCDg==
X-Forwarded-Encrypted: i=1; AKwUvBw5RcGbPtlbiY+UgkZeOyD6C8noVzh9nBf2Fm5hvfCOz9ZRcxL/90C4zNTy7kLkrW+gNJoqSQm4jA==@lists.linux.dev
X-Gm-Message-State: AFq9FYIAQ/JYSPmrWUqHCbqO959mmn7mFggsycdbh3Wyb6ma+W9zL111
	JNCCevvpCtCSkSSLJxglTTOEhAF2v70MAcuSVuWh1LhBcrNhT0CLSLwLT9BG25Odfnk=
X-Gm-Gg: AYBFou0h8GGICG+YZSuKAq21pT8tEywWYs7hVNic92xrbMy/NZHCshLhkcV7V0Bn/77
	xrWllxtv/BoB00zfh8gjju4A0GfnITn3puLDVOmy/VZSdBlkvWPakezAfwy27+EUfOW1zYREbkD
	SDiO/N5WlAl38Z+ekd0iZKPiHQWmHyg1nPjSBhHKDFJNzYX69NlmpQnJi5qyUeMaCyVT2Ef4IhN
	3V3C8cc75k1zu58hrKqhto1j+2Qj5kr9gR/6yDNucUxIxrd7R0na0PmbjEQPGu5b6kcPuUdQyCR
	Dhkq4Q7e4wPO4Rj9JdrzcBOVVa6fYzFCR6BzYBXOZjfPvwJ16lSi+VClMYLc+FiJ3/jrATjyXDg
	tPxWvz6GT19wagjSVYwiYqpTzJCxXOXRSSA+Si4LFmCYYuPA2e++KZ8hhJjqQQt4S4WUlLn/DDX
	/7yPW/DAk+z6drjjgQirUcvdMYN88hrXs87ugajcbGVBJL2hhnjrdZiFmN+eMbKhOBIc4U0xe2u
	wWyRczw+b4l8EZBWNCA5OSeeU1JwpP0QmDovINWCFfSTrGQGBFoYLiqeQ==
X-Received: by 2002:a05:6820:1c8d:b0:6fd:3c3e:3c66 with SMTP id 006d021491bc7-6fd3c3e3e7fmr1002063eaf.3.1791985400251;
        Wed, 14 Oct 2026 06:43:20 -0700 (PDT)
Received: from [192.168.1.106] ([198.8.77.135])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a6dfb4e92asm2073695fac.6.2026.10.14.06.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:43:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
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
In-Reply-To: <cover.1791975048.git.asml.silence@gmail.com>
References: <cover.1791975048.git.asml.silence@gmail.com>
Subject: Re: [PATCH v11 00/13] Add dmabuf read/write via io_uring
Message-Id: <179198539824.583283.3195125120949504062.b4-ty@b4>
Date: Wed, 14 Oct 2026 07:43:18 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Wed, 14 Oct 2026 12:01:58 +0100, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1],
> from where I borrowed a number of changes. Later it was brough back up
> to life by Tushar and Vishal.
> 
> [...]

Applied, thanks!

[01/13] dma-buf: introduce initial file I/O infrastructure
        commit: 0d3120db2cbe0a8793650e19f0923968a406ca2e
[02/13] iov_iter: add iterator type for dmabuf maps
        commit: aeb3bb52052b3548b3acf0cc5606dbb5babb228b
[03/13] block: always adjust bi_offset on bio_advance_iter
        commit: 801503b9a66f7c2423b5e495d8e77e0f4447e5d4
[04/13] block: introduce dma map backed bio type
        commit: d88e44f43e939e6ac0ca8302c6f3c957b33aa5fe
[05/13] block: add dma-buf support for raw bdev
        commit: 839231d193932ca0d592c2859669066f7c43731c
[06/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
        commit: a03648e2efda070322cd4066abf4dff15be093c4
[07/13] nvme-pci: implement dma-buf backed requests
        commit: ce5e386c110815e3a29e3ba27d97575c28589c39
[08/13] nvme-pci: add SGL support for the dmabuf path
        commit: d5c8cfd41d2575c65c3f1d543017949e578a92d3
[09/13] io_uring/rsrc: introduce buf registration structure
        commit: 727a66ad21b013555eedfd84559cd4707717463c
[10/13] io_uring/rsrc: extend buffer update
        commit: a5819c456b716fa8bcb7792b942ab02b15e07fc5
[11/13] io_uring/rsrc: add uncloneable regbuf flag
        commit: 13b1690bb4767d3f1c847baf71a704c5f2da99e2
[12/13] io_uring/rsrc: add regbuf import flags
        commit: d218f3e381908da0e68429f3a4b764e666564c60
[13/13] io_uring/rsrc: add dmabuf backed registered buffers
        commit: 62e4bf5b25d4458cf8aa9dece9022359f39f2294

Best regards,
-- 
Jens Axboe



