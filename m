Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB58C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 06:30:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-Ne7CZ7CbMOKU6H2O51X4XA-1; Wed, 16 Feb 2022 01:30:12 -0500
X-MC-Unique: Ne7CZ7CbMOKU6H2O51X4XA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 589388143F3;
	Wed, 16 Feb 2022 06:30:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B5736C18F;
	Wed, 16 Feb 2022 06:30:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 05CF05003D;
	Wed, 16 Feb 2022 06:30:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F93kxA005694 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 04:03:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C05AA400E123; Tue, 15 Feb 2022 09:03:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BAADD4010A07
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 09:03:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 856D91C0514E
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 09:03:46 +0000 (UTC)
Received: from APC01-HK2-obe.outbound.protection.outlook.com
	(mail-eopbgr1300132.outbound.protection.outlook.com [40.107.130.132])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-175-sbKrgUKFOEWsRHF2b6zdyQ-1; Tue, 15 Feb 2022 04:03:42 -0500
X-MC-Unique: sbKrgUKFOEWsRHF2b6zdyQ-1
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
	by HK0PR06MB2482.apcprd06.prod.outlook.com (2603:1096:203:6c::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15;
	Tue, 15 Feb 2022 09:03:36 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb]) by
	SL2PR06MB3082.apcprd06.prod.outlook.com
	([fe80::80b4:e787:47a9:41bb%4]) with mapi id 15.20.4975.019;
	Tue, 15 Feb 2022 09:03:35 +0000
From: =?utf-8?B?546L5pOO?= <wangqing@vivo.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Thread-Topic: [PATCH V3 5/13] hid: use time_is_after_jiffies() instead of open
	coding it
Thread-Index: AQHYIg9EnfxyFxjNWkWg98nJO/5UWayUTUWAgAABLl4=
Date: Tue, 15 Feb 2022 09:03:35 +0000
Message-ID: <SL2PR06MB30825E9679FD33F7F8E71075BD349@SL2PR06MB3082.apcprd06.prod.outlook.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
	<1644890154-64915-6-git-send-email-wangqing@vivo.com>
	<AFkA4QAPE2Ol9ndmGVhdHKpl.9.1644914882392.Hmail.wangqing@vivo.com.@PENBTy1od0pKSzV5ZVcrS192THBXVjl0M1RzRWRrMHhDTy1FVHhlSnNYTTJjMTE3SnpOd0BtYWlsLmdtYWlsLmNvbT4=>
In-Reply-To: <AFkA4QAPE2Ol9ndmGVhdHKpl.9.1644914882392.Hmail.wangqing@vivo.com.@PENBTy1od0pKSzV5ZVcrS192THBXVjl0M1RzRWRrMHhDTy1FVHhlSnNYTTJjMTE3SnpOd0BtYWlsLmdtYWlsLmNvbT4=>
Accept-Language: zh-CN, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: cadb0166-f93d-29f7-b7a3-f209084af4ce
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f91fe3ab-97fa-44c3-d80b-08d9f0620cae
x-ms-traffictypediagnostic: HK0PR06MB2482:EE_
x-microsoft-antispam-prvs: <HK0PR06MB2482905E315D173D3EB3B34CBD349@HK0PR06MB2482.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WHJdenequLjlJ752zdjZ57L24J0fYp70RJhGS6PyM5/LMoiNwh9lxJ9kxEXf/LUdeaKfHDBXETTClt7rLr/HAdF3HuY/yi5jbGex4RQf/9KWY9cxbvYSxORL9O/pau4Z9kGl40/NrJTCdp9YWJGEq07BlLzoVnkCQWNHSSPYlzhjrguv67pkq27f6TPcGGkqyaPnHpd8dVgEPI+0U1Xh1RPfL/KZ9HLmopk0kHHa2wl3QaqlnDqEDmLd1WkWyuCPYJAMK1lLNVgcfE8WthJaDZCq6z7DOql9XGWkQqUTsiinu53ljXbLALCPWgd855h7DcK8bopKfn1UoVlMHp+pEsCQReREZGanD1RjpjFyl4NN1ejwYU890Cg7Q54pBc6IxrmiKNKzzoGxA4pST/XZaSoMsannqj8YDA7bdRf486qAIEOeRb0KaSOYUwf5kHTjff8E09Bpk3+1Zh0xRrdassPDY5SAjUcyFFHuFVRA5dVGlND6rwYB6DmT+FpewRctdmkFls8xQcoo7jlSBcYPxYYqeUP9AeoAFSeX2v6XRPiJFnrcN5rTEV8GORU18O4i0RvcB7hoY/wYMn9Eu+uFCoK5W0zOAHaBwVuQJ9bzotdZCv9XnzEnBfZ9hRd0q0WtZNxndSVnChMZHnRhfF4FCW+pH0pt9EJqrWnVlyhPBbrzbGxKWITqDPtELRRREkSW87wBXVZ5mV0HVAIVyHbAQA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SL2PR06MB3082.apcprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(4636009)(366004)(4326008)(122000001)(64756008)(66946007)(7696005)(7406005)(55016003)(508600001)(6506007)(91956017)(5660300002)(9686003)(76116006)(66556008)(66446008)(83380400001)(7416002)(66476007)(86362001)(52536014)(71200400001)(8676002)(8936002)(2906002)(38100700002)(6916009)(85182001)(316002)(33656002)(38070700005)(54906003)(186003)(26005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SU50dlArcGdlOEc4OXFINDRpdDlGdTVVYkg4RlVtWkJoYUxZNW5IL3FNUVNP?=
	=?utf-8?B?cmVQb3c0WXU2UkpqeGhJdjNjYTV3RHJOTDFJQjRCSEt5MjdjWHVKV1V5TUVE?=
	=?utf-8?B?K1BjdzNCUzhxdnBCVkZYRE9KSnY5Q0ZzeGdwTTljeEpwb3NMNTZXRE0rZGRD?=
	=?utf-8?B?Ungxa2VUR3UyTUNSdHFueXlyMXFYemRkakhraFl0am5IaHAzd1VhQnlkbnA5?=
	=?utf-8?B?QnRlTy91R081QzVRd0ZEcTczcXpDbmpiL21vM3NWOXl1NVU1bDR2aFNWdlVS?=
	=?utf-8?B?UDBxV0VhbG5lenV2ZEpuT205K3ZOOUFVL2JKNlI0OUo5SzVuOHpONExEd2x1?=
	=?utf-8?B?NWRMNys4ZkxQQ005bXI1dEtESEZiUGs0dk5hOExpRXF6NkYyVkdxTFJWZ3J1?=
	=?utf-8?B?WXowS2pxdlYwNzU0YXl0bHVFWjhqZDVSS3psclgwdXljRnR0MDFRL2k5Z25C?=
	=?utf-8?B?dmJweGc5aFZSRTVORzBtNUc3Q1hMYnRXSXFxWnMwSndIVWpYRDJvelJPWGNS?=
	=?utf-8?B?cC9yTUVUVzFaODVocXRzNElIVnlsVUdPZmVySUh5Sk5TVVV0eG5oY2dVdi8x?=
	=?utf-8?B?THFuTVpWVWJuNkZ0dStjYmRDdWFWNWh3TVlFRDdveFByc0graWVpNklwRFl6?=
	=?utf-8?B?TGhuTnhRcHR3TmhPY0Yvem5aSFRwZHl5T3NCZnkwZndjTUI1cW9MVThwZ296?=
	=?utf-8?B?bmdoV0FqQ0ZZMVg2MkFGZGZFODdqQXhSU3c5TXRUZVg2VmpBOThaYytpeG5G?=
	=?utf-8?B?OUVFL3NXMXp2UjROV1lINUsyV1VmZDhlbjNFZU1jaFJ3bWJ4c3hISS9UMXZx?=
	=?utf-8?B?c1JyNWFPbWZ1YXNXQnpxbVJ6NVRGZzVrL0Jrb0dlblZOTE1HbENMNU44ZFN5?=
	=?utf-8?B?WUJMRDBHakVQUVAvMHQvQXdSR3YrcU9YYUJXR1RhR1dLV1hPUHQxS2pSVVdC?=
	=?utf-8?B?N0V5R0h5QTRvbWtSQTdRanF1YjlQekt2R1NPVTg1TGlYSCtDMW16QzM5OGdk?=
	=?utf-8?B?aHNJenoxbkp3V0NvS28yenV6cmUzU2hmdkVvQ3NRS1V2OTZHQUhKYk85dTBw?=
	=?utf-8?B?YXA5aFJwcGtLVEVnQ2x6TUNLVTJDdDZJRWlsZWF6RW1wV3cvSGZnQzUxbzdR?=
	=?utf-8?B?b3ZRSXpIcGozUExEWGVlYTYweFE0a3dPdGNlS0MrK2xjL1VTcW5CMU9ndDNw?=
	=?utf-8?B?QzlXNHdTVXVzRjEzWTJkTDZiMDZadjVCVmNkU3dMS0RKZlppeWJ6QjdOSCt0?=
	=?utf-8?B?K1kxRUJkYUlYczY3Q2g3UHJINk5RTG5sOVpFTURoRi9FSmxKL0FiYzBCTmx6?=
	=?utf-8?B?QlpIMlBOVXhzVDIvWnVxUXoxS1hnTzVadVg1ZUFhd2lFUThJQ056R0RCbHJj?=
	=?utf-8?B?ekNicElla0N0enFKWTFVeTJnTnVWMkR2OUxHRmFrTUdsQi9sbnBiSU4wZEJZ?=
	=?utf-8?B?YTZjKy93RWlMY1JZRzBwaHZubzJ1OTI0VUNKTk9ZNHR2TU95aTBuN3FhZ3Ux?=
	=?utf-8?B?Y21CZGNobHFUNE5LdlJleUduMGZxRHRORUp3SG5yalNWSkpDWjFzNWs3NHBx?=
	=?utf-8?B?Y3B0eU1jYUtCdkMxWVdncGZpemx4MnMrT20xd2I4ZzcwY3M3THJMQnpBZmQ3?=
	=?utf-8?B?dncwNDA4ZmVLdmR3ZWIxRHBlQWJ6Y25BcDlEWm9yMmQ3YWFCOU9lVmZaeEcz?=
	=?utf-8?B?cjBoSi91d1hoUUxBSVZ3cTNCRko2MGk5SVkwcDd4MWI2Z3V6ZDVwMkVNNHBn?=
	=?utf-8?B?MDJteGxwSDdEMEE4c2I5czNyd2FsNis3RCtTRnNIWHBxaHhyQnAxY29OWVZE?=
	=?utf-8?B?ODJMb3ZENXNZeHc5UXh5OFpTVmplSG0wbDllVHJHTFgzSExPcjEwRWR3WXNj?=
	=?utf-8?B?V2wxOEZZZjJ5VmlSanZSMWV4MnVNYnBEWGd3T3hTMmNhL2ErRldHSEx1bkQw?=
	=?utf-8?B?NXlPaXlPR0pHdVRjVk5LS01mdmZPaTBSNXBFMzVRTjNKWmhxQ2dXdEF3dFRC?=
	=?utf-8?B?UnY1ZXVWdng0YVhhTk9CYzJIb0tGNmExRGhzTC9zV1lXc0dBN0NyQUFaTHMv?=
	=?utf-8?B?K3JRSUQ5ZUhqNVBQUUtrTWR0RkFpaU5ybU9kUWhqc1dkOXVxOEpzdUJQMmRv?=
	=?utf-8?B?WVJJZEdDdnFDSHBjQmg0NWVXNXVzdHZhS01POWdaYnpYcmFtRmdwRzZvRllr?=
	=?utf-8?B?dmc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f91fe3ab-97fa-44c3-d80b-08d9f0620cae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 09:03:35.8007 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9wH0npR8CluoPGqmP2HJeFXUqq67lGSukIp+nLBWT0mWvc3/bUKXy4rkOv2bNsLCCOZBvjtIrs5GYJoR0Ftwaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2482
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21F93kxA005694
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 16 Feb 2022 01:28:09 -0500
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>, Snitzer <snitzer@redhat.com>,
	David Airlie <airlied@linux.ie>,
	Michael Turquette <mturquette@baylibre.com>,
	Lahtinen <joonas.lahtinen@linux.intel.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Joonas, "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "open
	list:HID CORE LAYER" <linux-input@vger.kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mike, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Jiri Kosina <jikos@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
	Torokhov <dmitry.torokhov@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	Alex Deucher <alexander.deucher@amd.com>, Dmitry,
	=?utf-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>,
	=?utf-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH V3 5/13] hid: use time_is_after_jiffies()
 instead of open coding it
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
Content-Language: zh-CN
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

wqAKPj5PbiBUdWUsIEZlYiAxNSwgMjAyMiBhdCAyOjU2IEFNIFFpbmcgV2FuZyA8d2FuZ3FpbmdA
dml2by5jb20+IHdyb3RlOgo+Pgo+PiBGcm9tOiBXYW5nIFFpbmcgPHdhbmdxaW5nQHZpdm8uY29t
Pgo+Pgo+PiBVc2UgdGhlIGhlbHBlciBmdW5jdGlvbiB0aW1lX2lzX3tiZWZvcmUsYWZ0ZXJ9X2pp
ZmZpZXMoKSB0byBpbXByb3ZlCj4+IGNvZGUgcmVhZGFiaWxpdHkuCj4+Cj4+IFNpZ25lZC1vZmYt
Ynk6IFdhbmcgUWluZyA8d2FuZ3FpbmdAdml2by5jb20+Cj4+IEFja2VkLWJ5OiBTcmluaXZhcyBQ
YW5kcnV2YWRhIDxzcmluaXZhcy5wYW5kcnV2YWRhQGxpbnV4LmludGVsLmNvbT4KPgo+RldJVywg
dGhpcyBvbmUgaXMKPkFja2VkLWJ5OiBCZW5qYW1pbiBUaXNzb2lyZXMgPGJlbmphbWluLnRpc3Nv
aXJlc0ByZWRoYXQuY29tPgo+Cj5XYW5nLCBpcyB0aGVyZSBhbnkgcGxhbiB0byB0YWtlIHRoaXMg
c2VyaWVzIHRocm91Z2ggdGhlIHRyaXZpYWwgdHJlZQoKVGhhdCdzIHdoeSBJIGJhdGNoIHRoZW0g
aW4gYSBzZXJpZXMsIGJ1dCBJIGRvbid0IGtub3cgaG93IHRvIHRha2UgCnRoaXMgc2VyaWVzIHRo
cm91Z2ggdGhlIHRyaXZpYWwgdHJlZSBkaXJlY3RseS4KCkkgd291bGQgYXBwcmVjaWF0ZSBpZiB5
b3UgY291bGQgaGVscC4KClRoYW5rcywKV2FuZwoKPm9yIHNob3VsZCBlYWNoIG1haW50YWluZXIg
dGFrZSB0aGUgbWF0Y2hpbmcgcGF0Y2hlcz8KPgo+Q2hlZXJzLAo+QmVuamFtaW4KPgo+PiAtLS0K
Pj7CoCBkcml2ZXJzL2hpZC9pbnRlbC1pc2gtaGlkL2lwYy9pcGMuYyB8IDIgKy0KPj7CoCAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKPj4KPj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvaGlkL2ludGVsLWlzaC1oaWQvaXBjL2lwYy5jIGIvZHJpdmVycy9oaWQvaW50
ZWwtaXNoLWhpZC9pcGMvaXBjLmMKPj4gaW5kZXggOGNjYjI0Ni4uMTVlMTQyMwo+PiAtLS0gYS9k
cml2ZXJzL2hpZC9pbnRlbC1pc2gtaGlkL2lwYy9pcGMuYwo+PiArKysgYi9kcml2ZXJzL2hpZC9p
bnRlbC1pc2gtaGlkL2lwYy9pcGMuYwo+PiBAQCAtNTc4LDcgKzU3OCw3IEBAIHN0YXRpYyB2b2lk
IF9pc2hfc3luY19md19jbG9jayhzdHJ1Y3QgaXNodHBfZGV2aWNlICpkZXYpCj4+wqDCoMKgwqDC
oMKgwqDCoCBzdGF0aWMgdW5zaWduZWQgbG9uZ8KgwqDCoCBwcmV2X3N5bmM7Cj4+wqDCoMKgwqDC
oMKgwqDCoCB1aW50NjRfdMKgwqDCoMKgwqDCoMKgIHVzZWM7Cj4+Cj4+IC3CoMKgwqDCoMKgwqAg
aWYgKHByZXZfc3luYyAmJiBqaWZmaWVzIC0gcHJldl9zeW5jIDwgMjAgKiBIWikKPj4gK8KgwqDC
oMKgwqDCoCBpZiAocHJldl9zeW5jICYmIHRpbWVfaXNfYWZ0ZXJfamlmZmllcyhwcmV2X3N5bmMg
KyAyMCAqIEhaKSkKPj7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47Cj4+
Cj4+wqDCoMKgwqDCoMKgwqDCoCBwcmV2X3N5bmMgPSBqaWZmaWVzOwo+PiAtLQo+PiAyLjcuNAo+
PgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9s
aXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

