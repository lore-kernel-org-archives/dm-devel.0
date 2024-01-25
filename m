Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8664111700
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 22:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706223085; cv=none; b=Fjynoovxz+IvZNG7b2AttmlXqEIf9amQhVsjSFaPgJeEIkW47K7rs91ZWjC43eEvkcngdIxR/xNw05IhVFFNn1A9N5zz10HQt/o3jcdP54tzl4hcGlsJBMh+SzuEmsyELOWZD+NKfDFRvQHHKZv7mzFhFsP5aO51Al5YNqIVLrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706223085; c=relaxed/simple;
	bh=x+9cZFwfUUbXCSIUNvGOd+YWk7iUfd+WBM+Y4Bxq87g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c1cLnSS3Wa+0IBNMRCImNoT0N8sZT8651qjuhAJke6TZAPClWJ7mF8ydjfLRwMCkq7jqsWD3umdtp+PICVCdyfGc5FcggDlG4/VvSYGgzM88EvoK4nU5BJc3L6UwlP8fzrHzz8dHYXPuJ9d2PEULkjvO4nYAM9JKBo+K481rkTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=MUF2wSKF; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="MUF2wSKF"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-290b9f83037so963285a91.1
        for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 14:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1706223083; x=1706827883; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnJEKVw0k0WgdGsgQiun3uEEO1MzAZB4cFb7xewCZWo=;
        b=MUF2wSKFH9isIYZt0DEcfKnO4vny56K3/g4fLqYQqQ6YNq4Bteog/cJNCu8kSejVvY
         M82tambaHdF44c4gOJ0M7Udg3Nv5uhuhSdYI+9LXm9gdrz/bJksA2i1OW8FgbN+RLSYx
         E2FFkQ3z/LqaO5tn+dDm5pCYsT6+JTf3sGCXi+IBZ2WkYj+SaD96C1yaDBbPA7j3B0W4
         ALpj6A7/k6Vz7bgzHdzc53SbLJgxy3iXroJ9042ZGL/DRDLY7ZKEf5qiIEacgV7vFRdT
         SwZt+zl+ZbdgfEZcHyrktwzE1vu++4neo3TR3Jn4xGofvGhRAqT8rYnrDcD+in9hNE+n
         sLWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706223083; x=1706827883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MnJEKVw0k0WgdGsgQiun3uEEO1MzAZB4cFb7xewCZWo=;
        b=SRGhEy3JCfcdgEo+R1TiQs9dboByiyvtzvNwq1op47DVwPWrAFVZGfkwPUEGBA1Nqj
         4n0P87EdIx5SsT96D3z3qzOAykw6SP98JRJyr1VluH234rK6VHZbTnjPva5nbzPpsSig
         nFK3OGLP7u5GpwlkxvTLJW1vzFRiBihUEUsHZwKomjFfp6D+cnCuGWPGCUYr+hh4Dxho
         BwUr0qHaq9e4PnYBlUhjV0F+D49tCCyDaziJSHP4/NbmDizvH9/mAl7qS5kyq2HbV+8n
         iHMAWvtwZTh+bQ41Q9/ZEDJqc9xDdTo6ThlDMMJnBEiDOcRd0sMWl0Y3J+vsPs8/ggRe
         RjEw==
X-Gm-Message-State: AOJu0YzFkGf+5C+Q8hFv8eyz88ldmpVvUhr3NOKs5/W3sVeLhVJjS1nc
	kyOgzpVWTaMl8wtw+dT80PZxVTb9A6OlPDOt6XW8o0p4YLCFGtCbZrRKT87q91Vd5bm27LNty+B
	Ri/nUB4G+Jfr0e3k9V/SHuzIm5eQiXySOpkLnYQ==
X-Google-Smtp-Source: AGHT+IHTt2kfCDEIEqdQhaB1moHLVMHvs0ForCZoVTPtNM//1C1xaPtRtXtr7AubXLZ/EjIQvOS1P1z4QWqLRBNJjKQ=
X-Received: by 2002:a17:90b:4c04:b0:293:dfe6:6046 with SMTP id
 na4-20020a17090b4c0400b00293dfe66046mr35774pjb.8.1706223082705; Thu, 25 Jan
 2024 14:51:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com> <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
In-Reply-To: <CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 25 Jan 2024 22:51:11 +0000
Message-ID: <CALrw=nGHUJWhZvibb61r8wDgZ7eRCDU5-vv=uTouAZH90vUGWw@mail.gmail.com>
Subject: Re: [PATCH] softirq: fix memory corruption when freeing tasklet_struct
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Tejun Heo <tj@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	Mike Snitzer <msnitzer@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, 
	Bob Liu <bob.liu@oracle.com>, Hou Tao <houtao1@huawei.com>, 
	Nathan Huckleberry <nhuck@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 7:51=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, 25 Jan 2024 at 10:30, Mikulas Patocka <mpatocka@redhat.com> wrote=
:
> >
> > There's a problem with the tasklet API - there is no reliable way how t=
o
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

This is not great just considering the following context: the
tasklet/interrupt code was added, when we discovered dm-crypt most
likely processes read bios in interrupt context when using NVME
drives. So this would penalise the most desirable case for fast disk
encryption (decryption that is): systems use NVMEs mostly to get fast
IO, so they are the most sensitive to any latency introduced by
dm-crypt. For us it was a go/no-go: without this we might have
switched to dodgy proprietary self encrypting drives.

On the other hand this code never uses tasklets for slower media, but
they don't care and can use the default workqueue option in the first
place.

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
