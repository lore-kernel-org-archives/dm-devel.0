Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0355C2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 12:05:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E820E2469D
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 12:05:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E820E2469D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-kbCX6UHTN4-HFxSqmGLWLA-1; Thu, 19 Nov 2020 07:05:46 -0500
X-MC-Unique: kbCX6UHTN4-HFxSqmGLWLA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6643DE758;
	Thu, 19 Nov 2020 12:05:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 753415C1A1;
	Thu, 19 Nov 2020 12:05:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4CA85180954D;
	Thu, 19 Nov 2020 12:05:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJC5XGw021745 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 07:05:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F41502026D13; Thu, 19 Nov 2020 12:05:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EEADD2026D11
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 12:05:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82B80811E78
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 12:05:30 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-533-5w5mj9IAOYyHRNZxcfkdvQ-1;
	Thu, 19 Nov 2020 07:05:27 -0500
X-MC-Unique: 5w5mj9IAOYyHRNZxcfkdvQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E1DC2AA4F;
	Thu, 19 Nov 2020 12:05:25 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 4E3FB1E130B; Thu, 19 Nov 2020 13:05:25 +0100 (CET)
Date: Thu, 19 Nov 2020 13:05:25 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201119120525.GW1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-15-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-15-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 14/20] block: remove the nr_sects field in
 struct hd_struct
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 18-11-20 09:47:54, Christoph Hellwig wrote:
> Now that the hd_struct always has a block device attached to it, there is
> no need for having two size field that just get out of sync.
> 
> Additional the field in hd_struct did not use proper serializiation,
> possibly allowing for torn writes.  By only using the block_device field
> this problem also gets fixed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Overall the patch looks good but I have a couple of comments below.

> diff --git a/block/bio.c b/block/bio.c
> index fa01bef35bb1fe..0c5269997434d6 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -613,7 +613,7 @@ void guard_bio_eod(struct bio *bio)
>  	rcu_read_lock();
>  	part = __disk_get_part(bio->bi_disk, bio->bi_partno);
>  	if (part)
> -		maxsector = part_nr_sects_read(part);
> +		maxsector = bdev_nr_sectors(part->bdev);
>  	else
>  		maxsector = get_capacity(bio->bi_disk);

I have to say that after these changes I find it a bit confusing that we
have get/set_capacity() and bdev_nr_sectors() / bdev_set_nr_sectors() and
they are all the same thing (i_size of the bdev). Is there a reason for the
distinction?

> diff --git a/block/genhd.c b/block/genhd.c
> index 94de95287a6370..e101b6843f7437 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -38,6 +38,16 @@ static void disk_add_events(struct gendisk *disk);
>  static void disk_del_events(struct gendisk *disk);
>  static void disk_release_events(struct gendisk *disk);
>  
> +void set_capacity(struct gendisk *disk, sector_t sectors)
> +{
> +	struct block_device *bdev = disk->part0.bdev;
> +
> +	spin_lock(&bdev->bd_size_lock);
> +	i_size_write(bdev->bd_inode, (loff_t)sectors << SECTOR_SHIFT);
> +	spin_unlock(&bdev->bd_size_lock);

AFAICT bd_size_lock is pointless after these changes so we can just remove
it?

> +}
> +EXPORT_SYMBOL(set_capacity);
> +
>  /*
>   * Set disk capacity and notify if the size is not currently zero and will not
>   * be set to zero.  Returns true if a uevent was sent, otherwise false.
> @@ -47,11 +57,12 @@ bool set_capacity_and_notify(struct gendisk *disk, sector_t size)
>  	sector_t capacity = get_capacity(disk);
>  
>  	set_capacity(disk, size);
> -	revalidate_disk_size(disk, true);
>  
>  	if (capacity != size && capacity != 0 && size != 0) {
>  		char *envp[] = { "RESIZE=1", NULL };
>  
> +		pr_info("%s: detected capacity change from %lld to %lld\n",
> +		       disk->disk_name, size, capacity);

So we are now missing above message for transitions from / to 0 capacity?
Is there any other notification in the kernel log when e.g. media is
inserted into a CD-ROM drive? I remember using these messages for detecting
that...

Also what about GENHD_FL_HIDDEN devices? Are we sure we never set capacity
for them?

>  		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
>  		return true;
>  	}

...

> @@ -983,7 +994,7 @@ void __init printk_all_partitions(void)
>  
>  			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
>  			       bdevt_str(part_devt(part), devt_buf),
> -			       (unsigned long long)part_nr_sects_read(part) >> 1
> +			       bdev_nr_sectors(part->bdev) >> 1
>  			       , disk_name(disk, part->partno, name_buf),
>  			       part->info ? part->info->uuid : "");
>  			if (is_part0) {
> @@ -1076,7 +1087,7 @@ static int show_partition(struct seq_file *seqf, void *v)
>  	while ((part = disk_part_iter_next(&piter)))
>  		seq_printf(seqf, "%4d  %7d %10llu %s\n",
>  			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
> -			   (unsigned long long)part_nr_sects_read(part) >> 1,
> +			   bdev_nr_sectors(part->bdev) >> 1,
>  			   disk_name(sgp, part->partno, buf));
>  	disk_part_iter_exit(&piter);
>  
> @@ -1158,8 +1169,7 @@ ssize_t part_size_show(struct device *dev,
>  {
>  	struct hd_struct *p = dev_to_part(dev);
>  
> -	return sprintf(buf, "%llu\n",
> -		(unsigned long long)part_nr_sects_read(p));
> +	return sprintf(buf, "%llu\n", bdev_nr_sectors(p->bdev));

Is sector_t really guaranteed to be unsigned long long?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

