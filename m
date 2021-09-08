Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9B0C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5BA6F61004
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5BA6F61004
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-92D4U4nYPYiC8VjmZw1Z0g-1; Mon, 13 Sep 2021 02:40:01 -0400
X-MC-Unique: 92D4U4nYPYiC8VjmZw1Z0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 698B384A5E6;
	Mon, 13 Sep 2021 06:39:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D3986B555;
	Mon, 13 Sep 2021 06:39:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE3CF4E58F;
	Mon, 13 Sep 2021 06:39:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1888RnPd015066 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Sep 2021 04:27:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 36388100B182; Wed,  8 Sep 2021 08:27:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 308F0100BCA6
	for <dm-devel@redhat.com>; Wed,  8 Sep 2021 08:27:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02E1F88647F
	for <dm-devel@redhat.com>; Wed,  8 Sep 2021 08:27:46 +0000 (UTC)
Received: from mail-edgeDD24.fraunhofer.de (mail-edgeDD24.fraunhofer.de
	[192.102.167.24]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-465-GoLJRSohOMW19ZiIAS7Fdg-1; Wed, 08 Sep 2021 04:27:41 -0400
X-MC-Unique: GoLJRSohOMW19ZiIAS7Fdg-1
IronPort-SDR: EmX1Eo6OzySeSlo7jxtFOSVnu0c8XmYPykqL6L1483g3F0NQLxZ8SF3Mvf3fb1WvKy2fe0Si1T
	IoRubWPiyjsg==
IronPort-PHdr: =?us-ascii?q?A9a23=3AkrJEvR9L61elO/9uWMnoyV9kXcBvk6/5Mg4c9?=
	=?us-ascii?q?twsjLcdOqig/pG3OkvZ6L0tiVLSRozU5rpCjPaeqKHvX2EMoPPj+HAPeZBBT?=
	=?us-ascii?q?VkJ3MMRmQFzGsOJCUTnavXtan9yEMFLTlQw+Xa9PABcE9r/YFuHpHq04FtwU?=
	=?us-ascii?q?hXyPAZ4PKL7AInX2s22zO25vZPJahhOhD2zbKk0IBjlxTg=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FzAABQczhh/xoBYJlXAxwBAQEBAQE?=
	=?us-ascii?q?HAQESAQEEBAEBQIFHBQEBCwGBUikofllphEiDSAOFOYgFA4t1hBSKU4EugSU?=
	=?us-ascii?q?DTgYLAQEBAQEBAQEBBwEBKgsKAgQBAQMDJIRIAheCJwElNgcOAQIEAQEBEgE?=
	=?us-ascii?q?BBgEBAQEBBgQCAoEghWgBDINTgQgBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQE?=
	=?us-ascii?q?BAQEBAQEBAQEBAQEFAg1SKT0BAQEBAgEBARAREQwBASQICwEECwIBCBgCAiY?=
	=?us-ascii?q?CAgIlCxUQAgQOBSKCBEsBglUDDiACDp4DAYE6AoofeoExgQGCCAEBBgQEhQo?=
	=?us-ascii?q?YgRaBHgMGCQGBBioBgn6EARGCbIN+J4IpgUuBBYE3Nz6CYgGBYRcKJoJQgmS?=
	=?us-ascii?q?HWgc9PhQrRhAFGBIMSRIBEBwOBRwgB5FFBIJ9RqhMB4IDUFuKQJQfMZVdkSi?=
	=?us-ascii?q?FUJBMjESTOzyEdAIEAgQFAg4BAQaBaAWCCU0kT4JpURkPjiAMFoNQil5DMTg?=
	=?us-ascii?q?CBgEKAQEDCYI5gw6MRQEB?=
X-IPAS-Result: =?us-ascii?q?A2FzAABQczhh/xoBYJlXAxwBAQEBAQEHAQESAQEEBAEBQ?=
	=?us-ascii?q?IFHBQEBCwGBUikofllphEiDSAOFOYgFA4t1hBSKU4EugSUDTgYLAQEBAQEBA?=
	=?us-ascii?q?QEBBwEBKgsKAgQBAQMDJIRIAheCJwElNgcOAQIEAQEBEgEBBgEBAQEBBgQCA?=
	=?us-ascii?q?oEghWgBDINTgQgBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBA?=
	=?us-ascii?q?QEFAg1SKT0BAQEBAgEBARAREQwBASQICwEECwIBCBgCAiYCAgIlCxUQAgQOB?=
	=?us-ascii?q?SKCBEsBglUDDiACDp4DAYE6AoofeoExgQGCCAEBBgQEhQoYgRaBHgMGCQGBB?=
	=?us-ascii?q?ioBgn6EARGCbIN+J4IpgUuBBYE3Nz6CYgGBYRcKJoJQgmSHWgc9PhQrRhAFG?=
	=?us-ascii?q?BIMSRIBEBwOBRwgB5FFBIJ9RqhMB4IDUFuKQJQfMZVdkSiFUJBMjESTOzyEd?=
	=?us-ascii?q?AIEAgQFAg4BAQaBaAWCCU0kT4JpURkPjiAMFoNQil5DMTgCBgEKAQEDCYI5g?=
	=?us-ascii?q?w6MRQEB?=
X-IronPort-AV: E=Sophos;i="5.85,277,1624312800"; d="scan'208";a="45332108"
Received: from mail-mtaka26.fraunhofer.de ([153.96.1.26])
	by mail-edgeDD24.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 10:26:34 +0200
IronPort-SDR: sylgJ2I8y9IgnVFf8sL7i5hHxjTRLqIg8rTI15VKeTic3b2mEVovL+VjNtMhNJj4zOFgtOrHDZ
	K58N3/zpQiI7w+oV86nnrOcHDwJk5xj8g=
IronPort-PHdr: =?us-ascii?q?A9a23=3Ad6XkVxXFeD4N/EEKu9aC5BoDxLjV8K0WAWYlg?=
	=?us-ascii?q?6HPw5pUf6ij9oikN0vatr1hj17MCIPc7f8My+/bqLvpVmFI55Gd+GsDf5pBW?=
	=?us-ascii?q?15g640WkgUsDdTDBRj9K/jnPDY3EMRLSBlu+HToeURQEdz1MlvVpHD65DUOG?=
	=?us-ascii?q?xL5YAxyIOmQeMbSgs272vr09YfUZlBBhSGwavV8NhyrqwXWuMQMx4dvec4M?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AqW47zqoelZK1wwKQii3eimkaV5oBeYIsim?=
	=?us-ascii?q?QD101hICG9Kvbo8vxG785rsSMc6QxhIE3I9urwW5VoLUmxyXcX2/hrAV7BZn?=
	=?us-ascii?q?iFhILAFugLhuGO/9SKIUPDH5tmtZuIBJIeNDSfNzdHZZmQ2njDLz9q+qjhzE?=
	=?us-ascii?q?nhv5a5857Gd3AWV0hP1XYBNjqm?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DHAABQczhh/z6wYZlXAxwBAQEBAQE?=
	=?us-ascii?q?HAQESAQEEBAEBQAmBPgUBAQsBgVIpKAdMK1gBJkOER4NIA4U5hWGCJAM4AY9?=
	=?us-ascii?q?QilOBLoElA1QLAQMBAQEBAQcBAQQmCwkBAgQBASqESAIXgiQCJjYHDgECBAE?=
	=?us-ascii?q?BARIBAQUBAQECAQYEgREThWgBDIZCAQEBAQIBAQEQEREMAQEUEAgLAQQLAgE?=
	=?us-ascii?q?IGAICJgICAiULBw4QAgQOBSKCBEsBglUDDiACDp4DAYE6AoofeoExgQGCCAE?=
	=?us-ascii?q?BBgQEhQoYgRaBHgMGCQGBBioBgn6EARGCbIN+glCBS4EFgTc3PoJiAYFhFwo?=
	=?us-ascii?q?mglCCZIdaBz0+FCtGEAUYEgxJEgEQHA4FHCAHkUUEgn1GqEwHggNQW4pAlB8?=
	=?us-ascii?q?xlV2RKIVQkEyMRJM7PIR0AgQCBAUCDgEBBoFoBS+BWU0kT4JpURkPjiAMFoN?=
	=?us-ascii?q?Qil5CATE4AgYBCgEBAwmCOYMMAQGMRQEB?=
X-IronPort-AV: E=Sophos;i="5.85,277,1624312800"; d="scan'208";a="123163249"
Received: from 153-97-176-62.vm.c.fraunhofer.de (HELO
	mobile.exch.fraunhofer.de) ([153.97.176.62])
	by mail-mtaKA26.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 10:26:31 +0200
Received: from XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) by
	XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.858.15; Wed, 8 Sep 2021 10:26:31 +0200
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (10.225.8.37) by
	XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP
	Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.15
	via Frontend Transport; Wed, 8 Sep 2021 10:26:30 +0200
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3c2::22)
	by AM6P194MB0471.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:3f::22) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19;
	Wed, 8 Sep 2021 08:26:30 +0000
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::ed17:5927:e044:2d07]) by AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::ed17:5927:e044:2d07%2]) with mapi id 15.20.4478.026;
	Wed, 8 Sep 2021 08:26:29 +0000
From: =?utf-8?B?V2Vpw58sIE1pY2hhZWw=?= <michael.weiss@aisec.fraunhofer.de>
To: "rgb@redhat.com" <rgb@redhat.com>
Thread-Topic: [PATCH v4 0/3] dm: audit event logging
Thread-Index: AQHXoXOgatbSdzBqHE+NW6mrjnaMV6uZVrUAgAB81YA=
Date: Wed, 8 Sep 2021 08:26:29 +0000
Message-ID: <9ca855cb19097b6fa98f2b3419864fd8ddadf065.camel@aisec.fraunhofer.de>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
	<20210908005942.GJ490529@madcap2.tricolour.ca>
In-Reply-To: <20210908005942.GJ490529@madcap2.tricolour.ca>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54cd43ea-5c0a-4528-4cd3-08d972a25bb4
x-ms-traffictypediagnostic: AM6P194MB0471:
x-microsoft-antispam-prvs: <AM6P194MB0471E76E760F66AFA3B0DE83ACD49@AM6P194MB0471.EURP194.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2DNcku+YHuBM9ZMAXEOKazWbixFTKIyKyZrsEsAXuNShWglZT7BBm03DErWcmczF5mxwUWVZKqh5XxbZySfu5lshXxE5BljwrYaxiHTJyjkN4vtDvul4dpfcxAFBuFNQ/SD58EtS5jm3ICdvZvEs6mSdV1r2TcVyDGniZGgpEPRRvqtynouIzhUTkJwWrlvwJUxs0Oax3M6n3RA4iboA8UHKxwXAbJEZ0wdRKFqTohzaefcFxp5OUQoq2Hgr9NrD2w0Pcyd8EbrmzUns49onqWMbPOlUENZFuUvAPtsraIfnnh7tEKJ24RnPpO0VfxKBR2dhxFxaFBme/tcDdWwDwdnJM3DqwcSa1z3u8vJhKuiCvlK+Y5MlvQuPz2zloz8QwLbLx4n8kK6jSgZkDO8tXC0pIA/7yoNAA6xzh0EeqP6Ii0643czW++oCcEFqQR1T6kBtv30u8tERFqaWlEvlOPjnLFDuPVsK8/djvS1nNg6UL5RiyTFkeMKVGSxNo21azHYvjLF5dNGBSav6trXSYmatpwARKZRGtmNvnL15fWi/bFhv52FzwOeT0YHbC68CiJ04/mdnyzL5C2qujpHlxoqaAZvAOY6zkaEP47/fjBZVxUPblsshDZcq/2rIS3qarbHhDQ2JuYanBhWuQahAzS8O/JF0DQSQ2WmijtE1t8sMolEo8mY+CxvWQYO8yrppm6iPXdlGoobW88vn5iuUOfLWfhDHZA/3c3Eh3zh0X+CBDmD3SEsXRjnNfWDOjjfgAFOxP1L353TmDUVMWLPVC4kaFuzm+EcviowfBf9pyXk=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AS8P194MB1288.EURP194.PROD.OUTLOOK.COM;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(66946007)(85182001)(66446008)(38100700002)(7416002)(478600001)(66476007)(86362001)(6486002)(6916009)(2906002)(53546011)(91956017)(6506007)(8936002)(76116006)(66556008)(64756008)(83380400001)(2616005)(5660300002)(186003)(54906003)(122000001)(26005)(6512007)(71200400001)(966005)(4326008)(316002)(8676002)(38070700005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azc0bytVUWNUclNBaCtaQkpReTdJNDlaOWhYaCsxbHFlNTZDRmJSL1RoVkFQ?=
	=?utf-8?B?TDJTdVIvczVtK0JWUkJLMG1jRVB4NVJwblV1ZmNLQ0FHdmRGYnF6cGFkS0RZ?=
	=?utf-8?B?SE85WlI5eFl4RnM2T2NVdTUrYkxCSU1raDJnNVA2MXB3ZWlYWDd5dWFPZXBT?=
	=?utf-8?B?MitnM2ZTRktjQVNUWVRHMlowaFBSbnp6TWNhUGhZWUVJcmRmdUNaeUNkNTgy?=
	=?utf-8?B?b0dBMG9tVkZTaFZVcDRoOHIwb0VxMU5JUE9vRmNNVFdrNzhnVjg3b2M0NWN0?=
	=?utf-8?B?ZWZXYW5vTjBPQXZvUnc1YUFTOWU0alVTM3BRUVNGZ2QwS1hpTGNtbHlEV1Uv?=
	=?utf-8?B?V3JiMmdKdVV0K0paZ3Z4THl5V0xNWk5oUkJBWkVBSUdSVG0wQWtxaVRVdElH?=
	=?utf-8?B?NmhPQWEwK3kvUXJEa1NDbWs2YUhUMEV3WER0R0RLbm5MVEdmNjhqRUVNdDll?=
	=?utf-8?B?RkRNUURqbG8yVmd2a0wyUzdXeDljd2JWb3djSExRRVp6R3o3eCtFZUdPRG4x?=
	=?utf-8?B?TTlxY25zL2FwSWdMOEh1ZEYzWXZhekpkWERCQ0t4eHhCV0N5K2JqL1FJL0xz?=
	=?utf-8?B?Z2RJbTBWSzAvbEtZajFoUTcrMkpVYXhRSldWZkVSYTBPVmZKL2tKM3JvQUYw?=
	=?utf-8?B?a2lRVzJhRnAydzVwNFFzSkNDcndHVk1qYVI5eWxLbUxoWUFLQmN3M1hGMmVn?=
	=?utf-8?B?VEg2S3VHdEFxWWVqS1NGTTB5UFdwUGt3bmk2aE0xdlZBL0pqS0c5d211RVBE?=
	=?utf-8?B?alpRSDB4emV5L1Z2NDM2Nm5zb1dudkwyOTJSemJCQXJLU1RQVmFiYVg3ci9S?=
	=?utf-8?B?T2xiUnZWQkxKejVDMWVVUGdHKzB3UG05bWtlOEt6UU9RWmljVllGRk9mQVE2?=
	=?utf-8?B?MmtxRG1YdGRsc1RQYUlET2ZUcHpXWjgycEJqemUvUkVXZHk3a0M5RWUzN1lt?=
	=?utf-8?B?THhmcEZNeTZIV2NsTUZLRWsvcytndjM2VUdHeFp2ZHlYb1V4RjhNaGVXbU5P?=
	=?utf-8?B?MGE3dmpxQjhhUlgyMDdqY0FoRkU3UHQzZFlLMjFVZ1g5MGJ6L0dnWlVkNGJL?=
	=?utf-8?B?R3lKcXpER2NlbVpBWFdRQUJqVXg3T2U0eVdKV1p3UGZ1Y3VJUnJBV3BDUjRa?=
	=?utf-8?B?ME9NUzhrMWJEem5oVDRwdXJKNy9jdnI1UmV4VURQVUFGY1poY0hYM3N1WThs?=
	=?utf-8?B?RUhWVEZ4TFhhem9iemEreHVIbWtwdjJNVEt4LzZ2dGxNV3c1REhDcHpOK1hi?=
	=?utf-8?B?bXdnL0hqUzNNM1djWEhRMXg3Qk4xWWZMLzNlSFFMMEJHdE85ZjdLSFZWaEt4?=
	=?utf-8?B?N2xUdjM3QThIY0lNbU5oWUdnUS9uT3NHdUpBbnJ1cXIrK0J5MnN5L0Fpc3B3?=
	=?utf-8?B?YWpkNzRENy9KKzhidStWcS9LYVdtLzV0RnFKUTN4bXk2T29tY2YzbjF0RTF3?=
	=?utf-8?B?cTd5Vm1ZZVhDeHJLc1Iva3gwQklCWW9VSXdhVk14dEEwd1dpMFVKcDJ0SXlV?=
	=?utf-8?B?UlRaN2g4S0ZkdHJhUGxYYTFYUFRPMW16ZGcrUGFNTUxudUF2T0E3VWduckJw?=
	=?utf-8?B?QTlJc2hCdzF2YkpoNWRKa2NkTHlicHg2RU9xVllET3RGaUZqVURaMVF0YVNO?=
	=?utf-8?B?QTh6YURoejR0U0xXVlJIbzZiNFdvdWdRT2s4RkF6MHlUdVRTVU8wbWh6c0NI?=
	=?utf-8?B?WHBGLzVCck9EaUc3VHNZQ1Jad0h3UTJKRDRSTE8vR1kvZGtQOUNvSlZUYlNx?=
	=?utf-8?Q?AV+L9/QBnOkyCy4DrnQIrcDaBSs8+iVuT40tt1w?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cd43ea-5c0a-4528-4cd3-08d972a25bb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 08:26:29.7232 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZjZHDIB5D9AnNv8CLy/edfWM07bTz1CEfEs2sZhAdKV3leF8Xr6fTvRGUQ8RUZFVJCATnsty0L8uocPsY46Yw6JOWzQYaF8AxMi5aR8AcWEzG8E//eAJas+m8ZHtyHxw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6P194MB0471
X-OriginatorOrg: aisec.fraunhofer.de
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1888RnPd015066
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 13 Sep 2021 02:39:51 -0400
Cc: "paul@paul-moore.com" <paul@paul-moore.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"casey@schaufler-ca.com" <casey@schaufler-ca.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 0/3] dm: audit event logging
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2E58E277737101419B4209E0AB5D38DD@EURP194.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDIxLTA5LTA3IGF0IDIwOjU5IC0wNDAwLCBSaWNoYXJkIEd1eSBCcmlnZ3Mgd3Jv
dGU6Cj4gT24gMjAyMS0wOS0wNCAxMTo1OSwgTWljaGFlbCBXZWnDnyB3cm90ZToKPiA+IGRtIGlu
dGVncml0eSBhbmQgYWxzbyBzdGFja2VkIGRtIGNyeXB0IGRldmljZXMgdHJhY2sgaW50ZWdyaXR5
Cj4gPiB2aW9sYXRpb25zIGludGVybmFsbHkuIFRodXMsIGludGVncml0eSB2aW9sYXRpb25zIGNv
dWxkIGJlIHBvbGxlZAo+ID4gZnJvbSB1c2VyIHNwYWNlLCBlLmcuLCBieSAnaW50ZWdyaXR5c2V0
dXAgc3RhdHVzJy4KPiA+IAo+ID4gPiBGcm9tIGFuIGF1ZGl0aW5nIHBlcnNwZWN0aXZlLCB3ZSBv
bmx5IGNvdWxkIHNlZSB0aGF0IHRoZXJlIHdlcmUKPiA+IGEgbnVtYmVyIG9mIGludGVncml0eSB2
aW9sYXRpb25zLCBidXQgbm90IHdoZW4gYW5kIHdoZXJlIHRoZQo+ID4gdmlvbGF0aW9uIGV4YWN0
bHkgd2FzIHRha2luZyBwbGFjZS4gVGhlIGN1cnJlbnQgZXJyb3IgbG9nIHRvCj4gPiB0aGUga2Vy
bmVsIHJpbmcgYnVmZmVyLCBjb250YWlucyB0aG9zZSBpbmZvcm1hdGlvbiwgdGltZSBzdGFtcCBh
bmQKPiA+IHNlY3RvciBvbiBkZXZpY2UuIEhvd2V2ZXIsIGZvciBhdWRpdGluZyB0aGUgYXVkaXQg
c3Vic3lzdGVtIHByb3ZpZGVzCj4gPiBhIHNlcGFyYXRlIGxvZ2dpbmcgbWVjaGFuaXNtIHdoaWNo
IG1lZXRzIGNlcnRhaW4gY3JpdGVyaWEgZm9yIHNlY3VyZQo+ID4gYXVkaXQgbG9nZ2luZy4KPiA+
IAo+ID4gV2l0aCB0aGlzIHNtYWxsIHNlcmllcyB3ZSBtYWtlIHVzZSBvZiB0aGUga2VybmVsIGF1
ZGl0IGZyYW1ld29yawo+ID4gYW5kIGV4dGVuZCB0aGUgZG0gZHJpdmVyIHRvIGxvZyBhdWRpdCBl
dmVudHMgaW4gY2FzZSBvZiBzdWNoCj4gPiBpbnRlZ3JpdHkgdmlvbGF0aW9ucy4gRnVydGhlciwg
d2UgYWxzbyBsb2cgY29uc3RydWN0aW9uIGFuZAo+ID4gZGVzdHJ1Y3Rpb24gb2YgdGhlIGRldmlj
ZSBtYXBwaW5ncy4KPiA+IAo+ID4gV2UgZm9jdXMgb24gZG0taW50ZWdyaXR5IGFuZCBzdGFja2Vk
IGRtLWNyeXB0IGRldmljZXMgZm9yIG5vdy4KPiA+IEhvd2V2ZXIsIHRoZSBoZWxwZXIgZnVuY3Rp
b25zIHRvIGxvZyBhdWRpdCBtZXNzYWdlcyBzaG91bGQgYmUKPiA+IGFwcGxpY2FibGUgdG8gZG0t
dmVyaXR5IHRvby4KPiA+IAo+ID4gVGhlIGZpcnN0IHBhdGNoIGludHJvZHVjZSBnZW5lcmljIGF1
ZGl0IHdyYXBwZXIgZnVuY3Rpb25zLgo+ID4gVGhlIHNlY29uZCBwYXRjaCBtYWtlcyB1c2Ugb2Yg
dGhlIGF1ZGl0IHdyYXBwZXIgZnVuY3Rpb25zIGluIHRoZQo+ID4gZG0taW50ZWdyaXR5LmMuCj4g
PiBUaGUgdGhpcmQgcGF0Y2ggdXNlcyB0aGUgd3JhcHBlciBmdW5jdGlvbnMgaW4gZG0tY3J5cHQu
Yy4KPiA+IAo+ID4gVGhlIGF1ZGl0IGxvZ3MgbG9vayBsaWtlIHRoaXMgaWYgZXhlY3V0aW5nIHRo
ZSBmb2xsb3dpbmcgc2ltcGxlIHRlc3Q6Cj4gPiAKPiA+ICMgZGQgaWY9L2Rldi96ZXJvIG9mPXRl
c3QuaW1nIGJzPTFNIGNvdW50PTEwMjQKPiA+ICMgbG9zZXR1cCAtZiB0ZXN0LmltZwo+ID4gIyBp
bnRlZ3JpdHlzZXR1cCAtdkQgZm9ybWF0IC0taW50ZWdyaXR5IHNoYTI1NiAtdCAzMiAvZGV2L2xv
b3AwCj4gPiAjIGludGVncml0eXNldHVwIG9wZW4gLUQgL2Rldi9sb29wMCAtLWludGVncml0eSBz
aGEyNTYgaW50ZWdyaXR5dGVzdAo+ID4gIyBpbnRlZ3JpdHlzZXR1cCBzdGF0dXMgaW50ZWdyaXR5
dGVzdAo+ID4gIyBpbnRlZ3JpdHlzZXR1cCBjbG9zZSBpbnRlZ3JpdHl0ZXN0Cj4gPiAjIGludGVn
cml0eXNldHVwIG9wZW4gLUQgL2Rldi9sb29wMCAtLWludGVncml0eSBzaGEyNTYgaW50ZWdyaXR5
dGVzdAo+ID4gIyBpbnRlZ3JpdHlzZXR1cCBzdGF0dXMgaW50ZWdyaXR5dGVzdAo+ID4gIyBkZCBp
Zj0vZGV2L3VyYW5kb20gb2Y9L2Rldi9sb29wMCBicz01MTIgY291bnQ9MSBzZWVrPTEwMDAwMAo+
ID4gIyBkZCBpZj0vZGV2L21hcHBlci9pbnRlZ3JpdHl0ZXN0IG9mPS9kZXYvbnVsbAo+ID4gCj4g
PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gPiBhdWRpdC5sb2cgZnJvbSBhdWRpdGQKPiA+
IAo+ID4gdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjMwNDI1MDM5LjM2MzoxODQpOiBt
b2R1bGU9aW50ZWdyaXR5IG9wPWN0ciBwcGlkPTM4MDcgcGlkPTM4MTkKPiA+IGF1aWQ9MTAwMCB1
aWQ9MCBnaWQ9MCBldWlkPTAgc3VpZD0wIGZzdWlkPTAgZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0
eT1wdHMyIHNlcz0zCj4gPiBjb21tPSJpbnRlZ3JpdHlzZXR1cCIgZXhlPSIvc2Jpbi9pbnRlZ3Jp
dHlzZXR1cCIgc3Viaj09dW5jb25maW5lZCBkZXY9MjU0OjMgZXJyb3JfbXNnPSdzdWNjZXNzJwo+
ID4gcmVzPTEKPiA+IHR5cGU9VU5LTk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYzMDQyNTAzOS40NzE6
MTg1KTogbW9kdWxlPWludGVncml0eSBvcD1kdHIgcHBpZD0zODA3IHBpZD0zODE5Cj4gPiBhdWlk
PTEwMDAgdWlkPTAgZ2lkPTAgZXVpZD0wIHN1aWQ9MCBmc3VpZD0wIGVnaWQ9MCBzZ2lkPTAgZnNn
aWQ9MCB0dHk9cHRzMiBzZXM9Mwo+ID4gY29tbT0iaW50ZWdyaXR5c2V0dXAiIGV4ZT0iL3NiaW4v
aW50ZWdyaXR5c2V0dXAiIHN1Ymo9PXVuY29uZmluZWQgZGV2PTI1NDozIGVycm9yX21zZz0nc3Vj
Y2VzcycKPiA+IHJlcz0xCj4gPiB0eXBlPVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0KDE2MzA0MjUw
MzkuNjExOjE4Nik6IG1vZHVsZT1pbnRlZ3JpdHkgb3A9Y3RyIHBwaWQ9MzgwNyBwaWQ9MzgxOQo+
ID4gYXVpZD0xMDAwIHVpZD0wIGdpZD0wIGV1aWQ9MCBzdWlkPTAgZnN1aWQ9MCBlZ2lkPTAgc2dp
ZD0wIGZzZ2lkPTAgdHR5PXB0czIgc2VzPTMKPiA+IGNvbW09ImludGVncml0eXNldHVwIiBleGU9
Ii9zYmluL2ludGVncml0eXNldHVwIiBzdWJqPT11bmNvbmZpbmVkIGRldj0yNTQ6MyBlcnJvcl9t
c2c9J3N1Y2Nlc3MnCj4gPiByZXM9MQo+ID4gdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgx
NjMwNDI1MDU0LjQ3NToxODcpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWR0ciBwcGlkPTM4MDcgcGlk
PTM4MTkKPiA+IGF1aWQ9MTAwMCB1aWQ9MCBnaWQ9MCBldWlkPTAgc3VpZD0wIGZzdWlkPTAgZWdp
ZD0wIHNnaWQ9MCBmc2dpZD0wIHR0eT1wdHMyIHNlcz0zCj4gPiBjb21tPSJpbnRlZ3JpdHlzZXR1
cCIgZXhlPSIvc2Jpbi9pbnRlZ3JpdHlzZXR1cCIgc3Viaj09dW5jb25maW5lZCBkZXY9MjU0OjMg
ZXJyb3JfbXNnPSdzdWNjZXNzJwo+ID4gcmVzPTEKPiA+IAo+ID4gdHlwZT1VTktOT1dOWzEzMzZd
IG1zZz1hdWRpdCgxNjMwNDI1MDczLjE3MToxOTEpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWN0ciBw
cGlkPTM4MDcgcGlkPTM4ODMKPiA+IGF1aWQ9MTAwMCB1aWQ9MCBnaWQ9MCBldWlkPTAgc3VpZD0w
IGZzdWlkPTAgZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0eT1wdHMyIHNlcz0zCj4gPiBjb21tPSJp
bnRlZ3JpdHlzZXR1cCIgZXhlPSIvc2Jpbi9pbnRlZ3JpdHlzZXR1cCIgc3Viaj09dW5jb25maW5l
ZCBkZXY9MjU0OjMgZXJyb3JfbXNnPSdzdWNjZXNzJwo+ID4gcmVzPTEKPiA+IAo+ID4gdHlwZT1V
TktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjMwNDI1MDg3LjIzOToxOTIpOiBtb2R1bGU9aW50ZWdy
aXR5IG9wPWR0ciBwcGlkPTM4MDcgcGlkPTM5MDIKPiA+IGF1aWQ9MTAwMCB1aWQ9MCBnaWQ9MCBl
dWlkPTAgc3VpZD0wIGZzdWlkPTAgZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0eT1wdHMyIHNlcz0z
Cj4gPiBjb21tPSJpbnRlZ3JpdHlzZXR1cCIgZXhlPSIvc2Jpbi9pbnRlZ3JpdHlzZXR1cCIgc3Vi
aj09dW5jb25maW5lZCBkZXY9MjU0OjMgZXJyb3JfbXNnPSdzdWNjZXNzJwo+ID4gcmVzPTEKPiA+
IAo+ID4gdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjMwNDI1MDkzLjc1NToxOTMpOiBt
b2R1bGU9aW50ZWdyaXR5IG9wPWN0ciBwcGlkPTM4MDcgcGlkPTM5MDYKPiA+IGF1aWQ9MTAwMCB1
aWQ9MCBnaWQ9MCBldWlkPTAgc3VpZD0wIGZzdWlkPTAgZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0
eT1wdHMyIHNlcz0zCj4gPiBjb21tPSJpbnRlZ3JpdHlzZXR1cCIgZXhlPSIvc2Jpbi9pbnRlZ3Jp
dHlzZXR1cCIgc3Viaj09dW5jb25maW5lZCBkZXY9MjU0OjMgZXJyb3JfbXNnPSdzdWNjZXNzJwo+
ID4gcmVzPTEKPiA+IAo+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEy
LjExOToxOTQpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4gZGV2
PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRp
dCgxNjMwNDI1MTEyLjExOToxOTUpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVj
a3N1bQo+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gdHlwZT1VTktOT1dOWzEz
MzddIG1zZz1hdWRpdCgxNjMwNDI1MTEyLjExOToxOTYpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWlu
dGVncml0eS1jaGVja3N1bQo+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gdHlw
ZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEyLjExOToxOTcpOiBtb2R1bGU9aW50
ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCBy
ZXM9MAo+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEyLjExOToxOTgp
OiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4gZGV2PTI1NDozIHNl
Y3Rvcj03NzQ4MCByZXM9MAo+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1
MTEyLjExOToxOTkpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4g
ZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1h
dWRpdCgxNjMwNDI1MTEyLjExOToyMDApOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1j
aGVja3N1bQo+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gdHlwZT1VTktOT1dO
WzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEyLjExOToyMDEpOiBtb2R1bGU9aW50ZWdyaXR5IG9w
PWludGVncml0eS1jaGVja3N1bQo+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4g
dHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEyLjExOToyMDIpOiBtb2R1bGU9
aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4
MCByZXM9MAo+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEyLjExOToy
MDMpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4gZGV2PTI1NDoz
IHNlY3Rvcj03NzQ4MCByZXM9MAo+IAo+IEFyZSB0aGVzZSBpc29sYXRlZCByZWNvcmRzLCBvciBh
cmUgdGhleSBhY2NvbXBhbmllZCBieSBhIHR5cGU9U1lTQ0FMTAo+IHJlY29yZCBpbiB5b3VyIGxv
Z3M/CgpZb3UgYXJlIHJpZ2h0IHRoZSBkbV9hdWRpdF9sb2dfe2N0cixkdHJ9IGZ1bmN0aW9ucyBw
cm9kdWNlIHR5cGU9QVVESVRfRE1fQ1RSTAphY2NvbXBhbmllZCBieSBhCnR5cGU9U1lTQ0FMTC4g
VGhpcyB3YXMgYSBtaXN0YWtlIGJ5IG1lLiBJIGdyZXBwZWQKdGhlIGF1ZGl0IGxvZyB3aXRoICdn
cmVwIC1lICIxMzNbNi03XSInIGR1cmluZyBteQp0ZXN0cywgdGh1cyBJIGhhdmUKbWlzc2VkIHRo
YXQuIEkgd2lsbCByZW1vdmUgdGhlIGF1ZGl0X2xvZ190YXNrX2luZm8oKSBjYWxsIGluIHRoZQpp
bnRlcm5hbCBkbV9hdWRpdF9sb2dfdGkoKSBmdW5jdGlvbgpmb3IgdHlwZT1BVURJVF9ETV9DVFJM
LgoKZG1fYXVkaXRfbG9nX3RhcmdldCBhbmQgZG1fYXVkaXRfbG9nX2JpbyBhcmUgdXNpbmcgdHlw
ZT1BVURJVF9ETV9FVkVOVCwKVGhlc2UgYXJlIGlzb2xhdGVkIGV2ZW50cyBzaW5jZSB0aGV5IGFy
ZSBub3QgdHJpZ2dlcnQgaW4gdXNlciBjb250ZXh0LiAKCj4gCj4gVGhlIHJlYXNvbiBJIGFzayBp
cyB0aGF0IGF1ZGl0X2xvZ190YXNrX2luZm8oKSBpcyBpbmNsdWRlZCBpbiB0aHJlZSBvZgo+IHRo
ZSBjYWxsaW5nIG1ldGhvZHMgKGRtX2F1ZGl0X2xvZ197dGFyZ2V0LGN0cixkdHJ9KSB3aGljaCB1
c2UgYQo+IGNvbWJpbmF0aW9uIG9mIEFVRElUX0RNX0NUUkwvQVVESVRfRE1fRVZFTlQgdHlwZSB3
aGlsZSB0aGUgZm91cnRoCj4gKGRtX2F1ZGl0X2xvZ19iaW8pIGFsc28gdXNlcyBvbmUgb2YgdGhl
IHR5cGVzIGFib3ZlIGJ1dCBkb2VzIG5vdCBpbmNsdWRlCj4gYXVkaXRfbG9nX3Rhc2tfaW5mbygp
LiAgSWYgYWxsIHRoZXNlIHJlY29yZHMgYXJlIGFjY29tcGFuaWVkIGJ5IFNZU0NBTEwKPiByZWNv
cmRzLCB0aGVuIHRoZSB0YXNrIGluZm8gd291bGQgYmUgcmVkdW5kYW50IChhbmQgbWlnaHQgZXZl
biBjb25mbGljdAo+IGlmIHRoZXJlJ3MgYSBidWcpLiAgQW5vdGhlciBtaW5vciBvZGRpdHkgaXMg
dGhlIGRvdWJsZSAiPSIgZm9yIHRoZSBzdWJqCj4gZmllbGQsIHdoaWNoIGRvZXNuJ3QgYXBwZWFy
IHRvIGJlIGEgYnVnIGluIHlvdXIgY29kZSwgYnV0IHN0aWxsIHB1enpsaW5nLgoKSW4gdGhlIHRl
c3Qgc2V0dXAsIEkgaGFkIEFwcGFybW9yIGVuYWJsZWQgYW5kIHNldCBhcyBkZWZhdWx0IHNlY3Vy
aXR5IG1vZHVsZS4KVGhpcyBiZWhhdmlvciBvY2N1cnMgaW4gYW55IGF1ZGl0X2xvZyBtZXNzYWdl
LgpTZWVtcyB0aGF0IHRoaXMgaXMgY29taW5nIGZyb20gdGhlIGxhYmVsIGhhbmRsaW5nIHRoZXJl
LiBIYXZpbmcgYSBxdWljayBsb29rCmF0IHRoZSBjb2RlIHRoZXJlIGlzIHRoYXQgdGhleSB1c2Ug
Jz0nIGluIHRoZSBsYWJlbCB0byBwcm92aWRlIGEgcm9vdCB2aWV3IGFzCnBhcnQgb2YgdGhlaXIg
cG9saWN5IHZpcnR1YWxpemF0aW9uLiBUaGUgY29ycmVzcG9uZGluZyBjb21taXQgaXMgc2l0dGlu
Zwp0aGVyZSBzaW5jZSAyMDE3OiAiMjZiNzg5OTUxMGFlMjQzZTM5Mjk2MDcwNGViZGJhNTJkMDVm
YmIxMyIKCj4gCj4gQXJlIHRob3NlIGxhc3QgMTAgcmVjb3JkcyBleHBlY3RlZCB0byBiZSBpZGVu
dGljYWwgb3RoZXIgdGhhbiBldmVudAo+IHNlcmlhbCBudW1iZXI/CgpZZXMsIGJlY2F1c2UgdGhl
IGFjY2VzcyB0byB0aGUgY29ycnVwdCBzZWN0b3IgaXMgbWFkZSAxMCB0aW1lcy4KVGhpcyByZWZs
ZWN0cyBleGFjdGx5IHRoZSBzYW1lIGJlaGF2aW9yIHdpdGhvdXQgdGhlIGF1ZGl0IGxvZ2dpbmcs
IGluIHRoZSAKa2VybmVsIGRlYnVnIGxvZy4KCj4gCj4gPiB2NCBDaGFuZ2VzOgo+ID4gLSBBZGRl
ZCBjb21tZW50cyBvbiBpbnRlbmRlZCB1c2Ugb2Ygd3JhcHBlciBmdW5jdGlvbnMgaW4gZG0tYXVk
aXQuaAo+ID4gLSBkbV9hdWRpdF9sb2dfYmlvKCk6IEZpeGVkIG1pc3NpbmcgJz0nIGFzIHNwb3R0
ZWQgYnkgUGF1bAo+ID4gLSBkbV9hdWRpdF9sb2dfdGkoKTogSGFuZGxlIHdyb25nIGF1ZGl0X3R5
cGUgYXMgc3VnZ2VzdGVkIGJ5IFBhdWwKPiA+IAo+ID4gdjMgQ2hhbmdlczoKPiA+IC0gVXNlIG9m
IHR3byBhdWRpdCBldmVudCB0eXBlcyBBVURJVF9ETV9FVkVOVCB1bmQgQVVESVRfRE1fQ1RSTAo+
ID4gLSBBZGRpdGlvbmFseSB1c2UgYXVkaXRfbG9nX3Rhc2tfaW5mbyBpbiBjYXNlIG9mIEFVRElU
X0RNX0NUUkwgbWVzc2FnZXMKPiA+IC0gUHJvdmlkZSBjb25zaXN0ZW50IGZpZWxkcyBwZXIgbWVz
c2FnZSB0eXBlIGFzIHN1Z2dlc3RlZCBieSBQYXVsCj4gPiAtIEFkZGVkIHNhbXBsZSBldmVudHMg
dG8gY29tbWl0IG1lc3NhZ2Ugb2YgWzEvM10gYXMgc3VnZ2VzdGVkIGJ5IFBhdWwKPiA+IC0gUmVi
YXNlZCBvbiB2NS4xNAo+ID4gCj4gPiB2MiBDaGFuZ2VzOgo+ID4gLSBGaXhlZCBjb21waWxlIGVy
cm9ycyBpZiBDT05GSUdfRE1fQVVESVQgaXMgbm90IHNldAo+ID4gLSBGaXhlZCBmb3JtYXR0aW5n
IGFuZCB0eXBvcyBhcyBzdWdnZXN0ZWQgYnkgQ2FzZXkKPiA+IAo+ID4gTWljaGFlbCBXZWnDnyAo
Myk6Cj4gPiAgIGRtOiBpbnRyb2R1Y2UgYXVkaXQgZXZlbnQgbW9kdWxlIGZvciBkZXZpY2UgbWFw
cGVyCj4gPiAgIGRtIGludGVncml0eTogbG9nIGF1ZGl0IGV2ZW50cyBmb3IgZG0taW50ZWdyaXR5
IHRhcmdldAo+ID4gICBkbSBjcnlwdDogbG9nIGFlYWQgaW50ZWdyaXR5IHZpb2xhdGlvbnMgdG8g
YXVkaXQgc3Vic3lzdGVtCj4gPiAKPiA+ICBkcml2ZXJzL21kL0tjb25maWcgICAgICAgICB8IDEw
ICsrKysrCj4gPiAgZHJpdmVycy9tZC9NYWtlZmlsZSAgICAgICAgfCAgNCArKwo+ID4gIGRyaXZl
cnMvbWQvZG0tYXVkaXQuYyAgICAgIHwgODQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysKPiA+ICBkcml2ZXJzL21kL2RtLWF1ZGl0LmggICAgICB8IDY2ICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKwo+ID4gIGRyaXZlcnMvbWQvZG0tY3J5cHQuYyAgICAgIHwgMjIg
KysrKysrKystLQo+ID4gIGRyaXZlcnMvbWQvZG0taW50ZWdyaXR5LmMgIHwgMjUgKysrKysrKysr
Ky0tCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmggfCAgMiArCj4gPiAgNyBmaWxlcyBj
aGFuZ2VkLCAyMDUgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKPiA+ICBjcmVhdGUgbW9k
ZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRpdC5jCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRy
aXZlcnMvbWQvZG0tYXVkaXQuaAo+ID4gCj4gPiAtLSAKPiA+IDIuMjAuMQo+ID4gCj4gPiAtLQo+
ID4gTGludXgtYXVkaXQgbWFpbGluZyBsaXN0Cj4gPiBMaW51eC1hdWRpdEByZWRoYXQuY29tCj4g
PiBodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWF1ZGl0
Cj4gCj4gLSBSR0IKPiAKPiAtLQo+IFJpY2hhcmQgR3V5IEJyaWdncyA8cmdiQHJlZGhhdC5jb20+
Cj4gU3IuIFMvVyBFbmdpbmVlciwgS2VybmVsIFNlY3VyaXR5LCBCYXNlIE9wZXJhdGluZyBTeXN0
ZW1zCj4gUmVtb3RlLCBPdHRhd2EsIFJlZCBIYXQgQ2FuYWRhCj4gSVJDOiByZ2IsIFN1blJheWNl
cgo+IFZvaWNlOiArMS42NDcuNzc3LjI2MzUsIEludGVybmFsOiAoODEpIDMyNjM1Cj4gCgpUaGFu
a3MsCk1pY2hhZWwKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

