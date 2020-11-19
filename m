Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E33F4C388F9
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 09:42:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0394C2469D
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 09:42:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0394C2469D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-BDjaLNWCP7SDMYi8NBd-pw-1; Thu, 19 Nov 2020 04:42:16 -0500
X-MC-Unique: BDjaLNWCP7SDMYi8NBd-pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9154E186E8E8;
	Thu, 19 Nov 2020 09:42:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7908E5D6A8;
	Thu, 19 Nov 2020 09:42:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 084B04BB7B;
	Thu, 19 Nov 2020 09:42:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ9g5iL028781 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 04:42:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 29C7D1004151; Thu, 19 Nov 2020 09:42:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2493810FD28C
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 09:42:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB842800B3A
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 09:42:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-255-Z7wmE6W8PHew0ntrzPN7XA-1;
	Thu, 19 Nov 2020 04:41:59 -0500
X-MC-Unique: Z7wmE6W8PHew0ntrzPN7XA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A3791AC98;
	Thu, 19 Nov 2020 09:41:57 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 286A51E1303; Thu, 19 Nov 2020 10:41:57 +0100 (CET)
Date: Thu, 19 Nov 2020 10:41:57 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201119094157.GT1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-12-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-12-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Subject: Re: [dm-devel] [PATCH 11/20] block: reference struct block_device
 from struct hd_struct
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 18-11-20 09:47:51, Christoph Hellwig wrote:
> To simplify block device lookup and a few other upcomdin areas, make sure
> that we always have a struct block_device available for each disk and
> each partition.  The only downside of this is that each device and
> partition uses a little more memories.  The upside will be that a lot of
				^^^ memory

> code can be simplified.
> 
> With that all we need to look up the block device is to lookup the inode
> and do a few sanity checks on the gendisk, instead of the separate lookup
> for the gendisk.
> 
> As part of the change switch bdget() to only find existing block devices,
> given that we know that the block_device structure must be allocated at
> probe / partition scan time.
> 
> blk-cgroup needed a bit of a special treatment as the only place that
> wanted to lookup a gendisk outside of the normal blkdev_get path.  It is
> switched to lookup using the block device hash now that this is the
> primary lookup path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The patch looks good to me and I like the simplifications! I've found just
one small issue below.

> @@ -1748,16 +1600,18 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
>  	if (!disk)
>  		return NULL;
>  
> +	disk->part0.bdev = bdev_alloc(disk, 0);
> +	if (!disk->part0.bdev)
> +		goto out_free_disk;
> +
>  	disk->part0.dkstats = alloc_percpu(struct disk_stats);
>  	if (!disk->part0.dkstats)
> -		goto out_free_disk;
> +		goto out_bdput;
>  
>  	init_rwsem(&disk->lookup_sem);
>  	disk->node_id = node_id;
> -	if (disk_expand_part_tbl(disk, 0)) {
> -		free_percpu(disk->part0.dkstats);
> -		goto out_free_disk;
> -	}
> +	if (disk_expand_part_tbl(disk, 0))
> +		goto out_free_bdstats;
>  
>  	ptbl = rcu_dereference_protected(disk->part_tbl, 1);
>  	rcu_assign_pointer(ptbl->part[0], &disk->part0);
> @@ -1772,8 +1626,10 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
>  	 * converted to make use of bd_mutex and sequence counters.
>  	 */
>  	hd_sects_seq_init(&disk->part0);
> -	if (hd_ref_init(&disk->part0))
> -		goto out_free_part0;
> +	if (hd_ref_init(&disk->part0)) {
> +		hd_free_part(&disk->part0);

Aren't you missing kfree(disk) here?

> +		return NULL;
> +	}
>  
>  	disk->minors = minors;
>  	rand_initialize_disk(disk);

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

