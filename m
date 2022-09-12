Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0449ECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977334;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=dJlpcXul65k+DiofYf6okCv4j6X9BvUfcwC2k9+5NuKMX43chkoUr5jE869ECl7zU3vhoz
	k4hYxdNExtKLe3/VLrGcVnykpMZGGjy9me9lF9G5m6/B88/2zWa5hcdMBE5AzEz1MJ3FL2
	GjBM+DrglxYjqZ4MacKicQMJCdIZerw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-FFoJ1w4JPyWfNSXOhFOCVw-1; Mon, 12 Sep 2022 06:08:50 -0400
X-MC-Unique: FFoJ1w4JPyWfNSXOhFOCVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C088138173D1;
	Mon, 12 Sep 2022 10:08:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB91D40C6EC2;
	Mon, 12 Sep 2022 10:08:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6C0D11946A43;
	Mon, 12 Sep 2022 10:08:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0721C1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:08:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E986E492B05; Mon, 12 Sep 2022 10:08:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E454E492B04
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:08:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD668801755
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:08:47 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-7S08uWM5N4Kq3Kwp_XKwEw-1; Mon, 12 Sep 2022 06:08:38 -0400
X-MC-Unique: 7S08uWM5N4Kq3Kwp_XKwEw-1
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="315397400"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:08:36 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB4067.namprd04.prod.outlook.com (2603:10b6:406:c8::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:08:30 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:08:30 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 10/13] dm-table: allow zoned devices with non
 power-of-2 zone sizes
Thread-Index: AQHYxoDf7fMsUGcEdE2DBUSb1Oarhg==
Date: Mon, 12 Sep 2022 10:08:30 +0000
Message-ID: <PH0PR04MB74163E8E098CE1D096EFFC859B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082217eucas1p15e4ba29d1438990db4acf5c3f6ca5d4f@eucas1p1.samsung.com>
 <20220912082204.51189-11-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BN7PR04MB4067:EE_
x-ms-office365-filtering-correlation-id: 6f7dc848-42f5-46f2-9f94-08da94a6be49
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 92nhMJM2JugktHzIXJXX2np7dYUy1eNfTzIOUApxLhzOy5w0HlEyegv4mfOeuOg+/G8qMF1SM3thNlR9FuxKbTgT6WiQC5qn3Fe5dsezWl/D8D6CfoPUg/LK5UXAKj+IuA19v+M52DT15KGy5Z4EEwfY8O1+PM5U29NWD2/tIZZbSO9tGCIrJGTYwUGQSTLsA2aV2KscyglNb52bR94opJz46zE0E1cApQvNonXAsDoIhw6NBvxF00c2xaNvl2nFmnj8Y1C0SPxCgG2RABf5UGTHI8j05I/qS3Akvs4jx65MDhhXF7aRADeA7yDQ77zc4xQ+MNfkWKo0Z3Y05UoIIkZtcEOQDxtbQPut3ugvZWCe06mDwE+PmwHPB/iOpXURVn65AaahZLzHL0YbF7ICkClJ+eudSjumhz8vljzHDCB47hSLRb8mztazWimY6FS9883c6rHUbLvZBwtKcUHz7avHWn1D+vvVV38wRYlKfiwGzYTh9/P3l4Kh4G/4K5nw4fgqU9NI/9gYmg1anotdWg4Kj8XlNSw33IgHf4csruzVkyH2GDhung4sDvkERh0/XXzb0pNIr72xjOxE7pdgkqp+TstWle8XWu/fZerrTf73y/Z8PCxgs/QYVXkXvDNsHTiW2GxDBJdpnU0PlS5w3NbV3eNh11S7QiAKAmpjQTeVDAXuKZNjbPX21Gv2q1l0NVZc2ybA/NEFZdPZanq8dub8am94KQPme/4Mm7944hEB1nBAkNBZcKFdLSLcanZFxvwtgRbKbViU4RZVCkSZjex/zLnIefhzeD22waVexUz5wffNuNwtM0EfEvyuvraa
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(38100700002)(8676002)(86362001)(122000001)(82960400001)(66556008)(66446008)(66476007)(76116006)(64756008)(91956017)(66946007)(558084003)(38070700005)(33656002)(71200400001)(41300700001)(7696005)(6506007)(478600001)(9686003)(4270600006)(316002)(110136005)(8936002)(54906003)(19618925003)(2906002)(4326008)(55016003)(186003)(7416002)(5660300002)(52536014);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?OkFwr0ajt+fpkfCGtWTWPk54R8PRqyl/QKKmX2SePYcEFl/db7H6CyyIUS?=
 =?iso-8859-1?Q?59JmgI83sWQgVPFCBqvclPANXDkA/LAlJWXDSp7e2A+NfUFYu4uAPgza2g?=
 =?iso-8859-1?Q?KTbXre2UkgK4tHrPRcg0YIQrgGnO6XZ1J1g6WCJyimK2sf/CfkyNqDiYB1?=
 =?iso-8859-1?Q?y+Bw6ie1+f5L1B9FHv+HrD4mi/8Vhn4tJjdCf2dbKv4Ul5DkBgXKVyENN0?=
 =?iso-8859-1?Q?tzJuqViPjjMf5t2RSWqZWdIKaLaZkuOdl78HnqRc6cG969pOpwCfHSE2A7?=
 =?iso-8859-1?Q?ljBuITulcydB+NvwpQessvL+BO7IdBmRHsqPpmjx0pEaMgvgACJSFcwZvd?=
 =?iso-8859-1?Q?x2ITGJjxg0y3cnhUevSX2tdiLJ4E/BaaKcqCpnN09BoByzs6BK6z0XzJsj?=
 =?iso-8859-1?Q?Xmddi1o2P7Ry+2+gXws5x+KL1hw1v2c5gXxBXAOAmIeKU5eFF+tIPRMlVr?=
 =?iso-8859-1?Q?wO77v7WSw8bNkZAuYdpHli5CDwsHBVHPyfRMfSphVdLyGPH0hy/Yya++YY?=
 =?iso-8859-1?Q?dfLLaI7HzSM6PrdMaFlCczkRxU9IsyTZ/R3iEPrO6cV0RMMHNiFJIf6cve?=
 =?iso-8859-1?Q?dbn3OE3UTRnPP8on2TKpVOBZSUYMkuoZuKz8GbVrhfOMjWrBHa/dusASpI?=
 =?iso-8859-1?Q?+Fg8rJVkag9CnOZlIL1BIfVUD3CLYc41X6OuUsizK5Fcr1rFdhmF7/VR0Y?=
 =?iso-8859-1?Q?wwSf9HNhl2YbkyNk1h5mblk80vbQjCXAfPlcy1bPmZbaeEn4+s4iM+Kwnb?=
 =?iso-8859-1?Q?Gi62R4vO+TPaoPgCZDybtii3UOB8VRter37852pnK0hGXskjIG459GSyx8?=
 =?iso-8859-1?Q?ThFca/mqoygFtQGLon4FGU4Kw5op6lVphKHWrQYx8Az4+uDnLglaffgaQf?=
 =?iso-8859-1?Q?TFHbZsml7XTDjia7UcXFCtrBsWBrP0oGuFTQtv2fyOEwYB9ExDex6PjymV?=
 =?iso-8859-1?Q?Vc20LVAT7OV4Q/9saDwlzXbn/3jE1+s9yffSPK4IA47/XP+rR0JJqscG77?=
 =?iso-8859-1?Q?CPE5eHeoDG9KtURF9ez97xuIlzcqdx4UEz+sEe6l0Afnf4tNgs7rtDmpRo?=
 =?iso-8859-1?Q?Sq29XwsrT7KN9qbSFIyNhiIRq1zk+Lo6PeAbKkk24O5yq73djTrjZBU7R+?=
 =?iso-8859-1?Q?Hn7ZSoIaDC2W9A2QlsjXf5jK6UYH7PSiN5szpxqvzKXjwobg8+Rm2wSdzf?=
 =?iso-8859-1?Q?EJDurSHnDNjmPewH7GD+/ON8k+NdyaUR2nMvRZHXRA0iT5t1G4Qr7u8XTV?=
 =?iso-8859-1?Q?TJ9IuHVgqekVbt0a3v9N9fm0pXsTdfHoxd17WnNLq7UAHP8W2ttM1eguNc?=
 =?iso-8859-1?Q?NifepHqbfUiBqddTgGTx1NnVLzE2IfqylvA9U+OXWFNGvOj2S4Dy8ycnyz?=
 =?iso-8859-1?Q?63UUvtboXBSixxcm6QI3VC83ArZpulC17yg/z07aU5AeIat+U31hkjZ1si?=
 =?iso-8859-1?Q?b+RRrLZe8CArXqTGJksHGUhz22x2b1KBMK97G//xCFJmOEF0I6xsrNhAW5?=
 =?iso-8859-1?Q?FTIa799+uzWt+jPDNb6Kesxv06H0l58G13KRnoik8hbGB/DFduUjv/+qln?=
 =?iso-8859-1?Q?3uftOd8m+DR9vpSvT2KLKaDyw4PNeiBGDn7jV7WKBcZZODzmyNmJZU3Mkx?=
 =?iso-8859-1?Q?JGaWZBIwhCMCsGuH/cHjkgifPapDBuvlwSxRxFW9v2vBTXaehHfC06sNiY?=
 =?iso-8859-1?Q?N2DXwRVLbxBwmQkwY651EcpKT+ahCpylsnx9NM6a/dyWQ27iHogj1iGgzX?=
 =?iso-8859-1?Q?HIWQgDcMix2Urx1UQgBlm5WI4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7dc848-42f5-46f2-9f94-08da94a6be49
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:08:30.4167 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MWCFs0c59VQ8pTFt+WQLmx3kOZnwJlSiEBsl+nJyDmFV/CbMeHhD0Q8YqxJo00K5ewh3QwkJ8lUIebrJevTk1wgGwD3Ce33SfpgHEkEJl5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4067
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v13 10/13] dm-table: allow zoned devices with
 non power-of-2 zone sizes
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
 =?iso-8859-1?Q?Matias_Bj=F8rling?= <Matias.Bjorling@wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

