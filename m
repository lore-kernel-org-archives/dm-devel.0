Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1CE21C9E7
	for <dm-devel@lists.linux.dev>; Thu, 14 Aug 2025 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755184766; cv=none; b=jAyh1oMKQJbfSfXbnsWWITpeH+7fSUH9RinJj8UiYSsyZWQN/9t3AG5veWkuG38HNrlsq4B5dAkQ+bDdbzwd5QzdhJRKwwwbLHB1FauBhfSEQ5sYxQd2LNe33Tu0hj6kvkEMJwqTm4MEcEdaiCwbro2fb/e7ODeH9Otn1SMS9OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755184766; c=relaxed/simple;
	bh=A4L5LKSAhRLDGyZYEay6l3Fn1TSA3Qi0RL9K5k8w9HU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OBNjDc3uRqrd6FRkPJ3XJJ1ChV9QrbcP1k8pLhThPB+P93XTAc0j2H/6RSFXSZpGZD7WD0F0J3HC+Zd2hjKYVxRNvd4ROADDc9YlXF4KIb9U0pYeT5uMt/lw8/BIioETSjU17K+mxgMHXxpoXHAIbOtOheIK2Y6/hnhObYyzLqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dlL3WPdG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dlL3WPdG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755184762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASxjRZzkrnKyteo9ARLnfMBcQhIG0eiE8ICwIx4pb8A=;
	b=dlL3WPdGSOugJ4pamwxQN4FMAG0jGub/Psy066v6k3vyxtDZsRf6RmHM0kV3ABHa4bAiMl
	qGsNwlX4G2jt1cq9sMuJguKZf2qePsiv/9ATHMEDDTz2N95a0QqbvwDeoPMjcDkghQvkNm
	JkJ4J0jd/ZCVjLPphie52GsUTK17EKs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-gEEAg7PNO6GpjRc1cKt8bA-1; Thu, 14 Aug 2025 11:19:20 -0400
X-MC-Unique: gEEAg7PNO6GpjRc1cKt8bA-1
X-Mimecast-MFC-AGG-ID: gEEAg7PNO6GpjRc1cKt8bA_1755184759
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55ce520e01eso743601e87.1
        for <dm-devel@lists.linux.dev>; Thu, 14 Aug 2025 08:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755184759; x=1755789559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASxjRZzkrnKyteo9ARLnfMBcQhIG0eiE8ICwIx4pb8A=;
        b=uYp/JmJHw4cMbnrWUoIbY1eBBo1tAv7Ql1IxH39Txwi42NBm8C7G1jqNpa7A4tprrj
         OS091OsuQK2P7Lyz785mptHTCFTlRxXrM+UomVo8HYoFNVVHyor9ATc5/Bw7mgN6+jSY
         scei1oI7T+iCDYNPxOKJFTmgb3lmM38crKuzYQjMXXZLC5NxQ9d+uXnVmKfV/g3HnWQV
         54kbEHZwGjkKsBlts+n79M7AucgNOr+57pwfFiaXeKIIVkaRASgJaZxHRanArJ2WhsgW
         HHNDlZD5FXwk/Acfz6sxEjhKY0dPMjZdKoU0SDvxRrLOGjb+uY4l7nypx7mhLw05vdoC
         1W0g==
X-Forwarded-Encrypted: i=1; AJvYcCVZpaW1vtRzYvh9ZL1WannPUyWEWJzb1SKIp4/BjvN4Z8lo7qKYCF4U58JmhYq9vz0KjCpO+EFfCg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxpnof0yha62B1RYU9JCmFBnLHRfrqfJYxhyOFvPcU1mTXBELLL
	tM6rEreAlmloqoUKWGr4fJC9BRC5QVytXPl0CgeVd3rmuJK+7mXYvW8yE/+w8aF4tAGHLYJVhTn
	7+U4JKrtAwWwMQiEchKDHz9hjvbmO/Jhol/a/SzgQ7Td55ZScpMajHSJLPO4ayyEJMDu8pvrCp+
	Fv58/PDcDuhvSubzmk9XyrWwf2CdYpPoPfTPU=
X-Gm-Gg: ASbGnctg4Yko3ZStypQuau/320pJISYYjKNRMv3lcBVb7PwoPUKqmTrX3EWs/l2GVdS
	knaILjcSruYsnDgnzEDXbo0cAAgldTNpIIYmGAc0dDbhGY3CO37AfrldVxTJ4HeIIkWVlHDR7Lb
	kU3jAxPEP+3N471mNBZCZfuw==
X-Received: by 2002:a05:6512:4406:b0:55b:8aa7:4c1e with SMTP id 2adb3069b0e04-55ce5057ce6mr1034911e87.53.1755184758557;
        Thu, 14 Aug 2025 08:19:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpjD4L9yGnt3Y8LK/vUqs2N4V9CeLkdpHNoORm8lSuTg5A3krqAMSN8n2lZEw8OB9cKOiq9iDoektuq47f0Ik=
X-Received: by 2002:a05:6512:4406:b0:55b:8aa7:4c1e with SMTP id
 2adb3069b0e04-55ce5057ce6mr1034897e87.53.1755184757723; Thu, 14 Aug 2025
 08:19:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722033340.1933388-1-linan666@huaweicloud.com>
In-Reply-To: <20250722033340.1933388-1-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 14 Aug 2025 23:19:05 +0800
X-Gm-Features: Ac12FXxiaI3onummDzWYpebymRi5yru3Q173Px_b3hfNsvGPcbJdxkMAfyRURRE
Message-ID: <CALTww2-kHxa5FsPWXURwvv0q_kps875Bmecs6OjtO0AdY_V8Fg@mail.gmail.com>
Subject: Re: [PATCH v2 md-6.17] md: rename recovery_cp to resync_offset
To: linan666@huaweicloud.com
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai3@huawei.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: baM5DZkiFI5uSSSMxSz1R1cctzV-Bi4F1cEN12DiFak_1755184759
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

mdadm build fails because of this change.

super0.c: In function =E2=80=98update_super0=E2=80=99:
super0.c:672:19: error: =E2=80=98mdp_super_t=E2=80=99 {aka =E2=80=98struct =
mdp_superblock_s=E2=80=99}
has no member named =E2=80=98recovery_cp=E2=80=99
  672 |                 sb->recovery_cp =3D 0;
      |                   ^~

Because we recently handled a similar thing that the kernel change
breaks userspace. It looks like it needs to modify mdadm too. But if
users don't update mdadm, it can't build successfully. What's your
suggestion? Now fedora can't update because of this failure.
https://kojipkgs.fedoraproject.org//work/tasks/9192/136039192/build.log

Regards
Xiao

On Tue, Jul 22, 2025 at 11:40=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> 'recovery_cp' was used to represent the progress of sync, but its name
> contains recovery, which can cause confusion. Replaces 'recovery_cp'
> with 'resync_offset' for clarity.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
> v2: cook on md-6.17
>
>  drivers/md/md.h                |  2 +-
>  include/uapi/linux/raid/md_p.h |  2 +-
>  drivers/md/dm-raid.c           | 42 ++++++++++++++--------------
>  drivers/md/md-bitmap.c         |  8 +++---
>  drivers/md/md-cluster.c        | 16 +++++------
>  drivers/md/md.c                | 50 +++++++++++++++++-----------------
>  drivers/md/raid0.c             |  6 ++--
>  drivers/md/raid1-10.c          |  2 +-
>  drivers/md/raid1.c             | 10 +++----
>  drivers/md/raid10.c            | 16 +++++------
>  drivers/md/raid5-ppl.c         |  6 ++--
>  drivers/md/raid5.c             | 30 ++++++++++----------
>  12 files changed, 95 insertions(+), 95 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b8ff70841fbe..edea7df579c8 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -524,7 +524,7 @@ struct mddev {
>         unsigned long                   normal_io_events; /* IO event tim=
estamp */
>         atomic_t                        recovery_active; /* blocks schedu=
led, but not written */
>         wait_queue_head_t               recovery_wait;
> -       sector_t                        recovery_cp;
> +       sector_t                        resync_offset;
>         sector_t                        resync_min;     /* user requested=
 sync
>                                                          * starts here */
>         sector_t                        resync_max;     /* resync should =
pause
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_=
p.h
> index ad1c84e772ba..2963c3dab57e 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -173,7 +173,7 @@ typedef struct mdp_superblock_s {
>  #else
>  #error unspecified endianness
>  #endif
> -       __u32 recovery_cp;      /* 11 recovery checkpoint sector count   =
     */
> +       __u32 resync_offset;    /* 11 resync checkpoint sector count     =
     */
>         /* There are only valid for minor_version > 90 */
>         __u64 reshape_position; /* 12,13 next address in array-space for =
reshape */
>         __u32 new_level;        /* 14 new level we are reshaping to      =
     */
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index e8c0a8c6fb51..9835f2fe26e9 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -439,7 +439,7 @@ static bool rs_is_reshapable(struct raid_set *rs)
>  /* Return true, if raid set in @rs is recovering */
>  static bool rs_is_recovering(struct raid_set *rs)
>  {
> -       return rs->md.recovery_cp < rs->md.dev_sectors;
> +       return rs->md.resync_offset < rs->md.dev_sectors;
>  }
>
>  /* Return true, if raid set in @rs is reshaping */
> @@ -769,7 +769,7 @@ static struct raid_set *raid_set_alloc(struct dm_targ=
et *ti, struct raid_type *r
>         rs->md.layout =3D raid_type->algorithm;
>         rs->md.new_layout =3D rs->md.layout;
>         rs->md.delta_disks =3D 0;
> -       rs->md.recovery_cp =3D MaxSector;
> +       rs->md.resync_offset =3D MaxSector;
>
>         for (i =3D 0; i < raid_devs; i++)
>                 md_rdev_init(&rs->dev[i].rdev);
> @@ -913,7 +913,7 @@ static int parse_dev_params(struct raid_set *rs, stru=
ct dm_arg_set *as)
>                 rs->md.external =3D 0;
>                 rs->md.persistent =3D 1;
>                 rs->md.major_version =3D 2;
> -       } else if (rebuild && !rs->md.recovery_cp) {
> +       } else if (rebuild && !rs->md.resync_offset) {
>                 /*
>                  * Without metadata, we will not be able to tell if the a=
rray
>                  * is in-sync or not - we must assume it is not.  Therefo=
re,
> @@ -1696,20 +1696,20 @@ static void rs_setup_recovery(struct raid_set *rs=
, sector_t dev_sectors)
>  {
>         /* raid0 does not recover */
>         if (rs_is_raid0(rs))
> -               rs->md.recovery_cp =3D MaxSector;
> +               rs->md.resync_offset =3D MaxSector;
>         /*
>          * A raid6 set has to be recovered either
>          * completely or for the grown part to
>          * ensure proper parity and Q-Syndrome
>          */
>         else if (rs_is_raid6(rs))
> -               rs->md.recovery_cp =3D dev_sectors;
> +               rs->md.resync_offset =3D dev_sectors;
>         /*
>          * Other raid set types may skip recovery
>          * depending on the 'nosync' flag.
>          */
>         else
> -               rs->md.recovery_cp =3D test_bit(__CTR_FLAG_NOSYNC, &rs->c=
tr_flags)
> +               rs->md.resync_offset =3D test_bit(__CTR_FLAG_NOSYNC, &rs-=
>ctr_flags)
>                                      ? MaxSector : dev_sectors;
>  }
>
> @@ -2144,7 +2144,7 @@ static void super_sync(struct mddev *mddev, struct =
md_rdev *rdev)
>         sb->events =3D cpu_to_le64(mddev->events);
>
>         sb->disk_recovery_offset =3D cpu_to_le64(rdev->recovery_offset);
> -       sb->array_resync_offset =3D cpu_to_le64(mddev->recovery_cp);
> +       sb->array_resync_offset =3D cpu_to_le64(mddev->resync_offset);
>
>         sb->level =3D cpu_to_le32(mddev->level);
>         sb->layout =3D cpu_to_le32(mddev->layout);
> @@ -2335,18 +2335,18 @@ static int super_init_validation(struct raid_set =
*rs, struct md_rdev *rdev)
>         }
>
>         if (!test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags))
> -               mddev->recovery_cp =3D le64_to_cpu(sb->array_resync_offse=
t);
> +               mddev->resync_offset =3D le64_to_cpu(sb->array_resync_off=
set);
>
>         /*
>          * During load, we set FirstUse if a new superblock was written.
>          * There are two reasons we might not have a superblock:
>          * 1) The raid set is brand new - in which case, all of the
>          *    devices must have their In_sync bit set.  Also,
> -        *    recovery_cp must be 0, unless forced.
> +        *    resync_offset must be 0, unless forced.
>          * 2) This is a new device being added to an old raid set
>          *    and the new device needs to be rebuilt - in which
>          *    case the In_sync bit will /not/ be set and
> -        *    recovery_cp must be MaxSector.
> +        *    resync_offset must be MaxSector.
>          * 3) This is/are a new device(s) being added to an old
>          *    raid set during takeover to a higher raid level
>          *    to provide capacity for redundancy or during reshape
> @@ -2391,8 +2391,8 @@ static int super_init_validation(struct raid_set *r=
s, struct md_rdev *rdev)
>                               new_devs > 1 ? "s" : "");
>                         return -EINVAL;
>                 } else if (!test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags) =
&& rs_is_recovering(rs)) {
> -                       DMERR("'rebuild' specified while raid set is not =
in-sync (recovery_cp=3D%llu)",
> -                             (unsigned long long) mddev->recovery_cp);
> +                       DMERR("'rebuild' specified while raid set is not =
in-sync (resync_offset=3D%llu)",
> +                             (unsigned long long) mddev->resync_offset);
>                         return -EINVAL;
>                 } else if (rs_is_reshaping(rs)) {
>                         DMERR("'rebuild' specified while raid set is bein=
g reshaped (reshape_position=3D%llu)",
> @@ -2697,11 +2697,11 @@ static int rs_adjust_data_offsets(struct raid_set=
 *rs)
>         }
>  out:
>         /*
> -        * Raise recovery_cp in case data_offset !=3D 0 to
> +        * Raise resync_offset in case data_offset !=3D 0 to
>          * avoid false recovery positives in the constructor.
>          */
> -       if (rs->md.recovery_cp < rs->md.dev_sectors)
> -               rs->md.recovery_cp +=3D rs->dev[0].rdev.data_offset;
> +       if (rs->md.resync_offset < rs->md.dev_sectors)
> +               rs->md.resync_offset +=3D rs->dev[0].rdev.data_offset;
>
>         /* Adjust data offsets on all rdevs but on any raid4/5/6 journal =
device */
>         rdev_for_each(rdev, &rs->md) {
> @@ -2756,7 +2756,7 @@ static int rs_setup_takeover(struct raid_set *rs)
>         }
>
>         clear_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
> -       mddev->recovery_cp =3D MaxSector;
> +       mddev->resync_offset =3D MaxSector;
>
>         while (d--) {
>                 rdev =3D &rs->dev[d].rdev;
> @@ -2764,7 +2764,7 @@ static int rs_setup_takeover(struct raid_set *rs)
>                 if (test_bit(d, (void *) rs->rebuild_disks)) {
>                         clear_bit(In_sync, &rdev->flags);
>                         clear_bit(Faulty, &rdev->flags);
> -                       mddev->recovery_cp =3D rdev->recovery_offset =3D =
0;
> +                       mddev->resync_offset =3D rdev->recovery_offset =
=3D 0;
>                         /* Bitmap has to be created when we do an "up" ta=
keover */
>                         set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
>                 }
> @@ -3222,7 +3222,7 @@ static int raid_ctr(struct dm_target *ti, unsigned =
int argc, char **argv)
>                         if (r)
>                                 goto bad;
>
> -                       rs_setup_recovery(rs, rs->md.recovery_cp < rs->md=
.dev_sectors ? rs->md.recovery_cp : rs->md.dev_sectors);
> +                       rs_setup_recovery(rs, rs->md.resync_offset < rs->=
md.dev_sectors ? rs->md.resync_offset : rs->md.dev_sectors);
>                 } else {
>                         /* This is no size change or it is shrinking, upd=
ate size and record in superblocks */
>                         r =3D rs_set_dev_and_array_sectors(rs, rs->ti->le=
n, false);
> @@ -3446,7 +3446,7 @@ static sector_t rs_get_progress(struct raid_set *rs=
, unsigned long recovery,
>
>         } else {
>                 if (state =3D=3D st_idle && !test_bit(MD_RECOVERY_INTR, &=
recovery))
> -                       r =3D mddev->recovery_cp;
> +                       r =3D mddev->resync_offset;
>                 else
>                         r =3D mddev->curr_resync_completed;
>
> @@ -4074,9 +4074,9 @@ static int raid_preresume(struct dm_target *ti)
>         }
>
>         /* Check for any resize/reshape on @rs and adjust/initiate */
> -       if (mddev->recovery_cp && mddev->recovery_cp < MaxSector) {
> +       if (mddev->resync_offset && mddev->resync_offset < MaxSector) {
>                 set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> -               mddev->resync_min =3D mddev->recovery_cp;
> +               mddev->resync_min =3D mddev->resync_offset;
>                 if (test_bit(RT_FLAG_RS_GROW, &rs->runtime_flags))
>                         mddev->resync_max_sectors =3D mddev->dev_sectors;
>         }
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index bd694910b01b..c74fe9c18658 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1987,12 +1987,12 @@ static void bitmap_dirty_bits(struct mddev *mddev=
, unsigned long s,
>
>                 md_bitmap_set_memory_bits(bitmap, sec, 1);
>                 md_bitmap_file_set_bit(bitmap, sec);
> -               if (sec < bitmap->mddev->recovery_cp)
> +               if (sec < bitmap->mddev->resync_offset)
>                         /* We are asserting that the array is dirty,
> -                        * so move the recovery_cp address back so
> +                        * so move the resync_offset address back so
>                          * that it is obvious that it is dirty
>                          */
> -                       bitmap->mddev->recovery_cp =3D sec;
> +                       bitmap->mddev->resync_offset =3D sec;
>         }
>  }
>
> @@ -2258,7 +2258,7 @@ static int bitmap_load(struct mddev *mddev)
>             || bitmap->events_cleared =3D=3D mddev->events)
>                 /* no need to keep dirty bits to optimise a
>                  * re-add of a missing device */
> -               start =3D mddev->recovery_cp;
> +               start =3D mddev->resync_offset;
>
>         mutex_lock(&mddev->bitmap_info.mutex);
>         err =3D md_bitmap_init_from_disk(bitmap, start);
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 94221d964d4f..5497eaee96e7 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -337,11 +337,11 @@ static void recover_bitmaps(struct md_thread *threa=
d)
>                         md_wakeup_thread(mddev->sync_thread);
>
>                 if (hi > 0) {
> -                       if (lo < mddev->recovery_cp)
> -                               mddev->recovery_cp =3D lo;
> +                       if (lo < mddev->resync_offset)
> +                               mddev->resync_offset =3D lo;
>                         /* wake up thread to continue resync in case resy=
nc
>                          * is not finished */
> -                       if (mddev->recovery_cp !=3D MaxSector) {
> +                       if (mddev->resync_offset !=3D MaxSector) {
>                                 /*
>                                  * clear the REMOTE flag since we will la=
unch
>                                  * resync thread in current node.
> @@ -863,9 +863,9 @@ static int gather_all_resync_info(struct mddev *mddev=
, int total_slots)
>                         lockres_free(bm_lockres);
>                         continue;
>                 }
> -               if ((hi > 0) && (lo < mddev->recovery_cp)) {
> +               if ((hi > 0) && (lo < mddev->resync_offset)) {
>                         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -                       mddev->recovery_cp =3D lo;
> +                       mddev->resync_offset =3D lo;
>                         md_check_recovery(mddev);
>                 }
>
> @@ -1027,7 +1027,7 @@ static int leave(struct mddev *mddev)
>          * Also, we should send BITMAP_NEEDS_SYNC message in
>          * case reshaping is interrupted.
>          */
> -       if ((cinfo->slot_number > 0 && mddev->recovery_cp !=3D MaxSector)=
 ||
> +       if ((cinfo->slot_number > 0 && mddev->resync_offset !=3D MaxSecto=
r) ||
>             (mddev->reshape_position !=3D MaxSector &&
>              test_bit(MD_CLOSING, &mddev->flags)))
>                 resync_bitmap(mddev);
> @@ -1605,8 +1605,8 @@ static int gather_bitmaps(struct md_rdev *rdev)
>                         pr_warn("md-cluster: Could not gather bitmaps fro=
m slot %d", sn);
>                         goto out;
>                 }
> -               if ((hi > 0) && (lo < mddev->recovery_cp))
> -                       mddev->recovery_cp =3D lo;
> +               if ((hi > 0) && (lo < mddev->resync_offset))
> +                       mddev->resync_offset =3D lo;
>         }
>  out:
>         return err;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9a704ddc107a..c3723ac57775 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1410,13 +1410,13 @@ static int super_90_validate(struct mddev *mddev,=
 struct md_rdev *freshest, stru
>                         mddev->layout =3D -1;
>
>                 if (sb->state & (1<<MD_SB_CLEAN))
> -                       mddev->recovery_cp =3D MaxSector;
> +                       mddev->resync_offset =3D MaxSector;
>                 else {
>                         if (sb->events_hi =3D=3D sb->cp_events_hi &&
>                                 sb->events_lo =3D=3D sb->cp_events_lo) {
> -                               mddev->recovery_cp =3D sb->recovery_cp;
> +                               mddev->resync_offset =3D sb->resync_offse=
t;
>                         } else
> -                               mddev->recovery_cp =3D 0;
> +                               mddev->resync_offset =3D 0;
>                 }
>
>                 memcpy(mddev->uuid+0, &sb->set_uuid0, 4);
> @@ -1542,13 +1542,13 @@ static void super_90_sync(struct mddev *mddev, st=
ruct md_rdev *rdev)
>         mddev->minor_version =3D sb->minor_version;
>         if (mddev->in_sync)
>         {
> -               sb->recovery_cp =3D mddev->recovery_cp;
> +               sb->resync_offset =3D mddev->resync_offset;
>                 sb->cp_events_hi =3D (mddev->events>>32);
>                 sb->cp_events_lo =3D (u32)mddev->events;
> -               if (mddev->recovery_cp =3D=3D MaxSector)
> +               if (mddev->resync_offset =3D=3D MaxSector)
>                         sb->state =3D (1<< MD_SB_CLEAN);
>         } else
> -               sb->recovery_cp =3D 0;
> +               sb->resync_offset =3D 0;
>
>         sb->layout =3D mddev->layout;
>         sb->chunk_size =3D mddev->chunk_sectors << 9;
> @@ -1898,7 +1898,7 @@ static int super_1_validate(struct mddev *mddev, st=
ruct md_rdev *freshest, struc
>                 mddev->bitmap_info.default_space =3D (4096-1024) >> 9;
>                 mddev->reshape_backwards =3D 0;
>
> -               mddev->recovery_cp =3D le64_to_cpu(sb->resync_offset);
> +               mddev->resync_offset =3D le64_to_cpu(sb->resync_offset);
>                 memcpy(mddev->uuid, sb->set_uuid, 16);
>
>                 mddev->max_disks =3D  (4096-256)/2;
> @@ -2084,7 +2084,7 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>         sb->utime =3D cpu_to_le64((__u64)mddev->utime);
>         sb->events =3D cpu_to_le64(mddev->events);
>         if (mddev->in_sync)
> -               sb->resync_offset =3D cpu_to_le64(mddev->recovery_cp);
> +               sb->resync_offset =3D cpu_to_le64(mddev->resync_offset);
>         else if (test_bit(MD_JOURNAL_CLEAN, &mddev->flags))
>                 sb->resync_offset =3D cpu_to_le64(MaxSector);
>         else
> @@ -2765,7 +2765,7 @@ void md_update_sb(struct mddev *mddev, int force_ch=
ange)
>         /* If this is just a dirty<->clean transition, and the array is c=
lean
>          * and 'events' is odd, we can roll back to the previous clean st=
ate */
>         if (nospares
> -           && (mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
> +           && (mddev->in_sync && mddev->resync_offset =3D=3D MaxSector)
>             && mddev->can_decrease_events
>             && mddev->events !=3D 1) {
>                 mddev->events--;
> @@ -4301,9 +4301,9 @@ __ATTR(chunk_size, S_IRUGO|S_IWUSR, chunk_size_show=
, chunk_size_store);
>  static ssize_t
>  resync_start_show(struct mddev *mddev, char *page)
>  {
> -       if (mddev->recovery_cp =3D=3D MaxSector)
> +       if (mddev->resync_offset =3D=3D MaxSector)
>                 return sprintf(page, "none\n");
> -       return sprintf(page, "%llu\n", (unsigned long long)mddev->recover=
y_cp);
> +       return sprintf(page, "%llu\n", (unsigned long long)mddev->resync_=
offset);
>  }
>
>  static ssize_t
> @@ -4329,7 +4329,7 @@ resync_start_store(struct mddev *mddev, const char =
*buf, size_t len)
>                 err =3D -EBUSY;
>
>         if (!err) {
> -               mddev->recovery_cp =3D n;
> +               mddev->resync_offset =3D n;
>                 if (mddev->pers)
>                         set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>         }
> @@ -6488,7 +6488,7 @@ static void md_clean(struct mddev *mddev)
>         mddev->external_size =3D 0;
>         mddev->dev_sectors =3D 0;
>         mddev->raid_disks =3D 0;
> -       mddev->recovery_cp =3D 0;
> +       mddev->resync_offset =3D 0;
>         mddev->resync_min =3D 0;
>         mddev->resync_max =3D MaxSector;
>         mddev->reshape_position =3D MaxSector;
> @@ -7434,9 +7434,9 @@ int md_set_array_info(struct mddev *mddev, struct m=
du_array_info_s *info)
>          * openned
>          */
>         if (info->state & (1<<MD_SB_CLEAN))
> -               mddev->recovery_cp =3D MaxSector;
> +               mddev->resync_offset =3D MaxSector;
>         else
> -               mddev->recovery_cp =3D 0;
> +               mddev->resync_offset =3D 0;
>         mddev->persistent    =3D ! info->not_persistent;
>         mddev->external      =3D 0;
>
> @@ -8375,7 +8375,7 @@ static int status_resync(struct seq_file *seq, stru=
ct mddev *mddev)
>                                 seq_printf(seq, "\tresync=3DREMOTE");
>                         return 1;
>                 }
> -               if (mddev->recovery_cp < MaxSector) {
> +               if (mddev->resync_offset < MaxSector) {
>                         seq_printf(seq, "\tresync=3DPENDING");
>                         return 1;
>                 }
> @@ -9018,7 +9018,7 @@ static sector_t md_sync_position(struct mddev *mdde=
v, enum sync_action action)
>                 return mddev->resync_min;
>         case ACTION_RESYNC:
>                 if (!mddev->bitmap)
> -                       return mddev->recovery_cp;
> +                       return mddev->resync_offset;
>                 return 0;
>         case ACTION_RESHAPE:
>                 /*
> @@ -9256,8 +9256,8 @@ void md_do_sync(struct md_thread *thread)
>                                    atomic_read(&mddev->recovery_active) =
=3D=3D 0);
>                         mddev->curr_resync_completed =3D j;
>                         if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) =
&&
> -                           j > mddev->recovery_cp)
> -                               mddev->recovery_cp =3D j;
> +                           j > mddev->resync_offset)
> +                               mddev->resync_offset =3D j;
>                         update_time =3D jiffies;
>                         set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>                         sysfs_notify_dirent_safe(mddev->sysfs_completed);
> @@ -9377,19 +9377,19 @@ void md_do_sync(struct md_thread *thread)
>             mddev->curr_resync > MD_RESYNC_ACTIVE) {
>                 if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
>                         if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))=
 {
> -                               if (mddev->curr_resync >=3D mddev->recove=
ry_cp) {
> +                               if (mddev->curr_resync >=3D mddev->resync=
_offset) {
>                                         pr_debug("md: checkpointing %s of=
 %s.\n",
>                                                  desc, mdname(mddev));
>                                         if (test_bit(MD_RECOVERY_ERROR,
>                                                 &mddev->recovery))
> -                                               mddev->recovery_cp =3D
> +                                               mddev->resync_offset =3D
>                                                         mddev->curr_resyn=
c_completed;
>                                         else
> -                                               mddev->recovery_cp =3D
> +                                               mddev->resync_offset =3D
>                                                         mddev->curr_resyn=
c;
>                                 }
>                         } else
> -                               mddev->recovery_cp =3D MaxSector;
> +                               mddev->resync_offset =3D MaxSector;
>                 } else {
>                         if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)=
)
>                                 mddev->curr_resync =3D MaxSector;
> @@ -9605,7 +9605,7 @@ static bool md_choose_sync_action(struct mddev *mdd=
ev, int *spares)
>         }
>
>         /* Check if resync is in progress. */
> -       if (mddev->recovery_cp < MaxSector) {
> +       if (mddev->resync_offset < MaxSector) {
>                 remove_spares(mddev, NULL);
>                 set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
>                 clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> @@ -9786,7 +9786,7 @@ void md_check_recovery(struct mddev *mddev)
>                 test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
>                 (mddev->external =3D=3D 0 && mddev->safemode =3D=3D 1) ||
>                 (mddev->safemode =3D=3D 2
> -                && !mddev->in_sync && mddev->recovery_cp =3D=3D MaxSecto=
r)
> +                && !mddev->in_sync && mddev->resync_offset =3D=3D MaxSec=
tor)
>                 ))
>                 return;
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c65732b330eb..d08d71e1fb41 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -674,7 +674,7 @@ static void *raid0_takeover_raid45(struct mddev *mdde=
v)
>         mddev->raid_disks--;
>         mddev->delta_disks =3D -1;
>         /* make sure it will be not marked as dirty */
> -       mddev->recovery_cp =3D MaxSector;
> +       mddev->resync_offset =3D MaxSector;
>         mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>
>         create_strip_zones(mddev, &priv_conf);
> @@ -717,7 +717,7 @@ static void *raid0_takeover_raid10(struct mddev *mdde=
v)
>         mddev->raid_disks +=3D mddev->delta_disks;
>         mddev->degraded =3D 0;
>         /* make sure it will be not marked as dirty */
> -       mddev->recovery_cp =3D MaxSector;
> +       mddev->resync_offset =3D MaxSector;
>         mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>
>         create_strip_zones(mddev, &priv_conf);
> @@ -760,7 +760,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev=
)
>         mddev->delta_disks =3D 1 - mddev->raid_disks;
>         mddev->raid_disks =3D 1;
>         /* make sure it will be not marked as dirty */
> -       mddev->recovery_cp =3D MaxSector;
> +       mddev->resync_offset =3D MaxSector;
>         mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
>
>         create_strip_zones(mddev, &priv_conf);
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index b8b3a9069701..52881e6032da 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -283,7 +283,7 @@ static inline int raid1_check_read_range(struct md_rd=
ev *rdev,
>  static inline bool raid1_should_read_first(struct mddev *mddev,
>                                            sector_t this_sector, int len)
>  {
> -       if ((mddev->recovery_cp < this_sector + len))
> +       if ((mddev->resync_offset < this_sector + len))
>                 return true;
>
>         if (mddev_is_clustered(mddev) &&
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7e37f1015646..0a0668fa148e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2821,7 +2821,7 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>         }
>
>         if (mddev->bitmap =3D=3D NULL &&
> -           mddev->recovery_cp =3D=3D MaxSector &&
> +           mddev->resync_offset =3D=3D MaxSector &&
>             !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
>             conf->fullsync =3D=3D 0) {
>                 *skipped =3D 1;
> @@ -3282,9 +3282,9 @@ static int raid1_run(struct mddev *mddev)
>         }
>
>         if (conf->raid_disks - mddev->degraded =3D=3D 1)
> -               mddev->recovery_cp =3D MaxSector;
> +               mddev->resync_offset =3D MaxSector;
>
> -       if (mddev->recovery_cp !=3D MaxSector)
> +       if (mddev->resync_offset !=3D MaxSector)
>                 pr_info("md/raid1:%s: not clean -- starting background re=
construction\n",
>                         mdname(mddev));
>         pr_info("md/raid1:%s: active with %d out of %d mirrors\n",
> @@ -3345,8 +3345,8 @@ static int raid1_resize(struct mddev *mddev, sector=
_t sectors)
>
>         md_set_array_sectors(mddev, newsize);
>         if (sectors > mddev->dev_sectors &&
> -           mddev->recovery_cp > mddev->dev_sectors) {
> -               mddev->recovery_cp =3D mddev->dev_sectors;
> +           mddev->resync_offset > mddev->dev_sectors) {
> +               mddev->resync_offset =3D mddev->dev_sectors;
>                 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         }
>         mddev->dev_sectors =3D sectors;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 375543f8153f..169bc5fe2d4f 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2109,7 +2109,7 @@ static int raid10_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>         int last =3D conf->geo.raid_disks - 1;
>         struct raid10_info *p;
>
> -       if (mddev->recovery_cp < MaxSector)
> +       if (mddev->resync_offset < MaxSector)
>                 /* only hot-add to in-sync arrays, as recovery is
>                  * very different from resync
>                  */
> @@ -3177,7 +3177,7 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>          * of a clean array, like RAID1 does.
>          */
>         if (mddev->bitmap =3D=3D NULL &&
> -           mddev->recovery_cp =3D=3D MaxSector &&
> +           mddev->resync_offset =3D=3D MaxSector &&
>             mddev->reshape_position =3D=3D MaxSector &&
>             !test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
>             !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
> @@ -4137,7 +4137,7 @@ static int raid10_run(struct mddev *mddev)
>                 disk->recovery_disabled =3D mddev->recovery_disabled - 1;
>         }
>
> -       if (mddev->recovery_cp !=3D MaxSector)
> +       if (mddev->resync_offset !=3D MaxSector)
>                 pr_notice("md/raid10:%s: not clean -- starting background=
 reconstruction\n",
>                           mdname(mddev));
>         pr_info("md/raid10:%s: active with %d out of %d devices\n",
> @@ -4237,8 +4237,8 @@ static int raid10_resize(struct mddev *mddev, secto=
r_t sectors)
>
>         md_set_array_sectors(mddev, size);
>         if (sectors > mddev->dev_sectors &&
> -           mddev->recovery_cp > oldsize) {
> -               mddev->recovery_cp =3D oldsize;
> +           mddev->resync_offset > oldsize) {
> +               mddev->resync_offset =3D oldsize;
>                 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         }
>         calc_sectors(conf, sectors);
> @@ -4267,7 +4267,7 @@ static void *raid10_takeover_raid0(struct mddev *md=
dev, sector_t size, int devs)
>         mddev->delta_disks =3D mddev->raid_disks;
>         mddev->raid_disks *=3D 2;
>         /* make sure it will be not marked as dirty */
> -       mddev->recovery_cp =3D MaxSector;
> +       mddev->resync_offset =3D MaxSector;
>         mddev->dev_sectors =3D size;
>
>         conf =3D setup_conf(mddev);
> @@ -5079,8 +5079,8 @@ static void raid10_finish_reshape(struct mddev *mdd=
ev)
>                 return;
>
>         if (mddev->delta_disks > 0) {
> -               if (mddev->recovery_cp > mddev->resync_max_sectors) {
> -                       mddev->recovery_cp =3D mddev->resync_max_sectors;
> +               if (mddev->resync_offset > mddev->resync_max_sectors) {
> +                       mddev->resync_offset =3D mddev->resync_max_sector=
s;
>                         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>                 }
>                 mddev->resync_max_sectors =3D mddev->array_sectors;
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index c0fb335311aa..56b234683ee6 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -1163,7 +1163,7 @@ static int ppl_load_distributed(struct ppl_log *log=
)
>                     le64_to_cpu(pplhdr->generation));
>
>         /* attempt to recover from log if we are starting a dirty array *=
/
> -       if (pplhdr && !mddev->pers && mddev->recovery_cp !=3D MaxSector)
> +       if (pplhdr && !mddev->pers && mddev->resync_offset !=3D MaxSector=
)
>                 ret =3D ppl_recover(log, pplhdr, pplhdr_offset);
>
>         /* write empty header if we are starting the array */
> @@ -1422,14 +1422,14 @@ int ppl_init_log(struct r5conf *conf)
>
>         if (ret) {
>                 goto err;
> -       } else if (!mddev->pers && mddev->recovery_cp =3D=3D 0 &&
> +       } else if (!mddev->pers && mddev->resync_offset =3D=3D 0 &&
>                    ppl_conf->recovered_entries > 0 &&
>                    ppl_conf->mismatch_count =3D=3D 0) {
>                 /*
>                  * If we are starting a dirty array and the recovery succ=
eeds
>                  * without any issues, set the array as clean.
>                  */
> -               mddev->recovery_cp =3D MaxSector;
> +               mddev->resync_offset =3D MaxSector;
>                 set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
>         } else if (mddev->pers && ppl_conf->mismatch_count > 0) {
>                 /* no mismatch allowed when enabling PPL for a running ar=
ray */
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 11307878a982..8e74cee3fb8e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3740,7 +3740,7 @@ static int want_replace(struct stripe_head *sh, int=
 disk_idx)
>             && !test_bit(Faulty, &rdev->flags)
>             && !test_bit(In_sync, &rdev->flags)
>             && (rdev->recovery_offset <=3D sh->sector
> -               || rdev->mddev->recovery_cp <=3D sh->sector))
> +               || rdev->mddev->resync_offset <=3D sh->sector))
>                 rv =3D 1;
>         return rv;
>  }
> @@ -3832,7 +3832,7 @@ static int need_this_block(struct stripe_head *sh, =
struct stripe_head_state *s,
>          * is missing/faulty, then we need to read everything we can.
>          */
>         if (!force_rcw &&
> -           sh->sector < sh->raid_conf->mddev->recovery_cp)
> +           sh->sector < sh->raid_conf->mddev->resync_offset)
>                 /* reconstruct-write isn't being forced */
>                 return 0;
>         for (i =3D 0; i < s->failed && i < 2; i++) {
> @@ -4097,7 +4097,7 @@ static int handle_stripe_dirtying(struct r5conf *co=
nf,
>                                   int disks)
>  {
>         int rmw =3D 0, rcw =3D 0, i;
> -       sector_t recovery_cp =3D conf->mddev->recovery_cp;
> +       sector_t resync_offset =3D conf->mddev->resync_offset;
>
>         /* Check whether resync is now happening or should start.
>          * If yes, then the array is dirty (after unclean shutdown or
> @@ -4107,14 +4107,14 @@ static int handle_stripe_dirtying(struct r5conf *=
conf,
>          * generate correct data from the parity.
>          */
>         if (conf->rmw_level =3D=3D PARITY_DISABLE_RMW ||
> -           (recovery_cp < MaxSector && sh->sector >=3D recovery_cp &&
> +           (resync_offset < MaxSector && sh->sector >=3D resync_offset &=
&
>              s->failed =3D=3D 0)) {
>                 /* Calculate the real rcw later - for now make it
>                  * look like rcw is cheaper
>                  */
>                 rcw =3D 1; rmw =3D 2;
> -               pr_debug("force RCW rmw_level=3D%u, recovery_cp=3D%llu sh=
->sector=3D%llu\n",
> -                        conf->rmw_level, (unsigned long long)recovery_cp=
,
> +               pr_debug("force RCW rmw_level=3D%u, resync_offset=3D%llu =
sh->sector=3D%llu\n",
> +                        conf->rmw_level, (unsigned long long)resync_offs=
et,
>                          (unsigned long long)sh->sector);
>         } else for (i =3D disks; i--; ) {
>                 /* would I have to read this buffer for read_modify_write=
 */
> @@ -4770,14 +4770,14 @@ static void analyse_stripe(struct stripe_head *sh=
, struct stripe_head_state *s)
>         if (test_bit(STRIPE_SYNCING, &sh->state)) {
>                 /* If there is a failed device being replaced,
>                  *     we must be recovering.
> -                * else if we are after recovery_cp, we must be syncing
> +                * else if we are after resync_offset, we must be syncing
>                  * else if MD_RECOVERY_REQUESTED is set, we also are sync=
ing.
>                  * else we can only be replacing
>                  * sync and recovery both need to read all devices, and s=
o
>                  * use the same flag.
>                  */
>                 if (do_recovery ||
> -                   sh->sector >=3D conf->mddev->recovery_cp ||
> +                   sh->sector >=3D conf->mddev->resync_offset ||
>                     test_bit(MD_RECOVERY_REQUESTED, &(conf->mddev->recove=
ry)))
>                         s->syncing =3D 1;
>                 else
> @@ -7781,7 +7781,7 @@ static int raid5_run(struct mddev *mddev)
>         int first =3D 1;
>         int ret =3D -EIO;
>
> -       if (mddev->recovery_cp !=3D MaxSector)
> +       if (mddev->resync_offset !=3D MaxSector)
>                 pr_notice("md/raid:%s: not clean -- starting background r=
econstruction\n",
>                           mdname(mddev));
>
> @@ -7922,7 +7922,7 @@ static int raid5_run(struct mddev *mddev)
>                                 mdname(mddev));
>                         mddev->ro =3D 1;
>                         set_disk_ro(mddev->gendisk, 1);
> -               } else if (mddev->recovery_cp =3D=3D MaxSector)
> +               } else if (mddev->resync_offset =3D=3D MaxSector)
>                         set_bit(MD_JOURNAL_CLEAN, &mddev->flags);
>         }
>
> @@ -7989,7 +7989,7 @@ static int raid5_run(struct mddev *mddev)
>         mddev->resync_max_sectors =3D mddev->dev_sectors;
>
>         if (mddev->degraded > dirty_parity_disks &&
> -           mddev->recovery_cp !=3D MaxSector) {
> +           mddev->resync_offset !=3D MaxSector) {
>                 if (test_bit(MD_HAS_PPL, &mddev->flags))
>                         pr_crit("md/raid:%s: starting dirty degraded arra=
y with PPL.\n",
>                                 mdname(mddev));
> @@ -8329,8 +8329,8 @@ static int raid5_resize(struct mddev *mddev, sector=
_t sectors)
>
>         md_set_array_sectors(mddev, newsize);
>         if (sectors > mddev->dev_sectors &&
> -           mddev->recovery_cp > mddev->dev_sectors) {
> -               mddev->recovery_cp =3D mddev->dev_sectors;
> +           mddev->resync_offset > mddev->dev_sectors) {
> +               mddev->resync_offset =3D mddev->dev_sectors;
>                 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>         }
>         mddev->dev_sectors =3D sectors;
> @@ -8424,7 +8424,7 @@ static int raid5_start_reshape(struct mddev *mddev)
>                 return -EINVAL;
>
>         /* raid5 can't handle concurrent reshape and recovery */
> -       if (mddev->recovery_cp < MaxSector)
> +       if (mddev->resync_offset < MaxSector)
>                 return -EBUSY;
>         for (i =3D 0; i < conf->raid_disks; i++)
>                 if (conf->disks[i].replacement)
> @@ -8649,7 +8649,7 @@ static void *raid45_takeover_raid0(struct mddev *md=
dev, int level)
>         mddev->raid_disks +=3D 1;
>         mddev->delta_disks =3D 1;
>         /* make sure it will be not marked as dirty */
> -       mddev->recovery_cp =3D MaxSector;
> +       mddev->resync_offset =3D MaxSector;
>
>         return setup_conf(mddev);
>  }
> --
> 2.39.2
>
>

