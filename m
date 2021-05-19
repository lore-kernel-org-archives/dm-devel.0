Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EA0C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 09:48:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 94D86611B0
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 09:48:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94D86611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-o18uIpjOPFaqOSl7b16oSg-1; Wed, 19 May 2021 05:48:37 -0400
X-MC-Unique: o18uIpjOPFaqOSl7b16oSg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E247D108C2AD;
	Wed, 19 May 2021 09:48:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAC5860C04;
	Wed, 19 May 2021 09:48:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2C440180B463;
	Wed, 19 May 2021 09:48:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J9mSam007158 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 05:48:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 455E121DE6E5; Wed, 19 May 2021 09:48:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4022C21DE6E4
	for <dm-devel@redhat.com>; Wed, 19 May 2021 09:48:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0F0085828E
	for <dm-devel@redhat.com>; Wed, 19 May 2021 09:48:24 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-601-B4flB4QvMuOD3bRXnwEZ_A-1; Wed, 19 May 2021 05:48:20 -0400
X-MC-Unique: B4flB4QvMuOD3bRXnwEZ_A-1
IronPort-SDR: /fy/oM7eHK0vkBHaT6Q/4T0KHOxgT/7JtDEebeutgcod+dScI9FXD2PMmPnSfRwAfEdqepLhIC
	5UuyNc/JNWZe4jzwHlBLdiKrWm3G/4PeUr3mDLfB6HiiNAE+mgp8Qra4BwPTpb0SVqRagpUQB8
	Bw7+SgEVDtPcPS/BPiblCe8piH41YtwR77konSu/PB32jO//tbHgQITxfWl632roiq6X0X65xW
	4slMuRbpQHbtISPTR1CADl5fxZMAG5xyawxJ35TPXkGlv8MvBQ8vBNYCpKwRdWnfCvs72RvYzs
	jVI=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="272628955"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 17:48:25 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB3884.namprd04.prod.outlook.com (2603:10b6:5:b7::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 19 May 2021 09:48:16 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 09:48:15 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
Thread-Topic: [PATCH 01/11] block: improve handling of all zones reset
	operation
Thread-Index: AQHXTFpwS0LsVhLQQ0izn4qPVyCy/w==
Date: Wed, 19 May 2021 09:48:15 +0000
Message-ID: <DM6PR04MB7081B7C64FA38C3DEC0C7D89E72B9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-2-damien.lemoal@wdc.com>
	<YKTb472jEYoMoQHQ@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:688d:8185:801b:83a0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 368fcfba-5a59-467c-6e48-08d91aab39b6
x-ms-traffictypediagnostic: DM6PR04MB3884:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB388438AE6A4E1589050923CCE72B9@DM6PR04MB3884.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hwkSoilDCS2fP8M2LCot7JarlTV3SfmUXFHroeHVn7px6jysSH5ldXYBQ4cI789AETGGrCStlsjLO5AciMsgDDnlvbluFONAz+IMgAs30kBFWRrInxB66aaiY/26WB0ZXroaUcuFK2xjrAI3OtTKV9jbCst+pf/UYkBN27qVxrZcbWHCTAEInvsgb1puJn1RNx+fJ+VPaSu0hze3GQj4fAxRIDRdbgvPIGVUxyDptmaUG7OT6vxdPQ2IrGeZsD1PX1yZLzcPXfjmLmmOxnyX0RLut4SkcI0kZzaqEoPiwquj6flUDvG7BKdCthTEIShjuP/AkI+TYB30T+gtDj79fRZtMW/ElG3YZ0tNafaHQP5ihYqB4TtDARg6zM1KcCEsy4GwwdkUW0/6t9SagWG6Chd/1odsMv62lseEuU6nyH6Z1grnwRUaISHxUqpHp+c1gBAsyxtVA10rFO4s6LfuFJwuxTB2dH85d35tbl36JEcvA9x+WbPv2sVAqhE1wU2Va2HFD31XJCH0qR8Z4+Egxo9Aa4sRHsNdnAZJyBb1ZMssMOwhWtwWh3n0yPqNKUWRHe3odZbZS/DQtYOw+Ag/yoxEhk1N65rsYIWgLc/iRWI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(5660300002)(54906003)(33656002)(186003)(8936002)(52536014)(8676002)(122000001)(83380400001)(38100700002)(71200400001)(316002)(66556008)(4326008)(2906002)(6916009)(86362001)(53546011)(6506007)(478600001)(91956017)(76116006)(55016002)(9686003)(66946007)(7696005)(66446008)(66476007)(64756008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pSp8NM1VDdxy5/vLgyOjvWzKDpvc3Zuf3rxcI050M7J8fvtrDb38nsStaQ5z?=
	=?us-ascii?Q?rCXWwVgllcULkR/WwpoI60Z5vXHavZk5bp6Ex47lVc6PKqb+UalJtNh6Qr6S?=
	=?us-ascii?Q?toHDI2Unf3NGyK9z6BrMrxN7poRg4oe6cNaNA6p4hafTISleh7Lks6AFnRaT?=
	=?us-ascii?Q?X4jj/o5aI/lxTP8GAe+1nrCaXNJ4rAqyAKwhlI4vAzBe4E36oQyYcvq+EmeP?=
	=?us-ascii?Q?OBQb/zkIGGHz/i5+C6luC5DVVk8QVMMBPxGYs8YwBh+TJXEITqmSETnJvnSh?=
	=?us-ascii?Q?B50I5Q4NdQnEVCgRUt29HbfbLxPfIBsE246ztgJzENClps2vGvJwDnbiUNsq?=
	=?us-ascii?Q?YHIYnaQAZ2C1uFVDK7fy2fYEFjfrBWL+soBir3BXGx8z8i+cuvbKRwgN5YZc?=
	=?us-ascii?Q?bdv6QVnekM7vSxxxbZbD1mPV7TVxgJrrs9Ogp0Huk9tU4UdC2WHZThz+0ESq?=
	=?us-ascii?Q?UJIV/y4MTgJO+zvEYY1mVUUxuZ4We4gy7BURyeTd5PKvpsX4NIDb3qQx3gvh?=
	=?us-ascii?Q?IrjR4fpGWrA7hdzQNH9liSHhc0m1qoiDLIYuG08OQ4k+sYJGJN2QNg4NnUwk?=
	=?us-ascii?Q?v+HEXxxRML4kzHS8TJTPRfUMTkflEd+RFx1dTzH2MOqC8OvXuZawvom4/wpK?=
	=?us-ascii?Q?gm7XKKAHxbStpLxspWrVVq6SNiCYMMI6GqcL6rN4Mo25FShsOl8JveXij67R?=
	=?us-ascii?Q?kWZCdqoWx0Zbyr3yv7AedW96DrAXJmtEpMLMk/gXWMQhPTuioTMnagL47PG4?=
	=?us-ascii?Q?UB0zpMbLF5t+2XgHfJL8o0X/YM0I2ZV8duP8QoylMtHKORsXGvJfb/vaNa5o?=
	=?us-ascii?Q?eQ1BqCn8EabD6yGgaJ3Cu1Ri41Pz51bD2zIcp1a9MZX/QS7qCwWN6L29mmUt?=
	=?us-ascii?Q?FUKXzn2ixnIqunZpFC2uAYspDrr76qQv880/DJQa/K0dBBkDDrexDQ/eyWQF?=
	=?us-ascii?Q?YO0C9BWg9J2TJUYqT7yQSmmLH/16/fjmB6mupMYrFnMYNjBfFFXWCcOd2nQO?=
	=?us-ascii?Q?FmTXIpJuwca1MeS5p7aJt87X37izWL00XSUp7THbZJ83IISqaIqanOZ6QWrx?=
	=?us-ascii?Q?v+1mognNPPm1Dmfrx+SB6xBVVGKUGZWPgTLuqYtRWRg7SZ3zWzDE70E1Ri+S?=
	=?us-ascii?Q?GxOXf29eo5fSlqFkbHpvVpbyXGtXWccPqGalZDZxx9MjBk+E9aJ1wFesAow/?=
	=?us-ascii?Q?YiAAIKpUBr30U5dU0aAhMeTkw0mpqtX9zMRn8ALP8ROpHhMKDRdr2LsGCm8E?=
	=?us-ascii?Q?AJDEBZ/RpNVn9JFodRAxoasjqM0V5tAgHsN96OSyHJAr02cMm8Xbw1bFsatF?=
	=?us-ascii?Q?LQPoG7+olbeaAfHaGXBn8PGl+HLpZUsE2kZlmuvu7KwXyDSDFiLWMMCtVHCp?=
	=?us-ascii?Q?tMWqOv2oWoXXYmSf8zIG5VPpX938lmTm/jMeVUxloAhmNz7Mvg=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368fcfba-5a59-467c-6e48-08d91aab39b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 09:48:15.8149 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1UkWRySMxO9BO5bT/OHUeE1tnKC1t6dp2lP7GsbeC925yihK2iVHBhmA2A2r+5oBzij25MJlUaZB2XxYsbsS3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3884
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J9mSam007158
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 01/11] block: improve handling of all zones
 reset operation
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/19 18:36, Christoph Hellwig wrote:
> The logic looks fine to me, but this makes blkdev_zone_mgmt extremely
> convoluted.  What do you think of the version below that splits out
> two self contained helpers instead?

Yep, that works for me. Will use this in v2.

> 
> ---
> From 3ff31f2502cf032ac1331122c9f1a018b769b577 Mon Sep 17 00:00:00 2001
> From: Damien Le Moal <damien.lemoal@wdc.com>
> Date: Wed, 19 May 2021 11:55:19 +0900
> Subject: block: improve handling of all zones reset operation
> 
> SCSI, ZNS and null_blk zoned devices support resetting all zones using
> a single command (REQ_OP_ZONE_RESET_ALL), as indicated using the device
> request queue flag QUEUE_FLAG_ZONE_RESETALL. This flag is not set for
> device mapper targets creating zoned devices. In this case, a user
> request for resetting all zones of a device is processed in
> blkdev_zone_mgmt() by issuing a REQ_OP_ZONE_RESET operation for each
> zone of the device. This leads to different behaviors of the
> BLKRESETZONE ioctl() depending on the target device support for the
> reset all operation. E.g.
> 
> blkzone reset /dev/sdX
> 
> will reset all zones of a SCSI device using a single command that will
> ignore conventional, read-only or offline zones.
> 
> But a dm-linear device including conventional, read-only or offline
> zones cannot be reset in the same manner as some of the single zone
> reset operations issued by blkdev_zone_mgmt() will fail. E.g.:
> 
> blkzone reset /dev/dm-Y
> blkzone: /dev/dm-0: BLKRESETZONE ioctl failed: Remote I/O error
> 
> To simplify applications and tools development, unify the behavior of
> an all-zone reset operation by modifying blkdev_zone_mgmt() to not
> issue a zone reset operation for conventional, read-only and offline
> zones, thus mimicking what an actual reset-all device command does on a
> device supporting REQ_OP_ZONE_RESET_ALL. The zones needing a reset are
> identified using a bitmap that is initialized using a zone report.
> Since empty zones do not need a reset, also ignore these zones.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> [hch: split into multiple functions]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-zoned.c | 115 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 88 insertions(+), 27 deletions(-)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 250cb76ee615..48e8376c1db8 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -161,18 +161,85 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>  }
>  EXPORT_SYMBOL_GPL(blkdev_report_zones);
>  
> -static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
> -						sector_t sector,
> -						sector_t nr_sectors)
> +static inline unsigned long *blk_alloc_zone_bitmap(int node,
> +						   unsigned int nr_zones)
>  {
> -	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
> -		return false;
> +	return kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(unsigned long),
> +			    GFP_NOIO, node);
> +}
>  
> +static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
> +				  void *data)
> +{
>  	/*
> -	 * REQ_OP_ZONE_RESET_ALL can be executed only if the number of sectors
> -	 * of the applicable zone range is the entire disk.
> +	 * For an all-zones reset, ignore conventional, empty, read-only
> +	 * and offline zones.
>  	 */
> -	return !sector && nr_sectors == get_capacity(bdev->bd_disk);
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_NOT_WP:
> +	case BLK_ZONE_COND_EMPTY:
> +	case BLK_ZONE_COND_READONLY:
> +	case BLK_ZONE_COND_OFFLINE:
> +		return 0;
> +	default:
> +		set_bit(idx, (unsigned long *)data);
> +		return 0;
> +	}
> +}
> +
> +static int blkdev_zone_reset_all_emulated(struct block_device *bdev,
> +		     gfp_t gfp_mask)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +	sector_t capacity = get_capacity(bdev->bd_disk);
> +	sector_t zone_sectors = blk_queue_zone_sectors(q);
> +	unsigned long *need_reset;
> +	sector_t sector;
> +	struct bio *bio = NULL;
> +	int ret;
> +
> +	need_reset = blk_alloc_zone_bitmap(q->node, q->nr_zones);
> +	if (!need_reset)
> +		return -ENOMEM;
> +	ret = bdev->bd_disk->fops->report_zones(bdev->bd_disk, 0,
> +				q->nr_zones, blk_zone_need_reset_cb,
> +				need_reset);
> +	if (ret < 0)
> +		goto out_free_need_reset;
> +
> +	ret = 0;
> +	while (sector < capacity) {
> +		if (!test_bit(blk_queue_zone_no(q, sector), need_reset)) {
> +			sector += zone_sectors;
> +			continue;
> +		}
> +		bio = blk_next_bio(bio, 0, gfp_mask);
> +		bio_set_dev(bio, bdev);
> +		bio->bi_opf = REQ_OP_ZONE_RESET | REQ_SYNC;
> +		bio->bi_iter.bi_sector = sector;
> +		sector += zone_sectors;
> +
> +		/* This may take a while, so be nice to others */
> +		cond_resched();
> +	}
> +
> +	if (bio) {
> +		ret = submit_bio_wait(bio);
> +		bio_put(bio);
> +	}
> +out_free_need_reset:
> +	kfree(need_reset);
> +	return ret;
> +}
> +
> +static int blkdev_zone_reset_all(struct block_device *bdev, gfp_t gfp_mask)
> +{
> +	struct bio bio;
> +
> +	bio_init(&bio, NULL, 0);
> +	bio_set_dev(&bio, bdev);
> +	bio.bi_opf = REQ_OP_ZONE_RESET_ALL | REQ_SYNC;
> +	return submit_bio_wait(&bio);
>  }
>  
>  /**
> @@ -200,7 +267,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  	sector_t capacity = get_capacity(bdev->bd_disk);
>  	sector_t end_sector = sector + nr_sectors;
>  	struct bio *bio = NULL;
> -	int ret;
> +	int ret = 0;
>  
>  	if (!blk_queue_is_zoned(q))
>  		return -EOPNOTSUPP;
> @@ -222,20 +289,21 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>  	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
>  		return -EINVAL;
>  
> +	/*
> +	 * In the case of a zone reset operation over all zones,
> +	 * REQ_OP_ZONE_RESET_ALL can be used with devices supporting this
> +	 * command. For other devices, we emulate this command behavior by
> +	 * identifying the zones needing a reset.
> +	 */
> +	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
> +		if (!blk_queue_zone_resetall(q))
> +			return blkdev_zone_reset_all_emulated(bdev, gfp_mask);
> +		return blkdev_zone_reset_all(bdev, gfp_mask);
> +	}
> +
>  	while (sector < end_sector) {
>  		bio = blk_next_bio(bio, 0, gfp_mask);
>  		bio_set_dev(bio, bdev);
> -
> -		/*
> -		 * Special case for the zone reset operation that reset all
> -		 * zones, this is useful for applications like mkfs.
> -		 */
> -		if (op == REQ_OP_ZONE_RESET &&
> -		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
> -			bio->bi_opf = REQ_OP_ZONE_RESET_ALL | REQ_SYNC;
> -			break;
> -		}
> -
>  		bio->bi_opf = op | REQ_SYNC;
>  		bio->bi_iter.bi_sector = sector;
>  		sector += zone_sectors;
> @@ -396,13 +464,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
>  	return ret;
>  }
>  
> -static inline unsigned long *blk_alloc_zone_bitmap(int node,
> -						   unsigned int nr_zones)
> -{
> -	return kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(unsigned long),
> -			    GFP_NOIO, node);
> -}
> -
>  void blk_queue_free_zone_bitmaps(struct request_queue *q)
>  {
>  	kfree(q->conv_zones_bitmap);
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

