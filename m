Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168CC6A326
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710955014; cv=none; b=SjHbzgytuIjEcLzv8wB/3bZ7MlUO8FeWd6oVnUSz2Tn9kIBaxsQJDfZJ0EKkVAEg8OdgxiXd24KS/H50lCRVdu7L7ow4fcmrXd8F7cd1yArBGBY5SS8nsTUC4Z3WeduuSyEQfsyUeIjhgXxLgMdatwI3MKV5YMlndQjJID+X4Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710955014; c=relaxed/simple;
	bh=PTgza+W1/v68t8gIEmwRzft+VKxQNQUrzbgfRmoXdEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fit93KpMcpleLF8fmdWEYUJ9HNo+IqmQzlToJHE9G0qiCEKmYI2jKykaaa0Z3+AWKU6pn040u6wmY/oiblt8Ybk2YAtlrbp3aQTgQRM/xOax6Wy1PaKJkq9Mey673NBG9n4aMf2RNVt9Efo+FFG5FF/Vw4WYNPXIbIATcPcfLz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txulIOkB; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txulIOkB"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dee917abd5so7825ad.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 10:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710955012; x=1711559812; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrHJYPRQxE5Zvv5TnRibVQ4dHuC7YD8BtX+J00w7sAs=;
        b=txulIOkBOzv1bNrmayRqmLaEOYFhqBDXH8a3tlhuQBoBNnruVi+wDYML22LaMWbWCw
         F1GeqVzXBMbl8w6CA+3c8gyJwtA0k9cgyxWe+kfIR8s9SzkdIZv4xXBc/QTY7MI5SGjB
         tSbcLNtblMEAk3l+PxJWNcnqhvM0gwG34nHLj5vPQcAOdq062zV9jA+4FPQAU+Wm2K5d
         x+jxPeHSh21GMbmNnko74Xe+QE10fMqXmNeUTrrAbe3pyfFM9/RV+LbqSVP9whoW0EVb
         1XVM82rBW2rZxRfdYFaEAAKXo+9svg+zWgOANRs6q76b/KV2QFVX+1U7w0g0p1Q4+tvU
         r9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710955012; x=1711559812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YrHJYPRQxE5Zvv5TnRibVQ4dHuC7YD8BtX+J00w7sAs=;
        b=SAMFOvJKwx5kOvlZgZpJmZ9vHKTf7WWw78SJw+cNetIOrt6W5YssUXVQYpMNpSQGqQ
         98x7BNRrmrsvzyPfZUvlChitXFV1cjomPBnjAlVw95CRygJF9dlLcAOa6MCnq1g4z/tn
         6xn33sXxSfchMAisWYcBtil0vMUs7XGf1a2XPAfTqzdlT3Z2jOkEM+FD+C3arH0d1c00
         6l2N2h3J3PMQWs4UHUmGWFT5oYX36RfVrdE5emFHXB0+nWsV9u5qeVLS27or0RLyKqE5
         fUQhMbCyd3thhJa89Oqx+T38aUbczPxYSjfgLNcrgiropH7TsIBYf2QNsGmrEVeRpZxZ
         0qAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoym2TNVkUwLBs2H7KPgcOOaIoEkdE+GsRAsLB5A7AdTUgZK0lc1UJkvcScgMQNWhtIx5cbkW6/ZJqR0O3AD+PsNKixD/8Tz8=
X-Gm-Message-State: AOJu0YzXnjMvpXRcw8jaKWHkJwnmt16hECjYW2ecprAez69gZHhCHWLI
	lJl6pkL+kbq+ah5y+r+2v8vU5Qtg4J/pyBuo0ZrQNkElYjhECy1Xz9IULt4bHgTPm10R0sgFtQY
	HfWzoctcLU+h2BsJCU1FFplHSs8TsuoCftt1I
X-Google-Smtp-Source: AGHT+IGhYuvoUpEMguGI9pVuujlqsVK7YxGeJA4BXDEYnr+q81vjH/5j0TsYhHOQkkJGzGl3Gg9kg0vfb28GWP26+Yk=
X-Received: by 2002:a17:903:41c4:b0:1dd:65bd:69ec with SMTP id
 u4-20020a17090341c400b001dd65bd69ecmr305677ple.20.1710955012019; Wed, 20 Mar
 2024 10:16:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-14-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-14-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:16:40 -0700
Message-ID: <CAP-5=fX-R=UGvb7a9hcFaRvWk-NiMvy9h2g+bKkTx5pQvjC9-A@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] lib/test_min_heap: Use min_heap_init() for initializing
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

On Wed, Mar 20, 2024 at 7:55=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> Replace direct assignment of values to heap data members with
> min_heap_init() for better code readability and maintainability.
>
> Link: https://lkml.kernel.org/CAP-5=3DfW+FvUu8JL+KrtVv5uC++4AW=3DVhyEOgmd=
WzpH1mswQNzw@mail.gmail.com
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Ah, got it :-)

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  lib/test_min_heap.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/lib/test_min_heap.c b/lib/test_min_heap.c
> index 062e908e9fa3..8d25fc8256db 100644
> --- a/lib/test_min_heap.c
> +++ b/lib/test_min_heap.c
> @@ -67,9 +67,8 @@ static __init int test_heapify_all(bool min_heap)
>                          -3, -1, -2, -4, 0x8000000, 0x7FFFFFF };
>         struct min_heap_test heap;
>
> -       heap.heap.data =3D values;
> +       min_heap_init(&heap, values, ARRAY_SIZE(values));
>         heap.heap.nr =3D ARRAY_SIZE(values);
> -       heap.heap.size =3D  ARRAY_SIZE(values);
>         struct min_heap_callbacks funcs =3D {
>                 .less =3D min_heap ? less_than : greater_than,
>                 .swp =3D swap_ints,
> @@ -99,9 +98,7 @@ static __init int test_heap_push(bool min_heap)
>         int values[ARRAY_SIZE(data)];
>         struct min_heap_test heap;
>
> -       heap.heap.data =3D values;
> -       heap.heap.nr =3D 0;
> -       heap.heap.size =3D  ARRAY_SIZE(values);
> +       min_heap_init(&heap, values, ARRAY_SIZE(values));
>         struct min_heap_callbacks funcs =3D {
>                 .less =3D min_heap ? less_than : greater_than,
>                 .swp =3D swap_ints,
> @@ -131,9 +128,7 @@ static __init int test_heap_pop_push(bool min_heap)
>         int values[ARRAY_SIZE(data)];
>         struct min_heap_test heap;
>
> -       heap.heap.data =3D values;
> -       heap.heap.nr =3D 0;
> -       heap.heap.size =3D  ARRAY_SIZE(values);
> +       min_heap_init(&heap, values, ARRAY_SIZE(values));
>         struct min_heap_callbacks funcs =3D {
>                 .less =3D min_heap ? less_than : greater_than,
>                 .swp =3D swap_ints,
> --
> 2.34.1
>
