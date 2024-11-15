Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE251DFFD
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 08:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731658043; cv=none; b=bFvRIF/Bc7WYGfhg1OHbI5vFqgI6qreTYUaW12I5nJR0NlJdSHw3HumcAJiFzfH87VLNKB+FltkAOEt3aPaYp0eEq9T0p3OGsJUb0rARB2jWuYZXrRI65KiiMH76m/fGMy/MWlyMBEGRCqBS2B6ntzazW0F+S9qBwnQqR36BVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731658043; c=relaxed/simple;
	bh=AhpOjDijHu4ef74HFg9Lz2wQjj9RLQmqvlRAOu27qp4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AO2geQhh91GdTx6rmVl6/ofa9jYL+4lmgG/d8QMS7lmX89Yjy8RrJZeWBSVWlb8tF7SMz/kOBXZCPtc27h9eVqO9fd3/sv1M9h6plv9z5pJSOilWbk6yi0npco5h/KV7Oszm3GwdS5Y6lc98yv8D3L+XIxTAl1Gux/F6OPGKl1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfdXZiwr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfdXZiwr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731658038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KpkmYBK4AScWbiZs8BhOtPl7mmfvoP8pqpyrDDiVHVU=;
	b=IfdXZiwrX95W4fE4anqBpOP+yTBMB6kUgUG0wk0myhCdGFABDE8mOVpFxDVeYl+dNoumoB
	2/jWdBXAoOq6h6ymAIiLAAoVeKxIqNKL3BKV4wCEgYhagTeiokAOy3cgl9oP43opOJZIjV
	n/JSMcn2xMOx4gBaZ+7Un6pULEUbqfk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-JTsKt2RtO0Whsi_ZnVZRmw-1; Fri, 15 Nov 2024 03:07:16 -0500
X-MC-Unique: JTsKt2RtO0Whsi_ZnVZRmw-1
X-Mimecast-MFC-AGG-ID: JTsKt2RtO0Whsi_ZnVZRmw
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2fb51681ac6so8078641fa.1
        for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 00:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731658034; x=1732262834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KpkmYBK4AScWbiZs8BhOtPl7mmfvoP8pqpyrDDiVHVU=;
        b=qFmoLSS3lLufWynr2M6pH47ltvJVZDPXRST0PcPgd30MKd6i8yu1Y8AAOcHZ9qiZ9/
         /5v/x+0cTLA3Ts3RgJ64LZdOGyVC2bdGndxIA2xvYGNBKoo3dpTnEplH2iYbldtRI58a
         N4woDfzdenRbEdZ7jOjYrxGSlLMmmB+WN+oZfKJGmkdOHgwBX5a6RNRiMiqy9tI3NERl
         oLYSb4R6+aSJLC6MzXorU4YzmaSdMjfSnhwIig5KaPEbVq2fdcvQqLofWS7tTL2CRFeo
         BQQi133TLYNyOmoiiUwzWbkOpQ2DHV4ywvLeGmEkA0Q57GT7A4F8emFOKeM+aiPAs2WD
         4o5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVc6hsjOu3CqOdHIaVtCBPXxCRKgHHi5p+Fbu8oE69ZRN92Vb9EuMndunfkp3tNpf6LnyD2ZeOX2Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwaA1cd+QvtcACqeQFt6yqTtvTsngC/zzJm3Y6vkEPaxR2FpO3N
	n8xmbPz+yoLHv/LUCXoJqfWBeOuzDodqeX71Dsy+W0gGU6P9MHNloKlLGFKReXhdS7+DoJaQ3rE
	jdcobz4JfAIPxeTBV74NEoUhYjPSzSICvKYRRw05qU9n9s7QZfKw697r9I2aauRSFHccWL9CyOb
	L5jJo6UAOL6g47QdY25jzJnJuxP+sdJg0=
X-Received: by 2002:a2e:a994:0:b0:2ff:5d7d:81a2 with SMTP id 38308e7fff4ca-2ff6064da71mr6702181fa.5.1731658034242;
        Fri, 15 Nov 2024 00:07:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHu5w2TFIAtmcUHRQH8FDrpEb0hMHzphWbFUzZfghgmstv6+o14uTorvrydJ8Nh3+w0gSKt06iG9utPdcn+RHA=
X-Received: by 2002:a2e:a994:0:b0:2ff:5d7d:81a2 with SMTP id
 38308e7fff4ca-2ff6064da71mr6702001fa.5.1731658033734; Fri, 15 Nov 2024
 00:07:13 -0800 (PST)
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
 <CALTww28iP_pGU7jmhZrXX9D-xL5Xb6w=9jLxS=fvv_6HgqZ6qw@mail.gmail.com>
 <09338D11-6B73-4C4B-A19A-6BDC6489C91D@flyingcircus.io> <C3A9A473-0F0E-4168-BB96-5AB140C6A9FC@flyingcircus.io>
 <0B1D29D1-523C-4E42-95F9-62B32B741930@flyingcircus.io> <4DA6F1FE-D465-40C7-A116-F49CF6A2CFF0@flyingcircus.io>
In-Reply-To: <4DA6F1FE-D465-40C7-A116-F49CF6A2CFF0@flyingcircus.io>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 15 Nov 2024 16:07:01 +0800
Message-ID: <CALTww292Dwduh=k1W4=u+N2K6WYK7RXQyPWG3Yn-JpLY9QDbDQ@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, John Stoffel <john@stoffel.org>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	=?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>, 
	David Jeffery <djeffery@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 44RE10jDao-L0egbf0x842s7Bx0tXOElUOc_6myr11E_1731658035
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 11:07=E2=80=AFPM Christian Theune <ct@flyingcircus.=
io> wrote:
>
> Hi,
>
> just a followup: the system ran over 2 days without my workload being abl=
e to trigger the issue. I=E2=80=99ve seen there is another thread where thi=
s patch wasn=E2=80=99t sufficient and if i understand correctly, Yu and Xia=
o are working on an amalgamated fix?
>
> Christian

Hi Christian

Beside the bitmap stuck problem, the other thread has a new problem.
But it looks like you don't have the new problem because you already
ran without failure for 2 days. I'll send patches against 6.13 and
6.11.

Regards
Xiao

>
> > On 12. Nov 2024, at 07:57, Christian Theune <ct@flyingcircus.io> wrote:
> >
> > Hi,
> >
> > my workload has been running for 22 hours now successfully - it seems t=
hat the patch works.
> >
> > If this gets accepted then I=E2=80=99d kindly ask for an LTS backport t=
o 6.6.
> >
> > Thanks to everyone for helping figuring this out and fixing it!
> >
> > Christian
> >
> >> On 11. Nov 2024, at 15:34, Christian Theune <ct@flyingcircus.io> wrote=
:
> >>
> >> I=E2=80=99ve been running withy my workflow that is known to trigger t=
he issue reliably for about 6 hours now. This is longer than it worked befo=
re.
> >> I=E2=80=99m leaving the office for today and will leave things running=
 over night and report back tomorrow.
> >>
> >> Christian
> >>
> >>> On 11. Nov 2024, at 09:00, Christian Theune <ct@flyingcircus.io> wrot=
e:
> >>>
> >>> Hi,
> >>>
> >>> I=E2=80=99m trying this with 6.11.7 today.
> >>>
> >>> Christian
> >>>
> >>>> On 9. Nov 2024, at 12:35, Xiao Ni <xni@redhat.com> wrote:
> >>>>
> >>>> On Thu, Nov 7, 2024 at 3:55=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.=
com> wrote:
> >>>>>
> >>>>> Hi!
> >>>>>
> >>>>> =E5=9C=A8 2024/11/06 14:40, Christian Theune =E5=86=99=E9=81=93:
> >>>>>> Hi,
> >>>>>>
> >>>>>>> On 6. Nov 2024, at 07:35, Yu Kuai <yukuai1@huaweicloud.com> wrote=
:
> >>>>>>>
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> =E5=9C=A8 2024/11/05 18:15, Christian Theune =E5=86=99=E9=81=93:
> >>>>>>>> Hi,
> >>>>>>>> after about 2 hours it stalled again. Here=E2=80=99s the full bl=
ocked process dump. (Tell me if this isn=E2=80=99t helpful, otherwise I=E2=
=80=99ll keep posting that as it=E2=80=99s the only real data I can show)
> >>>>>>>
> >>>>>>> This is bad news :(
> >>>>>>
> >>>>>> Yeah. But: the good new is that we aren=E2=80=99t eating any data =
so far =E2=80=A6 ;)
> >>>>>>
> >>>>>>> While reviewing related code, I come up with a plan to move bitma=
p
> >>>>>>> start/end write ops to the upper layer. Make sure each write IO f=
rom
> >>>>>>> upper layer only start once and end once, this is easy to make su=
re
> >>>>>>> they are balanced and can avoid many calls to improve performance=
 as
> >>>>>>> well.
> >>>>>>
> >>>>>> Sounds like a plan!
> >>>>>>
> >>>>>>> However, I need a few days to cooke a patch after work.
> >>>>>>
> >>>>>> Sure thing! I=E2=80=99ll switch off bitmaps for that time - I=E2=
=80=99m happy we found a workaround so we can take time to resolve it clean=
ly. :)
> >>>>>
> >>>>> I wrote a simple and crude version, please give it a test again.
> >>>>>
> >>>>> Thanks,
> >>>>> Kuai
> >>>>>
> >>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>>>> index d3a837506a36..5e1a82b79e41 100644
> >>>>> --- a/drivers/md/md.c
> >>>>> +++ b/drivers/md/md.c
> >>>>> @@ -8753,6 +8753,30 @@ void md_submit_discard_bio(struct mddev *mdd=
ev,
> >>>>> struct md_rdev *rdev,
> >>>>> }
> >>>>> EXPORT_SYMBOL_GPL(md_submit_discard_bio);
> >>>>>
> >>>>> +static bool is_raid456(struct mddev *mddev)
> >>>>> +{
> >>>>> +       return mddev->pers->level =3D=3D 4 || mddev->pers->level =
=3D=3D 5 ||
> >>>>> +              mddev->pers->level =3D=3D 6;
> >>>>> +}
> >>>>> +
> >>>>> +static void bitmap_startwrite(struct mddev *mddev, struct bio *bio=
)
> >>>>> +{
> >>>>> +       if (!is_raid456(mddev) || !mddev->bitmap)
> >>>>> +               return;
> >>>>> +
> >>>>> +       md_bitmap_startwrite(mddev->bitmap, bio_offset(bio),
> >>>>> bio_sectors(bio),
> >>>>> +                            0);
> >>>>> +}
> >>>>> +
> >>>>> +static void bitmap_endwrite(struct mddev *mddev, struct bio *bio,
> >>>>> sector_t sectors)
> >>>>> +{
> >>>>> +       if (!is_raid456(mddev) || !mddev->bitmap)
> >>>>> +               return;
> >>>>> +
> >>>>> +       md_bitmap_endwrite(mddev->bitmap, bio_offset(bio), sectors,=
o
> >>>>> +                          bio->bi_status =3D=3D BLK_STS_OK, 0);
> >>>>> +}
> >>>>> +
> >>>>> static void md_end_clone_io(struct bio *bio)
> >>>>> {
> >>>>>     struct md_io_clone *md_io_clone =3D bio->bi_private;
> >>>>> @@ -8765,6 +8789,7 @@ static void md_end_clone_io(struct bio *bio)
> >>>>>     if (md_io_clone->start_time)
> >>>>>             bio_end_io_acct(orig_bio, md_io_clone->start_time);
> >>>>>
> >>>>> +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
> >>>>>     bio_put(bio);
> >>>>>     bio_endio(orig_bio);
> >>>>>     percpu_ref_put(&mddev->active_io);
> >>>>> @@ -8778,6 +8803,7 @@ static void md_clone_bio(struct mddev *mddev,
> >>>>> struct bio **bio)
> >>>>>             bio_alloc_clone(bdev, *bio, GFP_NOIO,
> >>>>> &mddev->io_clone_set);
> >>>>>
> >>>>>     md_io_clone =3D container_of(clone, struct md_io_clone, bio_clo=
ne);
> >>>>> +       md_io_clone->sectors =3D bio_sectors(*bio);
> >>>>>     md_io_clone->orig_bio =3D *bio;
> >>>>>     md_io_clone->mddev =3D mddev;
> >>>>>     if (blk_queue_io_stat(bdev->bd_disk->queue))
> >>>>> @@ -8790,6 +8816,7 @@ static void md_clone_bio(struct mddev *mddev,
> >>>>> struct bio **bio)
> >>>>>
> >>>>> void md_account_bio(struct mddev *mddev, struct bio **bio)
> >>>>> {
> >>>>> +       bitmap_startwrite(mddev, *bio);
> >>>>>     percpu_ref_get(&mddev->active_io);
> >>>>>     md_clone_bio(mddev, bio);
> >>>>> }
> >>>>> @@ -8807,6 +8834,8 @@ void md_free_cloned_bio(struct bio *bio)
> >>>>>     if (md_io_clone->start_time)
> >>>>>             bio_end_io_acct(orig_bio, md_io_clone->start_time);
> >>>>>
> >>>>> +       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
> >>>>> +
> >>>>>     bio_put(bio);
> >>>>>     percpu_ref_put(&mddev->active_io);
> >>>>> }
> >>>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >>>>> index a0d6827dced9..0c2794230e0a 100644
> >>>>> --- a/drivers/md/md.h
> >>>>> +++ b/drivers/md/md.h
> >>>>> @@ -837,6 +837,7 @@ struct md_io_clone {
> >>>>>     struct mddev    *mddev;
> >>>>>     struct bio      *orig_bio;
> >>>>>     unsigned long   start_time;
> >>>>> +       sector_t        sectors;
> >>>>>     struct bio      bio_clone;
> >>>>> };
> >>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >>>>> index c14cf2410365..4f009e32f68a 100644
> >>>>> --- a/drivers/md/raid5.c
> >>>>> +++ b/drivers/md/raid5.c
> >>>>> @@ -3561,12 +3561,6 @@ static void __add_stripe_bio(struct stripe_h=
ead
> >>>>> *sh, struct bio *bi,
> >>>>>              * is added to a batch, STRIPE_BIT_DELAY cannot be chan=
ged
> >>>>>              * any more.
> >>>>>              */
> >>>>> -               set_bit(STRIPE_BITMAP_PENDING, &sh->state);
> >>>>> -               spin_unlock_irq(&sh->stripe_lock);
> >>>>> -               md_bitmap_startwrite(conf->mddev->bitmap, sh->secto=
r,
> >>>>> -                                    RAID5_STRIPE_SECTORS(conf), 0)=
;
> >>>>> -               spin_lock_irq(&sh->stripe_lock);
> >>>>> -               clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
> >>>>>             if (!sh->batch_head) {
> >>>>>                     sh->bm_seq =3D conf->seq_flush+1;
> >>>>>                     set_bit(STRIPE_BIT_DELAY, &sh->state);
> >>>>> @@ -3621,7 +3615,6 @@ handle_failed_stripe(struct r5conf *conf, str=
uct
> >>>>> stripe_head *sh,
> >>>>>     BUG_ON(sh->batch_head);
> >>>>>     for (i =3D disks; i--; ) {
> >>>>>             struct bio *bi;
> >>>>> -               int bitmap_end =3D 0;
> >>>>>
> >>>>>             if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
> >>>>>                     struct md_rdev *rdev =3D conf->disks[i].rdev;
> >>>>> @@ -3646,8 +3639,6 @@ handle_failed_stripe(struct r5conf *conf, str=
uct
> >>>>> stripe_head *sh,
> >>>>>             sh->dev[i].towrite =3D NULL;
> >>>>>             sh->overwrite_disks =3D 0;
> >>>>>             spin_unlock_irq(&sh->stripe_lock);
> >>>>> -               if (bi)
> >>>>> -                       bitmap_end =3D 1;
> >>>>>
> >>>>>             log_stripe_write_finished(sh);
> >>>>> @@ -3662,10 +3653,6 @@ handle_failed_stripe(struct r5conf *conf, st=
ruct
> >>>>> stripe_head *sh,
> >>>>>                     bio_io_error(bi);
> >>>>>                     bi =3D nextbi;
> >>>>>             }
> >>>>> -               if (bitmap_end)
> >>>>> -                       md_bitmap_endwrite(conf->mddev->bitmap, sh-=
>sector,
> >>>>> -                                          RAID5_STRIPE_SECTORS(con=
f),
> >>>>> 0, 0);
> >>>>> -               bitmap_end =3D 0;
> >>>>>             /* and fail all 'written' */
> >>>>>             bi =3D sh->dev[i].written;
> >>>>>             sh->dev[i].written =3D NULL;
> >>>>> @@ -3674,7 +3661,6 @@ handle_failed_stripe(struct r5conf *conf, str=
uct
> >>>>> stripe_head *sh,
> >>>>>                     sh->dev[i].page =3D sh->dev[i].orig_page;
> >>>>>             }
> >>>>>
> >>>>> -               if (bi) bitmap_end =3D 1;
> >>>>>             while (bi && bi->bi_iter.bi_sector <
> >>>>>                    sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) =
{
> >>>>>                     struct bio *bi2 =3D r5_next_bio(conf, bi,
> >>>>> sh->dev[i].sector);
> >>>>> @@ -3708,9 +3694,6 @@ handle_failed_stripe(struct r5conf *conf, str=
uct
> >>>>> stripe_head *sh,
> >>>>>                             bi =3D nextbi;
> >>>>>                     }
> >>>>>             }
> >>>>> -               if (bitmap_end)
> >>>>> -                       md_bitmap_endwrite(conf->mddev->bitmap, sh-=
>sector,
> >>>>> -                                          RAID5_STRIPE_SECTORS(con=
f),
> >>>>> 0, 0);
> >>>>>             /* If we were in the middle of a write the parity block
> >>>>> might
> >>>>>              * still be locked - so just clear all R5_LOCKED flags
> >>>>>              */
> >>>>> @@ -4059,10 +4042,6 @@ static void handle_stripe_clean_event(struct
> >>>>> r5conf *conf,
> >>>>>                                     bio_endio(wbi);
> >>>>>                                     wbi =3D wbi2;
> >>>>>                             }
> >>>>> -                               md_bitmap_endwrite(conf->mddev->bit=
map,
> >>>>> sh->sector,
> >>>>> -
> >>>>> RAID5_STRIPE_SECTORS(conf),
> >>>>> -
> >>>>> !test_bit(STRIPE_DEGRADED, &sh->state),
> >>>>> -                                                  0);
> >>>>>                             if (head_sh->batch_head) {
> >>>>>                                     sh =3D
> >>>>> list_first_entry(&sh->batch_list,
> >>>>>                                                           struct
> >>>>> stripe_head,
> >>>>> @@ -5788,13 +5767,6 @@ static void make_discard_request(struct mdde=
v
> >>>>> *mddev, struct bio *bi)
> >>>>>             }
> >>>>>             spin_unlock_irq(&sh->stripe_lock);
> >>>>>             if (conf->mddev->bitmap) {
> >>>>> -                       for (d =3D 0;
> >>>>> -                            d < conf->raid_disks - conf->max_degra=
ded;
> >>>>> -                            d++)
> >>>>> -                               md_bitmap_startwrite(mddev->bitmap,
> >>>>> -                                                    sh->sector,
> >>>>> -
> >>>>> RAID5_STRIPE_SECTORS(conf),
> >>>>> -                                                    0);
> >>>>>                     sh->bm_seq =3D conf->seq_flush + 1;
> >>>>>                     set_bit(STRIPE_BIT_DELAY, &sh->state);
> >>>>>             }
> >>>>>
> >>>>>
> >>>>>
> >>>>>>
> >>>>>> Thanks a lot for your help!
> >>>>>> Christian
> >>>>>>
> >>>>>
> >>>>>
> >>>>
> >>>> Hi Kuai
> >>>>
> >>>> Maybe it's not good to put the bitmap operation from raid5 to md whi=
ch
> >>>> the new api is only used for raid5. And the bitmap region which raid=
5
> >>>> needs to handle is based on the member disk. It should be calculated
> >>>> rather than the bio address space. Because the bio address space is
> >>>> for the whole array.
> >>>>
> >>>> We have a customer who reports a similar problem. There is a patch
> >>>> from David. I put it in the attachment.
> >>>>
> >>>> @Christian, can you have a try with the patch? It can be applied
> >>>> cleanly on 6.11-rc6
> >>>>
> >>>> Regards
> >>>> Xiao
> >>>> <md_raid5_one_bitmap_claim_per_stripe_head.patch>
> >>>
> >>> Liebe Gr=C3=BC=C3=9Fe,
> >>> Christian Theune
> >>>
> >>> --
> >>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> >>> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> >>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> >>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theu=
ne, Christian Zagrodnick
> >>>
> >>
> >> Liebe Gr=C3=BC=C3=9Fe,
> >> Christian Theune
> >>
> >> --
> >> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> >> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> >> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> >> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theun=
e, Christian Zagrodnick
> >>
> >
> > Liebe Gr=C3=BC=C3=9Fe,
> > Christian Theune
> >
> > --
> > Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> > Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> > Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> > HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune=
, Christian Zagrodnick
> >
> >
>
> Liebe Gr=C3=BC=C3=9Fe,
> Christian Theune
>
> --
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick
>

