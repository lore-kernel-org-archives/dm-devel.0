Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F44ECAAA1
	for <dm-devel@archiver.kernel.org>; Mon, 12 Sep 2022 10:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662977078;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=Z6cufMho4jVFx8q6Dr3bnxCOilCNt6OITd22UyPPkkTVks8BZ+SxCxsgzyy/dm/+oRTtzc
	5+3iKFJk6sXVLhRAWpz2WW8Ob/s7/AlzHrnARcU5TAI6vfJ1QKPzjeRr/GggkqRmJUtVmu
	3KZNZOE1+MiDn+QsI3cFaXOXmJO2Qik=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-ApAHmZ9IOJ-d6jBgv6PF-g-1; Mon, 12 Sep 2022 06:04:35 -0400
X-MC-Unique: ApAHmZ9IOJ-d6jBgv6PF-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EACB380673E;
	Mon, 12 Sep 2022 10:04:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B6DD2166B26;
	Mon, 12 Sep 2022 10:04:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F162E1946A43;
	Mon, 12 Sep 2022 10:04:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 985251946A43
 for <dm-devel@listman.corp.redhat.com>; Mon, 12 Sep 2022 10:04:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8AC852028E90; Mon, 12 Sep 2022 10:04:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 861C92028E8F
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:04:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BE031C14B74
 for <dm-devel@redhat.com>; Mon, 12 Sep 2022 10:04:31 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-BGLaStyBOmqUJNFJaPJGsg-1; Mon, 12 Sep 2022 06:04:29 -0400
X-MC-Unique: BGLaStyBOmqUJNFJaPJGsg-1
X-IronPort-AV: E=Sophos;i="5.93,310,1654531200"; d="scan'208";a="323221065"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
 by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2022 18:03:24 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB4067.namprd04.prod.outlook.com (2603:10b6:406:c8::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Mon, 12 Sep
 2022 10:03:16 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::bc05:f34a:403b:745c%8]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:03:16 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 02/13] block: rearrange
 bdev_{is_zoned,zone_sectors,get_queue} helper in blkdev.h
Thread-Index: AQHYxoDRPzKSIy7hXEqEXGC/7G3EjQ==
Date: Mon, 12 Sep 2022 10:03:16 +0000
Message-ID: <PH0PR04MB74168872BECCA784BEC6227E9B449@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082207eucas1p14b1bcefc6045a0a835e83db8ed810d5e@eucas1p1.samsung.com>
 <20220912082204.51189-3-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BN7PR04MB4067:EE_
x-ms-office365-filtering-correlation-id: 3153a815-537e-469d-1896-08da94a602f9
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: gQxgry3Rt4BkTzicM4Xg4wZTEveEtZQsQ/rb7JZOCLxUesiLLLvZ83dy2gCmUXidSRcBa1XlacEQMELenIipTvC1JgSUWG05yB4uAaVN2uUa5AcPAZKVrAYOHGlTDBq6mWNeK92jqH5qbEMpWcqy2ONkVR+qbC789NVZx0SUTutsx7ozEIh9ErPjzYxkTDiOTdvBRXU5Uzgkt+1cFYOfxGdFRFWJ3p1T4f1jm5g0uYVuDhau9XwWD+oBDZ0tlRvnOcMBDEg0w5ZIrlnQdv+KP1A/6CJ/oIXmTiUkGLhFcuZhSn3vNUpv28ysjjmUT/SdTF13yistUigkRFboFv9txbDweW8l0yND96LpblKCKlCnRjxsWGPOIpCMNP9no0lQkeVAM823Lz/hWWMr4Q8vXZnW6x1P/C2CNvrtF0xa8c9zO+rJN/Yl2dNvMn6ItiUUGwtAnXpWJAFARtLlhfIzTCFfc9WwYnCUwVNW5zvQ6rDANcsovpXnCcoI9h9aNpb0ZyteLO39bkSPm7h87wh6+VZXat1oT0r9ZsLVz3+ZvcZmAGMCOMDmFr+sS8bwGl2j1hoQSfMSceDMAS8hFvwbXAXIXan7+JRZR2KKeGCqhP/u9ynPIyYURLLtpwziW1CJRpwwNmnRCtwlm3PZEjYVKKyKFLSy88o6j7zHDSLsvfgJcfADF1CcGWeEBllM9UjMRXfHJ8ciPd6zoIuJHJkEc7WFaESjxHaIMBYvy/KQvR550Bku7aG7sY1RVeNZavUhAFJKbShSOd3lT1twC347f5mD8uAektccGn31LJsgOXc0fSeYFeSucC0GZa3zvA3x
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(38100700002)(8676002)(86362001)(122000001)(82960400001)(66556008)(66446008)(66476007)(76116006)(64756008)(91956017)(66946007)(558084003)(38070700005)(33656002)(71200400001)(41300700001)(7696005)(6506007)(478600001)(9686003)(4270600006)(316002)(110136005)(8936002)(54906003)(19618925003)(2906002)(4326008)(55016003)(186003)(7416002)(5660300002)(52536014);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?JCchuXVrQX864MsHsFrZfW/AhLAD3AaueLvO35swHDVFXzXWCM2utAM3up?=
 =?iso-8859-1?Q?NU2fbyCWBfNXm2QvfPBnHv/bU2p1RvverZm6Aoiu8cTHQ3F2w4k10LDnWk?=
 =?iso-8859-1?Q?HOl6j8N7txoM+1+BNK1AzOY85N+mYgzQ1DjHw2vxplIjMLKaN/G+6n5QTG?=
 =?iso-8859-1?Q?zV/lzhnhCaBatHnVrWzHWiAvqVi44FDql9m6z/z6ul0QgVE9cfzeiAWEIr?=
 =?iso-8859-1?Q?SwnxFhebu7zLUXlgdSt+jyC7gWLE9ML9rjSWrycKZZz8qs//29A9C3Od4E?=
 =?iso-8859-1?Q?uswlYH8rymoP5TzaoH1WJZsb9rCS0wOU8soy+b4wberrkZDK3pyPxYHCRy?=
 =?iso-8859-1?Q?flZEoeZRbzblsGSZMhAN6VKiFH6Yvt4bKgEt0Phagu9Nl6up05LZfG8Pl3?=
 =?iso-8859-1?Q?AjXJ/rSleuqVjXSqjR33g+1N3bCMZUZhBblEva5/uxZAsUHPUNoI7C/Pvj?=
 =?iso-8859-1?Q?1wVI6Vdh3+CRBTznCbKjnVEpN89Xwx7uks4zS+PfeA5lHe7HvvW9S9DHMR?=
 =?iso-8859-1?Q?50nTjBrjo9nHdC59q47jownnKE8WhWMFbnqY8GUldAFimcXx72srLQwVYw?=
 =?iso-8859-1?Q?k4+Rz50N68YqmPw8jLhP9Yo+kPkCuaUAQn5NiBKbfghkwZKI5GlexY/1CI?=
 =?iso-8859-1?Q?l1L6XbCW59FpT6YvT39pOOd9EdoPDhgQCalylEsiHGJlijMKeEW/8qlGdV?=
 =?iso-8859-1?Q?fx1YukGR6J8+VwJJN2ah1Xa/YRxiTuLEA/VKSFJtwCT7EDjKkKdMGP7JRA?=
 =?iso-8859-1?Q?V2HySpOhSamSpabiTjMcrfOvQ51I5GFJc0HLOsnpCiofrU875pV5m+fCr7?=
 =?iso-8859-1?Q?sa39NswLNQ1VDorbyWM7E/olsYV7wpa6nlNBI+Yafu2o+lvS9q/29mpAuv?=
 =?iso-8859-1?Q?cpeZueAjPFo9VovzvAE6ziOgJQ+RKYC9AzBiKdZqZwttcxAPyyii+Ng8XO?=
 =?iso-8859-1?Q?ba4AOapueaZ7y0NiauWwYtQ+45KrIO4CBIq6dxXx+AIb20Cqqlk0KEGenI?=
 =?iso-8859-1?Q?UnAcI0tzF2NprH4uTQ1aK2bNm/gTa1YAX8Eu2abYlBA7ji2I8C/80bUUqS?=
 =?iso-8859-1?Q?kFUU0EtenJ+t2dcZedFF4QA7Lo8Kj21OCOu14ifc344gpFw8qwpDpE33Ho?=
 =?iso-8859-1?Q?Fx6x014DeLLQFg3hb1UI0ZL817DcKyKqz/IEfukZEfxdPsSrrxube4dMsF?=
 =?iso-8859-1?Q?w0GTX6Le64vb0JHGiJM+tglTI5BRwSLFBcM5fIe0JXhsXIq0RJNd/eiS71?=
 =?iso-8859-1?Q?LzR+2gaKD0fYipK1Z11LQCJ9RdrlIkgDDjFLfGptjoGARZWAg0hAUn0lfa?=
 =?iso-8859-1?Q?IX8+EXhKXCk4/O0K5NdbgYlej73tng1HA95TvFMERuaYtQ231jKgHFHDze?=
 =?iso-8859-1?Q?1k7OxNgzVY6MsNU+aCWUswe6yyGO7AqxqLHMuejO2y0mHxCaB7WNOUEZyG?=
 =?iso-8859-1?Q?2OJz056R3QDkrInpp1OPYVTIJxgnKXzeQDLCX7VsuCAkIdpvPOXfxMd9+w?=
 =?iso-8859-1?Q?o+5KQPcM5jrOAEWss82Z24Rsi1PmBmFGYk94k/qJFbs0pRzO9NV4+8SWhl?=
 =?iso-8859-1?Q?swO2vhOC49bg1tefMIxaJUyN5lF+oqB74CTuv2lEdjv9eqCuQ9xz+TY5jH?=
 =?iso-8859-1?Q?NKWOiP0L0SIOTV0O87ywvN6f9XaZ8mDAytv3qGRuGweCI/8q/l2GvKzCPn?=
 =?iso-8859-1?Q?WzNtENI99jHEi0QNrIkswWLIxWnxUzr0wA9Ekx5u5Uj2eKYRFtWY4eqA1F?=
 =?iso-8859-1?Q?4djHW4ApzzYaXBNoGZeI0p5Xg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3153a815-537e-469d-1896-08da94a602f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:03:16.1082 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WynjysHIkb1KYgIraD5o8bUEjIid2EnlmYTTI02jbWhIVHuUYm4ksX+gczIFQVlU4prep1xBJLNEifmUU9C4QtVYb1ooeWZg6HKPj3Tqrzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4067
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v13 02/13] block: rearrange bdev_{is_zoned,
 zone_sectors, get_queue} helper in blkdev.h
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

