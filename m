Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CBBC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-Lswm8lgFM2OZlmUAkpmcYA-1; Wed, 01 Dec 2021 02:48:01 -0500
X-MC-Unique: Lswm8lgFM2OZlmUAkpmcYA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EB796D4E7;
	Wed,  1 Dec 2021 07:47:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D2295D740;
	Wed,  1 Dec 2021 07:47:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3C5A94BB7C;
	Wed,  1 Dec 2021 07:47:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUHRNQU008904 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 12:27:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6B8AC4047279; Tue, 30 Nov 2021 17:27:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 678674047272
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 17:27:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E83518162C1
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 17:27:23 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-119-ZwAbmk2BMH2QAcR8zQ4DGg-1; Tue, 30 Nov 2021 12:27:18 -0500
X-MC-Unique: ZwAbmk2BMH2QAcR8zQ4DGg-1
Received: from [192.168.0.2] (ip5f5aeac2.dynamic.kabel-deutschland.de
	[95.90.234.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested) (Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 583FE61E5FE02;
	Tue, 30 Nov 2021 18:27:16 +0100 (CET)
Message-ID: <3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
Date: Tue, 30 Nov 2021 18:27:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.2
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
	<36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
	<CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
	<9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
	<CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
	<a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
In-Reply-To: <a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AUHRNQU008904
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
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

W1VwZGF0ZSBHdW9xaW5n4oCZcyBlbWFpbCBhZGRyZXNzXQoKQW0gMzAuMTEuMjEgdW0gMTg6MjUg
c2NocmllYiBQYXVsIE1lbnplbDoKPiBEZWFyIExpbnV4IGZvbGtzLAo+IAo+IAo+IEFtIDIwLjAz
LjIxIHVtIDAwOjAwIHNjaHJpZWIgU29uZyBMaXU6Cj4+IE9uIFdlZCwgRmViIDI0LCAyMDIxIGF0
IDE6MjYgQU0gR3VvcWluZyBKaWFuZyB3cm90ZToKPiAKPj4+IE9uIDIvMjQvMjEgMTA6MDksIFNv
bmcgTGl1IHdyb3RlOgo+Pj4+IE9uIE1vbiwgRmViIDE1LCAyMDIxIGF0IDM6MDggQU0gUGF1bCBN
ZW56ZWwgd3JvdGU6Cj4+Pj4+Cj4+Pj4+IFsrY2MgRG9uYWxkXQo+Pj4+Pgo+Pj4+PiBBbSAxMy4w
Mi4yMSB1bSAwMTo0OSBzY2hyaWViIEd1b3FpbmcgSmlhbmc6Cj4+Pj4+PiBVbnJlZ2lzdGVyIHN5
bmNfdGhyZWFkIGRvZXNuJ3QgbmVlZCB0byBob2xkIHJlY29uZmlnX211dGV4IHNpbmNlIGl0Cj4+
Pj4+PiBkb2Vzbid0IHJlY29uZmlndXJlIGFycmF5Lgo+Pj4+Pj4KPj4+Pj4+IEFuZCBpdCBjb3Vs
ZCBjYXVzZSBkZWFkbG9jayBwcm9ibGVtIGZvciByYWlkNSBhcyBmb2xsb3dzOgo+Pj4+Pj4KPj4+
Pj4+IDEuIHByb2Nlc3MgQSB0cmllZCB0byByZWFwIHN5bmMgdGhyZWFkIHdpdGggcmVjb25maWdf
bXV0ZXggaGVsZCAKPj4+Pj4+IGFmdGVyIGVjaG8KPj4+Pj4+IMKgwqDCoMKgwqAgaWRsZSB0byBz
eW5jX2FjdGlvbi4KPj4+Pj4+IDIuIHJhaWQ1IHN5bmMgdGhyZWFkIHdhcyBibG9ja2VkIGlmIHRo
ZXJlIHdlcmUgdG9vIG1hbnkgYWN0aXZlIAo+Pj4+Pj4gc3RyaXBlcy4KPj4+Pj4+IDMuIFNCX0NI
QU5HRV9QRU5ESU5HIHdhcyBzZXQgKGJlY2F1c2Ugb2Ygd3JpdGUgSU8gY29tZXMgZnJvbSB1cHBl
ciAKPj4+Pj4+IGxheWVyKQo+Pj4+Pj4gwqDCoMKgwqDCoCB3aGljaCBjYXVzZXMgdGhlIG51bWJl
ciBvZiBhY3RpdmUgc3RyaXBlcyBjYW4ndCBiZSBkZWNyZWFzZWQuCj4+Pj4+PiA0LiBTQl9DSEFO
R0VfUEVORElORyBjYW4ndCBiZSBjbGVhcmVkIHNpbmNlIG1kX2NoZWNrX3JlY292ZXJ5IHdhcyAK
Pj4+Pj4+IG5vdCBhYmxlCj4+Pj4+PiDCoMKgwqDCoMKgIHRvIGhvbGQgcmVjb25maWdfbXV0ZXgu
Cj4+Pj4+Pgo+Pj4+Pj4gTW9yZSBkZXRhaWxzIGluIHRoZSBsaW5rOgo+Pj4+Pj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGludXgtcmFpZC81ZWQ1NGZmYy1jZTgyLWJmNjYtNGVmZi0zOTBjYjIz
YmMxYWNAbW9sZ2VuLm1wZy5kZS9ULyN0IAo+Pj4+Pj4KPj4+Pj4+Cj4+Pj4+PiBBbmQgYWRkIG9u
ZSBwYXJhbWV0ZXIgdG8gbWRfcmVhcF9zeW5jX3RocmVhZCBzaW5jZSBpdCBjb3VsZCBiZSAKPj4+
Pj4+IGNhbGxlZCBieQo+Pj4+Pj4gZG0tcmFpZCB3aGljaCBkb2Vzbid0IGhvbGQgcmVjb25maWdf
bXV0ZXguCj4+Pj4+Pgo+Pj4+Pj4gUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTogRG9uYWxkIEJ1Y3pl
ayA8YnVjemVrQG1vbGdlbi5tcGcuZGU+Cj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBHdW9xaW5nIEpp
YW5nIDxndW9xaW5nLmppYW5nQGNsb3VkLmlvbm9zLmNvbT4KPj4+Pgo+Pj4+IEkgZG9uJ3QgcmVh
bGx5IGxpa2UgdGhpcyBmaXguIEJ1dCBJIGhhdmVuJ3QgZ290IGEgYmV0dGVyIChhbmQgbm90IHRv
bwo+Pj4+IGNvbXBsaWNhdGVkKQo+Pj4+IGFsdGVybmF0aXZlLgo+Pj4+Cj4+Pj4+PiAtLS0KPj4+
Pj4+IFYyOgo+Pj4+Pj4gMS4gYWRkIG9uZSBwYXJhbWV0ZXIgdG8gbWRfcmVhcF9zeW5jX3RocmVh
ZCBwZXIgSmFjaydzIHN1Z2dlc3Rpb24uCj4+Pj4+Pgo+Pj4+Pj4gwqDCoMKgIGRyaXZlcnMvbWQv
ZG0tcmFpZC5jIHzCoCAyICstCj4+Pj4+PiDCoMKgwqAgZHJpdmVycy9tZC9tZC5jwqDCoMKgwqDC
oCB8IDE0ICsrKysrKysrKy0tLS0tCj4+Pj4+PiDCoMKgwqAgZHJpdmVycy9tZC9tZC5owqDCoMKg
wqDCoCB8wqAgMiArLQo+Pj4+Pj4gwqDCoMKgIDMgZmlsZXMgY2hhbmdlZCwgMTEgaW5zZXJ0aW9u
cygrKSwgNyBkZWxldGlvbnMoLSkKPj4+Pj4+Cj4+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZC9kbS1yYWlkLmMgYi9kcml2ZXJzL21kL2RtLXJhaWQuYwo+Pj4+Pj4gaW5kZXggY2FiMTJiMi4u
MGM0Y2JiYSAxMDA2NDQKPj4+Pj4+IC0tLSBhL2RyaXZlcnMvbWQvZG0tcmFpZC5jCj4+Pj4+PiAr
KysgYi9kcml2ZXJzL21kL2RtLXJhaWQuYwo+Pj4+Pj4gQEAgLTM2NjgsNyArMzY2OCw3IEBAIHN0
YXRpYyBpbnQgcmFpZF9tZXNzYWdlKHN0cnVjdCBkbV90YXJnZXQgCj4+Pj4+PiAqdGksIHVuc2ln
bmVkIGludCBhcmdjLCBjaGFyICoqYXJndiwKPj4+Pj4+IMKgwqDCoMKgwqDCoMKgIGlmICghc3Ry
Y2FzZWNtcChhcmd2WzBdLCAiaWRsZSIpIHx8ICFzdHJjYXNlY21wKGFyZ3ZbMF0sIAo+Pj4+Pj4g
ImZyb3plbiIpKSB7Cj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG1k
ZGV2LT5zeW5jX3RocmVhZCkgewo+Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzZXRfYml0KE1EX1JFQ09WRVJZX0lOVFIsICZtZGRldi0+cmVjb3Zl
cnkpOwo+Pj4+Pj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbWRf
cmVhcF9zeW5jX3RocmVhZChtZGRldik7Cj4+Pj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBtZF9yZWFwX3N5bmNfdGhyZWFkKG1kZGV2LCBmYWxzZSk7Cj4+Pj4K
Pj4+PiBJIHRoaW5rIHdlIGNhbiBhZGQgbWRkZXZfbG9jaygpIGFuZCBtZGRldl91bmxvY2soKSBo
ZXJlIGFuZCB0aGVuIHdlIAo+Pj4+IGRvbid0Cj4+Pj4gbmVlZCB0aGUgZXh0cmEgcGFyYW1ldGVy
Pwo+Pj4KPj4+IEkgdGhvdWdodCBpdCB0b28sIGJ1dCBJIHdvdWxkIHByZWZlciBnZXQgdGhlIGlu
cHV0IGZyb20gRE0gcGVvcGxlIGZpcnN0Lgo+Pj4KPj4+IEAgTWlrZSBvciBBbGFzZGFpcgo+Pgo+
PiBIaSBNaWtlIGFuZCBBbGFzZGFpciwKPj4KPj4gQ291bGQgeW91IHBsZWFzZSBjb21tZW50IG9u
IHRoaXMgb3B0aW9uOiBhZGRpbmcgbWRkZXZfbG9jaygpIGFuZCAKPj4gbWRkZXZfdW5sb2NrKCkK
Pj4gdG8gcmFpZF9tZXNzYWdlKCkgYXJvdW5kIG1kX3JlYXBfc3luY190aHJlYWQoKT8KPiAKPiBU
aGUgaXNzdWUgaXMgdW5mb3J0dW5hdGVseSBzdGlsbCB1bnJlc29sdmVkIChhdCBsZWFzdCBMaW51
eCA1LjEwLjgyKS4gCj4gSG93IGNhbiB3ZSBtb3ZlIGZvcndhcmQ/Cj4gCj4gCj4gS2luZCByZWdh
cmRzLAo+IAo+IFBhdWwKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

