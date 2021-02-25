Return-Path: <SRS0=vUAV=H3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17CFC433E0
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 02:02:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2159764E02
	for <dm-devel@archiver.kernel.org>; Thu, 25 Feb 2021 02:01:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2159764E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-E2_qizDPNZqydTM9PWHyVA-1; Wed, 24 Feb 2021 21:01:56 -0500
X-MC-Unique: E2_qizDPNZqydTM9PWHyVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DED2C85EE61;
	Thu, 25 Feb 2021 02:01:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C4A19C79;
	Thu, 25 Feb 2021 02:01:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F5FB4EEEC;
	Thu, 25 Feb 2021 02:01:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11P21b6W030094 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 21:01:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CEE4B20F4724; Thu, 25 Feb 2021 02:01:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C81AA20F4722
	for <dm-devel@redhat.com>; Thu, 25 Feb 2021 02:01:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 056859988E1
	for <dm-devel@redhat.com>; Thu, 25 Feb 2021 02:01:35 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-597-e6g4HjiyOGiQhbH2W9XQvA-1; Wed, 24 Feb 2021 21:01:30 -0500
X-MC-Unique: e6g4HjiyOGiQhbH2W9XQvA-1
IronPort-SDR: dKO7GnsPekgSoofHTpDkxvNtFgqIYGdlMf7rNmG2qdZuQVwmGBh78Zzwi0kbePO1TGJjYLePgK
	9ZLoJELIdXtOLF7sKE+oFFTNbnhKYhm7XhunC47uH8FsRmgGTku+Hj2wFq+oG0i7I54c+dwnGV
	TtGdbEu1Cbw5QjTg2WxXXUleBg9X82BrB1An8Uyq17pSIgowP6dSdmQhtoPLvge868Pvyycr0e
	NEbNLQ1/dWV/92ogGEt+f9ae9Ob/gBQBvj8DSsuiNoqP1vSm3EcgvFJlc5w3W/jkqz7n0gJIdn
	QgE=
X-IronPort-AV: E=Sophos;i="5.81,203,1610380800"; d="scan'208";a="161914056"
Received: from mail-dm6nam10lp2100.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.100])
	by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2021 10:01:26 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by SJ0PR04MB7501.namprd04.prod.outlook.com (2603:10b6:a03:321::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19;
	Thu, 25 Feb 2021 02:01:22 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3868.033;
	Thu, 25 Feb 2021 02:01:22 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [RFC PATCH] blk-core: remove blk_put_request()
Thread-Index: AQHXCV9JZjwro7cFh0S/a18Ze28sQg==
Date: Thu, 25 Feb 2021 02:01:22 +0000
Message-ID: <BYAPR04MB4965BC5C807658B3B433364A869E9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210222211115.30416-1-chaitanya.kulkarni@wdc.com>
	<YDY+ObNNiBMMuSEt@stefanha-x1.localdomain>
	<f3141eb3-9938-a216-a9f8-cb193589a657@kernel.dk>
	<20210224185521.GA2326119@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56f64fd6-2cdc-4abd-c521-08d8d9314028
x-ms-traffictypediagnostic: SJ0PR04MB7501:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR04MB7501900745C1A3FA0C31A251869E9@SJ0PR04MB7501.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1775
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 7a1exBGRqQktlYbDDZWv2RhRFbhqGiukSq1LW0aZf3mzSh5WjzQ0k37UaKivHB3QEqnT9Wur7CkpX+vSiETNDt3NSyq6uqQPXxQx8vT2+kX6HidYPZZfKA4AMREZqWNDIxHeHVbqqljrwyhaaVOTGcUqvm6sGgZTYfcIvBNAgRYX6Qn44w9HEnIwg1QfMxiNBDjbwkdEraaDj/sVin/H+pKFGLL8wleEXxddVYG8b+6z9pdN7UUteFeLXk+tkWsG/ul3IHa5DHsVW0SdIRIegIv222OApq7ejFai34kuWmA3S5msKWv3KWtz2xN4AqgBfZvymnHGA6AQ7CpY/Gy4jmTbcMAciS/TYQgk8K5r/oiW1hJ/p9luedxeRigmWLfTJYEpPG7JI7qypZQVqt+C2qQGKSKfobtOvNuQHOjwyKKuoAA/Oo6+93h4HC9vRQS9HEf1RBI/RYjmcpnpRfVdlL7kL5JENlMiv74DTZuiNJMt80b6wSjAmfq5SJCvL1Txb2FtVeghWLpxck6gbzK/4Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(478600001)(86362001)(2906002)(8936002)(6506007)(53546011)(8676002)(110136005)(316002)(4744005)(83380400001)(71200400001)(7696005)(54906003)(9686003)(7416002)(52536014)(64756008)(7406005)(66946007)(5660300002)(76116006)(91956017)(4326008)(33656002)(55016002)(186003)(26005)(66446008)(66476007)(66556008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gcZ7mh0KhEVI2AXURnV/bTrU9dnz9UR9APEeZ7x9qou92Rz7vl2RzC/fbjrY?=
	=?us-ascii?Q?OTDF2iQDykaxfGyfv2YBcgXg5C83VQb5TvWkb1UpWurvb5exQF/WrZkHdNgu?=
	=?us-ascii?Q?+0shO59m/wJVG5GwrC+hrItJ8wubPmOH09fcDsDtohjqU9fH47lNSpjjYrdN?=
	=?us-ascii?Q?FXGW+KYvNxJMFc6Rq/KP+XYhNhlSNcRbjZzsluj3BD8rob60NvYNbr3eGTwf?=
	=?us-ascii?Q?srbY5MA0yejRIIB4+tkZFYtegkiter+kEiMX8ctN308x41CmIUPbas0/AhxX?=
	=?us-ascii?Q?70nq+AMoqQ1M162pw9nrSyPpQtR2suQmC5lLIkTc12rkX+BVlMS643myVAqs?=
	=?us-ascii?Q?t4bHc59aLOIMw5surFL+VQiREZ7onYNixaRkkFcWDJ+4ONN6jF5VuxQlPN8k?=
	=?us-ascii?Q?4b8hbjfp7e3lZhiwFhFMXF0qLkZGEeJGNRDxxkQ5JIHV5xOL+b3/ywtTQYKg?=
	=?us-ascii?Q?9gclzxjcvgvZ6H7VXN5dZBtuCQPiPrDj/0Ov8iVJnyc7so1gTOTFeEHb3wMt?=
	=?us-ascii?Q?6W+HumdT7ELVp50t6qkVhw8ASRl9D7gr7piv5srMD13jo9yyXYXUiI3iHA/m?=
	=?us-ascii?Q?ajkQ3IO8GQGLa7qo81l3pcRGUGbMXvSprfZAy+3RTetqfUzmoHd3r01ojv9s?=
	=?us-ascii?Q?KWKZAN2A5UUCEEJWn/S81y8GT2Q4JhOTa+MkZIsSzLpR8/Rohw5quJKCPnHV?=
	=?us-ascii?Q?ERsYm5nvsKu5KtNB+5ZXSOsz3+j+N95k6tJik+dHf1pLRWYOi0AeM0XjGhT2?=
	=?us-ascii?Q?iV+hoIUiS5hQ1aIvVm872bpstxU36RJwDQhtzotyph9Epb2J4NxISFIJh3wF?=
	=?us-ascii?Q?2oSZMPnP2RocZtzP14OEgooDDhnfDYUmctmyVOWvJ1JQZfw7YFRdn/hXz06H?=
	=?us-ascii?Q?7y2N6Hcn9E6MWZ4RC3+hGANhnkhJc9JbH38HgIMuPDM3ainXyCikgANltpdq?=
	=?us-ascii?Q?fF5+XQlDpaHWquODZSZ0sE3yPLj+hIEFjDpTq5XSRNMt38j0lU8vCeT7CcEP?=
	=?us-ascii?Q?q9SYFaLnd9g3Bvs5epKhxo05IyZ/qov3SOHEY6icvHvHvmdA4N4V3a9xy11a?=
	=?us-ascii?Q?ljNVIQMG4g7clxi94FGSC/OeQwDdM9bUFZQeOJOHjI9x2KqDVMi3EhctPgEd?=
	=?us-ascii?Q?5d5XMRvbtqXkdYEhT2PMPCMELwxdJIcCavnTWWGQIVkWqQZmAk6PVRVPyH0B?=
	=?us-ascii?Q?QvxFBJd9mN87Glf6+F9JHBBE2P/xqyOEzVhZWzxrWoE2Z0TY4wLJf7b9kyiC?=
	=?us-ascii?Q?2HTTYQWH6AtSm2cqj8Bzd558VP865DO3ZmNWMP3vRH52PXI0rGB20YyUMwSW?=
	=?us-ascii?Q?p62Tq+6banbFmnFbD2A37jRhcvu8KVHVLrJuIqQV16aayQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f64fd6-2cdc-4abd-c521-08d8d9314028
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 02:01:22.4144 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f4h07uujdgDMaaLd+E6bOJvg9EKRXI8nL3l5DC6R3D4oFAfvDFXOiwV8CiczABQqDfr6y0PDGXBQhUjggbo4Jw3CwrTBGIPr7xseE97cCEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7501
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11P21b6W030094
X-loop: dm-devel@redhat.com
Cc: "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"mst@redhat.com" <mst@redhat.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>,
	"bfields@fieldses.org" <bfields@fieldses.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>,
	"stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"cang@codeaurora.org" <cang@codeaurora.org>,
	"tim@cyberelk.net" <tim@cyberelk.net>,
	"dgilbert@interlog.com" <dgilbert@interlog.com>,
	"vbadigan@codeaurora.org" <vbadigan@codeaurora.org>,
	"richard.peng@oppo.com" <richard.peng@oppo.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"guoqing.jiang@cloud.ionos.com" <guoqing.jiang@cloud.ionos.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Avri Altman <Avri.Altman@wdc.com>, "bp@alien8.de" <bp@alien8.de>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"baolin.wang@linaro.org" <baolin.wang@linaro.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
	"chuck.lever@oracle.com" <chuck.lever@oracle.com>,
	"zliua@micron.com" <zliua@micron.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
Subject: Re: [dm-devel] [RFC PATCH] blk-core: remove blk_put_request()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/21 10:56, Christoph Hellwig wrote:
> On Wed, Feb 24, 2021 at 09:48:21AM -0700, Jens Axboe wrote:
>> Would make sense to rename blk_get_request() to blk_mq_alloc_request()
>> and then we have API symmetry. The get/put don't make sense when there
>> are no references involved.
>>
>> But it's a lot of churn for very little reward, which is always kind
>> of annoying. Especially for the person that has to carry the patches.
> Let's do the following:
>
>  - move the initialize_rq_fn call from blk_get_request into
>    blk_mq_alloc_request and make the former a trivial alias for the
>    latter
>  - migrate to the blk_mq_* versions on a per-driver/subsystem basis.
>    The scsi migration depends on the first item above, so it will have
>    to go with that or wait for the next merge window
>  - don't migrate the legacy ide driver, as it is about to be removed and
>    has a huge number of blk_get_request calls
>

Okay, thanks for the feedback, will try and get something together.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

