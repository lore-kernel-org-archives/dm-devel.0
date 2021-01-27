Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D0EC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B2ECF2076E
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2ECF2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-bTdSrCn0Ox-meQMvlG7A1w-1; Wed, 27 Jan 2021 05:02:41 -0500
X-MC-Unique: bTdSrCn0Ox-meQMvlG7A1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2959D10054FF;
	Wed, 27 Jan 2021 10:02:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05AB96F92F;
	Wed, 27 Jan 2021 10:02:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 788104BB7B;
	Wed, 27 Jan 2021 10:02:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10R7LbEu006897 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 02:21:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CA08E33239; Wed, 27 Jan 2021 07:21:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C3DBBAE7D4
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:21:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 653DA101A560
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:21:35 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-509-8BC4YUH0NYSS5jtd7EykHQ-1;
	Wed, 27 Jan 2021 02:21:30 -0500
X-MC-Unique: 8BC4YUH0NYSS5jtd7EykHQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 040802074D;
	Wed, 27 Jan 2021 07:21:28 +0000 (UTC)
Received: by mail-lf1-f47.google.com with SMTP id i187so1257105lfd.4;
	Tue, 26 Jan 2021 23:21:28 -0800 (PST)
X-Gm-Message-State: AOAM533tlT/6jrVA0OUaeBU+0QPbH5/xL2lRaZ/9bxbDyxEPuJgrU894
	PRig4sXdzxqEhpiN/5CNdzG3A9cm5gMvohwGNi4=
X-Google-Smtp-Source: ABdhPJxzU6eEXjGgMsXjIbLicQlntxxKhHAHPBju5x4svSgsvP73GNvKL+gYo0RpjmVTLgHo2j69VOR6hw/D9eon+xA=
X-Received: by 2002:a05:6512:b1b:: with SMTP id
	w27mr4516614lfu.10.1611732087108; 
	Tue, 26 Jan 2021 23:21:27 -0800 (PST)
MIME-Version: 1.0
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-12-hch@lst.de>
In-Reply-To: <20210126145247.1964410-12-hch@lst.de>
From: Song Liu <song@kernel.org>
Date: Tue, 26 Jan 2021 23:21:16 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4SRXoOjfU5GHoOGfONjb1yMT7HEyHLZb4E4vNARF44jw@mail.gmail.com>
Message-ID: <CAPhsuW4SRXoOjfU5GHoOGfONjb1yMT7HEyHLZb4E4vNARF44jw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
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
Subject: Re: [dm-devel] [PATCH 11/17] md: remove bio_alloc_mddev
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 26, 2021 at 7:12 AM Christoph Hellwig <hch@lst.de> wrote:
>
> bio_alloc_mddev is never called with a NULL mddev, and ->bio_set is
> initialized in md_run, so it always must be initialized as well.  Just
> open code the remaining call to bio_alloc_bioset.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c     | 12 +-----------
>  drivers/md/md.h     |  2 --
>  drivers/md/raid1.c  |  2 +-
>  drivers/md/raid10.c |  2 +-
>  4 files changed, 3 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7d1bb24add3107..e2b9dbb6e888f6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -340,16 +340,6 @@ static int start_readonly;
>   */
>  static bool create_on_open = true;
>
> -struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
> -                           struct mddev *mddev)
> -{
> -       if (!mddev || !bioset_initialized(&mddev->bio_set))
> -               return bio_alloc(gfp_mask, nr_iovecs);
> -
> -       return bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
> -}
> -EXPORT_SYMBOL_GPL(bio_alloc_mddev);
> -
>  static struct bio *md_bio_alloc_sync(struct mddev *mddev)
>  {
>         if (!mddev || !bioset_initialized(&mddev->sync_set))
> @@ -613,7 +603,7 @@ static void submit_flushes(struct work_struct *ws)
>                         atomic_inc(&rdev->nr_pending);
>                         atomic_inc(&rdev->nr_pending);
>                         rcu_read_unlock();
> -                       bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
> +                       bi = bio_alloc_bioset(GFP_NOIO, 0, &mddev->bio_set);
>                         bi->bi_end_io = md_end_flush;
>                         bi->bi_private = rdev;
>                         bio_set_dev(bi, rdev->bdev);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index f13290ccc1c248..bcbba1b5ec4a71 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -742,8 +742,6 @@ extern void md_rdev_clear(struct md_rdev *rdev);
>  extern void md_handle_request(struct mddev *mddev, struct bio *bio);
>  extern void mddev_suspend(struct mddev *mddev);
>  extern void mddev_resume(struct mddev *mddev);
> -extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
> -                                  struct mddev *mddev);
>
>  extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>  extern void md_update_sb(struct mddev *mddev, int force);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 3b19141cdb4bc2..d2378765dc154f 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1104,7 +1104,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
>         int i = 0;
>         struct bio *behind_bio = NULL;
>
> -       behind_bio = bio_alloc_mddev(GFP_NOIO, vcnt, r1_bio->mddev);
> +       behind_bio = bio_alloc_bioset(GFP_NOIO, vcnt, &r1_bio->mddev->bio_set);
>         if (!behind_bio)
>                 return;
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index be8f14afb6d143..e1eefbec15d444 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4531,7 +4531,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
>                 return sectors_done;
>         }
>
> -       read_bio = bio_alloc_mddev(GFP_KERNEL, RESYNC_PAGES, mddev);
> +       read_bio = bio_alloc_bioset(GFP_KERNEL, RESYNC_PAGES, &mddev->bio_set);
>
>         bio_set_dev(read_bio, rdev->bdev);
>         read_bio->bi_iter.bi_sector = (r10_bio->devs[r10_bio->read_slot].addr
> --
> 2.29.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

