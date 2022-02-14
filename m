Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4FEC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-q0PIYZSdNlSpiH_QKM_iZQ-1; Mon, 14 Feb 2022 03:48:02 -0500
X-MC-Unique: q0PIYZSdNlSpiH_QKM_iZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BDC3814249;
	Mon, 14 Feb 2022 08:47:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AD15106F756;
	Mon, 14 Feb 2022 08:47:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 140204CA93;
	Mon, 14 Feb 2022 08:47:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E1g195012716 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 13 Feb 2022 20:42:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 229EF5361CB; Mon, 14 Feb 2022 01:42:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DCC95361C5
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 01:42:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F11821066558
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 01:42:00 +0000 (UTC)
Received: from APC01-HK2-obe.outbound.protection.outlook.com
	(mail-eopbgr1300097.outbound.protection.outlook.com [40.107.130.97]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-158-tpkKcd6aNYOxceLi_SpoqQ-1; Sun, 13 Feb 2022 20:41:56 -0500
X-MC-Unique: tpkKcd6aNYOxceLi_SpoqQ-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by TYAPR06MB2094.apcprd06.prod.outlook.com (2603:1096:404:20::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11;
	Mon, 14 Feb 2022 01:41:50 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.014;
	Mon, 14 Feb 2022 01:41:49 +0000
From: =?utf-8?B?546L5pOO?= <wangqing@vivo.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Thread-Topic: [PATCH V2 00/13] use time_is_xxx() instead of jiffies judgment
Thread-Index: AQHYHu9qiPwDdlFSYEaDYTiIhZy3uayQIm6AgAImXJI=
Date: Mon, 14 Feb 2022 01:41:48 +0000
Message-ID: <SL2PR06MB308222AB00048FDE424524EABD339@SL2PR06MB3082.apcprd06.prod.outlook.com>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
	<AC2AdwCTE8eh*443p3QtSarp.9.1644684463005.Hmail.wangqing@vivo.com.@PFlnZmtnMG42UnZ2SllNSmFAbWl0LmVkdT4=>
In-Reply-To: <AC2AdwCTE8eh*443p3QtSarp.9.1644684463005.Hmail.wangqing@vivo.com.@PFlnZmtnMG42UnZ2SllNSmFAbWl0LmVkdT4=>
Accept-Language: zh-CN, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 7bc8dbe4-fcbe-1b44-0918-3ec81ee5fc0a
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ab30851-031f-469f-73b5-08d9ef5b2afa
x-ms-traffictypediagnostic: TYAPR06MB2094:EE_
x-microsoft-antispam-prvs: <TYAPR06MB2094CADEBE0B9CDAB3ECF323BD339@TYAPR06MB2094.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PoQok9Mu3ZF5QO0IncVJflif2uy9diA524kPlDSLHY4UBs37e6JGiHkASFwIG+4yflYdZDqKgeWKeCYB5/Sbo32xdJcxsLyQ/+diycx6UprHMN0GVTLNQKoNW0v31rQHBp+1wnsHABWy51mcsQCAEVXtJ9ZEvXJVMu8MuZsbAU5tmZSMaxqF+8mSi+I4FD5uLIDv3TRe1qjuVPgIP2qTgJUPOaX1eoAvuBIn2y6zUMqMd/iyV2mgzBYPXMaJnOq+lnMd2D6lC/wDwrqZfZOvqsqsD/HyqwiVItBCTOonUeoinlpGPlRgF5Yon2yVaTf3I6qEDtgRKDDyTGx1BRID+Z3HechR68/SJbfFBWHZ3N+rEm59C2CBX7yAjzi1gp6jcfZHjKMqfIyokwvMQYnx22lA01R/AjbyxACX/Vh8uJXZBLdj4KLBn/dUIdnVl4NeEpujW80I19/Z2vpRIcxK4wcfU5uHYU/kD6kPgFTHaheNXHNrKltgMvqvwCArlDlN6Z0udpAEEJAjfTbODfYGN/zKMtn7TlR3VQCtcP0oN7QKXuD4eTy3IESB3FwXpSAnD5PPp+bag17YYRetFZpDxcEfSqEtDnYCeSdk0asfM96eC1an000kBwvsUpGkJ+u/4bK/gEW8lYFEK8lvRmI8u7AP439gqA5wcToYSWOR0LEDd6S7wSJjPXJuNRQcmv67qM0vj81Rspl+cs+8ReRhO5pmjS7z7PGWWgItqnMwFJ8=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(8936002)(66946007)(6916009)(52536014)(71200400001)(6506007)(5660300002)(66446008)(54906003)(86362001)(9686003)(316002)(55016003)(91956017)(66476007)(33656002)(66556008)(4326008)(64756008)(8676002)(76116006)(7696005)(38100700002)(2906002)(508600001)(38070700005)(7406005)(26005)(186003)(4744005)(7416002)(85182001)(122000001)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODRtSGRHcm8xbmh6VWlHS09HZ2JBWkFYVlFvNnBTNFJwaEZjQkhYVUpLZFpq?=
	=?utf-8?B?QS9jSTZRbDhzdjJoNmpwdFByT0hMcVN6aTZSazROcGhpVmlsTTBoUnZxdGJT?=
	=?utf-8?B?MHUxQU5maGVZQmovMmhLdnBWZitJVDlnVEhoaThxWGJNODBWRlEvQjRyNENK?=
	=?utf-8?B?REtlRStNOHhuTjIxeFVJTEcwVW9IRWx4cEJBM05vSlViWTgvUENLakxKM2Jk?=
	=?utf-8?B?OURpV254c2ZiRGw2UC9PUEU0REYzbFJ5MEoxdnl6K0REanh5aVMrY3U1Ymlp?=
	=?utf-8?B?Q3RxL2w1Zm53S3RuV05Zem1sa0Y4K253dldUWnk4ekY2aWU5MDBsQ09qblpq?=
	=?utf-8?B?am1EUU5qcEtubDM2T2p2UVFGWDduVXdVeU1jeVVrazc1SE5yeFN6Q3VObjRa?=
	=?utf-8?B?bjA1UFZBUHFDd3A2dGVaaDVta2dmUVR0aXNnQ2dESWt4UHluQVdIR28wYjh3?=
	=?utf-8?B?eHRzeFhyN1hlVkp3UURXVUp5ZU5XckxNQWUrVmxrVTdtc1dqU3FzQ2dUbTlu?=
	=?utf-8?B?WnpDUWxjQzdHRkIvVGJ3NWV6MGI3MnEwSkVIL0xvT3BTS0g5a09FRkswNnhp?=
	=?utf-8?B?Ukg5dUV2UDdxTm83Q2JVSlprOTEzU2tFbFBqdDMwTU0vSm44eW9FdWdiRkhR?=
	=?utf-8?B?LzNNV2Qyd3RkS29ONkdLRlRiUnJaYW5UTXlmb3ZUL000aXFrYkkraGFjR05O?=
	=?utf-8?B?cEV6MmxyM1JRalZGYUxKcHBqeittZ3Z3TWZVQzg4TFRwVWk5czMwS0JITFdz?=
	=?utf-8?B?QWlNZ2IwT09ROHhkbmNkbFNXOCtHcXNwbHNsajVaZ00wT2FvTWlBNCtYb1dE?=
	=?utf-8?B?QXJqemdOQVY2Vm5LajY1Vi9nM0VVUVZoNDMzMlJla2grZkJIVVFVclFIdmJz?=
	=?utf-8?B?Nm1QZGY4a0FUeXh0N013cWk3eVlHd21VdFRQNDl3a2N3NWJFRXVzbm5qaDRz?=
	=?utf-8?B?a1JkNUx0MC9nMzJHbTNoSmJMdW9udmZyQU5RSDdPMzdTdFV6Q3Q2czcvMTAv?=
	=?utf-8?B?cjhFenFMWjEyaFpQcHlIS016RWUvaWZDTVpLSzA1TnFieSs1dW9lUkV6UkxD?=
	=?utf-8?B?SERZZnF6NlZMWURyank2TnJvNnFCOGJNRlludFh3Q3lOcHZ1QSsyc01VaUI4?=
	=?utf-8?B?MDhBQjNMUjJLZFVVd0ZBRzEyWGlaYjZ0YndDY1NTRU5aZkpUOVhBNHdNVWp2?=
	=?utf-8?B?NXJXVDZSY21hcUZ3cVBlcTZPM0wxakI3TmVXVDdDZGt2NDlaZ2VsSVREaWJQ?=
	=?utf-8?B?Y0tHZzBzZGQyaFhtZFRRanBQV1Ixa0h1SXBUb01NWEhTekViSFM3cVNzZ00x?=
	=?utf-8?B?WUF5QXNUZ3NNRmYzakNDNkVORGluVGJENzBKOUcvajZxbGdTUHo2T2NrT3Z3?=
	=?utf-8?B?Wk0xWmhsdWluamJ0dHNRRElzZjM3WmprdS9LMm4xY3k0NGdzWHFGL2pyZnpp?=
	=?utf-8?B?WEtjcE96U09SSncvREhsaVVmVysxNDY0Qy9JTnZsc3BBY1l0cGFBYjVkRm5i?=
	=?utf-8?B?SnBHWmVwM0hzc2ZEeUZNcXJyZVJNc0NzcSt0TS9HdXlGTWpWbllYNlZJeXAz?=
	=?utf-8?B?cU5uVWdjUWVCOUg4TkFuZTRxY2RJL0k5clNiYU83NWNpS0s4Z3ZmSU9WWmpp?=
	=?utf-8?B?N2FNVWtWSjRlUHF3OStWUUVITnFGd1FtL1ZCRTdHU0lPRFRpbGJaQ2NkdXJF?=
	=?utf-8?B?T3A0dVE1ZU8wRVNWU3YxWktlVS9qdFFSTHRWMmp3YmVVNytrSDMvUUYvSm1j?=
	=?utf-8?B?NVBobGtVdlFJNHUwLzhGbGdGRHZuOGtWVnFTU2tqVEhiUEJjd0xEc01MZVgz?=
	=?utf-8?B?VXpzQldneDB4NHRIcUsvVkpPVzJBU3loVFpuTG0va09WZ1BDZFVzSnpKZVdJ?=
	=?utf-8?B?MExSYnJ5UnEwSEo5TUpJTHVhaVd2aEF5bVJNN2lkL2xUWkZOdG4zbUo0UWtD?=
	=?utf-8?B?VlJrTVVveE1UL2ZqTFA1R29sWFFuY0tDa1hvRFpJbHJuQVFYWXYzbGxtRENX?=
	=?utf-8?B?UTNTYXhnakxrOC9UaW15UXI1RER6UVlkeWNLRzJ6K2FFREljR0d1RVJKN3l1?=
	=?utf-8?B?T3hzOTZtMkhpeE5wc2tIczlWWThHTHp2aFRoRndzeWwrUHhzNWpqcEJpVzFu?=
	=?utf-8?B?MGhPRkJPeFZrZDRkNWNzTW1Rakg3Y3h2V0ZOa1RxL25HN3BFRlpZVTNNRzhF?=
	=?utf-8?B?OVE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab30851-031f-469f-73b5-08d9ef5b2afa
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 01:41:48.3161 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fYwai20+OBS3ibqU/l+iaNIA5hOEXoZPBj1zj3uSvEsBIMpWKxEJan80CVtyXohqi7yQF6XOy3ruUEsVXAclRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2094
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E1g195012716
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>,
	Michael Turquette <mturquette@baylibre.com>,
	Lahtinen <joonas.lahtinen@linux.intel.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Joonas, "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mauro,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Jiri Kosina <jikos@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Carvalho Chehab <mchehab@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>, "Pan, 
	Xinhui" <Xinhui.Pan@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
	=?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
	=?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH V2 00/13] use time_is_xxx() instead of
	jiffies judgment
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
Content-Language: zh-CN
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

wqAKPj5PbiBUaHUsIEZlYiAxMCwgMjAyMiBhdCAwNjozMDoyM1BNIC0wODAwLCBRaW5nIFdhbmcg
d3JvdGU6Cj4+IEZyb206IFdhbmcgUWluZyA8d2FuZ3FpbmdAdml2by5jb20+Cj4+IAo+PiBJdCBp
cyBiZXR0ZXIgdG8gdXNlIHRpbWVfaXNfeHh4KCkgZGlyZWN0bHkgaW5zdGVhZCBvZiBqaWZmaWVz
IGp1ZGdtZW50Cj4+IGZvciB1bmRlcnN0YW5kaW5nLgo+Cj5IaSBXYW5nLAo+Cj4ianVkZ2VtZW50
IiBkb2Vzbid0IHJlYWxseSBtYWtlIHNlbnNlIGFzIGEgZGVzY3JpcHRpb24gdG8gYW4gRW5nbGlz
aAo+c3BlYWtlci7CoCBUaGUgZm9sbG93aW5nIGEgY29tbWl0IGRlc3JpcHRpb24gKGZvciBhbGwg
b2YgdGhlc2Ugc2VyaWVzKQo+aXMgcHJvYmFibHkgZ29pbmcgdG8gYmUgYSBiaXQgbW9yZSB1bmRl
cnN0YWJsZToKPgo+VXNlIHRoZSBoZWxwZXIgZnVuY3Rpb24gdGltZV9pc197YmVmb3JlLGFmdGVy
fV9qaWZmaWVzKCkgdG8gaW1wcm92ZQo+Y29kZSByZWFkYWJpbGl0eS4KPgo+Q2hlZXJzLAo+Cj7C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtIFRlZAoKSSBzZWUsIGl0IHdpbGwg
YmUgY29ycmVjdGVkIGluIFYzLgpJJ2xsIHdhaXQgYSBmZXcgZGF5cyBpZiB0aGVyZSBhcmUgYW55
IG90aGVyIGRpc2FncmVlbWVudHMuCgpUaGFua3MsClFpbmcKCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWw=

