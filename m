Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10043C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:45:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 955EF6139A
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 955EF6139A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-jjKHLbciO5qxSJnlM1tsGw-1; Wed, 19 May 2021 03:44:58 -0400
X-MC-Unique: jjKHLbciO5qxSJnlM1tsGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2027F100747C;
	Wed, 19 May 2021 07:44:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBC152E181;
	Wed, 19 May 2021 07:44:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BC3AA55353;
	Wed, 19 May 2021 07:44:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J7i3Pi023023 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 03:44:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 05D5121EC5E7; Wed, 19 May 2021 07:44:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 001F421EC5E6
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:44:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9807F857D08
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:44:00 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-387-9wfFpU04NayEvHUHw8TmTQ-1; Wed, 19 May 2021 03:43:56 -0400
X-MC-Unique: 9wfFpU04NayEvHUHw8TmTQ-1
IronPort-SDR: eZ0QUX+NfQADNdlxQq1aEFK66GbCnU2ZG3i/M2yDlGSVjjtpATb/bmcDZhwwp92xf3BPFK3D/q
	AAVL8cC35YS3nfhgyhUaAfp8lqbQIz07PxB9wpR6pMeNBTqTBTAnDOrlRfYKeuCunUSiEr4Upd
	ik2WMhjnAv8KGiIQ2Pf8de8rhYgZiFGd9Bv/y/zEo6GbcxP+JiPCa+A1VQ5UW5B+V5i+ozQy4t
	FFW1QeAbibXVn7T4Y6atCMWaGPbl2b0PDz8mQgsUnB10fNi506sK6MAeAK9DDPfvuwN5LgrgAd
	y8o=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="169222019"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 15:42:53 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BY5PR04MB6642.namprd04.prod.outlook.com (2603:10b6:a03:21b::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 19 May 2021 07:42:51 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::6873:3d64:8f9f:faf0%7]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 07:42:51 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Thread-Topic: [PATCH 02/11] block: introduce bio zone helpers
Thread-Index: AQHXTFqE8cYwB7GqvU6hvEwRDzkvt6rqbG6S
Date: Wed, 19 May 2021 07:42:50 +0000
Message-ID: <65441A15-23E1-4C5B-A145-8C1EA9ECB251@wdc.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-3-damien.lemoal@wdc.com>,
	<PH0PR04MB7416EC127D2BB9639E82E1579B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
In-Reply-To: <PH0PR04MB7416EC127D2BB9639E82E1579B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.175.137.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 020cdd61-2d9b-4132-c1d0-08d91a99b484
x-ms-traffictypediagnostic: BY5PR04MB6642:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB66420BA6271DB78DF9A5324A862B9@BY5PR04MB6642.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4jkQCMzQXmD0dmWvqFxA0X9dw58Qs/Eu3h0+OLLuxVlLliVXkaBHSIi3WF6R/m4DNGWvZiOAoOyudK+Nqq+9AS++EeT1TW0HlB4gbvty4R1FOJ/FRgqUM//SrtULv4j9nM5I2AtzBk3L7WOXBtWlVhNSdSr0i9v8k3dSC7/1VREGxwc57qaAXN3lYF+d489Mu+dls8jlCFpa+7i+Kb20ee+o8Ux80aP0h28wuUOT/QqIielC+jKBw2exyAFN8edPnePXqPWHOOOjOeTFwP7ogCu29/E4l3u4uu7Juh30aOkQ9ZXOPha7mNSTcpZ2nyBFSggulE8Hin+O9StInd9+t2YJM11nG+8RUWJAZOPPQXBtuhlKaw2wXzih6b1yhnAiuMHSOLJPyfoFGEdDdQp3SxoBy72bezEIptLufSBZIw4UF/XxCI/Y4qTQnObntdzVLaIf5K3LBIcAqV/zd+vMXYs4W4NYQN2XFhlirEhi5nUWH1kVedH/hWNFsQvzd84SxkiOB7heen8hPT2Ec6NEIL5h25o2UiBTlIYXTzdmp1qmtqanjaNbYgcsqc12TASpAgbEXTBl3igjAI9a1SQP9Fy76fqIZRI9N6QJO+mfa9thL6Pl1sJyP0NBZVAXwoaKSxBB4OSa/iJUMtZ0BRDElc8ZjzuThhsgrrtWRibbRSg=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(2906002)(37006003)(316002)(38100700002)(86362001)(6512007)(54906003)(36756003)(6862004)(4326008)(2616005)(26005)(53546011)(6506007)(83380400001)(5660300002)(186003)(33656002)(66946007)(6636002)(66556008)(64756008)(66476007)(66446008)(71200400001)(8676002)(6486002)(8936002)(4744005)(478600001)(122000001)(76116006)(45980500001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?RllJSkwvQXB3d1F2TUZ4R0drTWNTQit2ZDVPOTI0WVJjZ1NsOGFmdk9tVG0r?=
	=?utf-8?B?WXQ2bHh1N0ZmUDcyY0J5ZGRkdHJvWXJzbEMreUR5UEcwaGhUQ2ZoMFlrc3dW?=
	=?utf-8?B?UHpLWlMxK3RVQTdlL3VsSnU4R01XTklKVEtWa1BTWTYyM0w2Z2ZwMFJWZ1NB?=
	=?utf-8?B?QXlNQ0V2RGtaand0SnpESUZETytHay85K0pHS2ZoYzNJMXdJdUs0UllKWUNr?=
	=?utf-8?B?b3ZsMHVGRGtQckhTNTlnREE1ZzdWUDlOSjBMTkJpWUlMTW94b3BFZ2xJT0ZH?=
	=?utf-8?B?a1d6MWVyS3RWd2hxRnV5cERib0JhalpjRElSREJaWTIza3V4aExyK3lMdTlt?=
	=?utf-8?B?NVBiekp1WUJwNzFnWGwrVVlUbU1JcmtlMFh4dHVzZkJBWVJscGtsMnpwUm5T?=
	=?utf-8?B?UkVrVDZzWGZCOTV4aEh0Q0QvVWMxaWMxbDBncVNSMHd4SWJ4TWEzSzhndncz?=
	=?utf-8?B?OEJIOG1jVGxMMnhXaFFtUFJRVE1nVGtVdTk0UTEwSFhyb1ozWjhxajdCcVRX?=
	=?utf-8?B?Nkl2bGEzaUhKTUw0Mkx4N21yckcrVElJdUYzd21pcnFOZDhwU1ZzSDhXeEg2?=
	=?utf-8?B?ZXlMbjNrTzA4Nks5WnlZb1RyZFlrQlFZcUVSSGJ2ajd2Mm1lQUV4bHNlbFV3?=
	=?utf-8?B?dVdValB1a1paU3RRbGU2M3dmbE0yeW94a3FTNjN3ZHRmejNuSnB4RkQ0Wko1?=
	=?utf-8?B?SFN6K1RiSGVOaFpJRzZFNWJNMExRa1htQzFEd2xaL1JHRVdOQnNBYW8xbzJ1?=
	=?utf-8?B?UHJCcGhZLzJWdlozSEdqaWJKMFVoc0pXeDZHaSt1bTFtQmZOVmpJS1NwcHpu?=
	=?utf-8?B?bm5Xd3VvUnJMUkFra3d0b0VScENpZk1vdHVtWjNPYmxnWEFFVXhSYytsUEh5?=
	=?utf-8?B?YVRUeklZS2VyMmZuNGVyQXV2YkkreEM5ZFdpM29hRDhVVVRSZ09ucWt4MHZp?=
	=?utf-8?B?aGZCVWNzdW9qM2h6UEE2TzBGejNBVkFjdlZWaVFNeitic3lEZjlDb2VjTWU4?=
	=?utf-8?B?VnBOTTFSZExOUWhUb2d5c0V3UWhQQnJWbGFReEV4ekRFMzl3YTEyOFM4bEFv?=
	=?utf-8?B?WkVZVHB0bU9CY3lwOW4zSlJ5UGtGaDVjNXZabklJekJnV2dNVEpvZmo2aXhw?=
	=?utf-8?B?QjNNdTFkK3B5ZWRRZ0dBNVlkcDlyNno2MWhEVFgzbXNvVVF1OGd6d3JQakVS?=
	=?utf-8?B?OG9VRzVXUzQ2YlpUcGYwekJvS20rajVyQnZUV0xiZVpHZXMzazZ0b1ExK1BR?=
	=?utf-8?B?dUtQL0YyWTd3Sy83SDBLRnZqRDFFVzRCNXI2SU1xclBKclNLQW9KUmQzU3N2?=
	=?utf-8?B?NXZHTlZQaDFVVE9pMGV3UHNkdmNZcDBtaFhTeUtlTVFMM21JVHByTm1mbVR0?=
	=?utf-8?B?SXl2aERpWDR2THJKbmw3U1BuUnZTbEV3L0txSWhmcnYzelZmQVR1Ulh2UXd0?=
	=?utf-8?B?cWpmTGRzU0VSQUYvbHBDaGFQQ1JLb1ZEWFJTbWY3SzlDUTRtdlNjelJ1Y1Vo?=
	=?utf-8?B?Uml1cFovZm1HZHN0di9ndzNRdDZXNVVFaHg1RHVQS1owTWZlM3BiUnp2dFVQ?=
	=?utf-8?B?RWlFcDdGWHBDbjRLUVowZDRXbXJUMXNnK0hjV2t2VlFXQmlxMWNvNGVMbkR3?=
	=?utf-8?B?cEJqeHdZUzV4eTQ4Y0JnMXJ6c3dHaUxGaExyZ2M4VUFkZ0JQWGFER2JZbFM5?=
	=?utf-8?B?OEdrZlVoVGkvaDBCd21EelRoRmVicGs3SnVCY0NpcTlZdm9xR1dwMXIzdFhE?=
	=?utf-8?Q?KLKH3rIzScWgLRPHZDVnndF0puIEplexEx4egTK?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 020cdd61-2d9b-4132-c1d0-08d91a99b484
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 07:42:50.8244 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PKJEXKQ+t8nqqZwU6+Uk8FZlSw2LWe3w+k/HdgEJHox+Wyeuuol7SYcRxYA7XpGtqLtGvqfctpKLY9zYiU/flldcG/wqbPAd04omQ+SLTNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6642
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J7i3Pi023023
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 02/11] block: introduce bio zone helpers
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgpTZW50IGZyb20gbXkgaVBob25lCgo+IE9uIE1heSAxOSwgMjAyMSwgYXQgMTI6MTcgQU0sIEpv
aGFubmVzIFRodW1zaGlybiA8Sm9oYW5uZXMuVGh1bXNoaXJuQHdkYy5jb20+IHdyb3RlOgo+IAo+
IO+7v09uIDE5LzA1LzIwMjEgMDQ6NTYsIERhbWllbiBMZSBNb2FsIHdyb3RlOgo+PiArc3RhdGlj
IGlubGluZSB1bnNpZ25lZCBpbnQgYmlvX3pvbmVfbm8oc3RydWN0IHJlcXVlc3RfcXVldWUgKnEs
Cj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBiaW8gKmJpbykKPj4gK3sKPj4gKyAg
ICByZXR1cm4gYmxrX3F1ZXVlX3pvbmVfbm8ocSwgYmlvLT5iaV9pdGVyLmJpX3NlY3Rvcik7Cj4+
ICt9Cj4+ICsKPj4gK3N0YXRpYyBpbmxpbmUgdW5zaWduZWQgaW50IGJpb196b25lX2lzX3NlcShz
dHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwKPj4gKyAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0
IGJpbyAqYmlvKQo+PiArewo+PiArICAgIHJldHVybiBibGtfcXVldWVfem9uZV9pc19zZXEocSwg
YmlvLT5iaV9pdGVyLmJpX3NlY3Rvcik7Cj4+ICt9Cj4+ICsKPiAKPiBDYW4ndCB3ZSBkZXJpdmUg
dGhlIHF1ZXVlIGZyb20gdGhlIGJpbyB2aWEgYmlvLT5iaV9iZGV2LT5iZF9kaXNrLT5xdWV1ZQo+
IG9yIHdvdWxkIHRoaXMgYmUgdG9vIG11Y2ggcG9pbnRlciBjaGFzaW5nIGZvciBhIHNtYWxsIGhl
bHBlciBsaWtlIHRoaXM/CgpXZSBoYXZlIG1hZGUgc3VjaCBjb2RlIGNoYW5nZXMgdG8gZ2V0IHJp
ZCBvZiBzZXBhcmF0ZSBhcmd1bWVudCBxIGFuZCBkZXJpdmUgaXQgZnJvbSBiaW8gZm9yIGJsb2Nr
IHRyYWNlIGNsZWFudXAuIFVubGVzcyB0aGVyZSBpcyBhIHN0cm9uZyByZWFzb24gKHN1Y2ggYXMg
cSBpcyBub3QgYXZhaWxhYmxlIGluIHRoaXMgY2FsbCB3aGljaCBJIGhhdmUgbm90IGxvb2tlZCBp
bnRvKSwgd2Ugc2hvdWxkIGF2b2lkIHBhc3NpbmcgcSBhcyBzZXBhcmF0ZSBhcmd1bWVudC4gCgoK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

