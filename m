Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD2C5FB91
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 20:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879228; cv=none; b=tMHOCWH8aA1gfcX/8hxMTXC7jUiMp2/0Cr0I1Wv0zEmRwhzaBrUhCd44nykycXwzDtD6wGWnk/bhhLxQfCGbSZ4UN20//sjv/7q3J5RNrcE3f4TsdVW5HIG7J4T7cpT+OycqiwNUzYl1mSbeFIKDs1diYJpzSwyDaoXC2zmWKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879228; c=relaxed/simple;
	bh=TEI1l16U8O229iRg+bnRlquzTRC42x/8zMW3wG5XbLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KsadZ4ZMYcaLkn9IWJZIQvacMNi0FrtRTnXMeA52/11Px7XY0FdaC/KrQpUQjckhkpOrd7XBUiXAY3sLVtOm7RG+z30NnrinjNzOHN0WUJ4kUkcSWbyWybUv/Nuyywf39gB6QJphgM0fLJ2UK/aQLCPx5SJ65N3eALDFC9a3PGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ywv+RP2; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ywv+RP2"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dee917abd5so5755ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 13:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710879225; x=1711484025; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61E5NQ6/YcOhVh/0k2iDBO7WpqpNwA0nbieT/ua9ouc=;
        b=3ywv+RP2/x9VLDyZjF3dVOcldIhs3UKI+SN8UFo5k/NBtH0jBpSgHyePuAReFurnT6
         Ce13MXGgyJxVUZhTc40DKNPaV+W8yIgQk7Deeq2P8jN0hZTIJeN4xyAcKW4KS33Mym9n
         xqojm1Ek5MAAJzDLpXuwxMfAutA5fvyZCU0U7farj0UJbF4h0fToJ6x7rzo47KcRNzrQ
         kUnAzRjvuMquryZQUVISJqY0njBtb1Kl7zvc6TR4JXZ2oBqyqgCLL0b578U+YczZRvqk
         MrVT5G/ttRyYUha93eWA4pD4z9SBoaE4NkccCcfsB1pLLoMK6ap1JbHJS5wg43Nzcyg2
         bjPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710879225; x=1711484025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61E5NQ6/YcOhVh/0k2iDBO7WpqpNwA0nbieT/ua9ouc=;
        b=AY+qcGf08rsBsHklGnTpwfvwRSQby6dmm30Ee5lNUIzz6+1L5KxzVLS5m2inJUGNJe
         ggEllLUC3gxBRBTs6bOUNji5z2Wu75PpjNYiRT1Wjyuul9lvNt88afBHrPgnzUg7gq+5
         7137qZN0qK7B86TvYShfBdsY88E5DLvTbpSGJtSqIC2DifhlqU7jaDfyfrpx9AjlckHh
         sHYxVXyXPbA2hg0FvVRlr8lGkIA6TgaNlPBX6oVtZgN7Mp5ctxakAeLdp0/OAO2SCpCn
         qqpH0L+gILcRl8OiGCrZjH0u+6W3gEXerlFr7hSmQf9STY6rE7pb8eseJgdkAtB/K9F7
         PAUw==
X-Forwarded-Encrypted: i=1; AJvYcCWsrxwjRV6wvWakfdsOu/01PZV4v+dIq0v8j7BVlHT0vQrFVPFUE85xXbzmwFs2iJSayhodmop7r4s9l4BWKUpY4lYAgTtlnDI=
X-Gm-Message-State: AOJu0YweuyKExYVfbMQptJ0iRRcM+CI0RPgtkbb5ZBfMwnpC/DkZeYeN
	5A/fBaEdPkbUo3Ys2Ag5uEr4WE13kQflJXMLqMAaCH3Y9rQu2yMNRV80inhHIir7jZNLq/FoZHc
	oljaJQvKMkgoDU8vAzLjCPbKDBj/NQeFeGH7s
X-Google-Smtp-Source: AGHT+IFREg9SwBdMDFnHH3n5tmN6yW8u/tyc7IrpIagXi7ukyBFEM1dN3wdN7uqPHmnG3vaEtYonkph3M4qPe2lMJDA=
X-Received: by 2002:a17:902:f691:b0:1de:f0f0:90aa with SMTP id
 l17-20020a170902f69100b001def0f090aamr68484plg.26.1710879225101; Tue, 19 Mar
 2024 13:13:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-4-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-4-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:13:33 -0700
Message-ID: <CAP-5=fUy=m2_f7jKO_kn4+onto5As2fUwrcNBtKEh8uObsNvYA@mail.gmail.com>
Subject: Re: [PATCH 03/13] bcachefs: Fix typo
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
> Replace 'utiility' with 'utility'.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  fs/bcachefs/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> index 216fadf16928..f5a16ad65424 100644
> --- a/fs/bcachefs/util.c
> +++ b/fs/bcachefs/util.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * random utiility code, for bcache but in theory not specific to bcache
> + * random utility code, for bcache but in theory not specific to bcache
>   *
>   * Copyright 2010, 2011 Kent Overstreet <kent.overstreet@gmail.com>
>   * Copyright 2012 Google, Inc.
> --
> 2.34.1
>
