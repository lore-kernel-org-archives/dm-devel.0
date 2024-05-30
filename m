Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E536181D18
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 20:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717102491; cv=none; b=iIY+aUy/llaVGRQvtXupy1++hnRq44Ff+nTEfXtVa00LEujacjA1nrUjXkwOV14fnlp3BKyPshENAsOKC6gV81F0XQLKcGGpug6M/dthtkQboqn8RHtMIn0lE/77iHRNgmcTYJCU6DQx4H31VBddyNr8W9j2GCCo3ugwb4c9I/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717102491; c=relaxed/simple;
	bh=eg+MIkwiEVxSkImTnP9/42HiBWABCU3sNxsgUn+kexk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=enIgBjWpjFxjG2yi2ePDuDeCM1D+Tla5GnTHYHdWI7XqWpqcEumIDYp9v9VwBoutuZMgs+mm4+anQ4t3R1iunuX6ZzcQ1rgtzx96/UQEKxuxh1DhSqGenK5EDzaXfAB3VF8oJb27yQJWZDbYWxQ8mMnA9GPuH+8HJ7PZ3Yygr3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=VGimXSFk; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="VGimXSFk"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-62a2a6a5ccfso13724067b3.3
        for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 13:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1717102489; x=1717707289; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IHhnEY8EBCWzfeI4r7ZxHSk1OcUfnIeP4X4PVOCwAbA=;
        b=VGimXSFkxb0ePMP17qay2hdsuwrcXwK8gCOW0nwrR641QgeHooYRI3fVgYfEbmCJyv
         ROwl0evuoqXCu8KTSCLnQ/T+KFVYBRrQ05ADDb4R+4cra8Hu7Qa4l8w24tirtjGfRmt+
         dGU1ZmQSQSFR1Ln4d+Ela+MN6/rDohYVkp0VElV9XAMDwdrFRwkCnRliQYwuf/zxN2ow
         74A3IuYD/MXsCEnsugXxDqHOX5RcjoVH200VQ06PNzyOtOElgszhvMfCgcQF0nEIJC91
         ScAuxgNaEUIqyca5y8L0P5wwJ7XXtn7rXk4QQLGo1ezbbXWt2A0U580nrxJGKz4Bebr1
         x4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717102489; x=1717707289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IHhnEY8EBCWzfeI4r7ZxHSk1OcUfnIeP4X4PVOCwAbA=;
        b=fDf892O19+Oo/maD8cQe0VPwstgmJ/F00HJc/GNTEDtcBqA5frCjNrhVWmrX194vcv
         gTCkzXz5co+C+jTpTwY78rY7sSFJwHuW7g2/gqu72xMu56DsfsQzuwdLQQfaYd6P+ebc
         gUwdfhZEGjMDw0LMRzNNwhjbM7igxvNy6sYcl5KKF/Cj5KXnL9CzeKgwbMnGwF77wGrn
         QyGW4VCGEHfxUiqn0tkEnx4eXUm43X99ewaVeCF8+YkcgYVCgUTB5W0xNSRJrQMk3T0M
         vy/Af5NpZDvkY+GSI8UZaFF0Ct9hbB20E7r6LD6IPkaZZHcMx6v/VBlZ3k+So75O7E45
         xBSA==
X-Forwarded-Encrypted: i=1; AJvYcCWDdnmQD1lvjYQccXYZrh/qNiCqMFyATvd52f0eJbExlzUC00mypWDOESARvQKXP1R8JYmyKKNxE55peDehQEYIDMHq7UpxDiA=
X-Gm-Message-State: AOJu0YxBdUksBkEdFgnhRBdKYASNNYnu/fYJhpi49v30oVg+AJe1eZnD
	SBgCe39k4plDzPD6BMfK0ITyaFU4c04WpKsUv8CJ7vyN2uuN+mIDHh+kRHzpPr71KRsT6yamvZO
	36C2+yyx6RpTGoIzw3ZpdhqXqznqrb06Jz0t/
X-Google-Smtp-Source: AGHT+IFGAao34yd3dClXG2DXw+Iy5chVgrvzZN/oG9tpxQvuE1hMom7wnNuLEmL3KD2ppvrBp7AAzHWyXJlgtWi13+A=
X-Received: by 2002:a0d:dc83:0:b0:61b:33fc:ad0e with SMTP id
 00721157ae682-62c6bc3120bmr35459887b3.17.1717102489115; Thu, 30 May 2024
 13:54:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1716583609-21790-1-git-send-email-wufan@linux.microsoft.com>
 <1716583609-21790-16-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRsnGjZATBj7-evK6Gdryr54raTTKMYO_vup8AGXLwjQg@mail.gmail.com> <20240530030605.GA29189@sol.localdomain>
In-Reply-To: <20240530030605.GA29189@sol.localdomain>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 30 May 2024 16:54:37 -0400
Message-ID: <CAHC9VhRySQ0c16UZz5xKT-y5Tn39wXxe4-f7LNjFY+ROGGxpaQ@mail.gmail.com>
Subject: Re: [PATCH v19 15/20] fsverity: expose verified fsverity built-in
 signatures to LSMs
To: Eric Biggers <ebiggers@kernel.org>
Cc: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, 
	jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, 
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, eparis@redhat.com, 
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2024 at 11:06=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
> On Wed, May 29, 2024 at 09:46:57PM -0400, Paul Moore wrote:
> > On Fri, May 24, 2024 at 4:46=E2=80=AFPM Fan Wu <wufan@linux.microsoft.c=
om> wrote:
> > >
> > > This patch enhances fsverity's capabilities to support both integrity=
 and
> > > authenticity protection by introducing the exposure of built-in
> > > signatures through a new LSM hook. This functionality allows LSMs,
> > > e.g. IPE, to enforce policies based on the authenticity and integrity=
 of
> > > files, specifically focusing on built-in fsverity signatures. It enab=
les
> > > a policy enforcement layer within LSMs for fsverity, offering granula=
r
> > > control over the usage of authenticity claims. For instance, a policy
> > > could be established to permit the execution of all files with verifi=
ed
> > > built-in fsverity signatures while restricting kernel module loading
> > > from specified fsverity files via fsverity digests.

...

> > Eric, can you give this patch in particular a look to make sure you
> > are okay with everything?  I believe Fan has addressed all of your
> > previous comments and it would be nice to have your Ack/Review tag if
> > you are okay with the current revision.
>
> Sorry, I've just gotten a bit tired of finding so many basic issues in th=
is
> patchset even after years of revisions.
>
> This patch in particular is finally looking better.  There are a couple i=
ssues
> that I still see.  (BTW, you're welcome to review it too to help find the=
se
> things, given that you seem to have an interest in getting this landed...=
):

I too have been reviewing this patchset across multiple years and have
worked with Fan to fix locking issues, parsing issues, the initramfs
approach, etc.  My interest in getting this landed is simply a
combination of fulfilling my role as LSM maintainer as well as being
Fan's coworker.  While I realize you don't work with Fan, you are
listed as the fs-verity maintainer and as such I've been looking to
you to help review and authorize the fs-verity related code.  If you
are too busy, frustrated, or <fill in the blank> to continue reviewing
this patchset it would be helpful if you could identify an authorized
fs-verity reviewer.  I don't see any besides you and Ted listed in the
MAINTAINERS file, but perhaps the fs-verity entry is dated.

Regardless, I appreciate your time and feedback thus far and I'm sure
Fan does as well.

--=20
paul-moore.com
