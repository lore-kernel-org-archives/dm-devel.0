Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D53C56201
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:32:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 34F7D204EC
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:32:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34F7D204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-h7I5ce5GP2-CEqyQOr5XRw-1; Tue, 24 Nov 2020 08:32:44 -0500
X-MC-Unique: h7I5ce5GP2-CEqyQOr5XRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE57618C43C8;
	Tue, 24 Nov 2020 13:32:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DAB5100164C;
	Tue, 24 Nov 2020 13:32:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 386C21809C9F;
	Tue, 24 Nov 2020 13:32:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODWb2x018920 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:32:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B36C3111286D; Tue, 24 Nov 2020 13:32:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFEEE1112869
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:32:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 862CA800B3B
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:32:36 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-344--d8v6hj-NG68CqL9ADGirQ-1;
	Tue, 24 Nov 2020 08:32:32 -0500
X-MC-Unique: -d8v6hj-NG68CqL9ADGirQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A52D5AC66;
	Tue, 24 Nov 2020 13:32:30 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-39-hch@lst.de>
From: Coly Li <colyli@suse.de>
Message-ID: <4cdd6877-f4fd-8022-4a4f-3eabb86af2b9@suse.de>
Date: Tue, 24 Nov 2020 21:32:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-39-hch@lst.de>
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 38/45] block: switch partition lookup to use
 struct block_device
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/24/20 9:27 PM, Christoph Hellwig wrote:
> Use struct block_device to lookup partitions on a disk.  This removes
> all usage of struct hd_struct from the I/O path, and this allows removing
> the percpu refcount in struct hd_struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


For the bcache part, Acked-by: Coly Li <colyli@suse.de>

> ---
>  block/bio.c                        |  4 +-
>  block/blk-core.c                   | 66 ++++++++++++++----------------
>  block/blk-flush.c                  |  2 +-
>  block/blk-mq.c                     |  9 ++--
>  block/blk-mq.h                     |  7 ++--
>  block/blk.h                        |  4 +-
>  block/genhd.c                      | 56 +++++++++++++------------
>  block/partitions/core.c            |  7 +---
>  drivers/block/drbd/drbd_receiver.c |  2 +-
>  drivers/block/drbd/drbd_worker.c   |  2 +-
>  drivers/block/zram/zram_drv.c      |  2 +-
>  drivers/md/bcache/request.c        |  4 +-
>  drivers/md/dm.c                    |  4 +-
>  drivers/md/md.c                    |  4 +-
>  drivers/nvme/target/admin-cmd.c    | 20 ++++-----
>  fs/ext4/super.c                    | 18 +++-----
>  fs/ext4/sysfs.c                    | 10 +----
>  fs/f2fs/f2fs.h                     |  2 +-
>  fs/f2fs/super.c                    |  6 +--
>  include/linux/blkdev.h             |  8 ++--
>  include/linux/genhd.h              |  4 +-
>  include/linux/part_stat.h          | 17 ++++----
>  22 files changed, 120 insertions(+), 138 deletions(-)
[snipped]

> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index afac8d07c1bd00..85b1f2a9b72d68 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -475,7 +475,7 @@ struct search {
>  	unsigned int		read_dirty_data:1;
>  	unsigned int		cache_missed:1;
>  
> -	struct hd_struct	*part;
> +	struct block_device	*part;
>  	unsigned long		start_time;
>  
>  	struct btree_op		op;
> @@ -1073,7 +1073,7 @@ struct detached_dev_io_private {
>  	unsigned long		start_time;
>  	bio_end_io_t		*bi_end_io;
>  	void			*bi_private;
> -	struct hd_struct	*part;
> +	struct block_device	*part;
>  };
[snipped]

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

