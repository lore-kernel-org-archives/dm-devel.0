Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414CB69E0A
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954832; cv=none; b=lBQasTrMcdyxMPH1C0YO0tNojtYZx6JXp5RdTQtZ+Qom/fr//RK1p4aK/EUE4kqws6nhRjweSrm3v7RQe8EobvW9ZEMF7Y7pOAKjX3esVyoCIOgVMGI1RYlxpvlnEIjWOyudCSQSGkfixQNieimo/id8D7AFgjf4qvN6rnH8eOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954832; c=relaxed/simple;
	bh=Z2QMshSRUV/Ic6Kf5osNo4mJkuPuXiVLb5k5is3/ucs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBfnGSWASa/HHfi8XlrpktGR76TOehy7upWTO2OutI5L4cfL1DB85hB+vyv5OJ86JUlBAAvsEANH81tQjGbMDqdACmVRnN4rsU/VWOkL5xFPRDilEYYVUywCFePjad6BtOLHPZ2mL5njfDtp3+Pwp49PnZvrvmeM3GGMiMIO1OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WaGKdXpD; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WaGKdXpD"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e058b9e479so8665ad.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 10:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710954830; x=1711559630; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+GdX2jdkDlWHWBVOsGIoAg8YOz++4sTFpjiRVGx7IY=;
        b=WaGKdXpDIBAbaZ7YL1FzwAyV/G86e1EFcSW0uQ7/rIj9yOMb+PwvF77z8FhP8zXlRt
         KBuSoLdlCyTqcTdZt6zZDjBzo2fpG2hbvs81ydICNOejkygsaO7ltYkKM+RGA/KknfKc
         JYDWq82N/CVFAEzRaFauB7GM6KdqSE+O3K6bSpBRsn2ZcUKn69P04DY0pR0X533tQK4w
         pt2fCs4X98AKwJUb9AUPTFtL5OoVWrRRis5f/GFJ/FFjxpmj7hmCAR5xVW6PraLyb/nb
         QFlTfF1epkYgKdwm/oNZP03znbuCLBXwZWdZmA5ZggP664yntW/aNNj4C6y7v6dPf8MX
         maaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710954830; x=1711559630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+GdX2jdkDlWHWBVOsGIoAg8YOz++4sTFpjiRVGx7IY=;
        b=p1u+srkWLanCrSPlipM22RCGk1Zl6su1eGImvU9bw12GGmgEU9rRTxxwLvDGn7FBoM
         N0IbDXArFk+obHEKpzIMnphpkSRVZ7AXkBdycDqgl9WvYkFZLURDRvtLAWT6tMoUaJts
         h3niFfUoVai7vs2NwiVfhHw5DV97TPSmteXrxYDhuOOf9DcdYXtpNm1vNb4rs+INIuYA
         c16SmXz9AkFH7wjU3d4S/ipi1TdlrESLAKQEkxhtwMUWcuxSQWluinHV6L+ZjQNMpaI8
         LeA4V7TJBrJIZXCcOqMC6afdHiLorLEGY3DK82A2n6kahRjeYj86D8E1JFe29L/zLsht
         61Xg==
X-Forwarded-Encrypted: i=1; AJvYcCWA0443SSuYDmkP84X9AXOT7CJR7JEoEbXAmR/qMVpRKm5HyGKWhexRNETVc0eWmt9GB/cE3bZ1IW4MrwnppPueZkAnXcOSoUY=
X-Gm-Message-State: AOJu0YzQu0piPir7dUVq99wHvM9VWi8TP+xxX2GDXXK8eezsQjbYmzXa
	UV0B8A8k3Hn4Sm/aWP654ZfwKdbA0dGdtjbp8SrmZDPbnut/Sh1mz2qQ31VX4hU8RhblEcQXnG4
	mbI+WJEKz0N30PotNvX2/noMK425kChGYeqeE
X-Google-Smtp-Source: AGHT+IH0qAID20MP6jp6NpXqn9mW2kuq00RtO9yb0PwCHdZ99yKuZBY632oWoHKU4JglvZUaklYHu5xGsWpmsCAynaA=
X-Received: by 2002:a17:902:6805:b0:1de:fdbd:930d with SMTP id
 h5-20020a170902680500b001defdbd930dmr312651plk.16.1710954830070; Wed, 20 Mar
 2024 10:13:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-6-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-6-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:13:38 -0700
Message-ID: <CAP-5=fXcWRfsAnByOnX5z6aBJrW6+CLRpj=bQ6uiLM38OZjbRw@mail.gmail.com>
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

On Wed, Mar 20, 2024 at 7:54=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> Add min_heap_init() for initializing heap with data, nr, and size.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Thanks, is it possible to update lib/test_min_heap.c to use min_heap_init?

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
