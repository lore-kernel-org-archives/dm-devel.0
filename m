Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2026A031
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955045; cv=none; b=u/C8fjmqKFX8HA1P1X4sq78DDaPj6bBxpI1r/CrgheA7P5OGjiWmM8eitXAs12ee3SNJ8LbEx3s10POgoITtU14h5Co69tS65bnw3Aae7Krdg2TauNPoIk1h3BjRmX6LhhkcsWeGZ6OnAu+fVpDh350MCvT0Z5yhaH74zMmzdsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955045; c=relaxed/simple;
	bh=E27O7oDV0qY/I1mKc9MBZuLsSH7nRcB25vJ+wBcgPpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PY1XKuiUba6rA/yyIT2TGqtziExOoEVY+PPsKN0HX8OXw0bI6smhsQjDLHyevDITE/6xzgHMdnd4s0cfkjEssgP0RPFmm1p1GZGc4HRV2zDrIukLiLu9AcWGG06bqpBA0+PJzetWOz3BNO04biXEwxx/CzR8QzvsHaBHKC6jcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LkUNBsmc; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LkUNBsmc"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-430e1e06e75so24171cf.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 10:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710955042; x=1711559842; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dpUfckfHblkI2O0whTqTHBYzMNvVrRqXL/Jx1TZ/mus=;
        b=LkUNBsmcBeWw7ppNt9NGtnub4zBVWnlRqnos5fDezN2AV+JTmSPYoTRyYu9wSUsYJi
         hMacofrN9bQTNTPSXl+bGTkdyYyGSxGxSndjRzuvW8Aam+uEizhg8jQih/rJTrBihAxe
         9P4uiWeUVa1kHKXeEWNT4M2lZbrHigb9qjDlBewk0I+7lH7znim2P8LY+avdSW8+Z9mS
         x4he6PzVNGOyfqMKvjVEaI8UCznmCYDHuvN2NI2tVYgxhF7n5I8GHjQUjayYXkzn57m5
         mVj8pjL++VPKCh436FLbgCUG2su8Fq73PrkmmaPfrT2l9tuejW5DtrasocxSDYDKjnac
         gchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710955042; x=1711559842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dpUfckfHblkI2O0whTqTHBYzMNvVrRqXL/Jx1TZ/mus=;
        b=ZNyihxM2tj0+rALQGoGTfKAWhYmVRc6bkic6dmIb/BnQiX0S/ort3mxUeWMcWh8uQ2
         4p8h85YFLk8sCwxQVnUKz9Hl12CAvYN4sk2efck8Yon13XXUYz8krO144T9Pa8LI/7JJ
         OxfJzx+/FF2yN7g9tUprhVlVIMsrIgm2qj3yiqCiX4dLMvuMZiDpkhVF4KOJnKv0yI/0
         J6TFf+KV6FQHHSktjZrAQKMjVWyb0U3PVIlx7/+gJPSZLpf34E2dEA7UxwxDEgGLeUgv
         Cd9ZcMEz8/dqB9pmTdaH7l6H9/AVkHpx+fpzxxp99y5do5w40VMJBJfeM7OSj1nIj7vy
         5IVg==
X-Forwarded-Encrypted: i=1; AJvYcCXSZNr/72Xw87ffkCVE2RuiOc3xRwQozv8ZXf+6J0TrlodiGTdb41VBaxM4ZiANfkERYQKJm/n/eluKujB2IjOXU7cLCHAIM44=
X-Gm-Message-State: AOJu0YwFgSXjAJAWo+zxj2F9BM6sjHzJbVei+Kdb6HfzRHSttRjnBXjY
	e1VkjQP77aShXzfBXVnxTRpUvDeSj1ANUE0g71XOs4yVaabHBsgcUw5kO/QmdKX0MD+hoRJj6ei
	b5tJ2hn5ani8BcXol59mO6lSaUbgTJzysR85Q
X-Google-Smtp-Source: AGHT+IFLYdQAuPvBBhJS/6SJFiSfMmYOd8EZJYjEr8SWoFWEUig1E5IadmU/lhuafRa8gSpXkf/xKrC3O60jQR7iw54=
X-Received: by 2002:a05:622a:30b:b0:431:1d88:ce5b with SMTP id
 q11-20020a05622a030b00b004311d88ce5bmr34205qtw.23.1710955042395; Wed, 20 Mar
 2024 10:17:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-6-visitorckw@gmail.com>
 <CAP-5=fXcWRfsAnByOnX5z6aBJrW6+CLRpj=bQ6uiLM38OZjbRw@mail.gmail.com>
In-Reply-To: <CAP-5=fXcWRfsAnByOnX5z6aBJrW6+CLRpj=bQ6uiLM38OZjbRw@mail.gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:17:11 -0700
Message-ID: <CAP-5=fVPZ+Nt_wub1iTpN=pa-1zJkeS5Sa+XHmG6=DnuWLiyNQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/15] lib min_heap: Add min_heap_init()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, dm-devel@lists.linux.dev, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2024 at 10:13=E2=80=AFAM Ian Rogers <irogers@google.com> wr=
ote:
>
> On Wed, Mar 20, 2024 at 7:54=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.c=
om> wrote:
> >
> > Add min_heap_init() for initializing heap with data, nr, and size.
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
>
> Thanks, is it possible to update lib/test_min_heap.c to use min_heap_init=
?

Found in patch 13, thanks!

Reviewed-by: Ian Rogers <irogers@google.com>

Ian


> Ian
>
> > ---
> >  include/linux/min_heap.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index c3635a7fdb88..ed462f194b88 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -44,6 +44,18 @@ struct min_heap_callbacks {
> >         void (*swp)(void *lhs, void *rhs);
> >  };
> >
> > +/* Initialize a min-heap. */
> > +static __always_inline
> > +void __min_heap_init(struct __min_heap *heap, void *data, int size)
> > +{
> > +       heap->data =3D data;
> > +       heap->nr =3D 0;
> > +       heap->size =3D size;
> > +}
> > +
> > +#define min_heap_init(_heap, _data, _size)     \
> > +       __min_heap_init(&(_heap)->heap, _data, _size)
> > +
> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> >  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> > --
> > 2.34.1
> >
