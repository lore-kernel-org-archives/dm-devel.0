Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA1454BEA
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 19:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878268; cv=none; b=LwvLu3ROdtLEnqgJoTMKto5qMWZDSwdL3rldpueUZr873BzNwVc3UGo7zMRsQsjNLP+vbLFL65ouiZuwUAlOhTwUvKtL8Y7N6sJ0IEonCwlerkPF7HpyDk1nmfwdtw5KqKJeeOxB9iLZNeXMxUMd//LClsl1VZz7ufAj7OE1sak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878268; c=relaxed/simple;
	bh=35ecHv+9qehFof6aQVy5gVpDqX2M7KB4dSVOdvgkfjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ngVzRs2tO9j4rUO2pAJHn07a8ityjg0okDIJRBk9wql3Y5d4Ma/MXPsOu85Hc4y99kbWpVQeJhKtJ/LB+P8LIdQ6tS8ITRTMglAo9GO/bSxY0JeOSwkkSq/aYMnY0VxRU22uTvKmAc2eWfloew4ihxb4Ut4Q03n2KkPPxKxhFZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X/n5irM5; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X/n5irM5"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e058b9e479so25335ad.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 12:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878266; x=1711483066; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XettUXCUytZxztvpokYxesf4Q1Gu8ZAwELXRrBrtnls=;
        b=X/n5irM5rbXeWhbar+AEVCPY18NR3HUri2bx63QfV75pFfxkMApdB7e6vsxlrrci17
         ckFBc5d60NOVbWJOmgpoADWvXUsyuo/bm2h0uT86nGl19Chc3kBm5C7v3EaaIUlfY0T8
         PXsxzeP7DnfeoaAPNP4Rjyj4ucDbCjX+YACelcsMFZtWEExEKnDKf7aCaV+emUXSzhdv
         zG4G+iJQ+TZNh4X+T8I5cFbVYE30H6QibpSbD2ywM4WYtCX9HNeLfLDVnaTz5M39Z83E
         3xwF3Fl1NRMAJkuc0xE+0m4WvFmHu/Hit9/KHSCC7yk550qeqY9C0Nc+6wZ4D6ZP0PG2
         DgiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878266; x=1711483066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XettUXCUytZxztvpokYxesf4Q1Gu8ZAwELXRrBrtnls=;
        b=B+nbNEPd8MDXkfkReEG+p0KnI7VWtRkQh0Kw12aXdiKglU9PI3zg1JL57vrEK2A5Fg
         7Bw+Ub+75zPjglFYo611P0IM4eiKkur9KlfOM4oh4HSfskDJEI3a6TkZbVAqp6JHKLQP
         B5DITiEy/tL8qdYgv0Sh+j19fVQal64BfO18A8ErkWODZCi0Z1MWJSnnZcwh+Ooy2eUX
         UHqKAOsDEc2MONvUtjql+mReL3D+totUrSTtLORY7RnvNpoKD+imXaK9HkEMLBGYbuMU
         12fJ3JUI73WhYwwlJO0CK2Ti+7eH9CBDOszt9aDz6GSCv/RI+K/Mpi2p1OM1o2k5omMe
         7w0g==
X-Forwarded-Encrypted: i=1; AJvYcCVrCw9uSsy9yv+HsX5Yn5sv+0xShceRPs+QmEx1EWOO7zGW4Ex/9goxHhGtZ3/wNSvJ0qZdBreJ6b3qTPnSGJj3gNSJ+3JNvng=
X-Gm-Message-State: AOJu0YwDTsKSYA4IS5MJ7XMrtAPbMAfHKJ8qnde30G/Ggr+2RaAHw8oK
	kmONEcKY2RoKU5j4nAW70XFRNndOSYDLDWG7mnMbX8uylBsylndTZELVGv1MHHRCHpTuIXfcqlZ
	Ukw2nSYhuNAeU6LTeKLwqkN4m0OA946nQWyC3
X-Google-Smtp-Source: AGHT+IGhJBZPV5sgsvA1Ag4NPK7bHjOsEVeBT2FsY6a3D5GhexHGoEVe1DyqNZMv3VMEmxrkmDela6UPobccY4gXZ38=
X-Received: by 2002:a17:903:230a:b0:1dd:b505:d518 with SMTP id
 d10-20020a170903230a00b001ddb505d518mr62555plh.22.1710878265724; Tue, 19 Mar
 2024 12:57:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-10-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-10-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:57:34 -0700
Message-ID: <CAP-5=fUkm-BxztTFUUsWk=VrksWD=Sb+zo0+Y8peX=c5icbqmw@mail.gmail.com>
Subject: Re: [PATCH 09/13] lib min_heap: Update min_heap_push() and
 min_heap_pop() to return bool values
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
> Modify the min_heap_push() and min_heap_pop() to return a boolean
> value. They now return false when the operation fails and true when it
> succeeds.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Nice change.

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 97d8ba5c32e6..154ac2102114 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -130,18 +130,20 @@ void __min_heapify_all(struct __min_heap *heap, siz=
e_t elem_size,
>
>  /* Remove minimum element from the heap, O(log2(nr)). */
>  static __always_inline
> -void __min_heap_pop(struct __min_heap *heap, size_t elem_size,
> +bool __min_heap_pop(struct __min_heap *heap, size_t elem_size,
>                 const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
>
>         if (WARN_ONCE(heap->nr <=3D 0, "Popping an empty heap"))
> -               return;
> +               return false;
>
>         /* Place last element at the root (position 0) and then sift down=
. */
>         heap->nr--;
>         memcpy(data, data + (heap->nr * elem_size), elem_size);
>         __min_heapify(heap, 0, elem_size, func, args);
> +
> +       return true;
>  }
>
>  #define min_heap_pop(_heap, _func, _args)      \
> @@ -167,7 +169,7 @@ void __min_heap_pop_push(struct __min_heap *heap,
>
>  /* Push an element on to the heap, O(log2(nr)). */
>  static __always_inline
> -void __min_heap_push(struct __min_heap *heap, const void *element, size_=
t elem_size,
> +bool __min_heap_push(struct __min_heap *heap, const void *element, size_=
t elem_size,
>                 const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
> @@ -175,7 +177,7 @@ void __min_heap_push(struct __min_heap *heap, const v=
oid *element, size_t elem_s
>         int pos;
>
>         if (WARN_ONCE(heap->nr >=3D heap->size, "Pushing on a full heap")=
)
> -               return;
> +               return false;
>
>         /* Place at the end of data. */
>         pos =3D heap->nr;
> @@ -190,6 +192,8 @@ void __min_heap_push(struct __min_heap *heap, const v=
oid *element, size_t elem_s
>                         break;
>                 func->swp(parent, child, args);
>         }
> +
> +       return true;
>  }
>
>  #define min_heap_push(_heap, _element, _func, _args)   \
> --
> 2.34.1
>
