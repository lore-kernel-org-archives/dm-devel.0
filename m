Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF12C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:13:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A53AE6135C
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A53AE6135C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-D9jqZOk1NCCXv0R80dRY3g-1; Fri, 21 May 2021 01:13:20 -0400
X-MC-Unique: D9jqZOk1NCCXv0R80dRY3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DC6B107ACC7;
	Fri, 21 May 2021 05:13:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F15310013D6;
	Fri, 21 May 2021 05:13:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 02BFC180B463;
	Fri, 21 May 2021 05:13:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L5DCuU024074 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:13:12 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 98D0921111D4; Fri, 21 May 2021 05:13:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 90466214DB91
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:13:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 762A280D0E0
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:13:09 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-302-FXB3O5FJPi6gMxbDdbOIYQ-1; Fri, 21 May 2021 01:13:07 -0400
X-MC-Unique: FXB3O5FJPi6gMxbDdbOIYQ-1
IronPort-SDR: WaJJPELP6I0uk/47STaA3iWSx6MRGZYb6DqgBIQ6kzIbahjQqePybB+nXlumoyJseGWOWFFM7X
	3gPyg+UJ5B321Ui+mamfQq4UWZ/G4K5X4OlkfNTgcdhYXJWuNzqw7Ei4etjAm7Z12gpiWXWCf6
	zo+nseN9YtU/vfdMPQAl7fFFAU2CWXjOBoLdsd6ArQhqVJvJ9/5NWAXVZqq9MnTkAyvPJuZt7U
	gU+ht+IRDxH0AYdKWEiINo0qvrZH1qhQPM27lB9Qd/ZIMIN5u9wbs9FNfsi0Tr193LeESzEuWl
	01w=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="173605137"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 13:13:05 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7255.namprd04.prod.outlook.com (2603:10b6:510:9::24) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Fri, 21 May 2021 05:13:03 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Fri, 21 May 2021 05:13:03 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v3 01/11] block: improve handling of all zones reset
	operation
Thread-Index: AQHXTe2XU1aQ+8ObyUqkoRB5QhQU0w==
Date: Fri, 21 May 2021 05:13:03 +0000
Message-ID: <PH0PR04MB74167C41F7BF7396703FA4CC9B299@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
	<20210521030119.1209035-2-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:f8bd:921e:9aa5:6d21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ba996a7-9645-4b55-149a-08d91c171c5d
x-ms-traffictypediagnostic: PH0PR04MB7255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB725523BDF43D4DF48EAC44739B299@PH0PR04MB7255.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cFs2kJVH6hiuZIsVKtEULrVrV3yz3/6ZCQxLSFY4FkbWIM7IOwka4H/BXp1/vgt1X+gy8Tq6vDHKJhXphBiyeKlQYUywlxbM6VhboVND6MB27IVQmA4QXh6EqnGIBM76KrLNK6mHuxpKXtLjRMrzhj5emOW46yJ2xTSkF56o6ACUkMolisfcU1sL3yWsP9eXXmCtC5a3YiVIEOEtzbRBKy/NxABEWYMML1nSW83ozV0Kizc+pAmgWRWh80VP5YPrDG97fpx4k759YvuS5Vt8W6rp4eB21Kaz0CzT/BTMHbDSSyWM3b7rkdUQv9nup99T/wCqByrhLx1rTCsQJBGkOCOVoGpjplIL345McbhqQk7VkXMLl715M98j8Ck4Njwl3T0mJTYApy7W0XkPtf8sF8q0n5ANZyVXeqH/bpY5BqX0b124cup0Expwals6+hzhPOTQe8rIhfY9vIdpzTiA6/F72dbeEPZMygybvJVQu92EdpOF1wP3M/XyevTNGUihjAS/oNG51O11t9O8ZTG8tSVR+jynIZuKRRUDcJGqreQyjtTsgQoZeDVr2QfzOB4E3HR7Lm6WR7NT5XhYWUiaMHuZFvy0cd+CGly+xdtph0M=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(558084003)(2906002)(86362001)(38100700002)(316002)(9686003)(55016002)(5660300002)(6506007)(478600001)(186003)(122000001)(8676002)(8936002)(52536014)(66446008)(7696005)(71200400001)(33656002)(4270600006)(66476007)(110136005)(91956017)(66556008)(76116006)(64756008)(66946007)(19618925003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aCwoD9wdAfBaBCd2s5QDCLVq1n3BMRU018pF2TFiZ/I0B4tyoaG25Pmser9t?=
	=?us-ascii?Q?47BoczUvxmTGDBZ7G4rtaSdRKpy+RtHwRXfgtca/Fai8AVqb7bnPJxarnzjw?=
	=?us-ascii?Q?Nbt4G1QdpMesPUTd6bbszhKr8Ul7t/vTm6PlsR+otDwkZ769NmEpT6oaux6Q?=
	=?us-ascii?Q?G36XKuQdmP3ljhf7ASA1jlhSoTrUVKl6zJ7cXcgTWnlsm6rCGAR9TDSYjQ5a?=
	=?us-ascii?Q?7K98yhXB2TPAa6JE+0Jfxh5eKc88lBRX4K9Lx3sFe1UmwhnoPw+4fok8k2DU?=
	=?us-ascii?Q?93iv0hZBrpVxpLpgvoUSWAUvXfzUsSxF+HOp+PNgBmXTAJRmw5nz51mknte9?=
	=?us-ascii?Q?uK7Ne4PLV9t8uZvM9FzMICOpmOmr/5fFJd5GMdrgg41qteogmwasTniCUlHl?=
	=?us-ascii?Q?Z/59QDlLx5x+Z2YsO6KPqsC/TW2BspAPMxSptwXH21+lvrN7mfHquCXVa4mJ?=
	=?us-ascii?Q?8XNmBLC4c8E4+n3JTUcSr+Y55Iu045F6pe/a0NhcAxXv6fCBp4+KHBs78wjB?=
	=?us-ascii?Q?CEIMGDPBFy60y7AbhkMNpbwf/612h6i6l1y8L+qe6N1FJTNIWm6oiPCXj/H9?=
	=?us-ascii?Q?BFnca4VUG9KkvTK/r6EZTYLKRFiQShd+Ej7c2nz1T+JF1dk0aryo6T8G9eM7?=
	=?us-ascii?Q?xl24Sxz3WhTddSluOS5L5tC6y4NEMlJiOJ7dm21+QQEGubTIwoIVwozQ/mxZ?=
	=?us-ascii?Q?W/nie9rEB63BMU+ZHpJny1vEGObTSAfVFsPzeOJRLrMGXF8GaCufu/KWN1U0?=
	=?us-ascii?Q?F2TyvX8QL8aso7e1gM97yMxg+8zVVF7cxwqv1OGolfKIuQSSPItkDoK1cYTq?=
	=?us-ascii?Q?ulFVClxejqPqMTc9fmFiUA/Oqp7rxxQcX8EB9CpKVEl5lperlsk7yMrJKyVO?=
	=?us-ascii?Q?9Toi+7+NdFv5RVqcIhuxw0vrvPtLrJ6jtt+d6lOzkfgnXkbKrskaQbCqBe28?=
	=?us-ascii?Q?pZNtbfOhklMvt48X3M/bu8/0TbHcq1dBJlOM3K8Et7Kiche+yIcqrmAJEtn9?=
	=?us-ascii?Q?Zz+42naOulkqq0gjFf7N4xG5z24iXqfm7OJCjSzOA7PLmzqoyoMwipzsLxda?=
	=?us-ascii?Q?Sb0o/PP67QjwQEbCcW/FAKRQxtq9XuFCzeRRQC8LnRdtXbMQJ9hq2kF+/Z+D?=
	=?us-ascii?Q?m3pP2WCsBTRvJ2HRqCN1AtzE5wV0ML8V5+K+6GXyeemewivFRyEbX2g+aSy+?=
	=?us-ascii?Q?gaDrBjWhXzk4idxk5aYrC320cS10+JHlkcHc0PRANSwiGHU2nE3HYsars//+?=
	=?us-ascii?Q?dv6PimrQpAY2J2MhaxXhRBrtbSAhC0nedSlGtbON2YS5ShEfGdebhZCjmyZ2?=
	=?us-ascii?Q?4fSVLeDRcoWDdWiJ1nhPoV2LKskCDT4QQWcqfU1dexhKDfd03yzfefICdBjp?=
	=?us-ascii?Q?UHN0f6ewEZ3aDdddcj4vZ1kyh8qfYS6w1bdBu8fTSICAt92DIA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba996a7-9645-4b55-149a-08d91c171c5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 05:13:03.3392 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bhfAz4rgLbJWYWr6o4rs6rdbo9z+BKUrX8uZXLfeCztvMyabUbO3Tjt/a54Y0GZh6806PILMuIO2yEU5Ftuv5su1Eu5NLmYEh5HrN9lHQKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7255
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14L5DCuU024074
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 01/11] block: improve handling of all
 zones reset operation
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

