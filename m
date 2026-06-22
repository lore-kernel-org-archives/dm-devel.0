Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B943935E1CC
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 07:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782112257; cv=none; b=sP98cOmsazoysdh9QxZ/x0DtykIspLng1lgQUqUMdVgutEH1MHfmngOj/bVhljv4fyA2vLAIP4er48nckv9w23r3kFDrtzynp4nWxV/EmCGuSRdWRBCb0QQIaDJ9AxcXIEuFx7lV5A77Y0FUyQUkfjLebgouaevhkIv3tRCvONA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782112257; c=relaxed/simple;
	bh=u+uJ4HaPyb2ulGWQw1CNNGmzGbVcQlnW5f3xNQcEsmI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdpUUHqTv4S4lmGDWi+xYUrSjRTDDh7OjaaAmIYT+0gG1DhrfMwmWeYPow+euAtGMyEhMgf6aD8PplgS9aXvkkRqlKmgzPdse9X0xZZ3SNZ6K3KsPc2+2ONuLZoe8An9RZoXqdxVrH9PdgZsDEZ3L09mHF3L2pq2rgsx1aLIl04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DcqUk3fG; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DcqUk3fG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782112256; x=1813648256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FdlnEGLSEKk038zsFCl8Dz0uFyO2Udiqy1kTdWElKLI=;
  b=DcqUk3fGGY+LlE3kxKavdFrhzN8iKXziVUhcu2U+OreQOLjtSTia5Svp
   5souIebFgwc/A40WeiSz/JpHUJ/MRDuX5LRcN6OMCOi6wnSl03saqdsfW
   xh7JNxAAKadAAxKU3knzH+pwO0ZiW8Qk0QsWH3y46EtnZbFvJdQ6SWFvv
   BofmC3WzOQ2yMt47KUV/95IJEkCVc+JIJkmogxVfnx33rjWyqf7zXBZ6v
   0USOLXgiV/Bv/2Z9DDq/UsvQvw0IVV3DfHUO0MlZXBfpndE74V/NnPz75
   cZA0k1uflMBqLMfQDoqjFsGRqYi9+tJnfYYSG0MgRWyNe9WzXBLa1kXnQ
   g==;
X-CSE-ConnectionGUID: rABLub2gRXyzLLuk3aR/Uw==
X-CSE-MsgGUID: NRKhkDvkSCGXMxH02XT7qQ==
X-IronPort-AV: E=Sophos;i="6.24,218,1774310400"; 
   d="scan'208";a="22108465"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 07:10:53 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:18825]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.30.151:2525] with esmtp (Farcaster)
 id 7fa548d2-71cc-4328-98d1-46c29245df1f; Mon, 22 Jun 2026 07:10:53 +0000 (UTC)
X-Farcaster-Flow-ID: 7fa548d2-71cc-4328-98d1-46c29245df1f
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 22 Jun 2026 07:10:52 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 22 Jun 2026 07:10:51 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers
	<ebiggers@kernel.org>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Jens
 Axboe" <axboe@kernel.dk>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] crypto: skcipher - per-request multi-data-unit batching
Date: Mon, 22 Jun 2026 07:10:44 +0000
Message-ID: <20260622071044.4079-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ajDWww8OgNcXs73c@gondor.apana.org.au>
References: <ajDWww8OgNcXs73c@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWA001.ant.amazon.com (10.13.139.45) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jun 15, 2026 at 03:53:17PM -0700, Eric Biggers wrote:
> So in other words, this series slows down dm-crypt and crypto_skcipher
> for everyone to optimize for an out-of-tree driver.  And there's also no
> benchmark showing that your driver is even worth it over just using the
> CPU.

I measured on arm64 (Graviton3, dm-crypt + xts-aes-ce, RAM-backed,
fixed CPU freq):

  - 4 KiB random write, 512-byte sectors: v4 as posted regressed ~5%.
    Root cause (ftrace): a per-bio kmalloc_array() for the scatterlists,
    where the per-sector path uses dm-crypt's inline sg_in[]/sg_out[].

  - Reusing the inline arrays when the segment count fits (heap only for
    larger bios) removes the regression, back to parity. This will be in
    the dm-crypt patch for v5.

So the software path is neutral after the fix, not slower. No software throughput win
either: the auto-splitter still calls alg->encrypt per data unit. The win
is for a consumer that takes the whole request in one pass, a HW engine,
or any async offload engine that pays a fixed per-request cost,
it currently pays once per sector instead of once per bio.

I'd rather not over-complicate the patches until there's a general
ack on the direction: per-request data_unit_size + auto-split,
enabling one-pass consumers, neutral for everyone else. Is that direction
acceptable? If so I'll respin v5.

Thanks,
Leonid
