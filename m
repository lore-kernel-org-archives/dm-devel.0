Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5686DECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977362;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=bV7pfTHjNVQGh1yH4WYDCqsGxl1/elnaGAyaQfK+TtFHKEH68spuZP8TvwkycX3jj9U4aE
	5PogbBaxOPM1X6viX+nR0rZa34VlC0xLogIdFc0BgRaFYdAXtbpBoNPtfYQ/WbNqP7vBOk
	4+GbNdR+7jiob3kei0mxPk/5l80zkA0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-bPjNHcKCPhagAPGWbPuKBg-1; Mon, 12 Sep 2022 06:09:21 -0400
X-MC-Unique: bPjNHcKCPhagAPGWbPuKBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A4FA8032FB;
	Mon, 12 Sep 2022 10:09:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA8E8C15BA4;
	Mon, 12 Sep 2022 10:09:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B307E1946A43;
	Mon, 12 Sep 2022 10:09:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DFF001946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:09:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CEABF492B05; Mon, 12 Sep 2022 10:09:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9C0D492B04
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:09:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2AD3101AA46
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:09:17 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-f-WxsIaQNky-n3I6Ha-dzQ-1; Mon, 12 Sep 2022 06:09:16 -0400
X-MC-Unique: f-WxsIaQNky-n3I6Ha-dzQ-1
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="211576789"
Received: from mail-sn1anam02lp2043.outbound.protection.outlook.com (HELO
 NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.43])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:08:11 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB4740.namprd04.prod.outlook.com (2603:10b6:208:43::31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:08:06 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:08:06 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 09/13] dm-zone: use generic helpers to calculate
 offset from zone start
Thread-Index: AQHYxoDcRAw+J+Kn9E+jUkr7Kineaw==
Date: Mon, 12 Sep 2022 10:08:06 +0000
Message-ID: <PH0PR04MB74163DA1F438B28750E2D8829B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082216eucas1p1d3068e7578a88007515c2f4f5ebcc2a8@eucas1p1.samsung.com>
 <20220912082204.51189-10-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BL0PR04MB4740:EE_
x-ms-office365-filtering-correlation-id: 34821fda-bebc-41e3-2a98-08da94a6b010
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EWR3RztVCwPlcHvRSbhKMzDI6VPbpIh2KbxgTE1/WSjtgHv/Sscd8shcPt8dqmSJeFw4isPJj3HDoQ0p/raTX+R9m8PngCpuqsFvBaPe0aK2+IG7QslSF++yzwlAs5HKSWmbTAwFBKwYqElzrk8zos4dIOn7T3ON1CgPXyP5nSL3dutJKjX8ge98GibqAft6sIgzDWrjeJltwaaavLgGCU10gHO417vTI5MVPe7w4Ru6CWTbTtZQGM0ALeekk0qJvswp10bHCObwjaH3REAyHW3KrSFw76cbsBjYpyrnS9N+f6XF9hp5HSuHo9zJ6ITKjJl83r72OZkeMHJb1uaCNTLYgIWPjSmDRgsMo5e94Uy2JOofuknB8EpFZo3gppas1vb37PTU7dsh1wavJ9/5r9xKwyzaOcOX1Efj9AYRCQMPI0xWxBHqjqlTFw4fEzz9yiJq/1yZbeW1WeuhiOOpjHS5iag5/xS2YJE5fGAFNGA8YsOup2r1YPeICcrEETmwPh3amoYho5Xh9LGW/ZfxXRFnM9OMfTXmL9ido5G+/8jUXo8cIyKRvvAGagsA83auN7kM24YnbR76Ne/uMxs/8oEJgnH1MTle3qWMFonVjVjlz7t6bEVvNl6VqHAvpcsXhYjM/HgB0LS/VbksYTtbI2bOvg+gQBnzDuyhEO8WeeGm+GxgQ45evurv/UAJMD/g8KXoY51ZiFjshraNXbBhxl/otwJgTQrJpKF64Vdrzewxks5GdJnoSx5d0zcN15oHnnSFNEWoEDniIr7DXRm535Xj2kJVrnvG2Lsmb2FRRKM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33656002)(5660300002)(186003)(4270600006)(52536014)(2906002)(8936002)(19618925003)(7696005)(6506007)(9686003)(7416002)(41300700001)(54906003)(38070700005)(55016003)(64756008)(122000001)(76116006)(478600001)(91956017)(66446008)(66556008)(4326008)(110136005)(66476007)(66946007)(8676002)(558084003)(86362001)(316002)(82960400001)(71200400001)(38100700002)(41533002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UM7YEfYi1nD3kBVSxhT4nTAYzgkQOe2ER4MrQe6wtwtJZriqTEIES1DkpT?=
 =?iso-8859-1?Q?9HqlDpChFV7U+7wEWweA6Jph/bmmKYYvgZcJx684Y1HewLRlOrX7131600?=
 =?iso-8859-1?Q?5nUYFmhuUgmUWwg9meSJkWdxUfPX5r68F0GHqUlcTH0JE/lpbYFOw7rYPV?=
 =?iso-8859-1?Q?pS1q6gIBZ/in4O24pgmIf2ZGQjevz6o1r8TdWisAzVSCAovc8Ubg9hqqOQ?=
 =?iso-8859-1?Q?FqWWVWYDNiEAPQVKBn6ncqCWEmYuE3w7vJEL4xwXBYfAkSzoy9JZLPV0dC?=
 =?iso-8859-1?Q?l6oigKIYXo4kZf0mY3VBe5VH6vy+M1z7jA53uERF2bDcqQlxzL79YXptf9?=
 =?iso-8859-1?Q?Bd6S/CU9VczN8POepgM28Q7fke7a0mOI7UdMyeNGrKlJ8KojkGCAFvICjn?=
 =?iso-8859-1?Q?hsxuq6VnM1OGXwrBcGb45wKQCUwTfZvg8DJSYNll4qgOhghExfe9iSzruk?=
 =?iso-8859-1?Q?WRSlDMqX2KowVzdzQldEIP0tE6ecTt8VQ/4v+utb0GtUf9SVryXuSIE9dm?=
 =?iso-8859-1?Q?gzhk3EqHBI/c+cu4tQ7a8K1haA8X/lO7ZxUwSfj+voimC5cieIt5kzvvoB?=
 =?iso-8859-1?Q?nvIuunlGEdwq0KPqhedOhv+am279B6ZQ0HVvophAWb4hfY1Uvl7+4yHZ0W?=
 =?iso-8859-1?Q?WcuOQuY0vZkPA3die5+VAIFTfm+pSSrTnTWSd7NgvWJEhDaXesb/pQG9Yf?=
 =?iso-8859-1?Q?EINNTxj7/fhdsgjsgdLvFzcKZ9dsm3oKvUwG4/W2p179/PWcGpfg2nV5n2?=
 =?iso-8859-1?Q?DoKXNSaF/UtCwNY69aQdslQt1OpatV057C0o+BcbAoPB2a4eIrb7yl6qk6?=
 =?iso-8859-1?Q?uyBpexGrZHNRr1TZ1rYkMdWS+2Hai+mUmhdy4olytGEBP2Y+LNeMKiMFXj?=
 =?iso-8859-1?Q?zpHyyQeDsWkAeWmbF3LcGQap1byzqrvIPjfiiX0IsjvmspbbGjDF8RHMum?=
 =?iso-8859-1?Q?CzzzuFxwrJTB+mBK1PVI+ECLKIs3mAqOlAi+jQTClvx28meTofREboBpOM?=
 =?iso-8859-1?Q?D13IVKuCZ9LfUUGJgxitQMLVwxsqoFDw4sUbNc2hbRz0PCSkH2lOMlR2Ex?=
 =?iso-8859-1?Q?tOs4Igf+8lcSDDTH4eT2gXnX5sxKPys2qKvdL7pyrp+clYoip7qwSbdYYq?=
 =?iso-8859-1?Q?ew7hX8EvLRxYOOnqUQbi59xy0l/J9/8NspRwDJ+kM9auC07HAFTR06s5yn?=
 =?iso-8859-1?Q?lpmf24/u7t64i2c+7hlXUq/qxfk96cSx6vcYc59nsfEiSfoFxWHZmNggp1?=
 =?iso-8859-1?Q?Q4oD0tnz8FeG876Y89K0gRXzDxHOI4AEMua5Saw/nWF7vhjMRNP7TJJ6o8?=
 =?iso-8859-1?Q?9NoYZ2cyfUU/CKnfTYTJtYmZ8sWKlCfwXh9+W0GqxyKYZ3tZlK1ct0jsjH?=
 =?iso-8859-1?Q?VldZDhRV/d9fCaUGD6uHg/vtxdRMboD1RsK7eVuw/jczVavzVrWEXe7qHS?=
 =?iso-8859-1?Q?1JAPBhlKzHqyTsvZ6nzjASGD0tv7hk/vqr9tqDou+arsZSf5BnIcXtzM/a?=
 =?iso-8859-1?Q?VAvRX7v4JYLl98JnYUGHHjdpCEcZmwHtA/EVCYTHXRyMUR/JDr8PZAynpO?=
 =?iso-8859-1?Q?9CCP1ccZVgiW1uejkpmj5Ii1ea6iWxl6tOSJqhomLt+D1rZ6qCh3ocUUFZ?=
 =?iso-8859-1?Q?i7dbxnndQV08hM2Xg+SqGCBDUQF4Pjc3VS3YZiaZCRDUbeQFACHHh5GY7f?=
 =?iso-8859-1?Q?MmG2CLSqpddc3U2AfuFnHYuk3O7Tog9uvebCWe6bqYKfw4TOThTSUdlHEw?=
 =?iso-8859-1?Q?pntwQknYryXyf1X3wR0870x9Q=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34821fda-bebc-41e3-2a98-08da94a6b010
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:08:06.5521 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9SzuZvstdJ6Qnpl5nZpfs/eUcJ1EHxc3boKstXoH+HPvoa2Bhsplsvvo47rjoVq1+fDTBUtchYm0V6yFV+lRmQTnWUsv2/hkOr99fHsN4Fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4740
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v13 09/13] dm-zone: use generic helpers to
 calculate offset from zone start
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

