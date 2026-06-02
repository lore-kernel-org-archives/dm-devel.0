Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E70E3D75A2
	for <dm-devel@lists.linux.dev>; Tue,  2 Jun 2026 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780397368; cv=none; b=JQOaxaL1mGA1py7/6Z10SgZ3DOvyd5xy/Pa6PZvbBEkhFh0okNvpLsd7e7Wa5FrWk/kij2mLE6tCysvdIlEpPwI+6iTSSAa7usQG/USQ7ZRAdy/Uw+Y94hWaRbjXQF+rM9JiWX4E0I95iM14wfx6Kd42tZlse7TN/aSRxzF0q5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780397368; c=relaxed/simple;
	bh=cPlcK7s77UCA5uBvKvkVM4xX6psC2kgeLoZ1b4Opzbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O8oZFLdFCjoK2llhtRs3IYVv6NtpIulxhgi3yEsMPDtFaZf6qsz4chxFouAVVVsu73qYn5NWv/zIDDGH4B0ybxQ3x1FHgFFqPjh/KxlxxIIcWNSuXS5IYLGgL1JO+UjxTTqO3M1QF8u1UCThiwXHff0gQ991ZzVsDYsda4uGOKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZsNlz4rS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZsNlz4rS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780397365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M1jZiyctYxsw2aPqUi8NMskjSV7qdIkJsbNzL2T4y2M=;
	b=ZsNlz4rS8SHkzn3800vipCo3VWupvcZyiwjANsnY7nzeYqxWhQtfNBsIa9Q66ZNTr3MHQV
	DjEYwxcd4z6/+0n4RvCOOaqxy1X0APn6fV/tKncCw8jN/K8QLblL+pBc27EWuQ4kEboBcw
	12+yasiTwvX6HAIO9NdUDoNN6fbdvgI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-GfEYS5khPzmJ3Z4kaCmmbQ-1; Tue, 02 Jun 2026 06:49:23 -0400
X-MC-Unique: GfEYS5khPzmJ3Z4kaCmmbQ-1
X-Mimecast-MFC-AGG-ID: GfEYS5khPzmJ3Z4kaCmmbQ_1780397362
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-39677266bd9so16453381fa.2
        for <dm-devel@lists.linux.dev>; Tue, 02 Jun 2026 03:49:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780397362; x=1781002162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M1jZiyctYxsw2aPqUi8NMskjSV7qdIkJsbNzL2T4y2M=;
        b=WwnGGod+6AAbv15ir45uZ2az+aTZgYCcjmfbpMngo1YJJ/MC0vKqdalwmlCDchhE6L
         mHglXOxXozZh68HZjyY7j9NwH0ypumqn0WTO1Qt72jHUWAFD88jGJZ/MvUKRtoXyOJ0u
         BDzMQEFEiutTPwtloEbadhjiSzuhaOGEoj5W2FtVYyGrhOZV4SCoxQPSQtLgRYV3U+Db
         Sc4xtTG6g6PYM2rfsjWgMtsc3vwpG/+I8AdItb9NTsMvNgB7c7k2OLZd/jt1YMZ48jmw
         w+Qy9sCaovGwzS2oae5h3HYR8qqKDg+/8MplpSRGIgQFP7VIUJTw6t6avyLKHCqdckPq
         b1Vg==
X-Gm-Message-State: AOJu0YwHOCR2p0xT0CcLQvcfrGXHPNwPe0lQCeh+Dg8SBilCVCmQZB2S
	aiMKww5TgnWWYQfgH9k6hQT0y0Sa/iriOaaUiOseTQytr6AyJ+QtGz4BqIJWhjJUCVRMksgJ4sy
	Pz8PyuN6o+4ZhqHsa7oGE3X2gnISE9tDWPu4SVlqQ8Ps3SmApEJjS0/Sm/ZVc6oqXmkwcKo/OuI
	ziHtc4xAD4Oa6+JRXKmgJu7IvGUiW10ZGMOyq7NJNKGdIT
X-Gm-Gg: Acq92OGSK6qDPEU2EVoB9CrlN+pcu7/DlvM9JPr8xul0vIE8dWSuJp0f7hB/H5DaP0n
	E28Rejf1Ywqpqq8jr9qMNu0l+vFcRhWfWvRvJS5yKnEnGWNmBZD8DFNhx+EXe/B3fjxXa0eDVYU
	YyU6dBKobAZFwoidS+yB3HIb8vgiFPYDqWGhWgtCRssBhmfHnpRqTHYHR6H7P5JIDUmMHcPIE7e
	6kIzM5sN6IFTWU=
X-Received: by 2002:a2e:a90f:0:b0:396:892a:7392 with SMTP id 38308e7fff4ca-396892a75c4mr24601111fa.29.1780397362234;
        Tue, 02 Jun 2026 03:49:22 -0700 (PDT)
X-Received: by 2002:a2e:a90f:0:b0:396:892a:7392 with SMTP id
 38308e7fff4ca-396892a75c4mr24600961fa.29.1780397361722; Tue, 02 Jun 2026
 03:49:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260529155745.1292113-1-lgs201920130244@gmail.com>
In-Reply-To: <20260529155745.1292113-1-lgs201920130244@gmail.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Tue, 2 Jun 2026 18:49:10 +0800
X-Gm-Features: AVHnY4IPs7KdQEdxq4VB9FB53TIhUya2gZ5AhFlckTCenguwyUcueFBgEaSehFM
Message-ID: <CALjSBEuom-tycJtndwYwHTPVOMLRSAXrZOF4+cvhje3y4Pgk2Q@mail.gmail.com>
Subject: Re: [PATCH] dm cache policy smq: check allocation under invalidate lock
To: dm-devel@lists.linux.dev, Guangshuo Li <lgs201920130244@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2EQJBAphwr_Oggi7EVjQMWSODBUa4dzvce5sp1H6Q9U_1780397362
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 30, 2026 at 12:00=E2=80=AFAM Guangshuo Li <lgs201920130244@gmai=
l.com> wrote:
>
> commit 2d1f7b65f5de ("dm cache policy smq: fix missing locks in
> invalidating cache blocks") added mq->lock around the destructive part of
> smq_invalidate_mapping(), but left the e->allocated check outside the
> critical section.
>
> That leaves a check-then-act race. Two concurrent invalidators can both
> observe e->allocated as true before either of them takes mq->lock. The
> first invalidator that acquires the lock removes the entry from the
> queues and hash table and then calls free_entry(), which clears
> e->allocated and puts the entry back on the free list. The second
> invalidator can then acquire mq->lock and continue with the stale result
> of the unlocked check.
>
> This can corrupt the SMQ queues or hash table by deleting an entry that
> is no longer on those structures. It can also hit the allocation check in
> free_entry() when the same entry is freed again.
>
> Move the allocation check under mq->lock so the predicate and the
> destructive operations are serialized by the same lock.
>
> Fixes: 2d1f7b65f5de ("dm cache policy smq: fix missing locks in invalidat=
ing cache blocks")
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>  drivers/md/dm-cache-policy-smq.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-polic=
y-smq.c
> index dd77a93fd68d..1ae304c2f573 100644
> --- a/drivers/md/dm-cache-policy-smq.c
> +++ b/drivers/md/dm-cache-policy-smq.c
> @@ -1590,18 +1590,22 @@ static int smq_invalidate_mapping(struct dm_cache=
_policy *p, dm_cblock_t cblock)
>         struct smq_policy *mq =3D to_smq_policy(p);
>         struct entry *e =3D get_entry(&mq->cache_alloc, from_cblock(cbloc=
k));
>         unsigned long flags;
> -
> -       if (!e->allocated)
> -               return -ENODATA;
> +       int r =3D 0;
>
>         spin_lock_irqsave(&mq->lock, flags);
> +       if (!e->allocated) {
> +               r =3D -ENODATA;
> +               goto out;
> +       }
>         // FIXME: what if this block has pending background work?
>         del_queue(mq, e);
>         h_remove(&mq->table, e);
>         free_entry(&mq->cache_alloc, e);
> +
> +out:
>         spin_unlock_irqrestore(&mq->lock, flags);
>
> -       return 0;
> +       return r;
>  }
>
>  static uint32_t smq_get_hint(struct dm_cache_policy *p, dm_cblock_t cblo=
ck)
> --
> 2.43.0
>

Thanks for the fix. While my previous commit addressed the race
between concurrent workers, it doesn't cover the invalidate_cblocks
message path, where the race between the message and write
invalidation wasn't solved. Moving the allocation check under the lock
is the right fix for the remaining gap.

I've verified the bug is reproducible. By running a passthrough write
and a dmsetup message simultaneously, the check-then-act race on
e->allocated leads to a double free of the cache entry, hitting the
BUG_ON in free_entry() on the second call. The patch fixes it as
expected. On the other hand, the write path itself is safe: the prison
cell serialization prevents two workers from invalidating a cache
block simultaneously.

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

