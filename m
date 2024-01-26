Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186421E882
	for <dm-devel@lists.linux.dev>; Fri, 26 Jan 2024 18:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706294219; cv=none; b=ei1kFrASuhNkMo+SM5jeaygp2qPA5+Rw8RX5KtaKJwUz9BkiPENM+PGI61cCrdYrBHt7LDHSyiWS3w7kYYx5qgmZQ0SkdUPvJt1Zy/uuu5ks24Qw9TmeBHnLi6c10By9O8OzJ2WCjhppD/0eNtRW/CE+SkboLqI1aqDMbuNeqKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706294219; c=relaxed/simple;
	bh=XbBNz5Xjkbj/AigQvzkQA0KxKZPt6W9V1ChoC5N95fg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s165kd/iwAC6Pw03ou05LqcVcmN1WahEaiGT/8zDbMam+Z7veURyof1QPkdO7/N+tLxyAgyFp3olsoUTdrNj6NH+eF0h9Lysi4HqcMGX9JRPVBdEFoWiOnBDi/+6Se8u8x8HjP2wswkPYHeZMPAi/6ySAEdTc51+Rv37bTsc1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZHlHJbW; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZHlHJbW"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-7d2df857929so267513241.3
        for <dm-devel@lists.linux.dev>; Fri, 26 Jan 2024 10:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706294217; x=1706899017; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TqXd2LbuyI9Qqh/FQNpz2+SVm8Ny+cq215471CRHkUI=;
        b=cZHlHJbWsIC4qyby0s0ou0nz2SWe3SUcEQL4HEYRSzZpAgY/mp+04emy87InmN3nNt
         ayRLZ2R7RvLBHCtalmZADud8I/BRG9A1bVX9/ZS7J9gZhAVsBtL+PcTaQVgzopLJb00T
         54JD0VIJBzkDKJoSBFlo+6ecS9mDWAx+LDBkqsbvuczFqoQgqIcj5odv7nNrENvqlupZ
         TU7uKP4d8mT+7AbowJR2wCEiX1nCtc9/R8YOPm6Cjb4KFSTEJDjSUGn7IeG/FqtmUsZJ
         b9Yaz7Rxeu8qU+oBO/wcDzLnLsILhFrjD1Pa++AtRKbSwbljWq92Mk4gAAnUh9UFKX8H
         8quw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706294217; x=1706899017;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqXd2LbuyI9Qqh/FQNpz2+SVm8Ny+cq215471CRHkUI=;
        b=UgGBXXWJ4fqrQe9kCc/cc80RHcFyY8/1WpnIPne52xbBo5AMqlexbcM+tgmhvfaGWF
         +j1zinb7bSioP4sdPx3pBXZeoqkWvhU87XiQ6fwl5OWpzLUCBeFmp/XydbeliOL9kilh
         vyqSDBf9OO7LGixDiSFvsH5aSOKK/xLcLoZRDwu2r9RMfuKkn0fYc3PnpGxhyPSrcInj
         9GaSov7jS4mRPsGutOhiAqJKmBR4GWzCv9pbKVUUHNzVTrcWwAYyYrLQufMYWa/oue1C
         ttbauRGhst7Ky8F2YKUB1N2F8Pqopp4ra7x4zzSUbMSoeL3/S7FdmC5A/5kcPXklOMV4
         p3Ng==
X-Gm-Message-State: AOJu0Yw65vKAV+aLXjz6xZERJFg29KEevOF7zVmbgdFB8lcCVhXz2iVo
	mFNyx2v2lQAhTI/2AmLYxeQXHK2zqIZKp7n4BenUf/Akn0LFcxx6vCVmizl2OPylr8HxDFcBp7m
	xruebpEJfJKT1EkzmS54ST2OAoZw=
X-Google-Smtp-Source: AGHT+IE1MLjGKr2ux1azYw+58wmOiUvg8E5WXoQmTYbkOgivsJfz1JIsqBfE4B/XNtYEHyZgtl89a1r7kKpPcLkAmz0=
X-Received: by 2002:a05:6122:4c0f:b0:4b6:e383:5f with SMTP id
 ff15-20020a0561224c0f00b004b6e383005fmr235259vkb.25.1706294216914; Fri, 26
 Jan 2024 10:36:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com> <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
In-Reply-To: <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Fri, 26 Jan 2024 10:36:45 -0800
Message-ID: <CAOMdWSKu9PhyjfWga-eMcAUiBF4Fg9dnt+husNRZgkL1rp_HFQ@mail.gmail.com>
Subject: Re: [PATCH] softirq: fix memory corruption when freeing tasklet_struct
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	Mike Snitzer <msnitzer@redhat.com>, Ignat Korchagin <ignat@cloudflare.com>, 
	Damien Le Moal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, Hou Tao <houtao1@huawei.com>, 
	Nathan Huckleberry <nhuck@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"

> > There's a problem with the tasklet API - there is no reliable way how to
> > free a structure that contains tasklet_struct. The problem is that the
> > function tasklet_action_common calls task_unlock(t) after it called the
> > callback. If the callback does something that frees tasklet_struct,
> > task_unlock(t) would write into free memory.
>
> Ugh.
>
> I see what you're doing, but I have to say, I dislike this patch
> immensely. It feels like a serious misdesign that is then papered over
> with a hack.
>
> I'd much rather see us trying to move away from tasklets entirely in
> cases like this. Just say "you cannot do that".
>
 The idea of moving away from using tasklets has been discussed several times.
I am working on entirely moving away from using tasklets. Ofcourse, we have
some subsystems(like DMA), where we need to do a little more.

> In fact, of the two cases that want this new functionality, at least
> dm-verity already makes tasklets a conditional feature that isn't even
> enabled by default, and that was only introduced in the last couple of
> years.
>
> So I think dm-verity would be better off just removing tasklet use,
> and we should check whether there are better models for handling the
> latency issue.
>
> The dm-crypt.c case looks different, but similar. I'm not sure why it
> doesn't just use the workqueue for the "in interrupt" case. Like
> dm-verity, it already does have a workqueue option, and it's a
> setup-time option to say "don't use the workqueue for reads / writes".
> But it feels like the code should just say "tough luck, in interrupt
> context we *will* use workqueues".
>
> So honestly, both of the cases you bring up seem to be just BUGGY. The
> fix is not to extend tasklets to a new thing, the fix is to say "those
> two uses of tasklets were broken, and should go away".
>
> End result: I would suggest:
>
>  - just get rid of the actively buggy use of tasklets. It's not
> necessary in either case.
>
>  - look at introducing a "low-latency atomic workqueue" that looks
> *exactly* like a regular workqueue, but has the rule that it's per-cpu
> and functions on it cannot sleep
>
> because I think one common issue with workqueues - which are better
> designed than tasklets - is that scheduling latency.
>
> I think if we introduced a workqueue that worked more like a tasklet -
> in that it's run in softirq context - but doesn't have the interface
> mistakes of tasklets, a number of existing workqueue users might
> decide that that is exactly what they want.
>
> So we could have a per-cpu 'atomic_wq' that things can be scheduled
> on, and that runs from softirqs just like tasklets, and shares the
> workqueue queueing infrastructure but doesn't use the workqueue
> threads.
>
> Yes, the traditional use of workqueues is to be able to sleep and do
> things in process context, so that sounds a bit odd, but let's face
> it, we
>
>  (a) already have multiple classes of workqueues
>
>  (b) avoiding deep - and possibly recursive - stack depths is another
> reason people use workqueues
>
>  (c) avoiding interrupt context is a real concern, even if you don't
> want to sleep
>
> and I really *really* would like to get rid of tasklets entirely.
>
> They started as this very specific hardcoded softirq thing used by
> some drivers, and then the notion was generalized.
>
> And I think it was generalized badly, as shown by this example.
>
> I have added Tejun to the cc, so that he can throw his hands up in
> horror and say "Linus, you're crazy, your drug-fueled idea would be
> horrid because of Xyz".
>
> But *maybe* Tejun has been taking the same drugs I have, and goes
> "yeah, that would fit well".
>
> Tejun? Please tell me I'm not on some bad crack..
>
>                Linus
>
       - Allen
