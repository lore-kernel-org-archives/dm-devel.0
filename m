Return-Path: <SRS0=YP8V=JM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EBAC433ED
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:50:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BFB9961152
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 23:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFB9961152
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-mcddR7hFMGG7APW4vPKPnw-1; Thu, 15 Apr 2021 19:50:51 -0400
X-MC-Unique: mcddR7hFMGG7APW4vPKPnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6B826D246;
	Thu, 15 Apr 2021 23:50:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 527CD610A8;
	Thu, 15 Apr 2021 23:50:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D0B29971;
	Thu, 15 Apr 2021 23:50:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13FNmDam014591 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 19:48:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 89AC42182DA6; Thu, 15 Apr 2021 23:48:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 836EA2182DA1
	for <dm-devel@redhat.com>; Thu, 15 Apr 2021 23:48:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4230C85A5AA
	for <dm-devel@redhat.com>; Thu, 15 Apr 2021 23:48:10 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-422-3MEi_-C7MQKb-E0LRQmdkQ-1; Thu, 15 Apr 2021 19:48:06 -0400
X-MC-Unique: 3MEi_-C7MQKb-E0LRQmdkQ-1
IronPort-SDR: vwnR6rezXMXlLArA86Q2Th1XA1FIiw/U3SEz4+S0+rec/NyTiRcGq5TZDCKU9IXQPE4GYoulSk
	saAa+GcTlQ13g9MtcZfXUMRwAZX9D1igetBnNbslRRd3/qEA9Up5Jf8Uvd9KqSrCRjfn34u2Lj
	HkfytgVdSirVjEFCmQjetNUcygXAI/AzBG96dhA0PTY+SM+b3NCUvmamHde59YfyHF0/Qj6ntv
	DXxA5vJ9nEGcMF9fx3uNuVE0Yok/ZBuyAq+JhFtcuPRLFK2Pp4rprnco3WaXZg8WYTVB1/WltR
	Olw=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="164988423"
Received: from mail-dm6nam11lp2175.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.175])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 07:48:04 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4232.namprd04.prod.outlook.com (2603:10b6:a02:fd::29)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16;
	Thu, 15 Apr 2021 23:48:02 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.4020.023;
	Thu, 15 Apr 2021 23:48:02 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens
	Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH v2 1/4] nvme: return BLK_STS_DO_NOT_RETRY if the DNR bit
	is set
Thread-Index: AQHXMk7X6k16GPe6nE2qzRxrTa/DAw==
Date: Thu, 15 Apr 2021 23:48:01 +0000
Message-ID: <BYAPR04MB496537773A662383CF1B7BEE864D9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210415231530.95464-1-snitzer@redhat.com>
	<20210415231530.95464-2-snitzer@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8d3a3c3-a8a4-4803-7b59-08d90068e819
x-ms-traffictypediagnostic: BYAPR04MB4232:
x-microsoft-antispam-prvs: <BYAPR04MB4232A70A9C23ABDE9AFB4169864D9@BYAPR04MB4232.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Lwtrp4qj2Y96mDzU7j1bdcxxWdvXWgsXYAPcfBm3Gff+4NHjxwTRn+/EwtShzLx76j3krtGlBPwNO8TWgGY2Q3pgn5RhRuIaU/ZMRPiz9z9qr0sKrXli5YzqC5l+zavXy43/wNfGQJgXP5lQP8EezILQvWmTNT/rC8t0ckLeawm3chlTOiq2RVvIY5tvPR8JgZa5L+AGz6mOSdcQzM4B10nbYxhnAvPWhT8A1UCzI5vnZcVGjkwTPu4JNvQtxLRiwcQqiDd1q1TAalxgXNqHkk4yqt92Qv+aQXNisO5IaxtTTlg9KFPHke47p5LNei4DwnKbiZ8VbY6MW5jMzSNgLY1S9FScP31SHqN9C5l3SFeq/Vt9TBNbu3dBuBPw33Gwc24CKF/C7lyLYWB11WgAURUaizkfU6HOCGaIOhl3hREa3seiydMmUpKquZ7OYw+1LvtCf/ASnqGjrNYAuJiHerl86oJ3/gav/f7VnmdmorzH5GOno9VEP59Vo4aeb4O2e/lmIRlyxAA3vL6YfI97jFUBQr20Oq86QoFgguoEHpzxFdTSrtkrnswM5w3s3jqewmaUXN9EFjWhqtVmMHwso55qAonxrVOdQE6etZ77OTE1W/mYpa3V0nZFGSySGbM/XGJxPCI38SXNetsUABnjO3UPDD7DTalxR3JSHvsRjsIwpu0NgN6DGx/N9TBqsCkE
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(9686003)(26005)(76116006)(86362001)(66946007)(53546011)(55016002)(110136005)(122000001)(186003)(478600001)(5660300002)(54906003)(64756008)(4326008)(52536014)(66476007)(4744005)(66446008)(66556008)(7696005)(316002)(8676002)(71200400001)(8936002)(966005)(38100700002)(83380400001)(2906002)(6506007)(33656002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?shNcMjpazFA3jqj1+XxoU2E1Bg15+afozS+Vmyhffq0WRLiIDbiuteGl0N3A?=
	=?us-ascii?Q?jB0wBw0NkSj5YbyzPsiYKsgyUkOf8hF4lc+iGehgR834IzlxR/58s/VphWx0?=
	=?us-ascii?Q?TELq686OXTJxHGcffcEHJMjyVE2HSNezDVeynByZDVqzDSO4v0KJLlmvojNl?=
	=?us-ascii?Q?ssAG/yTPa7yPw5bINykCyN4KdJDx9ge8bFwvlzjA0e0C/bDnwwsG0Br/5Zul?=
	=?us-ascii?Q?3ELezF/pMMOeBsME6/mSAGAJgZlKzZdEdJF7FD4x+FsNUYSyuxA6I9svRCTC?=
	=?us-ascii?Q?NLpVv2jx6xoe+B0SJEBLCUA+MYJCU/RFfC6kciXFZuSZs1I3VV+2fBmyTUks?=
	=?us-ascii?Q?WMujKrzw9y3hOWgWqdLMPyTHeXJsF1G9KacoexovDujb44U4Hq5Bmw8ViSM2?=
	=?us-ascii?Q?tPdUTE12YOAoemYhMMo1FLgVhAB77r4nprerNERiCm5lbGC1ZTu0PrSGVTRJ?=
	=?us-ascii?Q?x8vOnVMEs60RTNYhlQ4Xi9var4fYjlzK1RKeQKkEem6NWajwuHHgujZd3teF?=
	=?us-ascii?Q?lE2lBLxttYhKhBbYGJXSQwmXJNT8YrBSwYYjaP9GB+tFCAJXJSHDnwf5nTDB?=
	=?us-ascii?Q?atE0L/XMPGFUmRQxPyFRmbcKCahfB4TSCDeGaEVFvHDEKumnai1pmahFfyvo?=
	=?us-ascii?Q?OJKAXLoN5yKJOWEWA9VNdpBbO9eoRpPFCSWYOtUx3OigXNgAJdUGKOxYN6eD?=
	=?us-ascii?Q?aEzpJzCxot4l/V6QbX+6By3dAuMC4CtCM+JhG6LCKS6R0ujiN6B2KSB+rgap?=
	=?us-ascii?Q?1BYq8dWEVJScu+OHDkx7TSsC+bYy6hBdLh9zg5AiyltE0U9zQvU8Spsolanw?=
	=?us-ascii?Q?S02OdKmkPiJyFUsmn1pug+CLEM4rCAxfow0gM5KWmpECrWX8gSHXGNs7kLSj?=
	=?us-ascii?Q?0+yTixXD6h7e51NPjhq70yhx6SRyo8meUnzAN253+CxBx1MGm5vCD2LQVYlf?=
	=?us-ascii?Q?lQ2a4a3/h0M40GtLFxHIq0llAL57NFB5CzPxaBM/Pf+dBtX7bMdLpUYVCTqW?=
	=?us-ascii?Q?ZLgyx/aT8xio68A0AfUWar8bLr2tvL4vxhPCamg2awJZ2TLa4DsjZvQYJgSi?=
	=?us-ascii?Q?P7ky0AgQuQ5n0hql1CnfoAQH4HfZZINoWj1usXI8v5mHBRlpUIm0V8hTDHqj?=
	=?us-ascii?Q?Un8nuU6B3FUEWis796sHUGY428DSQFf6F8hHxftsd2QvK9EXRWXLljpCDAH6?=
	=?us-ascii?Q?bopw5S1cYNHy0GXTZQwWfNy5DVOTzPvpMzoMeQhUY3KaDVft3uPXkh+14jDF?=
	=?us-ascii?Q?ro15IMnH+pStKvIpT0scu+uo6ZrXf/7CfPCvOC4Mwkh0F+ZLlWkOsdCNyrf6?=
	=?us-ascii?Q?RcvStvtI6Cx3bSp5mthiwBOk?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d3a3c3-a8a4-4803-7b59-08d90068e819
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 23:48:01.8269 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R41h1+4oHoTdDS8bRi6iZw8FRvzqIx+1gttR2H99J9O2vRTvbcY3j+sNS0KnaAjsR2XCy9vmoOS0SMB2a88oXOk3rhyXe8dxttziVuV7OaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4232
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13FNmDam014591
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [dm-devel] [PATCH v2 1/4] nvme: return BLK_STS_DO_NOT_RETRY if
 the DNR bit is set
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/15/21 16:27, Mike Snitzer wrote:
> If the DNR bit is set we should not retry the command.
>
> We care about the retryable vs not retryable distinction at the block
> layer so propagate the equivalent of the DNR bit by introducing
> BLK_STS_DO_NOT_RETRY. Update blk_path_error() to _not_ retry if it
> is set.
>
> This change runs with the suggestion made here:
> https://lore.kernel.org/linux-nvme/20190813170144.GA10269@lst.de/
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

