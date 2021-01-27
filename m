Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45D5C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 238FB2076E
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 238FB2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339--uFSLEMYMbu7AxaVD37B-Q-1; Wed, 27 Jan 2021 05:02:49 -0500
X-MC-Unique: -uFSLEMYMbu7AxaVD37B-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08489EC1AB;
	Wed, 27 Jan 2021 10:02:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D776C1F40F;
	Wed, 27 Jan 2021 10:02:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A63B550030;
	Wed, 27 Jan 2021 10:02:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10R7NBXj007023 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 02:23:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4DA8B2166B2A; Wed, 27 Jan 2021 07:23:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44B472166B2E
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:23:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C205858287
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:23:08 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-242-eAUU--fTNFGVpmUMMsjCKQ-1;
	Wed, 27 Jan 2021 02:23:04 -0500
X-MC-Unique: eAUU--fTNFGVpmUMMsjCKQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F65B20739;
	Wed, 27 Jan 2021 07:16:05 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id h12so1219637lfp.9;
	Tue, 26 Jan 2021 23:16:05 -0800 (PST)
X-Gm-Message-State: AOAM531RPT/Lo4rUP5QnNI8iE8xzEbtLuIysy8ljwg+VmYsPrbi2JVCf
	tUOETshlr6ajL3BYWnMrEEwN5yfdGLOG4Ulw1kg=
X-Google-Smtp-Source: ABdhPJwFmb6CVFGHBWXlzQnS58PALEhepsv7f0h0Je/37NQinPkKDgqPDkTeBlpmndchuGkIHeS1z4Fyx1z/Fa+aNwE=
X-Received: by 2002:a05:6512:b1b:: with SMTP id
	w27mr4506047lfu.10.1611731763892; 
	Tue, 26 Jan 2021 23:16:03 -0800 (PST)
MIME-Version: 1.0
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-15-hch@lst.de>
In-Reply-To: <20210126145247.1964410-15-hch@lst.de>
From: Song Liu <song@kernel.org>
Date: Tue, 26 Jan 2021 23:15:52 -0800
X-Gmail-Original-Message-ID: <CAPhsuW599kbe-YFX0FOOGJy30gy3V2_hMYW3jg3sK_VwaayEBQ@mail.gmail.com>
Message-ID: <CAPhsuW599kbe-YFX0FOOGJy30gy3V2_hMYW3jg3sK_VwaayEBQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 27 Jan 2021 05:02:17 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>,
	dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>,
	linux-nilfs@vger.kernel.org, Chao Yu <chao@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid <linux-raid@vger.kernel.org>,
	linux-bcache@vger.kernel.org, drbd-dev@tron.linbit.com,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-f2fs-devel@lists.sourceforge.net,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 14/17] md/raid6: refactor raid5_read_one_chunk
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 26, 2021 at 7:19 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Refactor raid5_read_one_chunk so that all simple checks are done
> before allocating the bio.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>

Thanks for the clean-up!


> ---
>  drivers/md/raid5.c | 108 +++++++++++++++++++--------------------------
>  1 file changed, 45 insertions(+), 63 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f411b9e5c332f4..a348b2adf2a9f9 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5393,90 +5393,72 @@ static void raid5_align_endio(struct bio *bi)
>  static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
>  {
>         struct r5conf *conf = mddev->private;
> -       int dd_idx;
> -       struct bio* align_bi;
> +       struct bio *align_bio;
>         struct md_rdev *rdev;
> -       sector_t end_sector;
> +       sector_t sector, end_sector, first_bad;
> +       int bad_sectors, dd_idx;
>
>         if (!in_chunk_boundary(mddev, raid_bio)) {
>                 pr_debug("%s: non aligned\n", __func__);
>                 return 0;
>         }
> -       /*
> -        * use bio_clone_fast to make a copy of the bio
> -        */
> -       align_bi = bio_clone_fast(raid_bio, GFP_NOIO, &mddev->bio_set);
> -       if (!align_bi)
> -               return 0;
> -       /*
> -        *   set bi_end_io to a new function, and set bi_private to the
> -        *     original bio.
> -        */
> -       align_bi->bi_end_io  = raid5_align_endio;
> -       align_bi->bi_private = raid_bio;
> -       /*
> -        *      compute position
> -        */
> -       align_bi->bi_iter.bi_sector =
> -               raid5_compute_sector(conf, raid_bio->bi_iter.bi_sector,
> -                                    0, &dd_idx, NULL);
>
> -       end_sector = bio_end_sector(align_bi);
> +       sector = raid5_compute_sector(conf, raid_bio->bi_iter.bi_sector, 0,
> +                                     &dd_idx, NULL);
> +       end_sector = bio_end_sector(raid_bio);
> +
>         rcu_read_lock();
> +       if (r5c_big_stripe_cached(conf, sector))
> +               goto out_rcu_unlock;
> +
>         rdev = rcu_dereference(conf->disks[dd_idx].replacement);
>         if (!rdev || test_bit(Faulty, &rdev->flags) ||
>             rdev->recovery_offset < end_sector) {
>                 rdev = rcu_dereference(conf->disks[dd_idx].rdev);
> -               if (rdev &&
> -                   (test_bit(Faulty, &rdev->flags) ||
> +               if (!rdev)
> +                       goto out_rcu_unlock;
> +               if (test_bit(Faulty, &rdev->flags) ||
>                     !(test_bit(In_sync, &rdev->flags) ||
> -                     rdev->recovery_offset >= end_sector)))
> -                       rdev = NULL;
> +                     rdev->recovery_offset >= end_sector))
> +                       goto out_rcu_unlock;
>         }
>
> -       if (r5c_big_stripe_cached(conf, align_bi->bi_iter.bi_sector)) {
> -               rcu_read_unlock();
> -               bio_put(align_bi);
> +       atomic_inc(&rdev->nr_pending);
> +       rcu_read_unlock();
> +
> +       align_bio = bio_clone_fast(raid_bio, GFP_NOIO, &mddev->bio_set);
> +       bio_set_dev(align_bio, rdev->bdev);
> +       align_bio->bi_end_io = raid5_align_endio;
> +       align_bio->bi_private = raid_bio;
> +       align_bio->bi_iter.bi_sector = sector;
> +
> +       raid_bio->bi_next = (void *)rdev;
> +
> +       if (is_badblock(rdev, sector, bio_sectors(align_bio), &first_bad,
> +                       &bad_sectors)) {
> +               bio_put(align_bio);
> +               rdev_dec_pending(rdev, mddev);
>                 return 0;
>         }
>
> -       if (rdev) {
> -               sector_t first_bad;
> -               int bad_sectors;
> -
> -               atomic_inc(&rdev->nr_pending);
> -               rcu_read_unlock();
> -               raid_bio->bi_next = (void*)rdev;
> -               bio_set_dev(align_bi, rdev->bdev);
> -
> -               if (is_badblock(rdev, align_bi->bi_iter.bi_sector,
> -                               bio_sectors(align_bi),
> -                               &first_bad, &bad_sectors)) {
> -                       bio_put(align_bi);
> -                       rdev_dec_pending(rdev, mddev);
> -                       return 0;
> -               }
> +       /* No reshape active, so we can trust rdev->data_offset */
> +       align_bio->bi_iter.bi_sector += rdev->data_offset;
>
> -               /* No reshape active, so we can trust rdev->data_offset */
> -               align_bi->bi_iter.bi_sector += rdev->data_offset;
> +       spin_lock_irq(&conf->device_lock);
> +       wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce == 0,
> +                           conf->device_lock);
> +       atomic_inc(&conf->active_aligned_reads);
> +       spin_unlock_irq(&conf->device_lock);
>
> -               spin_lock_irq(&conf->device_lock);
> -               wait_event_lock_irq(conf->wait_for_quiescent,
> -                                   conf->quiesce == 0,
> -                                   conf->device_lock);
> -               atomic_inc(&conf->active_aligned_reads);
> -               spin_unlock_irq(&conf->device_lock);
> +       if (mddev->gendisk)
> +               trace_block_bio_remap(align_bio, disk_devt(mddev->gendisk),
> +                                     raid_bio->bi_iter.bi_sector);
> +       submit_bio_noacct(align_bio);
> +       return 1;
>
> -               if (mddev->gendisk)
> -                       trace_block_bio_remap(align_bi, disk_devt(mddev->gendisk),
> -                                             raid_bio->bi_iter.bi_sector);
> -               submit_bio_noacct(align_bi);
> -               return 1;
> -       } else {
> -               rcu_read_unlock();
> -               bio_put(align_bi);
> -               return 0;
> -       }
> +out_rcu_unlock:
> +       rcu_read_unlock();
> +       return 0;
>  }
>
>  static struct bio *chunk_aligned_read(struct mddev *mddev, struct bio *raid_bio)
> --
> 2.29.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

