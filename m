Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A4043AC0
	for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 19:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721331677; cv=none; b=EmYiaqzz33G4VXQ1PnDircIvhE8jV9T6SUBsItaG2lSD3s3IDqXE57jdzN213YXncfd0C4SixAo64hxPx3TwT5zfEx/ElfMXh8Zv0jDdIm1BrZEYP3JAyxaR/R3nAJ2Nxh4N29Ye5D3p5wC47BzS8nm8pF04sGK6EvHxbfr3IHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721331677; c=relaxed/simple;
	bh=Bvc2yyuLBDtU/8yfTquRpIeufSmH6UKlYCzzyKf+fXs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LU0+/Gd/ReCPPiZj7UxlUDNR6nNYbFvkYGD0gXoTx4YUAO0ojXohunjI9GkzzuXm4ANHF9WAVHtUFNNIdeSLVzW5Vn8AyLUY/cAIMQcw38+wgNHqhUV7PaN7aUMDhWc/u67E1srGC0FeqTxq6/RoGN1tTfAM+HhcD0WeC5Nva8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LCB867R5; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LCB867R5"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2eee298bd2eso14653261fa.3
        for <dm-devel@lists.linux.dev>; Thu, 18 Jul 2024 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721331673; x=1721936473; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=M5llC+1DWBOfl88R0npAt7JUYs7dSuebDXjLtc1a5MM=;
        b=LCB867R5UjkWK64GblNfvtpjVbw0OY4WqjS7xFGMm++gcUHhGEuioJiGHWyMtF65uL
         toTCxmvFYYrYMS67BKGJ559EgP4Ujm52mPnK/ZiFun+kHDklE1ZrIyIZ3pmNkU/+vNSO
         3ns8EurwMIHUKkqqLtmMeRz+Hs1YA48lGNjs4fpHsNbhAWLHtIQV5Wn6eg192ODblEIx
         pmvurPMLvI0mYtGgZacumUvNL18CXNb2wVyWzZYP7rrjM3/2+fzqqSNHW9uQnABUt5sT
         bWTZveVIdOVbiiMg8mMFOCLx7XP2NgprVlAt8mcr+O43MVKrbV11HEEITTmZJmLNk3zt
         yd8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721331673; x=1721936473;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M5llC+1DWBOfl88R0npAt7JUYs7dSuebDXjLtc1a5MM=;
        b=iM8JjGh34DDCXeiws4nG7aodY4BBb7z8bzp2k4sIzZaWkLes/o9DexSPVcekMEB3PG
         UdrpNJWlEPonEkoV2LpOPrE9gG3VA5F0BDUrNWQU4nacgOf3oPlkqXXHmy9NAaH2Oh7E
         Ac3w6krX7Ca0bPzHELrcZ3fgjgPNNZ+GROxrK3lAW9kJzecj2jjDatSCgd8pbJkwVN3r
         T9pumrm0htkCCJkx62ZHZ/HHvvVaQ7lIuXQyu8urayFbDrPpvpmZjfIAvUUR+39viA6o
         hg3/tMKy/HiOzWQjBUX/q5MdqsFmskAjPVkyymaiegOQBv2sL9NMRbW2yJn73iJK6iZo
         RKJQ==
X-Gm-Message-State: AOJu0Yzo3Z2SRfR5bFGCczHU14RsLGLIeNRuq0YJdYojRyWAViF2z9mR
	6+9zxt533EGNS6+Csm81US1KUhlDtGvFwzq6Xu4xAJIOd2ndi0Psp9Je9FHVWBE=
X-Google-Smtp-Source: AGHT+IFOZt1U685N0ZPk9SxjUxuNdFOlJZ19IFNC6+tDTYLdP0kqU6PhFdMMQEXKzJX/70ozfL2gxQ==
X-Received: by 2002:a05:6512:3ba3:b0:52e:969c:db8a with SMTP id 2adb3069b0e04-52ee542d8bamr4187225e87.44.1721331673183;
        Thu, 18 Jul 2024 12:41:13 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5a2b3bbbf84sm259220a12.0.2024.07.18.12.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 12:41:12 -0700 (PDT)
Message-ID: <56b29449c1e7c9fd419ad15968d0a2776abee784.camel@suse.com>
Subject: Re: [PATCH v2 03/20] multipathd: remove checker restart optimization
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 18 Jul 2024 21:41:11 +0200
In-Reply-To: <20240717181106.2173527-4-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
	 <20240717181106.2173527-4-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-07-17 at 14:10 -0400, Benjamin Marzinski wrote:
> Future commits will make this optimization unusable.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 27 +++++----------------------
> =C2=A01 file changed, 5 insertions(+), 22 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 13ed6d05..eaef505a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2704,7 +2704,7 @@ checkerloop (void *ap)
> =C2=A0
> =C2=A0	while (1) {
> =C2=A0		struct timespec diff_time, start_time, end_time;
> -		int num_paths =3D 0, strict_timing, rc =3D 0, i =3D 0;
> +		int num_paths =3D 0, strict_timing, rc =3D 0;
> =C2=A0		unsigned int ticks =3D 0;
> =C2=A0		enum checker_state checker_state =3D CHECKER_STARTING;
> =C2=A0
> @@ -2723,7 +2723,7 @@ checkerloop (void *ap)
> =C2=A0			sd_notify(0, "WATCHDOG=3D1");
> =C2=A0#endif
> =C2=A0		while (checker_state !=3D CHECKER_FINISHED) {
> -			unsigned int paths_checked =3D 0;
> +			unsigned int paths_checked =3D 0, i;

Nit: To avoid a coverity warning for the "i--" statement below, you
need to use a signed int for "i".

I can change this later on.

Martin

> =C2=A0			struct timespec chk_start_time;
> =C2=A0
> =C2=A0			pthread_cleanup_push(cleanup_lock, &vecs-
> >lock);
> @@ -2733,28 +2733,11 @@ checkerloop (void *ap)
> =C2=A0			if (checker_state =3D=3D CHECKER_STARTING) {
> =C2=A0				vector_foreach_slot(vecs->pathvec,
> pp, i)
> =C2=A0					pp->is_checked =3D false;
> -				i =3D 0;
> =C2=A0				checker_state =3D CHECKER_RUNNING;
> -			} else {
> -				/*
> -				 * Paths could have been removed
> since we
> -				 * dropped the lock. Find the path
> to continue
> -				 * checking at. Since paths can be
> removed from
> -				 * anywhere in the vector, but can
> only be added
> -				 * at the end, the last checked path
> must be
> -				 * between its old location, and the
> start or
> -				 * the vector.
> -				 */
> -				if (i >=3D VECTOR_SIZE(vecs->pathvec))
> -					i =3D VECTOR_SIZE(vecs-
> >pathvec) - 1;
> -				while ((pp =3D VECTOR_SLOT(vecs-
> >pathvec, i))) {
> -					if (pp->is_checked =3D=3D true)
> -						break;
> -					i--;
> -				}
> -				i++;
> =C2=A0			}
> -			vector_foreach_slot_after (vecs->pathvec,
> pp, i) {
> +			vector_foreach_slot(vecs->pathvec, pp, i) {
> +				if (pp->is_checked)
> +					continue;
> =C2=A0				pp->is_checked =3D true;
> =C2=A0				rc =3D check_path(vecs, pp, ticks);
> =C2=A0				if (rc < 0) {

