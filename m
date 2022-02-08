Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07E4C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:43:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-DI_ao5XhOjibTOg9iLekaA-1; Tue, 08 Feb 2022 17:43:52 -0500
X-MC-Unique: DI_ao5XhOjibTOg9iLekaA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55B1D4686C;
	Tue,  8 Feb 2022 22:43:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9DCF1037F4A;
	Tue,  8 Feb 2022 22:43:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D046182A8E8;
	Tue,  8 Feb 2022 22:43:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21872dnc020606 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Feb 2022 02:02:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7D6D240CFD02; Tue,  8 Feb 2022 07:02:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76F07400DAF7
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 07:02:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8772800B26
	for <dm-devel@redhat.com>; Tue,  8 Feb 2022 07:02:38 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-653-eq7yGO5-PtGmBdcHy4rgxA-1; Tue, 08 Feb 2022 02:02:36 -0500
X-MC-Unique: eq7yGO5-PtGmBdcHy4rgxA-1
X-IronPort-AV: E=Sophos;i="5.88,352,1635177600"; d="scan'208";a="192392790"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 08 Feb 2022 15:01:30 +0800
IronPort-SDR: pYii7FFqb261oFAukUjUEaEe1cjaFSJdq4iKUr3UyPH2X2J2JRuOJZrFWvEyFg46L414IIKfub
	DnBLKvOgYZjg+ic89TQHxoN2/ZP1Ye0u+et/GQsPsAHPBWvxDJ30FH8gP0RsnXTAplFg3YheaT
	MF7YxeCQyelaD/yhQokyOgW2700D7gPnhm6EJ9fp2SqXCKW4r1AeLVWJgwtGywj4Enjs/w/u9o
	rG8RvBX/96Asxz6rvwhE9DVA3DlvGH4TGLITRKuNF83EAzqyxMrblf6aJCoCXT/0LUHDNxM+zG
	jmzYkYsBU7421PTBJcMYiyGF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	07 Feb 2022 22:33:21 -0800
IronPort-SDR: uX33c+vh2OJ7Kv4q8X0LuYUu2Z/uP6hBeYpdSgOLF1+eqfprib26QOPSAIuUPLZ9ZqcUvYJEoU
	+j+hhywcf2D2MFqFkqBnF1GUiA5zda+KDsN4qwfkjh1Fw2hnj8HazxmON/POUyc1SXi79U1ikV
	Rhi3dNWMUDC4cG/gLjTzWGKi/JwOjP8nfbga70XpW1SEwz1zZYTlESuUDy4DyKdm/fI+SNnVI2
	c2cyvTKtxiJ7+hR2YBn45zMzbOY2rzVMvgjwfPjGEY0seS7SktDmZwCL3irjn8YB6qYLBJOdlY
	ktY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
	by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	07 Feb 2022 23:01:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JtDSq1fQ9z1SVp4
	for <dm-devel@redhat.com>; Mon,  7 Feb 2022 23:01:31 -0800 (PST)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	(amavisd-new, port 10026)
	with ESMTP id 1VQ5mHYGSQTk for <dm-devel@redhat.com>;
	Mon,  7 Feb 2022 23:01:29 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JtDSh47jKz1Rwrw;
	Mon,  7 Feb 2022 23:01:24 -0800 (PST)
Message-ID: <af214223-8bb9-a1ca-6394-9c403c9becef@opensource.wdc.com>
Date: Tue, 8 Feb 2022 16:01:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Nitesh Shetty <nj.shetty@samsung.com>, mpatocka@redhat.com
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141913epcas5p4d41cb549b7cca1ede5c7a66bbd110da0@epcas5p4.samsung.com>
	<20220207141348.4235-3-nj.shetty@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220207141348.4235-3-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, zach.brown@ni.com, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	axboe@kernel.dk, tytso@mit.edu, joshi.k@samsung.com,
	martin.petersen@oracle.com, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH v2 02/10] block: Introduce queue limits for
 copy-offload support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

On 2/7/22 23:13, Nitesh Shetty wrote:
> Add device limits as sysfs entries,
>         - copy_offload (READ_WRITE)
>         - max_copy_sectors (READ_ONLY)

Why read-only ? With the name as you have it, it seems to be the soft
control for the max size of copy operations rather than the actual
device limit. So it would be better to align to other limits like max
sectors/max_hw_sectors and have:

	max_copy_sectors (RW)
	max_hw_copy_sectors (RO)

>         - max_copy_ranges_sectors (READ_ONLY)
>         - max_copy_nr_ranges (READ_ONLY)

Same for these.

> 
> copy_offload(= 0), is disabled by default. This needs to be enabled if
> copy-offload needs to be used.

How does this work ? This limit will be present for a DM device AND the
underlying devices of the DM target. But "offload" applies only to the
underlying devices, not the DM device...

Also, since this is not an underlying device limitation but an on/off
switch, this should probably be moved to a request_queue boolean field
or flag bit, controlled with sysfs.

> max_copy_sectors = 0, indicates the device doesn't support native copy.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/blk-settings.c   |  4 ++++
>  block/blk-sysfs.c      | 51 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blkdev.h | 12 ++++++++++
>  3 files changed, 67 insertions(+)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index b880c70e22e4..818454552cf8 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -57,6 +57,10 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->misaligned = 0;
>  	lim->zoned = BLK_ZONED_NONE;
>  	lim->zone_write_granularity = 0;
> +	lim->copy_offload = 0;
> +	lim->max_copy_sectors = 0;
> +	lim->max_copy_nr_ranges = 0;
> +	lim->max_copy_range_sectors = 0;
>  }
>  EXPORT_SYMBOL(blk_set_default_limits);
>  
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 9f32882ceb2f..dc68ae6b55c9 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -171,6 +171,48 @@ static ssize_t queue_discard_granularity_show(struct request_queue *q, char *pag
>  	return queue_var_show(q->limits.discard_granularity, page);
>  }
>  
> +static ssize_t queue_copy_offload_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->limits.copy_offload, page);
> +}
> +
> +static ssize_t queue_copy_offload_store(struct request_queue *q,
> +				       const char *page, size_t count)
> +{
> +	unsigned long copy_offload;
> +	ssize_t ret = queue_var_store(&copy_offload, page, count);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (copy_offload && q->limits.max_copy_sectors == 0)
> +		return -EINVAL;
> +
> +	if (copy_offload)
> +		q->limits.copy_offload = BLK_COPY_OFFLOAD;
> +	else
> +		q->limits.copy_offload = 0;
> +
> +	return ret;
> +}
> +
> +static ssize_t queue_max_copy_sectors_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->limits.max_copy_sectors, page);
> +}
> +
> +static ssize_t queue_max_copy_range_sectors_show(struct request_queue *q,
> +		char *page)
> +{
> +	return queue_var_show(q->limits.max_copy_range_sectors, page);
> +}
> +
> +static ssize_t queue_max_copy_nr_ranges_show(struct request_queue *q,
> +		char *page)
> +{
> +	return queue_var_show(q->limits.max_copy_nr_ranges, page);
> +}
> +
>  static ssize_t queue_discard_max_hw_show(struct request_queue *q, char *page)
>  {
>  
> @@ -597,6 +639,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
>  QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
>  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
>  
> +QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
> +QUEUE_RO_ENTRY(queue_max_copy_sectors, "max_copy_sectors");
> +QUEUE_RO_ENTRY(queue_max_copy_range_sectors, "max_copy_range_sectors");
> +QUEUE_RO_ENTRY(queue_max_copy_nr_ranges, "max_copy_nr_ranges");
> +
>  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
>  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
>  QUEUE_RW_ENTRY(queue_poll, "io_poll");
> @@ -643,6 +690,10 @@ static struct attribute *queue_attrs[] = {
>  	&queue_discard_max_entry.attr,
>  	&queue_discard_max_hw_entry.attr,
>  	&queue_discard_zeroes_data_entry.attr,
> +	&queue_copy_offload_entry.attr,
> +	&queue_max_copy_sectors_entry.attr,
> +	&queue_max_copy_range_sectors_entry.attr,
> +	&queue_max_copy_nr_ranges_entry.attr,
>  	&queue_write_same_max_entry.attr,
>  	&queue_write_zeroes_max_entry.attr,
>  	&queue_zone_append_max_entry.attr,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index efed3820cbf7..f63ae50f1de3 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -51,6 +51,12 @@ extern struct class block_class;
>  /* Doing classic polling */
>  #define BLK_MQ_POLL_CLASSIC -1
>  
> +/* Define copy offload options */
> +enum blk_copy {
> +	BLK_COPY_EMULATE = 0,
> +	BLK_COPY_OFFLOAD,
> +};
> +
>  /*
>   * Maximum number of blkcg policies allowed to be registered concurrently.
>   * Defined here to simplify include dependency.
> @@ -253,6 +259,10 @@ struct queue_limits {
>  	unsigned int		discard_granularity;
>  	unsigned int		discard_alignment;
>  	unsigned int		zone_write_granularity;
> +	unsigned int            copy_offload;
> +	unsigned int            max_copy_sectors;
> +	unsigned short          max_copy_range_sectors;
> +	unsigned short          max_copy_nr_ranges;
>  
>  	unsigned short		max_segments;
>  	unsigned short		max_integrity_segments;
> @@ -562,6 +572,7 @@ struct request_queue {
>  #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
>  #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
>  #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
> +#define QUEUE_FLAG_COPY		30	/* supports copy offload */

Then what is the point of max_copy_sectors limit ? You can test support
by the device by looking at max_copy_sectors != 0, no ? This flag is
duplicated information.
I would rather use it for the on/off switch for the copy offload,
removing the copy_offload limit.

>  
>  #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_SAME_COMP) |		\
> @@ -585,6 +596,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
>  #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
>  #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
>  #define blk_queue_discard(q)	test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_flags)
> +#define blk_queue_copy(q)	test_bit(QUEUE_FLAG_COPY, &(q)->queue_flags)
>  #define blk_queue_zone_resetall(q)	\
>  	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
>  #define blk_queue_secure_erase(q) \


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

