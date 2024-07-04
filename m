Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C1F1649CC
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 09:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720084359; cv=none; b=TLi/3wv5e5r6wQ+Iv684ZkHmSL+lWFyZUB/17AhpT3YS2QfaDOX+U394VkEO9wEJZcADW6rhEq2Vk0B+DkT/AZhyTQahrh1r79HEmDwEQQl3963G+RAe8A+KT/SH/6DWgRBOsAxIdZKQEGXEXkTVnhAN9f1dLo4+YcNNWydgU2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720084359; c=relaxed/simple;
	bh=4Zy3A/R03Ea9KVeiTELXbEtMjlgFd5QKpAtjvYV8Ihs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LPIIiCT7ETt1i2paeO+hHdtlr+OGYhOWFJ27uc+PKoLZ6FWRU1PI8p3B+zPgeHOhGyVzuG4m7TFe6nAj/HPTe+q/MLFDMNXRrl+b5Tsd2mEMiWxZZ+DT1AtWhZWU3pmdOHrIkiNkzsZxA5w0EncLXXNhoEWvgwwx3FEgo/RoX/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GpD8U0aR; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpD8U0aR"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e03caab48a2so15849276.1
        for <dm-devel@lists.linux.dev>; Thu, 04 Jul 2024 02:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720084357; x=1720689157; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cViqdyaOCwn+ROKlv4dtSt/nqrwCEFM0XP/6otHc2rI=;
        b=GpD8U0aRjlldHrecpE0Na9YGfMZgG2o9h3Ft8Vb373bFgj9nrqqA/tWDG02WpZvu1D
         26/EQB4M2d8sqAVs8h1I5pmmQwoq/W3p5CaKEHkWzVT4eSHJSTEud2aRV1DpRtEngzpu
         ox96PkeSk3/0fzp38IIkA2WBLhnzwzGx8pmhMlaknz4lO1wSbQXVZnbWV718iLd/Xwqd
         m0v2uPQblNdm+BZWW7Uw5/Dad6sP4C+gJ1s2zH+QGDfcWDeiEdMU44lva6z1SuiJEuvT
         HF8jGe1e5AnX83dNMH+g7w7pUnRN/di+tAldS8ocaCTFZEAPEApWfZUFxcayfuwWq2uV
         csPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720084357; x=1720689157;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cViqdyaOCwn+ROKlv4dtSt/nqrwCEFM0XP/6otHc2rI=;
        b=QP6xZXFKnCjl3WQD0gNmvZkwszcHlRWS+H/fXwET6s85g+C+r2jiXR5mnI2nlcCpmK
         i71aQvGcxIKCniTj4EneWb+7Y0j+ROuGV0I2J91fP5eIB1UvrlfDYyKzOarPhS9oixKm
         +mnWDzVb2wdD/jR4tRx37o1yIv51w9+6MYRjhvJHqNexAAtH+FDkH7jhzSCxr3mF5YzZ
         1Ax2DdfiMhlshvjkqRf0jxJ/xL3/d5MYbIBbpUzMsmZrTnlc8DNBW48QRvwjMw0B0aCA
         oseYSKpGtXmR/RhCYjwR3qFqyYG4vtGYazrH/qVHE9ZdzfXB8bfwDoIOeW/1YzMv6uA9
         ftXw==
X-Gm-Message-State: AOJu0Yw5Xhtz/Uq9kgZG5iZ6csGIecYS4lP0MudAbE11cIYzRCDP8p8I
	EoqbRm5pHVg+M3VwWRwNFEJTpaWsq2kdW8vDvAMHfWzevDDOf1x3MtP8hiKDeNrBNfYGuxbG0th
	sutQyLoU+n1glZ7kXLZK5/Y1vGp5kGUqq
X-Google-Smtp-Source: AGHT+IGK9cO/Y3Kx7AjnAWYe8aljVXMGzquzBsbgTcYH0VQHl/lZ4BXdt1YQTy3egddkXiJCHNq1qxeGr6bUrWVKjfk=
X-Received: by 2002:a5b:b05:0:b0:e03:61d1:2b88 with SMTP id
 3f1490d57ef6-e03c2a17390mr488544276.15.1720084356615; Thu, 04 Jul 2024
 02:12:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240617220037.594792-1-luca.boccassi@gmail.com>
In-Reply-To: <20240617220037.594792-1-luca.boccassi@gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Thu, 4 Jul 2024 10:12:25 +0100
Message-ID: <CAMw=ZnR9Eqw1Q6CnQhitBKHDGduQStVK7BfSPj-54xJjgSMqcw@mail.gmail.com>
Subject: Re: [PATCH] dm verity: add support for signature verification with
 platform keyring
To: dm-devel@lists.linux.dev, linux-security-module@vger.kernel.org
Cc: snitzer@kernel.org, jmorris@namei.org, paul@paul-moore.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Jun 2024 at 23:00, <luca.boccassi@gmail.com> wrote:
>
> From: Luca Boccassi <bluca@debian.org>
>
> Add a new configuration CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> that enables verifying dm-verity signatures using the platform keyring,
> which is populated using the UEFI DB certificates. This is useful for
> self-enrolled systems that do not use MOK, as the secondary keyring which
> is already used for verification, if the relevant kconfig is enabled, is
> linked to the machine keyring, which gets its certificates loaded from MOK.
> On datacenter/virtual/cloud deployments it is more common to deploy one's
> own certificate chain directly in DB on first boot in unattended mode,
> rather than relying on MOK, as the latter typically requires interactive
> authentication to enroll, and is more suited for personal machines.
>
> Default to the same value as DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
> if not otherwise specified, as it is likely that if one wants to use
> MOK certificates to verify dm-verity volumes, DB certificates are
> going to be used too. Keys in DB are allowed to load a full kernel
> already anyway, so they are already highly privileged.
>
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
>  drivers/md/Kconfig                | 10 ++++++++++
>  drivers/md/dm-verity-verify-sig.c |  7 +++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 35b1080752cd..1e9db8e4acdf 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -540,6 +540,16 @@ config DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
>
>           If unsure, say N.
>
> +config DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> +       bool "Verity data device root hash signature verification with platform keyring"
> +       default DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
> +       depends on DM_VERITY_VERIFY_ROOTHASH_SIG
> +       depends on INTEGRITY_PLATFORM_KEYRING
> +       help
> +         Rely also on the platform keyring to verify dm-verity signatures.
> +
> +         If unsure, say N.
> +
>  config DM_VERITY_FEC
>         bool "Verity forward error correction support"
>         depends on DM_VERITY
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> index 4836508ea50c..d351d7d39c60 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -126,6 +126,13 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
>                                 NULL,
>  #endif
>                                 VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> +#ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> +       if (ret == -ENOKEY)
> +               ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
> +                                       sig_len,
> +                                       VERIFY_USE_PLATFORM_KEYRING,
> +                                       VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> +#endif
>
>         return ret;
>  }

Gentle ping. Anything I can do to help move this patch forward? It
fixes a gap in our dm-verity story that I'd really like to see sorted
for the next release. We will use this in systemd, among other things.
Thanks!
