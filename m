Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E506A8D2
	for <dm-devel@lists.linux.dev>; Wed, 27 Nov 2024 02:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732676384; cv=none; b=PQPy/F8rPeadKcThfs450yaBY4vaQdevH9QdjpHrRryOOwJbUsF2AV7qQHyCV0/mEBiOoCN4lY1w/Fi9OjQqlTUjEqJgxkGW8u2XPjwZUYc3rUfdj2zxN2Tm9sWoLFNFWYTyMGxKcWZ2cm6lpbqyD0BPClDYahsxTozan0F5wcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732676384; c=relaxed/simple;
	bh=UWmMiGZqLwobInZyxFH3bSZUtPpteFtRWw6WLfPhbAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bsx0vu+dztUwg4C/X77DZzhVmfg741V9FUrXfP9Y/z8HkhVJHYpxlPX3E1n4JYcYXlAYXewJnEt6eP2Bpk6UzApFvfX1x54WOoKZUlrEp3QM/MSU4YerZhwviFqrp15qBc0/2G0CYU0Zq6vCrUGIwycSuEGEMpmQpAgP8VwVHnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VNYEHVP2; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VNYEHVP2"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-724ffe64923so3633014b3a.2
        for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 18:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732676381; x=1733281181; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vDren5ADtiyyuDojahly2+sSPvL0WRct0w89l8MBRc4=;
        b=VNYEHVP22/QzxmpMoSss5V4Hh0BB32tqKL72Gc7ojoSKFCxcWIFn20cGFdGvfvdbii
         z+NM5/3Z0gerRwkqMeKC40/NIhbXCLypYc2VYhfRzOh0oqYyFfVKBViCKZnHmqDoGcsV
         C0RK9jQjqsh42SQliiQwrIfsT6FoHypMs6c3LPE9WLCZWjBdTeLO+3LXz2pFgYQhsces
         G6coh7uZ4UMowJ5Y2QrvTY04Y86XR12UI1orv0JFXC3FtCPugJc7ko/jDdImC76bRr4s
         2m3vAdDxbiAMBJYkJJ+rSu8ZeVlbbux4eA+XP3U0lb5SDL9ACulCDBhWhrbHAcZnj84W
         YOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732676381; x=1733281181;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vDren5ADtiyyuDojahly2+sSPvL0WRct0w89l8MBRc4=;
        b=tfq9nBOxUvgMBUUF6lYn9Pfbg+rq2HY9jlvSMcJSBVx+/fXPejCsekXn/kfRnlter+
         JyCVpfuCy6+ZwO0A/5e6tsXn+3oPCd04XR8fDCXBsRyJ3y59/r1wjLMzGGOkw82fD1mZ
         c9ZdxmgJs/Yf/6C0ZngBdHiBccLgVe28cK+uJ6y76w1EEOAHdyibTOUksZVt/Rj6R5wc
         1yv+yIKfq+oMCdD5d7DkeozpSzVITo7hYYAYDJckELafNxNUB++GihFDcf1ChBhJR+ej
         5sboyOkcpueXDH+oZZRDfDs0aTgcZIDkaum40YBc+ORdCykKZwJY7MpfvnX9U6C3Nqhp
         m5bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYpMFMktBafWpg/oLbWyRMl3VQMIaKW0S5naDkSCtZ2q4hrkKc3iyR8yV/ronHVi8Oq6+w9DL3/g==@lists.linux.dev
X-Gm-Message-State: AOJu0YxuzOdOleo6p30hv8v/sXex7PVcMBA2RD8+j8+Iu0WS70XF5lH0
	SXZRvb3Q1edUvrcnRF+YQCW+P8OnFezJjRPsJhGrss7jJ/Fe8+9M
X-Gm-Gg: ASbGncuJwg4QT83HwBBv7qaf/KQ3NjPbHGpcBREwZAACLYy+TUlrkMVQwibLdowuOdt
	s/gUSxy56af7ZoxuyjzSBbnDRE5QP74NAFy5wrNtqjE24mqf26atiA8rYP7g1gWd5JcIaZ63TI+
	GrAV5W0VtdtLOF0p6HL8nYYuerS+8V2l1sIr8LoPS+o75BfI8QUKIgcct65ddIbeorUgzrdQt73
	ltf8utDP8JIGOuTGbdaU5+vQWpt3MmwLQJbvvV9e0hW38tzlX+47LjULp5tFWFs7q+Rszg32ho2
	mw==
X-Google-Smtp-Source: AGHT+IFYiHisxMljvlFNcELzBIZNtvqA9E+SoH+TzdKr80+88ifldFSahzOnnXPVC3c2OejQpqXMZw==
X-Received: by 2002:a05:6a00:1da1:b0:725:3305:1a7e with SMTP id d2e1a72fcca58-72533051bb8mr723576b3a.9.1732676380691;
        Tue, 26 Nov 2024 18:59:40 -0800 (PST)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fbcc40143esm9471790a12.80.2024.11.26.18.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 18:59:40 -0800 (PST)
Date: Wed, 27 Nov 2024 10:59:34 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 01/10] lib/min_heap: Introduce non-inline versions of
 min heap API functions
Message-ID: <Z0aLFidHu/msXbXq@visitorckw-System-Product-Name>
References: <20241020040200.939973-1-visitorckw@gmail.com>
 <20241020040200.939973-2-visitorckw@gmail.com>
 <CAMuHMdVO5DPuD9HYWBFqKDHphx7+0BEhreUxtVC40A=8p6VAhQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdVO5DPuD9HYWBFqKDHphx7+0BEhreUxtVC40A=8p6VAhQ@mail.gmail.com>

Hi Geert,

On Tue, Nov 26, 2024 at 02:27:09PM +0100, Geert Uytterhoeven wrote:
> Hi Kuan-Wei,
> 
> On Sun, Oct 20, 2024 at 6:02 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> > All current min heap API functions are marked with '__always_inline'.
> > However, as the number of users increases, inlining these functions
> > everywhere leads to a increase in kernel size.
> >
> > In performance-critical paths, such as when perf events are enabled and
> > min heap functions are called on every context switch, it is important
> > to retain the inline versions for optimal performance. To balance this,
> > the original inline functions are kept, and additional non-inline
> > versions of the functions have been added in lib/min_heap.c.
> >
> > Link: https://lore.kernel.org/20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Thanks for your patch, which is now commit 92a8b224b833e82d
> ("lib/min_heap: introduce non-inline versions of min heap API
> functions") upstream.
> 
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> 
> > @@ -50,33 +50,33 @@ void __min_heap_init(min_heap_char *heap, void *data, int size)
> >                 heap->data = heap->preallocated;
> >  }
> >
> > -#define min_heap_init(_heap, _data, _size)     \
> > -       __min_heap_init((min_heap_char *)_heap, _data, _size)
> > +#define min_heap_init_inline(_heap, _data, _size)      \
> > +       __min_heap_init_inline((min_heap_char *)_heap, _data, _size)
> 
> Casting macro parameters without any further checks prevents the
> compiler from detecting silly mistakes.  Would it be possible to
> add safety-nets here and below, using e.g. container_of() or typeof()
> checks?

IIUC, the concern is that passing a pointer that is not of type
min_heap might lead to compiler errors being missed. To address this,
one possible solution could be to expand the members of struct min_heap
into individual parameters for the function.

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index e781727c8916..ebd577003f0b 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -207,18 +207,20 @@ static size_t parent(size_t i, unsigned int lsbit, size_t size)

 /* Initialize a min-heap. */
 static __always_inline
-void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
+void __min_heap_init_inline(int *heap_nr, int *heap_size, void **heap_data,
+			    void *heap_preallocated, void *data, int size)
 {
-	heap->nr = 0;
-	heap->size = size;
+	*heap_nr = 0;
+	*heap_size = size;
 	if (data)
-		heap->data = data;
+		*heap_data = data;
 	else
-		heap->data = heap->preallocated;
+		*heap_data = heap_preallocated;
 }

 #define min_heap_init_inline(_heap, _data, _size)	\
-	__min_heap_init_inline((min_heap_char *)_heap, _data, _size)
+	__min_heap_init_inline(&(_heap)->nr, &(_heap)->size, (void**)&(_heap)->data,	\
+			       &(_heap)->preallocated, _data, _size)

 /* Get the minimum element from the heap. */
 static __always_inline

Alternatively, we could use container_of() for type safety.

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index e781727c8916..fb96b1b82fb0 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -218,7 +218,7 @@ void __min_heap_init_inline(min_heap_char *heap, void *data, int size)
 }

 #define min_heap_init_inline(_heap, _data, _size)	\
-	__min_heap_init_inline((min_heap_char *)_heap, _data, _size)
+	__min_heap_init_inline(container_of(&(_heap)->nr, min_heap_char, nr), _data, _size)

 /* Get the minimum element from the heap. */
 static __always_inline

The first approach has better readability, while the second minimizes
the changes needed. Please let me know your thoughts.
> 
> > --- a/lib/Kconfig
> > +++ b/lib/Kconfig
> > @@ -777,3 +777,6 @@ config POLYNOMIAL
> >
> >  config FIRMWARE_TABLE
> >         bool
> > +
> > +config MIN_HEAP
> > +       bool
> 
> Perhaps tristate? See also below.
> 
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -2279,6 +2279,7 @@ config TEST_LIST_SORT
> >  config TEST_MIN_HEAP
> >         tristate "Min heap test"
> >         depends on DEBUG_KERNEL || m
> > +       select MIN_HEAP
> 
> Ideally, tests should not select functionality, to prevent increasing the
> attack vector by merely enabling (modular) tests.
> 
Makes sense. Thanks for catching this.

> In this particular case, just using "depends on MIN_HEAP" is not an
> option, as MIN_HEAP is not user-visible, and thus cannot be enabled
> by the user on its own.  However, making MIN_HEAP tristate could be
> a first step for the modular case.
> 
> The builtin case is harder to fix, as e.g.
> 
>         depends on MIN_HEAP || COMPILE_TEST
>         select MIN_HEAP if COMPILE_TEST
> 
> would still trigger a recursive dependency error.
> 
> Alternatively, the test could just keep on using the inline variants,
> unless CONFIG_MIN_HEAP=y? Or event test both for the latter?
> 
I think that having min_heap_test continue using the inline variants
might be the simplest solution?

Regards,
Kuan-Wei

> >         help
> >           Enable this to turn on min heap function tests. This test is
> >           executed only once during system boot (so affects only boot time),
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
