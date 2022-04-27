Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55B2AC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 01:59:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-_3DmtmdFM62Yegloa8k-dw-1; Tue, 26 Apr 2022 21:59:23 -0400
X-MC-Unique: _3DmtmdFM62Yegloa8k-dw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5610685A5A8;
	Wed, 27 Apr 2022 01:59:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F32994087D61;
	Wed, 27 Apr 2022 01:59:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6962A1947BBE;
	Wed, 27 Apr 2022 01:59:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1F06519451F0
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 01:59:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 012CF20296A6; Wed, 27 Apr 2022 01:59:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFDF420296A5
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:59:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E4E486B8A4
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 01:59:16 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-rOkSZH-aOki3qu3L9tkH1Q-1; Tue, 26 Apr 2022 21:59:14 -0400
X-MC-Unique: rOkSZH-aOki3qu3L9tkH1Q-1
X-IronPort-AV: E=Sophos;i="5.90,292,1643644800"; d="scan'208";a="310879646"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 27 Apr 2022 09:59:12 +0800
IronPort-SDR: XlLocv4vod79PqS+abkD+PwHq6RB7cAhGXIRnK8rgYvb9xKs1Doy+hotVQoznR/3Gxw6XkTnbb
 sHrWWzGz7ON+DwehBqk0zstEW6Ne7U8TDL3ls2/exN+5xllFO5xD/GRwB97L13wTYSymIgkV+W
 gKe08a5xdZczijf6k+YgyeyLobFkFYUCI3ey+cZRXQOY9icb+uQq8nExClcGPksdfeQvwPodYy
 tIDVJJ6wC+/SXIVtuiBSmxmE181YNad7KVbRT/kL+UROiy/tN7L3xhcNbwCUjIi0/VUQFev02G
 dCjG4RxucHJnpPI0P+rkNhzf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:29:22 -0700
IronPort-SDR: MJhSyB15fdP6+662O9ydsqbyDnYeFf9WYw6ySXG2AD1Nr2Uw85P18eZoPCtugXZyLS9sJmnYr0
 bkwq3ug+Z3hS5k+94p2l3zmfSJo6ptFZhLgYYiquaxY2YzZB0vRg4xv72hCcCnuep7ndl8RFkb
 L8K5z1/umGxkXUVDk03Xzvr6YfzQl5zb9WNCUxXoq9kAd/nKL7YaPwy4f6PByCD/av0XuOvoVI
 h0pedraug2q23uJ+91Ke9f6LJed0/GAVIZQzoiDIzmca05ktJ3jPrSy8w/0RFVqGfsMw/ZX6Fm
 jzw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 26 Apr 2022 18:59:12 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kp2400xGvz1Rvlx
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 18:59:11 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id kYycyugIgNhp for <dm-devel@redhat.com>;
 Tue, 26 Apr 2022 18:59:07 -0700 (PDT)
Received: from [10.225.163.27] (unknown [10.225.163.27])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kp23p3D6Gz1Rvlc;
 Tue, 26 Apr 2022 18:59:02 -0700 (PDT)
Message-ID: <0d52ad34-ab75-9672-321f-34053421c0c4@opensource.wdc.com>
Date: Wed, 27 Apr 2022 10:59:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101910epcas5p4fd64f83c6da9bbd891107d158a2743b5@epcas5p4.samsung.com>
 <20220426101241.30100-2-nj.shetty@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220426101241.30100-2-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v4 01/10] block: Introduce queue limits for
 copy-offload support
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
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu,
 Kanchan Joshi <joshi.k@samsung.com>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, Arnav Dawn <arnav.dawn@samsung.com>,
 jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/26/22 19:12, Nitesh Shetty wrote:
> Add device limits as sysfs entries,
>         - copy_offload (RW)
>         - copy_max_bytes (RW)
>         - copy_max_hw_bytes (RO)
>         - copy_max_range_bytes (RW)
>         - copy_max_range_hw_bytes (RO)
>         - copy_max_nr_ranges (RW)
>         - copy_max_nr_ranges_hw (RO)
> 
> Above limits help to split the copy payload in block layer.
> copy_offload, used for setting copy offload(1) or emulation(0).
> copy_max_bytes: maximum total length of copy in single payload.
> copy_max_range_bytes: maximum length in a single entry.
> copy_max_nr_ranges: maximum number of entries in a payload.
> copy_max_*_hw_*: Reflects the device supported maximum limits.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Arnav Dawn <arnav.dawn@samsung.com>
> ---
>  Documentation/ABI/stable/sysfs-block |  83 ++++++++++++++++
>  block/blk-settings.c                 |  59 ++++++++++++
>  block/blk-sysfs.c                    | 138 +++++++++++++++++++++++++++
>  include/linux/blkdev.h               |  13 +++
>  4 files changed, 293 insertions(+)
> 
> diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
> index e8797cd09aff..65e64b5a0105 100644
> --- a/Documentation/ABI/stable/sysfs-block
> +++ b/Documentation/ABI/stable/sysfs-block
> @@ -155,6 +155,89 @@ Description:
>  		last zone of the device which may be smaller.
>  
>  
> +What:		/sys/block/<disk>/queue/copy_offload
> +Date:		April 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RW] When read, this file shows whether offloading copy to
> +		device is enabled (1) or disabled (0). Writing '0' to this
> +		file will disable offloading copies for this device.
> +		Writing any '1' value will enable this feature.
> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_bytes
> +Date:		April 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RW] While 'copy_max_hw_bytes' is the hardware limit for the
> +		device, 'copy_max_bytes' setting is the software limit.
> +		Setting this value lower will make Linux issue smaller size
> +		copies.
> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_hw_bytes
> +Date:		April 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RO] Devices that support offloading copy functionality may have
> +		internal limits on the number of bytes that can be offloaded
> +		in a single operation. The `copy_max_hw_bytes`
> +		parameter is set by the device driver to the maximum number of
> +		bytes that can be copied in a single operation. Copy
> +		requests issued to the device must not exceed this limit.
> +		A value of 0 means that the device does not
> +		support copy offload.
> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_nr_ranges
> +Date:		April 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RW] While 'copy_max_nr_ranges_hw' is the hardware limit for the
> +		device, 'copy_max_nr_ranges' setting is the software limit.
> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_nr_ranges_hw
> +Date:		April 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RO] Devices that support offloading copy functionality may have
> +		internal limits on the number of ranges in single copy operation
> +		that can be offloaded in a single operation.
> +		A range is tuple of source, destination and length of data
> +		to be copied. The `copy_max_nr_ranges_hw` parameter is set by
> +		the device driver to the maximum number of ranges that can be
> +		copied in a single operation. Copy requests issued to the device
> +		must not exceed this limit. A value of 0 means that the device
> +		does not support copy offload.
> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_range_bytes
> +Date:		April 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RW] While 'copy_max_range_hw_bytes' is the hardware limit for
> +		the device, 'copy_max_range_bytes' setting is the software
> +		limit.
> +
> +
> +What:		/sys/block/<disk>/queue/copy_max_range_hw_bytes
> +Date:		April 2022
> +Contact:	linux-block@vger.kernel.org
> +Description:
> +		[RO] Devices that support offloading copy functionality may have
> +		internal limits on the size of data, that can be copied in a
> +		single range within a single copy operation.
> +		A range is tuple of source, destination and length of data to be
> +		copied. The `copy_max_range_hw_bytes` parameter is set by the
> +		device driver to set the maximum length in bytes of a range
> +		that can be copied in an operation.
> +		Copy requests issued to the device must not exceed this limit.
> +		Sum of sizes of all ranges in a single opeartion should not
> +		exceed 'copy_max_hw_bytes'. A value of 0 means that the device
> +		does not support copy offload.
> +
> +
>  What:		/sys/block/<disk>/queue/crypto/
>  Date:		February 2022
>  Contact:	linux-block@vger.kernel.org
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 6ccceb421ed2..70167aee3bf7 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -57,6 +57,12 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->misaligned = 0;
>  	lim->zoned = BLK_ZONED_NONE;
>  	lim->zone_write_granularity = 0;
> +	lim->max_hw_copy_sectors = 0;

For readability, I would keep "hw" next to sectors/nr_ranges:

max_copy_hw_sectors
max_copy_sectors
max_copy_hw_nr_ranges
max_copy_nr_ranges
max_copy_range_hw_sectors
max_copy_range_sectors

> +	lim->max_copy_sectors = 0;
> +	lim->max_hw_copy_nr_ranges = 0;
> +	lim->max_copy_nr_ranges = 0;
> +	lim->max_hw_copy_range_sectors = 0;
> +	lim->max_copy_range_sectors = 0;
>  }
>  EXPORT_SYMBOL(blk_set_default_limits);
>  
> @@ -81,6 +87,12 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	lim->max_dev_sectors = UINT_MAX;
>  	lim->max_write_zeroes_sectors = UINT_MAX;
>  	lim->max_zone_append_sectors = UINT_MAX;
> +	lim->max_hw_copy_sectors = ULONG_MAX;
> +	lim->max_copy_sectors = ULONG_MAX;
> +	lim->max_hw_copy_range_sectors = UINT_MAX;
> +	lim->max_copy_range_sectors = UINT_MAX;
> +	lim->max_hw_copy_nr_ranges = USHRT_MAX;
> +	lim->max_copy_nr_ranges = USHRT_MAX;
>  }
>  EXPORT_SYMBOL(blk_set_stacking_limits);
>  
> @@ -177,6 +189,45 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
>  }
>  EXPORT_SYMBOL(blk_queue_max_discard_sectors);
>  
> +/**
> + * blk_queue_max_copy_sectors - set max sectors for a single copy payload
> + * @q:  the request queue for the device
> + * @max_copy_sectors: maximum number of sectors to copy
> + **/
> +void blk_queue_max_copy_sectors(struct request_queue *q,

This should be blk_queue_max_copy_hw_sectors().

> +		unsigned int max_copy_sectors)
> +{
> +	q->limits.max_hw_copy_sectors = max_copy_sectors;
> +	q->limits.max_copy_sectors = max_copy_sectors;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors);
> +
> +/**
> + * blk_queue_max_copy_range_sectors - set max sectors for a single range, in a copy payload
> + * @q:  the request queue for the device
> + * @max_copy_range_sectors: maximum number of sectors to copy in a single range
> + **/
> +void blk_queue_max_copy_range_sectors(struct request_queue *q,

And this should be blk_queue_max_copy_range_hw_sectors(). Etc for the
other ones below.

> +		unsigned int max_copy_range_sectors)
> +{
> +	q->limits.max_hw_copy_range_sectors = max_copy_range_sectors;
> +	q->limits.max_copy_range_sectors = max_copy_range_sectors;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_range_sectors);
> +
> +/**
> + * blk_queue_max_copy_nr_ranges - set max number of ranges, in a copy payload
> + * @q:  the request queue for the device
> + * @max_copy_nr_ranges: maximum number of ranges
> + **/
> +void blk_queue_max_copy_nr_ranges(struct request_queue *q,
> +		unsigned int max_copy_nr_ranges)
> +{
> +	q->limits.max_hw_copy_nr_ranges = max_copy_nr_ranges;
> +	q->limits.max_copy_nr_ranges = max_copy_nr_ranges;
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_max_copy_nr_ranges);
> +
>  /**
>   * blk_queue_max_secure_erase_sectors - set max sectors for a secure erase
>   * @q:  the request queue for the device
> @@ -572,6 +623,14 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  	t->max_segment_size = min_not_zero(t->max_segment_size,
>  					   b->max_segment_size);
>  
> +	t->max_copy_sectors = min(t->max_copy_sectors, b->max_copy_sectors);
> +	t->max_hw_copy_sectors = min(t->max_hw_copy_sectors, b->max_hw_copy_sectors);
> +	t->max_copy_range_sectors = min(t->max_copy_range_sectors, b->max_copy_range_sectors);
> +	t->max_hw_copy_range_sectors = min(t->max_hw_copy_range_sectors,
> +						b->max_hw_copy_range_sectors);
> +	t->max_copy_nr_ranges = min(t->max_copy_nr_ranges, b->max_copy_nr_ranges);
> +	t->max_hw_copy_nr_ranges = min(t->max_hw_copy_nr_ranges, b->max_hw_copy_nr_ranges);
> +
>  	t->misaligned |= b->misaligned;
>  
>  	alignment = queue_limit_alignment_offset(b, start);
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 88bd41d4cb59..bae987c10f7f 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -212,6 +212,129 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
>  	return queue_var_show(0, page);
>  }
>  
> +static ssize_t queue_copy_offload_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(blk_queue_copy(q), page);
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
> +	if (copy_offload && !q->limits.max_hw_copy_sectors)
> +		return -EINVAL;
> +
> +	if (copy_offload)
> +		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
> +	else
> +		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
> +
> +	return ret;
> +}
> +
> +static ssize_t queue_copy_max_hw_show(struct request_queue *q, char *page)
> +{
> +	return sprintf(page, "%llu\n",
> +		(unsigned long long)q->limits.max_hw_copy_sectors << 9);
> +}
> +
> +static ssize_t queue_copy_max_show(struct request_queue *q, char *page> +{
> +	return sprintf(page, "%llu\n",
> +		(unsigned long long)q->limits.max_copy_sectors << 9);
> +}
> +
> +static ssize_t queue_copy_max_store(struct request_queue *q,
> +				       const char *page, size_t count)
> +{
> +	unsigned long max_copy;
> +	ssize_t ret = queue_var_store(&max_copy, page, count);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (max_copy & (queue_logical_block_size(q) - 1))
> +		return -EINVAL;
> +
> +	max_copy >>= 9;
> +	if (max_copy > q->limits.max_hw_copy_sectors)
> +		max_copy = q->limits.max_hw_copy_sectors;
> +
> +	q->limits.max_copy_sectors = max_copy;
> +	return ret;
> +}
> +
> +static ssize_t queue_copy_range_max_hw_show(struct request_queue *q, char *page)
> +{
> +	return sprintf(page, "%llu\n",
> +		(unsigned long long)q->limits.max_hw_copy_range_sectors << 9);
> +}
> +
> +static ssize_t queue_copy_range_max_show(struct request_queue *q,
> +		char *page)
> +{
> +	return sprintf(page, "%llu\n",
> +		(unsigned long long)q->limits.max_copy_range_sectors << 9);
> +}
> +
> +static ssize_t queue_copy_range_max_store(struct request_queue *q,
> +				       const char *page, size_t count)
> +{
> +	unsigned long max_copy;
> +	ssize_t ret = queue_var_store(&max_copy, page, count);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (max_copy & (queue_logical_block_size(q) - 1))
> +		return -EINVAL;
> +
> +	max_copy >>= 9;
> +	if (max_copy > UINT_MAX)

On 32-bits arch, unsigned long and unsigned int are the same so this test
is useless for these arch. Better have max_copy declared as unsigned long
long.

> +		return -EINVAL;
> +
> +	if (max_copy > q->limits.max_hw_copy_range_sectors)
> +		max_copy = q->limits.max_hw_copy_range_sectors;
> +
> +	q->limits.max_copy_range_sectors = max_copy;
> +	return ret;
> +}
> +
> +static ssize_t queue_copy_nr_ranges_max_hw_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->limits.max_hw_copy_nr_ranges, page);
> +}
> +
> +static ssize_t queue_copy_nr_ranges_max_show(struct request_queue *q,
> +		char *page)
> +{
> +	return queue_var_show(q->limits.max_copy_nr_ranges, page);
> +}
> +
> +static ssize_t queue_copy_nr_ranges_max_store(struct request_queue *q,
> +				       const char *page, size_t count)
> +{
> +	unsigned long max_nr;
> +	ssize_t ret = queue_var_store(&max_nr, page, count);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (max_nr > USHRT_MAX)
> +		return -EINVAL;
> +
> +	if (max_nr > q->limits.max_hw_copy_nr_ranges)
> +		max_nr = q->limits.max_hw_copy_nr_ranges;
> +
> +	q->limits.max_copy_nr_ranges = max_nr;
> +	return ret;
> +}
> +
>  static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
>  {
>  	return queue_var_show(0, page);
> @@ -596,6 +719,14 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
>  QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
>  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
>  
> +QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
> +QUEUE_RO_ENTRY(queue_copy_max_hw, "copy_max_hw_bytes");
> +QUEUE_RW_ENTRY(queue_copy_max, "copy_max_bytes");
> +QUEUE_RO_ENTRY(queue_copy_range_max_hw, "copy_max_range_hw_bytes");
> +QUEUE_RW_ENTRY(queue_copy_range_max, "copy_max_range_bytes");
> +QUEUE_RO_ENTRY(queue_copy_nr_ranges_max_hw, "copy_max_nr_ranges_hw");
> +QUEUE_RW_ENTRY(queue_copy_nr_ranges_max, "copy_max_nr_ranges");
> +
>  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
>  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
>  QUEUE_RW_ENTRY(queue_poll, "io_poll");
> @@ -642,6 +773,13 @@ static struct attribute *queue_attrs[] = {
>  	&queue_discard_max_entry.attr,
>  	&queue_discard_max_hw_entry.attr,
>  	&queue_discard_zeroes_data_entry.attr,
> +	&queue_copy_offload_entry.attr,
> +	&queue_copy_max_hw_entry.attr,
> +	&queue_copy_max_entry.attr,
> +	&queue_copy_range_max_hw_entry.attr,
> +	&queue_copy_range_max_entry.attr,
> +	&queue_copy_nr_ranges_max_hw_entry.attr,
> +	&queue_copy_nr_ranges_max_entry.attr,
>  	&queue_write_same_max_entry.attr,
>  	&queue_write_zeroes_max_entry.attr,
>  	&queue_zone_append_max_entry.attr,
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 1b24c1fb3bb1..3596fd37fae7 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -270,6 +270,13 @@ struct queue_limits {
>  	unsigned int		discard_alignment;
>  	unsigned int		zone_write_granularity;
>  
> +	unsigned long		max_hw_copy_sectors;
> +	unsigned long		max_copy_sectors;
> +	unsigned int		max_hw_copy_range_sectors;
> +	unsigned int		max_copy_range_sectors;
> +	unsigned short		max_hw_copy_nr_ranges;
> +	unsigned short		max_copy_nr_ranges;
> +
>  	unsigned short		max_segments;
>  	unsigned short		max_integrity_segments;
>  	unsigned short		max_discard_segments;
> @@ -574,6 +581,7 @@ struct request_queue {
>  #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
>  #define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
>  #define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
> +#define QUEUE_FLAG_COPY		30	/* supports copy offload */
>  
>  #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_SAME_COMP) |		\
> @@ -596,6 +604,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
>  	test_bit(QUEUE_FLAG_STABLE_WRITES, &(q)->queue_flags)
>  #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
>  #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
> +#define blk_queue_copy(q)	test_bit(QUEUE_FLAG_COPY, &(q)->queue_flags)
>  #define blk_queue_zone_resetall(q)	\
>  	test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
>  #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
> @@ -960,6 +969,10 @@ extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
>  extern void blk_queue_max_segments(struct request_queue *, unsigned short);
>  extern void blk_queue_max_discard_segments(struct request_queue *,
>  		unsigned short);
> +extern void blk_queue_max_copy_sectors(struct request_queue *q, unsigned int max_copy_sectors);
> +extern void blk_queue_max_copy_range_sectors(struct request_queue *q,
> +		unsigned int max_copy_range_sectors);
> +extern void blk_queue_max_copy_nr_ranges(struct request_queue *q, unsigned int max_copy_nr_ranges);
>  void blk_queue_max_secure_erase_sectors(struct request_queue *q,
>  		unsigned int max_sectors);
>  extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

