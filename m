Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A29211A2A;
	Thu, 13 Feb 2025 10:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739441423; cv=none; b=O2cLktU/ypQMSZvBxBnQ+UznrWnMD7k6ib5cg8eI3QZpBzMxpJPY5vTryX1mwpJEqArDgodk2itubV5OdNfaKN1RBxQu7iKvu8ra27fhAJUZrqYpZ5Lcdf7ohe3dqFKmPvlHYlV4U4cpli78sRkH1VmgCKScLFCOUR20GplWTtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739441423; c=relaxed/simple;
	bh=42FVAKglSdA4GCM9HFlOhDKZOpyrLuyiIonz/DiE3L8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TFHKZJ5Fc/rWuU0ijpwao0zkxDmdFi33Rm42+nusNneoEeYuMLIM2nYFbtX6dfLTesl8iewXyRr39v8eX1Hajx/i6SsBhG/YWCt4/b1DIO9CNIdO0jUBLaYXjKedplpVwJWNMT9HI1lpZpjoErCs5ep4p09VZVZw8M/pHQvotNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QduZ+V/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QduZ+V/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6C5C4AF0B;
	Thu, 13 Feb 2025 10:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739441423;
	bh=42FVAKglSdA4GCM9HFlOhDKZOpyrLuyiIonz/DiE3L8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QduZ+V/DRRjp2YWO++Ujfw3lygiGvik5JyzHxwkbzuCCpkjDQA2xTe9472qCN+Nmm
	 g8UPJBRO1x11HRM2ivIE8CcqfDWwXrogX25VnK26nn9dKYYSxVlODPp0HlmILK/i/p
	 ILEi1lvFLnbPFZ1RBFxCyUR9zSS2JVm7RVMD5EUeUO5vRTsL2pHLncYcwgGow9yA1I
	 mYmv3jE4woQi5p93XX32ny0y8aYTG6xUG+cNojoNuN4gr//3nWs+4xcMdeJ3iK/26I
	 8RMuhd8w68G4+i9xGt3TiXQciFWBB6LoanAcebArn+JtR6Jr1P+7tTOJogzdZMgjnR
	 bu3Pc5MrK9oNg==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5450f2959f7so625061e87.2;
        Thu, 13 Feb 2025 02:10:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVGGon4+sA73cFtthPtvmsdFAz0z08Fm176hlLEKqVF15o0PrToYcVJpw+dz28locfEVfjp6Zm3Lg==@lists.linux.dev, AJvYcCVjZZAbVmXjBVwpykzxWmyjzzLMWMhRhR9rWcyNi2EPbd27SxroqdtGq6vQIhOnrOKUJvLnOD7hnbg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDeXe5g3TuebW27wZ20PQaDSKS4ePjR8h6ItLp5TwY+oeM0DuL
	yJTYM/5kyG/w25BYJ1umLsaxvNp3iv7JTeB0xseSE5/YQu8wE3dgLNK2o3IEb/+FOZoj5f79+hN
	k86TvGw/QRqJnzMP8K5k5ZVQK8Ag=
X-Google-Smtp-Source: AGHT+IHR+xr20cYmx6lgB9lVJM3c3+XAiEna+ZFlbjgJt6DHiy1GJEpnHOR+KpKMxfjEGw7dyQYgQ9iz1/SKleqfvSQ=
X-Received: by 2002:a05:6512:159b:b0:545:4d1:64c0 with SMTP id
 2adb3069b0e04-5451dd9e2admr736305e87.27.1739441421532; Thu, 13 Feb 2025
 02:10:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250212154718.44255-1-ebiggers@kernel.org> <Z61yZjslWKmDGE_t@gondor.apana.org.au>
In-Reply-To: <Z61yZjslWKmDGE_t@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 13 Feb 2025 11:10:10 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE+K4XbmxkXwzj9tHE2DP_A5pKLPPFv6+Fa=CtH8rD24Q@mail.gmail.com>
X-Gm-Features: AWEUYZkVud9S7L-5xo9HDDz6-H1l2qn4wDw7iDL4qi7FjFF8ciQmJoIc0opMONg
Message-ID: <CAMj1kXE+K4XbmxkXwzj9tHE2DP_A5pKLPPFv6+Fa=CtH8rD24Q@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer hashing
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, fsverity@lists.linux.dev, 
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Feb 2025 at 05:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Feb 12, 2025 at 07:47:11AM -0800, Eric Biggers wrote:
> > [ This patchset keeps getting rejected by Herbert, who prefers a
> >   complex, buggy, and slow alternative that shoehorns CPU-based hashing
> >   into the asynchronous hash API which is designed for off-CPU offload:
> >   https://lore.kernel.org/linux-crypto/cover.1730021644.git.herbert@gondor.apana.org.au/
> >   This patchset is a much better way to do it though, and I've already
> >   been maintaining it downstream as it would not be reasonable to go the
> >   asynchronous hash route instead.  Let me know if there are any
> >   objections to me taking this patchset through the fsverity tree, or at
> >   least patches 1-5 as the dm-verity patches could go in separately. ]
>
> Yes I object.  While I very much like this idea of parallel hashing
> that you're introducing, shoehorning it into shash is restricting
> this to storage-based users.
>
> Networking is equally able to benefit from paralell hashing, and
> parallel crypto (in particular, AEAD) in general.  In fact, both
> TLS and IPsec can benefit directly from bulk submission instead
> of the current scheme where a single packet is processed at a time.
>
> But thanks for the reminder and I will be posting my patches
> soon.
>

I have to second Eric here, simply because his work has been ready to
go for a year now, while you keep rejecting it on the basis that
you're creating something better, and the only thing you have managed
to produce in the meantime didn't even work.

I strongly urge you to accept Eric's work, and if your approach is
really superior, it should be fairly easy making that point with
working code once you get around to producing it, and we can switch
over the users then.

The increased flexibility you claim your approach will have does not
mesh with my understanding of where the opportunities for improvement
are: CPU-based SHA can be tightly interleaved at the instruction level
to have a performance gain of almost 2x. Designing a more flexible
ahash based multibuffer API that can still take advantage of this to
the same extent is not straight-forward, and you going off and cooking
up something by yourself for months at a time does not inspire
confidence that this will converge any time soon, if at all.

Also, your network use case is fairly theoretical, whereas the
fsverity and dm-verity code runs on 100s of millions of mobile phones
in the field, so sacrificing any performance of the latter to serve
the former seems misguided to me.

So could you please remove yourself from the critical path here, and
merge this while we wait for your better alternative to materialize?

Thanks,
Ard.
