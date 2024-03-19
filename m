Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D659B4E
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 20:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879152; cv=none; b=ZMOusEVqcbABuzc8Eb+s7ubjk9g/K/47Yv+Us6o0EMzO/NGN8CJTbBwwmIGC7DEvWwEwdwANYYKnqwXCSKSTmMzTc+pR6io9IifxvSaoOMxcgV01JL2a4tQKsHo9LhW+7YoBTd77mig8XhKqD7hbqedLe3C8GBFKX+BPZRO6Evo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879152; c=relaxed/simple;
	bh=8yaxvB6bUHYBs0zmT9Eiw6XjDqKFmwedLMjHxHXfPnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SvkLLioKMUQRRthGjBtUIJ79HVCxMGXWZcfPlJquYB2wbOyLYjlrbapR7SkKmj2F/mB2m1dP2/euCFTSYUMktRtKTLWRPORvfHcS9R3xFH/obhXky8aD4VV3rBkNvtzu6aAg2GZXDl/xJ5sb4fp6jS97FW2mVnI2EAFoQlCkFuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=elFu25dA; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="elFu25dA"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1deddb82b43so45755ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 13:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710879150; x=1711483950; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tX+TNd0OCISuOTBPfi7a9IeALZq1DpePFpW0ki49zWs=;
        b=elFu25dAKA8wtuk0ebdvv6p2ZST9ZY6Co+ORVbKGGWB41gunYJIOiDrrxLH1493heS
         m8BHor3WJlXfYffj30kovcbIstgdZF/3OyDUg3lsYnlFvvgZXDh5LwS8E3a8HgK+3ykQ
         ipYXl7Zb12uzljGGPH0MJd91Jc2E8ZrVQEU+H/Sm+5zfbaMovG1zpWMyphNzqjz8UZ/6
         x7hdKZ898e6f6dUrypqPdxOUqcW3Krk1WqRWdwXKf/avXT3MdrNo2yLgOYx7mniNEiev
         Afbpkx+MKYC6Xf8hlxAOM964pkZXUFilXaRUCM01/NWWR/jG9vwjNymQSUoKHgWer1/v
         dsWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710879150; x=1711483950;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tX+TNd0OCISuOTBPfi7a9IeALZq1DpePFpW0ki49zWs=;
        b=UinnhR9lNRpMooz2K4bapGNac131etzZHqp/w5iEerLiAlk4x0C9fe95TIs/tugDge
         UwEtEO8IhYFN9XUqxOd36GNcef65OqNBLZttch4nZKwmLb0xGXndtbiUu+Pr6Qb99A/B
         mkAoXoU0R31jnzAXP4Z811LG7vhk+MWe4KOlDL4Qp5hYzsGSqGPFHvB2HOM/BZDGtf8s
         yh48lJXe7sVSTXIKEY4SHXke2QKzVBvtGsmuAUFyIxxKn634HKkgXAHgjWyyRP1fbNwh
         y1kdiTUoZr3sVlfqhlWfCel2Lb0RWf4TQmX1YA6pXEqH2qnV9Ov/PgKjnBi77QFx3vA3
         5O0w==
X-Forwarded-Encrypted: i=1; AJvYcCW33JG9kV2zLhbCaD/b2224N4ni6zUuSxDjIG6nE5+2bKAmBDw1XIHtaI3cVedHTbaeIj5rMNTKpen9wbZzuOSvWG54qnOLEf4=
X-Gm-Message-State: AOJu0YxHSETkqNLfGTl1jFnaYOKvCzELUcUKUkfmwX0QI1M4+ssoO0pI
	2UNgaLtkmxb46Bj4umcnv+e1IUuEi5BmkGcFJzus/SsbbLks3otYsJsrdHCLOlLjoaQpv7OuGyj
	5PCmaU5ucTctpGS5OX5wjIJ7gEGJBWc2nw8OX
X-Google-Smtp-Source: AGHT+IGbGf1RVMK7axLEkZqDasCPpcTykPmTPG7Mu7HWubRQke5co6hu1xILc3epPRWgfZ6F1xPBBZC5XffRHd5YKKQ=
X-Received: by 2002:a17:902:d508:b0:1e0:e16:dcc0 with SMTP id
 b8-20020a170902d50800b001e00e16dcc0mr10873plg.13.1710879149903; Tue, 19 Mar
 2024 13:12:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-13-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-13-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:12:18 -0700
Message-ID: <CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com>
Subject: Re: [PATCH 12/13] lib min_heap: Add min_heap_sift_up()
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

On Tue, Mar 19, 2024 at 11:01=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Add min_heap_sift_up() to sift up the element at index 'idx' in the
> heap.

Normally sift up is used to implement the min heap but isn't part of
the API, eg. there is a sift up in min_heap_push. Should min_heapify
be renamed to min_heap_sift_down to align with this name?

Thanks,
Ian

> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  include/linux/min_heap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index ce085137fce7..586965977104 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -199,6 +199,26 @@ bool __min_heap_push(struct __min_heap *heap, const =
void *element, size_t elem_s
>  #define min_heap_push(_heap, _element, _func, _args)   \
>         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func, _args)
>
> +/* Sift up ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_=
t idx,
> +               const struct min_heap_callbacks *func, void *args)
> +{
> +       void *data =3D heap->data;
> +       size_t parent;
> +
> +       while (idx) {
> +               parent =3D (idx - 1) / 2;
> +               if (func->less(data + parent * elem_size, data + idx * el=
em_size, args))
> +                       break;
> +               func->swp(data + parent * elem_size, data + idx * elem_si=
ze, args);
> +               idx =3D parent;
> +       }
> +}
> +
> +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> +       __min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _id=
x, _func, _args)
> +
>  /* Remove ith element from the heap, O(log2(nr)). */
>  static __always_inline
>  bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t id=
x,
> --
> 2.34.1
>
