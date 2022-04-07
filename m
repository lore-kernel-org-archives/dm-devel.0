Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B7D4C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 05:19:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-sSn-Q3nXNUGRVOmyTYesdg-1; Thu, 07 Apr 2022 01:19:07 -0400
X-MC-Unique: sSn-Q3nXNUGRVOmyTYesdg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E9391C01734;
	Thu,  7 Apr 2022 05:19:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66A47111F3C7;
	Thu,  7 Apr 2022 05:19:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 542FB194034B;
	Thu,  7 Apr 2022 05:19:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5628F194034F
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 05:19:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 300E740D2975; Thu,  7 Apr 2022 05:19:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2793640D282A
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 05:19:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FF95811E78
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 05:19:03 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-GU0go5heONKda6DH4IG_Zg-1; Thu, 07 Apr 2022 01:18:59 -0400
X-MC-Unique: GU0go5heONKda6DH4IG_Zg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id B3E5F210E1;
 Thu,  7 Apr 2022 05:18:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1F2F413A66;
 Thu,  7 Apr 2022 05:18:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 9Lo/Nzp0TmKaQQAAMHmgww
 (envelope-from <colyli@suse.de>); Thu, 07 Apr 2022 05:18:50 +0000
Message-ID: <f326944f-46b1-e888-18f6-97dcf69d945d@suse.de>
Date: Thu, 7 Apr 2022 13:18:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
To: Christoph Hellwig <hch@lst.de>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-26-hch@lst.de>
From: Coly Li <colyli@suse.de>
In-Reply-To: <20220406060516.409838-26-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 25/27] block: remove QUEUE_FLAG_DISCARD
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 4/6/22 2:05 PM, Christoph Hellwig wrote:
> Just use a non-zero max_discard_sectors as an indicator for discard
> support, similar to what is done for write zeroes.
>
> The only places where needs special attention is the RAID5 driver,
> which must clear discard support for security reasons by default,
> even if the default stacking rules would allow for it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the bcache part,

Acked-by: Coly Li <colyli@suse.de>


Thanks.

Coly Li


> ---
>   arch/um/drivers/ubd_kern.c    |  2 --
>   block/blk-mq-debugfs.c        |  1 -
>   drivers/block/drbd/drbd_nl.c  | 15 ---------------
>   drivers/block/loop.c          |  2 --
>   drivers/block/nbd.c           |  3 ---
>   drivers/block/null_blk/main.c |  1 -
>   drivers/block/rbd.c           |  1 -
>   drivers/block/rnbd/rnbd-clt.c |  2 --
>   drivers/block/virtio_blk.c    |  2 --
>   drivers/block/xen-blkfront.c  |  2 --
>   drivers/block/zram/zram_drv.c |  1 -
>   drivers/md/bcache/super.c     |  1 -
>   drivers/md/dm-table.c         |  5 +----
>   drivers/md/dm-thin.c          |  2 --
>   drivers/md/dm.c               |  1 -
>   drivers/md/md-linear.c        |  9 ---------
>   drivers/md/raid0.c            |  7 -------
>   drivers/md/raid1.c            | 14 --------------
>   drivers/md/raid10.c           | 14 --------------
>   drivers/md/raid5.c            | 12 ++++--------
>   drivers/mmc/core/queue.c      |  1 -
>   drivers/mtd/mtd_blkdevs.c     |  1 -
>   drivers/nvme/host/core.c      |  6 ++----
>   drivers/s390/block/dasd_fba.c |  1 -
>   drivers/scsi/sd.c             |  2 --
>   include/linux/blkdev.h        |  2 --
>   26 files changed, 7 insertions(+), 103 deletions(-)
[snipped]
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 296f200b2e208..2f49e31142f62 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -973,7 +973,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>   
>   	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
>   	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
> -	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);
>   
>   	blk_queue_write_cache(q, true, true);
>   


[snipped]

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

