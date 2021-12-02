Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A79C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 07:28:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-J8mclMrbPZqli-ikz_OcVQ-1; Fri, 03 Dec 2021 02:28:54 -0500
X-MC-Unique: J8mclMrbPZqli-ikz_OcVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DBE485B6C0;
	Fri,  3 Dec 2021 07:28:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79AB74ABAD;
	Fri,  3 Dec 2021 07:28:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BBF531809CB8;
	Fri,  3 Dec 2021 07:28:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2ENXtJ026852 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 09:23:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F3501402408; Thu,  2 Dec 2021 14:23:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 192921402406
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 14:23:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F217E106655F
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 14:23:32 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com
	(mail-mw2nam08on2047.outbound.protection.outlook.com [40.107.101.47])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-242-xnh1oZBnO2ej4hV8qejnFg-1; Thu, 02 Dec 2021 09:23:29 -0500
X-MC-Unique: xnh1oZBnO2ej4hV8qejnFg-1
Received: from SA1PR06MB8198.namprd06.prod.outlook.com (2603:10b6:806:1dd::6)
	by SA1PR06MB8227.namprd06.prod.outlook.com (2603:10b6:806:1c6::12)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22;
	Thu, 2 Dec 2021 14:23:26 +0000
Received: from SA1PR06MB8198.namprd06.prod.outlook.com
	([fe80::c96b:32af:94c3:118c]) by
	SA1PR06MB8198.namprd06.prod.outlook.com
	([fe80::c96b:32af:94c3:118c%8]) with mapi id 15.20.4734.024;
	Thu, 2 Dec 2021 14:23:26 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
Thread-Topic: [dm-devel] [PATCH resend] multipath-tools: delete duplicate RDAC
	maintainer entries
Thread-Index: AQHX51Is5y//U93liE2y4CH3Ea6nnKwfJTwAgAAZq0A=
Date: Thu, 2 Dec 2021 14:23:26 +0000
Message-ID: <SA1PR06MB8198B615586A2698D7E72BBE8C699@SA1PR06MB8198.namprd06.prod.outlook.com>
References: <20211201223518.3775-1-xose.vazquez@gmail.com>
	<20211201223518.3775-2-xose.vazquez@gmail.com>
	<dd47410226f48d3fc3851a10a12cb89854e6ac8c.camel@suse.com>
	<7514be21-8209-f3ab-2d83-4f8639e53458@gmail.com>
In-Reply-To: <7514be21-8209-f3ab-2d83-4f8639e53458@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66eb3848-312a-482d-70ac-08d9b59f4e40
x-ms-traffictypediagnostic: SA1PR06MB8227:
x-microsoft-antispam-prvs: <SA1PR06MB8227DCB242B9121F3FCE37D58C699@SA1PR06MB8227.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: /2Vc35zVNPRcl0Jlxb9kefuVOOvfl+i3S49MAFHFFve4XjszSG1Pz0YGMHowg4OYESPDFFO8tRnxpGyUDV06cm6/Au3/23oDUeeifM/D2KAbcKY7PqTgl088iAS/NuOWmiYA3KiXMQ0QaHcQz8vKt8JAC6iBMwA11CDon0o1Q7iyCLY4teOYcuGwTlUdxvYmMAWj6P4igJxymPadOVVs9SO9I4s91053r1tvmDtWilbRZHacHVcPZszY+CoIlL4nIN+d0ixOkMahOuBE30kg31x4Idma+XFieYjNeW57Mcv427sQLnPfcxeqX+SWWKDjh+89snXa4+hCfcEHbohtg06sXPEEbGNVsG/1nK9L2yh5TKd1B9u6Ys9LTYtD3Lq2x311pPRNln7N9BvX3i15Uj4BauOhxlC/Il5wHS6BHF/qSAtT0MioP5x9gPCMKm6yEqWpc4qYsx49qI9AvuFILx8Dj4/Ravt5O//d2YSsN64czUiyE3PFhlzc2yjXsJW8ZDVcVlc8OKIr4DSyGEToRI7gZhnxu/eAN1F9UV5m7r4lc/+cqhQ1vcUy9kDiHIrQwAFuQqaxAxC8z/3G/IFdu1SadoehhCdvi2ZPNSvNCojVLoSG86tg3hdpFCP2u2RhKRGgOS7pVtydP5OH9zZvOfUlatwyyK7HASrIdURwu8uT43lQPi7wL8C0EXzIl9AyN5GgSwhvLH2Xp6gIr6UjLg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SA1PR06MB8198.namprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(33656002)(53546011)(7696005)(71200400001)(122000001)(186003)(66476007)(64756008)(66446008)(66556008)(26005)(66946007)(76116006)(4744005)(38100700002)(54906003)(4326008)(508600001)(8676002)(316002)(8936002)(5660300002)(55016003)(86362001)(6506007)(52536014)(38070700005)(110136005)(107886003)(9686003)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sm5DeVVzNGxpaHpNamo1WEpnajZIaytEL2Y0a0RTWVVUTWx2THF4dkVUSks0?=
	=?utf-8?B?bUNUVkFIMFV5TlhtQnBPV2tTK21TV2VMOFpWMVIydkNzWmp4S3hPeGd3Mm9T?=
	=?utf-8?B?bkVEUXVSaTJ5WDRSSkNKUjRwdldhWVJPM3hQV2F1MkVSekRaSW9FN3dWVGx6?=
	=?utf-8?B?aG00bmZWNUtrZEJPME9xdjVUUDMwdisraTVnWDlWTzFLVk5Ec09SWjI4dXdJ?=
	=?utf-8?B?ZzZUVjY3Z1NBNEM3RXZyU1RkblJEc2tmbVpaRkpIY1hBZ1UwYTdPamRrbENv?=
	=?utf-8?B?T1BhbExxaGVtaDVvUmhiUW1lYlJYYVZGN0I4VGFCalU2aTlneGN1ZngzNTUv?=
	=?utf-8?B?OHBEaHlWb2JhVmVpb2FkcUQxTnVBQkNTZWpzcENmU2l2cmFvZHpKMVpiVlA0?=
	=?utf-8?B?TGpjWEVBMEdLY1dZRWlZNUh6OUFUNTVzLzlTenl5a1NpMW54OUlkS01wWHo3?=
	=?utf-8?B?ekdacnlPTzVoTm83WmtBWTREWVRPcWRGZm92OHk3Snh2QU5wMVNwQzNHYklY?=
	=?utf-8?B?TGpDQVNjQlhFR0phMERucXRpM2kvRVRxUGNBbUFqSVd5OW4wWFdlV014N01L?=
	=?utf-8?B?UkVOT2QzcmRsdExBQ011OUVzRjJWTXJ6SEF0RGx0QitiaGpzdE5VK0FwSHVB?=
	=?utf-8?B?MHVYbDRnL09ubUd5QmJlbjFlc1ZoMFdVUzRDUmVjd2lyelBRbnpYaFBuZWF3?=
	=?utf-8?B?Z1hZYlZwOCtoUEVjdHdVTnlhc1BzWHQ2a3dUSXRRZTZmNURpMmVOcnNjQ2t4?=
	=?utf-8?B?TnhUWklWOXUzKzZDdmtuVjEwbUc4UjVnRjloM0tlamQ2OE1oK09nSTJDN2Jn?=
	=?utf-8?B?bEk0VElmODl4d2pMU1RkcmxLUDgwSDdkUTZITHcwZ0NRWDkzL3YzbG9IK1Yv?=
	=?utf-8?B?VDZBLzVQNEdkZWJQUXE2Sm12aGdJcVUzRnk0NTB3KzJjU1NMOFZmWDZPbTR2?=
	=?utf-8?B?aDlmWDlCQVZROXMxVk9FWkZYOExhdTd1ZmVvL2ExbG9LOUxZQ1g5VXFDRWc2?=
	=?utf-8?B?akl3cFd2a3hXNU1VZG5HQ1d2cnkwTCtzZTh6WllnaUNEYmE3N3RnSGEvWGRW?=
	=?utf-8?B?OXZwYi84SWxpOTUvU21xcGdGT3JlWjh5SDUyY2t2RlRDaXZDZVJnVnJkUEFw?=
	=?utf-8?B?Q0pTSW5HdTBmYnl6VVU0WXRXdFF3YWIyck9KWi9IL0oyLzFtNmFVWEJDSmN1?=
	=?utf-8?B?Y2hqVWRNd0dFOFYyUlE0K3k5NzRzRFJma1dHbklFdk5ZWXZVb3R2Nmx2TzhE?=
	=?utf-8?B?ZHY2TTQ2Skd6TGFiaTlLZDVlMVRVazdpZlFEUG5nNEN0OVVsVStFejJXbzJo?=
	=?utf-8?B?WWtaQjNVaUZ5TVhrZlJOYmFNRzR0MkYrKzVYRGtSZUorN0J5N1JaRGtpUmNi?=
	=?utf-8?B?bzlqNmdUSFRlb1gzZnlLMHd6R09hL3BUQmF5VWdUZUhLYXlFSzNFbGx4Nmxa?=
	=?utf-8?B?dktpY3VYc3dxMk5MZHArN1B4QXo0VTgwdWgwREQ5UmQ5V3diNDNxU0xyWjY2?=
	=?utf-8?B?djhDckJWTFk3NzFFL1grVEFMV2xJWjhCT3lmM3JkYks1Nm93TEd6ZEo3cjhU?=
	=?utf-8?B?TXQvR05CRFZaTnRLZkRuUkt6NG1qWlFJVzJLcGZQV09FMHk5b0hRY2xRL0t2?=
	=?utf-8?B?aUtwS3BnQ2o5bWZkNUhmdGdyOWJhVDBDTmNSaUVCenQxWFB1ZTBaMStaVmto?=
	=?utf-8?B?RnA5V0RLWVIvcUJpVU9yUlc0VUk2OTBaTS9WVUZSN2hZczQrMVMvVzJxaXBI?=
	=?utf-8?B?ZnVtMUJ1cCtwUUxCSUtEQWhkZmJ3R2RhYm54WmZ5R3ZnZVpVclRhRlpMbVNx?=
	=?utf-8?B?UnRsWXNEOTNDK0xwSlhQN240TmhLQWtubXhXS1A3a1hWcnJoaVFqZE9sWTZD?=
	=?utf-8?B?b2hDdTBxeEsydGJyRDV3QnZMazBlNk1VcTR3dWdpWjQyZ2ltbDNGeURmNWlo?=
	=?utf-8?B?bTdvWWpoVUFiM0pPSjc3a0NqeHVWdkY4cTBWSUJuMEd2WTgvZ0JvYkZLWEJz?=
	=?utf-8?B?RFhyQnQ2MHFYeEtveFFGTGpQb2hmNFo2bE9UVkM0Q1p6R1ZhUVhnT2dTUmcv?=
	=?utf-8?B?eHBxa25wWk52WDVxSnMyc1FNa3pYU0xYOUpTbUVBTXRIR0F6enpBNzVreUVn?=
	=?utf-8?B?c2NQaVE0VXppK25uYjJsWjJ4bnB1R3NWZDN2dU1LbWpTZHpaWTFiallPMll3?=
	=?utf-8?B?Z1E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR06MB8198.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66eb3848-312a-482d-70ac-08d9b59f4e40
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 14:23:26.6152 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SAofyTLGZ/6xxuUOi7UTqrS3aM24qJYzy6q8dug8T8Ej6InJ/QOY3aF3cY2ti7jeMmttmqK6GjnMioBHL5ujuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR06MB8227
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B2ENXtJ026852
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 03 Dec 2021 02:28:43 -0500
Cc: DM-DEVEL ML <dm-devel@redhat.com>, "Schremmer,
	Steven" <Steve.Schremmer@netapp.com>, ng-eseries-upstream-maintainers
	<ng-eseries-upstream-maintainers@netapp.com>
Subject: Re: [dm-devel] [PATCH resend] multipath-tools: delete duplicate
 RDAC maintainer entries
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBGcm9tOiBYb3NlIFZhenF1ZXogUGVyZXogPHhvc2UudmF6cXVlekBnbWFpbC5jb20+Cj4gU2Vu
dDogVGh1cnNkYXksIERlY2VtYmVyIDIsIDIwMjEgNjo0MiBBTQo+IAo+IE9uIDEyLzIvMjEgMDg6
NTYsIE1hcnRpbiBXaWxjayB3cm90ZToKPiAKPiA+Cj4gPiBJJ2QgbGlrZSB0byBoYXZlIHRoaXMg
YWNrZWQgYnkgTmV0YXBwIGJlZm9yZSBtZXJnaW5nIGl0LiBBY3R1YWxseSwgSSdkCj4gPiBwcmVm
ZXIgdG8gaGF2ZSBpdCBhY2tlZCBieSBGdWppdHN1IGFuZCBMZW5vdm8sIHRvbywgYnV0IHdlIGRv
bid0IGhhdmUKPiA+IGNvbnRhY3QgYWRkcmVzc2VzIGZvciB0aGVtLCBzbyBiZSBpdC4KPiA+Cj4g
PiBNeSDigqwwLjAyOiBJJ2QgcmF0aGVyIG5vdCBoYXZlIHRoaXMsIGJlY2F1c2UgaXQncyBub3Qg
b2J2aW91cyB0bwo+ID4gZXZlcnlib2R5IHRoYXQgdGhlc2UgYXJyYXlzIGFyZSBhY3R1YWxseSBO
ZXRhcHAgc3lzdGVtcyBhbmQgYXJlIHRodXMKPiA+IG1haW50YWluZWQgbm90IGJ5IHRoZWlyIHZl
bmRvcnMgYnV0IE5ldGFwcC4KPiAKPiBUaGVyZSBhcmUgMjUgUkRBQyBhcnJheXMgaW4gaHd0YWJs
ZSwgb25seSB0d28gb2YgdGhlbSh0aG9zZSBpbmNsdWRlZCBpbgo+IHRoZSBwYXRjaCkgYW5kIHRo
ZSBOZXRBcHAgb25lIGhhdmUgYSAiTWFpbnRhaW5lciIgZW50cnkuCj4gQW5kIHRoZXkgY2FuIGVh
c2lseSBpZGVudGlmaWVkLCAuY2hlY2tlcl9uYW1lIGFuZCAucHJpb19uYW1lIGFyZSBSREFDLgoK
TmV0QXBwIHdvdWxkIGxpa2UgdGhvc2UgTWFpbnRhaW5lciBlbnRyaWVzIHRvIHJlbWFpbiBpbiB0
aGUgZmlsZSBhcyB3ZSBoYXZlCmFncmVlbWVudHMgd2l0aCBGdWppdHN1IGFuZCBMZW5vdm8gdG8g
aGFuZGxlIGl0IHRoaXMgd2F5LgoKVGhhbmtzLApTdGV2ZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbA==

