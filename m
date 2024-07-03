Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1648616F827
	for <dm-devel@lists.linux.dev>; Wed,  3 Jul 2024 13:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720012675; cv=none; b=nDa9qldKSrLBE+XMyxclxMscV+rylchh6cu4E+pXWCpkfaNCc9oy+vmLa136fhTodyEG8QI8xncEzPDJdFp2MRn2R9j2whpuoOBAi881DLK4deqo273gJePJoO5N5FWIUNkr8jCQTeHe/v/6SqTzegFh04DSZWFFtQI/4Jf98DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720012675; c=relaxed/simple;
	bh=mcGItjPIizmSbcFM9bKM4HyIZ/49XolntPHiDMcp9ag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+glL+Q/T73HySDkezRK+ecsaZu6+T5WzCOh/EsQiSRnnKSZpPBbb6w65JOp4JSIJxiTeTFUIdBxaGPZUW+qPEy4F9N/Mgr7Vm5eo4lXxfj2mmTZaolyvDdUNdUxBbLtAo973LDGyHUIAODeivwckCUnRgmOmsPOk+XEp/BcL6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7U2+HaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7U2+HaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0239C2BD10
	for <dm-devel@lists.linux.dev>; Wed,  3 Jul 2024 13:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720012674;
	bh=mcGItjPIizmSbcFM9bKM4HyIZ/49XolntPHiDMcp9ag=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=d7U2+HaHLLuKXsswaZjzdSc1oogrs0c0Jy30AkHmEV+xoOnGtLoFSs/mbyTqfQV7k
	 g+QrE0AIO46YFDGztlttR0idTIcN77TJ+clHU3AsODzo0WyFhsVhEK+wyzRBu4ag+5
	 psrjRGh3Txk1abGu17rQ8BRpGUu0BdhU5v+0iy1/k/skjbVtsTG6X6Qp278IL6Vnk3
	 8DMqbpb0OvMi1y+tFoQXHzgU5QZ61VoFGmSFrPbqrZ1kX7H7ZadmiAc2eMHQ63FhQc
	 U8p6TMP23mdkTfIDuuDWO3Isr4zBwz2SYlo0cyZH7Bebl81f8yoQa/vhhL1ZzC5+6o
	 fu1DwBrfq54tQ==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ee7885aa5fso19568611fa.1
        for <dm-devel@lists.linux.dev>; Wed, 03 Jul 2024 06:17:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YyWfnhZI4tVW+rffdq0eFxWWZDEE1sdLV9WgbBgVOr6XPcZU0bv
	y36hlSXZaCrO5msYz31G2bzbsZsARA5Sp8PDhQrg9CxawRHE6tyqvGdqCuT9LKKAzYMRqqAQZIT
	3q0pN8mcMVL5sNNok2aPCH4l7M9I=
X-Google-Smtp-Source: AGHT+IGxiMiHuZepoOYlg+kJEX/q3PKXT9+A8fl7xUC9BzW4sDICAOJ+wx0eiQ+SRsbDaZpa/81iQUr99dGxeEc+zT4=
X-Received: by 2002:a2e:a802:0:b0:2ec:56ce:d50e with SMTP id
 38308e7fff4ca-2ee5e337926mr107347521fa.3.1720012673010; Wed, 03 Jul 2024
 06:17:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702064835.120541-1-ebiggers@kernel.org> <20240702064835.120541-8-ebiggers@kernel.org>
 <CAMj1kXFE45J9fDJ9XtMyJiUP1F-odZUmH0zLKkuZeWL_bLdDZQ@mail.gmail.com> <20240702171640.GA1049704@google.com>
In-Reply-To: <20240702171640.GA1049704@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 3 Jul 2024 15:17:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF2iCVboRR=6_2OnKYVf4+d3XHvgfwz21mWccxCVnOxeQ@mail.gmail.com>
Message-ID: <CAMj1kXF2iCVboRR=6_2OnKYVf4+d3XHvgfwz21mWccxCVnOxeQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] dm-verity: hash blocks with shash import+finup when possible
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jul 2024 at 19:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Ard,
>
> On Tue, Jul 02, 2024 at 09:41:19AM +0200, Ard Biesheuvel wrote:
> > >  int verity_hash(struct dm_verity *v, struct dm_verity_io *io,
> > >                 const u8 *data, size_t len, u8 *digest, bool may_sleep)
> > >  {
> > > -       struct ahash_request *req = verity_io_hash_req(v, io);
> > >         int r;
> > > -       struct crypto_wait wait;
> > > -
> > > -       r = verity_hash_init(v, req, &wait, may_sleep);
> > > -       if (unlikely(r < 0))
> > > -               goto out;
> > >
> > > -       r = verity_hash_update(v, req, data, len, &wait);
> > > -       if (unlikely(r < 0))
> > > -               goto out;
> > > +       if (static_branch_unlikely(&ahash_enabled) && !v->shash_tfm) {
> >
> > Is the static key really worth the hassle? Couldn't this just be
> >
> > if (unlikely(!v->shash_tfm)) {
> >
> > so that the ahash logic is moved to the cold path? We need to
> > dereference v->shash_tfm right away in any case, and if it is never
> > NULL, the branch predictor should be able to remember that.
>
> The value of the static key is indeed marginal.  I included it because of the
> precedent of dm-verity's existing use_bh_wq_enabled static key, which exists for
> a similar purpose.  As long as we're going through the trouble of doing that, I
> think it makes sense to use the same pattern for ahash too.  It's another rarely
> needed option that can be patched in in the very rare case that it's needed.
>

If it's an existing pattern, fair enough.
