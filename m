Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838745DF24
	for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711126957; cv=none; b=QPRdI/N+FyS297V2jHL2JrO/Bq9nm3DQVNBmmVkxohfT7sOipzqnaqMbMU67mW+0nIrfStOmwN8moiVG8eFlTmzt53g3W1VVHwsukTVo8Juvs09Ssq+cNRPnOC8gCnmrBP5zDV9yyQjmKXvbWf9hiKqOBDc+KGPSwI7DsDRnNX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711126957; c=relaxed/simple;
	bh=JDNMOQbC3PXY7QpcMkns9oBdlRz2yyb1ZhLyIu3ZqTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faJ/UEg4Ddm3/ZAJJ3yEAEsa5MHhlV5/jRJQ32bkpiuqERaEl1PlEcc+Ym4HTEFBDqQB18xYBluHIpwYbEXzK2BWKaNPEAZJxooTlUpHF4ONYM8PlyHvag5z8odqy60xU4wlScBfHpx2csdTGSwsusEG53yOCfSzibeVV5NmdY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8sgEV/i; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8sgEV/i"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e696233f44so218033b3a.0
        for <dm-devel@lists.linux.dev>; Fri, 22 Mar 2024 10:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711126956; x=1711731756; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PxfXve+cVmsiI21kufWB4EHnClccPxAyzXoJTXcNJlo=;
        b=Z8sgEV/ipvRPk9XWI3RT63AFCoEEoUvdaFYEV7RuHxH/gBqNDBytOsTxGgxWTXgWxi
         IlsYRk/Iw0w2GNPzYMSrFDLHGIBcwX3SayY600yIM1/xi1DT/BTtoDy1XcPh990ik87U
         nu4O227XyOk+d5cUcwlTLlLXIvui11OHSPisxQSM+K9/8lFroZYkCjFBRnot47mJbIqi
         s4aOVubRpZgzXKnclabtrEutZdwDj/NRhuslAOjLgXKj2QJxhstvHPupdsUHCJYzBlf+
         IRmqjmHwcT7EAqVvVtadq0SvXj31UHaFuZ4jxC8NxjVcNkovE9DaAbDvFup5e57KM8b8
         ngcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711126956; x=1711731756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxfXve+cVmsiI21kufWB4EHnClccPxAyzXoJTXcNJlo=;
        b=nouuKCK02HyVbnCiM0vv2lyt+XV+g/NcXR6A/Mt5DWkKzXQ8WlNVuNm708dzrOG9vl
         gzilD9pK8plYwHJgfYcWcea5jRIG6d/CihNSMsRN1p5uIdoysIVAbi1H0NPiDA/3BqhY
         bWmF2cAWtDvNkxHsaLlhua9Zaq7enE5vVLp98I6Ur2so6dq7AGyawQBtwHO5pOmF8ziX
         LVyP3g6WlsSzCK0x6Ve3JkCECobvDSoozt0upelDwO+DLpBuHTHfqfFv+xDNjy4amgZ3
         h2rVdFXo9xGBKi6MNoqZQVmc1CKKi80y9qiTZM47hug3XcrnOzeteg/hxIpGEQUw0Adt
         lo8g==
X-Forwarded-Encrypted: i=1; AJvYcCUy6FIbnA6BvUJUlD89jdAWZIGkKvGk5+k4lBfkoUqjXd6L5OqFslv+5HJujk3GsU3NoXfS38xmvFEJ2+kkaBatvlM8saCR0eE=
X-Gm-Message-State: AOJu0Yzzi9ZTRlV4dz8JwaXgKEcrbHP5kcdDAcq7HXjD/ed2RO21p6EU
	cPP66P1A9Yp8Nyx4nxcTRtOEJpPNGRTysbb58WHeDbtMoEH2S2zF
X-Google-Smtp-Source: AGHT+IFa4H5VIiJ6qclzn3xJkPvqqFrgLJzJzz1hQuxN/TxMHL90VHkyed7eEbXy6+syQXO2mZ3qqA==
X-Received: by 2002:a05:6a00:9aa:b0:6ea:7f2e:633 with SMTP id u42-20020a056a0009aa00b006ea7f2e0633mr365527pfg.2.1711126955763;
        Fri, 22 Mar 2024 10:02:35 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id g26-20020aa79f1a000000b006e724ccdc3esm1879616pfr.55.2024.03.22.10.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 10:02:35 -0700 (PDT)
Date: Sat, 23 Mar 2024 01:02:29 +0800
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
Message-ID: <Zf25pSI4p0d5pFXX@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
 <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
 <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>

On Thu, Mar 21, 2024 at 05:22:14PM -0400, Kent Overstreet wrote:
> On Thu, Mar 21, 2024 at 07:57:47PM +0800, Kuan-Wei Chiu wrote:
> > On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> > > On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > > > Introduce a type-safe interface for min_heap by adding small macro
> > > > wrappers around functions and using a 0-size array to store type
> > > > information. This enables the use of __minheap_cast and
> > > > __minheap_obj_size macros for type casting and obtaining element size.
> > > > The implementation draws inspiration from generic-radix-tree.h,
> > > > eliminating the need to pass element size in min_heap_callbacks.
> > > 
> > > let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> > > trick for that. All heaps have the same memory layout, so we can just
> > > cast to a void pointer heap to get something the C code can use.
> > >
> > If I understand correctly, you're suggesting adding APIs similar to
> > darray_top(), darray_first(), and darray_last() within min_heap and
> > having them return a pointer. However, some users are using heap.nr in
> > conditional statements instead of utilizing heap.nr for memory
> > operations, so returning pointers may not be as convenient. What about
> > adding get and set functions for nr instead?
> 
> No, I mean not having separate inner and outer types. Want me to sketch
> something out?

Based on your suggestion, I've come up with the following code snippet:

#define MIN_HEAP_PREALLOCATED(_type, _name, _nr) \
struct _name {  \
    int nr; \
    int size;   \
    _type *data;    \
    _type preallocated[_nr];    \
};

#define MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)

typdef MIN_HEAP(char, _) min_heap_char;

static __always_inline
void min_heap_init(min_heap_char *heap, void *data, int size)
{
	heap->nr = 0;
	heap->size = size;
    heap->data = size <= ARRAY_SIZE(heap->preallocated) ? heap->preallocated : data;
}

But I'm not sure how to implement other inline functions like
min_heap_push or min_heap_pop if I do that, unless they are rewritten
using macros. Also, I'm not sure how to make the less and swp functions
in the min_heap_callbacks not use void * type parameters. Or perhaps I
misunderstood your meaning again. If you could sketch out your idea or
have a better approach, it would be a great help to me. Any guidance
would be greatly appreciated.

Regards,
Kuan-Wei
