Return-Path: <SRS0=87bc=K7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79269C4743C
	for <dm-devel@archiver.kernel.org>; Sat,  5 Jun 2021 00:18:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0DD77613AD
	for <dm-devel@archiver.kernel.org>; Sat,  5 Jun 2021 00:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DD77613AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-5Kd7GzjfMgqMyQ10cjrv-Q-1; Fri, 04 Jun 2021 20:18:13 -0400
X-MC-Unique: 5Kd7GzjfMgqMyQ10cjrv-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93A33518C;
	Sat,  5 Jun 2021 00:18:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE2B85C234;
	Sat,  5 Jun 2021 00:18:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7CC724E9E2;
	Sat,  5 Jun 2021 00:18:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1550I2dC025876 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Jun 2021 20:18:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0B7C1163CF1; Sat,  5 Jun 2021 00:18:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05871163D10
	for <dm-devel@redhat.com>; Sat,  5 Jun 2021 00:17:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CD321857F29
	for <dm-devel@redhat.com>; Sat,  5 Jun 2021 00:17:59 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-181-e8QipVgDNpiz70w9jeRxhg-1; Fri, 04 Jun 2021 20:17:57 -0400
X-MC-Unique: e8QipVgDNpiz70w9jeRxhg-1
IronPort-SDR: K7PdezmPcw2YlMs35TF2R6oXNcxTvnXNwTzTD0mn4ItXb0nwbDffXhPeZkrlKNAHCiotzO4Pls
	YWhQ+18Xnn/3kK70dmjjusz2MXgNptqMRI93WPyg6mLdQOyrvH4jbtJUcNZL9mSN2omygcux/k
	/mvTuXc4Z7VTJz8d3f0isG3tU3CPv6BHY8d0Sqx+Rl2AWa88+ThYApctm97jJkNWpYh/R02bJ+
	uoYIxb3w347tYJw/2kxMkTIj1C+Dnfl+FmCmIJXcVwsVtDwGr35xa7s3o3jpshpUEJVw29iMGK
	en8=
X-IronPort-AV: E=Sophos;i="5.83,249,1616428800"; d="scan'208";a="282208558"
Received: from mail-dm6nam08lp2044.outbound.protection.outlook.com (HELO
	NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.44])
	by ob1.hgst.iphmx.com with ESMTP; 05 Jun 2021 08:17:54 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM5PR04MB1244.namprd04.prod.outlook.com (2603:10b6:4:3d::20) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20;
	Sat, 5 Jun 2021 00:17:52 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4195.024;
	Sat, 5 Jun 2021 00:17:52 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: [PATCH v5 08/11] dm: Forbid requeue of writes to zones
Thread-Index: AQHXUax2oCc1akPfNkKbpC9TBPj7Lw==
Date: Sat, 5 Jun 2021 00:17:52 +0000
Message-ID: <DM6PR04MB70813E6E894DE0D69816CDBDE73A9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
	<20210525212501.226888-9-damien.lemoal@wdc.com>
	<YLo/LO32+rdrfygC@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:61af:6851:54e6:364]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c19e0bf-5c60-4c14-e4cf-08d927b75c12
x-ms-traffictypediagnostic: DM5PR04MB1244:
x-microsoft-antispam-prvs: <DM5PR04MB1244D3B2E1927FFF61B9952EE73A9@DM5PR04MB1244.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: sRdpcwI/pcLx25n/SPUN/xJywg7YZTcGk6s2eDuLhcWXYOdeFT5g+CTV3xiXp4bjx6Xx1J4H93Qcbu0LIjTKllpD601vSmohvoi1mBaj8t+E6GGh5KaTZ5+CisXlHbqZyQ2ddprz/0Z73CLghG5oQPYA5IUHkSERCTnN50Ytsvjzm3MEkp7epmbrRG67IzIxqhR5X0Ii2loO4l7iUZ1yFCDcobhUBydVNLd8J5u6rpnmU+qAWIsoer1osTOvIiV6igMekp2BMFRlVgTqiL9h1FZZe4YMUjXCxwN5XXwGXOTXcHO7ZimeuaTRRn0fjbs57RUyztEKv/LqtBcimcGs0qrLDqx3+7i+/jVI4uk1RUN0m6Jmd4beElQ3+2NamK71j5wQ2f9kHQqyp9wGG0BFGzYYpc1eL/WrbKsst+vnWEyFJzIrYa4Tk2XXc82NGx6Q1iiV4m/L0TENXP+QEEeacr67ARJwPSB3vHuJWleciqjQBtbebmdcyB5V7GXmb+/7NkqgFFuxqqueiZB9lsoyj4KEEOrwLGZUP7FoBqOZpVYcYzNpWt5J9j+1Xaly5n9ORfRAd3xa0oXGTu21KBIYrGgd4i0PIyqoV6Fcg9eFI5oqNtlnQWI+RojRF9xm2njrWikqFHTvrqVi5LGj9ftvrC2BsCyQ80EixLQTTwE+hGQZKbO9ywJJ9gkRkCXHhLMgYvpuQslyMF9ZUtyaLRfCOg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(966005)(478600001)(5660300002)(8676002)(122000001)(8936002)(38100700002)(91956017)(55016002)(9686003)(66476007)(66556008)(64756008)(66446008)(66946007)(76116006)(83380400001)(2906002)(6916009)(7696005)(316002)(4326008)(186003)(52536014)(54906003)(71200400001)(6506007)(53546011)(33656002)(86362001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?OaEoswdG1eS8vA0xO3wdjTcWEXEoPznvdipQ90XfbBvRAKJHod38sVxtsYzv?=
	=?us-ascii?Q?LVnH468wY8OK7qmOuLwv/T1y6g7WshxnJXiKVKSUS8GEsoui4x4qErzG+jMg?=
	=?us-ascii?Q?Mb2u9D8KJbf8uOvo3awFmfPX35A+irX95TS8Lcomg/GPpuC1SZQkhHX/EU0J?=
	=?us-ascii?Q?8s9HYgXP8tLj7bM+ZE7JYsdRqgy3TmLU6zL+giGnMZiq7Me42KIUCgOIWJh6?=
	=?us-ascii?Q?CB42nl7RcWYE4wuPO2kP6MzoylzU7unrc80Jhidqujt41aL38Wd1JLhqdaQb?=
	=?us-ascii?Q?y38B13lVG9P8Vo5xFoFyWWoGjWHK+5InBfS6BnXMAo3YHSymF1BJNYNG7a7/?=
	=?us-ascii?Q?4+yCRHJj5E+cir4I90FqyWtwm4MyE6nL8B4zONMqx0D8Cku8GBNN2K7B9l+D?=
	=?us-ascii?Q?8LxypYCaPRUq2eJmEOMh53A0shOjeiE0Bwik4k9maOaf89SJAWUDWlXJaX9/?=
	=?us-ascii?Q?14zoZl1T5E6kepcrenWpP1gZ91UWMlX2Oynd8hisA03FT1HJzzqZiMYZpWmz?=
	=?us-ascii?Q?R6hts9fbhCKzIUObD/XoknppzpXrsjEh//KtEowhJs1vZkTUXsaqE02Tcm8y?=
	=?us-ascii?Q?X6yF4yy/rSjMgKjgRXzVc9waLmEFgPPXv2jVASYwR/wqUDEAsUz/yvQh1Lpn?=
	=?us-ascii?Q?zj94Tq1PqU3PEtOmziSPFLJKfsa4+FqFLB9/MsMgKB1NPIxJ8IcXx1qBq//4?=
	=?us-ascii?Q?Lzj8QblzS+yvZndkAca80JXnzlz6wIzkn27uytUI64SpwcPh/X66jdE3XRZA?=
	=?us-ascii?Q?hWkxGa33Kc85RNu553tFq52GWQFaruzLWME5HdS4SJLnfSvnpNqSwwtQuTw9?=
	=?us-ascii?Q?GN61uOTbU3ovPLugfFp1cQThgKJurzbG50rbf1wOvndd3C6cczJ/8zFPicg5?=
	=?us-ascii?Q?8/bdFORbAQ6WJ5ZTfWJp8kbDgA48CCxwsV8rjJO8r+qVl3Zgh9JnCfpMcTsM?=
	=?us-ascii?Q?n6gaZ/HkaIF7mw+DP0xmANwo5f+KrZ49BUzA72uOvcstrI3BVHnHjkLJTXio?=
	=?us-ascii?Q?uhmdRYY6rSCVZ9/rzmvuf9/jDB/WbirJhq0onUbdWEJnlhRm3FtpASP0A57r?=
	=?us-ascii?Q?geOnUrco1HD4LHDlhMOEiUhfKeFdE2ncSHoCd9H6rIOu469CLS8xdTI7XqPN?=
	=?us-ascii?Q?5uNad7M8ggUmaYNgblm8MuzzGXNU01Txwc3Qh6PeHZG/PtGPrAQGPsnuzYg0?=
	=?us-ascii?Q?DNiv+U0LSub65y+97ADg6tJIAS/0vKtiG3owzttxiaVlZ44caA5+w3+sn5wk?=
	=?us-ascii?Q?M9WIRzaGD0aDSiLGOASn8t7KidZ5COUhVQCQ21mh1YznzWszh/II0ybYf9Z4?=
	=?us-ascii?Q?5k5CAQv5rP4FP7NhUGNd9LsvnU5Ch8WG+LJZyDGVjYLQ1f7FSnuM2Y6RnKY6?=
	=?us-ascii?Q?oZnfIpvqtabfkDoklWJjGWx8EOQFYY/8yWqTE2CGAeZFFlh9CA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c19e0bf-5c60-4c14-e4cf-08d927b75c12
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2021 00:17:52.6328 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o0f6dfvgiFUXR6HzQNrJg0PZdDxlmSxuhlsCIVLZMBDGzx5uXS8i/mJwL6P1AZSJxt33Ld2GMaZXsivqUrT/8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1244
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1550I2dC025876
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 08/11] dm: Forbid requeue of writes to
	zones
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/06/04 23:56, Mike Snitzer wrote:
> On Tue, May 25 2021 at  5:24P -0400,
> Damien Le Moal <damien.lemoal@wdc.com> wrote:
> 
>> A target map method requesting the requeue of a bio with
>> DM_MAPIO_REQUEUE or completing it with DM_ENDIO_REQUEUE can cause
>> unaligned write errors if the bio is a write operation targeting a
>> sequential zone. If a zoned target request such a requeue, warn about
>> it and kill the IO.
>>
>> The function dm_is_zone_write() is introduced to detect write operations
>> to zoned targets.
>>
>> This change does not affect the target drivers supporting zoned devices
>> and exposing a zoned device, namely dm-crypt, dm-linear and dm-flakey as
>> none of these targets ever request a requeue.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
>> ---
>>  drivers/md/dm-zone.c | 17 +++++++++++++++++
>>  drivers/md/dm.c      | 18 +++++++++++++++---
>>  drivers/md/dm.h      |  5 +++++
>>  3 files changed, 37 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
>> index b42474043249..edc3bbb45637 100644
>> --- a/drivers/md/dm-zone.c
>> +++ b/drivers/md/dm-zone.c
>> @@ -104,6 +104,23 @@ int dm_report_zones(struct block_device *bdev, sector_t start, sector_t sector,
>>  }
>>  EXPORT_SYMBOL_GPL(dm_report_zones);
>>  
>> +bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
>> +{
>> +	struct request_queue *q = md->queue;
>> +
>> +	if (!blk_queue_is_zoned(q))
>> +		return false;
>> +
>> +	switch (bio_op(bio)) {
>> +	case REQ_OP_WRITE_ZEROES:
>> +	case REQ_OP_WRITE_SAME:
>> +	case REQ_OP_WRITE:
>> +		return !op_is_flush(bio->bi_opf) && bio_sectors(bio);
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>>  void dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q)
>>  {
>>  	if (!blk_queue_is_zoned(q))
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index c49976cc4e44..ed8c5a8df2e5 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -846,11 +846,15 @@ static void dec_pending(struct dm_io *io, blk_status_t error)
>>  			 * Target requested pushing back the I/O.
>>  			 */
>>  			spin_lock_irqsave(&md->deferred_lock, flags);
>> -			if (__noflush_suspending(md))
>> +			if (__noflush_suspending(md) &&
>> +			    !WARN_ON_ONCE(dm_is_zone_write(md, bio)))
>>  				/* NOTE early return due to BLK_STS_DM_REQUEUE below */
>>  				bio_list_add_head(&md->deferred, io->orig_bio);
>>  			else
>> -				/* noflush suspend was interrupted. */
>> +				/*
>> +				 * noflush suspend was interrupted or this is
>> +				 * a write to a zoned target.
>> +				 */
>>  				io->status = BLK_STS_IOERR;
>>  			spin_unlock_irqrestore(&md->deferred_lock, flags);
>>  		}
> 
> So I now see this incremental fix:
> https://patchwork.kernel.org/project/dm-devel/patch/20210604004703.408562-1-damien.lemoal@opensource.wdc.com/
> 
> And I've folded it in...

Thanks.

>> @@ -947,7 +951,15 @@ static void clone_endio(struct bio *bio)
>>  		int r = endio(tio->ti, bio, &error);
>>  		switch (r) {
>>  		case DM_ENDIO_REQUEUE:
>> -			error = BLK_STS_DM_REQUEUE;
>> +			/*
>> +			 * Requeuing writes to a sequential zone of a zoned
>> +			 * target will break the sequential write pattern:
>> +			 * fail such IO.
>> +			 */
>> +			if (WARN_ON_ONCE(dm_is_zone_write(md, bio)))
>> +				error = BLK_STS_IOERR;
>> +			else
>> +				error = BLK_STS_DM_REQUEUE;
>>  			fallthrough;
>>  		case DM_ENDIO_DONE:
>>  			break;
> 
> But I'm left wondering why dec_pending, now dm_io_dec_pending, needs
> to be modified to also check dm_is_zone_write() if clone_endio() is
> already dealing with it?

The way I understand the code is that if the target ->map_bio() method returns
DM_MAPIO_REQUEUE (in __map_bio()), then clone_endio() is not called since the
clone BIO is not submitted. But we still need to fail orig_bio, hence the check
in dm_io_dec_pending() to cover the submission path. Am I missing something ? Is
clone_endio() also called in that case ?

> Not that big a deal, just not loving how we're sprinkling special
> zoned code around...

I do not like it either. It makes maintenance harder. But as explained above, I
did not see any other way to cover both the submission and completion cases.

> 
> Mike
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

