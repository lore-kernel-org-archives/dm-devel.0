Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACABF46B5
	for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727107562; cv=none; b=OED1Wfc5+nz6L11IOksW4toBxh7Tp06uj3gRfHDtGgJQw6lU6ST0VNWxAJPWz3tS2suV+FU0qsnoGqXvHRovHWZml6FCOlxS+SPk1cEXmko9Jx71LSk2o0pviuifb+xKxFN82TaVUoHB8xEAZvr2FNSaYziKE9tYqGzi1aQk+fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727107562; c=relaxed/simple;
	bh=B6nj2YLT4D/wlqqzFmJa2BxfrWUGYUdzA6f5p6Tagew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mNjNemt4FdwMePVMDBHXjWeSFzxSo0HpfMoDLlMWuv5qGgu+AhEomXeMmzNDbAfPdxpnvcEdEvCX60GIE0vp/t6qUDy6Z0iyEiJ39LhRF2RdeHVV99qqHpI7W0YsXujO/qGNnjgFq3ExAgAXyWM3SVwBlb5W6FrKr8JxovK73hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2Od0R61; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2Od0R61"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-49bd643f858so1511398137.0
        for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 09:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727107559; x=1727712359; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjP2FVA9GyHqcqrVlHf4sMId3XeNp2zxUyT00XEy7YQ=;
        b=A2Od0R61FUWhqJtesGREXZap9OitEKpuY+j0NdkawqgVIrFm6EyX74D9OQ3N8gEPkm
         1nSBiYfA0dAOFQ8sg1B9aIcrIoYwNU9aUoEZuY5PUBfDG/B503NOsrdPfcs6ITKI9bPd
         jLyBhRzaWH7T0WLK8SEJiFi7r/v4DJwIpl6ub1TfiJcoSGg/89WrkzxgA6qW9RS1FdKz
         DqVi+9pEInLJwUhJyvb7rO6CAhiHK5V8wNqQtsptrOrEKr3FAxiPb5Bh3J2gJLX17nZE
         lF5q21c/4RlgJhUEj8dilxh/1yn74AI3ZBdVrAve5/u1FATb4YsYvVTalV0rjT/VCVC1
         mL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727107559; x=1727712359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rjP2FVA9GyHqcqrVlHf4sMId3XeNp2zxUyT00XEy7YQ=;
        b=mqYkr5Z3P4rlZ/F7x6hv+LPgu7zJJRf1XX2T1MabBOlJ4KLawbs456ogRfXl5oMeZK
         +5HO2o2f0M7Qc7gONHC5v7lUN3txUrFyU3+gM6eF1gcP5djCOJoWfR36an0jJKaQ8pAf
         klrZRShjVzjmUeqhftFKKGvItln1Z73xANCJKYdGsowVjKNdiLmehP9jnoe+T/dPNj1B
         9i5X3npIf/0n9IYw3C5WX9sS3SbUOEbC6cLYl7HWh5AZ8otWO/a1vo2QX3wC0I1C+J3n
         f0XSlvwzAdSCHzd/8NQzDzspIhIBXvv2chghycc6+Uv772a+QLxk0wjkOGJRngpy26TV
         HEqw==
X-Forwarded-Encrypted: i=1; AJvYcCWQ6ktypLpQ6WG14PCDJ8v+55FvcYQC5+ltTTICckCF3vMZSectj5qdluXbtBtGjLJJ8OZYY6YWTg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyqTPN1sdZ6eywaJHEbyWrf28V16mAY4M8xq/WhDB/BJKT4AgH2
	zSrVahccOeYdsA0uZneohJwZIs8jcQJ88L65mJ7v87PqlVaKLbcbGp9G22udBIBYX00sCCDY4MB
	iDtW3out+2MpAxz9w/L9x3SUH9t8=
X-Google-Smtp-Source: AGHT+IEUg2zXAfe1tkR8PdEPwTh7fron36ChAGsRCD55XcwH8aCFU7+yHgfNiQZvwn9eMgeSstUj4zvz+ZqjMe7+aGA=
X-Received: by 2002:a05:6122:907:b0:4f5:2c0c:8528 with SMTP id
 71dfb90a1353d-503e05501f1mr7220010e0c.11.1727107559294; Mon, 23 Sep 2024
 09:05:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240922164702.49615-1-kdipendra88@gmail.com> <CAAYit8TfBD40aRchLiOWsvqwpAR0x6nW9zObza4vLVzg93N+eA@mail.gmail.com>
 <87139a89-4256-fceb-5ca2-c1077b036eef@redhat.com> <CAEKBCKMv4-dhWU=a2UnX2rBcQjVTJcF+wg6z6f3qtjA4td-62Q@mail.gmail.com>
 <28e1f99d-eb8e-2357-0afb-a9bb0d5b0a06@redhat.com>
In-Reply-To: <28e1f99d-eb8e-2357-0afb-a9bb0d5b0a06@redhat.com>
From: Dipendra Khadka <kdipendra88@gmail.com>
Date: Mon, 23 Sep 2024 21:50:47 +0545
Message-ID: <CAEKBCKOOm1UETLTgONr=eG8GY1MLkKdG_G=o8Wh0y1079Q1MeQ@mail.gmail.com>
Subject: Re: [PATCH] Return error code for failure input for sscanf in parse_cblock_range()
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming-Hung Tsai <mingnus@gmail.com>, agk@redhat.com, snitzer@kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Sept 2024 at 21:45, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Mon, 23 Sep 2024, Dipendra Khadka wrote:
>
> > Hi,
> >
> > On Mon, 23 Sept 2024 at 20:55, Mikulas Patocka <mpatocka@redhat.com> wr=
ote:
> > >
> > >
> > >
> > > On Mon, 23 Sep 2024, Ming-Hung Tsai wrote:
> > >
> > > > On Mon, Sep 23, 2024 at 12:47=E2=80=AFAM Dipendra Khadka <kdipendra=
88@gmail.com> wrote:
> > > > >
> > > > > Smatch reported following:
> > > > > '''
> > > > > drivers/md/dm-cache-target.c:3204 parse_cblock_range() warn: ssca=
nf doesn't return error codes
> > > > > drivers/md/dm-cache-target.c:3217 parse_cblock_range() warn: ssca=
nf doesn't return error codes
> > > > > '''
> > > > >
> > > > > Since, the only negative value that is returned by sscanf is -1.
> > > > > Returning -ENVAL when sscanf returns -1.
> > > > >
> > > > > Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
> > > > > ---
> > > > >  drivers/md/dm-cache-target.c | 8 ++++----
> > > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-t=
arget.c
> > > > > index 17f0fab1e254..c35d65e310d6 100644
> > > > > --- a/drivers/md/dm-cache-target.c
> > > > > +++ b/drivers/md/dm-cache-target.c
> > > > > @@ -3200,8 +3200,8 @@ static int parse_cblock_range(struct cache =
*cache, const char *str,
> > > > >          * Try and parse form (ii) first.
> > > > >          */
> > > > >         r =3D sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> > > > > -       if (r < 0)
> > > > > -               return r;
> > > > > +       if (r =3D=3D -1)
> > > > > +               return -EINVAL;
> > > > >
> > > > >         if (r =3D=3D 2) {
> > > > >                 result->begin =3D to_cblock(b);
> > > > > @@ -3213,8 +3213,8 @@ static int parse_cblock_range(struct cache =
*cache, const char *str,
> > > > >          * That didn't work, try form (i).
> > > > >          */
> > > > >         r =3D sscanf(str, "%llu%c", &b, &dummy);
> > > > > -       if (r < 0)
> > > > > -               return r;
> > > > > +       if (r =3D=3D -1)
> > > > > +               return -EINVAL;
> > > > >
> > > > >         if (r =3D=3D 1) {
> > > > >                 result->begin =3D to_cblock(b);
> > > >
> > > >
> > > > Could you please clarify how to reproduce unexpected results? From
> > > > what I observe, the kernel's sscanf doesn't return -1 on an empty
> > > > input. Even if a negative value other than -EINVAL is returned, it =
is
> > > > handled by the callers.
> > > >
> > > > Hank
> > >
> > > I applied the patch, but I deleted the conditions "if (r =3D=3D -1) r=
eturn
> > > -EINVAL;"
> > >
> > > sscanf in the kernel doesn't return negative numbers.
> > >
> >
> > Do I have to send v2 with
> > if (r !=3D 2)
> >  return -EINVAL;
> >
> > or what should I do now?
> > > Mikulas
> >
> > Best Regards,
> > Dipendra
>
> You can do nothing :)
>
> I fixed the patch and I'll send it to Linus in this merge window.
>

Oh, ok. Thank you for your time.

> Mikulas

Best Regards,
Dipendra.
