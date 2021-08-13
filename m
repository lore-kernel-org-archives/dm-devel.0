Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8654CC432BE
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B66560F5E
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B66560F5E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-F0vdSdP7M1iS228xOLOVcw-1; Tue, 17 Aug 2021 03:26:11 -0400
X-MC-Unique: F0vdSdP7M1iS228xOLOVcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF336802C80;
	Tue, 17 Aug 2021 07:26:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B203E60C81;
	Tue, 17 Aug 2021 07:26:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5B9A5181A12D;
	Tue, 17 Aug 2021 07:26:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17D70XpB016315 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 03:00:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2BDDD120ED1; Fri, 13 Aug 2021 07:00:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25BB8121607
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 07:00:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86C60866DF4
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 07:00:29 +0000 (UTC)
Received: from mail-edgeKA27.fraunhofer.de (mail-edgeka27.fraunhofer.de
	[153.96.1.27]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-209-mcu0UGk0PYOrTYknnC9xVw-1; Fri, 13 Aug 2021 03:00:24 -0400
X-MC-Unique: mcu0UGk0PYOrTYknnC9xVw-1
IronPort-SDR: Kb3VF3Wib90ppgYymzc5aAvwKVk6pyUXQqLNWA1aqVKWxCfUZRCEdalwI/Oq+5Q88Dvs03PCu1
	zMOPXJJZO/pab7frmrw0NUGUMlXCwPZR92KAAujmnBcGEosIm4yFUEMkftWAWIdIhWVSakW6ov
	T4vZaoaU2BDYf7lhEpyzxw1SpXV3TlqI85rkwCf16+2RUed4ef9TKlb3dfN7uov63Bm3waZ1Wv
	KH8uj8AXY+8zymBvloCmjupNBcmk1syCImPpe4mfkte4g1F+LOTKpwigmqtBnmiz/q51TKMgFW
	ldE=
IronPort-PHdr: =?us-ascii?q?A9a23=3AuLLPqh2cEBDH9vZasmDPX1BlVkEcU/3cJQUV4?=
	=?us-ascii?q?4cpj79UN6+quZ/lOR+X6fZsiQrPWoPWo7JBhvHNuq/tEWoH/d6asX8EfZANM?=
	=?us-ascii?q?n1NicgfkwE6RsLQD0r9Ia3xZCwzAcpGWUUg9Hj9Ok9QS47yYlTIqSi06jgfU?=
	=?us-ascii?q?hz0KQtyILHzHYjf6qb/1+2795DJJQtSgz/oaLJpIR7wox/Yq88WhoVvMOA9x?=
	=?us-ascii?q?0ihnw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EzBABfFxZh/xoBYJlaHgEBCxIMQIF?=
	=?us-ascii?q?OC4FTKSiBV2mESINIA4U5iGkDgRCIHpELgS4UgREDVAsBAQEBAQEBAQEHAQE?=
	=?us-ascii?q?/AgQBAQMDhFMCF4JTASU0CQ4BAgQBAQESAQEGAQEBAQEGBAICgSCFaAEMg1O?=
	=?us-ascii?q?BCAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCgQg9AQE?=
	=?us-ascii?q?BAQIBEhEEDQwBATcBDwIBCBgCAiYCAgIwFRACBA4FIoIES4JWAw4gAp1MAYE?=
	=?us-ascii?q?6Aoofen8ygQGCBwEBBgQEhSsYgRaBHgkJAYEGKoJ9hA+FRYEfJ4IpgRU2gQW?=
	=?us-ascii?q?BMzc+hAc9F4MAgmSDHVMgB3QTAYEBgRc/BhYelEpGph2CEgeCAFBbnlErg2W?=
	=?us-ascii?q?RcjWQaYVNgSyPGKUcAgQCBAUCDgEBBoFgghVNJIM4UBkOjiAMFoNQil5DMAI?=
	=?us-ascii?q?2AgYBCgEBAwlbiF0BAQ?=
X-IPAS-Result: =?us-ascii?q?A2EzBABfFxZh/xoBYJlaHgEBCxIMQIFOC4FTKSiBV2mES?=
	=?us-ascii?q?INIA4U5iGkDgRCIHpELgS4UgREDVAsBAQEBAQEBAQEHAQE/AgQBAQMDhFMCF?=
	=?us-ascii?q?4JTASU0CQ4BAgQBAQESAQEGAQEBAQEGBAICgSCFaAEMg1OBCAEBAQEBAQEBA?=
	=?us-ascii?q?QEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCgQg9AQEBAQIBEhEEDQwBA?=
	=?us-ascii?q?TcBDwIBCBgCAiYCAgIwFRACBA4FIoIES4JWAw4gAp1MAYE6Aoofen8ygQGCB?=
	=?us-ascii?q?wEBBgQEhSsYgRaBHgkJAYEGKoJ9hA+FRYEfJ4IpgRU2gQWBMzc+hAc9F4MAg?=
	=?us-ascii?q?mSDHVMgB3QTAYEBgRc/BhYelEpGph2CEgeCAFBbnlErg2WRcjWQaYVNgSyPG?=
	=?us-ascii?q?KUcAgQCBAUCDgEBBoFgghVNJIM4UBkOjiAMFoNQil5DMAI2AgYBCgEBAwlbi?=
	=?us-ascii?q?F0BAQ?=
X-IronPort-AV: E=Sophos;i="5.84,318,1620684000"; d="scan'208";a="34979012"
Received: from mail-mtaka26.fraunhofer.de ([153.96.1.26])
	by mail-edgeKA27.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 08:59:19 +0200
IronPort-SDR: UgUSLXpF+6WuanmMeb4QNcrneG/rZgUG8bMUHXcjvUIPuetr1vb6uT8cqveKodNJm9dikD5cjE
	yv8NImWRuAsjxpHz91LTiQA7ctC8BxHaU=
IronPort-PHdr: =?us-ascii?q?A9a23=3AYGX0CRJ/OM1l0PGI2dmcuZEyDhhOgF28FhUe6?=
	=?us-ascii?q?pM6hbZDaOGo9tLpO0mMrflujVqcW4Ld5roEjufNqKnvVCQG5orJq3ENdpFAF?=
	=?us-ascii?q?npnwcUblgAtGoiJXEv8KvO5dCc6FdlMUFJ/unqyd0NSHZW2a1jbuHbn6zkUF?=
	=?us-ascii?q?132PhZ0IeKgHInUgqHVn+C/8pHeeUNGnj24NLpzNxi96wvLv9QQgYxsJ7x3x?=
	=?us-ascii?q?haaykY=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A2kExaK7HL5GaelHVpwPXwZKCI+orL9Y04l?=
	=?us-ascii?q?Q7vn2ZFiY7TiXIrayTdaoguCMc0AxhJU3Jmbi7Scy9qeu1z+813WBjB8bfYO?=
	=?us-ascii?q?CAghrpEGgC1/qt/9SEIUPDH4FmpN5dmsRFeb7N5B1B/LzHCWqDYpUdKbu8gd?=
	=?us-ascii?q?iVbI7lph8HJ2ALV0gj1XYDNu/yKDwqeOAsP+tcKHPo3Lsgm9PWQwVxUi3UPA?=
	=?us-ascii?q?hmY8Hz4/nw0L72ax8PABAqrCOUiymz1bL8Gx+Emj8DTjJm294ZgCr4uj28wp?=
	=?us-ascii?q?/mn+Cwyxfa2WOWxY9RgsHdxtxKA9HJotQJKw/rlh2jaO1aKvi/VXEO0aWSAW?=
	=?us-ascii?q?QR4Z/xSiQbTp1OArTqDzmISC7Wqk7dOfAVmiTfIBGj8CHeSIfCNU0H4oJ69P?=
	=?us-ascii?q?xkm13imhYdVZhHodJ2NyjyjesnMTrQ2Cv6/NTGTBdsiw69pmcji/caizhFXZ?=
	=?us-ascii?q?IZc6I5l/1UwKp5KuZJIMvB0vFtLACuNrCp2N9GNVeBK3zJtGhmx9KhGnw1Ax?=
	=?us-ascii?q?edW0AH/siYySJfknx1x1YRgJV3pAZNyLstD51fo+jUOKVhk79DCscQcKJmHe?=
	=?us-ascii?q?8EBc+6EHbETx7AOH+bZV7nCKYEMXTQrIOf2sR52Mi6PJgTiJcikpXIV11V8W?=
	=?us-ascii?q?Y0ZkL1EMWLmIZG9xjcKV/NFAgFCvsukaSRn4eMC4YDHRfzOmzGovHQ1Mn3WP?=
	=?us-ascii?q?erKMpbEKgmdsPeEQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BEDQBfFxZh/z6wYZlaHgEBCxIMQAm?=
	=?us-ascii?q?BRQuBUykoB0yBAwEmQ4RHg0gDhTmGRoIjAzgBV5kpgS4UgREDVAsBAwEBAQE?=
	=?us-ascii?q?BBwEBBDoBAgQBAYRZAheCUAImNAkOAQIEAQEBEgEBBQEBAQIBBgSBEROFaAE?=
	=?us-ascii?q?MhkIBAQEBAgESEQQNDAEBFCMBDwIBCBgCAiYCAgIwBw4QAgQOBSKCBEuCVgM?=
	=?us-ascii?q?OIAKdTAGBOgKKH3p/MoEBggcBAQYEBIUrGIEWgR4JCQGBBiqCfYQPhUWBH4J?=
	=?us-ascii?q?QgRU2gQWBMzc+hAc9F4MAgmSDHVMgB3QTAYEBgRc/BhYelEpGph2CEgeCAFB?=
	=?us-ascii?q?bnlErg2WRcjWQaYVNgSyPGKUcAgQCBAUCDgEBBoFgO4FZTSSDOFAZDo4gDBa?=
	=?us-ascii?q?DUIpeQgEwAjYCBgEKAQEDCVkBAYhdAQE?=
X-IronPort-AV: E=Sophos;i="5.84,318,1620684000"; d="scan'208";a="121189815"
Received: from 153-97-176-62.vm.c.fraunhofer.de (HELO
	mobile.exch.fraunhofer.de) ([153.97.176.62])
	by mail-mtaKA26.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 08:59:16 +0200
Received: from XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) by
	XCH-HYBRID-02.ads.fraunhofer.de (10.225.8.59) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.858.12; Fri, 13 Aug 2021 08:59:15 +0200
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (10.225.8.37) by
	XCH-HYBRID-01.ads.fraunhofer.de (10.225.8.57) with Microsoft SMTP
	Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12
	via Frontend Transport; Fri, 13 Aug 2021 08:59:15 +0200
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3c2::22)
	by AM7P194MB0930.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:176::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16;
	Fri, 13 Aug 2021 06:59:15 +0000
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::4003:49ec:516:cc88]) by AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::4003:49ec:516:cc88%9]) with mapi id 15.20.4415.019;
	Fri, 13 Aug 2021 06:59:15 +0000
From: =?utf-8?B?V2Vpw58sIE1pY2hhZWw=?= <michael.weiss@aisec.fraunhofer.de>
To: "casey@schaufler-ca.com" <casey@schaufler-ca.com>
Thread-Topic: [PATCH 1/3] dm: introduce audit event module for device mapper
Thread-Index: AQHXj4p+RhDRkAKAeUGAaCUz8AYYXatwGmOAgADn+wA=
Date: Fri, 13 Aug 2021 06:59:15 +0000
Message-ID: <e82a0835059181fedbc5b143329b0594151f8221.camel@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
	<20210812145748.4460-2-michael.weiss@aisec.fraunhofer.de>
	<7f28b3b4-c0a2-cb03-09fd-e0705959576a@schaufler-ca.com>
In-Reply-To: <7f28b3b4-c0a2-cb03-09fd-e0705959576a@schaufler-ca.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 190d2b42-10a3-4873-b965-08d95e27dcdf
x-ms-traffictypediagnostic: AM7P194MB0930:
x-microsoft-antispam-prvs: <AM7P194MB0930C2963524B5993BD5D6E1ACFA9@AM7P194MB0930.EURP194.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:449
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PPUULmddyrdSUq6SdZYIUh1UU5TAPd34u5gSu97C5cyC2mTr+SVvlijHeHHtdXBd3H8WeAVCTICn3CCz+Ry+TeQmH+dqMPl4swuKYwZRTfAls2qiNu5pmYDyKW+42UwH0DWItLzG1QKrmJoUCz4PhekRBFrLqZngso4GdcZ4keNhB5sFJXvI62GYIjv1A1oxFai9nY84aK5wnaLsKZFIADmzET9H02rRIugrQq8uAVPLB3/ijaLbYDXJHh7OUUorrhf3Yf51Zgx4E1Ll/bCKhlj8ZDXpalGw7O3Lt3MXVv99eux+SKOcXL/oVyuPgzELK2dU1NSa883j/5y2YIoTT5kBrHXEuWmEv/iWfTlQt4/xpHMT0X7LGZgkE3MFfEFGWnzs8h2yRPTgiHO99sy7NldQTlTgnI2Bub6YsFYjLg4bVLxlhiDyEmsYmK622DxbsvwHhk2PNaiUJU+D+KtMoHCIwD8saHOs/CdXBOCvXIMVCLaxuZ73oD//5b5HSsVX3K4QGoKfHYeAUbLBvcUNdvtmjU1dPnZHuC5gPoqUDRP2v/R27GHaGptciGwMdVYpUOkGb+EQGR10OlTJpzNjn/2gJ9JZdYUQnEcxw4QbaANVFqSQolylcpmXCcAlqKEh240yMtSpeisnaGU5ibg+Iq6N3vyQB0gDzhiq7ipsOTQpIVOxGGJWNk6BBC+TxlcXs8FY2jckT1w3P2vYZ+t9gg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AS8P194MB1288.EURP194.PROD.OUTLOOK.COM;
	PTR:; CAT:NONE;
	SFS:(4636009)(39850400004)(396003)(136003)(346002)(366004)(376002)(6916009)(5660300002)(478600001)(6506007)(53546011)(83380400001)(38070700005)(85182001)(71200400001)(76116006)(316002)(91956017)(8676002)(6486002)(8936002)(6512007)(26005)(186003)(64756008)(66556008)(66446008)(66476007)(66946007)(38100700002)(122000001)(4326008)(54906003)(86362001)(2616005)(2906002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TS95SStPdHFmVmdFUThxa2hrbVZtK2pvMEhqUmNRQWh6RVNTUExZdHM0amRj?=
	=?utf-8?B?UnN1ckxPTkJ1NWdURWRzUXhnMHN1TktOSmpaVlYvS3FJWEpsYVgxaWh5a2lG?=
	=?utf-8?B?TUdRNVVKTm5pbE8yRm9hZ3lrOEFodkxzSUdtNEpaTnl5U2dHNGQyelFRa3Vo?=
	=?utf-8?B?MUlzVGVKV1QzRkt6TkhjSnNPV053dWJId0xpT2xuU0NkY3BRYUc1Ui90c2J1?=
	=?utf-8?B?VGQybHZEZjcwcG92eW02cW5qRVhXeEJFdzZ5RVZ6VlB4SmRVV2VZYjZIck5F?=
	=?utf-8?B?cDMydnBUdnVVRllDMlZsL1I1bDlxbUlWZVRPUzBnSHZnaEJLWldiMktoNjJE?=
	=?utf-8?B?dWN1VEFTTWF0cDNKNXNHbklJSCtrWEVlalFKTFlKeFRJeXBpOW9EcHdEcnVm?=
	=?utf-8?B?MDdHeml1c1l4dzU5eWZCaU4rTkFOVjZpVG9ZUm9IUHY3SjNmWFNOZmhmVGo1?=
	=?utf-8?B?YmNIUk5KR2kwVDk1U05EcjF3U1Z3dnZ4NHlqQ211WTRyR2ZzSFNCRUd1TWhB?=
	=?utf-8?B?VmI5T1cxeEFVaEM0cWNmOG9TR2RTQWthUm1YYjhKRjZVdEtrTndITldPN1Fv?=
	=?utf-8?B?YjFsbUwza0NETEFySnkwVnB3NlVodmhGZFVBSFlSdlU1SjByWmdrMUdadDZF?=
	=?utf-8?B?SitmRk04amRCS3I2MzArcHZiVVZrdWVqbHRnRjhzOEY1aHA3dDhqVW9WKzVp?=
	=?utf-8?B?Z0tRbHVLMnFvL1QxYzZQb091dDVuV2IrTXJsa0k2cHd6VWx6YUVtQ1JkdkJY?=
	=?utf-8?B?Tk13UVRNMnV4aWNRNjhrYTl5TER3NDRwdjIreWlsU0g1QjZGRG80RkMxTkN0?=
	=?utf-8?B?aWVyRVVqSk5QM3hoUzN3WTFnaXdha3hieHM3RVpQOEZWamV2Q2cwYVV3aGRH?=
	=?utf-8?B?M25jS21tZTVkTnQ2VWR1WXBRbjdNODQwbWhpV244UitYOXRoTFZvWkh5TUc5?=
	=?utf-8?B?RFNFODNxK1R3SUdCNEhFNzFnRGFrcitBTUpTTFhwVDg2OC8yYVVpWlFVUVRD?=
	=?utf-8?B?Tng2SjRvNlJBV2NuN1kwYkFKYTExeHhYc090M2I4SDBZVTc5WTZCTHExd3J2?=
	=?utf-8?B?OThaU3RDWkhSNm5sL3JwUHdDQW54emx1TVhadlVoYWp0MUpjS3l2aGFWb2tx?=
	=?utf-8?B?UnZtWFIwRUZRV2V3a2F3bDNJRWMydlF4cjNZa1doQVVkaUhDUEhQNlZNdXh0?=
	=?utf-8?B?SktSemkrSFVnaFY1OTFlU2V6ak5hT2FrMWtXbWM5M0V3eXV5RmxCVW5uSnRz?=
	=?utf-8?B?MnBQUmRCME1XQkhqY25HMmJmdyszQkNQdVFCNmRDcXFBK3QxVERSY3h0dHMx?=
	=?utf-8?B?MlN6OThnNWZxV0VOWWpWdkdiYUN3ZkFrRG0rbVYvUG50VWtacFhGdlV5bVlt?=
	=?utf-8?B?RFh0V0ZwU1BNRDluemxUTXR6dnJEMkRZOWUyaUNKTVV4b3FjNzJyRm1tNWQ1?=
	=?utf-8?B?UWEyUHlDWHRaVlhwRFk5bFJoZEVKcWRIdElPQkQ4MzQ3bFJURDJSNkxTR3Fa?=
	=?utf-8?B?QXZRM1Q4NFp2elg1SURTOWZSOG1PTitDcTRqdGp5QzJpd0pNKzZNeEdnQjJl?=
	=?utf-8?B?SDBEWTlKNUlDSlYrcTRxVTB1bmxtdE1hcW1UMkZVY2Jjc1lRZW1pdDRMWWhT?=
	=?utf-8?B?UU5BN01aR1RGVWx3MnZqdktaWDBEbldVczQrN25FRE9jdEJjS2RxbXY5NDM4?=
	=?utf-8?B?eXIyalp3OGdZS3V5RTFZYU1YU2NmYTlzVEZTODU1MkRLRlFPUzFtMmtkc09K?=
	=?utf-8?Q?Gey5xUlqZNfZ1p3WAoDn2oSjFLAzeoZrY+iq22Q?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 190d2b42-10a3-4873-b965-08d95e27dcdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 06:59:15.1144 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1RfFf+wP0WLtbBr4M0i175C1CSJJQq4dZfGmj/RvqcWMUDhR/wnzsmvNCDSdObrBUq3R3myImMdxS/WCsLcKj6EfeN+UfLjzO4k7CQtY9FISqHleeDLUMWemT5lB59Ak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P194MB0930
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17D70XpB016315
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/3] dm: introduce audit event module for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9E63A4029DB0014BA54829CDE8D347FB@EURP194.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgQ2FzZXksCgpPbiBUaHUsIDIwMjEtMDgtMTIgYXQgMTA6MDggLTA3MDAsIENhc2V5IFNjaGF1
ZmxlciB3cm90ZToKPiBPbiA4LzEyLzIwMjEgNzo1NyBBTSwgTWljaGFlbCBXZWnDnyB3cm90ZToK
PiA+IFRvIGJlIGFibGUgdG8gc2VuZCBhdWRpdGluZyBldmVudHMgdG8gdXNlciBzcGFjZSwgd2Ug
aW50cm9kdWNlCj4gPiBhIGdlbmVyaWMgZG0tYXVkaXQgbW9kdWxlLiBJdCBwcm92aWRlcyBoZWxw
ZXIgZnVuY3Rpb25zIHRvIGVtaXQKPiA+IGF1ZGl0IGV2ZW50cyB0aHJvdWdoIHRoZSBrZXJuZWwg
YXVkaXQgc3Vic3lzdGVtLiBXZSBjbGFpbSB0aGUKPiA+IEFVRElUX0RNIHR5cGU9MTMzNiBvdXQg
b2YgdGhlIGF1ZGl0IGV2ZW50IG1lc3NhZ2VzIHJhbmdlIGluIHRoZQo+ID4gY29ycmVzcG9uZGlu
ZyB1c2Vyc3BhY2UgYXBpIGluICdpbmNsdWRlL3VhcGkvbGludXgvYXVkaXQuaCcgZm9yCj4gPiB0
aG9zZSBldmVudHMuCj4gPiAKPiA+IEZvbGxvd2luZyBjb21taXRzIHRvIGRldmljZSBtYXBwZXIg
dGFyZ2V0cyBhY3R1YWxseSB3aWxsIG1ha2UKPiA+IHVzZSBvZiB0aGlzIHRvIGVtaXQgdGhvc2Ug
ZXZlbnRzIGluIHJlbGV2YW50IGNhc2VzLgo+ID4gCj4gPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWVs
IFdlacOfIDxtaWNoYWVsLndlaXNzQGFpc2VjLmZyYXVuaG9mZXIuZGU+Cj4gPiAtLS0KPiA+ICBk
cml2ZXJzL21kL0tjb25maWcgICAgICAgICB8IDEwICsrKysrKysKPiA+ICBkcml2ZXJzL21kL01h
a2VmaWxlICAgICAgICB8ICA0ICsrKwo+ID4gIGRyaXZlcnMvbWQvZG0tYXVkaXQuYyAgICAgIHwg
NTkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiA+ICBkcml2ZXJzL21k
L2RtLWF1ZGl0LmggICAgICB8IDMzICsrKysrKysrKysrKysrKysrKysrKwo+ID4gIGluY2x1ZGUv
dWFwaS9saW51eC9hdWRpdC5oIHwgIDIgKysKPiA+ICA1IGZpbGVzIGNoYW5nZWQsIDEwOCBpbnNl
cnRpb25zKCspCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWQvZG0tYXVkaXQuYwo+
ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21kL2RtLWF1ZGl0LmgKPiA+IAo+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbWQvS2NvbmZpZyBiL2RyaXZlcnMvbWQvS2NvbmZpZwo+ID4gaW5k
ZXggMDYwMmU4MmE5NTE2Li5mZDU0YzcxM2EwM2UgMTAwNjQ0Cj4gPiAtLS0gYS9kcml2ZXJzL21k
L0tjb25maWcKPiA+ICsrKyBiL2RyaXZlcnMvbWQvS2NvbmZpZwo+ID4gQEAgLTYwOCw2ICs2MDgs
NyBAQCBjb25maWcgRE1fSU5URUdSSVRZCj4gPiAgCXNlbGVjdCBDUllQVE8KPiA+ICAJc2VsZWN0
IENSWVBUT19TS0NJUEhFUgo+ID4gIAlzZWxlY3QgQVNZTkNfWE9SCj4gPiArCXNlbGVjdCBETV9B
VURJVCBpZiBBVURJVAo+ID4gIAloZWxwCj4gPiAgCSAgVGhpcyBkZXZpY2UtbWFwcGVyIHRhcmdl
dCBlbXVsYXRlcyBhIGJsb2NrIGRldmljZSB0aGF0IGhhcwo+ID4gIAkgIGFkZGl0aW9uYWwgcGVy
LXNlY3RvciB0YWdzIHRoYXQgY2FuIGJlIHVzZWQgZm9yIHN0b3JpbmcKPiA+IEBAIC02NDAsNCAr
NjQxLDEzIEBAIGNvbmZpZyBETV9aT05FRAo+ID4gIAo+ID4gIAkgIElmIHVuc3VyZSwgc2F5IE4u
Cj4gPiAgCj4gPiArY29uZmlnIERNX0FVRElUCj4gPiArCWJvb2wgIkRNIGF1ZGl0IGV2ZW50cyIK
PiA+ICsJZGVwZW5kcyBvbiBBVURJVAo+ID4gKwloZWxwCj4gPiArCSAgR2VuZXJhdGUgYXVkaXQg
ZXZlbnRzIGZvciBkZXZpY2UtbWFwcGVyLgo+ID4gKwo+ID4gKwkgIEVuYWJsZXMgYXVkaXQgbG9n
aW5nIG9mIHNldmVyYWwgc2VjdXJpdHkgcmVsZXZhbnQgZXZlbnRzIGluIHRoZQo+IAo+IHMvbG9n
aW5nL2xvZ2dpbmcvCj4gCj4gPiArCSAgcGFydGljdWxhciBkZXZpY2UtbWFwcGVyIHRhcmdldHMs
IGVzcGVjaWFsbHkgdGhlIGludGVncml0eSB0YXJnZXQuCj4gPiArCj4gPiAgZW5kaWYgIyBNRAo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvTWFrZWZpbGUgYi9kcml2ZXJzL21kL01ha2VmaWxl
Cj4gPiBpbmRleCBhNzRhYWY4YjE0NDUuLjRjZDQ3NjIzYzc0MiAxMDA2NDQKPiA+IC0tLSBhL2Ry
aXZlcnMvbWQvTWFrZWZpbGUKPiA+ICsrKyBiL2RyaXZlcnMvbWQvTWFrZWZpbGUKPiA+IEBAIC0x
MDMsMyArMTAzLDcgQEAgZW5kaWYKPiA+ICBpZmVxICgkKENPTkZJR19ETV9WRVJJVFlfVkVSSUZZ
X1JPT1RIQVNIX1NJRykseSkKPiA+ICBkbS12ZXJpdHktb2JqcwkJCSs9IGRtLXZlcml0eS12ZXJp
Znktc2lnLm8KPiA+ICBlbmRpZgo+ID4gKwo+ID4gK2lmZXEgKCQoQ09ORklHX0RNX0FVRElUKSx5
KQo+ID4gK2RtLW1vZC1vYmpzCQkJCSs9IGRtLWF1ZGl0Lm8KPiA+ICtlbmRpZgo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvZG0tYXVkaXQuYyBiL2RyaXZlcnMvbWQvZG0tYXVkaXQuYwo+ID4g
bmV3IGZpbGUgbW9kZSAxMDA2NDQKPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uYzdlNTgyNDgyMWJi
Cj4gPiAtLS0gL2Rldi9udWxsCj4gPiArKysgYi9kcml2ZXJzL21kL2RtLWF1ZGl0LmMKPiA+IEBA
IC0wLDAgKzEsNTkgQEAKPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAo+
ID4gKy8qCj4gPiArICogQ3JlYXRpbmcgYXVkaXQgcmVjb3JkcyBmb3IgbWFwcGVkIGRldmljZXMu
Cj4gPiArICoKPiA+ICsgKiBDb3B5cmlnaHQgKEMpIDIwMjEgRnJhdW5ob2ZlciBBSVNFQy4gQWxs
IHJpZ2h0cyByZXNlcnZlZC4KPiA+ICsgKgo+ID4gKyAqIEF1dGhvcnM6IE1pY2hhZWwgV2Vpw58g
PG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4KPiA+ICsgKi8KPiA+ICsKPiA+ICsj
aW5jbHVkZSA8bGludXgvYXVkaXQuaD4KPiA+ICsjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+Cj4g
PiArI2luY2x1ZGUgPGxpbnV4L2RldmljZS1tYXBwZXIuaD4KPiA+ICsjaW5jbHVkZSA8bGludXgv
YmlvLmg+Cj4gPiArI2luY2x1ZGUgPGxpbnV4L2Jsa2Rldi5oPgo+ID4gKwo+ID4gKyNpbmNsdWRl
ICJkbS1hdWRpdC5oIgo+ID4gKyNpbmNsdWRlICJkbS1jb3JlLmgiCj4gPiArCj4gPiArdm9pZCBk
bV9hdWRpdF9sb2dfYmlvKGNvbnN0IGNoYXIgKmRtX21zZ19wcmVmaXgsIGNvbnN0IGNoYXIgKm9w
LAo+ID4gKwkJICAgICAgc3RydWN0IGJpbyAqYmlvLCBzZWN0b3JfdCBzZWN0b3IsIGludCByZXN1
bHQpCj4gPiArewo+ID4gKwlzdHJ1Y3QgYXVkaXRfYnVmZmVyICphYjsKPiA+ICsKPiA+ICsJaWYg
KGF1ZGl0X2VuYWJsZWQgPT0gQVVESVRfT0ZGKQo+ID4gKwkJcmV0dXJuOwo+ID4gKwo+ID4gKwlh
YiA9IGF1ZGl0X2xvZ19zdGFydChhdWRpdF9jb250ZXh0KCksIEdGUF9LRVJORUwsIEFVRElUX0RN
KTsKPiA+ICsJaWYgKHVubGlrZWx5KCFhYikpCj4gPiArCQlyZXR1cm47Cj4gPiArCj4gPiArCWF1
ZGl0X2xvZ19mb3JtYXQoYWIsICJtb2R1bGU9JXMgZGV2PSVkOiVkIG9wPSVzIHNlY3Rvcj0lbGx1
IHJlcz0lZCIsCj4gPiArCQkJIGRtX21zZ19wcmVmaXgsIE1BSk9SKGJpby0+YmlfYmRldi0+YmRf
ZGV2KSwKPiA+ICsJCQkgTUlOT1IoYmlvLT5iaV9iZGV2LT5iZF9kZXYpLCBvcCwgc2VjdG9yLCBy
ZXN1bHQpOwo+ID4gKwlhdWRpdF9sb2dfZW5kKGFiKTsKPiA+ICt9Cj4gPiArRVhQT1JUX1NZTUJP
TF9HUEwoZG1fYXVkaXRfbG9nX2Jpbyk7Cj4gPiArCj4gPiArdm9pZCBkbV9hdWRpdF9sb2dfdGFy
Z2V0KGNvbnN0IGNoYXIgKmRtX21zZ19wcmVmaXgsIGNvbnN0IGNoYXIgKm9wLAo+ID4gKwkJCSBz
dHJ1Y3QgZG1fdGFyZ2V0ICp0aSwgaW50IHJlc3VsdCkKPiA+ICt7Cj4gPiArCXN0cnVjdCBhdWRp
dF9idWZmZXIgKmFiOwo+ID4gKwlzdHJ1Y3QgbWFwcGVkX2RldmljZSAqbWQgPSBkbV90YWJsZV9n
ZXRfbWQodGktPnRhYmxlKTsKPiA+ICsKPiA+ICsJaWYgKGF1ZGl0X2VuYWJsZWQgPT0gQVVESVRf
T0ZGKQo+ID4gKwkJcmV0dXJuOwo+ID4gKwo+ID4gKwlhYiA9IGF1ZGl0X2xvZ19zdGFydChhdWRp
dF9jb250ZXh0KCksIEdGUF9LRVJORUwsIEFVRElUX0RNKTsKPiA+ICsJaWYgKHVubGlrZWx5KCFh
YikpCj4gPiArCQlyZXR1cm47Cj4gPiArCj4gPiArCWF1ZGl0X2xvZ19mb3JtYXQoYWIsICJtb2R1
bGU9JXMgZGV2PSVzIG9wPSVzIiwKPiA+ICsJCQkgZG1fbXNnX3ByZWZpeCwgZG1fZGV2aWNlX25h
bWUobWQpLCBvcCk7Cj4gPiArCj4gPiArCWlmICghcmVzdWx0ICYmICFzdHJjbXAoImN0ciIsIG9w
KSkKPiA+ICsJCWF1ZGl0X2xvZ19mb3JtYXQoYWIsICIgZXJyb3JfbXNnPSclcyciLCB0aS0+ZXJy
b3IpOwo+ID4gKwlhdWRpdF9sb2dfZm9ybWF0KGFiLCAiIHJlcz0lZCIsIHJlc3VsdCk7Cj4gPiAr
CWF1ZGl0X2xvZ19lbmQoYWIpOwo+ID4gK30KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChkbV9hdWRp
dF9sb2dfdGFyZ2V0KTsKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLWF1ZGl0LmggYi9k
cml2ZXJzL21kL2RtLWF1ZGl0LmgKPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0Cj4gPiBpbmRleCAw
MDAwMDAwMDAwMDAuLjlkYjQ5NTVkMzJlMQo+ID4gLS0tIC9kZXYvbnVsbAo+ID4gKysrIGIvZHJp
dmVycy9tZC9kbS1hdWRpdC5oCj4gPiBAQCAtMCwwICsxLDMzIEBACj4gPiArLyogU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8KPiA+ICsvKgo+ID4gKyAqIENyZWF0aW5nIGF1ZGl0
IHJlY29yZHMgZm9yIG1hcHBlZCBkZXZpY2VzLgo+ID4gKyAqCj4gPiArICogQ29weXJpZ2h0IChD
KSAyMDIxIEZyYXVuaG9mZXIgQUlTRUMuIEFsbCByaWdodHMgcmVzZXJ2ZWQuCj4gPiArICoKPiA+
ICsgKiBBdXRob3JzOiBNaWNoYWVsIFdlacOfIDxtaWNoYWVsLndlaXNzQGFpc2VjLmZyYXVuaG9m
ZXIuZGU+Cj4gPiArICovCj4gPiArCj4gPiArI2lmbmRlZiBETV9BVURJVF9ICj4gPiArI2RlZmlu
ZSBETV9BVURJVF9ICj4gPiArCj4gPiArI2luY2x1ZGUgPGxpbnV4L2RldmljZS1tYXBwZXIuaD4K
PiA+ICsKPiA+ICsjaWZkZWYgQ09ORklHX0RNX0FVRElUCj4gPiArdm9pZCBkbV9hdWRpdF9sb2df
YmlvKGNvbnN0IGNoYXIgKmRtX21zZ19wcmVmaXgsIGNvbnN0IGNoYXIgKm9wLAo+ID4gKwkJICAg
ICAgc3RydWN0IGJpbyAqYmlvLCBzZWN0b3JfdCBzZWN0b3IsIGludCByZXN1bHQpOwo+ID4gK3Zv
aWQgZG1fYXVkaXRfbG9nX3RhcmdldChjb25zdCBjaGFyICpkbV9tc2dfcHJlZml4LCBjb25zdCBj
aGFyICpvcCwKPiA+ICsJCQkgc3RydWN0IGRtX3RhcmdldCAqdGksIGludCByZXN1bHQpOwo+ID4g
KyNlbHNlCj4gPiArc3RhdGljIGlubGluZSB2b2lkIGRtX2F1ZGl0X2xvZ19iaW8oY29uc3QgY2hh
ciAqZG1fbXNnX3ByZWZpeCwgY29uc3QgY2hhciAqb3AsCj4gPiArCQkJCSAgICBzdHJ1Y3QgYmlv
ICpiaW8sIHNlY3Rvcl90IHNlY3RvciwKPiA+ICsJCQkJICAgIGludCByZXN1bHQpOwo+ID4gK3sK
PiA+ICt9CgprZXJuZWwgdGVzdCByb2JvdCBzcG90dGVkIGEgc3ludGF4IGVycm9yIGlmIENPTkZJ
R19ETV9BVURJVCBpcwpub3Qgc2V0IGhlcmUsIHRvby4gV2lsbCBmaXggdGhpcyBpbiB2Mi4KCj4g
PiArc3RhdGljIGlubGluZSB2b2lkIGRtX2F1ZGl0X2xvZ190YXJnZXQoY29uc3QgY2hhciAqZG1f
bXNnX3ByZWZpeCwKPiA+ICsJCQkJICAgICAgIGNvbnN0IGNoYXIgKm9wLCBzdHJ1Y3QgZG1fdGFy
Z2V0ICp0aSwKPiA+ICsJCQkJICAgICAgIGludCByZXN1bHQpOwo+ID4gK3sKPiA+ICt9Cj4gPiAr
I2VuZGlmCj4gPiArCj4gPiArI2VuZGlmCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xp
bnV4L2F1ZGl0LmggYi9pbmNsdWRlL3VhcGkvbGludXgvYXVkaXQuaAo+ID4gaW5kZXggZGFhNDgx
NzI5ZTliLi45ZDc2NmZjYmNmNjIgMTAwNjQ0Cj4gPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgv
YXVkaXQuaAo+ID4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmgKPiA+IEBAIC0xMTgs
NiArMTE4LDcgQEAKPiA+ICAjZGVmaW5lIEFVRElUX1RJTUVfQURKTlRQVkFMCTEzMzMJLyogTlRQ
IHZhbHVlIGFkanVzdG1lbnQgKi8KPiA+ICAjZGVmaW5lIEFVRElUX0JQRgkJMTMzNAkvKiBCUEYg
c3Vic3lzdGVtICovCj4gPiAgI2RlZmluZSBBVURJVF9FVkVOVF9MSVNURU5FUgkxMzM1CS8qIFRh
c2sgam9pbmVkIG11bHRpY2FzdCByZWFkIHNvY2tldCAqLwo+ID4gKyNkZWZpbmUgQVVESVRfRE0J
CTEzMzYJLyogRGV2aWNlIE1hcHBlciBldmVudHMgKi8KPiA+ICAKPiA+ICAjZGVmaW5lIEFVRElU
X0FWQwkJMTQwMAkvKiBTRSBMaW51eCBhdmMgZGVuaWFsIG9yIGdyYW50ICovCj4gPiAgI2RlZmlu
ZSBBVURJVF9TRUxJTlVYX0VSUgkxNDAxCS8qIEludGVybmFsIFNFIExpbnV4IEVycm9ycyAqLwo+
ID4gQEAgLTE0MCw2ICsxNDEsNyBAQAo+ID4gICNkZWZpbmUgQVVESVRfTUFDX0NBTElQU09fQURE
CTE0MTgJLyogTmV0TGFiZWw6IGFkZCBDQUxJUFNPIERPSSBlbnRyeSAqLwo+ID4gICNkZWZpbmUg
QVVESVRfTUFDX0NBTElQU09fREVMCTE0MTkJLyogTmV0TGFiZWw6IGRlbCBDQUxJUFNPIERPSSBl
bnRyeSAqLwo+ID4gIAo+ID4gKwo+IAo+IFVubmVjZXNzYXJ5IGFkZGl0aW9uYWwgd2hpdGVzcGFj
ZS4KPiAKPiA+ICAjZGVmaW5lIEFVRElUX0ZJUlNUX0tFUk5fQU5PTV9NU0cgICAxNzAwCj4gPiAg
I2RlZmluZSBBVURJVF9MQVNUX0tFUk5fQU5PTV9NU0cgICAgMTc5OQo+ID4gICNkZWZpbmUgQVVE
SVRfQU5PTV9QUk9NSVNDVU9VUyAgICAgIDE3MDAgLyogRGV2aWNlIGNoYW5nZWQgcHJvbWlzY3Vv
dXMgbW9kZSAqLwoKVGhhbmtzIGZvciBzcG90dGluZyB0aGUgZXJyb3JzLCBJIHdpbGwgZml4IHRo
ZW0gaW4gdjIuCgpSZWdhcmRzLApNaWNoYWVsCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs

