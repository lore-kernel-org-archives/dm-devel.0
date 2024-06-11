Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EC62E417;
	Tue, 11 Jun 2024 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120387; cv=none; b=AGywJKyrPATH0lMoBgm/eUqHmqPuS8bODpuoRayzS73LbM0E5u715lbETeAK5lJdkydMpb3K24Q8hfELJqknix6HNAtwltGEl4XKPnPPe+WbyCh+bAgtyR2US/prm4lQGJTpJ0bIjYLngRH4BM/5Qqe3AmMGZWb/AYTbn65GgHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120387; c=relaxed/simple;
	bh=l0Wz8/b/qUtp1MMRy0nBNac1T85JAy+dV2wUzOiVwmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ol2hWGK4QoDg3+Lbv6yS5BeuOdbNugmbLzadMld/6r6qIrJYCglueaBeMl5/GfiuaLcZdcHiONNDB+zXKOwmVxIi0B6RtOg4rcZ55UgSqw4UjPD07s8KFQergqQsbB7fto3pm8Iv7ScFgq2sjcu82yca5asf80RSjROV1VnniOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2mckJAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2mckJAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB9C4AF49;
	Tue, 11 Jun 2024 15:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718120387;
	bh=l0Wz8/b/qUtp1MMRy0nBNac1T85JAy+dV2wUzOiVwmE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t2mckJAW+oe1EJP7zUAW4wC/6q5Fvol2jDGiPnlHM86g+Bmevz63HuvAGuvUgTNOO
	 XJLwtZLybIuXwwigMd2WDyLECknlRHJi0YljL69h7tOV44WHr1GPA9bhQH1wZy8TDD
	 0roD58YLFsI+LKpGXOMGd0aKG4JPNI+MIrPy8Mc/6gUUl/kmumW5IDyU3z7n3/aWtX
	 sEGslOsiG4WRU9y2u3Etyk0VFygoHuE0uNO0qSERXsDgo4Hfhb7IY4lijRcjrL0jy2
	 AlKAQkL18Mqq9zZlDuzvI0AhI3XS24DwRD7zi+YXNimLuhY0ip0QOPyp7VeYl/GanV
	 Iv5nhcoON8zqw==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ebf5b259ffso6655351fa.1;
        Tue, 11 Jun 2024 08:39:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUkWzADQkD2y7zznEbbKFBn8H8BoBX/yFDboQHn2utMdh3z1CVJlMfen6gphrwpsRKdQxGfbCoAau7TufyNG93qgQ4MtVDTThf2hMJ6AzEKalrogINOLz8P1fG9RZenH9APvg==
X-Gm-Message-State: AOJu0YylA8MdrTIfQRXoj0kVp8KRvLQIRy3oj4cl8igAHncc88D07AVP
	vmAeLa27q2gN9sOOkjwrbpC5dDB/zwdQF3uZQq6fu8/rpsq1hwJw93rV3m8M45k8M3c7oBYUj9/
	vfh86w9fvmT5cIsUDtbk3zEs5yqg=
X-Google-Smtp-Source: AGHT+IG7spKY3y+DQ9xLPb4U2LQpkYUyRr8Ss4KXbBwBVzSY5CCFccY0Sgw+PVAc0KrPpFXG2WAsUBCsAxkXHbZ4isI=
X-Received: by 2002:a05:651c:a04:b0:2ea:abac:f97b with SMTP id
 38308e7fff4ca-2ebf1039edbmr12147351fa.4.1718120385336; Tue, 11 Jun 2024
 08:39:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240611034822.36603-1-ebiggers@kernel.org>
In-Reply-To: <20240611034822.36603-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 11 Jun 2024 17:39:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEi1LGNu6xwxkAGg_b7DQh4092Y9vb4dobhkB5tbxjsQg@mail.gmail.com>
Message-ID: <CAMj1kXEi1LGNu6xwxkAGg_b7DQh4092Y9vb4dobhkB5tbxjsQg@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] Optimize dm-verity and fsverity using
 multibuffer hashing
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev, 
	dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Tue, 11 Jun 2024 at 05:49, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On many modern CPUs, it is possible to compute the SHA-256 hash of two
> equal-length messages in about the same time as a single message, if all
> the instructions are interleaved.  This is because each SHA-256 (and
> also most other cryptographic hash functions) is inherently serialized
> and therefore can't always take advantage of the CPU's full throughput.
>
> An earlier attempt to support multibuffer hashing in Linux was based
> around the ahash API.  That approach had some major issues, as does the
> alternative ahash-based approach proposed by Herbert (see my response at
> https://lore.kernel.org/linux-crypto/20240610164258.GA3269@sol.localdomain/).
> This patchset instead takes a much simpler approach of just adding a
> synchronous API for hashing equal-length messages.
>

I share Eric's skepticism that shoehorning this into ahash for
theoretical reasons is going to lead anywhere. So I would strongly
prefer this approach. We can always revisit this if/when this generic
multibuffer ahash materializes.

So for this series

Acked-by: Ard Biesheuvel <ardb@kernel.org>
