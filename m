Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1D7C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 13:52:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 35E0322AEC
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 13:52:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35E0322AEC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-LcTY5oyFNXGlf3JhwOXkWg-1; Mon, 25 Jan 2021 08:52:30 -0500
X-MC-Unique: LcTY5oyFNXGlf3JhwOXkWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A88441922055;
	Mon, 25 Jan 2021 13:52:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58B9760C0F;
	Mon, 25 Jan 2021 13:52:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 182B218095FF;
	Mon, 25 Jan 2021 13:52:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PDqIkT000870 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 08:52:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 547505D204; Mon, 25 Jan 2021 13:52:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BAB55D20B
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 13:52:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29E1A8001B8
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 13:52:14 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-604-jre8cbHTMnS9eukvLiVFTw-1; Mon, 25 Jan 2021 08:52:11 -0500
X-MC-Unique: jre8cbHTMnS9eukvLiVFTw-1
IronPort-SDR: cTNFEceCeU89THMwRJ6J2qN6mabMNFKK671hb8z1ZcSRDoAxOiOnXTrx3iGBnJ1UaRxYOMgR3j
	k3hXwWxE3IwwQDLAY5c7GgRki8seBfSF9v9jFwCobIhTzzjhttLvy0Q+7RHpPBJVXe3Yr7DXDz
	c/TOgqtZw3H1+CDGfAZ3kP4T6f2n/6WDJs2QVUYzE5ypwGtj3xSW/9Gc4SlJuNJVPLX1E/Yo0P
	SWi0qjOpleWHlxZBkUnYkovO2Sg8fd7bkuCVgdOzttwfUHGZ161fFSNpbzhQMuFF0fcavf8ipT
	Cm0=
X-IronPort-AV: E=Sophos;i="5.79,373,1602518400"; d="scan'208";a="159434226"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
	by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2021 21:51:07 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SA2PR04MB7612.namprd04.prod.outlook.com
	(2603:10b6:806:147::16) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11;
	Mon, 25 Jan 2021 13:51:05 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017;
	Mon, 25 Jan 2021 13:51:05 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 01/10] brd: remove the end of device check in brd_do_bvec
Thread-Index: AQHW8jiwwuJ8D6w9T0iSZ+Qk0m6aPQ==
Date: Mon, 25 Jan 2021 13:51:05 +0000
Message-ID: <SN4PR0401MB35982F96772179339E14453A9BBD9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210124100241.1167849-1-hch@lst.de>
	<20210124100241.1167849-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d333f5b-95de-47c9-36f0-08d8c13842f6
x-ms-traffictypediagnostic: SA2PR04MB7612:
x-microsoft-antispam-prvs: <SA2PR04MB761243AE27FDE64BEF44063E9BBD9@SA2PR04MB7612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nU1Mk2FRvwuR2W58MPpSVIZ+8D3rXEcUWWb/d1oqsSmwldvd32TXZerkd1qR+39N1iOyWJ3u2YiX2zkb/l8USWqJe7ZiTHaV5J9D94ewPQguAjxg7GCFXo2zNT8ozZt5GP8Hy12mJpfbwb3M+gScCe4pGxq5cst7m0eiFGuEKTy4L0WujJ7zzAuzUeQ6VLPP3ZdyQLKxFMg/zd75dsFAOH9HELAAYU91TGDI6TLnrVgdWNySSddzYIKb2cDTir8D/rii0Ith1024MPIQAdWOhB1umdRQ7Sk9jEjYqC89ywMG1iYRxOqLlALVLkC9QueVNbYquvsckbxU+PbIVdkfMzVpbtObP+wnp1bYHAuhELzlDwhnD9PIQ8jryTW+AGd9NwpLHM2oyaPsn2d1kyJ75A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(64756008)(186003)(5660300002)(4326008)(86362001)(7416002)(316002)(8936002)(52536014)(2906002)(33656002)(66446008)(66556008)(6506007)(4270600006)(66476007)(55016002)(110136005)(66946007)(8676002)(558084003)(76116006)(9686003)(478600001)(26005)(71200400001)(19618925003)(54906003)(7696005)(91956017);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SYLvfzUGSx1iDkeetP6rvCfTyX4UdRtVnYU064X1rFBJQJyiar96NH3ZfIxL?=
	=?us-ascii?Q?QKxSsEWZlMZItS6HfOmtjfoRxuj6HhDLbTX7es/K+We0dDabUGfcFJckimAq?=
	=?us-ascii?Q?P3Bwj4QESJnnENLKKUTBfqiEK6CJQJ1HyNq8x2KHX8cHBeUGLUm7QDPHjOrH?=
	=?us-ascii?Q?p5rbFFnhBwGudXr6ZALMCGJULrZ9bnpjcjhM0BOq/79KMV59s7jEa1o3WU0a?=
	=?us-ascii?Q?HP+UeUOAGGuDQgBi7tuJ3XiXC7/L/AW+Eyp7a5JNXK3HuFWG1cugtJgb/tvO?=
	=?us-ascii?Q?xTrUIiy5P3Pu+EPMt3lfXXNTwc138In4TBI4qnsI+lYU7mdwQRnOnL3WmCYy?=
	=?us-ascii?Q?/c1OXV81m8qwnK5kme3RH8+fbIrI+Ec3dIah3PjOlN/oilt9vJoXTGJ2Pp4P?=
	=?us-ascii?Q?hnA90A4oLmtqVQ7dhgmNBA5VNooWkFJ6RL6GhuRwKRMoq5PE41/MLuMoDwFj?=
	=?us-ascii?Q?XomV8NWdGZQvyC1McnCkooEh7VQizG96c0GytQ5QZNBp9Kk5DyCU/+Hya1Yd?=
	=?us-ascii?Q?5iAIDpbWa586NY7YIXR1qmb2UNcvu+CwEqa+Wgx8w6IiINzaGUZobFg9Tr8m?=
	=?us-ascii?Q?mwMre6hRNwXluFi7g1AoJF3t8K3pIiSpDbrTyJ8DmVgHrpKR/PROKnk8f+NN?=
	=?us-ascii?Q?b2d6egovr/bjxRNzlioVk6fBQ80v01yCW3meYGTYd7s3xkZZ5voY5woMEdyG?=
	=?us-ascii?Q?VAb+yfI3U4fXm7hARSeG+s99RaZXCl0kIgiPg5py8EmMeihs7aGFGETUDNPV?=
	=?us-ascii?Q?5+h+qP9Po+VwNlDMjuq1TryTIXyi74yUnnCAYGBOzaKFkCFJI/Ihc+3O1zov?=
	=?us-ascii?Q?q0mi3AabG/k8nV2AvQp2jPehnkpi8vtTAS1fofZ59z47eng1a6Mq2wXnXGjF?=
	=?us-ascii?Q?ZbdlLo4uvq5xW/i/EJlBQmAtZWi/ha+kXC7M8/gJeXtsgCfDv7Y1ShmirVD2?=
	=?us-ascii?Q?UxhbSDynWVix1vOXo6zQhoFVA/v/tKFkOr8VjFCMp5brfH8XEZ6Wr9346npk?=
	=?us-ascii?Q?dOUv+ouq8IWKOtdNS75cmzFU1jGQGen8Nw6ckq2azMGG0oREQlJkbgCM3GFn?=
	=?us-ascii?Q?m8GLTZsyU95loMl7XkWP29MrXgzpyA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d333f5b-95de-47c9-36f0-08d8c13842f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 13:51:05.7407 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nvh2FdmqvNtWZIuLkhy4dPT/oK4QDrw3SScRAJZ52O4WxgoyUu+pPFsy93WYQToSpJHLhgFHoDzZM4dTImEEC6Gtw6HGBQQ208KAvIwhBdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7612
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10PDqIkT000870
X-loop: dm-devel@redhat.com
Cc: "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 01/10] brd: remove the end of device check in
	brd_do_bvec
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

