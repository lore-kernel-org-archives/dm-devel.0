Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F73E331EC3
	for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 08:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782547573; cv=pass; b=BfOrw7LKgDFqy5fb8wW/1h8KFreJetY7CDjeNOebgV7ipIuiV1oAey6HdCvK021KoM0OLSYDeBE2DHdaw/WvXE6ZzOUJ1RCX8zkL67rIarzxGOLPSu3WvkdVWRHrOZv/zP91EuLjmgFSJevqh7m0odt+N8KWNexB1Q5mcdlB9+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782547573; c=relaxed/simple;
	bh=c7glGuYyD68lQUC0JtIX0vFqlrmESuR6eyXs+eMqSAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZH8U+z/+iTz2oklKZ0wjqGGfG2O8DLbkCfRmyrZqGE6IWMFhrX6gkuD1BhL24xMuVgsuylrXhqvE94yk12acDbwgscAonczh0S7saNtWyeFd3bLFxaGuWpEJ1ZgLpPGfgXhmH2FDnrRBxe1vlzK2BF7H86FFkR+m+pRQlMtNdqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDb0MC33; arc=pass smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDb0MC33"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-69d7aa0ac14so1374162eaf.3
        for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 01:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782547571; cv=none;
        d=google.com; s=arc-20260327;
        b=ThfdQyB93/q1uMJCErqbhwSS5J6GeMC7v9mDBiXG/bOGuXBvz0lLj3vWp+fPaWoZf/
         +2kYUn5CtTn4LRNFEvoACfMfzQk/PqREHSmVOf/1L9e0WB67i9whaSIWLI3p56fX/VvO
         B1bpnw4rJz29qwlZAclP7PmA4FjxcXfH5i/bhmThyYGQhiTaZbjS6330CZESX4PcbZRY
         xvlWQbpUIifNyaVT5+6carSBPNz0qPATgue1cYNhrQd038mZi43vVk2oZYrTlAqZkXS6
         eYz0UVMRqU20X2Ql0iXHp8zhaasOzLNlMT8bvu9+6IpJ2szj+XcMwd8Tlu5cV+14xBxo
         iwyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=etduQ49k6EN1mK8yaZUAxJUVkUnd+AdWd6AMC1QC14Q=;
        fh=ICQhqouqckbsUdr5yn+CmBfJPLVQWv3mELE0VuVk18Y=;
        b=Z85ZzpJSqLn3ygJ2XYgho/+4mFh/on1+DnRwRCWYRm6qgY1s/DsqZSTWBglyar5K61
         yFWqQaoCRGN/QWhsjACvkKVl/7ITpo7wK9+nK2ucTrCDA2OWdZdnkNkwF7MHHo8b36tJ
         8OMObjR6oN04SXtB71/IvwHYCxXFB7ACbIcBX3feXGC4oj6HFazOCGGsM3t8YTklQD/U
         +eHwx5cV07JAwd+2IapUEJXWqqjADxD82jo3Js+BDELGokEwU84wrL0ctlzPQjyIRxBF
         zomF35/wQknev5DV20Rm8uLGvNAzYy+/KOmjbSxnXidA8N2mfeLCEQ51rSDfKo0x04eA
         EQig==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782547571; x=1783152371; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etduQ49k6EN1mK8yaZUAxJUVkUnd+AdWd6AMC1QC14Q=;
        b=NDb0MC33wZegvCly5dyHv5Bj0bBUDwsT+KGUw8sVyi8ap/K8dmEa7N3OBYx+MJlxbR
         w85olzIcRsJKrerKB41aEPgYEjjgoJ7DqCs+btl+ayIWuK9aWwGkMyMZeCKC2V8t67Z8
         WOrALUbkxCMJ7OyWLgI5LRjl/YzEEj42BHxAYt5LNjmbyDRfVTCxZBjZgFUbbwuyn3pk
         +2iTGdQWR0g1REYN2Cz/jPxZwDTSMan0tw3j+zsYaFA+x/pg6bE5G559l0jK3fWDT/u1
         JmwSIGEz4E6L9L+9feHwaw/h2hhTemCP02YKAt8oUlyA9RxGZArI7TLz4q9aqPsIp28s
         E/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782547571; x=1783152371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=etduQ49k6EN1mK8yaZUAxJUVkUnd+AdWd6AMC1QC14Q=;
        b=Pc3gxUS94TDJGJaBXo6nFecR1ezYUfvkBm7J0ZfSNIoZbcX97ScLhfUxJGIl6wW2Xd
         sDEs7U0Z80xXZcvw7xumtx9kTzTqgsDblevbfZBVjzQ2MYQcka8B9vO9WEkMfKmDT6t0
         4aRO8DJva2LMGeQ6ucRCWxb3T1Ubbs9s8kZPk+knTODsQNMheX6t5EEIjMkxF6oR5UUx
         NZHx40lhV1YaGcOUKnncAI0jojuhIyE6COwE/zjaVFsq3mnOxcN+yRsyDM2omgc+nhK2
         X1hpm3sF9hzfxyYxr+s3p1HoPPPG539C1aZ4LUEniNYLfsaG/MPP+3cm5HXG5rsxoMr8
         HIiA==
X-Forwarded-Encrypted: i=1; AFNElJ9ayfl8ZaCntjQ0wAPRiXaAv5u6zYiwUS2u0j2mEB2i3ugpQzXUI1RK2ykm181VxXshEgZTV656RQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yze5RS0eMiBUU6Jxv7uq55ElBb+7AF9zXfD9uTcLQWtv0YFJqlX
	d39JXVctXFqx3950aUhK032OSjV62ZTIVSjzNTFZPs+E7JfNy7YZ2UYPJ+nE6UIQIe7RrsqIUCY
	McDySCYFktYK//MPB0ijTwO+u/QtlcaI=
X-Gm-Gg: AfdE7cnxmLdUFhS6ASouLVrXwpNsgfUnz60tKIylT7pidmVoHWDLUc4p4w1P3vUWQoG
	dKFoEZZfsBX2d0erxSNwsCWeXALPNx5HuD4SSYBygxOXsmwlIqZQxmMbTkuZi2pyIywCNe+4ng/
	8sxXqUSx3IznClyxHTmhJutHBhDk6842qsoeK9/28eLG1tMUpwIJlJga1QNCmcRqX7CLhVXe0Qf
	3i/NKu5UaczI11US2xvl3tCPLqMHFPQw85pm1HpH2aFqnLWFePg9yIDkTZtdHM2MSJXSNSxxfHp
	Pbi9vIQMnt2PL+VpqohiQ528WK30DQlpz0dz8/A=
X-Received: by 2002:a05:6820:2103:b0:6a1:2295:f47c with SMTP id
 006d021491bc7-6a1500847e1mr2357624eaf.36.1782547571133; Sat, 27 Jun 2026
 01:06:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619-b4-disp-997773a1-v1-0-14df8aedb323@proton.me> <20260619-b4-disp-997773a1-v1-3-14df8aedb323@proton.me>
In-Reply-To: <20260619-b4-disp-997773a1-v1-3-14df8aedb323@proton.me>
From: Zheng Gu <cengku@gmail.com>
Date: Sat, 27 Jun 2026 16:05:59 +0800
X-Gm-Features: AVVi8CfZctdDq2odLVlr7xIVUtd_JecEaiUejGuclLMl8bLIPgE7Q0T8hi6cISY
Message-ID: <CADSj-VqXChj64SBtN2--tx36dYX1QsPoUOBzZTE3kJuOeD2o4Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] dm-pcache: validate kset key_num and intra-segment bounds
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
> Two more fields decoded from the cache device go unbounded. The kset
> key_num drives cache_kset_crc() and the replay loop in cache_replay(),
> the writeback worker and the GC worker, but only the magic and a
> fixed-seed CRC are checked first, so a non-last kset whose key_num exceed=
s
> the PCACHE_KSET_KEYS_MAX buffer reads past its end before the CRC compare=
.
> A key's intra-segment offset and length in cache_key_decode() are taken
> verbatim, so a key running past its segment is replayed into the cache
> tree and the data CRC check and every later read hit then copy adjacent
> persistent memory into the caller's bio -- an out-of-bounds read that
> leaks to user space. Both fields are controlled by whoever supplies the
> cache device (CAP_SYS_ADMIN); the CRC seed is public.
>
> Add kset_onmedia_valid() to bound key_num before any kset read, and
> reject a key whose offset plus length, computed in 64 bits, exceeds the
> segment data_size. Valid metadata is unaffected.
>
> Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-ma=
pper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
>  drivers/md/dm-pcache/cache.h           | 21 +++++++++++++++++++++
>  drivers/md/dm-pcache/cache_gc.c        |  8 ++++----
>  drivers/md/dm-pcache/cache_key.c       | 10 +++++++++-
>  drivers/md/dm-pcache/cache_writeback.c |  8 ++++----
>  4 files changed, 38 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
> index 653ceea43131..d470e457b23f 100644
> --- a/drivers/md/dm-pcache/cache.h
> +++ b/drivers/md/dm-pcache/cache.h
> @@ -505,6 +505,27 @@ static inline u32 cache_key_data_crc(struct pcache_c=
ache_key *key)
>         return crc32c(PCACHE_CRC_SEED, data, key->len);
>  }
>
> +/**
> + * kset_onmedia_valid - Validate a kset header read from the cache devic=
e.
> + * @kset_onmedia: Pointer to the kset copied from on-media metadata.
> + *
> + * The magic and CRC are attacker-computable (fixed public seed). A non-=
last
> + * kset stores key_num keys inline, and cache_kset_crc() and the replay =
loop
> + * read struct_size(.., data, key_num) bytes from a buffer sized for
> + * PCACHE_KSET_KEYS_MAX keys, so key_num must be bounded before any such=
 use.
> + */
> +static inline bool kset_onmedia_valid(struct pcache_cache_kset_onmedia *=
kset_onmedia)
> +{
> +       if (kset_onmedia->magic !=3D PCACHE_KSET_MAGIC)
> +               return false;
> +
> +       if (!(kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) &&
> +           kset_onmedia->key_num > PCACHE_KSET_KEYS_MAX)
> +               return false;
> +
> +       return true;
> +}
> +
>  static inline u32 cache_kset_crc(struct pcache_cache_kset_onmedia *kset_=
onmedia)
>  {
>         u32 crc_size;
> diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache=
_gc.c
> index 02fa0ce03134..1ed513745023 100644
> --- a/drivers/md/dm-pcache/cache_gc.c
> +++ b/drivers/md/dm-pcache/cache_gc.c
> @@ -44,11 +44,11 @@ static bool need_gc(struct pcache_cache *cache, struc=
t pcache_cache_pos *dirty_t
>                 return false;
>         }
>
> -       /* Check if kset_onmedia is corrupted */
> -       if (kset_onmedia->magic !=3D PCACHE_KSET_MAGIC) {
> -               pcache_dev_debug(pcache, "gc error: magic is not as expec=
ted. key_tail: %u:%u magic: %llx, expected: %llx\n",
> +       /* Reject a corrupted or out-of-bounds kset before reading its ke=
ys */
> +       if (!kset_onmedia_valid(kset_onmedia)) {
> +               pcache_dev_debug(pcache, "gc error: invalid kset. key_tai=
l: %u:%u magic: %llx, key_num: %u\n",
>                                         key_tail->cache_seg->cache_seg_id=
, key_tail->seg_off,
> -                                       kset_onmedia->magic, PCACHE_KSET_=
MAGIC);
> +                                       kset_onmedia->magic, kset_onmedia=
->key_num);
>                 return false;
>         }
>
> diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cach=
e_key.c
> index 8eec5238c5da..f4459b2e1b3b 100644
> --- a/drivers/md/dm-pcache/cache_key.c
> +++ b/drivers/md/dm-pcache/cache_key.c
> @@ -103,6 +103,14 @@ int cache_key_decode(struct pcache_cache *cache,
>         key->cache_pos.cache_seg =3D &cache->segments[key_onmedia->cache_=
seg_id];
>         key->cache_pos.seg_off =3D key_onmedia->cache_seg_off;
>
> +       if ((u64)key->cache_pos.seg_off + key->len >
> +                       key->cache_pos.cache_seg->segment.data_size) {
> +               pcache_dev_err(pcache, "key seg_off %u + len %u exceeds s=
egment data size %u\n",
> +                               key->cache_pos.seg_off, key->len,
> +                               key->cache_pos.cache_seg->segment.data_si=
ze);
> +               return -EIO;
> +       }
> +
>         key->seg_gen =3D key_onmedia->seg_gen;
>         key->flags =3D key_onmedia->flags;
>
> @@ -784,7 +792,7 @@ int cache_replay(struct pcache_cache *cache)
>                         goto out;
>                 }
>
> -               if (kset_onmedia->magic !=3D PCACHE_KSET_MAGIC ||
> +               if (!kset_onmedia_valid(kset_onmedia) ||
>                                 kset_onmedia->crc !=3D cache_kset_crc(kse=
t_onmedia)) {
>                         break;
>                 }
> diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcach=
e/cache_writeback.c
> index a104e6ee8aa8..f96657a1dc1a 100644
> --- a/drivers/md/dm-pcache/cache_writeback.c
> +++ b/drivers/md/dm-pcache/cache_writeback.c
> @@ -55,11 +55,11 @@ static inline bool is_cache_clean(struct pcache_cache=
 *cache, struct pcache_cach
>                 return true;
>         }
>
> -       /* Check if the magic number matches the expected value */
> -       if (kset_onmedia->magic !=3D PCACHE_KSET_MAGIC) {
> -               pcache_dev_debug(pcache, "dirty_tail: %u:%u magic: %llx, =
not expected: %llx\n",
> +       /* Reject a corrupted or out-of-bounds kset before reading its ke=
ys */
> +       if (!kset_onmedia_valid(kset_onmedia)) {
> +               pcache_dev_debug(pcache, "dirty_tail: %u:%u invalid kset =
magic: %llx, key_num: %u\n",
>                                 dirty_tail->cache_seg->cache_seg_id, dirt=
y_tail->seg_off,
> -                               kset_onmedia->magic, PCACHE_KSET_MAGIC);
> +                               kset_onmedia->magic, kset_onmedia->key_nu=
m);
>                 return true;
>         }
>
>
> --
> 2.43.0
>
>

Reviewed-by:  Zheng Gu <cengku@gmail.com>
