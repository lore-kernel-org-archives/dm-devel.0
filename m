Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D81615B147
	for <dm-devel@lists.linux.dev>; Tue,  6 Aug 2024 20:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722977710; cv=none; b=JdJsm47zHUbmM6ct1Xf+CVDGxM9OELURxKDGUQ8Xk0GGkeJZyEn97xN4KqP6jqb/WdAYhdriyDYMF2vr4V/kjud+H6uE8xe/JflgXU3lbxFl4G9DB5WRvJ2ws35vHmwOnvePiDyyalYABgl2QgRj9nLbPr4EwCyjlHpmiy7KQUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722977710; c=relaxed/simple;
	bh=Q1EFjItpPAJVvRpOJiKVEeB9t84orASFY/TzMasrm54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dn2Iic+rmasp54kf3MbpGk22gYUooFySisgBlHL8EL9RSt9KwVxfsQOA2AA1RqFdDh951JbRMS0lmErgkpRZK7RctfUtCpM17C/t0m7h6hgvVlr4rJU62GIDFthyJLbTNGLEdXqYotWTWrUw5ZMHtCToGRm3NSpw13QiC872QSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=ZN4j74PL; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="ZN4j74PL"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e0b2d502c6eso1011588276.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Aug 2024 13:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1722977707; x=1723582507; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddUgUKkImUJBZRqaPBh4WpQntM2pgtbxW0LlNFNQthQ=;
        b=ZN4j74PLIaZYxu8Tzci6neF7bnnY+BBRxHx2Vvd0nkHPmFs+GtH8QtkDn+MNv26Ypu
         +KczsoqNF3639cp9MwjJLlPK2ynzlo/OkVVAL1YKFnR310Aefzh7J+yAWZyrPsnN6qpa
         9zAxfQvzGd6F+GZNBABqwYHsRxV7slXYjAoP9J+3uNa5UYuewNTMEpqtL6GfqAn3tud+
         RiNAonH4Pl3cQGo0PKjia8iIe1SuoGnYH9T7djmMR8PoGI/Xn42QRrlMiSPks6MDP08R
         T4tjIzJL7nRFso+6AyRcqj+YnUuzZ7EE2g28Ulyyt8ffHP3n3PzCAAqyzs1ZIeLdaMWq
         /92Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722977707; x=1723582507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddUgUKkImUJBZRqaPBh4WpQntM2pgtbxW0LlNFNQthQ=;
        b=PcYUCQY1zwGnxt+3rcD9+tuAa4IFgg+20/E7AiUVnRsDtEcVdmK1y8PJl8fqqzAovq
         L0PT3fXBhm791fvEfU7tyTVu9gxKfTQuK4FqyvTTQR8nDKRDBNiWrdhpU2PMc/WLoPoB
         Wg1jCL02pIRWceIB52PchTzBXVpAkzfYhUbEnZfyRDPJ0wWEwiB4tyuGW+ZNo9ki8nJn
         NWzBwedgQEDAmuF2+K1sTudWWufPW7wxZ27olwPxxlvBFq5jFP3nL1nCV1xEzN8dI8KP
         WXw6MTIFzB6aJhkNrKArERFfXit+gctNHSBaILJo2sqjO6VA+pgk5SDc+dD5IY7wHX3+
         cL5w==
X-Forwarded-Encrypted: i=1; AJvYcCXH+c2EyiCi2f+cpUYA7QnTJKVSBSgLhivGE5E5ebSwMCwpEWWHgWxcUitC6emr1D5GCNSR+b3XoA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwONDupHBkosDcKPoJwSYYdkXFlVztb2qH7/eGQgDoA0dP945kF
	uFDr0IP9f2YfQND3xPCVqSYkkny06hcMX5tiOLQ2WuHZUxeSM2jCer86L5frXcg4fl/ufILnuMb
	rAuPCgs5etSQBEGGq14jPBQsnsM6a2yQdja/N
X-Google-Smtp-Source: AGHT+IEV3DoSxpbwywgyClpobkg3f96r+2vacgaYADkIDoHb8BVfBMUuKoLI3KKW3kNSXmapcP0+yqslrTw3VHo3MFI=
X-Received: by 2002:a05:6902:dc9:b0:e03:5bca:aee6 with SMTP id
 3f1490d57ef6-e0e54be0a4amr8897314276.54.1722977707114; Tue, 06 Aug 2024
 13:55:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1722665314-21156-1-git-send-email-wufan@linux.microsoft.com>
 <1722665314-21156-21-git-send-email-wufan@linux.microsoft.com> <de7857fb-63d9-42fc-af1e-12ffcdfcdda8@molgen.mpg.de>
In-Reply-To: <de7857fb-63d9-42fc-af1e-12ffcdfcdda8@molgen.mpg.de>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 6 Aug 2024 16:54:56 -0400
Message-ID: <CAHC9VhRmcReVM_Le5bYor2deotnSe4OT08UYhL6xhiKCu0+3kA@mail.gmail.com>
Subject: Re: [PATCH v20 20/20] MAINTAINERS: ipe: add ipe maintainer information
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, 
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, 
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	eparis@redhat.com, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 3, 2024 at 4:15=E2=80=AFAM Paul Menzel <pmenzel@molgen.mpg.de> =
wrote:
>
> Dear Fan,
>
>
> Thank you very much for your patch. Two nits, should you sent another
> interation: A more specific summary would avoid people having to look at
> the message body or diff, and `git log --oneline` would be enough.
>
> MAINTAINERS: Add IPE entry with M: Fan Wu
>
> MAINTAINERS: Add IPE entry with Fan Wu as maintainer
>
> Am 03.08.24 um 08:08 schrieb Fan Wu:
> > Update MAINTAINERS to include ipe maintainer information.
>
> I=E2=80=99d at least mention Integrity Policy Enforcement. As you not onl=
y
> include the maintainer information but add a new entry, I=E2=80=99d leave=
 the
> body out, or mention that a new entry is added.
>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

Working under the current assumption that a new revision is not
needed, I can fix this up during the merge.  Fan, other-Paul, are you
both okay with the following:

  "MAINTAINERS: add IPE entry with Fan Wu as maintainer

   Add a MAINTAINERS entry for the Integrity Policy Enforcement (IPE) LSM."

> > --
> > v1-v16:
> >    + Not present
> >
> > v17:
> >    + Introduced
> >
> > v18:
> >    + No changes
> >
> > v19:
> >    + No changes
> >
> > v20:
> >    + No changes
> > ---
> >   MAINTAINERS | 10 ++++++++++
> >   1 file changed, 10 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 8766f3e5e87e..4cdf2d5a2058 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -11118,6 +11118,16 @@ T:   git git://git.kernel.org/pub/scm/linux/ke=
rnel/git/zohar/linux-integrity.git
> >   F:  security/integrity/
> >   F:  security/integrity/ima/
> >
> > +INTEGRITY POLICY ENFORCEMENT (IPE)
> > +M:   Fan Wu <wufan@linux.microsoft.com>
> > +L:   linux-security-module@vger.kernel.org
> > +S:   Supported
> > +T:   git https://github.com/microsoft/ipe.git
> > +F:   Documentation/admin-guide/LSM/ipe.rst
> > +F:   Documentation/security/ipe.rst
> > +F:   scripts/ipe/
> > +F:   security/ipe/
> > +
> >   INTEL 810/815 FRAMEBUFFER DRIVER
> >   M:  Antonino Daplas <adaplas@gmail.com>
> >   L:  linux-fbdev@vger.kernel.org
>
> Kind regards,
>
> Paul

--=20
paul-moore.com
