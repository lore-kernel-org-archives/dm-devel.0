Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C154B13AD0
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729582272; cv=none; b=pwz/O1HWn4UHqNJbSIQcyC4nEQ/gNEzGopWtNl+r/OmDQukF5syDu3fAGlNZ/OnYxa1KOvGpoJFRUIsC7/8dAGRAUdnkk+zeFo0Q0xDy3i5Apubi/VcTCowlH3isEcrJNMTdIcB7VsqyWs38yd3CVpk5P33ETLg3HaQW86LwXH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729582272; c=relaxed/simple;
	bh=rGuZ9yl+B2njoxmmjH60bJsMobqovPk/wpXgHB2SU6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=elMUZYZCr2M60vv3+ZVctYdHP5omRZgY1h+lKCdpjjnQaaJghRwt4GMKE+uUQWgJI/o2C8mEKUu3iTLrIW3LCtU6/n0GzFb7PT+ae1Thfw2/Rn5HHCVh/UC6YMQTzMeHn9AiHqpDHx19fOsmiRiU5mvx/0HSJkU+lRo59/DNgYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CBDHGomo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CBDHGomo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729582269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cbk6fkpFoEHbR+DhNEHiV/3bbCz9aFBsaWNCRer2BV0=;
	b=CBDHGomoUanzTGegQPg7ONr3Mj5gZ7chjC0MsAu72CxVUaZaDqoi5VUDXc0AWXWNYO087F
	CqHM3LwrBbHOrOKnd3oEyImtyAWHkAIWwLY1Yv0s75kzYc7BJ+kpk2xkalrmaJQPEytf3m
	HvGqxrYME40v8jaGh9sWNONeOTIXwkI=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-QjB82R8ZPFSglvteEc8qYg-1; Tue, 22 Oct 2024 03:31:08 -0400
X-MC-Unique: QjB82R8ZPFSglvteEc8qYg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-690404fd230so104140197b3.3
        for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 00:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729582268; x=1730187068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cbk6fkpFoEHbR+DhNEHiV/3bbCz9aFBsaWNCRer2BV0=;
        b=ao4McHHunOyH2uMCjvfE4yGN5a9ENCCpZ0q53pottFVFpjfSgHVAubMbByUkvTuZg1
         X7zS+JHntbY5AWb9IJD1uaM/WL76eo3NL6KLyXsgabAi+j9ZBCJkaU6Vhuv8/Gnplhfy
         NZknO8It2hqHRDnE8B1HP0R6DPPtvRvsuaRKI67SAQJC2ma7jCpVl95pVN4ttmfj0wQa
         XXGLh+gvuO4m0V0PEBiDqOMGuSq2IRfyrFJvjMV+nXTXc6FoSz1bpkCpNzUCWmNSOPgu
         rMIqRRM3g7k1Ps9GMtWuWlfRi02xapuJbWTqAjrm0cJQPY5aYOhsMRLp2aIAQXdi63og
         FLxA==
X-Gm-Message-State: AOJu0YzZzP8fKUijX4NOzQ1VL4nvgseUcKKG+xzr4kFx540mHPgOrj4O
	xpFL+g3hMsWROQ0TtB9GSopkewygzdtIgo7s+SECl8MS+CDL5lMUbh58HZVTcC/JOIOyerO3QRD
	74rnQTgVEZAh1+h77OAqeR3s22I1I9L1MUPtA5aLOaf9OhUrJgFND2WHVCe4j3XxT9ZXi4h+Lx1
	Yz3DtJXLp4uamjHvOwcolZ8lsVxdTeSHo=
X-Received: by 2002:a5b:c11:0:b0:e2b:d5cc:15e0 with SMTP id 3f1490d57ef6-e2e2742e4famr1140262276.42.1729582267831;
        Tue, 22 Oct 2024 00:31:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCNHsDDf1R4RX2+TnAwH0ZERX3nATjkH5gBDtfKV5lkxKKO9ClD3lOvBZjBD0QPaXZHjik1gDANgGVAiBWCyI=
X-Received: by 2002:a5b:c11:0:b0:e2b:d5cc:15e0 with SMTP id
 3f1490d57ef6-e2e2742e4famr1140250276.42.1729582267522; Tue, 22 Oct 2024
 00:31:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241022071316.778660-1-mtsai@redhat.com>
In-Reply-To: <20241022071316.778660-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 22 Oct 2024 08:30:39 +0100
Message-ID: <CAJ0trDYEVnPBCkmjVJtHHiKm_R3sGB8eAHUc0GS1=trs8cFGUg@mail.gmail.com>
Subject: Re: [PATCH 3/5] dm cache: fix out-of-bounds access to the dirty
 bitset when resizing
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ack

On Tue, Oct 22, 2024 at 8:13=E2=80=AFAM Ming-Hung Tsai <mtsai@redhat.com> w=
rote:
>
> dm-cache checks the dirty bits of the cache blocks to be dropped when
> shrinking the fast device, but an index bug in bitset iteration causes
> out-of-bounds access.
>
> Reproduce steps:
>
> 1. create a cache device of 1024 cache blocks (128 bytes dirty bitset)
>
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> dmsetup create cdata --table "0 131072 linear /dev/sdc 8192"
> dmsetup create corig --table "0 524288 linear /dev/sdc 262144"
> dd if=3D/dev/zero of=3D/dev/mapper/cmeta bs=3D4k count=3D1 oflag=3Ddirect
> dmsetup create cache --table "0 524288 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 128 2 metadata2 writethrough smq 0"
>
> 2. shrink the fast device to 512 cache blocks, triggering out-of-bounds
>    access to the dirty bitset (offset 0x80)
>
> dmsetup suspend cache
> dmsetup reload cdata --table "0 65536 linear /dev/sdc 8192"
> dmsetup resume cdata
> dmsetup resume cache
>
> KASAN reports:
>
>   BUG: KASAN: vmalloc-out-of-bounds in cache_preresume+0x269/0x7b0
>   Read of size 8 at addr ffffc900000f3080 by task dmsetup/131
>
>   (...snip...)
>   The buggy address belongs to the virtual mapping at
>    [ffffc900000f3000, ffffc900000f5000) created by:
>    cache_ctr+0x176a/0x35f0
>
>   (...snip...)
>   Memory state around the buggy address:
>    ffffc900000f2f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>    ffffc900000f3000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>   >ffffc900000f3080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>                      ^
>    ffffc900000f3100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>    ffffc900000f3180: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>
> Fix by making the index post-incremented.
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> Fixes: f494a9c6b1b6 ("dm cache: cache shrinking support")
> ---
>  drivers/md/dm-cache-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 68e9a1abd303..1fcd8c5c220e 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2912,13 +2912,13 @@ static bool can_resize(struct cache *cache, dm_cb=
lock_t new_size)
>          * We can't drop a dirty block when shrinking the cache.
>          */
>         while (from_cblock(new_size) < from_cblock(cache->cache_size)) {
> -               new_size =3D to_cblock(from_cblock(new_size) + 1);
>                 if (is_dirty(cache, new_size)) {
>                         DMERR("%s: unable to shrink cache; cache block %l=
lu is dirty",
>                               cache_device_name(cache),
>                               (unsigned long long) from_cblock(new_size))=
;
>                         return false;
>                 }
> +               new_size =3D to_cblock(from_cblock(new_size) + 1);
>         }
>
>         return true;
> --
> 2.47.0
>

