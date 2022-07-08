Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56290C43334
	for <dm-devel@archiver.kernel.org>; Tue, 12 Jul 2022 08:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657613744;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7d462XEQrtqA+NhCtpL2yCdAq45dcQqT74qVysVrlN8=;
	b=Be1cTSltizHfZEqUtxRJ7enRJN/sOJV9g7lf8HCN1hnlKEGn4yrC2x13PETDYKvE76Uklm
	onyX1WtW0XHwB6x11oEoX4qh8PrZsnB4jS1VU7UJS993Gkej9NOcoPri6sbtqpmse1w/ro
	2UJv8wRWx0vs12BHHk943yLTumkOBCA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-UYDlW-iRNiukBH4Wguh7iA-1; Tue, 12 Jul 2022 04:15:41 -0400
X-MC-Unique: UYDlW-iRNiukBH4Wguh7iA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01774101A54E;
	Tue, 12 Jul 2022 08:15:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E13C1121314;
	Tue, 12 Jul 2022 08:15:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ABE011947065;
	Tue, 12 Jul 2022 08:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BB7F5194706E
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Jul 2022 04:16:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A10D81121320; Fri,  8 Jul 2022 04:16:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BBD31121315
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 04:16:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D9003C0ED42
 for <dm-devel@redhat.com>; Fri,  8 Jul 2022 04:16:11 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-jpmJXg_1NY-P1VlF5lTc5g-1; Fri, 08 Jul 2022 00:16:09 -0400
X-MC-Unique: jpmJXg_1NY-P1VlF5lTc5g-1
X-IronPort-AV: E=Sophos;i="5.92,254,1650902400"; d="scan'208";a="309486087"
Received: from mail-dm6nam04lp2046.outbound.protection.outlook.com (HELO
 NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.46])
 by ob1.hgst.iphmx.com with ESMTP; 08 Jul 2022 12:16:08 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 CY4PR0401MB3666.namprd04.prod.outlook.com (2603:10b6:910:8a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Fri, 8 Jul
 2022 04:16:01 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::3cc7:ac84:d443:5833]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::3cc7:ac84:d443:5833%7]) with mapi id 15.20.5395.021; Fri, 8 Jul 2022
 04:16:01 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: clean up zoned device information v2
Thread-Index: AQHYkoFuwNMgOCV5fUetRXO/+tTtxw==
Date: Fri, 8 Jul 2022 04:16:01 +0000
Message-ID: <20220708041601.pcefrofpmiw4lht7@shindev>
References: <20220706070350.1703384-1-hch@lst.de>
In-Reply-To: <20220706070350.1703384-1-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae156ea7-edd8-4397-64bd-08da60989179
x-ms-traffictypediagnostic: CY4PR0401MB3666:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Ij/k3dkeguR8fWaB4R1JcRJTYvMbAgew0lS7xScUkhomx4n5LW/vXldC/48hxmgyIwMnN0C79JFLbk5/0VYB+Ta5ReM/UmvlH+q0wXF6c8V/znE2L1yshXWR2CVj591+bhOVNyDtwURtQxQpO16I3HuR8gIJbDhJyJ0d6GdGMllnLIVSsLZ6Btcb0q1vmdZECFHjNLEbQBOzCi2nBgLxBe4wMq+mqnw77yZgaCzRgh1mPi2A/TncIh6ZcsMCGHx8/2/2OVXykTD1Fa48jXEe95zwEs0qJhDKDtRGlQPwRSTQUCrr9ZypApq+6uS7HxavSAr8nqxrem+bYucMrfToOZ8f1t1phCs3gQXo+/9QvZJmbkFFdv7yTrOn/C4LuNCzDXh66biG3zP/5gxgTElR4PGUZymepkpeEn8LtoPrijm1pihrJoaSaUKkyoS9OP0hjjiTvncL8MyniKBmIlsZhmTsJExrazLvyBD8sP7enetFLay7k1Ch5AoY4f+7vMuOjzBjlzqq3KQQfBxygAe8+cCrYWJwr/JtPdfFEbvb2iRsdmT/M50DkaU1O9Bcr0PvMdr6eO2BVWSj7EogdIAmDkoWKwEuy1jx9syd0jcnk615gx0rzSVerdn55EXgG0mMS01GHs+kC3oaQYuvu7vtEYzxnnXSpLf+OjPfFwHRim+A8KZSrAtLjTAqSjmZ/pNgE+Foz38A4BtmQBGOjwFVlT+sd5HYYK6Jeh1X3AW/MEeS4EjR1QBlbfgHKcO6LnQ7lY3B3yDt2cf/9PZmM2x5AcNG9z1aQumWq3/Mf3s13hMMkcFBMERsSb+rD2mPWymS
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(7916004)(396003)(39860400002)(346002)(376002)(366004)(136003)(66446008)(4326008)(38070700005)(8676002)(5660300002)(66946007)(33716001)(66476007)(66556008)(64756008)(4744005)(91956017)(2906002)(6506007)(82960400001)(26005)(76116006)(8936002)(86362001)(44832011)(71200400001)(6486002)(6512007)(9686003)(478600001)(6916009)(54906003)(122000001)(38100700002)(1076003)(41300700001)(83380400001)(316002)(186003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9iub5NZi4lsRBhj2r0QoVxmkoYZERlxQCx+AgLAvFr3+9Qhgnnkt0tB1Y4+h?=
 =?us-ascii?Q?9+4XiWHftE2EPGmgEZSobmdxc7dkebEopN8UaW5i7g7GGj/EsXOPuyYk922L?=
 =?us-ascii?Q?Rzul9tfqs9Wk+ERmBhMILBT53Pkp38tpp5bCW5pwivJUdf32mp0e1KbiRjm3?=
 =?us-ascii?Q?e6BzFPE5/KbDXSbGYvJPAq9KcD1C1AXfXXg2tQ658jVoTgMDQNLuBWUXBYaL?=
 =?us-ascii?Q?rSIEfl/rshut5tVHgtljKrYQgrz2xsUqvPp1lbva12VKoJCB0tf1r1Q41nkJ?=
 =?us-ascii?Q?IOvl8AXdn2AJBaozsgVVHcA5FbK2lUpvLKdjPnMs0nKkqprAkzI8wC4d7IEs?=
 =?us-ascii?Q?OD/1YAIUpRl3wI2D+8sa2IQlMs3PxzLdJqK/ANiJakQSfmxEo6b68iTKFAFn?=
 =?us-ascii?Q?4yKsAHOVm4ZOqWo6eHtT32Lba1780DBMTXcAjgIucEEBdeljoD1CSmiV8DQN?=
 =?us-ascii?Q?yYNVsrZN9jm8oc61E74LWdB0BCpJi7UV55tDPvfOv9+yAnvtzQvOnzgNDcev?=
 =?us-ascii?Q?qyZ996tytN03wC4GX/tAZkoKSnhakFAxnfHYA5Kt6puYkgcZKoBuYMrXhbJX?=
 =?us-ascii?Q?fUrKop9+xWKmxU4Wn9mVdr0ZrZ3puhK6Ej+o4jeZKRp0YI2rKiJtn7Y9PNDm?=
 =?us-ascii?Q?/5bHf8XSqhg/ZED1m8/Ys7Jj32FfSgRYM/GvNPNgpLFY9hp06zPjdQ9VzHF4?=
 =?us-ascii?Q?wEOP1fT50GakxxeKOjo20jePe4Ghp4mAmbs8JBZenN2O/QfPRWR/Hu48mLOy?=
 =?us-ascii?Q?m3COcdtifvZBEQOioNuJYvfpqziV0NAUHl2PdVpMlM5KjO5QLuw71ga57p/e?=
 =?us-ascii?Q?MtZWEHK3HvXs7oPwc8J8Kve1hkZerJZdy1AwpVjGahjdmEbfKZ9sUrnj1gua?=
 =?us-ascii?Q?oVQPvrVK4qkGmSggmYCezzpzYda2bhMpPQa7WO9VA03f1AxGWdMj1GM0zuwP?=
 =?us-ascii?Q?/iiXogoK1w9crJ3SGASgfp24Lw4RDdJk5J4LUrx9ScOJDPrI3N7/heFzfMU1?=
 =?us-ascii?Q?bDZV8BiVrV7Dv1XxJeMRXLy2N6fwrlbdjur6vc53PIm22PjTtu9btyBPUct+?=
 =?us-ascii?Q?K1rWMTpQUpsuwI0/dkBXfGZ+TsSbFaHwaM7zz0A04FrumZpLYwAUHYBqChGD?=
 =?us-ascii?Q?gsLtHf2VsdKa3Je1RP3Nq0Q9+93fFGd0grmnHe94SMI9cn5VxOKKHM8yYDdX?=
 =?us-ascii?Q?kk02pZh1zdNzmIziDG90rftWwigkJS+RwJgS8JvwXONaxl1/ocLSrcVDVvro?=
 =?us-ascii?Q?yedRojcVU5ddy8tGmsrhH/shVlkBeS2W8iE2ubdL5gRSIPGguaoDelNsuyFF?=
 =?us-ascii?Q?JaePYKIyDqcTqsbae+KYRuS8kHksCeoTdshAx4bWhWP4yJDTIoGtkGVZB73W?=
 =?us-ascii?Q?YQ3MpjHIYYSDgvr1ldiA931APKjJ3ZA3elxM0eQzD9pQ5agp+vmzpwMJdAf6?=
 =?us-ascii?Q?LuUrkCxGGdponnYK6iYbS7TsWIatYhi/OsbwZN7Ij671wy7e9ApfShUUXvbj?=
 =?us-ascii?Q?NSc6txv1cD5ylXfGi8UsqvOPjYk+UhbGcXQ9gJzcASwXPFdRzofAN0GQS9Mp?=
 =?us-ascii?Q?pNO/1eyM/uN5gbbolr4IC//YOP9hgNn5qJLOSaYsuDsFtshSqmcXCju1sqME?=
 =?us-ascii?Q?onrW+lwZIsPNeZPocwVYXGg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae156ea7-edd8-4397-64bd-08da60989179
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 04:16:01.8137 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s9dkYnsGl94sMY7RNZw75Be52OPPuYy2ZqpY9Th8/0s26rR6zQ9kOODGhj+2wCEBizRovrCTqXUPXSxhkHqsQjvet8diAV0KXlFrroKfxKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3666
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Tue, 12 Jul 2022 08:15:28 +0000
Subject: Re: [dm-devel] clean up zoned device information v2
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <FA45823237EDA34CB0734B5D410AF553@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jul 06, 2022 / 09:03, Christoph Hellwig wrote:
> Hi all,
> 
> this cleans up the block layer zoned device information APIs and
> moves all fields currently in the request_queue to the gendisk as
> they aren't relevant for passthrough I/O.
> 
> Changes since v1:
>  - drop the blk-zoned/nvmet code sharing for now
>  - use a helper a little earlier
>  - various spelling fixes

This series passed my test set for zoned block devices. It may be late but,

Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

-- 
Shin'ichiro Kawasaki

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

