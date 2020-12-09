Return-Path: <SRS0=UIu2=FN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4893C4361B
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 05:17:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0B9E223A02
	for <dm-devel@archiver.kernel.org>; Wed,  9 Dec 2020 05:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B9E223A02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-fzFc8CNdMW-fYlfTLSLdmA-1; Wed, 09 Dec 2020 00:17:50 -0500
X-MC-Unique: fzFc8CNdMW-fYlfTLSLdmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F16601005D4C;
	Wed,  9 Dec 2020 05:17:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 357A919C78;
	Wed,  9 Dec 2020 05:17:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E78EA180954D;
	Wed,  9 Dec 2020 05:17:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B95HeXG031891 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Dec 2020 00:17:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3BD5E2026D48; Wed,  9 Dec 2020 05:17:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 35C672026D5D
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 05:17:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCCCB802A5D
	for <dm-devel@redhat.com>; Wed,  9 Dec 2020 05:17:37 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-542-VDpW7ZhkPDuBeNluWsVfbA-1; Wed, 09 Dec 2020 00:17:33 -0500
X-MC-Unique: VDpW7ZhkPDuBeNluWsVfbA-1
IronPort-SDR: lm7l5Okh1QRrWb3hvPP7BWHY3EGIJ4+c4Itw5t6xaFT/KpPeRglctQXSHV6nS0KFqv6++QLuCZ
	MQCYv8jJTUJ/rPdx/iNBGY+/jJ8VPn7FhZwKOXcZoYJBGlpnPPSYjH8OV0Wtb8wErwHfV9N0JA
	Bew5B4j2tiuT1zWp0pYeB5kwBUUQ012nXpqqbHvTrsMMYYQkkRC/Nn25oQx4lm+U4739W3RbL2
	ZE0VnLSvjXuJRLuU3XiKnXRQLLG35w8MSP2Le+UlEhPin2chDyqrll+dCj0b7clFljXrQEJwRS
	9Bw=
X-IronPort-AV: E=Sophos;i="5.78,404,1599494400"; d="scan'208";a="159205031"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
	by ob1.hgst.iphmx.com with ESMTP; 09 Dec 2020 13:17:30 +0800
Received: from CH2PR04MB6522.namprd04.prod.outlook.com (2603:10b6:610:34::19)
	by CH2PR04MB6791.namprd04.prod.outlook.com (2603:10b6:610:9b::21)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21;
	Wed, 9 Dec 2020 05:17:29 +0000
Received: from CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a]) by
	CH2PR04MB6522.namprd04.prod.outlook.com
	([fe80::897c:a04b:4eb0:640a%7]) with mapi id 15.20.3632.023;
	Wed, 9 Dec 2020 05:17:28 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, SelvaKumar S
	<selvakuma.s1@samsung.com>
Thread-Topic: [dm-devel] [RFC PATCH v2 1/2] block: add simple copy support
Thread-Index: AQHWyiz5N0MxrRzynkmTc7uhJBTBYQ==
Date: Wed, 9 Dec 2020 05:17:28 +0000
Message-ID: <CH2PR04MB6522D7423BC3165B784AF61FE7CC0@CH2PR04MB6522.namprd04.prod.outlook.com>
References: <20201204094659.12732-1-selvakuma.s1@samsung.com>
	<CGME20201204094731epcas5p307fe5a0b9360c5057cd48e42c9300053@epcas5p3.samsung.com>
	<20201204094659.12732-2-selvakuma.s1@samsung.com>
	<yq1blf3smcl.fsf@ca-mkp.ca.oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:1cf3:4043:c21d:e871]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: effca5b4-68b8-42b8-70c7-08d89c01b941
x-ms-traffictypediagnostic: CH2PR04MB6791:
x-microsoft-antispam-prvs: <CH2PR04MB67910378347E469B017CA39DE7CC0@CH2PR04MB6791.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: fWd06oyuE2GOy2NzyUwzNlg7yuT4ggpElhwRPN6jMC5h778IEGFtDurQPb+TbjbmPGxduKkzKuC4TnuGZ5PiLML9ddA28WSZ9aTyXdNDvRSemqvNYqBzJs9OBcnP/jMPS1lALNFrrxN8Bj311I40dKuaD0TlLUlwKrkxbjvWbKRLdmowR/kE93TWnod6eXFaMCzfdZyI4K6VqdlVyKHqaWA2aO1qheCMeQ++uq+7lBjmSN/u3lMC/ywhjH+6o+vuYQBas+6EtQ3B3Xq7/ydqFOXSfgWD5r9z7JfwG3s4w5SG1dADhOVc+R5f34NIcZqrOITFHFmwweMQ4HKfiMhdbA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB6522.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(136003)(346002)(376002)(76116006)(66476007)(66946007)(83380400001)(2906002)(54906003)(6506007)(66556008)(66446008)(186003)(9686003)(64756008)(33656002)(4326008)(110136005)(5660300002)(91956017)(52536014)(7416002)(8676002)(53546011)(8936002)(71200400001)(86362001)(508600001)(7696005)(55016002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gbIC8/jzf5kF72EfpuhGpJadTLpIfZiy8/70yW7aMs8wQ3lDZnKl3j92UZvQ?=
	=?us-ascii?Q?jtRUSnutW+ClMC9e94lKHgwHA7+/+j896TPh6u9MCJ6MLi41Sbc8bn3KD4Ym?=
	=?us-ascii?Q?omy6FPqzxVtFs0nkzjfEoa08dqzQNzYmto0AB6az+e5RJO5lJEdjoPeWFUU+?=
	=?us-ascii?Q?xi1YCnIM8/YSUc6pt9z5ZJXbi4/aOPKCstBtJJgJDsskkISxBq16QlZ1lhvh?=
	=?us-ascii?Q?cBqJEGxR1uUsW7PxJM5kSiS6xrki45GPvNDcbZ+WFiqxFVuHof3j2XFXDGUo?=
	=?us-ascii?Q?H1HwM7B+XVPamdQy1kH8lhLgbecXcIvn3YwDQ5NWGruxBz49Qcr4uAQLpEes?=
	=?us-ascii?Q?hgXJWWPdzHurDo/0xCP3J1YyWhQuXvKkgRKUBTwI6iFTptqgJUNQIR1KNVjm?=
	=?us-ascii?Q?up5CwN5akEwHnONDdUQCNqhTvY2gV1CM049MT4e0dHPOdYn1qNmBgVsgKiP7?=
	=?us-ascii?Q?rXkOe9AzP02z7EX2Xcq3trrXFegyXa3WF6MBeQ6Mt/RKdqWWcNInfDbL3kUJ?=
	=?us-ascii?Q?BKMrn25zg5obSbZ70lrQWWI7Tx7NyP9gG/LXx4KRkYMf6//kwfAk8NssDo3v?=
	=?us-ascii?Q?ZwZUEG+pROGnO7/YsNbIKAdyQIju75LeMxHT4KOKypdvaorq8hyAfTcUyds9?=
	=?us-ascii?Q?MJ1a/SAT14w2AM5hEEKV6MCep5qtX5lL/pyHMiBJSrfYJ0TJx5z9ZnQiuQhv?=
	=?us-ascii?Q?RXL2nHO5I/PnwmUUaHRBXIWtSVdsk55eTmNAk3ShYRsMQC8d7RINknYrytoo?=
	=?us-ascii?Q?TXDSRm8orR9grlNWFBZCHbzblt6NRG0R06QWdriLceL3yP33fXdo2X+37hQT?=
	=?us-ascii?Q?t0mgFVV4ueDkPH1Cj0axXNcMWC4adXV/atmzN9m6u6KwHj6YqLfCrNZ22PoP?=
	=?us-ascii?Q?U+dUM4O29swDXcmC9O/5mWs4k5+xQv4T026sgfGC4OT5SkTbPnZ8HE+XLx0Z?=
	=?us-ascii?Q?WBW1PbGKVY39a77wzQjbQ8G1ZooXGZryqwX+RMYO76s/77tKOM5Fhjr+cgDy?=
	=?us-ascii?Q?IpVd//wpzU1+HcvVPabQdy2yJ2MVBYwQpaNDtkgn5nZ1up6SF5RvSvsygAVH?=
	=?us-ascii?Q?7wPzG+UY?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6522.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: effca5b4-68b8-42b8-70c7-08d89c01b941
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 05:17:28.8933 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KA2WanAbrGVs2+t94kFiqM13Y5mDpdJekYRz3XZMv5eEm45UeYQTyKApNLKHOiBOWhzXz2rqyGJX4vJ+evwNcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6791
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B95HeXG031891
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] block: add simple copy support
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2020/12/09 13:20, Martin K. Petersen wrote:
> 
> SelvaKumar,
> 
>> Add new BLKCOPY ioctl that offloads copying of multiple sources
>> to a destination to the device.
> 
> Your patches are limited in scope to what is currently possible with
> NVMe. I.e. multiple source ranges to a single destination within the
> same device. That's fine, I think the garbage collection use case is
> valid and worth pursuing.
> 
> I just wanted to go over what the pain points were for the various
> attempts in SCSI over the years.
> 
> The main headache was due the stacking situation with DM and MD.
> Restricting offload to raw SCSI disks would have been simple but not
> really a good fit for most real world developments that often use DM or
> MD to provision the storage.
> 
> Things are simple for DM/MD with reads and writes because you have one
> bio as parent that may get split into many clones that complete
> individually prior to the parent being marked as completed.
> 
> In the copy offload scenario things quickly become complex once both
> source and destination ranges have to be split into multiple commands
> for potentially multiple devices. And these clones then need to be
> correctly paired at the bottom of the stack. There's also no guarantee
> that a 1MB source range maps to a single 1MB destination range. So you
> could end up with an M:N relationship to resolve.
> 
> After a few failed attempts we focused on single source range/single
> destination range. Just to simplify the slicing and dicing. That worked
> reasonably well. However, then came along the token-based commands in
> SCSI and those threw a wrench in the gears. Now the block layer plumbing
> had to support two completely different semantic approaches.
> 
> Inspired by a combination of Mikulas' efforts with pointer matching and
> the token-based approach in SCSI I switched the block layer
> implementation from a single operation (REQ_COPY) to something similar
> to the SCSI token approach with a REQ_COPY_IN and a REQ_COPY_OUT.
> 
> The premise being that you would send a command to the source device and
> "get" the data. In the EXTENDED COPY scenario, the data wasn't really
> anything but a confirmation from the SCSI disk driver that the I/O had
> reached the bottom of the stack without being split by DM/MD. And once
> completion of the REQ_COPY_IN reached blk-lib, a REQ_COPY_OUT would be
> issued and, if that arrived unchanged in the disk driver, get turned
> into an EXTENDED COPY sent to the destination.
> 
> In the token-based scenario the same thing happened except POPULATE
> TOKEN was sent all the way out to the device to receive a cookie
> representing the source block ranges. Upon completion, that cookie was
> used by blk-lib to issue a REQ_COPY_OUT command which was then sent to
> the destination device. Again only if the REQ_COPY_OUT I/O hadn't been
> split traversing the stack.
> 
> The idea was to subsequently leverage the separation of REQ_COPY_IN and
> REQ_COPY_OUT to permit a DM/MD iterative approach to both stages of the
> operation. That seemed to me like the only reasonable way to approach
> the M:N splitting problem (if at all)...

Another simple approach, at least initially for the first drop, would be to
disable any sort of native hardware-based copy for stacked devices. These
devices would simply not advertise copy support in their request queue flags,
forcing the block layer generic copy API to do read-writes, very similar to
dm-kcopyd. Use cases where a drive with native copy support is used directly
would still be able to benefit from the hardware native function, dependent
eventually on a sysfs switch (which by default would be off maybe).

Integrating nvme simple copy in such initial support would I think be quite
simple and scsi xcopy can follow. From there, adding stack device support can be
worked on with little, if any, impact on the existing users of the block copy
API (mostly FSes such as f2fs and btrfs).


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

