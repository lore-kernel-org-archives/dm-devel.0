Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2393D0D2
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 19:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878123; cv=none; b=LCTjs4NljrbRzz/Md7kvw66tKU5v1Y1KUV4bXgTueN0GxtzleqlIjfw/NFwJDeolmzJYA7HuK5LXAayGnyQ/+VCvmk6mv05p+hrdC3OLH86fnH0eAgTVIRInvdubaWxY5fHha42iZ4wLdwsAPplrV0AToF3PQsHE/cXl4EUt9QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878123; c=relaxed/simple;
	bh=tq/1pPtVk4bFy1TUWWqhNCcGUABz2Wn0gW+04VmLGUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZJuMMcY8gfT541iCOav4rjGHLIR36V26J8pezTCFhU85GBYxVUphgkw7LmCo62Pmd65ZZi0IL6LDiDon8+setvLpoMWPPcXjM+OmfnbqUCHqH5hvH1lI48gAbhulaWVSf/VDAavtxNS6ATFxmwSytCvss5yoRGCCdFSyb6aVVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kSw5RgEA; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kSw5RgEA"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-366a04fb186so34015ab.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 12:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878121; x=1711482921; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgLh9fxNWA3PLxV487Uv3NZnNjKvvWhoCvzQBg8zyQQ=;
        b=kSw5RgEAaYlJB2UwrYwu8iIDwWncPTZ7o8pdT84JlFZgg9pilkIPiJdGFxGXi0FCNu
         V9X/k5otY0gocc46nNIy5htcuPYe2tZWEzU2ymHJVpjp9g6ydv8dZUVWgLDHHgkBvPg7
         c7IMAvZdnVL1aXdQg/S6WTs3mdGTPWVAKU13XEIFZ/ymvIvPQBmz4Uv94JdBv/btZeU1
         bPw+CPt9Q7hqnNaKEcdJooodrytrzDK6Gvl9oKLJPsaUxFIaT0NflABQ4bTbMA7+iIuJ
         Ndd/Y5sT818YX0b/Wi1b6gBqowEQXssZidyg+mirHM0URnK3qExu4u42OQJXmSKj6+2b
         Qf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878121; x=1711482921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgLh9fxNWA3PLxV487Uv3NZnNjKvvWhoCvzQBg8zyQQ=;
        b=bEnca5+Zdayqsx08nEUGewwicZi/gCBi5+d/64EaxSlFH1qm/c7NmweBws05dYZm0/
         TauaJdtjGKRD4NiSCmqW5b2pLmiSlOKOntIGH/ofzZQBubUKoaL6uNzn7jIG6olrRWSy
         TpALUgpMjju9BZnLmAIZuLQ6P3Oz1VGMmG8PjRtPx0SJ1BRs73QhQxmE4JjUK4BLHjM+
         ec/CX63IUvKLS4fQM8wW7I4BGLHavYDWN1jXUO+mvu49JsejJ11fwksDVaD85JQ8VuZE
         ZPzHmcpqzaoSzHgBQ53NMudDll6xZJhGBf7MpRNDF23a2CVzywcjHhMbzDmLDW4UL0Cz
         Mv5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUPTmUPXhoF2ytR1U1xhgbmiA6YriVdZwrWGxzpSyodGPatl9lV8H8ZFvDJCvnRVMDmmZ/RXF6aAwC3lEY6VuYWRt7H8aX/qY4=
X-Gm-Message-State: AOJu0Ywp63e2ARtBU07dEub/ogw02FLu763aIaIhDcIJa3pq3GrbfNAm
	XgGs7ERqM87yjkrc6/0aLafHVWDZy5zqzUSvOkV9wBc37BB/fSmcqjlsbcznfVdX0Ruwrn6TE38
	sjyAhAsgBTM2vIjdLxUaqRLS02s7bXORZaFMK
X-Google-Smtp-Source: AGHT+IERlmpYbi7scXHRweGWqKFANu4nCnjg91c1eLgZPt1tpqmLTiArMaKYHHFVGIrDmnNDhYnBI2oLyIaUqaSz3v8=
X-Received: by 2002:a05:6e02:1aa7:b0:365:a6a3:9c82 with SMTP id
 l7-20020a056e021aa700b00365a6a39c82mr63098ilv.26.1710878121279; Tue, 19 Mar
 2024 12:55:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-7-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-7-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:55:10 -0700
Message-ID: <CAP-5=fURxwVSddrNRhRwT4rWsRhq+BLkAzqi7ooZ6JQbPsOP8A@mail.gmail.com>
Subject: Re: [PATCH 06/13] lib min_heap: Add min_heap_peek()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2024 at 11:00=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Add min_heap_peek() function to retrieve a pointer to the smallest
> element. The pointer is cast to the appropriate type of heap elements.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

I see there's coverage of these functions caused by later changes.

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index ed462f194b88..7c1fd1ddc71a 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -56,6 +56,16 @@ void __min_heap_init(struct __min_heap *heap, void *da=
ta, int size)
>  #define min_heap_init(_heap, _data, _size)     \
>         __min_heap_init(&(_heap)->heap, _data, _size)
>
> +/* Get the minimum element from the heap. */
> +static __always_inline
> +void *__min_heap_peek(struct __min_heap *heap)
> +{
> +       return heap->nr ? heap->data : NULL;
> +}
> +
> +#define min_heap_peek(_heap)   \
> +       (__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
> +
>  /* Sift the element at pos down the heap. */
>  static __always_inline
>  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> --
> 2.34.1
>
