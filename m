Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD30EC47080
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 02:24:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FC9F61139
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 02:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FC9F61139
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-WOWLJF8DNPmXCCXr50G3ZQ-1; Sun, 23 May 2021 22:24:41 -0400
X-MC-Unique: WOWLJF8DNPmXCCXr50G3ZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B97AA101371C;
	Mon, 24 May 2021 02:24:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA0BB6E70C;
	Mon, 24 May 2021 02:24:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B2CFD180B463;
	Mon, 24 May 2021 02:24:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14O2OTqr022205 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 May 2021 22:24:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 902C92166BB1; Mon, 24 May 2021 02:24:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A63B2166BA9
	for <dm-devel@redhat.com>; Mon, 24 May 2021 02:24:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34C2A80D0E1
	for <dm-devel@redhat.com>; Mon, 24 May 2021 02:24:27 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-1-zVORH4yzO8yCfnd4JEjshA-1; Sun, 23 May 2021 22:24:24 -0400
X-MC-Unique: zVORH4yzO8yCfnd4JEjshA-1
IronPort-SDR: UFsgXD/dhLji9XFXa62/6iNJYjUcfd8VA4ncbSYFY5IhNAh3jcjkNJufPaOUnaK5fd/dBuWz+p
	3l9kahKrzqQDhgZOfVLMe3xVTGRA0B3Wepnd3iIiuct8pcExPNZIAF4YivQLFsPXu63xqH2kJa
	fJoRd46vzd/FKqva8uQRqG7w5sY6OsTu0Z/yXiJhC0xl7Wx+rB8zxra3GmegoUuWFDPRx4WLqU
	nVve7KpWGn8reLzZbvyElt6pZDLKMUgGy0c09JRj8puKNBqZocRNH/+6IcXik8zflWnJIDMT74
	5AE=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; d="scan'208";a="169192655"
Received: from mail-bn1nam07lp2048.outbound.protection.outlook.com (HELO
	NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.48])
	by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 10:24:20 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB4229.namprd04.prod.outlook.com (2603:10b6:a02:f5::30)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26;
	Mon, 24 May 2021 02:24:20 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4150.027;
	Mon, 24 May 2021 02:24:20 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v3 02/11] block: introduce bio zone helpers
Thread-Index: AQHXTe2ZdAaik0/e4kW8jP+09NcdqQ==
Date: Mon, 24 May 2021 02:24:20 +0000
Message-ID: <BYAPR04MB496504DBE8E0F02036EF581A86269@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
	<20210521030119.1209035-3-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9ed4127-b97b-42ea-41c8-08d91e5b09a0
x-ms-traffictypediagnostic: BYAPR04MB4229:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB42297779B563B39D3248E42986269@BYAPR04MB4229.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:949
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: A8ub8lq7nUXo2n15+0g2/utfmre9hNpgg2fZazsO4IIjp/TaQVz9/i7YnGQj5gCyqFg+oMaLojJ1ign8EdCcV5hJAbW1JO7hx4bzCP05s/cIgVNlANWWhevcp8+51ii+XR8pDgdReR416ltZxBTPeF5f6DjdvQDuTfJXqn+MxkuHaAzf0OrhskuOjnnWJHEVHB4fCJmWWeafyibsCZgJPxlEFI8ZrTRMWNdoQgL1adQcTKus05BEWJbhUtjR9dzaE9hPAShoKJ/E+mv+RhPiOYaJib0TMTADKoj578vKwnmXJMNWPe/l4KK0fn3j+egqVvSMBXfLX2mapmX5MqasWxkPt/xo3QGyON0/HF8Tgr7O/Jmwa5Tf6aRltiEnqlXQbJBA9+UfklX27sA3RzQig8EdL3I7cr8HN4sImgBSIgAnE4a+3tfCc62To8ZFaJN0iJrf6IXtlWLxIwTGdLqqlxMDQjKNQp1mCOCN4iOno+AdMW5OiiZoIkbTNtENvc1sCnuRi12xbabDfWXTktYsB7KMr+tqPADbnYqcEoPW/yA39zrJNLfV7S/LMhUrm3DgHDpf/uKhtHY2sv475Q+dTPe8SxZMvsYS38RogCyPoDM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(6506007)(53546011)(83380400001)(55016002)(110136005)(186003)(8936002)(8676002)(478600001)(316002)(66556008)(52536014)(86362001)(26005)(7696005)(71200400001)(33656002)(76116006)(66946007)(66476007)(64756008)(66446008)(5660300002)(38100700002)(4744005)(9686003)(2906002)(122000001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ca7fZ9is1J1BzuxOixi6YhnSB3immSzQXGLPLRkkXy0Xx+4s0mwN4FK5D8uf?=
	=?us-ascii?Q?XgMCSZ7Zu9D29lubnqmWdajAOJg9mJt1YmQCAHPABTL0KNHn9rrwzbg8E36a?=
	=?us-ascii?Q?Arvcu2uifPgai2PJqjxix+el7rmmj7/bjp4ahtG2yexOTV6vuCygw60Yg0ku?=
	=?us-ascii?Q?nIFqrko+gdOIy3xUr710Ubyu13QasrD1PLWXi6z4MrCLWqVMhSRQ5bSju2cg?=
	=?us-ascii?Q?ojrzNv+EA7WAs+KusLMTTCs/BNdBQI1e/17m8DWn9UPJTGMVCsvaqQ+66rgT?=
	=?us-ascii?Q?gVraahOAuvnQMXAw0Hz/Onick/AbCQGDZ65YQ6IrUv1/teWpGGBZ52ZQxaRc?=
	=?us-ascii?Q?Zq74BBTupMh85aDhxZlMpM0v+fNSYxQv00jpwOQ5dc4oFAI6z6J8xzvvlLJV?=
	=?us-ascii?Q?dS9vgMLSJxoHzqxsLe7NgBa+BQEH08M9yeK+2GuljgDdjUP1guEj4YFbXLWz?=
	=?us-ascii?Q?QGKIXEq5B91Llx7TiC+pMxc1j45R2jDRUWenqvYuWw0OGvLPkczZQahVUtIo?=
	=?us-ascii?Q?FDvbMx7+6tZvbMvqLD2e7+566nt8HTcqgmfOVPv0N82dAIzQ13Li15gBekno?=
	=?us-ascii?Q?otk44/nVHIx43u6VQB0ETAPwJyUj6xIJFf71KVoPUzv/XNWy62OUFqhTxGCB?=
	=?us-ascii?Q?SVrQebwOtQKglXlUBsJ4HQGgxV2ReOEmMePEC6MoyPEEU/qLjuYDhUNNXPSG?=
	=?us-ascii?Q?/y3Lhbg1AK22dGBQuAkqoqs1cCgo4vkFtLWDUZMIDy/HqgkYF+6hRRUQ6mFk?=
	=?us-ascii?Q?EoPYJJejKbTJ4xRUk28A++REXYQTO7b3vE4VDJMVBEzeQRLkDsLIXCmQ8mg0?=
	=?us-ascii?Q?l15/lVykns/M15MQZgc4eHUXr9NW56mTP6ucTqOycKox3pX5LRrMdgV7+AZz?=
	=?us-ascii?Q?fVjSBS+DefhVldZu8ew6lzpl5n1EIQk3jcUF+v/VRpW67A6bYh9z9ZBD69Q/?=
	=?us-ascii?Q?g1WCaEM1WeP4qSsWWhY6wPnW7wi9DRssrVTL3zV9QCXgKzXaQm/xWuQSrIUh?=
	=?us-ascii?Q?ZIXTjLdI8dpoHniIsqZzuzpKPJfLb8gIeaEuSKXzFXYWkPxhRVNTM/bFz/I2?=
	=?us-ascii?Q?5DQNIsRwCwVQcbqJB1Bd02cEaxVYepU4HdbTOAl3R2+ZOFcXMhXcnNDKMIUZ?=
	=?us-ascii?Q?iSG5JFWxlj9DEMwTV98YRy6gS+ljlu7KOdiYACGPDXc2U6Y9pAtJnoDOB6B6?=
	=?us-ascii?Q?uwqarW+mIlMdT4MfesVX1fBUXtdhXjofi408f6vtp6cyJMEjfXu2IH9zAMFG?=
	=?us-ascii?Q?X97hgs9ekqNeTJOncklHDx763IZdzgBjI19OqCnuAY4Tq7ZYRkdP9/euqTr6?=
	=?us-ascii?Q?4Puj+FfwiVrdGYx6evscJJXp?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ed4127-b97b-42ea-41c8-08d91e5b09a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 02:24:20.0271 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: etwNGiW4nWB4+D2p6mTpNz36//zo1KOs+ITE2W7RKoOwzNaaFa5FNgf7/+87P7aUuuxq+IStAQVuyEb1zxqSijwR863oUWXDZ7gT8HVFQp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4229
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14O2OTqr022205
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 02/11] block: introduce bio zone helpers
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
> Introduce the helper functions bio_zone_no() and bio_zone_is_seq().
> Both are the BIO counterparts of the request helpers blk_rq_zone_no()
> and blk_rq_zone_is_seq(), respectively returning the number of the
> target zone of a bio and true if the BIO target zone is sequential.
>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>


Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>






--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

