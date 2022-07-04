Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29DDBC43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941279;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=jKDCvzX6FRWuqxgfn6y+c507rOe0f6Fj3W4IpESKjlAvEAKHBnLGnX6ipNkWXWlR0iCQOt
	QUkJlK8HJdc4OAgKjGOXncoNm6b4IWZVtrTaHOQ+32iXUzdStNQn1DfT42DZGN4Dp/8ssE
	GfitPxkYNj1HFQMoKPqjPyIsen9PKeM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-cKgGOPrMOp6N9xG-ljMfbw-1; Mon, 04 Jul 2022 09:27:55 -0400
X-MC-Unique: cKgGOPrMOp6N9xG-ljMfbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6382B1C05EBE;
	Mon,  4 Jul 2022 13:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 085802026D64;
	Mon,  4 Jul 2022 13:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B794F194704A;
	Mon,  4 Jul 2022 13:27:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E369519466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:27:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CA66F492CA3; Mon,  4 Jul 2022 13:27:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C56CD492C3B
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:27:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD192801755
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:27:51 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-BtK1mumrMz-h7-yDJnDq-A-1; Mon, 04 Jul 2022 09:27:50 -0400
X-MC-Unique: BtK1mumrMz-h7-yDJnDq-A-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="203428533"
Received: from mail-sn1anam02lp2041.outbound.protection.outlook.com (HELO
 NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.41])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:27:48 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:27:47 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:27:47 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 14/17] block: use bdev based helpers in blkdev_zone_mgmt
 / blkdev_zone_mgmt_all
Thread-Index: AQHYj6QJhV/jUhPC30WqDPob4rRZfg==
Date: Mon, 4 Jul 2022 13:27:46 +0000
Message-ID: <PH0PR04MB7416938C9ED2EF264149CB2E9BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-15-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8eec4415-791c-49de-c309-08da5dc0fc0f
x-ms-traffictypediagnostic: SN6PR04MB4640:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Z45Cr9w2EdVUZvMCrIZOA5g/4ZUMUJqD3JquCDr4MQtL02FElzvgSo2zXCQSnZzyQBkopRpjiuLj4Q11a7gXRoxdyeYnqPkEMCZSokboH3Q6GVqSqj3uakWCE5lM+usq9fq3nPoEk+LdNUcW0ARsatrlE1EfRcpMu5fOujvvyj/jnhVB4UQA6z4uIRpnqkgp/qeyJJcVryWCsbAHvpi0/QBO3di1rK9CtD+p732xfHG4wptYaHD22QqoJroFg/C40zvewNW8VmDOmIWRifWGpe5WKSogVe+/ZfNrZGC/ZjxXbDjPPtzoJ10uoolZHyjNED72Si2BZyzD0P9fA1QknKznmZBfrUK1Tva3sg5cUExFL2l0ELRMHNlLO93ysmHbiF5/y7SV4ge6zdNugzOUn0w5h8OyOp4PvByYvH77A+3fQ2qZ+A+rwpQQqyJCL8FFUIiBFrbsRD9+hO4+IjrnxMjPIqSzPCWnjjpKvkFWDzd60UwP9sTShWCntVF+QAJp6olSdiGnYNsr8MwlK5XLEYfWjXo9/UL8eFmVJNaKHF+GhnYkMTLJV8wj3dNoBLl71jlAyZI9HOi9xdRAROyVFJ48NofYw4EwP3al+gZ9xM1jAq7q9YV0t365vONNOo7BAaVtbvafLvERFM5sNxf9ybtiiPjLz7Xxv8rqzVPHVO07558lYrkG+8qkqYNWhgTD4bJO1wHwyRBUeP3dArZ7ZDxeA3ljVYds52OlrIdyGwPvL/B08QEpzZPsmI1XKWi8OLSxlMzdywDMI/EE86x5mVu6Mwq9beG+nZtfdEUq5PWpew40ZHEPbmuKdPg+JEAy
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(33656002)(38070700005)(4270600006)(122000001)(2906002)(5660300002)(558084003)(186003)(82960400001)(478600001)(55016003)(19618925003)(316002)(8676002)(66556008)(66946007)(41300700001)(66446008)(110136005)(8936002)(64756008)(52536014)(76116006)(54906003)(4326008)(66476007)(71200400001)(9686003)(7696005)(38100700002)(91956017)(6506007)(86362001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+7cgCNtDWvBqdCRm6k8imSv2q/uAJrq1guOvU0kCvZe3xCBuAz02rg8zye8i?=
 =?us-ascii?Q?qpWmcFriN6FOz6rasRF7UkixCg4GAzDs2WWseW/HLSU7g9G6zrSxigEdtWHj?=
 =?us-ascii?Q?sBKGSRazRubl15KCSsAST0PYo3YhfOe6Ng+cji7co8YF2nFFmkdjKLEQ5FZr?=
 =?us-ascii?Q?l1H2QT/mpJ1FODuvSbAnum/54HpSqyzxEagS1MxSCDxfdQfpOnbJRd+N4J2U?=
 =?us-ascii?Q?TgAZMAAsdPlMyiLF8eI5yU0Ky7ro47OFFIopD5FKpUNe9rKyUmVKcEHWHd4e?=
 =?us-ascii?Q?hE6zobQzia4A3DX4XuyYDHlyfjdWPFmPeirUVGii6pb2CyIWWUO6cu/CF/pl?=
 =?us-ascii?Q?gXIu/M/G9hNoh+8PqkKjujOxh3cI+7i1v11ERf7t3mToexn8xTKubN12YsUy?=
 =?us-ascii?Q?0k7b6Pbcf3I7S7mL4jbbDtt2NwH1xbBLlKTd+yNKqaSCrvcSp21h83wHRt/F?=
 =?us-ascii?Q?Odm6f8TQ6eiPEmIfKJCisC51CJJzBWe6VwyF2t6+1XHoGm0rUJ//xvvaVcGc?=
 =?us-ascii?Q?onm+4wEozjJ1aNBMNkpgM+zRM/ji0SKvHAzHmFYYc0YIoAXVFLvADxzWtDCi?=
 =?us-ascii?Q?pdKQY1Rbh8L5WC16oT9JZlzvXY7Z4G2obJ+fq8spwkzpnaY8glX/5cf9mqXQ?=
 =?us-ascii?Q?nLj9yjeXofIzP5GnvoNWkc/jYunkPPmoq8ISDIcxoRo2USt2zWdIAvwBPGNK?=
 =?us-ascii?Q?xgMdNI4H8Se92vnlP7D6AEEtVt+7utL2sPy/6v+/oK+OsJ6K5m8TedIbzqjX?=
 =?us-ascii?Q?LJwHRy5Hn7RIu+anMybYyLGsqhZ7yh5D18vV4U3YABdUPETjfq2D03TzCBYY?=
 =?us-ascii?Q?8syG+hQphSGaMV+3oNc+d8aqqiZeEe0bbrKzck+6lkcljepMEw2gVWvUKh9h?=
 =?us-ascii?Q?2giSNF7TO3TA3ySTgNN3Vy+721FsHoF9CX1RMNdbnN2mbFff64WHd/KDVFoi?=
 =?us-ascii?Q?ASaxO+Bt6LHtG8VNyF1IXxNqEH1jXoUOvaD5LLWuOKXR5lhiWABYogorssv3?=
 =?us-ascii?Q?3rowAHeICH3uT8PP+fKVLjcRHCOsEzMHBI2YGeh1MYRyYJ49/ASASEC5QsME?=
 =?us-ascii?Q?gjOr/CdDgeyC/XPvVAZ6s8aNFPEHNtoZ8qRy7ns0UgHBqbS94OB/nQ27Dph0?=
 =?us-ascii?Q?rzrBTijNx6AkL1uN8svuzBPHVwisE0BwnMMK1AdgHe41khofDY4sBDUmfNsn?=
 =?us-ascii?Q?VLUh1XciEhKD+8ZcjCmYR3f7Z/TnsvXYoYB7JePyZM33+3orfgJW6taMtIzb?=
 =?us-ascii?Q?TTpONkoxt51sm2M2wJMETCwomjHx3AFb8igPN5JVKXZKqQ0GtC+EtLQww/eO?=
 =?us-ascii?Q?iA9ilQhUV7cVuVznP4BlCGm54gIsNdtlReDV9ku2ySezmI0BFezXMUGCObWf?=
 =?us-ascii?Q?MTVIwO/yj/NfZzUAWTGTgg11Z7yaklk7MezHU7HA1lUsCetCheB3Y/tRnLdV?=
 =?us-ascii?Q?wISvaUnAnHbKU+5+iQzzlcLj0GlnzxzExnwHYu4YUgNFfHrPOQgQFrMTSKZ+?=
 =?us-ascii?Q?Clts9qH8zKDTWz7NCSXyzOmE+uvATZrs+rvosG4vyhWaEQgG6dsOZzIzXWEY?=
 =?us-ascii?Q?Aj2kUPxwQSVlvSKlm2OLYRBtQBcAChEGneDg1iN0H2pCIeEDjLLBZ885tDAN?=
 =?us-ascii?Q?zvMIry7sp3FG6RO7ID9Y0MtCBbGsvqN6SSpy1FtNIum5pPKXrm6og1PdCx8J?=
 =?us-ascii?Q?53EaE76Bf1DWm/sFseWnbUvIXYU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eec4415-791c-49de-c309-08da5dc0fc0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:27:46.9717 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjAx7d0NZGX7eCamTJ/4zWEXdDxJE92nnRShqoN1GYYxhXhNs3vKZmhl9X+HIa4yM38N2JjLXqJVKq6MgKzbsxFFVhA32tlY4S8O6MRKbNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4640
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 14/17] block: use bdev based helpers in
 blkdev_zone_mgmt / blkdev_zone_mgmt_all
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

