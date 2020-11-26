Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CDF1C63697
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:49:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8F7B42053B
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:49:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F7B42053B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-KNJ6zUgYNmyKhIENvDfqsw-1; Thu, 26 Nov 2020 12:49:14 -0500
X-MC-Unique: KNJ6zUgYNmyKhIENvDfqsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9A661009471;
	Thu, 26 Nov 2020 17:49:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AD9735D9D0;
	Thu, 26 Nov 2020 17:49:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C0C4180954D;
	Thu, 26 Nov 2020 17:49:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQHn8D1001480 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 12:49:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC58D2026D3D; Thu, 26 Nov 2020 17:49:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E608D2026D36
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:49:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A7A1103B805
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:49:04 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-594-m9kzxtUpMZ-kEYgp7qm2MA-1;
	Thu, 26 Nov 2020 12:49:01 -0500
X-MC-Unique: m9kzxtUpMZ-kEYgp7qm2MA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 6D7F9ACA9;
	Thu, 26 Nov 2020 17:49:00 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 402A71E10D0; Thu, 26 Nov 2020 18:49:00 +0100 (CET)
Date: Thu, 26 Nov 2020 18:49:00 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126174900.GZ422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-41-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-41-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 40/44] block: pass a block_device to
	invalidate_partition
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 26-11-20 14:04:18, Christoph Hellwig wrote:
> Pass the block_device actually needed instead of looking it up using
> bdget_disk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/genhd.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 89cd0ba8e3b84a..28299b24173be1 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -792,14 +792,8 @@ void device_add_disk_no_queue_reg(struct device *parent, struct gendisk *disk)
>  }
>  EXPORT_SYMBOL(device_add_disk_no_queue_reg);
>  
> -static void invalidate_partition(struct gendisk *disk, int partno)
> +static void invalidate_partition(struct block_device *bdev)
>  {
> -	struct block_device *bdev;
> -
> -	bdev = bdget_disk(disk, partno);
> -	if (!bdev)
> -		return;
> -
>  	fsync_bdev(bdev);
>  	__invalidate_device(bdev, true);
>  
> @@ -808,7 +802,6 @@ static void invalidate_partition(struct gendisk *disk, int partno)
>  	 * up any more even if openers still hold references to it.
>  	 */
>  	remove_inode_hash(bdev->bd_inode);
> -	bdput(bdev);
>  }
>  
>  /**
> @@ -853,12 +846,12 @@ void del_gendisk(struct gendisk *disk)
>  	disk_part_iter_init(&piter, disk,
>  			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
>  	while ((part = disk_part_iter_next(&piter))) {
> -		invalidate_partition(disk, part->bdev->bd_partno);
> +		invalidate_partition(part->bdev);
>  		delete_partition(part);
>  	}
>  	disk_part_iter_exit(&piter);
>  
> -	invalidate_partition(disk, 0);
> +	invalidate_partition(disk->part0);
>  	set_capacity(disk, 0);
>  	disk->flags &= ~GENHD_FL_UP;
>  	up_write(&bdev_lookup_sem);
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

