Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F26386
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 06:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715669136; cv=none; b=kNxaT/eHfuaY0QG6DAsVQz1fEsZzJeuzHQkI2tSP2+bDsqlvQpVXkSCOiOzq8Adz/PRCqvF/ecduTYHlhHHIngIat7Fo6kaTcgNz1b+vzQj9kATTa2gQFXDxWatpZlkKYv/gBGcYMotXK0yNm6geuJbk5Ga1R4CmN9VsyU+4dsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715669136; c=relaxed/simple;
	bh=LWQ6jexXuSZi5ZpaP1mUHm4kpvFrGFOwvM8Vegc8zdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pKa7BXWiMM2QiNBgpBnLF/VQiSRM5F7Prtmngt/p8IniRx8UG8cuoZZpVEqFU6NLAh4J9VE3uuftWBeM2/p1NiEqJ+Oj6WyG7nZ+oeKLaxCc/NhWA1+ZuKKwSyq7uJLe/oSFy3AEJ99x4Nn0oUulc5gUa8oo2URdy+T+v5Sv+v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IJ4bZ8A9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJ4bZ8A9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715669133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4hSY1d8jq6XzfstUOW1N/hjQcvfLd42t04S3x4l0Nw=;
	b=IJ4bZ8A9KHBAaXmFpixEG93WKsLpIjUnG0IEIWZjrQBmasRWlhmAfpOPzUKs+GDMJ6VMri
	d85AIC3pLMaV56dOq6VOMv4HajimSygdqBFQpCagr7fNO62XEmG37EwKQtbk3p9SziRA3T
	+1wmwDFEelYiNcbKnNq5j2wF+tTjYVM=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-8kOOm4gLPTK2EZEQN0qNtA-1; Tue, 14 May 2024 02:39:28 -0400
X-MC-Unique: 8kOOm4gLPTK2EZEQN0qNtA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5c6245bc7caso4224995a12.3
        for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 23:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715668767; x=1716273567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y4hSY1d8jq6XzfstUOW1N/hjQcvfLd42t04S3x4l0Nw=;
        b=FRYiBYWCLjAZrApTgMUWCOOL/Cc0waYGgwNmYQQ6ZyvXA2wVvMLBielshUK6/9AODN
         MVDJZVaODn9es/euR3wW0UgIAeGutAyD+lHoHxd3PX4imANZ4DKdrZpqfgWeYUd5VTAo
         oNxEDyYS/GVuf+oyONbzF2vljSnjXG50jd3RNXhMZ2cMhlPHEs0DaTo9G6yuPR/O392P
         w1s8gyBX/34w8/LMtxRXjkTN7Ne5zASNJMBZBnfLWiNgN26XiCMeaHDplKMEVgdihuLQ
         m6TMoX/HLET71yLWZ8aWFSA6uPZA9UB/f7vKwO9XrSOJaOiXQ2lo74N0Psip59oRQ+Pd
         wYPw==
X-Forwarded-Encrypted: i=1; AJvYcCUHqQDqCq+R46eX/j6F73Mb6eqW6fdD7mvONjWge0P6CLXdNsBBOC46J8y3Ma+1xwtlGswTusUBdYQd4ksUuwXdC/L3VjGqAFg=
X-Gm-Message-State: AOJu0YwdmtaX0j6TJ4J9GyLPbDNDIEz4rzuZWlpX2up0t2545WLX3uJu
	Ad1PMcuHAU+se79tsQ4gC4L+p7+V0DMRmLNaEz0ErBnTBsZi8UFKRupXVp24PblFQQNwrCmfLRJ
	CgtjrRw9hMCXhs1ZMvtaqKm21L3dPd8MPVgF4tJuh6lxsTpTiLef3f6AE+LN8Bhv9mgr6x3MexB
	7UY24K3VdQu47I4deKWCzQFvAi47u44/U=
X-Received: by 2002:a05:6a20:96cd:b0:1af:dae8:5eaf with SMTP id adf61e73a8af0-1afde1c5d90mr10068826637.56.1715668767292;
        Mon, 13 May 2024 23:39:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwOuzczaLAqIDR6EoehK9X+UPcltl2JP7zchAX15z0LD6Fbfw4vUmDQODVydh83/kwC9nwsiF6RLX00/wiP5g=
X-Received: by 2002:a05:6a20:96cd:b0:1af:dae8:5eaf with SMTP id
 adf61e73a8af0-1afde1c5d90mr10068813637.56.1715668766937; Mon, 13 May 2024
 23:39:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-2-yukuai1@huaweicloud.com> <CALTww2_2UG49wxNZv1Ay7u9X-2SoV31ca-=2K8uWHH9nRT2Apw@mail.gmail.com>
 <e71bec08-036b-9dc1-ca12-a187b2aff528@huaweicloud.com>
In-Reply-To: <e71bec08-036b-9dc1-ca12-a187b2aff528@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 14 May 2024 14:39:15 +0800
Message-ID: <CALTww2-z_YXTfgxxuTH1Qb_dp46sORiG=iD4S=Lh7_RZYqd8yA@mail.gmail.com>
Subject: Re: [PATCH md-6.10 1/9] md: rearrange recovery_flage
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 2:16=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/05/14 13:51, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, May 13, 2024 at 9:57=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> Currently there are lots of flags and the names are confusing, since
> >> there are two main types of flags, sync thread runnng status and sync
> >> thread action, rearrange and update comment to improve code readabilit=
y,
> >> there are no functional changes.
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-----------=
--
> >>   1 file changed, 38 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >> index 029dd0491a36..2a1cb7b889e5 100644
> >> --- a/drivers/md/md.h
> >> +++ b/drivers/md/md.h
> >> @@ -551,22 +551,46 @@ struct mddev {
> >>   };
> >>
> >>   enum recovery_flags {
> >> +       /* flags for sync thread running status */
> >> +
> >> +       /*
> >> +        * set when one of sync action is set and new sync thread need=
 to be
> >> +        * registered, or just add/remove spares from conf.
> >> +        */
> >> +       MD_RECOVERY_NEEDED,
> >> +       /* sync thread is running, or about to be started */
> >> +       MD_RECOVERY_RUNNING,
> >> +       /* sync thread needs to be aborted for some reason */
> >> +       MD_RECOVERY_INTR,
> >> +       /* sync thread is done and is waiting to be unregistered */
> >> +       MD_RECOVERY_DONE,
> >> +       /* running sync thread must abort immediately, and not restart=
 */
> >> +       MD_RECOVERY_FROZEN,
> >> +       /* waiting for pers->start() to finish */
> >> +       MD_RECOVERY_WAIT,
> >> +       /* interrupted because io-error */
> >> +       MD_RECOVERY_ERROR,
> >> +
> >> +       /* flags determines sync action */
> >> +
> >> +       /* if just this flag is set, action is resync. */
> >> +       MD_RECOVERY_SYNC,
> >> +       /*
> >> +        * paired with MD_RECOVERY_SYNC, if MD_RECOVERY_CHECK is not s=
et,
> >> +        * action is repair, means user requested resync.
> >> +        */
> >> +       MD_RECOVERY_REQUESTED,
> >>          /*
> >> -        * If neither SYNC or RESHAPE are set, then it is a recovery.
> >> +        * paired with MD_RECOVERY_SYNC and MD_RECOVERY_REQUESTED, act=
ion is
> >> +        * check.
> >
> > Hi Kuai
> >
> > I did a test as follows:
> >
> > echo check > /sys/block/md0/md/sync_action
> > I added some logs in md_do_sync to check these bits. It only prints
> > MD_RECOVERY_SYNC and MD_RECOVERY_CHECK without MD_RECOVERY_SYNC. So
> > the comment is not right?
>
> There is a typo, I'm not sure what you mean yet. Can you show how you
> add your logs? I think comment is right.

Sorry. I added logs in the wrong places. You're right. Data check has
the three bits. So, the comments are right.


>
>  From action_store:
>
>                  if (cmd_match(page, "check"))
>                          set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>                  else if (!cmd_match(page, "repair"))
>                          return -EINVAL;
>                  clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>                  set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>                  set_bit(MD_RECOVERY_SYNC, &mddev->recovery);

Yes.

Best Regards
Xiao

>
>  From md_do_sync:
>
>          if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
>                  if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
>                          desc =3D "data-check";
>                          action =3D "check";
>                  } else if (test_bit(MD_RECOVERY_REQUESTED,
> &mddev->recovery)) {
>                          desc =3D "requested-resync";
>                          action =3D "repair";
>                  } else
>                          desc =3D "resync";
>
> Thanks,
> Kuai
>
> >
> > Best Regards
> > Xiao
> >
> >>           */
> >> -       MD_RECOVERY_RUNNING,    /* a thread is running, or about to be=
 started */
> >> -       MD_RECOVERY_SYNC,       /* actually doing a resync, not a reco=
very */
> >> -       MD_RECOVERY_RECOVER,    /* doing recovery, or need to try it. =
*/
> >> -       MD_RECOVERY_INTR,       /* resync needs to be aborted for some=
 reason */
> >> -       MD_RECOVERY_DONE,       /* thread is done and is waiting to be=
 reaped */
> >> -       MD_RECOVERY_NEEDED,     /* we might need to start a resync/rec=
over */
> >> -       MD_RECOVERY_REQUESTED,  /* user-space has requested a sync (us=
ed with SYNC) */
> >> -       MD_RECOVERY_CHECK,      /* user-space request for check-only, =
no repair */
> >> -       MD_RECOVERY_RESHAPE,    /* A reshape is happening */
> >> -       MD_RECOVERY_FROZEN,     /* User request to abort, and not rest=
art, any action */
> >> -       MD_RECOVERY_ERROR,      /* sync-action interrupted because io-=
error */
> >> -       MD_RECOVERY_WAIT,       /* waiting for pers->start() to finish=
 */
> >> -       MD_RESYNCING_REMOTE,    /* remote node is running resync threa=
d */
> >> +       MD_RECOVERY_CHECK,
> >> +       /* recovery, or need to try it */
> >> +       MD_RECOVERY_RECOVER,
> >> +       /* reshape */
> >> +       MD_RECOVERY_RESHAPE,
> >> +       /* remote node is running resync thread */
> >> +       MD_RESYNCING_REMOTE,
> >>   };
> >>
> >>   enum md_ro_state {
> >> --
> >> 2.39.2
> >>
> >
> >
> > .
> >
>
>

