Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B45FB89
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 23:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710889258; cv=none; b=prAwulVirrNW5yED9N1NZ4dldMYh2mxCegfSmvvntheOJClNxnO5NFsIfhShGAxYylUmB8I/fgKgJZ7tQtD6rXVO1ZYWR2apuxzwZfkKBKQGtAYKPavZPnVb8mgVg2yYMaF0538WMLS7O1VqrXsu+1nKDKY5vqgAM20W6dZExrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710889258; c=relaxed/simple;
	bh=SI71iR5Y7Um8R7vAzXhLobI13BqpnZIrQxroXe8te6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UTnVDdvWZgzT9msZqvj7orbMEEEMakatdn2yoSv+3Dym3Zbl5APAIk62ptAu88R/BVSvv+70hz91MfzvKOquZHvdRC4m6gp38Ik8zXi0Dw2pG5BayTZRxKf8xRx8+Wr4cYT/vikt1147DTkmiZ9y8spwYvnCzelrCvXkJlOxkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=RlRjNppj; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="RlRjNppj"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dc742543119so5692199276.0
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 16:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1710889254; x=1711494054; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PhNnIPgHxerhIOr4RTfHPmKF6x9l0/Ckh/RvMFabA+Y=;
        b=RlRjNppjPUVv4wwbLF++d0fP+FFTyLz7gugw0DMaYMH75SnVWarDmEC+HcJZovINLF
         EYqxC31QaNlE5JB9/W3Hyl/Ijq+QdCHLC6o2VPdiGNrbCHQJ9k9Zq/tYQLABAyvKAAPN
         hu6M7Uwbq1uVz396HKI49XcaNKVyg1H7+xkNL5yuZfJ9dLZsW+xuKequCxVnNKQAuOlw
         uJwr+TAK5/AiR0on24/IoV/TYQptMZDJNnXifCjDmfgsC0UdSYs/K3NS2Lqz6Rz+1kiX
         FvY4y1Pv5H0w6fKGNNbT/in0O9zpabNMGVkQkGJ8IcORUnM4TwbVygqkn01ZIdNKK7tc
         Bjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710889254; x=1711494054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PhNnIPgHxerhIOr4RTfHPmKF6x9l0/Ckh/RvMFabA+Y=;
        b=TEIenHHh6c6TWRItjKY7guxrrUE+Iug7po0QrwkZSRrqBSN6UYJQ/jQ6uN3gDEsVOv
         Qov1OQhxT0gAiEJDgKOyEeoI8btVT4T7AbTHYB1RtAH8ITF/rv9GdI6InoXtf4ArwaZU
         Q3LHjRF6AL3j6fSTKijpZ1KJ2s18Z/03THpga07JdSv+l8zcmWP8V1wTXUrhCIDYWFxg
         ToAWB3JzBNm2WBossyKf6PLji797NKFWWYVZ24AmareJ5N5wzDGiK5VbC6HJXO3RqVHo
         c5mCQz9D4Egav9RlL4zosCzfvTbxhw6APbwLEGWnnCDQqG1zdCkd9HOKy4SwLY6WZ5MP
         uZ7A==
X-Forwarded-Encrypted: i=1; AJvYcCXXXn2jFnQ/rszh1u6OU3Dz53AnKZDA+SMlIBqB/HLyk8T/9VQ3tDuVNFph0DfsyfwxT/A9qp4PglX10y5GaebMYpk3lpY4Vfo=
X-Gm-Message-State: AOJu0YwT8GFr5Hp1fS7pxrEp+wHj7KlI0CRT/f3703TktECkCaGfhNjX
	lWCQWA99fo7yfn5YKfM8khABZDx7Vx8Lln/6/VI8YesMLXf2Qo9etfIBvYSjCv9n/5MDMklz+dm
	iIAglRpo6Ft6qyWU0DDcjtzyf/HgU2xKgg/Iz
X-Google-Smtp-Source: AGHT+IHMUIIIwsUIMpmgPc4Sro0qw/3fx6zM2LSAJ369atAEbEsfSVNxqySeZsH++rtDdEJkgBUDk7WxQwVaCN1faZ4=
X-Received: by 2002:a25:f40c:0:b0:dc7:2401:df4e with SMTP id
 q12-20020a25f40c000000b00dc72401df4emr12122020ybd.39.1710889254575; Tue, 19
 Mar 2024 16:00:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1710560151-28904-1-git-send-email-wufan@linux.microsoft.com>
 <1710560151-28904-18-git-send-email-wufan@linux.microsoft.com> <20240318052937.GC63337@sol.localdomain>
In-Reply-To: <20240318052937.GC63337@sol.localdomain>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 19 Mar 2024 19:00:43 -0400
Message-ID: <CAHC9VhTZ+xAiApjXqz9V_HHwQ0RdW7mWLGjm9zK=ZuhPqb1tgg@mail.gmail.com>
Subject: Re: [RFC PATCH v15 17/21] fsverity: consume builtin signature via LSM hook
To: Eric Biggers <ebiggers@kernel.org>
Cc: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, 
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024 at 1:29=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
> On Fri, Mar 15, 2024 at 08:35:47PM -0700, Fan Wu wrote:
> > fsverity represents a mechanism to support both integrity and
> > authenticity protection of a file, supporting both signed and unsigned
> > digests.

...

> > diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> > index 90c07573dd77..d4ed03a114e9 100644
> > --- a/fs/verity/signature.c
> > +++ b/fs/verity/signature.c
> > @@ -41,7 +41,10 @@ static struct key *fsverity_keyring;
> >   * @sig_size: size of signature in bytes, or 0 if no signature
> >   *
> >   * If the file includes a signature of its fs-verity file digest, veri=
fy it
> > - * against the certificates in the fs-verity keyring.
> > + * against the certificates in the fs-verity keyring. Note that verifi=
cation
> > + * happens as long as the file's signature exists regardless of the st=
ate of
> > + * fsverity_require_signatures, and the IPE LSM relies on this behavio=
r
> > + * to save the verified file signature of the file into security blobs=
.
>
> "save the verified file signature of the file into security blobs" isn't =
what
> IPE actually does, though.  And even if it was, it would not explain why =
IPE
> expects the signature to be verified.

We probably need to abstract away the IPE specific comments here as
these are general LSM hooks and could be used by additional LSMs in
the future.  How about something like the following?

"Note that signatures are verified regardless of the state of the
'fsverity_require_signatures' variable and the LSM subsystem relies
on this behavior to help enforce file integrity policies.  Please
discuss changes with the LSM list (thank you!)."

> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 0885866b261e..edd12c0a673a 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -86,6 +86,7 @@ enum lsm_event {
> >  enum lsm_intgr_type {
> >       LSM_INTGR_DMV_SIG,
> >       LSM_INTGR_DMV_ROOTHASH,
> > +     LSM_INTGR_FSV_SIG,
> >       __LSM_INTGR_MAX
> >  };
>
> These are hard to understand because they are abbreviated too much.  And =
again,
> there are multiple type of fsverity signatures.  How about:
>
> enum lsm_integrity_type {
>         LSM_INTEGRITY_DM_VERITY_SIG,
>         LSM_INTEGRITY_DM_VERITY_ROOT_HASH,
>         LSM_INTEGRITY_FS_VERITY_BUILTIN_SIG,
>         __LSM_INTEGRITY_MAX
> };

Ugh.  I'm willing to concede that the existing enums are probably a
bit too terse, but the suggestions above are a bit too long for my
tastes (and my typin' fingers).  How about a compromise like that
below?

  enum lsm_integrity_type {
    LSM_INT_DMVERITY_SIG,
    LSM_INT_DMVERITY_ROOTHASH,
    LSM_INT_FSVERITY_BUILTINSIG,
  };

--=20
paul-moore.com
