Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295AD3C6A41
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 09:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784281037; cv=pass; b=r0rqDy0VO3DavgEi/GG8KOUPjkh37+oXgStgscUCG1WFCvG0pEw6kZwOZah9tw0IVz0Bs1f4SSlauiSSnsma7bhrPs3kl6N80s5y5kdsBrT35NwxGY0iumLN+9O3gM0yb5c+hwnFe10Ulr3gz9c4CDf7ZB5CBF+5FGkscnoLCxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784281037; c=relaxed/simple;
	bh=yBufBTBrrDwvJGdAN+Jex5yhJG1Tu4fBXqdD+WAKtnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YgxhqAMPwftfVVQ8y5R4U4t4eXERBJ9nox5PDMbKql9dvMxyEF2Af3UwWw7ER0AiVHLWYSt/gEiau9KzcopS3YknVRnzIky3wVyXwZUZVWUJ8oPBEglzZJI9k11cpzM8YYfFL3z20lvKEnCrvF+oLVQiBS4PrRZUq7T8rp0iDH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eV1SqVdJ; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eV1SqVdJ"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6a39a267d34so2313500eaf.2
        for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 02:37:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784281033; cv=none;
        d=google.com; s=arc-20260327;
        b=JgrBdfwVMMD2ZVTl4R6w1wR/IHBc2XUzMMn/48erYvkGecBOGQaw+dsndhYLOYb0le
         iXyzXOdG8gSRZs9avnARddX145Rl+wn6rAphv8ES9tf9x1hBryLOq/UpwQrOKCRSq/Rj
         GhX1ukfx8N/5cHhGwzjVVAVVKTvUWD7CDNTJ4REZqzr/dH1JPVwY1nvGjAKX9zS6Ndis
         Ajw88AVh0HfrxEcPlft0yTean5gzhaVrpBBTOj0ckDC3bRamgaFLeRI3AfN5UegqXinT
         4P2ePiIXZQahu2rsy5gxeUvbQj42NY1w4uMSwK0sS1nmA6OyV8TlkCj2omrnoYwy1wyt
         A0Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tnGAWrpv6J5m+eeFLN4P7XWs3AaS6w3HJOPhdThFMvg=;
        fh=8kSAftcNY3/yopbXCcwyG6QvWawMmMHle/gTWe2cJ1w=;
        b=YFocyhFKzV+YdhWLFzHdd0RoUyvurML5LckhULOi0hv4lJA9mpuBGyyNGEfb4l/6xz
         7L7GJu7YWMXWZ4P+Aqzl9XQzTxmiZRPBwf65AHky81YosIiXmzl6swEukQTJNmQOrsDZ
         fYoVA6Pa5IsPyeXm77AxJ7JlnoM57MHI9SBsjoSIGljVUOgpZBSvHx09tuO2Z37wuajX
         rGNIu5q+8UmbP83TzACh+895+nDWVRphH/ScO0Lblw8kO7VE7R7YHtYGO+yB73URxNLx
         OaopHDm0F8y8BvMnWRQEjwXtT4G1Nfp7wh2ADmfFjK2gJetAG5gmeiTl00SO52QPyY08
         QD4Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784281033; x=1784885833; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tnGAWrpv6J5m+eeFLN4P7XWs3AaS6w3HJOPhdThFMvg=;
        b=eV1SqVdJUhZFdbbdrCCZUhIktM7HXwT1v+nCIeTmtJIg9cc82+ENBjFCBiu5CJl2QI
         H3QK07joSQsaRAWgDNImkdOdGEiHuP+qoPsBpEW2ojf8iyemZIfSWRg+wLXLKRiu+/BE
         ASw6U3BMQ8sYVHLU4+M8Q82xMFrGOaZpQdudjBFPv1tNU8NSkdS5oa3MOrn4XBfDj8gh
         XZ+LRhI/rTE7Dq4YikSMfZYGHTqAIqVnlz6f2Z4qGZYQVWYfbDq7gEj9OwHfrJGJXAw7
         gAlMiVMCUs6NaZduA/X1pxFMzpvr/zcq1ApyzltqVjM5YbGwhaBFR91lQyDflDKUfhDQ
         KA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784281033; x=1784885833;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tnGAWrpv6J5m+eeFLN4P7XWs3AaS6w3HJOPhdThFMvg=;
        b=IMrSojdyfDPn7F6YQDWI0b2RbxN51Xrz5aNRXtHber7j05SQUguB3Klqg1IwYMCsFk
         9YUyMrSEdKhSg0MuBLWqzMIBWmFfL3JHbHbeP5ZlwnEd0BvnuR+2ELzdEupYWScKxXRu
         M6i6JAMkiMuPEqZeWbuCYt484rSafaqmRX5FQ4MPKWgfV/TOMyIQFFtncBp6UGZo1YdT
         MZI+WtCqMUCcWPgbv9IHDsMXhMldjQOfx1KgcheM1MINiSG2XbFOWwqQH32qj4HPZtU3
         eFtiCF2FhuZ5zDuRNE7as1iF1SmyCsOzru570P6Lo8S2MQEe8vfhYFSG47wJ/VKbwIXX
         Y2aQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8I+IXpBw4hWHRDoCC5OspedbLNjTy1s14jwCndo2axfEFP0RTaVNJGfZmximtee4KGSW533PcGg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxlO4BF1evnxmJ6yZ7U/2faUxIfnois4+uLge39cnjQSeRflStn
	F+0vVXlCzkCk0VpHOOeojte6ZBA8/d7RY+OE8CFtH6l1fzBVd1X+Hfooy7/s6Mk/T5Ih2y0Nifp
	n0ktPowrKvwbOj7yseEbLi2lN0OQfmXM=
X-Gm-Gg: AfdE7cnGkPqi0NrAfqze7oLjnu2eqrA5guyoj3hLjb2b1U2DTevEXl0l4sN+tMLaUkz
	p3HH9/k5F5DOFNH9M0uFnoJ8edORvsRYM7+D9dUnLvjfXvG27vdcv6LQUP2DjoAZwbPHBUh2Gqe
	afWEKuAmjSY7CHACrT4e4lmIUTeWhlfm7pCg8qHqhaTxeJ4XxjdIyPrMmfSDFBJinm15Il5baL9
	dEHT3sP/bGlO7O5EPlD7gaUw+Z1Na6jlwTs5k9TrRJgHPmbnTZoW4sgi9B4DpmPrFvx+i1YV7do
	Y7wDTkKiEB73Q8Y2jQ==
X-Received: by 2002:a05:6820:1513:b0:6a1:19ad:7a0e with SMTP id
 006d021491bc7-6a5366b45a1mr686749eaf.17.1784281032625; Fri, 17 Jul 2026
 02:37:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me>
 <20260619-b4-disp-997773a1-v1-1-14df8aedb323@proton.me> <CADSj-VpDU6cti4UmqTc1KwZp9XqWg2zVBQ4obGWJj7h3MAe7AQ@mail.gmail.com>
 <9a467635-49e8-6e0f-9fd0-a478b4c89279@redhat.com>
In-Reply-To: <9a467635-49e8-6e0f-9fd0-a478b4c89279@redhat.com>
From: Zheng Gu <cengku@gmail.com>
Date: Fri, 17 Jul 2026 17:37:00 +0800
X-Gm-Features: AUfX_mxdSuRZMC-Q9yIrBrdEo5mptoKZOAEN2qSyl8aBzAD39cPdZ1hUGH-ivl4
Message-ID: <CADSj-VqirgxFf55xi2ETJ5kRh8PQTyJufMmYMASMOX=OhSh-3g@mail.gmail.com>
Subject: Re: [PATCH 1/3] dm-pcache: validate seg_id fields from persistent memory
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: hexlabsecurity@proton.me, Dongsheng Yang <dongsheng.yang@linux.dev>, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 10:38=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
>
>
> On Sat, 27 Jun 2026, Zheng Gu wrote:
>
> > On Fri, Jun 19, 2026 at 7:44=E2=80=AFPM Bryam Vargas via B4 Relay
> > <devnull+hexlabsecurity.proton.me@kernel.org> wrote:
> > >
> > > From: Bryam Vargas <hexlabsecurity@proton.me>
> > >
> > > cache_pos_decode(), cache_key_decode() and the last-kset branches of
> > > cache_replay(), the writeback worker and the GC worker take a cache
> > > segment id from the cache device metadata and index cache->segments[]
> > > with it without checking it against cache->n_segs. That metadata is o=
nly
> > > CRC-protected with a fixed public seed, so whoever supplies the cache
> > > device on a table load (CAP_SYS_ADMIN) controls the id; an out-of-ran=
ge
> > > value forms a wild pcache_cache_segment pointer that is dereferenced =
and
> > > written through -- an out-of-bounds read and write driven by on-disk =
data.
> > >
> > > Add cache_seg_id_valid() and reject an out-of-range id at each decode
> > > site, failing the operation with -EIO instead of indexing past the ar=
ray.
> > > Valid metadata is unaffected.
> > >
> > > Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in devic=
e-mapper")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> > > ---
> > >  drivers/md/dm-pcache/cache.c           |  3 +++
> > >  drivers/md/dm-pcache/cache.h           | 14 ++++++++++++++
> > >  drivers/md/dm-pcache/cache_gc.c        | 16 ++++++++++++++--
> > >  drivers/md/dm-pcache/cache_key.c       | 11 +++++++++++
> > >  drivers/md/dm-pcache/cache_writeback.c | 14 +++++++++++---
> > >  5 files changed, 53 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cach=
e.c
> > > index bb1ada31e483..e6a2f4460f6e 100644
> > > --- a/drivers/md/dm-pcache/cache.c
> > > +++ b/drivers/md/dm-pcache/cache.c
> > > @@ -118,6 +118,9 @@ int cache_pos_decode(struct pcache_cache *cache,
> > >         if (!latest_addr)
> > >                 return -EIO;
> > >
> > > +       if (!cache_seg_id_valid(cache, latest.cache_seg_id))
> > > +               return -EIO;
> > > +
> > >         pos->cache_seg =3D &cache->segments[latest.cache_seg_id];
> > >         pos->seg_off =3D latest.seg_off;
> > >         *seq =3D latest.header.seq;
> > > diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cach=
e.h
> > > index 27613b56be54..653ceea43131 100644
> > > --- a/drivers/md/dm-pcache/cache.h
> > > +++ b/drivers/md/dm-pcache/cache.h
> > > @@ -420,6 +420,20 @@ static inline bool cache_seg_is_ctrl_seg(u32 cac=
he_seg_id)
> > >         return (cache_seg_id =3D=3D 0);
> > >  }
> > >
> > > +/**
> > > + * cache_seg_id_valid - Validate a cache segment id read from the ca=
che device.
> > > + * @cache: Pointer to the pcache_cache structure.
> > > + * @cache_seg_id: Segment id decoded from on-media metadata.
> > > + *
> > > + * On-media segment ids are only protected by a CRC, which an attack=
er who can
> > > + * format the cache device computes over their chosen value. Reject =
any id that
> > > + * would index cache->segments[] out of bounds before it is derefere=
nced.
> > > + */
> > > +static inline bool cache_seg_id_valid(struct pcache_cache *cache, u3=
2 cache_seg_id)
> > > +{
> > > +       return cache_seg_id < cache->n_segs;
> > > +}
> > > +
> > >  /**
> > >   * cache_key_cutfront - Cuts a specified length from the front of a =
cache key.
> > >   * @key: Pointer to pcache_cache_key structure.
> > > diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/c=
ache_gc.c
> > > index 94f8b276a021..02fa0ce03134 100644
> > > --- a/drivers/md/dm-pcache/cache_gc.c
> > > +++ b/drivers/md/dm-pcache/cache_gc.c
> > > @@ -74,11 +74,17 @@ static bool need_gc(struct pcache_cache *cache, s=
truct pcache_cache_pos *dirty_t
> > >   * @cache: Pointer to the pcache_cache structure.
> > >   * @kset_onmedia: Pointer to the kset_onmedia structure for the last=
 kset.
> > >   */
> > > -static void last_kset_gc(struct pcache_cache *cache, struct pcache_c=
ache_kset_onmedia *kset_onmedia)
> > > +static int last_kset_gc(struct pcache_cache *cache, struct pcache_ca=
che_kset_onmedia *kset_onmedia)
> > >  {
> > >         struct dm_pcache *pcache =3D CACHE_TO_PCACHE(cache);
> > >         struct pcache_cache_segment *cur_seg, *next_seg;
> > >
> > > +       if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_i=
d)) {
> > > +               pcache_dev_err(pcache, "invalid next_cache_seg_id %u =
in gc (n_segs %u)\n",
> > > +                               kset_onmedia->next_cache_seg_id, cach=
e->n_segs);
> > > +               return -EIO;
> > > +       }
> > > +
> > >         cur_seg =3D cache->key_tail.cache_seg;
> > >
> > >         next_seg =3D &cache->segments[kset_onmedia->next_cache_seg_id=
];
> > > @@ -94,6 +100,8 @@ static void last_kset_gc(struct pcache_cache *cach=
e, struct pcache_cache_kset_on
> > >         spin_lock(&cache->seg_map_lock);
> > >         __clear_bit(cur_seg->cache_seg_id, cache->seg_map);
> > >         spin_unlock(&cache->seg_map_lock);
> > > +
> > > +       return 0;
> > >  }
> > >
> > >  void pcache_cache_gc_fn(struct work_struct *work)
> > > @@ -130,7 +138,11 @@ void pcache_cache_gc_fn(struct work_struct *work=
)
> > >                         if (dirty_tail.cache_seg =3D=3D key_tail.cach=
e_seg)
> > >                                 break;
> > >
> > > -                       last_kset_gc(cache, kset_onmedia);
> > > +                       ret =3D last_kset_gc(cache, kset_onmedia);
> > > +                       if (ret) {
> > > +                               atomic_inc(&cache->gc_errors);
> > > +                               return;
> > > +                       }
> > >                         continue;
> > >                 }
> > >
> > > diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/=
cache_key.c
> > > index e068e878231b..8eec5238c5da 100644
> > > --- a/drivers/md/dm-pcache/cache_key.c
> > > +++ b/drivers/md/dm-pcache/cache_key.c
> > > @@ -94,6 +94,12 @@ int cache_key_decode(struct pcache_cache *cache,
> > >         key->off =3D key_onmedia->off;
> > >         key->len =3D key_onmedia->len;
> > >
> > > +       if (!cache_seg_id_valid(cache, key_onmedia->cache_seg_id)) {
> > > +               pcache_dev_err(pcache, "invalid cache_seg_id %u in ca=
che key (n_segs %u)\n",
> > > +                               key_onmedia->cache_seg_id, cache->n_s=
egs);
> > > +               return -EIO;
> > > +       }
> > > +
> > >         key->cache_pos.cache_seg =3D &cache->segments[key_onmedia->ca=
che_seg_id];
> > >         key->cache_pos.seg_off =3D key_onmedia->cache_seg_off;
> > >
> > > @@ -789,6 +795,11 @@ int cache_replay(struct pcache_cache *cache)
> > >
> > >                         pcache_dev_debug(pcache, "last kset replay, n=
ext: %u\n", kset_onmedia->next_cache_seg_id);
> > >
> > > +                       if (!cache_seg_id_valid(cache, kset_onmedia->=
next_cache_seg_id)) {
> > > +                               ret =3D -EIO;
> > > +                               goto out;
> > > +                       }
> > > +
> > >                         next_seg =3D &cache->segments[kset_onmedia->n=
ext_cache_seg_id];
> > >
> > >                         pos->cache_seg =3D next_seg;
> > > diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-p=
cache/cache_writeback.c
> > > index 87a82b3fe836..a104e6ee8aa8 100644
> > > --- a/drivers/md/dm-pcache/cache_writeback.c
> > > +++ b/drivers/md/dm-pcache/cache_writeback.c
> > > @@ -196,12 +196,18 @@ static int cache_kset_insert_tree(struct pcache=
_cache *cache, struct pcache_cach
> > >         return ret;
> > >  }
> > >
> > > -static void last_kset_writeback(struct pcache_cache *cache,
> > > +static int last_kset_writeback(struct pcache_cache *cache,
> > >                 struct pcache_cache_kset_onmedia *last_kset_onmedia)
> > >  {
> > >         struct dm_pcache *pcache =3D CACHE_TO_PCACHE(cache);
> > >         struct pcache_cache_segment *next_seg;
> > >
> > > +       if (!cache_seg_id_valid(cache, last_kset_onmedia->next_cache_=
seg_id)) {
> > > +               pcache_dev_err(pcache, "invalid next_cache_seg_id %u =
in writeback (n_segs %u)\n",
> > > +                               last_kset_onmedia->next_cache_seg_id,=
 cache->n_segs);
> > > +               return -EIO;
> > > +       }
> > > +
> > >         pcache_dev_debug(pcache, "last kset, next: %u\n", last_kset_o=
nmedia->next_cache_seg_id);
> > >
> > >         next_seg =3D &cache->segments[last_kset_onmedia->next_cache_s=
eg_id];
> > > @@ -211,6 +217,8 @@ static void last_kset_writeback(struct pcache_cac=
he *cache,
> > >         cache->dirty_tail.seg_off =3D 0;
> > >         cache_encode_dirty_tail(cache);
> > >         mutex_unlock(&cache->dirty_tail_lock);
> > > +
> > > +       return 0;
> > >  }
> > >
> > >  void cache_writeback_fn(struct work_struct *work)
> > > @@ -241,8 +249,8 @@ void cache_writeback_fn(struct work_struct *work)
> > >         }
> > >
> > >         if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
> > > -               last_kset_writeback(cache, kset_onmedia);
> > > -               delay =3D 0;
> > > +               ret =3D last_kset_writeback(cache, kset_onmedia);
> > > +               delay =3D ret ? PCACHE_CACHE_WRITEBACK_INTERVAL : 0;
> > >                 goto queue_work;
> > >         }
> > >
> > >
> > > --
> > > 2.43.0
> > >
> > >
> >
> > Reviewed-by:  Zheng Gu <cengku@gmail.com>
>
> Hi.
>
> I used Claude to review this patch and it found this bug. Would you fix i=
t
> or confirm that it is false positive?
>
> Mikulas
>
>
>   Patch 1/3: validate seg_id fields -- Bug found
>
>   Bug: Writeback worker retries forever on corrupt next_cache_seg_id.
>
>   The patched cache_writeback_fn() (line 249-255 of the diff):
>
>   if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
>       ret =3D last_kset_writeback(cache, kset_onmedia);
>       delay =3D ret ? PCACHE_CACHE_WRITEBACK_INTERVAL : 0;
>       goto queue_work;
>   }
>
>   When last_kset_writeback() returns -EIO (invalid next_cache_seg_id):
>   1. delay =3D PCACHE_CACHE_WRITEBACK_INTERVAL (5 seconds) and the worker
> reschedules
>   2. dirty_tail was NOT advanced (the function returned before modifying
> it)
>   3. On the next invocation, is_cache_clean() reads the same kset -- magi=
c
> OK, CRC OK --
>   returns false
>   4. Same LAST kset, same invalid next_cache_seg_id, same -EIO
>   5. pcache_dev_err() fires again, reschedule again... forever
>
>   Contrast with the GC path for the identical error:
>
>   ret =3D last_kset_gc(cache, kset_onmedia);
>   if (ret) {
>       atomic_inc(&cache->gc_errors);   // permanent flag
>       return;                          // exits WITHOUT rescheduling
>   }
>
>   The GC worker stops permanently via gc_errors (checked at the top of
>   pcache_cache_gc_fn() at line 113). The writeback worker has no
> equivalent counter --
>   struct pcache_cache has atomic_t gc_errors but nothing for writeback.
> The writeback
>   worker will spin on the corrupt kset every 5 seconds, logging an error
> each time, for
>   the lifetime of the target.
>
>   Fix: Either add a writeback_errors counter (like gc_errors) and check i=
t
> at the top of
>   cache_writeback_fn(), or use return without rescheduling like the GC
> path does.
>
>   The remaining validation sites in Patch 1 (cache_pos_decode,
> cache_key_decode,
>   cache_replay, last_kset_gc) look correct -- error returns are properly
> handled by
>   their callers.

Ah, good catch. My bad, Claude's review is right, the writeback may
spin forever on the corrupt kset.

Hi Bryam, Could you please fix this issue and send a V2?

Best regards,
Gu
