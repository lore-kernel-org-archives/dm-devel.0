Return-Path: <SRS0=XTDI=IK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFA6C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 22:13:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 019EA64F33
	for <dm-devel@archiver.kernel.org>; Fri, 12 Mar 2021 22:13:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 019EA64F33
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570--6q4uOw6Pn2s_Fi8a0dbwQ-1; Fri, 12 Mar 2021 17:13:20 -0500
X-MC-Unique: -6q4uOw6Pn2s_Fi8a0dbwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E8178015BD;
	Fri, 12 Mar 2021 22:13:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 098FF60CD1;
	Fri, 12 Mar 2021 22:13:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D3ACC4ED86;
	Fri, 12 Mar 2021 22:13:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12CMD8Kg024840 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Mar 2021 17:13:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91F972166BA2; Fri, 12 Mar 2021 22:13:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A7882166B2F
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 22:13:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4135C810BD1
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 22:13:06 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-287-rON4ESDfPGqRFoHV7XvJgA-1; Fri, 12 Mar 2021 17:13:01 -0500
X-MC-Unique: rON4ESDfPGqRFoHV7XvJgA-1
IronPort-SDR: +0PA8dlRTDquvAFERqrysTRaVbAvpLOT84A1G85Rgs98lU99ITT6PjIt+NpM0s4iU6NZgwUARH
	nzcoPktYxOEvsF1lt42mS7cM5DF+2sSM48vk/wPq86xHR8/kb/mu1HMt3zsLBmnbrKAwCaRZFl
	QNGNmW2iswq/M2sJeI+eZgezoW9vsLVu/0cbe9NMMjPxTDTsvhQg3O2FjgCfiqWUj412gDhsjF
	Ss6WTPIwcOeRZSKpMYSA28TN88pmIOACeoWKukFTnXCYdKIaAZ0EvxUhcprobkdjuzxyVXnriL
	yhM=
X-IronPort-AV: E=Sophos;i="5.81,244,1610380800"; d="scan'208";a="162025077"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
	by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2021 06:12:59 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4612.namprd04.prod.outlook.com (2603:10b6:208:47::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28;
	Fri, 12 Mar 2021 22:12:57 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3933.032;
	Fri, 12 Mar 2021 22:12:57 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: dm table: Fix zoned model check and zone sectors check
Thread-Index: AQHXFp+jMtj6JRfarUejHyLQrYgS9g==
Date: Fri, 12 Mar 2021 22:12:57 +0000
Message-ID: <BL0PR04MB651417C61BA209065CE1B7D6E76F9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210310082547.576372-1-shinichiro.kawasaki@wdc.com>
	<20210311175440.GA28509@redhat.com>
	<BL0PR04MB6514474389D7E7EEAC82B2CBE7909@BL0PR04MB6514.namprd04.prod.outlook.com>
	<20210312190946.GA2591@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:bccc:6f52:efed:4bfb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f306e1dc-98d1-4711-2dcd-08d8e5a3fdbc
x-ms-traffictypediagnostic: BL0PR04MB4612:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB4612387AA59480A93D0BA8FBE76F9@BL0PR04MB4612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4ITFsoomArkhznN2XYCEPnieA3V9UkX6rShLGMOmyddbBxNjEcQ0kW9R2tswn4/Fe/fYnYnD6G5gOPmCMi87iu5XZVIt+lD9byaHmuXwd3iKglDEX1d2wVK7wOERB1OayZApl8HqmSj3wZSIsDC5WVvDvH6t1eRbWDYabRpjkJZLmByQJD3YEMx6RpJB2/l2d9UKzPAk1o077VXdVEA2XoviDg9aLhk3WaHQaKdA6FsZs0J53ORNaV6BdrTR3p4ejrVSctz5w3uyn8XflumVmFmyCzTcXmDLsjVelFuM+YPAWD5f+Brd+hLhNwrg4sMOw5gp5ZP/Yb09z4ABc6mtwKcwEeDRjKB2jMWL06Hi5J2w6aGN+r8UtkD98z/lWn6aqahM80ncxjCjDUJo0+pXMt2i9TTe5wr4YNFVLBWvtUnv0f8G7hw15FxZAz+RkHginrfU6hMiQfow/z96/WtvXKnENvKs6j5K05SbzC9mtRd30l20QWVb1LXeuDd4HuwZnkpWqOYLzs7WKqrUvPDfig==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(66446008)(66946007)(76116006)(64756008)(8676002)(478600001)(66476007)(186003)(66556008)(91956017)(6916009)(7696005)(71200400001)(8936002)(4326008)(33656002)(316002)(52536014)(86362001)(2906002)(9686003)(55016002)(5660300002)(83380400001)(53546011)(6506007)(54906003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ddlCgBunmjYtYilZAxVvpkGW+dgAfmvrIMEUlhhWNkFt2ebxOLoWa0fsPMio?=
	=?us-ascii?Q?kko2HjbyAHIwjzSl9gOZAAvjQrzf4i5V/Ur4dddosfUgCsV8Yr98pLL7r3tk?=
	=?us-ascii?Q?m6gp1tjizSiF5OQs2amKDhtow+zb7UZz8njGXX0esA4juVulAz7+94UHhi/Y?=
	=?us-ascii?Q?m7FKf06aD2Sxg7NNohwYbcSomRwuMhL6nABQTI0P5WmUMZH6F90xbMqy0AX0?=
	=?us-ascii?Q?SoMs4UTk9u0Jy4vEVXiqNr1lhbsAaxkLmC4QPyMgr3B5MXvgc3CUb+ZUxKlU?=
	=?us-ascii?Q?ieVrwQSsoV6KYc5oFKOD3XxVNUp5oRsdHDF3B6WgwchmPAPqFMzx/W5bRl8C?=
	=?us-ascii?Q?mxERwfhXUtxIdlF5RTJ3LltB1xx+QdlDh0XqbXdzwG+SvgNI2sbI+/fpD6iT?=
	=?us-ascii?Q?v0UkCXNNh5EZJesz1YXNkuqdx8pPfqyMH9B6QCZobKwiINMpwr2DGLzgOz9c?=
	=?us-ascii?Q?fQYJDmB70uLG8WdvqRmixoYIJqs0m2XyfT3HIgsHSwnsEiyagD+i1uSpfA54?=
	=?us-ascii?Q?RY70G8LAouqtE9BI/FNv7pNbZzkPG0SsHqbaBM4QHHG7wZhoW50iy20g44lG?=
	=?us-ascii?Q?hu0B6vJA9JBg/OpLN0UBf2PbE3j6pZS6HmfdSZ/p3BvBhW5iFptI7A1b5WRi?=
	=?us-ascii?Q?t6v5UoQLiIyCPNDNOnFbh4GQgix1u5mkT36dXgnA91sbIQJNfII0rPzLvrFN?=
	=?us-ascii?Q?QK4NqK2FnfFNqomswRJkMXno9LS8qJ8GzAzj8thmI3B6s1n5xBJudcc/tYLr?=
	=?us-ascii?Q?ACPtrH3oc3zcdNU7qUzl3gA4UDyq3JEJOyzAgs6QU7ktf0X/4dpH/U04WEIf?=
	=?us-ascii?Q?Z28B8rwMW7jCkM9wYAxK1XNrWIiYkv/SfbM7vcXRBV+WHH7gewa1AJuXTeLo?=
	=?us-ascii?Q?keJDRDBJeW+4ZiQzRQizl75wdp7suCd2hUNPBJ+PQUUeGRfVAnurlRtms8Hx?=
	=?us-ascii?Q?MKUClBGjaOhLq0zDz/gJXp1wmvI1Akbq8S9tlvMLcb+WDcJUYdaCaHOSrtrV?=
	=?us-ascii?Q?JjdiJWAFSFFR9sCUC+H/x/6CJkL8d9BzYjHUlnB931/ywUbnC3A01kaQyZVW?=
	=?us-ascii?Q?4b56+A2yv4qdWILeLl/gOGieiPgxTMcx84bsw9e752hq2zwL+P2oTrZgDg17?=
	=?us-ascii?Q?hc+hsk7lg5ZDhMvRpcvSyZdJ3bCN5SdFNvqo/f81ZbxeKVUSSXtsjbiaSODI?=
	=?us-ascii?Q?vO3ZojJU4WyG/QYHHmdESoi5ksPNRnVdkElGYbZDZHjCntzgh5qWknDStvgT?=
	=?us-ascii?Q?Tc3Aqd66w3k3WJ1ZwmjfKLAjFtlwjxKJlSv7PYGkkuVBbtI6IAVrQwK1MO1N?=
	=?us-ascii?Q?387jIb3UGR73o0+uSRmWf+Mz6YVVHnKZLhi4B1cPnksnub22ChqwLuHU7twa?=
	=?us-ascii?Q?PgS/JJhpGnPqvwfH0vIfebRxVswOWarc/8oNowknNdNhONZNNg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f306e1dc-98d1-4711-2dcd-08d8e5a3fdbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 22:12:57.1088 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Elu11JvHeiF8UvZq7y+FSmw0THQdxougJIjRXZELGMrvCPm4m4nHGpg+pN+JeUeNmaaqFvJZ/2YWvkAqsZ83SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4612
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12CMD8Kg024840
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm table: Fix zoned model check and zone sectors
	check
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

On 2021/03/13 4:09, Mike Snitzer wrote:
> On Thu, Mar 11 2021 at  6:30pm -0500,
> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> 
>> On 2021/03/12 2:54, Mike Snitzer wrote:
>>> On Wed, Mar 10 2021 at  3:25am -0500,
>>> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com> wrote:
>>>
>>>> Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
>>>> capability checks") triggered dm table load failure when dm-zoned device
>>>> is set up for zoned block devices and a regular device for cache.
>>>>
>>>> The commit inverted logic of two callback functions for iterate_devices:
>>>> device_is_zoned_model() and device_matches_zone_sectors(). The logic of
>>>> device_is_zoned_model() was inverted then all destination devices of all
>>>> targets in dm table are required to have the expected zoned model. This
>>>> is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
>>>> since each target has only one destination device. However, this results
>>>> in failure for dm-zoned with regular cache device since that target has
>>>> both regular block device and zoned block devices.
>>>>
>>>> As for device_matches_zone_sectors(), the commit inverted the logic to
>>>> require all zoned block devices in each target have the specified
>>>> zone_sectors. This check also fails for regular block device which does
>>>> not have zones.
>>>>
>>>> To avoid the check failures, fix the zone model check and the zone
>>>> sectors check. For zone model check, invert the device_is_zoned_model()
>>>> logic again to require at least one destination device in one target has
>>>> the specified zoned model. For zone sectors check, skip the check if the
>>>> destination device is not a zoned block device. Also add comments and
>>>> improve error messages to clarify expectations to the two checks.
>>>>
>>>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>>>> Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
>>>> ---
>>>>  drivers/md/dm-table.c | 21 +++++++++++++++------
>>>>  1 file changed, 15 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>>> index 95391f78b8d5..04b7a3978ef8 100644
>>>> --- a/drivers/md/dm-table.c
>>>> +++ b/drivers/md/dm-table.c
>>>> @@ -1585,13 +1585,13 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
>>>>  	return true;
>>>>  }
>>>>  
>>>> -static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
>>>> -				  sector_t start, sector_t len, void *data)
>>>> +static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
>>>> +				 sector_t start, sector_t len, void *data)
>>>>  {
>>>>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>>>>  	enum blk_zoned_model *zoned_model = data;
>>>>  
>>>> -	return blk_queue_zoned_model(q) != *zoned_model;
>>>> +	return blk_queue_zoned_model(q) == *zoned_model;
>>>>  }
>>>>  
>>>>  static bool dm_table_supports_zoned_model(struct dm_table *t,
>>>> @@ -1608,7 +1608,7 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>>>>  			return false;
>>>>  
>>>>  		if (!ti->type->iterate_devices ||
>>>> -		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
>>>> +		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
>>>>  			return false;
>>>>  	}
>>>
>>> The point here is to ensure all zoned devices match the specific model,
>>> right?
>>>
>>> I understand commit 24f6b6036c9e wasn't correct, sorry about that.
>>> But I don't think your change is correct either.  It'll allow a mix of
>>> various zoned models (that might come after the first positive match for
>>> the specified zoned_model)... but because the first match short-circuits
>>> the loop those later mismatched zoned devices aren't checked.
>>>
>>> Should device_is_zoned_model() also be trained to ignore BLK_ZONED_NONE
>>> (like you did below)?
>>
>> Thinking more about this, I think we may have a deeper problem here. We need to
>> allow the combination of BLK_ZONED_NONE and BLK_ZONED_HM for dm-zoned multi
>> drive config using a regular SSD as cache. But blindly allowing such combination
>> of zoned and non-zoned drives will also end up allowing a setup combining these
>> drive types with dm-linear or dm-flakey or any other target that has the
>> DM_TARGET_ZONED_HM feature flag set. And that will definitely be bad and break
>> things if the target is not prepared for that.
>>
>> Should we introduce a new feature flag ? Something like DM_TARGET_MIXED_ZONED_HM
>> ? (not sure about the name of the flag. Suggestions ?)
>> We can then refine the validation and keep it as is (no mixed drive types) for a
>> target that has DM_TARGET_ZONED_HM, and allow mixing drive types if the target
>> has DM_TARGET_MIXED_ZONED_HM. This last case would be dm-zoned only for now.
>> Thoughts ?
> 
> Think I'll struggle to give you a great answer until I understand which
> target(s) would be setting DM_TARGET_MIXED_ZONED_HM (or whatever name).

That would be dm-zoned only for now. dm-crypt, dm-linear and dm-flakey must keep
using DM_TARGET_ZONED_HM as they do not have any code allowing to handle mixed
drive type.

> 
> I'll defer to you to sort out how best to validate only the supported
> configs are allowed.  I trust you! ;)
> 
> Think this an instance where a patch (RFC or otherwise) would be quicker
> way to discuss.

Sounds good. I will work with Shin'ichiro to cook something and send it asap.

Thanks !

> 
> Thanks,
> Mike
> 
>>
>>>
>>> But _not_ invert the logic, so keep device_not_zoned_model.. otherwise
>>> the first positive return of a match will short-circuit checking all
>>> other devices match.
>>>
>>>>  
>>>> @@ -1621,9 +1621,18 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
>>>>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>>>>  	unsigned int *zone_sectors = data;
>>>>  
>>>> +	if (blk_queue_zoned_model(q) == BLK_ZONED_NONE)
>>>> +		return 0;
>>>> +
>>>>  	return blk_queue_zone_sectors(q) != *zone_sectors;
>>>>  }
>>>
>>> Thanks,
>>> Mike
>>>
>>>
>>
>>
>> -- 
>> Damien Le Moal
>> Western Digital Research
>>
>>
> 
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

