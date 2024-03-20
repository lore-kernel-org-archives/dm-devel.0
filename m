Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAAE1364
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 02:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710903414; cv=none; b=a0Lew8BpdR9S6REb4qFazGNsLfV83vHh/ydh4P9jGxMGIC58wi+zHBH4cSag6a2KLlOiAEDWHgl+w+7efzRmVTmC3ALonE37JrxMKOBgw2uyac/w/vTps+myDRKRMLR569gmCevYosjko3ocbcnpMSG+EX4oTXLWvplCsnf7gY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710903414; c=relaxed/simple;
	bh=QB2rQUbSStW7n4EoQ3DbUud+Rx1zHt6q2tLkyIr7z1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5OqkoqhekQhd4m6YU2WxuaVtcN6yJiJs9/KSZjP6IDx3xGT9HkHr+7rqKWeWmwtysBrm8PGO+jL3vEw4sLxwEeL1FwyBFER55c9arMuQwZ92iPuO1PCY15hWrimEFrrvJTDFNpnT86xlPV+LJsayoqLasS9oTbQDZYgYwPPaN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jtjv/Tc5; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jtjv/Tc5"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so2028261a91.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 19:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710903412; x=1711508212; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qsOh/COH4UX9LhObfLCurk23uZsxjWsmdSmkDaZcSnQ=;
        b=Jtjv/Tc5Aet8rawOBNRKF/Ds2tDAg6GZLpvYSW7I4yWeAOwe6AkIJPpq8e1aPVS/bk
         5swFLLRj4rv0KXXsq3vfKQbWmm8X2QxZ9fGLUYIrCkLIh1/ynFhLzX/538+WOCsqzbmC
         J6sqjfOp9vXHBXgvmcfIcfhGr0TGnIhVQQGRVYFSFVh+s3TheommuayBPjlXvtvtHFby
         Q3yHpjoiL6nOx9ZN+xQ/0dnuu2QgOyQDQb7WqzAjqyeZAP97Qz/LjtWC0RKXLPPEgdU5
         2DauPgX0b5KpsPIpl2ArgLOnN2T+6dlIS33dp5KW5qTb5YD5/yt1WNrH9IOmz+iKALkQ
         2AHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710903412; x=1711508212;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsOh/COH4UX9LhObfLCurk23uZsxjWsmdSmkDaZcSnQ=;
        b=JnKTpI8zBi54np88JuXReOdC5xS80/oF+K/MkG1Wd3KC4SxhUhhsw7gigdr3cE33qs
         Zx+ZejKypedq2yFgrC6jVdHJ+1XlgVF5XI6eOmpBuZwYwUsIYMbogjGwlyvhmEbGqieR
         p+5taKIHi5XD2MPTksyp97P3w0ADXMaTgkBMHhIzlJP3Iffn+aOrzF5o1igmnPnofJYt
         0ikUuiFeCci5/G3ICbX4K3NuofyiH6awaTic3JIRhMhm5gZed6GPkzUg4kV4pS45s9+f
         5fAT6ML/nMBGcIHeC+6y47D8t9PFDyEGufLdVCXqXuNCWRTCH6eFeyecTeaqd4gR3oys
         66EA==
X-Forwarded-Encrypted: i=1; AJvYcCW/KiJ4+DA7JGlx8dgzJJn/txAsNzqWJGBbsMo/2lI5yyYeMRWX5epkZENtGQQtpd/9gqqB4aMxCEQ8eHofPCwyB34nCEeEMMA=
X-Gm-Message-State: AOJu0Yx/cWWvTb491hTkXIU64CsPgYKYbnc7noUPdxMosTNduUDjdiHx
	l+YzdtZqB8t3qf9NeQb3mMMA7ScZn8T67eX6MLCiSQmG8TtnhdaGkQiIp2yRHC/ytw==
X-Google-Smtp-Source: AGHT+IHON3JpsXmHcnij8cE/0UE7WaDDQfaaHZl92iiO5QXsXfhWhM3/bmKt9lip9VyfiDYzo4pKoQ==
X-Received: by 2002:a17:90a:bf0b:b0:296:db75:c240 with SMTP id c11-20020a17090abf0b00b00296db75c240mr3863223pjs.1.1710903412309;
        Tue, 19 Mar 2024 19:56:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a7f8a00b0029c13f9bd7fsm330388pjl.34.2024.03.19.19.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 19:56:51 -0700 (PDT)
Date: Wed, 20 Mar 2024 10:56:47 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Ian Rogers <irogers@google.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org, bfoster@redhat.com,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/13] lib min_heap: Add min_heap_init()
Message-ID: <ZfpQbxFrTNCmhEVK@visitorckw-System-Product-Name>
References: <20240319180005.246930-1-visitorckw@gmail.com>
 <20240319180005.246930-6-visitorckw@gmail.com>
 <CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com>

On Tue, Mar 19, 2024 at 12:51:22PM -0700, Ian Rogers wrote:
> On Tue, Mar 19, 2024 at 11:00 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > Add min_heap_init() for initializing heap with data, nr, and size.
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Should this change update lib/test_min_heap.c to use min_heap_init?
> 
Sure, will do that in v2.

Regards,
Kuan-Wei
> 
> > ---
> >  include/linux/min_heap.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index c3635a7fdb88..ed462f194b88 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -44,6 +44,18 @@ struct min_heap_callbacks {
> >         void (*swp)(void *lhs, void *rhs);
> >  };
> >
> > +/* Initialize a min-heap. */
> > +static __always_inline
> > +void __min_heap_init(struct __min_heap *heap, void *data, int size)
> > +{
> > +       heap->data = data;
> > +       heap->nr = 0;
> > +       heap->size = size;
> > +}
> > +
> > +#define min_heap_init(_heap, _data, _size)     \
> > +       __min_heap_init(&(_heap)->heap, _data, _size)
> > +
> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> >  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> > --
> > 2.34.1
> >
