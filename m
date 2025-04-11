Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FBD18C011
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 22:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744409162; cv=none; b=G1zY8TffgK56VeeY+T2znaNbVdbutiIqVJobNO5cFfGS/NMRVxSlpzXZWIYYXtEuIQNhzRAAk7ftJyt5hhOQ0rCAOLBn2XGLMKjAgb2zOUsf/aoSd5XGftJkqWqEpiyZeOVjvMXnn+fNwb0Q0hECLs4W2D9adOj9Br6Z92wkcq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744409162; c=relaxed/simple;
	bh=zZCq38kqBrlACMD3cqfAAI5kAHuLazDEezyufbbVYZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p5zfSMzg5MeKwLHtC2GU4uOzDhUEiA5Zj1Mg66inPbOJEpziBvjVbniYLWNyJW0pFfUKHTMwyYPwmmY6T7OoOPU6A5v5HYzUaFMC/4pjbbjUSXyV+S33ar/LXdj2XEjuWcF+rvyLafU04gStD/j91TUsJ7JraSMj+UkNHz3BeY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=AETMv0rB; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="AETMv0rB"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3913b539aabso1494473f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 15:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1744409157; x=1745013957; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMFyQzA1jIlWMmU0bBY4jBSwNTn91iNavjb22bgJA9M=;
        b=AETMv0rBVRwliRhVT5iRwOG1up4fU95LPUf9yN+m1UwVx4xtaKX1Sf1IdluKc26mTn
         kJG6Y+btywdlWiz8va0eXZ9zljAd8ObFwT1fizt34BHukZwqY254Qf5NGChCf8Jlj3J5
         QLj0hTVvlVEa+B2e9lKVkb/lUCEOunRSqQ2LQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744409157; x=1745013957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xMFyQzA1jIlWMmU0bBY4jBSwNTn91iNavjb22bgJA9M=;
        b=e+/Ic5fk0Gqb6MRfSWc/ttkU6vZDb6AH14bQkrs4y9eOzJ1PXIrXI9JxhHF0C0hQiE
         iDWZuw5vf3iW12JwIxksaTtb8LH3gXJBOfqDKSQB9zP/SQ7+9jlvPCT755iXws/EEczn
         1JAhZuHzKSr3H0bN3BmuaBS+qsswb3fFFXStwb/og19dFHJbfHo+jwlnx+FEv8kaogjd
         BgZDIfnAHjLiV/sW4Gg+3kQvXRL2ased4yy1Nfi5fsxuO57yLH9d7hafgA6P/XBLC5Yu
         EWJ/rf1EkfNcLIWdi4frPhsqv4XjUo+6ddiX8EvfIpYCu6vnLIjIqys7ErjMbfiBZ+ul
         6y/A==
X-Forwarded-Encrypted: i=1; AJvYcCVSSbz1AuQIF0ieRq8+8LtNqbwwN5yHxdlOFoAa9HVgGV2Z8Es20cyKWPZPFOuTw3IhGUR6FAOAAw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyP+QzHdGYm/aMO7iHaTpesH1mXYc+WfW0qnwGOCd5asP8wYKMK
	xsk5okitwJ3z/2O/nL0VlNiLhHO2u6ohWM6x4c2ToKbcGDdLRiqs4hugJCG7lxbDCvmCJM6QfcS
	01F3FOtcSw1e06k/kKS1PP3KPmS3IWbdQpQiJLQ==
X-Gm-Gg: ASbGncvTqZpLQEG42gMAaZdTqpocqRfKSVE9blHkzRLhXqJXsGF4nPJk7qmWyg6jIZk
	cA81Vl8i23VsAqKdFxzHD1YU5NBMeuyuNSovJKP4I6he8Ap/cWL8ApZismxN9HL1o3cgWVFvsh9
	Zole73srmPrvsrCoSYMYeKfWOWBxUMyWbrjukoQ0PkZZUj9josKEu5RBk=
X-Google-Smtp-Source: AGHT+IF5/3Bb9D73WQqVrWhdbMeMJmqxKNZNkui203pBud7A1upGf6iEKalPDbYu6+8Fo0c01hLxqx5B59UY4tEdsq8=
X-Received: by 2002:a05:6000:2510:b0:39a:cd84:a77a with SMTP id
 ffacd0b85a97d-39eaaebdb23mr3414787f8f.37.1744409156771; Fri, 11 Apr 2025
 15:05:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
 <20250404122902.2750036-2-sofiane.hamam@smile.fr> <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
 <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com> <CAMSfU+5pbVe4JsXDY2xH40CS_K=vqH9iaCEso9tfMh19daNgZA@mail.gmail.com>
 <4333916895109b795283620765d57d74c18137ad.camel@suse.com>
In-Reply-To: <4333916895109b795283620765d57d74c18137ad.camel@suse.com>
From: Yoann Congal <yoann.congal@smile.fr>
Date: Sat, 12 Apr 2025 00:05:30 +0200
X-Gm-Features: ATxdqUGPSft5BlQhgoDytmyKFpvw1P1L-1ZMyge1S-451yP8zjl7HfRVn-bbbok
Message-ID: <CAMSfU+6ho6uxcNW4zx9Orb8qHAN239NaNt31vB3qE5vKuAVX=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target docs/man/dmmp_strerror.3
 to .PHONY list
To: Martin Wilck <mwilck@suse.com>
Cc: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev, bmarzins@redhat.com, 
	=?UTF-8?B?S8OpbMOpZmEgU2Fuw6k=?= <kelefa.sane@smile.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 7 avr. 2025 =C3=A0 16:42, Martin Wilck <mwilck@suse.com> a =C3=A9cr=
it :
>
> On Mon, 2025-04-07 at 12:53 +0200, Yoann Congal wrote:
> > Hello,
> >
> > Le lun. 7 avr. 2025 =C3=A0 12:32, Martin Wilck <mwilck@suse.com> a =C3=
=A9crit :
> > >
> > > On Mon, 2025-04-07 at 10:53 +0200, Martin Wilck wrote:
> > > > On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> > > > > From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
> > > > >
> > > > > When checking out the git repos, sometimes, target
> > > > > docs/man/dmmp_strerror.3 is newer that the prerequisite
> > > > > libdmmp/libdmmp.h this leads to a non reproducible behavior:
> > > > > Sometimes, the timestamps are updated in the manpages,
> > > > > sometimes
> > > > > not.
> > > > >
> > > > > Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> > > > > Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> > > > > Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> > > > > ---
> > > > >  libdmmp/Makefile | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > > > > index 7e0e2509..187bcb8c 100644
> > > > > --- a/libdmmp/Makefile
> > > > > +++ b/libdmmp/Makefile
> > > > > @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -fvisibility=3Dhidden
> > > > >  LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -
> > > > > L$(mpathcmddir) -
> > > > > lmpathcmd -lpthread
> > > > >
> > > > >  all: $(LIBS) doc
> > > > > -.PHONY:    doc clean install uninstall check speed_test
> > > > > dep_clean
> > > > > +.PHONY:    doc clean install uninstall check speed_test
> > > > > dep_clean docs/man/dmmp_strerror.3
> > > > >
> > > >
> > > > I've seen the issue you refer to, but this is not the right
> > > > solution.
> > > > It will cause the time stamps of the man pages to be regenerated
> > > > on
> > > > every build.
> > >
> > > After investigating this some more: AFAICS, your patch 1/2 fixes
> > > the
> > > erratic behavior in the (normal) case where KBUILD_BUILD_TIMESTAMP
> > > is
> > > not set and git is available. Previously, in this case, the kernel-
> > > doc
> > > script would have substituted the current date for
> > > KBUILD_BUILD_TIMESTAMP (yielding "April 2025" today). With your
> > > fix,
> > > KBUILD_BUILD_TIMESTAMP is correctly set to "August 2024".
> > >
> > > We need to create a commit that updates the man page time stamps to
> > > "August 2024". I'll do this.
> > >
> > > Once this is done, the build rule does the right thing, AFAICS.
> > > While
> > > it will rewrite the man pages if the libdmmp.h timestamp is
> > > updated, it
> > > won't apply any real changes (visible in "git diff" or "git
> > > status")
> > > unless libdmmp.h has actually changed.
> > >
> > > Am I overlooking something?
> >
> > Depending on the order the files are written on disk during the git
> > clone/archive extraction (is dmmp_strerror.3 written before or after
> > libdmmp.h ?), the build rule will either run or not.
> > But, as you wrote, with your latest patch, it does not matter at all
> > because the rewritten timestamp will be exactly the same.
> >
> > Apart from this little quirk without any consequence, it looks good
> > to me.
> >
> > The only future problem I can imagine is if libdmmp.h is updated
> > without updating the timestamps (again).
> > In this case, we will either get the timestamps from the sources or
> > from git.
>
> That shouldn't happen because as soon as someone changes libdmmp.h and
> runs "make", the timestamps will be updated. Even if it does, the worst
> possible outcome is an outdated timestamp in the man pages, which we've
> seem to have had for several years now.
> Also, the actual content of libdmmp.h has hardly changed over years.
>
> If someone can contribute a better fix, we'll apply it happily. But I'd
> rather not want to have to check in the man pages after every build.

Our (Yocto project) situation is quite different: We build from
scratch every time and the sources are only kept during the
compilation, erased after.
So we will use in our integration the 2 patches of this series to
force a reproducible build of the manpages.

Thanks!

> Regards
> Martin
--=20
Yoann Congal
Smile ECS
