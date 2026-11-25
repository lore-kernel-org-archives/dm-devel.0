Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795634233;
	b=AcHYG6H/dFIHFFVcPdh7deocAE+aXtAK+s5nI2UqBU+EL3ep1a8++O8YDyUKXdejWD7e
	 xTbJHcAa+1CipQ6NvyD5q2UtySh1TkmcOl6nONNQS5ceThz2u0poRxu/ZKiT3p3XUPo3y
	 133Aypba1gM40uLjjd8QAodRJy1UvOSLTl1l2K2AwwHAqjGv01UtnnNTzn7pWY/yHbhHv
	 H5gpsKl/JwBAMte3RrFdINMLhNNJGwNlXBsQbxiysnWNB68Vs6nSFxts5n9f9mo65z0XU
	 qPWIF6+WnRHNlWjUTZtz3eGj+6Jvl+gfUjF2u0vnCZBubyFEOCBqy5/kSYb8oqpCbJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795634233;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Transfer-Encoding;
	bh=6zdB/rQeLDq3D894FluXdu2Y35sjCX21XfyveRyDSBA=;
	b=4P4mmkc89bvsY3thoEbatEp1SnFcfOcUd+hRJ0JwQshxhoDAIklRgasRHVnwN8UrHfdv
	 3dIcxDOsvMTtlBVkasckI8OkIj/gMcI9MpjXOl3zO9cqRKK8dK2Od/Q0R6IDJtqRmiGfN
	 Lkc3E5FETqxC0Ocg72fLwLjbUdAG66bohFvYmxnP0Qo06P/gTFDMqtfKwfrQQI1DnlpZp
	 2DH8SpW0rMN3b/TVEy7RncTlBCbUy2F3m0n5zCERIi/A2cRbJx+ZdPLAbBoZam7xrazt6
	 dMk0CjLRknq+rvO1d08GnVWVV2Cy8anVZ+7A5ggei2HVP6+HS0AkiLigaJG7gMRg26Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Xdgf1B6I;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4AD606A326
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 19:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F4AD606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Xdgf1B6I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795634232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6zdB/rQeLDq3D894FluXdu2Y35sjCX21XfyveRyDSBA=;
	b=Xdgf1B6I4CtrtGl9jGctkH1PMDe8+8zU79EOK87tEO717JiWiYB9MtP8k45YDpM6PEYPEd
	SrJTZqJDck9LgL3fFr0OkG+6fQLEhtOWcnbbAxDL9ZlamvHCUj3MTk8qxXHga16AdT2F6S
	A+8FxQu1bOjAHRqs/Bhho+ZccNoWeA4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-_q6b0aJSNzGBDyhDNLeUrg-1; Wed, 25 Nov 2026 19:17:10 +0000
X-MC-Unique: _q6b0aJSNzGBDyhDNLeUrg-1
X-Mimecast-MFC-AGG-ID: _q6b0aJSNzGBDyhDNLeUrg_1795634229
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3ae4b12aa45so24968231fa.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 11:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795634228; x=1796239028;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6zdB/rQeLDq3D894FluXdu2Y35sjCX21XfyveRyDSBA=;
        b=KzvdaMY29kK7XZlur9K3QRwCu3WaxAHjXp57idWfrGmwOeq3zCf6Dp77jj2du4xH/t
         kyozSxh+N1IWGYO6K+oGSkq0KAtdcZMdoHnbD6DrzIYcw0muzMhhsSleDIO0CVlU4N0t
         6WV7flJamu4RpJlSZ7gu+5IsTt1Udqbfq8C2RB6y89xo42iYDkRLbhMV/GTWJAT1cE8R
         8DlVZTXOf6nbnlc+36lJNrcRi+F3N7LZ6s2E5z4a2jSRNs1e4Uvrm7tDbyBxP9UFssPs
         7/IJUu82PPGMQD+Ria0qCGn4dAhYgTGOg1Izvubnke42H9o+kKd/IWncRrcGKRiHCfcE
         gHsg==
X-Gm-Message-State: APuU4Z9Sf/ZzO2Y2aNoV7XHO1TA65a4zkZqdmv8cwwjO8rK6T9DZtyuo
	MStJq1nKSnwXuJ0I6mH3z5olM9LuuWcOSgEmIvKuJfYXXSQGpprCK2XvU5l7JOzo7L3qJQHH5kk
	FsBJNy1AD3aW0IdbRWSU7jKSUfuOxCsye2bNDYeTQRfC7dB5R1bPkGESaREffnqoyW+rZA20H+a
	QnxrJnZ0iniR5pO0yQDtYUmznOMyFEQEXOQXbaqa61fobuzFk=
X-Gm-Gg: AZFdTZc1dBvLh1a8AxFlbeyWfB+s6NqRM3EHE5Kvlq40iN7c7RlBd3LXSlzXHcv3oPD
	Q0OC8tenYDux6vTQXB+WySHk4JnYRdFfsTKgVqg0zgPnysmI9jKYqqmjBzRvSCTijNTk2rKC0Ei
	LvRQOqyUTfvQMDoGH7atjQuBpuSjmQ+GLR+H3uKX7GZh7mg99+vz0mXZ0JuxggAnZ/ger2wfXc1
	/B1IucwL5yFVHaTafjBRuatncbFzuSIufOQCIYMuGHzFMIF3ZBwDAK5fRLnEcAK4lSJo5EPjRc=
X-Received: by 2002:a05:6512:33ca:b0:5c1:57b6:5ffd with SMTP id 2adb3069b0e04-5c1bc552d9emr6331061e87.0.1795634228572;
        Wed, 25 Nov 2026 11:17:08 -0800 (PST)
X-Received: by 2002:a05:6512:33ca:b0:5c1:57b6:5ffd with SMTP id
 2adb3069b0e04-5c1bc552d9emr6331053e87.0.1795634228074; Wed, 25 Nov 2026
 11:17:08 -0800 (PST)
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev> <20261119-bug-dm-thin-rcu-gp-v3-2-c80ecc475e1e@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v3-2-c80ecc475e1e@linux.dev>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Thu, 26 Nov 2026 03:16:55 +0800
X-Gm-Features: Aa3M54pe6gUnH3xtgi3WUj1GWiGz9BVqRKh8waNkvHN9vH0Lj5E79L-u9RV6F0w
Message-ID: <CALjSBEtdn0PUx0WNsSDojK976JGg66ZqjEmUutuB-XwH1n=q4g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] dm thin: keep a thin on active_thins until its
 last reference is dropped
To: dm-devel@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org, 
	Qiliang Yuan <qiliang.yuan@linux.dev>, stable@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZK1EozoxFMS0LXRbfz9T3tEabCtHEgKFb87Uk5P1GM8_1795634229
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 7:12=E2=80=AFPM Qiliang Yuan <qiliang.yuan@linux.de=
v> wrote:
>
> get_first_thin() and get_next_thin() let the pool worker process the
> thins on pool->active_thins without holding rcu_read_lock() while it
> does: they take a reference on a thin under the lock, and
> get_next_thin() continues from that thin in a new read-side section.
> thin_dtr() takes the thin off the list, waits for a grace period and
> then for the references still held.
>
> Once thin_dtr() has removed a thin that the worker holds, nothing
> updates its list.next pointer any more. If the thin after it is removed
> and freed before the worker calls get_next_thin(), the walk continues
> from freed memory:
>
>   BUG: KASAN: slab-use-after-free in get_next_thin+0x8b/0x240 [dm_thin_po=
ol]
>   Write of size 4 at addr ff11000116371cc8 by task kworker/u128:0/13
>   Workqueue: dm-thin do_worker [dm_thin_pool]
>   Call Trace:
>    get_next_thin+0x8b/0x240 [dm_thin_pool]
>    process_deferred_bios+0x34/0x650 [dm_thin_pool]
>    do_worker+0x2b7/0x4f0 [dm_thin_pool]
>    process_one_work+0x8ce/0x1850
>    worker_thread+0x639/0x1190
>   Allocated by task 2290:
>    thin_ctr+0x130/0x1260 [dm_thin_pool]
>    dm_table_add_target+0x65f/0xf60 [dm_mod]
>    table_load+0x1c2/0x480 [dm_mod]
>   Freed by task 2391:
>    kfree+0x15d/0x550
>    thin_dtr+0x21c/0x2c0 [dm_thin_pool]
>    dm_table_destroy+0x13c/0x570 [dm_mod]
>    __dm_destroy+0x2eb/0x5d0 [dm_mod]
>    dev_remove+0x2f1/0x3c0 [dm_mod]
>
> Mark the thin as dying in thin_dtr() instead of removing it, and take it
> off the list only after the last reference is dropped, so that removing
> its neighbours keeps its list.next valid. Take references with
> refcount_inc_not_zero() and skip dying thins, so that thin_dtr() only
> waits for the references already taken, and have requeue_bios() and
> error_retry_list_with_code() skip dying thins as they skipped the thins
> already off the list.

The code looks correct to me. These notes are only for the record. The
two checks in thin_tryget() have different roles.

refcount_inc_not_zero() is what makes the patch correct. Once the
count reaches zero, no walker can take the thin again, so
list_del_rcu() is safe after wait_for_completion() returns.

The dying flag is only a hint. As Ben said, it is racy. It keeps the
old behavior of taking the thin off the list early, so thin_dtr()
mostly waits for the references already taken. For the ref-less
readers (requeue_bios() and error_retry_list_with_code()), the dying
check keeps most of them away, but their actual safety comes from the
synchronize_rcu() after list_del_rcu().

> With a test-only 3 s msleep() added to the worker after each thin it
> processes, thins 1 and 2 of a pool with three thins are suspended and
> then removed while the worker holds thin 1. Trials in which KASAN reports
> a slab-use-after-free in get_next_thin():
>
>                  before (trials)   after (trials)   change
>   KASAN report            3 of 3           0 of 5     -100%

Two thins are enough. Suspend both thins, let the worker sleep while
it holds thin 1, and then remove thin 1 and thin 2. When the worker
wakes up, get_next_thin() follows thin 1's stale list.next to the
freed thin 2:

    dmsetup suspend thin_1
    dmsetup suspend thin_2
    # make the worker sleep while it holds thin_1
    dmsetup remove thin_1 &    # thin_dtr() unlinks thin_1, then waits
    dmsetup remove thin_2      # thin_dtr() unlinks and frees thin_2

The suspend step is needed on kernels before v6.19. Before
be4addb1914f ("dm: Fix deadlock when reloading a multipath table"),
thin_postsuspend() always called noflush_work(), which queues a work
item on the ordered pool workqueue and waits for it. Removing an
active device runs the presuspend and postsuspend hooks, so the
removal waited until the worker returned. By then the worker had
dropped thin 1, so the bug did not trigger. A suspended device skips
the hooks on removal and goes straight to thin_dtr().

The walkers in pool_suspend_active_thins() and
pool_resume_active_thins() hit the same bug. To reproduce it there,
put the sleep in those walkers instead. It then runs in the dmsetup
process, not on the pool workqueue, so the suspend step is not needed.

> Fixes: 17181fb7a0c3 ("dm thin: fix a race in thin_dtr")
> Cc: stable@vger.kernel.org
> Reported-by: Benjamin Marzinski <bmarzins@redhat.com>
> Closes: https://lore.kernel.org/r/avz7qDWd2g-uubmL@redhat.com
> Co-developed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>

