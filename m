Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88D1C47083
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:10:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 56097613E7
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56097613E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-Lxb6RhdDOkiS6HynRMwg5A-1; Wed, 02 Jun 2021 20:10:35 -0400
X-MC-Unique: Lxb6RhdDOkiS6HynRMwg5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FFA3101371F;
	Thu,  3 Jun 2021 00:10:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56F251383F;
	Thu,  3 Jun 2021 00:10:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA8A644A59;
	Thu,  3 Jun 2021 00:10:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1530ATUB011697 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Jun 2021 20:10:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 65576103793; Thu,  3 Jun 2021 00:10:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E35B1037B8
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:10:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40890101D220
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 00:10:25 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-423-p-bI2ZRfOdmjAJIP45Izcw-1; Wed, 02 Jun 2021 20:10:21 -0400
X-MC-Unique: p-bI2ZRfOdmjAJIP45Izcw-1
IronPort-SDR: ZmknQuXoCnqDkfa8f/gIpbwcqsW3uxFIdkG6PulXIRgvre/V1WSuqDOxsKpr7HB12BBnz5bTJF
	dpg6fDUUhyjirRV+af+X4alFqYTr5oUWRrXWqVj5ekEdtvmwVj+iPCU5w8TuqpEHShe0SuLgiL
	quXXMMlt2JVZSIA7aAtVVNAi8tyYF+2kfYxk/N6iv7SP/zPHjRDhX0CIr4+aYsc1qKQWQ2lLfF
	1pwuG0X1Xj5/5yCDRAXWwP39oIHSazLjYk9RroQcS6fksS9XrRo0mCaN9h0b4MGo5ClYyMYoxw
	/BM=
X-IronPort-AV: E=Sophos;i="5.83,244,1616428800"; d="scan'208";a="170510803"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
	by ob1.hgst.iphmx.com with ESMTP; 03 Jun 2021 08:10:11 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (52.135.233.89) by
	BYAPR04MB3861.namprd04.prod.outlook.com (52.135.214.33) with Microsoft
	SMTP
	Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4173.24; Thu, 3 Jun 2021 00:10:09 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4173.034;
	Thu, 3 Jun 2021 00:10:09 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH 20/30] nullb: use blk_mq_alloc_disk
Thread-Index: AQHXV3xgq8Qh2KPeAkCUNVGDF6BX9g==
Date: Thu, 3 Jun 2021 00:10:09 +0000
Message-ID: <BYAPR04MB4965DDD0F4479F5B492A30D2863C9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210602065345.355274-1-hch@lst.de>
	<20210602065345.355274-21-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 410c689a-bed7-4693-4767-08d92623f325
x-ms-traffictypediagnostic: BYAPR04MB3861:
x-microsoft-antispam-prvs: <BYAPR04MB3861AC0DB66ED1C3B922E6C3863C9@BYAPR04MB3861.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:431
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: aSCUd3+tO2dW2W0V3W+l+z6iJa3IoJNFdybg9gYTu9cedQ5lLVvPpm91O+dgVW8ql8UgQUxU6WWy+SnXx4hkRSkEbO+Bh9nDVmSGwmMOGkQ1nHjaRH0AmmcUwOEgU8PZj0bie3HHe1HkTiR9t6S8uH0KYFxKuxPIpGACKfziR9SdgoJQgLBMsLpbcl/XMriIfz/BZePIx+YXeYb0iTZg1zQtisRQ8BHOzvcW9ojTtcViOSd0wEtiPtkPj9ECItd8k4g/tUkuJBZ4Atf6k6pkELhctJZ8WJ42PKiGHu8LVUlUFVPDN2VXhagXLymt7dDZFFWHppkOKUONGWiIdwRpSsODUHoao48cLNskAR6ZEXegvXyqzYYouET3Q0OIYmUwslAg8gnSfVyx+RA2Rzpr2haw1NRfeR8epVcIitoaVUWk4+eJMy/yHTuFQy6ansUVygucOFjq4n5CAbUDWG6Ze00DEqPbx1sGyplv+rZCuJ3RE45DyM89gvL+b6fQ1xcV3jiGTFdg5yKmctnZmapwoPLqBzlIAqKUQandH72F1kQ2EMY5/mqgVQY/NPHh71VFoA/EQHV29oPgt9v0n+SjOM12CltqYJUFiycBsklsHDQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(6916009)(55016002)(9686003)(86362001)(52536014)(54906003)(8936002)(316002)(26005)(33656002)(122000001)(83380400001)(6506007)(7406005)(5660300002)(2906002)(66946007)(71200400001)(76116006)(4326008)(66556008)(66476007)(66446008)(64756008)(38100700002)(8676002)(7416002)(186003)(478600001)(7696005)(53546011);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?tOMRmQzBu9HBrmE54pFYwQCAZwjNFQViLIYp42OXhgbm6VKfnHeKq6ibJR?=
	=?iso-8859-1?Q?XVtDPmSP9FYrKIi5HErHCnz8ZolVYTOTq88vxqGNp5E8WT++gvcDXHWzfQ?=
	=?iso-8859-1?Q?7F22uB4d6Y7jZld1kooNlgaZuhcOZcWVK5jZsiQX+Vnu5A/I0GM6g6pXG/?=
	=?iso-8859-1?Q?fANsvMtPVZl4OWLL2+zaMRzi0z4pS0r4jQpoJHOglAaZtuCNoz9bScDYZd?=
	=?iso-8859-1?Q?AEvlPDPcaU86D30vRAfxCysnlB1/4/Jt1MXUWHSmp8VPpBXRNLlDGEqQxm?=
	=?iso-8859-1?Q?yjCAb9tCYwQfYIz6bHAigje3Yd7B2eiHgPvxT0MqDL2+eflNzyXrCr3o6r?=
	=?iso-8859-1?Q?8UyJSz27O4zzS/20AtH04M+SPYCu8ZwG+hkW9ykY/xrisflV8VjyxJNEKP?=
	=?iso-8859-1?Q?syxQYvDaTwngygKAaCnYFDz2soLqZOyR3u63/D5w2gGDjyoVdakYkl5JrT?=
	=?iso-8859-1?Q?9Vs+HX399Av3uvglcvTgN0NDHBSxG2r2hLTZQIlfUdcTJgqbjEEbTzHh6i?=
	=?iso-8859-1?Q?f5IcKkyHFjcXOS8rdDFlqyJhhOXgloM0oDOXQcVVqLJJYYU8BsOfyIdyIu?=
	=?iso-8859-1?Q?pUOu2kZO3V6uNs6z5PMGZkekzt+S0uxCreJuGgQrKkBZMs48NO+3sbdnsU?=
	=?iso-8859-1?Q?4c6IMFPVWUid+K4P+Y26m0ZmGTZvgHW7EkcU3dFejhLkpHrBxNr4AXEZ2R?=
	=?iso-8859-1?Q?4TZn363tV9qBc7iYebk3NLvLRw3CV5c7IR84da+AVEFOGpO1yX+IYrvoJb?=
	=?iso-8859-1?Q?t7O3F27g+Q5KnNOqFYGbyqb35w7zFyF8QHTbKK8sldGZ2gqzSOBQY3lCLE?=
	=?iso-8859-1?Q?apO2p5Ip0z38niJbY5R/NGjElnkFYxnVQfDKaCjVIIGmhZWgLnu4hiOqzo?=
	=?iso-8859-1?Q?L8+IQB2+pqtlGfnUlBmSIzDBc3+49PFeL2MsQlwM5E9n1hY9qPOUyqbmET?=
	=?iso-8859-1?Q?rpcgr9YIpy7KXg0uR2TRn+2BeJzIBgIqtRJywgwZgA+B8CJ3RwFWYeL1n/?=
	=?iso-8859-1?Q?hY7Q7ycu4z8lPJyJAlsshldtZCy3E1sv89KZsNPETY4AQEr3vHlaaun+xd?=
	=?iso-8859-1?Q?vgyqfQ9WCG1L8tMRnzKsqh3RlrakY3XIEVU8StpIxjZlCsJpMf83zURXip?=
	=?iso-8859-1?Q?9D/f68Z33Hy6P74gkVsgSBM+9qbr+SvWM25poIJijA7qHdhsegGFjmiBA1?=
	=?iso-8859-1?Q?lGWdWKKQOqEX8dKOfdNFEOHYdtB9duMlsdbxaXtMAssT2AMavt2G7XtQ6I?=
	=?iso-8859-1?Q?isoClhWwp/3vVg6ae+fZei/Sg1PoAPAHoD6EWQaKtiyFmWRy4+3YFr/Q13?=
	=?iso-8859-1?Q?HTATyFL9dJB3hIn1M5qIgz0y2yIG8dpT5nMVQTnH8b/gBTJhn1ETaotnmi?=
	=?iso-8859-1?Q?ckYH8Sgs2Z?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410c689a-bed7-4693-4767-08d92623f325
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 00:10:09.2084 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: csvqD0vw659M62vyGjnjyxGD18c3A93cKZHc7kill9AefsspYbo6IxhVdXG3I88JuR8UAroB3qRvmH2ffepP66pf7ZnPFJxPeY8tuhTHcyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3861
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1530ATUB011697
X-loop: dm-devel@redhat.com
Cc: Justin Sanders <justin@coraid.com>, Vignesh Raghavendra <vigneshr@ti.com>,
	Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Denis,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jack Wang <jinpu.wang@ionos.com>, Tim Waugh <tim@cyberelk.net>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Richard,
	Weinberger <richard@nod.at>, Borntraeger <borntraeger@de.ibm.com>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Christian, Alex Dubov <oakad@yahoo.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Carstens <hca@linux.ibm.com>, Josef Bacik <josef@toxicpanda.com>,
	Efremov <efremov@linux.com>, "nbd@other.debian.org" <nbd@other.debian.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Heiko, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Geoff Levand <geoff@infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	=?iso-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH 20/30] nullb: use blk_mq_alloc_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/1/21 23:56, Christoph Hellwig wrote:
> Use blk_mq_alloc_disk and blk_cleanup_disk to simplify the gendisk and
> request_queue allocation.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/null_blk/main.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index d8e098f1e5b5..74fb2ec63219 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1851,13 +1851,12 @@ static int null_add_dev(struct nullb_device *dev)
>  
>  		rv = -ENOMEM;

Is above initialization needed ?

>  		nullb->tag_set->timeout = 5 * HZ;
> -		nullb->q = blk_mq_init_queue_data(nullb->tag_set, nullb);
> -		if (IS_ERR(nullb->q))
> -			goto out_cleanup_tags;
> -		nullb->disk = alloc_disk_node(1, nullb->dev->home_node);
> -		if (!nullb->disk)
> +		nullb->disk = blk_mq_alloc_disk(nullb->tag_set, nullb);
> +		if (IS_ERR(nullb->disk)) {
> +			rv = PTR_ERR(nullb->disk);
>  			goto out_cleanup_disk;
> -		nullb->disk->queue = nullb->q;
> +		}
> +		nullb->q = nullb->disk->queue;
>  	} else if (dev->queue_mode == NULL_Q_BIO) {
>  		rv = -ENOMEM;
>  		nullb->disk = blk_alloc_disk(nullb->dev->home_node);




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

