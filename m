Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F618613F
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706629837; cv=none; b=sgv5Yd9V8DsMyFrV+D7KsF3QEefwtfuvNX+SIcejECPeh/Rwq96F5Pay6CtWJsk0P/bh4Ehv22D41etE+VAkHa1LrDGGGn59VyM4RXpbYdySkDf3WM0RyRPSEnyHHWLElh77gGTtO8ClL+tgcDfgpnUByCip+SApTI3sX5PPsC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706629837; c=relaxed/simple;
	bh=QvBaZsLh8DPvYcl3VO8X2y1UuYCG/UYWMaa3pZVysnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0w1ePbXAJwX+MRP0pT0shgH5b1xZW/oOX474GLWCi884VAP4wRui2AX4nr+VZYt58Nl4e2oKxBoJerIgQSOezF6qqM6nfpfIPx8ZGsbcwVA3w7khCGRfC/EKrS5OGSUtC0q/vSnHjsk/Is5dI9io4UIep72sjmtyexie1Muinw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HsyA2wQb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsyA2wQb"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d8da50bfd9so12414935ad.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 07:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706629834; x=1707234634; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XL1Fflhk+Xb40dzgpJerE8E3hGMxHAI4xcbrdBQFd/M=;
        b=HsyA2wQbjyHxQluady5sRLq++i3jNipsIYFdwyHUcLhjLtGRr1od4NM6RAt3BL+4l9
         KNBZL3ygAQWDGrrji7ojw2xMw8dACdTEiJify3qHbx00PZ051Twfzwf8Dx5rSQGo/PSJ
         KC7uZ7TXx7FrdDIrITyyKG4ez2EwLnSpb7/sXX9uR82QhaHmchGgkAgpKnihjUEbDPHE
         Nzfyxd7eUHqJtRIAaO97DaVtbPkuURsl5o4xHZMUQyxuJq0knczKRUDNAPayFkS0viPG
         I9M9ZsuruvBz/ZW+qRk9x+RbUDYBr0fn3u1nPyfuZMv5NjXsbtbncwIAGd/o3A9fPpnm
         78Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706629834; x=1707234634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XL1Fflhk+Xb40dzgpJerE8E3hGMxHAI4xcbrdBQFd/M=;
        b=vqRMD48sQ/+uMosQp8qElnAJmkaY4CnuJjKO4aM7LJj3HYwmXtnw0Z8Js5SdwNfDua
         XDsnaWwGcPKbMa6BbksnK/zFDyfR7MjD4y0qQ1bw2v3FZAHHqWhcoZm8g010RsbeGJM8
         FehIWPwMhDmfbl6cobADqwBQInsM96jLXEGq8hp/qptaoURRCnM/DRChurrsCw3XWZHM
         /TjpGvz3zS4uH1PIQ+Vws1Gp5m9cAe1/cCs50hpVkNpvzM6CYFl0RKNRhq33ooqtHaIu
         txJd1hMIVJACxYpqVMO5ndezJgGKeVCN+tL4ckZFoScskaH72sv/r2/VPelwqL2jXZ3J
         pqqA==
X-Gm-Message-State: AOJu0YzQtJ0f5lw5gwfmolO99SPgro3OaOFDEquoX9yHb0qo7QSRbEhb
	BsAVFP6EJwNK3EZkmmUSOyYtAiyH3+pKMZUoHMTnlXAKl1NNTekT
X-Google-Smtp-Source: AGHT+IHIMCnEYaqIb4Pi3z0PuUNUYde12Aucu4qoHrB+Jeqg1FHSLC8058xLuEM1zdrmgWVouVt3kw==
X-Received: by 2002:a17:903:40c3:b0:1d8:d2b8:446a with SMTP id t3-20020a17090340c300b001d8d2b8446amr5082317pld.27.1706629833562;
        Tue, 30 Jan 2024 07:50:33 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902724600b001d8aadaa7easm6480425pll.96.2024.01.30.07.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 07:50:33 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 30 Jan 2024 05:50:32 -1000
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, tglx@linutronix.de
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
Message-ID: <ZbkayGEYJNJx3ohw@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130102011.rX9Qjnp1@linutronix.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130102011.rX9Qjnp1@linutronix.de>

Hello, Sebastian.

On Tue, Jan 30, 2024 at 11:20:11AM +0100, Sebastian Andrzej Siewior wrote:
> If one context creates multiple work item which are then moved to
> tasklet I don't see the difference vs workqueue with a bh_disable()
> around it.

The main difference is that it avoids scheduling latencies in scenarios
where softirq isn't heavily loaded.

> Looking at the USB changes, I would prefer to see it converted to
> threaded interrupts instead of using tasklet or workqueue. Both
> approaches (current tasklet, suggested workqueue) lose the original
> context where the request was created. Having threaded interrupts would
> allow to keep everything in the same "context" so you could prioritize
> according to your needs.

That's great. If threaded IRQs or even regular workqueues are suitable, that
should be fine. This conversion is just targeted at the use cases which can
benefit from executing in the softirq context.

Thanks.

-- 
tejun
