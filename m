Return-Path: <SRS0=WplP=N4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C05C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:15:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 049056103B
	for <dm-devel@archiver.kernel.org>; Mon,  6 Sep 2021 08:15:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 049056103B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=aisec.fraunhofer.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-FXUVkW0UP-y3M2tHx_DybQ-1; Mon, 06 Sep 2021 04:14:44 -0400
X-MC-Unique: FXUVkW0UP-y3M2tHx_DybQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47AA71009446;
	Mon,  6 Sep 2021 08:14:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A4AA5D740;
	Mon,  6 Sep 2021 08:14:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F17E718087F1;
	Mon,  6 Sep 2021 08:14:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1849PDLY022461 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 4 Sep 2021 05:25:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6BCAF2162393; Sat,  4 Sep 2021 09:25:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6376F216238D
	for <dm-devel@redhat.com>; Sat,  4 Sep 2021 09:25:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9257089C7DB
	for <dm-devel@redhat.com>; Sat,  4 Sep 2021 09:25:10 +0000 (UTC)
Received: from mail-edgeKA24.fraunhofer.de (mail-edgeka24.fraunhofer.de
	[153.96.1.24]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-277-LwE6RxHcNtqU9Uix438lMw-1; Sat, 04 Sep 2021 05:25:06 -0400
X-MC-Unique: LwE6RxHcNtqU9Uix438lMw-1
IronPort-SDR: v4OeD3M8EeGPWllmHum7mFzEpGztR7T9ltFJ59fyLMWo/5ZJgPs0jAIlfquTi2SRnOUbJMmngI
	KGpgKHzg0NufMJTRtuwrjqZZUgvNgtoxItpCOKp/5xpWs2XSCs9APhp9vQDBdj/WuK0cFbuont
	rPMANn7i6AUbDfKhj2ST7A9oMIFHcWBuG7vN7CXi2jNymiDx4MFeBqy+WYe2OF2/h0gLj4Dx1i
	qIeV3UeemKyBgCbqKq76H0QykmwQdyZDv0aLVRpjqNt/Xbk/mlR2f/rmzE955MOvctbqalTYtl
	/tQ=
IronPort-PHdr: =?us-ascii?q?A9a23=3AyeGifhA6J/Te+L15wPG8UyQVnBdPi9zP1kY98?=
	=?us-ascii?q?pM6j/dLdaO58tLpO0mMrflujVqcW4Ld5roEjufNqKnvVCQG5orJq3ENdpFAF?=
	=?us-ascii?q?npnwcUblgAtGoiJXEv8KvO5dyUnGIFHU1h/8jewNk0GUMr7bkfZ93u16zNaE?=
	=?us-ascii?q?x7jNA1zc+LyHIO37Yy32um+9oeVbR9PgW+0YKh/J1O4twzMsMkRj4Z4bKo8m?=
	=?us-ascii?q?XP0?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2FbBAAvOjNh/xoBYJlaHgEBCxIMQIF?=
	=?us-ascii?q?OC4FTKSiBV2mESIFHggEDhTmICJpagS6BJQNUCwEBAQEBAQEBAQcBAT8CBAE?=
	=?us-ascii?q?BAwMkhEYCF4IsASU0CQ4BAgQBAQESAQEGAQEBAQEGBAICgSCFaAEMg1OBCAE?=
	=?us-ascii?q?BAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCgQg9AQEBAQI?=
	=?us-ascii?q?BEhEEDQwBATcBBAsCAQgYAgImAgICMBUQAgQOBSKCBEuCVgMOIAKeZAGBOgK?=
	=?us-ascii?q?KH3p/MoEBgggBAQYEBIIRgnkYgRaBHgkJAYEGKoJ/hBKGaieCKYEVNoEFgW4?=
	=?us-ascii?q?+hFuDAIJkh1+DZRaRcIJ9RqhMB4IDUFueXzGVXZEohVCBLY8fpS8CBAIEBQI?=
	=?us-ascii?q?OAQEGgWGCFU0kgzhQGQ+OIAwWg1CKXkMxAjYCBgEKAQEDCYI5gw6MRgE?=
X-IPAS-Result: =?us-ascii?q?A2FbBAAvOjNh/xoBYJlaHgEBCxIMQIFOC4FTKSiBV2mES?=
	=?us-ascii?q?IFHggEDhTmICJpagS6BJQNUCwEBAQEBAQEBAQcBAT8CBAEBAwMkhEYCF4IsA?=
	=?us-ascii?q?SU0CQ4BAgQBAQESAQEGAQEBAQEGBAICgSCFaAEMg1OBCAEBAQEBAQEBAQEBA?=
	=?us-ascii?q?QEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQUCgQg9AQEBAQIBEhEEDQwBATcBB?=
	=?us-ascii?q?AsCAQgYAgImAgICMBUQAgQOBSKCBEuCVgMOIAKeZAGBOgKKH3p/MoEBgggBA?=
	=?us-ascii?q?QYEBIIRgnkYgRaBHgkJAYEGKoJ/hBKGaieCKYEVNoEFgW4+hFuDAIJkh1+DZ?=
	=?us-ascii?q?RaRcIJ9RqhMB4IDUFueXzGVXZEohVCBLY8fpS8CBAIEBQIOAQEGgWGCFU0kg?=
	=?us-ascii?q?zhQGQ+OIAwWg1CKXkMxAjYCBgEKAQEDCYI5gw6MRgE?=
X-IronPort-AV: E=Sophos;i="5.85,267,1624312800"; d="scan'208";a="35374804"
Received: from mail-mtaka26.fraunhofer.de ([153.96.1.26])
	by mail-edgeKA24.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2021 11:25:03 +0200
IronPort-SDR: mFpfxZtKHYLzuc1o+mmfc86HaVvArnQckyeOFDK01m7qDxuEa/5K8nZ5u6YhercJdYIhCRZS1X
	+XRKz9I9jwcQitu9Llb0vjdHSPvZKKrto=
IronPort-PHdr: =?us-ascii?q?A9a23=3AEojKwRFI06RjP1qFeouNe51GftIY04WdBeZdw?=
	=?us-ascii?q?oIulrYLd6Ok5ZmkN0vatr1hj17MCIPc7f8My+/bqLvpVmFI55Gd+GsDf5pBW?=
	=?us-ascii?q?15g640WkgUsDdTDBRj9K/jnPDQzAcAHUVhi5Xz9Ok9QS47yYlTIqSi06jgfU?=
	=?us-ascii?q?hz0KQtyILHzHYjf6qb/1+2795DJJQtSgz/oaLJpIR7wox/Yq88WhoVvMOA9x?=
	=?us-ascii?q?0ihnw=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AMpc+t6MpbQr4HsBcT5v255DYdb4zR+YMi2?=
	=?us-ascii?q?TDiHofdfUFSKClfp6V8cjzjSWE9Qr4WBkb6LW90DHpewKcyXcH2/hsAV7EZn?=
	=?us-ascii?q?inhILIFvAt0WKG+VPd8kLFh5dgPMtbAstD4ZjLfCJHZKXBkUqF+rQbsaG6Gc?=
	=?us-ascii?q?mT7I+0pRYMcegpUdAa0+4QMHfHLqQcfngjOXNNLuv72iMxnUvGRZ14VLXYOl?=
	=?us-ascii?q?A1G8z44/HbnpPvZhALQzQ97hOVsD+u4LnmVzCFwxY3SVp0sPUf2FmAtza8yr?=
	=?us-ascii?q?Sosvm9xBOZ/XTU9Y5qlNzozcYGLNCQi/ISNi7nhm+TFcFcsvy5zXQISdOUmR?=
	=?us-ascii?q?AXeer30k4d1gNImivsl1SO0FzQMs/boW0TAjHZuAWlaDDY0LPErXoBerR8bM?=
	=?us-ascii?q?RiA0fkAgMbzaFBOOgg5RPpi7NHSRzHhyjz/N7OSlVjkVe1u2MrlaoJg2VYSp?=
	=?us-ascii?q?Z2Us4akWUzxjIcLH47JlOw1GnnKpgbMOjMoPJNNV+KZXHQuWdihNSqQ3QoBx?=
	=?us-ascii?q?+DBkwPoNac3TRalG1wixJw/r1Sol4QsJYmD5VU7eXNNapl0LlIU88NdKp4QO?=
	=?us-ascii?q?MMW9G+BGDBSQ/FdGiSPVPkHqcaPG+lke+73JwloOWxPJAYxpo7n5rMFFteqG?=
	=?us-ascii?q?4pYkrrTdaD2ZVamyq9CVlVnQ6dvP22wqIJ9YEUaICbQxFreWpe5PdI+c9vcf?=
	=?us-ascii?q?Ezc8zDTa5rPw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AeBwAvOjNh/z6wYZlaHgEBCxIMQAm?=
	=?us-ascii?q?BRQuBUykoB4FPAWmER4FHggEDhTmFYYInOAGJAYI5jmeBLoElA1QLAQMBAQE?=
	=?us-ascii?q?BAQcBAQQ6AQIEAQEqhEYCF4IpAiY0CQ4BAgQBAQESAQEFAQEBAgEGBIERE4V?=
	=?us-ascii?q?oAQyGQwEBAQIBEhEEDQwBARQjAQQLAgEIGgImAgICMAcOEAIEDgUiggRLglY?=
	=?us-ascii?q?DDiACnmQBgToCixl/MoEBgggBAQYEBIIRgnkYgRaBHgkJAYEGKoJ/hBKGaoJ?=
	=?us-ascii?q?QgRU2gQWBbj6EW4MAgmSdSoJ9RqhMggpQW55fMZVdkSiFUIEtjx+lLwIEAgQ?=
	=?us-ascii?q?FAg4BAQaBYTuBWU0kgzhQGQ+OIAwWg1CKXkIBMQI2AgYBCgEBAwmCOYMMAQG?=
	=?us-ascii?q?MRQEB?=
X-IronPort-AV: E=Sophos;i="5.85,267,1624312800"; d="scan'208";a="122881821"
Received: from 153-97-176-62.vm.c.fraunhofer.de (HELO
	mobile.exch.fraunhofer.de) ([153.97.176.62])
	by mail-mtaKA26.fraunhofer.de with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2021 11:25:00 +0200
Received: from XCH-HYBRID-02.ads.fraunhofer.de (10.225.8.59) by
	XCH-HYBRID-02.ads.fraunhofer.de (10.225.8.59) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.858.15; Sat, 4 Sep 2021 11:25:00 +0200
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (10.225.8.37) by
	XCH-HYBRID-02.ads.fraunhofer.de (10.225.8.59) with Microsoft SMTP
	Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.15
	via Frontend Transport; Sat, 4 Sep 2021 11:25:00 +0200
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:3c2::22)
	by AM7P194MB0865.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:174::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21;
	Sat, 4 Sep 2021 09:24:58 +0000
Received: from AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::ed17:5927:e044:2d07]) by AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
	([fe80::ed17:5927:e044:2d07%2]) with mapi id 15.20.4478.024;
	Sat, 4 Sep 2021 09:24:58 +0000
From: =?utf-8?B?V2Vpw58sIE1pY2hhZWw=?= <michael.weiss@aisec.fraunhofer.de>
To: "paul@paul-moore.com" <paul@paul-moore.com>
Thread-Topic: [PATCH v3 1/3] dm: introduce audit event module for device mapper
Thread-Index: AQHXnp0mu9UtL79rKkShvTOtJeQmkauSlJMAgAELpoA=
Date: Sat, 4 Sep 2021 09:24:57 +0000
Message-ID: <d317655d8fb081f7902185540b62ea633572c21c.camel@aisec.fraunhofer.de>
References: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
	<20210831191845.7928-2-michael.weiss@aisec.fraunhofer.de>
	<CAHC9VhSa6mMAPocicaMNsWJr6eMsM7G6Ap6Ywoy8m89cCf=txg@mail.gmail.com>
In-Reply-To: <CAHC9VhSa6mMAPocicaMNsWJr6eMsM7G6Ap6Ywoy8m89cCf=txg@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9c216ae-093c-4bbd-9c9d-08d96f85dd23
x-ms-traffictypediagnostic: AM7P194MB0865:
x-microsoft-antispam-prvs: <AM7P194MB086596A3D867BFBBEE3183A5ACD09@AM7P194MB0865.EURP194.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hJkJeS2ZLuw0OYiwx5En+cKRXdI7BB7smvd3N0NHkv2FwIrJxbjgTWGMoLQsDMlYvC/N1m8EFA5ZTsRCy3PEsXOdbowQrKOG+5Y13kNbauxRpDV+MN1RiD0/12hWzld4mTqh070bLfGDmXcbeMN19XfjPNG2OWag7wYsZVAIlgUOhljOoWZCmisBA4bobbbsbz8lW5qDo4W+j+x5n2tD4Kt+Z5BU5dCN8Vt+ic3f6M29GkV6nUC9sd79dcUG5Vm9iOYElRcGBXxY8PsTQR0IWqkeTl3keZBEGkA7SQIhh/lgnv4v6BQnL/VV2mitUTYpfhR29JVu+po+TDl9xoPMTOtpJfsmN6Oegd07uckdLLov8Zepli6X/VDaNGLlrzh6c+Do3dRy+VZ+EUE6dytXJkly1OXmIsWUYGScbbZEc12q1/xyJOrFMgDOyP+vnD8JT/y7AKMb20oYJzQfOTkVT6sxuSGXTJqgpDJUPYxxzgLfQ3ely3+ac9qb20Kb7rkfxOWuk7VwSxiowA2crk5qDi+zH+MiIm24ks1/eUhtXUdbsavRC2GAHVL5sVKOdEKekTXdC53GR6/aljvg1kuJJmebmmn6uHmu0u0AD6SPT20Nx4iYRw6fT226v0+PKyChfOl3+7OBo7FlcP5wL4yKjfjm4Ym1E9E7lvqdokBYpb6xnkSH20M1HGUIsBk8MOR2K6PHjtICZjo3lHGcpL9Tgw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:AS8P194MB1288.EURP194.PROD.OUTLOOK.COM;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39850400004)(316002)(6512007)(64756008)(66476007)(54906003)(2906002)(6486002)(4326008)(85182001)(66446008)(76116006)(66946007)(66556008)(6916009)(71200400001)(186003)(8936002)(26005)(53546011)(6506007)(122000001)(38100700002)(5660300002)(478600001)(8676002)(7416002)(2616005)(38070700005)(91956017)(86362001)(83380400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1VqM2tGWEJHMC9UdDg5N0srUTJ4RHd0YVo5S2hVQldkQUZhTHVETVVHN2FP?=
	=?utf-8?B?UEN5cmh6SDk0Y1poVUQ3cy9TMkZScHNib0FRQktkV2FNdkZpemk3NjE0Y0dh?=
	=?utf-8?B?VnJvc2pBWmFVM0QwSjZoTkdqT0pXa3ZyUFVDQWk5ZUxjZEhZK1ZHeVdJbkhl?=
	=?utf-8?B?dEQzYW5oTVhhMWEwUEx2UUVTQmQ4RlA2S2hpR0tRRXlsT0ZRZ0dyOVlpdVh1?=
	=?utf-8?B?Q0xSMFJsYTByTnduNWJ0UWpuR3QwNW1xZFlhbFZ1NFMzQ2Nqd0crbHZKTEJy?=
	=?utf-8?B?Sm1xb1hTdzNXVkNManBTUzRHUyt3cC9GWlJMcmZtUlFuclUyTEk0L2Q0bW5V?=
	=?utf-8?B?UGp0TlNJTTVtZmlERDZzbGNSWXVXR3YvOXVEZ280b2h5UndCRTFwZGpEQlRP?=
	=?utf-8?B?Y21JUlNaNG56bUE2blFqQjJHQkFhNXRhUzBHM2FDTjBWTk1tUDJ5M2VldnQv?=
	=?utf-8?B?Q0N0ci9FRWxKWk5uZGNpVjh3ZVlaTDNISFQydnYyRjA1NmVMUmYvM0JSYmVn?=
	=?utf-8?B?WStZaEZWdWJTTEZJQkppdFpoNGlXRHpXOUxPdnUxMkphdzhoMVBDeWZJdlF4?=
	=?utf-8?B?NFhYQ2llRlU1SWdTSkQ1UG05RFRmL3JEZFpoMEpwZys4VWo0VkMzN00yRWdu?=
	=?utf-8?B?NDdrWHphSk9STTU0aktrL1VDNnpna3YyU1MvOWUrZHB5WjJxRmt6czhwV0xT?=
	=?utf-8?B?R0VWd2dEV0xjbFZ5a1gyS1dlVDNpdVU3ZC81R0NUZ3pSR1MrMmpqYVF6YWVX?=
	=?utf-8?B?anpmc3Q1REc5dTFmaEpYYjM0ZGFwbmhubEdpSlRnUnljb3hHRnBZZWFGZStM?=
	=?utf-8?B?SG9HbWZNd0s4YUJtQVpGZldNQXh2azQ4QjFlTlZkMytPa203TTZOZWU4akh3?=
	=?utf-8?B?dC9yZkNCbGdNRGlKMWpHczg5bmMyWVBObituOWZNZUE5UGxXazR1NDBaQ3Fs?=
	=?utf-8?B?NVdCMVFjWG5vT0RmUDJuMjhoUEdOc3p6QkNmUjJ2dzNiQkp1SXNIOUNHUmdQ?=
	=?utf-8?B?ZGdSTGswdkpKc3hHb3lxNXB5cTFydjcrZk5nRUhqbDI3VEtVWCtkaVdCVWVn?=
	=?utf-8?B?cUw2dFd6YjFLTlRydmNXRUtvendLYWhsT3lTenVVb0NDYmx6WVVEcTBPMzBp?=
	=?utf-8?B?eThJREE0ZzlUUjFWeTkybEJDUHl4aS8rOUFHMXVPbG55NGJHeGxzZ0Zyb3hs?=
	=?utf-8?B?M3VDRWdWQWhkYVBKOXA0aWRFS1FGalJCODl2TVNvcHlLempDMk1xZG40VFdO?=
	=?utf-8?B?ZmZabjBTU0hyVS9xbkY5QWFzRjdQN04zdEJ1RkdKMmFYMVpKbXM3eTFUejc0?=
	=?utf-8?B?MmVZSkhxUFRIQkY0UktPTkJpdVVIMTVCTEVDVUFqWGtSblY0T2k5RG9OaSs5?=
	=?utf-8?B?dEsxNy9pczZXZEpMdC9MMGc2MVdnWFJxRk0vKzhxby8rQUVCdURNUGMycFdD?=
	=?utf-8?B?OTI3amZWYitCNWtDd21VeFg1b29rc0t6VEdwQllKalJoQlhLZVN0cVY4WWoy?=
	=?utf-8?B?ZlMraWFzdlU4eVVxa1UrTUJpYVNoWElwakYxU1d6K2JzOFBJZkRHTkliUTZp?=
	=?utf-8?B?S3hEWjZIcEE1MGRUMFR1Z3UrWjd6RzZYQkx0MXc5c05RY29LVmhJdEhxNEFm?=
	=?utf-8?B?M08rVi9oRHdDckVYRmVSM1pENjEvaFB3d25yOVlpTVFkZ1NpdGlaN0VTdEFQ?=
	=?utf-8?B?bUFWOGVXaTcyN1BUL2E2aVh5aXY4djFXbzdNV3JCNXdCUjVBKzJncS84VkJU?=
	=?utf-8?Q?rG2LGMYQtgtuLHNvNofsUUYtegcd8mQNghStFvZ?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8P194MB1288.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c216ae-093c-4bbd-9c9d-08d96f85dd23
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2021 09:24:58.0122 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LpRswiSasgogeJP9N1oU3t9UY5EIyIOUKltGCFBg9efb3IpoZceNUYU1AjhZN+SZ6wPiWhYtzOUf5SOnYiwI6X4U1s8WY36Ovrc77g4CDP3e6mY2aWghz8RVagAbqSML
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P194MB0865
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1849PDLY022461
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 06 Sep 2021 04:14:38 -0400
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"song@kernel.org" <song@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"casey@schaufler-ca.com" <casey@schaufler-ca.com>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v3 1/3] dm: introduce audit event module for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CEBF85547705E54392E663991E1D8E4E@EURP194.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCAyMDIxLTA5LTAzIGF0IDEzOjI3IC0wNDAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+IE9u
IFR1ZSwgQXVnIDMxLCAyMDIxIGF0IDM6MTkgUE0gTWljaGFlbCBXZWnDnwo+IDxtaWNoYWVsLndl
aXNzQGFpc2VjLmZyYXVuaG9mZXIuZGU+IHdyb3RlOgo+ID4gVG8gYmUgYWJsZSB0byBzZW5kIGF1
ZGl0aW5nIGV2ZW50cyB0byB1c2VyIHNwYWNlLCB3ZSBpbnRyb2R1Y2UgYQo+ID4gZ2VuZXJpYyBk
bS1hdWRpdCBtb2R1bGUuIEl0IHByb3ZpZGVzIGhlbHBlciBmdW5jdGlvbnMgdG8gZW1pdCBhdWRp
dAo+ID4gZXZlbnRzIHRocm91Z2ggdGhlIGtlcm5lbCBhdWRpdCBzdWJzeXN0ZW0uIFdlIGNsYWlt
IHRoZQo+ID4gQVVESVRfRE1fQ1RSTCB0eXBlPTEzMzYgYW5kIEFVRElUX0RNX0VWRU5UIHR5cGU9
MTMzNyBvdXQgb2YgdGhlCj4gPiBhdWRpdCBldmVudCBtZXNzYWdlcyByYW5nZSBpbiB0aGUgY29y
cmVzcG9uZGluZyB1c2Vyc3BhY2UgYXBpIGluCj4gPiAnaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0
LmgnIGZvciB0aG9zZSBldmVudHMuCj4gPiAKPiA+IEFVRElUX0RNX0NUUkwgaXMgdXNlZCB0byBw
cm92aWRlIGluZm9ybWF0aW9uIGFib3V0IGNyZWF0aW9uIGFuZAo+ID4gZGVzdHJ1Y3Rpb24gb2Yg
ZGV2aWNlIG1hcHBlciB0YXJnZXRzIHdoaWNoIGFyZSB0cmlnZ2VyZWQgYnkgdXNlciBzcGFjZQo+
ID4gYWRtaW4gY29udHJvbCBhY3Rpb25zLgo+ID4gQVVESVRfRE1fRVZFTlQgaXMgdXNlZCB0byBw
cm92aWRlIGluZm9ybWF0aW9uIGFib3V0IGFjdHVhbCBlcnJvcnMKPiA+IGR1cmluZyBvcGVyYXRp
b24gb2YgdGhlIG1hcHBlZCBkZXZpY2UsIHNob3dpbmcgZS5nLiBpbnRlZ3JpdHkKPiA+IHZpb2xh
dGlvbnMgaW4gYXVkaXQgbG9nLgo+ID4gCj4gPiBGb2xsb3dpbmcgY29tbWl0cyB0byBkZXZpY2Ug
bWFwcGVyIHRhcmdldHMgYWN0dWFsbHkgd2lsbCBtYWtlIHVzZSBvZgo+ID4gdGhpcyB0byBlbWl0
IHRob3NlIGV2ZW50cyBpbiByZWxldmFudCBjYXNlcy4KPiA+IAo+ID4gVGhlIGF1ZGl0IGxvZ3Mg
bG9vayBsaWtlIHRoaXMgaWYgZXhlY3V0aW5nIHRoZSBmb2xsb3dpbmcgc2ltcGxlIHRlc3Q6Cj4g
PiAKPiA+ICAjIGRkIGlmPS9kZXYvemVybyBvZj10ZXN0LmltZyBicz0xTSBjb3VudD0xMDI0Cj4g
PiAgIyBsb3NldHVwIC1mIHRlc3QuaW1nCj4gPiAgIyBpbnRlZ3JpdHlzZXR1cCAtdkQgZm9ybWF0
IC0taW50ZWdyaXR5IHNoYTI1NiAtdCAzMiAvZGV2L2xvb3AwCj4gPiAgIyBpbnRlZ3JpdHlzZXR1
cCBvcGVuIC1EIC9kZXYvbG9vcDAgLS1pbnRlZ3JpdHkgc2hhMjU2IGludGVncml0eXRlc3QKPiA+
ICAjIGludGVncml0eXNldHVwIHN0YXR1cyBpbnRlZ3JpdHl0ZXN0Cj4gPiAgIyBpbnRlZ3JpdHlz
ZXR1cCBjbG9zZSBpbnRlZ3JpdHl0ZXN0Cj4gPiAgIyBpbnRlZ3JpdHlzZXR1cCBvcGVuIC1EIC9k
ZXYvbG9vcDAgLS1pbnRlZ3JpdHkgc2hhMjU2IGludGVncml0eXRlc3QKPiA+ICAjIGludGVncml0
eXNldHVwIHN0YXR1cyBpbnRlZ3JpdHl0ZXN0Cj4gPiAgIyBkZCBpZj0vZGV2L3VyYW5kb20gb2Y9
L2Rldi9sb29wMCBicz01MTIgY291bnQ9MSBzZWVrPTEwMDAwMAo+ID4gICMgZGQgaWY9L2Rldi9t
YXBwZXIvaW50ZWdyaXR5dGVzdCBvZj0vZGV2L251bGwKPiA+IAo+ID4gLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQo+ID4gYXVkaXQubG9nIGZyb20gYXVkaXRkCj4gPiAKPiA+IHR5cGU9VU5LTk9X
TlsxMzM2XSBtc2c9YXVkaXQoMTYzMDQyNTAzOS4zNjM6MTg0KTogbW9kdWxlPWludGVncml0eQo+
ID4gb3A9Y3RyIHBwaWQ9MzgwNyBwaWQ9MzgxOSBhdWlkPTEwMDAgdWlkPTAgZ2lkPTAgZXVpZD0w
IHN1aWQ9MCBmc3VpZD0wCj4gPiBlZ2lkPTAgc2dpZD0wIGZzZ2lkPTAgdHR5PXB0czIgc2VzPTMg
Y29tbT0iaW50ZWdyaXR5c2V0dXAiCj4gPiBleGU9Ii9zYmluL2ludGVncml0eXNldHVwIiBzdWJq
PT11bmNvbmZpbmVkIGRldj0yNTQ6Mwo+ID4gZXJyb3JfbXNnPSdzdWNjZXNzJyByZXM9MQo+ID4g
dHlwZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjMwNDI1MDM5LjQ3MToxODUpOiBtb2R1bGU9
aW50ZWdyaXR5Cj4gPiBvcD1kdHIgcHBpZD0zODA3IHBpZD0zODE5IGF1aWQ9MTAwMCB1aWQ9MCBn
aWQ9MCBldWlkPTAgc3VpZD0wIGZzdWlkPTAKPiA+IGVnaWQ9MCBzZ2lkPTAgZnNnaWQ9MCB0dHk9
cHRzMiBzZXM9MyBjb21tPSJpbnRlZ3JpdHlzZXR1cCIKPiA+IGV4ZT0iL3NiaW4vaW50ZWdyaXR5
c2V0dXAiIHN1Ymo9PXVuY29uZmluZWQgZGV2PTI1NDozCj4gPiBlcnJvcl9tc2c9J3N1Y2Nlc3Mn
IHJlcz0xCj4gPiB0eXBlPVVOS05PV05bMTMzNl0gbXNnPWF1ZGl0KDE2MzA0MjUwMzkuNjExOjE4
Nik6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWN0ciBwcGlkPTM4MDcgcGlkPTM4MTkgYXVpZD0x
MDAwIHVpZD0wIGdpZD0wIGV1aWQ9MCBzdWlkPTAgZnN1aWQ9MAo+ID4gZWdpZD0wIHNnaWQ9MCBm
c2dpZD0wIHR0eT1wdHMyIHNlcz0zIGNvbW09ImludGVncml0eXNldHVwIgo+ID4gZXhlPSIvc2Jp
bi9pbnRlZ3JpdHlzZXR1cCIgc3Viaj09dW5jb25maW5lZCBkZXY9MjU0OjMKPiA+IGVycm9yX21z
Zz0nc3VjY2VzcycgcmVzPTEKPiA+IHR5cGU9VU5LTk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYzMDQy
NTA1NC40NzU6MTg3KTogbW9kdWxlPWludGVncml0eQo+ID4gb3A9ZHRyIHBwaWQ9MzgwNyBwaWQ9
MzgxOSBhdWlkPTEwMDAgdWlkPTAgZ2lkPTAgZXVpZD0wIHN1aWQ9MCBmc3VpZD0wCj4gPiBlZ2lk
PTAgc2dpZD0wIGZzZ2lkPTAgdHR5PXB0czIgc2VzPTMgY29tbT0iaW50ZWdyaXR5c2V0dXAiCj4g
PiBleGU9Ii9zYmluL2ludGVncml0eXNldHVwIiBzdWJqPT11bmNvbmZpbmVkIGRldj0yNTQ6Mwo+
ID4gZXJyb3JfbXNnPSdzdWNjZXNzJyByZXM9MQo+ID4gCj4gPiB0eXBlPVVOS05PV05bMTMzNl0g
bXNnPWF1ZGl0KDE2MzA0MjUwNzMuMTcxOjE5MSk6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWN0
ciBwcGlkPTM4MDcgcGlkPTM4ODMgYXVpZD0xMDAwIHVpZD0wIGdpZD0wIGV1aWQ9MCBzdWlkPTAg
ZnN1aWQ9MAo+ID4gZWdpZD0wIHNnaWQ9MCBmc2dpZD0wIHR0eT1wdHMyIHNlcz0zIGNvbW09Imlu
dGVncml0eXNldHVwIgo+ID4gZXhlPSIvc2Jpbi9pbnRlZ3JpdHlzZXR1cCIgc3Viaj09dW5jb25m
aW5lZCBkZXY9MjU0OjMKPiA+IGVycm9yX21zZz0nc3VjY2VzcycgcmVzPTEKPiA+IAo+ID4gdHlw
ZT1VTktOT1dOWzEzMzZdIG1zZz1hdWRpdCgxNjMwNDI1MDg3LjIzOToxOTIpOiBtb2R1bGU9aW50
ZWdyaXR5Cj4gPiBvcD1kdHIgcHBpZD0zODA3IHBpZD0zOTAyIGF1aWQ9MTAwMCB1aWQ9MCBnaWQ9
MCBldWlkPTAgc3VpZD0wIGZzdWlkPTAKPiA+IGVnaWQ9MCBzZ2lkPTAgZnNnaWQ9MCB0dHk9cHRz
MiBzZXM9MyBjb21tPSJpbnRlZ3JpdHlzZXR1cCIKPiA+IGV4ZT0iL3NiaW4vaW50ZWdyaXR5c2V0
dXAiIHN1Ymo9PXVuY29uZmluZWQgZGV2PTI1NDozCj4gPiBlcnJvcl9tc2c9J3N1Y2Nlc3MnIHJl
cz0xCj4gPiAKPiA+IHR5cGU9VU5LTk9XTlsxMzM2XSBtc2c9YXVkaXQoMTYzMDQyNTA5My43NTU6
MTkzKTogbW9kdWxlPWludGVncml0eQo+ID4gb3A9Y3RyIHBwaWQ9MzgwNyBwaWQ9MzkwNiBhdWlk
PTEwMDAgdWlkPTAgZ2lkPTAgZXVpZD0wIHN1aWQ9MCBmc3VpZD0wCj4gPiBlZ2lkPTAgc2dpZD0w
IGZzZ2lkPTAgdHR5PXB0czIgc2VzPTMgY29tbT0iaW50ZWdyaXR5c2V0dXAiCj4gPiBleGU9Ii9z
YmluL2ludGVncml0eXNldHVwIiBzdWJqPT11bmNvbmZpbmVkIGRldj0yNTQ6Mwo+ID4gZXJyb3Jf
bXNnPSdzdWNjZXNzJyByZXM9MQo+ID4gCj4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNnPWF1ZGl0
KDE2MzA0MjUxMTIuMTE5OjE5NCk6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWludGVncml0eS1j
aGVja3N1bSBkZXY9MjU0OjMgc2VjdG9yIDc3NDgwIHJlcz0wCj4gPiB0eXBlPVVOS05PV05bMTMz
N10gbXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjE5NSk6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9w
PWludGVncml0eS1jaGVja3N1bSBkZXY9MjU0OjMgc2VjdG9yIDc3NDgwIHJlcz0wCj4gPiB0eXBl
PVVOS05PV05bMTMzN10gbXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjE5Nik6IG1vZHVsZT1pbnRl
Z3JpdHkKPiA+IG9wPWludGVncml0eS1jaGVja3N1bSBkZXY9MjU0OjMgc2VjdG9yIDc3NDgwIHJl
cz0wCj4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjE5Nyk6
IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWludGVncml0eS1jaGVja3N1bSBkZXY9MjU0OjMgc2Vj
dG9yIDc3NDgwIHJlcz0wCj4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNnPWF1ZGl0KDE2MzA0MjUx
MTIuMTE5OjE5OCk6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWludGVncml0eS1jaGVja3N1bSBk
ZXY9MjU0OjMgc2VjdG9yIDc3NDgwIHJlcz0wCj4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNnPWF1
ZGl0KDE2MzA0MjUxMTIuMTE5OjE5OSk6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWludGVncml0
eS1jaGVja3N1bSBkZXY9MjU0OjMgc2VjdG9yIDc3NDgwIHJlcz0wCj4gPiB0eXBlPVVOS05PV05b
MTMzN10gbXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjIwMCk6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+
IG9wPWludGVncml0eS1jaGVja3N1bSBkZXY9MjU0OjMgc2VjdG9yIDc3NDgwIHJlcz0wCj4gPiB0
eXBlPVVOS05PV05bMTMzN10gbXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjIwMSk6IG1vZHVsZT1p
bnRlZ3JpdHkKPiA+IG9wPWludGVncml0eS1jaGVja3N1bSBkZXY9MjU0OjMgc2VjdG9yIDc3NDgw
IHJlcz0wCj4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNnPWF1ZGl0KDE2MzA0MjUxMTIuMTE5OjIw
Mik6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWludGVncml0eS1jaGVja3N1bSBkZXY9MjU0OjMg
c2VjdG9yIDc3NDgwIHJlcz0wCj4gPiB0eXBlPVVOS05PV05bMTMzN10gbXNnPWF1ZGl0KDE2MzA0
MjUxMTIuMTE5OjIwMyk6IG1vZHVsZT1pbnRlZ3JpdHkKPiA+IG9wPWludGVncml0eS1jaGVja3N1
bSBkZXY9MjU0OjMgc2VjdG9yIDc3NDgwIHJlcz0wCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IE1p
Y2hhZWwgV2Vpw58gPG1pY2hhZWwud2Vpc3NAYWlzZWMuZnJhdW5ob2Zlci5kZT4KPiA+IC0tLQo+
ID4gIGRyaXZlcnMvbWQvS2NvbmZpZyAgICAgICAgIHwgMTAgKysrKysKPiA+ICBkcml2ZXJzL21k
L01ha2VmaWxlICAgICAgICB8ICA0ICsrCj4gPiAgZHJpdmVycy9tZC9kbS1hdWRpdC5jICAgICAg
fCA3OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ID4gIGRyaXZlcnMv
bWQvZG0tYXVkaXQuaCAgICAgIHwgNjIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4g
PiAgaW5jbHVkZS91YXBpL2xpbnV4L2F1ZGl0LmggfCAgMiArCj4gPiAgNSBmaWxlcyBjaGFuZ2Vk
LCAxNTcgaW5zZXJ0aW9ucygrKQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21kL2Rt
LWF1ZGl0LmMKPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tZC9kbS1hdWRpdC5oCj4g
PiAKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL0tjb25maWcgYi9kcml2ZXJzL21kL0tjb25m
aWcKPiA+IGluZGV4IDA2MDJlODJhOTUxNi4uNDhhZGJlYzEyMTQ4IDEwMDY0NAo+ID4gLS0tIGEv
ZHJpdmVycy9tZC9LY29uZmlnCj4gPiArKysgYi9kcml2ZXJzL21kL0tjb25maWcKPiA+IEBAIC02
MDgsNiArNjA4LDcgQEAgY29uZmlnIERNX0lOVEVHUklUWQo+ID4gICAgICAgICBzZWxlY3QgQ1JZ
UFRPCj4gPiAgICAgICAgIHNlbGVjdCBDUllQVE9fU0tDSVBIRVIKPiA+ICAgICAgICAgc2VsZWN0
IEFTWU5DX1hPUgo+ID4gKyAgICAgICBzZWxlY3QgRE1fQVVESVQgaWYgQVVESVQKPiA+ICAgICAg
ICAgaGVscAo+ID4gICAgICAgICAgIFRoaXMgZGV2aWNlLW1hcHBlciB0YXJnZXQgZW11bGF0ZXMg
YSBibG9jayBkZXZpY2UgdGhhdCBoYXMKPiA+ICAgICAgICAgICBhZGRpdGlvbmFsIHBlci1zZWN0
b3IgdGFncyB0aGF0IGNhbiBiZSB1c2VkIGZvciBzdG9yaW5nCj4gPiBAQCAtNjQwLDQgKzY0MSwx
MyBAQCBjb25maWcgRE1fWk9ORUQKPiA+IAo+ID4gICAgICAgICAgIElmIHVuc3VyZSwgc2F5IE4u
Cj4gPiAKPiA+ICtjb25maWcgRE1fQVVESVQKPiA+ICsgICAgICAgYm9vbCAiRE0gYXVkaXQgZXZl
bnRzIgo+ID4gKyAgICAgICBkZXBlbmRzIG9uIEFVRElUCj4gPiArICAgICAgIGhlbHAKPiA+ICsg
ICAgICAgICBHZW5lcmF0ZSBhdWRpdCBldmVudHMgZm9yIGRldmljZS1tYXBwZXIuCj4gPiArCj4g
PiArICAgICAgICAgRW5hYmxlcyBhdWRpdCBsb2dnaW5nIG9mIHNldmVyYWwgc2VjdXJpdHkgcmVs
ZXZhbnQgZXZlbnRzIGluIHRoZQo+ID4gKyAgICAgICAgIHBhcnRpY3VsYXIgZGV2aWNlLW1hcHBl
ciB0YXJnZXRzLCBlc3BlY2lhbGx5IHRoZSBpbnRlZ3JpdHkgdGFyZ2V0Lgo+ID4gKwo+ID4gIGVu
ZGlmICMgTUQKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL01ha2VmaWxlIGIvZHJpdmVycy9t
ZC9NYWtlZmlsZQo+ID4gaW5kZXggYTc0YWFmOGIxNDQ1Li4yZjgzZDY0OTUwMGQgMTAwNjQ0Cj4g
PiAtLS0gYS9kcml2ZXJzL21kL01ha2VmaWxlCj4gPiArKysgYi9kcml2ZXJzL21kL01ha2VmaWxl
Cj4gPiBAQCAtMTAzLDMgKzEwMyw3IEBAIGVuZGlmCj4gPiAgaWZlcSAoJChDT05GSUdfRE1fVkVS
SVRZX1ZFUklGWV9ST09USEFTSF9TSUcpLHkpCj4gPiAgZG0tdmVyaXR5LW9ianMgICAgICAgICAg
ICAgICAgICs9IGRtLXZlcml0eS12ZXJpZnktc2lnLm8KPiA+ICBlbmRpZgo+ID4gKwo+ID4gK2lm
ZXEgKCQoQ09ORklHX0RNX0FVRElUKSx5KQo+ID4gK2RtLW1vZC1vYmpzICAgICAgICAgICAgICAg
ICAgICArPSBkbS1hdWRpdC5vCj4gPiArZW5kaWYKPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2RtLWF1ZGl0LmMgYi9kcml2ZXJzL21kL2RtLWF1ZGl0LmMKPiA+IG5ldyBmaWxlIG1vZGUgMTAw
NjQ0Cj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLjc2MWVjZmRjZDQ5YQo+ID4gLS0tIC9kZXYvbnVs
bAo+ID4gKysrIGIvZHJpdmVycy9tZC9kbS1hdWRpdC5jCj4gPiBAQCAtMCwwICsxLDc5IEBACj4g
PiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKPiA+ICsvKgo+ID4gKyAqIENy
ZWF0aW5nIGF1ZGl0IHJlY29yZHMgZm9yIG1hcHBlZCBkZXZpY2VzLgo+ID4gKyAqCj4gPiArICog
Q29weXJpZ2h0IChDKSAyMDIxIEZyYXVuaG9mZXIgQUlTRUMuIEFsbCByaWdodHMgcmVzZXJ2ZWQu
Cj4gPiArICoKPiA+ICsgKiBBdXRob3JzOiBNaWNoYWVsIFdlacOfIDxtaWNoYWVsLndlaXNzQGFp
c2VjLmZyYXVuaG9mZXIuZGU+Cj4gPiArICovCj4gPiArCj4gPiArI2luY2x1ZGUgPGxpbnV4L2F1
ZGl0Lmg+Cj4gPiArI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgo+ID4gKyNpbmNsdWRlIDxsaW51
eC9kZXZpY2UtbWFwcGVyLmg+Cj4gPiArI2luY2x1ZGUgPGxpbnV4L2Jpby5oPgo+ID4gKyNpbmNs
dWRlIDxsaW51eC9ibGtkZXYuaD4KPiA+ICsKPiA+ICsjaW5jbHVkZSAiZG0tYXVkaXQuaCIKPiA+
ICsjaW5jbHVkZSAiZG0tY29yZS5oIgo+ID4gKwo+ID4gK3N0YXRpYyBzdHJ1Y3QgYXVkaXRfYnVm
ZmVyICpkbV9hdWRpdF9sb2dfc3RhcnQoaW50IGF1ZGl0X3R5cGUsCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IGNoYXIgKmRtX21zZ19wcmVm
aXgsCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNv
bnN0IGNoYXIgKm9wKQo+ID4gK3sKPiA+ICsgICAgICAgc3RydWN0IGF1ZGl0X2J1ZmZlciAqYWI7
Cj4gPiArCj4gPiArICAgICAgIGlmIChhdWRpdF9lbmFibGVkID09IEFVRElUX09GRikKPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gTlVMTDsKPiA+ICsKPiA+ICsgICAgICAgYWIgPSBhdWRpdF9s
b2dfc3RhcnQoYXVkaXRfY29udGV4dCgpLCBHRlBfS0VSTkVMLCBhdWRpdF90eXBlKTsKPiA+ICsg
ICAgICAgaWYgKHVubGlrZWx5KCFhYikpCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIE5VTEw7
Cj4gPiArCj4gPiArICAgICAgIGF1ZGl0X2xvZ19mb3JtYXQoYWIsICJtb2R1bGU9JXMgb3A9JXMi
LCBkbV9tc2dfcHJlZml4LCBvcCk7Cj4gPiArICAgICAgIHJldHVybiBhYjsKPiA+ICt9Cj4gPiAr
Cj4gPiArdm9pZCBkbV9hdWRpdF9sb2dfdGkoaW50IGF1ZGl0X3R5cGUsIGNvbnN0IGNoYXIgKmRt
X21zZ19wcmVmaXgsIGNvbnN0IGNoYXIgKm9wLAo+ID4gKyAgICAgICAgICAgICAgICAgICAgc3Ry
dWN0IGRtX3RhcmdldCAqdGksIGludCByZXN1bHQpCj4gPiArewo+ID4gKyAgICAgICBzdHJ1Y3Qg
YXVkaXRfYnVmZmVyICphYjsKPiA+ICsgICAgICAgc3RydWN0IG1hcHBlZF9kZXZpY2UgKm1kID0g
ZG1fdGFibGVfZ2V0X21kKHRpLT50YWJsZSk7Cj4gPiArICAgICAgIGludCBkZXZfbWFqb3IgPSBk
bV9kaXNrKG1kKS0+bWFqb3I7Cj4gPiArICAgICAgIGludCBkZXZfbWlub3IgPSBkbV9kaXNrKG1k
KS0+Zmlyc3RfbWlub3I7Cj4gPiArCj4gPiArICAgICAgIGFiID0gZG1fYXVkaXRfbG9nX3N0YXJ0
KGF1ZGl0X3R5cGUsIGRtX21zZ19wcmVmaXgsIG9wKTsKPiA+ICsgICAgICAgaWYgKHVubGlrZWx5
KCFhYikpCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuOwo+ID4gKwo+ID4gKyAgICAgICBzd2l0
Y2ggKGF1ZGl0X3R5cGUpIHsKPiA+ICsgICAgICAgY2FzZSBBVURJVF9ETV9DVFJMOgo+ID4gKyAg
ICAgICAgICAgICAgIGF1ZGl0X2xvZ190YXNrX2luZm8oYWIpOwo+ID4gKyAgICAgICAgICAgICAg
IGF1ZGl0X2xvZ19mb3JtYXQoYWIsICIgZGV2PSVkOiVkIGVycm9yX21zZz0nJXMnIiwgZGV2X21h
am9yLAo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZGV2X21pbm9yLCAhcmVz
dWx0ID8gdGktPmVycm9yIDogInN1Y2Nlc3MiKTsKPiA+ICsgICAgICAgICAgICAgICBicmVhazsK
PiA+ICsgICAgICAgY2FzZSBBVURJVF9ETV9FVkVOVDoKPiA+ICsgICAgICAgICAgICAgICBhdWRp
dF9sb2dfZm9ybWF0KGFiLCAiIGRldj0lZDolZCBzZWN0b3I9PyIsIGRldl9tYWpvciwKPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRldl9taW5vcik7Cj4gPiArICAgICAgICAg
ICAgICAgYnJlYWs7Cj4gPiArICAgICAgIH0KPiA+ICsgICAgICAgYXVkaXRfbG9nX2Zvcm1hdChh
YiwgIiByZXM9JWQiLCByZXN1bHQpOwo+ID4gKyAgICAgICBhdWRpdF9sb2dfZW5kKGFiKTsKPiA+
ICt9Cj4gPiArRVhQT1JUX1NZTUJPTF9HUEwoZG1fYXVkaXRfbG9nX3RpKTsKPiAKPiBKdXN0IGNo
ZWNraW5nLCBidXQgYXJlIHlvdSBva2F5IHdoZW4gdGhlIGluZXZpdGFibGUgaGFwcGVucyBhbmQK
PiBzb21lb25lIHBhc3NlcyBhbiBAYXVkaXRfdHlwZSB0aGF0IGlzIG5vdCBlaXRoZXIgQVVESVRf
Q01fQ1RSTCBvcgo+IEFVRElUX0RNX0VWRU5UPyAgUmlnaHQgbm93IHRoYXQgd2lsbCBzdWNjZWVk
IHdpdGhvdXQgZXJyb3IgYW5kIGdpdmUgYQo+IHJhdGhlciBzaG9ydCBhdWRpdCByZWNvcmQuCj4g
CldlbGwsIHRoaXMgZnVuY3Rpb24gaXMgbm90IGludGVuZGVkIHRvIGJlIGNhbGxlZCBkaXJlY3Rs
eSBmcm9tIG90aGVyIGRtCm1vZHVsZXMuIE9ubHkgdGhlIGNvcnJlc3BvbmRpbmcgd3JhcHBlciBm
dW5jdGlvbnMgaW4gZG0tYXVkaXQuaCBzaG91bGQKYmUgY2FsbGVkLiBJIHdpbGwgYWRkIGEgY29t
bWVudCBpbiB0aGUgaGVhZGVyIGFuZCBwcm92aWRlIGEgZGVmYXVsdCBjYXNlCndoaWNoIGRvZXMg
bm90IGxvZyBhbnl0aGluZyBoZXJlLgoKPiA+ICt2b2lkIGRtX2F1ZGl0X2xvZ19iaW8oY29uc3Qg
Y2hhciAqZG1fbXNnX3ByZWZpeCwgY29uc3QgY2hhciAqb3AsCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgc3RydWN0IGJpbyAqYmlvLCBzZWN0b3JfdCBzZWN0b3IsIGludCByZXN1bHQpCj4gPiAr
ewo+ID4gKyAgICAgICBzdHJ1Y3QgYXVkaXRfYnVmZmVyICphYjsKPiA+ICsgICAgICAgaW50IGRl
dl9tYWpvciA9IE1BSk9SKGJpby0+YmlfYmRldi0+YmRfZGV2KTsKPiA+ICsgICAgICAgaW50IGRl
dl9taW5vciA9IE1JTk9SKGJpby0+YmlfYmRldi0+YmRfZGV2KTsKPiA+ICsKPiA+ICsgICAgICAg
YWIgPSBkbV9hdWRpdF9sb2dfc3RhcnQoQVVESVRfRE1fRVZFTlQsIGRtX21zZ19wcmVmaXgsIG9w
KTsKPiA+ICsgICAgICAgaWYgKHVubGlrZWx5KCFhYikpCj4gPiArICAgICAgICAgICAgICAgcmV0
dXJuOwo+ID4gKwo+ID4gKyAgICAgICBhdWRpdF9sb2dfZm9ybWF0KGFiLCAiIGRldj0lZDolZCBz
ZWN0b3IgJWxsdSByZXM9JWQiLAo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgIGRldl9tYWpv
ciwgZGV2X21pbm9yLCBzZWN0b3IsIHJlc3VsdCk7Cj4gCj4gSSB0aGluayB5b3UgZm9yZ290IHRo
ZSAiPSIgYWZ0ZXIgInNlY3RvciIsIGUuZy4gInNlY3Rvcj0lbGx1Ii4KPiAKRGFtbiwgeW91IGFy
ZSByaWdodC4gSSdsbCBmaXggdGhhdC4KCj4gPiArICAgICAgIGF1ZGl0X2xvZ19lbmQoYWIpOwo+
ID4gK30KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChkbV9hdWRpdF9sb2dfYmlvKTsKCi0tIApUaGFu
a3MsCk1pY2hhZWwKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

