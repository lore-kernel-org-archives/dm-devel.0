Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF270C433ED
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 16:24:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 51DE46137D
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 16:24:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51DE46137D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-qdvDRdd_MjW8RWp9ku8G4g-1; Fri, 16 Apr 2021 12:24:37 -0400
X-MC-Unique: qdvDRdd_MjW8RWp9ku8G4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80BAD80623B;
	Fri, 16 Apr 2021 16:24:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C99560C16;
	Fri, 16 Apr 2021 16:24:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9AE1544A5F;
	Fri, 16 Apr 2021 16:24:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GGNStD013622 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 12:23:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A99D62021463; Fri, 16 Apr 2021 16:23:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4135202146B
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 16:23:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4588A185A79C
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 16:23:25 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-589-S2UtpQhTOSW_TqefS6-Njw-1;
	Fri, 16 Apr 2021 12:23:23 -0400
X-MC-Unique: S2UtpQhTOSW_TqefS6-Njw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7C2E4B229;
	Fri, 16 Apr 2021 16:23:20 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>
References: <20210415231530.95464-1-snitzer@redhat.com>
	<20210415231530.95464-4-snitzer@redhat.com>
	<6185100e-89e6-0a7f-8901-9ce86fe8f1ac@suse.de>
	<20210416150301.GC16047@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <d5a4867d-5dda-a5b7-2375-658da9630d63@suse.de>
Date: Fri, 16 Apr 2021 18:23:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210416150301.GC16047@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13GGNStD013622
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v2 3/4] nvme: introduce FAILUP handling for
 REQ_FAILFAST_TRANSPORT
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

T24gNC8xNi8yMSA1OjAzIFBNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gT24gRnJpLCBBcHIgMTYg
MjAyMSBhdCAxMDowN2FtIC0wNDAwLAo+IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPiB3
cm90ZToKPiAKPj4gT24gNC8xNi8yMSAxOjE1IEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4+PiBJ
ZiBSRVFfRkFJTEZBU1RfVFJBTlNQT1JUIGlzIHNldCBpdCBtZWFucyB0aGUgZHJpdmVyIHNob3Vs
ZCBub3QgcmV0cnkKPj4+IElPIHRoYXQgY29tcGxldGVkIHdpdGggdHJhbnNwb3J0IGVycm9ycy4g
UkVRX0ZBSUxGQVNUX1RSQU5TUE9SVCBpcwo+Pj4gc2V0IGJ5IG11bHRpcGF0aGluZyBzb2Z0d2Fy
ZSAoZS5nLiBkbS1tdWx0aXBhdGgpIGJlZm9yZSBpdCBpc3N1ZXMgSU8uCj4+Pgo+Pj4gVXBkYXRl
IE5WTWUgdG8gYWxsb3cgZmFpbG92ZXIgb2YgcmVxdWVzdHMgbWFya2VkIHdpdGggZWl0aGVyCj4+
PiBSRVFfTlZNRV9NUEFUSCBvciBSRVFfRkFJTEZBU1RfVFJBTlNQT1JULiBUaGlzIGFsbG93cyBz
dWNoIHJlcXVlc3RzCj4+PiB0byBiZSBnaXZlbiBhIGRpc3Bvc2l0aW9uIG9mIGVpdGhlciBGQUlM
T1ZFUiBvciBGQUlMVVAgcmVzcGVjdGl2ZWx5Lgo+Pj4gRkFJTFVQIGhhbmRsaW5nIGVuc3VyZXMg
YSByZXRyeWFibGUgZXJyb3IgaXMgcmV0dXJuZWQgdXAgZnJvbSBOVk1lLgo+Pj4KPj4+IEludHJv
ZHVjZSBudm1lX2ZhaWx1cF9yZXEoKSBmb3IgdXNlIGluIG52bWVfY29tcGxldGVfcnEoKSBpZgo+
Pj4gbnZtZV9kZWNpZGVfZGlzcG9zaXRpb24oKSByZXR1cm5zIEZBSUxVUC4gbnZtZV9mYWlsdXBf
cmVxKCkgZW5zdXJlcwo+Pj4gdGhlIHJlcXVlc3QgaXMgY29tcGxldGVkIHdpdGggYSByZXRyeWFi
bGUgSU8gZXJyb3Igd2hlbiBhcHByb3ByaWF0ZS4KPj4+IF9fbnZtZV9lbmRfcmVxKCkgd2FzIGZh
Y3RvcmVkIG91dCBmb3IgdXNlIGJ5IGJvdGggbnZtZV9lbmRfcmVxKCkgYW5kCj4+PiBudm1lX2Zh
aWx1cF9yZXEoKS4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJA
cmVkaGF0LmNvbT4KPj4+IC0tLQo+Pj4gIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyB8IDMxICsr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0KPj4+ICAxIGZpbGUgY2hhbmdlZCwgMjYgaW5z
ZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
dm1lL2hvc3QvY29yZS5jIGIvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jCj4+PiBpbmRleCA0MTM0
Y2YzYzdlNDguLjEwMzc1MTk3ZGQ1MyAxMDA2NDQKPj4+IC0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0
L2NvcmUuYwo+Pj4gKysrIGIvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jCj4+PiBAQCAtMjk5LDYg
KzI5OSw3IEBAIGVudW0gbnZtZV9kaXNwb3NpdGlvbiB7Cj4+PiAgCUNPTVBMRVRFLAo+Pj4gIAlS
RVRSWSwKPj4+ICAJRkFJTE9WRVIsCj4+PiArCUZBSUxVUCwKPj4+ICB9Owo+Pj4gIAo+Pj4gIHN0
YXRpYyBpbmxpbmUgZW51bSBudm1lX2Rpc3Bvc2l0aW9uIG52bWVfZGVjaWRlX2Rpc3Bvc2l0aW9u
KHN0cnVjdCByZXF1ZXN0ICpyZXEpCj4+PiBAQCAtMzE4LDEwICszMTksMTEgQEAgc3RhdGljIGlu
bGluZSBlbnVtIG52bWVfZGlzcG9zaXRpb24gbnZtZV9kZWNpZGVfZGlzcG9zaXRpb24oc3RydWN0
IHJlcXVlc3QgKnJlcSkKPj4+ICAJICAgIG52bWVfcmVxKHJlcSktPnJldHJpZXMgPj0gbnZtZV9t
YXhfcmV0cmllcykKPj4+ICAJCXJldHVybiBDT01QTEVURTsKPj4+ICAKPj4+IC0JaWYgKHJlcS0+
Y21kX2ZsYWdzICYgUkVRX05WTUVfTVBBVEgpIHsKPj4+ICsJaWYgKHJlcS0+Y21kX2ZsYWdzICYg
KFJFUV9OVk1FX01QQVRIIHwgUkVRX0ZBSUxGQVNUX1RSQU5TUE9SVCkpIHsKPj4+ICAJCWlmIChu
dm1lX2lzX3BhdGhfZXJyb3IobnZtZV9yZXEocmVxKS0+c3RhdHVzKSB8fAo+Pj4gIAkJICAgIGJs
a19xdWV1ZV9keWluZyhyZXEtPnEpKQo+Pj4gLQkJCXJldHVybiBGQUlMT1ZFUjsKPj4+ICsJCQly
ZXR1cm4gKHJlcS0+Y21kX2ZsYWdzICYgUkVRX05WTUVfTVBBVEgpID8KPj4+ICsJCQkJRkFJTE9W
RVIgOiBGQUlMVVA7Cj4+PiAgCX0gZWxzZSB7Cj4+PiAgCQlpZiAoYmxrX3F1ZXVlX2R5aW5nKHJl
cS0+cSkpCj4+PiAgCQkJcmV0dXJuIENPTVBMRVRFOwo+Pj4gQEAgLTMzMCwxMCArMzMyLDggQEAg
c3RhdGljIGlubGluZSBlbnVtIG52bWVfZGlzcG9zaXRpb24gbnZtZV9kZWNpZGVfZGlzcG9zaXRp
b24oc3RydWN0IHJlcXVlc3QgKnJlcSkKPj4+ICAJcmV0dXJuIFJFVFJZOwo+Pj4gIH0KPj4+ICAK
Pj4+IC1zdGF0aWMgaW5saW5lIHZvaWQgbnZtZV9lbmRfcmVxKHN0cnVjdCByZXF1ZXN0ICpyZXEp
Cj4+PiArc3RhdGljIGlubGluZSB2b2lkIF9fbnZtZV9lbmRfcmVxKHN0cnVjdCByZXF1ZXN0ICpy
ZXEsIGJsa19zdGF0dXNfdCBzdGF0dXMpCj4+PiAgewo+Pj4gLQlibGtfc3RhdHVzX3Qgc3RhdHVz
ID0gbnZtZV9lcnJvcl9zdGF0dXMobnZtZV9yZXEocmVxKS0+c3RhdHVzKTsKPj4+IC0KPj4+ICAJ
aWYgKElTX0VOQUJMRUQoQ09ORklHX0JMS19ERVZfWk9ORUQpICYmCj4+PiAgCSAgICByZXFfb3Ao
cmVxKSA9PSBSRVFfT1BfWk9ORV9BUFBFTkQpCj4+PiAgCQlyZXEtPl9fc2VjdG9yID0gbnZtZV9s
YmFfdG9fc2VjdChyZXEtPnEtPnF1ZXVlZGF0YSwKPj4+IEBAIC0zNDMsNiArMzQzLDI0IEBAIHN0
YXRpYyBpbmxpbmUgdm9pZCBudm1lX2VuZF9yZXEoc3RydWN0IHJlcXVlc3QgKnJlcSkKPj4+ICAJ
YmxrX21xX2VuZF9yZXF1ZXN0KHJlcSwgc3RhdHVzKTsKPj4+ICB9Cj4+PiAgCj4+PiArc3RhdGlj
IGlubGluZSB2b2lkIG52bWVfZW5kX3JlcShzdHJ1Y3QgcmVxdWVzdCAqcmVxKQo+Pj4gK3sKPj4+
ICsJX19udm1lX2VuZF9yZXEocmVxLCBudm1lX2Vycm9yX3N0YXR1cyhudm1lX3JlcShyZXEpLT5z
dGF0dXMpKTsKPj4+ICt9Cj4+PiArCj4+PiArc3RhdGljIHZvaWQgbnZtZV9mYWlsdXBfcmVxKHN0
cnVjdCByZXF1ZXN0ICpyZXEpCj4+PiArewo+Pj4gKwlibGtfc3RhdHVzX3Qgc3RhdHVzID0gbnZt
ZV9lcnJvcl9zdGF0dXMobnZtZV9yZXEocmVxKS0+c3RhdHVzKTsKPj4+ICsKPj4+ICsJaWYgKFdB
Uk5fT05fT05DRSghYmxrX3BhdGhfZXJyb3Ioc3RhdHVzKSkpIHsKPj4+ICsJCXByX2RlYnVnKCJS
ZXF1ZXN0IG1lYW50IGZvciBmYWlsb3ZlciBidXQgYmxrX3N0YXR1c190IChlcnJubz0lZCkgd2Fz
IG5vdCByZXRyeWFibGUuXG4iLAo+Pj4gKwkJCSBibGtfc3RhdHVzX3RvX2Vycm5vKHN0YXR1cykp
Owo+Pj4gKwkJc3RhdHVzID0gQkxLX1NUU19JT0VSUjsKPj4+ICsJfQo+Pj4gKwo+Pj4gKwlfX252
bWVfZW5kX3JlcShyZXEsIHN0YXR1cyk7Cj4+PiArfQo+Pj4gKwo+Pj4gIHZvaWQgbnZtZV9jb21w
bGV0ZV9ycShzdHJ1Y3QgcmVxdWVzdCAqcmVxKQo+Pj4gIHsKPj4+ICAJdHJhY2VfbnZtZV9jb21w
bGV0ZV9ycShyZXEpOwo+Pj4gQEAgLTM2MSw2ICszNzksOSBAQCB2b2lkIG52bWVfY29tcGxldGVf
cnEoc3RydWN0IHJlcXVlc3QgKnJlcSkKPj4+ICAJY2FzZSBGQUlMT1ZFUjoKPj4+ICAJCW52bWVf
ZmFpbG92ZXJfcmVxKHJlcSk7Cj4+PiAgCQlyZXR1cm47Cj4+PiArCWNhc2UgRkFJTFVQOgo+Pj4g
KwkJbnZtZV9mYWlsdXBfcmVxKHJlcSk7Cj4+PiArCQlyZXR1cm47Cj4+PiAgCX0KPj4+ICB9Cj4+
PiAgRVhQT1JUX1NZTUJPTF9HUEwobnZtZV9jb21wbGV0ZV9ycSk7Cj4+Pgo+Pgo+PiBIbW0uIFF1
aXRlIGNvbnZvbHV0ZWQsIG1ldGhpbmtzLgo+IAo+IE1heWJlIHlvdSBkaWRuJ3QgcmVhZCB0aGUg
aGVhZGVyIG9yIHBhdGNoPwo+IAo+IEknbSBjb29sIHdpdGggY3JpdGljYWwgcmV2aWV3IHdoZW4g
aXQgaXMgY2xlYXIgdGhlIHJldmlld2VyIGZ1bGx5Cj4gdW5kZXJzdGFuZHMgdGhlIHBhdGNoIGJ1
dC4uLiA7KQo+IAo+PiBTaG91bGRuJ3QgdGhpcyBhY2hpZXZlIHRoZSBzYW1lIHRoaW5nPwo+Pgo+
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jIGIvZHJpdmVycy9udm1lL2hv
c3QvY29yZS5jCj4+IGluZGV4IGU4OWVjMjUyMmNhNi4uOGMzNmEyMTk2YjY2IDEwMDY0NAo+PiAt
LS0gYS9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMKPj4gKysrIGIvZHJpdmVycy9udm1lL2hvc3Qv
Y29yZS5jCj4+IEBAIC0zMDMsOCArMzAzLDEwIEBAIHN0YXRpYyBpbmxpbmUgZW51bSBudm1lX2Rp
c3Bvc2l0aW9uCj4+IG52bWVfZGVjaWRlX2Rpc3Bvc2l0aW9uKHN0cnVjdCByZXF1ZXN0ICpyZXEp
Cj4+ICAgICAgICAgaWYgKGxpa2VseShudm1lX3JlcShyZXEpLT5zdGF0dXMgPT0gMCkpCj4+ICAg
ICAgICAgICAgICAgICByZXR1cm4gQ09NUExFVEU7Cj4+Cj4+IC0gICAgICAgaWYgKGJsa19ub3Jl
dHJ5X3JlcXVlc3QocmVxKSB8fAo+PiAtICAgICAgICAgICAobnZtZV9yZXEocmVxKS0+c3RhdHVz
ICYgTlZNRV9TQ19ETlIpIHx8Cj4+ICsgICAgICAgaWYgKGJsa19ub3JldHJ5X3JlcXVlc3QocmVx
KSkKPj4gKyAgICAgICAgICAgICAgIG52bWVfcmVxKHJlcSktPnN0YXR1cyB8PSBOVk1FX1NDX0RO
UjsKPj4gKwo+PiArICAgICAgIGlmICgobnZtZV9yZXEocmVxKS0+c3RhdHVzICYgTlZNRV9TQ19E
TlIpIHx8Cj4+ICAgICAgICAgICAgIG52bWVfcmVxKHJlcSktPnJldHJpZXMgPj0gbnZtZV9tYXhf
cmV0cmllcykKPj4gICAgICAgICAgICAgICAgIHJldHVybiBDT01QTEVURTsKPiAKPiBEZWZpbml0
ZWx5IHdvbid0IGFjaGlldmUgdGhlIHNhbWUuIEFuZCBlc3BlY2lhbGx5IG5vdCB3aXRoIHBhdGNo
IDEvNAo+ICgibnZtZTogcmV0dXJuIEJMS19TVFNfRE9fTk9UX1JFVFJZIGlmIHRoZSBETlIgYml0
IGlzIHNldCIpIHRoYXQgeW91Cj4gZ2F2ZSB5b3VyIFJldmlld2VkLWJ5IHRvIGVhcmxpZXIuCj4g
CkFoLiBSaWdodC4gU29ycnkuCgo+IEluc3RlYWQgb2YgIkZBSUxVUCIsIEkgdGhvdWdodCBhYm91
dCB1c2luZyAiRkFJTFVQX0FORF9PVkVSIiB0byBjb252ZXkKPiB0aGF0IHRoaXMgaXMgYSB2YXJp
YW50IG9mIGZhaWxvdmVyLiAgTWVhbmluZyBpdCB0YWtlcyB0aGUgc2FtZSBwYXRjaCBhcwo+IG52
bWUgIkZBSUxPVkVSIiB1bnRpbCB0aGUgdmVyeSBlbmQ7IHdoZXJlIGl0IGRvZXMgUkVRX0ZBSUxG
QVNUX1RSQU5TUE9SVAo+IHNwZWNpZmljIHdvcmsgZGV0YWlsZWQgaW4gbnZtZV9mYWlsdXBfcmVx
KCkuCj4gCkFsbCB2ZXJ5IGludHJpY2F0ZTsgd2lsbCBuZWVkIHRvIGNoZWNrIHRoZSBwYXRjaGVz
IGluIHRoZWlyIGNvbWJpbmVkCnZlcnNpb24uCk5vdCBkZWxpYmVyYXRlbHkgc3RhbGxpbmcsIG1p
bmQgeW91LCBqdXN0IHdhbnRpbmcgdG8gZmlndXJlIG91dCB3aGF0IHRoZQpuZXQgcmVzdWx0IHdp
bGwgYmUuCgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgICAg
S2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICs0
OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgOTA0
MDkgTsO8cm5iZXJnCkdGOiBGLiBJbWVuZMO2cmZmZXIsIEhSQiAzNjgwOSAoQUcgTsO8cm5iZXJn
KQoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

