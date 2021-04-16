Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F6AC433B4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 05:58:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 995BC61184
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 05:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 995BC61184
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179--q2iG1rZMi-CB3Gr_XlO_g-1; Fri, 16 Apr 2021 01:58:36 -0400
X-MC-Unique: -q2iG1rZMi-CB3Gr_XlO_g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3629383DD23;
	Fri, 16 Apr 2021 05:58:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C5BF847;
	Fri, 16 Apr 2021 05:58:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D4CBD9998;
	Fri, 16 Apr 2021 05:58:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G5wOpK013989 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 01:58:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 19A17FDCF9; Fri, 16 Apr 2021 05:58:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12691FDCF7
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 05:58:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92ECD101A52C
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 05:58:20 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-491-4f1A_TS-PHSVxol8fyqDdg-1;
	Fri, 16 Apr 2021 01:58:17 -0400
X-MC-Unique: 4f1A_TS-PHSVxol8fyqDdg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 23572AFEA;
	Fri, 16 Apr 2021 05:58:16 +0000 (UTC)
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
References: <20210415231126.8746-1-snitzer@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <c715a982-4a75-d30f-e6f6-15ad125e7b89@suse.de>
Date: Fri, 16 Apr 2021 07:58:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210415231126.8746-1-snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13G5wOpK013989
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org
Subject: Re: [dm-devel] nvme: Return BLK_STS_TARGET if the DNR bit is set
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNC8xNi8yMSAxOjExIEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gQlo6IDE5NDg2OTAKPiBV
cHN0cmVhbSBTdGF0dXM6IFJIRUwtb25seQo+IAo+IFNpZ25lZC1vZmYtYnk6IE1pa2UgU25pdHpl
ciA8c25pdHplckByZWRoYXQuY29tPgo+IAo+IHJoZWwtOC5naXQgY29tbWl0IGVmNGFiOTBjMTJk
YjVlMGU1MDgwMGVjMzIzNzM2Yjk1YmU3YTZmZjUKPiBBdXRob3I6IE1pa2UgU25pdHplciA8c25p
dHplckByZWRoYXQuY29tPgo+IERhdGU6ICAgVHVlIEF1ZyAyNSAyMTo1Mjo0NSAyMDIwIC0wNDAw
Cj4gCj4gICAgIFtudm1lXSBudm1lOiBSZXR1cm4gQkxLX1NUU19UQVJHRVQgaWYgdGhlIEROUiBi
aXQgaXMgc2V0Cj4gICAgIAo+ICAgICBNZXNzYWdlLWlkOiA8MjAyMDA4MjUyMTUyNDguMjI5MS04
LXNuaXR6ZXJAcmVkaGF0LmNvbT4KPiAgICAgUGF0Y2h3b3JrLWlkOiAzMjUxNzgKPiAgICAgUGF0
Y2h3b3JrLWluc3RhbmNlOiBwYXRjaHdvcmsKPiAgICAgTy1TdWJqZWN0OiBbUkhFTDguMyBQQVRD
SCAwNy8xMF0gbnZtZTogUmV0dXJuIEJMS19TVFNfVEFSR0VUIGlmIHRoZSBETlIgYml0IGlzIHNl
dAo+ICAgICBCdWd6aWxsYTogMTg0MzUxNQo+ICAgICBSSC1BY2tlZC1ieTogRGF2aWQgTWlsYnVy
biA8ZG1pbGJ1cm5AcmVkaGF0LmNvbT4KPiAgICAgUkgtQWNrZWQtYnk6IEdvcGFsIFRpd2FyaSA8
Z3Rpd2FyaUByZWRoYXQuY29tPgo+ICAgICBSSC1BY2tlZC1ieTogRXdhbiBNaWxuZSA8ZW1pbG5l
QHJlZGhhdC5jb20+Cj4gICAgIAo+ICAgICBCWjogMTg0MzUxNQo+ICAgICBVcHN0cmVhbSBTdGF0
dXM6IFJIRUwtb25seQo+ICAgICAKPiAgICAgSWYgdGhlIEROUiBiaXQgaXMgc2V0IHdlIHNob3Vs
ZCBub3QgcmV0cnkgdGhlIGNvbW1hbmQsIGV2ZW4gaWYKPiAgICAgdGhlIHN0YW5kYXJkIHN0YXR1
cyBldmFsdWF0aW9uIGluZGljYXRlcyBzby4KPiAgICAgCj4gICAgIFNVU0UgaXMgY2Fycnlpbmcg
dGhpcyBwYXRjaCBpbiB0aGVpciBrZXJuZWw6Cj4gICAgIGh0dHBzOi8vbHduLm5ldC9BcnRpY2xl
cy84MDAzNzAvCj4gICAgIAo+ICAgICBCYXNlZCBvbiBwYXRjaCBwb3N0ZWQgZm9yIHVwc3RyZWFt
IGluY2x1c2lvbiBidXQgcmVqZWN0ZWQ6Cj4gICAgIHYxOiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9saW51eC1udm1lLzIwMTkwODA2MTExMDM2LjExMzIzMy0xLWhhcmVAc3VzZS5kZS8KPiAgICAg
djI6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUvMjAxOTA4MDcwNzEyMDguMTAx
ODgyLTEtaGFyZUBzdXNlLmRlLwo+ICAgICB2Mi1rZWl0aDogaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvbGludXgtbnZtZS8yMDE5MDgwNzE0NDcyNS5HQjI1NjIxQGxvY2FsaG9zdC5sb2NhbGRvbWFp
bi8KPiAgICAgdjM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LW52bWUvMjAxOTA4MTIw
NzUxNDcuNzk1OTgtMS1oYXJlQHN1c2UuZGUvCj4gICAgIHYzLWtlaXRoOiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC1udm1lLzIwMTkwODEzMTQxNTEwLkdCMzI2ODZAbG9jYWxob3N0Lmxv
Y2FsZG9tYWluLwo+ICAgICAKPiAgICAgVGhpcyBjb21taXQncyBjaGFuZ2UgaXMgYmFzaWNhbGx5
ICJ2My1rZWl0aCIuCj4gICAgIAo+ICAgICBTaWduZWQtb2ZmLWJ5OiBNaWtlIFNuaXR6ZXIgPHNu
aXR6ZXJAcmVkaGF0LmNvbT4KPiAgICAgU2lnbmVkLW9mZi1ieTogRnJhbnRpc2VrIEhyYmF0YSA8
ZmhyYmF0YUByZWRoYXQuY29tPgo+IAo+IC0tLQo+ICBkcml2ZXJzL252bWUvaG9zdC9jb3JlLmMg
fCAgICAzICsrKwo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspCj4gCj4gSW5kZXg6
IGxpbnV4LXJoZWw5L2RyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYwo+ID09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KPiAtLS0g
bGludXgtcmhlbDkub3JpZy9kcml2ZXJzL252bWUvaG9zdC9jb3JlLmMKPiArKysgbGludXgtcmhl
bDkvZHJpdmVycy9udm1lL2hvc3QvY29yZS5jCj4gQEAgLTIzNyw2ICsyMzcsOSBAQCBzdGF0aWMg
dm9pZCBudm1lX2RlbGV0ZV9jdHJsX3N5bmMoc3RydWN0Cj4gIAo+ICBzdGF0aWMgYmxrX3N0YXR1
c190IG52bWVfZXJyb3Jfc3RhdHVzKHUxNiBzdGF0dXMpCj4gIHsKPiArCWlmICh1bmxpa2VseShz
dGF0dXMgJiBOVk1FX1NDX0ROUikpCj4gKwkJcmV0dXJuIEJMS19TVFNfVEFSR0VUOwo+ICsKPiAg
CXN3aXRjaCAoc3RhdHVzICYgMHg3ZmYpIHsKPiAgCWNhc2UgTlZNRV9TQ19TVUNDRVNTOgo+ICAJ
CXJldHVybiBCTEtfU1RTX09LOwo+IApObzsgdGhpcyBpcyBtb3N0IGxpa2VseSB3cm9uZyBmb3Ig
cXVpdGUgc29tZSBtYWNoaW5lcy4KQXQgdGhpcyB0aW1lIHdlIGRvbid0IGhhdmUgYSBmaXhlZCBt
YXBwaW5nIGZvciB0aGUgRE5SIGJpdDsKc29tZSBCTEtfU1RTX1hYIGNvZGVzIGNhbiBiZSByZXRy
aWVkLCBzb21lIG1pZ2h0LCBvdGhlcnMgc2hvdWxkIG5vdDsgd2UKbmV2ZXIgd2VudCBzbyBmYXIg
YXMgdG8gZm9ybWFsbHkgY29kZSB0aGF0LgoKQnV0IG1hcHBpbmcgaXQgdG8gQkxLX1NUU19UQVJH
RVQgaXMgbm90IHRoZSBjb3JyZWN0IHdheSBoZXJlLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4g
SGFubmVzIFJlaW5lY2tlCQkgICBUZWFtbGVhZCBTdG9yYWdlICYgTmV0d29ya2luZwpoYXJlQHN1
c2UuZGUJCQkgICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIExJTlVYIEdtYkgs
IE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpHRjogRi4gSW1lbmTDtnJmZmVyLCBKLiBT
bWl0aGFyZCwgSi4gR3VpbGQsIEQuIFVwbWFueXUsIEcuIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7D
vHJuYmVyZykKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

