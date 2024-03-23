Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0A3A31
	for <dm-devel@lists.linux.dev>; Sat, 23 Mar 2024 01:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711158796; cv=none; b=fIVaZoIuRoPKv8e2EbWdC3IL1xcEBVjLZb92oQXisGFcdxhi64oagdl2TCPuhCVMq3qVeQPlfVYQ8aZF05OH8YEIRffBckLv5uCK3CXI6rveAMVE3DJI+YsBzjCOjp8dukXyZotmLoacmvJpGemHy2eTPdhV8HL24f0XOLIh/+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711158796; c=relaxed/simple;
	bh=aUTXFCFu3rAz7WtNUADGa0nIJgF5aAYmNcf+O0y1ZDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MG8KnsOH5Bm+JRFfJdaCQGJq/XurqpmQQqcwDxXnW3poZvN5yR39FiFQL8tuB3iEqK/Im+iI63dGcILRW/ycvRgmgmAesql3DUzRooL0+ajg1uVv28fnfULpUpAkmyfgKJExk0Sf0FmgOC7rq5egJWbX+j+4texjyjrkJI0YDZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0D7Ep1G; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0D7Ep1G"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so515692a12.0
        for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 18:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711158795; x=1711763595; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ih1G9Lq2QipoMXy+VgNWidEhR3T48e5NfyFZpAOMBk=;
        b=B0D7Ep1GQKbRDgES3qSVURizd9T45rQHPiFBk4ZAMXlt+yg7bO1yS//5AQL8rIIbFJ
         /GZuzCHYwcyiDWrFIc6iJr6L005eSldIvJYOMhQLcxRp7y9uEGZRoTiYmJXJbaJkGVW4
         tNE6I9mUb5JG95LWJckF/2P/F0WkhPEXf+Cw7DJedVMGlU1kJEYawQW+m6arnb+8yASx
         leUd1uNFKgFvGA/FhS1LeCYYGOkuZk8IxyH4f9HztCWDv4ayaShZoDwtriJ34a1db9zm
         un8R418Z6XXD8ll78hG9hE1pCw1FFfv7VZXrtRotBTTrap0EVzPXaQuvG049Ymb0wRlZ
         QTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711158795; x=1711763595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ih1G9Lq2QipoMXy+VgNWidEhR3T48e5NfyFZpAOMBk=;
        b=h5fcMQ6aDwO3l8lVHotv56ITaC58SRG1nvGOI6ub1vXzwQQPVhgxA8KmcDffh+yt4z
         urLBuwuLtWCfQtdZ4fCbAKKodKL0G06W8kcOAqPg6LcF58uzopcmRmOxcZYUue3II4Ia
         NsItG0UJCU+zXg4dXGSVKL5Wdo3+7C/cJUrMSspAbYwxaeCyHByf0AU+AYVUCbz9J3tJ
         ep+Rzzsqs59DWlVbLImLRDf5tjpBsduC7eZ9q2FrsgpVrGo5qSK/RBQbCKC6QWQJi1hf
         10yqEgK38Atr1C4MctCXZuyOyxoV82hcgugRfNsm2myi2EZwE4J1oAOZEDi25V0zy8DA
         ikVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPmB2QS2xCG6JAAqZpd0U51QDDDJxXXYfaui5Wo6uvwz4vSkIp5CGbpQxjOe/fZiAdMWrUx+5q8zhhRqnkHdEJyO9MjqAx5Ng=
X-Gm-Message-State: AOJu0YzmjFhiTtdSf59O1z8oMP1yxgtc5i7Qz03PtCXKCBbQntlj6kNd
	+xqESjub9irtczmugaFg0T7NQV7k4jt1+uYsOw7KfxtbZ4Qv0Cco
X-Google-Smtp-Source: AGHT+IHJTjayi0fs3/rdLdc75kSxwhCSNIjCz3el8CQ6O8Wg+5iaMSPe+ohLniOuGZLh57+tPlvr/A==
X-Received: by 2002:a17:90a:ba98:b0:29c:7487:43b8 with SMTP id t24-20020a17090aba9800b0029c748743b8mr1232834pjr.1.1711158794474;
        Fri, 22 Mar 2024 18:53:14 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id g7-20020a17090ace8700b002a017061f6esm4463238pju.57.2024.03.22.18.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 18:53:13 -0700 (PDT)
Date: Sat, 23 Mar 2024 09:53:08 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 04/15] lib min_heap: Add type safe interface
Message-ID: <Zf42BA7EMCRI3hik@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
 <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
 <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>
 <Zf25pSI4p0d5pFXX@visitorckw-System-Product-Name>
 <gx3skkrp6pfp7ch3dmludzmqrsyncsptzhlvuwqt2abdhcli5m@xsny7x4nkxv3>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gx3skkrp6pfp7ch3dmludzmqrsyncsptzhlvuwqt2abdhcli5m@xsny7x4nkxv3>

On Fri, Mar 22, 2024 at 02:23:26PM -0400, Kent Overstreet wrote:
> On Sat, Mar 23, 2024 at 01:02:29AM +0800, Kuan-Wei Chiu wrote:
> > On Thu, Mar 21, 2024 at 05:22:14PM -0400, Kent Overstreet wrote:
> > > On Thu, Mar 21, 2024 at 07:57:47PM +0800, Kuan-Wei Chiu wrote:
> > > > On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> > > > > On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > > > > > Introduce a type-safe interface for min_heap by adding small macro
> > > > > > wrappers around functions and using a 0-size array to store type
> > > > > > information. This enables the use of __minheap_cast and
> > > > > > __minheap_obj_size macros for type casting and obtaining element size.
> > > > > > The implementation draws inspiration from generic-radix-tree.h,
> > > > > > eliminating the need to pass element size in min_heap_callbacks.
> > > > > 
> > > > > let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> > > > > trick for that. All heaps have the same memory layout, so we can just
> > > > > cast to a void pointer heap to get something the C code can use.
> > > > >
> > > > If I understand correctly, you're suggesting adding APIs similar to
> > > > darray_top(), darray_first(), and darray_last() within min_heap and
> > > > having them return a pointer. However, some users are using heap.nr in
> > > > conditional statements instead of utilizing heap.nr for memory
> > > > operations, so returning pointers may not be as convenient. What about
> > > > adding get and set functions for nr instead?
> > > 
> > > No, I mean not having separate inner and outer types. Want me to sketch
> > > something out?
> > 
> > Based on your suggestion, I've come up with the following code snippet:
> > 
> > #define MIN_HEAP_PREALLOCATED(_type, _name, _nr) \
> > struct _name {  \
> >     int nr; \
> >     int size;   \
> >     _type *data;    \
> >     _type preallocated[_nr];    \
> > };
> > 
> > #define MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)
> > 
> > typdef MIN_HEAP(char, _) min_heap_char;
> > 
> > static __always_inline
> > void min_heap_init(min_heap_char *heap, void *data, int size)
> > {
> > 	heap->nr = 0;
> > 	heap->size = size;
> >     heap->data = size <= ARRAY_SIZE(heap->preallocated) ? heap->preallocated : data;
> > }
> > 
> > But I'm not sure how to implement other inline functions like
> > min_heap_push or min_heap_pop if I do that, unless they are rewritten
> > using macros. Also, I'm not sure how to make the less and swp functions
> > in the min_heap_callbacks not use void * type parameters. Or perhaps I
> > misunderstood your meaning again. If you could sketch out your idea or
> > have a better approach, it would be a great help to me. Any guidance
> > would be greatly appreciated.
> 
> No, you're on the right track. To call C functions on different types of
> heaps you have to cast them all to a common type, say HEAP(char), also
> pass the element size as a paremeter (which you had to do previously
> anyways).

The other question I want to ask is, I'm not sure how this relates to
avoiding the heap->heap.nr. In cases where we need to know the current
number of elements in the heap, don't we still need to use the same
method to determine the number of elements?

Regards,
Kuan-Wei
