Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89BEC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 05:23:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-sgbmXXzoM9mhq3YQ56WsVg-1; Thu, 07 Apr 2022 01:23:35 -0400
X-MC-Unique: sgbmXXzoM9mhq3YQ56WsVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDE61185A79C;
	Thu,  7 Apr 2022 05:23:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AA2F6C28102;
	Thu,  7 Apr 2022 05:23:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7313F194034B;
	Thu,  7 Apr 2022 05:23:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 596FB1949763
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 05:23:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2563E145BA4A; Thu,  7 Apr 2022 05:23:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 20C61145BA46
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 05:23:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01BD585A5BC
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 05:23:32 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-_nuI8x77PCaxiUHSb_JREw-1; Thu, 07 Apr 2022 01:23:30 -0400
X-MC-Unique: _nuI8x77PCaxiUHSb_JREw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id B76E021122;
 Thu,  7 Apr 2022 05:16:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 81FE713A66;
 Thu,  7 Apr 2022 05:16:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 0FojFJ5zTmLoQAAAMHmgww
 (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 05:16:14 +0000
Message-ID: <2aee78dd-d5b6-5444-da28-34ab2631b264@suse.de>
Date: Thu, 7 Apr 2022 13:16:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
To: Christoph Hellwig <hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-24-hch@lst.de>
From: Coly Li <colyli@suse.de>
In-Reply-To: <20220406060516.409838-24-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 23/27] block: add a bdev_max_discard_sectors
 helper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/6/22 2:05 PM, Christoph Hellwig wrote:
> Add a helper to query the number of sectors support per each discard bio
> based on the block device and use this helper to stop various places from
> poking into the request_queue to see if discard is supported and if so how
> much.  This mirrors what is done e.g. for write zeroes as well.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>


For the bcache part,

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li



> ---
>   block/blk-core.c                    |  2 +-
>   block/blk-lib.c                     |  2 +-
>   block/ioctl.c                       |  3 +--
>   drivers/block/drbd/drbd_main.c      |  2 +-
>   drivers/block/drbd/drbd_nl.c        | 12 +++++++-----
>   drivers/block/drbd/drbd_receiver.c  |  5 ++---
>   drivers/block/loop.c                |  9 +++------
>   drivers/block/rnbd/rnbd-srv-dev.h   |  6 +-----
>   drivers/block/xen-blkback/xenbus.c  |  2 +-
>   drivers/md/bcache/request.c         |  4 ++--
>   drivers/md/bcache/super.c           |  2 +-
>   drivers/md/bcache/sysfs.c           |  2 +-
>   drivers/md/dm-cache-target.c        |  9 +--------
>   drivers/md/dm-clone-target.c        |  9 +--------
>   drivers/md/dm-io.c                  |  2 +-
>   drivers/md/dm-log-writes.c          |  3 +--
>   drivers/md/dm-raid.c                |  9 ++-------
>   drivers/md/dm-table.c               |  4 +---
>   drivers/md/dm-thin.c                |  9 +--------
>   drivers/md/dm.c                     |  2 +-
>   drivers/md/md-linear.c              |  4 ++--
>   drivers/md/raid0.c                  |  2 +-
>   drivers/md/raid1.c                  |  6 +++---
>   drivers/md/raid10.c                 |  8 ++++----
>   drivers/md/raid5-cache.c            |  2 +-
>   drivers/target/target_core_device.c |  8 +++-----
>   fs/btrfs/extent-tree.c              |  4 ++--
>   fs/btrfs/ioctl.c                    |  2 +-
>   fs/exfat/file.c                     |  2 +-
>   fs/exfat/super.c                    | 10 +++-------
>   fs/ext4/ioctl.c                     | 10 +++-------
>   fs/ext4/super.c                     | 10 +++-------
>   fs/f2fs/f2fs.h                      |  3 +--
>   fs/f2fs/segment.c                   |  6 ++----
>   fs/fat/file.c                       |  2 +-
>   fs/fat/inode.c                      | 10 +++-------
>   fs/gfs2/rgrp.c                      |  2 +-
>   fs/jbd2/journal.c                   |  7 ++-----
>   fs/jfs/ioctl.c                      |  2 +-
>   fs/jfs/super.c                      |  8 ++------
>   fs/nilfs2/ioctl.c                   |  2 +-
>   fs/ntfs3/file.c                     |  2 +-
>   fs/ntfs3/super.c                    |  2 +-
>   fs/ocfs2/ioctl.c                    |  2 +-
>   fs/xfs/xfs_discard.c                |  2 +-
>   fs/xfs/xfs_super.c                  | 12 ++++--------
>   include/linux/blkdev.h              |  5 +++++
>   mm/swapfile.c                       | 17 ++---------------
>   48 files changed, 87 insertions(+), 163 deletions(-)

[snipped]


> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index fdd0194f84dd0..e27f67f06a428 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1005,7 +1005,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
>   		bio_get(s->iop.bio);
>   
>   		if (bio_op(bio) == REQ_OP_DISCARD &&
> -		    !blk_queue_discard(bdev_get_queue(dc->bdev)))
> +		    !bdev_max_discard_sectors(dc->bdev))
>   			goto insert_data;
>   
>   		/* I/O request sent to backing device */
> @@ -1115,7 +1115,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
>   	bio->bi_private = ddip;
>   
>   	if ((bio_op(bio) == REQ_OP_DISCARD) &&
> -	    !blk_queue_discard(bdev_get_queue(dc->bdev)))
> +	    !bdev_max_discard_sectors(dc->bdev))
>   		bio->bi_end_io(bio);
>   	else
>   		submit_bio_noacct(bio);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index bf3de149d3c9f..296f200b2e208 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2350,7 +2350,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   	ca->bdev->bd_holder = ca;
>   	ca->sb_disk = sb_disk;
>   
> -	if (blk_queue_discard(bdev_get_queue(bdev)))
> +	if (bdev_max_discard_sectors((bdev)))
>   		ca->discard = CACHE_DISCARD(&ca->sb);
>   
>   	ret = cache_alloc(ca);
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index d1029d71ff3bc..c6f677059214d 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -1151,7 +1151,7 @@ STORE(__bch_cache)
>   	if (attr == &sysfs_discard) {
>   		bool v = strtoul_or_return(buf);
>   
> -		if (blk_queue_discard(bdev_get_queue(ca->bdev)))
> +		if (bdev_max_discard_sectors(ca->bdev))
>   			ca->discard = v;
>   
>   		if (v != CACHE_DISCARD(&ca->sb)) {


[snipped]

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

