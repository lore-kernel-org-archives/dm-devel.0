Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA4D42FCA0
	for <dm-devel@lists.linux.dev>; Thu, 16 Jul 2026 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212740; cv=none; b=cd4uu+yGy3rQcIIK+tkB0w9I/9K1F+CIBG0j0dzQ2eS3RTPj8WhehiQ93Df77S8HU3KNSx5gwNnDqiVMcsm9tu2zlkwcLJPUOIfthy8psNy4aLkr8K/EVZI2Or1p8jwHUZym56/1x2aAJ68wZZ5N7/PHOlyjwNrjrrmemdVnFUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212740; c=relaxed/simple;
	bh=9UWhKyXSzCKr07LHTM5H2bf0tXWpMIWDg9SGLnz8MAc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DYQcM2UT/1putRpTPDbB113gAmG+MiXLibbXBQ+pr3jOPZE4J1eWzltnuquJ72pI1OiTXQTzQF/JyAJisUKNp+Q3NH/V7a5qC7llJYRaTYgVHiSXSXBgm0cLW0sWHBM44nJ1SB5mrcUlFAr0g1U4y1Qmt/xXBdcTcOC0LpDU92w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FpFGC5+J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FpFGC5+J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784212736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lSCSVXOFc4F6qxOF+uNCTZ0t8yc6PHgzuYZN4feMCVU=;
	b=FpFGC5+JlqJdVKP255HctkK7Q7it7ks/nswEEF2eVaO5j+TtEWhp99e71fwiFQHvrxFVoT
	ppYhyNQjEyP4wbxh5ne1cP2vxNBZI1gN6Ex2bKaDph3gt57Z8FTW+Jju3rx5wLSaiW90jz
	1tW3uOfFHp0veEDM7qW0ukeMnJwZGrk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-SYJdKjkmPm2l0UW7MzJKmg-1; Thu,
 16 Jul 2026 10:38:52 -0400
X-MC-Unique: SYJdKjkmPm2l0UW7MzJKmg-1
X-Mimecast-MFC-AGG-ID: SYJdKjkmPm2l0UW7MzJKmg_1784212731
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CBEB1955F0B;
	Thu, 16 Jul 2026 14:38:51 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D895C180036E;
	Thu, 16 Jul 2026 14:38:49 +0000 (UTC)
Date: Thu, 16 Jul 2026 16:38:47 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Zheng Gu <cengku@gmail.com>
cc: hexlabsecurity@proton.me, Dongsheng Yang <dongsheng.yang@linux.dev>, 
    linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/3] dm-pcache: validate seg_id fields from persistent
 memory
In-Reply-To: <CADSj-VpDU6cti4UmqTc1KwZp9XqWg2zVBQ4obGWJj7h3MAe7AQ@mail.gmail.com>
Message-ID: <9a467635-49e8-6e0f-9fd0-a478b4c89279@redhat.com>
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me> <20260619-b4-disp-997773a1-v1-1-14df8aedb323@proton.me> <CADSj-VpDU6cti4UmqTc1KwZp9XqWg2zVBQ4obGWJj7h3MAe7AQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: ODqzmEf5VKFqSUBtAqdSPpecgsRAhCRlhvx0gP0xT38_1784212731
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-602454098-1784212731=:197679"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-602454098-1784212731=:197679
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Sat, 27 Jun 2026, Zheng Gu wrote:

> On Fri, Jun 19, 2026 at 7:44 PM Bryam Vargas via B4 Relay
> <devnull+hexlabsecurity.proton.me@kernel.org> wrote:
> >
> > From: Bryam Vargas <hexlabsecurity@proton.me>
> >
> > cache_pos_decode(), cache_key_decode() and the last-kset branches of
> > cache_replay(), the writeback worker and the GC worker take a cache
> > segment id from the cache device metadata and index cache->segments[]
> > with it without checking it against cache->n_segs. That metadata is only
> > CRC-protected with a fixed public seed, so whoever supplies the cache
> > device on a table load (CAP_SYS_ADMIN) controls the id; an out-of-range
> > value forms a wild pcache_cache_segment pointer that is dereferenced and
> > written through -- an out-of-bounds read and write driven by on-disk data.
> >
> > Add cache_seg_id_valid() and reject an out-of-range id at each decode
> > site, failing the operation with -EIO instead of indexing past the array.
> > Valid metadata is unaffected.
> >
> > Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> > ---
> >  drivers/md/dm-pcache/cache.c           |  3 +++
> >  drivers/md/dm-pcache/cache.h           | 14 ++++++++++++++
> >  drivers/md/dm-pcache/cache_gc.c        | 16 ++++++++++++++--
> >  drivers/md/dm-pcache/cache_key.c       | 11 +++++++++++
> >  drivers/md/dm-pcache/cache_writeback.c | 14 +++++++++++---
> >  5 files changed, 53 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> > index bb1ada31e483..e6a2f4460f6e 100644
> > --- a/drivers/md/dm-pcache/cache.c
> > +++ b/drivers/md/dm-pcache/cache.c
> > @@ -118,6 +118,9 @@ int cache_pos_decode(struct pcache_cache *cache,
> >         if (!latest_addr)
> >                 return -EIO;
> >
> > +       if (!cache_seg_id_valid(cache, latest.cache_seg_id))
> > +               return -EIO;
> > +
> >         pos->cache_seg = &cache->segments[latest.cache_seg_id];
> >         pos->seg_off = latest.seg_off;
> >         *seq = latest.header.seq;
> > diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
> > index 27613b56be54..653ceea43131 100644
> > --- a/drivers/md/dm-pcache/cache.h
> > +++ b/drivers/md/dm-pcache/cache.h
> > @@ -420,6 +420,20 @@ static inline bool cache_seg_is_ctrl_seg(u32 cache_seg_id)
> >         return (cache_seg_id == 0);
> >  }
> >
> > +/**
> > + * cache_seg_id_valid - Validate a cache segment id read from the cache device.
> > + * @cache: Pointer to the pcache_cache structure.
> > + * @cache_seg_id: Segment id decoded from on-media metadata.
> > + *
> > + * On-media segment ids are only protected by a CRC, which an attacker who can
> > + * format the cache device computes over their chosen value. Reject any id that
> > + * would index cache->segments[] out of bounds before it is dereferenced.
> > + */
> > +static inline bool cache_seg_id_valid(struct pcache_cache *cache, u32 cache_seg_id)
> > +{
> > +       return cache_seg_id < cache->n_segs;
> > +}
> > +
> >  /**
> >   * cache_key_cutfront - Cuts a specified length from the front of a cache key.
> >   * @key: Pointer to pcache_cache_key structure.
> > diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
> > index 94f8b276a021..02fa0ce03134 100644
> > --- a/drivers/md/dm-pcache/cache_gc.c
> > +++ b/drivers/md/dm-pcache/cache_gc.c
> > @@ -74,11 +74,17 @@ static bool need_gc(struct pcache_cache *cache, struct pcache_cache_pos *dirty_t
> >   * @cache: Pointer to the pcache_cache structure.
> >   * @kset_onmedia: Pointer to the kset_onmedia structure for the last kset.
> >   */
> > -static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
> > +static int last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
> >  {
> >         struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
> >         struct pcache_cache_segment *cur_seg, *next_seg;
> >
> > +       if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_id)) {
> > +               pcache_dev_err(pcache, "invalid next_cache_seg_id %u in gc (n_segs %u)\n",
> > +                               kset_onmedia->next_cache_seg_id, cache->n_segs);
> > +               return -EIO;
> > +       }
> > +
> >         cur_seg = cache->key_tail.cache_seg;
> >
> >         next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
> > @@ -94,6 +100,8 @@ static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_on
> >         spin_lock(&cache->seg_map_lock);
> >         __clear_bit(cur_seg->cache_seg_id, cache->seg_map);
> >         spin_unlock(&cache->seg_map_lock);
> > +
> > +       return 0;
> >  }
> >
> >  void pcache_cache_gc_fn(struct work_struct *work)
> > @@ -130,7 +138,11 @@ void pcache_cache_gc_fn(struct work_struct *work)
> >                         if (dirty_tail.cache_seg == key_tail.cache_seg)
> >                                 break;
> >
> > -                       last_kset_gc(cache, kset_onmedia);
> > +                       ret = last_kset_gc(cache, kset_onmedia);
> > +                       if (ret) {
> > +                               atomic_inc(&cache->gc_errors);
> > +                               return;
> > +                       }
> >                         continue;
> >                 }
> >
> > diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
> > index e068e878231b..8eec5238c5da 100644
> > --- a/drivers/md/dm-pcache/cache_key.c
> > +++ b/drivers/md/dm-pcache/cache_key.c
> > @@ -94,6 +94,12 @@ int cache_key_decode(struct pcache_cache *cache,
> >         key->off = key_onmedia->off;
> >         key->len = key_onmedia->len;
> >
> > +       if (!cache_seg_id_valid(cache, key_onmedia->cache_seg_id)) {
> > +               pcache_dev_err(pcache, "invalid cache_seg_id %u in cache key (n_segs %u)\n",
> > +                               key_onmedia->cache_seg_id, cache->n_segs);
> > +               return -EIO;
> > +       }
> > +
> >         key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
> >         key->cache_pos.seg_off = key_onmedia->cache_seg_off;
> >
> > @@ -789,6 +795,11 @@ int cache_replay(struct pcache_cache *cache)
> >
> >                         pcache_dev_debug(pcache, "last kset replay, next: %u\n", kset_onmedia->next_cache_seg_id);
> >
> > +                       if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_id)) {
> > +                               ret = -EIO;
> > +                               goto out;
> > +                       }
> > +
> >                         next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
> >
> >                         pos->cache_seg = next_seg;
> > diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
> > index 87a82b3fe836..a104e6ee8aa8 100644
> > --- a/drivers/md/dm-pcache/cache_writeback.c
> > +++ b/drivers/md/dm-pcache/cache_writeback.c
> > @@ -196,12 +196,18 @@ static int cache_kset_insert_tree(struct pcache_cache *cache, struct pcache_cach
> >         return ret;
> >  }
> >
> > -static void last_kset_writeback(struct pcache_cache *cache,
> > +static int last_kset_writeback(struct pcache_cache *cache,
> >                 struct pcache_cache_kset_onmedia *last_kset_onmedia)
> >  {
> >         struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
> >         struct pcache_cache_segment *next_seg;
> >
> > +       if (!cache_seg_id_valid(cache, last_kset_onmedia->next_cache_seg_id)) {
> > +               pcache_dev_err(pcache, "invalid next_cache_seg_id %u in writeback (n_segs %u)\n",
> > +                               last_kset_onmedia->next_cache_seg_id, cache->n_segs);
> > +               return -EIO;
> > +       }
> > +
> >         pcache_dev_debug(pcache, "last kset, next: %u\n", last_kset_onmedia->next_cache_seg_id);
> >
> >         next_seg = &cache->segments[last_kset_onmedia->next_cache_seg_id];
> > @@ -211,6 +217,8 @@ static void last_kset_writeback(struct pcache_cache *cache,
> >         cache->dirty_tail.seg_off = 0;
> >         cache_encode_dirty_tail(cache);
> >         mutex_unlock(&cache->dirty_tail_lock);
> > +
> > +       return 0;
> >  }
> >
> >  void cache_writeback_fn(struct work_struct *work)
> > @@ -241,8 +249,8 @@ void cache_writeback_fn(struct work_struct *work)
> >         }
> >
> >         if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
> > -               last_kset_writeback(cache, kset_onmedia);
> > -               delay = 0;
> > +               ret = last_kset_writeback(cache, kset_onmedia);
> > +               delay = ret ? PCACHE_CACHE_WRITEBACK_INTERVAL : 0;
> >                 goto queue_work;
> >         }
> >
> >
> > --
> > 2.43.0
> >
> >
> 
> Reviewed-by:  Zheng Gu <cengku@gmail.com>

Hi.

I used Claude to review this patch and it found this bug. Would you fix it 
or confirm that it is false positive?

Mikulas


  Patch 1/3: validate seg_id fields -- Bug found
     
  Bug: Writeback worker retries forever on corrupt next_cache_seg_id.

  The patched cache_writeback_fn() (line 249-255 of the diff):

  if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
      ret = last_kset_writeback(cache, kset_onmedia);
      delay = ret ? PCACHE_CACHE_WRITEBACK_INTERVAL : 0;
      goto queue_work;
  }

  When last_kset_writeback() returns -EIO (invalid next_cache_seg_id):
  1. delay = PCACHE_CACHE_WRITEBACK_INTERVAL (5 seconds) and the worker 
reschedules
  2. dirty_tail was NOT advanced (the function returned before modifying 
it)
  3. On the next invocation, is_cache_clean() reads the same kset -- magic 
OK, CRC OK --
  returns false
  4. Same LAST kset, same invalid next_cache_seg_id, same -EIO
  5. pcache_dev_err() fires again, reschedule again... forever

  Contrast with the GC path for the identical error:

  ret = last_kset_gc(cache, kset_onmedia);
  if (ret) {
      atomic_inc(&cache->gc_errors);   // permanent flag
      return;                          // exits WITHOUT rescheduling
  }
  
  The GC worker stops permanently via gc_errors (checked at the top of
  pcache_cache_gc_fn() at line 113). The writeback worker has no 
equivalent counter --
  struct pcache_cache has atomic_t gc_errors but nothing for writeback. 
The writeback
  worker will spin on the corrupt kset every 5 seconds, logging an error 
each time, for
  the lifetime of the target.

  Fix: Either add a writeback_errors counter (like gc_errors) and check it 
at the top of
  cache_writeback_fn(), or use return without rescheduling like the GC 
path does.

  The remaining validation sites in Patch 1 (cache_pos_decode, 
cache_key_decode,
  cache_replay, last_kset_gc) look correct -- error returns are properly 
handled by
  their callers.

---1463811712-602454098-1784212731=:197679--

