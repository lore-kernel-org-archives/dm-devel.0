Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9333BB25
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710877899; cv=none; b=ucm92RO/Q3DLXKkvJknxcX72JOx8IH6HFNenvqafQLy/d5zIAjXZlqFfx6/Y+dMqt8vkjyY6wJYQChsVSr/5ZdnOhDhARZqo+8ku+oIY1L7UkjWX/uNKWrCky/b62cPX1wOw3QtyGZo+1jHI7c1NysEXX0ih8A//KZuJOo4QNac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710877899; c=relaxed/simple;
	bh=u5ISTVgLFXBHPytLP7czQVcemEzdgRVw+u5krgsn5QA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mWUnC9kj1fCGa5FWdxhuThaT23fKsN0xHy46kMTAg0M7cKMte5UcqWvo8EWGHkYBIpUxQ2/bFGmXjb9ihCGqrJgDhwehNCjPCyeF99f5M30ddqM9swsc1Vft0Wbkp8jFT1a33VjBYcQvZsDucGLGKqc3QzZhniyTiINXmPGcdSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vhTGYM9t; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vhTGYM9t"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dee917abd5so1335ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 12:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710877897; x=1711482697; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TkXuhmLGM7c9bdHQNzOA0SGeCtxI5tN/gqKMMP6F0c=;
        b=vhTGYM9tYpEIXSmpKLy4guxpbOdF3wm4pidQfByLIYFpU6sXRRp5H9RHhnUvnqVzfi
         Q3gKTTe69efUnWoGXQSWwmpdA0/meJnq0buEVuhH2ULRFWB2R/KTPr6ylOmtQ6NQjvBs
         teB06zPM8v9QWw2sIKS4VF3ji1B5fAqC8BXzVY1Ilt3pdaObrqhQQFOiyt1gXprnZ6CZ
         s1XAKm2qJSiylh7qSSt5gj0f9UodVtpqJx/jRkz8kXYhDjIxn5ks0KehyPwJVycyxaml
         54HK2VFLneQYOFnbOLu/jqdNjMwJbgDSua5B1u4dID9q04DsKyveHalKLM9GMf3xZM8M
         /kAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710877897; x=1711482697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0TkXuhmLGM7c9bdHQNzOA0SGeCtxI5tN/gqKMMP6F0c=;
        b=RQnnxcJVnGZcPTmHf3RwwUBwoF/ZA+nx5zAUlWJOh9mMy6Csi/RhTMXE4IWs6T4s97
         g+LJTC9KCIslv/NS8kmy2UiJWYXn9CPh/UOyz2+fsvxmS+jytrtTRnlnSu8Bx0heQ5Fg
         QwiEkiZKulTHwyrRAQGEimI6Pqay+qK0VGh4ALkctDV+hVoQ1sm+kCuMNf4Yd2tMkxA7
         unhnEEjRXIkCr+8W/cPcU9OFZyYuudu/FG/SK6/qne9S3yTZ8KOsri0PdacD2SYyHSlN
         qs0aAqWFQ0wb/cKqiBYGHbpfMOU2DlF0f1hRCfqTrdu6ih/QiLA1nY4NMQdHWEKc7Vww
         AdyA==
X-Forwarded-Encrypted: i=1; AJvYcCUXXHotMUacrPLeKosYDm2B3PSJN86DUFm3SKgJWA6uWDdtFKoqdu+lutlUUU7OmyVmlDDXs3qoBgx3r2pM85p2o7JODC6YS5E=
X-Gm-Message-State: AOJu0Yzn2j6jCyGnZ2dE4SuZT4igfhdepIYIJ5JFtbh/uRpjx6KEoovv
	X2U6e79pVnqwxupxY6Kau+2U+KjbEXWjjRS3pa2rv3iMVcBT/o5z51/ksP7pR4GjBjovj45g2Hy
	USpYMa40FDJuklgKE36BNyhwyXQL6R6jJbOa6
X-Google-Smtp-Source: AGHT+IF+frKKJWR+nVJ2Vrwk/OC3+PDYLd1fNu1rRucHMrbQJorul6XLTLfqlvUhZfZc5d71eG8DO7rmDaJ3MYo16Z4=
X-Received: by 2002:a17:902:ecc8:b0:1de:ff9f:e760 with SMTP id
 a8-20020a170902ecc800b001deff9fe760mr68290plh.0.1710877897067; Tue, 19 Mar
 2024 12:51:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-6-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-6-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:51:22 -0700
Message-ID: <CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com>
Subject: Re: [PATCH 05/13] lib min_heap: Add min_heap_init()
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
> Add min_heap_init() for initializing heap with data, nr, and size.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Should this change update lib/test_min_heap.c to use min_heap_init?

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index c3635a7fdb88..ed462f194b88 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -44,6 +44,18 @@ struct min_heap_callbacks {
>         void (*swp)(void *lhs, void *rhs);
>  };
>
> +/* Initialize a min-heap. */
> +static __always_inline
> +void __min_heap_init(struct __min_heap *heap, void *data, int size)
> +{
> +       heap->data =3D data;
> +       heap->nr =3D 0;
> +       heap->size =3D size;
> +}
> +
> +#define min_heap_init(_heap, _data, _size)     \
> +       __min_heap_init(&(_heap)->heap, _data, _size)
> +
>  /* Sift the element at pos down the heap. */
>  static __always_inline
>  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> --
> 2.34.1
>
