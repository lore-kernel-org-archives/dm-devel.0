Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917DFC47083
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:07:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 15851613BF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15851613BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-YRyy-598Nr-3jXYoP1GZrw-1; Wed, 02 Jun 2021 20:07:44 -0400
X-MC-Unique: YRyy-598Nr-3jXYoP1GZrw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 153B2803626;
	Thu,  3 Jun 2021 00:07:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D35CF100760F;
	Thu,  3 Jun 2021 00:07:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9123238395;
	Thu,  3 Jun 2021 00:07:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15304qPE011174 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 20:04:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8EAA621EE56F; Thu,  3 Jun 2021 00:04:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 888FB21EE571
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:04:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6AB7802A5E
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:04:49 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-271-lsXKzPafObyhvE-ruzhAeQ-1; Wed, 02 Jun 2021 20:04:45 -0400
X-MC-Unique: lsXKzPafObyhvE-ruzhAeQ-1
IronPort-SDR: ebw43mH2wu2FVzDe3CjkBzn4Ei7G+EjMxL1XQCiLGvLghtxtAihVBK60Ry4k6dJZoGvWftqxQx
	JOxIS3UCpRN2nS4HH4Wm62h5r/EXDr2IleQUWCOCR/JGpCBywEbCpx/GYC9uZQTvIzMAY/7JSH
	sPxA5KUAkpdsPbOLkpRJC2kmm7YhOtUaHvJAMReu8KGWbm59+VPjQl1w6dFeYukHysBBSKN2Ve
	8tYhz5vOkifIjUqABb5q55MhEGp3sZwGNZ6DgKlv6nCCuBkSJ9uc0nsucgyRpJuUIvp3lIHZjf
	jfg=
X-IronPort-AV: E=Sophos;i="5.83,244,1616428800"; d="scan'208";a="169781069"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
	by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2021 08:04:41 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4327.namprd04.prod.outlook.com (2603:10b6:a02:ff::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22;
	Thu, 3 Jun 2021 00:04:40 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4173.034;
	Thu, 3 Jun 2021 00:04:40 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 15/30] blk-mq: remove blk_mq_init_sq_queue
Thread-Index: AQHXV3xQMWTzcORnaU+ja3Jg+8O85A==
Date: Thu, 3 Jun 2021 00:04:40 +0000
Message-ID: <BYAPR04MB49655D481F62EC6B18851664863C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210602065345.355274-1-hch@lst.de>
	<20210602065345.355274-16-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bfcc48e-3abd-4db8-6f0e-08d926232f0a
x-ms-traffictypediagnostic: BYAPR04MB4327:
x-microsoft-antispam-prvs: <BYAPR04MB432747C9EA426342BA62CB17863C9@BYAPR04MB4327.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:264
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: OwlTDekL7hwVlX3yba8Ek1cv4FkIZ+J/j/U7PpRxk3Z6zrPfxqaRQ/6AiAWI6itDIedVIjJ4P/W6bUX39lZ2ip5zMIJKqh/05UJFiYDK0MHvhs3zwpQfoEuMcStyuc+BhYT3uhZsYNCV5TRGsPl1mVdrHDJHNUK/lnYUVaNq18zgAKrkZgWciffi+4Ct4NP+FrvuKJBY09IU/uEQS7jNKhjCPUomKvV4IDaGxtSLwTxeAClzhi4eQiw0GPVya7qEaQM/q/ln+bNXhz/29w0KskRN8mdsz1KsHZK5Wi7y9lhhkhJxVlIpGkSQQi1C/wH9xLSHMVY/czRUmhemuQgI9mrZwrqEYSxFRBZqYF9nBuYYojd5+NfTx96l5e8yF1s1RLlX/9qJOVMIHDexCFN+i31dlDA7DF0dmZ2/iCAPgohvaeWovxNq4Rs8fLhuGKQZRGCJImFLnh1O6su/FnWQpmXnnZG2pvixy+xVS9twADWMTZjrp+bazYZMMY9QOvtp8cHrJEmOs3NgxMOurOKVxCnY+S08l+wpqukQTwR+6u4/Fs7Q3dxoc5sjB5wMCN76ZDTbK5jXcT2Ri36g36QMsPSeemPqnZuApkpWXEteLkc=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(33656002)(5660300002)(4326008)(76116006)(71200400001)(478600001)(26005)(558084003)(54906003)(110136005)(7696005)(86362001)(6506007)(53546011)(316002)(66446008)(66946007)(8676002)(7416002)(2906002)(8936002)(55016002)(38100700002)(9686003)(52536014)(186003)(66476007)(64756008)(122000001)(7406005)(66556008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?sXBdSKO61Lf02B48FKieGFHblhseRbF1S8+N01teottA2vv4FPCBtM2yB9?=
	=?iso-8859-1?Q?XuUTpza0ekK5nusUHt5kCqfwFN2O5ZfWqhm/HvpU5wbrVuAM6CRKSv1Q8o?=
	=?iso-8859-1?Q?493jUsBfFTaybWgE3BvjmA6N1jgye1ieRrBSOhD5nIzKRyFhegA+arODHA?=
	=?iso-8859-1?Q?FlH2T0XVxASIf6HpXWyyUjimqoacoHO43o+zvqgY9LAMiLl6sZTx5ykxLI?=
	=?iso-8859-1?Q?9toJguC0kpLfGurgmQOEsXj0AoM56Q+PN9b0PMkSX2Q1c8ScDaODM/7SBE?=
	=?iso-8859-1?Q?8PTOuPFzV+yaoiBD8f80N7tu7GhurIw3pG7Bg9AFQGYDhQD2WU26b58w2I?=
	=?iso-8859-1?Q?Gv3dw8qEAzgviFHj13iNNw4xEqq2tRmkz3QVUXXytYrXqVEafD+G9VJqbB?=
	=?iso-8859-1?Q?s52QR5HjBEj5lGencIoh5Cl6NhjU4kNoZinCLbd9EjobJvldk5IsU5W0v7?=
	=?iso-8859-1?Q?g7VIGxQMLLy+r1hAQPlEcRk2Wg1fhSDZktBP3O0h06bevoCyqvJozek6BP?=
	=?iso-8859-1?Q?6LAuU3XD9WVsw2mscsTfLxgIaSIt61R4l0ZA1+zhETsef7TZJ2DNPYoU9I?=
	=?iso-8859-1?Q?FFOknBNl7/2GAJunTPtDmm4XfaUNWAlnBmcy60CWi6KAWSJ5SZSPuADbyr?=
	=?iso-8859-1?Q?SNSZpjVZoL19+6Nr814QO2QrDqrd+dqS9rsKQeA7YOBvI7lQ0pMsM/XzGA?=
	=?iso-8859-1?Q?8pXBgAk7nzszU9rWKNVit7794Fq1L3m2LgiQnipR3sVfjrDHZft59UCLn+?=
	=?iso-8859-1?Q?fy53ydFRCfRjXgZ3RP/S3WJKMlOYT7n82HMEwGJinb/62Bf6SEa32rvTRa?=
	=?iso-8859-1?Q?FTwCf5r1mrCWYpqg4FwfMxekYF3n+eFwNBx0KrzUtYQd2mPslvonATonaq?=
	=?iso-8859-1?Q?C4IPG+mOSIQ81l3txem1E+R3J1wqtctKPY78n8yzz/Oq8OSwmwsOhok0NX?=
	=?iso-8859-1?Q?zdSnsADCpPu7b8GWyo5qAbD0EqGLRaEK+xJ0gRau6IveMgKPfeq0sc9Gc0?=
	=?iso-8859-1?Q?gI6LxtYoLRuSYQq6eHsUVCLBkWI5ovkh1UD8wFwszHN1qDKKxAnUXO1FP+?=
	=?iso-8859-1?Q?WxWMRPNwY+4YLTuI7AowSIZ1cdWwy5/WFsVaQ6i4PJUYE82JiEYOt+DbnV?=
	=?iso-8859-1?Q?ssV0J3WQW1yxgCaVSMpmWTxHoP6ixIG+fQ/CNfSM2Az13sEt8eC0ifz5Mu?=
	=?iso-8859-1?Q?kYX/IW2WXIstjvnGTqmoxxnjCKrBiBfsTBewNwain3nS5c6Kl5irUNkpug?=
	=?iso-8859-1?Q?xXIiDzf7Crei3NiCtcPCOKUhQoIDYvZryCIcOZfJ4ZF6lM+w/EIVOrZc09?=
	=?iso-8859-1?Q?Ilaz4K/hgpGq0m7v1MG+JZzmQarf8efzkXl7zSU1311foEViZpmHCaX4If?=
	=?iso-8859-1?Q?mTD76Vxg88?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bfcc48e-3abd-4db8-6f0e-08d926232f0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 00:04:40.1871 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PssMItytFcPuGJZL4oAW8jZKgJiD9CYlBtcjsvIe6eLx9/MAyQgmZKucAPLHbZG6UuQiJ2t+88piZpNQvn93QypCEVRt8ai9TDU7EOe+9+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4327
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15304qPE011174
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S.
	Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, Geoff, Konrad, "Md. Haris
	Iqbal" <haris.iqbal@ionos.com>, Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Richard Weinberger <richard@nod.at>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	Ilya Dryomov <idryomov@gmail.com>, Gorbik <gor@linux.ibm.com>,
	Alex Dubov <oakad@yahoo.com>, Wilk <konrad.wilk@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Denis Efremov <efremov@linux.com>,
	"nbd@other.debian.org" <nbd@other.debian.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Vasily,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	Levand <geoff@infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Vignesh,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	=?iso-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 15/30] blk-mq: remove blk_mq_init_sq_queue
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

On 6/1/21 23:55, Christoph Hellwig wrote:
> All users are gone now.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

