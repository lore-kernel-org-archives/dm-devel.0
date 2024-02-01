Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2193E49B
	for <dm-devel@lists.linux.dev>; Thu,  1 Feb 2024 21:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706824064; cv=none; b=eUaSLfLL+SxTPyNYD8x8W/igoc1GmjtBgoE0a9X062XRBP32zMte7SVWsIvOi8vhXS9I6dkfDa1+DWrUyxS9WNLAPwO03fyv2ulc3Isfqm58ZKUpAi2vrFDfVlxikwQAdmzC5bgr5QUsxXDjcljQyzEMJFArR050MdeTiipqG0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706824064; c=relaxed/simple;
	bh=i8ei3/3iBku7zImBxqYUtsEsmTLhfHzH/Wx7NbUnqrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqcIN4hQmiMyp71pZqxmm5jIKRYLbEI+HgYwiO8XdmeP36OiSeUH7B4AiLQOKPlB86M7+ZixOuRO7Joq/3CJmq/laCF8nDANEeJs/atnT4NSJ1rs6ZcVz3WNnOPsluksGiJvQbsFpqmRaPGzWkXtkaaAxFI9WLaQ1N88D3dXOW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTMY2Q7T; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTMY2Q7T"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d934c8f8f7so13176035ad.2
        for <dm-devel@lists.linux.dev>; Thu, 01 Feb 2024 13:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706824062; x=1707428862; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vPELX+OiDIyvT/Bzm5WtNE+XaH+punLg9rt/elSB1q8=;
        b=gTMY2Q7T6xHZSq5VyUND9atyKTvJa6yKHatyluP5Y6SfwOHBCSyetCLUwgtkFzoeBH
         0qwDOCWru9I7GImwJq9+OFDb0zOikag8lvf+CINK7abdmaHaVFrLk81pGtbRxJGJiK0C
         F2/m+PSOLffGp2LjuFCCal6W6lHMHwC/CDxwpiGnhbI6PiizsNDGNGF0XybzUu3pOPYZ
         dJD3KwbrruSSULJD9pqrzxmY4iI6r//v9ZPY0wlQ7nOqaFlhv2bG/WaL2YQH1tO+un+Z
         okhjFxHHR+5xQAI7pQr8d4Os5Uv/POP63sDZwKhEm7k+1Z/3YlD6xgz1NBINQtbW7Eu6
         UiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706824062; x=1707428862;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vPELX+OiDIyvT/Bzm5WtNE+XaH+punLg9rt/elSB1q8=;
        b=E5m5JKojkSPpIH7X1i0GwGMblr2PjyPspxdBNpa/9/ANZ9r4VXAkqMvAbILYw+AEvB
         SpI+hrvnvOU9jk5XpvDPOjzL8rEVRPYF7Lldsm19Wg4iO/y/Wju4KZ5FxB8ZDkEAJqLo
         rmFxnEBt4hmZ72TSp2Xujz0KHYNRj+KhJaNrogxwgotPMXR/xadi+MxuzxdcbTeZmaJc
         QYEN4Bli7i6+DtN7fZthFYE8fCLHUxpVcecaY1PzFEndjgRlsqLumJoHzXUkg4wicj2K
         g0BHmXBNhz4XMLaMp0wTdhqzpJQYSXpQiM5KTI7vvQ1vfrlk8BEC1cBpjVQiZIKiNdRU
         2/5Q==
X-Gm-Message-State: AOJu0Yzvm30lbK/CR/VKgKJaBlbLLxpV3ulqyqS6fHSP14Lq+5cwHbU6
	zYdDEgeLgw1CZWCoN4YSFe9dl3q2S7DBsKBGpkzUwXjhE+SnC1mL
X-Google-Smtp-Source: AGHT+IFmOk7TPgqBwYIoA82SSiSOedzORPryco3JEl3jmuOGX1BvCgU9mm1bLtu2enwAk2GrAVN3tw==
X-Received: by 2002:a17:902:8602:b0:1d3:45c8:bc0f with SMTP id f2-20020a170902860200b001d345c8bc0fmr3418205plo.46.1706824061997;
        Thu, 01 Feb 2024 13:47:41 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXhQWjH/0bDIcgXc1KerryMZkSeZmS/dDISMhFwIRX2ML9fFJ2t6J3eiLURpm60C9TmPMfkaej25NFDYbHlhR4AuoXleb07R/6w8q9CFq4o5zZfu3we+5Jv6Gf0ul9Uqokb97GgA3tt7KWEGNm1209Gj0mMulTpjMwyGqR5t6lnHyAxRyVwDx4oFW2wn0gdjKVgNi1qpJ6IXUo8ApCiKn/t4iHKzEf1PUnAY8BHc0iaHiXcVgFZUGAxY8tLO1UH5fw4yjXV0QTmNeLm+vOLyPCs/kNFARJF+GuJbfz6Z1ZeyLDeIn76BJLPyXZopRo5aTdWhkU7ntqRVh2yAJaxuAkG7po9lNW3BA2mXYsHWAXh7hR2PP2+m0gkktHI1PeBT4U1VjYuABhqoKjPmP8M2hsmVTHSFfjGPnWQa5iXNvZ01cO0CigbAWZ2/BDLR4XfgsfvhIB219UIIlGik4jSLtFgzXIk
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id ji7-20020a170903324700b001d944bf2d83sm301249plb.7.2024.02.01.13.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 13:47:41 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 1 Feb 2024 11:47:40 -1000
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	msnitzer@redhat.com, ignat@cloudflare.com, damien.lemoal@wdc.com,
	bob.liu@oracle.com, houtao1@huawei.com, peterz@infradead.org,
	mingo@kernel.org, netdev@vger.kernel.org, allen.lkml@gmail.com,
	kernel-team@meta.com
Subject: Re: [PATCH 3/8] workqueue: Implement BH workqueues to eventually
 replace tasklets
Message-ID: <ZbwRfHCfss2THOeX@slm.duckdns.org>
References: <20240130091300.2968534-1-tj@kernel.org>
 <20240130091300.2968534-4-tj@kernel.org>
 <CAJhGHyCk_cjD-Ex_OAd=DrBkTEe0Xvs81=On65Sp7sS8zNBfGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJhGHyCk_cjD-Ex_OAd=DrBkTEe0Xvs81=On65Sp7sS8zNBfGQ@mail.gmail.com>

Hello, Lai.

On Thu, Feb 01, 2024 at 07:02:27PM +0800, Lai Jiangshan wrote:
> On Tue, Jan 30, 2024 at 5:16 PM Tejun Heo <tj@kernel.org> wrote:
> > @@ -1184,6 +1211,14 @@ static bool kick_pool(struct worker_pool *pool)
> >         if (!need_more_worker(pool) || !worker)
> >                 return false;
> >
> > +       if (pool->flags & POOL_BH) {
> > +               if (pool->attrs->nice == HIGHPRI_NICE_LEVEL)
> > +                       tasklet_hi_schedule(&worker->bh_tasklet);
> > +               else
> > +                       tasklet_schedule(&worker->bh_tasklet);
> > +               return true;
> > +       }
> 
> I think it is more straightforward to call bh_worker_taskletfn[_hi]()
> in tasklet_action() and tasklet_hi_action() rather than add a
> worker->bh_tasklet.
> 
> raise_softirq_irqoff() can be used here (kick_pool()) instead.
> 
> As the changelog said, once the conversion is complete, tasklet can be
> removed and BH workqueues can directly take over the tasklet softirqs,
> in which case, then, bh_worker_taskletfn[_hi]() can directly take over
> the tasklet_action() and tasklet_hi_action().

Hmmm.... maybe. Yeah, that'd also make it a tiny bit cheaper for hot paths.
Lemme see how that looks.

> I think wq->max_active can be forced to be UINT_MAX or ULONG_MAX
> in the max_active management code to avoid a branch here.

Good point. Will update.

> worker_attach_to_pool() and worker_detach_from_pool also access to
> worker->task with kthread_set_per_cpu() and luckily to_kthread()
> checks the NULL pointer for it.
> 
> IMO, it is better to avoid calling kthread_set_per_cpu() for bh workers.

Note that BH worker pools are always DISASSOCIATED, so
worker_attach_to_pool() shouldn't call kthread_set_per_cpu(). Also, BH
workers and worker pools are never destroyed, so worker_detach_from_pool()
shouldn't be called either. I'll add WARN_ONs to clarify.

> > @@ -5605,7 +5731,12 @@ static void pr_cont_pool_info(struct worker_pool *pool)
> >         pr_cont(" cpus=%*pbl", nr_cpumask_bits, pool->attrs->cpumask);
> >         if (pool->node != NUMA_NO_NODE)
> >                 pr_cont(" node=%d", pool->node);
> > -       pr_cont(" flags=0x%x nice=%d", pool->flags, pool->attrs->nice);
> > +       pr_cont(" flags=0x%x", pool->flags);
> > +       if (pool->flags & POOL_BH)
> > +               pr_cont(" bh%s",
> > +                       pool->attrs->nice == HIGHPRI_NICE_LEVEL ? "-hi" : "");
> > +       else
> > +               pr_cont(" nice=%d", pool->attrs->nice);
> 
> There are also some "worker->task" in show_pwq(), show_one_worker_pool(),
> and show_cpu_pool_hog() needing taking care of.

Ah, right, I'll hunt them down. 

Thanks.

-- 
tejun
