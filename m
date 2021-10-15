Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0345EC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:26:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 82FE361056
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 19:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 82FE361056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-nGQ4KPAtN2y-qfTWuKSCJg-1; Fri, 15 Oct 2021 15:26:27 -0400
X-MC-Unique: nGQ4KPAtN2y-qfTWuKSCJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BE931005547;
	Fri, 15 Oct 2021 19:26:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 620165D9DE;
	Fri, 15 Oct 2021 19:26:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 389E81806D04;
	Fri, 15 Oct 2021 19:26:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FJQ38C025579 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 15:26:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5BE1F2166B2F; Fri, 15 Oct 2021 19:26:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 567282166B25
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:25:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56C3618A0169
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 19:25:58 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-576-DLs0J4IAMguoYLKAQ5526A-1;
	Fri, 15 Oct 2021 15:25:54 -0400
X-MC-Unique: DLs0J4IAMguoYLKAQ5526A-1
Received: from [10.137.106.139] (unknown [131.107.159.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 217B720B9D2B;
	Fri, 15 Oct 2021 12:25:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 217B720B9D2B
Message-ID: <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
Date: Fri, 15 Oct 2021 12:25:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.2.0
To: Eric Biggers <ebiggers@kernel.org>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
	<1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
	<YWcyYBuNppjrVOe2@gmail.com>
From: Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <YWcyYBuNppjrVOe2@gmail.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19FJQ38C025579
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-security-module@vger.kernel.org, tytso@mit.edu,
	paul@paul-moore.com, snitzer@redhat.com, corbet@lwn.net,
	jannh@google.com, linux-doc@vger.kernel.org, jmorris@namei.org,
	eparis@redhat.com, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-audit@redhat.com, linux-fscrypt@vger.kernel.org,
	agk@redhat.com, serge@hallyn.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

Ck9uIDEwLzEzLzIwMjEgMTI6MjQgUE0sIEVyaWMgQmlnZ2VycyB3cm90ZToKPiBPbiBXZWQsIE9j
dCAxMywgMjAyMSBhdCAxMjowNjozMVBNIC0wNzAwLCBkZXZlbi5kZXNhaUBsaW51eC5taWNyb3Nv
ZnQuY29tIHdyb3RlOgo+PiBGcm9tOiBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+
Cj4+Cj4+IEFkZCBzZWN1cml0eV9pbm9kZV9zZXRzZWN1cml0eSB0byBmc3Zlcml0eSBzaWduYXR1
cmUgdmVyaWZpY2F0aW9uLgo+PiBUaGlzIGNhbiBsZXQgTFNNcyBzYXZlIHRoZSBzaWduYXR1cmUg
ZGF0YSBhbmQgZGlnZXN0IGhhc2hlcyBwcm92aWRlZAo+PiBieSBmc3Zlcml0eS4KPiBDYW4geW91
IGVsYWJvcmF0ZSBvbiB3aHkgTFNNcyBuZWVkIHRoaXMgaW5mb3JtYXRpb24/CgpUaGUgcHJvcG9z
ZWQgTFNNIChJUEUpIG9mIHRoaXMgc2VyaWVzIHdpbGwgYmUgdGhlIG9ubHkgb25lIHRvIG5lZWQK
dGhpcyBpbmZvcm1hdGlvbiBhdCB0aGXCoCBtb21lbnQuIElQReKAmXMgZ29hbCBpcyB0byBoYXZl
IHByb3ZpZGUKdHJ1c3QtYmFzZWQgYWNjZXNzIGNvbnRyb2wuIFRydXN0IGFuZCBJbnRlZ3JpdHkg
YXJlIHRpZWQgdG9nZXRoZXIsCmFzIHlvdSBjYW5ub3QgcHJvdmUgdHJ1c3Qgd2l0aG91dCBwcm92
aW5nIGludGVncml0eS4KCklQRSBuZWVkcyB0aGUgZGlnZXN0IGluZm9ybWF0aW9uIHRvIGJlIGFi
bGUgdG8gY29tcGFyZSBhIGRpZ2VzdApwcm92aWRlZCBieSB0aGUgcG9saWN5IGF1dGhvciwgYWdh
aW5zdCB0aGUgZGlnZXN0IGNhbGN1bGF0ZWQgYnkKZnN2ZXJpdHkgdG8gbWFrZSBhIGRlY2lzaW9u
IG9uIHdoZXRoZXIgdGhhdCBzcGVjaWZpYyBmaWxlLCByZXByZXNlbnRlZApieSB0aGUgZGlnZXN0
IGlzIGF1dGhvcml6ZWQgZm9yIHRoZSBhY3Rpb25zIHNwZWNpZmllZCBpbiB0aGUgcG9saWN5LgoK
QSBtb3JlIGNvbmNyZXRlIGV4YW1wbGUsIGlmIGFuIElQRSBwb2xpY3kgYXV0aG9yIHdyaXRlczoK
CiDCoMKgwqAgb3A9RVhFQ1VURSBmc3Zlcml0eV9kaWdlc3Q9PEhleERpZ2VzdCA+IGFjdGlvbj1E
RU5ZCgpJUEUgdGFrZXMgdGhlIGRpZ2VzdCBwcm92aWRlZCBieSB0aGlzIHNlY3VyaXR5IGhvb2ss
IHN0b3JlcyBpdAppbiBJUEUncyBzZWN1cml0eSBibG9iIG9uIHRoZSBpbm9kZS4gSWYgdGhpcyBm
aWxlIGlzIGxhdGVyCmV4ZWN1dGVkLCBJUEUgY29tcGFyZXMgdGhlIGRpZ2VzdCBzdG9yZWQgaW4g
dGhlIExTTSBibG9iLApwcm92aWRlZCBieSB0aGlzIGhvb2ssIGFnYWluc3QgPEhleERpZ2VzdD4g
aW4gdGhlIHBvbGljeSwgaWYKaXQgbWF0Y2hlcywgaXQgZGVuaWVzIHRoZSBhY2Nlc3MsIHBlcmZv
cm1pbmcgYSByZXZvY2F0aW9uCm9mIHRoYXQgZmlsZS4KClRoaXMgYnJpbmdzIG1lIHRvIHlvdXIg
bmV4dCBjb21tZW50OgoKID4gVGhlIGRpZ2VzdCBpc24ndCBtZWFuaW5nZnVsIHdpdGhvdXQga25v
d2luZyB0aGUgaGFzaCBhbGdvcml0aG0gaXQgdXNlcy4KSXQncyBhdmFpbGFibGUgaGVyZSwgYnV0
IHlvdSBhcmVuJ3QgcGFzc2luZyBpdCB0byB0aGlzIGZ1bmN0aW9uLgoKVGhlIGRpZ2VzdCBpcyBt
ZWFuaW5nZnVsIHdpdGhvdXQgdGhlIGFsZ29yaXRobSBpbiB0aGlzIGNhc2UuCklQRSBkb2VzIG5v
dCB3YW50IHRvIHJlY2FsY3VsYXRlIGEgZGlnZXN0LCB0aGF04oCZcyBleHBlbnNpdmUgYW5kCmRv
ZXNu4oCZdCBwcm92aWRlIGFueSB2YWx1ZS4gSVBFLCBpbiB0aGlzIGNhc2UsIHRyZWF0cyB0aGlz
IGFzIGEKYnVmZmVyIHRvIGNvbXBhcmUgdGhlIHBvbGljeS1wcm92aWRlZCBvbmUgYWJvdmUgdG8g
bWFrZSBhCnBvbGljeSBkZWNpc2lvbiBhYm91dCBhY2Nlc3MgdG8gdGhlIHJlc291cmNlLgoKPj4g
QWxzbyBjaGFuZ2VzIHRoZSBpbXBsZW1lbnRhaW9uIGluc2lkZSB0aGUgaG9vayBmdW5jdGlvbiB0
byBsZXQKPj4gbXVsdGlwbGUgTFNNcyBjYW4gYWRkIGhvb2tzLgo+IFBsZWFzZSBzcGxpdCBmcy92
ZXJpdHkvIGNoYW5nZXMgYW5kIHNlY3VyaXR5LyBjaGFuZ2VzIGludG8gc2VwYXJhdGUgcGF0Y2hl
cywgaWYKPiBwb3NzaWJsZS4KClNvcnJ5LCB3aWxsIGRvLCBub3QgYSBwcm9ibGVtLgoKPj4gQEAg
LTE3Nyw2ICsxNzgsMTcgQEAgc3RydWN0IGZzdmVyaXR5X2luZm8gKmZzdmVyaXR5X2NyZWF0ZV9p
bmZvKGNvbnN0IHN0cnVjdCBpbm9kZSAqaW5vZGUsCj4+ICAgCQlmc3Zlcml0eV9lcnIoaW5vZGUs
ICJFcnJvciAlZCBjb21wdXRpbmcgZmlsZSBkaWdlc3QiLCBlcnIpOwo+PiAgIAkJZ290byBvdXQ7
Cj4+ICAgCX0KPj4gKwo+PiArCWVyciA9IHNlY3VyaXR5X2lub2RlX3NldHNlY3VyaXR5KChzdHJ1
Y3QgaW5vZGUgKilpbm9kZSwKPiBJZiBhIG5vbi1jb25zdCBpbm9kZSBpcyBuZWVkZWQsIHBsZWFz
ZSBwcm9wYWdhdGUgdGhhdCBpbnRvIHRoZSBjYWxsZXJzIHJhdGhlcgo+IHRoYW4gcmFuZG9tbHkg
Y2FzdGluZyBhd2F5IHRoZSBjb25zdC4KPgo+PiArCQkJCQkgRlNfVkVSSVRZX0RJR0VTVF9TRUNf
TkFNRSwKPj4gKwkJCQkJIHZpLT5maWxlX2RpZ2VzdCwKPj4gKwkJCQkJIHZpLT50cmVlX3BhcmFt
cy5oYXNoX2FsZy0+ZGlnZXN0X3NpemUsCj4+ICsJCQkJCSAwKTsKPj4gQEAgLTg0LDcgKzg1LDkg
QEAgaW50IGZzdmVyaXR5X3ZlcmlmeV9zaWduYXR1cmUoY29uc3Qgc3RydWN0IGZzdmVyaXR5X2lu
Zm8gKnZpLAo+PiAgIAo+PiAgIAlwcl9kZWJ1ZygiVmFsaWQgc2lnbmF0dXJlIGZvciBmaWxlIGRp
Z2VzdCAlczolKnBoTlxuIiwKPj4gICAJCSBoYXNoX2FsZy0+bmFtZSwgaGFzaF9hbGctPmRpZ2Vz
dF9zaXplLCB2aS0+ZmlsZV9kaWdlc3QpOwo+PiAtCXJldHVybiAwOwo+PiArCXJldHVybiBzZWN1
cml0eV9pbm9kZV9zZXRzZWN1cml0eSgoc3RydWN0IGlub2RlICopaW5vZGUsCj4+Cj4gTGlrZXdp
c2UsIHBsZWFzZSBkb24ndCBjYXN0IGF3YXkgY29uc3QuCgpTb3JyeSwgSSBzaG91bGQndmUgY2F1
Z2h0IHRoZXNlIG15c2VsZi4gSSdsbCBjaGFuZ2UKZnN2ZXJpdHlfY3JlYXRlX2luZm8gdG8gYWNj
ZXB0IHRoZSBub24tY29uc3QgaW5vZGUsIGFuZApjaGFuZ2UgZnN2ZXJpdHlfdmVyaWZ5X3NpZ25h
dHVyZSB0byBhY2NlcHQgYW4gYWRkaXRpb25hbCBpbm9kZQpzdHJ1Y3QgYXMgdGhlIGZpcnN0IGFy
ZyBpbnN0ZWFkIG9mIGNoYW5naW5nIHRoZSBmc3Zlcml0eV9pbmZvCnN0cnVjdHVyZSB0byBoYXZl
IGEgbm9uLWNvbnN0IGlub2RlIGZpZWxkLgoKPj4gKwkJCQkJRlNfVkVSSVRZX1NJR05BVFVSRV9T
RUNfTkFNRSwKPj4gKwkJCQkJc2lnbmF0dXJlLCBzaWdfc2l6ZSwgMCk7Cj4gVGhpcyBpcyBvbmx5
IGZvciBmcy12ZXJpdHkgYnVpbHQtaW4gc2lnbmF0dXJlcyB3aGljaCBhcmVuJ3QgdGhlIG9ubHkg
d2F5IHRvIGRvCj4gc2lnbmF0dXJlcyB3aXRoIGZzLXZlcml0eS4gIEFyZSB5b3Ugc3VyZSB0aGlz
IGlzIHdoYXQgeW91J3JlIGxvb2tpbmcgZm9yPwoKQ291bGQgeW91IGVsYWJvcmF0ZSBvbiB0aGUg
b3RoZXIgc2lnbmF0dXJlIHR5cGVzIHRoYXQgY2FuIGJlIHVzZWQKd2l0aCBmcy12ZXJpdHk/IEni
gJltIDk5JSBzdXJlIHRoaXMgaXMgd2hhdCBJ4oCZbSBsb29raW5nIGZvciBhcyB0aGlzCmlzIGEg
c2lnbmF0dXJlIHZhbGlkYXRlZCBpbiB0aGUga2VybmVsIGFnYWluc3QgdGhlIGZzLXZlcml0eSBr
ZXlyaW5nCmFzIHBhcnQgb2YgdGhlIOKAnGZzdmVyaXR5IGVuYWJsZeKAnSB1dGlsaXR5LgoKSXQn
cyBpbXBvcnRhbnQgdGhhdCB0aGUgc2lnbmF0dXJlIGlzIHZhbGlkYXRlZCBpbiB0aGUga2VybmVs
LCBhcwp1c2Vyc3BhY2UgaXMgY29uc2lkZXJlZCB1bnRydXN0ZWQgdW50aWwgdGhlIHNpZ25hdHVy
ZSBpcyB2YWxpZGF0ZWQKZm9yIHRoaXMgY2FzZS4KCj4gQ2FuIHlvdSBlbGFib3JhdGUgb24geW91
ciB1c2UgY2FzZSBmb3IgZnMtdmVyaXR5IGJ1aWx0LWluIHNpZ25hdHVyZXMsClN1cmUsIHNpZ25h
dHVyZXMsIGxpa2UgZGlnZXN0cywgYWxzbyBwcm92aWRlIGEgd2F5IHRvIHByb3ZlIGludGVncml0
eSwKYW5kIHRoZSB0cnVzdCBjb21wb25lbnQgY29tZXMgZnJvbSB0aGUgdmFsaWRhdGlvbiBhZ2Fp
bnN0IHRoZSBrZXlyaW5nLAphcyBvcHBvc2VkIHRvIGEgZml4ZWQgdmFsdWUgaW4gSVBF4oCZcyBw
b2xpY3kuIFRoZSB1c2UgY2FzZSBmb3IgZnMtdmVyaXR5CmJ1aWx0LWluIHNpZ25hdHVyZXMgaXMg
dGhhdCB3ZSBoYXZlIGEgcncgZXh0NCBmaWxlc3lzdGVtIHRoYXQgaGFzIHNvbWUKZXhlY3V0YWJs
ZSBmaWxlcywgYW5kIHdlIHdhbnQgdG8gaGF2ZSBhIGV4ZWN1dGlvbiBwb2xpY3kgKHRocm91Z2gg
SVBFKQp0aGF0IG9ubHkgX3RydXN0ZWRfIGV4ZWN1dGFibGVzIGNhbiBydW4uIFBlcmYgaXMgaW1w
b3J0YW50IGhlcmUsIGhlbmNlCmZzLXZlcml0eS4KCj4gYW5kIHdoYXQgdGhlIExTTSBob29rIHdp
bGwgZG8gd2l0aCB0aGVtPwoKQXQgdGhlIG1vbWVudCwgdGhpcyB3aWxsIGp1c3Qgc2lnbmFsIHRv
IElQRSB0aGF0IHRoZXNlIGZzLXZlcml0eSBmaWxlcyB3ZXJlCmVuYWJsZWQgd2l0aCBhIGJ1aWx0
LWluIHNpZ25hdHVyZSBhcyBvcHBvc2VkIHRvIGVuYWJsZWQgd2l0aG91dCBhIHNpZ25hdHVyZS4K
SW4gdjcsIGl0IGNvcGllcyB0aGUgc2lnbmF0dXJlIGRhdGEgaW50byBJUEUncyBMU00gYmxvYiBh
dHRhY2hlZCB0byB0aGUgCmlub2RlLgpJbiB2OCssIEknbSBjaGFuZ2luZyB0aGlzIHRvIHN0b3Jl
IOKAnHRydWXigJ0gaW4gSVBFJ3MgTFNNIGJsb2IgaW5zdGVhZCwgYXMgCmNvcHlpbmcKdGhlIHNp
Z25hdHVyZSBkYXRhIGlzIGFuIHVubmVjZXNzYXJ5IHdhc3RlIG9mIHNwYWNlIGFuZCBwb2ludCBv
ZiAKZmFpbHVyZS4gVGhpcwpoYXMgYSBfc2xpZ2h0bHlfIGRpZmZlcmVudCBmdW5jdGlvbmFsaXR5
IHRoZW4gZnMudmVyaXR5LnJlcXVpcmVfc2lnbmF0dXJlcywKYmVjYXVzZSBldmVuIGlmIHNvbWVv
bmUgd2VyZSB0byBkaXNhYmxlIHRoZSByZXF1aXJlIHNpZ25hdHVyZXMgb3B0aW9uLCBJUEUKd291
bGQgc3RpbGwga25vdyBpZiB0aGVzZSBmaWxlcyB3ZXJlIHNpZ25lZCBvciBub3QgYW5kIGJlIGFi
bGUgdG8gbWFrZSB0aGUKYWNjZXNzIGNvbnRyb2wgZGVjaXNpb24gYmFzZWQgSVBFJ3MgcG9saWN5
LgoKVmVyeSBjb25jcmV0ZWx5LCB0aGlzIHBvd2VycyB0aGlzIGtpbmQgb2YgcnVsZSBpbiBJUEU6
CgogwqAgb3A9RVhFQ1VURSBmc3Zlcml0eV9zaWduYXR1cmU9VFJVRSBhY3Rpb249QUxMT1cKCmlm
IHRoYXQgZnN2ZXJpdHlfc2lnbmF0dXJlIHZhbHVlIGluIElQReKAmXMgTFNNIGJsb2IgYXR0YWNo
ZWQgdG8gdGhlIGlub2RlIGlzCnRydWUsIHRoZW4gZnN2ZXJpdHlfc2lnbmF0dXJlIGluIElQReKA
mXMgcG9saWN5IHdpbGwgZXZhbHVhdGUgdG8gdHJ1ZSBhbmQgCm1hdGNoCnRoaXMgcnVsZS4gVGhl
IGludmVyc2UgaXMgYWxzbyBhcHBsaWNhYmxlLgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw=

