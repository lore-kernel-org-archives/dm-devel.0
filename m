Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627C513E8AE
	for <dm-devel@lists.linux.dev>; Mon, 29 Jul 2024 10:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722247684; cv=none; b=arJYwOlOs4otMqJ91sa6mudrVBvYv4UlVANHyK1DgH/TcZp3bxp4zhjXYIo43VfYyKZTjLX/bQJZCDb0uyeObjkI21ZrmMRNH//SXDZ4jMK9EaW3NCNlOD7EVB+IuUC+KvtcKKCx70G7zeA3rVA5X3oauSvvGg4JikymqM6YWGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722247684; c=relaxed/simple;
	bh=0Tuyx2oDUruZZ6uxuzgbNaLiuh970dbec3fFyh+TDOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pVIl2P25oZ85nEz40hKCZK33W+Nk25q/jX1xuchY11j8XoOw/jP2aviZcDUOGM71i8t1S1F0FLxkWxz8TC8G4TrWxnToYX+ncNx/a+YPkH7/BzGLGZcIdFE3JxMrg+k8oeZ6RnDEVVVQ6QtUsSZUOTcpioL4DbgGimStrYslwAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-65faa0614dbso19023807b3.2
        for <dm-devel@lists.linux.dev>; Mon, 29 Jul 2024 03:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722247680; x=1722852480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jwTfVYSGl0qov4UkTwnmIUGjC6ZGnXwHCwIWbd4QwcU=;
        b=RqHckWWyCp5nURkxk7rliQliNnedexTrUL0zfDQkmqjxNwX64PAf6Qiso3Rk8a7KsX
         O7u59rPxqhRzBUU95kK596dFqhG+c1CRfSZ8e6bo9UMwHfQikIUe32JbYkc9aHEnJiHp
         A6Onekqquh1R0bBzLsVOTIHzbHePeK5JIpCeEOgjRog9rOse98nuVYX9+xQgoDU5fdu/
         vNGQuQs+IAX6+5tOepfYDlftghzQ4rn6Gn2n5ppcq7WiYmegXhinVmDhhZx1bmuxGfxE
         sn/0xgLQ+jI/Qx76WMI4Og6zSGcA3NzRhAbWilzGBYaGci2uIWpjWnSzJWEEN2L3kI8U
         Qc6g==
X-Forwarded-Encrypted: i=1; AJvYcCX2m2iDIaaRm9f1cmedMiIQd3Jlgv+8RDYoqyN7kYuTDgEBNIAFUk6ncB93I5DGxGl4NdYxTLY/XTUKFufLk8wqtWZesqFtZyw=
X-Gm-Message-State: AOJu0YwVbPtpoaT0FlRssD9QiZwTvBXC8cwrWT0Rx0CTSTbY4NZjytaL
	hrIe71jSV0vG///c5yXUxnkgAuQqKZ1VF/e0L7pQp7VI4XlPuj+G1qR6Fg/E
X-Google-Smtp-Source: AGHT+IGeB8CRcxKIHQgBsSXyoVmH8MFlBCdIWS9E9+KwlqML/oQ83iJbb69nwXh8ZAEnrBKL26TN9w==
X-Received: by 2002:a05:690c:6c8c:b0:65f:ca2a:9d77 with SMTP id 00721157ae682-67a09783e65mr73719467b3.36.1722247679697;
        Mon, 29 Jul 2024 03:07:59 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6756c44dcb2sm19620797b3.146.2024.07.29.03.07.58
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 03:07:59 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6694b50a937so21588847b3.0
        for <dm-devel@lists.linux.dev>; Mon, 29 Jul 2024 03:07:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVqZDESJAjcS9Wb8p3qiJDBXRA8s1mmCoXqBzvbyuSuA3MdSPqYTQpS+F7hdv7iO0049wuFoLLr1hzRgcEvUdyZQqkxMRvsPig=
X-Received: by 2002:a05:690c:6203:b0:664:7b3d:a53f with SMTP id
 00721157ae682-67a0a7fba7cmr91084297b3.45.1722247678607; Mon, 29 Jul 2024
 03:07:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiyNokz0d3b=GRORij=mGvwoYHy=+bv6m2Hu_VqNdg66g@mail.gmail.com>
 <20240729092807.2235937-1-geert@linux-m68k.org> <bd4e9928-17b3-9257-8ba7-6b7f9bbb639a@linux-m68k.org>
 <502ee081-8e09-422a-a1f9-be40aeaa84fb@app.fastmail.com>
In-Reply-To: <502ee081-8e09-422a-a1f9-be40aeaa84fb@app.fastmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 29 Jul 2024 12:07:46 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUUepTM9v7Oyakv6XQg9iw7t08ggGX=K90zRXxm4Ffpjg@mail.gmail.com>
Message-ID: <CAMuHMdUUepTM9v7Oyakv6XQg9iw7t08ggGX=K90zRXxm4Ffpjg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v6.11-rc1
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mips@vger.kernel.org, 
	dm-devel@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-btrfs@vger.kernel.org, intel-xe@lists.freedesktop.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-hexagon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Mon, Jul 29, 2024 at 11:55=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrot=
e:
> On Mon, Jul 29, 2024, at 11:35, Geert Uytterhoeven wrote:
> >>  + /kisskb/src/kernel/fork.c: error: #warning clone3() entry point is =
missing, please fix [-Werror=3Dcpp]:  =3D> 3072:2
> >
> > sh4-gcc13/se{7619,7750}_defconfig
> > sh4-gcc13/sh-all{mod,no,yes}config
> > sh4-gcc13/sh-defconfig
> > sparc64-gcc5/sparc-allnoconfig
> > sparc64-gcc{5,13}/sparc32_defconfig
> > sparc64-gcc{5,13}/sparc64-{allno,def}config
> > sparc64-gcc13/sparc-all{mod,no}config
> > sparc64-gcc13/sparc64-allmodconfig
>
> Hexagon and NIOS2 as well, but this is expected. I really just
> moved the warning into the actual implementation, the warning
> is the same as before. hexagon and sh look like they should be
> trivial, it's just that nobody seems to care. I'm sure the
> patches were posted before and never applied.
>
> sparc and nios2 do need some real work to write and test
> the wrappers.
>
> It does look like CONFIG_WERROR did not fail the build before
> 505d66d1abfb ("clone3: drop __ARCH_WANT_SYS_CLONE3 macro")
> as it probably was intended.

Indeed. The actual regression is that this turned into a fatal error
with -Werror.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
