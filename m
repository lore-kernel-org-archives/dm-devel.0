Return-Path: <SRS0=5ROl=JH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF59C433ED
	for <dm-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:31:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 412D7600D4
	for <dm-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:31:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 412D7600D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-2p6BWZFDOS-iOz-lAlZFRw-1; Fri, 09 Apr 2021 20:31:27 -0400
X-MC-Unique: 2p6BWZFDOS-iOz-lAlZFRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD2F7802575;
	Sat, 10 Apr 2021 00:31:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0ED6571282;
	Sat, 10 Apr 2021 00:31:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A83C01806D0E;
	Sat, 10 Apr 2021 00:31:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13A0VA8w014510 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 9 Apr 2021 20:31:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CCD6510AF43B; Sat, 10 Apr 2021 00:31:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C772B10AF435
	for <dm-devel@redhat.com>; Sat, 10 Apr 2021 00:31:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A67585A5A8
	for <dm-devel@redhat.com>; Sat, 10 Apr 2021 00:31:08 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-61-8lUXrJJAPSSb1RxJQODRZA-1; Fri, 09 Apr 2021 20:31:06 -0400
X-MC-Unique: 8lUXrJJAPSSb1RxJQODRZA-1
IronPort-SDR: aD2egv+uYik22Zxl9QVNUw1l4FydOmyGYd+G7RXJMbPnDfXWLTus+H/dWrahB5/SqEGsP1xAiu
	n56E+am/3fV4tstN0JHqHdTwnmGTsxy6jZkFUiMJIA3Mms6A6Ij7+IanmpcZNIdzWCEUy5b5sN
	IjqlTx+7AgkQOqZjCsVOyCysq6qVKS+P2XtWcd+DG+LRXAJMvyD+6wKJ5QHQhPEtINLyY77z0N
	WGnQNQoksPOO55DaKTLxjoVnUsA5I1utdm8no0XmVcITrbFzq1OzZTwsCSLGI4uNBTsPkE2Vw3
	Uck=
X-IronPort-AV: E=Sophos;i="5.82,210,1613404800"; d="scan'208";a="168849976"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO
	NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
	by ob1.hgst.iphmx.com with ESMTP; 10 Apr 2021 08:30:01 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by SJ0PR04MB7439.namprd04.prod.outlook.com (2603:10b6:a03:29d::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21;
	Sat, 10 Apr 2021 00:30:00 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.4020.018;
	Sat, 10 Apr 2021 00:30:00 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, SelvaKumar S
	<selvakuma.s1@samsung.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Thread-Topic: [RFC PATCH v5 0/4] add simple copy support
Thread-Index: AQHXByxPYjd3lKFugEyHev6iOAHEsg==
Date: Sat, 10 Apr 2021 00:29:59 +0000
Message-ID: <BYAPR04MB49652982D00724001AE758C986729@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <CGME20210219124555epcas5p1334e7c4d64ada5dc4a2ca0feb48c1d44@epcas5p1.samsung.com>
	<20210219124517.79359-1-selvakuma.s1@samsung.com>
	<b56a18a0-facc-edb3-c809-7436f1b1c15a@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ea929b9-8254-4645-a389-08d8fbb7c683
x-ms-traffictypediagnostic: SJ0PR04MB7439:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB74392B9C2740C3CD3BBF04CE86729@SJ0PR04MB7439.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /TaepJfvUXC9mS8d+G/S9CPlHKIe+6hjpPma6YtqB9MngQ+AVnxclkFjcyhLql09RDlwDdlVrAvyAY7Z0sI8NT/732fXRYYVuIT2hRREbI563oE4WO+IG404Jx8UbwQfSNG0VTuc4hk4HTHCEdN4zzSmNNzUmf0Yrf8JJPSqtWcLHwON8CDHkiLh/wrv4zckznfVdSMNks0oHA7BT8388F50+6Cd6xJEJgt7Carn7A9SRSrGjTDaNepLQ7tC4RbRmck5Qb/8lWb8JXYRZTV3Hdn29p29BTVTpZ566NhcsbQLkTEkrm21+AIMJf4ji0LsxJSoiIUcQOtEq6+pmK2CZQ0ECMBNfkpLTR3IN7z92MqScpd/riFucLe8NNrS93E2ouKC43Z9E9GowfknyRLSrLtBmC7Mdw6xxKq/3jSRy55QLQadGTbx0pIQmuE/9mBnOIvguVsZFrrmuKUEdXfgttO3dVC6e41asEylR05YKU85qePVDQuOh+tvUvgbTJDDoJ0lR1J6IrTDThjuBB+EbBghcUk4VMku1Y0AQ+5e7l+NTUBnJfoXOfR+dxBv1Nb6LjwQE9zQ+NF7umY0EdJSm/0YYhd0Biv2WDoHPBrHpAEt8kw4k+Q4kD86VoZADEzvhl8fTLwfxVUPrzPfcPAtWgtZDTVleq6gRPJsOdVda94GShEMNFtUFjXXmlBu9b1gJ5WyrHuxDx9LRv5yZ9FpBGiVnoh0Tb3xddk/3uWVtD+gc5FLnvZJ8cELfZr82tCn6WwTKZDKlEla7wdLKA5WPoKy6FcqEyI7Y+0XLMQpSns=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(76116006)(186003)(38100700001)(4326008)(33656002)(66556008)(66446008)(316002)(64756008)(83380400001)(478600001)(8936002)(66946007)(66476007)(7696005)(5660300002)(86362001)(110136005)(52536014)(71200400001)(54906003)(26005)(9686003)(2906002)(6506007)(8676002)(55016002)(966005)(53546011)(7416002)(43620500001)(15398625002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1uqmL6hYj/1btMsacHkl+bRRyG4yzKHDK2jPWCMSPkjiroymsLkWmCg5IL77?=
	=?us-ascii?Q?Sl3tfdienDtTjrIMkcMYquM7YHyD8L8A6uVyEVnb/+wTiFSECKiNap9bjegF?=
	=?us-ascii?Q?f0p0ySs9Vc5TqakN3dkaGo8/wSKPPZjpQA27hENtFMmy6n/jKXKRqNCdtZ7I?=
	=?us-ascii?Q?BRudoAjF/Sr10XI6Xfz3PW88xkOWZ7b6uA5/KKwI60bbA0NOS0w3g4R8SSTK?=
	=?us-ascii?Q?3HrTaynW1I/80hV1KcmzZZsqodvj6RpRrNk9rQ+hGQjo3ZhE4V4lSVFAj8t9?=
	=?us-ascii?Q?Uv0drq9UIwzyNpK8XeQ5kalDY826bZyFm8+JH/2bBIHLc4KBwJTjVuaJ+8rU?=
	=?us-ascii?Q?8TcAk7MynsmgTyfRnSFBKv89aE66k1HFgolKj/vhCSWE4LbIy4vs1R4V4kdI?=
	=?us-ascii?Q?aFHIvyH2vwL7m/GfGJMKFX1kvq1le8zjaMQmWoDnOcZukHRqqdfaXA+iBkJs?=
	=?us-ascii?Q?usU9qIPVS5nYVu9NnRUEmpa28U70qrjA3dYaUyI1Q0gMR6XNWB4XDE2T/tSM?=
	=?us-ascii?Q?+KzUlgujTlfMXncB5pZeZI3O7JINppt2U5DHXa/FVIizzhHASrTwp0V9VZep?=
	=?us-ascii?Q?Ao3amLx6XRPjsR/1iwyJpX+hIxw2kiVaE8gysWn/UdO9zKO+1Kn2fuBgMmHd?=
	=?us-ascii?Q?hi/NfM3J4h/rraw4SegmQUL9le9iPE4T/+GO74B31Gh5+tcY0UVpGcK2dE8P?=
	=?us-ascii?Q?88Y5vPCkPoGIqYQ9XSh4+mmP39nSwN0C5I3b4QoTkl+0OjZRqyskw2ZK6MRs?=
	=?us-ascii?Q?aasRhJwTKAQZZ53OXUqq+ObdnAuL0ymMQehx/QzdKMo7BPudPyDQB//5rdDM?=
	=?us-ascii?Q?CAZlHnEV0GB0vHZUt6fBk+6gxqgh+eBkPKNZUbaw/Ptrovrzsm1MialqPZXt?=
	=?us-ascii?Q?PcWPd4csFglZK+BNhGvrf8Suj12Vkk2+5zoeeS9FgTGsjLMt6iNY3gAmJfYk?=
	=?us-ascii?Q?AyxG/FE2PwCgvHLnuLqQolnhxf3dl3uBFiidofgj44kax7ZQqcsAfXTHi3B6?=
	=?us-ascii?Q?6P8V7t/8F714/cma2xpM32c77gY/kpWqDccYMy5tN80KAey+K+DABLVmPopl?=
	=?us-ascii?Q?uixRWD1bVOqMUrf9ljuF+yM9yahwrqkrH/bSHPZ3aZiQdtKtZC6KLJXfbpUs?=
	=?us-ascii?Q?6zVjecOv5dVKT1RN6axH3t0NmAgJVD/2fuYTof6uDTQ6BO/QKUGz4kFgMDK2?=
	=?us-ascii?Q?0juL8nQM3NEaHn0o2eZsxv5zK+bb6bRgYZ8PKMdfF8G2UCRyT2qVCXHWGRlw?=
	=?us-ascii?Q?2GEVISeQi8blB/yXIZC9iGU3mR4sAgykWHplRcXCp3aBMUg7So6M4nY1JTjw?=
	=?us-ascii?Q?xKMDJVzpH6hsdpeRq8Ado41vBpnxr1W5cpWqwNtzGmmJug=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea929b9-8254-4645-a389-08d8fbb7c683
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2021 00:29:59.7459 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WueXi4KAIYNj0g34osPHVnoxdnpdZsZROOGaWM4jVOXySXeIHidddWbSCXFVkcqurXn3wlgiwZzdbt/Kux4KmYRK/ps3HtUIYclPwliZqrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7439
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13A0VA8w014510
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	"kch@kernel.org" <kch@kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"joshiiitr@gmail.com" <joshiiitr@gmail.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [dm-devel] [RFC PATCH v5 0/4] add simple copy support
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

On 4/9/21 17:22, Max Gurtovoy wrote:
> On 2/19/2021 2:45 PM, SelvaKumar S wrote:
>> This patchset tries to add support for TP4065a ("Simple Copy Command"),
>> v2020.05.04 ("Ratified")
>>
>> The Specification can be found in following link.
>> https://nvmexpress.org/wp-content/uploads/NVM-Express-1.4-Ratified-TPs-1.zip
>>
>> Simple copy command is a copy offloading operation and is  used to copy
>> multiple contiguous ranges (source_ranges) of LBA's to a single destination
>> LBA within the device reducing traffic between host and device.
>>
>> This implementation doesn't add native copy offload support for stacked
>> devices rather copy offload is done through emulation. Possible use
>> cases are F2FS gc and BTRFS relocation/balance.
>>
>> *blkdev_issue_copy* takes source bdev, no of sources, array of source
>> ranges (in sectors), destination bdev and destination offset(in sectors).
>> If both source and destination block devices are same and copy_offload = 1,
>> then copy is done through native copy offloading. Copy emulation is used
>> in other cases.
>>
>> As SCSI XCOPY can take two different block devices and no of source range is
>> equal to 1, this interface can be extended in future to support SCSI XCOPY.
> Any idea why this TP wasn't designed for copy offload between 2 
> different namespaces in the same controller ?

Yes, it was the first attempt so to keep it simple.

Further work is needed to add incremental TP so that we can also do a copy
between the name-spaces of same controller (if we can't already) and to the
namespaces that belongs to the different controller.

> And a simple copy will be the case where the src_nsid == dst_nsid ?
>
> Also why there are multiple source ranges and only one dst range ? We 
> could add a bit to indicate if this range is src or dst..
>
>






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

