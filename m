Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 553C3C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 23:30:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9C1D764F94
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 23:30:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C1D764F94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-Z5gepBkwOgem0AZlhdVd9A-1; Thu, 11 Mar 2021 18:30:44 -0500
X-MC-Unique: Z5gepBkwOgem0AZlhdVd9A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08C39801817;
	Thu, 11 Mar 2021 23:30:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18DA05946B;
	Thu, 11 Mar 2021 23:30:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFC8757DC0;
	Thu, 11 Mar 2021 23:30:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BNUYPL024429 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 18:30:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 059462166BA2; Thu, 11 Mar 2021 23:30:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F20E52166BA4
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 23:30:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F080F185A7A7
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 23:30:30 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-303-IdTIaTwFPR6jxLVK1Y9ZFw-1; Thu, 11 Mar 2021 18:30:26 -0500
X-MC-Unique: IdTIaTwFPR6jxLVK1Y9ZFw-1
IronPort-SDR: +rE9iEVvuR0Z2jC0Psi8r3dT5fstCX9/iKrA9Bm1hljpyg3vHXPUZby4cuY9dLb5YtNkLKnLQS
	sN2n98xEtRYKKXGuHUEWFGKpOCDilsNgZZvv79GklhLvIQSPwPeab4BlYXiWNuy8EuSVsJL5fD
	TiQ9bnqEykW4wGoaPFsebVpXPxgXmD927QomVQbEzNf9tFaj6xuZYHxOBbj9XUXN9esVZPmUuY
	0gBcyve/j+6vRmaTUq6ltgcd+kj6Gy1Bav2yvrVbWmrgpko0NWrPIqZytvMlTyTKT/w+srcrDO
	B8w=
X-IronPort-AV: E=Sophos;i="5.81,241,1610380800"; d="scan'208";a="166458185"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
	by ob1.hgst.iphmx.com with ESMTP; 12 Mar 2021 07:30:25 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4772.namprd04.prod.outlook.com (2603:10b6:208:46::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27;
	Thu, 11 Mar 2021 23:30:23 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887]) by BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::e9c5:588:89e:6887%3]) with mapi id 15.20.3912.026;
	Thu, 11 Mar 2021 23:30:23 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>, Shinichiro Kawasaki
	<shinichiro.kawasaki@wdc.com>
Thread-Topic: dm table: Fix zoned model check and zone sectors check
Thread-Index: AQHXFp+jMtj6JRfarUejHyLQrYgS9g==
Date: Thu, 11 Mar 2021 23:30:23 +0000
Message-ID: <BL0PR04MB6514474389D7E7EEAC82B2CBE7909@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210310082547.576372-1-shinichiro.kawasaki@wdc.com>
	<20210311175440.GA28509@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:c1a6:aaec:6201:ec23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 20344b34-a585-4621-cf24-08d8e4e5a4a5
x-ms-traffictypediagnostic: BL0PR04MB4772:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB477226DF1D59C6E26FF46CB1E7909@BL0PR04MB4772.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nbfocmil3kXgkVE7SHkhUAUgEfCnwpyUmEhPyvl5KZxgg/seZ1N6pNBJNCGbs9aCaThvLIXGgUyZV7O31qBIx+mVtfiXCyjeQf72Hp4LlR9gaZ+uzyAbSKsa/6uG4pIpfojOHrKZykZF0r4+W2CeT1EP1ZlN++EvM2G+HPG8jBi9qilIl7f6eI2wvpOcWE40Uiwx3u7e58GUpS+dPfQvIjImyRtiq4hMnDt/qqQ4q1cNOr+EMK1HkC2fEPBoMND1/ALLlkqYx+JkqHxi2IEoCe9Xcdc8T6FCZEO5DUctXjdXj/CIUWHB/jMCYiia5YMgX1ZZlS7MXtMnOSqMLkxhKeA8giK0vjrPplaBwoFoIIpeeZtf66Fs+jaW/shGYozEP8ZIwuHWaOlGo3WZqnDTrMwud5ek0sXhEBtuWxAZyFw6ke/4Wf0RCGTD0xwk6sOAW/z9WU2F9NB0xHga0Jh4pCVfs8S91pkapO3MgVJWQzivZMx/mQz8b6WeACMyyhkWLfvtIGYEfo+fK6cjCufh0Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(366004)(376002)(346002)(39860400002)(396003)(86362001)(53546011)(316002)(7696005)(55016002)(6506007)(8676002)(8936002)(5660300002)(66476007)(91956017)(66946007)(66446008)(64756008)(66556008)(186003)(76116006)(2906002)(54906003)(110136005)(83380400001)(71200400001)(33656002)(52536014)(9686003)(4326008)(478600001)(6636002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dnA2nNidmoevKAxs5SEu05Fk8/GXShiBZR4GmFEDJjwTd2tFYT7S1lzvZxnA?=
	=?us-ascii?Q?l5aygO15NrBkp2kO0w07GEjs6UcxbRFEASx7GA1hqyqYjcEYLL39oZ+CbEVN?=
	=?us-ascii?Q?WpTucfcMiZ4YliuIaXnuNH58nqfHaTproz2vDtxRJ0rVGEbWJ+xa05UycrCG?=
	=?us-ascii?Q?gqvZEptb9J/wo0c7gC47xfVzln7jdrmH79IMoo4nIRZZ1m/X25V3mCOLMjJL?=
	=?us-ascii?Q?IY91AUhc0A9p9BkcoOxyN3lEuj6PIlxEokqxv+KdL4t0aySxG+MiiLfOSkEM?=
	=?us-ascii?Q?skzoEA2eHNQIurO1+dynDQgib0c1XoQEW6YqmYeIXi+vzkeYSjJOKfSLdJ6/?=
	=?us-ascii?Q?PFuXk3bubKW5el2SBkUYyZzpWKy4KPBFL5L6TjahnRUBzOB4F8QiuzSW4cyh?=
	=?us-ascii?Q?mQFHTJJuU1e03Md+YaDL5u5/OCPtPYiSy2HMmoQZI1mlRfBdFm69twOWFfeL?=
	=?us-ascii?Q?SSNeYkyMmTLNuq/FaFqIPWKa8FP0BKYc9aM1yjeMKCBZCPjR5ZV9oop4z/HV?=
	=?us-ascii?Q?b1ZZ8WL28s5TQvkqJUei8ltljUFkx2wZbO7889sbe8D9exR5KFvqxQEjZlLp?=
	=?us-ascii?Q?e22c4Qn2xnPJkjroChbG43ASW08WrwtVeEP7xSTcw/Aqi0yP9Ubu2FmzCCd6?=
	=?us-ascii?Q?Z+GOMEdoOQU/UX/WeCCWthsuPD19wZu9FLCkVfA0Z3g/S9SGrOCSvmL7cBZu?=
	=?us-ascii?Q?nzsfpA3IBsu0VaAxjZ1UAqLa9QIqpPGxf4Qv4PktJokJGBfFJvGCtSOAShH8?=
	=?us-ascii?Q?GPekbzZlBeAml8x83UWpKyfEudBZFH0w3BO8SV0uvIze7A+bAvUG7VgsI4Y7?=
	=?us-ascii?Q?sYOSMyxECl8JUVL37mFjtfpuitVsUGJokDUqzFBgqE1wSoWIvFXGqGLhb0G6?=
	=?us-ascii?Q?1FjBG6+4zZh10IgXfxYtaWQMS74Kb2a/8vTEJ1ZiSW/El1piYajQXQevK/t1?=
	=?us-ascii?Q?xY/yJERWzlnxd8Lkn2rGvMRE/r3f6ARpny6ahSPqjZ/TSFJcOk+E87MVcr+B?=
	=?us-ascii?Q?qFuU8Wi/XhW3uHXlTxOiGjjnt8LaHismQI1C/W/3ZWoPtk8ZQYYKpfnNBRT/?=
	=?us-ascii?Q?pk6J63I0b08Fq1q8soutYf11SsRQ71Nv0zl7qMBrfPOx5Jqq/yRQtA1VMYVY?=
	=?us-ascii?Q?SLnYoZK5VlIuab97awCIg7VV/Xs8sTShr/a/AnQtfXx1GWTY5q4195P4VjLn?=
	=?us-ascii?Q?2asftAbC99gy+hnuBAZyJeuQObPNtc0zd6VZu780KlV9FdhVthXtuJizIvbg?=
	=?us-ascii?Q?wpB8dN26Avy4wNLfFAjz31+JiZFNY7yj9SsuFrlmR+8wijd4hoBOt0ABFnnf?=
	=?us-ascii?Q?pHF8EM+XFHs+y2+yW/aExw9RsyKCq0o0f9gDIr7hjqmNkAmpKYXPyCXGtDXU?=
	=?us-ascii?Q?oep5FD3WL5qkGzcdJEgZieGXD+aicWrzGR3zUjt9HkeRXFwDDQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20344b34-a585-4621-cf24-08d8e4e5a4a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 23:30:23.3132 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RScigOIIO8o1NOiMK64slTafAvanuDnmGO52zD4anKhHmHKg0BY/ZzbMWi55DWJo6k8M5DC/rGtmBK5mbmeMFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4772
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12BNUYPL024429
X-loop: dm-devel@redhat.com
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/03/12 2:54, Mike Snitzer wrote:
> On Wed, Mar 10 2021 at  3:25am -0500,
> Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com> wrote:
> 
>> Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
>> capability checks") triggered dm table load failure when dm-zoned device
>> is set up for zoned block devices and a regular device for cache.
>>
>> The commit inverted logic of two callback functions for iterate_devices:
>> device_is_zoned_model() and device_matches_zone_sectors(). The logic of
>> device_is_zoned_model() was inverted then all destination devices of all
>> targets in dm table are required to have the expected zoned model. This
>> is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
>> since each target has only one destination device. However, this results
>> in failure for dm-zoned with regular cache device since that target has
>> both regular block device and zoned block devices.
>>
>> As for device_matches_zone_sectors(), the commit inverted the logic to
>> require all zoned block devices in each target have the specified
>> zone_sectors. This check also fails for regular block device which does
>> not have zones.
>>
>> To avoid the check failures, fix the zone model check and the zone
>> sectors check. For zone model check, invert the device_is_zoned_model()
>> logic again to require at least one destination device in one target has
>> the specified zoned model. For zone sectors check, skip the check if the
>> destination device is not a zoned block device. Also add comments and
>> improve error messages to clarify expectations to the two checks.
>>
>> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
>> ---
>>  drivers/md/dm-table.c | 21 +++++++++++++++------
>>  1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 95391f78b8d5..04b7a3978ef8 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -1585,13 +1585,13 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
>>  	return true;
>>  }
>>  
>> -static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
>> -				  sector_t start, sector_t len, void *data)
>> +static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
>> +				 sector_t start, sector_t len, void *data)
>>  {
>>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>>  	enum blk_zoned_model *zoned_model = data;
>>  
>> -	return blk_queue_zoned_model(q) != *zoned_model;
>> +	return blk_queue_zoned_model(q) == *zoned_model;
>>  }
>>  
>>  static bool dm_table_supports_zoned_model(struct dm_table *t,
>> @@ -1608,7 +1608,7 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>>  			return false;
>>  
>>  		if (!ti->type->iterate_devices ||
>> -		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
>> +		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
>>  			return false;
>>  	}
> 
> The point here is to ensure all zoned devices match the specific model,
> right?
> 
> I understand commit 24f6b6036c9e wasn't correct, sorry about that.
> But I don't think your change is correct either.  It'll allow a mix of
> various zoned models (that might come after the first positive match for
> the specified zoned_model)... but because the first match short-circuits
> the loop those later mismatched zoned devices aren't checked.
> 
> Should device_is_zoned_model() also be trained to ignore BLK_ZONED_NONE
> (like you did below)?

Thinking more about this, I think we may have a deeper problem here. We need to
allow the combination of BLK_ZONED_NONE and BLK_ZONED_HM for dm-zoned multi
drive config using a regular SSD as cache. But blindly allowing such combination
of zoned and non-zoned drives will also end up allowing a setup combining these
drive types with dm-linear or dm-flakey or any other target that has the
DM_TARGET_ZONED_HM feature flag set. And that will definitely be bad and break
things if the target is not prepared for that.

Should we introduce a new feature flag ? Something like DM_TARGET_MIXED_ZONED_HM
? (not sure about the name of the flag. Suggestions ?)
We can then refine the validation and keep it as is (no mixed drive types) for a
target that has DM_TARGET_ZONED_HM, and allow mixing drive types if the target
has DM_TARGET_MIXED_ZONED_HM. This last case would be dm-zoned only for now.
Thoughts ?

> 
> But _not_ invert the logic, so keep device_not_zoned_model.. otherwise
> the first positive return of a match will short-circuit checking all
> other devices match.
> 
>>  
>> @@ -1621,9 +1621,18 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
>>  	struct request_queue *q = bdev_get_queue(dev->bdev);
>>  	unsigned int *zone_sectors = data;
>>  
>> +	if (blk_queue_zoned_model(q) == BLK_ZONED_NONE)
>> +		return 0;
>> +
>>  	return blk_queue_zone_sectors(q) != *zone_sectors;
>>  }
> 
> Thanks,
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

