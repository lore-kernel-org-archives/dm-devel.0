Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE736C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26ACA60FD9
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 06:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 26ACA60FD9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-WOzvBQenOmaLKF4aTTfAxA-1; Mon, 23 Aug 2021 02:40:25 -0400
X-MC-Unique: WOzvBQenOmaLKF4aTTfAxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 684E7190A7A4;
	Mon, 23 Aug 2021 06:40:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D14560BD9;
	Mon, 23 Aug 2021 06:40:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 241E34A7CD;
	Mon, 23 Aug 2021 06:40:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17JJTO4T012360 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 15:29:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7B008201181D; Thu, 19 Aug 2021 19:29:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7405F20B8C96
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 19:29:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08592866DF4
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 19:29:21 +0000 (UTC)
Received: from mail-edgeKA27.fraunhofer.de (mail-edgeka27.fraunhofer.de
	[153.96.1.27]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-79-xrBFU67kMuqdUj0mkyLCPA-1; Thu, 19 Aug 2021 15:29:16 -0400
X-MC-Unique: xrBFU67kMuqdUj0mkyLCPA-1
IronPort-SDR: Y+tWafKSOYtIp7iLiwcNpA9P3rWuoZ/8qL3mSqpjwja2OQ59dmLynEHwPD+GPjECrKaqmT7eJl
	PObVC+RM9fZ15mNpjNMpQumPfEs0ysl9FVhP+Mxco4Hqj3iBllFnDTfWprhR8WPgAilAmPtHQo
	LXK3NbIuc49l03bOGzo5V6nqUllqTnXuw1f1xgUKBEQXh95TW4Cp/IJvgJRHWOUAg0OE8pEBcS
	WtXr5EKqWR0uw6a0MA+h95Tl5fvWu1hqvwCtp52NhKaMX4tbYmKjoUw3yZIMJl8k85TtJMFDn+
	S/4=
IronPort-PHdr: =?us-ascii?q?A9a23=3Ao7SfjRKJCTABEUFZbdmcuZUyDhhOgF28FhYc9?=
	=?us-ascii?q?55ijrVJaKnl9JPnbwTT5vRo2VnOW4iTq/dJkPHfvK2oX2scqY2Av3YPfN0pN?=
	=?us-ascii?q?VcFhMwakhZmDJuDDkv2f+bjcih/GcNFTlIj9Ha+YgBZHc/kbAjUpXu/pTcZB?=
	=?us-ascii?q?hT4M19zIeL4f+yaj8m+2+2ovZPJZAAdjTumbLg0Ig+/sAPRsccbm81uJ/VZ9?=
	=?us-ascii?q?w=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FIAAAjsB5h/xoHYZlaHQEBAQEJARI?=
	=?us-ascii?q?BBQUBQIFFCAELAYFSKSiBV2mESINIA4RZYIgEA4ERmSyBLhSBEQNUCwEBAQE?=
	=?us-ascii?q?BAQEBAQcBAT8CBAEBAwOEXwIXgiABJTQJDgECBAEBARIBAQYBAQEBAQYEAgK?=
	=?us-ascii?q?BIIVoAQyDU4EIAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQE?=
	=?us-ascii?q?BBQKBCD0BAQEBAgESEQQNDAEBNwEPAgEIGAICJgICAjAVEAIEDgUiggNLglY?=
	=?us-ascii?q?DDiACnUcBgToCih96fzKBAYIHAQEGBASFChiBFoEeCQkBgQYqAYJ9hBCFSIE?=
	=?us-ascii?q?fJ4IpgRU2gQWBMzc+hAdUgwCCZIQqUxkHB3QTAYEBKgVVEgE/BhYekUqDAUa?=
	=?us-ascii?q?nH4EYB4IBUFueVSyDZYtjhg+RHoVPgSyPGaAfhH8CBAIEBQIOAQEGgWGCFU0?=
	=?us-ascii?q?kgzhQGQ+OIAwWg1CKXkMwAjYCBgEKAQEDCW6JFQEB?=
X-IPAS-Result: =?us-ascii?q?A2FIAAAjsB5h/xoHYZlaHQEBAQEJARIBBQUBQIFFCAELA?=
	=?us-ascii?q?YFSKSiBV2mESINIA4RZYIgEA4ERmSyBLhSBEQNUCwEBAQEBAQEBAQcBAT8CB?=
	=?us-ascii?q?AEBAwOEXwIXgiABJTQJDgECBAEBARIBAQYBAQEBAQYEAgKBIIVoAQyDU4EIA?=
	=?us-ascii?q?QEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBBQKBCD0BAQEBA?=
	=?us-ascii?q?gESEQQNDAEBNwEPAgEIGAICJgICAjAVEAIEDgUiggNLglYDDiACnUcBgToCi?=
	=?us-ascii?q?h96fzKBAYIHAQEGBASFChiBFoEeCQkBgQYqAYJ9hBCFSIEfJ4IpgRU2gQWBM?=
	=?us-ascii?q?zc+hAdUgwCCZIQqUxkHB3QTAYEBKgVVEgE/BhYekUqDAUanH4EYB4IBUFueV?=
	=?us-ascii?q?SyDZYtjhg+RHoVPgSyPGaAfhH8CBAIEBQIOAQEGgWGCFU0kgzhQGQ+OIAwWg?=
	=?us-ascii?q?1CKXkMwAjYCBgEKAQEDCW6JFQEB?=
X-IronPort-AV: E=Sophos;i="5.84,335,1620684000"; d="scan'208";a="35130528"
Received: from mail-mtas26.fraunhofer.de ([153.97.7.26])
	by mail-edgeKA27.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 21:29:13 +0200
IronPort-SDR: GnK6fbkQOIbqeVKO7ol5NqHROOmekACf6cRPLtQ5VYPB3hYAFjpj8D7/tYRwRZqiz6OT8MLUv2
	LQR42j3li6FynWp5Aw9qleCamktNY3Sr4=
IronPort-PHdr: =?us-ascii?q?A9a23=3AUB3E3BZkpOEHT9merj1yJQT/LTDdhN3EVzX9o?=
	=?us-ascii?q?rI/gq9KN6Gk+I7vekfY4KYlgFzIWNDd7PRJw6rTvrv7UGMNqZCGrDgZcZNKW?=
	=?us-ascii?q?hNE7KdenwEpDMOfT0GuKvnsYn8iFdlGEVpi+Gu2d0NSHZW2a1jbuHbn6zkUF?=
	=?us-ascii?q?132PhZ0IeKgHInUgqHVn+C/8pHeeUNGnj24NLpzNxi96wvLv9QQgYxsJ7x3x?=
	=?us-ascii?q?haaykY=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AzBn3gKom0il73pUIK/Idn7saV5txLNV00z?=
	=?us-ascii?q?EX/kB9WHVpm5Oj+PxGzc526farslsssSkb6K290KnpewK4yXbsibNhfItKLz?=
	=?us-ascii?q?OWxFdAS7sSrbcKogeQVREWk9Qy6U4OSdkGNDSdNykYsS++2njDLz9C+qjFzE?=
	=?us-ascii?q?nLv5an854Fd2gDAMsAjzuRSDzraXGeLDM2WKbRf6Dsgvav0gDQH0j/Gf7LYU?=
	=?us-ascii?q?XtMdKzxeHjpdbDW1orFhQn4A6BgXeD87jhCSWV2R8YTndm3aoi2XKtqX262o?=
	=?us-ascii?q?yT99WAjjPM3W7a6Jpb3PH7zMFYOcCKgs8Jbh3xlweTYph7UbHqhkFxnAjv0i?=
	=?us-ascii?q?dvrDD/mWZnAy1B0QKJQohzm2q05+DU6kdo15Yl8y7CvZKsm72ieNtwMbs/uW?=
	=?us-ascii?q?sQSGqm16NnhqAh7EsD5RPoi3IcZymw7RjV9pzGUQpnmVGzpmdnmekPj2ZHWY?=
	=?us-ascii?q?9bc7NJq5cDlXklWqvoMRiKoLzPKtMeR/00JcwmBW+yfjTcpC1i0dasVnM8El?=
	=?us-ascii?q?OPRVUDoNWc13xTkGpix0UVycQDljNYnahNB6Vs9qDBKOBlhbtORsgZYeZ0A/?=
	=?us-ascii?q?oAW9K+DijITQjXOGyfLFz7HOUMOm7LqZTw/LIpjdvaNaAg3d83gtDMQVlYvW?=
	=?us-ascii?q?k9dwbnDtCPxoRC9lTXTGC0TV3Wu4hjDlhCy8vBrZ/QQGK+oXwV4rmdSsQkc7?=
	=?us-ascii?q?rmsqyISeFr6tfYXB7TJbo=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0DFAACTsB5h/z6wYZlaHQEBAQEJARI?=
	=?us-ascii?q?BBQUBQAmBPAgBCwGBUikoB0yBAwEmQ4RHg0gDhFlghWCCJAM4AViIH4I0jlm?=
	=?us-ascii?q?BLhSBEQNUCwEDAQEBAQEHAQEEOgECBAEBhGUCF4IdAiY0CQ4BAgQBAQESAQE?=
	=?us-ascii?q?FAQEBAgEGBIERE4VoAQyGQgEBAQECARIRBA0MAQEUIwEPAgEIGAICJgICAjA?=
	=?us-ascii?q?HDhACBA4FIoIDS4JWAw4gAp1GAYE6Aoofen8ygQGCBwEBBgQEhQoYgRaBHgk?=
	=?us-ascii?q?JAYEGKgGCfYQQhUiBH4JQgRU2gQWBMzc+hAdUgwCCZIQqUxkHB3QTAYEBKgV?=
	=?us-ascii?q?VEgE/BhYekUqDAUanH4EYB4IBUFueVSyDZYtjhg+RHoVPgSyPGaAfhH8CBAI?=
	=?us-ascii?q?EBQIOAQEGgWE7gVlNJIM4UBkPjiAMFoNQil5CATACNgIGAQoBAQMJbAEBiRU?=
	=?us-ascii?q?BAQ?=
X-IronPort-AV: E=Sophos;i="5.84,335,1620684000"; d="scan'208";a="151151304"
Received: from 153-97-176-62.vm.c.fraunhofer.de (HELO
	mobile.exch.fraunhofer.de) ([153.97.176.62])
	by mail-mtaS26.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	19 Aug 2021 21:29:10 +0200
Received: from XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) by
	XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.858.12; Thu, 19 Aug 2021 21:29:10 +0200
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (10.225.8.37) by
	XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP
	Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12
	via Frontend Transport; Thu, 19 Aug 2021 21:29:10 +0200
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3c2::22)
	by AM5P194MB0193.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:89::13) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19;
	Thu, 19 Aug 2021 19:29:03 +0000
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::4003:49ec:516:cc88]) by AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::4003:49ec:516:cc88%9]) with mapi id 15.20.4415.024;
	Thu, 19 Aug 2021 19:29:03 +0000
From: =?utf-8?B?V2Vpw58sIE1pY2hhZWw=?= <michael.weiss@aisec.fraunhofer.de>
To: "paul@paul-moore.com" <paul@paul-moore.com>
Thread-Topic: [PATCH v2 1/3] dm: introduce audit event module for device mapper
Thread-Index: AQHXkTsP+nqUb8DozEWQEIL7nX0Ymat5o8gAgAGasAA=
Date: Thu, 19 Aug 2021 19:29:03 +0000
Message-ID: <67990d4f1ddc277a4444d329ea3623775616aa31.camel@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
	<20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
	<CAHC9VhRB1iviuOyeqi3L4DC8LNfnkz1HXC3hdqNvqm2sZQYXMQ@mail.gmail.com>
In-Reply-To: <CAHC9VhRB1iviuOyeqi3L4DC8LNfnkz1HXC3hdqNvqm2sZQYXMQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58b8ac2f-d917-4717-45a3-08d963479a77
x-ms-traffictypediagnostic: AM5P194MB0193:
x-microsoft-antispam-prvs: <AM5P194MB01932A4A91A4659519F707F6ACC09@AM5P194MB0193.EURP194.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3968
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: mFHoc7t1Y+aX2j2eBKlWobN7AmvG//rLKyXLqLirsI3fy3f0n3eg6JGszEUQzJ4c3B18aUppEp8PVsMjFhsambrU4LTxYDG3cCxj60INKiJ0w1EfrWnjmlg5iAPkR/rF4HtpgX+9e7DtH1ds36i3kWoaMuLDOMqUWF5evsA4qx4DrKn1qkOHcumnAxM5WnSdk1llMXJ25K9CwR1Lbg8ohXBLWdGweSMvr5/6pbCwIpsXaCS6ElXzNgzXDasOARdPjvFgsYDggtb0H2RZX1idOp6w917gDuCxg32S2gFX6B83nCJnvC5wQzk9/9x456ua1hMi1SibrjFDdqbDblpPcYhQPGdoadvw6tp35OSEByy0T3c8lj4Mqay5lnxnMbmbIDe/m3XlUfSQ7rqC8fw0iulmDVNRKzAvpg1f3XYH6qrPSIQEf/FZfOeaD0wNPPi9GhaekCVqhLfq/KMA3a6In4iMxSizl0cJTvobWGduFiYhe0H3RO0YvLPBELBICB88L3lmCRzb2ADzBcERChSlYfcCuC7WUl6SybMA/wc863C52ihlnN9hIvPKRNw5ZsDBsRg0QjT5BihjmwkgcHNUpCxdsfvpbyQQmefC9FKteAD6IsxqNjDytqiBYk8mgzFn6ifEbegzDXfMISYI0oG3kVI/h0zsMytMjrIdcJj3eBFxEb+Ibj9PeQ5PmQGmUzulMYgF6xGnmkXgGEm75DPSlw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AS8P194MB1288.EURP194.PROD.OUTLOOK.COM;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39840400004)(186003)(8676002)(85182001)(6512007)(122000001)(4326008)(316002)(38100700002)(71200400001)(6486002)(7416002)(2906002)(83380400001)(54906003)(66476007)(91956017)(66446008)(76116006)(2616005)(66556008)(8936002)(53546011)(26005)(6506007)(66946007)(38070700005)(86362001)(5660300002)(478600001)(64756008)(6916009);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFV2UkZ2UzFLaGZRL0VDN2lYRysyUzNEQTNDTmcvUjJEYk1rTnVIdEdkWEl3?=
	=?utf-8?B?SG9KOTRROFNkcjZ6RFBzSVBzT203ekNadEtDWGhOUWtwWHgxaDJTZ0x5Mkh6?=
	=?utf-8?B?Qk1hc1BIRmZHL0tiM1l5WEFFTERFRnNmWjdzbzFpUkNEV3liYThzN0xsT2dm?=
	=?utf-8?B?aWcwbXBoMzI0V1ZIVUNJc1FZN0xQSHFKbEpMV3Rwb1A0b2ljcngvZmpxNUxz?=
	=?utf-8?B?TGo4VWJtZVI2WWVISEpMc3J1UjltVWZ2L2k2MlIzZFJ0M1JmemgyRHdaUXAy?=
	=?utf-8?B?SUZvbnBTR1NZckFRKzRxT3N0YUovNGsxUWFIZjNxZ0p0cWJpNlhnTU1WUkJT?=
	=?utf-8?B?RklEOWl3dEt3NU1GS2FxNnBEaWJqYjc0SkFoV1FSNWNpdTVOUnZnMjU2OWxh?=
	=?utf-8?B?SFhydTNsand3aFFaWjhDYWxvUWpNYkphN3FVZGJRS3VTOVVxRlJ1NWhCQUJE?=
	=?utf-8?B?b1ZkNGV2RFR3QjNwaUxDeUMrU2lMZ1V2eXpNUlBXYU9oVW16MEo2V2VhS1RD?=
	=?utf-8?B?YW44U1k4bDFGUW84eVpRSTNnN3ZFV2dpbXoyaG8vN0V0R3k4NUN5UmFTZnJ3?=
	=?utf-8?B?OGdoK2hCcG4rZERJK1pjSzc0T2U5M1FtV1poMXNxS0VQUjZEZ2JJZVJxQkZU?=
	=?utf-8?B?NVVDU3o3STFjenQyN2RIWkNxTk5nVTF4UDYvcmhpd09mUC9Cczl1VHp5SGVN?=
	=?utf-8?B?QWhQVW1ObCt6b0EwdzkxWjlWUUxaaXlUUGNLQVA1T29rQ0RYT0Z3RkR3UkFr?=
	=?utf-8?B?M09uUkhSTmdQNXZMQy9XanREZEtXWG9nUmFKNWJnd3JaWnVTYlhhK2NpdXNN?=
	=?utf-8?B?MU5HVWg0WXUwamNhMFNyeUpFNnZBUllTR3dTdW9NR0JGMDdWZnZUR0ZwZ1dG?=
	=?utf-8?B?Ty9xSUcyZnJQSmpvS1VUOEJka25nTnd4R1NTVWU1K1BuVVh5V3E2OFpFeFhl?=
	=?utf-8?B?OXlGTnpCZUZyend1c1UxMWRFVTh6Unl3bVRPdmhQdEw4b0J4aGZ3bExRUS9n?=
	=?utf-8?B?TEZPSWtxdHF0N1B4NjVhLzBtSVdyS3dkaWljWGdOV21XN00rRm9HZ1M2WjVG?=
	=?utf-8?B?bFh6cm5yZUlWNUxwNWFSOGRUYkpOTHJZTWdZV1laQlBBMHlBalUxdkVma2hS?=
	=?utf-8?B?YlF1Y3VWOEJWdGt5S05zSUtmdFlSUFY1MGQ4VmZqc0RSMEd1Rm5rallFbG5s?=
	=?utf-8?B?cHk4OWF1eGJ4UVJpRSt1T1JMSmxhWTJvRzF1R0owTlNvM0xSUnlCaFFQMEJw?=
	=?utf-8?B?d244eW5zSFdXVDdCR29QVDFLaTdSTHFkMG1ZeGlhbGdFcWZwbCtrYnpFNTNx?=
	=?utf-8?B?bWEyU1J6NWU2NkV2UHVPSlJ5MU9MaVJJVzJwb2o3KzdTV0tNQ3FxOXRZN1JZ?=
	=?utf-8?B?Mm5ERk82WDNUdCtyQWNxR0NkanpvZUlpMnpRaWRKQzJPS0pra3FWcks3T2pU?=
	=?utf-8?B?UnNTbm9zVzdiUjIvc28xdWRFekZJcEdXT0RqRUdLQ25nLzhWL1AwU1FxQWZ3?=
	=?utf-8?B?S0FFc3FSeXZUcGdRMkJaUzh4bXczRWg4U1JaTzIyRlBGK09JVkpaNDB4Rndi?=
	=?utf-8?B?QTBNWlJRdkY5MXMvSGU1M1p2bzNFMUwrb1FvOXFGTjBGVC9ZMXEyd0ZjU0lP?=
	=?utf-8?B?WklRUStJSFN2d3prMXRvNUxLMkpxcGRCVVVnNnFJTUF1cndwU3ROdGJJWkg5?=
	=?utf-8?B?QzlrbTJ3bmIzMnNQS1JJZS9ubUMyeVJnL0JFZkVIeDU0cGtLVGVLdWdoSVJZ?=
	=?utf-8?Q?jBvozODhCJPodVo2v4nuzoRbVDCfRMvHfR4TxUP?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b8ac2f-d917-4717-45a3-08d963479a77
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 19:29:03.3657 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+NhJ4mpfvvvjEbA2qPCewMAvvazesiMusm37N8IBeE4GGO8uEev0xpAcAXQ9dR4/0qPMYb8Blx2LoFknhHaD2Yz/9LyWm84Y5f1eeQ2R5SYhOgUN7Bw92UTJEVImmOy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P194MB0193
X-OriginatorOrg: aisec.fraunhofer.de
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17JJTO4T012360
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Aug 2021 02:39:55 -0400
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"casey@schaufler-ca.com" <casey@schaufler-ca.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] dm: introduce audit event module for
	device mapper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1E4EB1CFA03B4E40BB825854767D65AB@EURP194.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCAyMDIxLTA4LTE4IGF0IDE0OjU5IC0wNDAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+IE9u
IFNhdCwgQXVnIDE0LCAyMDIxIGF0IDI6MzQgUE0gTWljaGFlbCBXZWnDnwo+IDxtaWNoYWVsLndl
aXNzQGFpc2VjLmZyYXVuaG9mZXIuZGU+IHdyb3RlOgo+ID4gVG8gYmUgYWJsZSB0byBzZW5kIGF1
ZGl0aW5nIGV2ZW50cyB0byB1c2VyIHNwYWNlLCB3ZSBpbnRyb2R1Y2UKPiA+IGEgZ2VuZXJpYyBk
bS1hdWRpdCBtb2R1bGUuIEl0IHByb3ZpZGVzIGhlbHBlciBmdW5jdGlvbnMgdG8gZW1pdAo+ID4g
YXVkaXQgZXZlbnRzIHRocm91Z2ggdGhlIGtlcm5lbCBhdWRpdCBzdWJzeXN0ZW0uIFdlIGNsYWlt
IHRoZQo+ID4gQVVESVRfRE0gdHlwZT0xMzM2IG91dCBvZiB0aGUgYXVkaXQgZXZlbnQgbWVzc2Fn
ZXMgcmFuZ2UgaW4gdGhlCj4gPiBjb3JyZXNwb25kaW5nIHVzZXJzcGFjZSBhcGkgaW4gJ2luY2x1
ZGUvdWFwaS9saW51eC9hdWRpdC5oJyBmb3IKPiA+IHRob3NlIGV2ZW50cy4KPiA+IAo+ID4gRm9s
bG93aW5nIGNvbW1pdHMgdG8gZGV2aWNlIG1hcHBlciB0YXJnZXRzIGFjdHVhbGx5IHdpbGwgbWFr
ZQo+ID4gdXNlIG9mIHRoaXMgdG8gZW1pdCB0aG9zZSBldmVudHMgaW4gcmVsZXZhbnQgY2FzZXMu
Cj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgV2Vpw58gPG1pY2hhZWwud2Vpc3NAYWlz
ZWMuZnJhdW5ob2Zlci5kZT4KPiAKPiBIaSBNaWNoYWVsLAo+IAo+IFlvdSB3ZW50IGludG8gbW9y
ZSBkZXRhaWwgaW4geW91ciBwYXRjaHNldCBjb3ZlciBsZXR0ZXIsIGUuZy4gZXhhbXBsZQo+IGF1
ZGl0IHJlY29yZHMsIHdoaWNoIEkgdGhpbmsgd291bGQgYmUgaGVscGZ1bCBoZXJlIGluIHRoZSBj
b21taXQKPiBkZXNjcmlwdGlvbiBzbyB3ZSBoYXZlIGl0IGFzIHBhcnQgb2YgdGhlIGdpdCBsb2cu
ICBJIGRvbid0IHdhbnQgdG8KPiBkaXNjb3VyYWdlIHlvdSBmcm9tIHdyaXRpbmcgY292ZXIgbGV0
dGVycywgYnV0IGRvbid0IGZvcmdldCB0aGF0IHRoZQo+IGNvdmVyIGxldHRlcnMgY2FuIGJlIGxv
c3QgdG8gdGhlIGV0aGVyIGFmdGVyIGEgY291cGxlIG9mIHllYXJzIHdoZXJlYXMKPiB0aGUgZ2l0
IGxvZyBoYXMgYSBtdWNoIGxvbmdlciBsaWZldGltZSAod2UgaG9wZSEpIGFuZCBhIHRpZ2h0ZXIK
PiBiaW5kaW5nIHRvIHRoZSByZWxhdGVkIGNvZGUuCgpIaSBQYXVsLAoKYXQgZmlyc3QgdGhhbmsg
eW91IGZvciB5b3VyIGNvbW1lbnRzLgpJIHNlZSB5b3VyIHBvaW50IGFuZCBJIHdpbGwgcmVzcGVj
dCB0aGF0IGluIHByb3ZpZGluZyB0aGUgbmV4dCB2ZXJzaW9uIG9mCnRoaXMgcGF0Y2gtc2V0LgoK
PiAKPiA+IC0tLQo+ID4gIGRyaXZlcnMvbWQvS2NvbmZpZyAgICAgICAgIHwgMTAgKysrKysrKwo+
ID4gIGRyaXZlcnMvbWQvTWFrZWZpbGUgICAgICAgIHwgIDQgKysrCj4gPiAgZHJpdmVycy9tZC9k
bS1hdWRpdC5jICAgICAgfCA1OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kwo+ID4gIGRyaXZlcnMvbWQvZG0tYXVkaXQuaCAgICAgIHwgMzMgKysrKysrKysrKysrKysrKysr
KysrCj4gPiAgaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmggfCAgMSArCj4gPiAgNSBmaWxlcyBj
aGFuZ2VkLCAxMDcgaW5zZXJ0aW9ucygrKQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L21kL2RtLWF1ZGl0LmMKPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRp
dC5oCj4gPiAKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL0tjb25maWcgYi9kcml2ZXJzL21k
L0tjb25maWcKPiA+IGluZGV4IDA2MDJlODJhOTUxNi4uNDhhZGJlYzEyMTQ4IDEwMDY0NAo+ID4g
LS0tIGEvZHJpdmVycy9tZC9LY29uZmlnCj4gPiArKysgYi9kcml2ZXJzL21kL0tjb25maWcKPiA+
IEBAIC02MDgsNiArNjA4LDcgQEAgY29uZmlnIERNX0lOVEVHUklUWQo+ID4gICAgICAgICBzZWxl
Y3QgQ1JZUFRPCj4gPiAgICAgICAgIHNlbGVjdCBDUllQVE9fU0tDSVBIRVIKPiA+ICAgICAgICAg
c2VsZWN0IEFTWU5DX1hPUgo+ID4gKyAgICAgICBzZWxlY3QgRE1fQVVESVQgaWYgQVVESVQKPiA+
ICAgICAgICAgaGVscAo+ID4gICAgICAgICAgIFRoaXMgZGV2aWNlLW1hcHBlciB0YXJnZXQgZW11
bGF0ZXMgYSBibG9jayBkZXZpY2UgdGhhdCBoYXMKPiA+ICAgICAgICAgICBhZGRpdGlvbmFsIHBl
ci1zZWN0b3IgdGFncyB0aGF0IGNhbiBiZSB1c2VkIGZvciBzdG9yaW5nCj4gPiBAQCAtNjQwLDQg
KzY0MSwxMyBAQCBjb25maWcgRE1fWk9ORUQKPiA+IAo+ID4gICAgICAgICAgIElmIHVuc3VyZSwg
c2F5IE4uCj4gPiAKPiA+ICtjb25maWcgRE1fQVVESVQKPiA+ICsgICAgICAgYm9vbCAiRE0gYXVk
aXQgZXZlbnRzIgo+ID4gKyAgICAgICBkZXBlbmRzIG9uIEFVRElUCj4gPiArICAgICAgIGhlbHAK
PiA+ICsgICAgICAgICBHZW5lcmF0ZSBhdWRpdCBldmVudHMgZm9yIGRldmljZS1tYXBwZXIuCj4g
PiArCj4gPiArICAgICAgICAgRW5hYmxlcyBhdWRpdCBsb2dnaW5nIG9mIHNldmVyYWwgc2VjdXJp
dHkgcmVsZXZhbnQgZXZlbnRzIGluIHRoZQo+ID4gKyAgICAgICAgIHBhcnRpY3VsYXIgZGV2aWNl
LW1hcHBlciB0YXJnZXRzLCBlc3BlY2lhbGx5IHRoZSBpbnRlZ3JpdHkgdGFyZ2V0Lgo+ID4gKwo+
ID4gIGVuZGlmICMgTUQKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL01ha2VmaWxlIGIvZHJp
dmVycy9tZC9NYWtlZmlsZQo+ID4gaW5kZXggYTc0YWFmOGIxNDQ1Li40Y2Q0NzYyM2M3NDIgMTAw
NjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL21kL01ha2VmaWxlCj4gPiArKysgYi9kcml2ZXJzL21kL01h
a2VmaWxlCj4gPiBAQCAtMTAzLDMgKzEwMyw3IEBAIGVuZGlmCj4gPiAgaWZlcSAoJChDT05GSUdf
RE1fVkVSSVRZX1ZFUklGWV9ST09USEFTSF9TSUcpLHkpCj4gPiAgZG0tdmVyaXR5LW9ianMgICAg
ICAgICAgICAgICAgICs9IGRtLXZlcml0eS12ZXJpZnktc2lnLm8KPiA+ICBlbmRpZgo+ID4gKwo+
ID4gK2lmZXEgKCQoQ09ORklHX0RNX0FVRElUKSx5KQo+ID4gK2RtLW1vZC1vYmpzICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICs9IGRtLWF1ZGl0Lm8KPiA+ICtlbmRpZgo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWQvZG0tYXVkaXQuYyBiL2RyaXZlcnMvbWQvZG0tYXVkaXQuYwo+ID4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQKPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uYzdlNTgyNDgyMWJiCj4g
PiAtLS0gL2Rldi9udWxsCj4gPiArKysgYi9kcml2ZXJzL21kL2RtLWF1ZGl0LmMKPiA+IEBAIC0w
LDAgKzEsNTkgQEAKPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAo+ID4g
Ky8qCj4gPiArICogQ3JlYXRpbmcgYXVkaXQgcmVjb3JkcyBmb3IgbWFwcGVkIGRldmljZXMuCj4g
PiArICoKPiA+ICsgKiBDb3B5cmlnaHQgKEMpIDIwMjEgRnJhdW5ob2ZlciBBSVNFQy4gQWxsIHJp
Z2h0cyByZXNlcnZlZC4KPiA+ICsgKgo+ID4gKyAqIEF1dGhvcnM6IE1pY2hhZWwgV2Vpw58gPG1p
Y2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4KPiA+ICsgKi8KPiA+ICsKPiA+ICsjaW5j
bHVkZSA8bGludXgvYXVkaXQuaD4KPiA+ICsjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Cj4gPiAr
I2luY2x1ZGUgPGxpbnV4L2RldmljZS1tYXBwZXIuaD4KPiA+ICsjaW5jbHVkZSA8bGludXgvYmlv
Lmg+Cj4gPiArI2luY2x1ZGUgPGxpbnV4L2Jsa2Rldi5oPgo+ID4gKwo+ID4gKyNpbmNsdWRlICJk
bS1hdWRpdC5oIgo+ID4gKyNpbmNsdWRlICJkbS1jb3JlLmgiCj4gPiArCj4gPiArdm9pZCBkbV9h
dWRpdF9sb2dfYmlvKGNvbnN0IGNoYXIgKmRtX21zZ19wcmVmaXgsIGNvbnN0IGNoYXIgKm9wLAo+
ID4gKyAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBiaW8gKmJpbywgc2VjdG9yX3Qgc2VjdG9y
LCBpbnQgcmVzdWx0KQo+ID4gK3sKPiA+ICsgICAgICAgc3RydWN0IGF1ZGl0X2J1ZmZlciAqYWI7
Cj4gPiArCj4gPiArICAgICAgIGlmIChhdWRpdF9lbmFibGVkID09IEFVRElUX09GRikKPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm47Cj4gPiArCj4gPiArICAgICAgIGFiID0gYXVkaXRfbG9nX3N0
YXJ0KGF1ZGl0X2NvbnRleHQoKSwgR0ZQX0tFUk5FTCwgQVVESVRfRE0pOwo+ID4gKyAgICAgICBp
ZiAodW5saWtlbHkoIWFiKSkKPiA+ICsgICAgICAgICAgICAgICByZXR1cm47Cj4gPiArCj4gPiAr
ICAgICAgIGF1ZGl0X2xvZ19mb3JtYXQoYWIsICJtb2R1bGU9JXMgZGV2PSVkOiVkIG9wPSVzIHNl
Y3Rvcj0lbGx1IHJlcz0lZCIsCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgZG1fbXNnX3By
ZWZpeCwgTUFKT1IoYmlvLT5iaV9iZGV2LT5iZF9kZXYpLAo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgIE1JTk9SKGJpby0+YmlfYmRldi0+YmRfZGV2KSwgb3AsIHNlY3RvciwgcmVzdWx0KTsK
PiA+ICsgICAgICAgYXVkaXRfbG9nX2VuZChhYik7Cj4gPiArfQo+ID4gK0VYUE9SVF9TWU1CT0xf
R1BMKGRtX2F1ZGl0X2xvZ19iaW8pOwo+ID4gKwo+ID4gK3ZvaWQgZG1fYXVkaXRfbG9nX3Rhcmdl
dChjb25zdCBjaGFyICpkbV9tc2dfcHJlZml4LCBjb25zdCBjaGFyICpvcCwKPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICBzdHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgaW50IHJlc3VsdCkKPiA+ICt7
Cj4gPiArICAgICAgIHN0cnVjdCBhdWRpdF9idWZmZXIgKmFiOwo+ID4gKyAgICAgICBzdHJ1Y3Qg
bWFwcGVkX2RldmljZSAqbWQgPSBkbV90YWJsZV9nZXRfbWQodGktPnRhYmxlKTsKPiA+ICsKPiA+
ICsgICAgICAgaWYgKGF1ZGl0X2VuYWJsZWQgPT0gQVVESVRfT0ZGKQo+ID4gKyAgICAgICAgICAg
ICAgIHJldHVybjsKPiA+ICsKPiA+ICsgICAgICAgYWIgPSBhdWRpdF9sb2dfc3RhcnQoYXVkaXRf
Y29udGV4dCgpLCBHRlBfS0VSTkVMLCBBVURJVF9ETSk7Cj4gPiArICAgICAgIGlmICh1bmxpa2Vs
eSghYWIpKQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybjsKPiA+ICsKPiA+ICsgICAgICAgYXVk
aXRfbG9nX2Zvcm1hdChhYiwgIm1vZHVsZT0lcyBkZXY9JXMgb3A9JXMiLAo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgIGRtX21zZ19wcmVmaXgsIGRtX2RldmljZV9uYW1lKG1kKSwgb3ApOwo+
ID4gKwo+ID4gKyAgICAgICBpZiAoIXJlc3VsdCAmJiAhc3RyY21wKCJjdHIiLCBvcCkpCj4gPiAr
ICAgICAgICAgICAgICAgYXVkaXRfbG9nX2Zvcm1hdChhYiwgIiBlcnJvcl9tc2c9JyVzJyIsIHRp
LT5lcnJvcik7Cj4gPiArICAgICAgIGF1ZGl0X2xvZ19mb3JtYXQoYWIsICIgcmVzPSVkIiwgcmVz
dWx0KTsKPiA+ICsgICAgICAgYXVkaXRfbG9nX2VuZChhYik7Cj4gPiArfQo+IAo+IEdlbmVyYWxs
eSBzcGVha2luZyB3ZSB0cnkgdG8ga2VlcCBhIGNvbnNpc3RlbnQgZm9ybWF0IGFuZCBvcmRlcmlu
Zwo+IHdpdGhpbiBhIGdpdmVuIGF1ZGl0IHJlY29yZCB0eXBlLiAgSG93ZXZlciB5b3UgYXBwZWFy
IHRvIGhhdmUgYXQgbGVhc3QKPiB0aHJlZSBkaWZmZXJlbnQgZm9ybWF0cyBmb3IgdGhlIEFVRElU
X0RNIHJlY29yZCBpbiB0aGlzIHBhdGNoOgo+IAo+ICAgIi4uLiBtb2R1bGU9JXMgZGV2PSVkOiVk
IG9wPSVzIHNlY3Rvcj0lbGx1IHJlcz0lZCIKPiAgICIuLi4gbW9kdWxlPSVzIGRldj0lcyBvcD0l
cyBlcnJvcl9tc2c9JyVzJyByZXM9JWQiCj4gICAiLi4uIG1vZHVsZT0lcyBkZXY9JXMgb3A9JXMg
cmVzPSVkIgo+IAo+IFRoZSBmaXJzdCB0aGluZyB0aGF0IGp1bXBzIG91dCBpcyB0aGF0IHNvbWUg
ZmllbGRzLCBlLmcuICJzZWN0b3IiLCBhcmUKPiBub3QgYWx3YXlzIHByZXNlbnQgaW4gdGhlIHJl
Y29yZDsgd2UgdHlwaWNhbGx5IGhhbmRsZSB0aGlzIGJ5IHVzaW5nIGEKPiAiPyIgZm9yIHRoZSBm
aWVsZCB2YWx1ZSBpbiB0aG9zZSBjYXNlcyB3aGVyZSB5b3Ugd291bGQgb3RoZXJ3aXNlIGRyb3AK
PiB0aGUgZmllbGQgZnJvbSB0aGUgcmVjb3JkLCBmb3IgZXhhbXBsZSB0aGUgZm9sbG93aW5nIHJl
Y29yZDoKPiAKPiAgICIuLi4gbW9kdWxlPSVzIGRldj0lcyBvcD0lcyByZXM9JWQiCj4gCj4gLi4u
IHdvdWxkIGJlIHJld3JpdHRlbiBsaWtlIHRoaXM6Cj4gCj4gICAiLi4uIG1vZHVsZT0lcyBkZXY9
JXMgb3A9JXMgc2VjdG9yPT8gcmVzPSVkIgoKV2VsbCwgSSBkaWRuJ3Qga25vdyB0aGF0LgpGb3Ig
dGFyZ2V0IGNyZWF0aW9uIGFuZCBkZXN0cnVjdGlvbiBhIHNlY3RvciBpcyBub3QgcmVsZXZhbnQu
ClNvIHdvdWxkIGl0IGFsc28gYmUgYW4gb3B0aW9uIGZvciB5b3UgaWYgd2UganVzdCBkZWZpbmUg
dHdvIGRpZmZlcmVudAp0eXBlIG9mIG1lc3NhZ2VzIGxpa2UgdGhpcyBpbiBhdWRpdC5oPwoKI2Rl
ZmluZSBBVURJVF9ETV9DVFJMICAgICAgICAgICAxMzM2ICAgIC8qIERldmljZSBNYXBwZXIgdGFy
Z2V0IGNvbnRyb2wgKi8KI2RlZmluZSBBVURJVF9ETV9FVkVOVAkJMTMzNwkvKiBEZXZpY2UgTWFw
cGVyIGV2ZW50cyAqLwoKPiAKPiBUaGUgc2Vjb25kIHRoaW5nIHRoYXQgSSBub3RpY2VkIGlzIHRo
YXQgdGhlICJkZXYiIGZpZWxkIGNoYW5nZXMgZnJvbSBhCj4gIm1ham9yOm1pbm9yIiBudW1iZXIg
cmVwcmVzZW50YXRpb24gdG8gYW4gYXJiaXRyYXJ5IHN0cmluZyB2YWx1ZSwgZS5nLgo+ICJkZXY9
JXMiLiAgVGhpcyBnZW5lcmFsbHkgaXNuJ3Qgc29tZXRoaW5nIHdlIGRvIHdpdGggYXVkaXQgcmVj
b3JkcywKPiBwbGVhc2Ugc3RpY2sgdG8gYSBzaW5nbGUgcmVwcmVzZW50YXRpb24gZm9yIGEgZ2l2
ZW4gYXVkaXQKPiByZWNvcmQtdHlwZS9maWVsZCBjb21iaW5hdGlvbi4KCmRtX2RldmljZV9uYW1l
KG1kKSBhbHJlYWR5IGRvZXMgcHJvdmlkZSBhIG1ham9yOm1pbm9yIGluIHN0cmluZwpyZXByZXNl
bnRhdGlvbiwgdGhhdCBpcyB3aHkgSSB1c2VkIGl0CmRpcmVjdGx5IHdpdGggZGV2PSVzCmFuZCBp
biB0aGUgYmlvIGNhc2UgYnVpbGQgaXQgdXAgbWFudWFsbHkgb3V0IG9mIG1ham9yIGFuZCBtaW5v
cgpvZiB0aGUgYmRldi4KCkkgc2VlIHR3byBvcHRpb25zIGhlcmUgdG8gYmUgbW9yZSBjbGVhciBv
biB0aGlzIGluIHRoZSBjb2RlLgpGaXJzdCwganVzdCBwcm92aWRlIGEKY29tbWVudCBvciBzZWNv
bmQgdXNlIHRoZSBtYWpvciBtaW5vciBkaXJlY3RseSBmcm9tCmRtX2Rpc2sobWQpLT5tYWpvciwg
ZG1fZGlzayhtZCktPmZpcnN0X21pbm9yLgoKSSdtIG5vdCBzdXJlIHdoYXQncyBiZXR0ZXIgaGVy
ZS4KCgpUaGFua3MsCk1pY2hhZWwKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEBy
ZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWw=

