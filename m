Return-Path: <SRS0=xPb5=LF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6150DC4743D
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 06:04:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C73C3610A5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 06:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C73C3610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-kXD3-Q2MPWyaR916C0kGbw-1; Fri, 11 Jun 2021 02:04:09 -0400
X-MC-Unique: kXD3-Q2MPWyaR916C0kGbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 891C936360;
	Fri, 11 Jun 2021 06:04:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 29D7B10013D7;
	Fri, 11 Jun 2021 06:04:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27D8B4EE7F;
	Fri, 11 Jun 2021 06:04:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15B63uCh027178 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Jun 2021 02:03:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D544F205D6A9; Fri, 11 Jun 2021 06:03:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFF47205D6A4
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 06:03:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BA2E811E9C
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 06:03:53 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-120-gp89TvfVPn23GGd4X1AJbw-1; Fri, 11 Jun 2021 02:03:49 -0400
X-MC-Unique: gp89TvfVPn23GGd4X1AJbw-1
IronPort-SDR: AnyCrNkk0b2As/Vn54jAFhBaw1gSC2hivcotOQtGH2aPjaRmh9eNZVe73IoDcft6rl+C05uaTM
	TN3lDJecB7PYXwJ8Sv3BIkp6RTyqw1L5neMkQli0TVjApW3yKmbJPQTzERlKYA2vfcgcFsXE4i
	ynR2U5HuXdj3EZw6piF0oKOZJ18O5eRNJX1Yyb28MzAHpegDrqw6L4w+IAofw+PwB7zhJ25H5t
	UDf+GfHz/od4CnZvYKeUYjycIqOtzMqnp94tTWqZxADIIcH2cu90eeXalqameB67U+c2zg6Huk
	3G0=
X-IronPort-AV: E=Sophos;i="5.83,265,1616428800"; d="scan'208";a="170827041"
Received: from mail-mw2nam08lp2172.outbound.protection.outlook.com (HELO
	NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.172])
	by ob1.hgst.iphmx.com with ESMTP; 11 Jun 2021 14:03:48 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4229.namprd04.prod.outlook.com (2603:10b6:a02:f5::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.27;
	Fri, 11 Jun 2021 06:03:47 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4219.021;
	Fri, 11 Jun 2021 06:03:47 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaA==
Date: Fri, 11 Jun 2021 06:03:47 +0000
Message-ID: <BYAPR04MB49650D374549472F6A47FE7786349@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5be62dd3-01ed-489d-39ab-08d92c9ead3d
x-ms-traffictypediagnostic: BYAPR04MB4229:
x-microsoft-antispam-prvs: <BYAPR04MB4229D929AA78996921158FC186349@BYAPR04MB4229.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: coFKMFWtUO8nBQCW3TtlH9vC2oMac/dHchenVDmoaI2SbrxqOs2R5MMoTufwH7xcmAJO7V61enHKnUl9DJrF8xEENafquQPjIbjs7Kpe3v7tNSaGu58cSIllZTyNLf3gf70/L4jzkgWXKz9xiyB+F4Q9Rvwevs9w7ASfKRdjn760WWoY1zU2F33Nps8aG1+zkdvlYLxjhB89RS2zNM350NjYtr6BIwsdbkxvOVZIum7NkysjRt9gJxXPnLhsCPnH2GHw0JImNN2TTAlnJuTLWsL+hVt7Ezueo83Tznfph/F98sIcSSCOJcZH6+mga6IkYLun/mvoH14iDsYwvubsnBu/uqdSG4WLmLDyGCPkhQIg8C74LVLqKvVAJWLeFC+f8e1SESP+kjHmSpc7RD3NNIpEXGYQ4d50Jhiur6QXpCX25Tb8MpVECMFN8ovAbTzqsxb5Gfigb1ce+sFMv60kUGn96WvfT59ffDkgAxRVLRx5IBOFTH/QKfq0KTvNDsqZdjaRPl6V7ol84wxzZtq/XXj8n33U8WtIZ1t4weYaQ3xEf2YXd6TJhrTcthlRy//77d/j4/s2JEl9lNgZtaPcQkiumDcrBB1TRVN9TSQhytjQUGtpoa/yEpkTmpqY6iDJ7xQwfwzQvsJHJ0kQkJnfV5vTJfT/K2LEHg870uVacJEiyKxYMOAPpuYW87eclvnUn1M7zRn/4ap+spj4YJZSJHHZ7f0xUpuaQ8ydUFIdvT9/QzSw/t6M8udBDAF5nag7Kuuj/9twlu+XEbUzDL81pfSpHiBtfrRYXl/2FQDSYh7pinMfdxl/oAzdby31E3Gy
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(76116006)(9686003)(53546011)(86362001)(5660300002)(33656002)(4326008)(966005)(52536014)(6506007)(2906002)(66556008)(478600001)(83380400001)(55016002)(66946007)(64756008)(66476007)(110136005)(316002)(8676002)(71200400001)(122000001)(26005)(8936002)(7696005)(66446008)(38100700002)(186003)(15398625002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3AlIT2PUDZ8GYva5dnGvCri1fBBCg0PVySMZdGJzotMdx8tHEPcaRuqudlAF?=
	=?us-ascii?Q?9cKB5CFG1U2dhdBn5GSWfzYE1WTDuzudBMSEhzxU1MFEhsWLvJVE72nz2ubB?=
	=?us-ascii?Q?cb8WexDIZIIwpa13wg3thS1MJ//2JrVAuVbdPLQnpe/WXw0aBYAAZ7IzbFIC?=
	=?us-ascii?Q?PldSolR1w2wNCMsNjtgZZBT5EqMbordOwLvYv9vGeNpb58q2/ZLSbgUSv+dJ?=
	=?us-ascii?Q?u1fNXGv0TMTd+QUgUIOkiJ2Z6AzNUZqRxo99M4zJt6T3901EfypvKocdblju?=
	=?us-ascii?Q?SqwLARcYKSub7cd5pAdLAOUNJxXJTC/5wIJUNp4LyKrfPlK6F5nsPal60eAn?=
	=?us-ascii?Q?Wh5uKTCbjW27j6SO1Om+i8vcZ+Ay7yg2D93YWJP1KzAW0XqgDVS8DOf5ijH3?=
	=?us-ascii?Q?fYMom61hmD9Z/ixKBZys88G2gFWWc/nECgfQGneM/p0tjTjbaVtTe5mOnWvn?=
	=?us-ascii?Q?rvwRf3Ocm9fiWw/VN97/Xdsvl1PRRf4EkAbLn3pGudxVfWa4QU9KlwsveJa4?=
	=?us-ascii?Q?CBG0wGO0qf/ZEa9Kr5AyP1UZSA2WL5TxQ6KnLL8rDJu31MkrejGEMfmqRaNF?=
	=?us-ascii?Q?BbcRn2Fd9DguC5SwpwI6iqtOyNpcO03L1G0nJlEJMlW1B7Rzkmyn8lJzSndD?=
	=?us-ascii?Q?Ah5TCmo9TF3Mr+XMg4ocTwwCA2iJQ4I3h1NOcHPsMWdI+B0avYtQA9kOGW/C?=
	=?us-ascii?Q?P038lxZLTToLxMUaH9JXw/yVmNnRAh9EKgW5IPxvMvNBdi7EoT2BdIrwEqBA?=
	=?us-ascii?Q?9w9CBaFbs484TpMrA3W2/r2KaN0oVbOq/hFVTEhL3rfwZShyAR7CudSqd0YE?=
	=?us-ascii?Q?0lxlYHipxfYkHOoiC7r/8Lb7pny5kGC39DO9aRiry78HkBvfTOACiSS/zPP4?=
	=?us-ascii?Q?2attSIW8VPZqJNUOsQ5cN+J67Mz9EW0hWTWlwuCoR0xJhpOZOJvUwHqMLbB0?=
	=?us-ascii?Q?SArZwejN9y8/mC710Wvr5Xz50b5a2OY2/UYvi+iRSQp8bOqrJ+AXlLXMieDP?=
	=?us-ascii?Q?GERgVGG/mD1Bm60DOET2/Lk6+ApG+P38e4fp0JS7VB+pzYX+62fYSbrrqA/M?=
	=?us-ascii?Q?zegyAc5W4+C60HQFLCXa+oQXulI5zvRt1EyPVnIZBpsHktRLobv8hUTnU3z7?=
	=?us-ascii?Q?g8PTE3pHy1eLTOmatcjobNEMynOF37ZLeZpXwSubHRoJ5PmW8Do+6XAihpEP?=
	=?us-ascii?Q?MusJchFfT2phYw6q063P4SgjHuB0+HJX3h1icASyqohzqgWwx73CbdoTkNfu?=
	=?us-ascii?Q?7unClvyvTEGIoTasI0lNNVZ+L3HXw7KXZ9jM9bHsOGDEqHRLamKO09Bsy2wc?=
	=?us-ascii?Q?NU5dPfIdX9IyQ4Rh38DFaPWz?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be62dd3-01ed-489d-39ab-08d92c9ead3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 06:03:47.0513 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: USzjgWd1zMIWMBe1lHc+K/WhrbG6rDhO8k9o8+i+2P9th0l4qPe+8W7e6X+JR4MS1pFA/+d7WdaNGQm5pexWX0RbqkG+OIUK1dWc7UWaKNE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4229
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15B63uCh027178
X-loop: dm-devel@redhat.com
Cc: "ckulkarnilinux@gmail.com" <ckulkarnilinux@gmail.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/10/21 17:15, Chaitanya Kulkarni wrote:
> Hi,
>
> * Background :-
> -----------------------------------------------------------------------
>
> Copy offload is a feature that allows file-systems or storage devices
> to be instructed to copy files/logical blocks without requiring
> involvement of the local CPU.
>
> With reference to the RISC-V summit keynote [1] single threaded
> performance is limiting due to Denard scaling and multi-threaded
> performance is slowing down due Moore's law limitations. With the rise
> of SNIA Computation Technical Storage Working Group (TWG) [2],
> offloading computations to the device or over the fabrics is becoming
> popular as there are several solutions available [2]. One of the common
> operation which is popular in the kernel and is not merged yet is Copy
> offload over the fabrics or on to the device.
>
> * Problem :-
> -----------------------------------------------------------------------
>
> The original work which is done by Martin is present here [3]. The
> latest work which is posted by Mikulas [4] is not merged yet. These two
> approaches are totally different from each other. Several storage
> vendors discourage mixing copy offload requests with regular READ/WRITE
> I/O. Also, the fact that the operation fails if a copy request ever
> needs to be split as it traverses the stack it has the unfortunate
> side-effect of preventing copy offload from working in pretty much
> every common deployment configuration out there.
>
> * Current state of the work :-
> -----------------------------------------------------------------------
>
> With [3] being hard to handle arbitrary DM/MD stacking without
> splitting the command in two, one for copying IN and one for copying
> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
> candidate. Also, with [4] there is an unresolved problem with the
> two-command approach about how to handle changes to the DM layout
> between an IN and OUT operations.
>
> * Why Linux Kernel Storage System needs Copy Offload support now ?
> -----------------------------------------------------------------------
>
> With the rise of the SNIA Computational Storage TWG and solutions [2],
> existing SCSI XCopy support in the protocol, recent advancement in the
> Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
> DMA support in the Linux Kernel mainly for NVMe devices [7] and
> eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
> from Copy offload operation.
>
> With this background we have significant number of use-cases which are
> strong candidates waiting for outstanding Linux Kernel Block Layer Copy
> Offload support, so that Linux Kernel Storage subsystem can to address
> previously mentioned problems [1] and allow efficient offloading of the
> data related operations. (Such as move/copy etc.)
>
> For reference following is the list of the use-cases/candidates waiting
> for Copy Offload support :-
>
> 1. SCSI-attached storage arrays.
> 2. Stacking drivers supporting XCopy DM/MD.
> 3. Computational Storage solutions.
> 7. File systems :- Local, NFS and Zonefs.
> 4. Block devices :- Distributed, local, and Zoned devices.
> 5. Peer to Peer DMA support solutions.
> 6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
>
> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
>
> I'd like to propose a session to go over this topic to understand :-
>
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
>
> * Required Participants :-
> -----------------------------------------------------------------------
>
> I'd like to invite file system, block layer, and device drivers
> developers to:-
>
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.
>
> Required attendees :-
>
> Martin K. Petersen
> Jens Axboe
> Christoph Hellwig
> Bart Van Assche
> Zach Brown
> Roland Dreier
> Ric Wheeler
> Trond Myklebust
> Mike Snitzer
> Keith Busch
> Sagi Grimberg
> Hannes Reinecke
> Frederick Knight
> Mikulas Patocka
> Keith Busch
>
> Regards,
> Chaitanya
>
> [1]https://content.riscv.org/wp-content/uploads/2018/12/A-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterson-.pdf
> [2] https://www.snia.org/computational
> https://www.napatech.com/support/resources/solution-descriptions/napatech-smartnic-solution-for-hardware-offload/
>       https://www.eideticom.com/products.html
> https://www.xilinx.com/applications/data-center/computational-storage.html
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
> [4] https://www.spinics.net/lists/linux-block/msg00599.html
> [5] https://lwn.net/Articles/793585/
> [6] https://nvmexpress.org/new-nvmetm-specification-defines-zoned-
> namespaces-zns-as-go-to-industry-technology/
> [7] https://github.com/sbates130272/linux-p2pmem
> [8] https://kernel.dk/io_uring.pdf
>
>

Mail server is dropping emails from the mailing list, adding personal
email address.





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

