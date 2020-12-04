Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CCBC4361A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:25:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B31822513
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:25:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B31822513
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-8cdvs3b4Pxmr-ekGblbnOw-1; Thu, 03 Dec 2020 22:25:41 -0500
X-MC-Unique: 8cdvs3b4Pxmr-ekGblbnOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13FBB803625;
	Fri,  4 Dec 2020 03:25:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F9F51A4D0;
	Fri,  4 Dec 2020 03:25:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 067304A7C6;
	Fri,  4 Dec 2020 03:25:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B43PMSB011587 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 22:25:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 601FB10D1783; Fri,  4 Dec 2020 03:25:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AF5210D1782
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:25:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 129588007D9
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:25:20 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-576-W_gCFCkJPxKRS9MIIUkILQ-1; Thu, 03 Dec 2020 22:25:17 -0500
X-MC-Unique: W_gCFCkJPxKRS9MIIUkILQ-1
IronPort-SDR: 6TGqd9cAtoI0X0rqu4rpcy2W49ELch59T+vmvjtopV+C/V0Slpm+T3P4KQrfcqaDoPWnVBV1UX
	8+9xOmuAevHhXQBtAMs19alemOboOvwW/4MVfYNZgNRSL/dc+7avcOOUc3/GAdwkQWg1a4kQBW
	ulcz9ZIB1YEPtudBaSNWWP0510bnfS2DnbmAm7AfiLwlFtJNEJ+yIJ+Iht7g6790BgagE2KOdo
	dEMbPI7UbxdiguL8+OB+zCcl93s/DrqRLSGJWTW/eYuj3MxxuM5LmGmSMtB/Otxf/cSMNr4wYQ
	DV0=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; d="scan'208";a="158871639"
Received: from mail-cys01nam02lp2052.outbound.protection.outlook.com (HELO
	NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.52])
	by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:25:16 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Fri, 4 Dec 2020 03:25:15 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031;
	Fri, 4 Dec 2020 03:25:15 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 1/5] block: remove the unused block_sleeprq tracepoint
Thread-Index: AQHWyZDC35x3z2bn6UGINOM1pHH38A==
Date: Fri, 4 Dec 2020 03:25:15 +0000
Message-ID: <BYAPR04MB4965C0AF4B7461309062FD6186F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cb39fcb0-b1eb-492b-9beb-08d8980437a4
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123671F1214CC854F1B554586F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:901
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Yb4iqdoIqWnojrHlcMuIADml8F6IiLKFSLGoIihyLkEFFg08Jpo5JzUgqgukjXh7HNuMmyNaxYCJZF/agR424dUdG9FSQdh8KiLak0gwhPoG3Qh/pABLsCoZjp1Fi/+9ZHTYjLN/TnY/Lvp78+rxZnVXBMb/F3d21/wbbDyhaexHWuyTSnuLVdZvPJSvJKhGyDqTy9T5KxRRyPasx+VoFXSr5RXhDqdrOcGrC+4k2RU8X9F16cGnM0qBF1HJ7t0BVVRgBsS9H/Mq4Upi/kc/3C1PEFhwQdOicaTnQ4mAUJ0Nq8+tBAyeWihV7OfDK/d9hFWYCcaHoFZ+JOnnt0+2MA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4744005)(4326008)(54906003)(316002)(110136005)(26005)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PG+wyrnBE/vHz/CUfpCUYs+lj1LPsqrBMOMkT2EK7wkl5UwykT7+aiG/Addm?=
	=?us-ascii?Q?U5bVBanNe5hK65DCWrVVCDfEYlwbHwrmCTsyD5d00TZGmy305kZhEJLnuiwa?=
	=?us-ascii?Q?DnaTuq3PhGRY27wGgPt55POvu0PUa2kc+rxTFa/FMqI/7Ty5lt416ZP3x51i?=
	=?us-ascii?Q?EbQIshE6HnKhnAbYeJwucAav7nnJLwA2cwovgLDuGMXMGUq1T4AdgsO6s2MM?=
	=?us-ascii?Q?E6ejjosqMb4V0rdKRjeu7ffoeyKE00m84rJ7xKkD0qgwVL0gnFezSgmJIafJ?=
	=?us-ascii?Q?a3g0mxj/KcDGvLjOEOvzkviiAHBiun5msx7HvxiPKqrv3E/q8GhS/5CtmcwI?=
	=?us-ascii?Q?RRI7E4nTlUw4qPnrBju/YdNv/L2+devfBWV3mCi8l0DuWW0V/eZWbH2vt3Zy?=
	=?us-ascii?Q?z5WeLAHxU4daSkEloI81eVn/zHDONrkZA44PQCWJ/BB7A/+Y0oo6HKEBawG+?=
	=?us-ascii?Q?Vyomulbbo4FzQl64UmS0+JWoBlfILF87GrEqOUH5uy+2aFKYMN1zRtsxQNZp?=
	=?us-ascii?Q?2FlSuUeiM8KN3cVXDj3/ff58HrW1x2GkI/zre4YhBwuuc0yaNYnxlEn+3q3E?=
	=?us-ascii?Q?W0joT88bzAmBkp6LpO3XDUPCmRnCB7f9ySzYEI9/yJI+DZ5xh6wsLhNnIFZ5?=
	=?us-ascii?Q?CkppSSSQTVL/Oi1lB/wBOgvUeUytaVDKREZnJQgWeaziHQx23k71Gsf76uH7?=
	=?us-ascii?Q?VkzsBmtwVxb9G4abaiS8IXtxxsWJy/+ieCcHrQiszz5gXOoRriVx3GHystXU?=
	=?us-ascii?Q?arKkRDexY5eNnCdIAKoiwjA6GSjKZMle7BER0uwUMO+OZeeGMbcYxEBaxqCa?=
	=?us-ascii?Q?jHNhH4SITe8pFLTi5kWNbfMQ/3WvoGc/kq9KxnyhCqvPh6ceyRxOrdXCVtIx?=
	=?us-ascii?Q?OxwVGonbEKPhJKXdI5bGU2tRMEbB2vwcvqiNSCwKFuemM/mdneHb1262Nqrc?=
	=?us-ascii?Q?TLh1q0ypEEMuM/1I+SN+2Z2aj0tCA9FEMeVlHv9y9ANxxWTK0nrCfYGmJptl?=
	=?us-ascii?Q?sIwn?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb39fcb0-b1eb-492b-9beb-08d8980437a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:25:15.3031 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fjwqt6qsefY0V+LSrT+gbch7JJEWoXDsqdVq041pnYaj2vsWGuGRR3cbJ7/HrbCGyl+cmedvCIkg4P7NDLT0Q40VhFUfnofxNBrEAY05pvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B43PMSB011587
X-loop: dm-devel@redhat.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 1/5] block: remove the unused block_sleeprq
	tracepoint
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

On 12/3/20 08:24, Christoph Hellwig wrote:
> The block_sleeprq tracepoint was only used by the legacy request code.
> Remove it now that the legacy request code is gone.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

