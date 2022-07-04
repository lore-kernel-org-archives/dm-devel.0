Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA73C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941358;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=iH2xM02VBtG69EVU+SswTMk04M7JqgUrPdZGbQxSDE1xR72F0+XfT2qX16L2V3RJ4jy634
	krMs/xdI5SPAqJaFp2elhvwnMhzazTSju8wL98PrCIjUWTIz80SI9/y/hBvGcSxUniPp3x
	UsdLD8PzCPO506HglKSBDVigGafo/9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-wPO3XSdlNtS9BJzXY48iqA-1; Mon, 04 Jul 2022 09:29:15 -0400
X-MC-Unique: wPO3XSdlNtS9BJzXY48iqA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45996801755;
	Mon,  4 Jul 2022 13:29:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2F3DE47500A;
	Mon,  4 Jul 2022 13:29:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E3A10194704A;
	Mon,  4 Jul 2022 13:29:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01613194704A
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:29:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E76751121315; Mon,  4 Jul 2022 13:29:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2547112131B
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:29:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8899801231
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:29:11 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-q3jBc_jROQ63OIbQw9DegA-1; Mon, 04 Jul 2022 09:29:10 -0400
X-MC-Unique: q3jBc_jROQ63OIbQw9DegA-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="209661083"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO
 NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:29:08 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7253.namprd04.prod.outlook.com (2603:10b6:510:19::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 13:29:07 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:29:07 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 16/17] block: remove blk_queue_zone_sectors
Thread-Index: AQHYj6QPLHSgoyaazkONPu0LXTiOgQ==
Date: Mon, 4 Jul 2022 13:29:07 +0000
Message-ID: <PH0PR04MB7416F0D03312B064C29FA7BA9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-17-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08a0181e-0e5d-4768-3623-08da5dc12be4
x-ms-traffictypediagnostic: PH0PR04MB7253:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lyYFMVVFfMFRlyF1z3qT46jg28D+TRzD2+JCxi6junZQhzvV1mj+OuZdO2kJ+TsYNVB44auEsFNyCejIePbla1FZWs8kHqoI/tx/BvV0BkzIMCEUo/FsObClGVk5VpQ0QPpN8pm4O7268DBQq8c7oyKCZ4hT3oahftDxaFutD3XvGlu9/yOprhVE2aFATqHo4eqrgS3JK81XHFeKm2YZSKCagEgOsg+qVzxf4mTQsGEZsycTGbRM31VCshXbz0QJmsbbJxnw8aJAzxzXZSeG3LdX18GcJwnNuPQZ3LRlJfJKLFfYFEg4vBLhBxbPg+HNSQvmB1v+SsjW4yVEhdATmJc4s+nhwqB81nu1qJpy8iixqtAIYpSC80zwX6RdeX964sBKFD5FjAjYDfsYX2Nbjzz4cnqV7EQEn9YGxwBj7W+Ca/DHQ0kurTjK5h/ukBsrzquDSOAnCoYMuz46lgXgZOKcHBHlSj9lQ2DvM73/zIe0bWN4R36ydUOtGGtmUDmPhlw/0Lk7LhN7K+XU/SMMkZgwUlbtpDO6rLAOQDBUITYs3kD54lMbYKhhFc5zsAYF7ADCJ9lH1Fcwj2Hc3Vahgip3mBW1/U7HpqV3lHo9znFQQxlVIipgc+tolTsEOXtGhlhQGLrYJVeXQJA6wWy+D+xoQw1h37fvl5TzWBDIMtGupi+iwQqBALlFSeIlKWsSNVsCjXkkTABE18Ly9V3UiMXkdRTwFZX3IhYBAptr6zp+go4T7+lMknWoeeRzSecT/ww9QY6X/2bhWgT5WVLEJ3zYSuHcXdeEqvEoLlkcfkrwmP7HfCnffsk6A6zaQirp
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(186003)(55016003)(8676002)(316002)(76116006)(66556008)(4326008)(66946007)(66446008)(91956017)(64756008)(110136005)(54906003)(71200400001)(38100700002)(33656002)(6506007)(8936002)(7696005)(4270600006)(558084003)(5660300002)(9686003)(52536014)(478600001)(86362001)(122000001)(38070700005)(82960400001)(41300700001)(2906002)(66476007)(19618925003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5TyCkcdORhzik+xam5ow4a//YvXeL0qD6eNUjpQHnME93txHOjgx0dYAP01i?=
 =?us-ascii?Q?Fi7SUzjYQBsVLrdoaT2ecd5udKfrCE9Be0WBoibIaAhyFVHFKq4RKQHQWIkx?=
 =?us-ascii?Q?M2b6FIWaBB2Kr8M4UuX2vRgalcDy0VXKzTpZ2n/MMEm/fXN+Om+pX0Xe0b+V?=
 =?us-ascii?Q?92uPAVW4zO/FaTyS50CvGUUQhBu5jFdJvX9XozZwHqB7y498xCBu4JWMFimx?=
 =?us-ascii?Q?XYUFA7Rg+wDod0Y7l5eVjLE0idjSlGKAsRInhBYdLsKoVzMouSzKgjv5YXFV?=
 =?us-ascii?Q?1rSqd0fukkAISDwWNtSRGk05bNoJGUeoMQQxdpA1jK09rf617MMJoHtW5jwl?=
 =?us-ascii?Q?6RG5IqFOY0BEnjdBpwv1lcGA1mBbUZRn3FMn+AZRCH336SvXYmBEYGN85xZQ?=
 =?us-ascii?Q?v/0zndGSJAOlHsTxANlVbAFfy2AmX9qiJb4BHywDChaQ34+ZrEd+8wY5MEXx?=
 =?us-ascii?Q?2wCHto91McDdqm/iRpMP++6z2RH/qSxeegBthKAW4+nmD7hKtCXzinatgfy3?=
 =?us-ascii?Q?8Z1RDFiMA/dVgbf1gytS6pyu1Z7f/14hwFKiabx9Ie+i3o6Zt3ZruxdrhQk/?=
 =?us-ascii?Q?Vl+J8W0OSeY22wUj022on59zfEo82D/uIdzi39/0O8KZQfDFRVYIFvTOjUqG?=
 =?us-ascii?Q?8gHzsrT1KP2pyDkZIwV2+dz+xm7JITkDXYeLfgXO6fuGJ6Ivgg9vBrklWfx3?=
 =?us-ascii?Q?w30njhi/9FEIwNkSmpVIE8xlanJHj6fgZOBZYj/rao+ewOKxE3WDn/rSQ4eX?=
 =?us-ascii?Q?9TwzNYOHA4kPrdWwwTncTBB6XVX2oZ6vKf2s9iKQfw82MbfOyeoBMP4hxydO?=
 =?us-ascii?Q?ApaWujOydj4nNDjMopPQ6vHvKqpZUSXv+7PZl35TSXywqY9VycHT6p50T0Ri?=
 =?us-ascii?Q?96JeLeN68ROojYAvOdNKRKATR8rW8Az/G8K9tHse7kufJFL3kQe8wkHjnABu?=
 =?us-ascii?Q?WDNgKX4V5FrXoSj5z1XV731S56xRsvQ3cVLw44SH+QYWi1G42E6epKm5BAvG?=
 =?us-ascii?Q?3d6nR3TTkueD+LFKgAFifo54tjLKghRYK7aa8qeTr2hL0O6RYBCn7y9RUudX?=
 =?us-ascii?Q?jfsNQG0+ctBjRvhFM50Fok2FrLDtRCNXxsn0UTm38dkMIszoEpUjNHiceSSP?=
 =?us-ascii?Q?4l1CUj0tJ1GXfCdn4+6CapPkfsh0E1rwEtB+LwRmVXlAtuG5JiePlmJzUItu?=
 =?us-ascii?Q?qHLzH9uFLE/juiolSVtf/L++OMdHqNgeXKLSxXbZP6ReVh3daK7mKVQayeZC?=
 =?us-ascii?Q?RvG8bModOkVmEUp5oN8zhMkr3wxnLt5Y31wPyiFvZilzZwqe1JSQJXAqAi6m?=
 =?us-ascii?Q?r5C4xODVdydHjshDQn1hLIXS9HsikfoQzte+T7d3R0IN5bnkR+OznSB8sgb9?=
 =?us-ascii?Q?p7aurx+A7aNxbywnSxowETGfKJ1HInioh26V0O5vTxINNjjfwsNq5RpzcFbC?=
 =?us-ascii?Q?8RiAvaLkNyQnPQjdFrglbjd3p6Kn+8u8bLkKktQbp2/fqYoLQpxhBMm9d0XG?=
 =?us-ascii?Q?sxP0yFlZAkXA3Mf1JyFN5gPJcvH9l4EGM1NTacbavYiMv079MWIMsgqQ3lBQ?=
 =?us-ascii?Q?6r5ESVWeAKm+3OjOjyYDXWTPb7f1NI2xFs6GlFzu9eY+f2GXIvz1b3TuKwsy?=
 =?us-ascii?Q?XRtWKerZEjG2wRI4b47q8Z0lR+4+3ywHXyNQwDJiBCh0XTZtMADW8RxBqP1g?=
 =?us-ascii?Q?iKBTMz76IcdJkWykAHf6TKcjU6M=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a0181e-0e5d-4768-3623-08da5dc12be4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:29:07.2482 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: heKr0ZBanBUSW93Sd6gMRwAbdhdc8BKaaCP/J+8NsNsjTjVx1p1ZDr36YgJ/99sg9UoGeNruyBaoNsJJpl9dnMEH0dyiYS7Uz0hwU3F1k1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7253
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 16/17] block: remove blk_queue_zone_sectors
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

