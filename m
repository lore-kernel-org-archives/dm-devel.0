Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BB9142E9F
	for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 07:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729582296; cv=none; b=fX8Ec3uNsMw3YUrlwUnl2kCKT1UUDY9UHfV1cGpOyr88Q23wHX6cNA64nCoBt1kcXqbnkC+GVvTC1JuWBTTm/4oGACi2x1Lc7J9i5Fdx6FF2DN7WgQDbW79il6i4UzFG991MRsJm11KmugIQhIymR3iY6TTKzfYROZr16Lb4nEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729582296; c=relaxed/simple;
	bh=IbmXcW484o7GGS0hGid7NaS+HBkSTtfwVJ837qkk1gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tkK4Jyr6NHdvSZoA+/b2n6uoKkAPE2dR9U2EbzgG2z5zbowohfXePh226gvmJQoUvfdzQ87gFCHQOS+xNHjTbmJCpZibcU0kfJ461s+iYlSC6KdxwXAyiO7rRclyVOLxjY0SEjyxXEyDBMsMAtUjH2n+QNXI9iunGHP8GQFPY3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8ZFS19I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8ZFS19I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729582293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GkH/gvdcQ+8sOERbD3JuoMS2kY6Yrv0BnJYwqfJUKIw=;
	b=G8ZFS19IsOOuRRoKobafsK/IVFp41r65BjxnaJA2Z+bJ5OtQjOOIWH+ODLwfcfj4z+AkQd
	vZC6Aw2FTk3vuj/3fOu0i26GiytWOWEfm2bFVDtA8rx+KkOAanpylplVxJP7XqvLM6TVna
	rB4iCY8k+7x211GMAnxvn9m6CoQ6F+Y=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-LgPGLehdNTOlSFmY9X4mBw-1; Tue, 22 Oct 2024 03:31:32 -0400
X-MC-Unique: LgPGLehdNTOlSFmY9X4mBw-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e02b5792baaso7497920276.2
        for <dm-devel@lists.linux.dev>; Tue, 22 Oct 2024 00:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729582291; x=1730187091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GkH/gvdcQ+8sOERbD3JuoMS2kY6Yrv0BnJYwqfJUKIw=;
        b=SflmzKhBE/0PpIfDc4swxvbpS8vMH/dUfE4YjrWsP3Ea61QYPl6EUBR2bBGbMCzz1D
         VC97N5eX0QhA07QsS1HOgPnrLR/9SI6VU3jJb0EDYkorxDqTAvW7fQa7K7v0gDOJsp10
         z849vIkaeSFSeqbzId4ibfyW6M78PzOYJSKub+WdSUDs/0j6iH0ZkaLZWDS4GIIViqw0
         SFFMUjCg+TmslVbi+4AI6jgTyLr9M1O/6D6/KXNG10ZxaHG6ONTEzzq52zj3Vccqi40y
         BJd85UMxZMuTy9PsITagpwI8T+qzx2h6CU8XxDY560ruY3bfr/aVDzlO9O2J6lgmJ6l8
         wPaw==
X-Gm-Message-State: AOJu0YwdoYz0Y8QPpfDi8eIgEJn1vbuLO9lnKyXAV97hBhObLQV/sjUd
	739lbHzT4nT+FC48OTWrKqmcHw+yLqvJjRxx6OR1sTH9GwSdqVnHGIjyNTIuOybNGoUbW1/A8Ma
	IBnAGnOi4FIs9cveT9AF37u9pB5X6G+MpabBItzUOd/jlvhvPardrfRNf9wa8mmOM20MPAuuLW8
	Ylsw02fwQQlumjzz8rC7A7YqeV0U3FzaQ=
X-Received: by 2002:a05:6902:1006:b0:e28:ea65:d1c0 with SMTP id 3f1490d57ef6-e2bb16d4863mr10548584276.54.1729582291570;
        Tue, 22 Oct 2024 00:31:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcuRbkkF5zH08TreTbM1oBYULWBdKUp1toN3foo5BOGHDOwzOWFPu2xXW9FZm6cCWidgd0z2dW83eDchX652o=
X-Received: by 2002:a05:6902:1006:b0:e28:ea65:d1c0 with SMTP id
 3f1490d57ef6-e2bb16d4863mr10548572276.54.1729582291265; Tue, 22 Oct 2024
 00:31:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241022071339.778721-1-mtsai@redhat.com>
In-Reply-To: <20241022071339.778721-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 22 Oct 2024 08:31:03 +0100
Message-ID: <CAJ0trDas+j=Tu2Toe76Vw_tXBFQv2UxFjzsCUbp11OviK=baGg@mail.gmail.com>
Subject: Re: [PATCH 4/5] dm cache: optimize dirty bit checking with
 find_next_bit when resizing
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
> When shrinking the fast device, dm-cache iteratively searches for a
> dirty bit among the cache blocks to be dropped, which is less efficient.
> Use find_next_bit instead, as it is twice as fast as the iterative
> approach with test_bit.
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> ---
>  drivers/md/dm-cache-target.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
> index 1fcd8c5c220e..fa8ef2c32af8 100644
> --- a/drivers/md/dm-cache-target.c
> +++ b/drivers/md/dm-cache-target.c
> @@ -2911,14 +2911,14 @@ static bool can_resize(struct cache *cache, dm_cb=
lock_t new_size)
>         /*
>          * We can't drop a dirty block when shrinking the cache.
>          */
> -       while (from_cblock(new_size) < from_cblock(cache->cache_size)) {
> -               if (is_dirty(cache, new_size)) {
> -                       DMERR("%s: unable to shrink cache; cache block %l=
lu is dirty",
> -                             cache_device_name(cache),
> -                             (unsigned long long) from_cblock(new_size))=
;
> -                       return false;
> -               }
> -               new_size =3D to_cblock(from_cblock(new_size) + 1);
> +       new_size =3D to_cblock(find_next_bit(cache->dirty_bitset,
> +                                          from_cblock(cache->cache_size)=
,
> +                                          from_cblock(new_size)));
> +       if (new_size !=3D cache->cache_size) {
> +               DMERR("%s: unable to shrink cache; cache block %llu is di=
rty",
> +                     cache_device_name(cache),
> +                     (unsigned long long) from_cblock(new_size));
> +               return false;
>         }
>
>         return true;
> --
> 2.47.0
>

