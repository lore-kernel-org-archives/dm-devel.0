Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D8682D71
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 15:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706630010; cv=none; b=mGvURSayIbewimz8tUoffquJS9cqIoStE7BXUw1zqwVTbSFTsVtTnO0bCyNQAeQY8W0PaD6FuINtfKqg2J+1DaOsVxf5TKLJCZEDXScmm2wHS8W1bfbBBr96u4jQbkD0Aiw6zbHnjsHwbohV+Zvc/5wzPxa2yTwu7zZMxbybark=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706630010; c=relaxed/simple;
	bh=UIe+zdWCR/Ww2V/jLPrMjticY2axcU12ENjKMXzkdzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GE2Jtt+YMRcCfT+nUadTWmOLbZM6TeDu72cuc4IZ81Jq9h2dsqhtOq5Wq/1c/bLe7X/0HtT4S8sNjpyFhJO7mf9GS14wVgsW2LmRP5YNVP4cnE+VBiJAm6b1RSzVqN1LEBsjC5c4YpiAkrpHV8ZOnY8pQs7LnPLSf5R7R6ffnws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hycmpFpe; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hycmpFpe"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6de28744a46so1055307b3a.3
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 07:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706630008; x=1707234808; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WvnOw81iTWv+Rh9SWXo4ayaLBbjRis7Z8HFX8oWs5s8=;
        b=hycmpFpeSmSaYk9fg1GwnrkEN3o8JOWXN5rgNXgr9mO4UWwzTfWCXLfHrqZYVPucEB
         7sbia5ueu8Tgp51zYVt7g5VTjU0SiF9PWYOlFqmBNjTh3hxgJg/lglhv/nxYsEp/PlKM
         zlW6Ge1TK1Azsq6mSGsl7O9jZ7HJnNA3gr9/oiewYwLChnMaWNM+1YIwlA18gVlKHYqH
         00FCEm+r7eJznCZK0Ur5qq+cmag3NneuN+X0bp2VCXfT5WmwQ71/RkPv3HUmBIAr3ycX
         HxCbw6lofOBu/aAruH/NrnHDy0GcIIzZnlYdxPT7E5V+MR8stAiTC10aTLKPS2VDp1u5
         LqTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706630008; x=1707234808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WvnOw81iTWv+Rh9SWXo4ayaLBbjRis7Z8HFX8oWs5s8=;
        b=EQ0LU0VTK9nAGGlCxkw5Q6UxmwmRlhgGxOJULOXsG7eE4Ei62sdUCHXzH6g92TlS8C
         E7nn/QNF8FFYFLYzTXKH9S9Z371BDaM1FelNjrujf+JAH2Q/HpiMZEDJCfuQn5MUHtBy
         HHvwztj3tlj+4rtrWfBDgAGFF72qYnXgRZTMmPbezS+0lBw3J/x21N0xcnA5cuChg4y2
         K6a2fRlOpGVFctDTxiN5gyUi+dQK/iwXl65Q5Z96Cse1g/qBRcQeWhxkM8g0MN12OpzT
         J6oqK9ylZ1mcTgG4Ywl5+BDnxyBgzrwD+aYZnUo2KeYL5OZp/u0sXaTpihsGU1pol94S
         1wvQ==
X-Gm-Message-State: AOJu0Yxu/DGuCGQrapbZxhJMBvbqf5ZfacfHm9S7jOTn/XshjC8gANxd
	QX/90wi0Dn+U2RJjOwo0T9kn3t4nKtZvhu/V7IeeXLEIlZ92nSPQ
X-Google-Smtp-Source: AGHT+IHjs+7Au2nQ2UZ02r/5YFemO3930W53TAMdk751tM0g6UVfvFp8IJR1SUj7EikwCAORkxjt2w==
X-Received: by 2002:a62:d148:0:b0:6d9:ecbb:8bd8 with SMTP id t8-20020a62d148000000b006d9ecbb8bd8mr4760905pfl.32.1706630008269;
        Tue, 30 Jan 2024 07:53:28 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id gu2-20020a056a004e4200b006dde1781800sm8219654pfb.94.2024.01.30.07.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 07:53:27 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 30 Jan 2024 05:53:26 -1000
From: Tejun Heo <tj@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, tglx@linutronix.de
Subject: Re: [PATCH 7/8] dm-crypt: Convert from tasklet to BH workqueue
Message-ID: <Zbkbdm66X2LcxSHD@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-8-tj@kernel.org>
 <20240130104645.Gvnx8KnC@linutronix.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130104645.Gvnx8KnC@linutronix.de>

Hello,

On Tue, Jan 30, 2024 at 11:46:45AM +0100, Sebastian Andrzej Siewior wrote:
> On 2024-01-29 23:11:54 [-1000], Tejun Heo wrote:
> >  		if (in_hardirq() || irqs_disabled()) {
> > -			io->in_tasklet = true;
> > -			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
> > -			tasklet_schedule(&io->tasklet);
> > +			INIT_WORK(&io->work, kcryptd_crypt);
> > +			queue_work(system_bh_wq, &io->work);
> 
> Why do we need the tasklet here in the first place? Couldn't we use
> workqueue? As per comment, the request originates in hardirq and then it
> is moved to tasklet. Couldn't it be moved to workqueue regardless?

Yes, you can and if you replace that system_bh_wq with system_wq, or
system_highpri_wq, everything should be fine in terms of correctness.
However, that would mean that the work item now would always incur a
scheduling latency which can be lengthy in certain circumstances. Whether
that's an actual problem for the subsystem at hand, I have no idea.

Thanks.

-- 
tejun
