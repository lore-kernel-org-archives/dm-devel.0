Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DBFC433E9
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:14:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90ADD2079A
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 19:14:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90ADD2079A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-qx1m3DD4PzG93BRutIuPnw-1; Tue, 26 Jan 2021 14:14:44 -0500
X-MC-Unique: qx1m3DD4PzG93BRutIuPnw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7326801AC0;
	Tue, 26 Jan 2021 19:14:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F7F06F920;
	Tue, 26 Jan 2021 19:14:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8C9DE4BB7B;
	Tue, 26 Jan 2021 19:14:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QJBTht014769 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 14:11:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 426022166B2D; Tue, 26 Jan 2021 19:11:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C0792166B2C
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:11:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53D67803CB1
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 19:11:26 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-202-4aONLZ6iO4u3QLurN_D9sg-1; Tue, 26 Jan 2021 14:11:21 -0500
X-MC-Unique: 4aONLZ6iO4u3QLurN_D9sg-1
IronPort-SDR: 9HrUbYLhXi0toG9lWlwQ111gEyZxDJnP776ZlBI/cre4cQGC66/tHZrdY7ZvWcqdOjH+D5ze95
	TutGps+CGm7uVKGD0TBGMIxCHZaRwQ2282KRgGnO8QjYDXcobHE2JLuN3rLmPY26qVPY71dw2T
	xqwzF7u4UA970Aq9SJcl+hjCqMuKKB/HnPRXjP5saZOGBNz3yhO/SfEQcgeExO4Kb7r+E+ykAQ
	XGdNVbr1RVUUvi6jx8UTeQYFRxjs7dpADtExt4fiyOZFM46D3Ck3Dq5JvR6FXIld2yEROAKZYH
	dzQ=
X-IronPort-AV: E=Sophos;i="5.79,377,1602518400"; d="scan'208";a="159553899"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
	by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 03:11:20 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by SJ0PR04MB7262.namprd04.prod.outlook.com (2603:10b6:a03:292::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13;
	Tue, 26 Jan 2021 19:11:18 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3784.016;
	Tue, 26 Jan 2021 19:11:18 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu
	<song@kernel.org>
Thread-Topic: [PATCH 02/17] btrfs: use bio_kmalloc in __alloc_device
Thread-Index: AQHW8/R60f6RE8OXIUCkbvhVzCX0Mg==
Date: Tue, 26 Jan 2021 19:11:18 +0000
Message-ID: <BYAPR04MB4965808085867317CEDE615186BC9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2600:8802:270c:4b00:b091:5edc:1473:bf45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fa00d4b4-9e05-4e1e-33e9-08d8c22e28dc
x-ms-traffictypediagnostic: SJ0PR04MB7262:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB7262B19D21BE2A31F5E3BD6386BC9@SJ0PR04MB7262.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:227
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2KZA1/rEr/W1lpsd1PINRSs1f7HpMDml5NjuyzUcogKy1mCT3fgeDTpF1FIazWAF8MR+Yd77vp/F11XUtpv4hlThBYYPia3DmQ3A0TjfFC3J2cJF+KKjRN2E9Tm8nWK52cTa6a7EPO7VSVnqQErVZjbOGFbPuWeUnlVkO0SJ8CYaG1DNLb21CabGvBVe3IsaV5GSQZBROQTlzVK8iza7zdXyXqkCCeOOhHuJzC1eVj2COw1C25soX+k/CX4rzrvgMO0TE64hT07HISuBgQPH/h7MD8gwNSXWJ7OlYni5WZxKiT7usYVgJNc3IxG5cjHtnTy89noCKjl1EqsF6pmTZ5Ai2ujRbw1TrlyHA+3XFnf1FpT/Qr+35LLAPDF1bM0Slawui5uIfyO9Zso13TkCpa2row9Nceqzhaqd9NlOxz9evZLDBqSN+GmxWoIUcnmqJSKRI+ifYMag5l+7vv51aEg8h7xD36SCxPYGVJJx5LKFwkUvdDykR3BcdLZ0yU2uTuTITD8PlslERMvihzVByw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(558084003)(52536014)(186003)(33656002)(7696005)(8936002)(53546011)(6506007)(8676002)(110136005)(9686003)(316002)(64756008)(66556008)(5660300002)(55016002)(54906003)(66946007)(66476007)(66446008)(4326008)(76116006)(71200400001)(2906002)(7416002)(86362001)(478600001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?d4ptxX6mZEPBGIZsteWKaLZjzSo1m+Lq7aENEzkgzE+r+P9kNQHhSVi1ehRM?=
	=?us-ascii?Q?RMLcPq2hxicyKbHz+eg+N+ogzO9lhKeNRPhcPnLHWgdf7QfWGmIt2THZ8Fw3?=
	=?us-ascii?Q?6S78Vl8duyVcvcecfD5nQy4TwkCdlwFeoBVONhhsfO7sK1cG880KqU9UTi/G?=
	=?us-ascii?Q?oiatjNa4LLxdzYXulB5dVOrifgDo7omNXmOdISIK/wwGMWMzTUqBHftGHQqb?=
	=?us-ascii?Q?zk3qx5Mh8mXAqrXa3W6ZFVuGW9TBRzJvPG1iOXRKAnArShWTbqDFhSXG1hoy?=
	=?us-ascii?Q?WIZHCGn8KSyKiEZXkNVlSFKxV17kfwTXzKk7NNtP4gTf6U6n1zQS1dXSWkhn?=
	=?us-ascii?Q?Yl0iClvJsO+6dqGmA6WYOKm/u9Zp5OedUru6UgVMKWYARWer7jvh4kpjLfVT?=
	=?us-ascii?Q?jNNLn06mRoEVmZcG6rjqqf5+tpX7XpNEzc2yQ1+4R2gGH3p43HylRaDbOhl2?=
	=?us-ascii?Q?Lb19ODYgIlpXUbk0tgTZ8jN0J50YN1EVSazlk6hjdC673/LMlx/MSYgI21zQ?=
	=?us-ascii?Q?W/dvD6CTswOGwZ8vdTTq+/6F+plGhCuqfJobVaqyCjTVzpeWDWWvgb61/xTF?=
	=?us-ascii?Q?O7ZU72VgeL0o+xyrwiSDlGEayXnCsivG3sH21/Gy589h8UI08L646cL6A/T4?=
	=?us-ascii?Q?dHSPBbHgBX6fowOnMoN0YrgG87OzCbN4XxNm/ABh1QekfQ7l+9Zgjhe2mu5B?=
	=?us-ascii?Q?/e2goxVgjfFAILuB79AinYBOwGSf9KVTlLwwPlJTh+IdW6+8o7QzJREpaIgH?=
	=?us-ascii?Q?2IxE7UeVmoDOhw4GCxJR2Room/m20b+K15If9Brbnv5ETahJvVeT+4Fvga7k?=
	=?us-ascii?Q?kFle1+xQ9qSBL3qCsR844RUQv+fmwkDLQxBcWJjW/uqnci5ls5Y9sA/Pq3u6?=
	=?us-ascii?Q?Xe1bz6CLthQv1PiaZGp4jwHKU+riFE8/z6aGlKffeOiruP0v2pJapm00K23Z?=
	=?us-ascii?Q?DMBCjL327szzR5Nku5yRBJZ1p8HSqozCpp32w8zzQwbpSRNJMKboeugOafYn?=
	=?us-ascii?Q?iyDKdxmH4Eb1cuNL6Cf0b94NpxR2YdspdcERHuyLjyZzgoxcE/ENl5YsNLbp?=
	=?us-ascii?Q?7G9h33NyV4Lir4m0h2OvTVl+59AmQe/tvhNz5aOqgQurle+SKteGNpSyVNLz?=
	=?us-ascii?Q?hpWu2csTD3cO/KMFJSiB4RSVnIQ67Hb/Rg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa00d4b4-9e05-4e1e-33e9-08d8c22e28dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 19:11:18.1689 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NW/d4FbXu1icGoh8C9XQmW4dRM0JEd+cBUzwUw/wAHLhcJ6XSs3gYponomIRJGMZ8CrpHOU6ygsZgtqzLCnAa5EXK3aXQckWIRUfscUiJ7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7262
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QJBTht014769
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	Ryusuke, Chao Yu <chao@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Konishi <konishi.ryusuke@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>, Philipp,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Reisner <philipp.reisner@linbit.com>,
	"linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 02/17] btrfs: use bio_kmalloc in
	__alloc_device
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

On 1/26/21 7:04 AM, Christoph Hellwig wrote:
> Use bio_kmalloc instead of open coding it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

