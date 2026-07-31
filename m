Received: from mail-oa2-f1.google.com (mail-oa2-f1.google.com [74.125.231.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D35E3B8BBB
	for <dm-devel@lists.linux.dev>; Fri, 31 Jul 2026 14:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785507090; cv=none; b=GqPzj4TlFB3sigBEKpfukjG6OggdSa1NyODuWu4lQlUTxZD4BewotfefFJMRR8j7mgM7XR9vY/w52jPNxfJpyEdefxskGxQouohGVj+DDaqeKlYYI8wykZt1Ea/msB/0tbCT/d/t2RXLDCzIRVL9BVekohOj0exJDDnVrxipRKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785507090; c=relaxed/simple;
	bh=4ZdjWakCq/Aqizx6AFYC1adkwgp2P7rM4QX9GlA4i94=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ICyUmnhvxnXK1lyUGJjYEr54+/viC10TIdxyLE9oB5A0J+VkVn11RmmY1seZn/PDV1tY2RYRmUHQOROOPIyIeHD9Ab48IVJInyf8f0uXjXLDjz4bmexyJfytGnJupS9NIWc93yl63wliocX7J+/2pqI0ZOnFoASVjqU7kU8OTMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Dg8gX0+A; arc=none smtp.client-ip=74.125.231.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Dg8gX0+A"
Received: by mail-oa2-f1.google.com with SMTP id 586e51a60fabf-451e22b4773so82949fac.0
        for <dm-devel@lists.linux.dev>; Fri, 31 Jul 2026 07:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785507087; x=1786111887; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SUpW3doNTk9ZVDYiQz02iPdiZ/HzJ9pbPw8kgbFuw4Y=;
        b=Dg8gX0+AmUQYDXUxHuU1WGXMZN/D8iSQbowuRIYxkIpby1rQy2luoKo+00Plm30Ppv
         gPz9Ys6fj0ASu2DRBSaMW1a81q7FDPvmLU2ivZWgxkt34/dIL1QdskkxBLtI9M2gRvDP
         xmGKSZF7/n8rwBuLJBlnVTQkLc59/RdtfCkJHTZtB3nwjALbY8KHrxDnRo75OgnRaiaD
         iJ2flOAdqnF/HghjZIiYJGwji/hqjmxJtvcOWmc2xQYTc6uvQLsIVm4O2NfrQJ8F2EHr
         AKv8dyKGzr2iVosUVYn5HZ/crLe2+bBVqOfg9Hx1Smi0u9Wq9qLGavK3iIB0+wcKKkH5
         7iwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785507087; x=1786111887;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SUpW3doNTk9ZVDYiQz02iPdiZ/HzJ9pbPw8kgbFuw4Y=;
        b=rOViN9NhnObIpUbfGooiEjW08oSglPG3XDFI+9nJC37RTepMZmgddsRW2DUu6TyYy8
         Bkx7CiJXSgwXxczDhvgBQgPsqHLK9kdK6cXRka137UA7xPouAjLbekS3R7nE3lpdZ7U5
         uDhe0ym/OM97czsFEVXU/Xt7fDVQKxzqMm++nTp3LBFovjFEODsL5fj4OuaD/3vOzBD/
         xbgs+cGMXVOMVHuoFjFiCHvsuVpdA708aulFNlW1ONf0GPTbKDh5G+KJAI9tGRzAzUH8
         v32DOrCD2z8clAQ36B8Z99yF0HZY/inaj/rqzonOPRKW5MQmleP8JKtG2Spu3lmkpm3v
         tliQ==
X-Gm-Message-State: AOJu0YxPmc6snhcG/3y3+mRgX4Gqa4erG2ud1JBOGEmNuA1/7CqjDcRw
	XJvQ2+HYzfSZNquMBcSMKy5S7m8Cuja9+ZucAeXJbwKF/x5jCItrnXgTO/mtrlDBwKs=
X-Gm-Gg: AR+sD11ObscC45EKogNoBzFWHJBx0ppC19YdMIQ8VwIo1ygOjVHooXc+xoDeBfvePHb
	KuSCqOrW/369zdNlTrvMO0eANiV1iJEg/P7r/7MzQ7BgpyWKMGQ7tmR8MIWATPTRch6k6S+Ewt0
	ZQZp8JrSsSkUfDhxOcHbRGFTAtKH/CGBeNPI2oxCsKwaW9ZTnJlJyBU6B3r41y+XScoWxYJsBtY
	THk8Lbqb+ORsjFHenIxFjjBU+atfR5HKX/3HwdRK9JEVs+LomdwQJFt3ivakM/ctV42KdYWUzMl
	/XgeREhFORTtVX+QDxln95uHt146B5q1tcvfPLkfAxAaNL17FqPSHbG8TFkH2MayMFkfcS368lQ
	L5DDwaBamnWFQsV5OEV3OtqX1hp/2OyDOQU3+EM4CYEAy0uqeWpLmIZV2bUXApjUJVqsz5Kei9A
	Zi5co7udb2ghfGoEFcFnr8X9MhSfE23gSftOdjMTjmAkoZ6pYbZHCLxagF+9x4X2PolN24pkV85
	VV49LxDwdeLF1n/1KYCK58SvOzYRasEfBVUtBdbcY0=
X-Received: by 2002:a05:6870:d40d:b0:448:a0cf:5afd with SMTP id 586e51a60fabf-4590572cc6cmr526052fac.4.1785507087079;
        Fri, 31 Jul 2026 07:11:27 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458f66c1fe3sm1162982fac.14.2026.07.31.07.11.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 07:11:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, hch@lst.de, brauner@kernel.org, 
 djwong@kernel.org, viro@zeniv.linux.org.uk, Keith Busch <kbusch@kernel.org>
In-Reply-To: <20260720201057.1862857-1-kbusch@meta.com>
References: <20260720201057.1862857-1-kbusch@meta.com>
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
Message-Id: <178550708596.3329022.10599196691426679849.b4-ty@b4>
Date: Fri, 31 Jul 2026 08:11:25 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Mon, 20 Jul 2026 13:10:52 -0700, Keith Busch wrote:
> Resending in case this got lost.
> 
> This addresses the misaligned direct-io problem behind various threads:
> 
>  https://lore.kernel.org/linux-xfs/20260610145218.141369-1-cem@kernel.org/
>  https://lore.kernel.org/all/CAC_j7i1R7oy+nRhxEjCTba=DUgn02w9X+p94DCu0aHv5+5tKnQ@mail.gmail.com/
>  https://lore.kernel.org/linux-block/ai7rnH20IYeSmY8s@gallifrey/
>  https://lore.kernel.org/linux-block/20260616154009.2123183-1-kbusch@meta.com/
> 
> [...]

Applied, thanks!

[1/5] block: use blkdev_iov_iter_get_pages status for errors
      commit: 75ae18ca942674f9d5b55d7e8a2975485125f715
[2/5] block: fix dio leak on metadata mapping error
      commit: 702a2a9f3dfe066a7481698c858371112f3cb697
[3/5] loop: set dma_alignment from the backing file for direct I/O
      commit: 6c8dec275ccc35e8f86cb9287283d31c5d8e9ab7
[4/5] zloop: set dma_alignment from the backing files for direct I/O
      commit: c5059c1af2bd22bc1435b99d27d800164162cb72
[5/5] block: validate user space vectors during extraction
      commit: 14b007e178811db72fbb1ebb3535160db6ec1e6a

Best regards,
-- 
Jens Axboe



