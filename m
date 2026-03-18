Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74BB3AA1A1
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 09:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773825924; cv=none; b=YkSMRYLk7llnGlvMnk7Rp0RgnX2aoAHASuqI7f41foaeBAsUuWf+Ob9/dWxl4wH74pUpojGVmJhYyJctdAncbjvdIbciec8CZRzq+a+5zQZw3LNTZRPdnygVGcV6KdsCiW6643eI9Fph14mMLHcpoH8Z0BdTguoWwgS3WER6mDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773825924; c=relaxed/simple;
	bh=T/LVWvo2nvKPWMNK0xMWm2ZwaHkEiI/tDG+V+ayj/sk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Nq08CR3ZexBMzJNhsgK/whlKaLOMDSQv4yFHQ+fXUG2tuQ7oXTyOATh3FbjbutAEN5ueOLVhasJyxtB4UmO2nUe3pwdaQXuEULBHJObMb7uDAxuOAuEUflYtxZoeeBx+g+oe4NxqDeITmrYE/aLaEkZsXSF51URw1D1tQ2fyBvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdtgcWur; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdtgcWur"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43b4915161fso2173273f8f.2
        for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 02:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773825919; x=1774430719; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/LVWvo2nvKPWMNK0xMWm2ZwaHkEiI/tDG+V+ayj/sk=;
        b=ZdtgcWurrpz2ROgcE11ffMte5iJ9wdX1nlZkFBSF+yYs411Jjpca1ixNmtktFl8e/B
         WTAEXClev7Ea2rmpY3ZBRaHZKZ6Gv7Zo2IidrFcnk6CtfRkM4APR0wrD2tIEAdfRas0h
         lsudRWvkNEjylFCjVCcYG59g9F8UfFyGEtIybWcVj3uJ7yfafqmlo8UBNtokF90DmeaF
         KG+X3vEA11AvY9Yr7ct2+cfV7Xpq+dLJdojqXyjduROHyMNM06D4SWa63XAq9x31vmI4
         bqRU8h8Jot1iQroYpiGnZL4Ibi06sjO7NtjYWvGRLiqwp/GI6Mid2yBVxhgL6QCHZGx1
         VIbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773825919; x=1774430719;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T/LVWvo2nvKPWMNK0xMWm2ZwaHkEiI/tDG+V+ayj/sk=;
        b=ofjKylKFNuV3+8oGd/amZMFbR+8fOtP5vU8O1CUu6pAHwH3Y+UX3UrXwPOX5AHT07a
         8sdi3l/v7pQe4V5zjiPOzQXI39xVDGqSkJAM5PLfYH5Px/mdaoW+r3MtZuKHKFQMjflA
         zF8LodSzzypah2g8gcOljmHyXRWun7dTiodgslNCiyDICrrO1JcrW5PCF1yd26aSRxuf
         jcmOFvhRhROnfPNsKc6E4s48Ca9wU6nGBWTd32OXPcDgCQBY4gWmPHX+u3kgIseRgN3+
         vUPnzYhvb2Gr9RTiqrFBMXLH7W1DzAj095kjRe7R5sCjudIa02gD6deCT/LSBFwaRAd6
         XUMg==
X-Forwarded-Encrypted: i=1; AJvYcCWTuOy+bOOR4+Jn4iqqJy6l7h+AdzheKSfeqHPm4FvnKUtLC65zuyfxdJpoW4qt6pN8O49UmrEBlw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwLchU6ypFNYPvCj/1errsEYkOuNftt1UkgpLXJn0Nn2Kp3HQX5
	GMSgFAqjCcixxYBJYW3/4eDhbzPf4K9u0BddwzQVouHYM2DWY2TD1JAe
X-Gm-Gg: ATEYQzx7CQjsxbLpwQI3q7ZMoggbP6TihnzRT7c0FoSEVnKJ3+noXJaKBQP+rNaFjJz
	30iCwWQ4miv6u0Xby/O21SRGsMfjMDPbU8xAmMNsSN8e/HWaqb8hhsY5TsPNe/HREFGwgehsow6
	q3HyshygmwuiAhP//xzK+LbO2zrmuOCDYLPHqr/W5xNxRGNoZKBj2d6uWH2Fytc196aavStRJHU
	Sh2tSN36yAPPzhRpc30ktWmZwrFVGeRZOOJHroEDkvmibfWGOBbAytYQT+kniChMTdMiQ5j/GNh
	EmE4g8QU9yv09YUGQFhUMH+gAAQsjLsjBuUJbMMOD4y7HcOfn600hArXPVay1acjBaTfwQ8VYsz
	FuADIV9XLZVsWF5oO1wOrrBvhXEg5AiisQIk4EsZrKxrGl6sx9kj9NcoPVyLXIazwK+WrmPtfGH
	3hgx4uWLVjpxGJFWjf5p14k5cF8ihr
X-Received: by 2002:a05:6000:24c3:b0:43b:3d02:7806 with SMTP id ffacd0b85a97d-43b527c4e07mr4024003f8f.28.1773825918743;
        Wed, 18 Mar 2026 02:25:18 -0700 (PDT)
Received: from localhost ([2a01:cb16:3041:ebff:ef18:4b18:1931:7603])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b51892234sm6249342f8f.24.2026.03.18.02.25.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 02:25:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Mar 2026 10:25:15 +0100
Message-Id: <DH5ST417XXZ2.BF2S1QWZIQRP@gmail.com>
Cc: "Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>,
 "Mikulas Patocka" <mpatocka@redhat.com>, "Benjamin Marzinski"
 <bmarzins@redhat.com>, <dm-devel@schwermer.no>, <chanho.min@lge.com>,
 <jaeyuel.im@lge.com>, <dm-devel@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, <hch@lst.de>
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
From: "Guillaume GONNET" <ggonnet.linux@gmail.com>
To: "Peter Korsgaard" <peter@korsgaard.com>
X-Mailer: aerc 0.20.1-8-g985ce7a92be4-dirty
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
 <87341xh7hc.fsf@dell.be.48ers.dk>
In-Reply-To: <87341xh7hc.fsf@dell.be.48ers.dk>

On Wed Mar 18, 2026 at 9:22 AM CET, Peter Korsgaard wrote:
> There is already a wait_for_device_probe() just above the loop, so what
> does this fix exactly? Do we need both?

The mmc_rescan() function (that probes the MMC device) is called in a
delayed work. When the issue occurs, MMC device has not started probing
yet (bacause the work has not been scheduled yet), so the first
wait_for_device_probe() does not wait for it. That's also the reason why
this waitfor parameter exists, otherwise the first wait_for_device_probe
would be enough to wait for the MMC device if probing wasn't deleayed.

The second call ensures that this delayed probing, which includes scaning
avaialble partitions, is done.

That's also what is done for rootwait=3D, there is a first call to
wait_for_device_probe() in prepare_namespace(), then the busy while loop
in wait_for_root() still wait for probing to be done.

> Interesting enough, I have never encountered this issue myself. I do use
> a partition identifier (dm-mod.waitfor=3D"PARTLABEL=3Droot-a") which
> presumably sidetracks the /dev/mmcblk0 available, but partition table
> not yet parsed issue.

Yes, the issue occurs only when partition scaning has not finished yet.
