Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1CBC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 19F7861004
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 06:40:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 19F7861004
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-UgWW1sifMMiSwhp8JtVrHg-1; Mon, 13 Sep 2021 02:40:15 -0400
X-MC-Unique: UgWW1sifMMiSwhp8JtVrHg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E5CE802C80;
	Mon, 13 Sep 2021 06:40:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F09EE60C82;
	Mon, 13 Sep 2021 06:40:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C696A1800FE4;
	Mon, 13 Sep 2021 06:40:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18C9dPKU027650 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Sep 2021 05:39:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E9B4A5F27A; Sun, 12 Sep 2021 09:39:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DEFCE5F25A
	for <dm-devel@redhat.com>; Sun, 12 Sep 2021 09:39:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82BA8934E2
	for <dm-devel@redhat.com>; Sun, 12 Sep 2021 09:39:16 +0000 (UTC)
Received: from mail-edgeKA24.fraunhofer.de (mail-edgeka24.fraunhofer.de
	[153.96.1.24]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-41-T0FcmA--NTGf6jsC8rSLWg-1; Sun, 12 Sep 2021 05:39:14 -0400
X-MC-Unique: T0FcmA--NTGf6jsC8rSLWg-1
IronPort-SDR: Kq67nMvD7lTL4qw7rXPgrf86X+wvv2gfEKkdMg9KXYuecupeMCBHNkbLIYKtpXUKsMwHJgOc+A
	zY6mGOjZb+6jSo8b7CH76skxB6fDmm1QLkfsrNyav9GBAzIk4eJ9LDBAf+N5JLRp2gw8P7LXE9
	ovxjXbZyqjhUVERD4g4oOl2PS+vsynLFSMwNGjf+LmUMV5mu08kfFrWmfnOeJF0eAQd7/TkZCl
	Sha5a5yUybi4vpAe6XNC4ATDrPGkiqQL4BazjO3cUPDXtqLWBsoEvNW9pB6W6pYpOXlGOXJUjV
	Jvk=
IronPort-PHdr: =?us-ascii?q?A9a23=3AHbDO/BLKxBkjGc1uOtmcuY0yDhhOgF28FhQY5?=
	=?us-ascii?q?poul/RFdaHwt5jhPUmK4/JrgReJWIjA8PtLhqLQtLyoQm0P55uN8RVgOJxBX?=
	=?us-ascii?q?hMIk4MaygonBsPWE0D3LPf2KSc9GZcKWFps5XruN09TFY73bEHTpXvn6zkUF?=
	=?us-ascii?q?3CdfQp4L+j4AMjclcOygumz4JDYJQtSjSe7YbR8IQ/woQiC3vQ=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FXBQBbyj1h/xmnZsBXAx4BAQsSDEC?=
	=?us-ascii?q?BTguBUykofllphEiDSAOFOYgHA5ALilOBLoElAxgsEAsBAQEBAQEBAQEHAQE?=
	=?us-ascii?q?qCwoCBAEBAwMkhEkCF4ItASU2Bw4BAgQBAQESAQEGAQEBAQEGBAICgSCFaA2?=
	=?us-ascii?q?CcGOBCAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCDVI?=
	=?us-ascii?q?pPQEBAQECAQEBEBERDAEBJAgLAQ8CAQgYAgImAgICJQsVEAIEAQ0FIoIESwG?=
	=?us-ascii?q?CVQMOIAEBDp8bAYE6AoofeoExgQGCCAEBBgQEgTYBg1MYgRaBHgMGCQGBBiq?=
	=?us-ascii?q?Cf4QBEYZtJ4IpgUuBBoE3Nz6BBAGBXQEBgXcKJoJQgmSHYQc9NQkUKyACJBA?=
	=?us-ascii?q?FGBIMPA0SARAcDgUcIAeRRQSCfUaoTAeCA1BbikCUHzGVXZEohVCQTIxEkzs?=
	=?us-ascii?q?8hHQCBAIEBQIOAQEGgWgBgg1NJE+CaVEZD44gDAsLg1CKXkMxOAIGAQoBAQM?=
	=?us-ascii?q?JgjmDDoosAQE?=
X-IPAS-Result: =?us-ascii?q?A2FXBQBbyj1h/xmnZsBXAx4BAQsSDECBTguBUykofllph?=
	=?us-ascii?q?EiDSAOFOYgHA5ALilOBLoElAxgsEAsBAQEBAQEBAQEHAQEqCwoCBAEBAwMkh?=
	=?us-ascii?q?EkCF4ItASU2Bw4BAgQBAQESAQEGAQEBAQEGBAICgSCFaA2CcGOBCAEBAQEBA?=
	=?us-ascii?q?QEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCDVIpPQEBAQECAQEBE?=
	=?us-ascii?q?BERDAEBJAgLAQ8CAQgYAgImAgICJQsVEAIEAQ0FIoIESwGCVQMOIAEBDp8bA?=
	=?us-ascii?q?YE6AoofeoExgQGCCAEBBgQEgTYBg1MYgRaBHgMGCQGBBiqCf4QBEYZtJ4Ipg?=
	=?us-ascii?q?UuBBoE3Nz6BBAGBXQEBgXcKJoJQgmSHYQc9NQkUKyACJBAFGBIMPA0SARAcD?=
	=?us-ascii?q?gUcIAeRRQSCfUaoTAeCA1BbikCUHzGVXZEohVCQTIxEkzs8hHQCBAIEBQIOA?=
	=?us-ascii?q?QEGgWgBgg1NJE+CaVEZD44gDAsLg1CKXkMxOAIGAQoBAQMJgjmDDoosAQE?=
X-IronPort-AV: E=Sophos;i="5.85,287,1624312800"; d="scan'208";a="35536877"
Received: from mail-mtadd25.fraunhofer.de ([192.102.167.25])
	by mail-edgeKA24.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2021 11:39:09 +0200
IronPort-SDR: oK4CKC4BdXcYzc9oBrFTNNJapn8FUoCfentgLzfSZ8BNXPxE0QrGxqVgSPT1Aqyf35eVshCojk
	jTK5wpYVw0ETWomz+Khj0KU4PLh0OUBc8=
IronPort-PHdr: =?us-ascii?q?A9a23=3AnITc/B/C/Zf0y/9uWMnoyV9kXcBvk6/5Mg4c9?=
	=?us-ascii?q?twsjLcdOqig/pG3OkvZ6L0tiVLSRozU5rpCjPaeqKHvX2EMoPPj+HAPeZBBT?=
	=?us-ascii?q?VkJ3MMRmQFzGsOJCUTnavXtan9yEMFLTlQw+Xa9PABcE9r/YFuHpHq04FtwU?=
	=?us-ascii?q?hXyPAZ4PKL7AInX2s22zO25vZPJahhOhD2zbKk0IBjlxTg=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AyvUbw6xc4tBG31n48dcNKrPxdugkLtp133?=
	=?us-ascii?q?Aq2lEZdPULSKOlfpGV8MjziyWYtN9IYgBcpTiBUJPwJE81bfZOkMgs1MSZLX?=
	=?us-ascii?q?XbUQyTXcFfBOrZsnPd8kjFmNK1up0QCpSWZOeAbmSSyPyKmjVQcOxQg+Vvkp?=
	=?us-ascii?q?rY/ds2pk0FJWoBCsFdBkVCe32m+yVNNVR77PECZf6hD7981lydkAMsH6OG7x?=
	=?us-ascii?q?c+Lor+juyOsKijTQ8NBhYh5gXLpyiv8qTGHx+R2Qpbey9TwJ85mFK10TDR1+?=
	=?us-ascii?q?GGibWW2xXc32jc49B9g9360OZOA8SKl4w8NijssAC1f45sMofy+Qzd4dvfrG?=
	=?us-ascii?q?rCouO85SvIDP4Dsk85uVvF+ScF7jOQlwrGLUWSkmNwz0GT+/ARDwhKdPapzb?=
	=?us-ascii?q?gpDCcxrXBQ4O2UmZg7r15w/fBsfGL9tTW46N7SWx5wkE2o5XIkjO4IlnRaFZ?=
	=?us-ascii?q?ATcblLsOUkjQlo+bo7bWrHAbocYaJT5QDnlYJrWELfa2qcsnhkwdSqUHh2Fh?=
	=?us-ascii?q?CaQlIassjQ1zRNhnh2w0YR2cRaxx47hd4AYogB4/6BPrVjlblIQMNTZaVhBP?=
	=?us-ascii?q?0ZSc/yDmDWWxrDPG+bPFyiHqAaPHDGrYLx/dwOlayXUY1NyIF3lIXKUVteu2?=
	=?us-ascii?q?J3c0XyCdeW1JkO6RzJSHXVZ0Wl9iif3ekOhlTYfsulDcSuciFdryKQmYRpPi?=
	=?us-ascii?q?SAYYfBBHt/OY6XEVfT?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AoCQBbyj1h/z6wYZlXAx4BAQsSDEA?=
	=?us-ascii?q?JgUULgVMpKAd3WAEmQ4RHg0gDhTmFY4IkAzgBiz6EFIpTgS6BJQNUCwEDAQE?=
	=?us-ascii?q?BAQEHAQEEJgsJAQIEAQEqhEkCF4IqAiY2Bw4BAgQBAQESAQEFAQEBAgEGBIE?=
	=?us-ascii?q?RE4VoDYZCAQEBAQIBAQEQEREMAQEUEAgLAQ8CAQgYAgImAgICJQsHDhACBAE?=
	=?us-ascii?q?NBSKCBEsBglUDDiACDp8bAYE6AoofeoExgQGCCAEBBgQEgTYBg1MYgRaBHgM?=
	=?us-ascii?q?GCQGBBiqCf4QBEYZtglCBS4EGgTc3PoEEAYFdAQGBdwomglCCZIdhBz01CRQ?=
	=?us-ascii?q?rIAIkEAUYEgw8DRIBEBwOBRwgB5FFBIJ9RqhMB4IDUFuKQJQfMZVdkSiFUJB?=
	=?us-ascii?q?MjESTOzyEdAIEAgQFAg4BAQaBaAEzgVlNJE+CaVEZD44gDAsLg1CKXkIBMTg?=
	=?us-ascii?q?CBgEKAQEDCYI5gwwBAYosAQE?=
X-IronPort-AV: E=Sophos;i="5.85,287,1624312800"; d="scan'208";a="120455197"
Received: from 153-97-176-62.vm.c.fraunhofer.de (HELO
	mobile.exch.fraunhofer.de) ([153.97.176.62])
	by mail-mtaDD25.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2021 11:39:05 +0200
Received: from XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) by
	XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.858.15; Sun, 12 Sep 2021 11:38:54 +0200
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (10.225.8.37) by
	XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP
	Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.15
	via Frontend Transport; Sun, 12 Sep 2021 11:38:54 +0200
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3c2::22)
	by AM5P194MB0146.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:81::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17;
	Sun, 12 Sep 2021 09:39:01 +0000
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::ed17:5927:e044:2d07]) by AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::ed17:5927:e044:2d07%2]) with mapi id 15.20.4500.018;
	Sun, 12 Sep 2021 09:38:54 +0000
From: =?utf-8?B?V2Vpw58sIE1pY2hhZWw=?= <michael.weiss@aisec.fraunhofer.de>
To: "sgrubb@redhat.com" <sgrubb@redhat.com>, "rgb@redhat.com" <rgb@redhat.com>
Thread-Topic: [PATCH v4 0/3] dm: audit event logging
Thread-Index: AQHXoXOgatbSdzBqHE+NW6mrjnaMV6uZVrUAgAB81YCAAFD3AIAGDJaA
Date: Sun, 12 Sep 2021 09:38:54 +0000
Message-ID: <9f889eb0f97f778b2074486cdb06d7ad743bab44.camel@aisec.fraunhofer.de>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
	<20210908005942.GJ490529@madcap2.tricolour.ca>
	<9ca855cb19097b6fa98f2b3419864fd8ddadf065.camel@aisec.fraunhofer.de>
	<20210908131616.GK490529@madcap2.tricolour.ca>
In-Reply-To: <20210908131616.GK490529@madcap2.tricolour.ca>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f8e640f-5a48-413e-3545-08d975d12314
x-ms-traffictypediagnostic: AM5P194MB0146:
x-microsoft-antispam-prvs: <AM5P194MB01469D87A4D7C4FADCEDDD4FACD89@AM5P194MB0146.EURP194.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FwFeCD5Ab+VkT/BSjiA4uvhbWlxbN//GxkM2kSy5QvZAa2lTATvskBuoEsoL+Y6Khd+WH7sNx7jvjGGsCZZgvcPlE3dvQ8WM+aSu7jnWPgJDDUeEBX7TrR9E7Xua4DNxxeYjGzBET/D8n1aRB4MboeynW5+n0dwEFRrcU3Cdxt69yyLYUo0dn8of+r9yrWEH7TDR9n6OskIzs2ePRiep4KtyCmFMRXzrD7pFHsbXgBv6wg4yDBwTL5WbCSuiL5py8azHwwUlXPk1deJjIWCCE1NAPZogY+e4wBxMo3r59otOstn3JweOPMMFZEcPGSOM8oTo5nbx88wHirG0I6bAanAnkrykqkHrhxoKa2n5wQPbpX05OZFq8ZIYTlCSuqjiFN8u4SQ7DCqDgCgWXdgycl5qwqVr2eIlw/Wq8+RpFGUEGXWo+N7lVWCOERlWpjDwbyNyC+R4PHJSv9+fjkII+I9qemfrM8bZaD7YkpJDULPEOdrQaNSt8vbMqdMX7iaVmPDazaN3GfkwzS0/mioXJxsVULXsuDlNUFw88jDQf8HWOzaC68xzi/eXORDZWxYVexnmv3VVsUaoe5GL2abLp81rvKegRJggeaR0aAJMRc3tq5OSblRvAROCMyDW0Mq03NbP5da7rxnhFU/6pKiBKPa0eDpywaVtx6AlibrSZlEt1ugF2jTtTiaRYAz15GfHMC3XkL45Zc1yXxchOtf2igQtIiQaTC8Wr77Pgnq7AWQNZVFZ/U/pQIN7GYyTWnGc2gIMbEZWbIMgqaKd3iX8XTQI0eu3kW4+f7uApFvAOXE=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AS8P194MB1288.EURP194.PROD.OUTLOOK.COM;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39850400004)(8936002)(85182001)(7416002)(6512007)(8676002)(38070700005)(122000001)(110136005)(26005)(71200400001)(186003)(30864003)(83380400001)(64756008)(478600001)(66446008)(40140700001)(53546011)(6506007)(5660300002)(86362001)(76116006)(2906002)(316002)(966005)(4326008)(2616005)(66946007)(91956017)(66556008)(38100700002)(54906003)(45080400002)(6486002)(66476007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVo0dGo5dE5MQi81dWlzN3luRkQ5b2lhTitXNzU5VjhzODNOaWQ0S0RVR2N5?=
	=?utf-8?B?aU8wWkIxbUFvVnVCaTFNK3VDOFpLQlJ2WE9kaStzWmJOQXpWcTRQWEg0cUtr?=
	=?utf-8?B?WlFMOWpHdE9JN3NPc29QemRYMnlnRHhtUWJaWHY5eHM0RndKbHo1bkRKUkpt?=
	=?utf-8?B?dDBkQ2t6aXRqNUs2MmZCZGtDbTFzSWc3V2ZmL0cyRjBUdFNmNFVUbkZ5Uk9M?=
	=?utf-8?B?MW01cDF1K3NQTW9QeE1wYi9uRTRmQkswZnE2ZDVvWmRvazNYa0laczBSc1Uy?=
	=?utf-8?B?TVJ3TzNmMmVjVTdTNm1ueE9lNTNWTVo1ZHdBTVpiT0tLTE0xaUpPZFowTjNZ?=
	=?utf-8?B?R3gybmR3WVJ6amJBQmRHMWlxeVVpT2VUaFN1a2dRd1NZL04vajd5TzlTR080?=
	=?utf-8?B?enFheWR3dUNKUGdtZFdaMG1FaWFIcE5RL1VsRkk2VHB4SnFrM2Y4TGNFVS8x?=
	=?utf-8?B?eHU5NHE5dzRkclk4R1NWVmxybU9sTklVV3lKdkxjbzRvNG9lVi9IcTEzWkhl?=
	=?utf-8?B?Y0E3dXlxc0o5cVhOLzZWdC9CUzhMWHVORHlGWHdkT3cyWS9RdTArNmVaMTV3?=
	=?utf-8?B?TDRROXlDZDROWGlQU0lHQ2dlcjBoNzFVajVlc0Y4c3VLT3VETllLNHZ0UDRi?=
	=?utf-8?B?VFczVXdvMFhlYzA2R3g3WWFmWUdZTGFOSGhnNUl5ajlRMFRxRVA2MU45WlA4?=
	=?utf-8?B?QXpoaytwUnp5alNGenlHY0szOG52eVRBMGE0bkwzL2twb2tGSDlxV2p2d2Yr?=
	=?utf-8?B?UUdHSWs2U3A0S0p0ZHYrVFhqc0ZzSEdKSDNBRjRibTQzV0k0bjYvSTlvelVO?=
	=?utf-8?B?dDViMmpreUJiN2ZManFuM1RXMldCb1dmUmIzbk1ETWxNeWN1QVJGMENpVzJQ?=
	=?utf-8?B?QWtyUEtrRmRyYnFYSkZDVEhvYjIwSlNTdFZpZDg4K044RytHdVREOEM0eEhv?=
	=?utf-8?B?NGJiL2twTTRDWnVvTUVtclF2N0RXOG9Vc0Z1aDBwSmZZS21xaFEwUFZuS3lq?=
	=?utf-8?B?ZGo1SmR6WHBtVURtQk00RlpFZkM3WW9RL3doNHJxZ3FKaWNmNGl6NXpJNWgy?=
	=?utf-8?B?SlUzbVRQaldGcXE2Y2hFRDZyMW45bno5WURRM3QyYnlCbFlVa0xZR29pNFJz?=
	=?utf-8?B?bzU2aXovSnFqVTNBajNkTFpiQ2xwS01XVCtqMXFQR3grWU1GNmtJU1V3RUFx?=
	=?utf-8?B?UHRHVDFwSjlKbEdIcVBhM05kZkFUb0ZmVmVVL1BoU3k3WDFZd1gzb2NJV3Zy?=
	=?utf-8?B?bHNhUElDbFp5QWdsTTgwRkdKTVpVZm9EWUhiRFg1NVNlbFkwbDFlTkpwK1dN?=
	=?utf-8?B?SzBBTW9BL2Y5K2xTWnNRN0F1dzlIYjEvbGRPSytLNEtYV2ZMZlQzZHNoWUds?=
	=?utf-8?B?Q0d5WGJiMkUzQ0t0VTR4dk9PRlZPLzFtWTgwY3REOUI4M3B3SEgrRFNpU0Q0?=
	=?utf-8?B?VXdQNnRnZ1BLdUdPMjB4VFoyZkFNUjE3WGRmdW5CdFpqT0NtTnluSTBrYlRn?=
	=?utf-8?B?dHpVazBYL29kNk9rUTRzMWZ3RFJUcDlUbCtRV2N3K04yd1ZHV2RTZGhOWG9G?=
	=?utf-8?B?T3RxTGxoTGhzSzUrTVB4dXlLaVR4R2sxNmJKaW5IN05SaTRySGZKRTk2R05M?=
	=?utf-8?B?TlkyMnQvQ201aG5lUXg3RURzZkorRUdOSWxpZjc2Ym1kcm1TTzJoTFdOaTBr?=
	=?utf-8?B?N1A1R21VaENacjVnMzJEVjlSZjB1d0l6dUlMOC9CL0JOMzRBTmlJMkFmai9D?=
	=?utf-8?Q?aYGAxPwLB9YTOHmmegeXBTdxTWxRffAVv9HnQej?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8e640f-5a48-413e-3545-08d975d12314
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2021 09:38:54.5622 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vM9ZkbwsyuIUSZFFnz5niHx6h1gy3R/sK3S4mGAV/FFQioEnPpZumOtoFUqlFcG53mxLnUcrTV23K4BCd8HZDuIu/HgxLvBCEaFx9q8EEoFmzTVr2GmL2heR3EREF+KT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P194MB0146
X-OriginatorOrg: aisec.fraunhofer.de
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18C9dPKU027650
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9E6BFD46A10AF84A85C62C6CFF65035C@EURP194.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCAyMDIxLTA5LTA4IGF0IDA5OjE2IC0wNDAwLCBSaWNoYXJkIEd1eSBCcmlnZ3Mgd3Jv
dGU6Cj4gT24gMjAyMS0wOS0wOCAwODoyNiwgV2Vpw58sIE1pY2hhZWwgd3JvdGU6Cj4gPiBPbiBU
dWUsIDIwMjEtMDktMDcgYXQgMjA6NTkgLTA0MDAsIFJpY2hhcmQgR3V5IEJyaWdncyB3cm90ZToK
PiA+ID4gT24gMjAyMS0wOS0wNCAxMTo1OSwgTWljaGFlbCBXZWnDnyB3cm90ZToKPiA+ID4gPiBk
bSBpbnRlZ3JpdHkgYW5kIGFsc28gc3RhY2tlZCBkbSBjcnlwdCBkZXZpY2VzIHRyYWNrIGludGVn
cml0eQo+ID4gPiA+IHZpb2xhdGlvbnMgaW50ZXJuYWxseS4gVGh1cywgaW50ZWdyaXR5IHZpb2xh
dGlvbnMgY291bGQgYmUgcG9sbGVkCj4gPiA+ID4gZnJvbSB1c2VyIHNwYWNlLCBlLmcuLCBieSAn
aW50ZWdyaXR5c2V0dXAgc3RhdHVzJy4KPiA+ID4gPiAKPiA+ID4gPiA+IEZyb20gYW4gYXVkaXRp
bmcgcGVyc3BlY3RpdmUsIHdlIG9ubHkgY291bGQgc2VlIHRoYXQgdGhlcmUgd2VyZQo+ID4gPiA+
IGEgbnVtYmVyIG9mIGludGVncml0eSB2aW9sYXRpb25zLCBidXQgbm90IHdoZW4gYW5kIHdoZXJl
IHRoZQo+ID4gPiA+IHZpb2xhdGlvbiBleGFjdGx5IHdhcyB0YWtpbmcgcGxhY2UuIFRoZSBjdXJy
ZW50IGVycm9yIGxvZyB0bwo+ID4gPiA+IHRoZSBrZXJuZWwgcmluZyBidWZmZXIsIGNvbnRhaW5z
IHRob3NlIGluZm9ybWF0aW9uLCB0aW1lIHN0YW1wIGFuZAo+ID4gPiA+IHNlY3RvciBvbiBkZXZp
Y2UuIEhvd2V2ZXIsIGZvciBhdWRpdGluZyB0aGUgYXVkaXQgc3Vic3lzdGVtIHByb3ZpZGVzCj4g
PiA+ID4gYSBzZXBhcmF0ZSBsb2dnaW5nIG1lY2hhbmlzbSB3aGljaCBtZWV0cyBjZXJ0YWluIGNy
aXRlcmlhIGZvciBzZWN1cmUKPiA+ID4gPiBhdWRpdCBsb2dnaW5nLgo+ID4gPiA+IAo+ID4gPiA+
IFdpdGggdGhpcyBzbWFsbCBzZXJpZXMgd2UgbWFrZSB1c2Ugb2YgdGhlIGtlcm5lbCBhdWRpdCBm
cmFtZXdvcmsKPiA+ID4gPiBhbmQgZXh0ZW5kIHRoZSBkbSBkcml2ZXIgdG8gbG9nIGF1ZGl0IGV2
ZW50cyBpbiBjYXNlIG9mIHN1Y2gKPiA+ID4gPiBpbnRlZ3JpdHkgdmlvbGF0aW9ucy4gRnVydGhl
ciwgd2UgYWxzbyBsb2cgY29uc3RydWN0aW9uIGFuZAo+ID4gPiA+IGRlc3RydWN0aW9uIG9mIHRo
ZSBkZXZpY2UgbWFwcGluZ3MuCj4gPiA+ID4gCj4gPiA+ID4gV2UgZm9jdXMgb24gZG0taW50ZWdy
aXR5IGFuZCBzdGFja2VkIGRtLWNyeXB0IGRldmljZXMgZm9yIG5vdy4KPiA+ID4gPiBIb3dldmVy
LCB0aGUgaGVscGVyIGZ1bmN0aW9ucyB0byBsb2cgYXVkaXQgbWVzc2FnZXMgc2hvdWxkIGJlCj4g
PiA+ID4gYXBwbGljYWJsZSB0byBkbS12ZXJpdHkgdG9vLgo+ID4gPiA+IAo+ID4gPiA+IFRoZSBm
aXJzdCBwYXRjaCBpbnRyb2R1Y2UgZ2VuZXJpYyBhdWRpdCB3cmFwcGVyIGZ1bmN0aW9ucy4KPiA+
ID4gPiBUaGUgc2Vjb25kIHBhdGNoIG1ha2VzIHVzZSBvZiB0aGUgYXVkaXQgd3JhcHBlciBmdW5j
dGlvbnMgaW4gdGhlCj4gPiA+ID4gZG0taW50ZWdyaXR5LmMuCj4gPiA+ID4gVGhlIHRoaXJkIHBh
dGNoIHVzZXMgdGhlIHdyYXBwZXIgZnVuY3Rpb25zIGluIGRtLWNyeXB0LmMuCj4gPiA+ID4gCj4g
PiA+ID4gVGhlIGF1ZGl0IGxvZ3MgbG9vayBsaWtlIHRoaXMgaWYgZXhlY3V0aW5nIHRoZSBmb2xs
b3dpbmcgc2ltcGxlIHRlc3Q6Cj4gPiA+ID4gCj4gPiA+ID4gIyBkZCBpZj0vZGV2L3plcm8gb2Y9
dGVzdC5pbWcgYnM9MU0gY291bnQ9MTAyNAo+ID4gPiA+ICMgbG9zZXR1cCAtZiB0ZXN0LmltZwo+
ID4gPiA+ICMgaW50ZWdyaXR5c2V0dXAgLXZEIGZvcm1hdCAtLWludGVncml0eSBzaGEyNTYgLXQg
MzIgL2Rldi9sb29wMAo+ID4gPiA+ICMgaW50ZWdyaXR5c2V0dXAgb3BlbiAtRCAvZGV2L2xvb3Aw
IC0taW50ZWdyaXR5IHNoYTI1NiBpbnRlZ3JpdHl0ZXN0Cj4gPiA+ID4gIyBpbnRlZ3JpdHlzZXR1
cCBzdGF0dXMgaW50ZWdyaXR5dGVzdAo+ID4gPiA+ICMgaW50ZWdyaXR5c2V0dXAgY2xvc2UgaW50
ZWdyaXR5dGVzdAo+ID4gPiA+ICMgaW50ZWdyaXR5c2V0dXAgb3BlbiAtRCAvZGV2L2xvb3AwIC0t
aW50ZWdyaXR5IHNoYTI1NiBpbnRlZ3JpdHl0ZXN0Cj4gPiA+ID4gIyBpbnRlZ3JpdHlzZXR1cCBz
dGF0dXMgaW50ZWdyaXR5dGVzdAo+ID4gPiA+ICMgZGQgaWY9L2Rldi91cmFuZG9tIG9mPS9kZXYv
bG9vcDAgYnM9NTEyIGNvdW50PTEgc2Vlaz0xMDAwMDAKPiA+ID4gPiAjIGRkIGlmPS9kZXYvbWFw
cGVyL2ludGVncml0eXRlc3Qgb2Y9L2Rldi9udWxsCj4gPiA+ID4gCj4gPiA+ID4gLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQo+ID4gPiA+IGF1ZGl0LmxvZyBmcm9tIGF1ZGl0ZAo+ID4gPiA+IAo+
ID4gPiA+IHR5cGU9VU5LTk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYzMDQyNTAzOS4zNjM6MTg0KTog
bW9kdWxlPWludGVncml0eSBvcD1jdHIgcHBpZD0zODA3IHBpZD0zODE5Cj4gPiA+ID4gYXVpZD0x
MDAwIHVpZD0wIGdpZD0wIGV1aWQ9MCBzdWlkPTAgZnN1aWQ9MCBlZ2lkPTAgc2dpZD0wIGZzZ2lk
PTAgdHR5PXB0czIgc2VzPTMKPiA+ID4gPiBjb21tPSJpbnRlZ3JpdHlzZXR1cCIgZXhlPSIvc2Jp
bi9pbnRlZ3JpdHlzZXR1cCIgc3Viaj09dW5jb25maW5lZCBkZXY9MjU0OjMKPiA+ID4gPiBlcnJv
cl9tc2c9J3N1Y2Nlc3MnCj4gPiA+ID4gcmVzPTEKPiA+ID4gPiB0eXBlPVVOS05PV05bMTMzNl0g
bXNnPWF1ZGl0KDE2MzA0MjUwMzkuNDcxOjE4NSk6IG1vZHVsZT1pbnRlZ3JpdHkgb3A9ZHRyIHBw
aWQ9MzgwNyBwaWQ9MzgxOQo+ID4gPiA+IGF1aWQ9MTAwMCB1aWQ9MCBnaWQ9MCBldWlkPTAgc3Vp
ZD0wIGZzdWlkPTAgZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0eT1wdHMyIHNlcz0zCj4gPiA+ID4g
Y29tbT0iaW50ZWdyaXR5c2V0dXAiIGV4ZT0iL3NiaW4vaW50ZWdyaXR5c2V0dXAiIHN1Ymo9PXVu
Y29uZmluZWQgZGV2PTI1NDozCj4gPiA+ID4gZXJyb3JfbXNnPSdzdWNjZXNzJwo+ID4gPiA+IHJl
cz0xCj4gPiA+ID4gdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjMwNDI1MDM5LjYxMTox
ODYpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWN0ciBwcGlkPTM4MDcgcGlkPTM4MTkKPiA+ID4gPiBh
dWlkPTEwMDAgdWlkPTAgZ2lkPTAgZXVpZD0wIHN1aWQ9MCBmc3VpZD0wIGVnaWQ9MCBzZ2lkPTAg
ZnNnaWQ9MCB0dHk9cHRzMiBzZXM9Mwo+ID4gPiA+IGNvbW09ImludGVncml0eXNldHVwIiBleGU9
Ii9zYmluL2ludGVncml0eXNldHVwIiBzdWJqPT11bmNvbmZpbmVkIGRldj0yNTQ6Mwo+ID4gPiA+
IGVycm9yX21zZz0nc3VjY2VzcycKPiA+ID4gPiByZXM9MQo+ID4gPiA+IHR5cGU9VU5LTk9XTlsx
MzM2XSBtc2c9YXVkaXQoMTYzMDQyNTA1NC40NzU6MTg3KTogbW9kdWxlPWludGVncml0eSBvcD1k
dHIgcHBpZD0zODA3IHBpZD0zODE5Cj4gPiA+ID4gYXVpZD0xMDAwIHVpZD0wIGdpZD0wIGV1aWQ9
MCBzdWlkPTAgZnN1aWQ9MCBlZ2lkPTAgc2dpZD0wIGZzZ2lkPTAgdHR5PXB0czIgc2VzPTMKPiA+
ID4gPiBjb21tPSJpbnRlZ3JpdHlzZXR1cCIgZXhlPSIvc2Jpbi9pbnRlZ3JpdHlzZXR1cCIgc3Vi
aj09dW5jb25maW5lZCBkZXY9MjU0OjMKPiA+ID4gPiBlcnJvcl9tc2c9J3N1Y2Nlc3MnCj4gPiA+
ID4gcmVzPTEKPiA+ID4gPiAKPiA+ID4gPiB0eXBlPVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0KDE2
MzA0MjUwNzMuMTcxOjE5MSk6IG1vZHVsZT1pbnRlZ3JpdHkgb3A9Y3RyIHBwaWQ9MzgwNyBwaWQ9
Mzg4Mwo+ID4gPiA+IGF1aWQ9MTAwMCB1aWQ9MCBnaWQ9MCBldWlkPTAgc3VpZD0wIGZzdWlkPTAg
ZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0eT1wdHMyIHNlcz0zCj4gPiA+ID4gY29tbT0iaW50ZWdy
aXR5c2V0dXAiIGV4ZT0iL3NiaW4vaW50ZWdyaXR5c2V0dXAiIHN1Ymo9PXVuY29uZmluZWQgZGV2
PTI1NDozCj4gPiA+ID4gZXJyb3JfbXNnPSdzdWNjZXNzJwo+ID4gPiA+IHJlcz0xCj4gPiA+ID4g
Cj4gPiA+ID4gdHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjMwNDI1MDg3LjIzOToxOTIp
OiBtb2R1bGU9aW50ZWdyaXR5IG9wPWR0ciBwcGlkPTM4MDcgcGlkPTM5MDIKPiA+ID4gPiBhdWlk
PTEwMDAgdWlkPTAgZ2lkPTAgZXVpZD0wIHN1aWQ9MCBmc3VpZD0wIGVnaWQ9MCBzZ2lkPTAgZnNn
aWQ9MCB0dHk9cHRzMiBzZXM9Mwo+ID4gPiA+IGNvbW09ImludGVncml0eXNldHVwIiBleGU9Ii9z
YmluL2ludGVncml0eXNldHVwIiBzdWJqPT11bmNvbmZpbmVkIGRldj0yNTQ6Mwo+ID4gPiA+IGVy
cm9yX21zZz0nc3VjY2VzcycKPiA+ID4gPiByZXM9MQo+ID4gPiA+IAo+ID4gPiA+IHR5cGU9VU5L
Tk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYzMDQyNTA5My43NTU6MTkzKTogbW9kdWxlPWludGVncml0
eSBvcD1jdHIgcHBpZD0zODA3IHBpZD0zOTA2Cj4gPiA+ID4gYXVpZD0xMDAwIHVpZD0wIGdpZD0w
IGV1aWQ9MCBzdWlkPTAgZnN1aWQ9MCBlZ2lkPTAgc2dpZD0wIGZzZ2lkPTAgdHR5PXB0czIgc2Vz
PTMKPiA+ID4gPiBjb21tPSJpbnRlZ3JpdHlzZXR1cCIgZXhlPSIvc2Jpbi9pbnRlZ3JpdHlzZXR1
cCIgc3Viaj09dW5jb25maW5lZCBkZXY9MjU0OjMKPiA+ID4gPiBlcnJvcl9tc2c9J3N1Y2Nlc3Mn
Cj4gPiA+ID4gcmVzPTEKPiA+ID4gPiAKPiA+ID4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNnPWF1
ZGl0KDE2MzA0MjUxMTIuMTE5OjE5NCk6IG1vZHVsZT1pbnRlZ3JpdHkgb3A9aW50ZWdyaXR5LWNo
ZWNrc3VtCj4gPiA+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gPiA+IHR5cGU9
VU5LTk9XTlsxMzM3XSBtc2c9YXVkaXQoMTYzMDQyNTExMi4xMTk6MTk1KTogbW9kdWxlPWludGVn
cml0eSBvcD1pbnRlZ3JpdHktY2hlY2tzdW0KPiA+ID4gPiBkZXY9MjU0OjMgc2VjdG9yPTc3NDgw
IHJlcz0wCj4gPiA+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEyLjEx
OToxOTYpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4gPiA+IGRl
dj0yNTQ6MyBzZWN0b3I9Nzc0ODAgcmVzPTAKPiA+ID4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNn
PWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjE5Nyk6IG1vZHVsZT1pbnRlZ3JpdHkgb3A9aW50ZWdyaXR5
LWNoZWNrc3VtCj4gPiA+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gPiA+IHR5
cGU9VU5LTk9XTlsxMzM3XSBtc2c9YXVkaXQoMTYzMDQyNTExMi4xMTk6MTk4KTogbW9kdWxlPWlu
dGVncml0eSBvcD1pbnRlZ3JpdHktY2hlY2tzdW0KPiA+ID4gPiBkZXY9MjU0OjMgc2VjdG9yPTc3
NDgwIHJlcz0wCj4gPiA+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1MTEy
LjExOToxOTkpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4gPiA+
IGRldj0yNTQ6MyBzZWN0b3I9Nzc0ODAgcmVzPTAKPiA+ID4gPiB0eXBlPVVOS05PV05bMTMzN10g
bXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjIwMCk6IG1vZHVsZT1pbnRlZ3JpdHkgb3A9aW50ZWdy
aXR5LWNoZWNrc3VtCj4gPiA+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4gPiA+
IHR5cGU9VU5LTk9XTlsxMzM3XSBtc2c9YXVkaXQoMTYzMDQyNTExMi4xMTk6MjAxKTogbW9kdWxl
PWludGVncml0eSBvcD1pbnRlZ3JpdHktY2hlY2tzdW0KPiA+ID4gPiBkZXY9MjU0OjMgc2VjdG9y
PTc3NDgwIHJlcz0wCj4gPiA+ID4gdHlwZT1VTktOT1dOWzEzMzddIG1zZz1hdWRpdCgxNjMwNDI1
MTEyLjExOToyMDIpOiBtb2R1bGU9aW50ZWdyaXR5IG9wPWludGVncml0eS1jaGVja3N1bQo+ID4g
PiA+IGRldj0yNTQ6MyBzZWN0b3I9Nzc0ODAgcmVzPTAKPiA+ID4gPiB0eXBlPVVOS05PV05bMTMz
N10gbXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjIwMyk6IG1vZHVsZT1pbnRlZ3JpdHkgb3A9aW50
ZWdyaXR5LWNoZWNrc3VtCj4gPiA+ID4gZGV2PTI1NDozIHNlY3Rvcj03NzQ4MCByZXM9MAo+ID4g
PiAKPiA+ID4gQXJlIHRoZXNlIGlzb2xhdGVkIHJlY29yZHMsIG9yIGFyZSB0aGV5IGFjY29tcGFu
aWVkIGJ5IGEgdHlwZT1TWVNDQUxMCj4gPiA+IHJlY29yZCBpbiB5b3VyIGxvZ3M/Cj4gPiAKPiA+
IFlvdSBhcmUgcmlnaHQgdGhlIGRtX2F1ZGl0X2xvZ197Y3RyLGR0cn0gZnVuY3Rpb25zIHByb2R1
Y2UgdHlwZT1BVURJVF9ETV9DVFJMCj4gPiBhY2NvbXBhbmllZCBieSBhCj4gPiB0eXBlPVNZU0NB
TEwuIFRoaXMgd2FzIGEgbWlzdGFrZSBieSBtZS4gSSBncmVwcGVkCj4gPiB0aGUgYXVkaXQgbG9n
IHdpdGggJ2dyZXAgLWUgIjEzM1s2LTddIicgZHVyaW5nIG15Cj4gPiB0ZXN0cywgdGh1cyBJIGhh
dmUKPiA+IG1pc3NlZCB0aGF0LiBJIHdpbGwgcmVtb3ZlIHRoZSBhdWRpdF9sb2dfdGFza19pbmZv
KCkgY2FsbCBpbiB0aGUKPiA+IGludGVybmFsIGRtX2F1ZGl0X2xvZ190aSgpIGZ1bmN0aW9uCj4g
PiBmb3IgdHlwZT1BVURJVF9ETV9DVFJMLgo+IAo+IChUbyBnZXQgdGhlIHdob2xlIGV2ZW50cywg
dXNlICJhdXNlYXJjaCAuLi4gLW0gMTMzNiwxMzM3IC4uLiIuKQo+IAo+ID4gZG1fYXVkaXRfbG9n
X3RhcmdldCBhbmQgZG1fYXVkaXRfbG9nX2JpbyBhcmUgdXNpbmcgdHlwZT1BVURJVF9ETV9FVkVO
VCwKPiA+IFRoZXNlIGFyZSBpc29sYXRlZCBldmVudHMgc2luY2UgdGhleSBhcmUgbm90IHRyaWdn
ZXJ0IGluIHVzZXIgY29udGV4dC4gCj4gCj4gT2ssIHNvIGl0IHNvdW5kcyBsaWtlIHRob3NlIGV2
ZW50cyAqc2hvdWxkKiBoYXZlIHRhc2tfaW5mbyBpbiB0aGVpcgo+IHJlY29yZCBmb3JtYXQgc2lu
Y2UgdGhleSBhcmUgbm90IGFjY29tcGFuaWVkIGJ5IFNZU0NBTEwgcmVjb3JkcyB0aGF0Cj4gYWxy
ZWFkeSBjb250YWluIHRoYXQgaW5mb3JtYXRpb24uICBTbyBpdCBhcHBlYXJzIHRoYXQKPiBhdWRp
dF9sb2dfdGFza19pbmZvKCkgc2hvdWxkIGJlIG1vdmVkIGZyb20gdGhlIHR5cGU9QVVESVRfRE1f
Q1RSTCBjYXNlCj4gdG8gdGhlIHR5cGU9QVVESVRfRE1fRVZFTlQgY2FzZS4KCk9rIGluIGZ1cnRo
ZXIgdGVzdGluZyB1c2luZyBhdXNlYXJjaCBhcyB5b3UgcHJvcG9zZWQsIGl0IHR1cm5lZCBvdXQg
dGhhdAphbHNvIGRtX2xvZ19hdWRpdF90YXJnZXQoKQppcyBjYWxsZWQgaW4gaW9jdGwgY29udGV4
dCBhbmQgdGhlIERNX0VWRU5UcwphcmUgYWNjb21wYW5pZWQgYnkgYSBTWVNDQUxMIHJlY29yZC4g
U28gaXQgc2VlbXMgdGhhdCB3ZQpjYW4gY29tcGxldGVseQpkcm9wIGl0IGZyb20gdGhlIGRtX2F1
ZGl0X2xvZ190aSgpIGZ1bmN0aW9uLgoKPiA+ID4gVGhlIHJlYXNvbiBJIGFzayBpcyB0aGF0IGF1
ZGl0X2xvZ190YXNrX2luZm8oKSBpcyBpbmNsdWRlZCBpbiB0aHJlZSBvZgo+ID4gPiB0aGUgY2Fs
bGluZyBtZXRob2RzIChkbV9hdWRpdF9sb2dfe3RhcmdldCxjdHIsZHRyfSkgd2hpY2ggdXNlIGEK
PiA+ID4gY29tYmluYXRpb24gb2YgQVVESVRfRE1fQ1RSTC9BVURJVF9ETV9FVkVOVCB0eXBlIHdo
aWxlIHRoZSBmb3VydGgKPiA+ID4gKGRtX2F1ZGl0X2xvZ19iaW8pIGFsc28gdXNlcyBvbmUgb2Yg
dGhlIHR5cGVzIGFib3ZlIGJ1dCBkb2VzIG5vdCBpbmNsdWRlCj4gPiA+IGF1ZGl0X2xvZ190YXNr
X2luZm8oKS4gIElmIGFsbCB0aGVzZSByZWNvcmRzIGFyZSBhY2NvbXBhbmllZCBieSBTWVNDQUxM
Cj4gPiA+IHJlY29yZHMsIHRoZW4gdGhlIHRhc2sgaW5mbyB3b3VsZCBiZSByZWR1bmRhbnQgKGFu
ZCBtaWdodCBldmVuIGNvbmZsaWN0Cj4gPiA+IGlmIHRoZXJlJ3MgYSBidWcpLiAgQW5vdGhlciBt
aW5vciBvZGRpdHkgaXMgdGhlIGRvdWJsZSAiPSIgZm9yIHRoZSBzdWJqCj4gPiA+IGZpZWxkLCB3
aGljaCBkb2Vzbid0IGFwcGVhciB0byBiZSBhIGJ1ZyBpbiB5b3VyIGNvZGUsIGJ1dCBzdGlsbCBw
dXp6bGluZy4KPiA+IAo+ID4gSW4gdGhlIHRlc3Qgc2V0dXAsIEkgaGFkIEFwcGFybW9yIGVuYWJs
ZWQgYW5kIHNldCBhcyBkZWZhdWx0IHNlY3VyaXR5IG1vZHVsZS4KPiA+IFRoaXMgYmVoYXZpb3Ig
b2NjdXJzIGluIGFueSBhdWRpdF9sb2cgbWVzc2FnZS4KPiA+IFNlZW1zIHRoYXQgdGhpcyBpcyBj
b21pbmcgZnJvbSB0aGUgbGFiZWwgaGFuZGxpbmcgdGhlcmUuIEhhdmluZyBhIHF1aWNrIGxvb2sK
PiA+IGF0IHRoZSBjb2RlIHRoZXJlIGlzIHRoYXQgdGhleSB1c2UgJz0nIGluIHRoZSBsYWJlbCB0
byBwcm92aWRlIGEgcm9vdCB2aWV3IGFzCj4gPiBwYXJ0IG9mIHRoZWlyIHBvbGljeSB2aXJ0dWFs
aXphdGlvbi4gVGhlIGNvcnJlc3BvbmRpbmcgY29tbWl0IGlzIHNpdHRpbmcKPiA+IHRoZXJlIHNp
bmNlIDIwMTc6ICIyNmI3ODk5NTEwYWUyNDNlMzkyOTYwNzA0ZWJkYmE1MmQwNWZiYjEzIgo+IAo+
IEludGVyZXN0aW5nLi4uICBUaGFua3MgZm9yIHRyYWNraW5nIGRvd24gdGhhdCBjYXVzZS4gIEkg
ZG9uJ3Qga25vdyBob3cKPiBtdWNoIHBhaW4gdGhhdCB3aWxsIGNhdXNlIHRoZSB1c2Vyc3BhY2Ug
cGFyc2luZyB0b29scy4gIEkndmUgYWRkZWQgU3RldmUKPiBHcnViYiB0byB0aGUgQ2M6IHRvIGdl
dCBoaXMgaW5wdXQsIGJ1dCB0aGlzIHNob3VsZCBub3QgZGVyYWlsIHRoaXMgcGF0Y2gKPiBzZXQu
Cj4gCj4gVGhpcyBoYXMgcGFyYWxsZWxzIHRvIHRoaXMgcHJldmlvdXNseSByZXBvcnRlZCBpc3N1
ZSB3aXRoIGltYS9pbnRlZ3JpdHk6Cj4gCWh0dHBzOi8vZ2l0aHViLmNvbS9saW51eC1hdWRpdC9h
dWRpdC1rZXJuZWwvaXNzdWVzLzExMwo+IAo+ID4gPiBBcmUgdGhvc2UgbGFzdCAxMCByZWNvcmRz
IGV4cGVjdGVkIHRvIGJlIGlkZW50aWNhbCBvdGhlciB0aGFuIGV2ZW50Cj4gPiA+IHNlcmlhbCBu
dW1iZXI/Cj4gPiAKPiA+IFllcywgYmVjYXVzZSB0aGUgYWNjZXNzIHRvIHRoZSBjb3JydXB0IHNl
Y3RvciBpcyBtYWRlIDEwIHRpbWVzLgo+ID4gVGhpcyByZWZsZWN0cyBleGFjdGx5IHRoZSBzYW1l
IGJlaGF2aW9yIHdpdGhvdXQgdGhlIGF1ZGl0IGxvZ2dpbmcsIGluIHRoZSAKPiA+IGtlcm5lbCBk
ZWJ1ZyBsb2cuCj4gCj4gSXMgdGhlcmUgYW55IG90aGVyIGRpc3Rpbmd1aXNoaW5nIGluZm9ybWF0
aW9uIGZvciB0aGF0IGV2ZW50IG90aGVyIHRoYW4KPiBhdWRpdCBsb2cgc2VyaWFsIG51bWJlciB0
aGF0IHdvdWxkIGJlIHVzZWZ1bCB0byBhZGQ/ICAoSXQgZG9lc24ndCBzb3VuZAo+IGxpa2UgaXQu
KQpObyB0aGVyZSBpc24ndC4KCkZ1cnRoZXIsIEkgaGF2ZSBlbmNvdW50ZXJlZCBzb21lIG90aGVy
IHF1aXJrcywgd2hpY2ggSSB3aWxsIGZpeCBpbiB2NS4KVGhlIGR0ciBpcyBjYWxsZWQgaW50ZXJu
YWxseQpvbiBlcnJvciBpbiBjdHIsIHdoaWNoIHJlc3VsdHMgaW4gdGhlIHNhbWUKYXVkaXQgbG9n
IHNlcmlhbCBvZiBhIGN0ciBmb2xsb3dlZCBieSBhIGR0ciBldmVudC4KQW5kIEkKbWlzc2VkIHRv
IHN5bmNocm9uaXplIHRoZSBhdWRpdCBsb2cgaW4gZG0taW50ZWdyaXR5LmMsIHdoaWNoIHJlc3Vs
dHMgaW4KZHVwbGljYXRlIGV2ZW50cyBsb2dnZWQgYnkKdGhlIHdvcmtlciB0aHJlYWRzLgoKVGhh
bmtzIGZvciB0aGUgaGludCB3aXRoIGF1c2VhcmNoLiBGb3Igb3VyIHVzZSBjYXNlIHdlIGRvIG5v
dCBkZXBlbmQgb24gdGhlCnVzZXJzcGFjZSBwYXJ0IG9mIGxpbnV4LWF1ZGl0IGFuZCBJIHVzZWQg
dGhhdCBvbmx5IGZvciB0ZXN0aW5nLCBhbmQgb2J2aW91c2x5Cm1pc3NlZCBzb21lIGNvbnZlbnRp
b25zCnRoZXJlLgoKSSB0aGluayBhYm91dCB0byByZW5hbWUgdGhlIGVycm9yX21zZyBmaWVsZCB0
byByZWFzb24gYW5kIHRvIHByZS1wcm9jZXNzIHRoZQpzdHJpbmcgd2l0aCBzdHJyZXBsYWNlKCkK
dG8gcmVwbGFjZSBzcGFjZXMgYnkgJy0nIGluc3RlYWQgb2YgZGlyZWN0bHkgbG9nZ2luZwplcnJv
cl9tc2c9IGFzIHF1b3RlZCBTdHJpbmcuIFdoYXQgZG8geW91IGd1eXMgdGhpbmsgYWJvdXQgdGhp
cz8KCkkgYWxzbyB3aWxsIHJ1biB0aGUgdGVzdCBzdWl0IGxpbmtlZCBpbiBTdGV2ZSdzIHdpa2kg
dG8gYmUgc3VyZSBub3QgdG8gYnJlYWsKdXNlcnNwYWNlIHBhcnQgb2YgbGludXgtYXVkaXQgYmVm
b3JlIEkgc3VibWl0IHY1LgoKPiAKPiA+ID4gPiB2NCBDaGFuZ2VzOgo+ID4gPiA+IC0gQWRkZWQg
Y29tbWVudHMgb24gaW50ZW5kZWQgdXNlIG9mIHdyYXBwZXIgZnVuY3Rpb25zIGluIGRtLWF1ZGl0
LmgKPiA+ID4gPiAtIGRtX2F1ZGl0X2xvZ19iaW8oKTogRml4ZWQgbWlzc2luZyAnPScgYXMgc3Bv
dHRlZCBieSBQYXVsCj4gPiA+ID4gLSBkbV9hdWRpdF9sb2dfdGkoKTogSGFuZGxlIHdyb25nIGF1
ZGl0X3R5cGUgYXMgc3VnZ2VzdGVkIGJ5IFBhdWwKPiA+ID4gPiAKPiA+ID4gPiB2MyBDaGFuZ2Vz
Ogo+ID4gPiA+IC0gVXNlIG9mIHR3byBhdWRpdCBldmVudCB0eXBlcyBBVURJVF9ETV9FVkVOVCB1
bmQgQVVESVRfRE1fQ1RSTAo+ID4gPiA+IC0gQWRkaXRpb25hbHkgdXNlIGF1ZGl0X2xvZ190YXNr
X2luZm8gaW4gY2FzZSBvZiBBVURJVF9ETV9DVFJMIG1lc3NhZ2VzCj4gPiA+ID4gLSBQcm92aWRl
IGNvbnNpc3RlbnQgZmllbGRzIHBlciBtZXNzYWdlIHR5cGUgYXMgc3VnZ2VzdGVkIGJ5IFBhdWwK
PiA+ID4gPiAtIEFkZGVkIHNhbXBsZSBldmVudHMgdG8gY29tbWl0IG1lc3NhZ2Ugb2YgWzEvM10g
YXMgc3VnZ2VzdGVkIGJ5IFBhdWwKPiA+ID4gPiAtIFJlYmFzZWQgb24gdjUuMTQKPiA+ID4gPiAK
PiA+ID4gPiB2MiBDaGFuZ2VzOgo+ID4gPiA+IC0gRml4ZWQgY29tcGlsZSBlcnJvcnMgaWYgQ09O
RklHX0RNX0FVRElUIGlzIG5vdCBzZXQKPiA+ID4gPiAtIEZpeGVkIGZvcm1hdHRpbmcgYW5kIHR5
cG9zIGFzIHN1Z2dlc3RlZCBieSBDYXNleQo+ID4gPiA+IAo+ID4gPiA+IE1pY2hhZWwgV2Vpw58g
KDMpOgo+ID4gPiA+ICAgZG06IGludHJvZHVjZSBhdWRpdCBldmVudCBtb2R1bGUgZm9yIGRldmlj
ZSBtYXBwZXIKPiA+ID4gPiAgIGRtIGludGVncml0eTogbG9nIGF1ZGl0IGV2ZW50cyBmb3IgZG0t
aW50ZWdyaXR5IHRhcmdldAo+ID4gPiA+ICAgZG0gY3J5cHQ6IGxvZyBhZWFkIGludGVncml0eSB2
aW9sYXRpb25zIHRvIGF1ZGl0IHN1YnN5c3RlbQo+ID4gPiA+IAo+ID4gPiA+ICBkcml2ZXJzL21k
L0tjb25maWcgICAgICAgICB8IDEwICsrKysrCj4gPiA+ID4gIGRyaXZlcnMvbWQvTWFrZWZpbGUg
ICAgICAgIHwgIDQgKysKPiA+ID4gPiAgZHJpdmVycy9tZC9kbS1hdWRpdC5jICAgICAgfCA4NCAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ID4gPiA+ICBkcml2ZXJzL21k
L2RtLWF1ZGl0LmggICAgICB8IDY2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ID4g
PiA+ICBkcml2ZXJzL21kL2RtLWNyeXB0LmMgICAgICB8IDIyICsrKysrKysrLS0KPiA+ID4gPiAg
ZHJpdmVycy9tZC9kbS1pbnRlZ3JpdHkuYyAgfCAyNSArKysrKysrKysrLS0KPiA+ID4gPiAgaW5j
bHVkZS91YXBpL2xpbnV4L2F1ZGl0LmggfCAgMiArCj4gPiA+ID4gIDcgZmlsZXMgY2hhbmdlZCwg
MjA1IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCj4gPiA+ID4gIGNyZWF0ZSBtb2RlIDEw
MDY0NCBkcml2ZXJzL21kL2RtLWF1ZGl0LmMKPiA+ID4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRy
aXZlcnMvbWQvZG0tYXVkaXQuaAo+ID4gPiA+IAo+ID4gPiA+IC0tIAo+ID4gPiA+IDIuMjAuMQo+
ID4gPiA+IAo+ID4gPiA+IC0tCj4gPiA+ID4gTGludXgtYXVkaXQgbWFpbGluZyBsaXN0Cj4gPiA+
ID4gTGludXgtYXVkaXRAcmVkaGF0LmNvbQo+ID4gPiA+IGh0dHBzOi8vbGlzdG1hbi5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vbGludXgtYXVkaXQKPiA+ID4gCj4gPiA+IC0gUkdCCj4gPiA+
IAo+ID4gPiAtLQo+ID4gPiBSaWNoYXJkIEd1eSBCcmlnZ3MgPHJnYkByZWRoYXQuY29tPgo+ID4g
PiBTci4gUy9XIEVuZ2luZWVyLCBLZXJuZWwgU2VjdXJpdHksIEJhc2UgT3BlcmF0aW5nIFN5c3Rl
bXMKPiA+ID4gUmVtb3RlLCBPdHRhd2EsIFJlZCBIYXQgQ2FuYWRhCj4gPiA+IElSQzogcmdiLCBT
dW5SYXljZXIKPiA+ID4gVm9pY2U6ICsxLjY0Ny43NzcuMjYzNSwgSW50ZXJuYWw6ICg4MSkgMzI2
MzUKPiA+ID4gCj4gPiAKPiA+IFRoYW5rcywKPiA+IE1pY2hhZWwKPiAKPiAtIFJHQgo+IAo+IC0t
Cj4gUmljaGFyZCBHdXkgQnJpZ2dzIDxyZ2JAcmVkaGF0LmNvbT4KPiBTci4gUy9XIEVuZ2luZWVy
LCBLZXJuZWwgU2VjdXJpdHksIEJhc2UgT3BlcmF0aW5nIFN5c3RlbXMKPiBSZW1vdGUsIE90dGF3
YSwgUmVkIEhhdCBDYW5hZGEKPiBJUkM6IHJnYiwgU3VuUmF5Y2VyCj4gVm9pY2U6ICsxLjY0Ny43
NzcuMjYzNSwgSW50ZXJuYWw6ICg4MSkgMzI2MzUKPiAKCgpUaGFua3MsCk1pY2hhZWwKCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

