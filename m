Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC74ECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977252;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=X2fBk8L0PYTnszhbdqaaVLPQOWcl7JDrdDetNBwnsDZQ3j3ukePAOWAhw817z0thKVLxjU
	FqirwN2Ry5C2kCpWJ13acnhtKZtIk8EXL9hV0Q203tCJAVI/VAXmBpMQhNwmbrgbbe8+pi
	wKQ5kImmlu3fuKcR67LyuMji89oJ0U0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-O_-TCd8jOUeYKSNL88wtFQ-1; Mon, 12 Sep 2022 06:07:30 -0400
X-MC-Unique: O_-TCd8jOUeYKSNL88wtFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6B81811E76;
	Mon, 12 Sep 2022 10:07:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C357117582;
	Mon, 12 Sep 2022 10:07:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B474A1946A43;
	Mon, 12 Sep 2022 10:07:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13A0B1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:07:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D4511C15BA5; Mon, 12 Sep 2022 10:07:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF91FC15BA4
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:07:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2F6C89C965
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:07:26 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-YWeGWao3NkCIhjOCoLtXXQ-1; Mon, 12 Sep 2022 06:07:24 -0400
X-MC-Unique: YWeGWao3NkCIhjOCoLtXXQ-1
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="315397324"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:07:22 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB4740.namprd04.prod.outlook.com (2603:10b6:208:43::31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:07:16 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:07:16 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 07/13] zonefs: allow non power of 2 zoned devices
Thread-Index: AQHYxoDnaNrn4mY9t0ukwL0Kst8xTA==
Date: Mon, 12 Sep 2022 10:07:16 +0000
Message-ID: <PH0PR04MB741654A684770934E6E533759B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082213eucas1p239d6095dab9b042f05efd3a6e82bac9c@eucas1p2.samsung.com>
 <20220912082204.51189-8-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BL0PR04MB4740:EE_
x-ms-office365-filtering-correlation-id: dae4e84e-bdba-4e95-3095-08da94a6922d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IzaLZ7KoNsNsrT3QBeEJiEdkJISCj0tV8/QEWNLgK4AhKm+BdqytBSrjNNyLR4VGDZwyFmLNMeswS/rlFW5a/CGIWwgVcfYC3f3YvRSdK42WpXnB+bpDd5eRuxt3dvq8D7vbK+oLdKvWPDCtS53IsmJg7EIrcCyCVTUIi0hOrCU3MaqIyc5856z6ZEKBzDofejQkWyrMd7YD+caI272G21Kw8z6pZL7vWO4aLSmZ+Fahg9As3Xv9NB9dXZuL1w0kJAFS9OoZlnHj5ODMmi9P2rYx91+nCDullwU19O18SSH/WLWNGQW8laYHR9rmutRNAkEfKJJswa53dszBJKdyS2o1Mu5NHtFp6nfroZGWs2KTg+no2Ewl7Fv3FtXqlXGSvFZ/G2JBHcAj5ePi9NOeyTI6mn03rD/fmPMr/xL8+3KagXaQP/3ANEEn0/5pb2YRGYMepoiINiW5ENLD08o4Cg3hyQE8WAplJeM6gJqlPX+NYqMywn4WrmD77Xypgtlz8FotcYFSd4mMtJyZ21otIvL+fKNaCpzqw5EoGUML47dlPRlZoXWUG57OdgcHT7vmwigGfaTL1e8fpZJVHRqfpzsdUkH85gOZHOdwZG3cSHS78YUXWSWOt3nDLYpNr5Xi22cMLRvoU/bvgFpJjvrVqi2xGJQnfcMFQzcp0AcfnBQB+3Vc1Y8Oys+3eMpISQTy7WC5zTNymAZmxWH2Bwe9fPyg0I87aHbDjsM2xOeZ6H99ruMp7rC1vMVGzgwTOn/ci41/A2EjKXuNVnFXXyUz4A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33656002)(5660300002)(186003)(4270600006)(52536014)(2906002)(8936002)(19618925003)(7696005)(6506007)(9686003)(7416002)(41300700001)(54906003)(38070700005)(55016003)(64756008)(122000001)(76116006)(478600001)(91956017)(66446008)(66556008)(4326008)(110136005)(66476007)(66946007)(8676002)(558084003)(86362001)(316002)(82960400001)(71200400001)(38100700002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?KCsEk7odCjfEqwcAWs2yRb1dNFrpcoKU4FGhJG2xvbiGDPSyOEK3SPOJCX?=
 =?iso-8859-1?Q?URXNj0RjAAT2DbaIkRXK1hk1S1gDPSu2a6gF4uxB+sgxzx3ZDnVHwHQ0aO?=
 =?iso-8859-1?Q?F96DKDYFnTvIvxOcm87R3IqCydrlptj/uG+bCm4O7gF3h5kJ8D4dNotxtJ?=
 =?iso-8859-1?Q?Lg7qIWCyn0XZsibpiCoNYmX2wgKqOWDpu+gWxOHr/3GXlIx1W7wlzAH6T9?=
 =?iso-8859-1?Q?BU/KCTT+tKYFpDEwBFvv1pez0bsFh4rCSyuwcZDgZshGlPiw4iLlVsgQzK?=
 =?iso-8859-1?Q?hMe5yHxNpIQAnQxupTGDFjGdLi2BWN+yOIGzfnEc9rF+tWoWE3a90GHczT?=
 =?iso-8859-1?Q?fckJdP/4rqNhcdLw5JcNy6NC5bcjIElAVhBkGqzFLc3SGHlwwQ6TFeq4Wq?=
 =?iso-8859-1?Q?pixUuuiy76laV3X+lgKi2ujqF3RosqHdhARy5KaTkkIl76egweOb4FIU1A?=
 =?iso-8859-1?Q?F9uQ0lOhNqgRgridPdZoFcbIv1uO36oS+tcKqk63cXXdRt+vWpbDMq3tFe?=
 =?iso-8859-1?Q?fFlJ7HIOtFu/dQy5yvwwD3U8kV4Amo51w4ZgOl0Yozf2lxkO+fTli1sL/j?=
 =?iso-8859-1?Q?nw1vUeGKbV6vso8Jc0xVedI8XFAODYZ3XJTmoG3zWdnJ17/I7ejd3pFmuW?=
 =?iso-8859-1?Q?a9uz15OeIwImkAp1xFT7a79nk8y43gk1XWqfWGSNxEbcMIBPc0XF88F21E?=
 =?iso-8859-1?Q?z9K6qubSA5X7r5iVutEU9vShJtvzc2f11WoTijTeUHu2C+etFsHT0C+Isc?=
 =?iso-8859-1?Q?QsHbL+nc0bNb1uVL+CXUfR8vS6NuuANdyNykf1Tj7YmkErpIPsrr0jEBQO?=
 =?iso-8859-1?Q?KRQp/VID9zZ4Uo9DKcmZrAXw5sJralFvu0D1VImEvtiiW0F4ZLUHqMLyi4?=
 =?iso-8859-1?Q?4u2xdKRoRYr0XMkcvw5JieQ7T6Az0qihCme5Sz6A3h903Unl0/0jD3rXBx?=
 =?iso-8859-1?Q?r+j7rkcPnkxXiX4ceJJHHeKByR91IjeQ71ckWatwoKVa4CA2w3D5GPhSPo?=
 =?iso-8859-1?Q?fGWG/EPqtzmTdTaqwjb+/tOwfUMUH5HmQgxWD25HYBqwu9NZHoLBhv8mKu?=
 =?iso-8859-1?Q?57r9nwUbmpydzQSLsNXz4MVFK0Dam+kt7X3Nis8Sy7iNMm53SywpdeNCYG?=
 =?iso-8859-1?Q?pffOUX1zlTqUntx6dUf6ouHNmwOFqqmbUJgPCCWDjDIF1SWFMDw9UuUFS6?=
 =?iso-8859-1?Q?31PfTtXg48Zd04x8hBGZ9h7kTsaKE+KMPFhphmig+kCoeJU0aBUFwAFkjE?=
 =?iso-8859-1?Q?kC3wymktr+1emxVw1Wns4sbvaNyHtGRqxdIMZuIaR5SofCsIKaMN/o0Xa1?=
 =?iso-8859-1?Q?PR2B/BQ98Wrd+Yj28G0j0zZzlt7QM5ckraOg8Eq67ZMpoOCv+QTjkHKbOx?=
 =?iso-8859-1?Q?QU0k9vhGx/nii1X6mK4S2/sgGDx0pjJ5ZODZHWcyrhEVT6skvm8hGheiYF?=
 =?iso-8859-1?Q?nZPxMO8ZxqAiWk+Bz254/h0j1ih5HWsAM+x8wCeYoVegKvw2sJUrgimqss?=
 =?iso-8859-1?Q?FC2yhNsKMd8AV7GDLpzdjSGUjX+Acr0y9uMXoce+Q9XevyM8cVva5AN2lY?=
 =?iso-8859-1?Q?ZIQv9/S9Ea9+OnHJVrj6DfJ3lqydmef9d+v34vYfqPR0GJ119ISZ4MRxlI?=
 =?iso-8859-1?Q?PYlVK7NurPYvlb3ItS0cGlkFqch9uqJ9Ljx3daKuIvEuyg8w4ndDrPUPbs?=
 =?iso-8859-1?Q?vw2Zl6cVW7JEGm5q2jK83HCfLGQDCEorElz9kzfnF070MD0tZ/j25ylKjB?=
 =?iso-8859-1?Q?x3B/+D7Iz7bIKrCb3okWorVao=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae4e84e-bdba-4e95-3095-08da94a6922d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:07:16.3638 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ndEWTXlMNECEiLY8GXuUBH1970H/I8xzWyqInAU1xtJOpdw+hZRO4BofMl4BqZM3SfDrW7NUZgaDxKvCFnBfIJcNXhNHzY/MDUJqbDlPhaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4740
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v13 07/13] zonefs: allow non power of 2 zoned
 devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 =?iso-8859-1?Q?Matias_Bj=F8rling?= <Matias.Bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

