Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF74B13B586
	for <dm-devel@lists.linux.dev>; Sat,  9 Nov 2024 11:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731152121; cv=none; b=oEMntRrlfWvzuEkP45lc6aQOzVj6tsqFBiuoPRDf3I2gC26L7PsHDV6Y6ID2Bne1hUpLWtW2ONrqXMhWTZ0wPaFsnrwtdviKoVdZqYPwE/Cna3A8VIE3wa4fayidpCmg8sPkRO4WiEQoaGxqSo8fs8DHLbP+ArrvdfuvSWlmIcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731152121; c=relaxed/simple;
	bh=EsYA52V9ouDJmsQD6t1wczwY3+ALywCYNyMZes6RAiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tEEHHKrNsmnYnguqPd1rSDLfkodrL7eINUcCRmyNUZsoaG14JWGeyscCA8G0lirhL03uHppywr6oRpwWrrqb+u0by351dAkfUe1sZv9S/aw7RTTwR+Y5e8O9dKJwKf1BETIBgyrF0zBZHoqK8GfvKtGMXax4cPLQGngnkt2KnqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jru1EJoS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jru1EJoS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731152118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4LhqM4M7tJ5srFTlDdbHXjM6EWLsQBoqOsLY1T1hVts=;
	b=Jru1EJoSX+oqMV1oZRKQPDknR5G23YI4eYNnP7pwV22KIed0Y+dQUDR2nmOQ6ozvmYhE81
	jWs9y3XA1y68VDMoMzzaDce0gtTdWbJDxx8vUzN+n3c3hrEl3HvEljXJ49dSVb2PSV/DQf
	HEbA5e/LkXXLGurOk/C0dW6rdnTchTw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-Oj8ptFL8NQOSt73PN3_jCg-1; Sat, 09 Nov 2024 06:35:16 -0500
X-MC-Unique: Oj8ptFL8NQOSt73PN3_jCg-1
X-Mimecast-MFC-AGG-ID: Oj8ptFL8NQOSt73PN3_jCg
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-539fdef0040so2463805e87.0
        for <dm-devel@lists.linux.dev>; Sat, 09 Nov 2024 03:35:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731152115; x=1731756915;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ci5+WUKUGdN9hISd12rVCcVNmSHsA6SperZ5+gohatI=;
        b=GE4oGU89cnVOLEOzJ0vO5HA3JMzSenwEddZYqQWJsLe5yL/CRSSz8+ro3KMd5k/6Bx
         POUQqOJOrsfHsG52Il9lsn4ITzWSU+rcJ6JVAyjND0QsHUUdAE5jTa/ChHi1kuCV90Cc
         Q/nNnF4RD5g2slArwXNLeSNty77AlxPTFnEMva2IngFU4rPC9y3wHBiwAajhiCB0NGh3
         N87yXiQ/kY79xMJMgaRihyxJI/BIKvP7RuXWj67Q0Cci1i+YinjuAr2Q58b78SvBsk/p
         /oMDMgznRreg+Stj4dsaHAByTpZg41EC72RRrraZ0rtaHJJZBW83+T90DEfvoUJaYhBY
         9sTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbDJis4s6wnlmYwkvS/CMY1SmApZLg/5/6dSqRp6QX7V6T19OMM0nW679nM6gEIRDh+gZC8tjeBQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5Km5bO3DYz19IszpOm7OHga+yOOOkUncSFT4fdCfiV2j8nMaV
	FitJXqVkrfdtf93f5M1WP+32nnJ+9poNMZo+ZlcdU/1y0CJKHmhqwKhbXBzo//Nmx1LcU4qh5+m
	urMdlC7OCxNxUTQzEWkJICMGgi/5iLsqmFDXPGMluJ1VFddvyWOroEstb8k/48gIaO2tO5wGpDW
	/X52GcNOI3d/vx8Bun2q+H/Odmj/V+F5Y=
X-Received: by 2002:a05:6512:2254:b0:533:d3e:16f5 with SMTP id 2adb3069b0e04-53d862e5d63mr3342166e87.38.1731152115137;
        Sat, 09 Nov 2024 03:35:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/Y+f1A3wcrVYsejB9OE0ntAIM+1zNr0sPleSHOM8dnDlV6TDuERyQQtxQzkahTR74VretL1W1he9SMCnsBno=
X-Received: by 2002:a05:6512:2254:b0:533:d3e:16f5 with SMTP id
 2adb3069b0e04-53d862e5d63mr3342150e87.38.1731152114574; Sat, 09 Nov 2024
 03:35:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com> <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
 <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io> <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
 <26403.59789.480428.418012@quad.stoffel.home> <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com>
 <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io> <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io>
 <5170f0d2-cb0f-2e0f-eb5e-31aa9d6ff65d@huawei.com> <2b093abc-cd9a-0b84-bcba-baec689fa153@huaweicloud.com>
 <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io> <F8A5ABD5-0773-414D-BBBC-538481BCD0F4@flyingcircus.io>
 <753611d4-5c54-ee0d-30ab-9321274fd749@huaweicloud.com> <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
 <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io> <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
 <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io> <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
In-Reply-To: <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 9 Nov 2024 19:35:02 +0800
Message-ID: <CALTww28iP_pGU7jmhZrXX9D-xL5Xb6w=9jLxS=fvv_6HgqZ6qw@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christian Theune <ct@flyingcircus.io>, John Stoffel <john@stoffel.org>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	=?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>, 
	David Jeffery <djeffery@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z5GMRmIcTkve95gJqIgeE7xLYaxg6rQjvGgn0T9Ay4w_1731152115
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="000000000000d79b2306267942a7"

--000000000000d79b2306267942a7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 3:55=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi!
>
> =E5=9C=A8 2024/11/06 14:40, Christian Theune =E5=86=99=E9=81=93:
> > Hi,
> >
> >> On 6. Nov 2024, at 07:35, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/11/05 18:15, Christian Theune =E5=86=99=E9=81=93:
> >>> Hi,
> >>> after about 2 hours it stalled again. Here=E2=80=99s the full blocked=
 process dump. (Tell me if this isn=E2=80=99t helpful, otherwise I=E2=80=99=
ll keep posting that as it=E2=80=99s the only real data I can show)
> >>
> >> This is bad news :(
> >
> > Yeah. But: the good new is that we aren=E2=80=99t eating any data so fa=
r =E2=80=A6 ;)
> >
> >> While reviewing related code, I come up with a plan to move bitmap
> >> start/end write ops to the upper layer. Make sure each write IO from
> >> upper layer only start once and end once, this is easy to make sure
> >> they are balanced and can avoid many calls to improve performance as
> >> well.
> >
> > Sounds like a plan!
> >
> >> However, I need a few days to cooke a patch after work.
> >
> > Sure thing! I=E2=80=99ll switch off bitmaps for that time - I=E2=80=99m=
 happy we found a workaround so we can take time to resolve it cleanly. :)
>
> I wrote a simple and crude version, please give it a test again.
>
> Thanks,
> Kuai
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3a837506a36..5e1a82b79e41 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8753,6 +8753,30 @@ void md_submit_discard_bio(struct mddev *mddev,
> struct md_rdev *rdev,
>   }
>   EXPORT_SYMBOL_GPL(md_submit_discard_bio);
>
> +static bool is_raid456(struct mddev *mddev)
> +{
> +       return mddev->pers->level =3D=3D 4 || mddev->pers->level =3D=3D 5=
 ||
> +              mddev->pers->level =3D=3D 6;
> +}
> +
> +static void bitmap_startwrite(struct mddev *mddev, struct bio *bio)
> +{
> +       if (!is_raid456(mddev) || !mddev->bitmap)
> +               return;
> +
> +       md_bitmap_startwrite(mddev->bitmap, bio_offset(bio),
> bio_sectors(bio),
> +                            0);
> +}
> +
> +static void bitmap_endwrite(struct mddev *mddev, struct bio *bio,
> sector_t sectors)
> +{
> +       if (!is_raid456(mddev) || !mddev->bitmap)
> +               return;
> +
> +       md_bitmap_endwrite(mddev->bitmap, bio_offset(bio), sectors,o
> +                          bio->bi_status =3D=3D BLK_STS_OK, 0);
> +}
> +
>   static void md_end_clone_io(struct bio *bio)
>   {
>          struct md_io_clone *md_io_clone =3D bio->bi_private;
> @@ -8765,6 +8789,7 @@ static void md_end_clone_io(struct bio *bio)
>          if (md_io_clone->start_time)
>                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
> +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
>          bio_put(bio);
>          bio_endio(orig_bio);
>          percpu_ref_put(&mddev->active_io);
> @@ -8778,6 +8803,7 @@ static void md_clone_bio(struct mddev *mddev,
> struct bio **bio)
>                  bio_alloc_clone(bdev, *bio, GFP_NOIO,
> &mddev->io_clone_set);
>
>          md_io_clone =3D container_of(clone, struct md_io_clone, bio_clon=
e);
> +       md_io_clone->sectors =3D bio_sectors(*bio);
>          md_io_clone->orig_bio =3D *bio;
>          md_io_clone->mddev =3D mddev;
>          if (blk_queue_io_stat(bdev->bd_disk->queue))
> @@ -8790,6 +8816,7 @@ static void md_clone_bio(struct mddev *mddev,
> struct bio **bio)
>
>   void md_account_bio(struct mddev *mddev, struct bio **bio)
>   {
> +       bitmap_startwrite(mddev, *bio);
>          percpu_ref_get(&mddev->active_io);
>          md_clone_bio(mddev, bio);
>   }
> @@ -8807,6 +8834,8 @@ void md_free_cloned_bio(struct bio *bio)
>          if (md_io_clone->start_time)
>                  bio_end_io_acct(orig_bio, md_io_clone->start_time);
>
> +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
> +
>          bio_put(bio);
>          percpu_ref_put(&mddev->active_io);
>   }
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index a0d6827dced9..0c2794230e0a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -837,6 +837,7 @@ struct md_io_clone {
>          struct mddev    *mddev;
>          struct bio      *orig_bio;
>          unsigned long   start_time;
> +       sector_t        sectors;
>          struct bio      bio_clone;
>   };
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c14cf2410365..4f009e32f68a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3561,12 +3561,6 @@ static void __add_stripe_bio(struct stripe_head
> *sh, struct bio *bi,
>                   * is added to a batch, STRIPE_BIT_DELAY cannot be chang=
ed
>                   * any more.
>                   */
> -               set_bit(STRIPE_BITMAP_PENDING, &sh->state);
> -               spin_unlock_irq(&sh->stripe_lock);
> -               md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
> -                                    RAID5_STRIPE_SECTORS(conf), 0);
> -               spin_lock_irq(&sh->stripe_lock);
> -               clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
>                  if (!sh->batch_head) {
>                          sh->bm_seq =3D conf->seq_flush+1;
>                          set_bit(STRIPE_BIT_DELAY, &sh->state);
> @@ -3621,7 +3615,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>          BUG_ON(sh->batch_head);
>          for (i =3D disks; i--; ) {
>                  struct bio *bi;
> -               int bitmap_end =3D 0;
>
>                  if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
>                          struct md_rdev *rdev =3D conf->disks[i].rdev;
> @@ -3646,8 +3639,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                  sh->dev[i].towrite =3D NULL;
>                  sh->overwrite_disks =3D 0;
>                  spin_unlock_irq(&sh->stripe_lock);
> -               if (bi)
> -                       bitmap_end =3D 1;
>
>                  log_stripe_write_finished(sh);
> @@ -3662,10 +3653,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                          bio_io_error(bi);
>                          bi =3D nextbi;
>                  }
> -               if (bitmap_end)
> -                       md_bitmap_endwrite(conf->mddev->bitmap, sh->secto=
r,
> -                                          RAID5_STRIPE_SECTORS(conf),
> 0, 0);
> -               bitmap_end =3D 0;
>                  /* and fail all 'written' */
>                  bi =3D sh->dev[i].written;
>                  sh->dev[i].written =3D NULL;
> @@ -3674,7 +3661,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                          sh->dev[i].page =3D sh->dev[i].orig_page;
>                  }
>
> -               if (bi) bitmap_end =3D 1;
>                  while (bi && bi->bi_iter.bi_sector <
>                         sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
>                          struct bio *bi2 =3D r5_next_bio(conf, bi,
> sh->dev[i].sector);
> @@ -3708,9 +3694,6 @@ handle_failed_stripe(struct r5conf *conf, struct
> stripe_head *sh,
>                                  bi =3D nextbi;
>                          }
>                  }
> -               if (bitmap_end)
> -                       md_bitmap_endwrite(conf->mddev->bitmap, sh->secto=
r,
> -                                          RAID5_STRIPE_SECTORS(conf),
> 0, 0);
>                  /* If we were in the middle of a write the parity block
> might
>                   * still be locked - so just clear all R5_LOCKED flags
>                   */
> @@ -4059,10 +4042,6 @@ static void handle_stripe_clean_event(struct
> r5conf *conf,
>                                          bio_endio(wbi);
>                                          wbi =3D wbi2;
>                                  }
> -                               md_bitmap_endwrite(conf->mddev->bitmap,
> sh->sector,
> -
> RAID5_STRIPE_SECTORS(conf),
> -
> !test_bit(STRIPE_DEGRADED, &sh->state),
> -                                                  0);
>                                  if (head_sh->batch_head) {
>                                          sh =3D
> list_first_entry(&sh->batch_list,
>                                                                struct
> stripe_head,
> @@ -5788,13 +5767,6 @@ static void make_discard_request(struct mddev
> *mddev, struct bio *bi)
>                  }
>                  spin_unlock_irq(&sh->stripe_lock);
>                  if (conf->mddev->bitmap) {
> -                       for (d =3D 0;
> -                            d < conf->raid_disks - conf->max_degraded;
> -                            d++)
> -                               md_bitmap_startwrite(mddev->bitmap,
> -                                                    sh->sector,
> -
> RAID5_STRIPE_SECTORS(conf),
> -                                                    0);
>                          sh->bm_seq =3D conf->seq_flush + 1;
>                          set_bit(STRIPE_BIT_DELAY, &sh->state);
>                  }
>
>
>
> >
> > Thanks a lot for your help!
> > Christian
> >
>
>

Hi Kuai

Maybe it's not good to put the bitmap operation from raid5 to md which
the new api is only used for raid5. And the bitmap region which raid5
needs to handle is based on the member disk. It should be calculated
rather than the bio address space. Because the bio address space is
for the whole array.

We have a customer who reports a similar problem. There is a patch
from David. I put it in the attachment.

@Christian, can you have a try with the patch? It can be applied
cleanly on 6.11-rc6

Regards
Xiao

--000000000000d79b2306267942a7
Content-Type: application/octet-stream; 
	name="md_raid5_one_bitmap_claim_per_stripe_head.patch"
Content-Disposition: attachment; 
	filename="md_raid5_one_bitmap_claim_per_stripe_head.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_m3a39dcg0>
X-Attachment-Id: f_m3a39dcg0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvcmFpZDUuYyBiL2RyaXZlcnMvbWQvcmFpZDUuYwppbmRl
eCBjMTRjZjI0MTAzNjUuLjZlMzE4NTk4YTdiNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlk
NS5jCisrKyBiL2RyaXZlcnMvbWQvcmFpZDUuYwpAQCAtMzU0OCw3ICszNTQ4LDcgQEAgc3RhdGlj
IHZvaWQgX19hZGRfc3RyaXBlX2JpbyhzdHJ1Y3Qgc3RyaXBlX2hlYWQgKnNoLCBzdHJ1Y3QgYmlv
ICpiaSwKIAkJICgqYmlwKS0+YmlfaXRlci5iaV9zZWN0b3IsIHNoLT5zZWN0b3IsIGRkX2lkeCwK
IAkJIHNoLT5kZXZbZGRfaWR4XS5zZWN0b3IpOwogCi0JaWYgKGNvbmYtPm1kZGV2LT5iaXRtYXAg
JiYgZmlyc3R3cml0ZSkgeworCWlmIChjb25mLT5tZGRldi0+Yml0bWFwICYmIGZpcnN0d3JpdGUg
JiYgIXRlc3RfYW5kX3NldF9iaXQoU1RSSVBFX0JJVE1BUF9DTEFJTSwgJnNoLT5zdGF0ZSkpIHsK
IAkJLyogQ2Fubm90IGhvbGQgc3BpbmxvY2sgb3ZlciBiaXRtYXBfc3RhcnR3cml0ZSwKIAkJICog
YnV0IG11c3QgZW5zdXJlIHRoaXMgaXNuJ3QgYWRkZWQgdG8gYSBiYXRjaCB1bnRpbAogCQkgKiB3
ZSBoYXZlIGFkZGVkIHRvIHRoZSBiaXRtYXAgYW5kIHNldCBibV9zZXEuCkBAIC0zNjIxLDcgKzM2
MjEsNiBAQCBoYW5kbGVfZmFpbGVkX3N0cmlwZShzdHJ1Y3QgcjVjb25mICpjb25mLCBzdHJ1Y3Qg
c3RyaXBlX2hlYWQgKnNoLAogCUJVR19PTihzaC0+YmF0Y2hfaGVhZCk7CiAJZm9yIChpID0gZGlz
a3M7IGktLTsgKSB7CiAJCXN0cnVjdCBiaW8gKmJpOwotCQlpbnQgYml0bWFwX2VuZCA9IDA7CiAK
IAkJaWYgKHRlc3RfYml0KFI1X1JlYWRFcnJvciwgJnNoLT5kZXZbaV0uZmxhZ3MpKSB7CiAJCQlz
dHJ1Y3QgbWRfcmRldiAqcmRldiA9IGNvbmYtPmRpc2tzW2ldLnJkZXY7CkBAIC0zNjQ2LDggKzM2
NDUsNiBAQCBoYW5kbGVfZmFpbGVkX3N0cmlwZShzdHJ1Y3QgcjVjb25mICpjb25mLCBzdHJ1Y3Qg
c3RyaXBlX2hlYWQgKnNoLAogCQlzaC0+ZGV2W2ldLnRvd3JpdGUgPSBOVUxMOwogCQlzaC0+b3Zl
cndyaXRlX2Rpc2tzID0gMDsKIAkJc3Bpbl91bmxvY2tfaXJxKCZzaC0+c3RyaXBlX2xvY2spOwot
CQlpZiAoYmkpCi0JCQliaXRtYXBfZW5kID0gMTsKIAogCQlsb2dfc3RyaXBlX3dyaXRlX2Zpbmlz
aGVkKHNoKTsKIApAQCAtMzY2MiwxMCArMzY1OSw2IEBAIGhhbmRsZV9mYWlsZWRfc3RyaXBlKHN0
cnVjdCByNWNvbmYgKmNvbmYsIHN0cnVjdCBzdHJpcGVfaGVhZCAqc2gsCiAJCQliaW9faW9fZXJy
b3IoYmkpOwogCQkJYmkgPSBuZXh0Ymk7CiAJCX0KLQkJaWYgKGJpdG1hcF9lbmQpCi0JCQltZF9i
aXRtYXBfZW5kd3JpdGUoY29uZi0+bWRkZXYtPmJpdG1hcCwgc2gtPnNlY3RvciwKLQkJCQkJICAg
UkFJRDVfU1RSSVBFX1NFQ1RPUlMoY29uZiksIDAsIDApOwotCQliaXRtYXBfZW5kID0gMDsKIAkJ
LyogYW5kIGZhaWwgYWxsICd3cml0dGVuJyAqLwogCQliaSA9IHNoLT5kZXZbaV0ud3JpdHRlbjsK
IAkJc2gtPmRldltpXS53cml0dGVuID0gTlVMTDsKQEAgLTM2NzQsNyArMzY2Nyw2IEBAIGhhbmRs
ZV9mYWlsZWRfc3RyaXBlKHN0cnVjdCByNWNvbmYgKmNvbmYsIHN0cnVjdCBzdHJpcGVfaGVhZCAq
c2gsCiAJCQlzaC0+ZGV2W2ldLnBhZ2UgPSBzaC0+ZGV2W2ldLm9yaWdfcGFnZTsKIAkJfQogCi0J
CWlmIChiaSkgYml0bWFwX2VuZCA9IDE7CiAJCXdoaWxlIChiaSAmJiBiaS0+YmlfaXRlci5iaV9z
ZWN0b3IgPAogCQkgICAgICAgc2gtPmRldltpXS5zZWN0b3IgKyBSQUlENV9TVFJJUEVfU0VDVE9S
Uyhjb25mKSkgewogCQkJc3RydWN0IGJpbyAqYmkyID0gcjVfbmV4dF9iaW8oY29uZiwgYmksIHNo
LT5kZXZbaV0uc2VjdG9yKTsKQEAgLTM3MDgsMTQgKzM3MDAsMTUgQEAgaGFuZGxlX2ZhaWxlZF9z
dHJpcGUoc3RydWN0IHI1Y29uZiAqY29uZiwgc3RydWN0IHN0cmlwZV9oZWFkICpzaCwKIAkJCQli
aSA9IG5leHRiaTsKIAkJCX0KIAkJfQotCQlpZiAoYml0bWFwX2VuZCkKLQkJCW1kX2JpdG1hcF9l
bmR3cml0ZShjb25mLT5tZGRldi0+Yml0bWFwLCBzaC0+c2VjdG9yLAotCQkJCQkgICBSQUlENV9T
VFJJUEVfU0VDVE9SUyhjb25mKSwgMCwgMCk7CiAJCS8qIElmIHdlIHdlcmUgaW4gdGhlIG1pZGRs
ZSBvZiBhIHdyaXRlIHRoZSBwYXJpdHkgYmxvY2sgbWlnaHQKIAkJICogc3RpbGwgYmUgbG9ja2Vk
IC0gc28ganVzdCBjbGVhciBhbGwgUjVfTE9DS0VEIGZsYWdzCiAJCSAqLwogCQljbGVhcl9iaXQo
UjVfTE9DS0VELCAmc2gtPmRldltpXS5mbGFncyk7CiAJfQorCWlmICh0ZXN0X2FuZF9jbGVhcl9i
aXQoU1RSSVBFX0JJVE1BUF9DTEFJTSwgJnNoLT5zdGF0ZSkpIHsKKwkJbWRfYml0bWFwX2VuZHdy
aXRlKGNvbmYtPm1kZGV2LT5iaXRtYXAsIHNoLT5zZWN0b3IsCisJCQkJICAgUkFJRDVfU1RSSVBF
X1NFQ1RPUlMoY29uZiksIDAsIDApOworCX0KIAlzLT50b193cml0ZSA9IDA7CiAJcy0+d3JpdHRl
biA9IDA7CiAKQEAgLTQwNTksMTAgKzQwNTIsNiBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfc3RyaXBl
X2NsZWFuX2V2ZW50KHN0cnVjdCByNWNvbmYgKmNvbmYsCiAJCQkJCWJpb19lbmRpbyh3YmkpOwog
CQkJCQl3YmkgPSB3YmkyOwogCQkJCX0KLQkJCQltZF9iaXRtYXBfZW5kd3JpdGUoY29uZi0+bWRk
ZXYtPmJpdG1hcCwgc2gtPnNlY3RvciwKLQkJCQkJCSAgIFJBSUQ1X1NUUklQRV9TRUNUT1JTKGNv
bmYpLAotCQkJCQkJICAgIXRlc3RfYml0KFNUUklQRV9ERUdSQURFRCwgJnNoLT5zdGF0ZSksCi0J
CQkJCQkgICAwKTsKIAkJCQlpZiAoaGVhZF9zaC0+YmF0Y2hfaGVhZCkgewogCQkJCQlzaCA9IGxp
c3RfZmlyc3RfZW50cnkoJnNoLT5iYXRjaF9saXN0LAogCQkJCQkJCSAgICAgIHN0cnVjdCBzdHJp
cGVfaGVhZCwKQEAgLTQwNzcsNyArNDA2NiwxMSBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfc3RyaXBl
X2NsZWFuX2V2ZW50KHN0cnVjdCByNWNvbmYgKmNvbmYsCiAJCQl9IGVsc2UgaWYgKHRlc3RfYml0
KFI1X0Rpc2NhcmQsICZkZXYtPmZsYWdzKSkKIAkJCQlkaXNjYXJkX3BlbmRpbmcgPSAxOwogCQl9
Ci0KKwlpZiAodGVzdF9hbmRfY2xlYXJfYml0KFNUUklQRV9CSVRNQVBfQ0xBSU0sICZzaC0+c3Rh
dGUpKSB7CisJCW1kX2JpdG1hcF9lbmR3cml0ZShjb25mLT5tZGRldi0+Yml0bWFwLCBzaC0+c2Vj
dG9yLAorCQkJCSAgIFJBSUQ1X1NUUklQRV9TRUNUT1JTKGNvbmYpLAorCQkJCSAgICF0ZXN0X2Jp
dChTVFJJUEVfREVHUkFERUQsICZzaC0+c3RhdGUpLCAwKTsKKwl9CiAJbG9nX3N0cmlwZV93cml0
ZV9maW5pc2hlZChzaCk7CiAKIAlpZiAoIWRpc2NhcmRfcGVuZGluZyAmJgpAQCAtNTc4OCwxMyAr
NTc4MSwxMSBAQCBzdGF0aWMgdm9pZCBtYWtlX2Rpc2NhcmRfcmVxdWVzdChzdHJ1Y3QgbWRkZXYg
Km1kZGV2LCBzdHJ1Y3QgYmlvICpiaSkKIAkJfQogCQlzcGluX3VubG9ja19pcnEoJnNoLT5zdHJp
cGVfbG9jayk7CiAJCWlmIChjb25mLT5tZGRldi0+Yml0bWFwKSB7Ci0JCQlmb3IgKGQgPSAwOwot
CQkJICAgICBkIDwgY29uZi0+cmFpZF9kaXNrcyAtIGNvbmYtPm1heF9kZWdyYWRlZDsKLQkJCSAg
ICAgZCsrKQotCQkJCW1kX2JpdG1hcF9zdGFydHdyaXRlKG1kZGV2LT5iaXRtYXAsCi0JCQkJCQkg
ICAgIHNoLT5zZWN0b3IsCi0JCQkJCQkgICAgIFJBSUQ1X1NUUklQRV9TRUNUT1JTKGNvbmYpLAot
CQkJCQkJICAgICAwKTsKKwkJCXNldF9iaXQoU1RSSVBFX0JJVE1BUF9DTEFJTSwgJnNoLT5zdGF0
ZSk7CisJCQltZF9iaXRtYXBfc3RhcnR3cml0ZShtZGRldi0+Yml0bWFwLAorCQkJCQkgICAgIHNo
LT5zZWN0b3IsCisJCQkJCSAgICAgUkFJRDVfU1RSSVBFX1NFQ1RPUlMoY29uZiksCisJCQkJCSAg
ICAgMCk7CiAJCQlzaC0+Ym1fc2VxID0gY29uZi0+c2VxX2ZsdXNoICsgMTsKIAkJCXNldF9iaXQo
U1RSSVBFX0JJVF9ERUxBWSwgJnNoLT5zdGF0ZSk7CiAJCX0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bWQvcmFpZDUuaCBiL2RyaXZlcnMvbWQvcmFpZDUuaAppbmRleCA5YjVhN2RjM2YyYTAuLjgzMGQ1
YjMzYTRmYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9yYWlkNS5oCisrKyBiL2RyaXZlcnMvbWQv
cmFpZDUuaApAQCAtMzk5LDYgKzM5OSw5IEBAIGVudW0gewogCQkJCSAqIGluIGNvbmYtPnI1Y19m
dWxsX3N0cmlwZV9saXN0KQogCQkJCSAqLwogCVNUUklQRV9SNUNfUFJFRkxVU0gsCS8qIG5lZWQg
dG8gZmx1c2ggam91cm5hbCBkZXZpY2UgKi8KKwlTVFJJUEVfQklUTUFQX0NMQUlNLAkvKiBIYXMg
YSBjbGFpbSBvbiB0aGUgYml0bWFwIHdoaWNoIHdpbGwgbmVlZCB0bworCQkJCSAqIGJlIHJlbGVh
c2VkCisJCQkJICovCiB9OwogCiAjZGVmaW5lIFNUUklQRV9FWFBBTkRfU1lOQ19GTEFHUyBcCg==

--000000000000d79b2306267942a7--

