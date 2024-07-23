Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325214C5A1
	for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721755065; cv=none; b=JfiN8pcZIRLbx4WWQdnRmK6q/85yIQe7JQon0SDQ4jZofoHOhr4g2l6uVloD7YODCOfiTukLzfRaJRkD8edMan++TeyArmbiedPiiRzFpDdsjjgESpP6W8SsIC6KoXl9Ml/CBEDPLfffyKWuAa15AaAigczd4RI6Th/5xgtsf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721755065; c=relaxed/simple;
	bh=wsp9KB8SuHg/ClNGOBJifz2KS20QsmLx/86VcT0FNUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PmAuzcWM9IHNC2kTEsaLrLIeuWmUgWeUObpq7yoasnGlHvdjSwlvYLenS431+LfQ4mHy7GAW4kb/jcwbGluvf1O7SZBd/eVs64I0nhkmO6HNzYx7J45xC10IUHsKr8fD7SML8uDfM6fiGLQSVrMUYa4G+4v1o4y08sCYdibuiEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=JVvtWI6U; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JVvtWI6U"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7a17b4eeb50so359455985a.1
        for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 10:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1721755063; x=1722359863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqpmdY8tkUX7S7RHI1j3eoWbLgmNFz+Dl9nwWGk07rE=;
        b=JVvtWI6Ua9deumeuOBPI7RV8X29yfrTkZENmwg5WxeBnFEvr2D5feNVXew5v3dqG/7
         dqilnPCHO/c8Sfbu6a+8bz6pBVJU7DovcqNfWLXwEvngtiJbz4ekoG4f00bBDfBdQTeM
         pKSS70Qd0FixFuHsF4ZN02brJrMMqoiQhm+Pk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721755063; x=1722359863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqpmdY8tkUX7S7RHI1j3eoWbLgmNFz+Dl9nwWGk07rE=;
        b=bhzUMwWaorefWRQtuIezcVcEMk5aBhlUccKal9JgEooH2S7p9noA1c8TrSIlcTiVll
         ZxPCT1RQ4BHmsJVWpWUmXAjr2AE8NED+SRprAzkcbnF53xDwkJVpUePUmoOzGM/sQ/Iu
         5RfCE5qHBXNS6NJ2Jd+QUFVwALwYzR1RtEi9xh6cdD18QCEfvdGCjKK/qtQ5CfiHpK6x
         jggySRGsjMZKuRJLLG2xy5vD6w3lGRyfWESBd90uN7n5WG8VmmEkvwEs3IjnK5sN3PO1
         dv2sbaPp9FQHSADTB91yhAbRvooWRK30m7uJq+pa5lisiK0dZdYouBMuI+X2Lfu+RupH
         Ur+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8R7crFBycsp5UKisQioqDw8J3RQzYHRFSmYND4D4RpofUsU3kNbh9Ax1vKx4NxAKLEKV4EK7bV9ZFTei6ySVru8+TyRTHV2s=
X-Gm-Message-State: AOJu0YzuRUblqz5agp8xYG4dLmfvXmJdrz0p9zF25wqdWnjt/Z7gum01
	FJep4fdPNSHO/OFyRe13+3cNNpkFelGk71RlrErnhFmOLnAhsQe4Z346hS2gCdxg0GaKTpQh/O0
	=
X-Google-Smtp-Source: AGHT+IHRbkWEjlaisIyVFpWKFXU6iRbo5yUyn4VDY8+Ob0gxKcTYxp1mREJWndtLRRQBayjsXj0V4Q==
X-Received: by 2002:a05:620a:40d1:b0:79f:23a:bf89 with SMTP id af79cd13be357-7a1a6530c27mr1302629985a.19.1721755062712;
        Tue, 23 Jul 2024 10:17:42 -0700 (PDT)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com. [209.85.160.176])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a19905a890sm494907985a.76.2024.07.23.10.17.42
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 10:17:42 -0700 (PDT)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-44e534a1fbeso9951cf.1
        for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 10:17:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV9+j91NmTqyD7tIWJR8G5pBkf8OO6WRfCTbC2as3Nv4dE0Y5df3jH+0U5s/voeR1lDoL7SMhnbqp2kOXbpTlP2tGQe+jLHFR8=
X-Received: by 2002:a05:622a:5c7:b0:447:d225:6e3a with SMTP id
 d75a77b69052e-44fd4a74a99mr188261cf.4.1721755061784; Tue, 23 Jul 2024
 10:17:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
 <20240717231833.2090430-1-khazhy@google.com> <34139e33-3e7-4895-bd4-2d9f7727e9fb@redhat.com>
 <99266e5d-de9d-4d31-a1f2-d003bddb7b44@gmail.com>
In-Reply-To: <99266e5d-de9d-4d31-a1f2-d003bddb7b44@gmail.com>
From: Khazhy Kumykov <khazhy@chromium.org>
Date: Tue, 23 Jul 2024 10:17:28 -0700
X-Gmail-Original-Message-ID: <CACGdZY+bY+i=pbe9MXJQFVRVXehTsHT60ew_QxS7z4xXXvyvbw@mail.gmail.com>
Message-ID: <CACGdZY+bY+i=pbe9MXJQFVRVXehTsHT60ew_QxS7z4xXXvyvbw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] dm ioctl: fix erroneous EINVAL when signaled
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Zdenek Kabelac <zkabelac@redhat.com>, 
	Joe Thornber <thornber@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2024 at 6:11=E2=80=AFAM Zdenek Kabelac <zdenek.kabelac@gmai=
l.com> wrote:
>
> Dne 23. 07. 24 v 14:51 Mikulas Patocka napsal(a):
> >
> >
> > On Wed, 17 Jul 2024, Khazhismel Kumykov wrote:
> >
> >> do_resume when loading a new map first calls dm_suspend, which could
> >> silently fail. When we proceeded to dm_swap_table, we would bail out
> >> with EINVAL. Instead, attempt to restore new_map and return ERESTARTSY=
S
> >> when signaled.
> >>
> >> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> >> ---
> >>   drivers/md/dm-ioctl.c | 23 +++++++++++++++++++++--
> >>   1 file changed, 21 insertions(+), 2 deletions(-)
> >>
> >> v2: don't leak new_map if we can't assign it back to hc.
> >>
> >> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> >> index c2c07bfa6471..0591455ad63c 100644
> >> --- a/drivers/md/dm-ioctl.c
> >> +++ b/drivers/md/dm-ioctl.c
> >> @@ -1181,8 +1181,27 @@ static int do_resume(struct dm_ioctl *param)
> >>                      suspend_flags &=3D ~DM_SUSPEND_LOCKFS_FLAG;
> >>              if (param->flags & DM_NOFLUSH_FLAG)
> >>                      suspend_flags |=3D DM_SUSPEND_NOFLUSH_FLAG;
> >> -            if (!dm_suspended_md(md))
> >> -                    dm_suspend(md, suspend_flags);
> >> +            if (!dm_suspended_md(md)) {
> >> +                    r =3D dm_suspend(md, suspend_flags);
> >> +                    if (r =3D=3D -EINTR)
> >> +                            r =3D -ERESTARTSYS;
> >
> > I'd like to ask why the "EINTR -> ERESTARTSYS" conversion is here and w=
hy
> > it isn't in dm_suspend?
I proposed ERESTARTSYS here since the act of waiting for the device to
suspend successfully seems "restartable" - I think the same reasoning
would apply to do_suspend.
> >
> > What do libdevmapper+lvm maintainers think about it? Does lvm hadle EIN=
TR
> > by restarting the ioctl syscall? Should we return ERESTARTSYS when susp=
end
> > is interrupted?
>
> In general - with suspend failures - we are just stopping whole operation=
 -
> and restoring previous state - so user can run operation again.
>
> There is no special check for exact reason of ioctl failure.
>
> Regards
>
> Zdenek
>
