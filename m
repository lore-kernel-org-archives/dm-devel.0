Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B2624BD03
	for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 08:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782547459; cv=pass; b=KRVJw9YGZvPVaBkUrfOIGbD1ZUY8okdOMBcfn2qhEhmgK/MCXgNtWqO3fvP22Qql/3unQcWrThiyFF0SLdN3w/oVCfBY/kQmrgqz2fufDiUyg9BGbm0QJ+FN+I5jUW/m4g+q1V/gepjNsMLOMVVKsQdOodvaR3wkwkuQyywB62Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782547459; c=relaxed/simple;
	bh=TUMTe4hxuPzNMW4temOfbNodVWXFUGVw9zm4gEY6sM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AsAuOHxzxHznXuxifaw3AsvrDtBW79EbZsKubZfCnOy1HaOt/0QK7bd3AfldiPe5sTVfMMIdrNj7yU9hRCYR51OPgGVP6ER+LW8OuSEnkH/GjI24MdCxS1/+Ruxpm5yS9+9Pu1X4mN6m7rBxH2ZhhWGFsbtadyL9gNY86WWZ/+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LB8B+Jdl; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LB8B+Jdl"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6a13fffa9b6so648788eaf.1
        for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 01:04:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782547457; cv=none;
        d=google.com; s=arc-20260327;
        b=FSu7wvo4u+R9ty1hjZAn+xKiZJTaq9X0+iJ0WpLZDA7Hz/cfpv9Umj8pOA0y/rMIjj
         AJirJmXyvON6v3NkFyWWlBeVUVntC44GjbkWeIXNQgLjB59RPIqZ6Bb8+0CoBBPlkUzN
         5xacpSOfy0a2a8Uc5sEVyHwzbThH+qTwJOp/EkiA3V1G+oOdy1hbrBfUME7DuLpwELyN
         08Yaudv13wJrMWf0sD/R1tbsixd/OaSvFO++dmtQqzwdmLbTvMQwBdULE6sSOwYB12UK
         QeC3A5qCRlby64B884ccAGasqWUqcUFbN+E/cTW2g5IKhj8GknTnFdDNZ3bbA9tefXCj
         WKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZKyLKeANvohLeSYZ8V4iD6wj+tbLRvnSleYUOYI6T84=;
        fh=eXTPA3NOoLOIMrCtYxFbD0NFvpca1C06NO5gfRqAIMg=;
        b=ObyJ7tzyZtsYiKXOgC6kocXG1LeFDfpe76gfo9rh+mIDeGdTwV+pnpxlQzKILOIQYy
         J9DG/0p5oq68wnIz1rNjHGVFpR7ZMsN7KbFpkg6G8mwq3h5Yumnm2NZ9+68ed/CFBc7h
         k5hNzAwigBuHIjAMo6fbiN+dRWynAb+b9R3EdaQe1vEw2xFo/C+FbwFg7afp9/bhfMlu
         SXVXK5KRprMa3CJgzMb6DAQq3od4Fsdu5nN7/rZjC8KX3jP7qEdxnJmAWIGPNnqR/Tqz
         dTRvQOJwVD5TaqW6HiCQ4wEmZpOa/geUwjdmCLdm3ob5QZwKubg5wyLH2ze974ZngwXs
         TN9Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782547457; x=1783152257; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZKyLKeANvohLeSYZ8V4iD6wj+tbLRvnSleYUOYI6T84=;
        b=LB8B+JdlpOtTSKFfXKphCe+GnJcVegGapPIA2/ez7i20ylyfICZXtlQvh0FAPIU/9E
         UDNL0nd5KNCpwcdbg6olSILggA0sektzh/cKbyNgn1yAc7VDawBZEAg4NWBVkZs83uf8
         F/3S5zD7r33d6CUMOPkozikdcYJQm1dzcq36t+xeVWWMPtoSLbLkOhE8dOuRyo+TLURY
         cCm5BpxwNupyJfnnU/gayQeSy//7NE4LhR9G/krNAD03e35UfCleThtilVElOBkEwIqh
         XiFbTAIROQuB/LwaXU3ytX2TkG3n5NtpEJ8k/rWlshY1bOXzuwAx01Fll7JgYTKqWbJt
         z8NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782547457; x=1783152257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZKyLKeANvohLeSYZ8V4iD6wj+tbLRvnSleYUOYI6T84=;
        b=Jy6L8Zwps3NdJbd64ZPm6JuLZtHMjPavwwyH6626Pa/DfOUvvD8ILkhYbqqF8Wzv4M
         Rzn8+ThdMlnm2ckK1jByihND9/zUskJ2Fvecr0yuJN2I4mpFQMVPQoKi9J+btFhzT3kp
         GC+fa9C/LoXu5I8Y9YGmCIfb8bZ9/oVSc6rAbOrD4jf7LdqRWL4cTVTmkMvo8uyYLMY5
         AW/ngJQBXoD1NTlRHWIRogd+W2NYbG5hX4WMHIbyL7jl7OOdH/CmSCONBfVuUtu5S68k
         hGDBQLoknPFXPrwqLAmQRCQpNpBXhtCruybe+HqHKmOw4rq15u81rleik1Ms9gkh2tVA
         JXVw==
X-Forwarded-Encrypted: i=1; AFNElJ9C0KR+XThh8OpQqGGioCAZrlHxYxHdwIPE0vV56dKI7WJb8sz3P8eDZrUUrA2fQ479eckjD87zmw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMt0S6Y3b3+IfHFaas0KCzcHDFEgpowr8Dh9bQL0qctZtW7vm6
	ILdYh67liHN3i0doBnhIPkwzvQH25bMB2cwcZYs12AqYITFTstzkL7lYLXxPltwALiADObDluTR
	uDvZiMptxQU4cIexCY7XPgixFKSnpWcs2GA0QKPFtNs4Petc=
X-Gm-Gg: AfdE7ckunc5Do7Pphp8GgN2DT1FJD0ZMXtqu/0vSotiGsGtRkFXKrhbvHLJrvFOndCU
	qk5b90izjApGz+NWdd++7UhWHrFQOfHDaAagkTPzgzDE9BwOvox4Xne/FUzfimEuV9Xcz57MQ+B
	MlQnObb8lpVFdYQYcVAYHuBLtiChXiZuvM38B21sp8E62g8Y5FaRBqihm/HsY7Lqk7dRhrew2zf
	rjGLoCA+ZUaMQlknCQfuWZjD5L83CnkaeMIznV8CV/RsrFDXi49vr8TZv6XeZ9CQD+OUYDV5e4D
	HqhMQivShOvLYdo/CTQszc4hz+MMdA+/ULiI7Ns=
X-Received: by 2002:a05:6820:1c94:b0:6a1:41ae:1be3 with SMTP id
 006d021491bc7-6a141ae1eedmr4468219eaf.41.1782547456891; Sat, 27 Jun 2026
 01:04:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me> <20260619-b4-disp-997773a1-v1-1-14df8aedb323@proton.me>
In-Reply-To: <20260619-b4-disp-997773a1-v1-1-14df8aedb323@proton.me>
From: Zheng Gu <cengku@gmail.com>
Date: Sat, 27 Jun 2026 16:04:06 +0800
X-Gm-Features: AVVi8CdmFYoIOC742zVvP-YZZKYReBZoYRt5aHnt2PzgO6VFYL1NJAbMe-A_hR0
Message-ID: <CADSj-VpDU6cti4UmqTc1KwZp9XqWg2zVBQ4obGWJj7h3MAe7AQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] dm-pcache: validate seg_id fields from persistent memory
To: hexlabsecurity@proton.me
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>, linux-kernel@vger.kernel.org, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2026 at 7:44=E2=80=AFPM Bryam Vargas via B4 Relay
<devnull+hexlabsecurity.proton.me@kernel.org> wrote:
>
> From: Bryam Vargas <hexlabsecurity@proton.me>
>
> cache_pos_decode(), cache_key_decode() and the last-kset branches of
> cache_replay(), the writeback worker and the GC worker take a cache
> segment id from the cache device metadata and index cache->segments[]
> with it without checking it against cache->n_segs. That metadata is only
> CRC-protected with a fixed public seed, so whoever supplies the cache
> device on a table load (CAP_SYS_ADMIN) controls the id; an out-of-range
> value forms a wild pcache_cache_segment pointer that is dereferenced and
> written through -- an out-of-bounds read and write driven by on-disk data=
.
>
> Add cache_seg_id_valid() and reject an out-of-range id at each decode
> site, failing the operation with -EIO instead of indexing past the array.
> Valid metadata is unaffected.
>
> Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-ma=
pper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  drivers/md/dm-pcache/cache.c           |  3 +++
>  drivers/md/dm-pcache/cache.h           | 14 ++++++++++++++
>  drivers/md/dm-pcache/cache_gc.c        | 16 ++++++++++++++--
>  drivers/md/dm-pcache/cache_key.c       | 11 +++++++++++
>  drivers/md/dm-pcache/cache_writeback.c | 14 +++++++++++---
>  5 files changed, 53 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index bb1ada31e483..e6a2f4460f6e 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -118,6 +118,9 @@ int cache_pos_decode(struct pcache_cache *cache,
>         if (!latest_addr)
>                 return -EIO;
>
> +       if (!cache_seg_id_valid(cache, latest.cache_seg_id))
> +               return -EIO;
> +
>         pos->cache_seg =3D &cache->segments[latest.cache_seg_id];
>         pos->seg_off =3D latest.seg_off;
>         *seq =3D latest.header.seq;
> diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
> index 27613b56be54..653ceea43131 100644
> --- a/drivers/md/dm-pcache/cache.h
> +++ b/drivers/md/dm-pcache/cache.h
> @@ -420,6 +420,20 @@ static inline bool cache_seg_is_ctrl_seg(u32 cache_s=
eg_id)
>         return (cache_seg_id =3D=3D 0);
>  }
>
> +/**
> + * cache_seg_id_valid - Validate a cache segment id read from the cache =
device.
> + * @cache: Pointer to the pcache_cache structure.
> + * @cache_seg_id: Segment id decoded from on-media metadata.
> + *
> + * On-media segment ids are only protected by a CRC, which an attacker w=
ho can
> + * format the cache device computes over their chosen value. Reject any =
id that
> + * would index cache->segments[] out of bounds before it is dereferenced=
.
> + */
> +static inline bool cache_seg_id_valid(struct pcache_cache *cache, u32 ca=
che_seg_id)
> +{
> +       return cache_seg_id < cache->n_segs;
> +}
> +
>  /**
>   * cache_key_cutfront - Cuts a specified length from the front of a cach=
e key.
>   * @key: Pointer to pcache_cache_key structure.
> diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache=
_gc.c
> index 94f8b276a021..02fa0ce03134 100644
> --- a/drivers/md/dm-pcache/cache_gc.c
> +++ b/drivers/md/dm-pcache/cache_gc.c
> @@ -74,11 +74,17 @@ static bool need_gc(struct pcache_cache *cache, struc=
t pcache_cache_pos *dirty_t
>   * @cache: Pointer to the pcache_cache structure.
>   * @kset_onmedia: Pointer to the kset_onmedia structure for the last kse=
t.
>   */
> -static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache=
_kset_onmedia *kset_onmedia)
> +static int last_kset_gc(struct pcache_cache *cache, struct pcache_cache_=
kset_onmedia *kset_onmedia)
>  {
>         struct dm_pcache *pcache =3D CACHE_TO_PCACHE(cache);
>         struct pcache_cache_segment *cur_seg, *next_seg;
>
> +       if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_id)) =
{
> +               pcache_dev_err(pcache, "invalid next_cache_seg_id %u in g=
c (n_segs %u)\n",
> +                               kset_onmedia->next_cache_seg_id, cache->n=
_segs);
> +               return -EIO;
> +       }
> +
>         cur_seg =3D cache->key_tail.cache_seg;
>
>         next_seg =3D &cache->segments[kset_onmedia->next_cache_seg_id];
> @@ -94,6 +100,8 @@ static void last_kset_gc(struct pcache_cache *cache, s=
truct pcache_cache_kset_on
>         spin_lock(&cache->seg_map_lock);
>         __clear_bit(cur_seg->cache_seg_id, cache->seg_map);
>         spin_unlock(&cache->seg_map_lock);
> +
> +       return 0;
>  }
>
>  void pcache_cache_gc_fn(struct work_struct *work)
> @@ -130,7 +138,11 @@ void pcache_cache_gc_fn(struct work_struct *work)
>                         if (dirty_tail.cache_seg =3D=3D key_tail.cache_se=
g)
>                                 break;
>
> -                       last_kset_gc(cache, kset_onmedia);
> +                       ret =3D last_kset_gc(cache, kset_onmedia);
> +                       if (ret) {
> +                               atomic_inc(&cache->gc_errors);
> +                               return;
> +                       }
>                         continue;
>                 }
>
> diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cach=
e_key.c
> index e068e878231b..8eec5238c5da 100644
> --- a/drivers/md/dm-pcache/cache_key.c
> +++ b/drivers/md/dm-pcache/cache_key.c
> @@ -94,6 +94,12 @@ int cache_key_decode(struct pcache_cache *cache,
>         key->off =3D key_onmedia->off;
>         key->len =3D key_onmedia->len;
>
> +       if (!cache_seg_id_valid(cache, key_onmedia->cache_seg_id)) {
> +               pcache_dev_err(pcache, "invalid cache_seg_id %u in cache =
key (n_segs %u)\n",
> +                               key_onmedia->cache_seg_id, cache->n_segs)=
;
> +               return -EIO;
> +       }
> +
>         key->cache_pos.cache_seg =3D &cache->segments[key_onmedia->cache_=
seg_id];
>         key->cache_pos.seg_off =3D key_onmedia->cache_seg_off;
>
> @@ -789,6 +795,11 @@ int cache_replay(struct pcache_cache *cache)
>
>                         pcache_dev_debug(pcache, "last kset replay, next:=
 %u\n", kset_onmedia->next_cache_seg_id);
>
> +                       if (!cache_seg_id_valid(cache, kset_onmedia->next=
_cache_seg_id)) {
> +                               ret =3D -EIO;
> +                               goto out;
> +                       }
> +
>                         next_seg =3D &cache->segments[kset_onmedia->next_=
cache_seg_id];
>
>                         pos->cache_seg =3D next_seg;
> diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcach=
e/cache_writeback.c
> index 87a82b3fe836..a104e6ee8aa8 100644
> --- a/drivers/md/dm-pcache/cache_writeback.c
> +++ b/drivers/md/dm-pcache/cache_writeback.c
> @@ -196,12 +196,18 @@ static int cache_kset_insert_tree(struct pcache_cac=
he *cache, struct pcache_cach
>         return ret;
>  }
>
> -static void last_kset_writeback(struct pcache_cache *cache,
> +static int last_kset_writeback(struct pcache_cache *cache,
>                 struct pcache_cache_kset_onmedia *last_kset_onmedia)
>  {
>         struct dm_pcache *pcache =3D CACHE_TO_PCACHE(cache);
>         struct pcache_cache_segment *next_seg;
>
> +       if (!cache_seg_id_valid(cache, last_kset_onmedia->next_cache_seg_=
id)) {
> +               pcache_dev_err(pcache, "invalid next_cache_seg_id %u in w=
riteback (n_segs %u)\n",
> +                               last_kset_onmedia->next_cache_seg_id, cac=
he->n_segs);
> +               return -EIO;
> +       }
> +
>         pcache_dev_debug(pcache, "last kset, next: %u\n", last_kset_onmed=
ia->next_cache_seg_id);
>
>         next_seg =3D &cache->segments[last_kset_onmedia->next_cache_seg_i=
d];
> @@ -211,6 +217,8 @@ static void last_kset_writeback(struct pcache_cache *=
cache,
>         cache->dirty_tail.seg_off =3D 0;
>         cache_encode_dirty_tail(cache);
>         mutex_unlock(&cache->dirty_tail_lock);
> +
> +       return 0;
>  }
>
>  void cache_writeback_fn(struct work_struct *work)
> @@ -241,8 +249,8 @@ void cache_writeback_fn(struct work_struct *work)
>         }
>
>         if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
> -               last_kset_writeback(cache, kset_onmedia);
> -               delay =3D 0;
> +               ret =3D last_kset_writeback(cache, kset_onmedia);
> +               delay =3D ret ? PCACHE_CACHE_WRITEBACK_INTERVAL : 0;
>                 goto queue_work;
>         }
>
>
> --
> 2.43.0
>
>

Reviewed-by:  Zheng Gu <cengku@gmail.com>
