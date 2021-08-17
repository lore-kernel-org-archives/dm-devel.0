Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9655CC4320A
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 01:51:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B39960F4B
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 01:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2B39960F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-5dFzcfudPSG5xsA4KT5rbA-1; Mon, 16 Aug 2021 21:51:13 -0400
X-MC-Unique: 5dFzcfudPSG5xsA4KT5rbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94465801AC0;
	Tue, 17 Aug 2021 01:51:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB3B25D6A8;
	Tue, 17 Aug 2021 01:51:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 13D94181A0F8;
	Tue, 17 Aug 2021 01:51:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17H1idcb026917 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Aug 2021 21:44:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A543B201B061; Tue, 17 Aug 2021 01:44:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A017A201B060
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 01:44:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B107185A7A4
	for <dm-devel@redhat.com>; Tue, 17 Aug 2021 01:44:37 +0000 (UTC)
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com
	[68.232.159.87]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-115-FpSEmUpWPxKRHxoay3zJuA-1; Mon, 16 Aug 2021 21:44:34 -0400
X-MC-Unique: FpSEmUpWPxKRHxoay3zJuA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="36751826"
X-IronPort-AV: E=Sophos;i="5.84,327,1620658800"; d="scan'208";a="36751826"
Received: from mail-os2jpn01lp2054.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.54])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 10:44:30 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OS3PR01MB6194.jpnprd01.prod.outlook.com (2603:1096:604:e4::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17;
	Tue, 17 Aug 2021 01:44:27 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb%6]) with mapi id 15.20.4415.023;
	Tue, 17 Aug 2021 01:44:27 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Jane Chu <jane.chu@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
Thread-Index: AQHXhSoSnS/qStIblEyff+FzJU/rBqtlt1aAgBDEPoCAAIiTMA==
Date: Tue, 17 Aug 2021 01:44:26 +0000
Message-ID: <OSBPR01MB292024FD65B5B21716C4CB66F4FE9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
In-Reply-To: <de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a6df821-f31c-4b23-d3ac-08d961208c4f
x-ms-traffictypediagnostic: OS3PR01MB6194:
x-microsoft-antispam-prvs: <OS3PR01MB619482DB1BF8268616E0F6F4F4FE9@OS3PR01MB6194.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wLLEkGThhbiMBszBTNw/HfCDUOKz4Bwp0us8/ongZRjpQyof6RGzqAbR1gQlqQx7HF7rWd2V+tl1Udnkh00KSMV/9xiIpkh1aS8k9qYZb84SLlljeWGmQNpts2m9NOGBT/xGcrOzbmv0CXrVk0EP/4Ww3BIXUoj81EVCKtQsYvEmUL+9OPRCtfE8TFsTauGV33t5pXkzvr54nYpzBKcv376WcVER9k+SGq+PyYHQYYXY6WqwpwD3II2A89m0J4EZlEZxIp4vuKBfq4w47iThGloc1e4D/9MVAE0rc6J6lIujbbzw9WOQaAo0R+QNNxowbUhsA6kWCfsvwozLqVAGjsDUUShXeZTFuoge3oavwUIH3d+eOAfxXwEa8ZlPGQ40Z9twCnowYQBnl6k3nwdB/f+M/PqkxGX6uyO1Qljw+0kOc89sP+mbzBMRH/VAK/GAKEWj7+7KjZh8cbvPBMBAsw+KWLWPBh0sUktK3MAXaz1aWjy1lfAUO36q6AMz4ASJR444vc+OqrGIi1hwLrv9FjcnTTs+L7Ty8NLCd970tY4jEAhNwR41ozRn40bsbH4xpjXMy7TsE5qN8f+CBGyuQee4VCmdVAaA0JiUBxqu7qhroPi/LoSi/9etLEbTDcJ0YE/wH0EA8tB91e7WYDqvu/2jB7Wsv/NLiwpdxf4bCTfnopFTU6DMFCAI2UUwSXbSm3gmt0oyBw8nB8Xmp6BnVw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(8936002)(2906002)(122000001)(38100700002)(478600001)(5660300002)(4326008)(86362001)(186003)(83380400001)(55016002)(71200400001)(52536014)(33656002)(7416002)(7696005)(8676002)(316002)(76116006)(85182001)(66946007)(38070700005)(110136005)(66556008)(66476007)(54906003)(66446008)(64756008)(26005)(9686003)(53546011)(6506007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2M0UW9GQUt1TlRrd3ZOTVhHeGoxSXl2S1R0WktjcUZ0bHdvcCtLMU1MVjBU?=
	=?utf-8?B?OTk4a3hZQTdyUjlDZVpJeitxckZLTk1Lc000YmNwaWJtNnAwYVVtdmFHbXcx?=
	=?utf-8?B?VW1Hd3RremtrRnN0UGxVR0JRb2ltR3RDdGVSeW9POENlczhvRHF2Y2dxaGxr?=
	=?utf-8?B?QVpKbWh2OFJQZHNJYXNKcjJVZWp6Wnp3bmQxbXVFMDRKUmQzQnZrMHR3Vmd6?=
	=?utf-8?B?QlF2QXI3Wk40R253Z3VrYWk0QXR0MmYyYTZKQW5UVmVXUTlOVllNdkVuT3A5?=
	=?utf-8?B?YTNSd2dPQ0c0bFZGOGY1c09ucUhiei93L2pvaXpOMWtsWFZZa1FJRGRIYzFl?=
	=?utf-8?B?ME1taDFSVGplZks0SU5zaHRLSXJla3NMZEZFQnFTR3hGRmxaSFI3cWRyWjdG?=
	=?utf-8?B?R1R4QysrNjZicjJQc29qbm9VSW5XSXNnd3F5MEtzVGNqWFkxV2ZxUno2WmdN?=
	=?utf-8?B?V3FDeThwZEpndU5aN014bDRrcVJtdUVHL0wzaytDZWtGZ29XeDZMRHF0dEtN?=
	=?utf-8?B?WkRnczAvTHlCRHpoaXlpV3A0WVF0TXFQTmMrNTAxVTlDWVk5TUVHZDN1d1NC?=
	=?utf-8?B?RFNDT2IxbTRoNWx3TmE5Z1B5SkZ1OHo2ZXAxMllsR2ZJSnYxM292MkRoWWxO?=
	=?utf-8?B?ZjBkZ2lhY3B0WlkwOUQ0YVJQaVB5NzZHNnp3SVJ4WmpITlJObElZR011eFRK?=
	=?utf-8?B?Z0tXN0kxWERudG16OW5VZHlWUUljOUZDcFZsUERKc0JkeGZUVGl1QUdqRFR2?=
	=?utf-8?B?cThwS3RYdDNsWFZUYjBGNWdzRTFLazBOUkp2ditIN1JaS3ZzZHh0UTZrc2li?=
	=?utf-8?B?OHNaUWQ4Y1JmeFFZY0RJYkJrN1RUZFlIS3NpNWlVZUt4Ym1tU3FvNFBIYjlU?=
	=?utf-8?B?WmovRFAycy9GM3IrQjA3b05JeDJLYjFwYzZxS1c4S3BXRjJCK28yRjZxanFh?=
	=?utf-8?B?WTlod3dhMGtRYVUxSHdPWHlLYkY5SUZwU0w3Z3k0WTN3aFZ2L1BhSkI2eVZH?=
	=?utf-8?B?YjBIbjNDMlFkSloyMkJFeXpvUlE2QjBIb3dnYml0bUZSemJVTWl6TFZ6MWRt?=
	=?utf-8?B?N1ZYQWhoRzN2SnVEdnQ3MjVlUnc1VzhKMlZNY3dML2lOWG5aaitOR2JCWkRB?=
	=?utf-8?B?TFN0VWhoNTBIUlpleEhYZGZiTE5Pdm5CeEk4QTRjRzlLM2xrZ3VlSGUyRzl3?=
	=?utf-8?B?enN3WE4zbjdUa1M1ajk2eUhjWmRua3g4cnhqRGZlWGM4OUlRTTJJc0xBYUlp?=
	=?utf-8?B?T2pwUWkyM3NqaFJPc1VzU085bjB0UnNTdWxjeFVIN3FyM1ArUWFIMHg1YVlw?=
	=?utf-8?B?YjVjZEJlMkZIUHBoalB4QnhwcGRveXloZDc2UXhrY0JiNzN3andzS1BzM1ZV?=
	=?utf-8?B?enF1aUs5ajZvRDF0QUV4alZFQXVISlF2WWFDUjBXUUxCamxmdUE1UUM4NkpP?=
	=?utf-8?B?QXdrWFF1S2hXbUw0R1RGcHFLVUZCWWxvUWRaYUtaeFpRaHRJSEo3Qk0yQncv?=
	=?utf-8?B?MFRTekt0QXRBWHlvaHBMWU5SMVNOM0VQZWJIQm9iMUZORzgvZEZRNnZFMVYx?=
	=?utf-8?B?NmN2LzZ6UVJJL1YvNExLeUJpcFVBTDdqa3dCdExkZHhEWUk2bGc5Ukt1ekFS?=
	=?utf-8?B?bWZmdXJmRFZzdDFDNzV6dmU3NHo4OHNpbUlncjNzRGorVHRiQmlYNEcyWU5x?=
	=?utf-8?B?RWZjZHVsT1ZxZXloUkFmWElEenNXQWljdjhsY0F3VUNmNDNKMXp2VEY5UDZt?=
	=?utf-8?Q?oMaQH4zyP/m2wInazQ=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6df821-f31c-4b23-d3ac-08d961208c4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 01:44:27.0085 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R16RznhLDeaqjndQkbsAyrMW+Cl4XpbX33QheYAEkOg0Zt0M8vjtqD9wmqrJYTVIHyaqLSIdZPWgg/TXI4KHug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6194
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17H1idcb026917
X-loop: dm-devel@redhat.com
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
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
Content-Language: zh-CN
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQo+IEZyb206IEphbmUgQ2h1IDxqYW5lLmNodUBv
cmFjbGUuY29tPgo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggUkVTRU5EIHY2IDEvOV0gcGFnZW1hcDog
SW50cm9kdWNlIC0+bWVtb3J5X2ZhaWx1cmUoKQo+IAo+IEhpLCBTaGlZYW5nLAo+IAo+IFNvIEkg
YXBwbGllZCB0aGUgdjYgcGF0Y2ggc2VyaWVzIHRvIG15IDUuMTQtcmMzIGFzIGl0J3Mgd2hhdCB5
b3UgaW5kaWNhdGVkIGlzIHdoYXQKPiB2NiB3YXMgYmFzZWQgYXQsIGFuZCBpbmplY3RlZCBhIGhh
cmR3YXJlIHBvaXNvbi4KPiAKPiBJJ20gc2VlaW5nIHRoZSBzYW1lIHByb2JsZW0gdGhhdCB3YXMg
cmVwb3J0ZWQgYSB3aGlsZSBhZ28gYWZ0ZXIgdGhlIHBvaXNvbgo+IHdhcyBjb25zdW1lZCAtIGlu
IHRoZSBTSUdCVVMgcGF5bG9hZCwgdGhlIHNpX2FkZHIgaXMgbWlzc2luZzoKPiAKPiAqKiBTSUdC
VVMoNyk6IGNhbmptcD0xLCB3aGljaHN0ZXA9MCwgKioKPiAqKiBzaV9hZGRyKDB4KG5pbCkpLCBz
aV9sc2IoMHhDKSwgc2lfY29kZSgweDQsIEJVU19NQ0VFUlJfQVIpICoqCj4gCj4gVGhlIHNpX2Fk
ZHIgb3VnaHQgdG8gYmUgMHg3ZjY1NjgwMDAwMDAgLSB0aGUgdmFkZHIgb2YgdGhlIGZpcnN0IHBh
Z2UgaW4gdGhpcwo+IGNhc2UuCj4gCj4gU29tZXRoaW5nIGlzIG5vdCByaWdodC4uLgoKSGkgSmFu
ZSwKClNvcnJ5IGZvciBsYXRlIHJlcGx5LiAgVGhhbmtzIGZvciB0ZXN0aW5nLiAgVGhpcyBhZGRy
ZXNzIHNob3VsZCBoYXZlIGJlZW4gcmVwb3J0ZWQgaW4gbXkgY29kZS4gSSdsbCBjaGVjayB3aHkg
aXQncyBmaW5hbGx5IG5pbC4KCgotLQpUaGFua3MuClJ1YW4uCgo+IAo+IHRoYW5rcywKPiAtamFu
ZQo+IAo+IAo+IE9uIDgvNS8yMDIxIDY6MTcgUE0sIEphbmUgQ2h1IHdyb3RlOgo+ID4gVGhlIGZp
bGVzeXN0ZW0gcGFydCBvZiB0aGUgcG1lbSBmYWlsdXJlIGhhbmRsaW5nIGlzIGF0IG1pbmltdW0g
YnVpbHQKPiA+IG9uIFBBR0VfU0laRSBncmFudWxhcml0eSAtIGFuIGluaGVyaXRhbmNlIGZyb20g
Z2VuZXJhbCBtZW1vcnlfZmFpbHVyZQo+ID4gaGFuZGxpbmcuwqAgSG93ZXZlciwgd2l0aCBJbnRl
bCdzIERDUE1FTSB0ZWNobm9sb2d5LCB0aGUgZXJyb3IgYmxhc3QKPiA+IHJhZGl1cyBpcyBubyBt
b3JlIHRoYW4gMjU2Ynl0ZXMsIGFuZCBtaWdodCBnZXQgc21hbGxlciB3aXRoIGZ1dHVyZQo+ID4g
aGFyZHdhcmUgZ2VuZXJhdGlvbiwgYWxzbyBhZHZhbmNlZCBhdG9taWMgNjRCIHdyaXRlIHRvIGNs
ZWFyIHRoZSBwb2lzb24uCj4gPiBCdXQgSSBkb24ndCBzZWUgYW55IG9mIHRoYXQgY291bGQgYmUg
aW5jb3Jwb3JhdGVkIGluLCBnaXZlbiB0aGF0IHRoZQo+ID4gZmlsZXN5c3RlbSBpcyBub3RpZmll
ZCBhIGNvcnJ1cHRpb24gd2l0aCBwZm4sIHJhdGhlciB0aGFuIGFuIGV4YWN0Cj4gPiBhZGRyZXNz
Lgo+ID4KPiA+IFNvIEkgZ3Vlc3MgdGhpcyBxdWVzdGlvbiBpcyBhbHNvIGZvciBEYW46IGhvdyB0
byBhdm9pZCB1bm5lY2Vzc2FyaWx5Cj4gPiByZXBhaXJpbmcgYSBQTUQgcmFuZ2UgZm9yIGEgMjU2
QiBjb3JydXB0IHJhbmdlIGdvaW5nIGZvcndhcmQ/Cj4gPgo+ID4gdGhhbmtzLAo+ID4gLWphbmUK
PiA+Cj4gPgo+ID4gT24gNy8zMC8yMDIxIDM6MDEgQU0sIFNoaXlhbmcgUnVhbiB3cm90ZToKPiA+
PiBXaGVuIG1lbW9yeS1mYWlsdXJlIG9jY3Vycywgd2UgY2FsbCB0aGlzIGZ1bmN0aW9uIHdoaWNo
IGlzCj4gPj4gaW1wbGVtZW50ZWQgYnkgZWFjaCBraW5kIG9mIGRldmljZXMuwqAgRm9yIHRoZSBm
c2RheCBjYXNlLCBwbWVtIGRldmljZQo+ID4+IGRyaXZlciBpbXBsZW1lbnRzIGl0LsKgIFBtZW0g
ZGV2aWNlIGRyaXZlciB3aWxsIGZpbmQgb3V0IHRoZQo+ID4+IGZpbGVzeXN0ZW0gaW4gd2hpY2gg
dGhlIGNvcnJ1cHRlZCBwYWdlIGxvY2F0ZWQgaW4uwqAgQW5kIGZpbmFsbHkgY2FsbAo+ID4+IGZp
bGVzeXN0ZW0gaGFuZGxlciB0byBkZWFsIHdpdGggdGhpcyBlcnJvci4KPiA+Pgo+ID4+IFRoZSBm
aWxlc3lzdGVtIHdpbGwgdHJ5IHRvIHJlY292ZXIgdGhlIGNvcnJ1cHRlZCBkYXRhIGlmIG5lY2Vz
c2FyeS4KPiA+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

