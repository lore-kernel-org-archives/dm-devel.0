Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA92AC47082
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 02:25:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 63AA061132
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 02:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63AA061132
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-_8hrJ_T0PMiJds8jPdVlog-1; Sun, 23 May 2021 22:25:00 -0400
X-MC-Unique: _8hrJ_T0PMiJds8jPdVlog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80922101371E;
	Mon, 24 May 2021 02:24:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 312276E6F9;
	Mon, 24 May 2021 02:24:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B96F55356;
	Mon, 24 May 2021 02:24:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14O2Oqwc022236 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 May 2021 22:24:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D24A2112CA2E; Mon, 24 May 2021 02:24:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC9BA112CA2C
	for <dm-devel@redhat.com>; Mon, 24 May 2021 02:24:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DCD28007AC
	for <dm-devel@redhat.com>; Mon, 24 May 2021 02:24:48 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-350-eh-kxYu_OqWfkIZSrP4QMw-1; Sun, 23 May 2021 22:24:44 -0400
X-MC-Unique: eh-kxYu_OqWfkIZSrP4QMw-1
IronPort-SDR: 6f7TDbGVGnlffZ3W53gqyHxNVyx+OpVH6/X5l4y68p2zfIvxS3B60VmxQpYGEZUyQB5sTzjz5D
	pMK5CwbaqCsPCDOVUlDS8NHjwsSwNUq8Nh0kg0NDH7z8n7EcwWiaRWzjCknBJX3RoGI1Tkc+fo
	xyozfNJlVWyIA7SOukImxjAy0pt8DSXD+lmUwpAhz2waw5dRcs5d1ho/KuDGdAVVnPs+NXRXpR
	ECzWtSCokc3mHdL/mTJb4AkI0amqzljqUE6pYAc25haEQuUlGc9NETy0064RIlU9YlLykgQA6o
	zjw=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; d="scan'208";a="169192667"
Received: from mail-bn1nam07lp2045.outbound.protection.outlook.com (HELO
	NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.45])
	by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 10:24:42 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4229.namprd04.prod.outlook.com (2603:10b6:a02:f5::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Mon, 24 May 2021 02:24:42 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4150.027;
	Mon, 24 May 2021 02:24:41 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v3 03/11] block: introduce BIO_ZONE_WRITE_LOCKED bio flag
Thread-Index: AQHXTe2ZDmA1EJRz1Eeaai5icAjieA==
Date: Mon, 24 May 2021 02:24:41 +0000
Message-ID: <BYAPR04MB4965C7A1458171847AD1CC8986269@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
	<20210521030119.1209035-4-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59bec431-8d96-4334-5dfe-08d91e5b169b
x-ms-traffictypediagnostic: BYAPR04MB4229:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB42293ADB24E4B6A1D47306CC86269@BYAPR04MB4229.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: o12VGXRXgqspH44hjnW7kItAMTxA+zDyklgOwXMaKMoys6cwdrlt32EWNuNf2NZZaRwuRtgs2T5C2Tp874UMO6sn863w44c/H4CwDMJPNyo4ORxxm+t/CQCmY0FwtK4ZCWsKJ40XA2Okx/ZO7YaueOsZ9ptKhhf86CAMhzbAYR7uxTiMV5wQKTlAs0TzsNGk/7RURGAByGqJOP3qZJSjbSo/5/9BtIj5vIVR0Rx38ibB4VNBBEbyEtfyi8yZi0kGr7qK9elZ1/cspuZQr3iuHkzabqcpeRA4rL3F11jMvIwN+ECQuEuCti3wvVVL1a/KOHdFbqmLscXS6s+8wQMPOCN/9iZylzI3TsLtlpblH05zWeaaetehLd68MnraSf6LZc/fRVqI0bXDGJ2s6hxzNUWeH+W3lRVr1x+ROD806+HP6glpFfgdDf4IQFM7/87xc3A17158Qz1oYONiDU+SW6ZkGbnZg08SSCsRh30XgD95MTOyvvWkbcdmYaEDuk1Ta8RKQEsUiTqxxTrfXb9aGsTxdfnliZYQKnxuh8xg0quBSkcs8DYkAvG+Xs4DnXO4KXCMU7KIJGctsT8EDk9Y6o5k6IboF5jBn/jXe+rbl6fcOjE/Y+JC1FXVC9l2subzROWGCooKyF9TIIKraLQWjw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(6506007)(53546011)(83380400001)(55016002)(110136005)(186003)(8936002)(8676002)(478600001)(316002)(66556008)(52536014)(86362001)(26005)(7696005)(71200400001)(33656002)(76116006)(66946007)(66476007)(64756008)(66446008)(5660300002)(38100700002)(4744005)(9686003)(2906002)(122000001)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JYJIevQGRXkZY4mNFZdBrAxLh8T12Rgo1Dh53t2/K66dAG/avnEtmF+w8FDt?=
	=?us-ascii?Q?n+DCgj8ESohQ+iPPpY3PqJK2sgQxM0mi0OTwqr8OPpTVQErfvmj0PtPKElPC?=
	=?us-ascii?Q?Bfgr2GpeJAYUbCTEX0k1fqVphUbT9wke41OLWAYkWIAY0ikX6JaGhJ8h5zES?=
	=?us-ascii?Q?P7p8Ff97VZprZ+DsDtbOmW+WGwf09ISq88Q2frFxjcSAUOTU9L2VpTOGQW4r?=
	=?us-ascii?Q?BlzmqWm9hTv53jD4u5hIJ581Qj6lFj/Jqkm0kQHAjNgqAEGFO4pNCyjW0p7Z?=
	=?us-ascii?Q?fp+dwjaQcfDjk4DW47dASy3EJLVFAuhClWBhiBhQ0aqatHCXhf0vj+jjzPEQ?=
	=?us-ascii?Q?BeZXYqGlEKEuBwZeIlXGI4HRjw7dBsT689ozuQ1AItB7SoK6itAA6z3UU7xX?=
	=?us-ascii?Q?V8tE1W78SQzcplxgQkXvrHjvzbKBjbl3r0pzN7Edqn9F7Rw3hhO5Wx46QuGJ?=
	=?us-ascii?Q?zHjWlgYOxjKePkr2X2ir15uRWv3XTpuF79F1STBJvSRJPr3wBFSMQW9avXdS?=
	=?us-ascii?Q?VQpItRUQIRPJbFzlr+b5IDt3SHU+JNf0AcMJpzv5OLjS006QJvbJfSJRx4xz?=
	=?us-ascii?Q?BgfqTgLzUuwC7giIjQv0hv2soxxXEbVMnpcAKZwgg/fFtQDjiOR8/yYuoUYL?=
	=?us-ascii?Q?3Y87pQL9v1KQ32Ztdd8tr7NwC1MVH7uzjqyhniM1KDDVel7k1/1slZCLkGw4?=
	=?us-ascii?Q?R+4dCxvGa0TDpGgX3uVy2tvi/yxGwzNGxOxLQ0BX3pFsd+hno1dvuuok9kSZ?=
	=?us-ascii?Q?E0+JZ2leYHbUC91CPQOKVwIBO4MMElFTBSJDmFhsaqkxBLZG12JTs8kkhbED?=
	=?us-ascii?Q?JWyuJZNXDE8McEeHPCl7rq9+OfF94qEFA0yECQaHebt9YwJQwB5v55ekHz3b?=
	=?us-ascii?Q?JPSnsCOFMa4/JkBGGeRIj6mhkZKeY9QYg9LxLIkKnzA8s7HG+7vctcHa/DD3?=
	=?us-ascii?Q?r7gT5HcL0zxoZ9P20/X7P+csJqMOcy/KyG4iPv4D2+NoKVYKA6ktlG1ZMuBC?=
	=?us-ascii?Q?GS7HRrdDZhhtOCRM+uEUcGct/NF+oXNYoDIjSnmxyC10iOixxkdYuGhomrjI?=
	=?us-ascii?Q?A2Pxl+V+ZgZ10970ilbI58mZf94/AsNT4nWjjZbrdTjOPA+DPda3Ce7Y6ebz?=
	=?us-ascii?Q?6eWBmcL2Ke0jA5vx8lMyRW2rTFMb6qEnCQ+eXPu+K7d0fX4gzZXT5d95flRc?=
	=?us-ascii?Q?GRO15NLhw6d9DG++njp+dI4d23+wEsGLQSnNx1OqULeg1J7O2UBCS5yCkRr3?=
	=?us-ascii?Q?AfNu0wZq7+zw0TyHmQJ1lqPsN1XVL2Zwy6ai6vRHOqprTpIyL66VYM8TTQBE?=
	=?us-ascii?Q?TI2ydDW0ms3o1xIlJJkGl2KK?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59bec431-8d96-4334-5dfe-08d91e5b169b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 02:24:41.8094 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RQLlBYWHcUf0Nb+wIsz+4bHeWcDJeZPnrSrJv/HwJWNHaQiasv2jZFcVjKaw/NDdHzXkfIKIgvor460tRefB0gMSYftTwt0vuI8FyVdma8c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4229
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14O2Oqwc022236
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 03/11] block: introduce
	BIO_ZONE_WRITE_LOCKED bio flag
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/20/21 20:01, Damien Le Moal wrote:
> Introduce the BIO flag BIO_ZONE_WRITE_LOCKED to indicate that a BIO owns
> the write lock of the zone it is targeting. This is the counterpart of
> the struct request flag RQF_ZONE_WRITE_LOCKED.
>
> This new BIO flag is reserved for now for zone write locking control
> for device mapper targets exposing a zoned block device. Since in this
> case, the lock flag must not be propagated to the struct request that
> will be used to process the BIO, a BIO private flag is used rather than
> changing the RQF_ZONE_WRITE_LOCKED request flag into a common REQ_XXX
> flag that could be used for both BIO and request. This avoids conflicts
> down the stack with the block IO scheduler zone write locking
> (in mq-deadline).
>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

