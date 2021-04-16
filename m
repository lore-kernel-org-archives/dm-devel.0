Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFDAC433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:53:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 99AEA611AC
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:53:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99AEA611AC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-4h0_GVUEOQWsoZxvWYCefw-1; Fri, 16 Apr 2021 09:53:29 -0400
X-MC-Unique: 4h0_GVUEOQWsoZxvWYCefw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 681541006C82;
	Fri, 16 Apr 2021 13:53:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2B1B5C266;
	Fri, 16 Apr 2021 13:53:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88E0044A5E;
	Fri, 16 Apr 2021 13:53:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GDphpB031543 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 09:51:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2B28320BDB1C; Fri, 16 Apr 2021 13:51:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 258EA20BDB1D
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 13:51:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DE5F8030A0
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 13:51:40 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-159-2vpMrRxFPpqTiaixgBP2Lg-1;
	Fri, 16 Apr 2021 09:51:36 -0400
X-MC-Unique: 2vpMrRxFPpqTiaixgBP2Lg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 88BDFB12D;
	Fri, 16 Apr 2021 13:51:34 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
References: <20210415231530.95464-1-snitzer@redhat.com>
	<20210415231530.95464-2-snitzer@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <afeb4a15-eed3-9544-439e-f69b9eff5ad7@suse.de>
Date: Fri, 16 Apr 2021 15:51:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210415231530.95464-2-snitzer@redhat.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13GDphpB031543
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] [PATCH v2 1/4] nvme: return BLK_STS_DO_NOT_RETRY if
 the DNR bit is set
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8xNi8yMSAxOjE1IEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gSWYgdGhlIEROUiBiaXQg
aXMgc2V0IHdlIHNob3VsZCBub3QgcmV0cnkgdGhlIGNvbW1hbmQuCj4gCj4gV2UgY2FyZSBhYm91
dCB0aGUgcmV0cnlhYmxlIHZzIG5vdCByZXRyeWFibGUgZGlzdGluY3Rpb24gYXQgdGhlIGJsb2Nr
Cj4gbGF5ZXIgc28gcHJvcGFnYXRlIHRoZSBlcXVpdmFsZW50IG9mIHRoZSBETlIgYml0IGJ5IGlu
dHJvZHVjaW5nCj4gQkxLX1NUU19ET19OT1RfUkVUUlkuIFVwZGF0ZSBibGtfcGF0aF9lcnJvcigp
IHRvIF9ub3RfIHJldHJ5IGlmIGl0Cj4gaXMgc2V0Lgo+IAo+IFRoaXMgY2hhbmdlIHJ1bnMgd2l0
aCB0aGUgc3VnZ2VzdGlvbiBtYWRlIGhlcmU6Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgtbnZtZS8yMDE5MDgxMzE3MDE0NC5HQTEwMjY5QGxzdC5kZS8KPiAKPiBTdWdnZXN0ZWQtYnk6
IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgU25p
dHplciA8c25pdHplckByZWRoYXQuY29tPgo+IC0tLQo+ICBkcml2ZXJzL252bWUvaG9zdC9jb3Jl
LmMgIHwgMyArKysKPiAgaW5jbHVkZS9saW51eC9ibGtfdHlwZXMuaCB8IDggKysrKysrKysKPiAg
MiBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbnZtZS9ob3N0L2NvcmUuYyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYwo+IGluZGV4IDA4
OTZlMjE2NDJiZS4uNTQwZDZmZDhmZmVmIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvbnZtZS9ob3N0
L2NvcmUuYwo+ICsrKyBiL2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYwo+IEBAIC0yMzcsNiArMjM3
LDkgQEAgc3RhdGljIHZvaWQgbnZtZV9kZWxldGVfY3RybF9zeW5jKHN0cnVjdCBudm1lX2N0cmwg
KmN0cmwpCj4gIAo+ICBzdGF0aWMgYmxrX3N0YXR1c190IG52bWVfZXJyb3Jfc3RhdHVzKHUxNiBz
dGF0dXMpCj4gIHsKPiArCWlmICh1bmxpa2VseShzdGF0dXMgJiBOVk1FX1NDX0ROUikpCj4gKwkJ
cmV0dXJuIEJMS19TVFNfRE9fTk9UX1JFVFJZOwo+ICsKPiAgCXN3aXRjaCAoc3RhdHVzICYgMHg3
ZmYpIHsKPiAgCWNhc2UgTlZNRV9TQ19TVUNDRVNTOgo+ICAJCXJldHVybiBCTEtfU1RTX09LOwo+
IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIGIvaW5jbHVkZS9saW51eC9i
bGtfdHlwZXMuaAo+IGluZGV4IGRiMDI2YjZlYzE1YS4uMWNhNzI0OTQ4YzU2IDEwMDY0NAo+IC0t
LSBhL2luY2x1ZGUvbGludXgvYmxrX3R5cGVzLmgKPiArKysgYi9pbmNsdWRlL2xpbnV4L2Jsa190
eXBlcy5oCj4gQEAgLTE0Miw2ICsxNDIsMTMgQEAgdHlwZWRlZiB1OCBfX2JpdHdpc2UgYmxrX3N0
YXR1c190Owo+ICAgKi8KPiAgI2RlZmluZSBCTEtfU1RTX1pPTkVfQUNUSVZFX1JFU09VUkNFCSgo
X19mb3JjZSBibGtfc3RhdHVzX3QpMTYpCj4gIAo+ICsvKgo+ICsgKiBCTEtfU1RTX0RPX05PVF9S
RVRSWSBpcyByZXR1cm5lZCBmcm9tIHRoZSBkcml2ZXIgaW4gdGhlIGNvbXBsZXRpb24gcGF0aAo+
ICsgKiBpZiB0aGUgZGV2aWNlIHJldHVybnMgYSBzdGF0dXMgaW5kaWNhdGluZyB0aGF0IGlmIHRo
ZSBzYW1lIGNvbW1hbmQgaXMKPiArICogcmUtc3VibWl0dGVkIGl0IGlzIGV4cGVjdGVkIHRvIGZh
aWwuCj4gKyAqLwo+ICsjZGVmaW5lIEJMS19TVFNfRE9fTk9UX1JFVFJZCSgoX19mb3JjZSBibGtf
c3RhdHVzX3QpMTcpCj4gKwo+ICAvKioKPiAgICogYmxrX3BhdGhfZXJyb3IgLSByZXR1cm5zIHRy
dWUgaWYgZXJyb3IgbWF5IGJlIHBhdGggcmVsYXRlZAo+ICAgKiBAZXJyb3I6IHN0YXR1cyB0aGUg
cmVxdWVzdCB3YXMgY29tcGxldGVkIHdpdGgKPiBAQCAtMTU3LDYgKzE2NCw3IEBAIHR5cGVkZWYg
dTggX19iaXR3aXNlIGJsa19zdGF0dXNfdDsKPiAgc3RhdGljIGlubGluZSBib29sIGJsa19wYXRo
X2Vycm9yKGJsa19zdGF0dXNfdCBlcnJvcikKPiAgewo+ICAJc3dpdGNoIChlcnJvcikgewo+ICsJ
Y2FzZSBCTEtfU1RTX0RPX05PVF9SRVRSWToKPiAgCWNhc2UgQkxLX1NUU19OT1RTVVBQOgo+ICAJ
Y2FzZSBCTEtfU1RTX05PU1BDOgo+ICAJY2FzZSBCTEtfU1RTX1RBUkdFVDoKPiAKUmV2aWV3ZWQt
Ynk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKSGFubmVzCi0tIApEci4gSGFubmVz
IFJlaW5lY2tlCQkgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUJ
CQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9u
cyBHZXJtYW55IEdtYkgsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZykKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxA
cmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2Rt
LWRldmVs

