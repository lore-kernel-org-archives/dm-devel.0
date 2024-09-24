Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC46D11CA0
	for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 18:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727202234; cv=none; b=rTbRJpibyKfSJtoLYEFVGYecLQNGCRh0mqossLr1gL8rY1I445x+84Cdpp2HHP46Fkx8zpW1a6YYVLOgMBwxcr0DQbJOqrNfzJ8j5Roi0+cLjakF8lCrGvHsvEKlGSyfQ5V1AbvEDsDrOw/WPhmK7z6S3/S9iMMyn4W/t6HPK7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727202234; c=relaxed/simple;
	bh=JgAseltbHcoPvYTZr4FDq+eO6BaW5x8dJGRj7nCwtWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=if6xCeLI/jOeaN2/4OWPGT47rTFpFRybUaLldFnuPzC4t0Vx9PJgA/iReBfRiiNPdV9PouOG2h0OmlEprZrycEIIBesUle8BgB+06+t84VQzwN+HZKA+hFuJtjZUTqyeKcyrVO6D1pY7reFDNzRkC1slMRyrrNqzLaU81Zm8OzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IKPfv5Pn; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IKPfv5Pn"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c2460e885dso2993a12.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Sep 2024 11:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727202231; x=1727807031; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L2GZRbVLvSJYL5pvSH7ABhKOijW7RrztT8fIBc8MF5c=;
        b=IKPfv5PnWstqpUWlPskNa2NN+bjYdiapVh+Qufas9ZcVLllRa0OiuHbMKcbeiqis0B
         Fa2EtZr4pf3I4hkJa75OPqK6jk8iGOfuDjzUNrlqgT49U7Nu4SVe9AuGufaltqmMfnDU
         sRGirSUXWpi7fXBSQBvK6BIGiWjvksS/KUf4jWG7Kjf84Z19U3JCRMHRJYK5YKDhkYDq
         aVxQgWpHO7My6DjuBHOLh3EDArzxgrnXrn/abKdz3cR7KO+stSXy18DGDzOsL9zTYR/u
         usemTFx6B8SDfXx+BHF7Wc7Y2bjtCt5IEuOpQ3t14U8rLSuGeNQtmSe/qrOBGjonwfHI
         r6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727202231; x=1727807031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L2GZRbVLvSJYL5pvSH7ABhKOijW7RrztT8fIBc8MF5c=;
        b=cm02NtSL9enpEI/e5bX6Yc36BGK57ChXnL2wc3InUAG4Mp+LUH9gj5Ltx5Yym1rhax
         B2/UYWMZI9fGflqzxBHWKQj0jsqwLwFJDpae3TJQD/pHsNntGqq0JslhrsaHROy9fUVi
         glf8xYQOv0bVWi1e+qIyZWriukmZ+GDLvpvxiiZXdtvJHZdFstx9GkCQQ4U9B5tTnDHG
         EU1uygXDBw793AhRgs1pEA4aB14/V0qci7V/GltM0KSvXnp5MiTSd8PJgNJJxrMkTBih
         I5gjA2icOHKYBotqwgFsZFVW6RJT/ZIbYLrHZs1bIiF4fN92T0I+JtSmenIAScjKF0Ga
         88hg==
X-Forwarded-Encrypted: i=1; AJvYcCWLBu8LGwiXm60W+6a0W/hr7Vir4kw6nNGm/lrkYfnpgH+BT74nPhmFOTRc9mc6TIDgNqgRmAvw6Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzSew2rqPIxdprl1z7RW50lfLvxsoZWHHa5rVzCnr8EOHEmfdx7
	TPIuJ2f8saeMx7DvsZd9cIRtwitg9PUpCW4VJpUApn2v9jI9zHWLF7Wv9L3E2RJoEobfXNWeMQQ
	8wsbpBeYHJIM45V+Oc43oeaF2zwkVoqBTGjVTHPO2Hto8MCFKpBQV
X-Google-Smtp-Source: AGHT+IGozz28aMTKzaXwEX1b2882qeXCsxAWAgqXWn3zud67xGgn+L7N2uQAaNHSsaO+aM+U6msN+tRgzYAO50Sq+Is=
X-Received: by 2002:a05:6402:84c:b0:5c2:5251:ba5c with SMTP id
 4fb4d7f45d1cf-5c72073ddeemr54404a12.0.1727202230589; Tue, 24 Sep 2024
 11:23:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com> <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
In-Reply-To: <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
From: Akilesh Kailash <akailash@google.com>
Date: Tue, 24 Sep 2024 11:23:38 -0700
Message-ID: <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Maxim Suhanov <dfirblog@gmail.com>, 
	Alasdair G Kergon <agk@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Mike Snitzer <snitzer@kernel.org>, security@kernel.org, dm-devel@lists.linux.dev, 
	Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2024 at 10:44=E2=80=AFAM Sami Tolvanen <samitolvanen@google=
.com> wrote:
>
> Hi Mikulas,
>
> On Tue, Sep 24, 2024 at 6:18=E2=80=AFAM Mikulas Patocka <mpatocka@redhat.=
com> wrote:
> >
> > Maxim Suhanov reported that dm-verity doesn't crash if an I/O error
> > happens. In theory, this could be used to subvert security, because an
> > attacker can create sectors that return error with the Write Uncorrecta=
ble
> > command. Some programs may misbehave if they have to deal with EIO.
>
> I seem to recall that this was intentional. We used to restart/panic
> on I/O errors with FEC enabled, but the behavior was changed in commit
> 2c0468e054c0 ("dm verity: skip redundant verity_handle_err() on I/O
> errors"). Akilesh, do you remember what exactly was the issue here?
>

I looked at the history and the original intent and the idea stems
from this patch:
https://lore.kernel.org/dm-devel/b004e7c7-f795-77ed-19b9-983785780e92@gmail=
.com/T/#mec4df1ba3f3cb63846875fb2bfc1f8b3100f31f1

I think the EIO should be propagated back up the stack; I think this
will trigger panic
even for genuine I/O errors.

> > This commit fixes dm-verity, so that if "panic_on_corruption" or
> > "restart_on_corruption" was specified and an I/O error happens, the
> > machine will panic or restart.
> >
> > This commit also changes kernel_restart to emergency_restart -
> > kernel_restart calls reboot notifiers and these reboot notifiers may wa=
it
> > for the bio that failed. emergency_restart doesn't call the notifiers.
> >
> > Reported-by: Maxim Suhanov <dfirblog@gmail.com>
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> >
> > ---
> >  drivers/md/dm-verity-target.c |   15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6/drivers/md/dm-verity-target.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/drivers/md/dm-verity-target.c        2024-09-23 17:4=
8:08.000000000 +0200
> > +++ linux-2.6/drivers/md/dm-verity-target.c     2024-09-24 11:34:08.000=
000000 +0200
> > @@ -273,7 +273,7 @@ out:
> >                 return 0;
> >
> >         if (v->mode =3D=3D DM_VERITY_MODE_RESTART)
> > -               kernel_restart("dm-verity device corrupted");
> > +               emergency_restart();
>
> Can we still log the reason for the restart? I remember some folks
> used to rely on the "dm-verity device corrupted" message in the kernel
> log.
>
> Sami
