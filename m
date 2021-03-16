Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FAAC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 06:15:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8817E650EC
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 06:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8817E650EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-ahw-rYu_M-ycvZ15PqhcWA-1; Tue, 16 Mar 2021 02:15:37 -0400
X-MC-Unique: ahw-rYu_M-ycvZ15PqhcWA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C93D760C1;
	Tue, 16 Mar 2021 06:15:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3366B5C1A1;
	Tue, 16 Mar 2021 06:15:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D38DD1800848;
	Tue, 16 Mar 2021 06:15:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12G6FPm0021603 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 02:15:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3BBCE2166BB1; Tue, 16 Mar 2021 06:15:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 346962166BA4
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 06:15:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1C81801E8D
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 06:15:22 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-95-VUnuZSJ9OjeIotaUTKKRKA-1; Tue, 16 Mar 2021 02:15:20 -0400
X-MC-Unique: VUnuZSJ9OjeIotaUTKKRKA-1
IronPort-SDR: 8lTYCC2dyGDEwpad/xnlxkJsujbsjNwcpoK+mA5konPRC0L2i1ImdDu7LrZ04Ogmg66ZOy9ta1
	m85KeE4MqnWHVEMwA7Dp5pqQyEO2/Ws/vFZk52VZt/getgodSy5FQZOZjgYV/jdyh9wiTX/JfF
	SRiS/VPcoGdrSCYiPA5597Rk9PBwV7WZ4mJsAOJAlIyBGo04Swyj3ObKcH01g4qvWFmQV1rL1L
	DyidkIwE7OEWTsNrkVhfz4LE639RvEnBKVRInRTrp5wN+asOUU8JGS8DX5shqdOmDv5Q6F0qq7
	mR8=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; d="scan'208";a="272951558"
Received: from mail-dm6nam10lp2104.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.104])
	by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 14:14:15 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4739.namprd04.prod.outlook.com (2603:10b6:208:48::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32;
	Tue, 16 Mar 2021 06:14:14 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3933.032;
	Tue, 16 Mar 2021 06:14:14 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Thread-Topic: [PATCH v2] dm table: Fix zoned model check and zone sectors check
Thread-Index: AQHXGh3izz670F4QskaqbJkCtpIqbg==
Date: Tue, 16 Mar 2021 06:14:14 +0000
Message-ID: <BL0PR04MB6514D80C4CDFE34F1A293397E76B9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210316043602.1208915-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d8f9:73e8:b1d8:d796]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f845604d-a2de-4f24-cc32-08d8e842b901
x-ms-traffictypediagnostic: BL0PR04MB4739:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB4739B2F967FCAFC2398A2CE6E76B9@BL0PR04MB4739.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:328
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AnGyesi+QXSGln2s7XDWKKZS02NEQE8+ju5kqvnOujE8Bkltbvao2Vlm6XEakvvMV/ZlBBadBxjBAa3p94BSL5Iq5YHV9SAeO4V6QM5FUhSkEPbs5vWp49XkAw93FdLwf4H/AO+qYBE7V4EDBX2wxEPQSbn7Bom/X9RlW406oS3WAs147BnZIRs80bFHSq7mvmgM9CP5UkPypf3f88SXmAT8btT+ZW6zwhMZyshGa/4jkcoVL4A/hsVJSz1COaaeiQX8l40YAav/itc0QzxzBOrvhOE8hRAv6z1sEaW5DedCkDg2NO3Oo7jJuZzcq7wpEohNloMCuX4WE5B5S9pmwnCtPWfF1t3on76JMonRB0ZDbSqnu3tqIQ+olbbEpHXhCdoCi3suoeazpm+/VWCNR8fCePBLJ47UAi+H4INf90duBIN965eY0SLU6Rzwovvk7E8iI/RhVU6cXJQCxMrlAjE5X6XM0S0WyPRTlREobqTo8f6vWm8E/oXNajq6kyPt5vhuyjFIR5q8UJZXabzLrjZlDRUPRiIilwKEbTXzKDx9tZkLHDdI6TgsVgEe7i+N
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(66556008)(86362001)(478600001)(91956017)(316002)(64756008)(66446008)(5660300002)(66946007)(4326008)(66476007)(8676002)(83380400001)(76116006)(8936002)(55016002)(53546011)(9686003)(186003)(7696005)(52536014)(71200400001)(33656002)(2906002)(110136005)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4ihnYKIjqF6uGu5ci1r7AgunOt2Fq9D5gVu0J6HFRTXbs/ojtRVsyEGLamca?=
	=?us-ascii?Q?AQWpx2Mm71yekyqqA6Y2OhryO21M5S8q1RSidVifbGnGCWe/fnAye6n9xA8j?=
	=?us-ascii?Q?ALp7EfEDhE963YsGHWZDlY48uvq1cAWr6inpJc6wCvqpmarNJDJ0BOh+WeLZ?=
	=?us-ascii?Q?MPkzcLoCLg/rcdQLaKYleYoFnb08750HV3pKAGUAnETo2Yd3suzRZaifL5kq?=
	=?us-ascii?Q?qW8XAb18grEF9p2IsQwaDLmSPfO6mJtcdyuPfNlfP/ip6efDvYXJldV4KQf5?=
	=?us-ascii?Q?F5/90tisJvol5+bNdVej+TYXn1wJcHEjUq2xQhmt6MxQmtTqzs/RyneVuy/O?=
	=?us-ascii?Q?yzY//ilm9EZu8ZBgpFuIccnT2phTtKxevmsu5JPg2xOtLavaxhM2C7yXr/sH?=
	=?us-ascii?Q?3cR1oStnfK80ep5yyVAzLUKGb6wMcMH80OvoxAdu4df0ZbnF1kN9xmOosuWD?=
	=?us-ascii?Q?3uR4u7+GwSgVtdpk3d5gET11s4BaEu271mH5OMaKb3sxw8hq6RWWE8Vpv0jz?=
	=?us-ascii?Q?E9NqOIavorauevQ5W2N7G4RIUKYd9LKHokjXjm8lebV43Lwd3qm5SWitnDeE?=
	=?us-ascii?Q?KjDxA3qcuL6+0jryVGdE03Gh5IGJv6/gD7CkQqGRRV+o1wawy3ET80ab+BmJ?=
	=?us-ascii?Q?LHD/yi3T1VT3uZvpBXZl22y0beORl+Y0RgL2JqRvKFL3xXGwrRsWWrRN9YM7?=
	=?us-ascii?Q?VwpOtYc2Gpnth5Ggtq5l/BLpbFM5kgxknBQMdmGlQ6ypZ8WENX35+SQ+yc17?=
	=?us-ascii?Q?3t+gg7R7dFtskiDtGOQq2idkJHFZ0fOxns2ZVyuxiQVpS/B+5qRnYqIz69Ua?=
	=?us-ascii?Q?av2oyykuzP/Qs7UM84WuJx2EAQMMKml6RybCHI9MUJi8zx85TAGu93DF6pXf?=
	=?us-ascii?Q?yTymVttiK00gr4byoHKMPF7R8Qu3ReBYL7C3Z4DJrBhm1q7PYX3odGXe35ro?=
	=?us-ascii?Q?SaldKSmvoW7ilCR4llugXfdJNIbXLWTRvuHgpXko2mUATLoTB/F8LalA9N/x?=
	=?us-ascii?Q?M2eEipAG6lfcFkA68KOnI97BK6An1E3oW7ERdcugN6eps0Qzv1KpgX92iQZn?=
	=?us-ascii?Q?pGeoUv2BMBNV4bIbHnKGNQjg0qWxCRbwrIxT13IeZi1Ye9T8nhIi4wdUUnfu?=
	=?us-ascii?Q?oFbgRkE6os3aA7RRRZhw5xOle7pvK3XB0NX8trWDPBMsOO2uV3i4NogeZJn0?=
	=?us-ascii?Q?yAO19SGY3wNHAL5Ou3VX/lnkSa8SdLddXQgRJpukm3Ku9ZqSh/kyBpEg3ZxJ?=
	=?us-ascii?Q?vFlHVEYPzkD79bwt5A33anD2c7Wv6CPq4xZ/5nkmwf84jKViU/YnkFGeTD3T?=
	=?us-ascii?Q?OealLz15usXoluOHZflT+AD5GkkgNWJhehz51vBZO1AnW3gilNQEYZaX1z3g?=
	=?us-ascii?Q?RXqGsXbr/y4UmxXJueMXqtle7vdVe6eK7c7OtGPWdFGRTmussQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f845604d-a2de-4f24-cc32-08d8e842b901
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 06:14:14.1059 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1tjgRqEVrmXhTPTUjus6SS4zQKdnJ+cGCcIGPQreH7a0K3O2ESduBLr5rtJGU3o34rOy7KmQbcSmY5/Dhp+LlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4739
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12G6FPm0021603
X-loop: dm-devel@redhat.com
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Subject: Re: [dm-devel] [PATCH v2] dm table: Fix zoned model check and zone
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

On 2021/03/16 13:36, Shin'ichiro Kawasaki wrote:
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
> sectors check. For zone model check, introduce the new feature flag
> DM_TARGET_MIXED_ZONED_MODEL, and set it to dm-zoned target. When the
> target has this flag, allow it to have destination devices with any
> zoned model. For zone sectors check, skip the check if the destination
> device is not a zoned block device. Also add comments and improve an
> error message to clarify expectations to the two checks.
> 
> Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> Changes from v1:
> * Added DM_TARGET_MIXED_ZONED_MODEL feature for zoned model check of dm-zoned
> 
>  drivers/md/dm-table.c         | 34 ++++++++++++++++++++++++++--------
>  drivers/md/dm-zoned-target.c  |  2 +-
>  include/linux/device-mapper.h | 15 ++++++++++++++-
>  3 files changed, 41 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 95391f78b8d5..cc73d5b473eb 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1594,6 +1594,13 @@ static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
>  	return blk_queue_zoned_model(q) != *zoned_model;
>  }
>  
> +/*
> + * Check the device zoned model based on the target feature flag. If the target
> + * has the DM_TARGET_ZONED_HM feature flag set, host-managed zoned devices are
> + * also accepted but all devices must have the same zoned model. If the target
> + * has the DM_TARGET_MIXED_ZONED_MODEL feature set, the devices can have any
> + * zoned model with all zoned devices having the same zone size.
> + */
>  static bool dm_table_supports_zoned_model(struct dm_table *t,
>  					  enum blk_zoned_model zoned_model)
>  {
> @@ -1603,13 +1610,16 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>  	for (i = 0; i < dm_table_get_num_targets(t); i++) {
>  		ti = dm_table_get_target(t, i);
>  
> -		if (zoned_model == BLK_ZONED_HM &&
> -		    !dm_target_supports_zoned_hm(ti->type))
> -			return false;
> -
> -		if (!ti->type->iterate_devices ||
> -		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
> -			return false;
> +		if (dm_target_supports_zoned_hm(ti->type)) {
> +			if (!ti->type->iterate_devices ||
> +			    ti->type->iterate_devices(ti,
> +						      device_not_zoned_model,
> +						      &zoned_model))
> +				return false;
> +		} else if (!dm_target_supports_mixed_zoned_model(ti->type)) {
> +			if (zoned_model == BLK_ZONED_HM)
> +				return false;
> +		}
>  	}
>  
>  	return true;
> @@ -1621,9 +1631,17 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>  	unsigned int *zone_sectors = data;
>  
> +	if (!blk_queue_is_zoned(q))
> +		return 0;
> +
>  	return blk_queue_zone_sectors(q) != *zone_sectors;
>  }
>  
> +/*
> + * Check consistency of zoned model and zone sectors across all targets. For
> + * zone sectors, if the destination device is a zoned block device, it shall
> + * have the specified zone_sectors.
> + */
>  static int validate_hardware_zoned_model(struct dm_table *table,
>  					 enum blk_zoned_model zoned_model,
>  					 unsigned int zone_sectors)
> @@ -1642,7 +1660,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
>  		return -EINVAL;
>  
>  	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
> -		DMERR("%s: zone sectors is not consistent across all devices",
> +		DMERR("%s: zone sectors is not consistent across all zoned devices",
>  		      dm_device_name(table->md));
>  		return -EINVAL;
>  	}
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 697f9de37355..7e88df64d197 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -1143,7 +1143,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
>  static struct target_type dmz_type = {
>  	.name		 = "zoned",
>  	.version	 = {2, 0, 0},
> -	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
> +	.features	 = DM_TARGET_SINGLETON | DM_TARGET_MIXED_ZONED_MODEL,

Thinking about it, DM_TARGET_SINGLETON is wrong for dm-zoned now that we can
create devices using multiple devices... But it does not seem to matter much
since it really looks like this flag is totally unused/unchecked by DM core.
Maybe something we can remove in a followup cleanup ? Mike ?


>  	.module		 = THIS_MODULE,
>  	.ctr		 = dmz_ctr,
>  	.dtr		 = dmz_dtr,
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 7f4ac87c0b32..5c641f930caf 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -253,7 +253,11 @@ struct target_type {
>  #define dm_target_passes_integrity(type) ((type)->features & DM_TARGET_PASSES_INTEGRITY)
>  
>  /*
> - * Indicates that a target supports host-managed zoned block devices.
> + * Indicates support for zoned block devices:
> + * - DM_TARGET_ZONED_HM: the target also supports host-managed zoned
> + *   block devices but does not support combining different zoned models.
> + * - DM_TARGET_MIXED_ZONED_MODEL: the target supports combining multiple
> + *   devices with different zoned models.
>   */
>  #ifdef CONFIG_BLK_DEV_ZONED
>  #define DM_TARGET_ZONED_HM		0x00000040
> @@ -275,6 +279,15 @@ struct target_type {
>  #define DM_TARGET_PASSES_CRYPTO		0x00000100
>  #define dm_target_passes_crypto(type) ((type)->features & DM_TARGET_PASSES_CRYPTO)
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +#define DM_TARGET_MIXED_ZONED_MODEL	0x00000200
> +#define dm_target_supports_mixed_zoned_model(type) \
> +	((type)->features & DM_TARGET_MIXED_ZONED_MODEL)
> +#else
> +#define DM_TARGET_MIXED_ZONED_MODEL	0x00000000
> +#define dm_target_supports_mixed_zoned_model(type) (false)
> +#endif
> +
>  struct dm_target {
>  	struct dm_table *table;
>  	struct target_type *type;
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

