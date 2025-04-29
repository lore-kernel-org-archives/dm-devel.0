Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F566247299
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 20:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745957974; cv=none; b=G4cW9U+1j3bPZ3Y5GaWiJg7iquWhUSKI7gR+SFTmrwD0bYNod1fGouH/SPcKbiTXavalwY6Co7j4DWc0kDI0u/lAc9mp4GXyduyaZGZUwegHhGcjjIA4OZkVlwpUJskT+bfLdccazPU8iyZari7YLnMk2+YmjWZa38/T2WIlVIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745957974; c=relaxed/simple;
	bh=+4+NvcnbBK5DeU1y3KDsaw+0f4nUoz57zcWZ6ujqwo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjdayYYoNoI3IsdOMOyrLE3JbsqEo1ZdH7b5PLC7NCDRkBoA9Dbkmh4tt8AIxwRhH5Lkn82ZtIWIlX4G0nfcFaZT48B+KKzpDVQp02iOnKw6JBIyjG9D4rwbaaFg8PyI6+LhdfnFo9SH3FGCI3MmjdTeYnnmyolXkLUlvpTuaFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=qkmACTvp; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="qkmACTvp"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso145344f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 13:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1745957968; x=1746562768; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aknxvHa51FWqbwLMlLGOiAj4PgdaBz5BjwlXj6r/pEM=;
        b=qkmACTvppSSpvigJMVB1RgHOQA1aTe3g6vCsryzaMJwYdTuSTdKCaeDLWRulgXDPw2
         rBsUVuZu4W6nbo8YLgskAcAsr4ynbt3CAj7c7ulGeJA2VaDONfD7fYF2aWXyH/MmfnjA
         V+4ZqgNX6yhqKrvFX8XL7egeCTh9ac8xu65kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745957968; x=1746562768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aknxvHa51FWqbwLMlLGOiAj4PgdaBz5BjwlXj6r/pEM=;
        b=pvjovaxsYO8dnLYKltc19N+pT2mfGw3xQFVUU7yBzZQfzrM9hrcaxqe68XLkQRbePG
         di5z739BFksuyzV+tuc7bMT4kOmAjx6zt9CqZT2Tb92CGR/GcIPeItc1zbtaDcLJP06d
         3uMukM/XWfthx98fsqgtsB+9fvitUReiAjX7gzQhUaN7tavR0O7uPnyLaqzgAGQQ+zUQ
         AioM3z3XYn+x63niO+sZQa8kCjiMRXiv8Lp+vuaN0QdI46SFeOBDKVjWbQr3387vPOL4
         WGknabd198VQ37abME23z3W8MLpN6mUkunlQKvhkSED47h/E3x5s4oYrLaHJZVdYYJf6
         jn3A==
X-Forwarded-Encrypted: i=1; AJvYcCXAZ6ylA3uymrwZzHSSi5srOWxoTnDalZ8/oo7YJDLmqESEA1cvmoLx6dncYU1QHqekQCtTeFlKcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0rlLeYYHw5F5olVfmSRpNLPee9lTW8Yv2rSYXSEop3aq+xBsq
	DwpaHdRH9aQr2x2UbrI81SfBWOq5JUBhiJs26xJxdTS0IA7WRidLPjVAYFOwB1pXv8h8DChsUeh
	7h8rsncdU749P8sQ2PNBU51nYBArKfFqkQLRsew==
X-Gm-Gg: ASbGncs4NEw1BnRIp571j0/6Z05t8d1iT/vsEz0CuuKpb0NKs+a6+1hr3RFzT2yu0/n
	gg453nzeEYbElfSZ6x1NkaGU9qG8xFIu26HoY2MbEE3AyJwYyRPtnhNSzRSX1xII/1bgwt2ydz2
	HJ2h/0sb8vZdOtvHHVmMEB3UXxiOnjVangJcNRnAaScXPrV9E8lx3ibzYt
X-Google-Smtp-Source: AGHT+IF4E2b73U2V3OWcSkIM8LxpsmSTYqNj6d6HqMljU4Vil3xUklNIiWHoGw0g94COgD2yC8MCao7bmNwUj1kRDXs=
X-Received: by 2002:a05:6000:1846:b0:3a0:6c56:9fb5 with SMTP id
 ffacd0b85a97d-3a08fb69338mr157407f8f.19.1745957968285; Tue, 29 Apr 2025
 13:19:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
 <20250404122902.2750036-2-sofiane.hamam@smile.fr> <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
 <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com> <CAMSfU+5pbVe4JsXDY2xH40CS_K=vqH9iaCEso9tfMh19daNgZA@mail.gmail.com>
 <4333916895109b795283620765d57d74c18137ad.camel@suse.com> <CAMSfU+6ho6uxcNW4zx9Orb8qHAN239NaNt31vB3qE5vKuAVX=A@mail.gmail.com>
 <bee02f6baae30380b8f2c5021dd0dcdebc7d81d8.camel@suse.com>
In-Reply-To: <bee02f6baae30380b8f2c5021dd0dcdebc7d81d8.camel@suse.com>
From: Yoann Congal <yoann.congal@smile.fr>
Date: Tue, 29 Apr 2025 22:19:01 +0200
X-Gm-Features: ATxdqUHkd3avxatmna8CXiaGmZu6TFeZLidUsyiBZrv14oYj8KTaj2uyZa0VP_Q
Message-ID: <CAMSfU+5X2XA57xkXuueGOEm+ZB5xyiJXPJjjwQgaNBrjRsKu=w@mail.gmail.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target docs/man/dmmp_strerror.3
 to .PHONY list
To: Martin Wilck <mwilck@suse.com>
Cc: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev, bmarzins@redhat.com, 
	=?UTF-8?B?S8OpbMOpZmEgU2Fuw6k=?= <kelefa.sane@smile.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mar. 29 avr. 2025 =C3=A0 22:06, Martin Wilck <mwilck@suse.com> a =C3=A9c=
rit :
>
> On Sat, 2025-04-12 at 00:05 +0200, Yoann Congal wrote:
> > Le lun. 7 avr. 2025 =C3=A0 16:42, Martin Wilck <mwilck@suse.com> a =C3=
=A9crit :
> > >
> > > On Mon, 2025-04-07 at 12:53 +0200, Yoann Congal wrote:
> > > > Hello,
> > > >
> > > > Le lun. 7 avr. 2025 =C3=A0 12:32, Martin Wilck <mwilck@suse.com> a
> > > > =C3=A9crit :
> > > > >
> > > > > On Mon, 2025-04-07 at 10:53 +0200, Martin Wilck wrote:
> > > > > > On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> > > > > > > From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
> > > > > > >
> > > > > > > When checking out the git repos, sometimes, target
> > > > > > > docs/man/dmmp_strerror.3 is newer that the prerequisite
> > > > > > > libdmmp/libdmmp.h this leads to a non reproducible
> > > > > > > behavior:
> > > > > > > Sometimes, the timestamps are updated in the manpages,
> > > > > > > sometimes
> > > > > > > not.
> > > > > > >
> > > > > > > Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> > > > > > > Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> > > > > > > Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> > > > > > > ---
> > > > > > >  libdmmp/Makefile | 2 +-
> > > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > > > > > > index 7e0e2509..187bcb8c 100644
> > > > > > > --- a/libdmmp/Makefile
> > > > > > > +++ b/libdmmp/Makefile
> > > > > > > @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -
> > > > > > > fvisibility=3Dhidden
> > > > > > >  LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -
> > > > > > > L$(mpathcmddir) -
> > > > > > > lmpathcmd -lpthread
> > > > > > >
> > > > > > >  all: $(LIBS) doc
> > > > > > > -.PHONY:    doc clean install uninstall check speed_test
> > > > > > > dep_clean
> > > > > > > +.PHONY:    doc clean install uninstall check speed_test
> > > > > > > dep_clean docs/man/dmmp_strerror.3
> > > > > > >
> > > > > >
> > > > > > I've seen the issue you refer to, but this is not the right
> > > > > > solution.
> > > > > > It will cause the time stamps of the man pages to be
> > > > > > regenerated
> > > > > > on
> > > > > > every build.
> > > > >
> > > > > After investigating this some more: AFAICS, your patch 1/2
> > > > > fixes
> > > > > the
> > > > > erratic behavior in the (normal) case where
> > > > > KBUILD_BUILD_TIMESTAMP
> > > > > is
> > > > > not set and git is available. Previously, in this case, the
> > > > > kernel-
> > > > > doc
> > > > > script would have substituted the current date for
> > > > > KBUILD_BUILD_TIMESTAMP (yielding "April 2025" today). With your
> > > > > fix,
> > > > > KBUILD_BUILD_TIMESTAMP is correctly set to "August 2024".
> > > > >
> > > > > We need to create a commit that updates the man page time
> > > > > stamps to
> > > > > "August 2024". I'll do this.
> > > > >
> > > > > Once this is done, the build rule does the right thing, AFAICS.
> > > > > While
> > > > > it will rewrite the man pages if the libdmmp.h timestamp is
> > > > > updated, it
> > > > > won't apply any real changes (visible in "git diff" or "git
> > > > > status")
> > > > > unless libdmmp.h has actually changed.
> > > > >
> > > > > Am I overlooking something?
> > > >
> > > > Depending on the order the files are written on disk during the
> > > > git
> > > > clone/archive extraction (is dmmp_strerror.3 written before or
> > > > after
> > > > libdmmp.h ?), the build rule will either run or not.
> > > > But, as you wrote, with your latest patch, it does not matter at
> > > > all
> > > > because the rewritten timestamp will be exactly the same.
> > > >
> > > > Apart from this little quirk without any consequence, it looks
> > > > good
> > > > to me.
> > > >
> > > > The only future problem I can imagine is if libdmmp.h is updated
> > > > without updating the timestamps (again).
> > > > In this case, we will either get the timestamps from the sources
> > > > or
> > > > from git.
> > >
> > > That shouldn't happen because as soon as someone changes libdmmp.h
> > > and
> > > runs "make", the timestamps will be updated. Even if it does, the
> > > worst
> > > possible outcome is an outdated timestamp in the man pages, which
> > > we've
> > > seem to have had for several years now.
> > > Also, the actual content of libdmmp.h has hardly changed over
> > > years.
> > >
> > > If someone can contribute a better fix, we'll apply it happily. But
> > > I'd
> > > rather not want to have to check in the man pages after every
> > > build.
> >
> > Our (Yocto project) situation is quite different: We build from
> > scratch every time and the sources are only kept during the
> > compilation, erased after.
> > So we will use in our integration the 2 patches of this series to
> > force a reproducible build of the manpages.
> >
> > Thanks!
>
> Can I take this as an acked-by: from your part?

You can!

Acked-by: Yoann Congal <yoann.congal@smile.fr>

FYI, I participated in the patch development and am already in the
Signed-off-by list if you did not notice.

> Or @Ben could you give it a review?
>
> Martin

--=20
Yoann Congal
Smile ECS
