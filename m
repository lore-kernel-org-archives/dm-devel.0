Return-Path: <SRS0=zgrO=PK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60558C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 16:31:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C0B49610A4
	for <dm-devel@archiver.kernel.org>; Fri, 22 Oct 2021 16:31:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C0B49610A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-ZDTRHqLWPdikc7YuZElqYg-1; Fri, 22 Oct 2021 12:31:31 -0400
X-MC-Unique: ZDTRHqLWPdikc7YuZElqYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7188110A8E16;
	Fri, 22 Oct 2021 16:31:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B1D55B826;
	Fri, 22 Oct 2021 16:31:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 940994E58F;
	Fri, 22 Oct 2021 16:31:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19MGVEN3030482 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Oct 2021 12:31:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BCCE32166B2D; Fri, 22 Oct 2021 16:31:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B720F2166B25
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 16:31:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6717A1881442
	for <dm-devel@redhat.com>; Fri, 22 Oct 2021 16:31:11 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-435-xwxiwPq9OLqcT2coAX5JPg-1; Fri, 22 Oct 2021 12:31:05 -0400
X-MC-Unique: xwxiwPq9OLqcT2coAX5JPg-1
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HbVBg2v7pz67Nc8;
	Sat, 23 Oct 2021 00:27:55 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Fri, 22 Oct 2021 18:31:02 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.015; Fri, 22 Oct 2021 18:31:02 +0200
From: Roberto Sassu <roberto.sassu@huawei.com>
To: Eric Biggers <ebiggers@kernel.org>, Deven Bowers
	<deven.desai@linux.microsoft.com>
Thread-Topic: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
	fsverity digest and signature
Thread-Index: AQHXwGWUN6BqcPCg3Uma5jdt5usPz6vRLYAAgAMlHYCAAAy0gIAHoD6wgAM9LeA=
Date: Fri, 22 Oct 2021 16:31:02 +0000
Message-ID: <a16a628b9e21433198c490500a987121@huawei.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
	<YWngaVdvMyWBlITZ@gmail.com>
	<5c1f800ba554485cb3659da689d2079a@huawei.com>
In-Reply-To: <5c1f800ba554485cb3659da689d2079a@huawei.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19MGVEN3030482
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
	"paul@paul-moore.com" <paul@paul-moore.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "jannh@google.com" <jannh@google.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"jmorris@namei.org" <jmorris@namei.org>,
	"eparis@redhat.com" <eparis@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-audit@redhat.com" <linux-audit@redhat.com>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>, "serge@hallyn.com" <serge@hallyn.com>
Subject: Re: [dm-devel] [RFC PATCH v7 12/16] fsverity|security: add security
 hooks to fsverity digest and signature
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBGcm9tOiBSb2JlcnRvIFNhc3N1IFttYWlsdG86cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tXQo+
IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciAyMCwgMjAyMSA1OjA5IFBNCj4gPiBGcm9tOiBFcmlj
IEJpZ2dlcnMgW21haWx0bzplYmlnZ2Vyc0BrZXJuZWwub3JnXQo+ID4gU2VudDogRnJpZGF5LCBP
Y3RvYmVyIDE1LCAyMDIxIDEwOjExIFBNCj4gPiBPbiBGcmksIE9jdCAxNSwgMjAyMSBhdCAxMjoy
NTo1M1BNIC0wNzAwLCBEZXZlbiBCb3dlcnMgd3JvdGU6Cj4gPiA+Cj4gPiA+IE9uIDEwLzEzLzIw
MjEgMTI6MjQgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToKPiA+ID4gPiBPbiBXZWQsIE9jdCAxMywg
MjAyMSBhdCAxMjowNjozMVBNIC0wNzAwLAo+ID4gZGV2ZW4uZGVzYWlAbGludXgubWljcm9zb2Z0
LmNvbSB3cm90ZToKPiA+ID4gPiA+IEZyb206IEZhbiBXdSA8d3VmYW5AbGludXgubWljcm9zb2Z0
LmNvbT4KPiA+ID4gPiA+Cj4gPiA+ID4gPiBBZGQgc2VjdXJpdHlfaW5vZGVfc2V0c2VjdXJpdHkg
dG8gZnN2ZXJpdHkgc2lnbmF0dXJlIHZlcmlmaWNhdGlvbi4KPiA+ID4gPiA+IFRoaXMgY2FuIGxl
dCBMU01zIHNhdmUgdGhlIHNpZ25hdHVyZSBkYXRhIGFuZCBkaWdlc3QgaGFzaGVzIHByb3ZpZGVk
Cj4gPiA+ID4gPiBieSBmc3Zlcml0eS4KPiA+ID4gPiBDYW4geW91IGVsYWJvcmF0ZSBvbiB3aHkg
TFNNcyBuZWVkIHRoaXMgaW5mb3JtYXRpb24/Cj4gPiA+Cj4gPiA+IFRoZSBwcm9wb3NlZCBMU00g
KElQRSkgb2YgdGhpcyBzZXJpZXMgd2lsbCBiZSB0aGUgb25seSBvbmUgdG8gbmVlZAo+ID4gPiB0
aGlzIGluZm9ybWF0aW9uIGF0IHRoZcKgIG1vbWVudC4gSVBF4oCZcyBnb2FsIGlzIHRvIGhhdmUg
cHJvdmlkZQo+ID4gPiB0cnVzdC1iYXNlZCBhY2Nlc3MgY29udHJvbC4gVHJ1c3QgYW5kIEludGVn
cml0eSBhcmUgdGllZCB0b2dldGhlciwKPiA+ID4gYXMgeW91IGNhbm5vdCBwcm92ZSB0cnVzdCB3
aXRob3V0IHByb3ZpbmcgaW50ZWdyaXR5Lgo+ID4KPiA+IEkgdGhpbmsgeW91IG1lYW4gYXV0aGVu
dGljaXR5LCBub3QgaW50ZWdyaXR5Pwo+ID4KPiA+IEFsc28gaG93IGRvZXMgdGhpcyBkaWZmZXIg
ZnJvbSBJTUE/ICBJIGtub3cgdGhhdCBJTUEgZG9lc24ndCBzdXBwb3J0IGZzLXZlcml0eQo+ID4g
ZmlsZSBoYXNoZXMsIGJ1dCB0aGF0IGNvdWxkIGJlIGNoYW5nZWQuICBXaHkgbm90IGV4dGVuZCBJ
TUEgdG8gY292ZXIgeW91ciB1c2UKPiA+IGNhc2Uocyk/Cj4gPgo+ID4gPiBJUEUgbmVlZHMgdGhl
IGRpZ2VzdCBpbmZvcm1hdGlvbiB0byBiZSBhYmxlIHRvIGNvbXBhcmUgYSBkaWdlc3QKPiA+ID4g
cHJvdmlkZWQgYnkgdGhlIHBvbGljeSBhdXRob3IsIGFnYWluc3QgdGhlIGRpZ2VzdCBjYWxjdWxh
dGVkIGJ5Cj4gPiA+IGZzdmVyaXR5IHRvIG1ha2UgYSBkZWNpc2lvbiBvbiB3aGV0aGVyIHRoYXQg
c3BlY2lmaWMgZmlsZSwgcmVwcmVzZW50ZWQKPiA+ID4gYnkgdGhlIGRpZ2VzdCBpcyBhdXRob3Jp
emVkIGZvciB0aGUgYWN0aW9ucyBzcGVjaWZpZWQgaW4gdGhlIHBvbGljeS4KPiA+ID4KPiA+ID4g
QSBtb3JlIGNvbmNyZXRlIGV4YW1wbGUsIGlmIGFuIElQRSBwb2xpY3kgYXV0aG9yIHdyaXRlczoK
PiA+ID4KPiA+ID4gwqDCoMKgIG9wPUVYRUNVVEUgZnN2ZXJpdHlfZGlnZXN0PTxIZXhEaWdlc3Qg
PiBhY3Rpb249REVOWQo+ID4gPgo+ID4gPiBJUEUgdGFrZXMgdGhlIGRpZ2VzdCBwcm92aWRlZCBi
eSB0aGlzIHNlY3VyaXR5IGhvb2ssIHN0b3JlcyBpdAo+ID4gPiBpbiBJUEUncyBzZWN1cml0eSBi
bG9iIG9uIHRoZSBpbm9kZS4gSWYgdGhpcyBmaWxlIGlzIGxhdGVyCj4gPiA+IGV4ZWN1dGVkLCBJ
UEUgY29tcGFyZXMgdGhlIGRpZ2VzdCBzdG9yZWQgaW4gdGhlIExTTSBibG9iLAo+ID4gPiBwcm92
aWRlZCBieSB0aGlzIGhvb2ssIGFnYWluc3QgPEhleERpZ2VzdD4gaW4gdGhlIHBvbGljeSwgaWYK
PiA+ID4gaXQgbWF0Y2hlcywgaXQgZGVuaWVzIHRoZSBhY2Nlc3MsIHBlcmZvcm1pbmcgYSByZXZv
Y2F0aW9uCj4gPiA+IG9mIHRoYXQgZmlsZS4KPiA+Cj4gPiBEbyB5b3UgaGF2ZSBhIGJldHRlciBl
eGFtcGxlPyAgVGhpcyBvbmUgaXMgcHJldHR5IHVzZWxlc3Mgc2luY2Ugb25lIGNhbiBnZXQKPiA+
IGFyb3VuZCBpdCBqdXN0IGJ5IGV4ZWN1dGluZyBhIGZpbGUgdGhhdCBkb2Vzbid0IGhhdmUgZnMt
dmVyaXR5IGVuYWJsZWQuCj4gCj4gSSB3YXMgd29uZGVyaW5nIGlmIHRoZSBmb2xsb3dpbmcgdXNl
IGNhc2UgY2FuIGJlIHN1cHBvcnRlZDoKPiBhbGxvdyB0aGUgZXhlY3V0aW9uIG9mIGZpbGVzIHBy
b3RlY3RlZCB3aXRoIGZzdmVyaXR5IGlmIHRoZSByb290Cj4gZGlnZXN0IGlzIGZvdW5kIGFtb25n
IHJlZmVyZW5jZSB2YWx1ZXMgKGluc3RlYWQgb2YgcHJvdmlkaW5nCj4gdGhlbSBvbmUgYnkgb25l
IGluIHRoZSBwb2xpY3kpLgo+IAo+IFNvbWV0aGluZyBsaWtlOgo+IAo+IG9wPUVYRUNVVEUgZnN2
ZXJpdHlfZGlnZXN0PWRpZ2xpbSBhY3Rpb249QUxMT1cKCkxvb2tzIGxpa2UgaXQgd29ya3MuIEkg
bW9kaWZpZWQgSVBFIHRvIHF1ZXJ5IHRoZSByb290IGRpZ2VzdApvZiBhbiBmc3Zlcml0eS1wcm90
ZWN0ZWQgZmlsZSBpbiBESUdMSU0uCgojIGNhdCBpcGUtcG9saWN5CnBvbGljeV9uYW1lPSJBbGxv
d0ZTVmVyaXR5S21vZHVsZXMiIHBvbGljeV92ZXJzaW9uPTAuMC4xCkRFRkFVTFQgYWN0aW9uPUFM
TE9XCkRFRkFVTFQgb3A9S01PRFVMRSBhY3Rpb249REVOWQpvcD1LTU9EVUxFIGZzdmVyaXR5X2Rp
Z2VzdD1kaWdsaW0gYWN0aW9uPUFMTE9XCgpJUEUgc2V0dXA6CiMgY2F0IGlwZS1wb2xpY3kucDdz
ID4gL3N5cy9rZXJuZWwvc2VjdXJpdHkvaXBlL25ld19wb2xpY3kKIyBlY2hvIC1uIDEgPiAgL3N5
cy9rZXJuZWwvc2VjdXJpdHkvaXBlL3BvbGljaWVzL0FsbG93RlNWZXJpdHlLbW9kdWxlcy9hY3Rp
dmUKIyBlY2hvIDEgPiAvc3lzL2tlcm5lbC9zZWN1cml0eS9pcGUvZW5mb3JjZQoKSVBFIGRlbmll
cyBsb2FkaW5nIG9mIGtlcm5lbCBtb2R1bGVzIG5vdCBwcm90ZWN0ZWQgYnkgZnN2ZXJpdHk6CiMg
aW5zbW9kICAvbGliL21vZHVsZXMvNS4xNS4wLXJjMSsva2VybmVsL2ZzL2ZhdC9mYXQua28KaW5z
bW9kOiBFUlJPUjogY291bGQgbm90IGluc2VydCBtb2R1bGUgL2xpYi9tb2R1bGVzLzUuMTUuMC1y
YzErL2tlcm5lbC9mcy9mYXQvZmF0LmtvOiBQZXJtaXNzaW9uIGRlbmllZAoKUHJvdGVjdCBmYXQu
a28gd2l0aCBmc3Zlcml0eToKIyBjcCAvbGliL21vZHVsZXMvNS4xNS4wLXJjMSsva2VybmVsL2Zz
L2ZhdC9mYXQua28gL2ZzdmVyaXR5CiMgZnN2ZXJpdHkgZW5hYmxlIC9mc3Zlcml0eS9mYXQua28K
IyBmc3Zlcml0eSBtZWFzdXJlIC9mc3Zlcml0eS9mYXQua28Kc2hhMjU2OjA3OWJlNmQ4ODYzOGU1
ODE0MWVlMjRiYmE4OTgxMzkxN2M0NGZhYTU1YWRhNGJmNWQ4MDMzNWVmZTE1NDc4MDMgL2ZzdmVy
aXR5L2ZhdC5rbwoKSVBFIHN0aWxsIGRlbmllcyB0aGUgbG9hZGluZyBvZiBmYXQua28gKHJvb3Qg
ZGlnZXN0IG5vdCB1cGxvYWRlZCB0byB0aGUga2VybmVsKToKIyBpbnNtb2QgL2ZzdmVyaXR5L2Zh
dC5rbwppbnNtb2Q6IEVSUk9SOiBjb3VsZCBub3QgaW5zZXJ0IG1vZHVsZSAvZnN2ZXJpdHkvZmF0
LmtvOiBQZXJtaXNzaW9uIGRlbmllZAoKR2VuZXJhdGUgYSBkaWdlc3QgbGlzdCB3aXRoIHRoZSBy
b290IGRpZ2VzdCBhYm92ZSBhbmQgdXBsb2FkIGl0IHRvIHRoZSBrZXJuZWw6CiMgLi9jb21wYWN0
X2dlbiAtaSAwNzliZTZkODg2MzhlNTgxNDFlZTI0YmJhODk4MTM5MTdjNDRmYWE1NWFkYTRiZjVk
ODAzMzVlZmUxNTQ3ODAzIC1hIHNoYTI1NiAtZCB0ZXN0IC1zIC10IGZpbGUgLWYKIyBlY2hvICRQ
V0QvdGVzdC8wLWZpbGVfbGlzdC1jb21wYWN0LTA3OWJlNmQ4ODYzOGU1ODE0MWVlMjRiYmE4OTgx
MzkxN2M0NGZhYTU1YWRhNGJmNWQ4MDMzNWVmZTE1NDc4MDMgPiAvc3lzL2tlcm5lbC9zZWN1cml0
eS9pbnRlZ3JpdHkvZGlnbGltL2RpZ2VzdF9saXN0X2FkZAoKSVBFIGFsbG93cyB0aGUgbG9hZGlu
ZyBvZiBmYXQua286CiMgaW5zbW9kIC9mc3Zlcml0eS9mYXQua28KIwoKUmVnYXJkaW5nIGF1dGhl
bnRpY2l0eSwgbm90IHNob3duIGluIHRoaXMgZGVtbywgSVBFIHdpbGwgYWxzbwplbnN1cmUgdGhh
dCB0aGUgcm9vdCBkaWdlc3QgaXMgc2lnbmVkIChkaWdsaW1fZGlnZXN0X2dldF9pbmZvKCkKcmVw
b3J0cyB0aGlzIGluZm9ybWF0aW9uKS4KClJvYmVydG8KCkhVQVdFSSBURUNITk9MT0dJRVMgRHVl
c3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzCk1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBaaG9u
ZyBSb25naHVhCgo+IERJR0xJTSBpcyBhIGNvbXBvbmVudCBJJ20gd29ya2luZyBvbiB0aGF0IGdl
bmVyaWNhbGx5Cj4gc3RvcmVzIGRpZ2VzdHMuIFRoZSBjdXJyZW50IHVzZSBjYXNlIGlzIHRvIHN0
b3JlIGZpbGUgZGlnZXN0cwo+IGZyb20gUlBNVEFHX0ZJTEVESUdFU1RTIGFuZCB1c2UgdGhlbSB3
aXRoIElNQSwgYnV0Cj4gdGhlIGZzdmVyaXR5IHVzZSBjYXNlIGNvdWxkIGJlIGVhc2lseSBzdXBw
b3J0ZWQgKGlmIHRoZSByb290Cj4gZGlnZXN0IGlzIHN0b3JlZCBpbiB0aGUgUlBNIGhlYWRlciku
Cj4gCj4gRElHTElNIGFsc28gdGVsbHMgd2hldGhlciBvciBub3QgdGhlIHNpZ25hdHVyZSBvZiB0
aGUgc291cmNlCj4gY29udGFpbmluZyBmaWxlIGRpZ2VzdHMgKG9yIGZzdmVyaXR5IGRpZ2VzdHMp
IGlzIHZhbGlkICh0aGUgc2lnbmF0dXJlCj4gb2YgdGhlIFJQTSBoZWFkZXIgaXMgdGFrZW4gZnJv
bSBSUE1UQUdfUlNBSEVBREVSKS4KPiAKPiBUaGUgbWVtb3J5IG9jY3VwYXRpb24gaXMgcmVsYXRp
dmVseSBzbWFsbCBmb3IgZXhlY3V0YWJsZXMKPiBhbmQgc2hhcmVkIGxpYnJhcmllcy4gSSBwdWJs
aXNoZWQgYSBkZW1vIGZvciBGZWRvcmEgYW5kCj4gb3BlblNVU0Ugc29tZSB0aW1lIGFnbzoKPiAK
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC0KPiBpbnRlZ3JpdHkvNDhjZDczN2M1MDRk
NDUyMDgzNzdkYWEyN2Q2MjU1MzFAaHVhd2VpLmNvbS8KPiAKPiBUaGFua3MKPiAKPiBSb2JlcnRv
Cj4gCj4gSFVBV0VJIFRFQ0hOT0xPR0lFUyBEdWVzc2VsZG9yZiBHbWJILCBIUkIgNTYwNjMKPiBN
YW5hZ2luZyBEaXJlY3RvcjogTGkgUGVuZywgWmhvbmcgUm9uZ2h1YQo+IAo+ID4gPiBUaGlzIGJy
aW5ncyBtZSB0byB5b3VyIG5leHQgY29tbWVudDoKPiA+ID4KPiA+ID4gPiBUaGUgZGlnZXN0IGlz
bid0IG1lYW5pbmdmdWwgd2l0aG91dCBrbm93aW5nIHRoZSBoYXNoIGFsZ29yaXRobSBpdCB1c2Vz
Lgo+ID4gPiBJdCdzIGF2YWlsYWJsZSBoZXJlLCBidXQgeW91IGFyZW4ndCBwYXNzaW5nIGl0IHRv
IHRoaXMgZnVuY3Rpb24uCj4gPiA+Cj4gPiA+IFRoZSBkaWdlc3QgaXMgbWVhbmluZ2Z1bCB3aXRo
b3V0IHRoZSBhbGdvcml0aG0gaW4gdGhpcyBjYXNlLgo+ID4KPiA+IE5vLCBpdCdzIG5vdC4KPiA+
Cj4gPiBEaWdlc3RzIGFyZSBtZWFuaW5nbGVzcyB3aXRob3V0IGtub3dpbmcgd2hhdCBhbGdvcml0
aG0gdGhleSB3ZXJlIGNyZWF0ZWQKPiA+IHdpdGguCj4gPgo+ID4gSWYgeW91ciBzZWN1cml0eSBw
b2xpY3kgaXMgc29tZXRoaW5nIGxpa2UgIlRydXN0IHRoZSBmaWxlIHdpdGggZGlnZXN0ICRmb28i
IGFuZAo+ID4gbXVsdGlwbGUgaGFzaCBhbGdvcml0aG1zIGFyZSBwb3NzaWJsZSwgdGhlbiB0aGUg
YWxvcml0aG0gaW50ZW5kZWQgdG8gYmUgdXNlZAo+ID4gbmVlZHMgdG8gYmUgZXhwbGljaXRseSBz
cGVjaWZpZWQuICBPdGhlcndpc2UgYW55IGFsZ29yaXRobSB3aXRoIHRoZSBzYW1lIGxlbmd0aAo+
ID4gZGlnZXN0IHdpbGwgYmUgYWNjZXB0ZWQuICBUaGF0J3MgYSBmYXRhbCBmbGF3IGlmIGFueSBv
ZiB0aGVzZSBhbGdvcml0aG1zIGlzCj4gPiBjcnlwdG9ncmFwaGljYWxseSBicm9rZW4gb3Igd2Fz
IG5ldmVyIGludGVuZGVkIHRvIGJlIGEgY3J5cHRvZ3JhcGhpYwo+IGFsZ29yaXRobQo+ID4gaW4g
dGhlIGZpcnN0IHBsYWNlIChlLmcuLCBhIG5vbi1jcnlwdG9ncmFwaGljIGNoZWNrc3VtKS4KPiA+
Cj4gPiBDcnlwdG9zeXN0ZW1zIGFsd2F5cyBuZWVkIHRvIHNwZWNpZnkgdGhlIGNyeXB0byBhbGdv
cml0aG0ocykgdXNlZDsgdGhlCj4gPiBhZHZlcnNhcnkKPiA+IG11c3Qgbm90IGJlIGFsbG93ZWQg
dG8gY2hvb3NlIHRoZSBhbGdvcml0aG1zLgo+ID4KPiA+IEknbSBub3Qgc3VyZSBob3cgdGhlc2Ug
cGF0Y2hlcyBjYW4gYmUgdGFrZW4gc2VyaW91c2x5IHdoZW4gdGhleSdyZSBnZXR0aW5nCj4gdGhp
cwo+ID4gc29ydCBvZiB0aGluZyB3cm9uZy4KPiA+Cj4gPiA+ID4gPiArCj4gCUZTX1ZFUklUWV9T
SUdOQVRVUkVfU0VDX05BTUUsCj4gPiA+ID4gPiArCQkJCQlzaWduYXR1cmUsIHNpZ19zaXplLCAw
KTsKPiA+ID4gPiBUaGlzIGlzIG9ubHkgZm9yIGZzLXZlcml0eSBidWlsdC1pbiBzaWduYXR1cmVz
IHdoaWNoIGFyZW4ndCB0aGUgb25seSB3YXkgdG8gZG8KPiA+ID4gPiBzaWduYXR1cmVzIHdpdGgg
ZnMtdmVyaXR5LiAgQXJlIHlvdSBzdXJlIHRoaXMgaXMgd2hhdCB5b3UncmUgbG9va2luZyBmb3I/
Cj4gPiA+Cj4gPiA+IENvdWxkIHlvdSBlbGFib3JhdGUgb24gdGhlIG90aGVyIHNpZ25hdHVyZSB0
eXBlcyB0aGF0IGNhbiBiZSB1c2VkCj4gPiA+IHdpdGggZnMtdmVyaXR5PyBJ4oCZbSA5OSUgc3Vy
ZSB0aGlzIGlzIHdoYXQgSeKAmW0gbG9va2luZyBmb3IgYXMgdGhpcwo+ID4gPiBpcyBhIHNpZ25h
dHVyZSB2YWxpZGF0ZWQgaW4gdGhlIGtlcm5lbCBhZ2FpbnN0IHRoZSBmcy12ZXJpdHkga2V5cmlu
Zwo+ID4gPiBhcyBwYXJ0IG9mIHRoZSDigJxmc3Zlcml0eSBlbmFibGXigJ0gdXRpbGl0eS4KPiA+
ID4KPiA+ID4gSXQncyBpbXBvcnRhbnQgdGhhdCB0aGUgc2lnbmF0dXJlIGlzIHZhbGlkYXRlZCBp
biB0aGUga2VybmVsLCBhcwo+ID4gPiB1c2Vyc3BhY2UgaXMgY29uc2lkZXJlZCB1bnRydXN0ZWQg
dW50aWwgdGhlIHNpZ25hdHVyZSBpcyB2YWxpZGF0ZWQKPiA+ID4gZm9yIHRoaXMgY2FzZS4KPiA+
ID4KPiA+ID4gPiBDYW4geW91IGVsYWJvcmF0ZSBvbiB5b3VyIHVzZSBjYXNlIGZvciBmcy12ZXJp
dHkgYnVpbHQtaW4gc2lnbmF0dXJlcywKPiA+ID4gU3VyZSwgc2lnbmF0dXJlcywgbGlrZSBkaWdl
c3RzLCBhbHNvIHByb3ZpZGUgYSB3YXkgdG8gcHJvdmUgaW50ZWdyaXR5LAo+ID4gPiBhbmQgdGhl
IHRydXN0IGNvbXBvbmVudCBjb21lcyBmcm9tIHRoZSB2YWxpZGF0aW9uIGFnYWluc3QgdGhlIGtl
eXJpbmcsCj4gPiA+IGFzIG9wcG9zZWQgdG8gYSBmaXhlZCB2YWx1ZSBpbiBJUEXigJlzIHBvbGlj
eS4gVGhlIHVzZSBjYXNlIGZvciBmcy12ZXJpdHkKPiA+ID4gYnVpbHQtaW4gc2lnbmF0dXJlcyBp
cyB0aGF0IHdlIGhhdmUgYSBydyBleHQ0IGZpbGVzeXN0ZW0gdGhhdCBoYXMgc29tZQo+ID4gPiBl
eGVjdXRhYmxlIGZpbGVzLCBhbmQgd2Ugd2FudCB0byBoYXZlIGEgZXhlY3V0aW9uIHBvbGljeSAo
dGhyb3VnaCBJUEUpCj4gPiA+IHRoYXQgb25seSBfdHJ1c3RlZF8gZXhlY3V0YWJsZXMgY2FuIHJ1
bi4gUGVyZiBpcyBpbXBvcnRhbnQgaGVyZSwgaGVuY2UKPiA+ID4gZnMtdmVyaXR5Lgo+ID4KPiA+
IE1vc3QgdXNlcnMgb2YgZnMtdmVyaXR5IGJ1aWx0LWluIHNpZ25hdHVyZXMgaGF2ZSBhY3R1YWxs
eSBiZWVuIGVuZm9yY2luZyB0aGVpcgo+ID4gc2VjdXJpdHkgcG9saWN5IGluIHVzZXJzcGFjZSwg
YnkgY2hlY2tpbmcgd2hldGhlciBzcGVjaWZpYyBmaWxlcyBoYXZlIHRoZQo+ID4gZnMtdmVyaXR5
IGJpdCBzZXQgb3Igbm90LiAgU3VjaCB1c2VycyBjb3VsZCBqdXN0IHN0b3JlIGFuZCB2ZXJpZnkg
c2lnbmF0dXJlcyBpbgo+ID4gdXNlcnNwYWNlIGluc3RlYWQsIHdpdGhvdXQgYW55IGtlcm5lbCBp
bnZvbHZlbWVudC4gIFNvIHRoYXQncyB3aGF0IEkndmUgYmVlbgo+ID4gcmVjb21tZW5kaW5nICh3
aXRoIGxpbWl0ZWQgc3VjY2VzcywgdW5mb3J0dW5hdGVseSkuCj4gPgo+ID4gSWYgeW91IHJlYWxs
eSBkbyBuZWVkIGluLWtlcm5lbCBzaWduYXR1cmUgdmVyaWZpY2F0aW9uLCB0aGVuIHRoYXQgbWF5
IGJlIGEKPiA+IGxlZ2l0aW1hdGUgdXNlIGNhc2UgZm9yIHRoZSBmcy12ZXJpdHkgYnVpbHQtaW4g
c2lnbmF0dXJlcywgYWx0aG91Z2ggSSBkbyB3b25kZXIKPiA+IHdoeSB5b3UgYXJlbid0IHVzaW5n
IElNQSBhbmQgaXRzIHNpZ25hdHVyZSBtZWNoYW5pc20gaW5zdGVhZC4KPiA+Cj4gPiAtIEVyaWMK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

