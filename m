Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4620AC2B9F8
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 06:36:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE222613F9
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 06:36:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE222613F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-fVw5IKgTO86FZpnRe4mUIw-1; Tue, 25 May 2021 02:36:12 -0400
X-MC-Unique: fVw5IKgTO86FZpnRe4mUIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A54668015F5;
	Tue, 25 May 2021 06:36:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D579421F;
	Tue, 25 May 2021 06:36:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C032E55340;
	Tue, 25 May 2021 06:36:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P6ZInP014810 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 02:35:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 363AF200BA92; Tue, 25 May 2021 06:35:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30E922077FAD
	for <dm-devel@redhat.com>; Tue, 25 May 2021 06:35:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCE2080D0E0
	for <dm-devel@redhat.com>; Tue, 25 May 2021 06:35:15 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-423-eRUtrjFpNxePie6R0mUl_Q-1; Tue, 25 May 2021 02:35:11 -0400
X-MC-Unique: eRUtrjFpNxePie6R0mUl_Q-1
IronPort-SDR: bKs8OJ40rEAcLCjw07xCNfjKop04F5sY1ECR9PtenFH9eGH/lpVlr4Kk6H3VrWpWOcjVjaUl+g
	EQ42zgVwppGQY9gl9nu2mu+ZMVLZBemOOCNRGkobA5DNFFIifpf5AIOpNt46Y+MxWL78NnJkXm
	G4CwBPkASJ+sb1a/Eg51cm97u0VHm3v2nlrRRpoM5DdqWA50tTCD0Bq1ekYg7YhiQ798SX/95G
	wWPU5kL/EOkg2DzOsOWCX28A7mAUu5zlcgmICg2/St2JztjhnC/f5G+nb3uRlewOLvWUb/y1a5
	cXE=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="280623360"
Received: from mail-bn8nam08lp2041.outbound.protection.outlook.com (HELO
	NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 14:35:09 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB4539.namprd04.prod.outlook.com (2603:10b6:5:2c::18) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Tue, 25 May 2021 06:35:06 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4150.027;
	Tue, 25 May 2021 06:35:06 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v4 01/11] block: improve handling of all zones reset
	operation
Thread-Index: AQHXUQ1EQNMzdteJWECqsLfWuiJWkA==
Date: Tue, 25 May 2021 06:35:06 +0000
Message-ID: <DM6PR04MB708184EFEBB8AE75C49A39CDE7259@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
	<20210525022539.119661-2-damien.lemoal@wdc.com>
	<BYAPR04MB496571E36CF14B9647FDD21186259@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:9d12:5efd:fc6d:4ecd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8661c5b0-0b2a-42cd-f3ae-08d91f473c6e
x-ms-traffictypediagnostic: DM6PR04MB4539:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB4539F7C838445778CE40BD66E7259@DM6PR04MB4539.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ymaoq9XbALW/Ef4sbfJhKTWPvVs9PTkCrVKJQAab9wB+0OfUMnx+JFwfqiwZBP5tXgBAkI1YGcxUYTyXH9REIgOftJ1MrF73vGelLcBAwqJ7yRaap2CIVXzj9KVtYOP4tgwjvPK8oEsZXS2XKplQsn4ApKHHITbswmG25CzSaoimL+UQz+If5oU54y0oge1hH0giY2ZRCNMP+7ZoiRySmvU++bLyQXOygw9n0pg6RMJUDNANtu/ZeIefBim+3NRBV/2IBNa65GWcmKy5OsYMxs61pIYV7bsICCh1ePoSTN4ldWCD4OSlhHU+RYxPZ6GnUYxAEWRZggnoF3stlrmrQzgzZyVPxo3l1Cv4vN8O+mEcJxz93MrAQJylBdFSYP2gbaM6CU0e++d/Bav/8HAdH7WBodaSW7mdkI7aYONaG47VDpuurtAqUyLfS8uKapYrogECiAXtHVP1YMbkEPdMpbWMdnnmA0SaWpcpvI95IB5AltgiYbx3n0PpUOTEjfjmEq4jYEbeydTMkaB+AyQjoqP0aT7lSGfbEKHmKhSci8krNSK1QBMlJQvKi1uzVFuZ5jXhIdTn0sBJ7EuKwqAETHSjd3BEia/n9E8XKNB7w+E=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(83380400001)(76116006)(110136005)(316002)(478600001)(91956017)(38100700002)(2906002)(122000001)(71200400001)(7696005)(6506007)(86362001)(8676002)(52536014)(9686003)(66946007)(66446008)(66556008)(33656002)(66476007)(64756008)(186003)(5660300002)(53546011)(55016002)(8936002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UCHKxHMuuTYNdv2j13Zs2HGHoiTbu/VYBp3IxL4lXx9kbG7JLSKmWjCNDmQx?=
	=?us-ascii?Q?nNmXx4EQlMcg/vMdO9pTp6BFiHwYkPy/ffTN/fECGLrahqQuzqY45ldLBkIW?=
	=?us-ascii?Q?p9Y4lb7b5pPtFDqWEABmCU1QVgIl/AZLGQBwe7iwwMnmU1juTLrvfoQ/5Bf6?=
	=?us-ascii?Q?nyRPwOKCNF56spEgJ+uAbf0Puvexg+34S8/BxTEtrd7R5OH2luHNgnXqobd/?=
	=?us-ascii?Q?xJn2YZSA1OlsFyZblcRSW0NhZ177tLRJbWBAbjFBjcC08bE+NF2ZuMEHeVak?=
	=?us-ascii?Q?XCihnRnPMvpR5fh244uYDlSqOrg3AVDIBpD+//lliJCtS4aIZrjNd9D3Acm8?=
	=?us-ascii?Q?qAMX9rlsS4WXPOAYgeSjazQEAHj6u6tY1T6bElutPREOXwKb3mf59WDMaYoI?=
	=?us-ascii?Q?zpEN4xMtwWGuG7Zrxu/Dv4DZshC0T8fiEHvBzL5adcw8Pm+tx3Samn+rdiS1?=
	=?us-ascii?Q?1wmryBSrpwjyG/QHNnb5cL7XsLU71Xi9FH1GFPjRLVYtUH1St/SdwCAZOoGJ?=
	=?us-ascii?Q?+mtrIClzujFY6/ojnS4r187+pB4k6FpyJnOI9gnKTL+sjg2XxBqcS3veu1LS?=
	=?us-ascii?Q?BhdCyvKCeGryIPMN9x5ESYTsWyeYif+pwztA4Ypmsy1Sg7BBzThUQOT834++?=
	=?us-ascii?Q?3j+Z2WD/9WzKWDpupnzGR/CqR0YH8KKdAWFJKwq8Z9eQ0WWWSJQ50Fi5SIDW?=
	=?us-ascii?Q?0BNTh2aC5856WR6wZ6DWhlIldD5FIe+Q15G27twV3iWP/pbyyXQ4dzJkG51D?=
	=?us-ascii?Q?Neww4o5PCjU5xEUUN+sAvlvGWBIsr0XRsVqo/ApuCkPM4j4IZ0IkocPEJM0P?=
	=?us-ascii?Q?HGpNV+/6kQq8MpljTAUOjElIMueYqUQCVjZ5Ucny/SbGz556FyPfCf60rMVV?=
	=?us-ascii?Q?Pe90HmBcD+uWEAZ0sBC9yvv7fyRLc65mReYO1KkXN5Si/7zs/6oo1CgZjACr?=
	=?us-ascii?Q?UrEPChOLUzyxcPLzDq+TwQ2NqDU9hSXewrDyXM3YUHH4+Nd3VHjG5ywwvDdq?=
	=?us-ascii?Q?G3SrQh7eTVc8PHT4/adiDVXtc/sUcrkNDHnH3EKMytV6BSPMnW98WwBNeR3W?=
	=?us-ascii?Q?SSdPz1awNmusHfDGgGKJz6US0H794pnulZMuVNe6aBERQMDrVafVChZ4j40A?=
	=?us-ascii?Q?DP3RUUZwreh8VnUDOQw5HEm5EPH/Hvv7IINhQvsz56XJJho/lqhNGnLB667U?=
	=?us-ascii?Q?ypk0Nat6IMRKgpjFG3sftSifhiZKDNI2RlICosH4akEj1c31N9SoLu9oxVR7?=
	=?us-ascii?Q?dYgEc/oirzru0ZrnQzZL1qBHOnGQ98pnBbDJ2RBa1Boe6Gd7DEXu9XwKxEP/?=
	=?us-ascii?Q?ax+pWSIbwikOD648HPS8bN5SuUm0OGTwKlIqnp/hqnNbboDtqVpVDnH6NQnP?=
	=?us-ascii?Q?JZVolR5J65nI3lDFm3TDs+5fOquO+u2iX3sg2EXwrnxZbPEawA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8661c5b0-0b2a-42cd-f3ae-08d91f473c6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 06:35:06.6171 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FaC/WGNkXrW96gJZd8nKpcP8Ks3Lo26c3DNMlch4oC7nLic69Djh02F5FS0P7uzczXnjc31pUYua6TB7JOVwfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4539
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14P6ZInP014810
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v4 01/11] block: improve handling of all
 zones reset operation
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

On 2021/05/25 15:15, Chaitanya Kulkarni wrote:
> On 5/24/21 7:25 PM, Damien Le Moal wrote:
>> SCSI, ZNS and null_blk zoned devices support resetting all zones using
>> a single command (REQ_OP_ZONE_RESET_ALL), as indicated using the device
>> request queue flag QUEUE_FLAG_ZONE_RESETALL. This flag is not set for
>> device mapper targets creating zoned devices. In this case, a user
>> request for resetting all zones of a device is processed in
>> blkdev_zone_mgmt() by issuing a REQ_OP_ZONE_RESET operation for each
>> zone of the device. This leads to different behaviors of the
>> BLKRESETZONE ioctl() depending on the target device support for the
>> reset all operation. E.g.
>>
>> blkzone reset /dev/sdX
>>
>> will reset all zones of a SCSI device using a single command that will
>> ignore conventional, read-only or offline zones.
>>
>> But a dm-linear device including conventional, read-only or offline
>> zones cannot be reset in the same manner as some of the single zone
>> reset operations issued by blkdev_zone_mgmt() will fail. E.g.:
>>
>> blkzone reset /dev/dm-Y
>> blkzone: /dev/dm-0: BLKRESETZONE ioctl failed: Remote I/O error
>>
>> To simplify applications and tools development, unify the behavior of
>> the all-zone reset operation by modifying blkdev_zone_mgmt() to not
>> issue a zone reset operation for conventional, read-only and offline
>> zones, thus mimicking what an actual reset-all device command does on a
>> device supporting REQ_OP_ZONE_RESET_ALL. This emulation is done using
>> the new function blkdev_zone_reset_all_emulated(). The zones needing a
>> reset are identified using a bitmap that is initialized using a zone
>> report. Since empty zones do not need a reset, also ignore these zones.
>> The function blkdev_zone_reset_all() is introduced for block devices
>> natively supporting reset all operations. blkdev_zone_mgmt() is modified
>> to call either function to execute an all zone reset request.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> [hch: split into multiple functions]
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Apart from nit mentioned earlier, looks good.
> 
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

Thanks. Will send v5 with a correction of the extra space.

> 
> 
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

