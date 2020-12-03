Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B426C71156
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 09:05:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 471D1206E3
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 09:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 471D1206E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-g5kXD4j2MwCXimI_X8pZsA-1; Thu, 03 Dec 2020 04:05:19 -0500
X-MC-Unique: g5kXD4j2MwCXimI_X8pZsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 388039A22E;
	Thu,  3 Dec 2020 09:05:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1347318A2F;
	Thu,  3 Dec 2020 09:05:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A91C6180954D;
	Thu,  3 Dec 2020 09:05:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B395CXt012185 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 04:05:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC9E2D7DFE; Thu,  3 Dec 2020 09:05:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E5824D7DF6
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 09:05:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB97811E84
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 09:05:09 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-27-Xxt-LQ1vNg2zolA-8vFfhQ-1; Thu, 03 Dec 2020 04:05:06 -0500
X-MC-Unique: Xxt-LQ1vNg2zolA-8vFfhQ-1
IronPort-SDR: /xaIun1MX7pwirgd2wVgHeTRt9jpQQUvg0rFDJ/7UDHUE4Uf/LKyaWXJn3VeRt0QmigvBovPDi
	ofCHHzfoCdyDOJF5X94HSVOuYx8vDc8liHGeeUOfQ/oH1ockR3jxMLYvSJObu5L1VjHZ8dii2F
	0JG8tTlUPowRC9ra/21qN/7HhFEaqSrYUE+JCNICMY3SIWi81ASOqylz6v8ckMEyMp7HLpqWlC
	+tsP1BU86TGQdw7JUiPrcE4O5deKQuVxljk4nml8aT3LDKuItoFbIQCtXyWw16tEpuHiKnFL4j
	PYg=
X-IronPort-AV: E=Sophos;i="5.78,389,1599494400"; d="scan'208";a="257939590"
Received: from mail-bn8nam08lp2045.outbound.protection.outlook.com (HELO
	NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.45])
	by ob1.hgst.iphmx.com with ESMTP; 03 Dec 2020 17:19:10 +0800
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
	by CH2PR04MB6854.namprd04.prod.outlook.com (2603:10b6:610:99::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23;
	Thu, 3 Dec 2020 09:02:58 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a]) by
	CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3589.022;
	Thu, 3 Dec 2020 09:02:58 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [dm-devel] [PATCH 4/5] block: remove the request_queue argument
	to the block_bio_remap tracepoint
Thread-Index: AQHWyVMYnJFmCt1NHkWKCNqf/y7nEA==
Date: Thu, 3 Dec 2020 09:02:58 +0000
Message-ID: <CH2PR04MB65229B3EE2DBB2BDD215EEA9E7F20@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201130175854.982460-1-hch@lst.de>
	<20201130175854.982460-5-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.182.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9249a803-9606-4da3-2824-08d8976a3b30
x-ms-traffictypediagnostic: CH2PR04MB6854:
x-microsoft-antispam-prvs: <CH2PR04MB68540A0E133BD2A6FA23C9A7E7F20@CH2PR04MB6854.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:61
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ISM7PcOGfuj5JDvIahkwEnO3OJ3UWojj8drM933QjYfCm+HR0vBCXk1fFpj2WDaEX/ZCubNNu5D1queJ2pAxOGz9nVF4XADpbSXjq57d95iHskEvj8nL2jjTG3SGuR1LDFzXS0u04wyA5TusfW5MurAZ6pvvyqrKo7OIPztP0sjCYIpwtj+R8MaQxGliRdozNytPkUfiCpCAF3EOf3avDmOb5gDBIkaxV1Kg0Byo39dynV8Zah5ckkfa1zl4Oeqx3GdGylDgzRL1Abf5zKiNKnR16OWHBSEALHFJadTY/sqZ2PQsFatyrxrFmkhkWhyH
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB6522.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(66946007)(8676002)(316002)(2906002)(66556008)(64756008)(76116006)(55016002)(66476007)(186003)(66446008)(478600001)(26005)(91956017)(54906003)(110136005)(33656002)(83380400001)(6506007)(4326008)(71200400001)(86362001)(7696005)(5660300002)(9686003)(8936002)(53546011)(52536014);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?O5fkxDnMJ17LwcWVVrsMdDsCOA7m1Y1DWCHiJC5tuNEfOo1tt4mzhjldaVAv?=
	=?us-ascii?Q?UbhLyAp4AjBk2JWEkLCO7mt7Hc6qEqSKs979T9HlhDcsC+bQ0ASYNQGHNR7f?=
	=?us-ascii?Q?Xgl9+5T0jkhjujj7jIjtyrYLAvN0GxGQVvVY+8v4XYdUNwQdhKUYyN82rcxF?=
	=?us-ascii?Q?lWQLJLFWm4H+o5zafXZ/KFikYFN5gv2hKNdEvX4q72eZDNl448C5ohVQxmRx?=
	=?us-ascii?Q?bQGXlkYlIYGdm0HxTH09Wjf84HhwAa7kpe0jXsqvZIRN/W0b1ysuGQQ2FuO7?=
	=?us-ascii?Q?zUThSvptJimepGwLSaXzX3bCyWl6+Tgih6lkPaZPpMWiuwcQRYvGAPZl5Eyc?=
	=?us-ascii?Q?I2iyu903PvAZYdKM+mTtsGTSpi1OmNzbS7nN8wfy1dCiaGCCa94P1KgZ2sM7?=
	=?us-ascii?Q?V7H/cqTeLZwT43gsCjT2abGSbXwSZLuOn8pwa3iuTWjrw5mgyxaHaO2JWU/1?=
	=?us-ascii?Q?z2oJPhL0uxnHJgQRuBfXJfj5lLdVJtdNNRke4FfmQsgMYOnhWOuA1e7tT3mu?=
	=?us-ascii?Q?4akmkOJL96ro5MSsiNQTSrUS8EGMzFTWVEM8Jw+QHWhdZxcwLKyClukbJEa2?=
	=?us-ascii?Q?Cl4ZIc6MCyoBXS9I7J3zzUHnp3P9R5cNkcZNcA0XfgqjZfABQ7hGMuoZs0rS?=
	=?us-ascii?Q?LDX4wTkFI9Hgp8WN5dl6aaalbL6Sk7Wpw70hqROpEnNpY6uvBjPiKSPjuwzV?=
	=?us-ascii?Q?w2gZGMLlz4yEgkZorw8gS8TuNkL2cmDKucfJ91Sram5T7/PhaJcFYCxBNGGp?=
	=?us-ascii?Q?dVsbivjPIva16tDnRr/0Mw0NeuitS2ghkEV4qQDiuZiwmOBP1gcnEFnVpz/F?=
	=?us-ascii?Q?0ALWKqnzK7VCnGkdKW0+fIm8WNG64CqSM7QEJbLnWlFTK38mvqKeCqMn00Vy?=
	=?us-ascii?Q?EFLIM+FApmzhMIM1aEoarhy4gPpJQnGr5rtQLhS2x+w0Bb5dX15dw8ZrQF8z?=
	=?us-ascii?Q?hD2/8MoK6xYOA2w0WGAI/9oxaKNyKG3OJ8EJmECZveSwvCw5gLhyBf+8WK58?=
	=?us-ascii?Q?8s7s?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9249a803-9606-4da3-2824-08d8976a3b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2020 09:02:58.7338 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xo02l5EUbcA2GYEqD/yKWJimF5Vk+2t32idcr1aSMC+vYuBP3TR3lj8obQypFP07jQuMiBs8rvCXsj2aS/Bbfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6854
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B395CXt012185
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 4/5] block: remove the request_queue argument
 to the block_bio_remap tracepoint
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020/12/01 3:09, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c              |  2 +-
>  drivers/md/dm.c               |  3 +--
>  drivers/md/md-linear.c        |  3 +--
>  drivers/md/md.c               |  5 ++---
>  drivers/md/raid0.c            |  4 ++--
>  drivers/md/raid1.c            |  7 +++----
>  drivers/md/raid10.c           |  6 ++----
>  drivers/md/raid5.c            | 15 +++++++--------
>  drivers/nvme/host/multipath.c |  3 +--
>  include/trace/events/block.h  |  8 +++-----
>  kernel/trace/blktrace.c       | 14 +++++---------
>  11 files changed, 28 insertions(+), 42 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index cb24654983e1e4..96e5fcd7f071b6 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -758,7 +758,7 @@ static inline int blk_partition_remap(struct bio *bio)
>  		if (bio_check_eod(bio, bdev_nr_sectors(p)))
>  			goto out;
>  		bio->bi_iter.bi_sector += p->bd_start_sect;
> -		trace_block_bio_remap(bio->bi_disk->queue, bio, p->bd_dev,
> +		trace_block_bio_remap(bio, p->bd_dev,
>  				      bio->bi_iter.bi_sector -
>  				      p->bd_start_sect);
>  	}
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 9a5bd90779c7c4..5181907dc59537 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1276,8 +1276,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
>  		break;
>  	case DM_MAPIO_REMAPPED:
>  		/* the bio has been remapped so dispatch it */
> -		trace_block_bio_remap(clone->bi_disk->queue, clone,
> -				      bio_dev(io->orig_bio), sector);
> +		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
>  		ret = submit_bio_noacct(clone);
>  		break;
>  	case DM_MAPIO_KILL:
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 98f1b4b2bdcef8..68cac7d1927823 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -257,8 +257,7 @@ static bool linear_make_request(struct mddev *mddev, struct bio *bio)
>  		bio_endio(bio);
>  	} else {
>  		if (mddev->gendisk)
> -			trace_block_bio_remap(bio->bi_disk->queue,
> -					      bio, disk_devt(mddev->gendisk),
> +			trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
>  					      bio_sector);
>  		mddev_check_writesame(mddev, bio);
>  		mddev_check_write_zeroes(mddev, bio);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0065736f05b428..c555be0a8dce78 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8591,9 +8591,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>  	bio_chain(discard_bio, bio);
>  	bio_clone_blkg_association(discard_bio, bio);
>  	if (mddev->gendisk)
> -		trace_block_bio_remap(bdev_get_queue(rdev->bdev),
> -			discard_bio, disk_devt(mddev->gendisk),
> -			bio->bi_iter.bi_sector);
> +		trace_block_bio_remap(discard_bio, disk_devt(mddev->gendisk),
> +				      bio->bi_iter.bi_sector);
>  	submit_bio_noacct(discard_bio);
>  }
>  EXPORT_SYMBOL(md_submit_discard_bio);
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 6f44177593a552..e5d7411cba9b46 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -571,8 +571,8 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>  		tmp_dev->data_offset;
>  
>  	if (mddev->gendisk)
> -		trace_block_bio_remap(bio->bi_disk->queue, bio,
> -				disk_devt(mddev->gendisk), bio_sector);
> +		trace_block_bio_remap(bio, disk_devt(mddev->gendisk),
> +				      bio_sector);
>  	mddev_check_writesame(mddev, bio);
>  	mddev_check_write_zeroes(mddev, bio);
>  	submit_bio_noacct(bio);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 960d854c07f897..c0347997f6ff73 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1305,8 +1305,8 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
>  	read_bio->bi_private = r1_bio;
>  
>  	if (mddev->gendisk)
> -	        trace_block_bio_remap(read_bio->bi_disk->queue, read_bio,
> -				disk_devt(mddev->gendisk), r1_bio->sector);
> +	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
> +				      r1_bio->sector);
>  
>  	submit_bio_noacct(read_bio);
>  }
> @@ -1517,8 +1517,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>  		atomic_inc(&r1_bio->remaining);
>  
>  		if (mddev->gendisk)
> -			trace_block_bio_remap(mbio->bi_disk->queue,
> -					      mbio, disk_devt(mddev->gendisk),
> +			trace_block_bio_remap(mbio, disk_devt(mddev->gendisk),
>  					      r1_bio->sector);
>  		/* flush_pending_writes() needs access to the rdev so...*/
>  		mbio->bi_disk = (void *)conf->mirrors[i].rdev;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b7bca6703df814..a6f99fa0b32cfc 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1200,8 +1200,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
>  	read_bio->bi_private = r10_bio;
>  
>  	if (mddev->gendisk)
> -	        trace_block_bio_remap(read_bio->bi_disk->queue,
> -	                              read_bio, disk_devt(mddev->gendisk),
> +	        trace_block_bio_remap(read_bio, disk_devt(mddev->gendisk),
>  	                              r10_bio->sector);
>  	submit_bio_noacct(read_bio);
>  	return;
> @@ -1250,8 +1249,7 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
>  	mbio->bi_private = r10_bio;
>  
>  	if (conf->mddev->gendisk)
> -		trace_block_bio_remap(mbio->bi_disk->queue,
> -				      mbio, disk_devt(conf->mddev->gendisk),
> +		trace_block_bio_remap(mbio, disk_devt(conf->mddev->gendisk),
>  				      r10_bio->sector);
>  	/* flush_pending_writes() needs access to the rdev so...*/
>  	mbio->bi_disk = (void *)rdev;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 39343479ac2a94..3a90cc0e43ca8e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1222,9 +1222,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
>  
>  			if (conf->mddev->gendisk)
> -				trace_block_bio_remap(bi->bi_disk->queue,
> -						      bi, disk_devt(conf->mddev->gendisk),
> -						      sh->dev[i].sector);
> +				trace_block_bio_remap(bi,
> +						disk_devt(conf->mddev->gendisk),
> +						sh->dev[i].sector);
>  			if (should_defer && op_is_write(op))
>  				bio_list_add(&pending_bios, bi);
>  			else
> @@ -1272,9 +1272,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  			if (op == REQ_OP_DISCARD)
>  				rbi->bi_vcnt = 0;
>  			if (conf->mddev->gendisk)
> -				trace_block_bio_remap(rbi->bi_disk->queue,
> -						      rbi, disk_devt(conf->mddev->gendisk),
> -						      sh->dev[i].sector);
> +				trace_block_bio_remap(rbi,
> +						disk_devt(conf->mddev->gendisk),
> +						sh->dev[i].sector);
>  			if (should_defer && op_is_write(op))
>  				bio_list_add(&pending_bios, rbi);
>  			else
> @@ -5468,8 +5468,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
>  		spin_unlock_irq(&conf->device_lock);
>  
>  		if (mddev->gendisk)
> -			trace_block_bio_remap(align_bi->bi_disk->queue,
> -					      align_bi, disk_devt(mddev->gendisk),
> +			trace_block_bio_remap(align_bi, disk_devt(mddev->gendisk),
>  					      raid_bio->bi_iter.bi_sector);
>  		submit_bio_noacct(align_bi);
>  		return 1;
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 74896be40c1769..106cf5c44ee7ab 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -312,8 +312,7 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
>  	if (likely(ns)) {
>  		bio->bi_disk = ns->disk;
>  		bio->bi_opf |= REQ_NVME_MPATH;
> -		trace_block_bio_remap(bio->bi_disk->queue, bio,
> -				      disk_devt(ns->head->disk),
> +		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
>  				      bio->bi_iter.bi_sector);
>  		ret = submit_bio_noacct(bio);
>  	} else if (nvme_available_path(head)) {
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index b415e4cba84304..8fb89574d8677f 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -450,9 +450,8 @@ TRACE_EVENT(block_split,
>  
>  /**
>   * block_bio_remap - map request for a logical device to the raw device
> - * @q: queue holding the operation
>   * @bio: revised operation
> - * @dev: device for the operation
> + * @dev: original device for the operation
>   * @from: original sector for the operation
>   *
>   * An operation for a logical device has been mapped to the
> @@ -460,10 +459,9 @@ TRACE_EVENT(block_split,
>   */
>  TRACE_EVENT(block_bio_remap,
>  
> -	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
> -		 sector_t from),
> +	TP_PROTO(struct bio *bio, dev_t dev, sector_t from),
>  
> -	TP_ARGS(q, bio, dev, from),
> +	TP_ARGS(bio, dev, from),
>  
>  	TP_STRUCT__entry(
>  		__field( dev_t,		dev		)
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 3ca6d62114f461..405637144a0389 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -993,20 +993,16 @@ static void blk_add_trace_split(void *ignore, struct bio *bio, unsigned int pdu)
>  /**
>   * blk_add_trace_bio_remap - Add a trace for a bio-remap operation
>   * @ignore:	trace callback data parameter (not used)
> - * @q:		queue the io is for
>   * @bio:	the source bio
> - * @dev:	target device
> + * @dev:	source device
>   * @from:	source sector
>   *
> - * Description:
> - *     Device mapper or raid target sometimes need to split a bio because
> - *     it spans a stripe (or similar). Add a trace for that action.
> - *
> + * Called after a bio is remapped to a different device and/or sector.
>   **/
> -static void blk_add_trace_bio_remap(void *ignore,
> -				    struct request_queue *q, struct bio *bio,
> -				    dev_t dev, sector_t from)
> +static void blk_add_trace_bio_remap(void *ignore, struct bio *bio, dev_t dev,
> +				    sector_t from)
>  {
> +	struct request_queue *q = bio->bi_disk->queue;
>  	struct blk_trace *bt;
>  	struct blk_io_trace_remap r;
>  
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

