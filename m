Return-Path: <SRS0=DHxF=KG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34BBC433ED
	for <dm-devel@archiver.kernel.org>; Tue, 11 May 2021 00:16:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C6CC6161F
	for <dm-devel@archiver.kernel.org>; Tue, 11 May 2021 00:16:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C6CC6161F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-egY3UJBRM1CA0QI8qKcH4A-1; Mon, 10 May 2021 20:16:01 -0400
X-MC-Unique: egY3UJBRM1CA0QI8qKcH4A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9924D107ACCA;
	Tue, 11 May 2021 00:15:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69F865C1A3;
	Tue, 11 May 2021 00:15:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5E7B244A60;
	Tue, 11 May 2021 00:15:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14B0Fm8r029362 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 May 2021 20:15:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8099E2138BB8; Tue, 11 May 2021 00:15:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AFD52138BB6
	for <dm-devel@redhat.com>; Tue, 11 May 2021 00:15:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC44380D0AE
	for <dm-devel@redhat.com>; Tue, 11 May 2021 00:15:45 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-166-ln4noSryOH-9jTfThgO6JQ-1; Mon, 10 May 2021 20:15:43 -0400
X-MC-Unique: ln4noSryOH-9jTfThgO6JQ-1
IronPort-SDR: hKACrQiB/ODSzwU0IkVnaOF5ZGwDwhIIG0YGg3kF8iA3k3SzfF3aa1n6g7Ab7j9YFXrZPe9387
	Dr+a/HpAMvsr/zT+b06NhfChdWzUdn26HWCKK1jNq4uLk4xxCw/e25pSpjl27Ofe6US5z2y+Ip
	9vo4Xpojv48E66YI+/Fih1TRqGbbo7y65Fw9uN4bmseV6+hzN5DSHJ+Fl71bOlQysosVoM1M+v
	7E+rKReNrcDQTEpfiaLpTpoqifl0Kg7Q7w2DBOkR45V/aktLeb5CS4BGQuTVerP4YGKn0hAVs6
	BNE=
X-IronPort-AV: E=Sophos;i="5.82,288,1613404800"; d="scan'208";a="167685163"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO
	NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
	by ob1.hgst.iphmx.com with ESMTP; 11 May 2021 08:15:39 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB6088.namprd04.prod.outlook.com (2603:10b6:a03:eb::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26;
	Tue, 11 May 2021 00:15:37 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4108.031;
	Tue, 11 May 2021 00:15:37 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaA==
Date: Tue, 11 May 2021 00:15:37 +0000
Message-ID: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d3141c5-56b0-4b6e-0e1e-08d91411e710
x-ms-traffictypediagnostic: BYAPR04MB6088:
x-microsoft-antispam-prvs: <BYAPR04MB6088839B9CE235B2E05EF16886539@BYAPR04MB6088.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: dVR08EHLBMBVndjSSzCM9Fbf0NQJBDNh11xCLBpRGyYoWb8qefYJQcGgdwrh04/AULruZJgyvczISwoPuHN++xKyqkuYpDIl24us0i7HtWVh9OsZwIjBoHi4NiujkVuC7cAQuOljCYGeA40I9Af3YGVIK6OWmy8a/1vLwkQb3twazbSjXo5YAxfrwIeRPxZa94BtPX5GyPX5X8lNHuM4MDcZFxlTqqPzmb4U9LxAUn7xlXIR5RrwK60iaoqW/Dopn29XsWz2XHRH/hiQGU9T2dvw8ckT2MnbptKo12BvSSNjZutoAezFKRq7o/rMe4UK0CPu1ACIThHKVEuslvGFoEx4WaaZkP7JN3b5y8VIR/64Mtk6F0i1pKDZoiVLNJXN0+YRPL46yRSMTZz/jPqHrAfIUO0BErZBGiJhz8ineMWx5p7pU77pw99uiTq5nNhB8BmyYYv3/tHDH/lhDp0C7hxTKeG9+WJQ3Atfs+FUXUAzV/rgJsCGT5cdIrD2AqL9pz1wpTkgzxQQrc0MHBBIaI8jVuBYwgiVFylxWgAzsCHPfqr7Va06pf8BJiShyjD3aUpTzl9FV3pOIMBXPEcvojZG+kavU5gMS3SmhpVh5RwC8jpj1yZsIvbEC8JWpCJUdvrQFRnCCE22we/g8kMaPb950lT7D7ZoK4kkiWfmxF3sPML7RPHmdBdVjXeovkhja5oF8o63+iC1PBlo8F2qOYQ2rbro8uvp7yGNkG4rMl94EYSLY6VURTkgOeoocJpYdjuIZcLkg6Xr1ms5BBp+XA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(136003)(376002)(39850400004)(396003)(346002)(2906002)(64756008)(186003)(66446008)(83380400001)(66556008)(66946007)(52536014)(66476007)(316002)(966005)(110136005)(6506007)(54906003)(8936002)(7416002)(4326008)(71200400001)(86362001)(5660300002)(38100700002)(122000001)(55016002)(7696005)(9686003)(33656002)(76116006)(478600001)(26005)(8676002)(15398625002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IFSN04bQCjnysLzidHAS4sFGBWQqehrif1DABUkifaOaiwocMi1jsF7KyeFX?=
	=?us-ascii?Q?QjFw8c/EX4hG2oKUnnNdMpG0ogDVL6lrULLlWM84s/qI55yohcDB0VyKGQzV?=
	=?us-ascii?Q?giqXk0Lc8P8n85UNTm0Ypy6VsmsoJDhGCZ/02/7GmOOtGKV4gInSvRMA2wa/?=
	=?us-ascii?Q?fxnpFP8+w6rBBZQWd2SvzlMktcyOPdNYDvw6Z1QZvQlQ0SZFnSGrjTQxNDoN?=
	=?us-ascii?Q?EFsQzavdQILKamCxL65OphBWbHl0yjsiR/4WefZuP1evg/QloACPiHLlXOl6?=
	=?us-ascii?Q?kj05tWVbqYP49wbdqZQ+Jm0qEAq8Hs2NxqjIME2pA5/FOSxoSDKk3iW9jCl2?=
	=?us-ascii?Q?dls1LljJKppfm2tbz2C6WMaZ2lqzkNUiVSJbRitUmWDzk3D41PdWar5iPqm3?=
	=?us-ascii?Q?6ww5untp8yOf1zTAptV1uQ5K2LSHzx0gE1j4NRwvGcRgoUZMDRpuO/4ylwfa?=
	=?us-ascii?Q?xtjKdxRnUsbRdeHsjcYbzNQPIZQUpBrUAcvBkHrpHgIouHQRmahnJJ1duOvB?=
	=?us-ascii?Q?Ta+T0QPGo76pcfAu9nzU68ES6H80U5hkPgUsrFiz3z4hhCtcHHw2cSahZnvQ?=
	=?us-ascii?Q?ZrUhx9c2b2yuCYptDwKoH1sJrHoPQvUGw1Nm4f38RCgmNiAqtejJG4v7mS2Z?=
	=?us-ascii?Q?dZZGQ2VeBvwIfvr30C6K9gXystOYor23XeiaAkq7GCOhdlYtYxoEUk15yzx2?=
	=?us-ascii?Q?W+lkFvmDyc0k4kciqUvcueBHV1Ll+p45QS0CM6iiwcxJGiSXm2o2ng9oBBnJ?=
	=?us-ascii?Q?yQ4Z9P+2vK/VMW2zwf9XoXAtfsfssKGUuiwPFtyxnC9PLWuGEUiXs11MrKel?=
	=?us-ascii?Q?ZURk4/REPYhKBbZmYMNeMcCjwIafeth852711nEjSTdhBNCP+teSR36/zhBB?=
	=?us-ascii?Q?t2aNAPuRU95ZlplmGXEED4uSjnTJbhRfekbJRQFS1HP+qx55WLJKK5TpoDqO?=
	=?us-ascii?Q?/Yzg46jNWCwtxb//+SgwMFsys1fULSB7OBJGYWXnWpBRCe5d9XZx251jrFn5?=
	=?us-ascii?Q?/phBmdkNXHxRW1Lea4NA2bGi8+HWAFZ2FCh0VgStXKBQHc746WZRsRtoBld6?=
	=?us-ascii?Q?CIDJNSVCPqZRgsbzp555yWlaweVDKkeBrOLM05TyvR33rl2MSpk4yqghc4GS?=
	=?us-ascii?Q?FS4G5/RzZWk5KeW5hUd8Ph6+I61cLwVfBLxmfij6+XKl8FreJeFruhigc4kc?=
	=?us-ascii?Q?KGHtRtUydW9exMIsiVQBqNaQ9zmY2Yv+EiLYZOPdXmxwVlxrIlqlXkAkSpjC?=
	=?us-ascii?Q?ZaoK5Wv8MS3+dCavCUt1PayenEF4Z4ba0gHDhNMWDS3eIPvr3LWv5kQIdy7D?=
	=?us-ascii?Q?J5WKGriqQLP7S+XqzdKCkPUt?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3141c5-56b0-4b6e-0e1e-08d91411e710
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 00:15:37.1555 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mSYtTpSKo4aEFK1FYZvnXxoXH4xilMS7ALiBTuBvFXlvcXxVrm7s0R279gvGbFC8oCZOefXk5don8hAha2WSBNome6k4qfJymuiXgFxu9Bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB6088
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14B0Fm8r029362
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>
Subject: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
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

Hi,

* Background :-
-----------------------------------------------------------------------

Copy offload is a feature that allows file-systems or storage devices
to be instructed to copy files/logical blocks without requiring
involvement of the local CPU.

With reference to the RISC-V summit keynote [1] single threaded
performance is limiting due to Denard scaling and multi-threaded
performance is slowing down due Moore's law limitations. With the rise
of SNIA Computation Technical Storage Working Group (TWG) [2],
offloading computations to the device or over the fabrics is becoming
popular as there are several solutions available [2]. One of the common
operation which is popular in the kernel and is not merged yet is Copy
offload over the fabrics or on to the device.

* Problem :-
-----------------------------------------------------------------------

The original work which is done by Martin is present here [3]. The
latest work which is posted by Mikulas [4] is not merged yet. These two
approaches are totally different from each other. Several storage
vendors discourage mixing copy offload requests with regular READ/WRITE
I/O. Also, the fact that the operation fails if a copy request ever
needs to be split as it traverses the stack it has the unfortunate
side-effect of preventing copy offload from working in pretty much
every common deployment configuration out there.

* Current state of the work :-
-----------------------------------------------------------------------

With [3] being hard to handle arbitrary DM/MD stacking without
splitting the command in two, one for copying IN and one for copying
OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
candidate. Also, with [4] there is an unresolved problem with the
two-command approach about how to handle changes to the DM layout
between an IN and OUT operations.

* Why Linux Kernel Storage System needs Copy Offload support now ?
-----------------------------------------------------------------------

With the rise of the SNIA Computational Storage TWG and solutions [2],
existing SCSI XCopy support in the protocol, recent advancement in the
Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
DMA support in the Linux Kernel mainly for NVMe devices [7] and
eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
from Copy offload operation.

With this background we have significant number of use-cases which are
strong candidates waiting for outstanding Linux Kernel Block Layer Copy
Offload support, so that Linux Kernel Storage subsystem can to address
previously mentioned problems [1] and allow efficient offloading of the
data related operations. (Such as move/copy etc.)

For reference following is the list of the use-cases/candidates waiting
for Copy Offload support :-

1. SCSI-attached storage arrays.
2. Stacking drivers supporting XCopy DM/MD.
3. Computational Storage solutions.
7. File systems :- Local, NFS and Zonefs.
4. Block devices :- Distributed, local, and Zoned devices.
5. Peer to Peer DMA support solutions.
6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.

* What we will discuss in the proposed session ?
-----------------------------------------------------------------------

I'd like to propose a session to go over this topic to understand :-

1. What are the blockers for Copy Offload implementation ?
2. Discussion about having a file system interface.
3. Discussion about having right system call for user-space.
4. What is the right way to move this work forward ?
5. How can we help to contribute and move this work forward ?

* Required Participants :-
-----------------------------------------------------------------------

I'd like to invite file system, block layer, and device drivers
developers to:-

1. Share their opinion on the topic.
2. Share their experience and any other issues with [4].
3. Uncover additional details that are missing from this proposal.

Required attendees :-

Martin K. Petersen
Jens Axboe
Christoph Hellwig
Bart Van Assche
Zach Brown
Roland Dreier
Ric Wheeler
Trond Myklebust
Mike Snitzer
Keith Busch
Sagi Grimberg
Hannes Reinecke
Frederick Knight
Mikulas Patocka
Keith Busch

Regards,
Chaitanya

[1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterson-.pdf
[2] https://www.snia.org/computational
https://www.napatech.com/support/resources/solution-descriptions/napatech-smartnic-solution-for-hardware-offload/
      https://www.eideticom.com/products.html
https://www.xilinx.com/applications/data-center/computational-storage.html
[3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
[4] https://www.spinics.net/lists/linux-block/msg00599.html
[5] https://lwn.net/Articles/793585/
[6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
namespaces-zns-as-go-to-industry-technology/
[7] https://github.com/sbates130272/linux-p2pmem
[8] https://kernel.dk/io_uring.pdf




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

