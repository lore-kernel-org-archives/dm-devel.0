Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278B68835
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 22:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g+EaiNkh"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7b6b4c2f1a0so2084144241.1
        for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 15:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698705745; x=1699310545; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4Xfwsz1oJlkefwpBB8y7aaULUoJ88otHslpIuLKkVg=;
        b=g+EaiNkhLHtddTuU8pTRSe+WciqxqfIk55BNau1mbbrr0BeGvNqCy6SBipA8jNE2LK
         YSJm0ByQ5WslYy8PvC2OPFFcuDrH5rOdO/74q2PsM1bBLf1Lerhqn4bppr2SL/Qw3Tr/
         NqpRb+vn3oc1d8lIEaT2fjaknHvJ398uY3ZkxD3u56dGaPks3l7bOfaYp/cxT5oo96WT
         ei1u15s/GkY+MOI0qGW44l+jpi22QyKqGsylrS0yVg895a6Tz22TTuTUiPsES64R7/X/
         vDYaPXqUMGSl4PpOYuoHSoFqqnylcVmzNY6WS9xqwoNs6fxSCYLsFtZFR5u+qfFBIqGh
         ykGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698705745; x=1699310545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H4Xfwsz1oJlkefwpBB8y7aaULUoJ88otHslpIuLKkVg=;
        b=Ai6Zn/5XdKJeLQHoi2DciUtLwq/aRcSBYl+y3zpXN4Vfjjk2Rr5TYg6El3fhp0sb9j
         JnFvD8uP56X4kZEFnLwehVzoCFVwZzbwN0a6S/QSCdpJ5GOjZBsma4oWRdTNZSKnBHxM
         XdXGkepCWt1Teq1UocMeQO536By0s4j1iGNbShnMoMvbI74Bkk1RonGyzadCUX4+QWTL
         iOm+riLe5BeKEIOLBXi0nK2IUvlLiqHOcFpGHljFOFQqEi7y5M29Y9vb1M5d9dynXufX
         UYp7G4ki23G1SUBz2mWyE39VrBix68k/40PX7RxAiq/xogUnrlY6SmZIBazzbQeb3dMh
         LWAg==
X-Gm-Message-State: AOJu0Ywf7TLxEGPPimbmfeQ5gJ0ItOmJO7TCZXDeytYDCDnnRR1N+lp6
	xqCtv25GDY9kPVhyRDyL4ocJYmKtd6e0YOeGZZuDQg==
X-Google-Smtp-Source: AGHT+IElSIreengSYfX3J9F+wjAA/z8qeUHV2jxyky2FMN1F5OkngNrqiAGehwXeGLl8fUjyDlcjlGhUu07FRU3iJEo=
X-Received: by 2002:a67:e0c9:0:b0:457:cd8b:57bb with SMTP id
 m9-20020a67e0c9000000b00457cd8b57bbmr8964903vsl.29.1698705744671; Mon, 30 Oct
 2023 15:42:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231030023351.6041-1-ebiggers@kernel.org>
In-Reply-To: <20231030023351.6041-1-ebiggers@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 30 Oct 2023 15:41:46 -0700
Message-ID: <CABCJKufw9qsPKZw9iQVFWzVrp6Qh5LPWQY2yc+8Wadn5R7ecOA@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: hash blocks with shash import+finup when possible
To: Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
	linux-crypto@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Sun, Oct 29, 2023 at 7:34=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Commit d1ac3ff008fb ("dm verity: switch to using asynchronous hash
> crypto API"), from Linux v4.12, made dm-verity do its hashing using the
> ahash API instead of the shash API.  While this added support for
> hardware (off-CPU) hashing offload, it slightly hurt performance for
> everyone else due to additional crypto API overhead.  This API overhead
> is becoming increasingly significant as I/O speeds increase and CPUs
> achieve increasingly high SHA-2 speeds using native SHA-2 instructions.
>
> Recent crypto API patches
> (https://lore.kernel.org/linux-crypto/20231022081100.123613-1-ebiggers@ke=
rnel.org)
> are reducing that overhead.  However, it cannot be eliminated.
>
> Meanwhile, another crypto API related sub-optimality of how dm-verity
> currently implements block hashing is that it always computes each hash
> using multiple calls to the crypto API.  The most common case is:
>
>     1. crypto_ahash_init()
>     2. crypto_ahash_update() [salt]
>     3. crypto_ahash_update() [data]
>     4. crypto_ahash_final()
>
> With less common dm-verity settings, the update of the salt can happen
> after the data, or the data can require multiple updates.
>
> Regardless, each call adds some API overhead.  Again, that's being
> reduced by recent crypto API patches, but it cannot be eliminated; each
> init, update, or final step necessarily involves an indirect call to the
> actual "algorithm", which is expensive on modern CPUs, especially when
> mitigations for speculative execution vulnerabilities are enabled.
>
> A significantly more optimal sequence for the common case is to do an
> import (crypto_ahash_import(), then a finup (crypto_ahash_finup()).
> This results in as few as one indirect call, the one for finup.
>
> Implementing the shash and import+finup optimizations independently
> would result in 4 code paths, which seems a bit excessive.  This patch
> therefore takes a slightly simpler approach.  It implements both
> optimizations, but only together.  So, dm-verity now chooses either the
> existing, fully general ahash method; or it chooses the new shash
> import+finup method which is optimized for what most dm-verity users
> want: CPU-based hashing with the most common dm-verity settings.
>
> The new method is used automatically when appropriate, i.e. when the
> ahash API and shash APIs resolve to the same underlying algorithm, the
> dm-verity version is not 0 (so that the salt is hashed before the data),
> and the data block size is not greater than the page size.
>
> In benchmarks with veritysetup's default parameters (SHA-256, 4K data
> and hash block sizes, 32-byte salt), which also match the parameters
> that Android currently uses, this patch improves block hashing
> performance by about 15% on an x86_64 system that supports the SHA-NI
> instructions, or by about 5% on an arm64 system that supports the ARMv8
> SHA2 instructions.  This was with CONFIG_CRYPTO_STATS disabled; an even
> larger improvement can be expected if that option is enabled.

That's an impressive performance improvement. Thanks for the patch!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
