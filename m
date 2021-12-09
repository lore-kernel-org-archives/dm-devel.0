Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98863C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  9 Dec 2021 00:55:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-469-p0Nx43EiMY2i5jqHeKGH_A-1; Wed, 08 Dec 2021 19:55:45 -0500
X-MC-Unique: p0Nx43EiMY2i5jqHeKGH_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA93F101F002;
	Thu,  9 Dec 2021 00:55:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B414745D72;
	Thu,  9 Dec 2021 00:55:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EBAE21809CB8;
	Thu,  9 Dec 2021 00:55:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B90tYVw018669 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Dec 2021 19:55:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3C59440D1B9F; Thu,  9 Dec 2021 00:55:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 381E640D1B9E
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 00:55:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EC8A868912
	for <dm-devel@redhat.com>; Thu,  9 Dec 2021 00:55:34 +0000 (UTC)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-34-Vcy6cAOZPiCslqiS02ktlA-1; Wed, 08 Dec 2021 19:55:32 -0500
X-MC-Unique: Vcy6cAOZPiCslqiS02ktlA-1
To: Heinz Mauelshagen <heinzm@redhat.com>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
	<9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
	<CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
	<a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
	<3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
	<abe73176-03ca-9305-2005-677edc6ef158@linux.dev>
	<CAM23VxrYRbWEUsCsez2QOQM9oWKxSv432rc9oZCj5zEPmtND0A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <4beac38d-8932-9081-23ca-4552311697f0@linux.dev>
Date: Thu, 9 Dec 2021 08:47:58 +0800
MIME-Version: 1.0
In-Reply-To: <CAM23VxrYRbWEUsCsez2QOQM9oWKxSv432rc9oZCj5zEPmtND0A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B90tYVw018669
X-loop: dm-devel@redhat.com
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Mike Snitzer <snitzer@redhat.com>,
	linux-raid <linux-raid@vger.kernel.org>,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	it+raid@molgen.mpg.de, Donald Buczek <buczek@molgen.mpg.de>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH V2] md: don't unregister sync_thread with
 reconfig_mutex held
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAxMi85LzIxIDEyOjM1IEFNLCBIZWlueiBNYXVlbHNoYWdlbiB3cm90ZToKPiBOQUNLLCBz
ZWUgZGV0YWlscyBiZWxvdy4KPgo+IE9uIFdlZCwgRGVjIDgsIDIwMjEgYXQgMzoyNCBQTSBHdW9x
aW5nIEppYW5nIDxndW9xaW5nLmppYW5nQGxpbnV4LmRldiAKPiA8bWFpbHRvOmd1b3Fpbmcuamlh
bmdAbGludXguZGV2Pj4gd3JvdGU6Cj4KPgo+Cj4gICAgIE9uIDEyLzEvMjEgMToyNyBBTSwgUGF1
bCBNZW56ZWwgd3JvdGU6Cj4gICAgID4KPiAgICAgPj4+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9tZC9kbS1yYWlkLmMgYi9kcml2ZXJzL21kL2RtLXJhaWQuYwo+ICAgICA+Pj4+Pj4+IGluZGV4
IGNhYjEyYjIuLjBjNGNiYmEgMTAwNjQ0Cj4gICAgID4+Pj4+Pj4gLS0tIGEvZHJpdmVycy9tZC9k
bS1yYWlkLmMKPiAgICAgPj4+Pj4+PiArKysgYi9kcml2ZXJzL21kL2RtLXJhaWQuYwo+ICAgICA+
Pj4+Pj4+IEBAIC0zNjY4LDcgKzM2NjgsNyBAQCBzdGF0aWMgaW50IHJhaWRfbWVzc2FnZShzdHJ1
Y3QKPiAgICAgZG1fdGFyZ2V0Cj4gICAgID4+Pj4+Pj4gKnRpLCB1bnNpZ25lZCBpbnQgYXJnYywg
Y2hhciAqKmFyZ3YsCj4gICAgID4+Pj4+Pj4gwqDCoMKgwqDCoMKgwqAgaWYgKCFzdHJjYXNlY21w
KGFyZ3ZbMF0sICJpZGxlIikgfHwKPiAgICAgIXN0cmNhc2VjbXAoYXJndlswXSwKPiAgICAgPj4+
Pj4+PiAiZnJvemVuIikpIHsKPiAgICAgPj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgaWYgKG1kZGV2LT5zeW5jX3RocmVhZCkgewo+ICAgICA+Pj4+Pj4+IHNldF9iaXQoTURf
UkVDT1ZFUllfSU5UUiwKPiAgICAgPj4+Pj4+PiAmbWRkZXYtPnJlY292ZXJ5KTsKPiAgICAgPj4+
Pj4+PiAtIG1kX3JlYXBfc3luY190aHJlYWQobWRkZXYpOwo+ICAgICA+Pj4+Pj4+ICsgbWRfcmVh
cF9zeW5jX3RocmVhZChtZGRldiwgZmFsc2UpOwo+ICAgICA+Pj4+Pgo+ICAgICA+Pj4+PiBJIHRo
aW5rIHdlIGNhbiBhZGQgbWRkZXZfbG9jaygpIGFuZCBtZGRldl91bmxvY2soKSBoZXJlIGFuZAo+
ICAgICB0aGVuCj4gICAgID4+Pj4+IHdlIGRvbid0Cj4gICAgID4+Pj4+IG5lZWQgdGhlIGV4dHJh
IHBhcmFtZXRlcj8KPiAgICAgPj4+Pgo+ICAgICA+Pj4+IEkgdGhvdWdodCBpdCB0b28sIGJ1dCBJ
IHdvdWxkIHByZWZlciBnZXQgdGhlIGlucHV0IGZyb20gRE0KPiAgICAgcGVvcGxlCj4gICAgID4+
Pj4gZmlyc3QuCj4gICAgID4+Pj4KPiAgICAgPj4+PiBAIE1pa2Ugb3IgQWxhc2RhaXIKPiAgICAg
Pj4+Cj4gICAgID4+PiBIaSBNaWtlIGFuZCBBbGFzZGFpciwKPiAgICAgPj4+Cj4gICAgID4+PiBD
b3VsZCB5b3UgcGxlYXNlIGNvbW1lbnQgb24gdGhpcyBvcHRpb246IGFkZGluZyBtZGRldl9sb2Nr
KCkgYW5kCj4gICAgID4+PiBtZGRldl91bmxvY2soKQo+ICAgICA+Pj4gdG8gcmFpZF9tZXNzYWdl
KCkgYXJvdW5kIG1kX3JlYXBfc3luY190aHJlYWQoKT8KPgo+ICAgICBBZGQgSGVpbnogYW5kIEpv
bmF0aGFuLCBjb3VsZCB5b3UgY29tbWVudCBhYm91dCB0aGlzPyBUaGFua3MuCj4KPiAgICAgPj4K
PiAgICAgPj4gVGhlIGlzc3VlIGlzIHVuZm9ydHVuYXRlbHkgc3RpbGwgdW5yZXNvbHZlZCAoYXQg
bGVhc3QgTGludXgKPiAgICAgNS4xMC44MikuCj4gICAgID4+IEhvdyBjYW4gd2UgbW92ZSBmb3J3
YXJkPwo+Cj4gICAgIElmIGl0IGlzIG5vdCBhcHBsaWNhYmxlIHRvIGNoYW5nZSBkbS1yYWlkLCBh
bm90aGVyIGFsdGVybmF0aXZlCj4gICAgIGNvdWxkIGJlCj4gICAgIGxpa2UgdGhpcwo+Cj4gICAg
IC0tLSBhL2RyaXZlcnMvbWQvbWQuYwo+ICAgICArKysgYi9kcml2ZXJzL21kL21kLmMKPiAgICAg
QEAgLTk0MDksOCArOTQwOSwxMiBAQCB2b2lkIG1kX3JlYXBfc3luY190aHJlYWQoc3RydWN0IG1k
ZXYgKm1kZGV2KQo+ICAgICDCoMKgwqDCoMKgwqDCoMKgIHNlY3Rvcl90IG9sZF9kZXZfc2VjdG9y
cyA9IG1kZGV2LT5kZXZfc2VjdG9yczsKPiAgICAgwqDCoMKgwqDCoMKgwqDCoCBib29sIGlzX3Jl
c2hhcGVkID0gZmFsc2U7Cj4KPiAgICAgK8KgwqDCoMKgwqDCoCBpZiAobWRkZXZfaXNfbG9ja2Vk
KG1kZGV2KSkKPiAgICAgK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRkZXZfdW5sb2Nr
KG1kZGV2KTsKPiAgICAgwqDCoMKgwqDCoMKgwqDCoCAvKiByZXN5bmMgaGFzIGZpbmlzaGVkLCBj
b2xsZWN0IHJlc3VsdCAqLwo+ICAgICDCoMKgwqDCoMKgwqDCoMKgIG1kX3VucmVnaXN0ZXJfdGhy
ZWFkKCZtZGRldi0+c3luY190aHJlYWQpOwo+ICAgICArwqDCoMKgwqDCoMKgIGlmIChtZGRldl9p
c19sb2NrZWQobWRkZXYpKQo+ICAgICArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZGRl
dl9sb2NrKG1kZGV2KTsKPiAgICAgwqDCoMKgwqDCoMKgwqDCoCBpZiAoIXRlc3RfYml0KE1EX1JF
Q09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpICYmCj4gICAgIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAhdGVzdF9iaXQoTURfUkVDT1ZFUllfUkVRVUVTVEVELCAmbWRkZXYtPnJlY292ZXJ5
KSAmJgo+ICAgICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRkZXYtPmRlZ3JhZGVkICE9IG1k
ZGV2LT5yYWlkX2Rpc2tzKSB7Cj4gICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmggYi9k
cml2ZXJzL21kL21kLmgKPiAgICAgaW5kZXggNTNlYTdhNjk2MWRlLi45NmE4OGI3NjgxZDYgMTAw
NjQ0Cj4gICAgIC0tLSBhL2RyaXZlcnMvbWQvbWQuaAo+ICAgICArKysgYi9kcml2ZXJzL21kL21k
LmgKPiAgICAgQEAgLTU0OSw2ICs1NDksMTEgQEAgc3RhdGljIGlubGluZSBpbnQgbWRkZXZfdHJ5
bG9jayhzdHJ1Y3QgbWRkZXYKPiAgICAgKm1kZGV2KQo+ICAgICDCoMKgfQo+ICAgICDCoMKgZXh0
ZXJuIHZvaWQgbWRkZXZfdW5sb2NrKHN0cnVjdCBtZGRldiAqbWRkZXYpOwo+Cj4gICAgICtzdGF0
aWMgaW5saW5lIGludCBtZGRldl9pc19sb2NrZWQoc3RydWN0IG1kZGV2ICptZGRldikKPiAgICAg
K3sKPiAgICAgK8KgwqDCoMKgwqDCoCByZXR1cm4gbXV0ZXhfaXNfbG9ja2VkKCZtZGRldi0+cmVj
b25maWdfbXV0ZXgpOwo+ICAgICArfQo+ICAgICArCj4KPgo+IFBhdGNoIGlzIGJvZ3VzIHJlbGF0
aXZlIHRvIHRoZSBwcm9wb3NlZMKgbWRkZXZfdW5sb2NrL21kZGV2X2xvY2sgbG9naWMgCj4gaW4g
bWQuYyBhcm91bmQgdGhlCj4gbWRfdW5yZWdpc3Rlcl90aHJlYWQoKSBhcyBpdCdzIGZhaWxpbmcg
dG8gbG9jayBhZ2FpbiBpZiBpdCB3YXMgaG9sZGluZyAKPiB0aGUgbXV0ZXggYmVmb3JlIGFzIGl0
IGFnYWluCj4gY2FsbHMgbWRkZXZfbG9ja2VkKCkgYWZ0ZXIgaGF2aW5nIHRoZSBtdXRleCB1bmxv
Y2tlZCBqdXN0IGJlZm9yZSB0aGUgCj4gbWRfdW5yZWdpc3Rlcl90aHJlYWQoKSBjYWxsLgo+Cj4g
SWYgdGhhdCBwYXRjaCB0byBtZC5jIGhvbGRzIHVwIGluIGZ1cnRoZXIgYW5hbHlzaXMsIGl0IGhh
cyB0byBrZWVwIHRoZSAKPiBtZGRldl9pc19sb2NrZWQoKSByZXN1bHQKPiBhbmQgdW5sb2NrL2xv
Y2sgY29uZGl0aW9uYWxseSBiYXNlZCBvbiBpdHMgcmVzdWx0Lgo+CgpZZXMsIHRoYXQgd2FzIG15
IGludGVudGlvbiB0b28sIHRoYW5rcyBmb3IgcG9pbnRpbmcgaXQgb3V0LgoKQEAgLTk0MDcsMTAg
Kzk0MDcsMTYgQEAgdm9pZCBtZF9yZWFwX3N5bmNfdGhyZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYp
CiDCoHsKIMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBtZF9yZGV2ICpyZGV2OwogwqDCoMKgwqDCoMKg
wqAgc2VjdG9yX3Qgb2xkX2Rldl9zZWN0b3JzID0gbWRkZXYtPmRldl9zZWN0b3JzOwotwqDCoMKg
wqDCoMKgIGJvb2wgaXNfcmVzaGFwZWQgPSBmYWxzZTsKK8KgwqDCoMKgwqDCoCBib29sIGlzX3Jl
c2hhcGVkID0gZmFsc2UsIGlzX2xvY2tlZCA9IGZhbHNlOwoKIMKgwqDCoMKgwqDCoMKgIC8qIHJl
c3luYyBoYXMgZmluaXNoZWQsIGNvbGxlY3QgcmVzdWx0ICovCivCoMKgwqDCoMKgwqAgaWYgKG1k
ZGV2X2lzX2xvY2tlZChtZGRldikpIHsKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaXNf
bG9ja2VkID0gdHJ1ZTsKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRkZXZfdW5sb2Nr
KG1kZGV2KTsKK8KgwqDCoMKgwqDCoCB9CiDCoMKgwqDCoMKgwqDCoCBtZF91bnJlZ2lzdGVyX3Ro
cmVhZCgmbWRkZXYtPnN5bmNfdGhyZWFkKTsKK8KgwqDCoMKgwqDCoCBpZiAoaXNfbG9ja2VkKQor
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZGRldl9sb2NrKG1kZGV2KTsKClRoYW5rcywK
R3VvcWluZwoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0
dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

