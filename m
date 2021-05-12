Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50629C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 07:33:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AB93061936
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 07:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB93061936
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-_9SqfW7qMfaCjo8kxJKARA-1; Wed, 12 May 2021 03:33:22 -0400
X-MC-Unique: _9SqfW7qMfaCjo8kxJKARA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E6D86D4E8;
	Wed, 12 May 2021 07:33:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66F88761E7;
	Wed, 12 May 2021 07:33:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A5A9180B463;
	Wed, 12 May 2021 07:33:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14C7XCTB022677 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 03:33:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 10F0B10379E; Wed, 12 May 2021 07:33:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 086101037B4
	for <dm-devel@redhat.com>; Wed, 12 May 2021 07:33:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62F2A185A79C
	for <dm-devel@redhat.com>; Wed, 12 May 2021 07:33:09 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-26-3JdUhV8SOZy6mZiEU4tMWA-1; Wed, 12 May 2021 03:33:07 -0400
X-MC-Unique: 3JdUhV8SOZy6mZiEU4tMWA-1
IronPort-SDR: lyJuZPLRt5GxyFWdqR9bvSGVcnwnr3ujS2xMNZR35ud0U+BngjXPQwgSZ3PCJps8f0JGQMKhsH
	NkWAnCTm9IgIrz6AUMY3UUhmIs7bT6qxk43AxXVIXZxPVFZWvPJz7gcCU/WCtV+9pTaNMq6j5L
	qEZ1+pmP9MPgYqRfvG1GY81W0nrCUsGFQ4Zov1ppvmOqiggR+LeFotmScOLtsaNQaVXCAVBDaM
	XVKhPkEnHFVvVtIwn5argGMlgsXoSyZ7r7lDLMxn0WWBAX+ZCG9noYAWR2RyjNfisdqj+AZNBR
	aP0=
X-IronPort-AV: E=Sophos;i="5.82,293,1613404800"; d="scan'208";a="271843966"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
	by ob1.hgst.iphmx.com with ESMTP; 12 May 2021 15:31:03 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7256.namprd04.prod.outlook.com (2603:10b6:510:1a::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 12 May 2021 07:31:00 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4108.031;
	Wed, 12 May 2021 07:30:59 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaA==
Date: Wed, 12 May 2021 07:30:59 +0000
Message-ID: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:2079:86fb:b3fc:1190]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d68beba-92db-471b-fc85-08d91517e3cd
x-ms-traffictypediagnostic: PH0PR04MB7256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB725661D975B16B6558016E029B529@PH0PR04MB7256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: e0dsVs7Ja7xxFnkfyj8UANuku9WoxDwCoWvD+AZCIqlFRl0syHUXH9HcX+6HrAnmCH6U52bR4QZLRK2dWX/NBUlAkgtVeBKIE50gduFk1aGvIVcV7yZ+szQXae/5ebaR5eH6vvLOT1MLY3+9fGLVWJOHLpVYmybFfu/2Te2fcY/d7qnNaZ8yZepKD9FDm/sr8w+z5Ter7o06Tmr7D9cJp9lx1kmWVU7oafcj97Ffb4tgWAQA07HmQQpM1rnhxojdOyM4/gXK9dsG5tc+hYZeDfIbQzY85hyEAI0di1ZckJ1VRZMIShnk7aRfy/ASnsIStI+ikiBKltaRf2vxjsMvjSbk8LHX7Ag8/v/Oe+MDP0YvgRH3HSCjEU2tVceIn44RSfsD9JBpoBm7QDcEcVsqweXSm49zKwa2WExwuZvtA4jRg81OKcqUtUSQoln/4Ue5k2nLdaasq1egvn3yhnyvEMXEHH4RdiaO3SVA87x2FUoeYEsb7G02fRHNbVPgY+A0rxI6ms/fiWwn2SukfPYk1Yt9LfhiqGx54xx1lVnjMlUBlDKbUXOThxnovRGRW4LbmxwvRGsOJSxz/Lpq0DiWAF6TYb8dF8TlIrymTWdRstw=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(86362001)(8936002)(7696005)(53546011)(6506007)(33656002)(38100700002)(83380400001)(122000001)(8676002)(71200400001)(7416002)(2906002)(52536014)(55016002)(9686003)(5660300002)(478600001)(54906003)(316002)(110136005)(66946007)(66446008)(66476007)(66556008)(64756008)(76116006)(91956017)(4326008)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?H0NCOAO4x3gXiz5Kffc3II1BmoVmu7KwMq5oVbpwec1jy/D9JztAbbO43T1L?=
	=?us-ascii?Q?PxdQRtNpn5oTm+EjbQhi6df8eCJMtyc2DP+Iv6v0Hm/lCnsFukZGS0XdhIMK?=
	=?us-ascii?Q?K3YLh0eosSu7VF1w4mG45TyMhx5FNv6ZWp+7EEv9o8XqAUHCbZn1c0UQ3SRP?=
	=?us-ascii?Q?Oj941wnQCO4U5+liXANqCsrVciz3psGR69WSncGcgrZFYjobgJ6nYoeWY/2/?=
	=?us-ascii?Q?IShpNLWB39h9AzJDTslxMV33r1Wu4rd1+7t5EujvucMeqRtUljD4LQhfQ+ss?=
	=?us-ascii?Q?XmOzr129tc3SqnZD6ENlk5hkyPkS9LEgGjmyRea5tDOMwPjK6naMdvrxYWjo?=
	=?us-ascii?Q?USzIYNV072urfgwiJjQ44EdxJYUFluq86rDb5xXJ4bEFSpZ/Wm1YIiZmZ8ir?=
	=?us-ascii?Q?1UKOI9QbixhjDgvg9KHR5rTuzNaSybp2uokdcYUQmvghMFvQTTTXv/43BnC8?=
	=?us-ascii?Q?WVvjSF0Do5uCZGrEEw58IS4PE5SF8cKWA/Z9/ttcFS9EuTCGPxrV/YBTenv3?=
	=?us-ascii?Q?qzPW7jQfLsoBS41DjwVIt0xaoitJif/FdOFODa56QkvvZwQhUzf5HkN3e19b?=
	=?us-ascii?Q?9Et66I4x4Zry2OjBwWljEg21+aEBgFhRjMut38xL82p8hlhHmn5OnCWSF9Cz?=
	=?us-ascii?Q?vp1GizjVc+l2LkflT5f5y62MTIAQIzxM9s6UKR2/B7sBKY1r/ecxJEeZ5ba+?=
	=?us-ascii?Q?UFpSpQZCXsTuVQNfnq7rl3SmZ93YxfgZKniUZVpX9Fz9V7tRmXMF6EPXUQJT?=
	=?us-ascii?Q?lyAGXsN7DMYIorKCGJYHuoxYxbQhWg+j+YKbitxx0V6V0Qw1zZAfDk9Qj7EW?=
	=?us-ascii?Q?pQ2bwrPj7cKlb0t/aGhuPmz0horIc4HwxMEEJiwMnB6ytxnc0Dj20diF5Igs?=
	=?us-ascii?Q?FvfHBgRtBjDxrqSZn5lW7e+4Rv/NGjEvyKRj7z8BAfQ/8ZS77tx0fHpNg17m?=
	=?us-ascii?Q?HYeX3WRvtQeU6CpB72pLLd9/6VS/8lgylruhM75VxVKPfcsI35zE7IUKPYl+?=
	=?us-ascii?Q?vgJeJY0veiPhEQCyp5tKbOTcJ2QqH676W3L6RWvfxJsWYVoTBpJVOti0d1BW?=
	=?us-ascii?Q?fevi1I6DeyXagbyVlmKM9B81xjlVI6xVI4VknEMoOOz15rWgINfZF+rQB0Ai?=
	=?us-ascii?Q?V6GmNMrxB1OJDt5IYJ+n3SEtgH4b8bzjwbK27ufYxjQzXhBFL6xQamNzA2eb?=
	=?us-ascii?Q?1kzryMIXhX6+oE9u22HGDxNEqg7wEjiqBA2tHD1C8KdZ8FUZchvUxRhO+Aew?=
	=?us-ascii?Q?LaPaCnF5Vlzcxj194lmSZ1TwZezi0wL2gbdzjUgivcyI8oUpGxNYzNJejPIz?=
	=?us-ascii?Q?mGnzuU94rwgpIdjZuEoS3pIPdFJzenoxA3kKfa2xLBheN5fiqxzCvGjWZBEH?=
	=?us-ascii?Q?IAwN0pvcetCAiktEhqDoNuBt/nF+zJYkyExZTuYUIvMZSF2XOA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d68beba-92db-471b-fc85-08d91517e3cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 07:30:59.8252 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y3sCZyGWHLmUE2T3zyzy4pjcnFOYZdZuj8QMapJiN5LcnWc+ltdmjUz9gnThOBNGDahyy/gYmF3tjyDQ8+7Q2dnEnOhWZoO2iIDOtHlprzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7256
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14C7XCTB022677
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/05/2021 02:15, Chaitanya Kulkarni wrote:
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

I would like to participate in this discussion as well. A generic block layer
copy API is extremely helpful for filesystem garbage collection and copy operations
like copy_file_range().



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

