Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D887314A4F7
	for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 21:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727300290; cv=none; b=LrXO8YOdFriEdOoGeJVfofcBwOU/cdOc6Jqtnme8R1jOywTlDD1WPalz0pEedLWW6ZwGf/1o/UZ7KhQaJOm20IvnJKd6hNJt84h8y3FJ6jdO+v2KCch72/y42UGXFnq6AauzjSCFH/7PhBOQ1VHXBG84L/4Mc3G+MLY/D1+iXus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727300290; c=relaxed/simple;
	bh=xhO9Utrq1GvQAR21AfwpFkujyu/w0PlgWgaVnO8p6f0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nUG1H4qB5mU3N7phn10/JePk1ipfsMa1XK7amoHMZvJtBU9pEx1XoV/oKEjZU2ngt5hhLLoHAvIp4WFUDAegJVOPnb91vzNgwq6X2Or0FENUj6XRxA5KHMqHuQpmAhO/GbmrRXysLfsKg4it4TxMKPgEVIdSQw+Y1dh4YqWK/TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nVmPc7JV; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVmPc7JV"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-68518bc1407so4176607b3.2
        for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 14:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727300288; x=1727905088; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RBdtfod6/SGfKvqVNGYuOI0V/rC4LlxT5oHx7XyTzEU=;
        b=nVmPc7JVdCJr1yxnXrjgHuy1OSlgnzOF0/hFnck56QIRjJf2810ASEBBMViM5s/dez
         2vCdO+zHEGA3EIPbCd56abxr7Rk+wBpgYhVZp2DZbD82rGBzx02ujiSA1ssnLOCuXVVn
         sH9nBT+XImDGSILp120+IZ0TQtVjDrnPRufIkadabhiNAWB/gSI3482XQp0yMSDxMFsE
         EpOJ4ZxrHbEbCZmI//HfJIMBEwBeYq7ZW857bFMJM6c2sAg2ZvSBvI1XmfU0fkzIkl3Z
         DZq3jRYiBD8sxde6wEk8PXVMJpfXp/CmZXsLELDVly6Ub+DWOs4ZCxaxWY198kTe07N4
         sQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727300288; x=1727905088;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RBdtfod6/SGfKvqVNGYuOI0V/rC4LlxT5oHx7XyTzEU=;
        b=inoTlMs5oEvM6/FeVbOM2jiRCQcshxjYN4dIg99+0j4wZoeu5ZUhbClBtiDrJSJJFY
         akZmy4Rw9ZcGGcUsv3wb/AA35vXEU/POkJk+rtT6Jj2oG1FeFoGXDE1IeATBS/c6wXY5
         PB+MJlZM+ll9r2GymuaXW4cbKIpikpCb46+PeEGrD5q+MWiXTkWyt26oc7tLsQZCM2PW
         0Uvru6foK3ICFMK79GfM47HpfLW2SXanBAIsLZ9QR/Y3r7YEStqReCu6n7CINqhTAqdn
         SFPjTC47aOjM+0ICB1JIKrFPSZziTwjcy/OFztBJMz+IiBgOUyc+tg4NggLPtka0zOuc
         ignQ==
X-Gm-Message-State: AOJu0Yy529hztoRfC21vPr7fXbrX7FmPwodEES+IPo4JJJPKojm9M0MO
	G/77W4jDEchUjqmiKeXNv2TXr7BxQI0osGcPQG3A4bNdZGiFAf3VdSpB/KbsOfvujef0OOsaC52
	b8R2tH1Y7QRP+el3BKvSEU0JZ43KNX4sPAuC1arjX
X-Google-Smtp-Source: AGHT+IESmfov4HQOFPCYCx1KJ/4jEGIcbm4R0igEcLP8p13EA5A/O/rI3RfcyPlweSJVe1ciGuSD8K7FAIS2hpj3d5k=
X-Received: by 2002:a05:690c:6ac5:b0:6c3:7d68:b400 with SMTP id
 00721157ae682-6e21d705474mr38571057b3.10.1727300287595; Wed, 25 Sep 2024
 14:38:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240922161753.244476-1-luca.boccassi@gmail.com> <8b212fc8-c67a-2973-fc5c-0cb61d165fd5@redhat.com>
In-Reply-To: <8b212fc8-c67a-2973-fc5c-0cb61d165fd5@redhat.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Wed, 25 Sep 2024 23:37:55 +0200
Message-ID: <CAMw=ZnRO3WTm4Ad=MA99ehiDei4cAYG7zSQFEMUYhUKaUmmb=Q@mail.gmail.com>
Subject: Re: [PATCH] dm verity: fallback to platform keyring also if key in
 trusted keyring is rejected
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, snitzer@kernel.org, serge@hallyn.com, 
	wufan@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 25 Sept 2024 at 17:38, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Sun, 22 Sep 2024, luca.boccassi@gmail.com wrote:
>
> > From: Luca Boccassi <bluca@debian.org>
> >
> > If enabled, we fallback to the platform keyring if the trusted keyring doesn't have
> > the key used to sign the roothash. But if pkcs7_verify() rejects the key for other
> > reasons, such as usage restrictions, we do not fallback. Do so.
> >
> > Follow-up for 6fce1f40e95182ebbfe1ee3096b8fc0b37903269
> >
> > Suggested-by: Serge Hallyn <serge@hallyn.com>
> > Signed-off-by: Luca Boccassi <bluca@debian.org>
> > ---
> >  drivers/md/dm-verity-verify-sig.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> > index d351d7d39c60..a9e2c6c0a33c 100644
> > --- a/drivers/md/dm-verity-verify-sig.c
> > +++ b/drivers/md/dm-verity-verify-sig.c
> > @@ -127,7 +127,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> >  #endif
> >                               VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> >  #ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> > -     if (ret == -ENOKEY)
> > +     if (ret == -ENOKEY || ret == -EKEYREJECTED)
> >               ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
> >                                       sig_len,
> >                                       VERIFY_USE_PLATFORM_KEYRING,
> > --
> > 2.39.5
>
> Hi
>
> Please describe what problem does this patch solve. I.e. why would anyone
> put a key into the trusted keyring that could sign the roothash and
> restrict its usage so that it can't be used to sign the roothash?
>
> In the other places of the kernel, only -ENOKEY is tested:
> kexec_kernel_verify_pe_sig:
> if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
> s390_verify_sig:
> if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
> do they need to be converted to -EKEYREJECTED too?

To be perfectly honest, I do not have a use case for the EKEYREJECTED
fallback - it was suggested by Serge when I was working on the IPE
keyrings usage:

https://lore.kernel.org/all/20240920020217.GA528455@mail.hallyn.com/

I would like to maintain the usage of keyrings in sync between the two
components given they are used together, for consistency, so I
counter-proposed to send the change to dmverity first. I am following
up on that promise with this patch.
If there are reasons not to take this change, or if there are no
convincing reasons to take it, I do not have strong opinions either
way so I don't mind what the outcome is either way, as I am just
following up on that review comment. I'll let Serge explain the
reasoning for the request, if he wants to do it.

If this change is accepted, I will send the same for IPE. If not, I
won't. I do not directly use other subsystems that use these keyrings,
so I will not send changes for those even if this goes in.
