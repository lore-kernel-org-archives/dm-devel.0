Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B9B153812
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 08:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732694687; cv=none; b=qysptFDQBKBseSY3p1EZ8nEd7vJ5jYwW/+jRNtG8/t9xjqcoaBwtQ1LyOJD7Usny1PzByywXdKSOYHJgOn6POZhr6hk+uDG22WBSu0out9lYOxojahhMjjAsBadJzEJxoxZyyvxHU7+K0TZYGtAPi1zDXQkT9hO2R14x17a460g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732694687; c=relaxed/simple;
	bh=SXMUsolydLhLlh0RYa90/Fp6yYGJOG2VlShDRyUu/0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ofYIsyNy6/8LHRQ7iwK/zaLPa4R+Y4+4+LYV+NeiPuVoUvlpRQAJgKYxg1FIrjVeHoIzkxjp4ln6FKJ18tPMM02Wxfgiwd+5seosnHAA8ruCtjTIarDYN55hrGb8BTXehI0Br6Rsp0BWlNN9NpkeVtuZch7tvQ1IRg3ZktFTDkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ffd6b7d77aso5609761fa.0
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 00:04:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732694678; x=1733299478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJwxTYx2memGrlAcayO/d+D9wemFJ5kB8ER25ZwyFGQ=;
        b=NNcNFvuD9fyPZVZrsKacQq7qDxS7Js7fRsMjclFKHDXqFwNfEwOYNXZURSlCJh5+V6
         35O/Mp8ww2LR9fP5A8V86Q1ofJK1MEhPCNX3+3g2Ifw4wK+XwIUiiyvrDsiG64vA2Vwt
         P6O7f70cjINAYGCnjuQ0JzftXsYU/bN3kcOV6m/mSF2wJDN9e5JhpcnTZuUOUAIVcYJ9
         0gBHQmRnt8BvtnBcVLrgm78d4jx+BdF4HrVzxY4LkO2H7NmTDRBk7eZ7+x+//4j6yZau
         98Qe1vgfNPZQXeCsJJdcy8AWaRDxxbvyQJShiWZsIQB/XaFYXVh+/k+vr0EydgZ1n5G+
         eLKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVllxHHDPZRMuj7PnvELeIk2auhxdDB1SWUY4lCvnL3jZhIPMC1F5EtcRCKnPyCfS6dbeqfOGrrMA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwznhSHE5utFkGpQLxAQuUlRB/AvLhzd1yHDcsMipH1GwpwEy/j
	FDEUtwGD48s5CyrF0v4I2WpU/sRV6FcDwyEPKAiEtRBUheRDvL+uyxKJNz8/XB7cSA==
X-Gm-Gg: ASbGncvzhzcVCXNlvlVKxI7inaX9mRLlf4NFmU4+b4MS4go7ymb3EWkwdgWKxclk1Mj
	X6iuLJAqTAkZUREdXUp6nkHlJHXtKR9uT3je/rVpdtR0W70UNC7vFsHTK0F52ArTCtP/PwcAnFR
	mw6kk5xZ6EeuxAc35MCRFGqHI84yY7XazseYcj6T94vKrrvy5si4cdt8qB4oCSHE927uiQznOpo
	2ayySUlIguz7I6JeSMdDgOQxTJii875VNRhIkko8YMc6gQyG8n4ty/DHbKEWY6HoGOyKhvTH5vp
	WOm0Hvl0zLyq
X-Google-Smtp-Source: AGHT+IHyOuRurg40SVxUdAyVuaK1t9ME/TgViN+DE1+l3ZWwjK+BRsnhHf0965hVWI/bnyd1yFPhCQ==
X-Received: by 2002:a05:6512:20cb:b0:53d:eef6:bb6a with SMTP id 2adb3069b0e04-53df01148a9mr821480e87.54.1732694677371;
        Wed, 27 Nov 2024 00:04:37 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa53e87d050sm472120966b.188.2024.11.27.00.04.34
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 00:04:34 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a68480164so885817566b.3
        for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 00:04:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWKer6ydRa1LNJFVrsg6jpNv3sgufeYwuA8S9udhI/DcI+kYzc9xEKzGPC6nUKqIEY3w+6UFCu9+A==@lists.linux.dev
X-Received: by 2002:a17:906:5a6b:b0:a99:fc3d:7c76 with SMTP id
 a640c23a62f3a-aa581057f64mr101384466b.37.1732694673930; Wed, 27 Nov 2024
 00:04:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241020040200.939973-1-visitorckw@gmail.com> <20241020040200.939973-2-visitorckw@gmail.com>
 <CAMuHMdVO5DPuD9HYWBFqKDHphx7+0BEhreUxtVC40A=8p6VAhQ@mail.gmail.com> <Z0aLFidHu/msXbXq@visitorckw-System-Product-Name>
In-Reply-To: <Z0aLFidHu/msXbXq@visitorckw-System-Product-Name>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 Nov 2024 09:04:19 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUVfQvA_d+ERuqRbd_aRVabUX4N=kKd+gc7RK+EArwi+w@mail.gmail.com>
Message-ID: <CAMuHMdUVfQvA_d+ERuqRbd_aRVabUX4N=kKd+gc7RK+EArwi+w@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] lib/min_heap: Introduce non-inline versions of
 min heap API functions
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com, acme@kernel.org, 
	namhyung@kernel.org, akpm@linux-foundation.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com, kan.liang@linux.intel.com, willy@infradead.org, 
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-doc@vger.kernel.org, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuan-Wei,

On Wed, Nov 27, 2024 at 3:59=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
> On Tue, Nov 26, 2024 at 02:27:09PM +0100, Geert Uytterhoeven wrote:
> > On Sun, Oct 20, 2024 at 6:02=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail=
.com> wrote:
> > > All current min heap API functions are marked with '__always_inline'.
> > > However, as the number of users increases, inlining these functions
> > > everywhere leads to a increase in kernel size.
> > >
> > > In performance-critical paths, such as when perf events are enabled a=
nd
> > > min heap functions are called on every context switch, it is importan=
t
> > > to retain the inline versions for optimal performance. To balance thi=
s,
> > > the original inline functions are kept, and additional non-inline
> > > versions of the functions have been added in lib/min_heap.c.
> > >
> > > Link: https://lore.kernel.org/20240522161048.8d8bbc7b153b4ecd92c50666=
@linux-foundation.org
> > > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> >
> > Thanks for your patch, which is now commit 92a8b224b833e82d
> > ("lib/min_heap: introduce non-inline versions of min heap API
> > functions") upstream.
> >
> > > --- a/include/linux/min_heap.h
> > > +++ b/include/linux/min_heap.h
> >
> > > @@ -50,33 +50,33 @@ void __min_heap_init(min_heap_char *heap, void *d=
ata, int size)
> > >                 heap->data =3D heap->preallocated;
> > >  }
> > >
> > > -#define min_heap_init(_heap, _data, _size)     \
> > > -       __min_heap_init((min_heap_char *)_heap, _data, _size)
> > > +#define min_heap_init_inline(_heap, _data, _size)      \
> > > +       __min_heap_init_inline((min_heap_char *)_heap, _data, _size)
> >
> > Casting macro parameters without any further checks prevents the
> > compiler from detecting silly mistakes.  Would it be possible to
> > add safety-nets here and below, using e.g. container_of() or typeof()
> > checks?
>
> IIUC, the concern is that passing a pointer that is not of type
> min_heap might lead to compiler errors being missed. To address this,

Exactly.

> one possible solution could be to expand the members of struct min_heap
> into individual parameters for the function.
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index e781727c8916..ebd577003f0b 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -207,18 +207,20 @@ static size_t parent(size_t i, unsigned int lsbit, =
size_t size)
>
>  /* Initialize a min-heap. */
>  static __always_inline
> -void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
> +void __min_heap_init_inline(int *heap_nr, int *heap_size, void **heap_da=
ta,
> +                           void *heap_preallocated, void *data, int size=
)
>  {

Which means all functions and users must be updated now, and possibly
again in the future (when there is ever a need to change the struct).

> Alternatively, we could use container_of() for type safety.
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index e781727c8916..fb96b1b82fb0 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -218,7 +218,7 @@ void __min_heap_init_inline(min_heap_char *heap, void=
 *data, int size)
>  }
>
>  #define min_heap_init_inline(_heap, _data, _size)      \
> -       __min_heap_init_inline((min_heap_char *)_heap, _data, _size)
> +       __min_heap_init_inline(container_of(&(_heap)->nr, min_heap_char, =
nr), _data, _size)
>
>  /* Get the minimum element from the heap. */
>  static __always_inline
>
> The first approach has better readability, while the second minimizes
> the changes needed. Please let me know your thoughts.

container_of() is a well-known idiom in the Linux kernel, so I would go
for this solution, for min_heap_init_inline() and all other functions
currently using such a cast.

> > > --- a/lib/Kconfig
> > > +++ b/lib/Kconfig
> > > @@ -777,3 +777,6 @@ config POLYNOMIAL
> > >
> > >  config FIRMWARE_TABLE
> > >         bool
> > > +
> > > +config MIN_HEAP
> > > +       bool
> >
> > Perhaps tristate? See also below.
> >
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -2279,6 +2279,7 @@ config TEST_LIST_SORT
> > >  config TEST_MIN_HEAP
> > >         tristate "Min heap test"
> > >         depends on DEBUG_KERNEL || m
> > > +       select MIN_HEAP
> >
> > Ideally, tests should not select functionality, to prevent increasing t=
he
> > attack vector by merely enabling (modular) tests.
> >
> Makes sense. Thanks for catching this.
>
> > In this particular case, just using "depends on MIN_HEAP" is not an
> > option, as MIN_HEAP is not user-visible, and thus cannot be enabled
> > by the user on its own.  However, making MIN_HEAP tristate could be
> > a first step for the modular case.
> >
> > The builtin case is harder to fix, as e.g.
> >
> >         depends on MIN_HEAP || COMPILE_TEST
> >         select MIN_HEAP if COMPILE_TEST
> >
> > would still trigger a recursive dependency error.
> >
> > Alternatively, the test could just keep on using the inline variants,
> > unless CONFIG_MIN_HEAP=3Dy? Or event test both for the latter?
> >
> I think that having min_heap_test continue using the inline variants
> might be the simplest solution?

As lib/min_heap.c contains just wrappers around the inline functions,
that would be fine for me.  If/when lib/min_heap.c gains more
functionality, tests for that can be added to lib/test_min_heap.c
inside an #ifdef CONFIG_MIN_HEAP/#endif block.

Thanks!

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
