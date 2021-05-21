Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1375DC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:08:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 98E6B61074
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:08:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98E6B61074
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-4UVjpwCjM1O_3tFwnxRpew-1; Fri, 21 May 2021 01:08:07 -0400
X-MC-Unique: 4UVjpwCjM1O_3tFwnxRpew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 541DA180FD70;
	Fri, 21 May 2021 05:08:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 366505D74D;
	Fri, 21 May 2021 05:08:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EE4A935B77;
	Fri, 21 May 2021 05:08:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L580rJ023658 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:08:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 821892062C00; Fri, 21 May 2021 05:08:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CC0220B94D0
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:07:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34898833942
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:07:56 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-231-Kat5J3JpM3Geoqeu7sIwMQ-1; Fri, 21 May 2021 01:07:53 -0400
X-MC-Unique: Kat5J3JpM3Geoqeu7sIwMQ-1
IronPort-SDR: VAHmfhvREAPx81Z65D+7F5y9DU3V41sIfO3EVyK24nNKMKM1gQ5q8x2fxG1hFuDKPUG+C6kh2d
	7wI3d/tul/HzPbiLbSlaDjagsQaW6JU4zqXOn2l6ndyMBXAYW7K8HDwoLjw0zLOisuX7WYTzPm
	Ow6EPAOfwVSw9xuQrSPZBBTgBFVAIqn88zTlsXVVPb5Zcvshu3JWAQdMg+yg2v8Gjwc1XnloAI
	JpiT7oSh8agT2nC7uduQXHwirPHj6QDbWapvzn0qb40Ll9PMFBsvLz1G7IIwtqwiPJHUf9f1X9
	umg=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="280211929"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 13:07:51 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7687.namprd04.prod.outlook.com (2603:10b6:510:56::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28;
	Fri, 21 May 2021 05:07:50 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Fri, 21 May 2021 05:07:50 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v3 11/11] dm crypt: Fix zoned block device support
Thread-Index: AQHXTe2iQKcUT1xv2ECjONnMivJSnw==
Date: Fri, 21 May 2021 05:07:50 +0000
Message-ID: <PH0PR04MB7416ACD55929833C745200B99B299@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
	<20210521030119.1209035-12-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:f8bd:921e:9aa5:6d21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7dc80ce-b0df-4026-bc19-08d91c1661ad
x-ms-traffictypediagnostic: PH0PR04MB7687:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7687404F828AE8D1C8C6DE759B299@PH0PR04MB7687.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TvhH3xsuwvtGTMT1ORHHTs2Y+YztuxnvH6A8EnD9OEyMMUVAMx1xI32Rd88Dq2vAgJXgb3W0oXa0OTzvcoNyn/0/o4Xi64kIC40UChGEJN4UtN4hmbay3VJNoF8XKLsYlPVZAny7ZpLeq/a/BTer5jao2Aa1Ei/pFIzX2AC6dFyXPDJQ/xBTo8Zj9njdDqX4t79ZmDW6viG+IZ/M1jQhddLXEICE8YZMFi0TccjZrnguRjnliufLVUop/KDC7tdaE1EjgHWJLlsrZN2qsgWeRaHBlkdAdPCwyaMT3Cn1szw9aZMpy+t3k/lQBBzyHfHRMznUFLV0WxSF38rW4XhTegYh/CBnKAU/Vvp61GjAdVEZbHfs0FODSFINnQHvJMcESGR2Y4LFK0gPYAbLOrwjsFtLtvlSjon4qOPPIsu338SHqx3o19TA4CkIMAV9I1vwQugfeh66JRnaHYppYVs0HF6mdw9wZPHltsWbFRHDSZT3Xjy2AtpZOPkOaSbRa7HAlCEV3vSSNe26ROQnJzGVylDZd6dVqyxeYRGigzKn06FCFKEpawzigUIEcttm18Kw8MyC1vOcQ8Cgd5AX1c/0D+z1ZxOA7pDO4T2U1q9JxQY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(52536014)(478600001)(86362001)(76116006)(33656002)(5660300002)(71200400001)(66556008)(66446008)(91956017)(66946007)(66476007)(64756008)(19618925003)(110136005)(38100700002)(558084003)(55016002)(4270600006)(316002)(7696005)(9686003)(2906002)(8676002)(186003)(8936002)(122000001)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Xz0L7+JTdWMAkmANhWwXkPUKuV1L9jTNn3mqtFJQbpNdr/TwNVihk+tGmzfy?=
	=?us-ascii?Q?/59HKfwies+twrt/fMBQ4/pE42JkxWaiUHTYAPZodYB9ixNcTKerdSvUfYkf?=
	=?us-ascii?Q?obbUKo7gSHYidbMGkU3ZphggaEa8yYvlZQEKikIz+JiPKsqQXxC5hesPHPk7?=
	=?us-ascii?Q?u0k4ms/f0pc+oz0aahISObGvWxHWi5etQnWYjkaw4Uf+jrXtWqJiYl+wXPRE?=
	=?us-ascii?Q?g/gvAuIb5k36dJH+revI6MZ7KPWfmuBnydCVoxtdukPoAerPaIA3sHV5NN+i?=
	=?us-ascii?Q?ao/iC1X0pnF1nOGxwu0gg2uCxkE2xYbo3NguMDwGkxuhBjKeD/NeoqayDvBa?=
	=?us-ascii?Q?JtC8zqVdU6tN/3KLoaImJAqzw6xZLAL2ajwr9kJe+l67rqg8DK2Ygsdebd+1?=
	=?us-ascii?Q?y/BMBn0+41j1t4HAFpRIkSr5jbgQ6IcCymBMwbYGDvlGXFzLNHbW5FBYSklP?=
	=?us-ascii?Q?yAlnyf+e6Ow1q74bL0Fd7DphU/ANQbNCgniO5qIvsyncH3BtsMlisz4L0Zpo?=
	=?us-ascii?Q?rx3dyYpftv9wV/ifyoDwvuP1/usufNEQDrapFWrtTCJnmDq8XbLXtShnodfN?=
	=?us-ascii?Q?E6DlWQv4wJxzAKZfciZ4xpET3kA8jWhkEskF8T7buI/+/AioztHOGX+OvhX5?=
	=?us-ascii?Q?zhvwwUZfS+g4U8oZET+7ejTkly+CxMZK6DGKQ9TgcAVQxf7mdurSBOpzH3oB?=
	=?us-ascii?Q?b0x1coDMobtavlsq+fYXUHuYhvHzaPJfGeaWt7N6Pi+zfMRi1E6f4TVULvN4?=
	=?us-ascii?Q?hE36oMtFutSIm3EDq8fxVfgYv6zvjpl73DgjRCZj9beEMyiOm+JpdIPdKXVX?=
	=?us-ascii?Q?UonuUDUTBXvCX113RSUzuDYymcEM4ls1Z0HQBE9DcIJM2HzCQfu/wou4RIr2?=
	=?us-ascii?Q?ZLwBIsLgdezrrxguB8LIb7USJ73YkI8i7cFXjJiwDETMN1oIV0hDdDbG/K3w?=
	=?us-ascii?Q?WqCfykUozM5ivvjRWjdl3zwCHPSuzdS51OTjioUrZ1L19sd4ulANGB3VlBbi?=
	=?us-ascii?Q?vlIUTrp4RSKo7jgH3orzOHp9IBc3rTY2oprjejaiCBIwjkeUZ1Ye2yL3UZHL?=
	=?us-ascii?Q?IekQUOfPgbb3CHUTo7pgU6Jf3IwSafA01e8P1vvcO037wCZF6bUQzOL/C5Ex?=
	=?us-ascii?Q?3YgYmd5y40JRHAgNagIWWIre/taMZjLRCDoEg+0TrZTe5TK9DxhzyYE5J1AO?=
	=?us-ascii?Q?V66BN/AinaTGiI4DYO6BlV8B8uPv3yFH+t2ZTbYL1VDw/yPwoIjY4q7HSfO3?=
	=?us-ascii?Q?mhgNgI3gQxRkLv4El2vnykkI2cGUNSR8Uf40vjc3nhkKfghCD8gafek2oQ8l?=
	=?us-ascii?Q?ohHC21Astji6UYHMRTpW+Bat5o3f9vKJ+crwoCoEMnBmkCoTl76CSdC2aWm8?=
	=?us-ascii?Q?QLAYfw7o5n/T+PhNjjGj0NMJ7/DGmmZ219RqAwMwPAwkkPfNDQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7dc80ce-b0df-4026-bc19-08d91c1661ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 05:07:50.2164 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pPgMXU/k4F88jgbW82npc6LwNE9NlQyPaw7WTHuEFGx8z8oQawDD+eIMsH1VdI7b+WovpX76WXA0g0DohbN2sL7/TMOpAmFoiNKDeTWGHQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7687
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14L580rJ023658
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 11/11] dm crypt: Fix zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
https://listman.redhat.com/mailman/listinfo/dm-devel

