Return-Path: <SRS0=vwJi=FQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF83C4361B
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 17:05:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D305A22AAC
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 17:05:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D305A22AAC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=fb.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-_uUWp84HMGKBHBhc4YmBqg-1; Sat, 12 Dec 2020 12:05:03 -0500
X-MC-Unique: _uUWp84HMGKBHBhc4YmBqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0FD1180A08A;
	Sat, 12 Dec 2020 17:04:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA7A060BFA;
	Sat, 12 Dec 2020 17:04:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B3B34A7C6;
	Sat, 12 Dec 2020 17:04:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BCH4uCL022669 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Dec 2020 12:04:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 314B92166B2A; Sat, 12 Dec 2020 17:04:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ACB92166B29
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 17:04:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 838101010424
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 17:04:52 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-496-3vaZNnYMN16CLnqVedGqNg-1; Sat, 12 Dec 2020 12:04:46 -0500
X-MC-Unique: 3vaZNnYMN16CLnqVedGqNg-1
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id
	0BCH0P5k004419; Sat, 12 Dec 2020 09:04:43 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com with ESMTP id 35cvfw1385-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT); Sat, 12 Dec 2020 09:04:43 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
	by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.1979.3; Sat, 12 Dec 2020 09:04:42 -0800
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
	by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20;
	Sat, 12 Dec 2020 17:04:28 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
	([fe80::f49e:bdbb:8cd7:bf6b]) by
	BYAPR15MB2999.namprd15.prod.outlook.com
	([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3654.018;
	Sat, 12 Dec 2020 17:04:28 +0000
From: Song Liu <songliubraving@fb.com>
To: Mike Snitzer <snitzer@redhat.com>
Thread-Topic: [PATCH] md: change mddev 'chunk_sectors' from int to unsigned
Thread-Index: AQHW0KeiIw2KhQOkrEGtati8GGezYanzsGEA
Date: Sat, 12 Dec 2020 17:04:28 +0000
Message-ID: <1A230145-26A2-4D0B-A81F-0B0873EAB251@fb.com>
References: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
	<20201212144229.GB21863@redhat.com>
	<2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
	<20201212165537.GA53870@lobo>
In-Reply-To: <20201212165537.GA53870@lobo>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c091:480::1:e346]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cf37407-8cd7-4cae-6163-08d89ebffc76
x-ms-traffictypediagnostic: BYAPR15MB2455:
x-microsoft-antispam-prvs: <BYAPR15MB24554A54F998D8AF5DB5EFF9B3C90@BYAPR15MB2455.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1360
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SDMYYy4KjrTUKlzcosZasxHRj4bciiyELFbuNe2IbBNoGocrGYLumx8x1R/Um8AF8FL8bPsTI4x8Z2U4YXyBnuP0t4bMIiaMn1q3fITbmdbI1Ncmg7TnCf/xeFiW/H87KCZIunUz11VSKytUoQxa07dc179BTg7936MtuXuELTUv0qGgjxK9jHHWthZjh2hPzc6PtngXH72EtiB9ASXAnBQb+vdSJ/n7Rc59m3Pz/rbkRhPw797oeyuj70bKC0/uzpr9Mke/H1EaPzL2ZVSHkq2DN3przEaSKGQt0QWGao2iscEYAGnl0DAvkgNhL/6Y/5heZAvFRcYRCLHXr7XDzaIoyh4botwK6S27Ei4ZAygcVpgcL3MTvpe41nNzhFHk
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR15MB2999.namprd15.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(376002)(366004)(6916009)(71200400001)(2906002)(6512007)(8676002)(6486002)(4326008)(66946007)(91956017)(36756003)(66446008)(64756008)(54906003)(66476007)(66556008)(76116006)(33656002)(53546011)(8936002)(2616005)(5660300002)(186003)(508600001)(6506007)(86362001)(83380400001)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?WGtFQUJYRUlDRkwyZVYvdnkrQ3JoNjNvUXN5K3p6NzVOR3l2U3luVzRJNzU3?=
	=?utf-8?B?bmMzR2wvdERsZDAwdkVheSt2anZ4N3o0QUVWMFJ5Q05CSGh6YmlBazhwSVBp?=
	=?utf-8?B?eWJhRkM2d1FVZGhHNVJlYmtJME8xamQ4cTFkRnFNcS90ZFFRaDFOdVVoTUlC?=
	=?utf-8?B?TC92d2hZSTY1Z0FzNldrYlovOCs0UGJqdVZydHdCZmNzejNZNXNwTHlEYUc3?=
	=?utf-8?B?THg3ZFNJWEVZVlZYbytFR0ZmRlorTDgvK0dFemlOWCtlSUVwRHpFY3Jneklk?=
	=?utf-8?B?NVJBaE9ldTV4UkthSkZBMWJSZ3ZxbmVCYXNabjAySWVDVWk0Q3E3SjkvRE51?=
	=?utf-8?B?Uk9zcnQvK0FudjlOVEJOdkFVZTR5cUZWd2h1TlBFUmc1WVJ4a2dDbUsxWlRL?=
	=?utf-8?B?YlA5d2dRTU5RYU1TQURxa3ZwL1dObnc4Rm02THZ0VGxmSnJoQWxOV1hPTDNw?=
	=?utf-8?B?NFNSRWs3V2xKRkFaOGVxdjBNcU41SXZxY0FQQS94UTFtWExYeVhITmVuaDRa?=
	=?utf-8?B?RUJON21GSGlQS21icDk5V0NnTWZ0dDBTYWxxcldTaEdMWUwzcVVRVXNIc2xm?=
	=?utf-8?B?M2MvbEZtQWQ2SjRrcVlMd3kwQkY0NzYyeEtaa2RiY2I0TDZxUE1OamFtbXVY?=
	=?utf-8?B?SUF2RWJUNE9NQUgrenlMVTd0eTVuTHRzUFlINU9EU1BVczREMUxmZ1Y0aFRp?=
	=?utf-8?B?K2RMZVFGVFYrM1dGN2UzdFFpTDUyMDduUVZ5ZXJQN0FlRHE0WmhOSkVMN2RV?=
	=?utf-8?B?c2ZkWjlYTTBuclUwS1ppRVR5eVVFbmkva3h0RHVodWFaOU5hUk55R2RidnpP?=
	=?utf-8?B?d1BBbFBJb0FmL1lVcFlrU3Vsc2lnSVRqclFJS25XZ1lKLytTQkJpcmp3eGU1?=
	=?utf-8?B?R3lpZFkzQlNTTFRYQUcwdVRMcFVjcHIrS2MyK3Q5dld2Tm5aTjNDb1hjMlNH?=
	=?utf-8?B?eGZHRXZvMFRDNjBPSHZ1cXdrT3RKZHFOa0ZhN3haNjM4cUIvZzc2MGxTcEZj?=
	=?utf-8?B?WnU5T2FnNnQrVk5JR2JSaFdkZ3Q2TngwNzRqU1Y3cW5JNlQwSnF0MjZ2WVRv?=
	=?utf-8?B?TlVIVnh5ZlM3SEVGRTloVVZZa2dXRUpRazQ0cEpSTmw4T0xWVUU4anR4cUxT?=
	=?utf-8?B?T2QybDhJTExZZzBCZHNkdHd3WC85MXhERkRVR1dOVnFYV3pWakZ6UmcwVGZY?=
	=?utf-8?B?bkFhcVNYUTBsRXBod2EybFZLUy81QldFVnFQZ0pJaVVWdjI0YUlNREFYamJz?=
	=?utf-8?B?VkxyOWpNcXRuV1F3QS90SzRzYlk2Q1haRXpiekg4SXRrZFRqWWluRE1RQnBo?=
	=?utf-8?B?OXRIRHd0cFQxQnB4eEZnNytEdStScUxHUWtBMG85d1M5UGhPOUxyVHIxS1FE?=
	=?utf-8?Q?lDkLJR/iXGm5OTL4U6HdK9sMsOd2L1X0=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf37407-8cd7-4cae-6163-08d89ebffc76
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2020 17:04:28.3424 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wByF42GS25RGk9P4krguRTUNWwjpC9IXFecXnbiaEn2FycBKqqqTDePbaJVymic8BS//zKcsVNygSueehzZJPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343, 18.0.737
	definitions=2020-12-12_05:2020-12-11,
	2020-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
	lowpriorityscore=0
	mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 clxscore=1011
	impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0
	mlxscore=0
	adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2012120133
X-FB-Internal: deliver
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BCH4uCL022669
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Heinz Mauelshagen <heinzm@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Matthew Ruffell <matthew.ruffell@canonical.com>,
	linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
Subject: Re: [dm-devel] [PATCH] md: change mddev 'chunk_sectors' from int to
	unsigned
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <844C10DC6C764944B9613788F2D46046@namprd15.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Cgo+IE9uIERlYyAxMiwgMjAyMCwgYXQgODo1NSBBTSwgTWlrZSBTbml0emVyIDxzbml0emVyQHJl
ZGhhdC5jb20+IHdyb3RlOgo+IAo+IENvbW1pdCBlMjc4MmY1NjBjMjkgKCJSZXZlcnQgImRtIHJh
aWQ6IHJlbW92ZSB1bm5lY2Vzc2FyeSBkaXNjYXJkCj4gbGltaXRzIGZvciByYWlkMTAiIikgZXhw
b3NlZCBjb21waWxlciB3YXJuaW5ncyBpbnRyb2R1Y2VkIGJ5IGNvbW1pdAo+IGUwOTEwYzhlNGY4
NyAoImRtIHJhaWQ6IGZpeCBkaXNjYXJkIGxpbWl0cyBmb3IgcmFpZDEgYW5kIHJhaWQxMCIpOgo+
IAo+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSAuL2luY2x1ZGUvbGludXgva2VybmVsLmg6MTQsCj4g
ICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2FzbS1nZW5lcmljL2J1Zy5oOjIwLAo+ICAg
ICAgICAgICAgICAgICBmcm9tIC4vYXJjaC94ODYvaW5jbHVkZS9hc20vYnVnLmg6OTMsCj4gICAg
ICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L2J1Zy5oOjUsCj4gICAgICAgICAgICAg
ICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L21tZGVidWcuaDo1LAo+ICAgICAgICAgICAgICAgICBm
cm9tIC4vaW5jbHVkZS9saW51eC9nZnAuaDo1LAo+ICAgICAgICAgICAgICAgICBmcm9tIC4vaW5j
bHVkZS9saW51eC9zbGFiLmg6MTUsCj4gICAgICAgICAgICAgICAgIGZyb20gZHJpdmVycy9tZC9k
bS1yYWlkLmM6ODoKPiBkcml2ZXJzL21kL2RtLXJhaWQuYzogSW4gZnVuY3Rpb24g4oCYcmFpZF9p
b19oaW50c+KAmToKPiAuL2luY2x1ZGUvbGludXgvbWlubWF4Lmg6MTg6Mjg6IHdhcm5pbmc6IGNv
bXBhcmlzb24gb2YgZGlzdGluY3QgcG9pbnRlciB0eXBlcyBsYWNrcyBhIGNhc3QKPiAgKCEhKHNp
emVvZigodHlwZW9mKHgpICopMSA9PSAodHlwZW9mKHkpICopMSkpKQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIF5+Cj4gLi9pbmNsdWRlL2xpbnV4L21pbm1heC5oOjMyOjQ6IG5vdGU6IGlu
IGV4cGFuc2lvbiBvZiBtYWNybyDigJhfX3R5cGVjaGVja+KAmQo+ICAgKF9fdHlwZWNoZWNrKHgs
IHkpICYmIF9fbm9fc2lkZV9lZmZlY3RzKHgsIHkpKQo+ICAgIF5+fn5+fn5+fn5+Cj4gLi9pbmNs
dWRlL2xpbnV4L21pbm1heC5oOjQyOjI0OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCY
X19zYWZlX2NtcOKAmQo+ICBfX2J1aWx0aW5fY2hvb3NlX2V4cHIoX19zYWZlX2NtcCh4LCB5KSwg
XAo+ICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fgo+IC4vaW5jbHVkZS9saW51eC9t
aW5tYXguaDo1MToxOTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmF9fY2FyZWZ1bF9j
bXDigJkKPiAjZGVmaW5lIG1pbih4LCB5KSBfX2NhcmVmdWxfY21wKHgsIHksIDwpCj4gICAgICAg
ICAgICAgICAgICAgXn5+fn5+fn5+fn5+fgo+IC4vaW5jbHVkZS9saW51eC9taW5tYXguaDo4NDoz
OTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmG1pbuKAmQo+ICBfX3ggPT0gMCA/IF9f
eSA6ICgoX195ID09IDApID8gX194IDogbWluKF9feCwgX195KSk7IH0pCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBefn4KPiBkcml2ZXJzL21kL2RtLXJhaWQuYzozNzM5
OjMzOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYbWluX25vdF96ZXJv4oCZCj4gICBs
aW1pdHMtPm1heF9kaXNjYXJkX3NlY3RvcnMgPSBtaW5fbm90X3plcm8ocnMtPm1kLmNodW5rX3Nl
Y3RvcnMsCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn4KPiAK
PiBGaXggdGhpcyBieSBjaGFuZ2luZyB0aGUgY2h1bmtfc2VjdG9ycyBtZW1iZXIgb2YgJ3N0cnVj
dCBtZGRldicgZnJvbQo+IGludCB0byAndW5zaWduZWQgaW50JyB0byBtYXRjaCB0aGUgdHlwZSB1
c2VkIGZvciB0aGUgJ2NodW5rX3NlY3RvcnMnCj4gbWVtYmVyIG9mICdzdHJ1Y3QgcXVldWVfbGlt
aXRzJy4gIFZhcmlvdXMgTUQgY29kZSBzdGlsbCB1c2VzICdpbnQnIGJ1dAo+IG5vbmUgb2YgaXQg
YXBwZWFycyB0byBldmVyIG1ha2UgdXNlIG9mIHNpZ25lZCBpbnQ7IGFuZCBzdG9yaW5nCj4gcG9z
aXRpdmUgc2lnbmVkIGludCBpbiB1bnNpZ25lZCBpcyBwZXJmZWN0bHkgc2FmZS4KClRoYW5rcyBm
b3IgdGhlIHF1aWNrIGZpeCBhbmQgdGhvcm91Z2ggYW5hbHlzaXMuIEkgYWxzbyBjaGVja2VkIE1E
IGNvZGUgCmFuZCBkaWRuJ3Qgc2VlIGFueSB1c2Ugb2YgbmVnYXRpdmUgY2h1bmtfc2VjdG9ycywg
c28gdGhpcyBjaGFuZ2UgaXMgc2FmZS4KSSB3aWxsIGNvbnZlcnQgdGhlIHJlc3QgdXNlIG9mIHNp
Z25lZCBjaHVua19zZWN0b3JzIGluIDUuMTEuIAoKPiAKPiBSZXBvcnRlZC1ieTogU29uZyBMaXUg
PHNvbmdsaXVicmF2aW5nQGZiLmNvbT4KPiBGaXhlczogZTI3ODJmNTYwYzI5ICgiUmV2ZXJ0ICJk
bSByYWlkOiByZW1vdmUgdW5uZWNlc3NhcnkgZGlzY2FyZCBsaW1pdHMgZm9yIHJhaWQxMCIiKQo+
IEZpeGVzOiBlMDkxMGM4ZTRmODcgKCJkbSByYWlkOiBmaXggZGlzY2FyZCBsaW1pdHMgZm9yIHJh
aWQxIGFuZCByYWlkMTAiKQo+IENjOiBzdGFibGVAdmdlcixrZXJuZWwub3JnICMgZTA5MTBjOGU0
Zjg3IHdhcyBtYXJrZWQgZm9yIHN0YWJsZUAKPiBTaWduZWQtb2ZmLWJ5OiBNaWtlIFNuaXR6ZXIg
PHNuaXR6ZXJAcmVkaGF0LmNvbT4KClJldmlld2VkLWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwu
b3JnPgoKPiAtLS0KPiBkcml2ZXJzL21kL21kLmggfCA0ICsrLS0KPiAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L21kL21kLmggYi9kcml2ZXJzL21kL21kLmgKPiBpbmRleCAyMTc1YTVhYzRmN2MuLmJiNjQ1YmMz
YmE2ZCAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL21kL21kLmgKPiArKysgYi9kcml2ZXJzL21kL21k
LmgKPiBAQCAtMzExLDcgKzMxMSw3IEBAIHN0cnVjdCBtZGRldiB7Cj4gCWludAkJCQlleHRlcm5h
bDsJLyogbWV0YWRhdGEgaXMKPiAJCQkJCQkJICogbWFuYWdlZCBleHRlcm5hbGx5ICovCj4gCWNo
YXIJCQkJbWV0YWRhdGFfdHlwZVsxN107IC8qIGV4dGVybmFsbHkgc2V0Ki8KPiAtCWludAkJCQlj
aHVua19zZWN0b3JzOwo+ICsJdW5zaWduZWQgaW50CQkJY2h1bmtfc2VjdG9yczsKPiAJdGltZTY0
X3QJCQljdGltZSwgdXRpbWU7Cj4gCWludAkJCQlsZXZlbCwgbGF5b3V0Owo+IAljaGFyCQkJCWNs
ZXZlbFsxNl07Cj4gQEAgLTMzOSw3ICszMzksNyBAQCBzdHJ1Y3QgbWRkZXYgewo+IAkgKi8KPiAJ
c2VjdG9yX3QJCQlyZXNoYXBlX3Bvc2l0aW9uOwo+IAlpbnQJCQkJZGVsdGFfZGlza3MsIG5ld19s
ZXZlbCwgbmV3X2xheW91dDsKPiAtCWludAkJCQluZXdfY2h1bmtfc2VjdG9yczsKPiArCXVuc2ln
bmVkIGludAkJCW5ld19jaHVua19zZWN0b3JzOwo+IAlpbnQJCQkJcmVzaGFwZV9iYWNrd2FyZHM7
Cj4gCj4gCXN0cnVjdCBtZF90aHJlYWQJCSp0aHJlYWQ7CS8qIG1hbmFnZW1lbnQgdGhyZWFkICov
Cj4gLS0gCj4gMi4xNS4wCj4gCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

