Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104E6C433B4
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 08:31:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8CB3B60FE8
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 08:31:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CB3B60FE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-pQfe6apbMqSZaYT3v_J8fw-1; Wed, 19 May 2021 04:31:14 -0400
X-MC-Unique: pQfe6apbMqSZaYT3v_J8fw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74221101962E;
	Wed, 19 May 2021 08:31:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AB775D9CC;
	Wed, 19 May 2021 08:31:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 732C51800FFC;
	Wed, 19 May 2021 08:31:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J8Rn1A027531 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 04:27:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4ABC3AECA5; Wed, 19 May 2021 08:27:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44E2C9C05B
	for <dm-devel@redhat.com>; Wed, 19 May 2021 08:27:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D329E80D0E0
	for <dm-devel@redhat.com>; Wed, 19 May 2021 08:27:46 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-431-lnAvqg-MNAaZjZQrHyl3oA-1; Wed, 19 May 2021 04:27:42 -0400
X-MC-Unique: lnAvqg-MNAaZjZQrHyl3oA-1
IronPort-SDR: Dc8lC+/vKeR3aHLF47efCviR+fMp6Te1+N69+/aLsh1/v00qHZF6nEVo5yb72Jn6xsDK7MCIxq
	iI8+BqjETpsJGeM3ZYE9ikJRkJtqgV00FD3XJljJ4vJ3tgdFkZc5PKlbKPWhnQcMyHoc2POHJI
	I+jG4y/e0nCIPtnQvA+eNFosc1iM2yPpitMKAkgy2lv6gCieuU08Pg5+FRIQBEmnScuJ9AC6Yu
	qAQduNE9ibKLDfnAwBjB+XOD4S5wAh5Y/W3sxCzbdtq1/+w+QO/DM+xTQ1WbU+f9qkYShUnT06
	/pE=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="272623090"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 16:27:42 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB7082.namprd04.prod.outlook.com (2603:10b6:5:24d::23) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25;
	Wed, 19 May 2021 08:27:39 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.032;
	Wed, 19 May 2021 08:27:39 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Johannes Thumshirn
	<Johannes.Thumshirn@wdc.com>
Thread-Topic: [PATCH 02/11] block: introduce bio zone helpers
Thread-Index: AQHXTFpxxhi/R314VUOlDqa3DvnpJQ==
Date: Wed, 19 May 2021 08:27:39 +0000
Message-ID: <DM6PR04MB70815F66C8611016CD579BC6E72B9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-3-damien.lemoal@wdc.com>
	<PH0PR04MB7416EC127D2BB9639E82E1579B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
	<65441A15-23E1-4C5B-A145-8C1EA9ECB251@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:688d:8185:801b:83a0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0308d761-a99d-4677-9483-08d91a9ff721
x-ms-traffictypediagnostic: DM6PR04MB7082:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB7082653D08529B916BDA812DE72B9@DM6PR04MB7082.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KInG5gBRN9gTjmgPdzznkrHxpO2BsAJFKxdQ/uvpe3ixt+9RM2wvsIR4geUnEhor1HLH99V4m8RDnhNeovMHAXsPPoXdXXLAY2g1x3ompPkYA/tmYS8O7ngXc32WJR5lbmf+VmynOCQSlbNz0N+rbF+nynngEhXigmFMTF2fGijUeErbrTTmszKZTt51NRpKe738B72MOZ5/fuUpB4I0LNYcwJgASCQSpYM60Qz0xryObrv05GCvaBrn5mSz3YqVjOmBdkEpFw7GdOpW4SVTRlo5qxhn5Vw2hSr4iDT57K5lKsC4OuRqqpJuXCkpJEE5Y7+DHhApCZUstK45SuUexdIPmVvrLsVe/fo3au/1o0oIwWDswOBNWMXug8nSNt7BAS2Wo0lqS5TOoqnN/N5AVz833eZO1OweQn9jNE7czAuEvkRjwKQPGDYpV0Y3LAvhjM8rxmLVAKmZOF6a9k3w00ipwGQxLQ71+Vad2W3739B4Gqfo5aEsgLuLB7T7yZFYdTSHBq4KERshusicnsNxnKHlw3Rgw7B9ZLRqTKQF4jSUp9+p4PEi77nkZbGX7fBCbZXPM6qmJoK+JU9FhMGZYJ6JZ5i2w2gi/DpEehMFlpU=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(39850400004)(346002)(136003)(366004)(396003)(122000001)(38100700002)(53546011)(83380400001)(86362001)(7696005)(186003)(4744005)(6506007)(33656002)(71200400001)(64756008)(9686003)(6636002)(2906002)(8936002)(55016002)(76116006)(4326008)(478600001)(91956017)(66946007)(66476007)(54906003)(110136005)(52536014)(316002)(5660300002)(66556008)(66446008)(8676002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?utf-8?B?bzRLanhvbytyYUFkL0V1bWRrc0duRXJZaEhSdUQ0bytmRGFWU3VHL01QRGQ5?=
	=?utf-8?B?MHFRVU5rMFZiVU9Rd0tnK0hmTUoySk9mTmgwVzhRelNCeGdNWTNNMjRmd0NI?=
	=?utf-8?B?aUNCMlpFRmxBb2dMZmhoNkJMbU9FYnYveERPYWxrdzk0c21ic2V6Mk1Nekox?=
	=?utf-8?B?NHNXK3lsN0ZVblZWVmpienNtdGxKRzUvaEJKOFVsVjlaem9uMHk0N2tLbUN5?=
	=?utf-8?B?Y2gvTGowSjhZa1JvVEpCSFBaOEdCUjh4dnVMUC9Xbm9nc25WK1EzbFJDVFpT?=
	=?utf-8?B?bThLamhXYVJpSGRrdVZVMTFNQXJ1SzR0YU8vYzdMM2tLdEdPNkpMcjlpOUtN?=
	=?utf-8?B?anZWZVgwdXpKaG9QaXFzQTR0VDZRZzRITzk2V2kzMFczUzNkZDVuTEdjbm5p?=
	=?utf-8?B?WklmYVZWYzArOXlka0Z0bWtKaXZjNHVZa01PcGE2MG4reVh4a1p5Z3R0bGNO?=
	=?utf-8?B?WjlHaFc3SWJ3TVo5dThYWUc3VzdVUk9OcW1vYm1abysxcVFQYUJJOGozVGtC?=
	=?utf-8?B?UU1KNWJnSE0xd1h5R0FYcmY4Sjd3T01jZGp6b1JzVmlxelp2SlVjWmlEVk1y?=
	=?utf-8?B?S1NRTjBXWHB2SDg2UWF1YkVNN3I3Z2NQUzNUSkVXUnJpVE9VbFIyb1JvaEpl?=
	=?utf-8?B?TnRQM29kT0ZQa2EvRXVsZVNBUHZLSXJMYUxRckgrMmtFN0ZUbFVRUFhqYlBH?=
	=?utf-8?B?djllaUtzM0kzeXVRVXhIOTBLTkM1ajRBV0wrYWswbkU0UE05RGRwQ0hoZlk5?=
	=?utf-8?B?Q01RQnpKU2FCWTRLTEVmN2dwdmlnTDdMRTNNRjd1WG5RbW1XcFZzamRQRU14?=
	=?utf-8?B?b0VHblowMUdlWHovRzNwVTV3UWRCTjRtY0RaRlZvTmNZYm1meHlaMXlqREpk?=
	=?utf-8?B?OEd1cEhWOFBTYTNtZDd0VHR3dzJydlBYMVZyQWVVNGloZEhOcmVVQUluNkc3?=
	=?utf-8?B?Q0dtQUlJNVQyVVQrYk5ZQXU0TFFwMUxPc3Y0c2V1VlNnZzBYa1kxWlZqSUl0?=
	=?utf-8?B?RU1ZdVJBanFlamxQQVJHT1JuQmJzY2twQzMyWGF5Z3JIa1RETVpTTmx6NzBD?=
	=?utf-8?B?Q3Qyek9sM2dVaCtkODlpY09zS2gyQ09TSFE0MVk1Z2FBNXVxb3FZTVBKUE9u?=
	=?utf-8?B?WDJoWUVRQVNjV0pjTGlyTHBZQ2NZZzdHbkNZZzBBT05zS0VDOE5Cb0ptTHp5?=
	=?utf-8?B?NnJhMmFobGFKaU45by8zRjVCYkRSL1VKSjhlcEtGVm5jZ1dndFY3YTZuLzJF?=
	=?utf-8?B?VVdaTFQxVitPYk1DQUFZUmx0Qm9NUnQvNitNekc5TTE0aSs4cjlFL0ZHcVlq?=
	=?utf-8?B?dnNQTGZRMmNlUEhSZHZjNXdWR01mMSttRktVeUhpS1NuTUpPV2JSb21uTkhE?=
	=?utf-8?B?RkhnMEE5M04yQWltekpkaDN1UmhyM0sxZ2FrdmU5aXJwcEtsR2R1Qmx5bDlC?=
	=?utf-8?B?dytPQ1NCS2pOUmIzZkl4N0dqY0ZoRWtMczUyaUQzTzhuaTdvNFJOUi9ERUpk?=
	=?utf-8?B?VkdLRlhKYnZVYmhSYjI3KzZEZTIxWWNVaWNKVEZrMXIyNkd4aUttckU2NnhB?=
	=?utf-8?B?T0lOU09yOVRvQjZaRVRabzJId2VGOFFJdVNERDgxd1pBWUlhMmFDb1lza3Ar?=
	=?utf-8?B?OFpjeGozTEpVc2ZCeXpzNDZ4cTBqeTJaamZpTWgyYlFuUVJueUFxRnB6bzlI?=
	=?utf-8?B?NzFUcTRvbngzWWVzRCtsS2FwSUNRVUNlUUd4cXVHOXNCRmxiR1RFU0hPbHZ0?=
	=?utf-8?B?QkdMWXdPSjgvY3pYekZlSGhzRzYzN29qNjd3NGtZOWk5MTVsWVFqcjk4NDVs?=
	=?utf-8?B?dkUreG9JL1ZzZS9KTXc1MmZ6dGkxbWMvdnBQeFVTeFJGSjBXZk8rRks2SXU2?=
	=?utf-8?B?TGtpVlRFempwUmZUcTM5T1pSUXB5UnM4Vm0yN21NQ0M2VkE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0308d761-a99d-4677-9483-08d91a9ff721
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 08:27:39.6323 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KMvCJc9xoE2cnsPLRqOyrF/CUKCgUMN8t8u/rEbh2M0F/hdZaz4iqq7eB/n3bT/fn5ZIk+L4gY0GfD8BRxgxbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7082
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J8Rn1A027531
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMS8wNS8xOSAxNjo0MiwgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOgo+PiBPbiBNYXkg
MTksIDIwMjEsIGF0IDEyOjE3IEFNLCBKb2hhbm5lcyBUaHVtc2hpcm4gPEpvaGFubmVzLlRodW1z
aGlybkB3ZGMuY29tPiB3cm90ZToKPj4KPj4g77u/T24gMTkvMDUvMjAyMSAwNDo1NiwgRGFtaWVu
IExlIE1vYWwgd3JvdGU6Cj4+PiArc3RhdGljIGlubGluZSB1bnNpZ25lZCBpbnQgYmlvX3pvbmVf
bm8oc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsCj4+PiArICAgICAgICAgICAgICAgICAgICAgICBz
dHJ1Y3QgYmlvICpiaW8pCj4+PiArewo+Pj4gKyAgICByZXR1cm4gYmxrX3F1ZXVlX3pvbmVfbm8o
cSwgYmlvLT5iaV9pdGVyLmJpX3NlY3Rvcik7Cj4+PiArfQo+Pj4gKwo+Pj4gK3N0YXRpYyBpbmxp
bmUgdW5zaWduZWQgaW50IGJpb196b25lX2lzX3NlcShzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwK
Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBiaW8gKmJpbykKPj4+ICt7Cj4+PiAr
ICAgIHJldHVybiBibGtfcXVldWVfem9uZV9pc19zZXEocSwgYmlvLT5iaV9pdGVyLmJpX3NlY3Rv
cik7Cj4+PiArfQo+Pj4gKwo+Pgo+PiBDYW4ndCB3ZSBkZXJpdmUgdGhlIHF1ZXVlIGZyb20gdGhl
IGJpbyB2aWEgYmlvLT5iaV9iZGV2LT5iZF9kaXNrLT5xdWV1ZQo+PiBvciB3b3VsZCB0aGlzIGJl
IHRvbyBtdWNoIHBvaW50ZXIgY2hhc2luZyBmb3IgYSBzbWFsbCBoZWxwZXIgbGlrZSB0aGlzPwo+
IAo+IFdlIGhhdmUgbWFkZSBzdWNoIGNvZGUgY2hhbmdlcyB0byBnZXQgcmlkIG9mIHNlcGFyYXRl
IGFyZ3VtZW50IHEgYW5kIGRlcml2ZSBpdCBmcm9tIGJpbyBmb3IgYmxvY2sgdHJhY2UgY2xlYW51
cC4gVW5sZXNzIHRoZXJlIGlzIGEgc3Ryb25nIHJlYXNvbiAoc3VjaCBhcyBxIGlzIG5vdCBhdmFp
bGFibGUgaW4gdGhpcyBjYWxsIHdoaWNoIEkgaGF2ZSBub3QgbG9va2VkIGludG8pLCB3ZSBzaG91
bGQgYXZvaWQgcGFzc2luZyBxIGFzIHNlcGFyYXRlIGFyZ3VtZW50LiAKCldpbGwgZml4IHRoYXQg
aW4gdjIuCgotLSAKRGFtaWVuIExlIE1vYWwKV2VzdGVybiBEaWdpdGFsIFJlc2VhcmNoCgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

