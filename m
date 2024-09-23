Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F471E4AD
	for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 15:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727105748; cv=none; b=PfrY5qC8sM2JXCVhgKrUifuzQktU+hwNH1qcuootgcnH5bRlBz5TI8qgZBtp1CRPyb9TcJZx8JNXt3m4bAnYxlS2aTBfiVB+XN08daXCqgXsWXPQQSmkIi3WCodPnk6pU3mpEG41jhm+DrSMzThUOu6Z2JckPAQHJR+g9llghaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727105748; c=relaxed/simple;
	bh=VRGPDRmB9nJi9jBl9qjzBZeAzQSekiWLYp2PNxF7UKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JsOwKgfbZzujBmTPkO4zsv6Vz0VbvnZlIUzKVa+huNc9bGQ6ozq7kIOxseXMOgtVqVuoGk8/zsdnVjxdl/NGPVYK6DxIZQcAp/3jWvA7wiqstkJ2Fz6oPMJngokNcPSGFYHmJnMSOZnAeD1i4PbHvOUJZLZOqYLA4b2x7bSgb1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RqDmLeEL; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RqDmLeEL"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-846b934981aso907429241.3
        for <dm-devel@lists.linux.dev>; Mon, 23 Sep 2024 08:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727105745; x=1727710545; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXrAGmFueWM5YytEy96ZiRUN6nOMakcrPk1l4nuEcQU=;
        b=RqDmLeEL5kAX8fkROpsC5WwmK4GxVKwfh4smrKsADR7ZhmqhhMWzf06EqVXE/gCMCF
         obUWtyO9tZpShM1KDutqP74KblcLmaapd07Is9R5BIi0f8ao8LIbcQG02YOJ5cE8BdGj
         mmzPtmCqB41fImNo1YBIXls87ctLG28PhC8cqdwDFq83QcnvVtTX61F1Hv37YRlQ/2eh
         okGtJKGF086cE3VS5DCrmpEgRKdHWfTvIj95GZOabTl7jaR5q5ioNYwmakk2wJ3PNFgE
         0k1hKHq18dSy0sVowh7gMB3/2TWU1DEDs0vEvTMWKXkH39OV3uaoEdSTT0mAa7jtHU2x
         ip3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727105745; x=1727710545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXrAGmFueWM5YytEy96ZiRUN6nOMakcrPk1l4nuEcQU=;
        b=KxVNEAqKI1xC5Fh6eS2pL+Uf6RJAZRsybyyw95+C2YH2Wlk+ejektT+ycvj49cHm9D
         u8MEPjg5niIMuCOWWFWE3CEyX4Jdj+murrzEVGmlNBdfrnGLCTPMEPd1QdyRWB+0in33
         cW5gLp43pFhevglKUVAwD3Qeo0kbUyhUEs4kBd+fbO6zwDWDX9ZsE9RaVs0TENbdDbKJ
         JTx2oU1lZyFtgXTD7jHFcZne9QVUs51nkTmn0Rn4GD5PgxHncN4MEM9WaxcmrTlSQOj4
         E7lytNmASSWHMofQkXGNqyPgM10y+2+IOfAIs8gkT68qEK4NvOab8MRdEFWlvpj+knjU
         0JPA==
X-Forwarded-Encrypted: i=1; AJvYcCW6pMgSEN5jVMya1dhmpgM8SOqP13f2ruaj7MmmUx0EGfw1u//O1f2dF4tzfnze0qPzwj9K+EXjJQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YynOByEy4c+LGk47xenzlHiAbwiSDnWrDRSYKAWuVwb/sHABl/O
	VAFQf2tTC2bxcY4NmCq/O31BGkVm7tITa8i66JJPC+cyzP19/aP5a1bY/Q0/FOpjRyPrLfBTSfT
	aDjgjv2Tn9hipEOOCg3cdBg9p00E=
X-Google-Smtp-Source: AGHT+IH9GQKnphCafHZMSRLrNhU3B8R/CoHeOdgwljGfcKMJcggbdT0zd3vFgDwFtBc1mBUQSl61BnRO+IQRsxxjE6c=
X-Received: by 2002:a05:6122:1692:b0:4f3:828:7a47 with SMTP id
 71dfb90a1353d-503e045928dmr7393256e0c.6.1727105745277; Mon, 23 Sep 2024
 08:35:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240922164702.49615-1-kdipendra88@gmail.com> <CAAYit8TfBD40aRchLiOWsvqwpAR0x6nW9zObza4vLVzg93N+eA@mail.gmail.com>
 <87139a89-4256-fceb-5ca2-c1077b036eef@redhat.com>
In-Reply-To: <87139a89-4256-fceb-5ca2-c1077b036eef@redhat.com>
From: Dipendra Khadka <kdipendra88@gmail.com>
Date: Mon, 23 Sep 2024 21:20:33 +0545
Message-ID: <CAEKBCKMv4-dhWU=a2UnX2rBcQjVTJcF+wg6z6f3qtjA4td-62Q@mail.gmail.com>
Subject: Re: [PATCH] Return error code for failure input for sscanf in parse_cblock_range()
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming-Hung Tsai <mingnus@gmail.com>, agk@redhat.com, snitzer@kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 23 Sept 2024 at 20:55, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
>
> On Mon, 23 Sep 2024, Ming-Hung Tsai wrote:
>
> > On Mon, Sep 23, 2024 at 12:47=E2=80=AFAM Dipendra Khadka <kdipendra88@g=
mail.com> wrote:
> > >
> > > Smatch reported following:
> > > '''
> > > drivers/md/dm-cache-target.c:3204 parse_cblock_range() warn: sscanf d=
oesn't return error codes
> > > drivers/md/dm-cache-target.c:3217 parse_cblock_range() warn: sscanf d=
oesn't return error codes
> > > '''
> > >
> > > Since, the only negative value that is returned by sscanf is -1.
> > > Returning -ENVAL when sscanf returns -1.
> > >
> > > Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
> > > ---
> > >  drivers/md/dm-cache-target.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-targe=
t.c
> > > index 17f0fab1e254..c35d65e310d6 100644
> > > --- a/drivers/md/dm-cache-target.c
> > > +++ b/drivers/md/dm-cache-target.c
> > > @@ -3200,8 +3200,8 @@ static int parse_cblock_range(struct cache *cac=
he, const char *str,
> > >          * Try and parse form (ii) first.
> > >          */
> > >         r =3D sscanf(str, "%llu-%llu%c", &b, &e, &dummy);
> > > -       if (r < 0)
> > > -               return r;
> > > +       if (r =3D=3D -1)
> > > +               return -EINVAL;
> > >
> > >         if (r =3D=3D 2) {
> > >                 result->begin =3D to_cblock(b);
> > > @@ -3213,8 +3213,8 @@ static int parse_cblock_range(struct cache *cac=
he, const char *str,
> > >          * That didn't work, try form (i).
> > >          */
> > >         r =3D sscanf(str, "%llu%c", &b, &dummy);
> > > -       if (r < 0)
> > > -               return r;
> > > +       if (r =3D=3D -1)
> > > +               return -EINVAL;
> > >
> > >         if (r =3D=3D 1) {
> > >                 result->begin =3D to_cblock(b);
> >
> >
> > Could you please clarify how to reproduce unexpected results? From
> > what I observe, the kernel's sscanf doesn't return -1 on an empty
> > input. Even if a negative value other than -EINVAL is returned, it is
> > handled by the callers.
> >
> > Hank
>
> I applied the patch, but I deleted the conditions "if (r =3D=3D -1) retur=
n
> -EINVAL;"
>
> sscanf in the kernel doesn't return negative numbers.
>

Do I have to send v2 with
if (r !=3D 2)
 return -EINVAL;

or what should I do now?
> Mikulas

Best Regards,
Dipendra
