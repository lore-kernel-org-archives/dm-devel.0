Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAAD149C41
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729582333; cv=none; b=Gtp58Rx6+2DmvgBJI72e6hO5aGxv6rDt2QDTISn4rd+pTuZq53t18Y9AAFwuoyFv8huZ5VDF299n9J2M69Spj7XeMs1Cg3uwdQPQtUFrCJKgeT5tRFoC25kykSJtB6IA/bBn6UQHVLpdv4PfFeucAL5y+AJj1jIFOLenqWDQ/NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729582333; c=relaxed/simple;
	bh=0khxtXlcH4YZq+SUsGcI3toM97dhHFnlpOWK0nsY/Pc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mVOZA97NtwcpGknzZskAIFN+9nGkFKQAJtqpA0oQA2JyFHGu/T+ZLzzEccU+QQv1Dyhv+zVHV4esAVrZMaUGxm62wgDpecFEG70AHiPHDyPiq+2zeg+qVWRByjiLmR+6heNUAdiW/p36+xSohWZ1/FnyH5bmX0tTbicwVIB5kgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TiAWAeb5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TiAWAeb5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729582330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BkwhmghRoze7NMQMl45Lvu4r+gdOJIh721TBOvawelw=;
	b=TiAWAeb5Uu29GWr25DAaRucJFRU9blcWEHhz9EAwR3jteXun4l4WZ9T3Gh1MQiA67VvbsN
	zysCcHlJameD/ZbqgreI/cSv5Oncsy+ENeLmrg95v7scnLcV80NaclnLeghqFjXmoQNynG
	scEMIP1ww8evCKknF5T4/ubKJjb3Pcs=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-O2_gLAhFOIWrcBHSfYDJRQ-1; Tue, 22 Oct 2024 03:32:09 -0400
X-MC-Unique: O2_gLAhFOIWrcBHSfYDJRQ-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e2bd09d2505so4528625276.2
        for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 00:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729582328; x=1730187128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BkwhmghRoze7NMQMl45Lvu4r+gdOJIh721TBOvawelw=;
        b=r2Ovopj1y0Up35ZGrQaFpgsIWcruisU+xo5zICf/Q0LxYvOUBntgTlVj3XslCrj89M
         TA+F1Xqc/EpPsyjPU8WrTnlFSCn3BvTT7TBW68XEscQ487F/W/V4BMVGt+9Sjw5o0Qeh
         jWs/bhFut7huoKjyIOMjobytZdJMSyX5/Pw86Muccy+WmdrgYPn32whtwLnOdXMQv/jY
         9GHSJiELU0KxQazj8idwzmFozkTbQ/wC/3IDlCA9j9YQzfnfUOv36jgufMuBwqw2NUFj
         AYr67rbke2r0cAw5IbdHTR2ieMw3h5eDol981xNkvsfPwJlWqWVhQC5gmyZJAQOGPKfT
         LDMQ==
X-Gm-Message-State: AOJu0YyALhbBdqyTG0AU/szJjEhKGyFOjQHNolP1TE8rCaxQqqp95D2b
	/gNgceXx15AWxqarFqHxziylsRb7KreuYg4IUjQbBV2wV1E07pc+2b7TuYZMsd9/tt3NQxsGb4J
	I8GdU4RdGzirO+ulU8UHXdj9GMJBTQ/HTqZiW3aFEhJKVAX4askTLqX5GeAAqidFrHQ3+BRiPOB
	lgKFble7SRlNv2lj1j0kICOt2sKHnKXTU=
X-Received: by 2002:a05:6902:2381:b0:e2b:df1a:c012 with SMTP id 3f1490d57ef6-e2e271ca991mr1457856276.34.1729582328570;
        Tue, 22 Oct 2024 00:32:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEuLLpfbrkYCuLQbLsq/3bJyL+o1W7n5ad9VfGo9PfXGWQshdXetePM68KtXX2xkDoOTya+zOBT9oI429QqDU=
X-Received: by 2002:a05:6902:2381:b0:e2b:df1a:c012 with SMTP id
 3f1490d57ef6-e2e271ca991mr1457850276.34.1729582328288; Tue, 22 Oct 2024
 00:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241022071354.778749-1-mtsai@redhat.com>
In-Reply-To: <20241022071354.778749-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 22 Oct 2024 08:31:40 +0100
Message-ID: <CAJ0trDagr5towoCsracG20VHSaM5F0pMQ_n=VGc4udVdCzO37w@mail.gmail.com>
Subject: Re: [PATCH 5/5] dm cache: fix potential out-of-bounds access on the
 first resume
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ack

On Tue, Oct 22, 2024 at 8:14=E2=80=AFAM Ming-Hung Tsai <mtsai@redhat.com> w=
rote:
>
> Out-of-bounds access occurs if the fast device is expanded unexpectedly
> before the first-time resume of the cache table. This happens because
> expanding the fast device requires reloading the cache table for
> cache_create to allocate new in-core data structures that fit the new
> size, and the check in cache_preresume is not performed during the
> first resume, leading to the issue.
>
> Reproduce steps:
>
> 1. prepare component devices:
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
> dd if=3D/dev/zero of=3D/dev/mapper/cmeta bs=3D4k count=3D1 oflag=3Ddirect
>
> 2. load a cache table of 512 cache blocks, and deliberately expand the
>    fast device before resuming the cache, making the in-core data
>    structures inadequate.
>
> dmsetup create cache --notable
> dmsetup reload cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
> dmsetup reload cdata --table "0 131072 linear /dev/sdc 8192"
> dmsetup resume cdata
> dmsetup resume cache
>
> 3. suspend the cache to write out the in-core dirty bitset and hint
>    array, leading to out-of-bounds access to the dirty bitset at offset
>    0x40:
>
> dmsetup suspend cache
>
> KASAN reports:
>
>   BUG: KASAN: vmalloc-out-of-bounds in is_dirty_callback+0x2b/0x80
>   Read of size 8 at addr ffffc90000085040 by task dmsetup/90
>
>   (...snip...)
>   The buggy address belongs to the virtual mapping at
>    [ffffc90000085000, ffffc90000087000) created by:
>    cache_ctr+0x176a/0x35f0
>
>   (...snip...)
>   Memory state around the buggy address:
>    ffffc90000084f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>    ffffc90000084f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>   >ffffc90000085000: 00 00 00 00 00 00 00 00 f8 f8 f8 f8 f8 f8 f8 f8
>                                              ^
>    ffffc90000085080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>    ffffc90000085100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>
> Fix by checking the size change on the first resume.
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> Fixes: f494a9c6b1b6 ("dm cache: cache shrinking support")
> ---
>  drivers/md/dm-cache-target.c | 37 ++++++++++++++++--------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index fa8ef2c32af8..40709310e327 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2901,24 +2901,24 @@ static dm_cblock_t get_cache_dev_size(struct cach=
e *cache)
>  static bool can_resize(struct cache *cache, dm_cblock_t new_size)
>  {
>         if (from_cblock(new_size) > from_cblock(cache->cache_size)) {
> -               if (cache->sized) {
> -                       DMERR("%s: unable to extend cache due to missing =
cache table reload",
> -                             cache_device_name(cache));
> -                       return false;
> -               }
> +               DMERR("%s: unable to extend cache due to missing cache ta=
ble reload",
> +                     cache_device_name(cache));
> +               return false;
>         }
>
>         /*
>          * We can't drop a dirty block when shrinking the cache.
>          */
> -       new_size =3D to_cblock(find_next_bit(cache->dirty_bitset,
> -                                          from_cblock(cache->cache_size)=
,
> -                                          from_cblock(new_size)));
> -       if (new_size !=3D cache->cache_size) {
> -               DMERR("%s: unable to shrink cache; cache block %llu is di=
rty",
> -                     cache_device_name(cache),
> -                     (unsigned long long) from_cblock(new_size));
> -               return false;
> +       if (cache->loaded_mappings) {
> +               new_size =3D to_cblock(find_next_bit(cache->dirty_bitset,
> +                                                  from_cblock(cache->cac=
he_size),
> +                                                  from_cblock(new_size))=
);
> +               if (new_size !=3D cache->cache_size) {
> +                       DMERR("%s: unable to shrink cache; cache block %l=
lu is dirty",
> +                             cache_device_name(cache),
> +                             (unsigned long long) from_cblock(new_size))=
;
> +                       return false;
> +               }
>         }
>
>         return true;
> @@ -2949,20 +2949,15 @@ static int cache_preresume(struct dm_target *ti)
>         /*
>          * Check to see if the cache has resized.
>          */
> -       if (!cache->sized) {
> -               r =3D resize_cache_dev(cache, csize);
> -               if (r)
> -                       return r;
> -
> -               cache->sized =3D true;
> -
> -       } else if (csize !=3D cache->cache_size) {
> +       if (!cache->sized || csize !=3D cache->cache_size) {
>                 if (!can_resize(cache, csize))
>                         return -EINVAL;
>
>                 r =3D resize_cache_dev(cache, csize);
>                 if (r)
>                         return r;
> +
> +               cache->sized =3D true;
>         }
>
>         if (!cache->loaded_mappings) {
> --
> 2.47.0
>

