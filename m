Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B083C092
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 19:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710878386; cv=none; b=ovq8xkrV/2Cz6aKX6ZNdTs9k56DNI+kGvcvAcwMYV5uCum9FviBVW7ayej+h2eW8uUuE7LjZtBKTDpaubMrKGeleceiOWaA5oziwYl+BykteaevgpHOcCgfEkZ0Gpmg25tY5joA31p3K/DLzIaNMtsjB/XGACy6LjHv9Ej26xbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710878386; c=relaxed/simple;
	bh=5F9GV5774xtDFEEGdDVdO5yEYWYXmfsvieiNhJPNsC8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUVnEzhqdxrcj7EatocaR6u+T5eM/4chglIPzBOJeLcXQJV+nmH4pnTUuB+H81YKM3wSCcOUTUi6B6t/hcrDgbRO+2mgoBM3XK6VWi+npYwG2BA5wBRQFOHhh/jgs/I+yJPZZ0SmtDIrg1cf4pRXIipUha0HdrxqB8RtTpD0jZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CHLAJdFI; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CHLAJdFI"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dee917abd5so2995ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 12:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710878384; x=1711483184; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DobisIZIdWT5fAMjugODSdKj/CsBUKizI1tCDIITWoc=;
        b=CHLAJdFIspPKaNG6BP34DItZCJ+jEgUQAryG12ClQ4VOSvGqWD/i0mtFfC/iRGFiXm
         ZmuNdh3jhv85pngH2Xqq59j4do5nbiap51TsJ13026UP17gNAlQ0ZAeRBkrzB5wqJE74
         O/AVzy9HZqrbQB5vnFrnPFz+Hwlmgum5LvAj94Y+FMkHaGkmEb0A8cnewEs0qhr3R4zW
         1OvVj4JiYEA3cmvPz0cOtexzPqoEjY2sVGbs8dakvM1EUW6qyabK24JUL1sOarFSJ7A8
         /N0aYhZ6YY2uAdTqBtB2i08l9A3EGLsLp+kOSH0PFo5vwh5tDZVFvhg1CLOXJSG9LvRA
         RQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710878384; x=1711483184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DobisIZIdWT5fAMjugODSdKj/CsBUKizI1tCDIITWoc=;
        b=Xhe6GX0rI2lZMQIzpelqos8cFP2zgATR4zd1STEFGdN2dPto3JsNPb0KqNSE9ew9zM
         ShwerlWk3du3mAbM8gDJQGtRaprbs9RdGYiR2I8s4I+Y3Z+NhSMh1eLs3+sSHmL8UAAH
         iziO8LhQSfApCng97q/2BIHutYdgwbW7/sPHc9yr89QlvO/aFez3jv/33Fwmf4IHA4Qy
         1VUDLukk1GjLVHESMQlvZ2SK4v/az2jfG0VqcOvitJjYRwi5WM6hrMhBYMUY94OuMGq1
         hYE8vm21EBI9qivLC/BXZrtQwwoW4mfG6bCF02MKvAHFErB0/0oMYvhIxcE3OaOfj2kv
         0Idw==
X-Forwarded-Encrypted: i=1; AJvYcCXZenav0iRaTkMRbfR4vhpyyvUnD3AtwDIRn5MIzrpoJkW9VcCdADPmkAuzQRLNK2dejSXtpJa5ICrATITlEdbGSQuK1MMztB4=
X-Gm-Message-State: AOJu0YzfNPpbWkzhaivhXcm6wk606wcYvpjq0KNhRFyqgtEQJ1eeQWTO
	IaaDVe4qN905UgdnqofE8ItgtYX69iU6SxMYl9BLDY1+CRy8JXznxM5OVMMbYEc2N9A5/BGK91E
	uA69qH/IWMXuWBIpEtkzZjRCJjFT35gvOBXBC
X-Google-Smtp-Source: AGHT+IHKYWLHUpxloLUH+NKyvBuPDnmTq249MWbzWivuQqJ4VjbGHKTaD+z9zajEi+vi9n0XoP3Own5xUGSSExIU1xI=
X-Received: by 2002:a17:902:d4c6:b0:1dd:b010:8339 with SMTP id
 o6-20020a170902d4c600b001ddb0108339mr65089plg.8.1710878383639; Tue, 19 Mar
 2024 12:59:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-12-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-12-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 12:59:32 -0700
Message-ID: <CAP-5=fXKU9uS-F=G5q8jEdCGC8tS9uM52TKjHOE9aP7yXb6RaQ@mail.gmail.com>
Subject: Re: [PATCH 11/13] lib min_heap: Add min_heap_del()
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
> Add min_heap_del() to delete the element at index 'idx' in the heap.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 154ac2102114..ce085137fce7 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -199,4 +199,28 @@ bool __min_heap_push(struct __min_heap *heap, const =
void *element, size_t elem_s
>  #define min_heap_push(_heap, _element, _func, _args)   \
>         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func, _args)
>
> +/* Remove ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t id=
x,
> +               const struct min_heap_callbacks *func, void *args)
> +{
> +       void *data =3D heap->data;
> +
> +       if (WARN_ONCE(heap->nr <=3D 0, "Popping an empty heap"))
> +               return false;
> +
> +       /* Place last element at the root (position 0) and then sift down=
. */
> +       heap->nr--;
> +       if (idx =3D=3D heap->nr)
> +               return true;
> +       memcpy(data, data + (heap->nr * elem_size), elem_size);
> +       __min_heap_sift_up(heap, elem_size, idx, func, args);
> +       __min_heapify(heap, idx, elem_size, func, args);
> +
> +       return true;
> +}
> +
> +#define min_heap_del(_heap, _idx, _func, _args)        \
> +       __min_heap_del(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _=
func, _args)
> +
>  #endif /* _LINUX_MIN_HEAP_H */
> --
> 2.34.1
>
