Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 600EFC43334
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jul 2022 02:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656989959;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2jiyhjb59bL70DtfaMyddftUG5CLy4TcLQeVhltRwS0=;
	b=aVQDLhKXbYRp5ZoJJN21TpmcmI2L6srhPTok0mKlhDE9N/Nq3+ts5+P6GP8/gp2l2O4Acz
	P4m8gmpGgLJVZB8KbecFzYsrgnyfWv32xCrFzmHCcwe8sPWoZfK/ZKeO2oZxn/SF7/fXdw
	1TmzRjlzJfMnqhX6sLsrGJSr7TXGpJ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-3K5D8C1dN9-VmzACLbnBYg-1; Mon, 04 Jul 2022 22:59:15 -0400
X-MC-Unique: 3K5D8C1dN9-VmzACLbnBYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16D0485A581;
	Tue,  5 Jul 2022 02:59:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF3C04010FA6;
	Tue,  5 Jul 2022 02:59:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9697194704D;
	Tue,  5 Jul 2022 02:59:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88A781947041
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 02:59:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D08B112131B; Tue,  5 Jul 2022 02:59:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 68B451121315
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:59:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45FE9101A58E
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 02:59:12 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-u9d6kBl3M1-ZubMw_UZ6JA-1; Mon, 04 Jul 2022 22:59:10 -0400
X-MC-Unique: u9d6kBl3M1-ZubMw_UZ6JA-1
X-IronPort-AV: E=Sophos;i="5.92,245,1650902400"; d="scan'208";a="205521222"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2022 10:59:09 +0800
IronPort-SDR: 5HZYGJnp/7CgUxhosqeNEWsnb2D6z5XORQBBZcy0ebllzX8M1hsEbkHsDUQbfHHTS0NnLtFvU7
 IHjxkpX12vBgByAS/vN+BN8FROxQywmk/5NDd/hUEd1M+naKdWQFn5QY4YW56ZkkX1BC3O3kDS
 IDrxGFalHrWm53ca0AjyANo/oRAeGjNnWFj9XAJ8KM2NuNIo78r+bf5AOQ4F/7mALOEbY9R4WK
 FZNsgHkmFVCQDlQaPPSU+wqBe9E+NIib3UYI9z+B/zukXd2cO2xh/sypIPWsk3y13HwpxhWu9L
 vHfZZzSJwgWYC61NNSWr3xR8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:16:29 -0700
IronPort-SDR: zkRgNraEiWuFH/CpHrbGEerQnjTLnbkhhTdw0FvxwaxIy54ulsoHf073nWeMgwt5vBuecgv1rd
 2CEdLfgrhTf579UrIegD7XUA/Vt796t60iAPtOOkfrzH9Oyg1a6W2aO9aO/3YxQ8GVvjoSghP0
 6BG9mVWjIn9bUEbrOaUXmIrkkt3q+r7uI3jybz1Zv/ew+r3qSxNDQAxjQc4w0CzAZBCJvMCZAL
 FDpQ8YT4vZ1LqLfQaW54MbUixtk4DmD6Fv+YXCNojeuFhuZE3o/aXqyfrW0G2dUDBunh0tPjW+
 Pew=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 04 Jul 2022 19:59:10 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LcS7K0NdKz1Rwqy
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 19:59:09 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 90wQK4uQAY-q for <dm-devel@redhat.com>;
 Mon,  4 Jul 2022 19:59:06 -0700 (PDT)
Received: from [10.225.163.105] (unknown [10.225.163.105])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LcS7F5f7pz1RtVk;
 Mon,  4 Jul 2022 19:59:05 -0700 (PDT)
Message-ID: <1b7c08a5-f0e0-f5cb-7575-e9d3b79fec99@opensource.wdc.com>
Date: Tue, 5 Jul 2022 11:59:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-18-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220704124500.155247-18-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 17/17] block: move zone related fields to
 struct gendisk
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/22 21:45, Christoph Hellwig wrote:
> Move the zone related fields that are currently stored in
> struct request_queue to struct gendisk as these are part of the highlevel
> block layer API and are only used for non-passthrough I/O that requires
> the gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  block/blk-mq-debugfs-zoned.c   |  6 +--
>  block/blk-sysfs.c              |  2 +-
>  block/blk-zoned.c              | 45 ++++++++---------
>  drivers/block/null_blk/zoned.c |  2 +-
>  drivers/md/dm-zone.c           | 74 +++++++++++++--------------
>  drivers/nvme/host/multipath.c  |  2 +-
>  drivers/nvme/target/zns.c      |  2 +-
>  drivers/scsi/sd_zbc.c          |  2 +-
>  include/linux/blk-mq.h         |  8 +--
>  include/linux/blkdev.h         | 91 ++++++++++++++++------------------
>  10 files changed, 110 insertions(+), 124 deletions(-)
> 
> diff --git a/block/blk-mq-debugfs-zoned.c b/block/blk-mq-debugfs-zoned.c
> index 038cb627c8689..a77b099c34b7a 100644
> --- a/block/blk-mq-debugfs-zoned.c
> +++ b/block/blk-mq-debugfs-zoned.c
> @@ -11,11 +11,11 @@ int queue_zone_wlock_show(void *data, struct seq_file *m)
>  	struct request_queue *q = data;
>  	unsigned int i;
>  
> -	if (!q->seq_zones_wlock)
> +	if (!q->disk->seq_zones_wlock)
>  		return 0;
>  
> -	for (i = 0; i < q->nr_zones; i++)
> -		if (test_bit(i, q->seq_zones_wlock))
> +	for (i = 0; i < q->disk->nr_zones; i++)
> +		if (test_bit(i, q->disk->seq_zones_wlock))
>  			seq_printf(m, "%u\n", i);
>  
>  	return 0;
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 5ce72345ac666..c0303026752d5 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -325,7 +325,7 @@ static ssize_t queue_zoned_show(struct request_queue *q, char *page)
>  
>  static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
>  {
> -	return queue_var_show(blk_queue_nr_zones(q), page);
> +	return queue_var_show(disk_nr_zones(q->disk), page);
>  }
>  
>  static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index ee8752f083a94..4826083ce9a48 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -57,10 +57,10 @@ EXPORT_SYMBOL_GPL(blk_zone_cond_str);
>   */
>  bool blk_req_needs_zone_write_lock(struct request *rq)
>  {
> -	if (!rq->q->seq_zones_wlock)
> +	if (blk_rq_is_passthrough(rq))
>  		return false;
>  
> -	if (blk_rq_is_passthrough(rq))
> +	if (!rq->q->disk->seq_zones_wlock)
>  		return false;
>  
>  	switch (req_op(rq)) {
> @@ -77,7 +77,7 @@ bool blk_req_zone_write_trylock(struct request *rq)
>  {
>  	unsigned int zno = blk_rq_zone_no(rq);
>  
> -	if (test_and_set_bit(zno, rq->q->seq_zones_wlock))
> +	if (test_and_set_bit(zno, rq->q->disk->seq_zones_wlock))
>  		return false;
>  
>  	WARN_ON_ONCE(rq->rq_flags & RQF_ZONE_WRITE_LOCKED);
> @@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(blk_req_zone_write_trylock);
>  void __blk_req_zone_write_lock(struct request *rq)
>  {
>  	if (WARN_ON_ONCE(test_and_set_bit(blk_rq_zone_no(rq),
> -					  rq->q->seq_zones_wlock)))
> +					  rq->q->disk->seq_zones_wlock)))
>  		return;
>  
>  	WARN_ON_ONCE(rq->rq_flags & RQF_ZONE_WRITE_LOCKED);
> @@ -101,9 +101,9 @@ EXPORT_SYMBOL_GPL(__blk_req_zone_write_lock);
>  void __blk_req_zone_write_unlock(struct request *rq)
>  {
>  	rq->rq_flags &= ~RQF_ZONE_WRITE_LOCKED;
> -	if (rq->q->seq_zones_wlock)
> +	if (rq->q->disk->seq_zones_wlock)
>  		WARN_ON_ONCE(!test_and_clear_bit(blk_rq_zone_no(rq),
> -						 rq->q->seq_zones_wlock));
> +						 rq->q->disk->seq_zones_wlock));
>  }
>  EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
>  
> @@ -189,7 +189,7 @@ static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
>  int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>  			 gfp_t gfp_mask)
>  {
> -	struct request_queue *q = bdev_get_queue(bdev);
> +	struct gendisk *disk = bdev->bd_disk;
>  	sector_t capacity = bdev_nr_sectors(bdev);
>  	sector_t zone_sectors = bdev_zone_sectors(bdev);
>  	unsigned long *need_reset;
> @@ -197,19 +197,18 @@ int blkdev_zone_mgmt_all(struct block_device *bdev, unsigned int op,
>  	sector_t sector = 0;
>  	int ret;
>  
> -	need_reset = blk_alloc_zone_bitmap(q->node, q->nr_zones);
> +	need_reset = blk_alloc_zone_bitmap(disk->queue->node, disk->nr_zones);
>  	if (!need_reset)
>  		return -ENOMEM;
>  
> -	ret = bdev->bd_disk->fops->report_zones(bdev->bd_disk, 0,
> -				q->nr_zones, blk_zone_need_reset_cb,
> -				need_reset);
> +	ret = disk->fops->report_zones(disk, 0, disk->nr_zones,
> +				       blk_zone_need_reset_cb, need_reset);
>  	if (ret < 0)
>  		goto out_free_need_reset;
>  
>  	ret = 0;
>  	while (sector < capacity) {
> -		if (!test_bit(blk_queue_zone_no(q, sector), need_reset)) {
> +		if (!test_bit(disk_zone_no(disk, sector), need_reset)) {
>  			sector += zone_sectors;
>  			continue;
>  		}
> @@ -452,12 +451,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>  
>  void disk_free_zone_bitmaps(struct gendisk *disk)
>  {
> -	struct request_queue *q = disk->queue;
> -
> -	kfree(q->conv_zones_bitmap);
> -	q->conv_zones_bitmap = NULL;
> -	kfree(q->seq_zones_wlock);
> -	q->seq_zones_wlock = NULL;
> +	kfree(disk->conv_zones_bitmap);
> +	disk->conv_zones_bitmap = NULL;
> +	kfree(disk->seq_zones_wlock);
> +	disk->seq_zones_wlock = NULL;
>  }
>  
>  struct blk_revalidate_zone_args {
> @@ -607,9 +604,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
>  	blk_mq_freeze_queue(q);
>  	if (ret > 0) {
>  		blk_queue_chunk_sectors(q, args.zone_sectors);
> -		q->nr_zones = args.nr_zones;
> -		swap(q->seq_zones_wlock, args.seq_zones_wlock);
> -		swap(q->conv_zones_bitmap, args.conv_zones_bitmap);
> +		disk->nr_zones = args.nr_zones;
> +		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
> +		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
>  		if (update_driver_data)
>  			update_driver_data(disk);
>  		ret = 0;
> @@ -634,9 +631,9 @@ void disk_clear_zone_settings(struct gendisk *disk)
>  	disk_free_zone_bitmaps(disk);
>  	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
>  	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
> -	q->nr_zones = 0;
> -	q->max_open_zones = 0;
> -	q->max_active_zones = 0;
> +	disk->nr_zones = 0;
> +	disk->max_open_zones = 0;
> +	disk->max_active_zones = 0;
>  	q->limits.chunk_sectors = 0;
>  	q->limits.zone_write_granularity = 0;
>  	q->limits.max_zone_append_sectors = 0;
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index e62c52e964259..64b06caab9843 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -170,7 +170,7 @@ int null_register_zoned_dev(struct nullb *nullb)
>  			return ret;
>  	} else {
>  		blk_queue_chunk_sectors(q, dev->zone_size_sects);
> -		q->nr_zones = bdev_nr_zones(nullb->disk->part0);
> +		nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
>  	}
>  
>  	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index 842c31019b513..2b89cde30c9e9 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -139,13 +139,11 @@ bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>  
>  void dm_cleanup_zoned_dev(struct mapped_device *md)
>  {
> -	struct request_queue *q = md->queue;
> -
> -	if (q) {
> -		kfree(q->conv_zones_bitmap);
> -		q->conv_zones_bitmap = NULL;
> -		kfree(q->seq_zones_wlock);
> -		q->seq_zones_wlock = NULL;
> +	if (md->disk) {
> +		kfree(md->disk->conv_zones_bitmap);
> +		md->disk->conv_zones_bitmap = NULL;
> +		kfree(md->disk->seq_zones_wlock);
> +		md->disk->seq_zones_wlock = NULL;
>  	}
>  
>  	kvfree(md->zwp_offset);
> @@ -179,31 +177,31 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>  				 void *data)
>  {
>  	struct mapped_device *md = data;
> -	struct request_queue *q = md->queue;
> +	struct gendisk *disk = md->disk;
>  
>  	switch (zone->type) {
>  	case BLK_ZONE_TYPE_CONVENTIONAL:
> -		if (!q->conv_zones_bitmap) {
> -			q->conv_zones_bitmap =
> -				kcalloc(BITS_TO_LONGS(q->nr_zones),
> +		if (!disk->conv_zones_bitmap) {
> +			disk->conv_zones_bitmap =
> +				kcalloc(BITS_TO_LONGS(disk->nr_zones),
>  					sizeof(unsigned long), GFP_NOIO);
> -			if (!q->conv_zones_bitmap)
> +			if (!disk->conv_zones_bitmap)
>  				return -ENOMEM;
>  		}
> -		set_bit(idx, q->conv_zones_bitmap);
> +		set_bit(idx, disk->conv_zones_bitmap);
>  		break;
>  	case BLK_ZONE_TYPE_SEQWRITE_REQ:
>  	case BLK_ZONE_TYPE_SEQWRITE_PREF:
> -		if (!q->seq_zones_wlock) {
> -			q->seq_zones_wlock =
> -				kcalloc(BITS_TO_LONGS(q->nr_zones),
> +		if (!disk->seq_zones_wlock) {
> +			disk->seq_zones_wlock =
> +				kcalloc(BITS_TO_LONGS(disk->nr_zones),
>  					sizeof(unsigned long), GFP_NOIO);
> -			if (!q->seq_zones_wlock)
> +			if (!disk->seq_zones_wlock)
>  				return -ENOMEM;
>  		}
>  		if (!md->zwp_offset) {
>  			md->zwp_offset =
> -				kvcalloc(q->nr_zones, sizeof(unsigned int),
> +				kvcalloc(disk->nr_zones, sizeof(unsigned int),
>  					 GFP_KERNEL);
>  			if (!md->zwp_offset)
>  				return -ENOMEM;
> @@ -228,7 +226,7 @@ static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>   */
>  static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  {
> -	struct request_queue *q = md->queue;
> +	struct gendisk *disk = md->disk;
>  	unsigned int noio_flag;
>  	int ret;
>  
> @@ -236,7 +234,7 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  	 * Check if something changed. If yes, cleanup the current resources
>  	 * and reallocate everything.
>  	 */
> -	if (!q->nr_zones || q->nr_zones != md->nr_zones)
> +	if (!disk->nr_zones || disk->nr_zones != md->nr_zones)
>  		dm_cleanup_zoned_dev(md);
>  	if (md->nr_zones)
>  		return 0;
> @@ -246,17 +244,17 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
>  	 * operations in this context are done as if GFP_NOIO was specified.
>  	 */
>  	noio_flag = memalloc_noio_save();
> -	ret = dm_blk_do_report_zones(md, t, 0, q->nr_zones,
> +	ret = dm_blk_do_report_zones(md, t, 0, disk->nr_zones,
>  				     dm_zone_revalidate_cb, md);
>  	memalloc_noio_restore(noio_flag);
>  	if (ret < 0)
>  		goto err;
> -	if (ret != q->nr_zones) {
> +	if (ret != disk->nr_zones) {
>  		ret = -EIO;
>  		goto err;
>  	}
>  
> -	md->nr_zones = q->nr_zones;
> +	md->nr_zones = disk->nr_zones;
>  
>  	return 0;
>  
> @@ -301,7 +299,7 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>  	 * correct value to be exposed in sysfs queue/nr_zones.
>  	 */
>  	WARN_ON_ONCE(queue_is_mq(q));
> -	q->nr_zones = bdev_nr_zones(md->disk->part0);
> +	md->disk->nr_zones = bdev_nr_zones(md->disk->part0);
>  
>  	/* Check if zone append is natively supported */
>  	if (dm_table_supports_zone_append(t)) {
> @@ -466,26 +464,26 @@ static blk_status_t dm_zone_map_bio_end(struct mapped_device *md, unsigned int z
>  	}
>  }
>  
> -static inline void dm_zone_lock(struct request_queue *q,
> -				unsigned int zno, struct bio *clone)
> +static inline void dm_zone_lock(struct gendisk *disk, unsigned int zno,
> +				struct bio *clone)
>  {
>  	if (WARN_ON_ONCE(bio_flagged(clone, BIO_ZONE_WRITE_LOCKED)))
>  		return;
>  
> -	wait_on_bit_lock_io(q->seq_zones_wlock, zno, TASK_UNINTERRUPTIBLE);
> +	wait_on_bit_lock_io(disk->seq_zones_wlock, zno, TASK_UNINTERRUPTIBLE);
>  	bio_set_flag(clone, BIO_ZONE_WRITE_LOCKED);
>  }
>  
> -static inline void dm_zone_unlock(struct request_queue *q,
> -				  unsigned int zno, struct bio *clone)
> +static inline void dm_zone_unlock(struct gendisk *disk, unsigned int zno,
> +				  struct bio *clone)
>  {
>  	if (!bio_flagged(clone, BIO_ZONE_WRITE_LOCKED))
>  		return;
>  
> -	WARN_ON_ONCE(!test_bit(zno, q->seq_zones_wlock));
> -	clear_bit_unlock(zno, q->seq_zones_wlock);
> +	WARN_ON_ONCE(!test_bit(zno, disk->seq_zones_wlock));
> +	clear_bit_unlock(zno, disk->seq_zones_wlock);
>  	smp_mb__after_atomic();
> -	wake_up_bit(q->seq_zones_wlock, zno);
> +	wake_up_bit(disk->seq_zones_wlock, zno);
>  
>  	bio_clear_flag(clone, BIO_ZONE_WRITE_LOCKED);
>  }
> @@ -520,7 +518,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  	struct dm_io *io = tio->io;
>  	struct dm_target *ti = tio->ti;
>  	struct mapped_device *md = io->md;
> -	struct request_queue *q = md->queue;
>  	struct bio *clone = &tio->clone;
>  	struct orig_bio_details orig_bio_details;
>  	unsigned int zno;
> @@ -536,7 +533,7 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  
>  	/* Lock the target zone */
>  	zno = bio_zone_no(clone);
> -	dm_zone_lock(q, zno, clone);
> +	dm_zone_lock(md->disk, zno, clone);
>  
>  	orig_bio_details.nr_sectors = bio_sectors(clone);
>  	orig_bio_details.op = bio_op(clone);
> @@ -546,7 +543,7 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  	 * both valid, and if the bio is a zone append, remap it to a write.
>  	 */
>  	if (!dm_zone_map_bio_begin(md, zno, clone)) {
> -		dm_zone_unlock(q, zno, clone);
> +		dm_zone_unlock(md->disk, zno, clone);
>  		return DM_MAPIO_KILL;
>  	}
>  
> @@ -570,12 +567,12 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  		sts = dm_zone_map_bio_end(md, zno, &orig_bio_details,
>  					  *tio->len_ptr);
>  		if (sts != BLK_STS_OK)
> -			dm_zone_unlock(q, zno, clone);
> +			dm_zone_unlock(md->disk, zno, clone);
>  		break;
>  	case DM_MAPIO_REQUEUE:
>  	case DM_MAPIO_KILL:
>  	default:
> -		dm_zone_unlock(q, zno, clone);
> +		dm_zone_unlock(md->disk, zno, clone);
>  		sts = BLK_STS_IOERR;
>  		break;
>  	}
> @@ -592,7 +589,6 @@ int dm_zone_map_bio(struct dm_target_io *tio)
>  void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  {
>  	struct mapped_device *md = io->md;
> -	struct request_queue *q = md->queue;
>  	struct gendisk *disk = md->disk;
>  	struct bio *orig_bio = io->orig_bio;
>  	unsigned int zwp_offset;
> @@ -651,5 +647,5 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
>  				zwp_offset - bio_sectors(orig_bio);
>  	}
>  
> -	dm_zone_unlock(q, zno, clone);
> +	dm_zone_unlock(disk, zno, clone);
>  }
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index ccf9a6da8f6e1..f26640ccb9555 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -830,7 +830,7 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
>  				   ns->head->disk->queue);
>  #ifdef CONFIG_BLK_DEV_ZONED
>  	if (blk_queue_is_zoned(ns->queue) && ns->head->disk)
> -		ns->head->disk->queue->nr_zones = ns->queue->nr_zones;
> +		ns->head->disk->nr_zones = ns->disk->nr_zones;
>  #endif
>  }
>  
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index c9b2ce06ca93e..385f2fe2792ff 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -57,7 +57,7 @@ bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
>  	 * zones, reject the device. Otherwise, use report zones to detect if
>  	 * the device has conventional zones.
>  	 */
> -	if (ns->bdev->bd_disk->queue->conv_zones_bitmap)
> +	if (ns->bdev->bd_disk->conv_zones_bitmap)
>  		return false;
>  
>  	ret = blkdev_report_zones(ns->bdev, 0, bdev_nr_zones(ns->bdev),
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index b4106f8997342..b8c97456506ac 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -855,7 +855,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
>  
>  	if (sdkp->zone_info.zone_blocks == zone_blocks &&
>  	    sdkp->zone_info.nr_zones == nr_zones &&
> -	    disk->queue->nr_zones == nr_zones)
> +	    disk->nr_zones == nr_zones)
>  		goto unlock;
>  
>  	flags = memalloc_noio_save();
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 43aad0da3305d..1b0b753609975 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -1123,12 +1123,12 @@ void blk_dump_rq_flags(struct request *, char *);
>  #ifdef CONFIG_BLK_DEV_ZONED
>  static inline unsigned int blk_rq_zone_no(struct request *rq)
>  {
> -	return blk_queue_zone_no(rq->q, blk_rq_pos(rq));
> +	return disk_zone_no(rq->q->disk, blk_rq_pos(rq));
>  }
>  
>  static inline unsigned int blk_rq_zone_is_seq(struct request *rq)
>  {
> -	return blk_queue_zone_is_seq(rq->q, blk_rq_pos(rq));
> +	return disk_zone_is_seq(rq->q->disk, blk_rq_pos(rq));
>  }
>  
>  bool blk_req_needs_zone_write_lock(struct request *rq);
> @@ -1150,8 +1150,8 @@ static inline void blk_req_zone_write_unlock(struct request *rq)
>  
>  static inline bool blk_req_zone_is_write_locked(struct request *rq)
>  {
> -	return rq->q->seq_zones_wlock &&
> -		test_bit(blk_rq_zone_no(rq), rq->q->seq_zones_wlock);
> +	return rq->q->disk->seq_zones_wlock &&
> +		test_bit(blk_rq_zone_no(rq), rq->q->disk->seq_zones_wlock);
>  }
>  
>  static inline bool blk_req_can_dispatch_to_zone(struct request *rq)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f1eca3f5610eb..547eb07848741 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -164,6 +164,29 @@ struct gendisk {
>  #ifdef  CONFIG_BLK_DEV_INTEGRITY
>  	struct kobject integrity_kobj;
>  #endif	/* CONFIG_BLK_DEV_INTEGRITY */
> +
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	/*
> +	 * Zoned block device information for request dispatch control.
> +	 * nr_zones is the total number of zones of the device. This is always
> +	 * 0 for regular block devices. conv_zones_bitmap is a bitmap of nr_zones
> +	 * bits which indicates if a zone is conventional (bit set) or
> +	 * sequential (bit clear). seq_zones_wlock is a bitmap of nr_zones
> +	 * bits which indicates if a zone is write locked, that is, if a write
> +	 * request targeting the zone was dispatched.
> +	 *
> +	 * Reads of this information must be protected with blk_queue_enter() /
> +	 * blk_queue_exit(). Modifying this information is only allowed while
> +	 * no requests are being processed. See also blk_mq_freeze_queue() and
> +	 * blk_mq_unfreeze_queue().
> +	 */
> +	unsigned int		nr_zones;
> +	unsigned int		max_open_zones;
> +	unsigned int		max_active_zones;
> +	unsigned long		*conv_zones_bitmap;
> +	unsigned long		*seq_zones_wlock;
> +#endif /* CONFIG_BLK_DEV_ZONED */
> +
>  #if IS_ENABLED(CONFIG_CDROM)
>  	struct cdrom_device_info *cdi;
>  #endif
> @@ -469,31 +492,6 @@ struct request_queue {
>  
>  	unsigned int		required_elevator_features;
>  
> -#ifdef CONFIG_BLK_DEV_ZONED
> -	/*
> -	 * Zoned block device information for request dispatch control.
> -	 * nr_zones is the total number of zones of the device. This is always
> -	 * 0 for regular block devices. conv_zones_bitmap is a bitmap of nr_zones
> -	 * bits which indicates if a zone is conventional (bit set) or
> -	 * sequential (bit clear). seq_zones_wlock is a bitmap of nr_zones
> -	 * bits which indicates if a zone is write locked, that is, if a write
> -	 * request targeting the zone was dispatched. All three fields are
> -	 * initialized by the low level device driver (e.g. scsi/sd.c).
> -	 * Stacking drivers (device mappers) may or may not initialize
> -	 * these fields.
> -	 *
> -	 * Reads of this information must be protected with blk_queue_enter() /
> -	 * blk_queue_exit(). Modifying this information is only allowed while
> -	 * no requests are being processed. See also blk_mq_freeze_queue() and
> -	 * blk_mq_unfreeze_queue().
> -	 */
> -	unsigned int		nr_zones;
> -	unsigned long		*conv_zones_bitmap;
> -	unsigned long		*seq_zones_wlock;
> -	unsigned int		max_open_zones;
> -	unsigned int		max_active_zones;
> -#endif /* CONFIG_BLK_DEV_ZONED */
> -
>  	int			node;
>  #ifdef CONFIG_BLK_DEV_IO_TRACE
>  	struct blk_trace __rcu	*blk_trace;
> @@ -670,63 +668,59 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
>  }
>  
>  #ifdef CONFIG_BLK_DEV_ZONED
> -static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
> +static inline unsigned int disk_nr_zones(struct gendisk *disk)
>  {
> -	return blk_queue_is_zoned(q) ? q->nr_zones : 0;
> +	return blk_queue_is_zoned(disk->queue) ? disk->nr_zones : 0;
>  }
>  
> -static inline unsigned int blk_queue_zone_no(struct request_queue *q,
> -					     sector_t sector)
> +static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
> -	if (!blk_queue_is_zoned(q))
> +	if (!blk_queue_is_zoned(disk->queue))
>  		return 0;
> -	return sector >> ilog2(q->limits.chunk_sectors);
> +	return sector >> ilog2(disk->queue->limits.chunk_sectors);
>  }
>  
> -static inline bool blk_queue_zone_is_seq(struct request_queue *q,
> -					 sector_t sector)
> +static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
>  {
> -	if (!blk_queue_is_zoned(q))
> +	if (!blk_queue_is_zoned(disk->queue))
>  		return false;
> -	if (!q->conv_zones_bitmap)
> +	if (!disk->conv_zones_bitmap)
>  		return true;
> -	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
> +	return !test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
>  }
>  
>  static inline void disk_set_max_open_zones(struct gendisk *disk,
>  		unsigned int max_open_zones)
>  {
> -	disk->queue->max_open_zones = max_open_zones;
> +	disk->max_open_zones = max_open_zones;
>  }
>  
>  static inline void disk_set_max_active_zones(struct gendisk *disk,
>  		unsigned int max_active_zones)
>  {
> -	disk->queue->max_active_zones = max_active_zones;
> +	disk->max_active_zones = max_active_zones;
>  }
>  
>  static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
> -	return bdev->bd_disk->queue->max_open_zones;
> +	return bdev->bd_disk->max_open_zones;
>  }
>  
>  static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
>  {
> -	return bdev->bd_disk->queue->max_active_zones;
> +	return bdev->bd_disk->max_active_zones;
>  }
>  
>  #else /* CONFIG_BLK_DEV_ZONED */
> -static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
> +static inline unsigned int disk_nr_zones(struct gendisk *disk)
>  {
>  	return 0;
>  }
> -static inline bool blk_queue_zone_is_seq(struct request_queue *q,
> -					 sector_t sector)
> +static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
>  {
>  	return false;
>  }
> -static inline unsigned int blk_queue_zone_no(struct request_queue *q,
> -					     sector_t sector)
> +static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
>  {
>  	return 0;
>  }
> @@ -734,6 +728,7 @@ static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
>  {
>  	return 0;
>  }
> +
>  static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
>  {
>  	return 0;
> @@ -902,14 +897,12 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
>  
>  static inline unsigned int bio_zone_no(struct bio *bio)
>  {
> -	return blk_queue_zone_no(bdev_get_queue(bio->bi_bdev),
> -				 bio->bi_iter.bi_sector);
> +	return disk_zone_no(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
>  }
>  
>  static inline unsigned int bio_zone_is_seq(struct bio *bio)
>  {
> -	return blk_queue_zone_is_seq(bdev_get_queue(bio->bi_bdev),
> -				     bio->bi_iter.bi_sector);
> +	return disk_zone_is_seq(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
>  }
>  
>  /*


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

