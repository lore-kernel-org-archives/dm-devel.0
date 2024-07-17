Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B33433D0
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 19:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721245978; cv=none; b=mLbqPVqk6j3VaE0CLznU03IWzQKGt+ajDo3ExIIujyAhAp+ToqopG+JfNG+qs+jz+Qx0NDTWYgGIpx3596WSjlCNOY7scdoWj1i10z+VSAX5rNyN2K/MHMUiK5V4LMtpInHDTFLFA7YfLGPjtrkRlWWtZvi0IRK2LbzN9oa6SxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721245978; c=relaxed/simple;
	bh=ZauPFTwig0lAM8GH3yDgtA99zKZJdt45erSe5eINhJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NsQUIcrqlfwErUrA9DjHmW+BcGHJhvjnR/d2Tt9/gOj+2kUasX51wo5bDyeVptnnHePCs92efgzULUsdNScEfzFTrYpNeAhXwXDVaAwlmpE72HTj1aedVuD8IYoRNSxAFfKnkUZC5LUBNRsdHvLP0dmF2zNj0xvwY5oUs+YjfHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jbie/1nE; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jbie/1nE"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-44acdd30c3fso118841cf.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 12:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1721245975; x=1721850775; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCt2qgFBTENxzYjWiHSzIwJ4sPIWdAkJsmJNvcaX3wg=;
        b=jbie/1nETbdzeaeMf2gHx0u9P8uT4C3yb9lLc+c8XddQOmI+M8yEeqIJ9gzR39+LEK
         4/wgFk7VMoSCSuuXLi9lMJyJ6/bqzRLQD0a17rIQBcL4npB9techJHOKceSnSz/Cw0Ce
         96xyBHs9jrlGI7uyx97p3/WCXOj4v7Al+P/rg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721245975; x=1721850775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dCt2qgFBTENxzYjWiHSzIwJ4sPIWdAkJsmJNvcaX3wg=;
        b=v6wOyJVtS02EAvjniKWrAS33JWiVOzYEd1oWw/tTFwQ6mXAt9yM31YZ4QRppIQh9s8
         cDiT6nfl5sTS1pYm1z9BCLN/GWgSPjlXcArYPliMCLtap94dSqlrrYPtTBwImw3KMDI+
         vgwfLZaulDDrh5bxvZGb6FD4JPQl+MMX9VBVasioQ0S201fLRLlOc/VDIxsGT1RwTLH3
         b2o4W5WJ5d2zyZAp1zP5fxVy4Os38TsZ+9Yq4dG0i8vfhn9r8ejjAUhzcZ8nJehzDwnR
         o6sfJBAqZSQq6Y5+7SYGJSULKUq9Lo4nkM3dZvpqdfYHTqQXJX9lAWG1SY+j61DZ+sA9
         SVGw==
X-Forwarded-Encrypted: i=1; AJvYcCXKSc8IpXPMrm23aIUFnLimnkchT7X7KH/IeFdxLJ2zvXcIwTpeknAhscjBsR8jEders56/emhV53MR42hF9+19Bzprxkzh9/s=
X-Gm-Message-State: AOJu0YzWhOedtm4b3jyIFq+ufgTx+S7VEwBlUB87TqnFnO/kCoQaWp+5
	7FKMWKO3tCBRQE4mjmomPW+3E6prK8qvw5Ph2a/LIBpHPRlzVTalJBxpUdNtitG+8VfbfhreHcg
	=
X-Google-Smtp-Source: AGHT+IEXfWtrkGfvovQNq8XGg9wCBovZqeCU8D5/ax90VxSqfw+AzNGEtXkMiYbKxR0HB3EJSNPsOQ==
X-Received: by 2002:a05:6214:21eb:b0:6b5:e898:16be with SMTP id 6a1803df08f44-6b79c7a5201mr5559986d6.40.1721245974708;
        Wed, 17 Jul 2024 12:52:54 -0700 (PDT)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com. [209.85.160.172])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b79c60ac07sm1669846d6.92.2024.07.17.12.52.53
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 12:52:54 -0700 (PDT)
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-447f8aa87bfso85311cf.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 12:52:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVErybMU4RjqgT/V4JLxO5cHPc1f8IcxfFeG9ITcEl+7qWt8uSL2kF4+5EjXbTjbYvI7eXV2lE2sq2h6tvUDlP1JjoePi8PfZc=
X-Received: by 2002:a05:622a:17ce:b0:447:d81a:9320 with SMTP id
 d75a77b69052e-44f9058d2bdmr608721cf.20.1721245973459; Wed, 17 Jul 2024
 12:52:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717185640.1026114-1-khazhy@google.com> <43954d4-6130-f36a-384c-9f18eda892@redhat.com>
In-Reply-To: <43954d4-6130-f36a-384c-9f18eda892@redhat.com>
From: Khazhy Kumykov <khazhy@chromium.org>
Date: Wed, 17 Jul 2024 12:52:40 -0700
X-Gmail-Original-Message-ID: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
Message-ID: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com>
Subject: Re: [RFC PATCH] dm ioctl: fix erroneous EINVAL when signaled
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <thornber@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 12:45=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
> Hi
>
> I am wondering why does do_resume need to call dm_suspend at all. Does
> anyone here remember why is this code path needed?

In our case, we have a sequence with load_table followed by a resume,
with no suspend first. The resume path suspends if needed, swaps
tables, then resumes. Removing the suspend here would break existing
userspace, I'd imagine. It seems like minimizing the suspended time
would also be a nice benefit.

>
> Mikulas
>
>
>
> On Wed, 17 Jul 2024, Khazhismel Kumykov wrote:
>
> > do_resume when loading a new map first calls dm_suspend, which could
> > silently fail. When we proceeded to dm_swap_table, we would bail out
> > with EINVAL. Instead, restore new_map and return ERESTARTSYS when
> > signaled.
> >
> > Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> > ---
> >  drivers/md/dm-ioctl.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> >
> >
> > RFC as I am rather unfamiliar with the locking semantics here - whether
> > we do need to re-grab hash_lock to write to an hc we previously grabbed=
,
> > and whether the device becoming unhashed while we're in this function i=
s
> > really something that needs to be checked. However, this patch does fix
> > the issue we were seeing - we'd get EINVAL when thread in ioctl was
> > signaled.
> >
> >
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index c2c07bfa6471..b81650c6d096 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -1181,8 +1181,22 @@ static int do_resume(struct dm_ioctl *param)
> >                       suspend_flags &=3D ~DM_SUSPEND_LOCKFS_FLAG;
> >               if (param->flags & DM_NOFLUSH_FLAG)
> >                       suspend_flags |=3D DM_SUSPEND_NOFLUSH_FLAG;
> > -             if (!dm_suspended_md(md))
> > -                     dm_suspend(md, suspend_flags);
> > +             if (!dm_suspended_md(md)) {
> > +                     r =3D dm_suspend(md, suspend_flags);
> > +                     if (r =3D=3D -EINTR)
> > +                             r =3D -ERESTARTSYS;
> > +                     if (r) {
> > +                             down_write(&_hash_lock);
> > +                             hc =3D dm_get_mdptr(md);
> > +                             if (!hc)
> > +                                     r =3D -ENXIO;
> > +                             else
> > +                                     hc->new_map =3D new_map;
Oh - I probably want to check if hc->new_map has become non-null in
the meantime and if so... pick a winner then put the loser? Presumably
the newest map should win if that happens / is possible. although the
concept seems suspect to me.
> > +                             up_write(&_hash_lock);
> > +                             dm_put(md);
> > +                             return r;
> > +                     }
> > +             }
> >
> >               old_size =3D dm_get_size(md);
> >               old_map =3D dm_swap_table(md, new_map);
> > --
> > 2.45.2.993.g49e7a77208-goog
> >
>
