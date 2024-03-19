Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4085786B
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879210; cv=none; b=Ej/zCVoQs9K+/gYMnscl7oPjWLU47Dech1puEG8Q3/yKXh1hZfmNxtrsEvS02LLkiDOeC8ru++qkrApeb2f4tZC4YtiQh9B6DHBsTO7HvO1QFvAFDem16mU51N5BhyJJz8gG3qk6+TdcegWN5q7ZazHxB1OX3Tz5GlgpD1PCbMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879210; c=relaxed/simple;
	bh=+sQCudOZfuqXiUUoG5vR5ACJJLNxAMax7xwD1W4e41A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BWRFHku7HI1dtjk78pPi/lH+4WCnZH9almGsiufVUZ1Tut+YpuajxwnSZ+YIL5OZ9p4TtwWDiBHubvytnL7Jk09CXUTWn3VL/fI2zGHJyskyApiO1EAWamTWLB/HczPf4aSze4pK37jKyNtZmU+QFa8W23p5AL24NRkgMD9Ar7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a5YejVBN; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a5YejVBN"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dddd7d64cdso5685ad.1
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 13:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710879208; x=1711484008; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TmjIUAWre/OnPAbZKoo/CqmH4il78nzu/N6uFzuSi8=;
        b=a5YejVBN6Lb5/6SeDYs8WEAN4MUpnSrvF7eKz0iN1jZXNxNAcbstsw3wBTEZyjAh4l
         AS8BNVMVLwWpC4e14gW5EutVRDikdxxrtm9te6kKkIxwUx5PILPpjbmoR/47K9QBI/3h
         M4QuADdGGn0OYmi9LVKCrrsjk+Z5f9P7mKk4oBuwALG86BFZXepAw4lvkQXO0xe5G8RI
         XaNjS+8aVLyCQxreu3Rq/WULR33Hi0n5hqkyW65MMPzCZCYIgsRLLw1y2C1NGs6y8VMx
         DDpOpGbV8w5ImZF5FY6hiVl6Es4yGGoS2+TWFTCZ/7u+PeMt2D+VHVQfk1GEiVq1GlJc
         QG/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710879208; x=1711484008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TmjIUAWre/OnPAbZKoo/CqmH4il78nzu/N6uFzuSi8=;
        b=hXMUlQlxT2P7kIvBRW2MCLta3qFcgJPUuRekdyKSklQg8TUl5E2mZL51IdZkuxMCgQ
         1W/0WjLGo6tiwtjr9HVqfrFv9C2Ja+JLVk5ibD37w14cdZcbfLSwIYbFDfYR0oiGu+Xt
         HUKw4wF5ICeNgCVld5/uPrXdqtZjfrDicUVxrQ02nepqZ+16ZsZyGQHZRyRUKnkU/jqR
         hINiiPix/Mw6m3OXL3gDIyA80NSae9/BwKt/pxKBMjiUdIQlPgTTmEg0nIXv+7avxLhY
         jCXXvEnzK4Y6Tajlpi1dTtQybODnDPutowrc53aagXWkcwV8/x3LdkyJMTnvVxla0/eN
         u3sQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl1y72pzVcxOsUz+q++iCuwxjj1wYzZGVOqIVuk6n3OD1eSREl3P2pUwmbaecgoWS2IrRedaECXiUqOQ9GBbKdPUpWxJUJE9g=
X-Gm-Message-State: AOJu0Yxmcf1pe2CsKMLOhEjgZnx911AuIpQrnVjpeVoW4g29CKCxQKvz
	gFBi9NpMkXCllGTYU+lcYAORCWxbeFlahMQNPXsXaW2HBeG10rOvP3BmOTrhlMyc64XHxD6OHF2
	9bQA5Bt6vjWa7pUvS2VYtDCUNFTypN8DGQOHB
X-Google-Smtp-Source: AGHT+IEw7XqscOujrExd+TjwtySjz62M3/jll6P8bD2QCyweYla8m9DhRt5lU7Qo9n5jCXQMEtTIf22XYc74lAhBJZ8=
X-Received: by 2002:a17:902:ea11:b0:1de:ed50:41f8 with SMTP id
 s17-20020a170902ea1100b001deed5041f8mr65676plg.22.1710879207491; Tue, 19 Mar
 2024 13:13:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240319180005.246930-1-visitorckw@gmail.com> <20240319180005.246930-3-visitorckw@gmail.com>
In-Reply-To: <20240319180005.246930-3-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Tue, 19 Mar 2024 13:13:16 -0700
Message-ID: <CAP-5=fXvQoOOpCTm1FXqatzv-wCTYxAymjAu5Veb2fBZE6KivQ@mail.gmail.com>
Subject: Re: [PATCH 02/13] bcache: Fix typo
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
>  drivers/md/bcache/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index ae380bc3992e..410d8cb49e50 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
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
