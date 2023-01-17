Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1FBC54E76
	for <dm-devel@archiver.kernel.org>; Tue, 17 Jan 2023 17:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673977961;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=akwONDrRm+QrSySo/ifawi6MPImRkDSQzXVXjPFI7v0=;
	b=etyNxqpK6ugZOEvu43Amz0O5rOBIdmtUso9na6ZSAXFXdCG4onbuqBEKZ6twpIXiy52LG4
	5uSrh9YTW/JmA5xiI8PfG6kZu8x7NOzNDOUfk6Gi6VdoSZSNWemtShGvRy1K9aoDwO1CoC
	LZyp42P0cB9/G54A5Yr93aXtchE4fZ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-RMqiWWHPPGi5jg_azkXrcQ-1; Tue, 17 Jan 2023 12:52:38 -0500
X-MC-Unique: RMqiWWHPPGi5jg_azkXrcQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 641B71C189A5;
	Tue, 17 Jan 2023 17:52:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 651A4C15BAE;
	Tue, 17 Jan 2023 17:52:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4DEB719465B3;
	Tue, 17 Jan 2023 17:52:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 364BF19465B3
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 Jan 2023 17:52:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 298BD492B11; Tue, 17 Jan 2023 17:52:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 219BA492B10
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 17:52:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01E3029AA38A
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 17:52:29 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-qhQkvEzuO2Sq5zAZ9VP0rg-1; Tue, 17 Jan 2023 12:52:25 -0500
X-MC-Unique: qhQkvEzuO2Sq5zAZ9VP0rg-1
Received: by mail-qv1-f69.google.com with SMTP id
 k15-20020a0cd68f000000b00535261af1b1so1606140qvi.13
 for <dm-devel@redhat.com>; Tue, 17 Jan 2023 09:52:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=7bhc0N8lOZgDifhC2frdOWe817b3omvaW/l36eahars=;
 b=T5MHh5K0P9YJ4MnHMtcQwNSaxT8mpoR92WmH3iryJMcZ68Dvtvtx67w4RqxsnYLYrE
 wxLTp7LSDLgaXHLMcbDIgfDUZPnp8MDhfcp/a4I6VNKQALYo/YL6YHfgtgUphwrbHpQW
 Cuh1MJgkg/g76aDAW273CudDj30s+RF9Qw999YZeedG4ns0D3QvrAI5OJ15akiIzbHmo
 8cIswv0RaEq8XWG77Aj+IeJ9YYA1mI6e78C+Sxpb1/Bq1S0e4cEv4WtrUyQBnRHcXw6d
 7cZd976CBcQZew0+PrriE+fXUcEmgDB4plyH/Wyoa9q1VKE6AN0NJpk07v7v4bLteJp7
 Ka7g==
X-Gm-Message-State: AFqh2kp/nX1kXDkRDAsN8EP81yIXMm3u4pcvWcj6NP1nRYN7Uh0js/wN
 G/GBQfO6Ly1ieCreXUqPf0WHz9HZVnCkqoDjckMQSZWGThKRlO1QxtCwVmao6VKB7DSPT///PkA
 VVGPrVo4MvzMi8Q==
X-Received: by 2002:ac8:480a:0:b0:3ae:55ba:8392 with SMTP id
 g10-20020ac8480a000000b003ae55ba8392mr4862287qtq.32.1673977944873; 
 Tue, 17 Jan 2023 09:52:24 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtgV1rHPprpYlV6nz/fDPisM7ofVJJ0FHk5YLTcA4e90viVYHPitevtt/bN1J4+T4+w8pQt7w==
X-Received: by 2002:ac8:480a:0:b0:3ae:55ba:8392 with SMTP id
 g10-20020ac8480a000000b003ae55ba8392mr4862262qtq.32.1673977944562; 
 Tue, 17 Jan 2023 09:52:24 -0800 (PST)
Received: from localhost (pool-68-160-145-102.bstnma.fios.verizon.net.
 [68.160.145.102]) by smtp.gmail.com with ESMTPSA id
 x21-20020a05620a0b5500b0070688f60025sm2768704qkg.76.2023.01.17.09.52.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 17 Jan 2023 09:52:24 -0800 (PST)
Date: Tue, 17 Jan 2023 12:52:22 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Gulam Mohamed <gulam.mohamed@oracle.com>
Message-ID: <Y8bgVh7HQx9jZWtF@redhat.com>
References: <20221221040506.1174644-1-gulam.mohamed@oracle.com>
 <20221221040506.1174644-2-gulam.mohamed@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20221221040506.1174644-2-gulam.mohamed@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH for-6.2/block V3 2/2] block: Change the
 granularity of io ticks from ms to ns
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
Cc: nvdimm@lists.linux.dev, shminderjit.singh@oracle.com,
 philipp.reisner@linbit.com, song@kernel.org, dm-devel@redhat.com,
 ira.weiny@intel.com, agk@redhat.com, drbd-dev@lists.linbit.com,
 dave.jiang@intel.com, senozhatsky@chromium.org, vishal.l.verma@intel.com,
 joe.jin@oracle.com, kent.overstreet@gmail.com, ngupta@vflare.org,
 kch@nvidia.com, konrad.wilk@oracle.com, snitzer@kernel.org, colyli@suse.de,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 dan.j.williams@intel.com, axboe@kernel.dk, linux-block@vger.kernel.org,
 martin.petersen@oracle.com, rajesh.sivaramasubramaniom@oracle.com,
 minchan@kernel.org, linux-kernel@vger.kernel.org, junxiao.bi@oracle.com,
 christoph.boehmwalder@linbit.com, lars.ellenberg@linbit.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[comments/questions inlined below]

On Tue, Dec 20 2022 at 11:05P -0500,
Gulam Mohamed <gulam.mohamed@oracle.com> wrote:

> Problem Desc
> ============
> The "iostat" user-space utility was showing %util as 100% for the disks
> which has latencies less than a milli-second i.e for latencies in the
> range of micro-seconds and below.
> 
> Root Cause
> ==========
> The IO accounting in block layer is currently done by updating the
> io_ticks in jiffies which is of milli-seconds granularity. Due to this,
> for the devices with IO latencies less than a milli-second, the latency
> will be accounted as 1 milli-second even-though its in the range of
> micro-seconds. This was causing the iostat command to show %util
> as 100% which is incorrect.
> 
> Recreationg of the issue
> ========================
> Setup
> -----
> Devices: NVMe 24 devices
> Model number: 4610 (Intel)
> 
> fio
> ---
> [global]
> bs=4K
> iodepth=1
> direct=1
> ioengine=libaio
> group_reporting
> time_based
> runtime=100
> thinktime=1ms
> numjobs=1
> name=raw-write
> rw=randrw
> ignore_error=EIO:EIO
> [job1]
> filename=/dev/nvme0n1
> 
> iostat o/p
> ----------
> 
> Device   %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme3n1   0.00    0.05    0.00  75.38     0.50     0.00   0.00 100.00
> 
> Device   %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme3n1   0.00    0.05    0.00  74.74     0.50     0.00   0.00 100.00
> 
> Solution
> ========
> Use ktime_get_ns() to update the disk_stats io_ticks so that the io_ticks
> are updated for every io start and end times.
> 
> Issues using ktime
> ==================
> 
> Using ktime_get_ns() has a performance overhead as ktime will go ahead
> and reads the clock everytime its called. Following test environment
> was used by Jens Axboe on which t/io_uring was run which has shown a
> high performance drop.
> 
> Devices
> -------
> SSDs: P5800X
> No of devices: 24
> 
> io_uring config
> ---------------
> Polled IO
> iostats: Enabled
> Reads: Random
> Block Size: 512
> QDepth: 128
> Batch Submit: 32
> Batch Complete: 32
> No of Threads: 24
> 
> With the above environment and ktime patch, it has shown a performance
> drop of ~25% from iostats disabled and ~19% performance drop from current
> iostats enabled. This performance drop is high.
> 
> Suggestion from Jens Axboe
> ==========================
> Jens Axboe suggested to split the bigger patch into two as follows:
> 
> 1. In first patch, change all the types from unsigned long to u64, that
>    can be done while retaining jiffies.
> 
> 2. In second patch, add an iostats == 2 setting, which enables the higher
>    resolution mode using ktime. We'd still default to 1, lower granularity
>    iostats enabled.
> 
> Fix details
> ===========
> 1. Use ktime_get_ns() to get the current nano-seconds to update the
>    io_ticks for start and end time stamps in block layer for io accounting
> 
> 2. Create a new setting '2' in sysfs for iostats variable i.e for
>    /sys/block/<device-name>/queue/iostats, to enable the iostat (io
>    accounting) with nano-seconds (using ktime) granularity. This setting
>    should be enabled only if the iostat is needed with high resolution
>    mode as it has a high performance drop
> 
> 3. Earlier available settings were 0 and 1 for disable and enable io
>    accounting with milli-seconds granularity (jiffies)
> 
> Testing
> =======
> Ran the t/io_uring command with following setup:
> 
> Devices
> -------
> SSDs: P4610
> No of devices: 8
> 
> io_uring config
> ---------------
> Polled IO
> iostats: Enabled
> Reads: Random
> Block Size: 512
> QDepth: 128
> Batch Submit: 32
> Batch Complete: 32
> No of Threads: 24
> 
> io_uring o/p
> ------------
> iostat=0, with patch: Maximum IOPS=10.09M
> iostat=1, with patch: Maximum IOPS=9.84M
> iostat=2, with patch: Maximum IOPS=9.48M
> 
> Changes from V2 to V3
> =====================
> 1. Changed all the required variables data-type to u64 as a first patch
> 2. Create a new setting '2' for iostats in sysfs in this patch
> 3. Change the code to get the ktime values when iostat=2, in this patch
> 
> Signed-off-by: Gulam Mohamed <gulam.mohamed@oracle.com>
> ---
>  block/blk-core.c                  | 26 +++++++++++++++++----
>  block/blk-mq.c                    |  4 ++--
>  block/blk-sysfs.c                 | 39 ++++++++++++++++++++++++++++++-
>  block/genhd.c                     | 18 ++++++++++----
>  drivers/block/drbd/drbd_debugfs.c | 12 ++++++++--
>  drivers/block/zram/zram_drv.c     |  3 ++-
>  drivers/md/dm.c                   | 13 +++++++++--
>  include/linux/blkdev.h            |  4 ++++
>  8 files changed, 103 insertions(+), 16 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 5670032fe932..0b5e4eb909a5 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -927,6 +927,18 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
>  }
>  EXPORT_SYMBOL_GPL(iocb_bio_iopoll);
>  
> +/*
> + * Get the time based upon the available granularity for io accounting
> + * If the resolution mode is set to precise (2) i.e
> + * (/sys/block/<device>/queue/iostats = 2), then this will return time
> + * in nano-seconds else this will return time in jiffies
> + */
> +u64  blk_get_iostat_ticks(struct request_queue *q)
> +{
> +       return (blk_queue_precise_io_stat(q) ? ktime_get_ns() : jiffies);
> +}
> +EXPORT_SYMBOL_GPL(blk_get_iostat_ticks);
> +

Would prefer to see blk_get_iostat_ticks tagged with 'static inline'
and moved to blkdev.h (obviously below blk_queue_precise_io_stat).

Also, just a general comment: I've historically been a bigger (ab)user
of jump_labels to avoid excess branching costs per IO, e.g. see commit
442761fd2b29 ("dm: conditionally enable branching for less used features").
It could be there is an opportunity for a follow-on patch that
leverages them?  Or should that just be left to each driver to decide
to do with its own resources (rather than have block core provide that)?

(if nothing in the system ever uses QUEUE_FLAG_PRECISE_IO_STAT then
it'd be nice to avoid needless branching).

<snip>

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 011a85ea40da..1bb58a0b8cd1 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -482,7 +482,11 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
>  
>  u64 dm_start_time_ns_from_clone(struct bio *bio)
>  {
> -	return jiffies_to_nsecs(clone_to_tio(bio)->io->start_time);
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +	u64 start_time_ns = (blk_queue_precise_io_stat(q) ?
> +				clone_to_tio(bio)->io->start_time :
> +				jiffies_to_nsecs(clone_to_tio(bio)->io->start_time));
> +	return start_time_ns;
>  }
>  EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
>  
> @@ -498,6 +502,11 @@ static void dm_io_acct(struct dm_io *io, bool end)
>  	struct mapped_device *md = io->md;
>  	struct bio *bio = io->orig_bio;
>  	unsigned int sectors;
> +	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> +
> +	u64 start_time = (blk_queue_precise_io_stat(q) ?
> +				nsecs_to_jiffies(io->start_time) :
> +				io->start_time);
>  
>  	/*
>  	 * If REQ_PREFLUSH set, don't account payload, it will be
> @@ -589,7 +598,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
>  	io->orig_bio = bio;
>  	io->md = md;
>  	spin_lock_init(&io->lock);
> -	io->start_time = jiffies;
> +	io->start_time = blk_get_iostat_ticks(bio->bi_bdev->bd_queue);
>  	io->flags = 0;
>  
>  	if (static_branch_unlikely(&stats_enabled))

The above seems correct, by checking the top-level DM device's
disposition on QUEUE_FLAG_PRECISE_IO_STAT, but I'm now wondering
if there should be code that ensures consistency across stacked
devices (which DM is the biggest creator/consumer of)?

dm_table_set_restrictions() deals with such inconsistencies at DM
device creation time (so basically: if any device in the DM table has
QUEUE_FLAG_PRECISE_IO_STAT set then the top-level DM device should
inherit that queue flag). A user could still override it but at least
the default will be sane initially.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

