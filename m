Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9686410E5
	for <dm-devel@lists.linux.dev>; Sat, 26 Oct 2024 12:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729944501; cv=none; b=We0cxC2tibSHAz5mHkNiaQgn/a4q/5XYGAm7L3zOekBRNxaRcBizIu27nIIMKFdULVeqwJln/cDCZazpHHZV/FlOMWyu/W1N4tMYZ0ELbKgyiutTbG6a2X7fSCH8xPGNCbB/+od/55zxvSibqV1U9h8a0P9T9++v9WQySB0WfR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729944501; c=relaxed/simple;
	bh=05y5b2qb/+GNAxuITCws9Co+5hGhtRDK5jCGPhvQ4tE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BJvvrVyWtfhNHX3OgTJ1uCbBQNp1qN/Pra3p45dUTJ6LJ9fVTLYtscMSPIGxoJOf8zXHkmsECV98q02UroU1Zv/KhyZLxPIURZGsUy1o3DPZjxHXy2rlUzmpSSnYsFebZxsa0XT6OL+RRfo+vwhoe7p2p9ABWUcpSLbagl0GCxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=ajaQNbPY; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="ajaQNbPY"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1729944495;
	bh=1CyHuSwN0gUIoW6VugDa3hFK0S+UCpr+RSLTbF+Db/E=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=ajaQNbPY2k9k5M+yBku+wTZHHXCkvrRCaPkPR9T7EC5erIPJcdxbe2TD2mP0Gi5GO
	 QZK4SPBBEJU8itfHVzwLt9RKow419qM8N3dBOu+OwHHJf4toWV2IusAEj6ay250N74
	 FuKWyp89F6ZunvbaQiIXwnCNXE6mg57pCBIoyzWM=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
Date: Sat, 26 Oct 2024 14:07:53 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io>
 <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
 <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
 <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
 <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
 <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
 <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
 <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

I can=E2=80=99t apply this on 6.10.5 and trying to manually reconstruct =
your patch lets me directly stumble into:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c14cf2410365..ce5466d4791a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2366,7 +2366,7 @@ static struct stripe_head *alloc_stripe(struct =
kmem_cache *sc, gfp_t gfp,
                INIT_LIST_HEAD(&sh->lru);
                INIT_LIST_HEAD(&sh->r5c);
                INIT_LIST_HEAD(&sh->log_list);
-               atomic_set(&sh->count, 1);
+               atomic_set(&sh->count, 0);
                sh->raid_conf =3D conf;
                sh->log_start =3D MaxSector;

Which version is your patch based on?

Christian

> On 26. Oct 2024, at 11:07, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/10/26 13:37, Christian Theune =E5=86=99=E9=81=93:
>>> On 25. Oct 2024, at 16:02, Christian Theune <ct@flyingcircus.io> =
wrote:
>>>=20
>>> Yeah, this was more directed towards the question whether Yu needs =
me to run the patch that he posted earlier.
>>>=20
>>> So. The current status is: previously this crashed within 2-3 hours. =
Both machines are now running with the bitmap turned off as described =
above and have been syncing data for about 7 hours. This seems to =
indicate that the bitmap is involved here.
>> Update: both machines have been able to finish their multi-TiB rsync =
job that previously caused reliable lockups. So: the bitmap code seems =
to be the culprit here =E2=80=A6
>> Christian
>=20
> Then, can you enable bitmap and test the following debug patch:
>=20
> Thanks,
> Kuai
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 58f71c3e1368..b2a75a904209 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2369,6 +2369,7 @@ static struct stripe_head *alloc_stripe(struct =
kmem_cache *sc, gfp_t gfp,
>                atomic_set(&sh->count, 1);
>                sh->raid_conf =3D conf;
>                sh->log_start =3D MaxSector;
> +               atomic_set(&sh->bitmap_counts, 0);
>=20
>                if (raid5_has_ppl(conf)) {
>                        sh->ppl_page =3D alloc_page(gfp);
> @@ -3565,6 +3566,7 @@ static void __add_stripe_bio(struct stripe_head =
*sh, struct bio *bi,
>                spin_unlock_irq(&sh->stripe_lock);
>                conf->mddev->bitmap_ops->startwrite(conf->mddev, =
sh->sector,
>                                        RAID5_STRIPE_SECTORS(conf), =
false);
> +               printk("%s: %s: start %px(%llu+%lu) %u\n", __func__, =
mdname(conf->mddev), sh, sh->sector, RAID5_STRIPE_SECTORS(conf), =
atomic_inc_return(&sh->bitmap_counts));
>                spin_lock_irq(&sh->stripe_lock);
>                clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
>                if (!sh->batch_head) {
> @@ -3662,10 +3664,12 @@ handle_failed_stripe(struct r5conf *conf, =
struct stripe_head *sh,
>                        bio_io_error(bi);
>                        bi =3D nextbi;
>                }
> -               if (bitmap_end)
> +               if (bitmap_end) {
>                        conf->mddev->bitmap_ops->endwrite(conf->mddev,
>                                        sh->sector, =
RAID5_STRIPE_SECTORS(conf),
>                                        false, false);
> +                       printk("%s: %s: end %px(%llu+%lu) %u\n", =
__func__, mdname(conf->mddev), sh, sh->sector, =
RAID5_STRIPE_SECTORS(conf), atomic_dec_return(&sh->bitmap_counts));
> +               }
>                bitmap_end =3D 0;
>                /* and fail all 'written' */
>                bi =3D sh->dev[i].written;
> @@ -3709,10 +3713,12 @@ handle_failed_stripe(struct r5conf *conf, =
struct stripe_head *sh,
>                                bi =3D nextbi;
>                        }
>                }
> -               if (bitmap_end)
> +               if (bitmap_end) {
>                        conf->mddev->bitmap_ops->endwrite(conf->mddev,
>                                        sh->sector, =
RAID5_STRIPE_SECTORS(conf),
>                                        false, false);
> +                       printk("%s: %s: end %px(%llu+%lu) %u\n", =
__func__, mdname(conf->mddev), sh, sh->sector, =
RAID5_STRIPE_SECTORS(conf), atomic_dec_return(&sh->bitmap_counts));
> +               }
>                /* If we were in the middle of a write the parity block =
might
>                 * still be locked - so just clear all R5_LOCKED flags
>                 */
> @@ -4065,6 +4071,7 @@ static void handle_stripe_clean_event(struct =
r5conf *conf,
>                                        sh->sector, =
RAID5_STRIPE_SECTORS(conf),
>                                        !test_bit(STRIPE_DEGRADED, =
&sh->state),
>                                        false);
> +                               printk("%s: %s: end %px(%llu+%lu) =
%u\n", __func__, mdname(conf->mddev), sh, sh->sector, =
RAID5_STRIPE_SECTORS(conf), atomic_dec_return(&sh->bitmap_counts));
>                                if (head_sh->batch_head) {
>                                        sh =3D =
list_first_entry(&sh->batch_list,
>                                                              struct =
stripe_head,
> @@ -5785,9 +5792,11 @@ static void make_discard_request(struct mddev =
*mddev, struct bio *bi)
>                spin_unlock_irq(&sh->stripe_lock);
>                if (conf->mddev->bitmap) {
>                        for (d =3D 0; d < conf->raid_disks - =
conf->max_degraded;
> -                            d++)
> +                            d++) {
>                                mddev->bitmap_ops->startwrite(mddev, =
sh->sector,
>                                        RAID5_STRIPE_SECTORS(conf), =
false);
> +                               printk("%s: %s: start %px(%llu+%lu) =
%u\n", __func__, mdname(conf->mddev), sh, sh->sector, =
RAID5_STRIPE_SECTORS(conf), atomic_inc_return(&sh->bitmap_counts));
> +                       }
>                        sh->bm_seq =3D conf->seq_flush + 1;
>                        set_bit(STRIPE_BIT_DELAY, &sh->state);
>                }
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 896ecfc4afa6..12024249245e 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -255,6 +255,7 @@ struct stripe_head {
>        int     nr_pages;       /* page array size */
>        int     stripes_per_page;
> #endif
> +       atomic_t bitmap_counts;
>        struct r5dev {
>                /* rreq and rvec are used for the replacement device =
when
>                 * writing data to both devices.


Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

