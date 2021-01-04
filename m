Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 956C2C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 12:16:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0630221E92
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 12:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0630221E92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-w7yrn1fBMGSo-HaWwoH0Og-1; Mon, 04 Jan 2021 07:16:01 -0500
X-MC-Unique: w7yrn1fBMGSo-HaWwoH0Og-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7BF110054FF;
	Mon,  4 Jan 2021 12:15:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E89301042A84;
	Mon,  4 Jan 2021 12:15:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7BEC8180954D;
	Mon,  4 Jan 2021 12:15:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104CFoNw009853 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 07:15:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5835F2026D48; Mon,  4 Jan 2021 12:15:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 523EA2026D47
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 12:15:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB9BB800198
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 12:15:47 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-474-UeP0M-BAN4CPBBRJtz3S_A-1; Mon, 04 Jan 2021 07:15:44 -0500
X-MC-Unique: UeP0M-BAN4CPBBRJtz3S_A-1
IronPort-SDR: RtKuc2ZuyZbVaNzupwE5PvyxCmLuU+WI2L6U0+9+IabClFjlbyF/Q6+DYm1vREmezSOjq9XFvN
	WWUbGWCP7K+gm0vGpm2O54+GAdqaIyH7blyHachelioPSiCnqI/ypq9zfaSfJ8LlwXItun4tgD
	1XDxykqRX6zTR6g/z8vdfUFY82o2FV8lF9CBbcOrRTcC+wERkGsloNq8IkyV9I+UJncSNcjNt6
	JD7g5V+7RNVT6+jTvknojAL+t7QO7DJky1g6AzPhjD6Ta2hpqvlRgS+kpdDc3CbczDcOI33CjR
	pcU=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; d="scan'208";a="156456899"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO
	NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
	by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 20:15:40 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6734.namprd04.prod.outlook.com (2603:10b6:208:1eb::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20;
	Mon, 4 Jan 2021 12:15:38 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::2dbb:7e01:f076:eca0%9]) with mapi id 15.20.3721.024;
	Mon, 4 Jan 2021 12:15:38 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: SelvaKumar S <selvakuma.s1@samsung.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>
Thread-Topic: [RFC PATCH v4 1/3] block: export bio_map_kern()
Thread-Index: AQHW4ocU0RUveu4eRki+HX4FIJ17pA==
Date: Mon, 4 Jan 2021 12:15:38 +0000
Message-ID: <BL0PR04MB6514554D569AC302850BA1DDE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
	<CGME20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7@epcas5p2.samsung.com>
	<20210104104159.74236-2-selvakuma.s1@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:4d2:96cc:b27d:4f9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a49498b1-7384-462e-4cd4-08d8b0aa72af
x-ms-traffictypediagnostic: MN2PR04MB6734:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB67344E16F859876580EE0C87E7D20@MN2PR04MB6734.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: mcvD+SBwh3dbOi0uVo6OBPyUWb6hnneXAv8JpqB1brob1ZQs8aRj3iGEtRRVqHenVb+8MR28qwcOPUiFaNkNoU/kN82hA+dH+LKH1JLyLeEcNp4NwyUvj+OfU6t0oh2m1pWTrFO1ote4OhjArx1V+IPnsHcbCGhZ9Ldg/2dWy4ekjhcA5TfGgGHrClNa9LIAlXfOKRqod9seiJnJ4zkTnSi8xKIPdbemDzNmvw9Po3bMl/nAMNlRORiOAhvdf3ClqzSq1OQPlWHikuosJgxvJv8tXFOyO1qMkktrnx71W5x7hNuiuVEXttZ6sb+2Jz/yk4q4A3/giRqoVdkk1zCVRllbvvQtDRrpyeL5d9/g6/81g4MpR99E6FdZC2TNGbYdcdbG8iaBS+YqV8Gs3CUCmw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(52536014)(55016002)(9686003)(53546011)(7696005)(33656002)(4326008)(83380400001)(8936002)(71200400001)(6506007)(5660300002)(316002)(186003)(64756008)(66476007)(66556008)(110136005)(66946007)(91956017)(76116006)(54906003)(86362001)(478600001)(2906002)(66446008)(7416002)(8676002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6wfQL0CEuknbUUvXyIZHzKIh5IsLibPQ3+gAPFVG+oOTe6ZAXQx0pS5XdmGX?=
	=?us-ascii?Q?vPrXieaJsI6ntfeTQx5kZiVguM3alj0U2StYNW10qWXi5GzDYYL1scGN3xPl?=
	=?us-ascii?Q?uWXuJ+CqpAhT7KgwQV1a3Ed3Y/ck2SHj6i6U2AQ4Tw5ukIKpmO79JdsS4kax?=
	=?us-ascii?Q?28Ts6U8pBbxvAsrKuUytgjDKz8BjCll4KQmoXyd74SKPKBsnzQPCTbwvP/z2?=
	=?us-ascii?Q?pEBec0uM+bmSPAcVrkjb0OCRb3h7j3x+BecpCB6WzHocnVQCLcnhHnCyhaPY?=
	=?us-ascii?Q?Ml74hGxshtR5WeunMO98Es8dtXGFStrwjlL27AP97ZzKl//GvQB4C63trV0g?=
	=?us-ascii?Q?ozffo2VaNu4kF5DXBxKcyByiTXo+veUlUYly2EiJNhuM10dsvBQt72YYP2yn?=
	=?us-ascii?Q?dXS6l/uQzFpDE2LuLFFO95eMWCUZ+mlXY8paIjzNCOmAgkEa3rcTJyKgJs9x?=
	=?us-ascii?Q?6MvcOKvZuZVtyRc0N6AiEqXyC/d1hTHTJ/T3vtyRWkSF2NtB3mRR7RJtwnTX?=
	=?us-ascii?Q?KshPFC77LyteuG/qB2X9pUguW5LtFcHAQ+WmU2kUIaNke5SCTTjezFSHbVIG?=
	=?us-ascii?Q?7X53rgnfG8CpC4eWAnZ9tYQqqhjw+l6INiqlP6OgVMdoQfPdT7CWePBfPUOn?=
	=?us-ascii?Q?yz0WtNMr6ptfuJ4AWDKHP4QrEkkQW8G1Q0wFzeTPIvjmAIttkB+4nKgbK//i?=
	=?us-ascii?Q?BOVO52E8PAprla+GvsG6cUYYmqEJ3jc2DFBDIkTJIJo6G6pCLxpdlIhVbOJx?=
	=?us-ascii?Q?gWBSYtKLh6RK79wjhfFrjCdL0KDnboFyLn/G+JAvGGNe89wC3+hAP9gJIf28?=
	=?us-ascii?Q?UJoFlM4WlHkevAKOF1DhvllvQZoENexDfbf499DIc8LYzz6M7YYc9L1ZPYAA?=
	=?us-ascii?Q?j1e/XQbgQBST/vexFgXIxPpzjm7dVPUjEVN2/xrFcsj/C4RqQWqxImI/RtOf?=
	=?us-ascii?Q?/2jkiC30454NQcOA817tt6S7w3cTEdLxaEyla/+SnsZGD+cxL1nCOl64FvZH?=
	=?us-ascii?Q?2GWyvCzHk6xeURLmxxbjM4BMmALVL+i6gz/J5i7coTx+eXq5NaK8GoFf3a8R?=
	=?us-ascii?Q?jgZqFFSY?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a49498b1-7384-462e-4cd4-08d8b0aa72af
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2021 12:15:38.7059 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hSKz19corPi6dlFsrZTAHchb8Q42ljd+SX9gHASSKK0d857v0S5cGcdfRYz36/sqzDeihc0wqa1mlz+IWMCBcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6734
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 104CFoNw009853
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v4 1/3] block: export bio_map_kern()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/04 19:48, SelvaKumar S wrote:
> Export bio_map_kern() so that copy offload emulation can use
> it to add vmalloced memory to bio.
> 
> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> ---
>  block/blk-map.c        | 3 ++-
>  include/linux/blkdev.h | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 21630dccac62..50d61475bb68 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -378,7 +378,7 @@ static void bio_map_kern_endio(struct bio *bio)
>   *	Map the kernel address into a bio suitable for io to a block
>   *	device. Returns an error pointer in case of error.
>   */
> -static struct bio *bio_map_kern(struct request_queue *q, void *data,
> +struct bio *bio_map_kern(struct request_queue *q, void *data,
>  		unsigned int len, gfp_t gfp_mask)
>  {
>  	unsigned long kaddr = (unsigned long)data;
> @@ -428,6 +428,7 @@ static struct bio *bio_map_kern(struct request_queue *q, void *data,
>  	bio->bi_end_io = bio_map_kern_endio;
>  	return bio;
>  }
> +EXPORT_SYMBOL(bio_map_kern);

Simple copy support is a block layer code, so you I do not think you need this.
You only need to remove the static declaration of the function.

>  
>  static void bio_copy_kern_endio(struct bio *bio)
>  {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 070de09425ad..81f9e7bec16c 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -936,6 +936,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
>  			   struct rq_map_data *, void __user *, unsigned long,
>  			   gfp_t);
>  extern int blk_rq_unmap_user(struct bio *);
> +extern struct bio *bio_map_kern(struct request_queue *q, void *data,
> +				unsigned int len, gfp_t gfp_mask);
>  extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
>  extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
>  			       struct rq_map_data *, const struct iov_iter *,
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

