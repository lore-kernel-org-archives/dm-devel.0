Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2472F43AB3
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 15:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720107682; cv=none; b=Hd3NtKMxfbwfY9U+/OBynaPSNrMB+SsVBIRk/LHJJx2D4k+SKEYKta7E0JTiRjQ1AWqNRX3WyyhLUmIUmsQgon9+BOblv9+rE+fgT5pA+LfsFkVvAiioaCjNfdhaSbR1BnaxwAPjd/FN/EFTWh4n+zdE2Y09DDOS9H/P0n+7M3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720107682; c=relaxed/simple;
	bh=734jGeCYpeOLG3n9n2FW4DvlJ2Oc8m9Vh/q8wOJQXqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3Ec1W4AO8kVGVrQD892/ss8Tm4TjUCjlGqcrea2kNwPaDN7VKHzPyfvKTdsy54iJC6+D96N8FW0bV0Su3Ab2T+5dOwaOfWpdAGVCqtwF+TTmSSiNC+EY1XwB3Nbb6St64dSuVu4pdOTnyFkhOtzIRorbTpAeTNn/wbmC2V2a/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=akYvcUUz; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akYvcUUz"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-651541b4d40so7443257b3.3
        for <dm-devel@lists.linux.dev>; Thu, 04 Jul 2024 08:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720107680; x=1720712480; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gdhhJ1yEpAlS7gdLN7RTjEDFACJPIBHZWoNJg5YLD94=;
        b=akYvcUUzPyxue9flulFYAqLM8SQyfuWrsgtmchIleug4JkM7LfIb9S3Jt8cpushqEJ
         R3X1Et5PrQid5wEDTGgeT01UNdoUVOVyKC/XDO9xva0TuI2l2vdY64PzkLMVnlwjrV5T
         GOAeXmz4lr2V1pypkQfvWm24AfcK0E9bWnzxrRoqKAD8YDtySreM910sO4wX2hOuS9II
         dAkd8xBKBxEs49b+FqkUvferzSSwDahENr2gGsZQOP2GMninToKxC4kvv5Tvc8OYS5Rl
         Lxf/X45koNEEngcG8EMCWNeU+Ca4VwAIWio0It/LS+E4n0eS/zPfB4e3ULtc6k2IXG8x
         lYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720107680; x=1720712480;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gdhhJ1yEpAlS7gdLN7RTjEDFACJPIBHZWoNJg5YLD94=;
        b=UqBw/sCqAJNwuPpCzSmsz9IgOdFwMnV8IOEj2+gzeYsXaou0LUggEpuuLijknaNX0Q
         WRdDFIysYOPUzZA3xwBvS+EGO1n02dNFlluyUluRn3WI7q7c1JNWqLPMV8afdVqLIrgI
         Qw2DVzuwXOOo9lwwIHeM1boXHIb/g/meJvpMS7NQsz1crHDRKXRdihqgXAjLUFFgQexI
         oGua3tKZepyZ4zx416x4TOU78QxB1VvxKaWi508Y2JW0M5qNvjdsNZBM9AjW1h9S7OTv
         NdrPsdTboojfC24MBzyPivAej3dXku616UXy9PogI3jJKuzfDKgtlvSUTzpxHv4CtDEP
         7AuA==
X-Gm-Message-State: AOJu0Yzj0OBhOMd160xqftnogm8VY5lWX5/lYtZbKq5js8zBcA3A/Jnd
	ZBbz7L0di9LNK7MgN7iNPUUslv5D+Kh5KtKrBr/KJ6iNY6AV1xusLNWtjcRXZsLWrT8ewARcujS
	jSlNbt8Wc8xRYZL3IbiZYDmIsfyo=
X-Google-Smtp-Source: AGHT+IEhol6cY8jqvpqQqci3e5FDhkCPjp7a2QVUat6MFEub4Bhois0yPvMspDumVKjWPZuPv8rVVv9MnHAE0+d029o=
X-Received: by 2002:a05:690c:7082:b0:615:20db:4a4d with SMTP id
 00721157ae682-652da44dfa9mr26884057b3.35.1720107680000; Thu, 04 Jul 2024
 08:41:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240617220037.594792-1-luca.boccassi@gmail.com> <544c16649bafe77d5ff4f6cecb09f3de3b97d9a6.camel@HansenPartnership.com>
In-Reply-To: <544c16649bafe77d5ff4f6cecb09f3de3b97d9a6.camel@HansenPartnership.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Thu, 4 Jul 2024 16:41:08 +0100
Message-ID: <CAMw=ZnQzAsNUg+AAbqZWWzz_=uBDwUzo4NKsaTAgzxCs7j9LkQ@mail.gmail.com>
Subject: Re: [PATCH] dm verity: add support for signature verification with
 platform keyring
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dm-devel@lists.linux.dev, snitzer@kernel.org, jmorris@namei.org, 
	paul@paul-moore.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jul 2024 at 16:21, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Mon, 2024-06-17 at 23:00 +0100, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <bluca@debian.org>
> >
> > Add a new configuration
> > CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> > that enables verifying dm-verity signatures using the platform
> > keyring, which is populated using the UEFI DB certificates. This is
> > useful for self-enrolled systems that do not use MOK, as the
> > secondary keyring which is already used for verification, if the
> > relevant kconfig is enabled, is linked to the machine keyring, which
> > gets its certificates loaded from MOK. On datacenter/virtual/cloud
> > deployments it is more common to deploy one's own certificate chain
> > directly in DB on first boot in unattended mode, rather than relying
> > on MOK, as the latter typically requires interactive authentication
> > to enroll, and is more suited for personal machines.
>
> I think that's true if you roll your own cloud OS.  If you rely on a
> distro OS (as, say, IBM Cloud does) you do use shim/mok and actually
> you als have to enroll all the driver module keys in MoK.

Yes, that is true, in many cases shim + 2nd stage is still used in
those environments. Perhaps a better use case I should have mentioned
is: this is also useful for those who self-enroll, and do not use
shim/mok at all. This is actually quite common, for example it's the
main way Arch users do SecureBoot, and there's an entire ecosystem
around this workflow, using sbctl and friends. systemd-boot provides
facilities to self-enroll on first boot, for example.
Another use case is in CIs, where we boot with a locally built
systemd-boot, self-enroll in EDK2, run some tests, and then throw away
the VM. This is the case in systemd's upstream CI that uses mkosi, for
example.

> > Default to the same value as
> > DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
> > if not otherwise specified, as it is likely that if one wants to use
> > MOK certificates to verify dm-verity volumes, DB certificates are
> > going to be used too. Keys in DB are allowed to load a full kernel
> > already anyway, so they are already highly privileged.
>
> But there's a reason we allow mok users to distrust DB through mokutil.
> It's because although you might be OK with these keys guarding the pre-
> boot environment (because if they don't do that Microsoft will be
> unhappy) and transferring control to SHIM via these keys, you wouldn't
> necessarily trust the owner of these keys to tamper with your kernel or
> install modules.  Doesn't a similar reasoning apply to dm-verity root
> hash signing?

Yes, although to me it personally feels like the real benefit of that
is avoiding being too exposed to the kitchen sink that is the UEFI 3rd
party CA, more than protection against an intentionally malicious CA
owner, after all if you are malicious and control the first stage of
the chain of trust things are very dire at that point. However, this
is all moot because of the next point that you correctly raised:

> By the way, if I look at how the machine keyring is handled, db certs
> won't get added if MokIgnoreDB is set by shim, so I think the behaviour
> of this patch is correct, and it's just the wording above that may be
> misleading.

This is of course entirely correct, and I should have worded the
commit message better to reflect it. I'll send v2 with these updates.
Thanks for the review!
