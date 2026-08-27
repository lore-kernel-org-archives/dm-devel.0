Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4119441A547
	for <dm-devel@lists.linux.dev>; Thu, 27 Aug 2026 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787830015; cv=none; b=EqTam8YEpWOOcOIKV//+aEI5HLTqBGvP1jyCVql7T7dx4eQkYpDDe+mP2jHCPBJ9SmeHfhHfPdldZKm0psEC3RWBDdmd3/O8VtRidybc1i+bZIqOSFDhKhCFlLunS+hupQJvhD4QETzFFeb1CtmK2RcROPLdsTf5Xj4p7vuZj1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787830015; c=relaxed/simple;
	bh=DOytka88CkeHk58tpDxH3++C+aNYb2Z7nh+vodT+Ufs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iQn/bGsoaRrHV6diAPu1QnogOfPSUC5/12ENJ+dPFwE/pIBwUfnz9EgEzh+0/XDttpQ0mY2TKNz/oUkdx1FwOxq+z36ztS4XjFveSkSb2p1yQgTwm0YsyVkt/gflJnTY7uYnH2gINR8+xyKruxx9a8uTdzc1I0QQuJXi06RvU4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U47HORaa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U47HORaa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787830011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ud0SWGWQmZJ9XgH3i6V0GXHekL/Kt3MhAtzvAF66CZI=;
	b=U47HORaapc8TJA9m2wf3qUZgG/ibxz20+nK/3HTS+u/ZJ4s8HyIZ0H+upRZH4qyIaMsTT0
	7qPVbfzM9Q+7Xkdx7HaMUECwXl9i6hJ6afPCBJuvfPrhEnaUr9QjY8LI+E+SLqyhx8GL7e
	n3icmnXoHkSo+f7eQH7uBitJ2W35Hh8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-ixZ7YA2dNlylR1Ofgng5AA-1; Thu,
 27 Aug 2026 07:26:50 -0400
X-MC-Unique: ixZ7YA2dNlylR1Ofgng5AA-1
X-Mimecast-MFC-AGG-ID: ixZ7YA2dNlylR1Ofgng5AA_1787830008
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA98619540D9;
	Thu, 27 Aug 2026 11:26:48 +0000 (UTC)
Received: from [10.44.48.209] (unknown [10.44.48.209])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04B0C18001C7;
	Thu, 27 Aug 2026 11:26:46 +0000 (UTC)
Date: Thu, 27 Aug 2026 13:26:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Hung Tsai <mtsai@redhat.com>
cc: Benjamin Marzinski <bmarzins@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm cache: fix issue with background work locking
In-Reply-To: <CALjSBEv9piEcLBxbDT_6YZPkkp-Um62DhJpAhL+VhPGeHz7MoA@mail.gmail.com>
Message-ID: <4813781d-84ba-35a8-661b-af6ef92bf3c7@redhat.com>
References: <20260825192226.4191036-1-bmarzins@redhat.com> <CALjSBEv9piEcLBxbDT_6YZPkkp-Um62DhJpAhL+VhPGeHz7MoA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mXR5nIwbudOeIZ4vy6MdSSdJDLNjFd2VzYlz9kZsa7g_1787830008
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-1689477233-1787830008=:1330975"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1689477233-1787830008=:1330975
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 27 Aug 2026, Ming Hung Tsai wrote:

> On Wed, Aug 26, 2026 at 3:22 AM Benjamin Marzinski <bmarzins@redhat.com> wrote:
> >
> > dm cache used a rw_semaphore for background_work_lock. Write locks on
> > rw_semaphores have strict owner semantics, but there was no guarantee
> > that the process that locked background_work_lock was the same process
> > that unlocked it. This can be easily seen using a kernel compiled with
> > CONFIG_DEBUG_RWSEMS. Given a dm cache device <cache>, run: 'dmsetup
> > suspend <cache> && dmsetup resume <cache>'. This will tigger a kernel
> > warning:
> >
> > DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE))
> >
> > triggered by cache_resume(). To fix this, switch from a rw_semaphore to
> > a spinlock and a wait queue. dm cache already hasd a wait queue and
> > associated counter, migration_wait and nr_allocated_migrations, that was
> > getting woken up when background work was getting completed, but wasn't
> > actually used by anything. This is replaced by the background_work queue
> > and counter.
> >
> > Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> 
> Thanks Ben. I confirmed the patch fixed it.
> 
> Just one minor nit: checkpatch prefers 'unsigned int' for background_work_nr.

Hi

Personally, I prefer 'unsigned'. There is no reason why to type more 
tokens if we don't have to.

Mikulas

> Worth noting before the commit b29d4986d0da ("dm cache: significant
> rework to leverage dm-bio-prison-v2"), dm cache waited for migrations
> via wait_for_migrations(), which did a wait_event() on migration_wait
> and nr_allocated_migrations. That commit replaced it with
> rw_semaphores and used lockdep_off() to suppress warnings, before
> DEBUG_RWSEMS existed.
> 
> Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
> 
> >  drivers/md/dm-cache-target.c | 55 ++++++++++++++++++------------------
> >  1 file changed, 28 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> > index 33dbc71b730f..d8d9c63d2a67 100644
> > --- a/drivers/md/dm-cache-target.c
> > +++ b/drivers/md/dm-cache-target.c
> > @@ -340,8 +340,6 @@ struct cache {
> >         struct list_head invalidation_requests;
> >
> >         sector_t migration_threshold;
> > -       wait_queue_head_t migration_wait;
> > -       atomic_t nr_allocated_migrations;
> >
> >         /*
> >          * The number of in flight migrations that are performing
> > @@ -397,7 +395,11 @@ struct cache {
> >         bool loaded_mappings:1;
> >         bool loaded_discards:1;
> >
> > -       struct rw_semaphore background_work_lock;
> > +       /* background work management */
> > +       bool background_work_allowed;
> > +       unsigned background_work_nr;
> > +       spinlock_t background_work_lock;
> > +       wait_queue_head_t background_work_wait;
> >
> >         struct batcher committer;
> >         struct work_struct commit_ws;
> > @@ -488,19 +490,13 @@ static struct dm_cache_migration *alloc_migration(struct cache *cache)
> >         memset(mg, 0, sizeof(*mg));
> >
> >         mg->cache = cache;
> > -       atomic_inc(&cache->nr_allocated_migrations);
> >
> >         return mg;
> >  }
> >
> >  static void free_migration(struct dm_cache_migration *mg)
> >  {
> > -       struct cache *cache = mg->cache;
> > -
> > -       if (atomic_dec_and_test(&cache->nr_allocated_migrations))
> > -               wake_up(&cache->migration_wait);
> > -
> > -       mempool_free(mg, &cache->migration_pool);
> > +       mempool_free(mg, &mg->cache->migration_pool);
> >  }
> >
> >  /*----------------------------------------------------------------*/
> > @@ -1030,34 +1026,39 @@ static void calc_discard_block_range(struct cache *cache, struct bio *bio,
> >
> >  static void prevent_background_work(struct cache *cache)
> >  {
> > -       lockdep_off();
> > -       down_write(&cache->background_work_lock);
> > -       lockdep_on();
> > +       spin_lock_irq(&cache->background_work_lock);
> > +       cache->background_work_allowed = false;
> > +       wait_event_lock_irq(cache->background_work_wait,
> > +                           cache->background_work_nr == 0,
> > +                           cache->background_work_lock);
> > +       spin_unlock_irq(&cache->background_work_lock);
> >  }
> >
> >  static void allow_background_work(struct cache *cache)
> >  {
> > -       lockdep_off();
> > -       up_write(&cache->background_work_lock);
> > -       lockdep_on();
> > +       spin_lock_irq(&cache->background_work_lock);
> > +       cache->background_work_allowed = true;
> > +       spin_unlock_irq(&cache->background_work_lock);
> >  }
> >
> >  static bool background_work_begin(struct cache *cache)
> >  {
> >         bool r;
> >
> > -       lockdep_off();
> > -       r = down_read_trylock(&cache->background_work_lock);
> > -       lockdep_on();
> > -
> > +       spin_lock_irq(&cache->background_work_lock);
> > +       r = cache->background_work_allowed;
> > +       if (r)
> > +               cache->background_work_nr++;
> > +       spin_unlock_irq(&cache->background_work_lock);
> >         return r;
> >  }
> >
> >  static void background_work_end(struct cache *cache)
> >  {
> > -       lockdep_off();
> > -       up_read(&cache->background_work_lock);
> > -       lockdep_on();
> > +       spin_lock_irq(&cache->background_work_lock);
> > +       if (--cache->background_work_nr == 0)
> > +               wake_up(&cache->background_work_wait);
> > +       spin_unlock_irq(&cache->background_work_lock);
> >  }
> >
> >  /*----------------------------------------------------------------*/
> > @@ -2507,9 +2508,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
> >
> >         spin_lock_init(&cache->lock);
> >         bio_list_init(&cache->deferred_bios);
> > -       atomic_set(&cache->nr_allocated_migrations, 0);
> >         atomic_set(&cache->nr_io_migrations, 0);
> > -       init_waitqueue_head(&cache->migration_wait);
> >
> >         r = -ENOMEM;
> >         atomic_set(&cache->nr_dirty, 0);
> > @@ -2592,8 +2591,10 @@ static int cache_create(struct cache_args *ca, struct cache **result)
> >                      issue_op, cache, cache->wq);
> >         dm_iot_init(&cache->tracker);
> >
> > -       init_rwsem(&cache->background_work_lock);
> > -       prevent_background_work(cache);
> > +       init_waitqueue_head(&cache->background_work_wait);
> > +       spin_lock_init(&cache->background_work_lock);
> > +       cache->background_work_allowed = false;
> > +       cache->background_work_nr = 0;
> >
> >         *result = cache;
> >         return 0;
> > --
> > 2.53.0
> >
> 

---1463811712-1689477233-1787830008=:1330975--

