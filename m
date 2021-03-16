Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE62C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:26:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1099764F90
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 23:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1099764F90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-Usvr-geDObaE0HLfwlxnkQ-1; Tue, 16 Mar 2021 19:26:47 -0400
X-MC-Unique: Usvr-geDObaE0HLfwlxnkQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AFC51850605;
	Tue, 16 Mar 2021 23:26:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EC1660875;
	Tue, 16 Mar 2021 23:26:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9512E4EA31;
	Tue, 16 Mar 2021 23:26:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12GNQYYN021169 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 19:26:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 78E812166BA3; Tue, 16 Mar 2021 23:26:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71DA62166BA2
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 23:26:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ADAD800B24
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 23:26:31 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-513-pu3SdP0AMx2rQbdDc7aaXQ-1; Tue, 16 Mar 2021 19:26:27 -0400
X-MC-Unique: pu3SdP0AMx2rQbdDc7aaXQ-1
IronPort-SDR: /fP1D7DIj8EeYCFZQkNuOxm/bkw0/j7RBdjU2BMHLDIKUTXYwn557aYdCIkFzIZ5cldeqvKPXb
	VGDW+9KG9aAdJTvDelqChwzs/Z6gX9v91HZMivihB34L3p5P2ktQ978lTiKbLAEk2mtElbqhDU
	iw5VPi3Z1AfavrCwEjDVxC2vTQ6KmyqKtPWXpZDsV+GZ4zB36FiAlOQX0ceh1hVbT89yLtRCwG
	gUSUTEsFXhBHkU/Y4USmHXxviIWI+3rjgnTClFoKv4Yjx/+2f5aqTY/hoXCWf23VjIc4T6uHTk
	SxI=
X-IronPort-AV: E=Sophos;i="5.81,254,1610380800"; d="scan'208";a="273028537"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
	by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 07:26:25 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6669.namprd04.prod.outlook.com (2603:10b6:208:1e0::16)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32;
	Tue, 16 Mar 2021 23:26:22 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3933.032;
	Tue, 16 Mar 2021 23:26:22 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: [PATCH v2] dm table: Fix zoned model check and zone sectors check
Thread-Index: AQHXGh3izz670F4QskaqbJkCtpIqbg==
Date: Tue, 16 Mar 2021 23:26:22 +0000
Message-ID: <BL0PR04MB6514DF27C4DC5A22866D704FE76B9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210316043602.1208915-1-shinichiro.kawasaki@wdc.com>
	<BL0PR04MB6514D80C4CDFE34F1A293397E76B9@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20210316134716.GA23081@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:d8f9:73e8:b1d8:d796]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b3a9407-f09a-4863-5a90-08d8e8d2e943
x-ms-traffictypediagnostic: MN2PR04MB6669:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6669053425AB19C393609BAFE76B9@MN2PR04MB6669.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:480
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: to+bxylT9APIi9dkCW1aR6w/4Bzi+KnFyu3ieSiza+VJggDVcmqqOYdvz305f6V7EAHYfF6grjveMYPrwht0Q6MhmACEZWxc5aq5AlN9P216T4uoOtlJ2UTNT/LFT9upe7LK5qPpcgQQzs0OpLmoWSejVrMduTu5EyzsjINdee9SYvpoHXkgpAU2usuBllwADX92XWU0yrsBMR/vN0e78g8XOGK5S2p1P5WABIybbLBXPxFGx1GEGP+HLTXwx6OFBsZBNb0JO/OMjoD5Xo/9S4AkFSHwXU4jVU6XrA40IifafbHEMqiiOb+0F5n0jPoS1wxYNIZQlNSFcgmX+k1sZ7745wgwa6qhQr/pYBTVPEBv5mmXy3BrzkUPBvFUvmGzT67o0MUkFk1vH1sFNffzDG+1hmJRy8EcZBJvY8lbnU2FbCcRfsf7NAhDPbBN+7Yn5uoYHkNNEwcPhu8WbzymoQPSlU/AXhh2a6aHwYsyA6TLUO6UHSs05GV4PrEXg8ZUXGn6ndEPfkiErWjmrqSNPtu/hsBPYYNZckfmnZTGTmXI0P1xwiygmYvv088sHzSy
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(8936002)(6916009)(71200400001)(2906002)(186003)(66476007)(54906003)(52536014)(53546011)(66946007)(8676002)(66556008)(91956017)(6506007)(478600001)(66446008)(7696005)(5660300002)(64756008)(55016002)(76116006)(4326008)(9686003)(83380400001)(33656002)(316002)(86362001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QeECgjpr7A68qPlGXE+N7NSX7bS2Fw1GjPhT+/vSYhuzo9KCMdW4coHvYFUY?=
	=?us-ascii?Q?9pyEEbcs8sLDmm4bb6pyXqAhXYN8AcCBxwcxc2IwFkdUy89vN4K4eY13iRzD?=
	=?us-ascii?Q?5DvmuZyucchqmgqiScJxicqvYZSPqtZRlxorgqb5fn3jeHpKXANouYLCmeDh?=
	=?us-ascii?Q?R1PEO+VnwNN3MhDYaXrW73Cc/Npr/LFXXgMaBNnVpsZzTnJdGTggDWKS2hX3?=
	=?us-ascii?Q?INVdS7o3/zYDe953jiRzzI3SOXRHARd6sI7zZ7CVEb6ik4mfQPcDoL1EL6iC?=
	=?us-ascii?Q?ir/gZgr8hby4wagkFBCHdSzvWmtaXHwyjY2u4FNNL5LGdMUQxGPDT8br3cIp?=
	=?us-ascii?Q?lPNdaN/Vg2jY67qvl3/AVGJrJVMqIlxtze+WgN6hKKf1fdw3SV139si5getg?=
	=?us-ascii?Q?R63zeJ/AByMsAZWL+XuOxPaesfpxWYdtzcJMI7uNScL80bzCjl7MuMqFKupP?=
	=?us-ascii?Q?EwRJwqctmQbtHHMSn5hFJmThhY65UL/FzjxFOnUhKXFrah7fIyVqfSBgtXmu?=
	=?us-ascii?Q?aUSODErplk4NhIvPjvH/dBWV28iIhSA8I0jMh1spT13crpqjZuMmQyYjtwQ5?=
	=?us-ascii?Q?Ir7FpfClfdMIGNADb9EjscLy3ZQl6xNy858+tT1Cy0TI2qLn25Ncp7JolNIP?=
	=?us-ascii?Q?HJ4pFN1/nT704gG+fpYsC5LM82RBaSnFiExKovo5CcioSwO8a+1seKDcqEcU?=
	=?us-ascii?Q?pi47qaB005R9Kp7NR1UEDXywWRO0OoOjP4hvDBniYuHxTs8F7TB/yMQGQdeM?=
	=?us-ascii?Q?CsHP8vRl1+bJNBFUjaBez7kXianO4GQJqto/ZpDrVIBxW+g2OZjwr8uCc9Bm?=
	=?us-ascii?Q?knnZRTL81DdBwWu0gV3aB+L8OOXb73CgbpOSSsWjrR23gO/bmqgv7qR7K6wq?=
	=?us-ascii?Q?M4JBvs3SHZbKnu/IPY2gmmIbbJCm8HaAW4/VXymBZvdJAoTsT1R9qU1hNkHT?=
	=?us-ascii?Q?1HWJBSf6SYUbXXNtv/0EAUtfIPWeCd1fy+B25uXT/OsevhiHp/W/lWeSqspJ?=
	=?us-ascii?Q?qcwziINCadz2ikv0YRLObdbuy63rtWjs+pJY9TdbMOM8m3mzXepdcT4jL9sq?=
	=?us-ascii?Q?6OnMSp4AXcHnwNUuT7EUGtPaW0ZdiU8BT+yaWD261mn986Gkv4UK+D2szUu6?=
	=?us-ascii?Q?b7Uul9Hi0A3xLqQAm8IWrx34+XSTN4s0otHvIvWzahcwSrH4h2OLeQNVMZ+S?=
	=?us-ascii?Q?C6hZFhv6Edyf+76XwkCbpz3owhb48Espjhc5BEInu11T3G2C85ukBLwafXso?=
	=?us-ascii?Q?FWQKx7MKBqD9+1a2DBIsg1XoKrkluy+90OInCPF4ouzPrjJYXo8DTwjou+KJ?=
	=?us-ascii?Q?l3yWnlqpO57Qrqz8KlFPEiyywhQp2oysBMkRbdeqZcPblJAJpEoqIv4lTdmk?=
	=?us-ascii?Q?BDhfvamqqraVOibh5CDQycyUOvrYvHuD4xN6BOZsN03gvdO+yQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3a9407-f09a-4863-5a90-08d8e8d2e943
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 23:26:22.5912 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BICmfZqWgz+Xcin6g1UII6ZrtdPKNEa1XR5D+U9VEY/nmwYPwy1SQZFyIE3TyhKPRYqUBR+BxO2mtJKzXrB9hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6669
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12GNQYYN021169
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/03/16 22:47, Mike Snitzer wrote:
> On Tue, Mar 16 2021 at  2:14am -0400,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> On 2021/03/16 13:36, Shin'ichiro Kawasaki wrote:
>>> Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
>>> capability checks") triggered dm table load failure when dm-zoned device
>>> is set up for zoned block devices and a regular device for cache.
>>>
>>> The commit inverted logic of two callback functions for iterate_devices:
>>> device_is_zoned_model() and device_matches_zone_sectors(). The logic of
>>> device_is_zoned_model() was inverted then all destination devices of all
>>> targets in dm table are required to have the expected zoned model. This
>>> is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
>>> since each target has only one destination device. However, this results
>>> in failure for dm-zoned with regular cache device since that target has
>>> both regular block device and zoned block devices.
>>>
>>> As for device_matches_zone_sectors(), the commit inverted the logic to
>>> require all zoned block devices in each target have the specified
>>> zone_sectors. This check also fails for regular block device which does
>>> not have zones.
>>>
>>> To avoid the check failures, fix the zone model check and the zone
>>> sectors check. For zone model check, introduce the new feature flag
>>> DM_TARGET_MIXED_ZONED_MODEL, and set it to dm-zoned target. When the
>>> target has this flag, allow it to have destination devices with any
>>> zoned model. For zone sectors check, skip the check if the destination
>>> device is not a zoned block device. Also add comments and improve an
>>> error message to clarify expectations to the two checks.
>>>
>>> Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
>>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>>> ---
>>> Changes from v1:
>>> * Added DM_TARGET_MIXED_ZONED_MODEL feature for zoned model check of dm-zoned
>>>
>>>  drivers/md/dm-table.c         | 34 ++++++++++++++++++++++++++--------
>>>  drivers/md/dm-zoned-target.c  |  2 +-
>>>  include/linux/device-mapper.h | 15 ++++++++++++++-
>>>  3 files changed, 41 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>> index 95391f78b8d5..cc73d5b473eb 100644
>>> --- a/drivers/md/dm-table.c
>>> +++ b/drivers/md/dm-table.c
>>> @@ -1594,6 +1594,13 @@ static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
>>>  	return blk_queue_zoned_model(q) != *zoned_model;
>>>  }
>>>  
>>> +/*
>>> + * Check the device zoned model based on the target feature flag. If the target
>>> + * has the DM_TARGET_ZONED_HM feature flag set, host-managed zoned devices are
>>> + * also accepted but all devices must have the same zoned model. If the target
>>> + * has the DM_TARGET_MIXED_ZONED_MODEL feature set, the devices can have any
>>> + * zoned model with all zoned devices having the same zone size.
>>> + */
>>>  static bool dm_table_supports_zoned_model(struct dm_table *t,
>>>  					  enum blk_zoned_model zoned_model)
>>>  {
>>> @@ -1603,13 +1610,16 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>>>  	for (i = 0; i < dm_table_get_num_targets(t); i++) {
>>>  		ti = dm_table_get_target(t, i);
>>>  
>>> -		if (zoned_model == BLK_ZONED_HM &&
>>> -		    !dm_target_supports_zoned_hm(ti->type))
>>> -			return false;
>>> -
>>> -		if (!ti->type->iterate_devices ||
>>> -		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
>>> -			return false;
>>> +		if (dm_target_supports_zoned_hm(ti->type)) {
>>> +			if (!ti->type->iterate_devices ||
>>> +			    ti->type->iterate_devices(ti,
>>> +						      device_not_zoned_model,
>>> +						      &zoned_model))
>>> +				return false;
>>> +		} else if (!dm_target_supports_mixed_zoned_model(ti->type)) {
>>> +			if (zoned_model == BLK_ZONED_HM)
>>> +				return false;
>>> +		}
>>>  	}
>>>  
>>>  	return true;
>>> @@ -1621,9 +1631,17 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
>>>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>>>  	unsigned int *zone_sectors = data;
>>>  
>>> +	if (!blk_queue_is_zoned(q))
>>> +		return 0;
>>> +
>>>  	return blk_queue_zone_sectors(q) != *zone_sectors;
>>>  }
>>>  
>>> +/*
>>> + * Check consistency of zoned model and zone sectors across all targets. For
>>> + * zone sectors, if the destination device is a zoned block device, it shall
>>> + * have the specified zone_sectors.
>>> + */
>>>  static int validate_hardware_zoned_model(struct dm_table *table,
>>>  					 enum blk_zoned_model zoned_model,
>>>  					 unsigned int zone_sectors)
>>> @@ -1642,7 +1660,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
>>>  		return -EINVAL;
>>>  
>>>  	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
>>> -		DMERR("%s: zone sectors is not consistent across all devices",
>>> +		DMERR("%s: zone sectors is not consistent across all zoned devices",
>>>  		      dm_device_name(table->md));
>>>  		return -EINVAL;
>>>  	}
>>> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
>>> index 697f9de37355..7e88df64d197 100644
>>> --- a/drivers/md/dm-zoned-target.c
>>> +++ b/drivers/md/dm-zoned-target.c
>>> @@ -1143,7 +1143,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
>>>  static struct target_type dmz_type = {
>>>  	.name		 = "zoned",
>>>  	.version	 = {2, 0, 0},
>>> -	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
>>> +	.features	 = DM_TARGET_SINGLETON | DM_TARGET_MIXED_ZONED_MODEL,
>>
>> Thinking about it, DM_TARGET_SINGLETON is wrong for dm-zoned now that we can
>> create devices using multiple devices... But it does not seem to matter much
>> since it really looks like this flag is totally unused/unchecked by DM core.
>> Maybe something we can remove in a followup cleanup ? Mike ?
> 
> Not sure why you think it unused, drivers/md/dm-table.c:dm_table_add_target:
> 
>         if (t->singleton) {
>                 DMERR("%s: target type %s must appear alone in table",
>                       dm_device_name(t->md), t->targets->type->name);
>                 return -EINVAL;
>         }
> 
>         ...
> 
>         if (dm_target_needs_singleton(tgt->type)) {
>                 if (t->num_targets) {
>                         tgt->error = "singleton target type must appear alone in table";
>                         goto bad;
>                 }
>                 t->singleton = true;
>         }
> 
> So it really should be causing problems if you do in fact support/need
> multiple targets combined with "zoned".

I completely misread the code ! There is no problem :)
My apologies about the noise.

> 
> Mike
> 
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

