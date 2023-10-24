Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF66A14ABB
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DweB8J30"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1c9c5a1b87bso32671165ad.3
        for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 14:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698183305; x=1698788105; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NHsb4Ex0pB6bm1QiWPhIzbrZDkhX+OINEs8BrrsAL2I=;
        b=DweB8J30HSahbQ+FREohMAqds4GeiWDFRTu1EQe+e95XTGpxynZM2jQlFADUZW8h5f
         GQbd4o7Utj4+LyvNzucgO6QltRGA03TTgZDv1rSFrvAeIWdDC+E0QHUjofktgmpvC/WQ
         GR40pY+sV097uHST7VvXD8z6irjT5pV1rvyzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698183305; x=1698788105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NHsb4Ex0pB6bm1QiWPhIzbrZDkhX+OINEs8BrrsAL2I=;
        b=nl+iCTnWvcH41lps7j68fz1e1YEjk3sjWdIFw0myXUxOpdYE0k6xselClTHK00Vard
         5eNmf5cDyYGpnlFkR8kZZ0pRQvroamamnGi3b7Qk2J20kh+NzCviY51H4LhB83bRBHKS
         yadY9Lbhi21NGF4uuPiCJhKjuHs39x0OJt7PTnbOqoAb1Y75d8c5U1vkAFIPh4rey2Wh
         6xCCeYIe58rXhiTwGWtJnGyaU9eGlnJgjo22L0ypxsXuFSdHC5wDakXhD97ZA3ZU2DM0
         FlLqYL2ioiGy3JjWzQbnqzYZFeWcKSJ4ybj+8/1gA8MXN40VlEl8T1krx4wkDkIEiOe5
         h9pQ==
X-Gm-Message-State: AOJu0Yyf+1t0ry7osNTZggxly7lzecWyQhDFnFYu3zNW6KiQWSYzDvUC
	EN6ATM+TaZtGXxW4/EA2cIEeOA==
X-Google-Smtp-Source: AGHT+IH8PaF/n/DrhVjd3Tfui8Frjxc0yy2UwijaAjvCygeAOMkANgQntYz5ozjGkte9ZI6XbWx9OA==
X-Received: by 2002:a17:902:ec8e:b0:1c6:d70:144d with SMTP id x14-20020a170902ec8e00b001c60d70144dmr14848663plg.34.1698183305222;
        Tue, 24 Oct 2023 14:35:05 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902eb4d00b001c9b384731esm7865117pli.270.2023.10.24.14.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 14:35:04 -0700 (PDT)
Date: Tue, 24 Oct 2023 14:35:04 -0700
From: Kees Cook <keescook@chromium.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dm crypt: replace open-coded kmemdup_nul
Message-ID: <202310241434.54EF4068@keescook>
References: <20230925-strncpy-drivers-md-dm-crypt-c-v1-1-eef875e4f9b2@google.com>
 <169818232968.2100071.5806064081646325604.b4-ty@chromium.org>
 <ZTg4GA005km7mmgC@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTg4GA005km7mmgC@redhat.com>

On Tue, Oct 24, 2023 at 05:33:12PM -0400, Mike Snitzer wrote:
> On Tue, Oct 24 2023 at  5:18P -0400,
> Kees Cook <keescook@chromium.org> wrote:
> 
> > On Mon, 25 Sep 2023 06:35:54 +0000, Justin Stitt wrote:
> > > kzalloc() followed by strncpy() on an expected NUL-terminated string is
> > > just kmemdup_nul(). Let's simplify this code (while also dropping a
> > > deprecated strncpy() call [1]).
> > > 
> > > 
> > 
> > Applied to for-next/hardening, thanks!
> > 
> > [1/1] dm crypt: replace open-coded kmemdup_nul
> >       https://git.kernel.org/kees/c/17348b0a6a6d
> > 
> > Take care,
> > 
> > -- 
> > Kees Cook
> > 
> 
> I had picked up this patch and the 3 others in my local tree
> yesterday, was going to push shortly... do you still want them to go
> through your hardening tree?

Oh! Great; thank you! I'll drop them from my tree. :)

-Kees

-- 
Kees Cook
