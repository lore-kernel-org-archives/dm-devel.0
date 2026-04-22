Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933523CB2D2
	for <dm-devel@lists.linux.dev>; Wed, 22 Apr 2026 09:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776851911; cv=none; b=erjnSkPxv1crM9zp02ndhHgLhjiz48H1lE4kMfy8Pin+yV8WB0yOA+VMrKeLMB4PQ5WKKVj3Akx937UWiYzcmWjeBbctHvKH9WLrB2K3HexyI1LKC9G4hOVX8DaHvZ5Ms8A+ZaVySGTeMwZEQP8kos6pDSMtdqTjOG6gqmrhj0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776851911; c=relaxed/simple;
	bh=EC11Y3vyMmB/Q/cm7lJbxm1JG8YBrXNT034yIEeyXt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OIjkVN2RYaJCUr+r7reySaAinj1ti+ZQG44SHd/RQ7MvfRglTNgf6BqYIiSE4xUvDU7xVQ6YvGF/0EcAHj7FfgQ+jfZROhNJkqI9xAJOsxJA5+aVRoixaePagSIVQcdVKUTBCrMKR168TjL8c1K7cNLIwe2PF4fTkD8uNg/vgcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gwyrpcya; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwyrpcya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776851908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmwNlum+GScoMSRK+6uvuC4//taXSJ0HkuWKsvWIqig=;
	b=gwyrpcyaQyauLCw7+6N0CJTYC7y30SerR3JMb3DAyzk6PukF0nHqdZzJsMrLQC26tn0/Ed
	jtxKRd8279WSHh97GVo+qZgO5bv1VK23PL3UGe9TqZxphA3yct3fOxnECNJskUB/XqcRGT
	BDbxTlJ1eophveA+Yap9HDfI+RhVT64=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-NrxamCkEN2-nIzrYJSe7Ow-1; Wed, 22 Apr 2026 05:58:27 -0400
X-MC-Unique: NrxamCkEN2-nIzrYJSe7Ow-1
X-Mimecast-MFC-AGG-ID: NrxamCkEN2-nIzrYJSe7Ow_1776851906
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38e817d9498so24341171fa.2
        for <dm-devel@lists.linux.dev>; Wed, 22 Apr 2026 02:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776851906; x=1777456706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tmwNlum+GScoMSRK+6uvuC4//taXSJ0HkuWKsvWIqig=;
        b=cSQ1PUsDPC8fsupE65a5dlTVXbml1lIHrmpP5UjrNB+AcGhZlo90Y/9REmUFkrk+hV
         bR2aWEB90Lup/nC6zD5tJ1/XtdrXBAxSd37VG/ydhnBFQutscsOqzrv75mmy008/Zn/z
         Yk6a/WW1DfyM8r1qn7C8k2siMVR0AcByS4Q1i2H0fgtjrW2ene1VI5RiTzDighHf+Uge
         CbWb65cPKmURdrpu43C+pUFiArdfu/WV2i6gZMyd1uGftZgdWV35JFSG8aTWHdJI+asg
         AnYCYLuOIJqniJLNFCzICcpaGwbsyxft/t5jEUMVKUI32FQAgxVaWqar6LtZus4IX4iJ
         pRuA==
X-Forwarded-Encrypted: i=1; AFNElJ8E4r5FOaVz2YYb05NdunhSnyhcxZpwEkRnbGmOqKFqtTSmFjAo2EmZcuY4VAqHxRiq73lohmjvig==@lists.linux.dev
X-Gm-Message-State: AOJu0YxzLH6VCUmPUA97JxdfFtqVIesOkFFl6iMHahO86UCER3aDXPMF
	6iqQ4U/Q3k7kpeyY0h/1mGIsa+Ak1amMY9cg+cDmVrCApaFgU0PEMOSIySe9mhudbOGCx6lE7rm
	gV+UJvtrOotyBONYsn+FsSosqaASBCnqXwVVKpz6klIAuFbaDySWupine/4MqJulDdJjrMsPFAY
	IEFW8GzvicL+5yLyonw9UckCnrS8xKhxf1XEc=
X-Gm-Gg: AeBDiescKIMyWq5RzuvjwOf1XA9h+6vFnzNMhrrNuGhaMbOFSjD8a3y2GaEO9I51bRC
	riqbpExTwqlfTX9ZAS5cqlYqkI1zy888nwhmBWCiXrAZXrVBbtfdTjuE7QMuhAYSwOIcpD3fA+F
	0S9cpyfPtTNjQvRqR4JEqEiEcV2tUpl1ij/e6YUOh+AlwDejvJo3ro/I6tw0i7XNesK2vIAoIWv
	9VUufbNAWo+H+H3s17hPF/3JhWCeikHytYH0/qEjtTsx8WBrEa41Ed+SU7rGf4T0QE2n54A/CVW
	N0T3NASTRk4v
X-Received: by 2002:a05:6512:12c4:b0:5a4:1687:a32 with SMTP id 2adb3069b0e04-5a4172e47damr7674248e87.33.1776851905470;
        Wed, 22 Apr 2026 02:58:25 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:b0:5a4:1687:a32 with SMTP id
 2adb3069b0e04-5a4172e47damr7674230e87.33.1776851904853; Wed, 22 Apr 2026
 02:58:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ad6FNUtSCS_zTrHW@redhat.com> <20260414190350.1946406-1-bmarzins@redhat.com>
In-Reply-To: <20260414190350.1946406-1-bmarzins@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 22 Apr 2026 17:58:11 +0800
X-Gm-Features: AQROBzBrq25lZuxIRU48QL5iysCPWwrt42l70tafWZ7uVSy37zefF7nWrPHUtu8
Message-ID: <CALTww295wXriSs0zWwS4bsYfQiJ0-xKLFYmqO5P2eLBxUe+yGg@mail.gmail.com>
Subject: Re: [RFC PATCH] dm-raid: only requeue bios when dm is suspending.
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yang Xiuwei <yangxiuwei@kylinos.cn>, 
	Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6c1AVztjQQLSS51sOTnivFJYjftwgx1mNqmtL0njzrk_1776851906
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 3:03=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> returning DM_MAPIO_REQUEUE from the target map() function only requeues
> the bio during noflush suspends. During regular operations or during
> flushing suspends, it fails the bio. Failing the bio during flushing
> suspends is the correct behavior here. We cannot handle the bio, and we
> cannot suspends while it is outstanding. But during normal operations,
> we should not push the bio back to do. Instead, wait for the reshape
> to be resumed.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>
> Yang Xiuwei, if you are still able to see I/O errors during LVM testing,
> does this patch fix them?
>
>  drivers/md/dm-raid.c | 7 +++++++
>  drivers/md/md.h      | 1 +
>  drivers/md/raid5.c   | 6 ++++--
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 4bacdc499984..cac61d57e7e2 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3831,6 +3831,7 @@ static void raid_presuspend(struct dm_target *ti)
>          * resume, raid_postsuspend() is too late.
>          */
>         set_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
> +       WRITE_ONCE(mddev->dm_suspending, 1);
>
>         if (!reshape_interrupted(mddev))
>                 return;
> @@ -3847,6 +3848,9 @@ static void raid_presuspend(struct dm_target *ti)
>  static void raid_presuspend_undo(struct dm_target *ti)
>  {
>         struct raid_set *rs =3D ti->private;
> +       struct mddev *mddev =3D &rs->md;
> +
> +       WRITE_ONCE(mddev->dm_suspending, 0);
>
>         clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
>  }
> @@ -3854,6 +3858,7 @@ static void raid_presuspend_undo(struct dm_target *=
ti)
>  static void raid_postsuspend(struct dm_target *ti)
>  {
>         struct raid_set *rs =3D ti->private;
> +       struct mddev *mddev =3D &rs->md;
>
>         if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) =
{
>                 /*
> @@ -3864,6 +3869,8 @@ static void raid_postsuspend(struct dm_target *ti)
>                 mddev_suspend(&rs->md, false);
>                 rs->md.ro =3D MD_RDONLY;
>         }
> +       WRITE_ONCE(mddev->dm_suspending, 0);
> +
>  }
>
>  static void attempt_restore_of_faulty_devices(struct raid_set *rs)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..e8d7332c5cb9 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -463,6 +463,7 @@ struct mddev {
>         int                             delta_disks, new_level, new_layou=
t;
>         int                             new_chunk_sectors;
>         int                             reshape_backwards;
> +       int                             dm_suspending;
>
>         struct md_thread __rcu          *thread;        /* management thr=
ead */
>         struct md_thread __rcu          *sync_thread;   /* doing resync o=
r reconstruct */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8854e024f311..d528263f92a3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6042,8 +6042,10 @@ static enum stripe_result make_stripe_request(stru=
ct mddev *mddev,
>         raid5_release_stripe(sh);
>  out:
>         if (ret =3D=3D STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(m=
ddev)) {
> -               bi->bi_status =3D BLK_STS_RESOURCE;
> -               ret =3D STRIPE_WAIT_RESHAPE;
> +               if (!mddev_is_dm(mddev) || READ_ONCE(mddev->dm_suspending=
)) {
> +                       bi->bi_status =3D BLK_STS_RESOURCE;
> +                       ret =3D STRIPE_WAIT_RESHAPE;
> +               }
>                 pr_err_ratelimited("dm-raid456: io across reshape positio=
n while reshape can't make progress");
>         }
>         return ret;
> --
> 2.50.1
>

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

