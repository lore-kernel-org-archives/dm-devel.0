Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104A11ACE67
	for <dm-devel@lists.linux.dev>; Thu,  4 Jul 2024 15:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720108573; cv=none; b=tRIo/R16dozl6dWWQPAX/zIHQ8cr5kru7eTq9KsO+wAkR8OWNGkku+mStj0Nvr97hdqWlzAppquTUjnS88Yxj+1KQPC6KYc9tUVbfp2i/KuJFilt9141KMOwCWPlRWZ5AbaWDKawE8ZFpcSvbHFn1k267Y0Bsfcpcsx7sKMd8AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720108573; c=relaxed/simple;
	bh=i07ux+NjVOhhFkJUlNxA7kQj+gq0hbtgFgoY0xU4aBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DKSSzV2HHJqMHaUnwxtheHJ0fwZ7bczxGvN1Ze9kQerKwtkbUfUmx79YGNU0B74q/kGfWhcUlSTVZoldAqgGkjfrWNZ6D6f6wObLaD0Zw6Qum4UBnS+fACv778c7JNvSjSvo5yCDTXlcw0ogYuLceAVZUTgzVY37dsYubwYq3ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aEzt95m9; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aEzt95m9"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e02c4983bfaso800498276.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Jul 2024 08:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720108571; x=1720713371; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IrkSVZh75pgEQC8FB1FpCa32y0qVCFPnK2+rrz9LncE=;
        b=aEzt95m9WrgSkWxaIHsRx6W0PNzor2/6n+WJmHOoltyQ3Qer0nIB4YmCzuAAGvaB+K
         3ZOxTUiQalSZo/6MJ7TKkodS0OpjXvL83LgKAQ52RwXiMXmgwagCZ0Ron5M83fIQu4MM
         M5qUpirsa1JJvbyq9/wBiBkQRU3jUiODym7D0thPqQO+BekaKRsBgyp7gi3m4Ff1YBIK
         Ug4CxAW5fgCuCGI3diyCOT/QPTcO8bIhDdAl7dgpQqnzGmZ8nY5/hlMRbk/PRUmrvetP
         2GL1b0fntavL7gh7O2cIxLNgj7gyFbpyp7P2xZImLZP/W1zWUW8nhTtJpCSMy52ZSoRF
         L+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720108571; x=1720713371;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IrkSVZh75pgEQC8FB1FpCa32y0qVCFPnK2+rrz9LncE=;
        b=BrFKW9QTtHZo+TeWwXJBOBGLhEGqG6aikTbRpy0BRAkzdAdjMAtXKhVLZdu08wjjqD
         aYDqV1mjujiCYRC+hjj94XLK5KNM+xSJ1CwBLtXD8sKOmiNvFLgd8gqsHltkgZG2cQgL
         CRCGxsbKdX1aG3r+7bNWHplhXkclYrrUeUAgrrzt3zwJVtWam87pZBpM5tEFjRAQf97T
         NFdgJu/sPuFnAUZdYmig6Y9LApyxW4lqa7qgOGQC+tzRBeDw+fQD/ue7bvSBPpEwNVQx
         yaoX3sX+mDKNdnuZfitJvIBAGHrN/FzGXAGBsGDmJRS0uFR136dOEWDlctAFQY/Qwx9t
         kq+g==
X-Gm-Message-State: AOJu0YzkAKgHUCR+xpC4XuRion8LcXEQLUKr8mjjxSuh7fQXEn7ydA+G
	JQYWSrO10uuwGafbBloPX7paq5DcHloXOcjjEXeWfGLlfQRrhsXVLBoGobR0yGO5urH1vMPGHcF
	IqiS0RmSWZvuvO/NkEZHAmf+H9DneuA==
X-Google-Smtp-Source: AGHT+IHp9kQqE7EULip4r6sblbYrKkKEmqPRlFIQ71ggZxfPhx6Z2i/25iJHKp5cV9Iu6ViV81NWjnaUuESXoTreLK0=
X-Received: by 2002:a05:6902:50b:b0:e03:5edd:99b5 with SMTP id
 3f1490d57ef6-e03c1944665mr2112230276.4.1720108571003; Thu, 04 Jul 2024
 08:56:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240617220037.594792-1-luca.boccassi@gmail.com>
 <544c16649bafe77d5ff4f6cecb09f3de3b97d9a6.camel@HansenPartnership.com> <CAMw=ZnQzAsNUg+AAbqZWWzz_=uBDwUzo4NKsaTAgzxCs7j9LkQ@mail.gmail.com>
In-Reply-To: <CAMw=ZnQzAsNUg+AAbqZWWzz_=uBDwUzo4NKsaTAgzxCs7j9LkQ@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Thu, 4 Jul 2024 16:55:59 +0100
Message-ID: <CAMw=ZnTtwDbaH6gg17np+Vf+_cZGuO6+25B7mnt0pZ9T0SvZqg@mail.gmail.com>
Subject: Re: [PATCH] dm verity: add support for signature verification with
 platform keyring
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Jul 2024 at 16:41, Luca Boccassi <luca.boccassi@gmail.com> wrote:
>
> On Thu, 4 Jul 2024 at 16:21, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > On Mon, 2024-06-17 at 23:00 +0100, luca.boccassi@gmail.com wrote:
> > > From: Luca Boccassi <bluca@debian.org>
> > >
> > > Add a new configuration
> > > CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> > > that enables verifying dm-verity signatures using the platform
> > > keyring, which is populated using the UEFI DB certificates. This is
> > > useful for self-enrolled systems that do not use MOK, as the
> > > secondary keyring which is already used for verification, if the
> > > relevant kconfig is enabled, is linked to the machine keyring, which
> > > gets its certificates loaded from MOK. On datacenter/virtual/cloud
> > > deployments it is more common to deploy one's own certificate chain
> > > directly in DB on first boot in unattended mode, rather than relying
> > > on MOK, as the latter typically requires interactive authentication
> > > to enroll, and is more suited for personal machines.
> >
> > I think that's true if you roll your own cloud OS.  If you rely on a
> > distro OS (as, say, IBM Cloud does) you do use shim/mok and actually
> > you als have to enroll all the driver module keys in MoK.
>
> Yes, that is true, in many cases shim + 2nd stage is still used in
> those environments. Perhaps a better use case I should have mentioned
> is: this is also useful for those who self-enroll, and do not use
> shim/mok at all. This is actually quite common, for example it's the
> main way Arch users do SecureBoot, and there's an entire ecosystem
> around this workflow, using sbctl and friends. systemd-boot provides
> facilities to self-enroll on first boot, for example.
> Another use case is in CIs, where we boot with a locally built
> systemd-boot, self-enroll in EDK2, run some tests, and then throw away
> the VM. This is the case in systemd's upstream CI that uses mkosi, for
> example.
>
> > > Default to the same value as
> > > DM_VERITY_VERIFY_ROOTHASH_SIG_SECONDARY_KEYRING
> > > if not otherwise specified, as it is likely that if one wants to use
> > > MOK certificates to verify dm-verity volumes, DB certificates are
> > > going to be used too. Keys in DB are allowed to load a full kernel
> > > already anyway, so they are already highly privileged.
> >
> > But there's a reason we allow mok users to distrust DB through mokutil.
> > It's because although you might be OK with these keys guarding the pre-
> > boot environment (because if they don't do that Microsoft will be
> > unhappy) and transferring control to SHIM via these keys, you wouldn't
> > necessarily trust the owner of these keys to tamper with your kernel or
> > install modules.  Doesn't a similar reasoning apply to dm-verity root
> > hash signing?
>
> Yes, although to me it personally feels like the real benefit of that
> is avoiding being too exposed to the kitchen sink that is the UEFI 3rd
> party CA, more than protection against an intentionally malicious CA
> owner, after all if you are malicious and control the first stage of
> the chain of trust things are very dire at that point. However, this
> is all moot because of the next point that you correctly raised:
>
> > By the way, if I look at how the machine keyring is handled, db certs
> > won't get added if MokIgnoreDB is set by shim, so I think the behaviour
> > of this patch is correct, and it's just the wording above that may be
> > misleading.
>
> This is of course entirely correct, and I should have worded the
> commit message better to reflect it. I'll send v2 with these updates.
> Thanks for the review!

Ah it looks like this was merged yesterday in dm/for-next, so a bit
late to update the commit message. Fortunately it's not wrong per-se,
just missing a couple of useful bits of information :-)
