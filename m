Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70D9ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977076;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=dGSNILWmCMJd136VH+VPP1LKrQRByqXL5g5TsNJNyLz2AYXllKs/Lsak0UnNYGBtPbfRwY
	kx+bLjvB6w3LfAmMxhj17N2zp3kjE8AhfSbZietWBXFwT6mO2TR11qqFGOI/esjLnDGgwk
	pZH/IE3rHikPQUBG2MQPWF9CleMSWrM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-RkxEKEoBN2G0IvP1pj_vrw-1; Mon, 12 Sep 2022 06:04:33 -0400
X-MC-Unique: RkxEKEoBN2G0IvP1pj_vrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C59A1101A56D;
	Mon, 12 Sep 2022 10:04:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1AC7C15BA4;
	Mon, 12 Sep 2022 10:04:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A363A1946A43;
	Mon, 12 Sep 2022 10:04:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E85AC1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:04:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DB3FCC15BA5; Mon, 12 Sep 2022 10:04:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D6887C15BA4
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:04:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE176804191
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:04:28 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-zwl9S5qyMaOci5q396h5kQ-2; Mon, 12 Sep 2022 06:04:25 -0400
X-MC-Unique: zwl9S5qyMaOci5q396h5kQ-2
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="315397144"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:04:23 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB4067.namprd04.prod.outlook.com (2603:10b6:406:c8::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:04:16 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:04:16 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 03/13] block: allow blk-zoned devices to have
 non-power-of-2 zone size
Thread-Index: AQHYxoDUrKiPyzGD8kqRF8YWZ8kiQw==
Date: Mon, 12 Sep 2022 10:04:16 +0000
Message-ID: <PH0PR04MB74165CBFDFD4285B3436C4DE9B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082209eucas1p2747fa09635df54a6c76821585776672f@eucas1p2.samsung.com>
 <20220912082204.51189-4-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BN7PR04MB4067:EE_
x-ms-office365-filtering-correlation-id: cf66d907-ace0-4eee-64d5-08da94a626ed
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: DpYt/diRgcZTiICSx9gKR0uyp6aAnofxnIONq5dg6wM/cW2jsHLs/v7srndVXcA6/QAYoyEUPvZOB+TP24eQa9Y/xXXyGznRboKuoEIf5OFlm60UaTjHuzC/aLypmmgE6pKwv9MSaTZ5sRhhqA70wWd+iJzjGnlmJW2s8pRgexcfVM/fOmAlDFL/7jPbLxd7U67S4gchfkxBdjfEGBJZuJbxzSGKwxt7yAiLzEhjg7+uWnRu5m1t0qWf5Z2aebJepYEfumS83Q0b2VgRStHBQbhO4/z7N9EvKtvlBE/KGqQmgtQOul2X+YJdBFkSHBSypKm9Ps4OC6naiIxhC2cXIyCVyGfAIQSqDA1ByuA1GrtHkireM81sevgHsVMoeMrbVKf4wxgdZ7GamUh8BdYWGrr2SBjMM7PTkKl09QBc2Aydkjgbk4ClE9zzG6SSw1yFjlEL14nRW1xbJLEerrcwPDLIqgB/cGI0MxgcMzbjL78SypcfJ6532E9sHH7rAKAQZzE1Ymoy9MNXFQRflSq+SR9FQAccjizUEjyG0uNk788Wf4PmvKCYillYwfWfAGV01MV0Ev5k3zp7dSmKORvNPoGDqjxqLW26359KUSpO8Qqk4/8k3lrMRPC8vBlYpBbkpiSCA9H2ngTio+BLwTn0VOfb6+QU+zTjOLfQMfjQu/EnpISBBtcDQfX2Obtvo5gnqPIkpjbKFmtxW2VYmYCtVw4Sd6A4TnsIRp30pGxWkTow8BkHYpsv6QQLdI7xgNlEODcgd3bZ9SnQBa4ZnBq+toqkC4vZrVW/U5ZhkFAAHqpmSwwTxFlqTQbRd3JCtkOz
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(38100700002)(8676002)(86362001)(122000001)(82960400001)(66556008)(66446008)(66476007)(76116006)(64756008)(91956017)(66946007)(558084003)(38070700005)(33656002)(71200400001)(41300700001)(7696005)(6506007)(478600001)(9686003)(4270600006)(316002)(110136005)(8936002)(54906003)(19618925003)(2906002)(4326008)(55016003)(186003)(7416002)(5660300002)(52536014);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?4E3EpQ82K8APWE1qtrs+j7C2wg2/h/fH/BnLPSHVrneeIstVwcuVr2RwXM?=
 =?iso-8859-1?Q?WwI+VEJyD90AnHGF6HxnoMyb4JmRoGesLeAqx+nA2hxgC+WCJfo1XyX8E9?=
 =?iso-8859-1?Q?2lkwqfVQWqAxq1hW4I4O4GZNAKxMPdLQOTvqlGkJDo8bdG/7+5ICJW7nsg?=
 =?iso-8859-1?Q?QUkmIcMfusR1OilakbLnyVb530kMmx4SNJXQc22Fy8U9V8+sAH5+DLEBow?=
 =?iso-8859-1?Q?wM8+VvZnZTJjVXGMXQwwuBcfYeUe6R+9F9ffgv4FJXWJNKcYi90nXWJ74x?=
 =?iso-8859-1?Q?cfnoY3D5yKdNNoYNqPULOY6EYZXAJ4lC1hz/FHl/YdbO7WrjOb7dsRLI7g?=
 =?iso-8859-1?Q?Vh/Foq9E7/gd43p/ZI+mGESoYusmWzNopZnns1iXLqJlBECMd3VhDK5+Lv?=
 =?iso-8859-1?Q?OqeHCStSH1IjQvjnOlyHa8lTrEqahjDUDlQyht83ynmQZA8WxNbXUI3EKT?=
 =?iso-8859-1?Q?B17sIOqyvHshdpBc8IwaHTEwJ7kA6B0f0anC5BdL7EVXXp8squC4Ekrpw9?=
 =?iso-8859-1?Q?aR8El8IfWOMTldTivpDYxWSGYZHSeSmSAuklCgRGNPnUXYFNzH6F6xT8NP?=
 =?iso-8859-1?Q?8W86KpmvTERFb62AR6oclyeRn56ZANxROIkcVmp2LR5oYZJyMYr1goMbSZ?=
 =?iso-8859-1?Q?o2fY3sOdecsNSCqukHmcVTL30UciEQ0jXH4KTVcqWbjtFX6xaGguFnJrDR?=
 =?iso-8859-1?Q?mu+rl7FfOXvLyYn85SGQRah4MwnwQHvbk/NQmCbKNbqO110rqNRQHltPkN?=
 =?iso-8859-1?Q?bQjkr8VPDfKnGL1ImBuBJ2S4jLDPCYmbWUJ1U9AWSU0SXEINhyGLguIF3C?=
 =?iso-8859-1?Q?aqVf36Kl28mleCXcIPaYJeFY4ndv55yf4ztdHPJM6PDnRyg9A4ZKiQJdt1?=
 =?iso-8859-1?Q?sIsTNEAjQPTveE6TsJEHC6A1Dz7swi7xnMp8FoxkmUu86T664Ud2kAe70/?=
 =?iso-8859-1?Q?De+dCOfzYnVNWs23AZ1FyKfdPdoJjEVfPfxbqXWY7P+kTG98+NE5mnBwyG?=
 =?iso-8859-1?Q?T1reK4NoJQWoVTbSMF3GLuAw3gIQyofGUkuNsrGBhK5dXnN30pTr3G/gvO?=
 =?iso-8859-1?Q?pAscACeFIalRk3Tbfpdq1FjrhFLzeHiWrd0y8JpXg05bl+2+YxqDJ86fCC?=
 =?iso-8859-1?Q?JPkFTwmV18ilGc0UPmFZOyaV0dcpn8DITG8pPSHXali1O65vP00aQsQt2a?=
 =?iso-8859-1?Q?TqANqLU6PNRYR5TDVpFyQ4/akAmKGYbClHcBbqLCetUEkcut1FeBxr6v47?=
 =?iso-8859-1?Q?xu7+p1r0GBeL+enOz1wGILt4wOQiuFxK/YTv3R6o+5JHuEQdWSI66W7B3a?=
 =?iso-8859-1?Q?zr84F0RMWHg7qjHpx/w9SvcVvncSl/sB6CpsRNvlqliDos4NL+ZMZFj89e?=
 =?iso-8859-1?Q?HPduhCNHkXMYPaeLjm3Ul/RrRAuWYkN1YPQzytj68UUO2arz8SDuewtdSP?=
 =?iso-8859-1?Q?U6fxGaqJWyUo+qJleL3Jufnrx1i9CluOpcytw2TknUOwf/Gnp6grPCSfGG?=
 =?iso-8859-1?Q?u7e3O1GvcYDBFgmngrpzzVYSSPcZQI4Hc+vH7Qj03KnNpEbwkSUWp+JljX?=
 =?iso-8859-1?Q?0kenOujwJN5yodqPrznOw2jvmUyZcbQk5EfifI2iFjpBEl5tIoAL2lIOdK?=
 =?iso-8859-1?Q?cwlXpSO7ygZVn4cKgfiFpxwLMUDg6kj5A4WVCcy7lAQ1tw2hiJBwqaDXu+?=
 =?iso-8859-1?Q?7PTA0m5OXLlnD1DISRHK9JtdqtzYnLc/Gmyr0n2exE+TcCah/B0OuCGsRv?=
 =?iso-8859-1?Q?yOMidcWAfk9vDUeZXPrjaCSfM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf66d907-ace0-4eee-64d5-08da94a626ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:04:16.4764 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPMPSR7RWG01A2j4E5OFj5iDjSZ0KFggDxQtcsED1Q6MDSxJqYDg2XJU+KzsPnRMKjb9fBs4DLE/Gpv6eD66vNOkLYBZM8nqul0CB8wnPiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4067
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v13 03/13] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

