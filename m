Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD08FC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3218B2076E
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3218B2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-RUOdgzCjM9eh35FolCemxw-1; Wed, 27 Jan 2021 05:02:45 -0500
X-MC-Unique: RUOdgzCjM9eh35FolCemxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 024221034B21;
	Wed, 27 Jan 2021 10:02:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE2881F407;
	Wed, 27 Jan 2021 10:02:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9C2CC4EEEE;
	Wed, 27 Jan 2021 10:02:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10R7MLtF006966 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 02:22:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7A4B12026DE4; Wed, 27 Jan 2021 07:22:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 740052026D16
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:22:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857C8811E76
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:22:18 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-258-1J9pyzs-PZ6IXCUVq2d1oQ-1;
	Wed, 27 Jan 2021 02:22:16 -0500
X-MC-Unique: 1J9pyzs-PZ6IXCUVq2d1oQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7210F2075A;
	Wed, 27 Jan 2021 07:22:14 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id q8so1234704lfm.10;
	Tue, 26 Jan 2021 23:22:14 -0800 (PST)
X-Gm-Message-State: AOAM5332fD9RFi+z3akH+nmsLVjpodmX5dSRXIslYnejwQ/4Q8MwG+SC
	XQaFRihFlmaSXpNKokl8Yf59MQefsbq/D0QwIhg=
X-Google-Smtp-Source: ABdhPJxflUggj8S5jQsQ3WpKvrE0C44XGXqHsiBc4rX5F3+Z0c1NJpDcJfbjDkFKR5D14faCz9LusUBrixofxv3V23Y=
X-Received: by 2002:a05:6512:5c6:: with SMTP id
	o6mr4374679lfo.281.1611732132634; 
	Tue, 26 Jan 2021 23:22:12 -0800 (PST)
MIME-Version: 1.0
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-13-hch@lst.de>
In-Reply-To: <20210126145247.1964410-13-hch@lst.de>
From: Song Liu <song@kernel.org>
Date: Tue, 26 Jan 2021 23:22:01 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6sVtB-baGn46_o6NVynuxQfy9_FuhC2ZK0cKu5cQHWDg@mail.gmail.com>
Message-ID: <CAPhsuW6sVtB-baGn46_o6NVynuxQfy9_FuhC2ZK0cKu5cQHWDg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: Re: [dm-devel] [PATCH 12/17] md: simplify sync_page_io
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

On Tue, Jan 26, 2021 at 7:14 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Use an on-stack bio and biovec for the single page synchronous I/O.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e2b9dbb6e888f6..6a27f52007c871 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1021,29 +1021,29 @@ int md_super_wait(struct mddev *mddev)
>  int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
>                  struct page *page, int op, int op_flags, bool metadata_op)
>  {
> -       struct bio *bio = md_bio_alloc_sync(rdev->mddev);
> -       int ret;
> +       struct bio bio;
> +       struct bio_vec bvec;
> +
> +       bio_init(&bio, &bvec, 1);
>
>         if (metadata_op && rdev->meta_bdev)
> -               bio_set_dev(bio, rdev->meta_bdev);
> +               bio_set_dev(&bio, rdev->meta_bdev);
>         else
> -               bio_set_dev(bio, rdev->bdev);
> -       bio_set_op_attrs(bio, op, op_flags);
> +               bio_set_dev(&bio, rdev->bdev);
> +       bio.bi_opf = op | op_flags;
>         if (metadata_op)
> -               bio->bi_iter.bi_sector = sector + rdev->sb_start;
> +               bio.bi_iter.bi_sector = sector + rdev->sb_start;
>         else if (rdev->mddev->reshape_position != MaxSector &&
>                  (rdev->mddev->reshape_backwards ==
>                   (sector >= rdev->mddev->reshape_position)))
> -               bio->bi_iter.bi_sector = sector + rdev->new_data_offset;
> +               bio.bi_iter.bi_sector = sector + rdev->new_data_offset;
>         else
> -               bio->bi_iter.bi_sector = sector + rdev->data_offset;
> -       bio_add_page(bio, page, size, 0);
> +               bio.bi_iter.bi_sector = sector + rdev->data_offset;
> +       bio_add_page(&bio, page, size, 0);
>
> -       submit_bio_wait(bio);
> +       submit_bio_wait(&bio);
>
> -       ret = !bio->bi_status;
> -       bio_put(bio);
> -       return ret;
> +       return !bio.bi_status;
>  }
>  EXPORT_SYMBOL_GPL(sync_page_io);
>
> --
> 2.29.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

