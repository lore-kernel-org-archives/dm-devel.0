Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524C110F1
	for <dm-devel@lists.linux.dev>; Sat, 23 Mar 2024 02:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711160350; cv=none; b=laD2CjJGPop1KaXAa/4NT7nPrUDinB/po1kF8XqxlhKMMCN2ztsfzhD4jv2L5nVcP8XG170X1+Oj2wrl6jwXR0n5cDrvudP2IgZKUDXcxAiw3PnM5tx622qX7x/w3fB8xQ+nceubBnItuXCyaQ31QcButeAI9fUSX0PTpI6e2Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711160350; c=relaxed/simple;
	bh=gAMXekvrV6ZKXab4d1ERZxjVZVzrG9Fx8iCOxKUw+YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gotfj/Q/q4WKVZ6NlaRNjCJxiOQ8IHAbiHL7oPg1f0TwSy+A+IfsHB0klpMDe/2xlKskWO07PYjZV46OYP8z+JUbUlr8jFzfPDvGJnU5qmEoO1gcTdyeLCY1d1GU52/nb3WNefkOhIPR574D2EkmMVVmp4ooRLoUz1BJmits2Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JUqpTToW; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUqpTToW"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2a050cf9adfso44754a91.1
        for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 19:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711160349; x=1711765149; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5lTwxDxwY27GakzptqgwyUTb6+DEPiSueWO/uwZZ9+4=;
        b=JUqpTToW/thFIoThx/D6ZzSqystzvuE560giOdgH0f7hAeosJe98y8lMdaR5yJ74MA
         DaLSDYN0gGuaNWnh5s8TGITZab+Ow3SDqVAh1L+mX8KueSnHtPCVNFws6ebNwFExLL5O
         yqkPfKKH2Weceyq1H3h+ErcEeKbYJJkgSvJFNMv4SGTI7fUVgRm0v52yrMrDyFsMNedo
         yn54JucCixHLLgaEM3wnb0EKjS/5u7UEGkZmD1MssY1/sFjoWHiS5/cYHmJQAUnwSgYS
         bKdRJ0mymb0Z+kt6TQk17+N9RcYkgSKHbDsAaOwe4/xUEUKslwS+jUgTDfdIj6OMbNie
         aGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711160349; x=1711765149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lTwxDxwY27GakzptqgwyUTb6+DEPiSueWO/uwZZ9+4=;
        b=evEPHRZDyh2Hovu5tkFaZTFGeEsv1PJZY58KiBrLCRYwlKD5SPu8s/fL2Qd7qT6YaG
         vKPhJdwcHiJepnWTYTPbasJXsv63Gq+FkdEXflRbSbyaYlN/HBzex0liBQx+A8fZFIZ0
         TFubTpyF8tZW0X0w9Q7J8yfaO9wLRecBCtd2ocmHrSQslr1GoyGcy9g/iIGaaTOxXX/k
         dssjxVEwEhluMtE8pYeDP+oFZDXLJVrO4nJsA4QPMf19hFqHdX5G70kk/NjN7geL5aF7
         UN4uh/wbeNYZvNInx7GExjQ7XC4/B9S6Tg/GhIjMWcnHaC+ox4tGwzoAqhKIw6Rya7z5
         DPZg==
X-Forwarded-Encrypted: i=1; AJvYcCWcL9WRQDcwN3hyRjkU94IPyO4djQDdU262XsP75t9eUVAxsTH+eQwiHfdGYOvxbWsBbX8HOLzFcXDshj57R/XRaNdo+2Kc2o4=
X-Gm-Message-State: AOJu0YxKHl5XhVebUwXHeJnDOXikvn6hIwOPuTr2U/zYsd4jqlH+edko
	g79hFVfrrL2JWH8eEO1ddc6rJZPXiI7e/nRGE9OVMKTe1BZ/LEkO
X-Google-Smtp-Source: AGHT+IEVpJlVSi/GN7Uznx+4tr5sLyoneciAh6D/p0FO9ZxEEi73L38a1h4zDmZ1l6dT85sXU176jA==
X-Received: by 2002:a05:6a00:2da5:b0:6ea:7ff6:31ed with SMTP id fb37-20020a056a002da500b006ea7ff631edmr1727001pfb.1.1711160348544;
        Fri, 22 Mar 2024 19:19:08 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id c13-20020a62f84d000000b006e6c81b6055sm435168pfm.6.2024.03.22.19.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 19:19:08 -0700 (PDT)
Date: Sat, 23 Mar 2024 10:19:03 +0800
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
Message-ID: <Zf48FxpOo4/NZwk/@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
 <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
 <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>
 <Zf25pSI4p0d5pFXX@visitorckw-System-Product-Name>
 <gx3skkrp6pfp7ch3dmludzmqrsyncsptzhlvuwqt2abdhcli5m@xsny7x4nkxv3>
 <Zf42BA7EMCRI3hik@visitorckw-System-Product-Name>
 <ako4ddhjw4i7nt6mq54g4coeht4ksgwmoas3bdds2pzvfgqibc@ko3voxva75ge>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ako4ddhjw4i7nt6mq54g4coeht4ksgwmoas3bdds2pzvfgqibc@ko3voxva75ge>

On Fri, Mar 22, 2024 at 10:08:59PM -0400, Kent Overstreet wrote:
> On Sat, Mar 23, 2024 at 09:53:08AM +0800, Kuan-Wei Chiu wrote:
> > On Fri, Mar 22, 2024 at 02:23:26PM -0400, Kent Overstreet wrote:
> > > On Sat, Mar 23, 2024 at 01:02:29AM +0800, Kuan-Wei Chiu wrote:
> > > > On Thu, Mar 21, 2024 at 05:22:14PM -0400, Kent Overstreet wrote:
> > > > > On Thu, Mar 21, 2024 at 07:57:47PM +0800, Kuan-Wei Chiu wrote:
> > > > > > On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> > > > > > > On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > > > > > > > Introduce a type-safe interface for min_heap by adding small macro
> > > > > > > > wrappers around functions and using a 0-size array to store type
> > > > > > > > information. This enables the use of __minheap_cast and
> > > > > > > > __minheap_obj_size macros for type casting and obtaining element size.
> > > > > > > > The implementation draws inspiration from generic-radix-tree.h,
> > > > > > > > eliminating the need to pass element size in min_heap_callbacks.
> > > > > > > 
> > > > > > > let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> > > > > > > trick for that. All heaps have the same memory layout, so we can just
> > > > > > > cast to a void pointer heap to get something the C code can use.
> > > > > > >
> > > > > > If I understand correctly, you're suggesting adding APIs similar to
> > > > > > darray_top(), darray_first(), and darray_last() within min_heap and
> > > > > > having them return a pointer. However, some users are using heap.nr in
> > > > > > conditional statements instead of utilizing heap.nr for memory
> > > > > > operations, so returning pointers may not be as convenient. What about
> > > > > > adding get and set functions for nr instead?
> > > > > 
> > > > > No, I mean not having separate inner and outer types. Want me to sketch
> > > > > something out?
> > > > 
> > > > Based on your suggestion, I've come up with the following code snippet:
> > > > 
> > > > #define MIN_HEAP_PREALLOCATED(_type, _name, _nr) \
> > > > struct _name {  \
> > > >     int nr; \
> > > >     int size;   \
> > > >     _type *data;    \
> > > >     _type preallocated[_nr];    \
> > > > };
> > > > 
> > > > #define MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)
> > > > 
> > > > typdef MIN_HEAP(char, _) min_heap_char;
> > > > 
> > > > static __always_inline
> > > > void min_heap_init(min_heap_char *heap, void *data, int size)
> > > > {
> > > > 	heap->nr = 0;
> > > > 	heap->size = size;
> > > >     heap->data = size <= ARRAY_SIZE(heap->preallocated) ? heap->preallocated : data;
> > > > }
> > > > 
> > > > But I'm not sure how to implement other inline functions like
> > > > min_heap_push or min_heap_pop if I do that, unless they are rewritten
> > > > using macros. Also, I'm not sure how to make the less and swp functions
> > > > in the min_heap_callbacks not use void * type parameters. Or perhaps I
> > > > misunderstood your meaning again. If you could sketch out your idea or
> > > > have a better approach, it would be a great help to me. Any guidance
> > > > would be greatly appreciated.
> > > 
> > > No, you're on the right track. To call C functions on different types of
> > > heaps you have to cast them all to a common type, say HEAP(char), also
> > > pass the element size as a paremeter (which you had to do previously
> > > anyways).
> > 
> > The other question I want to ask is, I'm not sure how this relates to
> > avoiding the heap->heap.nr. In cases where we need to know the current
> > number of elements in the heap, don't we still need to use the same
> > method to determine the number of elements?
> 
> Yes, but this eliminates the nested types; so it's just heap->nr.
> 
> It's a pretty minor detail, cosmetic really, but I managed it in darray
> so it'd be nice to have here as well :)

Ah, got it. I'll make that change in v3.

Regards,
Kuan-Wei
