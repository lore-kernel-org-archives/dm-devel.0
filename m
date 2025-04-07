Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E19237194
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 10:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744023234; cv=none; b=s9vuGtVD8TWA5TMwvMhQaB6Rcf5WIxMJtmEpgRtqdXwO4g8GQtcdtsVoIXRmDFonO/jWhlTeCoSZ2gMMKxd3XNrln5ZADqvPy1zrzJ/aALwRQKo7+3/UBw8Nah4vLN1AnsCGg12uM6RZ68qzuhfWJ7/QQo0SEmaBnfTc4NInQ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744023234; c=relaxed/simple;
	bh=aIDdCo+1i8sOH2djO2ICbw6f6bX85oqEG1331TvOY8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ind3MZG1rTtUyKB+dofKT5VJf1zng2z5oXPkPbpo/Co0McVM/AHZVL/2CRbZnklAs0CJjwIB1ktT8FBWGYknd4C+z/IyIT4C+Poq0aw1udn96d5KrMn5DYcwQ5JZQXlBgOA4J39p5kvNHkVjM+4/IvPjrAINGM/1parF7G5CEg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=pbvxnVMi; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="pbvxnVMi"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38f2f391864so2304448f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 07 Apr 2025 03:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1744023229; x=1744628029; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5a+lditdfnRfhCWKjnGX9UGQTDBMDvtmWaY1Exrnhg=;
        b=pbvxnVMilu98XwM2JXd93YbFuNBNsfOgfJ4YY4tIfIwXkh7iB8DnXlwY75X1wDM/oh
         HkXE8GA2QS2rFK+Y0U0cCosD9FKWP+eE9LRECd0cmRurG3gfrQAuUdG3taGLaeqrlzqg
         o41AzoG5a72EF9swagEswThlGG6M0kPqDUBTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744023229; x=1744628029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I5a+lditdfnRfhCWKjnGX9UGQTDBMDvtmWaY1Exrnhg=;
        b=K9xqNrUkO2fJrqUvfrdTJeXHUnpXjS3wTCAZQMdEC9qsMxxjfHyz5gXoQa2VSoaI8F
         QMIhCh4BLHTqRu4BNh9PoOM2B7/RViG3N7bHMkeM8da/pEiSiutLnhIq7Xk0YeW9BzhO
         VGoL7cRkVvnH8JOaE/KiOYzGoLy1WJo0dsga9JrotMgmMJ9EgS512DD0wGSZG0zAYJYi
         crsNfn3VkjPJxJwf2A8/9tEHX6vitF3nWwACeJ8BU34b42CnQD2XULZUmbQKjcp0FtJH
         2TPb60TmOLHn1z8tgOydLpMiViAf2XMAkuVeQQRNbS2mxs6/GObuCLRLKpsBSM/x8MBH
         WMaA==
X-Forwarded-Encrypted: i=1; AJvYcCV+rnDso5lpVzumS5AoYbYpsXIqNVEKnPqPRLYtbgRLmobpcpGyhWfEn6QT5/L8003/e34PHR0rag==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+q5P5OhLuTdVGKBxbiQfKotd027VkGzl0oXE0SKR+z/RBxtVy
	RS2x7JmVfmykTRK34EMlDHmOhU05uZRrlaOhwJl3s1npwLsuJHGjGTjdIdGRx0tXMwJMZIrqIxV
	96RYJ71OXlY+PEE2Z3t5f7Rk4gneEP/rzIRavBA==
X-Gm-Gg: ASbGncs2WzMaspijrJJgMxT3CrfqWRV9J1R/urmmrYWPFNlbGuiK6jq0sBiI8twGQ69
	hgVF3aXbqjekXzXW/biHXL7szZqVitacIgcQ67jjSMShSYtc0cPy2MGGUjPPkUtxuuY8zQqKZdr
	Q2wd1+NhHz1fq03aPPPK0rPSKbLHssnQ7/sgoadVcKxrSsEFNaaxK2jQtMP9U=
X-Google-Smtp-Source: AGHT+IEoVtS3wtABMueDyhwxwPrmwekordJTJx/TktHKgJJHSvBtMqZN9mqoDPlniigIDnIWShFsVJg6OcS8AgF/8qI=
X-Received: by 2002:a5d:5c84:0:b0:39c:2665:2bfc with SMTP id
 ffacd0b85a97d-39d146624demr9176866f8f.52.1744023229145; Mon, 07 Apr 2025
 03:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
 <20250404122902.2750036-2-sofiane.hamam@smile.fr> <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
 <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com>
In-Reply-To: <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com>
From: Yoann Congal <yoann.congal@smile.fr>
Date: Mon, 7 Apr 2025 12:53:23 +0200
X-Gm-Features: ATxdqUExZj9Ryx5aO8fBfcZYT4EXlMtR8Xu0tprjpeUSvlYJpb-g9Uc_YUn86h8
Message-ID: <CAMSfU+5pbVe4JsXDY2xH40CS_K=vqH9iaCEso9tfMh19daNgZA@mail.gmail.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target docs/man/dmmp_strerror.3
 to .PHONY list
To: Martin Wilck <mwilck@suse.com>
Cc: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev, bmarzins@redhat.com, 
	=?UTF-8?B?S8OpbMOpZmEgU2Fuw6k=?= <kelefa.sane@smile.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Le lun. 7 avr. 2025 =C3=A0 12:32, Martin Wilck <mwilck@suse.com> a =C3=A9cr=
it :
>
> On Mon, 2025-04-07 at 10:53 +0200, Martin Wilck wrote:
> > On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> > > From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
> > >
> > > When checking out the git repos, sometimes, target
> > > docs/man/dmmp_strerror.3 is newer that the prerequisite
> > > libdmmp/libdmmp.h this leads to a non reproducible behavior:
> > > Sometimes, the timestamps are updated in the manpages, sometimes
> > > not.
> > >
> > > Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> > > Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> > > Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> > > ---
> > >  libdmmp/Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > > index 7e0e2509..187bcb8c 100644
> > > --- a/libdmmp/Makefile
> > > +++ b/libdmmp/Makefile
> > > @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -fvisibility=3Dhidden
> > >  LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -L$(mpathcmddir) -
> > > lmpathcmd -lpthread
> > >
> > >  all: $(LIBS) doc
> > > -.PHONY:    doc clean install uninstall check speed_test
> > > dep_clean
> > > +.PHONY:    doc clean install uninstall check speed_test
> > > dep_clean docs/man/dmmp_strerror.3
> > >
> >
> > I've seen the issue you refer to, but this is not the right solution.
> > It will cause the time stamps of the man pages to be regenerated on
> > every build.
>
> After investigating this some more: AFAICS, your patch 1/2 fixes the
> erratic behavior in the (normal) case where KBUILD_BUILD_TIMESTAMP is
> not set and git is available. Previously, in this case, the kernel-doc
> script would have substituted the current date for
> KBUILD_BUILD_TIMESTAMP (yielding "April 2025" today). With your fix,
> KBUILD_BUILD_TIMESTAMP is correctly set to "August 2024".
>
> We need to create a commit that updates the man page time stamps to
> "August 2024". I'll do this.
>
> Once this is done, the build rule does the right thing, AFAICS. While
> it will rewrite the man pages if the libdmmp.h timestamp is updated, it
> won't apply any real changes (visible in "git diff" or "git status")
> unless libdmmp.h has actually changed.
>
> Am I overlooking something?

Depending on the order the files are written on disk during the git
clone/archive extraction (is dmmp_strerror.3 written before or after
libdmmp.h ?), the build rule will either run or not.
But, as you wrote, with your latest patch, it does not matter at all
because the rewritten timestamp will be exactly the same.

Apart from this little quirk without any consequence, it looks good to me.

The only future problem I can imagine is if libdmmp.h is updated
without updating the timestamps (again).
In this case, we will either get the timestamps from the sources or from gi=
t.

Thanks for looking into this!

>
> Martin
>

Regards,
--=20
Yoann Congal
Smile ECS
