Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708C03FB8A
	for <dm-devel@lists.linux.dev>; Sun,  7 Apr 2024 19:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712517807; cv=none; b=QbMF8NQdXmfD78GN0+W5QJ4cY7rPlL/tPPS+/iudPuFejDlmpZ7Nikb0geFB3BxUSCXGtlAI3mNyqbBcX28XCujqaW0GqbnBINlcnnTMNyx71pNqknTyvl5nxnbu+ah19Wg01jilsyP1ScFNZCm5aRjCL12zvN+fdYF9SsInb7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712517807; c=relaxed/simple;
	bh=22VmL+tFNE0uTkCejpkMoP/bIhby50wK3RXGm4NSyrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQstqVixWdGx44MgDbLVwpWe+4sC6r+6eTtWSqim8J7XNg0yB3FsZXtyNDC6s3WMgmqFdd2se8AjTnD9x0UjRnyd28mfYV/+ENYTaIFCvrxr0doW1IYvZWQJoyUjqIy7JdDmcfuvsMNgNBL+cVce9v/fY71VHyr8uQw8Ebtf3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ok6c6itQ; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ok6c6itQ"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-431347c6c99so318071cf.0
        for <dm-devel@lists.linux.dev>; Sun, 07 Apr 2024 12:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712517804; x=1713122604; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u9EK+/yKJWqRz4L882cCc6fbjSJC3IRZpgkO1qv3gbY=;
        b=Ok6c6itQLHGL/B5Chpq3rSv7xdv9/4xTCLsR1CNwSWLGg0A+W4qxhkwsO1aZD+toBd
         l0pfN4r7k/iXFpGqdmUamEDpPWwzgZckFag9O5n1C96X+L3J01u/+LyD5V/Yx2tAD6t0
         Pf0ARrOItYOCwl5e1gqNX5FZj+ZEnpLrRfeNYeIqMB5XXnalycrfKd9wo9wddutAEKK8
         hcePei0amH46kcMdbJXgbrV5jzlwB0gm+fQ9Q+HgBo+4RI2rTL8cbXAT5h7j/GZxlJ8o
         /OGjdn/KskKP/yw1vn39kpPd3u5XS0yUyutgJKx9nnjZIscR03Mr18aVfjr5mBjZT1Z6
         /gnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712517804; x=1713122604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u9EK+/yKJWqRz4L882cCc6fbjSJC3IRZpgkO1qv3gbY=;
        b=ErSh2oEBXxogkhsMOIOFWemmQO2CVLl3FDqlHP2nyFjaf1CdQcT0WDuTGD6XMaB330
         MUy5T/UYdk48jzj48hmhTpB1Ao/muNPqV1b/LJ30S0VBqQM/3JI/1c7CUo/m4fkP68iX
         E+igXEGT8P8BzWOVCnHGmmEcnl7n35HbqT3axgdlk1qfgoDDDlYnuPSIHW+whxmsrsLU
         Jk5Zz9xx/35jNhFys2llGRUiFpTiZ/6ewyVi+Mscdf6NNnM6bN+j0Q5FFdavKBSUb20j
         hCjjbYMuZMV4LlbQJVx3EIaUYom1q4iUajvSv5HamW0BNbx+uNm79Xk3oZIexd5PEeBo
         UrDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwqugUU8c+IApO70Ml1Ye0FdsGj2TodNFc+UYMeTCWzTF0sEk097MZrnS5ROfTTyYEU/TaRvbHXMMte+0Y/JYe29WEDKLMt7c=
X-Gm-Message-State: AOJu0YxpMJB5o1KeBPcJNbZUocQT+XhrXc6Jx/gSHPwYuph0aJEkjFFb
	48FntZ3V2cemMCEA2HlvwJsxrs6Ya/LUsXBN4QGzcEY8SW69whEb0Kw8eTOOwyLn3E8AzGqKO4K
	QR3ICHPPuH05q1NQFw4Fpt6RlQLGdmVkGOtGK
X-Google-Smtp-Source: AGHT+IHar9eAfxca2nmrIrD2fR+nsCEr8Z9S6xUUBtYvOamZ7oI6wPcUjOWZvBJYg8gNmg59mfRxZth/y35fmMF/4NM=
X-Received: by 2002:a05:622a:1b1f:b0:430:e8f2:7d02 with SMTP id
 bb31-20020a05622a1b1f00b00430e8f27d02mr277035qtb.10.1712517804333; Sun, 07
 Apr 2024 12:23:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240406164727.577914-1-visitorckw@gmail.com> <20240406164727.577914-16-visitorckw@gmail.com>
In-Reply-To: <20240406164727.577914-16-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Sun, 7 Apr 2024 12:23:10 -0700
Message-ID: <CAP-5=fUQz0oiO9i6=+F3X9QgkaPVfCRWxH=kCSpYzNRFR=Y=qg@mail.gmail.com>
Subject: Re: [PATCH v3 15/17] lib/test_min_heap: Add test for heap_del()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 6, 2024 at 9:48=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com>=
 wrote:
>
> Add test cases for the min_heap_del() to ensure its functionality is
> thoroughly tested.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  lib/test_min_heap.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> index 67dd4f644f6c..9d4bbb590a49 100644
> --- a/lib/test_min_heap.c
> +++ b/lib/test_min_heap.c
> @@ -160,6 +160,40 @@ static __init int test_heap_pop_push(bool min_heap)
>         return err;
>  }
>
> +static __init int test_heap_del(bool min_heap)
> +{
> +       int values[] =3D { 3, 1, 2, 4, 0x8000000, 0x7FFFFFF, 0,
> +                        -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
> +       struct min_heap_test heap;
> +
> +       min_heap_init(&heap, values, ARRAY_SIZE(values));
> +       heap.nr =3D ARRAY_SIZE(values);
> +       struct min_heap_callbacks funcs =3D {
> +               .less =3D min_heap ? less_than : greater_than,
> +               .swp =3D swap_ints,
> +       };
> +       int i, err;
> +
> +       /* Test with known set of values. */
> +       min_heapify_all(&heap, &funcs, NULL);
> +       for (i =3D 0; i < ARRAY_SIZE(values) / 2; i++)
> +               min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, N=
ULL);
> +       err =3D pop_verify_heap(min_heap, &heap, &funcs);
> +
> +
> +       /* Test with randomly generated values. */
> +       heap.nr =3D ARRAY_SIZE(values);
> +       for (i =3D 0; i < heap.nr; i++)
> +               values[i] =3D get_random_u32();
> +       min_heapify_all(&heap, &funcs, NULL);
> +
> +       for (i =3D 0; i < ARRAY_SIZE(values) / 2; i++)
> +               min_heap_del(&heap, get_random_u32() % heap.nr, &funcs, N=
ULL);
> +       err +=3D pop_verify_heap(min_heap, &heap, &funcs);
> +
> +       return err;
> +}
> +
>  static int __init test_min_heap_init(void)
>  {
>         int err =3D 0;
> @@ -170,6 +204,8 @@ static int __init test_min_heap_init(void)
>         err +=3D test_heap_push(false);
>         err +=3D test_heap_pop_push(true);
>         err +=3D test_heap_pop_push(false);
> +       err +=3D test_heap_del(true);
> +       err +=3D test_heap_del(false);
>         if (err) {
>                 pr_err("test failed with %d errors\n", err);
>                 return -EINVAL;
> --
> 2.34.1
>
