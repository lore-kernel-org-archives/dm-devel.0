Return-Path: <SRS0=WDPk=PP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DF8C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:46:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 33F1D60F9D
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:46:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 33F1D60F9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-BhyLY90JNQGKuK6jikxMxg-1; Wed, 27 Oct 2021 04:46:43 -0400
X-MC-Unique: BhyLY90JNQGKuK6jikxMxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B78528066FB;
	Wed, 27 Oct 2021 08:46:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95C0960862;
	Wed, 27 Oct 2021 08:46:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B9911800B9E;
	Wed, 27 Oct 2021 08:46:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19R8g8bY024477 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 04:42:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EC35851E1; Wed, 27 Oct 2021 08:42:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6AE851DD
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 08:42:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B8CC10AF7C0
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 08:42:03 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
	[185.176.79.56]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-294-VIg-fSj9Mj2y0E8pw3CIAw-1; Wed, 27 Oct 2021 04:41:59 -0400
X-MC-Unique: VIg-fSj9Mj2y0E8pw3CIAw-1
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HfMWP5vgbz6H7dv;
	Wed, 27 Oct 2021 16:37:21 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
	fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Wed, 27 Oct 2021 10:41:56 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
	fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id
	15.01.2308.015; Wed, 27 Oct 2021 10:41:56 +0200
From: Roberto Sassu <roberto.sassu@huawei.com>
To: Deven Bowers <deven.desai@linux.microsoft.com>, Eric Biggers
	<ebiggers@kernel.org>
Thread-Topic: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
	fsverity digest and signature
Thread-Index: AQHXwGWUN6BqcPCg3Uma5jdt5usPz6vRLYAAgAMlHYCAAAy0gIAHoD6wgAM9LeCABllegIABBN/w
Date: Wed, 27 Oct 2021 08:41:56 +0000
Message-ID: <7ba78ee8bf444fe99e1e7346dad475b7@huawei.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
	<9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
	<YWngaVdvMyWBlITZ@gmail.com>
	<5c1f800ba554485cb3659da689d2079a@huawei.com>
	<a16a628b9e21433198c490500a987121@huawei.com>
	<40f70c77-80eb-2716-be77-9cbcf4770b8a@linux.microsoft.com>
In-Reply-To: <40f70c77-80eb-2716-be77-9cbcf4770b8a@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19R8g8bY024477
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBGcm9tOiBEZXZlbiBCb3dlcnMgW21haWx0bzpkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQu
Y29tXQo+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgMjYsIDIwMjEgOTowNCBQTQo+IE9uIDEwLzIy
LzIwMjEgOTozMSBBTSwgUm9iZXJ0byBTYXNzdSB3cm90ZToKPiA+PiBGcm9tOiBSb2JlcnRvIFNh
c3N1IFttYWlsdG86cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tXQo+ID4+IFNlbnQ6IFdlZG5lc2Rh
eSwgT2N0b2JlciAyMCwgMjAyMSA1OjA5IFBNCj4gPj4+IEZyb206IEVyaWMgQmlnZ2VycyBbbWFp
bHRvOmViaWdnZXJzQGtlcm5lbC5vcmddCj4gPj4+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAxNSwg
MjAyMSAxMDoxMSBQTQo+ID4+PiBPbiBGcmksIE9jdCAxNSwgMjAyMSBhdCAxMjoyNTo1M1BNIC0w
NzAwLCBEZXZlbiBCb3dlcnMgd3JvdGU6Cj4gPj4+PiBPbiAxMC8xMy8yMDIxIDEyOjI0IFBNLCBF
cmljIEJpZ2dlcnMgd3JvdGU6Cj4gPj4+Pj4gT24gV2VkLCBPY3QgMTMsIDIwMjEgYXQgMTI6MDY6
MzFQTSAtMDcwMCwKPiA+Pj4gZGV2ZW4uZGVzYWlAbGludXgubWljcm9zb2Z0LmNvbSAgd3JvdGU6
Cj4gPj4+Pj4+IEZyb206IEZhbiBXdTx3dWZhbkBsaW51eC5taWNyb3NvZnQuY29tPgo+ID4+Pj4+
Pgo+ID4+Pj4+PiBBZGQgc2VjdXJpdHlfaW5vZGVfc2V0c2VjdXJpdHkgdG8gZnN2ZXJpdHkgc2ln
bmF0dXJlIHZlcmlmaWNhdGlvbi4KPiA+Pj4+Pj4gVGhpcyBjYW4gbGV0IExTTXMgc2F2ZSB0aGUg
c2lnbmF0dXJlIGRhdGEgYW5kIGRpZ2VzdCBoYXNoZXMgcHJvdmlkZWQKPiA+Pj4+Pj4gYnkgZnN2
ZXJpdHkuCj4gPj4+Pj4gQ2FuIHlvdSBlbGFib3JhdGUgb24gd2h5IExTTXMgbmVlZCB0aGlzIGlu
Zm9ybWF0aW9uPwo+ID4+Pj4gVGhlIHByb3Bvc2VkIExTTSAoSVBFKSBvZiB0aGlzIHNlcmllcyB3
aWxsIGJlIHRoZSBvbmx5IG9uZSB0byBuZWVkCj4gPj4+PiB0aGlzIGluZm9ybWF0aW9uIGF0IHRo
ZcKgIG1vbWVudC4gSVBF4oCZcyBnb2FsIGlzIHRvIGhhdmUgcHJvdmlkZQo+ID4+Pj4gdHJ1c3Qt
YmFzZWQgYWNjZXNzIGNvbnRyb2wuIFRydXN0IGFuZCBJbnRlZ3JpdHkgYXJlIHRpZWQgdG9nZXRo
ZXIsCj4gPj4+PiBhcyB5b3UgY2Fubm90IHByb3ZlIHRydXN0IHdpdGhvdXQgcHJvdmluZyBpbnRl
Z3JpdHkuCj4gPj4+IEkgdGhpbmsgeW91IG1lYW4gYXV0aGVudGljaXR5LCBub3QgaW50ZWdyaXR5
Pwo+ID4+Pgo+ID4+PiBBbHNvIGhvdyBkb2VzIHRoaXMgZGlmZmVyIGZyb20gSU1BPyAgSSBrbm93
IHRoYXQgSU1BIGRvZXNuJ3Qgc3VwcG9ydCBmcy0KPiB2ZXJpdHkKPiA+Pj4gZmlsZSBoYXNoZXMs
IGJ1dCB0aGF0IGNvdWxkIGJlIGNoYW5nZWQuICBXaHkgbm90IGV4dGVuZCBJTUEgdG8gY292ZXIg
eW91cgo+IHVzZQo+ID4+PiBjYXNlKHMpPwo+ID4+Pgo+ID4+Pj4gSVBFIG5lZWRzIHRoZSBkaWdl
c3QgaW5mb3JtYXRpb24gdG8gYmUgYWJsZSB0byBjb21wYXJlIGEgZGlnZXN0Cj4gPj4+PiBwcm92
aWRlZCBieSB0aGUgcG9saWN5IGF1dGhvciwgYWdhaW5zdCB0aGUgZGlnZXN0IGNhbGN1bGF0ZWQg
YnkKPiA+Pj4+IGZzdmVyaXR5IHRvIG1ha2UgYSBkZWNpc2lvbiBvbiB3aGV0aGVyIHRoYXQgc3Bl
Y2lmaWMgZmlsZSwgcmVwcmVzZW50ZWQKPiA+Pj4+IGJ5IHRoZSBkaWdlc3QgaXMgYXV0aG9yaXpl
ZCBmb3IgdGhlIGFjdGlvbnMgc3BlY2lmaWVkIGluIHRoZSBwb2xpY3kuCj4gPj4+Pgo+ID4+Pj4g
QSBtb3JlIGNvbmNyZXRlIGV4YW1wbGUsIGlmIGFuIElQRSBwb2xpY3kgYXV0aG9yIHdyaXRlczoK
PiA+Pj4+Cj4gPj4+PiAgwqDCoMKgIG9wPUVYRUNVVEUgZnN2ZXJpdHlfZGlnZXN0PTxIZXhEaWdl
c3QgPiBhY3Rpb249REVOWQo+ID4+Pj4KPiA+Pj4+IElQRSB0YWtlcyB0aGUgZGlnZXN0IHByb3Zp
ZGVkIGJ5IHRoaXMgc2VjdXJpdHkgaG9vaywgc3RvcmVzIGl0Cj4gPj4+PiBpbiBJUEUncyBzZWN1
cml0eSBibG9iIG9uIHRoZSBpbm9kZS4gSWYgdGhpcyBmaWxlIGlzIGxhdGVyCj4gPj4+PiBleGVj
dXRlZCwgSVBFIGNvbXBhcmVzIHRoZSBkaWdlc3Qgc3RvcmVkIGluIHRoZSBMU00gYmxvYiwKPiA+
Pj4+IHByb3ZpZGVkIGJ5IHRoaXMgaG9vaywgYWdhaW5zdCA8SGV4RGlnZXN0PiBpbiB0aGUgcG9s
aWN5LCBpZgo+ID4+Pj4gaXQgbWF0Y2hlcywgaXQgZGVuaWVzIHRoZSBhY2Nlc3MsIHBlcmZvcm1p
bmcgYSByZXZvY2F0aW9uCj4gPj4+PiBvZiB0aGF0IGZpbGUuCj4gPj4+IERvIHlvdSBoYXZlIGEg
YmV0dGVyIGV4YW1wbGU/ICBUaGlzIG9uZSBpcyBwcmV0dHkgdXNlbGVzcyBzaW5jZSBvbmUgY2Fu
IGdldAo+ID4+PiBhcm91bmQgaXQganVzdCBieSBleGVjdXRpbmcgYSBmaWxlIHRoYXQgZG9lc24n
dCBoYXZlIGZzLXZlcml0eSBlbmFibGVkLgo+ID4+IEkgd2FzIHdvbmRlcmluZyBpZiB0aGUgZm9s
bG93aW5nIHVzZSBjYXNlIGNhbiBiZSBzdXBwb3J0ZWQ6Cj4gPj4gYWxsb3cgdGhlIGV4ZWN1dGlv
biBvZiBmaWxlcyBwcm90ZWN0ZWQgd2l0aCBmc3Zlcml0eSBpZiB0aGUgcm9vdAo+ID4+IGRpZ2Vz
dCBpcyBmb3VuZCBhbW9uZyByZWZlcmVuY2UgdmFsdWVzIChpbnN0ZWFkIG9mIHByb3ZpZGluZwo+
ID4+IHRoZW0gb25lIGJ5IG9uZSBpbiB0aGUgcG9saWN5KS4KPiA+Pgo+ID4+IFNvbWV0aGluZyBs
aWtlOgo+ID4+Cj4gPj4gb3A9RVhFQ1VURSBmc3Zlcml0eV9kaWdlc3Q9ZGlnbGltIGFjdGlvbj1B
TExPVwo+ID4gTG9va3MgbGlrZSBpdCB3b3Jrcy4gSSBtb2RpZmllZCBJUEUgdG8gcXVlcnkgdGhl
IHJvb3QgZGlnZXN0Cj4gPiBvZiBhbiBmc3Zlcml0eS1wcm90ZWN0ZWQgZmlsZSBpbiBESUdMSU0u
Cj4gPgo+ID4gIyBjYXQgaXBlLXBvbGljeQo+ID4gcG9saWN5X25hbWU9IkFsbG93RlNWZXJpdHlL
bW9kdWxlcyIgcG9saWN5X3ZlcnNpb249MC4wLjEKPiA+IERFRkFVTFQgYWN0aW9uPUFMTE9XCj4g
PiBERUZBVUxUIG9wPUtNT0RVTEUgYWN0aW9uPURFTlkKPiA+IG9wPUtNT0RVTEUgZnN2ZXJpdHlf
ZGlnZXN0PWRpZ2xpbSBhY3Rpb249QUxMT1cKPiA+Cj4gPiBJUEUgc2V0dXA6Cj4gPiAjIGNhdCBp
cGUtcG9saWN5LnA3cyA+IC9zeXMva2VybmVsL3NlY3VyaXR5L2lwZS9uZXdfcG9saWN5Cj4gPiAj
IGVjaG8gLW4gMSA+ICAvc3lzL2tlcm5lbC9zZWN1cml0eS9pcGUvcG9saWNpZXMvQWxsb3dGU1Zl
cml0eUttb2R1bGVzL2FjdGl2ZQo+ID4gIyBlY2hvIDEgPiAvc3lzL2tlcm5lbC9zZWN1cml0eS9p
cGUvZW5mb3JjZQo+ID4KPiA+IElQRSBkZW5pZXMgbG9hZGluZyBvZiBrZXJuZWwgbW9kdWxlcyBu
b3QgcHJvdGVjdGVkIGJ5IGZzdmVyaXR5Ogo+ID4gIyBpbnNtb2QgIC9saWIvbW9kdWxlcy81LjE1
LjAtcmMxKy9rZXJuZWwvZnMvZmF0L2ZhdC5rbwo+ID4gaW5zbW9kOiBFUlJPUjogY291bGQgbm90
IGluc2VydCBtb2R1bGUgL2xpYi9tb2R1bGVzLzUuMTUuMC0KPiByYzErL2tlcm5lbC9mcy9mYXQv
ZmF0LmtvOiBQZXJtaXNzaW9uIGRlbmllZAo+ID4KPiA+IFByb3RlY3QgZmF0LmtvIHdpdGggZnN2
ZXJpdHk6Cj4gPiAjIGNwIC9saWIvbW9kdWxlcy81LjE1LjAtcmMxKy9rZXJuZWwvZnMvZmF0L2Zh
dC5rbyAvZnN2ZXJpdHkKPiA+ICMgZnN2ZXJpdHkgZW5hYmxlIC9mc3Zlcml0eS9mYXQua28KPiA+
ICMgZnN2ZXJpdHkgbWVhc3VyZSAvZnN2ZXJpdHkvZmF0LmtvCj4gPgo+IHNoYTI1NjowNzliZTZk
ODg2MzhlNTgxNDFlZTI0YmJhODk4MTM5MTdjNDRmYWE1NWFkYTRiZjVkODAzMzVlZmUxNTQKPiA3
ODAzIC9mc3Zlcml0eS9mYXQua28KPiA+Cj4gPiBJUEUgc3RpbGwgZGVuaWVzIHRoZSBsb2FkaW5n
IG9mIGZhdC5rbyAocm9vdCBkaWdlc3Qgbm90IHVwbG9hZGVkIHRvIHRoZSBrZXJuZWwpOgo+ID4g
IyBpbnNtb2QgL2ZzdmVyaXR5L2ZhdC5rbwo+ID4gaW5zbW9kOiBFUlJPUjogY291bGQgbm90IGlu
c2VydCBtb2R1bGUgL2ZzdmVyaXR5L2ZhdC5rbzogUGVybWlzc2lvbiBkZW5pZWQKPiA+Cj4gPiBH
ZW5lcmF0ZSBhIGRpZ2VzdCBsaXN0IHdpdGggdGhlIHJvb3QgZGlnZXN0IGFib3ZlIGFuZCB1cGxv
YWQgaXQgdG8gdGhlIGtlcm5lbDoKPiA+ICMgLi9jb21wYWN0X2dlbiAtaQo+IDA3OWJlNmQ4ODYz
OGU1ODE0MWVlMjRiYmE4OTgxMzkxN2M0NGZhYTU1YWRhNGJmNWQ4MDMzNWVmZTE1NDc4MDMgLWEK
PiBzaGEyNTYgLWQgdGVzdCAtcyAtdCBmaWxlIC1mCj4gPiAjIGVjaG8gJFBXRC90ZXN0LzAtZmls
ZV9saXN0LWNvbXBhY3QtCj4gMDc5YmU2ZDg4NjM4ZTU4MTQxZWUyNGJiYTg5ODEzOTE3YzQ0ZmFh
NTVhZGE0YmY1ZDgwMzM1ZWZlMTU0NzgwMyA+Cj4gL3N5cy9rZXJuZWwvc2VjdXJpdHkvaW50ZWdy
aXR5L2RpZ2xpbS9kaWdlc3RfbGlzdF9hZGQKPiA+Cj4gPiBJUEUgYWxsb3dzIHRoZSBsb2FkaW5n
IG9mIGZhdC5rbzoKPiA+ICMgaW5zbW9kIC9mc3Zlcml0eS9mYXQua28KPiA+ICMKPiA+Cj4gPiBS
ZWdhcmRpbmcgYXV0aGVudGljaXR5LCBub3Qgc2hvd24gaW4gdGhpcyBkZW1vLCBJUEUgd2lsbCBh
bHNvCj4gPiBlbnN1cmUgdGhhdCB0aGUgcm9vdCBkaWdlc3QgaXMgc2lnbmVkIChkaWdsaW1fZGln
ZXN0X2dldF9pbmZvKCkKPiA+IHJlcG9ydHMgdGhpcyBpbmZvcm1hdGlvbikuCj4gCj4gSSBhcG9s
b2dpemUgZm9yIHRoZSBkZWxheSBpbiByZXNwb25zZXMsIGJ1dCBpdCBsb29rcyBsaWtlCj4geW91
J3ZlIGZpZ3VyZWQgaXQgb3V0LgoKTm8gcHJvYmxlbS4KCj4gVGhpcyBraW5kIG9mIHRoaW5nIGlz
IGV4YWN0bHkgd2hhdCBJUEUncyBkZXNpZ24gaXMgc3VwcG9zZWQgdG8KPiBzb2x2ZSwgeW91IGhh
dmUgc29tZSBvdGhlciBzeXN0ZW0gd2hpY2ggcHJvdmlkZXMgdGhlCj4gaW50ZWdyaXR5IG1lY2hh
bmlzbSBhbmQgKG9wdGlvbmFsbHkpIGRldGVybWluZSBpZiBpdCBpcyB0cnVzdGVkIG9yCj4gbm90
LCBhbmQgSVBFIGNhbiBwcm92aWRlIHRoZSBwb2xpY3kgYXNwZWN0IHZlcnkgZWFzaWx5IHRvCj4g
bWFrZSBhIHNldCBvZiBzeXN0ZW0td2lkZSByZXF1aXJlbWVudHMgYXJvdW5kIHlvdXIgbWVjaGFu
aXNtLgo+IAo+IEknbSB2ZXJ5IHN1cHBvcnRpdmUgb2YgYWRkaW5nIHRoZSBmdW5jdGlvbmFsaXR5
LCBidXQgSSB3b25kZXIKPiBpZiBpdCBtYWtlcyBtb3JlIHNlbnNlIHRvIGhhdmUgZGlnaWxtJ3Mg
ZXh0ZW5zaW9uIGJlIGEgc2VwYXJhdGUKPiBrZXkgaW5zdGVhZCBvZiB0aWVkIHRvIHRoZSBmc3Zl
cml0eV9kaWdlc3Qga2V5IC0gc29tZXRoaW5nIGxpa2UKPiAKPiAgICAgb3A9RVhFQ1VURSBkaWds
aW1fZnN2ZXJpdHk9VFJVRSBhY3Rpb249REVOWQo+IAo+IHRoYXQgd2F5IHRoZSBjb25kaXRpb24g
dGhhdCBlbmFibGVzIHRoaXMgcHJvcGVydHkgY2FuIGRlcGVuZAo+IG9uIGRpZ2lsbSBpbiB0aGUg
YnVpbGQsIGFuZCBpdCBzZXBhcmF0ZXMgdGhlIHR3byBzeXN0ZW1zJwo+IGludGVncmF0aW9ucyBp
biBhIHNsaWdodGx5IG1vcmUgY2xlYW4gd2F5LgoKWWVzLCBJIGFncmVlLiBJdCBpcyBtdWNoIG1v
cmUgY2xlYW4uCgo+IEFzIGFuIGFzaWRlLCBkaWQgeW91IGZpbmQgaXQgZGlmZmljdWx0IHRvIGV4
dGVuZD8KCk5vLCBpdCB3YXMgdmVyeSBzdHJhaWdodGZvcndhcmQuCgpSb2JlcnRvCgpIVUFXRUkg
VEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2MwpNYW5hZ2luZyBEaXJlY3Rv
cjogTGkgUGVuZywgWmhvbmcgUm9uZ2h1YQoKPiA+IFJvYmVydG8KPiA+Cj4gPiBIVUFXRUkgVEVD
SE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mwo+ID4gTWFuYWdpbmcgRGlyZWN0
b3I6IExpIFBlbmcsIFpob25nIFJvbmdodWEKPiA+Cj4gPj4gRElHTElNIGlzIGEgY29tcG9uZW50
IEknbSB3b3JraW5nIG9uIHRoYXQgZ2VuZXJpY2FsbHkKPiA+PiBzdG9yZXMgZGlnZXN0cy4gVGhl
IGN1cnJlbnQgdXNlIGNhc2UgaXMgdG8gc3RvcmUgZmlsZSBkaWdlc3RzCj4gPj4gZnJvbSBSUE1U
QUdfRklMRURJR0VTVFMgYW5kIHVzZSB0aGVtIHdpdGggSU1BLCBidXQKPiA+PiB0aGUgZnN2ZXJp
dHkgdXNlIGNhc2UgY291bGQgYmUgZWFzaWx5IHN1cHBvcnRlZCAoaWYgdGhlIHJvb3QKPiA+PiBk
aWdlc3QgaXMgc3RvcmVkIGluIHRoZSBSUE0gaGVhZGVyKS4KPiA+Pgo+ID4+IERJR0xJTSBhbHNv
IHRlbGxzIHdoZXRoZXIgb3Igbm90IHRoZSBzaWduYXR1cmUgb2YgdGhlIHNvdXJjZQo+ID4+IGNv
bnRhaW5pbmcgZmlsZSBkaWdlc3RzIChvciBmc3Zlcml0eSBkaWdlc3RzKSBpcyB2YWxpZCAodGhl
IHNpZ25hdHVyZQo+ID4+IG9mIHRoZSBSUE0gaGVhZGVyIGlzIHRha2VuIGZyb20gUlBNVEFHX1JT
QUhFQURFUikuCj4gPj4KPiA+PiBUaGUgbWVtb3J5IG9jY3VwYXRpb24gaXMgcmVsYXRpdmVseSBz
bWFsbCBmb3IgZXhlY3V0YWJsZXMKPiA+PiBhbmQgc2hhcmVkIGxpYnJhcmllcy4gSSBwdWJsaXNo
ZWQgYSBkZW1vIGZvciBGZWRvcmEgYW5kCj4gPj4gb3BlblNVU0Ugc29tZSB0aW1lIGFnbzoKPiA+
Pgo+ID4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LQo+ID4+IGludGVncml0eS80OGNk
NzM3YzUwNGQ0NTIwODM3N2RhYTI3ZDYyNTUzMUBodWF3ZWkuY29tLwo+ID4+Cj4gPj4gVGhhbmtz
Cj4gPj4KPiA+PiBSb2JlcnRvCj4gPj4KPiA+PiBIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxk
b3JmIEdtYkgsIEhSQiA1NjA2Mwo+ID4+IE1hbmFnaW5nIERpcmVjdG9yOiBMaSBQZW5nLCBaaG9u
ZyBSb25naHVhCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

