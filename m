Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B2879943
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 23:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706657868; cv=none; b=fO077TYd6AkTLmngVwVnJbBuw6uFdDXufnGlpZjeCBvq8KBuPSlHhElmboqGzWivXIkGiLxJYsTyZgG46kZ9L1UXLMxMig5iIH9mvky6AOCy+JVCn11lHnePdSGp8k1OpmPcGjAehDkTZ3NjF5UlnxV8QGL+aH9J3cNux/YFlzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706657868; c=relaxed/simple;
	bh=5d0Rdm3ZZCAJql7eb29HYdgGbUh6X6aK/alnR6Wd/TQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A51asJ/pa8Ro3zoApHFeij71kHPJJgYNzOZpSr+HrY9EUIWevQ2Iq1dmNIz4Gzu0fAZSXulHL32iJ5AB4PLvdvMnn2Fwy+ajoWrkvTV2GmCwWmqf3+BynarsgBptbzvr8UM1w0SZLUISEVYZiaA42Z1fLHckEdSH+E240oMo6y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cy0TK6K6; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cy0TK6K6"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7d5bbbe5844so1126121241.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 15:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706657866; x=1707262666; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UlC58ozOMYV/8+rov/khdBbDz0WwZoFrGbm9VuvZG7Y=;
        b=cy0TK6K60SdFjtTzR23GtAAr4K8i5Gu9BlBu6BEa1yOJpxahaqZv33jrCWQwts5vGI
         BiU3ONZkpvr8YjMkGy97w8GeqMDlYmH77hLY+q8qLOX77kRMF29ifP/QZl6wCtK9Po++
         pkEa945XLL/g85pSQC8fFQYZqM2dns4aoC39yFcgG0Kkoo5rfqkV9auN3nmedcFWp73Y
         pdc6BFTOTAscuabIMDLoq8SMtdeBQjMQh5z73Oh/O8jX2JmimvAdKfOQLzKJlE0gx+aK
         pbE1LkSvbG/OnoWBsuaVKlaTpxaunH3MFo/tf6+lzMD89fF8w40ev4C5YEQyiEGwq4FZ
         /VWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706657866; x=1707262666;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UlC58ozOMYV/8+rov/khdBbDz0WwZoFrGbm9VuvZG7Y=;
        b=wAvOmX+SK5PY2+PRlj8E2LkM019waE7/naAqxisVrRxGQdpSp/EM5r6QLxkbdep2Ah
         mhAKsmQiFg7tF/XX9ENwjBomfAqz2n0cxZsYyehcBF3/yZfVb6OPxfK779tf6uo99c6t
         rFv7R6B5JHnotqEB+1TKXrvTs78wIFkfyCZQoLzUCVVlM9nxzuiL3brlpGtlAl5Iemv6
         55JcqHD7y/ST4+YD9EBMMEVMsKuCvDh3YakxjS1Jrmz0tLXFPnXOPIjlDjHUkVRMXk4Q
         1gT3yHp/qtvZaML3Mq2+t9Gn99DuKT5Pu488ILjNVKAS8GP55gJA/k04LWTLxtwVxeO0
         fEvg==
X-Gm-Message-State: AOJu0YwQ3uD6iYPGe8AVhs8AvfDvY+hZff6hMDXn/1im15gbK4VCGT/a
	2hdbafqb/FQHFIKS1FGd79xfXHaqH6omHJo0BskcnovzyEcHHw9Phqmsd/YsKNKFK3dZnngbIhm
	CpnM+JOceCZ1HfZbMFKxec94Aih0=
X-Google-Smtp-Source: AGHT+IGyFCYK1juTehlFYSxnULd+i/m2IB7EGF0N0kW1HZsR3FGAWDKIq3BMMu0yyNYeF87k80TYBNDzaCHdOQYU540=
X-Received: by 2002:a05:6122:3903:b0:4b7:2940:8fa2 with SMTP id
 ep3-20020a056122390300b004b729408fa2mr5295982vkb.12.1706657865767; Tue, 30
 Jan 2024 15:37:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org>
In-Reply-To: <20240130091300.2968534-1-tj@kernel.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 30 Jan 2024 15:37:34 -0800
Message-ID: <CAOMdWSJxQ4trkFeEtL1549kgnxmTN1ikWYH7r6bdD40FxbuNpw@mail.gmail.com>
Subject: Re: [PATCHSET wq/for-6.9] workqueue: Implement BH workqueue and
 convert several tasklet users
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

> The only generic interface to execute asynchronously in the BH context is
> tasklet; however, it's marked deprecated and has some design flaws such as
> the execution code accessing the tasklet item after the execution is
> complete which can lead to subtle use-after-free in certain usage scenarios
> and less-developed flush and cancel mechanisms.
>
> Mikulas Patocka recently reported that dm-crypt and dm-crypt are affected by
> the access-after-completion issue and suggested adding TASKLET_STATE_ONESHOT
> flag which selectively removes post-completion access while significantly
> limiting how the tasklet can be used in the following thread:
>
>  http://lkml.kernel.org/r/82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com
>
> Linus didn't like the approach and suggested extending workqueue to support
> execution from atomic context:
>
>  http://lkml.kernel.org/r/CAHk-=wjDW53w4-YcSmgKC5RruiRLHmJ1sXeYdp_ZgVoBw=5byA@mail.gmail.com
>
> As suggested, this patchset implements BH workqueues which are like regular
> workqueues but executes work items in the BH (softirq) context and converts
> several tasklet users.
>
> - The name bh is used instead of the suggested atomic as it's more in line
>   with widely used execution context interface - local_bh_enable/disable()
>   and friends.
>
> - The system default BH workqueues - system_bh_wq and system_bh_highpri_wq -
>   are provided. As queue-wide flushing doesn't exist in tasklet, all
>   existing tasklet users should be able to use the system BH workqueues
>   without creating their own.
>
> - BH workqueues currently use tasklet to run the work items to avoid
>   priority inversions involving tasklet_hi and WQ_BH | WQ_HIGHPRI. Once all
>   tasklet users are converted, tasklet code can be removed and BH workqueues
>   can take over its softirqs.
>
> This patchset is on top of wq/for-6.9 (aae17ebb53c ("workqueue: Avoid using
> isolated cpus' timers on queue_delayed_work")) and contains the following
> eight patches.
>
>  0001-workqueue-Update-lock-debugging-code.patch
>  0002-workqueue-Factor-out-init_cpu_worker_pool.patch
>  0003-workqueue-Implement-BH-workqueues-to-eventually-repl.patch
>  0004-backtracetest-Convert-from-tasklet-to-BH-workqueue.patch
>  0005-usb-core-hcd-Convert-from-tasklet-to-BH-workqueue.patch
>  0006-net-tcp-tsq-Convert-from-tasklet-to-BH-workqueue.patch
>  0007-dm-crypt-Convert-from-tasklet-to-BH-workqueue.patch
>  0008-dm-verity-Convert-from-tasklet-to-BH-workqueue.patch
>
> 0001-0003 prepare and implement BH workqueues.
>
> 0004-0008 convert some tasklet users to BH workqueue. The conversions are
> relatively straightforward but are in descending order of confidence.
>
> The patchset is also available in the following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git wq-bh-v1
>

 Thank you for doing this work.

Tested the series, things look good. I am going to run LTP and Unixbench
on the kernel.

Tested-by: Allen Pais <allen.lkml@gmail.com>

Thanks.

> diffstat follows. Thanks.
>
>  Documentation/core-api/workqueue.rst |   29 ++++-
>  drivers/md/dm-crypt.c                |   36 -------
>  drivers/md/dm-verity-target.c        |    8 -
>  drivers/md/dm-verity.h               |    2
>  drivers/usb/core/hcd.c               |   23 ++--
>  include/linux/usb/hcd.h              |    2
>  include/linux/workqueue.h            |    9 +
>  include/net/tcp.h                    |    2
>  kernel/backtracetest.c               |   18 +--
>  kernel/workqueue.c                   |  312 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
>  kernel/workqueue_internal.h          |    3
>  net/ipv4/tcp.c                       |    2
>  net/ipv4/tcp_output.c                |   36 +++----
>  tools/workqueue/wq_dump.py           |   11 +-
>  14 files changed, 335 insertions(+), 158 deletions(-)
>
> --
> tejun



-- 
       - Allen
