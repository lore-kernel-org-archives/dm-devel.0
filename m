Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4742914287
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716478513; cv=none; b=lHi5CEhXM5VTvO3a78B42k6uIIkhxFuc/A0weO1Z7vwBRjgLLntj/sJsT+/9D3I4aUlbj53d2qL9sjUF7Ua1fI7Kb39YBu5NCg8YdWnXh6KgChvpbOCElBkL/Yug+UTE7ABFR1Kf23lts+N+RS7BcMm7lty6oRE7H6KNrQvr0pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716478513; c=relaxed/simple;
	bh=wdxKfjjLUk84a/tGuQYvrmqaFy9ZW/mj1pQCdE0YSj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=powmlF1Cr2YOUUuYkVRU8bwB47FJTUgjrga8XaIfF7VvTdq+Gyzb+A0zcZNFvRapbqpeKek+IGuvtiuJuxOKJibxbf3q9s8+qSGqI5q4bl4x9/Xyerjgb7DATurRykgKfe3RO3MfZe7FsByW+n/iPlT1DKDm1o0uwACWw+zB4bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eP3VRtXf; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eP3VRtXf"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f347e8f6acso658575ad.1
        for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 08:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716478511; x=1717083311; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2MfGbJLhBeGeMBRL5E+PaOkpQOo7Wuw1ls15958h4U=;
        b=eP3VRtXfUIp07ray+EpVfMWV42l+cQiLXo89KRIEGOwzbA+HlNbu4B+mv0eUkKaq+M
         erPxfnP03C2rvZW4LU35Vbokco7f/lAsbswsqrapezBGTYCYtysf05eVKpHVKCtOjWlm
         iHsjVblSktA0w1hQmZCZ68lX0vClY0Sojn+ImPY9N0wulCWTCCm8isMGcC3TvF1YGtV1
         G2qGtMDDvocw2zM71I05ecYyXsKLg/MdjE0xgCNixxjGZF8GKiruOZi5wlLemdyWtcQ2
         190Cxlc4POdfyeApLj5PdwnbqLXXvezpa9SMnD2RWN8xqlj3NyzDnbjhzblWqw86fksc
         E3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716478511; x=1717083311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2MfGbJLhBeGeMBRL5E+PaOkpQOo7Wuw1ls15958h4U=;
        b=uEy1Avlf+dl8O6eAN+AZZuVIGfx5oVODJE+AEACqAYsxxTvZ/vvBXYSWKnxuEIgVzV
         KWC9RdzRkDZHxg39thDbY1oDXtNmEGfa+L3F2rgGuW4I5ApMq5gxTiUnUWDj/GOEmOIg
         BVuQCM7GC+HSd82iaLcD3uRiBkMyZDswY+U+h1ppkP6qzKVkhPL5bD25D2SWfrlzDFwM
         RttOi9SvBe7En/kpE0Mx/7ltEOx3P8o3yJSv+nqxF6vd8rLT4ntmJVlsU9YcLLDn0YPh
         ae4umBlfdod+xDyZyps7b1nBMTGAvU4KrPDgQbKlP9dcSaEAmDGL1xqoQ8W/azrOfetn
         1L2A==
X-Forwarded-Encrypted: i=1; AJvYcCVdhqE+6yAzF66dR47jrRu1dyv0CHJxBbBrTVUhWzwvbhGxOGmT/Ph7RwfduoTqdb5FiY7zSRKSf9Di74x3K3u7LeZaw9Ceb/w=
X-Gm-Message-State: AOJu0Yzzcm6wx02HZiWGqBkC99wt2MiJn4xB9SUvE6WUVKOM6jbPrm0N
	Cz9CPjptLhAIuSSQ75fn5Ugee3Sf/drlsXDljO+a1ueMyh99H8/1
X-Google-Smtp-Source: AGHT+IHkI5Ag6ABIYhzsCAV6jWiQywV28rXKTT8C0iDOse037T9i6PohK5hkxxdwVCFRk3QopDFa2Q==
X-Received: by 2002:a17:902:c94d:b0:1f3:453:2c82 with SMTP id d9443c01a7336-1f31ca5f2afmr56496085ad.4.1716478511499;
        Thu, 23 May 2024 08:35:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f3044a81c9sm69555845ad.43.2024.05.23.08.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 08:35:10 -0700 (PDT)
Date: Thu, 23 May 2024 23:35:05 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [RESEND PATCH v5 04/16] lib min_heap: Add type safe interface
Message-ID: <Zk9iKUhv7Oew6Lsh@visitorckw-System-Product-Name>
References: <20240514084724.557100-1-visitorckw@gmail.com>
 <20240514084724.557100-5-visitorckw@gmail.com>
 <20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org>

On Wed, May 22, 2024 at 04:10:48PM -0700, Andrew Morton wrote:
> On Tue, 14 May 2024 16:47:12 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> > Implement a type-safe interface for min_heap using strong type
> > pointers instead of void * in the data field. This change includes
> > adding small macro wrappers around functions, enabling the use of
> > __minheap_cast and __minheap_obj_size macros for type casting and
> > obtaining element size. This implementation removes the necessity of
> > passing element size in min_heap_callbacks. Additionally, introduce the
> > MIN_HEAP_PREALLOCATED macro for preallocating some elements.
> 
> I guess it's a nice change, although it's unclear how valuable all this
> is.  Being able to remove the local implementations in bcache and
> bcachefs is good.
> 
> > --- a/drivers/md/dm-vdo/repair.c
> > +++ b/drivers/md/dm-vdo/repair.c
> > @@ -51,6 +51,8 @@ struct recovery_point {
> >  	bool increment_applied;
> >  };
> >  
> > +MIN_HEAP(struct numbered_block_mapping, replay_heap);
> >
> > ...
> >
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
> I think that the MIN_HEAP() macro would be better named
> DEFINE_MIN_HEAP().  There's a lot of precedent for this and it's
> unclear whether "MIN_HEAP" actually implements storage.  I looked at
> the repair.c addition and thought "hm, shouldn't that be static"!
>
I will update this in the next version.

> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> > -void min_heapify(struct min_heap *heap, int pos,
> > +void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
> >  		const struct min_heap_callbacks *func)
> >  {
> 
> It's a separate project, but min_heap.h has some crazily huge inlined
> functions.  I expect we'd have a smaller and faster kernel if those
> were moved into a new lib/min_heap.c.
> 
Moving these inline functions to lib/min_heap.c to reduce kernel size
seems reasonable. However, I saw Ian mention that perf event's min_heap
is used during context switches. Since I'm unsure about the performance
impact of making these functions non-inline, I'd like to discuss this
further before actually moving them to lib/min_heap.c.

