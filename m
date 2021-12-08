Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E52C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  8 Dec 2021 14:24:55 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-X9nIKEnJPNGrMTZ3JmSXdQ-1; Wed, 08 Dec 2021 09:24:51 -0500
X-MC-Unique: X9nIKEnJPNGrMTZ3JmSXdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 927201018721;
	Wed,  8 Dec 2021 14:24:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CC445D740;
	Wed,  8 Dec 2021 14:24:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D5764BB7C;
	Wed,  8 Dec 2021 14:24:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B8EOZnx016907 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Dec 2021 09:24:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B5D6440149B2; Wed,  8 Dec 2021 14:24:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B024D40CFD08
	for <dm-devel@redhat.com>; Wed,  8 Dec 2021 14:24:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 893E53C11D26
	for <dm-devel@redhat.com>; Wed,  8 Dec 2021 14:24:35 +0000 (UTC)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-291-OAjfXNLHMfekg6oUT1749A-1; Wed, 08 Dec 2021 09:24:33 -0500
X-MC-Unique: OAjfXNLHMfekg6oUT1749A-1
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
	include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
To: Paul Menzel <pmenzel@molgen.mpg.de>, Song Liu <song@kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	heinzm@redhat.com, jbrassow@redhat.com
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
	<9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
	<CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
	<a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
	<3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
Message-ID: <abe73176-03ca-9305-2005-677edc6ef158@linux.dev>
Date: Wed, 8 Dec 2021 22:16:16 +0800
MIME-Version: 1.0
In-Reply-To: <3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B8EOZnx016907
X-loop: dm-devel@redhat.com
Cc: linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
	Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CgpPbiAxMi8xLzIxIDE6MjcgQU0sIFBhdWwgTWVuemVsIHdyb3RlOgo+Cj4+Pj4+Pj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbWQvZG0tcmFpZC5jIGIvZHJpdmVycy9tZC9kbS1yYWlkLmMKPj4+Pj4+
PiBpbmRleCBjYWIxMmIyLi4wYzRjYmJhIDEwMDY0NAo+Pj4+Pj4+IC0tLSBhL2RyaXZlcnMvbWQv
ZG0tcmFpZC5jCj4+Pj4+Pj4gKysrIGIvZHJpdmVycy9tZC9kbS1yYWlkLmMKPj4+Pj4+PiBAQCAt
MzY2OCw3ICszNjY4LDcgQEAgc3RhdGljIGludCByYWlkX21lc3NhZ2Uoc3RydWN0IGRtX3Rhcmdl
dCAKPj4+Pj4+PiAqdGksIHVuc2lnbmVkIGludCBhcmdjLCBjaGFyICoqYXJndiwKPj4+Pj4+PiDC
oMKgwqDCoMKgwqDCoCBpZiAoIXN0cmNhc2VjbXAoYXJndlswXSwgImlkbGUiKSB8fCAhc3RyY2Fz
ZWNtcChhcmd2WzBdLCAKPj4+Pj4+PiAiZnJvemVuIikpIHsKPj4+Pj4+PiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1kZGV2LT5zeW5jX3RocmVhZCkgewo+Pj4+Pj4+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0X2JpdChNRF9SRUNP
VkVSWV9JTlRSLCAKPj4+Pj4+PiAmbWRkZXYtPnJlY292ZXJ5KTsKPj4+Pj4+PiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2
KTsKPj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBtZF9y
ZWFwX3N5bmNfdGhyZWFkKG1kZGV2LCBmYWxzZSk7Cj4+Pj4+Cj4+Pj4+IEkgdGhpbmsgd2UgY2Fu
IGFkZCBtZGRldl9sb2NrKCkgYW5kIG1kZGV2X3VubG9jaygpIGhlcmUgYW5kIHRoZW4gCj4+Pj4+
IHdlIGRvbid0Cj4+Pj4+IG5lZWQgdGhlIGV4dHJhIHBhcmFtZXRlcj8KPj4+Pgo+Pj4+IEkgdGhv
dWdodCBpdCB0b28sIGJ1dCBJIHdvdWxkIHByZWZlciBnZXQgdGhlIGlucHV0IGZyb20gRE0gcGVv
cGxlIAo+Pj4+IGZpcnN0Lgo+Pj4+Cj4+Pj4gQCBNaWtlIG9yIEFsYXNkYWlyCj4+Pgo+Pj4gSGkg
TWlrZSBhbmQgQWxhc2RhaXIsCj4+Pgo+Pj4gQ291bGQgeW91IHBsZWFzZSBjb21tZW50IG9uIHRo
aXMgb3B0aW9uOiBhZGRpbmcgbWRkZXZfbG9jaygpIGFuZCAKPj4+IG1kZGV2X3VubG9jaygpCj4+
PiB0byByYWlkX21lc3NhZ2UoKSBhcm91bmQgbWRfcmVhcF9zeW5jX3RocmVhZCgpPwoKQWRkIEhl
aW56IGFuZCBKb25hdGhhbiwgY291bGQgeW91IGNvbW1lbnQgYWJvdXQgdGhpcz8gVGhhbmtzLgoK
Pj4KPj4gVGhlIGlzc3VlIGlzIHVuZm9ydHVuYXRlbHkgc3RpbGwgdW5yZXNvbHZlZCAoYXQgbGVh
c3QgTGludXggNS4xMC44MikuIAo+PiBIb3cgY2FuIHdlIG1vdmUgZm9yd2FyZD8KCklmIGl0IGlz
IG5vdCBhcHBsaWNhYmxlIHRvIGNoYW5nZSBkbS1yYWlkLCBhbm90aGVyIGFsdGVybmF0aXZlIGNv
dWxkIGJlIApsaWtlIHRoaXMKCi0tLSBhL2RyaXZlcnMvbWQvbWQuYworKysgYi9kcml2ZXJzL21k
L21kLmMKQEAgLTk0MDksOCArOTQwOSwxMiBAQCB2b2lkIG1kX3JlYXBfc3luY190aHJlYWQoc3Ry
dWN0IG1kZXYgKm1kZGV2KQogwqDCoMKgwqDCoMKgwqAgc2VjdG9yX3Qgb2xkX2Rldl9zZWN0b3Jz
ID0gbWRkZXYtPmRldl9zZWN0b3JzOwogwqDCoMKgwqDCoMKgwqAgYm9vbCBpc19yZXNoYXBlZCA9
IGZhbHNlOwoKK8KgwqDCoMKgwqDCoCBpZiAobWRkZXZfaXNfbG9ja2VkKG1kZGV2KSkKK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRkZXZfdW5sb2NrKG1kZGV2KTsKIMKgwqDCoMKgwqDC
oMKgIC8qIHJlc3luYyBoYXMgZmluaXNoZWQsIGNvbGxlY3QgcmVzdWx0ICovCiDCoMKgwqDCoMKg
wqDCoCBtZF91bnJlZ2lzdGVyX3RocmVhZCgmbWRkZXYtPnN5bmNfdGhyZWFkKTsKK8KgwqDCoMKg
wqDCoCBpZiAobWRkZXZfaXNfbG9ja2VkKG1kZGV2KSkKK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgbWRkZXZfbG9jayhtZGRldik7CiDCoMKgwqDCoMKgwqDCoCBpZiAoIXRlc3RfYml0KE1E
X1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3ZlcnkpICYmCiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICF0ZXN0X2JpdChNRF9SRUNPVkVSWV9SRVFVRVNURUQsICZtZGRldi0+cmVjb3ZlcnkpICYm
CiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1kZGV2LT5kZWdyYWRlZCAhPSBtZGRldi0+cmFpZF9k
aXNrcykgewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9tZC5oIGIvZHJpdmVycy9tZC9tZC5oCmlu
ZGV4IDUzZWE3YTY5NjFkZS4uOTZhODhiNzY4MWQ2IDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL21k
LmgKKysrIGIvZHJpdmVycy9tZC9tZC5oCkBAIC01NDksNiArNTQ5LDExIEBAIHN0YXRpYyBpbmxp
bmUgaW50IG1kZGV2X3RyeWxvY2soc3RydWN0IG1kZGV2ICptZGRldikKIMKgfQogwqBleHRlcm4g
dm9pZCBtZGRldl91bmxvY2soc3RydWN0IG1kZGV2ICptZGRldik7Cgorc3RhdGljIGlubGluZSBp
bnQgbWRkZXZfaXNfbG9ja2VkKHN0cnVjdCBtZGRldiAqbWRkZXYpCit7CivCoMKgwqDCoMKgwqAg
cmV0dXJuIG11dGV4X2lzX2xvY2tlZCgmbWRkZXYtPnJlY29uZmlnX211dGV4KTsKK30KKwoKQlRX
LCBpdCBpcyBob2xpZGF5IHNlYXNvbizCoCBzbyBwZW9wbGUgYXJlIHByb2JhYmx5IG9uIHZhY2F0
aW9uLgoKVGhhbmtzLApHdW9xaW5nCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbA==

