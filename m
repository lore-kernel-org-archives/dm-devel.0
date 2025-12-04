Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092B026F2A0
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 03:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764817747; cv=none; b=jh52/1i4gXj00+t/YRmy9491bVQpQJZ9zhOuuagwmbPphzL/5iZ9bOI/le2rYB9UHm8VM1zvfFAbxdneYl3XfH4AUB3Grv2XS8cA0OOu8yhnF//+LugJyIHODFDcnm+LiA80TNszftmMRbRsuvxmFbAEskN/q7bTWnHEgb/DCHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764817747; c=relaxed/simple;
	bh=0LW03AlwU+Yb+Kz9h3DjEZ9Ns/DI3pTUR/ichQ7HCiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TWn0i1uphpA9x0d+00AxdyFu5//+TP6d3WSsTCLSsbCdMfPNrqRRaehzwAIAt5osAduFDCIuARBOmp6YEE82X+vU/O/DsH132qI9RYbuFBKT7jFgqWmDmgfz2jHUJNfO7G2fwmATKLUKbNLPoRry48RLVWavBxCjSpNJrbcmVms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y67p7RDm; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y67p7RDm"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-656b4881f55so239169eaf.2
        for <dm-devel@lists.linux.dev>; Wed, 03 Dec 2025 19:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764817741; x=1765422541; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ja0IQVgurSVBwpz+0ZyrYv59su8tvE0i05Tm9HdEfrI=;
        b=Y67p7RDmFZIftZpBkAU/JpHmbL7YhyWTzMHqa9zGACVDG2lqTrXWl7gJ9ueLggT2g8
         KUA0cgl5hKJx8ZZyPdfECWgN7wfO7RvOoXhpODnUJN0g1ubECGYDY4VJO/em1jEE13a8
         rBc3fY6B8NPX5NBsruYA9S+AMT76LcwGJsPsCovd7TQZEO8X1R/5yC+ZXi3vbEODXrMt
         a5MqUzkTe4gzWGer2iRgaXZsZ8QpqgK3oNKZ1M9nbsqe6XrYlefe7r0th1ngjvT9qWEg
         SIhg+GS6mY+3sPVzfqj1pn92fzaR44PHvcOcR78MJg8aUo/Q9gBheUXoK2wqLcUGT7p3
         vfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764817741; x=1765422541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ja0IQVgurSVBwpz+0ZyrYv59su8tvE0i05Tm9HdEfrI=;
        b=WkxWZq1kCkhmlHkd90iTbfXNNPiBr3l4ZbqidI6KJ7zpzrCmy6xot978zT+X3O/GKJ
         ESZKSnRearG/VIpra3n0ZFB0/xInuQTMCaa6e+CEgLhybVLlLLiBpjaAoov8P3EL7qXb
         rclB2GkqMuO4/T4WaISqN0rEh79isJbjRBLGbIcM3oaNU/rWxKRMg+kYFWQyOOSFV0Cq
         zQG9SwVn/+XbtUTYzWLCT4uM95xDTuvsehLVn1HFT8XMsAk5rtkAgUPC+oL1aYQzCUWz
         PjCsXeY93cDeyYaeyrmRXKwxE2lkSutzXV7A19IvipLpMvwlOSULxkJgWIuvum8+B9en
         Xqcw==
X-Gm-Message-State: AOJu0YxAvtutTaE4RpZMRoAF6Fp0nWNSKaRYG2ZDC29UIUw44/PiZ0OC
	j6f/bmoRqJNKufCq62JTdwB6vCQTtaWrJQymYe91CQ0kEGknJmRsku2tBZRRyubIcUwUsBPwx5M
	Vxcj3tzxH79eU/WBrs9Ts+mnB2JvdTvo=
X-Gm-Gg: ASbGncuD+zVcY6p2CCQwQIq+jkgSt4R9A3YEUj089ZDSom8ba/mvgWT5qrwLEy/W1iJ
	I63f9Q51qbWwfIOz2mFVpd0I/vvf5iDQ4Mt65Catkm8JI+NhgNvQhEQLat2qN9GCgCRGGqclV4O
	8Pp7iuReTMqKGeU/kxJM6A+BdenLlRLCBfbP/qLdK+YOf9gCU8SFZArw4pMpppOVYVDZEhNZxic
	WS/ckyhPfULXPqgq9BX4z1j2NgcXaG9Nc9wWqRnlkCLgZfyhfDn/yZI/6mb3io5GDpkNESJjQl/
	sHq3spBmwNME1++AYCDCxw3ZI54=
X-Google-Smtp-Source: AGHT+IFmtagxz4VFLxbTpUuFHSJsFE0lpixmHfn49cUjJMCxtcmYeEIvQlTZ0Tv8qwD2KG/C5OU6eK+AcUcEUfZ5ifU=
X-Received: by 2002:a05:6808:4fd4:b0:450:ccc6:4113 with SMTP id
 5614622812f47-45379e76627mr817111b6e.52.1764817741200; Wed, 03 Dec 2025
 19:09:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
In-Reply-To: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
From: Zheng Gu <cengku@gmail.com>
Date: Thu, 4 Dec 2025 11:08:50 +0800
X-Gm-Features: AWmQ_bn9GD-iXo82LDTgVADSbaDBF-B5ouo3adorbqbooF7Lvr0CAoUZBAH1ZCk
Message-ID: <CADSj-VrvbZGT0_gBwu-r++eSKbJvL+xNdJ_s8zVg4mvpOzK0fA@mail.gmail.com>
Subject: Re: [PATCH 1/3] dm-pcache: advance slot index before writing slot
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, chenl311@chinatelecom.cn, mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 10:57=E2=80=AFAM Dongsheng Yang <dongsheng.yang@linu=
x.dev> wrote:
>
> In dm-pcache, in order to ensure crash-consistency, a dual-copy scheme
> is used to alternately update metadata, and there is a slot index that
> records the current slot. However, in the write path the current
> implementation writes directly to the current slot indexed by slot
> index, and then advances the slot =E2=80=94 which ends up overwriting the
> existing slot, violating the crash-consistency guarantee.
>
> This patch fixes that behavior, preventing metadata from being
> overwritten incorrectly.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache.c         | 8 ++++----
>  drivers/md/dm-pcache/cache_segment.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index 698697a7a73c..9289c016b7c9 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -21,10 +21,10 @@ static void cache_info_write(struct pcache_cache *cac=
he)
>         cache_info->header.crc =3D pcache_meta_crc(&cache_info->header,
>                                                 sizeof(struct pcache_cach=
e_info));
>
> +       cache->info_index =3D (cache->info_index + 1) % PCACHE_META_INDEX=
_MAX;
> +
>         memcpy_flushcache(get_cache_info_addr(cache), cache_info,
>                         sizeof(struct pcache_cache_info));
> -
> -       cache->info_index =3D (cache->info_index + 1) % PCACHE_META_INDEX=
_MAX;
>  }
>
>  static void cache_info_init_default(struct pcache_cache *cache);
> @@ -93,10 +93,10 @@ void cache_pos_encode(struct pcache_cache *cache,
>         pos_onmedia.header.seq =3D seq;
>         pos_onmedia.header.crc =3D cache_pos_onmedia_crc(&pos_onmedia);
>
> +       *index =3D (*index + 1) % PCACHE_META_INDEX_MAX;
> +
>         memcpy_flushcache(pos_onmedia_addr, &pos_onmedia, sizeof(struct p=
cache_cache_pos_onmedia));
>         pmem_wmb();
> -
> -       *index =3D (*index + 1) % PCACHE_META_INDEX_MAX;
>  }
>
>  int cache_pos_decode(struct pcache_cache *cache,
> diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/=
cache_segment.c
> index f0b58980806e..ae57cc261422 100644
> --- a/drivers/md/dm-pcache/cache_segment.c
> +++ b/drivers/md/dm-pcache/cache_segment.c
> @@ -26,11 +26,11 @@ static void cache_seg_info_write(struct pcache_cache_=
segment *cache_seg)
>         seg_info->header.seq++;
>         seg_info->header.crc =3D pcache_meta_crc(&seg_info->header, sizeo=
f(struct pcache_segment_info));
>
> +       cache_seg->info_index =3D (cache_seg->info_index + 1) % PCACHE_ME=
TA_INDEX_MAX;
> +
>         seg_info_addr =3D get_seg_info_addr(cache_seg);
>         memcpy_flushcache(seg_info_addr, seg_info, sizeof(struct pcache_s=
egment_info));
>         pmem_wmb();
> -
> -       cache_seg->info_index =3D (cache_seg->info_index + 1) % PCACHE_ME=
TA_INDEX_MAX;
>         mutex_unlock(&cache_seg->info_lock);
>  }
>
> @@ -129,10 +129,10 @@ static void cache_seg_ctrl_write(struct pcache_cach=
e_segment *cache_seg)
>         cache_seg_gen.header.crc =3D pcache_meta_crc(&cache_seg_gen.heade=
r,
>                                                  sizeof(struct pcache_cac=
he_seg_gen));
>
> +       cache_seg->gen_index =3D (cache_seg->gen_index + 1) % PCACHE_META=
_INDEX_MAX;
> +
>         memcpy_flushcache(get_cache_seg_gen_addr(cache_seg), &cache_seg_g=
en, sizeof(struct pcache_cache_seg_gen));
>         pmem_wmb();
> -
> -       cache_seg->gen_index =3D (cache_seg->gen_index + 1) % PCACHE_META=
_INDEX_MAX;
>  }
>
>  static void cache_seg_ctrl_init(struct pcache_cache_segment *cache_seg)
> --
> 2.43.0
>

Nice catch!

Reviewed-by:  Zheng Gu <cengku@gmail.com>

Regards,
Gu
