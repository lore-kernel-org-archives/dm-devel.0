Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D7D1D5147
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 13:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732627646; cv=none; b=qgaSz6zdC+g0/+M/HlJdaVQYX4XnP2g2dTGEg4N/uyqqNTJ7tsxwad1JYP09QlrBFU2iESbMifQBlRVWLEHSBnkU9CdG9cSZZWyvUlKSBDfibRZ4q4G2xyPy6o8Z9WP2yaPFyvmWvk6l+AgMgR5bq6CZW2rUyTZl6sVFAG/7Ujg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732627646; c=relaxed/simple;
	bh=kB14QwEsljC+Ih1ESFLNWeIU3yAv12TYYWftsJsDocU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n1t3wSmiHPZip2/cgh2XfKTZPhmllKjGLqW5uYQjJNgxtD29PgGd6orIq2Dj48exyJCLvGqAk1aDgwFgPKsIybDWeVdczDrIZJdAoOLpIzqNag5YQ0d/wUKs3N1+lBeIdIxucJyFEW24Ybdz4RfqXT8D67Lbw1oBn7yMMUZVPM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6eebae6f013so57425107b3.0
        for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 05:27:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732627643; x=1733232443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdSJmr80vU+P2PQ4iahpq7fx/jHhWG8mOuWEpt3bZZI=;
        b=ZdIniAhUC6qWkuwgpVsozts9bsYwTGLluA2pU+FKfVER+KaF/phcKaR0C4/A32VK98
         HedrR7pZofalvkSBEavoxFvciatCV+P2hNR8B7L/whzDz55uEdDKNs6ltC2if4em2S4M
         TYWRCQRtsCILYJhm1dN7vtMj7HHClNt4oKIae1UdriDsY7rpYkgpBeex/zZm07kWjhW0
         tx4qPBJjLXp5QExiO6SLDBawrOA0OikjFOGS60jiVJM587/7/YJFTiwT+3f9BWaTvFbR
         uQvhhWRInQaAH1z1vvVlYjGvxIBUJ1GDV62dwtiSa0HDCg+DVj8DGLGSP/xfghgx/ST3
         e4PA==
X-Forwarded-Encrypted: i=1; AJvYcCXjpNV9YvXI9tBlhA5jVkZyE4niFu4zJYN6nDHfn1xpDghro/d0tP6xBaCI7MlQDEcXSDS2diVYgA==@lists.linux.dev
X-Gm-Message-State: AOJu0YyU5r0eMaLrVR7MONIYnShNe2Fo0OV5y+x1SU0vSMDBW/zAW9Bd
	bbo+vD9P8cG5YnfchmFV3jS9fk1p4UOVdfxE+4vaiNKB4gzC2g6fJ4EDxJJc
X-Gm-Gg: ASbGncs9RBW5S/kVivgfrXRW36m7q8Gy/wMtA2sAohRe09MB8JOBauxGrtRdPRTt4Ov
	u+MkTsgYrSvyH0RB84JCNF2IAWEChdtyuyr17Zi3lzFP5xUgO7oKYO8VMEz2pkpaS1Of3MxYV1v
	W0aH0jbThhMmCWUrzIDsU2s7hARTv4EKhb/t6KfHra+GaukMsE5boRytbyEwwWc7f8BHKd3rT7U
	jk7NywtXk34mVyhbZSso8foIbKrtXjzrEq01pu+SciDCg0qB3Kk/pAs7qb4zAU6r85vtaqF6mZP
	60n6jAH04PBL8PCq
X-Google-Smtp-Source: AGHT+IEu6F9R3Vht0+wXa7zbKfvBU8yFiivmBW8gO4W0NTaDxe1jg78t3WdBfP2pU9PB2YJNPs5WWg==
X-Received: by 2002:a05:690c:480a:b0:6e7:e1aa:ba80 with SMTP id 00721157ae682-6eee08a5a10mr163413257b3.18.1732627641794;
        Tue, 26 Nov 2024 05:27:21 -0800 (PST)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6eee00800e1sm22948487b3.83.2024.11.26.05.27.21
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 05:27:21 -0800 (PST)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6eebae6f013so57424517b3.0
        for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 05:27:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU0EXMSh6aH/5KnLkNfHKsv3FRDmIf55KzGmLVhwZ1UBIRIm8RvgE6uKylr9M8YtScOhL3ACy4oHA==@lists.linux.dev
X-Received: by 2002:a0d:d303:0:b0:6ea:807c:bbaa with SMTP id
 00721157ae682-6eee08825d3mr111480937b3.5.1732627641261; Tue, 26 Nov 2024
 05:27:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241020040200.939973-1-visitorckw@gmail.com> <20241020040200.939973-2-visitorckw@gmail.com>
In-Reply-To: <20241020040200.939973-2-visitorckw@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 26 Nov 2024 14:27:09 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVO5DPuD9HYWBFqKDHphx7+0BEhreUxtVC40A=8p6VAhQ@mail.gmail.com>
Message-ID: <CAMuHMdVO5DPuD9HYWBFqKDHphx7+0BEhreUxtVC40A=8p6VAhQ@mail.gmail.com>
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

On Sun, Oct 20, 2024 at 6:02=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
> All current min heap API functions are marked with '__always_inline'.
> However, as the number of users increases, inlining these functions
> everywhere leads to a increase in kernel size.
>
> In performance-critical paths, such as when perf events are enabled and
> min heap functions are called on every context switch, it is important
> to retain the inline versions for optimal performance. To balance this,
> the original inline functions are kept, and additional non-inline
> versions of the functions have been added in lib/min_heap.c.
>
> Link: https://lore.kernel.org/20240522161048.8d8bbc7b153b4ecd92c50666@lin=
ux-foundation.org
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Thanks for your patch, which is now commit 92a8b224b833e82d
("lib/min_heap: introduce non-inline versions of min heap API
functions") upstream.

> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h

> @@ -50,33 +50,33 @@ void __min_heap_init(min_heap_char *heap, void *data,=
 int size)
>                 heap->data =3D heap->preallocated;
>  }
>
> -#define min_heap_init(_heap, _data, _size)     \
> -       __min_heap_init((min_heap_char *)_heap, _data, _size)
> +#define min_heap_init_inline(_heap, _data, _size)      \
> +       __min_heap_init_inline((min_heap_char *)_heap, _data, _size)

Casting macro parameters without any further checks prevents the
compiler from detecting silly mistakes.  Would it be possible to
add safety-nets here and below, using e.g. container_of() or typeof()
checks?

> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -777,3 +777,6 @@ config POLYNOMIAL
>
>  config FIRMWARE_TABLE
>         bool
> +
> +config MIN_HEAP
> +       bool

Perhaps tristate? See also below.

> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2279,6 +2279,7 @@ config TEST_LIST_SORT
>  config TEST_MIN_HEAP
>         tristate "Min heap test"
>         depends on DEBUG_KERNEL || m
> +       select MIN_HEAP

Ideally, tests should not select functionality, to prevent increasing the
attack vector by merely enabling (modular) tests.

In this particular case, just using "depends on MIN_HEAP" is not an
option, as MIN_HEAP is not user-visible, and thus cannot be enabled
by the user on its own.  However, making MIN_HEAP tristate could be
a first step for the modular case.

The builtin case is harder to fix, as e.g.

        depends on MIN_HEAP || COMPILE_TEST
        select MIN_HEAP if COMPILE_TEST

would still trigger a recursive dependency error.

Alternatively, the test could just keep on using the inline variants,
unless CONFIG_MIN_HEAP=3Dy? Or event test both for the latter?

>         help
>           Enable this to turn on min heap function tests. This test is
>           executed only once during system boot (so affects only boot tim=
e),

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
