Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5C59443
	for <dm-devel@lists.linux.dev>; Fri, 19 Sep 2025 01:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758244836; cv=none; b=gsbwygMDPM7yumQ6ik4AHpc1ZeI2q2cFZex91vA1jkG6uXGR3rH5JqIiEDjHH7T0VnxKwH0AcYD6yBOOEigYcgHx4yVnb9A/ytaSalevcvJzJYLS94RapmUTVht1EEI2rtv6pnNmMtavZJ+Z/1/puHW8hQAryENo5xAtCQgQIPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758244836; c=relaxed/simple;
	bh=t/GFPp/NyRSWgLBajZcRfgakT1RKaHtGJSNx5Fr7Qm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FMyL5GSv53RLyVsS4qEVbtl4Qrau1mSNRsyf23RDzKDeg6bmYPAuy0RtZWVjtvF4/HOcP0yJCr+HBEfofwR9ttqYlKnZEDp7T78xiR3HAk5HrYdFVBpjL7FcqXTUdPF3yhZiGSKWDFEujqkYrj+nKM0uCeGkR5XwAuOH7AHMBbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWQ0wihv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWQ0wihv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758244831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLCxZIZSaolOd8gbpcXQmKMRqvsgkZXUNyHRQduproI=;
	b=eWQ0wihvFkgfaxVtSdKF3maqF+dcOidN8WviJwt/nB4TZiHIR8dM32BmElX/fEz/4a3dCh
	55WTXoBDFZ3gpP9ZeAG9avXEaVE5MG3WUPTubXmtmIlvy8B5fKJLjXecdnK53tNSwtl25u
	W+ewrGplCG/+ZimoF3JDJeF9XnVVwcw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-JUarusieOamcdby_X9lqFg-1; Thu, 18 Sep 2025 21:20:30 -0400
X-MC-Unique: JUarusieOamcdby_X9lqFg-1
X-Mimecast-MFC-AGG-ID: JUarusieOamcdby_X9lqFg_1758244829
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-57a01f7f623so174101e87.2
        for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 18:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758244828; x=1758849628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kLCxZIZSaolOd8gbpcXQmKMRqvsgkZXUNyHRQduproI=;
        b=SsAUKr/nZ5zICIsXVcz5+P30eOSs/MrE8ZvU24UvVMHGuCWZCGPodwN8rnuUevk48f
         S6Zpztn527FDjcSV120+WcHd2vCb6bjNvIiDzYxugUnsRNCPl6t6QVlVJLoWxTFQTlW+
         Gn1CRBFQ4fGrodTXmaY7ZrR7Fex5T0K4wRkP17P+mA7f5/FoibV0lt0xB2u/hfCs+8bQ
         /ikEwkkkF/JTUNJzLzgUOJZALMW94aMdETsg9ZEdKYcV6ek3g2e6AStvGtkw9qLgkptz
         jm22Lh9C56Ov1dQS5eQnL9DKnipYIA86ConDTeNhcXGfJhUo/pMaLoDSzntl8wmYZTKR
         DBfQ==
X-Gm-Message-State: AOJu0YxPibpNGVGrFN7H5qcTt9iVNWqWKeTkFYZ92zfBouU6YoK2jyB7
	Gweqb5dNt87SI2OLMvS50zj1JrKyVgRkFhxZ4wklMmLjLbBttzgFGD3t85WFkddWmERFSRAjlaD
	JRNWJKlthkzzI6jSN7fPSb9QDlSA1QfyTQOL1IdLhPdmjKPEOD/J8hgpsXCd/2GV7cD1y3RGrgP
	uy6ZkWS4tOhxwHnJSRmNC8jnApkETBs24ecrY=
X-Gm-Gg: ASbGncv9V30DD2vt81mAyrJj9RvyhX1rRhdgh/jXz/wUCOC0ZpiUhw/emCUFopOok/I
	oU02dhnirgyA/XWHKBUktGQJZsvPY+D4+q2jqkstP9SCmu4aDet+1IMXlEt3mUTThV/bdT846Gp
	+4ycuWapuirgaKdLX0yyCgNg==
X-Received: by 2002:a05:6512:6d2:b0:568:e790:ae29 with SMTP id 2adb3069b0e04-579e432d92dmr493887e87.47.1758244828513;
        Thu, 18 Sep 2025 18:20:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5I7jWlwJ95IKiZsESoRjHfZ42gmfZl7D2EOz/5qIDJFCu2lLJDK6zOvVWsfdOr57KytuWQR3fxLXV+PzbiYc=
X-Received: by 2002:a05:6512:6d2:b0:568:e790:ae29 with SMTP id
 2adb3069b0e04-579e432d92dmr493874e87.47.1758244828030; Thu, 18 Sep 2025
 18:20:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1758201368.git.heinzm@redhat.com> <e14e3358a3b0acc015c01c61e6471e622a2dbe8f.1758201368.git.heinzm@redhat.com>
In-Reply-To: <e14e3358a3b0acc015c01c61e6471e622a2dbe8f.1758201368.git.heinzm@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 19 Sep 2025 09:20:16 +0800
X-Gm-Features: AS18NWDQ1xMREGJa1zEdc1PAnRPOFm8s8HhtE6b1_tnZOrjehlzIfcXguJD7N7Y
Message-ID: <CALTww2_B88au2WmDFm6-EpkZSUUz9DkQ64=ak6j-Nif+y6kT6w@mail.gmail.com>
Subject: Re: [PATCH] dm raid: use proper md_ro_state enumerators
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eP71dJ4-2ImXkhJMme1Atqt9WYGUsCGnBbIS2BjhPRU_1758244829
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Heinz

On Thu, Sep 18, 2025 at 9:55=E2=80=AFPM Heinz Mauelshagen <heinzm@redhat.co=
m> wrote:
>
> The dm-raid code was using hardcoded integer values to represent the read=
-only/read-write state
> of RAID arrays instead of the proper enumeration constants defined in the=
 md_ro_state enumerator type.
>
> Changes:
>
> - Replace hardcoded integers with the appropriate md_ro_state enumerator =
values
>
> - Add the missing MD_RDONLY setting in the post_suspend function

It should be the most important change in this patch. Mind adding the
reproducer in the commit message? And explain why you say missing it?

Best Regards
Xiao
>
> This improves code clarity and maintainability by using the defined enume=
ration constants
> rather than magic numbers, ensuring the code properly conforms to the est=
ablished API interface.
>
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>  drivers/md/dm-raid.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 79ea85d18e24..6cdfd7ca998c 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3247,7 +3247,7 @@ static int raid_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)
>         rs_reset_inconclusive_reshape(rs);
>
>         /* Start raid set read-only and assumed clean to change in raid_r=
esume() */
> -       rs->md.ro =3D 1;
> +       rs->md.ro =3D MD_RDONLY;
>         rs->md.in_sync =3D 1;
>
>         /* Has to be held on running the array */
> @@ -3385,7 +3385,7 @@ static enum sync_state decipher_sync_action(struct =
mddev *mddev, unsigned long r
>         /* The MD sync thread can be done with io or be interrupted but s=
till be running */
>         if (!test_bit(MD_RECOVERY_DONE, &recovery) &&
>             (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
> -            (!mddev->ro && test_bit(MD_RECOVERY_NEEDED, &recovery)))) {
> +            (md_is_rdwr(mddev) && test_bit(MD_RECOVERY_NEEDED, &recovery=
)))) {
>                 if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
>                         return st_reshape;
>
> @@ -3775,11 +3775,11 @@ static int raid_message(struct dm_target *ti, uns=
igned int argc, char **argv,
>                 } else
>                         return -EINVAL;
>         }
> -       if (mddev->ro =3D=3D 2) {
> +       if (mddev->ro =3D=3D MD_AUTO_READ) {
>                 /* A write to sync_action is enough to justify
>                  * canceling read-auto mode
>                  */
> -               mddev->ro =3D 0;
> +               mddev->ro =3D MD_RDWR;
>                 if (!mddev->suspended)
>                         md_wakeup_thread(mddev->sync_thread);
>         }
> @@ -3858,6 +3858,7 @@ static void raid_postsuspend(struct dm_target *ti)
>                  */
>                 md_stop_writes(&rs->md);
>                 mddev_suspend(&rs->md, false);
> +               rs->md.ro =3D MD_RDONLY;
>         }
>  }
>
> @@ -3968,7 +3969,7 @@ static void rs_update_sbs(struct raid_set *rs)
>         int ro =3D mddev->ro;
>
>         set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -       mddev->ro =3D 0;
> +       mddev->ro =3D MD_RDWR;
>         md_update_sb(mddev, 1);
>         mddev->ro =3D ro;
>  }
> @@ -4125,7 +4126,7 @@ static void raid_resume(struct dm_target *ti)
>                 WARN_ON_ONCE(rcu_dereference_protected(mddev->sync_thread=
,
>                                                        lockdep_is_held(&m=
ddev->reconfig_mutex)));
>                 clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
> -               mddev->ro =3D 0;
> +               mddev->ro =3D MD_RDWR;
>                 mddev->in_sync =3D 0;
>                 md_unfrozen_sync_thread(mddev);
>                 mddev_unlock_and_resume(mddev);
> --
> 2.51.0
>
>

