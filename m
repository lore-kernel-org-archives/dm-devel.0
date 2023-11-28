Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC7341C7C
	for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gxvvwi4o"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7b060378c47so160455539f.1
        for <dm-devel@lists.linux.dev>; Tue, 28 Nov 2023 10:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701194406; x=1701799206; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJQXN+s6rR7MVQoH2RQDeWOK81GIoOsXNTJLSzN1Zpc=;
        b=Gxvvwi4oZegIlB2KG+cM9iMowjn3tZVnet9vwYOvRcP8q3IF/Hwp1wK2I89/dwskHj
         6O+HcDvUJmyvjn7b28XKeVXoAqcM/q/Bv+0W0/4G2yMILW2HTwx0O1QlzErc+crDQffe
         MmCNE6/xUqe7zxR3ZweHbmFE2jX/rVbj1G+IKz2P8ir8MAgb9rZhhFoM/KUj/ddSsRa+
         mDC4JzSnyJv7wWQVXrlfzD5LXQvueJODYBYf0KxsmA30encg1RNh9lkydw4SFUfXTY18
         SdQ56EXEV5h+8HBZDHTq6V9+zTdIBG/s0GQMpZZcnwHfj06+IJSAM7mG75HEJBWBFtYD
         l9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701194406; x=1701799206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJQXN+s6rR7MVQoH2RQDeWOK81GIoOsXNTJLSzN1Zpc=;
        b=l/dMSuXvnfOMi1phQFn+f6p+XY4u28BE/aFRmd6y50QsueaiktSPqse339ZHyS9syJ
         G4fEsnnaRMUQY6Kj8156WRf8/Q+0jLcJAvCEOr2TeAEsVjxD4z3stBnXp37F1RVFw1Yj
         w7AK40n3fY7uGfwKWKX0oZZx6M4kImh8QZtB53qixHeSYRWAkWHKhRtWaUCEJrhSvyLq
         AVUNN2cutR9O5at+Vr3D8QnRg7RuFtoBRDhA2ov34Fw/gp6HgEKQVgVwzLc2AbkGJG5q
         q4TuHuEQsisqkQkn7POsl3abpn1LO7Jyw4EP/sjNOTQUA6qDWOuleq5tKAJv5v5kYifi
         kSeQ==
X-Gm-Message-State: AOJu0Yxh0S1V4eltwHvFHPWBlIrTqk/r9RpF63ZntFQin5jmAcgL8zYU
	Vn34E3EU1Jyp4SSWMH3uX4HcjVYMGDJdp2lERgdSOy2/6tU=
X-Google-Smtp-Source: AGHT+IFSs8FUtaQ3ixbEp/XDTkogF2CK6u7CXE3jZMsDYCgZJCsTK9ycYxGpzN4ETN1k5Xwdx44GbCj0jcwHhdJMUqM=
X-Received: by 2002:a5e:8a4b:0:b0:7a2:dee5:84b6 with SMTP id
 o11-20020a5e8a4b000000b007a2dee584b6mr12016157iom.21.1701194406510; Tue, 28
 Nov 2023 10:00:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231127215418.271708-1-bmarzins@redhat.com> <CAAMCDeer-7Nw72UBdQGeT_EsGfXUj=L5RshvDsPCp+5QNY2eyQ@mail.gmail.com>
 <ZWYfxODHbb0Jag66@bmarzins-01.fast.rdu2.eng.redhat.com>
In-Reply-To: <ZWYfxODHbb0Jag66@bmarzins-01.fast.rdu2.eng.redhat.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Tue, 28 Nov 2023 11:59:55 -0600
Message-ID: <CAAMCDefHt9bKpdmK+zfz5dP0fjy6T=vzEuCyfTF4QsdDHWKvfQ@mail.gmail.com>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery has failed.
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	device-mapper development <dm-devel@lists.linux.dev>, Martin Wilck <Martin.Wilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you.  That makes it clear.    Yes, we are setting it to "queue"
so it won't change behavior with that setting.

It also makes it clear that if we say set it no_path_retry to say
100000 that once all paths fail and it goes into recovery mode then
queuing would be disabled.


On Tue, Nov 28, 2023 at 11:13=E2=80=AFAM Benjamin Marzinski <bmarzins@redha=
t.com> wrote:
>
> On Mon, Nov 27, 2023 at 04:07:46PM -0600, Roger Heflin wrote:
> > How long does recovery take?     I am unclear on when the explictly
> > set queue_if_no_path is being overridden, and why disabling it is
> > useful.
>
> To be clear here. This fix shouldn't cause multipath to disable queueing
> in cases where it wasn't configured to do so. Previously, we were not
> always respecting no_path_retry. This fix makes sure that we are.
>
> This change only applies to the case where no_path_retry is set to
> a specific number of retries. When configuring multipath, if
> no_path_reties is set, it always takes precedence over
> "queue_if_no_path" set in the features line. So if a multipath device
> isn't configured to queue for a limited number of retries and then
> disable queueing, the fix changes nothing.
>
> When no_path_retry is set to a number of retries, if the last path is
> lost, the device goes into recovery mode. When a device goes into
> recovery mode, multipathd sets a counter to the value of no_path_retry.
> After every loop of the path checker through all the devices, that
> counter ticks down. If the counter hits zero, multipathd disables
> queueing on the device. When a path becomes usable, the device leaves
> recovery mode, stopping the countdown or restoring queueing as
> necessary.
>
> The problem that this patch fixes happens if the multipath device is
> reloaded after that count has hit zero, and queueing has been disabled.
> When reloading a device with no_path_retry set to anything other than
> "fail", multipathd will automatically enable queueing.  After reloading
> the device, multipathd checks the number of usable paths. If there are
> no usable paths, it tries to enter recovery mode.  However, in this
> case, the device already is in recovery mode, so nothing happens. And
> since the countdown has already completed, nothing will happen to
> disable queueing in the future. Now you are left with a device stuck
> indefinitely in recovery mode with queueing enabled and no usable paths,
> even though you configured it to only queue for a limited number of
> retries. This is bad.
>
> The solution the patch implements is to check if you are in this
> situation:
> 1. The device has no_path_retry set to a number of retries.
> 2. The device has no usable paths
> 3. The device is already in recovery mode
> 4. The retry counter for the device has already reached 0
> 5. The device is currently queueing IO.
>
> In this case, we clearly shouldn't be queueing, and calling
> enter_recovery_mode() will do nothing. So, we just tell the device to
> disable queueing.
>
> The change I made is in set_no_path_retry() which does get called in
> other cases besides after a device reload. However, if we are ever in
> the situation outlined above, we should not be queueing, so it is
> correct to disable it. The code I added in this patch is the mirror of
> the code directly above it in set_no_path_retry(). Here is that code.
>
> if (count_active_paths(mpp) > 0) {
>         /*
>          * If in_recovery is set, leave_recovery_mode() takes
>          * care of dm_queue_if_no_path. Otherwise, do it here.
>          */
>         if ((!mpp->features || !is_queueing) &&
>             !mpp->in_recovery)
>                 dm_queue_if_no_path(mpp->alias, 1);
>         leave_recovery_mode(mpp);
>
> It this case, we should be queueing, but we're not, and since we aren't
> in recovery mode, calling leave_recovery_mode() doesn't do anything.
> Instead we just directly enable queueing.
>
> > Typically we are setting queue_if_no_path to forever with the intent
> > that it will survive longer storage and/or disk issues without
> > returning an error to the application and/or corrupting fses if the
> > storage issue can be fixed.
> >
> > We generally expect it to recover when the storage comes back, but
> > that the storage could be experiencing significant issues for a
> > significant period of time >10 minutes.   Since the storage has to be
> > fixed to get things working again, there is a lot of negative value
> > that requires manual recovery steps when an error gets returned (fsck,
> > loss of data).
> >
> > We also manually disable queueing if we need to remove the mpath
> > devices (paths are already gone as they were non-responsive > 24 hours
> > and removed via tmo_timeout), and/or forcible reboot the nodes when we
> > determine storage is not coming back.
>
> If you are setting no_path_retry to "queue" (the recommended way) or
> adding "queue_if_no_path" to the features line while leaving
> no_path_retry unset (the deprecated way. See the man page) this change
> will not effect you. You will not ever get to this code in
> set_no_path_retry().
>
> Does that clear things up?
>
> -Ben
>
> >
> > On Mon, Nov 27, 2023 at 3:54=E2=80=AFPM Benjamin Marzinski <bmarzins@re=
dhat.com> wrote:
> > >
> > > If a multipath device has no_path_retry set to a number and has lost =
all
> > > paths, gone into recovery mode, and timed out, it will disable
> > > queue_if_no_paths. After that, if one of those failed paths is remove=
d,
> > > when the device is reloaded, queue_if_no_paths will be re-enabled.  W=
hen
> > > set_no_path_retry() is then called to update the queueing state, it w=
ill
> > > not disable queue_if_no_paths, since the device is still in the recov=
ery
> > > state, so it believes no work needs to be done. The device will remai=
n
> > > in the recovery state, with retry_ticks at 0, and queueing enabled,
> > > even though there are no usable paths.
> > >
> > > To fix this, in set_no_path_retry(), if no_path_retry is set to a num=
ber
> > > and the device is queueing but it is in recovery mode and out of
> > > retries with no usable paths, manually disable queue_if_no_path.
> > >
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >  libmultipath/structs_vec.c | 12 +++++++++++-
> > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> > > index 0e8a46e7..3cb23c73 100644
> > > --- a/libmultipath/structs_vec.c
> > > +++ b/libmultipath/structs_vec.c
> > > @@ -627,8 +627,18 @@ void set_no_path_retry(struct multipath *mpp)
> > >                             !mpp->in_recovery)
> > >                                 dm_queue_if_no_path(mpp->alias, 1);
> > >                         leave_recovery_mode(mpp);
> > > -               } else if (pathcount(mpp, PATH_PENDING) =3D=3D 0)
> > > +               } else if (pathcount(mpp, PATH_PENDING) =3D=3D 0) {
> > > +                       /*
> > > +                        * If in_recovery is set, enter_recovery_mode=
 does
> > > +                        * nothing. If the device is already in recov=
ery
> > > +                        * mode and has already timed out, manually c=
all
> > > +                        * dm_queue_if_no_path to stop it from queuei=
ng.
> > > +                        */
> > > +                       if ((!mpp->features || is_queueing) &&
> > > +                           mpp->in_recovery && mpp->retry_tick =3D=
=3D 0)
> > > +                               dm_queue_if_no_path(mpp->alias, 0);
> > >                         enter_recovery_mode(mpp);
> > > +               }
> > >                 break;
> > >         }
> > >  }
> > > --
> > > 2.41.0
> > >
> > >
>
