Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B89C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3ABB62076E
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 10:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ABB62076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-Yxt7bodOPeKNrhYVv25eVA-1; Wed, 27 Jan 2021 05:02:46 -0500
X-MC-Unique: Yxt7bodOPeKNrhYVv25eVA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E53018144E6;
	Wed, 27 Jan 2021 10:02:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2FE65FC29;
	Wed, 27 Jan 2021 10:02:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 93A0C5002C;
	Wed, 27 Jan 2021 10:02:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10R7N8Pg007013 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 02:23:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 28CEA2026D11; Wed, 27 Jan 2021 07:23:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 23CCE2026D49
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:23:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2876F858281
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 07:23:05 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-520-R70NygayMAiwmcC7YxKXUw-1;
	Wed, 27 Jan 2021 02:23:01 -0500
X-MC-Unique: R70NygayMAiwmcC7YxKXUw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F62F20756;
	Wed, 27 Jan 2021 07:22:59 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id y11so923401ljk.1;
	Tue, 26 Jan 2021 23:22:59 -0800 (PST)
X-Gm-Message-State: AOAM5326TBChlzoch5x4iRl//3LYiOiyNfQw8b8EUQLqAA6t+iKyIBqZ
	EsGpaIGBJCR4R6uTJlanZ6AkaGRwmWADn6NJnwo=
X-Google-Smtp-Source: ABdhPJwT4SgEWFQYI+aGplxcgngrqXZ09YVZXq+be6TcwdS2L0sd+F5PxgqsedykGzzK3GAh/e6zF7ilKInCLGcj5r0=
X-Received: by 2002:a2e:b8d3:: with SMTP id s19mr5116366ljp.97.1611732177533; 
	Tue, 26 Jan 2021 23:22:57 -0800 (PST)
MIME-Version: 1.0
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-14-hch@lst.de>
In-Reply-To: <20210126145247.1964410-14-hch@lst.de>
From: Song Liu <song@kernel.org>
Date: Tue, 26 Jan 2021 23:22:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4AViTNjq1mp6zvbEJ8zKdK7__BfXEsvATTBWraK2u1Jg@mail.gmail.com>
Message-ID: <CAPhsuW4AViTNjq1mp6zvbEJ8zKdK7__BfXEsvATTBWraK2u1Jg@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH 13/17] md: remove md_bio_alloc_sync
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 26, 2021 at 7:17 AM Christoph Hellwig <hch@lst.de> wrote:
>
> md_bio_alloc_sync is never called with a NULL mddev, and ->sync_set is
> initialized in md_run, so it always must be initialized as well.  Just
> open code the remaining call to bio_alloc_bioset.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6a27f52007c871..399c81bddc1ae1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -340,14 +340,6 @@ static int start_readonly;
>   */
>  static bool create_on_open = true;
>
> -static struct bio *md_bio_alloc_sync(struct mddev *mddev)
> -{
> -       if (!mddev || !bioset_initialized(&mddev->sync_set))
> -               return bio_alloc(GFP_NOIO, 1);
> -
> -       return bio_alloc_bioset(GFP_NOIO, 1, &mddev->sync_set);
> -}
> -
>  /*
>   * We have a system wide 'event count' that is incremented
>   * on any 'interesting' event, and readers of /proc/mdstat
> @@ -989,7 +981,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>         if (test_bit(Faulty, &rdev->flags))
>                 return;
>
> -       bio = md_bio_alloc_sync(mddev);
> +       bio = bio_alloc_bioset(GFP_NOIO, 1, &mddev->sync_set);
>
>         atomic_inc(&rdev->nr_pending);
>
> --
> 2.29.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

