Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE94355F35
	for <dm-devel@lists.linux.dev>; Thu, 27 Aug 2026 08:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787819799; cv=none; b=Vr3Ql92y5fGRpZ3KzpDqxFr3IynNcAcCCR/4KydzoOQd0q6P6k0gjegDiyuJmYT13CppjWsDLHnRuaY2ou79LDTgz2Pl5hkoWn9xAD2cKlVilgk36wK3PSFrzgNKA3jIcAVPn9XOU+bnrbH8xwTysQ7F6DOiBfHn4gKBOs3LWQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787819799; c=relaxed/simple;
	bh=twgHFJelQC1ATyt9cXs+8juc4xjU96MVObHtsYjaIPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ceI4xSLXSgyq/5rMjrR+mOU3zipUEpkdStqWRArGjb4q1/t4n9eLGM97ZbHi3HZH2zHjRsb+iQv365TVEAZCWPFI2bX6vUMzK2brCren1/xk07AnRJihOeqPMcsoO9S6VYI/LS7p2en6eyZovTrAQPbxg1uiSnlQE7A1Tnb1NvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/d16PRV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/d16PRV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787819796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t1Z8sC2WGVSF637BSSwMK+oLVjJ7Fv4YC1mjPOauHEg=;
	b=P/d16PRVzmdlga3wiIEdvo+kGs2Uexat/6eNhDVtX7C9WdgXpMvmqBB1a3IqYxdQZEoYDL
	hB4rbZc6Jhvm/4SYagHcEKVQ/GR+GF2kt/pnucz9Od6xdJTz76M6PipBivHtNgWvaLc3oN
	tTQiykC+v/VCFVTt1a3tSXRXMXV00r0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-hI_c7_zVOw6yV-a5mtJrHw-1; Thu, 27 Aug 2026 04:36:33 -0400
X-MC-Unique: hI_c7_zVOw6yV-a5mtJrHw-1
X-Mimecast-MFC-AGG-ID: hI_c7_zVOw6yV-a5mtJrHw_1787819792
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a27d89a894so2205831fa.3
        for <dm-devel@lists.linux.dev>; Thu, 27 Aug 2026 01:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787819792; x=1788424592;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1Z8sC2WGVSF637BSSwMK+oLVjJ7Fv4YC1mjPOauHEg=;
        b=Rt/WakHODdXUKiqlGZL73TWI0CVOXFOPfOj8qT5Tw+mgLhuKRCA8LG0FUyAonIgQh5
         WpJ84JLtMOo+no+ZJ99xkvvTXg2ZaqYngQe0Rj07pfbyJYBuLgua5iZufRrzZd+Hcty/
         F8fAkW9RWTWkUiySAUoBNQLIsAmZ5zzBQu9OeHyMmyKVnQYk0QJBbydGeFDmY7qhNO4o
         KlEI76bX6d6B3KUXxmp6t6B69vorxQmygo4hQhDIDV73F9tJU7qQd0tt2+VVJuaFNUAb
         5FxZNaE6Foj6I/pm5dYQj7fTDc6NccI9s5m+DbhrwGxiD+8dGQR58BMIpeAW3Ch0xxt+
         qtaw==
X-Forwarded-Encrypted: i=1; AHgh+RpU5TWJVJhFAdsPJKOpL/V3GCQgwgZZd9Njvud61EZtR9HrwCHY/FEPohZ7uE40xlkC42tIbT1kKA==@lists.linux.dev
X-Gm-Message-State: AFuF++kNJSNNP+Ox5ewWHb9jCt/8S0OWLSHo1yJD1ovGvI3H1480wYcf
	uUJDKiYlQ+l6/SACFCMENUXbZahuN0dbb+O+YQx3+6L+XLJkkm+CuQeAfUdN1PVl6G2EPqPbOcq
	OZzVrRa7l+DSEDPca5g64GlGgxXELkN1g02FpH3njcf2aiTpSOHXGH1R6nUZFVc2lmxSnqCV2V4
	Z9OQOXu31jfsN0nSjZjsDJkLErBB5386K/Ug==
X-Gm-Gg: AR+sD13x20Mjpf77aWgN+oCVG9R4vm17+HztYS/wqGdLFUuA9HxfiAuqYEBXGhZOIBm
	3N+Avjl0SaBjn2TYIYHq8qJ3vN0V8QiXcCmKEzrGKj/2g5PNtNdcV2gl4EQM9Zz0UDhmytx6zbJ
	UWMtsBneoFeW7UpKvz3FiY/OihgvDJH2cK3ZqrGyHFWgu5Yajhn9qxECY=
X-Received: by 2002:a05:651c:31c4:b0:3a1:93cb:fa44 with SMTP id 38308e7fff4ca-3a1fd660d67mr33803691fa.10.1787819792180;
        Thu, 27 Aug 2026 01:36:32 -0700 (PDT)
X-Received: by 2002:a05:651c:31c4:b0:3a1:93cb:fa44 with SMTP id
 38308e7fff4ca-3a1fd660d67mr33803551fa.10.1787819791759; Thu, 27 Aug 2026
 01:36:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825192226.4191036-1-bmarzins@redhat.com>
In-Reply-To: <20260825192226.4191036-1-bmarzins@redhat.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Thu, 27 Aug 2026 16:36:19 +0800
X-Gm-Features: AcwNN1Xvy-cXzQBBywpinVAWjaRMthg0BrHkm-ZR3X6ZQHdPz15PeUE4UTXj8Zo
Message-ID: <CALjSBEv9piEcLBxbDT_6YZPkkp-Um62DhJpAhL+VhPGeHz7MoA@mail.gmail.com>
Subject: Re: [PATCH] dm cache: fix issue with background work locking
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pgljz5B91wCQIs-msW2vaAggrz19vwMO4D7JCswSsTU_1787819792
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 3:22=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> dm cache used a rw_semaphore for background_work_lock. Write locks on
> rw_semaphores have strict owner semantics, but there was no guarantee
> that the process that locked background_work_lock was the same process
> that unlocked it. This can be easily seen using a kernel compiled with
> CONFIG_DEBUG_RWSEMS. Given a dm cache device <cache>, run: 'dmsetup
> suspend <cache> && dmsetup resume <cache>'. This will tigger a kernel
> warning:
>
> DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) !=3D current) && !rwsem_test_oflag=
s(sem, RWSEM_NONSPINNABLE))
>
> triggered by cache_resume(). To fix this, switch from a rw_semaphore to
> a spinlock and a wait queue. dm cache already hasd a wait queue and
> associated counter, migration_wait and nr_allocated_migrations, that was
> getting woken up when background work was getting completed, but wasn't
> actually used by anything. This is replaced by the background_work queue
> and counter.
>
> Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-pri=
son-v2")
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---

Thanks Ben. I confirmed the patch fixed it.

Just one minor nit: checkpatch prefers 'unsigned int' for background_work_n=
r.

Worth noting before the commit b29d4986d0da ("dm cache: significant
rework to leverage dm-bio-prison-v2"), dm cache waited for migrations
via wait_for_migrations(), which did a wait_event() on migration_wait
and nr_allocated_migrations. That commit replaced it with
rw_semaphores and used lockdep_off() to suppress warnings, before
DEBUG_RWSEMS existed.

Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>

>  drivers/md/dm-cache-target.c | 55 ++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 33dbc71b730f..d8d9c63d2a67 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -340,8 +340,6 @@ struct cache {
>         struct list_head invalidation_requests;
>
>         sector_t migration_threshold;
> -       wait_queue_head_t migration_wait;
> -       atomic_t nr_allocated_migrations;
>
>         /*
>          * The number of in flight migrations that are performing
> @@ -397,7 +395,11 @@ struct cache {
>         bool loaded_mappings:1;
>         bool loaded_discards:1;
>
> -       struct rw_semaphore background_work_lock;
> +       /* background work management */
> +       bool background_work_allowed;
> +       unsigned background_work_nr;
> +       spinlock_t background_work_lock;
> +       wait_queue_head_t background_work_wait;
>
>         struct batcher committer;
>         struct work_struct commit_ws;
> @@ -488,19 +490,13 @@ static struct dm_cache_migration *alloc_migration(s=
truct cache *cache)
>         memset(mg, 0, sizeof(*mg));
>
>         mg->cache =3D cache;
> -       atomic_inc(&cache->nr_allocated_migrations);
>
>         return mg;
>  }
>
>  static void free_migration(struct dm_cache_migration *mg)
>  {
> -       struct cache *cache =3D mg->cache;
> -
> -       if (atomic_dec_and_test(&cache->nr_allocated_migrations))
> -               wake_up(&cache->migration_wait);
> -
> -       mempool_free(mg, &cache->migration_pool);
> +       mempool_free(mg, &mg->cache->migration_pool);
>  }
>
>  /*----------------------------------------------------------------*/
> @@ -1030,34 +1026,39 @@ static void calc_discard_block_range(struct cache=
 *cache, struct bio *bio,
>
>  static void prevent_background_work(struct cache *cache)
>  {
> -       lockdep_off();
> -       down_write(&cache->background_work_lock);
> -       lockdep_on();
> +       spin_lock_irq(&cache->background_work_lock);
> +       cache->background_work_allowed =3D false;
> +       wait_event_lock_irq(cache->background_work_wait,
> +                           cache->background_work_nr =3D=3D 0,
> +                           cache->background_work_lock);
> +       spin_unlock_irq(&cache->background_work_lock);
>  }
>
>  static void allow_background_work(struct cache *cache)
>  {
> -       lockdep_off();
> -       up_write(&cache->background_work_lock);
> -       lockdep_on();
> +       spin_lock_irq(&cache->background_work_lock);
> +       cache->background_work_allowed =3D true;
> +       spin_unlock_irq(&cache->background_work_lock);
>  }
>
>  static bool background_work_begin(struct cache *cache)
>  {
>         bool r;
>
> -       lockdep_off();
> -       r =3D down_read_trylock(&cache->background_work_lock);
> -       lockdep_on();
> -
> +       spin_lock_irq(&cache->background_work_lock);
> +       r =3D cache->background_work_allowed;
> +       if (r)
> +               cache->background_work_nr++;
> +       spin_unlock_irq(&cache->background_work_lock);
>         return r;
>  }
>
>  static void background_work_end(struct cache *cache)
>  {
> -       lockdep_off();
> -       up_read(&cache->background_work_lock);
> -       lockdep_on();
> +       spin_lock_irq(&cache->background_work_lock);
> +       if (--cache->background_work_nr =3D=3D 0)
> +               wake_up(&cache->background_work_wait);
> +       spin_unlock_irq(&cache->background_work_lock);
>  }
>
>  /*----------------------------------------------------------------*/
> @@ -2507,9 +2508,7 @@ static int cache_create(struct cache_args *ca, stru=
ct cache **result)
>
>         spin_lock_init(&cache->lock);
>         bio_list_init(&cache->deferred_bios);
> -       atomic_set(&cache->nr_allocated_migrations, 0);
>         atomic_set(&cache->nr_io_migrations, 0);
> -       init_waitqueue_head(&cache->migration_wait);
>
>         r =3D -ENOMEM;
>         atomic_set(&cache->nr_dirty, 0);
> @@ -2592,8 +2591,10 @@ static int cache_create(struct cache_args *ca, str=
uct cache **result)
>                      issue_op, cache, cache->wq);
>         dm_iot_init(&cache->tracker);
>
> -       init_rwsem(&cache->background_work_lock);
> -       prevent_background_work(cache);
> +       init_waitqueue_head(&cache->background_work_wait);
> +       spin_lock_init(&cache->background_work_lock);
> +       cache->background_work_allowed =3D false;
> +       cache->background_work_nr =3D 0;
>
>         *result =3D cache;
>         return 0;
> --
> 2.53.0
>

