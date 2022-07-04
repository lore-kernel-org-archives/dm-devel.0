Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB977C43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941019;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=Tmy5Bv2o5BxkIuTaLda/BcK3s/eaHRsM1FWk9mu+ndiFcCq1DrU7Dn0zr9ya7sbZ67WUdl
	eIPpfwcgnZS/uqaMLOZhY2+y4OMe/CuTFvBe6t5rkRp6PpOWnonVpVGNwedlHJi5fvbYUw
	TeFukcSOAb2vRYMLRSDjWnnG7Phx8Cw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-OYvED-DeNJSqW3IdPbt93g-1; Mon, 04 Jul 2022 09:23:36 -0400
X-MC-Unique: OYvED-DeNJSqW3IdPbt93g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5421C1C00129;
	Mon,  4 Jul 2022 13:23:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 416DC1121315;
	Mon,  4 Jul 2022 13:23:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC6971947041;
	Mon,  4 Jul 2022 13:23:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63A381947041
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:23:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 499F31415130; Mon,  4 Jul 2022 13:23:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4485F141510F
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:23:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 282621019C89
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:23:34 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-cR6Yg5bUMPeRgpf4O2Qxkg-1; Mon, 04 Jul 2022 09:23:32 -0400
X-MC-Unique: cR6Yg5bUMPeRgpf4O2Qxkg-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="204767331"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:23:30 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CO2PR04MB2152.namprd04.prod.outlook.com (2603:10b6:102:11::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:23:29 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:23:29 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
Thread-Index: AQHYj6QASEyytapJ10WFibhlgH8yCw==
Date: Mon, 4 Jul 2022 13:23:29 +0000
Message-ID: <PH0PR04MB741681AA0BD262865045696E9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-11-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2331791a-3fde-4158-76e6-08da5dc062a2
x-ms-traffictypediagnostic: CO2PR04MB2152:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QkKy4jes4Qi+4Ur471ng8dpaMuGYrNdD4onWo/7VQq93/dix5rWW6gygdZZ9mImvIuhYzcGJs6EodVNEs9z19Xmd8EOSKcZUhdUN3nqW7/AdDk2XVxjtFHEPZXQvC4Y7BX8V76+g3DIn46mKLr5GBmJCVtgGBe0gy4wSS74UbroM+GRXMjdHwnEi3EH5iauli1O34VGy8Rxh0CXkBx0tzJ4FpurCQ2daZDZSaQLY4c9x8XsZLGmvaUULEi6QC62AZQs1kF8L/ax/E+LQG3A6O44V7494CP1DvtdKxda6bb7RIUIZndewmTRgvsCwUMV7QXP5qwcQRpUTtWnqo9KUVH+/6jkQvwktq9mZrKEawoR4xeKzkHGzHpiasTodGJzFi5RMc5VFiKgdaFC5pSE+6SWeJiUJGbD8B4cm+hBETQNmTf23nIjbGhQ960QKf3Wm07gWSzPluJuyZW2oVlaTLVLqY+MfOLFDT+hnKUml2F+Ui6RfohF//Updz3W+z0YH7Ems3HzC2IbSpijRzEXy7wQigAmZVfeIB/f6X8zcaa2SSwaTbKgyGRv9r6jYx2aLvazdJKIyDCA5hTKHsxRuV7WWMhLev5Rw6sr58OGg9eHkdbOt+C2coWWBcTGCac4ZOe8K1FImEq+0QX3J6cr02lnn2Qu15XbpEaeTTvkKq+48bI4ZqajJL84BK3RcjMDbjFogFvbYvtzpHZrqA9r8cqY/zNGZsIhJoJuclzN+NvgAFU3DdPa+l2RpJ/mUd/lZdQ6Ncsv8YbYrw+EUhRRkpP/aik08wUYFFXpP9lyoZRwBqywEaJlCko+FjwBfT9Xd
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(52536014)(9686003)(5660300002)(110136005)(86362001)(8936002)(6506007)(7696005)(76116006)(64756008)(54906003)(91956017)(66946007)(66556008)(66476007)(8676002)(4326008)(66446008)(316002)(122000001)(41300700001)(38070700005)(82960400001)(478600001)(71200400001)(55016003)(33656002)(19618925003)(2906002)(558084003)(4270600006)(38100700002)(186003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Cn4aT3kqXreR30VD3JbVnlTk/72PpqgrLJ++vUw68SMJSDENvMGNrDJeO67g?=
 =?us-ascii?Q?vEvIogtmzH3QgRIbYJuRw/wZcYCA0/6ENtDEZkoCevdqWmO5SU54+McluXsr?=
 =?us-ascii?Q?EWYiHYoNUMPJRsBqzY3gIZeJ7nO4haXVZryIyz5jxpko7ZUyIP1fWOCtH1xi?=
 =?us-ascii?Q?ZIsHH2pNUwPYervMGJmRtEu8RYJ3MOhwms/8H+PDHayioZIdBYKzqcf0fa0H?=
 =?us-ascii?Q?fq05gkXB12Hyud0JJCkSA2Uv9be66Q8hdln1l9kbvL8PgvAigUnbXf738sy7?=
 =?us-ascii?Q?/0SvPlUMdKOgg8gLPdtTfO73Q6hYaR55yB3REv8YlwTuQlSlsm7tUplNg0hL?=
 =?us-ascii?Q?An7oUcAhGg7pfUS7rWxxSyCl8pyYa5eaqq8iItBMTiujvjfad7HMM90d4/dm?=
 =?us-ascii?Q?TXvQAcjVhwsnnqJF8D1AJC4axg/tS+hWh70GATkJKxDHY5QFnZTCvz1CuCNH?=
 =?us-ascii?Q?TJVlRdD8S5Y3ziobP1WAKr3WlugSEW/psaooUiD4l59BVL8v0Dr3h2kabIox?=
 =?us-ascii?Q?q8S7b1vnrcXAYnlDqlKNzCekZ5oge8HLI827lwAtTFnFsVVvz8H5yLvdGSSm?=
 =?us-ascii?Q?4Qx7eCIuZ7tnVBqZnacUNrDtf7wO4TEuf/I5WlGcwEJgdjAFTdzeBDSPLK/W?=
 =?us-ascii?Q?o5E9rDScMHy4eyFToHBH6AiSbBQ8NOpQBjmdOl8tTRCG2njTD9st0yL0Cwj4?=
 =?us-ascii?Q?NOWtxPvOm7lmtQ+exgzBz72kUCn51ZbrDEGccoZW8RugxzchWK34hWbmRxxe?=
 =?us-ascii?Q?eyVDQtmvQmn8Sebewhulwibr/dOKOwPFw9FKIAyfGiXfAzmq6SEZjwHmMg1+?=
 =?us-ascii?Q?ayYO5ykPXAaWMeefzzz/jrE3zCaNBgVaAZZZKjxg2HpVB0Y+mh/j7Uh4bvzd?=
 =?us-ascii?Q?rjBQO1kjDxlVlnWhDsTA76k5uk74VFg5+m15Uv6pgix5d36z6E/NIKK45Fyj?=
 =?us-ascii?Q?viHzWf9DGw/lxnrR59wuJ/tPrUKH166Cpw0kVOtLNcMLnS4vdgcaNMJ19orY?=
 =?us-ascii?Q?QHT8nOam7NhMOPxvM21JnkomGWQ1jFRvPxP5/wmlP8UhRCD+QU0lDFQZMZrn?=
 =?us-ascii?Q?pUFvX5qTK0bF2PSY8MIoPHZGZVgEymr7sxr1bK6uFCIgLMONwWBQU7lzaJfw?=
 =?us-ascii?Q?G4N9Qb+uxUWQYdim4ME7Q53qJfnObpTArjJtLyzsucrOPb0l1OfoVtkqqX1G?=
 =?us-ascii?Q?7zGq9gwiWryVwnkPs+NXJrj2dGeg8Te3ojH8tCSibv42wtx0O3dPGcfRErHV?=
 =?us-ascii?Q?AzIx9Ji1LIVQOsHh0FDyq/H2P1sr8Bpo0tvfgv8qZ53H/ZU9n9Y0SIqxMETZ?=
 =?us-ascii?Q?boabXYM5kV93OBRxY3sdyPUypBDNZhhLRKw1e1sezFsL3IeXxF18p1LU/6uI?=
 =?us-ascii?Q?pm2odcjP/ZFzxGlaN6jzitRZ2Q3uXacS/DwxSCpRx11uan8Th6LyQodooSp6?=
 =?us-ascii?Q?xT1QiLiU2jrZufWarL9RYdktN+CMT7ryPdlc1aKO4JSSwDN0rG5WRK9npJku?=
 =?us-ascii?Q?5xqWFpSaBnIrHnJogF9PVVwKxOFEJT7xuJ0wLqn2ynig+Tqs/ajSO6l6ObWk?=
 =?us-ascii?Q?XOrEjUoTt50hq0DcwmISBUAvpfOoMe1YT73oeBavEDqaLMQEvFoukLePPsDx?=
 =?us-ascii?Q?qT5BQ0tqqUL3qt4bLPig0KHZ1P/iN/1SeetnVRoJaCHkehVzfYz6rj+9RwvY?=
 =?us-ascii?Q?lULyt5Bi4YnOLhWamenph2cKyuE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2331791a-3fde-4158-76e6-08da5dc062a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:23:29.5951 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bxc3qta+cZdnzm+UFeJ/wq8aYg4Sd8p9gg3ZM+VQ6TiI9FAFBkW63YfLI4jWiSGvvP3bv2/go5MAlk6VnLH0mD5T56H9AhOSAwE49J9fI4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2152
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
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

