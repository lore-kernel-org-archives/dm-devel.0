Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B27C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 01:23:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DA59764DFB
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 01:23:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA59764DFB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-aLtvQJixMbaSqwuQg-mUGg-1; Thu, 28 Jan 2021 20:23:01 -0500
X-MC-Unique: aLtvQJixMbaSqwuQg-mUGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4536A803F42;
	Fri, 29 Jan 2021 01:22:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 85F075C6AB;
	Fri, 29 Jan 2021 01:22:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A65D84BB7B;
	Fri, 29 Jan 2021 01:22:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10T1LH8K011883 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 20:21:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2C48210D16B1; Fri, 29 Jan 2021 01:21:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2658C10D16B4
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 01:21:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0FB51875040
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 01:21:14 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-231-T0TNn9QKPt-2DG5ahJRVug-1; Thu, 28 Jan 2021 20:21:12 -0500
X-MC-Unique: T0TNn9QKPt-2DG5ahJRVug-1
IronPort-SDR: 88pnH7Ec60/SslnnLGJo0FhRrzQSc2tyE0fc0OCmLB2jqx8Ub9dQxHyVVYEJ3ToXdG4vFOBE/m
	XW0sqtlA3EeJ9JyI20yV1IG2xBaz6lR3er32ENgBZYlaHi7ZvNAAvSX5fVHq9o2OkzLvdRNBiD
	s7zlziVqSMgNf0pmABEefrFRiyzyECLRs6seQ3VrS2rQSFkrZ5+Cx/fayhHkS7m/fLafOb8lOI
	sPRkKjg40ogInQg5c1MJ/I4MHEa/hIsBQ7Td3ygdHXlyT1jMUN1iarvuKlCeOBVumfLU85pxst
	zRA=
X-IronPort-AV: E=Sophos;i="5.79,384,1602518400"; d="scan'208";a="159771331"
Received: from mail-sn1nam02lp2056.outbound.protection.outlook.com (HELO
	NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.56])
	by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2021 09:21:09 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6733.namprd04.prod.outlook.com (2603:10b6:208:1e0::9)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17;
	Fri, 29 Jan 2021 01:21:07 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Fri, 29 Jan 2021 01:21:07 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Sergei Shtepa <sergei.shtepa@veeam.com>, "hare@suse.de" <hare@suse.de>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>, "agk@redhat.com"
	<agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Thread-Topic: [dm-devel] [PATCH 1/2] block: blk_interposer
Thread-Index: AQHW9ZpcJE05P/jO2k2LywRNymQ1Yw==
Date: Fri, 29 Jan 2021 01:21:07 +0000
Message-ID: <BL0PR04MB6514943D2E257F88778C389CE7B99@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <1611853955-32167-1-git-send-email-sergei.shtepa@veeam.com>
	<1611853955-32167-2-git-send-email-sergei.shtepa@veeam.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e0dcf58d-daf5-4a2e-0cbf-08d8c3f42745
x-ms-traffictypediagnostic: MN2PR04MB6733:
x-microsoft-antispam-prvs: <MN2PR04MB6733E95CF4F44CED2B64875DE7B99@MN2PR04MB6733.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 9OAXTCxIJ+RGMnJJvg3S7GtAhXq4weLfoqDMg+kWaA4Dr/P2WjUGexIDmvSc5Pcwlsekf161Cq0pOzR7nKjyMBm+qtgxmLUs2j1/UJ2QkuEsTZECdUHQcanaE0jXrDD4jBM642VjcljEwPcW76i3NVC6YyhX3VgEYkjq+eZPmTJj2RS+l/0RZEhRNPYP2yGSamiQCpBXOL46ngaS+BJweQMDA3hzctEEfsW0V2hXYXvogCPd/hE3yucf+ltaU5z9dtp/Qo5F9R6lXuHxevCKeEUdncPJBRsodmjYP912FgJZdt3gZ6FCx7wOT4gd26pb+f7AlAoS3W1IJcmSwCW2s26lyVdVF0SY2tytAthv9ARxJTEieCB57dIwTny1BK420jPFvSEHlPjWoFQ6cz84bOy1n+dBPrEdy82j9CoaM2C5lAtLIwwOxDxAUOG24nH4UWNubU9s8xaLyV6KVBnqSQ0DXizjOtI+BVB5FHWZnuU3zRgXc2jkxOgdKsc73NiZuXYv83ult+BLQwElZCKI4w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(53546011)(6506007)(71200400001)(2906002)(86362001)(4326008)(83380400001)(9686003)(55016002)(8676002)(316002)(110136005)(7696005)(5660300002)(52536014)(91956017)(76116006)(66946007)(478600001)(66446008)(66476007)(66556008)(64756008)(33656002)(186003)(30864003)(8936002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Jno2RAw+BHJkwIncEIXHLZxFY1GbOeMFx3sYAfEhrwRAo8/Amf8jW3kqcXx8?=
	=?us-ascii?Q?eUen1WlUiwyULcPoI6bVqn8QSbMAGIMxhxvafqVSvQ+i/XKyGMz6wLQjWHBA?=
	=?us-ascii?Q?lZ5ryfLfEAnSCMW4zEEGdbGovAGWyjxVsTic62uEGoYwa4upDbDYVxUlzdsI?=
	=?us-ascii?Q?krWbnQs1iW42VVgNNtI7ZxcI84s3UQH+bz7aW2VvYIuyIE0uFKIFfNP/EhgL?=
	=?us-ascii?Q?YpGoBhLknXy16HK6JEnjBM67f+hIuTT8nlKyIqQBWBv31JiV9wD8TJmCipDg?=
	=?us-ascii?Q?lNoARSIhYd6WZ7Kf6hlZdgmzBlabtr63d3e0a/g5CwGknMo5UosdVRzPVRo9?=
	=?us-ascii?Q?nEAZQ3f0ModiS0F7hBNWAr+ePPOCHKgJCOIHDIZEiZIfhzMmw62htMXicgCQ?=
	=?us-ascii?Q?gpyTJdVIWuF+3fBBxsMlkqJR7/yT+Y7LiJQD0tTutCL62tD1/tvzUsF4Msfc?=
	=?us-ascii?Q?CFQ0g4eVRsl+m4Ok0IHO7K9sqAe5LjmNJj7GXNNltZbeq92lhskk5T+CNMUP?=
	=?us-ascii?Q?1bgHS2E/a/tCHclL8fS65bSqB/JCgcs6aLrsIm3jYh/q1HofIs9uhlnWXFOl?=
	=?us-ascii?Q?NrLUihNxSEh0ZdvUgSxk7hbKmtxtMBJeVDjFbARYoye1HRyaVNLOQygFc0Fa?=
	=?us-ascii?Q?hAr0Av6Kcyiof2qrmYmhcgjEV0O+Ja0oaXXWIk3SnbB/hJ5Z2bmRk4aA0Xa0?=
	=?us-ascii?Q?UCFZfqegM3T6novkfT8akd4AvCABazY+Go6x8xeOkNAeyJDQ9RdFFVMITCct?=
	=?us-ascii?Q?Pjng6oBXW50UHveYT6oN51sYpvLXoBKeySzrv3CaTYF3vgjJfPzMPeLEN5G+?=
	=?us-ascii?Q?P8OWxhDeWOPLMP7PzUfNMppYjQtwcWkhx1Kw2beeR7qIVTMnfyCkmlYy3dbL?=
	=?us-ascii?Q?bBRgFYG5YJvZ1DWCd91gp4x0lnRJondrMicOms3p4IQjX3qkpLcoB0c97enk?=
	=?us-ascii?Q?+vSkBPGzxqHnyFznWjLgysrV0OPMBsjS/B4EScFk9Zf21PgTPgmBaXm9+Pn4?=
	=?us-ascii?Q?2VmpghMT32V0O++j/94OIg+KRuuw8dyui/lVD7DOtm11kohHgwugNe5uYxk5?=
	=?us-ascii?Q?m1aabxmBG49PxZrRBVB3GGPW4uXYxz69ORON/9hskChn+GqhMnmZ1naHnjmv?=
	=?us-ascii?Q?owC+sCF/uyYO03MrRWd6uFTGhOqPBVb0Iw=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0dcf58d-daf5-4a2e-0cbf-08d8c3f42745
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 01:21:07.0601 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +WIrbQ2NFWJ34JVY448Pu2lo5FYMd6x/siGjlwid5FxIcTG+cfl4vfZF0E8LYeCXuJ7aNf95biT1GttUMCXkkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6733
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10T1LH8K011883
X-loop: dm-devel@redhat.com
Cc: "pavel.tide@veeam.com" <pavel.tide@veeam.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: blk_interposer
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/29 2:23, Sergei Shtepa wrote:
> The block layer interposer allows to intercept bio requests.
> This allows to connect device mapper and other kernel modules
> to the block device stack on the fly.
> 
> changes:
>   * new BIO_INTERPOSED bio flag.
>   * new function __submit_bio_interposed() implements the interposers
>     logic.
>   * new function blk_mq_is_queue_frozen() allow to assert that
>     the queue is frozen.
>   * functions blk_interposer_attach() and blk_interposer_detach()
>     allow to attach and detach interposers.

The changelog should not be part of the commit message. If you need a changelog
for a single patch, add it between the commit message end "---" and the patch
stats. git will ignore that part.

> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
> ---
>  block/bio.c               |  2 +
>  block/blk-core.c          | 29 ++++++++++++++
>  block/blk-mq.c            | 13 +++++++
>  block/genhd.c             | 82 +++++++++++++++++++++++++++++++++++++++
>  include/linux/blk-mq.h    |  1 +
>  include/linux/blk_types.h |  6 ++-
>  include/linux/genhd.h     | 19 +++++++++
>  7 files changed, 150 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 1f2cc1fbe283..f6f135eb84b5 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -684,6 +684,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>  	bio_set_flag(bio, BIO_CLONED);
>  	if (bio_flagged(bio_src, BIO_THROTTLED))
>  		bio_set_flag(bio, BIO_THROTTLED);
> +	if (bio_flagged(bio_src, BIO_INTERPOSED))
> +		bio_set_flag(bio, BIO_INTERPOSED);
>  	bio->bi_opf = bio_src->bi_opf;
>  	bio->bi_ioprio = bio_src->bi_ioprio;
>  	bio->bi_write_hint = bio_src->bi_write_hint;
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7663a9b94b80..07ec82d8fe57 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1032,6 +1032,32 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
>  	return ret;
>  }
>  
> +static blk_qc_t __submit_bio_interposed(struct bio *bio)
> +{
> +	struct bio_list bio_list[2] = { };
> +	blk_qc_t ret = BLK_QC_T_NONE;
> +
> +	current->bio_list = bio_list;
> +	if (likely(bio_queue_enter(bio) == 0)) {
> +		struct gendisk *disk = bio->bi_disk;
> +
> +		bio_set_flag(bio, BIO_INTERPOSED);
> +		if (likely(blk_has_interposer(disk)))
> +			disk->interposer->ip_submit_bio(bio);

Why do you check again blk_has_interposer() here ? That is checked already in
submit_bio_noacct() and the interposer attach/detach cannot run without the
queue frozen. So I do not think you need to check again. If you do, then you
definitely have a race condition here.

> +		else /* interposer was removed */
> +			bio_list_add(&current->bio_list[0], bio);
> +
> +		blk_queue_exit(disk->queue);
> +	}
> +	current->bio_list = NULL;
> +
> +	/* Resubmit remaining bios */
> +	while ((bio = bio_list_pop(&bio_list[0])))
> +		ret = submit_bio_noacct(bio);
> +
> +	return ret;
> +}
> +
>  /**
>   * submit_bio_noacct - re-submit a bio to the block device layer for I/O
>   * @bio:  The bio describing the location in memory and on the device.
> @@ -1057,6 +1083,9 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
>  		return BLK_QC_T_NONE;
>  	}
>  
> +	if (blk_has_interposer(bio->bi_disk) &&
> +	    !bio_flagged(bio, BIO_INTERPOSED))
> +		return __submit_bio_interposed(bio);

OK. I *think* that this is to handle stacked devices, right ? Otherwise, this
condition does not make much sense. Why not just:

	if (blk_has_interposer(bio->bi_disk))
		return __submit_bio_interposed(bio);

So at least adding some comments here may be good.

>  	if (!bio->bi_disk->fops->submit_bio)
>  		return __submit_bio_noacct_mq(bio);
>  	return __submit_bio_noacct(bio);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f285a9123a8b..924ec26fae5f 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -161,6 +161,19 @@ int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait_timeout);
>  
> +
> +bool blk_mq_is_queue_frozen(struct request_queue *q)
> +{
> +	bool ret;
> +
> +	mutex_lock(&q->mq_freeze_lock);
> +	ret = percpu_ref_is_dying(&q->q_usage_counter) && percpu_ref_is_zero(&q->q_usage_counter);
> +	mutex_unlock(&q->mq_freeze_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_is_queue_frozen);

Maybe move this change to its own patch preceding this one ?

> +
>  /*
>   * Guarantee no request is in use, so we can change any data structure of
>   * the queue afterward.
> diff --git a/block/genhd.c b/block/genhd.c
> index 419548e92d82..d3459582f56c 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -30,6 +30,7 @@
>  static struct kobject *block_depr;
>  
>  DECLARE_RWSEM(bdev_lookup_sem);
> +DEFINE_MUTEX(bdev_interposer_mutex);
>  
>  /* for extended dynamic devt allocation, currently only one major is used */
>  #define NR_EXT_DEVT		(1 << MINORBITS)
> @@ -2148,3 +2149,84 @@ static void disk_release_events(struct gendisk *disk)
>  	WARN_ON_ONCE(disk->ev && disk->ev->block != 1);
>  	kfree(disk->ev);
>  }
> +
> +/**
> + * blk_interposer_attach - Attach interposer to disk
> + * @disk: target disk
> + * @interposer: block device interposer
> + * @ip_submit_bio: hook for submit_bio()
> + *
> + * Returns:
> + *     -EINVAL if @interposer is NULL.
> + *     -EPERM if queue is not frozen.
> + *     -EBUSY if the block device already has @interposer.
> + *     -EALREADY if the block device already has @interposer with same callback.
> + *
> + * Disk must be frozen by blk_mq_freeze_queue().
> + */
> +int blk_interposer_attach(struct gendisk *disk, struct blk_interposer *interposer,
> +			  const ip_submit_bio_t ip_submit_bio)
> +{
> +	int ret = 0;
> +
> +	if (!interposer)
> +		return -EINVAL;

Is this really necessary ? If some user of this function has interposer == NULL,
that caller needs debugging...

> +
> +	if (!blk_mq_is_queue_frozen(disk->queue))
> +		return -EPERM;

Why not do the queue freeze here ?

> +
> +	mutex_lock(&bdev_interposer_mutex);
> +	if (blk_has_interposer(disk)) {
> +		if (disk->interposer->ip_submit_bio == ip_submit_bio)
> +			ret = -EALREADY;
> +		else
> +			ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	interposer->ip_submit_bio = ip_submit_bio;
> +	interposer->disk = disk;
> +
> +	disk->interposer = interposer;
> +out:
> +	mutex_unlock(&bdev_interposer_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(blk_interposer_attach);
> +
> +/**
> + * blk_interposer_detach - Detach interposer from disk
> + * @interposer: block device interposer
> + * @ip_submit_bio: hook for submit_bio()
> + *
> + * Disk must be frozen by blk_mq_freeze_queue().
> + */
> +void blk_interposer_detach(struct blk_interposer *interposer,
> +			  const ip_submit_bio_t ip_submit_bio)
> +{

The interface is weird. Why not passing the gendisk ?

> +	struct gendisk *disk;
> +
> +	if (WARN_ON(!interposer))
> +		return;

Same comment as above. This should not be necessary.

> +
> +	mutex_lock(&bdev_interposer_mutex);
> +
> +	/* Check if the interposer is still active. */
> +	disk = interposer->disk;
> +	if (WARN_ON(!disk))
> +		goto out;
> +
> +	if (WARN_ON(!blk_mq_is_queue_frozen(disk->queue)))
> +		goto out;
> +
> +	/* Check if it is really our interposer. */
> +	if (WARN_ON(disk->interposer->ip_submit_bio != ip_submit_bio))
> +		goto out;
> +
> +	disk->interposer = NULL;
> +	interposer->disk = NULL;
> +out:
> +	mutex_unlock(&bdev_interposer_mutex);
> +}
> +EXPORT_SYMBOL_GPL(blk_interposer_detach);
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index d705b174d346..9d1e8c4e922e 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -525,6 +525,7 @@ void blk_freeze_queue_start(struct request_queue *q);
>  void blk_mq_freeze_queue_wait(struct request_queue *q);
>  int blk_mq_freeze_queue_wait_timeout(struct request_queue *q,
>  				     unsigned long timeout);
> +bool blk_mq_is_queue_frozen(struct request_queue *q);
>  
>  int blk_mq_map_queues(struct blk_mq_queue_map *qmap);
>  void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues);
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 866f74261b3b..6c1351d7b73f 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -227,7 +227,7 @@ struct bio {
>  						 * top bits REQ_OP. Use
>  						 * accessors.
>  						 */
> -	unsigned short		bi_flags;	/* status, etc and bvec pool number */
> +	unsigned int		bi_flags;	/* status, etc and bvec pool number */
>  	unsigned short		bi_ioprio;
>  	unsigned short		bi_write_hint;
>  	blk_status_t		bi_status;
> @@ -304,6 +304,8 @@ enum {
>  				 * of this bio. */
>  	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
>  	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
> +	BIO_INTERPOSED,		/* bio has been interposed and can be moved to
> +				 * a different disk */
>  	BIO_FLAG_LAST
>  };
>  
> @@ -322,7 +324,7 @@ enum {
>   * freed.
>   */
>  #define BVEC_POOL_BITS		(3)
> -#define BVEC_POOL_OFFSET	(16 - BVEC_POOL_BITS)
> +#define BVEC_POOL_OFFSET	(32 - BVEC_POOL_BITS)
>  #define BVEC_POOL_IDX(bio)	((bio)->bi_flags >> BVEC_POOL_OFFSET)
>  #if (1<< BVEC_POOL_BITS) < (BVEC_POOL_NR+1)
>  # error "BVEC_POOL_BITS is too small"
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 809aaa32d53c..8094af3a3db9 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -134,6 +134,14 @@ struct blk_integrity {
>  	unsigned char				tag_size;
>  };
>  
> +struct blk_interposer;

This is not needed.

> +typedef void (*ip_submit_bio_t) (struct bio *bio);

This hides the definition of the submit callback for no good reasons that I can
see. Since the callback has a simple interface, I would prefer this to be dropped.

> +
> +struct blk_interposer {
> +	ip_submit_bio_t ip_submit_bio;
> +	struct gendisk *disk;

If you fix the interface of the detach function, you should not need this field.

> +};
> +
>  struct gendisk {
>  	/* major, first_minor and minors are input parameters only,
>  	 * don't use directly.  Use disk_devt() and disk_max_parts().
> @@ -158,6 +166,7 @@ struct gendisk {
>  
>  	const struct block_device_operations *fops;
>  	struct request_queue *queue;
> +	struct blk_interposer *interposer;
>  	void *private_data;
>  
>  	int flags;
> @@ -346,4 +355,14 @@ static inline void printk_all_partitions(void)
>  }
>  #endif /* CONFIG_BLOCK */
>  
> +/*
> + * block layer interposer
> + */
> +#define blk_has_interposer(d) ((d)->interposer != NULL)

Please make this an inline function.

> +
> +int blk_interposer_attach(struct gendisk *disk, struct blk_interposer *interposer,
> +			  const ip_submit_bio_t ip_submit_bio);
> +void blk_interposer_detach(struct blk_interposer *interposer,
> +			   const ip_submit_bio_t ip_submit_bio);
> +
>  #endif /* _LINUX_GENHD_H */
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

