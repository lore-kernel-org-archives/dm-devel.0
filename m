Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031802F39C2
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 09:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783934801; cv=none; b=aJpQ6s12NzgPWLNwIvy+g48hJbP6l5Updvr0Krub3ZB4J8jvoGHJGpnBPMhw3BKwSXcmyBnDaDVmbdj77mqgBNcFI4FxpyT36XYFfX3I3fjSrMjSnArKgqKUNzXIaqZCg+hmYe8dmNMnVt8LQXRlMKSmBKMHHLC7FaShttf022w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783934801; c=relaxed/simple;
	bh=md6N0RCrvvJNB7WxjUvLI6ETC1E3qtlOXqIAEuYYhYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cgx3Lk/2FdXenzCeki1PR765ZDzl31HgWLR7FgeN+xSFBM2hhx6aOcDDrAxLrUfFBdhfnEBa1ugeMEzQV9aRY1yprRDweGuXP0czF2CEPA7w54udH31DeSTU7JDaAwUxzjIboWRq/NPov5NoofkFeqHmKIcu7CGlLUHpPVOgW3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnbpwTQt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnbpwTQt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783934798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z5hZtv4O7MDxRSw7Evhh+r3SzxTai94Z3EuWKtFv7aI=;
	b=JnbpwTQtgyU1x2+Q9Nw6zh5hG702NMk6tnejFw3N161ippnz13skVpG29bZ4neaNaiTuZF
	gZrIuCaUaHYrefuc7BWVat52HFdKFsFVRKFp7UhWXTtg7M5UKAOoMhCVsq2zJoGT5B304M
	ctTNb94rkyKIFj6UIwcmJ6xX8D3CgbI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-OqjREnLPMVm9zu5AtoEf2g-1; Mon, 13 Jul 2026 05:26:37 -0400
X-MC-Unique: OqjREnLPMVm9zu5AtoEf2g-1
X-Mimecast-MFC-AGG-ID: OqjREnLPMVm9zu5AtoEf2g_1783934796
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3998d89ef9eso11053651fa.1
        for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 02:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783934796; x=1784539596;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z5hZtv4O7MDxRSw7Evhh+r3SzxTai94Z3EuWKtFv7aI=;
        b=dLsLqsWJCxGcBYPmBK7IFZs/DTBj7U96S0OKnFokZzO03hpucDenH1vFqKcOLG4FZy
         6NMCImmLfkh1/C01SlHqtz6yDedeHFctRsbdRXN+7pi3UQADiNu+JdbSvjNC6eUEHJSK
         wCnr0pI7O+jrIa4IqbhmjJGP+kedMBA4IVbxMkwQum870mEoAtQEdiOhupKz5axWUYLS
         dcQ5oMs8Dd1axS6d1kd/73wDm10M0S0aLfPLaDvr0qIFC4xC3ZSZTKtmY+/ObRJ6uKcm
         vte00USHpCMPN280D07sQXDwDM1m2C5ZdKF5slHKLt1hh/yJ/1jtVozuEu7lC6XDxKNy
         sQ7w==
X-Forwarded-Encrypted: i=1; AHgh+RoytIgcNkeW5hZi9UovZaGh8vzOVCGAXJqIquN1TE7wUBAmoQLjQQcsVX+cijZvtXaH3GVCpDpYwg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw04ZXAAvR6rGQr2DIr8axbRQ+3e71FOogC7IGFggbjczJLNBWc
	OWlM6nFjXkVIDFDG0Ok7sW0WT8zKK87FMgkwXeQRVUz/a8MYbAeC9lmPNV05WDbKZK33MAB1mLk
	QtiEykzdrdS203Pj7GOdCdvrwBoZG+T52nFLJwWQSUOMbV36iUjNEwapxJVzAyXQg/xFYY2wFck
	HkXCC86hhcrlGq7zHBxVfi8x15tjg2ZtysdQ==
X-Gm-Gg: AfdE7cnrZVcGmGgIi70NQeAC9JJk7asgNbbQcSDD9YmaE3s/ICIlBnZZX87zFme37XA
	iLavgUOOCgKu7ZRjkJ43ch3NTX24ZpbANa2Ng+RQEUVrN70Af67e9UjsJFu9mttXe/hLGB9bjir
	xCKxhymcvHp9mltFgXv42ZzIZYsdjrzwKHXbQ9ynU7cXbj08pro1JSEBMEN3wme0OZnw==
X-Received: by 2002:a05:651c:254e:10b0:39c:828a:ec28 with SMTP id 38308e7fff4ca-39caa87c3f2mr13907791fa.31.1783934796172;
        Mon, 13 Jul 2026 02:26:36 -0700 (PDT)
X-Received: by 2002:a05:651c:254e:10b0:39c:828a:ec28 with SMTP id
 38308e7fff4ca-39caa87c3f2mr13907691fa.31.1783934795792; Mon, 13 Jul 2026
 02:26:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260711212849.92086.ae319593b1e2.dm-cache-invalidate-cblock-truncation@trailofbits.com>
In-Reply-To: <20260711212849.92086.ae319593b1e2.dm-cache-invalidate-cblock-truncation@trailofbits.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Mon, 13 Jul 2026 17:26:22 +0800
X-Gm-Features: AUfX_mxmw7fbXjZxLzo_ImWY0Bzim4q7K96FPSHOfyL84LgMoO5VLLCyUASIdaE
Message-ID: <CALjSBEvnJj=C4N1g2c7vuVorCA0vsSP=xNwQhDdChQTANTwadA@mail.gmail.com>
Subject: Re: [PATCH v3] dm cache: parse invalidate_cblocks with kstrtouint()
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5fw7dNClUqAcKT9bv0_Q3zlRetUieHhQTeVFaU5kgeg_1783934796
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2026 at 5:39=E2=80=AFAM Samuel Moelius
<sam.moelius@trailofbits.com> wrote:
>
> +       if (str) {
> +               blocknr =3D str;
> +
> +               r =3D kstrtouint(blocknr, 10, &e);
> +               if (r)
> +                       goto bad;
>
> -       if (r =3D=3D 1) {
> -               result->begin =3D to_cblock(b);
> -               result->end =3D to_cblock(from_cblock(result->begin) + 1u=
);
> +               result->end =3D to_cblock(e);
>                 return 0;
>         }
>
> -       DMERR("%s: invalid cblock range '%s'", cache_device_name(cache), =
str);
> +       result->end =3D cblock_succ(result->begin);
> +       return 0;

A minor nit: the range vs. single-value cases are peer alternatives.
Rather than multiple "returns 0", using if-else makes the parallel
structure more explicit: both paths share the same prologue (parse
result->begin) and epilogue (return 0), differ only in how result->end
is computed.

