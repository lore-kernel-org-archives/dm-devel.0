Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634DB57C8A
	for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715765163; cv=none; b=AG44tz/79l6kXDqSgMVSN3mM3nZ7eNtF1vLq3zKw+pDcO0N4RtEOhbGMVY1RUemg+dGdgJzZlgCWU4idIDuaTa/U3tadG4JEiggEit8utcLw4eVDVUju5qxA4XzEYLunQm4pvZhjo557fWU784xJ2oQd4KbZWyCAubJ458Z3OMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715765163; c=relaxed/simple;
	bh=U537H0j/9PlQaC0LiL9fsVT4K5alZFkllM7ciYu/MeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBG5Bn8VAfvDPq84J97RhkhBQE/qtOylnTQ0gRHvSKgER3yNEv4nnxZEvwq9t3i+A1ZEJVL/4Hu7yGYJpj88mx7Ey75tDtNTvClizWcnHoeMwJM20kZanPzUP51UUjKrA8qvuyi5rHQKRurc8l5VlKWCLPBEYcdxIMnUMuwNot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TrDk+Bgc; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrDk+Bgc"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2b6215bcd03so1472963a91.1
        for <dm-devel@lists.linux.dev>; Wed, 15 May 2024 02:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715765160; x=1716369960; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OPKfNooZp8Km8QQjbs+4OOukYiKVYt2UrV4I2QW6i4c=;
        b=TrDk+Bgc1bK7UJw9WozdpREfkQPlBLJ1q4IO3DAEBaIwBGIjAI+s6YeX7O5zRfq5QH
         +IpwmmdESBHVeiHRo+kHRpRKCnIOMKIoG3xsdZKyzzmMPTfiOI6/+w1erHw00QqtFArB
         nKPxJrnazoqJEvTEFJzr0Y5htLJkGjq9N14ukka9JKOC4gknyHsY5crHU0Fr/sqYq9bm
         GbP0LehCIn4Z1yYHMCngWSvM6E1wZaFPXuNzmaMwZbpLDtzBSxPppAfAmKoSavlu0jWU
         u3tEtvOqyf/ylF/b2fr8hun+lv68CzaNql2EykyA38IetsJvjviDe4aI7AteA2XFvFwQ
         VIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715765160; x=1716369960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPKfNooZp8Km8QQjbs+4OOukYiKVYt2UrV4I2QW6i4c=;
        b=VFLANzz4VkmJm0nVZxMzFpvb4CO44fKxf5q/odlJAaOV52wwVQKfvrnAe88SQkalLv
         B6GKe1pjc04dq0bVzbPSEPlab/XSkUYRkndp/dTlUD8gbvYIuGbPrGOwa/by8OIxAM0u
         Ony75bTk9s4HNosaShJp7qBv7OnEIHnE39F0p0bAY1avxltgdBY/0JEXDjwNv/LNoyDF
         tIHAUmi84EyzxgCZ6KJLxGPFcivKsLocKxF1tJSbFlqpcNSBrUmDzy39/ZpKjJnhWgUA
         gTW8w12shMAMLxRAYAcvzZeyu7tqPQ7D+nbV7JTPyrhmk3GAqIHrvrywFT9FQXjhsFo2
         NZeg==
X-Forwarded-Encrypted: i=1; AJvYcCU72r0BBaWhiH2f3BkqvRnkIv3mqLfgsxsceKX2b4t1eSmuCfKtsl+YQK5/fEvz9XoeXx3I5khuP0ccXB1yTtO+L6fLHbhPPds=
X-Gm-Message-State: AOJu0YzoUCf2tfqN664GrQvUcdRZ4GQX7BfrzH9WmJl/zW0uWYbsrliw
	0gdmTid6iryFueMQsLdHZ9XJyrLREbJqbX5kKX4QMDRynq0lBcKd
X-Google-Smtp-Source: AGHT+IF2x8/iHfJaxUooX4X3TGoGoXPwzr8yltF5Wclj64bedUjHLoWk82Et3XcILWR8yWtSNWfX5A==
X-Received: by 2002:a17:902:cec6:b0:1eb:ac3c:e39f with SMTP id d9443c01a7336-1ef441b5da6mr178395365ad.6.1715765159464;
        Wed, 15 May 2024 02:25:59 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d16dasm113812805ad.15.2024.05.15.02.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 02:25:58 -0700 (PDT)
Date: Wed, 15 May 2024 17:25:54 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [RESEND PATCH v5 11/16] lib min_heap: Update min_heap_push() and
 min_heap_pop() to return bool values
Message-ID: <ZkR/ovACvPFqvFCv@visitorckw-System-Product-Name>
References: <20240514084724.557100-1-visitorckw@gmail.com>
 <20240514084724.557100-12-visitorckw@gmail.com>
 <20240515083755.GB40213@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515083755.GB40213@noisy.programming.kicks-ass.net>

On Wed, May 15, 2024 at 10:37:55AM +0200, Peter Zijlstra wrote:
> On Tue, May 14, 2024 at 04:47:19PM +0800, Kuan-Wei Chiu wrote:
> > Modify the min_heap_push() and min_heap_pop() to return a boolean
> > value. They now return false when the operation fails and true when it
> > succeeds.
> 
> But why ?!

When handling failures of push/pop operations, although we could
achieve the same effect by checking whether the heap is empty/full
before push/pop, we have already performed such checks within the
push/pop operations. Therefore, I believe directly using the result
of the check as the return value will make the code written by the user
more concise. This return value is used in subsequent patches for
replacing the heap macro in bcache and bcachefs to determine if an
error has occurred. The original heap macros in bcache and bcachefs
also do the same thing.

Regards,
Kuan-Wei
> 
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Reviewed-by: Ian Rogers <irogers@google.com>
> > ---
> >  include/linux/min_heap.h | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index c94f9d303205..2d080f85ad0d 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
> >  
> >  /* Remove minimum element from the heap, O(log2(nr)). */
> >  static __always_inline
> > -void __min_heap_pop(min_heap_char *heap, size_t elem_size,
> > +bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
> >  		const struct min_heap_callbacks *func, void *args)
> >  {
> >  	void *data = heap->data;
> >  
> >  	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
> > -		return;
> > +		return false;
> >  
> >  	/* Place last element at the root (position 0) and then sift down. */
> >  	heap->nr--;
> >  	memcpy(data, data + (heap->nr * elem_size), elem_size);
> >  	__min_heapify(heap, 0, elem_size, func, args);
> > +
> > +	return true;
> >  }
> >  
> >  #define min_heap_pop(_heap, _func, _args)	\
> > @@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *heap,
> >  
> >  /* Push an element on to the heap, O(log2(nr)). */
> >  static __always_inline
> > -void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> > +bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> >  		const struct min_heap_callbacks *func, void *args)
> >  {
> >  	void *data = heap->data;
> > @@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> >  	int pos;
> >  
> >  	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
> > -		return;
> > +		return false;
> >  
> >  	/* Place at the end of data. */
> >  	pos = heap->nr;
> > @@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> >  			break;
> >  		func->swp(parent, child, args);
> >  	}
> > +
> > +	return true;
> >  }
> >  
> >  #define min_heap_push(_heap, _element, _func, _args)	\
> > -- 
> > 2.34.1
> > 
