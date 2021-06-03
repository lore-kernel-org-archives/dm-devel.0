Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E418FC47093
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:07:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81016613EA
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:07:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81016613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-SG1D2-aaMXirph3lf3uMKg-1; Wed, 02 Jun 2021 20:07:49 -0400
X-MC-Unique: SG1D2-aaMXirph3lf3uMKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBBAD107ACE8;
	Thu,  3 Jun 2021 00:07:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9895060D06;
	Thu,  3 Jun 2021 00:07:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A58244A5B;
	Thu,  3 Jun 2021 00:07:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15305TPK011233 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 20:05:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 06910209A501; Thu,  3 Jun 2021 00:05:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01273209A505
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:05:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC85B185A79C
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:05:25 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-77-pB8U3qRrNBOaqe7uwsDNGQ-1; Wed, 02 Jun 2021 20:05:21 -0400
X-MC-Unique: pB8U3qRrNBOaqe7uwsDNGQ-1
IronPort-SDR: LTb6lWTZrT6MpXhNb90CXDWwwbXdwgf7gnlp3B+5NpeFnl49QaTVO9d3+JGjekYbIqFJqNeky8
	juc4HJiGdxwkVx3B4wM1UHFgwF0LrHxxv7K53bcl6FoPHgidfYHEXOuQseFdIBq7sRXaG15g/x
	FFmf8sTaug1JzxVrcRlIVLwuuHqI/kB6FgX9fPyc/7N++MoFutfUXVVlY3W7g7WDVKoJQx2kVY
	t4qy2LB5jXTo5H1YFdL7hIAgUZUiEEaLdVwLeUV/thdwRmAxTRqyS7wH4MZ6tqVc1WqBmygTgV
	W0I=
X-IronPort-AV: E=Sophos;i="5.83,244,1616428800"; d="scan'208";a="274374650"
Received: from mail-dm6nam08lp2041.outbound.protection.outlook.com (HELO
	NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.41])
	by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2021 08:03:11 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4327.namprd04.prod.outlook.com (2603:10b6:a02:ff::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22;
	Thu, 3 Jun 2021 00:03:11 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4173.034;
	Thu, 3 Jun 2021 00:03:11 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 03/30] blk-mq: add the blk_mq_alloc_disk APIs
Thread-Index: AQHXV3wpg+GpGHxRB0OZy0BgL2WPKw==
Date: Thu, 3 Jun 2021 00:03:11 +0000
Message-ID: <BYAPR04MB49653D1B88ADA8EDEAA88F82863C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210602065345.355274-1-hch@lst.de>
	<20210602065345.355274-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a35b10a6-7fc6-40a1-0ea7-08d92622f9fc
x-ms-traffictypediagnostic: BYAPR04MB4327:
x-microsoft-antispam-prvs: <BYAPR04MB43277DCC98ED185FAD050823863C9@BYAPR04MB4327.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KUrktxVP+HJoyFo+Xhee5NaJZPcQWKKjnb74IsZAcSkgfCH6+h+NTgHgkMgXC+hwOuSG/i1IhPYyYKCsv77QSzV9Hhxn7pe0x68SgN+2AzX3rRjWTDe9DRIvSVanF8X2xHqtALAvdDy2ycNLQAQoEkxScFxhheG3qy2xYatcVn6IbXsDKKAIG5ch3PISks8XZ49m15svn5lR1L6k0UcaE0ycDI0tDr91fCMwL+cPaxDOeJN/vwOHF2ADWiJKkoY8c5CBW/PWmwsBeBB0VkYtMlLQQ1hmkLTPjrtDolAW6VfrTCTDF2yt4ozSc8pKBlk/zi/Rh8Duc7FPDk5ZnwFGOcWpoEY9n6EOaOUGel8w8s3sl6uLcHqUsE7U0x1awfu146GXHfAOXix9XA4Ve7vp3YoNmEOcFHKlnNutlWKIeC+QaMcQCbCeWWqsTdYr6gCst4hOWYrX5P6gHlnSOKMSL0IFN4Yhk4jyqWIJJQ5rCFeQsOY9CyxnpmXPC8mOPTbs5r38pDAUOey+TbzObDC/i5Tvq5iaasgO1B3U6i91LO49JWmhUV1c5QVDRHx9b7qQiQFSjbyDtMcJj4BWIjcfbnE8Chv2pWlZYEXBqq5W2tI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(33656002)(5660300002)(4326008)(4744005)(76116006)(71200400001)(478600001)(26005)(54906003)(110136005)(7696005)(86362001)(83380400001)(6506007)(53546011)(316002)(66446008)(66946007)(8676002)(7416002)(2906002)(8936002)(55016002)(38100700002)(9686003)(52536014)(186003)(66476007)(64756008)(122000001)(7406005)(66556008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?ynVliGDQxRvrJcMGRyYPK/j4RBDB/47O8t3S1ZBmmqi+OJl5cSFj36BpMo?=
	=?iso-8859-1?Q?duRdXwb92TxF9zCA2J+P5WyYYWJRZ7m7yKAAdRJ3hNHdIUhx62prWbAllO?=
	=?iso-8859-1?Q?5RzOYlHsmxLJg+MygW/Kw2A/GTRNKk77DPVvAMNbZV8oZOyETasQ16Od6c?=
	=?iso-8859-1?Q?4ZCVwGDu8x2CQ3QzJNsJLqvcxCM0cPdTuqouzX4I1Pio3tR5HNBGqfPCNR?=
	=?iso-8859-1?Q?Z+IgWO+M5NixkHMYNj0aKB1Dc/wY/3iHguuMp3vnUD+EAHjKVDTyCfVw8l?=
	=?iso-8859-1?Q?wrJw0rM7eSMFx+/cl0Bkb3op9EgyVU8L7sB2nBNpzGNCPPbsQijJxXnh2q?=
	=?iso-8859-1?Q?xCV6e9qqdx9fqomwbQ7OALpxqS5/3BHu+fm9/8AtX5rxpM5ppAz6YMr6x9?=
	=?iso-8859-1?Q?YVJwy2YhgSW9FovzjveHt+0+Mlerhknec+EHSa+YIc592uuH55NgadlSg6?=
	=?iso-8859-1?Q?xwMh7eU5Ye4bQO6LgA29iZQcfT5UWTnWwhmwGcN2RQ4QMSsZP3lOWoE2Lw?=
	=?iso-8859-1?Q?/oa0c0LbzbVy+oZJZrQXC214a+1pSfA3J/oukxkCCVZy+ZJjIE24lzGvyl?=
	=?iso-8859-1?Q?NKMLX+J7hK0iRFLrla9gI3Y9pdma9MEQuOZjUGslMsZCMLvkeokcK5UexK?=
	=?iso-8859-1?Q?vhSvLlBfi0dzJ2fVNY7C9WtwNxgkrP9y4aEikHYXl/ex0027ccidERsazY?=
	=?iso-8859-1?Q?XmMV+SNP8XyGnSLmFS2Uoo1HZWXGa2Rp53DCkghI0cqmLT3ALHSlq/pWhr?=
	=?iso-8859-1?Q?edbuRICh9T840Rmq44qk0cphIGz6/CNJ0h5MGwL9m21dInIDnfM65GjhOG?=
	=?iso-8859-1?Q?hRprIHCj84jMb+2kEGnQnfyOJbRqCXxwVniBHSTsP+rcSl2hfOxYUupLcZ?=
	=?iso-8859-1?Q?yiZ3S2b91z8+tiP2Tx+o9UIeLNQdZuQyfl4Ki58ul5h8b4mWJ83xDPA8Dg?=
	=?iso-8859-1?Q?jgRQ8ivpRJWPx87Q54ZWRmVBanO8sRxhLtaWy/VAO4bP/1IEe3p2kjK8cI?=
	=?iso-8859-1?Q?N7eFSdRP+VZQsvFktJr/tEQhuHJZqIEy4hUZlMhxFBtj5rlHIGECM7zVi3?=
	=?iso-8859-1?Q?oYmOUS/rKmsGB53BS/h4yKaiTBh1hr/33nwKz88puhi8PIoJBHQwjgdbUY?=
	=?iso-8859-1?Q?jW8L/RcihUjfKP25UQVcyfUMWzVkZ5Wn6pd8QTiS4VyzI+V2/yRo8RSb+S?=
	=?iso-8859-1?Q?XEjy3TiONhDX9jH4u8CaJ37mbvIQsX+cnTOK5EgtJgH/gNotsknqrTZOtG?=
	=?iso-8859-1?Q?6vMjFlI+n66XU3uCAnAj+od+U/vfHAsUXH+K15iPWW8g+f9xg5MbrhK37J?=
	=?iso-8859-1?Q?OCpDLLKwXs4bpDw1i/lgQtxo5+UN2h7coueAuN0AcEhHfMP7bayfzpAEpr?=
	=?iso-8859-1?Q?XUuyds4AE6?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a35b10a6-7fc6-40a1-0ea7-08d92622f9fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 00:03:11.2016 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RDjWAyq6BnuphswWhaa7UCiHTzD/aNrldhcDCrmF+sKsMkcPX6G37kEVI5ch879ou5meUtnrLy6SEuld6NLqkNrrCFzCbDYRgIMVPMUYv2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4327
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15305TPK011233
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
Subject: Re: [dm-devel] [PATCH 03/30] blk-mq: add the blk_mq_alloc_disk APIs
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/1/21 23:54, Christoph Hellwig wrote:
> Add a new API to allocate a gendisk including the request_queue for use
> with blk-mq based drivers.  This is to avoid boilerplate code in drivers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This would be a nice API to get rid of the couple initialization
calls and respective error handling in each blk-mq based drivers.

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

