Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE24C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 14 Dec 2021 02:35:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-qGdlkp1dMharpiXIMUybGg-1; Mon, 13 Dec 2021 21:35:04 -0500
X-MC-Unique: qGdlkp1dMharpiXIMUybGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EF90801AAB;
	Tue, 14 Dec 2021 02:34:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCCD67AB44;
	Tue, 14 Dec 2021 02:34:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 95C691809CB8;
	Tue, 14 Dec 2021 02:34:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BE2Ym7K014002 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 21:34:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 581AE1121315; Tue, 14 Dec 2021 02:34:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 539691121314
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 02:34:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60EFC800B21
	for <dm-devel@redhat.com>; Tue, 14 Dec 2021 02:34:45 +0000 (UTC)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-190-sF1s4YkgP563lnGSiMP31Q-1; Mon, 13 Dec 2021 21:34:42 -0500
X-MC-Unique: sF1s4YkgP563lnGSiMP31Q-1
To: Donald Buczek <buczek@molgen.mpg.de>, song@kernel.org
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <87206712-b066-9d1d-3e46-14338e704c1a@linux.dev>
Date: Tue, 14 Dec 2021 10:34:32 +0800
MIME-Version: 1.0
In-Reply-To: <8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BE2Ym7K014002
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
	dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAxMi8xMC8yMSAxMDoxNiBQTSwgRG9uYWxkIEJ1Y3playB3cm90ZToKPiBEZWFyIEd1b3Fp
bmcsCj4KPiBPbiAxMy4wMi4yMSAwMTo0OSwgR3VvcWluZyBKaWFuZyB3cm90ZToKPj4gVW5yZWdp
c3RlciBzeW5jX3RocmVhZCBkb2Vzbid0IG5lZWQgdG8gaG9sZCByZWNvbmZpZ19tdXRleCBzaW5j
ZSBpdAo+PiBkb2Vzbid0IHJlY29uZmlndXJlIGFycmF5Lgo+Pgo+PiBBbmQgaXQgY291bGQgY2F1
c2UgZGVhZGxvY2sgcHJvYmxlbSBmb3IgcmFpZDUgYXMgZm9sbG93czoKPj4KPj4gMS4gcHJvY2Vz
cyBBIHRyaWVkIHRvIHJlYXAgc3luYyB0aHJlYWQgd2l0aCByZWNvbmZpZ19tdXRleCBoZWxkIGFm
dGVyIAo+PiBlY2hvCj4+IMKgwqDCoCBpZGxlIHRvIHN5bmNfYWN0aW9uLgo+PiAyLiByYWlkNSBz
eW5jIHRocmVhZCB3YXMgYmxvY2tlZCBpZiB0aGVyZSB3ZXJlIHRvbyBtYW55IGFjdGl2ZSBzdHJp
cGVzLgo+PiAzLiBTQl9DSEFOR0VfUEVORElORyB3YXMgc2V0IChiZWNhdXNlIG9mIHdyaXRlIElP
IGNvbWVzIGZyb20gdXBwZXIgCj4+IGxheWVyKQo+PiDCoMKgwqAgd2hpY2ggY2F1c2VzIHRoZSBu
dW1iZXIgb2YgYWN0aXZlIHN0cmlwZXMgY2FuJ3QgYmUgZGVjcmVhc2VkLgo+PiA0LiBTQl9DSEFO
R0VfUEVORElORyBjYW4ndCBiZSBjbGVhcmVkIHNpbmNlIG1kX2NoZWNrX3JlY292ZXJ5IHdhcyBu
b3QgCj4+IGFibGUKPj4gwqDCoMKgIHRvIGhvbGQgcmVjb25maWdfbXV0ZXguCj4+Cj4+IE1vcmUg
ZGV0YWlscyBpbiB0aGUgbGluazoKPj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtcmFp
ZC81ZWQ1NGZmYy1jZTgyLWJmNjYtNGVmZi0zOTBjYjIzYmMxYWNAbW9sZ2VuLm1wZy5kZS9ULyN0
IAo+Pgo+Pgo+PiBBbmQgYWRkIG9uZSBwYXJhbWV0ZXIgdG8gbWRfcmVhcF9zeW5jX3RocmVhZCBz
aW5jZSBpdCBjb3VsZCBiZSBjYWxsZWQgYnkKPj4gZG0tcmFpZCB3aGljaCBkb2Vzbid0IGhvbGQg
cmVjb25maWdfbXV0ZXguCj4+Cj4+IFJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IERvbmFsZCBCdWN6
ZWsgPGJ1Y3pla0Btb2xnZW4ubXBnLmRlPgo+PiBTaWduZWQtb2ZmLWJ5OiBHdW9xaW5nIEppYW5n
IDxndW9xaW5nLmppYW5nQGNsb3VkLmlvbm9zLmNvbT4KPj4gLS0tCj4+IFYyOgo+PiAxLiBhZGQg
b25lIHBhcmFtZXRlciB0byBtZF9yZWFwX3N5bmNfdGhyZWFkIHBlciBKYWNrJ3Mgc3VnZ2VzdGlv
bi4KPj4KPj4gwqAgZHJpdmVycy9tZC9kbS1yYWlkLmMgfMKgIDIgKy0KPj4gwqAgZHJpdmVycy9t
ZC9tZC5jwqDCoMKgwqDCoCB8IDE0ICsrKysrKysrKy0tLS0tCj4+IMKgIGRyaXZlcnMvbWQvbWQu
aMKgwqDCoMKgwqAgfMKgIDIgKy0KPj4gwqAgMyBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25z
KCspLCA3IGRlbGV0aW9ucygtKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1yYWlk
LmMgYi9kcml2ZXJzL21kL2RtLXJhaWQuYwo+PiBpbmRleCBjYWIxMmIyLi4wYzRjYmJhIDEwMDY0
NAo+PiAtLS0gYS9kcml2ZXJzL21kL2RtLXJhaWQuYwo+PiArKysgYi9kcml2ZXJzL21kL2RtLXJh
aWQuYwo+PiBAQCAtMzY2OCw3ICszNjY4LDcgQEAgc3RhdGljIGludCByYWlkX21lc3NhZ2Uoc3Ry
dWN0IGRtX3RhcmdldCAqdGksIAo+PiB1bnNpZ25lZCBpbnQgYXJnYywgY2hhciAqKmFyZ3YsCj4+
IMKgwqDCoMKgwqAgaWYgKCFzdHJjYXNlY21wKGFyZ3ZbMF0sICJpZGxlIikgfHwgIXN0cmNhc2Vj
bXAoYXJndlswXSwgCj4+ICJmcm96ZW4iKSkgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1k
ZGV2LT5zeW5jX3RocmVhZCkgewo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXRfYml0
KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpOwo+PiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2KTsKPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgbWRfcmVhcF9zeW5jX3RocmVhZChtZGRldiwgZmFsc2UpOwo+PiDCoMKgwqDCoMKgwqDC
oMKgwqAgfQo+PiDCoMKgwqDCoMKgIH0gZWxzZSBpZiAoZGVjaXBoZXJfc3luY19hY3Rpb24obWRk
ZXYsIG1kZGV2LT5yZWNvdmVyeSkgIT0gCj4+IHN0X2lkbGUpCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCByZXR1cm4gLUVCVVNZOwo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5jIGIvZHJpdmVy
cy9tZC9tZC5jCj4+IGluZGV4IGNhNDA5NDIuLjBjMTJiN2YgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZl
cnMvbWQvbWQuYwo+PiArKysgYi9kcml2ZXJzL21kL21kLmMKPj4gQEAgLTQ4NTcsNyArNDg1Nyw3
IEBAIGFjdGlvbl9zdG9yZShzdHJ1Y3QgbWRkZXYgKm1kZGV2LCBjb25zdCBjaGFyIAo+PiAqcGFn
ZSwgc2l6ZV90IGxlbikKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmbHVz
aF93b3JrcXVldWUobWRfbWlzY193cSk7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlm
IChtZGRldi0+c3luY190aHJlYWQpIHsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpOwo+PiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1kX3JlYXBfc3luY190aHJlYWQobWRkZXYpOwo+
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1kX3JlYXBfc3luY190aHJlYWQobWRk
ZXYsIHRydWUpOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIG1kZGV2X3VubG9jayhtZGRldik7Cj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCB9Cj4+IEBAIC02MjM0LDcgKzYyMzQsNyBAQCBzdGF0aWMgdm9pZCBfX21kX3N0b3Bfd3JpdGVz
KHN0cnVjdCBtZGRldiAqbWRkZXYpCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBmbHVzaF93b3JrcXVl
dWUobWRfbWlzY193cSk7Cj4+IMKgwqDCoMKgwqAgaWYgKG1kZGV2LT5zeW5jX3RocmVhZCkgewo+
PiDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0X2JpdChNRF9SRUNPVkVSWV9JTlRSLCAmbWRkZXYtPnJl
Y292ZXJ5KTsKPj4gLcKgwqDCoMKgwqDCoMKgIG1kX3JlYXBfc3luY190aHJlYWQobWRkZXYpOwo+
PiArwqDCoMKgwqDCoMKgwqAgbWRfcmVhcF9zeW5jX3RocmVhZChtZGRldiwgdHJ1ZSk7Cj4+IMKg
wqDCoMKgwqAgfQo+PiDCoCDCoMKgwqDCoMKgIGRlbF90aW1lcl9zeW5jKCZtZGRldi0+c2FmZW1v
ZGVfdGltZXIpOwo+PiBAQCAtOTI1Niw3ICs5MjU2LDcgQEAgdm9pZCBtZF9jaGVja19yZWNvdmVy
eShzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICog
LT5zcGFyZV9hY3RpdmUgYW5kIGNsZWFyIHNhdmVkX3JhaWRfZGlzawo+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICovCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNldF9iaXQo
TURfUkVDT1ZFUllfSU5UUiwgJm1kZGV2LT5yZWNvdmVyeSk7Cj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIG1kX3JlYXBfc3luY190aHJlYWQobWRkZXYpOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2LCB0cnVlKTsKPj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgY2xlYXJfYml0KE1EX1JFQ09WRVJZX1JFQ09WRVIsICZtZGRldi0+cmVjb3Zl
cnkpOwo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjbGVhcl9iaXQoTURfUkVDT1ZFUllf
TkVFREVELCAmbWRkZXYtPnJlY292ZXJ5KTsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
Y2xlYXJfYml0KE1EX1NCX0NIQU5HRV9QRU5ESU5HLCAmbWRkZXYtPnNiX2ZsYWdzKTsKPj4gQEAg
LTkyOTEsNyArOTI5MSw3IEBAIHZvaWQgbWRfY2hlY2tfcmVjb3Zlcnkoc3RydWN0IG1kZGV2ICpt
ZGRldikKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byB1bmxvY2s7Cj4+IMKgwqDC
oMKgwqDCoMKgwqDCoCB9Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAobWRkZXYtPnN5bmNfdGhy
ZWFkKSB7Cj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1kX3JlYXBfc3luY190aHJlYWQobWRk
ZXYpOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2
LCB0cnVlKTsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byB1bmxvY2s7Cj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCB9Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoCAvKiBTZXQgUlVOTklORyBi
ZWZvcmUgY2xlYXJpbmcgTkVFREVEIHRvIGF2b2lkCj4+IEBAIC05MzY0LDE0ICs5MzY0LDE4IEBA
IHZvaWQgbWRfY2hlY2tfcmVjb3Zlcnkoc3RydWN0IG1kZGV2ICptZGRldikKPj4gwqAgfQo+PiDC
oCBFWFBPUlRfU1lNQk9MKG1kX2NoZWNrX3JlY292ZXJ5KTsKPj4gwqAgLXZvaWQgbWRfcmVhcF9z
eW5jX3RocmVhZChzdHJ1Y3QgbWRkZXYgKm1kZGV2KQo+PiArdm9pZCBtZF9yZWFwX3N5bmNfdGhy
ZWFkKHN0cnVjdCBtZGRldiAqbWRkZXYsIGJvb2wgcmVjb25maWdfbXV0ZXhfaGVsZCkKPj4gwqAg
ewo+PiDCoMKgwqDCoMKgIHN0cnVjdCBtZF9yZGV2ICpyZGV2Owo+PiDCoMKgwqDCoMKgIHNlY3Rv
cl90IG9sZF9kZXZfc2VjdG9ycyA9IG1kZGV2LT5kZXZfc2VjdG9yczsKPj4gwqDCoMKgwqDCoCBi
b29sIGlzX3Jlc2hhcGVkID0gZmFsc2U7Cj4+IMKgIMKgwqDCoMKgwqAgLyogcmVzeW5jIGhhcyBm
aW5pc2hlZCwgY29sbGVjdCByZXN1bHQgKi8KPj4gK8KgwqDCoCBpZiAocmVjb25maWdfbXV0ZXhf
aGVsZCkKPj4gK8KgwqDCoMKgwqDCoMKgIG1kZGV2X3VubG9jayhtZGRldik7Cj4KPgo+IElmIG9u
ZSB0aHJlYWQgZ290IGhlcmUsIGUuZy4gdmlhIGFjdGlvbl9zdG9yZSggLyogImlkbGUiICovICks
IG5vdyAKPiB0aGF0IHRoZSBtdXRleCBpcyB1bmxvY2tlZCwgaXMgdGhlcmUgYW55dGhpbmcgd2hp
Y2ggd291bGQgcHJldmVudCAKPiBhbm90aGVyIHRocmVhZCBnZXR0aW5nwqAgaGVyZSBhcyB3ZWxs
LCBlLmcuIHZpYSB0aGUgc2FtZSBwYXRoPwo+Cj4gSWYgbm90LCB0aGV5IGJvdGggbWlnaHQgY2Fs
bAo+Cj4+IG1kX3VucmVnaXN0ZXJfdGhyZWFkKCZtZGRldi0+c3luY190aHJlYWQpOwo+Cj4gV2hp
Y2ggaXMgbm90IHJlZW50cmFudDoKPgo+IHZvaWQgbWRfdW5yZWdpc3Rlcl90aHJlYWQoc3RydWN0
IG1kX3RocmVhZCAqKnRocmVhZHApCj4gewo+IMKgwqDCoMKgc3RydWN0IG1kX3RocmVhZCAqdGhy
ZWFkID0gKnRocmVhZHA7Cj4gwqDCoMKgwqBpZiAoIXRocmVhZCkKPiDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm47Cj4gwqDCoMKgwqBwcl9kZWJ1ZygiaW50ZXJydXB0aW5nIE1ELXRocmVhZCBwaWQgJWRc
biIsIAo+IHRhc2tfcGlkX25yKHRocmVhZC0+dHNrKSk7Cj4gwqDCoMKgwqAvKiBMb2NraW5nIGVu
c3VyZXMgdGhhdCBtZGRldl91bmxvY2sgZG9lcyBub3Qgd2FrZV91cCBhCj4gwqDCoMKgwqAgKiBu
b24tZXhpc3RlbnQgdGhyZWFkCj4gwqDCoMKgwqAgKi8KPiDCoMKgwqDCoHNwaW5fbG9jaygmcGVy
c19sb2NrKTsKPiDCoMKgwqDCoCp0aHJlYWRwID0gTlVMTDsKPiDCoMKgwqDCoHNwaW5fdW5sb2Nr
KCZwZXJzX2xvY2spOwo+Cj4gwqDCoMKgwqBrdGhyZWFkX3N0b3AodGhyZWFkLT50c2spOwo+IMKg
wqDCoMKga2ZyZWUodGhyZWFkKTsKPiB9Cj4KPiBUaGlzIG1pZ2h0IGJlIGEgcHJlZXhpc3Rpbmcg
cHJvYmxlbSwgYmVjYXVzZSB0aGUgY2FsbCBzaXRlIGluIAo+IGRtLXJhaWQuYywgd2hpY2ggeW91
IHVwZGF0ZWQgdG8gYG1kX3JlYXBfc3luY190aHJlYWQobWRkZXYsIGZhbHNlKTtgLCAKPiBkaWRu
J3QgaG9sZCB0aGUgbXV0ZXggYW55d2F5Lgo+Cj4gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8gUHJv
YmFibHksIEkgZG8uCj4KPiBPdGhlcndpc2U6IE1vdmUgdGhlIGRlcmVmIG9mIHRocmVhZHAgaW4g
bWRfdW5yZWdpc3Rlcl90aHJlYWQoKSBpbnRvIAo+IHRoZSBzcGlubG9jayBzY29wZT8KCkdvb2Qg
cG9pbnQsIEkgdGhpbmsgeW91IGFyZSByaWdodC4KCkFuZCBhY3R1YWxseSBwZXJzX2xvY2sgZG9l
cyBleHRyYSBzZXJ2aWNlIHRvIHByb3RlY3QgYWNjZXNzZXMgdG8gCm1kZGV2LT50aHJlYWQgKEkg
dGhpbmsgaXQKYWxzbyBzdWl0YWJsZSBmb3IgbWRkZXYtPnN5bmNfdGhyZWFkICkgd2hlbiB0aGUg
bXV0ZXggY2FuJ3QgYmUgaGVsZC4gCkNhcmUgdG8gc2VuZCBhIHBhdGNoCmZvciBpdD8KClRoYW5r
cywKR3VvcWluZwoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

