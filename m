Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CB7235BF9
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303827; cv=none; b=LTSqfUkn+twneWDxtB3mTAvCqB3ZKP9FvStYWGCNBQJSWdwMi2ZSgHZnyJOrdP2SvHE2YCHSou1oM73DJVqWZMX3soW+wb7u8Pg3JQyciTrcAlFJ0Di0f2o8CkzFv0NEDQT9FT5WnlVsF/7k0Dlb5LnfiFq5SGiUINwbiQ/kO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303827; c=relaxed/simple;
	bh=zBO3cHLiclV36iHkjy3oMjCqNLjeZzA8xzmJ0uI8Ooc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dtmNc0ZVTcvpKWgqDkd4r0hXdq9O28EE7cgMUfeCZNxVhUBk3OeBFXJXnUtgT6JCepGiqJLDPH5s5d77EGDx3bTQn289hAeLDVEroTFGdaYeADo2bipGUsTwfss9CAgkNxDO1L+pNNU8OaA1z1Er1/6cb07CZ2tniW6qH0sj+ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QqakaDrW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QqakaDrW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745303823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hfIwSQHpPbbjZ79uxCsh57KYVS3IPmjvnfmuDlU/GrM=;
	b=QqakaDrWFKRy87pX2wOMXfO+dyuICPDacvDdDTUZgaH9ZFcw7eieJ598JtEFzml/2QaDtP
	JOzA1dfkL+X/3oDEfA+a02LXKs7nfHIP3fJcJ3sh6sdUA1uQgo8LrLPcSOxreQGLPnqHmL
	Wlfgsgw495RTjcptmQRCCln0q22ePiY=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-eOxw6q-QO6GeeAb0SWQGhQ-1; Tue, 22 Apr 2025 02:36:59 -0400
X-MC-Unique: eOxw6q-QO6GeeAb0SWQGhQ-1
X-Mimecast-MFC-AGG-ID: eOxw6q-QO6GeeAb0SWQGhQ_1745303816
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5499c383444so2192073e87.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Apr 2025 23:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745303815; x=1745908615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfIwSQHpPbbjZ79uxCsh57KYVS3IPmjvnfmuDlU/GrM=;
        b=kfijSeljelR2hg9uweHYQj+CLD7jzq/AGdumzT8EYCm46Q8biZ58GmztzxQESje22t
         URLKAu8oYl9nNND/+fK7jIm8utgUSjA/mC2/dKO2dniajaZhoOpCDbMqrhwUhn/ghgB1
         oEypEWbjsEIHV3UOM6+VUkr6e0NuZYpowFofnFJydR83LrOL55j+MOZCnXcaqF+hc8Tk
         dUlNhvzs4a0UFXZWcad/onzGs5MEnu/aScTV8HouiiDIH/fGeW9fM8MB1y14LGBvsb+Z
         VO3Vy/l9Ro5Xq81f1SAta0j9zQRr6obDk7wwpTop/Dd0FNvCYN9ddz1It05RQ/Pjb/n3
         8KtQ==
X-Forwarded-Encrypted: i=1; AJvYcCV47TgZ9MENMVdjiPzyqbQzqhxFY45QGBKQOlVcJvOvuDk4co/ZISn7CHRvgKexhkFI2ykQ9dV3Xg==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywkfp9C7hLKgImWWsfE8YLVLcYlxxqo+W/s1hkAH4b3faqGDepR
	5JPFY2XrfSgP9dlzpCF9GV8BZ/rqKIMg1VQksP6osuZn4PWAqeWSs+umBj8qHKKDZLIgBa5qRbp
	kSk7B2FIlpk4aKwEjRUwflYNL/z5YJpBz2QXjlRKplsehH6OCyWOzq8expZygDQFivqMYw2TdJD
	ZlGlLfu+QYtc5J3v/qx8nFWAzfcIbzOtg=
X-Gm-Gg: ASbGnctEI8W/Nj3cMbOM4+0rbUUe9D9g8h9fgAv2zL8Bdb5+dJMThqGeKDoDZ6I8vzl
	aHOWU18CwibzUrIKfR5wayaC837NQT89eA5bw9t5iofJdPBbMTIy0w7SumfnJ1g2QurQ3ww==
X-Received: by 2002:a05:6512:2213:b0:545:4d1:64c0 with SMTP id 2adb3069b0e04-54d6e635993mr2725355e87.27.1745303815500;
        Mon, 21 Apr 2025 23:36:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGsV2iKdntyWD/PlIwdej6iLCJiyJyLNOfrenMmofROOrUiJsbOhpMOVsC7xc8mcg9b4+o+jSpP+wEhNJU3zTY=
X-Received: by 2002:a05:6512:2213:b0:545:4d1:64c0 with SMTP id
 2adb3069b0e04-54d6e635993mr2725339e87.27.1745303815071; Mon, 21 Apr 2025
 23:36:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250418010941.667138-1-yukuai1@huaweicloud.com> <20250418010941.667138-6-yukuai1@huaweicloud.com>
In-Reply-To: <20250418010941.667138-6-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 22 Apr 2025 14:36:42 +0800
X-Gm-Features: ATxdqUFS0VYNC-vDgIRo-qzVHjqRjAfEYxMXTx6b8XG9gBvuL_2101HF5aUyueA
Message-ID: <CALTww28DOGXMHXfofCh8SRK7GBJSwHoPaCJHGKAt5BjfoN-S7Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] md: cleanup accounting for issued sync IO
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, yukuai3@huawei.com, viro@zeniv.linux.org.uk, 
	akpm@linux-foundation.org, nadav.amit@gmail.com, ubizjak@gmail.com, 
	cl@linux.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ki4WLNP_KWgfY-573NRtLGKmENmOAM8-7kjmFhP3BGM_1745303816
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 18, 2025 at 9:17=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> It's no longer used and can be removed, also remove the field
> 'gendisk->sync_io'.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h        | 11 -----------
>  drivers/md/raid1.c     |  3 ---
>  drivers/md/raid10.c    |  9 ---------
>  drivers/md/raid5.c     |  8 --------
>  include/linux/blkdev.h |  1 -
>  5 files changed, 32 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1d51c2405d3d..07b40a55ed5f 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -717,17 +717,6 @@ static inline int mddev_trylock(struct mddev *mddev)
>  }
>  extern void mddev_unlock(struct mddev *mddev);
>
> -static inline void md_sync_acct(struct block_device *bdev, unsigned long=
 nr_sectors)
> -{
> -       if (blk_queue_io_stat(bdev->bd_disk->queue))
> -               atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
> -}
> -
> -static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_se=
ctors)
> -{
> -       md_sync_acct(bio->bi_bdev, nr_sectors);
> -}
> -
>  struct md_personality
>  {
>         struct md_submodule_head head;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index de9bccbe7337..657d481525be 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2382,7 +2382,6 @@ static void sync_request_write(struct mddev *mddev,=
 struct r1bio *r1_bio)
>
>                 wbio->bi_end_io =3D end_sync_write;
>                 atomic_inc(&r1_bio->remaining);
> -               md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbi=
o));
>
>                 submit_bio_noacct(wbio);
>         }
> @@ -3055,7 +3054,6 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>                         bio =3D r1_bio->bios[i];
>                         if (bio->bi_end_io =3D=3D end_sync_read) {
>                                 read_targets--;
> -                               md_sync_acct_bio(bio, nr_sectors);
>                                 if (read_targets =3D=3D 1)
>                                         bio->bi_opf &=3D ~MD_FAILFAST;
>                                 submit_bio_noacct(bio);
> @@ -3064,7 +3062,6 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>         } else {
>                 atomic_set(&r1_bio->remaining, 1);
>                 bio =3D r1_bio->bios[r1_bio->read_disk];
> -               md_sync_acct_bio(bio, nr_sectors);
>                 if (read_targets =3D=3D 1)
>                         bio->bi_opf &=3D ~MD_FAILFAST;
>                 submit_bio_noacct(bio);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index ba32bac975b8..dce06bf65016 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2426,7 +2426,6 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>
>                 atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>                 atomic_inc(&r10_bio->remaining);
> -               md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbi=
o));
>
>                 if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
>                         tbio->bi_opf |=3D MD_FAILFAST;
> @@ -2448,8 +2447,6 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>                         bio_copy_data(tbio, fbio);
>                 d =3D r10_bio->devs[i].devnum;
>                 atomic_inc(&r10_bio->remaining);
> -               md_sync_acct(conf->mirrors[d].replacement->bdev,
> -                            bio_sectors(tbio));
>                 submit_bio_noacct(tbio);
>         }
>
> @@ -2583,13 +2580,10 @@ static void recovery_request_write(struct mddev *=
mddev, struct r10bio *r10_bio)
>         d =3D r10_bio->devs[1].devnum;
>         if (wbio->bi_end_io) {
>                 atomic_inc(&conf->mirrors[d].rdev->nr_pending);
> -               md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbi=
o));
>                 submit_bio_noacct(wbio);
>         }
>         if (wbio2) {
>                 atomic_inc(&conf->mirrors[d].replacement->nr_pending);
> -               md_sync_acct(conf->mirrors[d].replacement->bdev,
> -                            bio_sectors(wbio2));
>                 submit_bio_noacct(wbio2);
>         }
>  }
> @@ -3757,7 +3751,6 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>                 r10_bio->sectors =3D nr_sectors;
>
>                 if (bio->bi_end_io =3D=3D end_sync_read) {
> -                       md_sync_acct_bio(bio, nr_sectors);
>                         bio->bi_status =3D 0;
>                         submit_bio_noacct(bio);
>                 }
> @@ -4880,7 +4873,6 @@ static sector_t reshape_request(struct mddev *mddev=
, sector_t sector_nr,
>         r10_bio->sectors =3D nr_sectors;
>
>         /* Now submit the read */
> -       md_sync_acct_bio(read_bio, r10_bio->sectors);
>         atomic_inc(&r10_bio->remaining);
>         read_bio->bi_next =3D NULL;
>         submit_bio_noacct(read_bio);
> @@ -4940,7 +4932,6 @@ static void reshape_request_write(struct mddev *mdd=
ev, struct r10bio *r10_bio)
>                         continue;
>
>                 atomic_inc(&rdev->nr_pending);
> -               md_sync_acct_bio(b, r10_bio->sectors);
>                 atomic_inc(&r10_bio->remaining);
>                 b->bi_next =3D NULL;
>                 submit_bio_noacct(b);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6389383166c0..ca5b0e8ba707 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1240,10 +1240,6 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
>                 }
>
>                 if (rdev) {
> -                       if (s->syncing || s->expanding || s->expanded
> -                           || s->replacing)
> -                               md_sync_acct(rdev->bdev, RAID5_STRIPE_SEC=
TORS(conf));
> -
>                         set_bit(STRIPE_IO_STARTED, &sh->state);
>
>                         bio_init(bi, rdev->bdev, &dev->vec, 1, op | op_fl=
ags);
> @@ -1300,10 +1296,6 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
>                                 submit_bio_noacct(bi);
>                 }
>                 if (rrdev) {
> -                       if (s->syncing || s->expanding || s->expanded
> -                           || s->replacing)
> -                               md_sync_acct(rrdev->bdev, RAID5_STRIPE_SE=
CTORS(conf));
> -
>                         set_bit(STRIPE_IO_STARTED, &sh->state);
>
>                         bio_init(rbi, rrdev->bdev, &dev->rvec, 1, op | op=
_flags);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index e39c45bc0a97..f3a625b00734 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -182,7 +182,6 @@ struct gendisk {
>         struct list_head slave_bdevs;
>  #endif
>         struct timer_rand_state *random;
> -       atomic_t sync_io;               /* RAID */
>         struct disk_events *ev;
>
>  #ifdef CONFIG_BLK_DEV_ZONED
> --
> 2.39.2
>

Looks good to me. Reviewed-by: Xiao Ni <xni@redhat.com>

