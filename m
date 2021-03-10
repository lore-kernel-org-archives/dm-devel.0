Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38AFC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 09:07:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0BD5564FEF
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 09:07:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BD5564FEF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-WnYKqIFeNWacbCHNv8R3Nw-1; Wed, 10 Mar 2021 04:07:18 -0500
X-MC-Unique: WnYKqIFeNWacbCHNv8R3Nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE1041084D68;
	Wed, 10 Mar 2021 09:07:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22FD15E1A7;
	Wed, 10 Mar 2021 09:07:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2BCE71809C86;
	Wed, 10 Mar 2021 09:07:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12A978F4030309 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 04:07:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9C5AE100F4D5; Wed, 10 Mar 2021 09:07:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 955C9100F4DA
	for <dm-devel@redhat.com>; Wed, 10 Mar 2021 09:07:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6672B1854CBD
	for <dm-devel@redhat.com>; Wed, 10 Mar 2021 09:07:04 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-163-OFxlwte7Piy8MKiy3MMwcw-1; Wed, 10 Mar 2021 04:07:00 -0500
X-MC-Unique: OFxlwte7Piy8MKiy3MMwcw-1
IronPort-SDR: WnuXTLvotu/lMblZdCRPA1sQnng3DrKQzABvGIUOXp1VAL6MLbUtIUf3tj4iAEOcfuK1l66umV
	2d1gn82ceL2fOTiekd/YWQduI7wPpWslgImohNJKzjuWnf1ZpipiENQ61azsUUxjmZrtnQPDbo
	Nur7y/5ywVzfSSNOj/DAPMX/IWc+PrZjDqsc5A+3IeIQDOcAzmvT8X284CnBfSBznKbEnKDuqN
	gzuT97zfmk/fRaEAhGjk+2XFXgOaqOlLkcuMkgaY5jSf/21Z7mCHXscO5RIDBiY8zhf/cUu5Uj
	klg=
X-IronPort-AV: E=Sophos;i="5.81,237,1610380800"; d="scan'208";a="161817250"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
	by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2021 17:05:55 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6862.namprd04.prod.outlook.com (2603:10b6:208:1ed::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19;
	Wed, 10 Mar 2021 09:05:54 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3912.026;
	Wed, 10 Mar 2021 09:05:54 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Thread-Topic: [PATCH] dm table: Fix zoned model check and zone sectors check
Thread-Index: AQHXFYb+2D4H+Hfup060k8SyDIfc6g==
Date: Wed, 10 Mar 2021 09:05:54 +0000
Message-ID: <BL0PR04MB65147C5826EC4F4AA35A5917E7919@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210310082547.576372-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:c1a6:aaec:6201:ec23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad4cfd3e-9d9a-431e-d08f-08d8e3a3b5f0
x-ms-traffictypediagnostic: MN2PR04MB6862:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6862B75C9A6DD335E825F87BE7919@MN2PR04MB6862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:243
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 9UUPD7FI6Px4ynqVdyYQlQOgeSx+/6P8/dmwDn9jzOGI+XaDRsUVkR/1RPsiVZGl7Z2yDpA+n8Gqf9Tq8l+Ok5R8BGDnctBWO0LyKmXqepnwtWBrkMqOyDDQw3xtxi34pdA/75F35g4LQBJ8OcrLvsGnG6FSmyF8jJxdBGrBjOGNUdODUfDLrV+oF1F2mdXVMfzqfWeIda7zSSobU8VEJEfMrP/X7o6/YNkEymhpOvRucnSYrTZs8WeMcim1u8SRkwrN+C0T8b6ZMNmCipEVgxbIuf5rwa5fdbn0AfAveLgo9XgQbTrst6bEKTwpapMCKSDbvxYkPDRQntz1fJR0ng1uSyi5N8w17WcuZhx2MBDN9kCKtF0lanIOkqof3FF7cvIzbOGU8ZQNo58u/EwXD6hGRHxUD4l1qtQIdFpdkM4YRSxJNNxaa9wSkoFZ/eikAx1g0kvFJcQLoOAT6MSUa4MfbbRgGZI4fbW+4YyqMFAYIlsoCjDaxGlN41qan6sIthrndHoKFqB5H/rhr3Qcjg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(316002)(8936002)(478600001)(6506007)(53546011)(71200400001)(8676002)(33656002)(86362001)(186003)(110136005)(52536014)(83380400001)(5660300002)(9686003)(7696005)(55016002)(76116006)(91956017)(4326008)(66476007)(66556008)(66946007)(2906002)(64756008)(66446008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KTOnJ6zFul3/iTo3qjy03vmrNwYDcI5S6f7AyTwjaQ7eBvC34GPPSm0Ea4vC?=
	=?us-ascii?Q?jO4rVRNiCGA7S0hc3102oHT2ojKQGt/6RROIJnd35rH0cX/UpL/5zDyGfGKM?=
	=?us-ascii?Q?LSWVdoW8n5NaQQzxk7pEmMhL+zaoHFyXZeXIb0jWAOjx1NC/jmZObIspwEV4?=
	=?us-ascii?Q?K/u9TOlzdE267efB+hb39IhTTwegA3eGIq/C4Pxy95zbCzV7BRv2vV3sBaVf?=
	=?us-ascii?Q?pYKSF1evo3ydnrbKW1KSCweMiUCvXN0wetel/cVO/lp2lVrPUOBfDkUmhOnE?=
	=?us-ascii?Q?3hJDGBUbf6VfuQRl7DxrGmWH2ShZEUy2nMhkxo/jMdScS/ZbKI5aROPd9Pnz?=
	=?us-ascii?Q?KvorfTgd95PakbxvILf+zQFRdJGEeQZ5VLuzDDfK6pC+e5lMlWIO8OGalsKK?=
	=?us-ascii?Q?z1Yghdc0oKyK1Zjke2Rd9JRPdifMtlH+iWCK9BwdGShuanAL3aJ4XoUy1EuB?=
	=?us-ascii?Q?RfZrlzQIghH8rDERL6Sc5eULez7dXjX/NdDnAuUrCC0RjGP5S37Sc4HktlPi?=
	=?us-ascii?Q?8y9LatsRagxlZIaa4xliAgHoRn2w2I0sq3oRTyYWTv9hHX2TOVVdZrvHtC8T?=
	=?us-ascii?Q?20ZgOPg9MkqGNjnjEK/CBhXh84GmLRWBFfmjjd0Nl+kljjRxPvbFM/J5BUFS?=
	=?us-ascii?Q?fx1JN7PLlYeqcpSfOlen8T9KEYavoizqkLeHb0AWIXtnRLLQodsclSs/ZEg4?=
	=?us-ascii?Q?6q6QQfT8uwMjvNMykVACdB4flxalImbPYGTmU98NhSbTirzdK2qtlrpY/5zo?=
	=?us-ascii?Q?+rpIjADTVvedqs7fJut6go6Bc3Ud9TLCv1Ep+/wdAnkKizjDP83Xq5Zj7SrU?=
	=?us-ascii?Q?9InzbvSwczrmJ5d/RhA0fm2wcnVED1SsL1rHW8Rza4W1vTxb4HxM4xRzMBkn?=
	=?us-ascii?Q?6TV3KZWVeOEOmSOSDVIQplYjif9GA7BAY95hXkR2HrOGpl934xXQ/wIDkSkG?=
	=?us-ascii?Q?DU9IFUYm7gdeo80Uzi3nwQOLxHS0iQeukYVWgwHSrVxewCh0+gE6fFDDGFOB?=
	=?us-ascii?Q?mfCTHvFN57dVyhchIdpm9+CkVxS6v1vnS54FnJU1SngYhr4BsrLHl95k1n6o?=
	=?us-ascii?Q?Uu65svbKY+SX4k4dm3TDbv3tpT8c70HbGdgGEiudReF5qKvCka0XkiLJazeO?=
	=?us-ascii?Q?oWWWHrKAHGXk8yiRMZMSNbiUhLnDXyxWPJfQ7Isz8WUEq2ppjTtL3yHVabaM?=
	=?us-ascii?Q?khQgo6kxmuSpru0O6+jzD7+8YC63jtPDt0oE+yI2Yc2bLqzErbM1ZGDisQdm?=
	=?us-ascii?Q?3obI1hwJOagfO2aVc9QwiCoqYAtnHCeJMNEyd9+wSAOG1B1DGAAvNANFF4Q/?=
	=?us-ascii?Q?CGuQQFjUbiVIR6j8gcoOcKCnLijg/JxjhVBHNUyZBe5VaJW3kO4V4ycvl/PP?=
	=?us-ascii?Q?TRNQ/LwH1geNfwIQC8u1rWAivnTtqsmrtDhBDJfQoOGf+sIF9w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad4cfd3e-9d9a-431e-d08f-08d8e3a3b5f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 09:05:54.3203 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PwniJfWoSGQjgKC5viGYDLaImyJL10MIwyZPTwztrPlAyc43vQthjnIcZWSpoLh3z2vj4b0udtXcB/V4Y1QVtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6862
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12A978F4030309
X-loop: dm-devel@redhat.com
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [dm-devel] [PATCH] dm table: Fix zoned model check and zone
	sectors check
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

On 2021/03/10 17:25, Shin'ichiro Kawasaki wrote:
> Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
> capability checks") triggered dm table load failure when dm-zoned device
> is set up for zoned block devices and a regular device for cache.
> 
> The commit inverted logic of two callback functions for iterate_devices:
> device_is_zoned_model() and device_matches_zone_sectors(). The logic of
> device_is_zoned_model() was inverted then all destination devices of all
> targets in dm table are required to have the expected zoned model. This
> is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
> since each target has only one destination device. However, this results
> in failure for dm-zoned with regular cache device since that target has
> both regular block device and zoned block devices.
> 
> As for device_matches_zone_sectors(), the commit inverted the logic to
> require all zoned block devices in each target have the specified
> zone_sectors. This check also fails for regular block device which does
> not have zones.
> 
> To avoid the check failures, fix the zone model check and the zone
> sectors check. For zone model check, invert the device_is_zoned_model()
> logic again to require at least one destination device in one target has
> the specified zoned model. For zone sectors check, skip the check if the
> destination device is not a zoned block device. Also add comments and
> improve error messages to clarify expectations to the two checks.
> 
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
> ---
>  drivers/md/dm-table.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 95391f78b8d5..04b7a3978ef8 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1585,13 +1585,13 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
>  	return true;
>  }
>  
> -static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
> -				  sector_t start, sector_t len, void *data)
> +static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
> +				 sector_t start, sector_t len, void *data)
>  {
>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>  	enum blk_zoned_model *zoned_model = data;
>  
> -	return blk_queue_zoned_model(q) != *zoned_model;
> +	return blk_queue_zoned_model(q) == *zoned_model;
>  }
>  
>  static bool dm_table_supports_zoned_model(struct dm_table *t,
> @@ -1608,7 +1608,7 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>  			return false;
>  
>  		if (!ti->type->iterate_devices ||
> -		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
> +		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
>  			return false;
>  	}
>  
> @@ -1621,9 +1621,18 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>  	unsigned int *zone_sectors = data;
>  
> +	if (blk_queue_zoned_model(q) == BLK_ZONED_NONE)
> +		return 0;
> +
>  	return blk_queue_zone_sectors(q) != *zone_sectors;
>  }
>  
> +/*
> + * Check consistency of zoned model and zone sectors across all targets.
> + * For zoned model, at least one destination device used by each target shall
> + * have the zoned model. For zone sectors, if the destination device is a zoned
> + * block device, it shall have the specified zone_sectors.
> + */
>  static int validate_hardware_zoned_model(struct dm_table *table,
>  					 enum blk_zoned_model zoned_model,
>  					 unsigned int zone_sectors)
> @@ -1632,7 +1641,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
>  		return 0;
>  
>  	if (!dm_table_supports_zoned_model(table, zoned_model)) {
> -		DMERR("%s: zoned model is not consistent across all devices",
> +		DMERR("%s: zoned model is not consistent across all targets",
>  		      dm_device_name(table->md));
>  		return -EINVAL;
>  	}
> @@ -1642,7 +1651,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
>  		return -EINVAL;
>  
>  	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
> -		DMERR("%s: zone sectors is not consistent across all devices",
> +		DMERR("%s: zone sectors is not consistent across all zoned devices",
>  		      dm_device_name(table->md));
>  		return -EINVAL;
>  	}
> 

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

