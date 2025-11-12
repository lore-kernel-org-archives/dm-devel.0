Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC8727EFE9
	for <dm-devel@lists.linux.dev>; Wed, 12 Nov 2025 08:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762935870; cv=none; b=jX8bjB6LTgEgG4WTZr4sxt9VGZ+z3txsh0ITygaHMyIGqBagLOURqtZA4svzjBNS+JkaHRYIlMl/BAyqLJ7bx0lq/vSsqFmfI0KHR45qBYWJPEfDjzKovwxw1Hdt676rZE7oQEpnbI+rwYtDtj/hBM2riC0JArqkAbPYsJtwzw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762935870; c=relaxed/simple;
	bh=2hGy/y6GWB/3BVQmLh5g5L9C42SPXeblpDpl9ztl84E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+/KOcR3n7XSy1FWqAGMCk9kcgUXweXjewHnfMyu4IyT06h6DWe5Q4MD99KyHTFR68tF5HEmc8VSQUhOuoZbDrD2U3Qs14QAWLMfF6r4kttqAPO5hIAnDstdwh+OpeL4MUJSN8ppU3HTX9xobPPomWs8QWDomV1Fvz0lawce0cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLx51Yn2; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLx51Yn2"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c70b2839c7so282098a34.2
        for <dm-devel@lists.linux.dev>; Wed, 12 Nov 2025 00:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762935866; x=1763540666; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC0+9MNDnzyNqzZubxOrLmRyJcdQ84zI5Y3RJeI7EeU=;
        b=KLx51Yn2xTslYuGMogIy5ZTQTqAf0qjI9n6X5hzoTenNSKE4qwAb/Oww1whsDG3F6F
         SnfRnYwJgfZ8daRwALmfviehJ25FL8rt46tCaKbv5cuwHte4aJZF1Xt/TekSVbs7zQZ/
         g/Cq7ctWy92bpoEEuyQI+Sje3dloCMSNN91gJTedPZX3k0DRWdkY6iQVzOPkFQUgZbUd
         eYPbqC8K/A/LzbbriVFXf/rS+4fhzLLruPB5qwAZGbUrTDVM+VDfXoSLyoWXNyW3EONd
         aZ+egpGLoGnXTkOnLQSbUofV48vPJ2WiHmen6YEYHFk4u2KJaCD+S5DS4XzNoMIUUreu
         4iRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762935866; x=1763540666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eC0+9MNDnzyNqzZubxOrLmRyJcdQ84zI5Y3RJeI7EeU=;
        b=ejSIjMx7fk8sUzwmaVZxCjRxSZSoKWrtJ+zTD5jn+aE6iVxs2w9QRqc6l7L+eFSswd
         jWHSSBZUC63rwjHAoONOeT6KmBV4LSgGwiQiwlerxQuWOurxfz638vTcEjL2dcTTGdos
         XLNVNAV1HqHvP31Ag4h3lRZJEqUP+cGkD1LMDEE23Ox6DuUtGb08XIB8ZV65rm6LJJXL
         SFiQemSuwvBsSKK+Oi9MfD/Nzl4dlBwgvyvibFxlbLxWLWnG/eW63tzWSVRNTAXFf/jv
         1EEqbhidLwYtn/tk8ONVmx5FxAIUlm98nFdX80I4MSm04hzuMwaFlzh4dqwSdIb8PB36
         Wwbg==
X-Gm-Message-State: AOJu0YyQ5jy6FQGgnNFp4lypxCM25YdihXScqx1Rup/lLaAfMEcmIwuE
	Px9lWhK6fP+1+uFdTgbJ+4gV/vq9J+Pjjn2zMM0Khem258PoS5gl5HVFOs9HHt7L/4myPBwgGGg
	M2ung0RqJWtak9Hvu6vLIg1VYnbRQjIc=
X-Gm-Gg: ASbGncu9jP5qxou11o+NYrHR+GymrENNmmajIrGjKUayMmaeyzvfGvEIHkteOI5G3Ii
	QEYk5+zpAxzEX/gBMVt3wnsmjXRv5JrlBlyt480yiuy75a4usyG57DM3iim2Yv/xNeJpQv+sGGi
	zDjoopP0rchCxLrMpvAAz3ISfy0tYg/PKqjf7tR9JrFIxuXF+vo86PnrUk9SZRsK6TrXO1XUXKG
	yV9fwPIPkgxttzuFNv60F2/SFFTlTPFSril6NwAUbuTdKQJs7RK36F7eYdMyP2JOWc73bCfv+LH
	DPkkJQn2ApfXLg==
X-Google-Smtp-Source: AGHT+IH7g8AFP4FtAEniY6ui43Str9+Uk6vm5CFl/wqcfSOCHCFtpi/5pcVqWUwvGBHrOQm3LUnrVrAR00nZm8WGYoI=
X-Received: by 2002:a05:6808:3098:b0:450:2db2:72b1 with SMTP id
 5614622812f47-450745ba573mr935265b6e.46.1762935866595; Wed, 12 Nov 2025
 00:24:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111121337.1063443-1-me@linux.beauty> <20251111121337.1063443-4-me@linux.beauty>
In-Reply-To: <20251111121337.1063443-4-me@linux.beauty>
From: Zheng Gu <cengku@gmail.com>
Date: Wed, 12 Nov 2025 16:24:14 +0800
X-Gm-Features: AWmQ_bn_tpjynKvZXxIV4vbHcHa64h6cS4Z1tKzR2jhZzSlOa4zu3oRwBeQfppM
Message-ID: <CADSj-VoEF63HPCp5Uip2u94OVgkjbH+SZP6DP-JpCo7tRa6jvg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] dm-pcache: zero cache_info before default init
To: Li Chen <me@linux.beauty>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Dongsheng Yang <dongsheng.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 8:14=E2=80=AFPM Li Chen <me@linux.beauty> wrote:
>
> From: Li Chen <chenl311@chinatelecom.cn>
>
> pcache_meta_find_latest() leaves whatever it last copied into the
> caller=E2=80=99s buffer even when it returns NULL. For cache_info_init(),
> that meant cache->cache_info could still contain CRC-bad garbage when
> no valid metadata exists, leading later initialization paths to read
> bogus flags.
>
> Explicitly memset cache->cache_info in cache_info_init_default()
> so new-cache paths start from a clean slate. The default sequence
> number assignment becomes redundant with this reset, so it drops out.
>
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> ---
>  drivers/md/dm-pcache/cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index d516d4904227..698697a7a73c 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -181,7 +181,7 @@ static void cache_info_init_default(struct pcache_cac=
he *cache)
>  {
>         struct pcache_cache_info *cache_info =3D &cache->cache_info;
>
> -       cache_info->header.seq =3D 0;
> +       memset(cache_info, 0, sizeof(*cache_info));
>         cache_info->n_segs =3D cache->cache_dev->seg_num;
>         cache_info_set_gc_percent(cache_info, PCACHE_CACHE_GC_PERCENT_DEF=
AULT);
>  }
> --
> 2.51.0
>
It looks good to me.

Reviewed-by:  Zheng Gu <cengku@gmail.com>
