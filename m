Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B50ECAAD5
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977208;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=iv9hrGL7KTYAuZ53oCwuQgD5Q1tuFWB36XfgJvVtKi+fqmOQ/4LFIb6qh8dDSxbCgXuo9g
	4rYRjjvrPD7FmtwrxicU1+aA1IGtwI5a59FmY3sUSBD9yBXF8QtP8EvBp1ajz7zsi6Jgc7
	p/2BoSRiIXZ+b3Kz7EcwYBc3gRyDfNc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-JOyxF334MYyACXTcPGZ9Yw-1; Mon, 12 Sep 2022 06:06:45 -0400
X-MC-Unique: JOyxF334MYyACXTcPGZ9Yw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A702B1824635;
	Mon, 12 Sep 2022 10:06:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9329B2027061;
	Mon, 12 Sep 2022 10:06:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A6831946A43;
	Mon, 12 Sep 2022 10:06:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8C3FF1946A42
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:06:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6E21140C6EC3; Mon, 12 Sep 2022 10:06:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 691B740C6EC2
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:06:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 502E2800124
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:06:42 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-YgJD_y8_NW2VFZJxmLiycA-1; Mon, 12 Sep 2022 06:06:39 -0400
X-MC-Unique: YgJD_y8_NW2VFZJxmLiycA-1
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="323221226"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:06:36 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BL0PR04MB4740.namprd04.prod.outlook.com (2603:10b6:208:43::31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:06:32 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:06:32 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 06/13] null_blk: allow zoned devices with non
 power-of-2 zone sizes
Thread-Index: AQHYxoDYe4IHkDWBLkuW20Jl3XLfgw==
Date: Mon, 12 Sep 2022 10:06:32 +0000
Message-ID: <PH0PR04MB74163531ED71D55BCF9A1EEA9B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082212eucas1p1032064dd2ac1638d7d18be7e6fe5344e@eucas1p1.samsung.com>
 <20220912082204.51189-7-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BL0PR04MB4740:EE_
x-ms-office365-filtering-correlation-id: 3ea78402-36f3-4ff3-4d58-08da94a677d9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FtlENEO9REp+0k/7v4tyMLwILJwF3/RFbWamh5QUppcx3rNvZDIwsXCPhMJBLt1rK7QQEeFM/ztC5u3c2UkfMH9/kgJmeJ7HJTpFI59/SZIrEQwpjCE25MO7PKzc+9G06aY1FAtzgihma3JrctdW0zxJp2NXOxDRv8qU4fVaAxn5MDZKh+PiwSpcDj+wfqKETzHhLGC1uMEckgmwM1b5pHPqc+sR3ZH7s59l7fKqfUxOSzft+8fJY/TSttzGMDlYvKA1hm3xM+T0Gkr8cpMWt6k0qj7tMCob7r5E5a7whfaAeECdS4KOm9uFfVwQCLBzIdEzbT05VIJbZIekxfajHXVL/ITgmcJIzkg1t7Hn84TykCWRxmnJBd8OcSJt4MsDQPU7WXnoGkBkYMA03VOnmsMnlLw0mXfOZEjszjIkYVrsWMSWXGe4hy6wcWKdChZCcF/XfcGIFUugJXA6qFJqiIlYpKE0RThzColjFbKea7Fs3/btkwwlBDhjypteE5+jdCDlF88bgEBMzzQxMuFu5t4+ronf0XyF4bZhKLMq2i/N0KJAwTpj8Dhw8z+J4vgNhkZXJ3E6s11OLXSjFfKqyqSVGGT3PAzxOWtIiam3r3t7bRkl+l1Q5pwqkJk8RSbkaRuylRggT576OzrCA58abnmg5czL4J+Yspj25BrRnJsJrokXBUlYJ5HXkhAvSAunTkmsoSqSyTpHh8HStMzZ8KLI/aidJJ6JXyhPj92VaFSBc3rQg3gr/BL2nbkUMIZBdqREAFfcV1TrL8fnkHiCIA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33656002)(5660300002)(186003)(4270600006)(52536014)(2906002)(8936002)(19618925003)(7696005)(6506007)(9686003)(7416002)(41300700001)(54906003)(38070700005)(55016003)(64756008)(122000001)(76116006)(478600001)(91956017)(66446008)(66556008)(4326008)(110136005)(66476007)(66946007)(8676002)(558084003)(86362001)(316002)(82960400001)(71200400001)(38100700002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?edKMZmFmBO9aO0bB2DwgnXbK3tQQ78YbqSnftHtnEj6vRBKo6GfOAge7hu?=
 =?iso-8859-1?Q?bmzY2KOO0IxCebr3ji7xUveJfImo54HiuzEhkxQKGjlkwG/lmQ3dnxI3X0?=
 =?iso-8859-1?Q?HAoao4JzQDipeZkDNCM5uj7XGTXVZHbRsr9fzQEAnmahf8a8cmg6cuSUzn?=
 =?iso-8859-1?Q?dlAtItMLv8OSKulUiba18aWuYTPgMYY7u8Js2/5Y8UrQumiJD3Hphw9Hw4?=
 =?iso-8859-1?Q?VHyu+bnTIT1XQ7cfIwCLJ0icVphJ/FGFBolwV3DhT6zwCThMyoqoOsGMeB?=
 =?iso-8859-1?Q?SgPfsz+JFUX4ZccfdTj0XGWMfHDPGUEW8QzZYOReMrs7X+9mEB6IV9QF4A?=
 =?iso-8859-1?Q?gI9m5MLcs7iwUV8DBvdOaJs9cqYHVqvpEhgKzcSwYExZ2yWFTlJcbRR2Hb?=
 =?iso-8859-1?Q?hn8oMNvefbsuhG8GwDvViogetr8XAH4qOCYEXD5CJIagGbrOSTPsCdYED2?=
 =?iso-8859-1?Q?GYsSTain+K5RNlM/wOvHrDlYbMKNan6QDxidpMNk2KpzAaRceBmIuV4B5u?=
 =?iso-8859-1?Q?mHMrE1k2PzvbPMfSsrSqgjk9UZsr4zOlyeqct4xfStIDC1gK4ZiySpUzzd?=
 =?iso-8859-1?Q?h4P7ic7YGegYx/pvsdLYZhkCYchskf0QER8jt0opJVLOorKgANLJR77jmf?=
 =?iso-8859-1?Q?MYsuBUHtrf8BOfLUzHslOC3IcqVMlNg+1M+s3h4aBGQSykFucECTJlMz2h?=
 =?iso-8859-1?Q?4fxrhnwNvHUs51D/d30wY0nZPAaaoQLdlC3HHqFNDKNGn4Zr9i8ugvLV6l?=
 =?iso-8859-1?Q?Yw8nxG9iOlEUPxWNW+L+P/6El9VdyqUE/0VvIQt6j/aYYZvEZjvcw1SX2A?=
 =?iso-8859-1?Q?QuvW64VqBXlpaLGdDbD9vqVDULdu/BDOB0iY2nElyAQgmSEvqePk6Shb3B?=
 =?iso-8859-1?Q?b9OCJuCyHvQsmCUwwb48isIA0i+lThgUe1vz6PMJ4usESQJ8nJ91rbWqxm?=
 =?iso-8859-1?Q?bf14oWDhRTarBMmK+ML5beBWlQxF0rKhrIgcAq0KpMpmG+L+NRuYdlJjaz?=
 =?iso-8859-1?Q?ONr/0aVqt58MBQSYjO+MjmPMOcBLtlcf6v+1AT73NEVC7gdHVH/JFETkRg?=
 =?iso-8859-1?Q?riP3irHpRotcbUbHetr0C77TL5yzIm7ELAZwbDzfg85eEKpaGbHoYeaENQ?=
 =?iso-8859-1?Q?ByZ4UOjttIWhz+sxWrDW9/KwSQnFQWnAw1S0YxDGNXR6wilBIejNP9SjPT?=
 =?iso-8859-1?Q?NXfo7vToV9jX4oxmzscrVIqfhkcPirK0W7LVYy5Q3N6VSGBQMXrC2BaSx+?=
 =?iso-8859-1?Q?eeV5w7IQMHeMfMWzI7U/D+jMT3mTX4epa050enWegrr3u5glZLbzaqW6Ym?=
 =?iso-8859-1?Q?TiqIeMf6aQXacGjep5KhZjeuarRg2vJFOdJpFmPdAQ8+ZVjD2frpIt1Ijb?=
 =?iso-8859-1?Q?yNz7dhIKTGSJBz3k3/IFrcBZCT9nFjR2vhTDvFc5NbwJwhVKNeKWtMcJmM?=
 =?iso-8859-1?Q?OZ+rnXRQrqAiPjEjHPARBqR9WukjnOgNcMq6EtdnlIsem1dyTwRlfAlEIk?=
 =?iso-8859-1?Q?HWGpHi73JsaEUl+02TI/M+lE8jPG9VJ/DZBaDCMuW7vzoNb5QfPszuCceF?=
 =?iso-8859-1?Q?zReVmKzsULoghwqeMYSJwkjeE3+ItfxmCSf4FQycpJ5tPgmXwp/6Vmk9CC?=
 =?iso-8859-1?Q?azmpNWi7YI4AeuEMfKKJ2iQawbFMUzz5yMZFJtcZxr6NjQa8TLHc+XKbHQ?=
 =?iso-8859-1?Q?YQpetB7N/fA89YoF95X7XLbxDUr2oQQwxrZDIVgMm9WVIVN1/72kH3P4cj?=
 =?iso-8859-1?Q?PiCVzc1YGKQMTzgLOZQwBLFY4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ea78402-36f3-4ff3-4d58-08da94a677d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:06:32.2089 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /ICACrpq8olvDiDJo531LJUuH3oWRDnAlJ5dOL2h7Gk8aJaMN3lPzyixY3dp8GmoQr8bnMQ7YerOQzN2pGS3YMbkdaAbYKg+YbPCuW2xTb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4740
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v13 06/13] null_blk: allow zoned devices with
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
 =?iso-8859-1?Q?Matias_Bj=F8rling?= <Matias.Bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

