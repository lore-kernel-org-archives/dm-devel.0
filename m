Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A04D82C63
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713202539; cv=none; b=N4PAjDnSI5jB1hiGdZyQWb6Is14vMhoVgNxlfqm6Yhd9pcnp0cvgW032wNRQO79jhDVAhqYkxVIb95W/8X+mgyRwVduAE92zsLhzTo+PjQvZ6IoiIzN0vBlKgxCzFLn6QDGQ7tIWmYiSH5U36QVicegwCWiwcU9B7Aa9D9tR0Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713202539; c=relaxed/simple;
	bh=+mDx52s9ABbP+qylPDjlEdQbUbUBCGmkdgYzyLRZEsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqeNeb/Z19YIaPnZaa6lP5S/kM9ifYZxEJ6rAH7AL7A+V4BaleeEjAEFZKzfdTiO+0i3I74mmMQ+4GunAPFDYIaxEGo3kAqm0S1bT0bM3l2Wz9DL7Pv1nFOwvAt4iYkoDOZdKwPOpmo69ZnGw9d5nQIvhDPqe9rUoNGDUFs/MeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIbK6YYY; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIbK6YYY"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6ee0d5044e6so503692b3a.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 10:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713202537; x=1713807337; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yND2zUfUi+v4q+Fs4T63lVmVArBJWibOzfGLa99Xn9w=;
        b=LIbK6YYY5bpp1do90/NO7lUYHQoJA9mLFQ9L6C6Cnah9cWEXIFUpGkQOKC9F1ksrvP
         yzveEpEsRY5TjceQPUw+B9F+hlhzpy8svRqRzNiuTiL0uY7CjPVmDqymTiS46t9aoraN
         qRbaY9zkEmCSTqEi+X5FTeNmiWucl4v58kf4TJuxrBsuq77yDEfxPk8CjhadNdQxuSch
         FeP9+41JWSrxHRF2GSdahGQkgQ8AtslGh5/lS7zxFGGaFEPITQHPsvfHy/9ro6yxKdNU
         UKI9/pLWjYG7221YFPWKx7Ihozqt4OKkaa3tGsKuIawGm/w/i/CBkQjpgB+xQ3HRIewy
         TMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713202537; x=1713807337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yND2zUfUi+v4q+Fs4T63lVmVArBJWibOzfGLa99Xn9w=;
        b=R55ykfZzx3yBQu7nsZ2VjvyzWVpZk8FAdLglxG6i0OzPlXs5zh1C6GXUYC6HhoSWm7
         ZI9eim8VXYgLhEyN2Uc+pqAP3tUpC9tfpb3cvUcx4dXrHSrdmu/fbuieCNXqWonVPptO
         /P1zkFoWbvvqwct+vFXFQbG2tKsXYtKbtoto6GJtO/JyGrEGvXA0FQxv5QhfXGrZqOzI
         RbnisKjgX0CIo0DT+fd45uOd2UuyCuKuCHLnnTDFVAdM9Zp5LjTKg4F0IbHM83CRE7/y
         96jtGh89E4eW9IQaeKPnl5x2ZoJd8d3fhl4GFAjF0772iI310RF6ovUG3wFhPLv42gJN
         15WA==
X-Forwarded-Encrypted: i=1; AJvYcCWXLE9ASSQCkE56N3Mf3X/bS6inc91FfuhCmPTd5h86XcbzG5lcvL2mzZhzVbVPfsnkEw1UPzpSdC4Uyh3Doxv70bF49ECqYMo=
X-Gm-Message-State: AOJu0YzR+Evp0MjiwX+/ckGl6EedStCxP8/qevhMp4M9oxwjTuew96JH
	3nH/wR2GPhJtoBtbyYtRlBHBN0ZkKqXteLji7YHrUFjK1U4GKIGB
X-Google-Smtp-Source: AGHT+IG6NKLoYgtNA0zwWTzkP8WTGQd4qLXhWBTEEVWaqnnI2QLPzr1rMVeOMKwzxaqVx/1yQ3sSow==
X-Received: by 2002:a05:6a20:2590:b0:1a9:a31a:1b69 with SMTP id k16-20020a056a20259000b001a9a31a1b69mr13640576pzd.6.1713202537217;
        Mon, 15 Apr 2024 10:35:37 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id t6-20020a056a00138600b006ecef9e9615sm7456833pfg.200.2024.04.15.10.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 10:35:36 -0700 (PDT)
Date: Tue, 16 Apr 2024 01:35:31 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 04/17] lib min_heap: Add type safe interface
Message-ID: <Zh1lY8EFyE943+89@visitorckw-System-Product-Name>
References: <20240406164727.577914-1-visitorckw@gmail.com>
 <20240406164727.577914-5-visitorckw@gmail.com>
 <20240412073017.GE30852@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412073017.GE30852@noisy.programming.kicks-ass.net>

On Fri, Apr 12, 2024 at 09:30:17AM +0200, Peter Zijlstra wrote:
> On Sun, Apr 07, 2024 at 12:47:14AM +0800, Kuan-Wei Chiu wrote:
> 
> > -struct min_heap {
> > -	void *data;
> > -	int nr;
> > -	int size;
> > -};
> > +#define MIN_HEAP_PREALLOCATED(_type, _name, _nr)	\
> > +struct _name {	\
> > +	int nr;	\
> > +	int size;	\
> > +	_type *data;	\
> > +	_type preallocated[_nr];	\
> > +}
> 
> 
> > @@ -3738,7 +3739,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  	struct perf_cpu_context *cpuctx = NULL;
> >  	/* Space for per CPU and/or any CPU event iterators. */
> >  	struct perf_event *itrs[2];
> > -	struct min_heap event_heap;
> > +	struct perf_event_min_heap event_heap;
> >  	struct perf_event **evt;
> >  	int ret;
> >  
> > @@ -3747,11 +3748,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  
> >  	if (!ctx->task) {
> >  		cpuctx = this_cpu_ptr(&perf_cpu_context);
> > -		event_heap = (struct min_heap){
> > -			.data = cpuctx->heap,
> > -			.nr = 0,
> > -			.size = cpuctx->heap_size,
> > -		};
> > +		event_heap.data = cpuctx->heap;
> > +		event_heap.nr = 0;
> > +		event_heap.size = cpuctx->heap_size;
> >  
> >  		lockdep_assert_held(&cpuctx->ctx.lock);
> >  
> > @@ -3760,11 +3759,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  			css = &cpuctx->cgrp->css;
> >  #endif
> >  	} else {
> > -		event_heap = (struct min_heap){
> > -			.data = itrs,
> > -			.nr = 0,
> > -			.size = ARRAY_SIZE(itrs),
> > -		};
> > +		event_heap.data = itrs;
> > +		event_heap.nr = 0;
> > +		event_heap.size = ARRAY_SIZE(itrs);
> >  		/* Events not within a CPU context may be on any CPU. */
> >  		__heap_add(&event_heap, perf_event_groups_first(groups, -1, pmu, NULL));
> >  	}
> 
> Not too happy about these. If you ever add more fields they will go
> uninitialized. Why not keep the existing form and fix the struct name?

Sorry for the late reply. I'm traveling.
I'll change that back in v4.

Regards,
Kuan-Wei
