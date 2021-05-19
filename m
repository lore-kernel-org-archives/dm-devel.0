Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EBCC433B4
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:44:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 76435613AA
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:44:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76435613AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-BcB3qKbtMCuAElfsDyXQRQ-1; Wed, 19 May 2021 03:44:12 -0400
X-MC-Unique: BcB3qKbtMCuAElfsDyXQRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF662107ACE6;
	Wed, 19 May 2021 07:44:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 72EF818A50;
	Wed, 19 May 2021 07:44:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9F27055347;
	Wed, 19 May 2021 07:44:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J7akWr022336 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 03:36:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0184A2157FBE; Wed, 19 May 2021 07:36:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE4832157FCE
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:36:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95B56101D228
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:36:43 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-393-xMc1zG03OM2Uz0q5pxkhwQ-1; Wed, 19 May 2021 03:36:41 -0400
X-MC-Unique: xMc1zG03OM2Uz0q5pxkhwQ-1
IronPort-SDR: Sg1Rvi9YvBu0x6sHHPSlAn+7yeHO4/mPDVlLqa/hYOWpQbRB0OQgaqBdQ5j1BqYWZJIvevx0AU
	LfA/U8jKi5QxjXjuntev8Y6c/RulH+EHnBiO9GTIJIdRDmOc4/U3jKCCM5mYI+OraaQZSQgTye
	MfVBs088xBs4fpustCUwwwBbi5yt/n6jCpong8mI0zGsmVNf0oq3iXcsFbvkBgAbSwQL9SeNVi
	OVYfBSJFySejGvCKGOK8Ykm+XHvlVC0Nhi3dk0u2joMZZzXUqal7KLFseaIg7sTk8IBj9d75xJ
	rZo=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="279912595"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 15:36:39 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7493.namprd04.prod.outlook.com (2603:10b6:510:51::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 19 May 2021 07:36:38 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 07:36:38 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH 05/11] dm: cleanup device_area_is_invalid()
Thread-Index: AQHXTFqCCP/2Ogsa3U+NRbmUC2YSrg==
Date: Wed, 19 May 2021 07:36:38 +0000
Message-ID: <PH0PR04MB74161DA3B6ECE23F9CEE945F9B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-6-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:95b:718f:422f:1ec2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca815c5a-c660-45b7-aa4b-08d91a98d6a9
x-ms-traffictypediagnostic: PH0PR04MB7493:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7493A07C6B490AED56E31B1A9B2B9@PH0PR04MB7493.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zTf02mu1omwk6ylNdhFFckRL653yd41NN71c3SFSZtXQZveVh2TWCDob6OjHzCoU4sOxb/FRq7hO/lZLPxl7I/grl7YviFBygHkK+sdWs6fhXz17A8a7NpIfy9F5zevAd8SpAN1JsfnQ147eV+gO2buulTH4DSd8fsBK/O7B7Ld0uvT2qwa2FHyPEDT2vvjN3KTkC+NVX96HVuFRFgnNbLqKQUYY8QiNgaOOLq5/X59DJObBiacFKNzh3+mp42/iRT0ivZArjG0gcfThATTXcPZ1e3brOUmKczcPr2rJCkULZJ0afihm4y4JFvO1+xRBEqHIZHGJxQiC9nay2k5untqGYJ691GPVpVbmS45YZDUxr62eERrkb/mIewvZKxyjtZD1LMcwKhvmRu27Ek1mIEPeGGEqQoW75gOvcGp3oxpmNYh8PZ4/W7FqEuHtqa1gVTrQgOVg9JSRIPlACvlnOe2FdU+eiFhXC3513QuMzKAHWFOfkBSMz7tt+OWxf22qboyKL6IeV2JhuM8c8GEUA6U9uyfcComRLcMP3LcHM3HVAgC4F411mGa9dTRZuCPOc4v0Dxk4gZE1qnwJN5qd0yBNGy4a9aQe0cM/Mt1ADYI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(7696005)(86362001)(71200400001)(33656002)(558084003)(6506007)(66446008)(8936002)(2906002)(122000001)(478600001)(91956017)(9686003)(38100700002)(19618925003)(55016002)(52536014)(5660300002)(4270600006)(64756008)(66476007)(8676002)(186003)(76116006)(110136005)(66556008)(316002)(66946007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?eQz1vH/bq7I7AYlgZm4h34bBnGGAQZ1Nrslqj54TRqWsKsjKy/aY9/FeY9l/?=
	=?us-ascii?Q?CPAwk7Fi/qjSAUKqs1iUPu3myPk7/rQJfSy7zdFaXKPYvXEFqAIpkW5PWo+K?=
	=?us-ascii?Q?0GbvB9behUWYWPZ+Kb1KLSIWoZbtz3K8ff64sQ+BkqIBgCTSh1yzrCcnvA9c?=
	=?us-ascii?Q?P5+meILqpaIaicOkxfEvnnJ/kAeUtDB+c2OvU5hQEIgRrhs0tBxRyPN49DK1?=
	=?us-ascii?Q?wT0fIV/8qXav03U+ArBhf3A5I8j3Sw1/ecjFK5TJKyWnTMOEtZBlxa5tKBbY?=
	=?us-ascii?Q?F2WhvY3siSFTBtNGABAwAkXuwHGpwMcnkeKJHzyZK3Leo9T0fn/zA5D4OW3G?=
	=?us-ascii?Q?vSACHFeqnTlALh2ux00ND+ArEIQ601ZFzqwPgsvscXxUXCRxbKilPpBmqFcK?=
	=?us-ascii?Q?x6l2uOyc8Rbq5f082eRvNLiXA6p98ZCyJhrz/Hd54WrZiwir0C97yY7rJYuG?=
	=?us-ascii?Q?HobJZXVq/P3W+2DkKhuqnB4zG0RAhO7fTI4jmLCugamj6keYErl1lOHyFUwF?=
	=?us-ascii?Q?p1jAu4NOFXig4XWKRg5NV4yQx68Y5t+YcxSAChfIAM+bOjYUJ+VdrAA5NvDq?=
	=?us-ascii?Q?V0sgUgKvfNUdOfPcBjbb7/IqtykMtE7rwHUuJVlzmq1DqfBTEfw1ua/anFeH?=
	=?us-ascii?Q?bXuIREVFUxJ3EP6oNE4pZcZ4M+FQ/yzywrq4Aof0/PT+JJ/4uskgaDSg8puS?=
	=?us-ascii?Q?wdyzq8vsIypznm6OHXCNDjuDQZR+3R1vb/WgsQIN3iMckJaq1VbRCGa5yXl0?=
	=?us-ascii?Q?LERFCgbLBcuZATdqfnz78GXgEd7Hd+GLDwGggf5eoRhyEQ0oG1hE0yIlklQh?=
	=?us-ascii?Q?C274dg7XoCkmUQatIZtY+3e3ZWbP9eOCwOly8LkkE21k8iVQrIUPnpopoTLg?=
	=?us-ascii?Q?ah8u2H/vAHUSB+/TMfhLrbkrNuisSS+mKcua4ufBrgzV6uC2U6AP0R/KPKvK?=
	=?us-ascii?Q?Nf/em59gfH7WdCKU5t7VL4GoPXloiOa0L4mcKzFAJKFqTS14pb+T1HTIS6N7?=
	=?us-ascii?Q?jg2CxYC3fEkN+Vd8n4WTAKJcSm2MHdZynUYYlncDBU0HLhjW3ynPpovYbZnk?=
	=?us-ascii?Q?YTMTW2xU3Ocq8itbk5dPAT5jOyRNq61XfAw8dEdNGBk6XxM+KOFIwWyHvc3u?=
	=?us-ascii?Q?vSHKzDWVgz5JWfz9aNRMYNq/tWPcCczf8QC3lzs6c0OImUxbuqtawFwjm3yX?=
	=?us-ascii?Q?d/h3RiqPYxMasOjB0TZE5l8zqJLE0BHyF0NqLsfS5E3lt4/43JgOv23nCs7w?=
	=?us-ascii?Q?WMLZhLTVLwqdHRP4YFvOn5Jultg+rZFgM8SQmeeHkmgpbVI6lmnUz7FVn+WX?=
	=?us-ascii?Q?dSSQsQrUC7hOlFoD7OVZQb66sHWKawH1tHND8oflqAh7typ0oyTidB+uP/4j?=
	=?us-ascii?Q?Y+hFftJFXlJK/7Tk+JNEJdB0/LTB?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca815c5a-c660-45b7-aa4b-08d91a98d6a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 07:36:38.6936 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Mamkynejkp5bwh12AcSSEu5Kt7IvJexzmx5re47RcZKA/dIDAlTPxtZei7pU5S+BWZZBV5Dj4JLTwvjWZyzJbBDUq7NuTGvTJBE3mPhYI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7493
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J7akWr022336
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 05/11] dm: cleanup device_area_is_invalid()
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

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

