Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DD64D8D1
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 21:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717103070; cv=none; b=WjdBQXLrqPaVxN+2h1h+Mtsi+frUjFhUxyenob0v+1N4g6X7p86DIeaDfUwLPWna7o3PbB9GLiZjxG4xA2Alh/LDOEcjB3qJ3RGhTdoQDYdIMCEA8RJQRSS2zef6KRGIC7LdyPq/Gd1crDMmIXfLxyIxs4Ykj0pVg3L4e8Uz/sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717103070; c=relaxed/simple;
	bh=zacMwD2B75k17xBwiTcDV8Fm746aX+06s3VllNJfDbA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Y/dYh4PphxtEzVthpg4FYHEn+DNO278dpzzgtRt8iyr03+QPFMaX4WISflLvVMIuiZaBl2ghLWOkHJ8Ef7jKS5mdog7H2NAGm8gUnnVvVvrpQChvYDRoJWKuON9tbZMdMEBt+ULdSm31bxWKQsPipuuxWAMDHO4tJpVVV3zkOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PpO5wZuK; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PpO5wZuK"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6f8d967078dso40444a34.0
        for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 14:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717103067; x=1717707867; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DmVsWK/E9tOB9NkFQ0ll8LZhGunDUEIrCnb9vISkFqs=;
        b=PpO5wZuKqnMVe2N0KicBDxwVx9AfDCuAGm6SF5z88wKfhK2rVG9J37oAttrYIbGyph
         wYZ5jjwVTUp81RrzxCsJhcKDCmn2fgsrs4M5siU4skCX6RH/EZu4ln8M0rrD+lmv9tYI
         OubY31Yir/tcM7tAOpM7FEg1vZIjkKX8rJo2USSTuEJiAbIpEB6APpbWolVkJ4Rk2vdY
         2WbiK9fKSScV1IrEXS4q9xWpVyK0f5/rHla8TdPNEmVsA+j/eiWALdE+4IAiz6ZTRgz8
         iBwB1WGmCdcifs9IEBkliIBJ4CfdmbjAiE5LrDzAz8QX4V8hmMokYK33odxYLbXuvNO1
         gKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717103067; x=1717707867;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DmVsWK/E9tOB9NkFQ0ll8LZhGunDUEIrCnb9vISkFqs=;
        b=vwFQJ+XbgrA2jCDfq/I0SoFW6Tvp4qpPPwbQaGnKojiyMTC9Yf+wMnBBhhs6o55BmW
         M/Wm4wg0QLF2CUY70nQ54BNUtpDhuLV4dZtfbaSLxKxb6GfO7Zf/5rFK/0uSrxvP/Q7g
         2i+Yq/B0mkapHIDr93zaemld3pPMOr1H3rXfrhxPSCwQIyoe5Diikb4p9l8TIAVuVnAO
         uBmdjPQCes3Y2RPexbmapZ7rqpRPSZZpKpYV7CgcxWVe4wYwNRAlXv/tIrl3l0z4ZFu7
         WZlcqXU1AGnE1LW81PkRfouG2Z8AraajIHVpovPDKRDlreUaNwTaCLkKgSSbcommgEde
         TxbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIrVS5kwSoVVSZh8pCb3Lgd9U4CdPdeIa5XEC2cPaJcx6PM+riC/Dw+B1NT9bKFJXKa6I2ls+8eRYJuno0JZzHdF3TssO5FG4=
X-Gm-Message-State: AOJu0Yy4dj6oHClXgJ31J9MzyV+i0tgiCEeWlYNFRD3qGES4+9w8TH6w
	G9SQzkLvmTaKNaU5Dr1EOjGNFkH4I99kmbYrNvdLUlBaUdT9RajRk6o4yhP2by82iQCN9REuT5H
	4
X-Google-Smtp-Source: AGHT+IFU8TrnMQc7ItWkJnQGMjr97rywwV4nt/yGguhqbP6/Dfyv5QV7PXG46HjLsFxcH4q6LD600A==
X-Received: by 2002:a05:6830:4597:b0:6f1:2171:4f9a with SMTP id 46e09a7af769-6f911d8fd89mr19716a34.0.1717103067428;
        Thu, 30 May 2024 14:04:27 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f910539e29sm100113a34.17.2024.05.30.14.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 14:04:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
 Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20240530054035.491497-1-dlemoal@kernel.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
Subject: Re: (subset) [PATCH 0/4] Zone write plugging and DM zone fixes
Message-Id: <171710306664.600767.9806925600309225248.b4-ty@kernel.dk>
Date: Thu, 30 May 2024 15:04:26 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 30 May 2024 14:40:31 +0900, Damien Le Moal wrote:
> The first patch of this series fixes null_blk to avoid weird zone
> configurations, namely, a zoned device with a last smaller zone with a
> zone capacity smaller than the zone size. Related to this, the next 2
> patches fix the handling by zone write plugging of zoned devices with a
> last smaller zone. That was completely botched in the initial series.
> 
> Finally, the last patch addresses a long standing issue with zoned
> device-mapper devices: no zone resource limits (max open and max active
> zones limits) are not exposed to the user. This patch fixes that,
> allowing for the limits of the underlying target devices to be exposed
> with a warning for setups that lead to unreliable limits.
> 
> [...]

Applied, thanks!

[1/4] null_blk: Do not allow runt zone with zone capacity smaller then zone size
      commit: b164316808ec5de391c3e7b0148ec937d32d280d
[2/4] block: Fix validation of zoned device with a runt zone
      commit: cd6399936869b4a042dd1270078cbf2bb871a407
[3/4] block: Fix zone write plugging handling of devices with a runt zone
      commit: 29459c3eaa5c6261fbe0dea7bdeb9b48d35d862a

Best regards,
-- 
Jens Axboe



