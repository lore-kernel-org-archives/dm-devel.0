Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C76C7EE2F
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903837;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YYNDrMC55UI+6DYCz2rx7zPw3cDNX/o2rXG89cMQnQ8=;
	b=NRfU0d3lQea/lekvG0kMEVaEJQ+P3yuiJ5rdOuZUdFDPYBvPX82v2r3wIBW8HET0DBafaG
	tUGxwrHNXt4uPW7J33nYIzLTp0Ibq85rjYLCwvBMR6EysHXwjfmRFS4rJRk612V+OUWNch
	7zLHv2+AOeismz86Cg8ZDFxr6gH0bto=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-HJDHIIXrPLy5_xYXry0bVA-1; Wed, 24 May 2023 00:50:33 -0400
X-MC-Unique: HJDHIIXrPLy5_xYXry0bVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 393E3800B2A;
	Wed, 24 May 2023 04:50:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5F17140E95D;
	Wed, 24 May 2023 04:50:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A360B19465A8;
	Wed, 24 May 2023 04:50:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B08F19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 18:37:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C1E6B401024; Tue, 23 May 2023 18:37:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA580492B00
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:37:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C7B0299E74E
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:37:05 +0000 (UTC)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com
 [209.85.218.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-wZXuCH_wMUyJcDWsg-GRCw-1; Tue, 23 May 2023 14:37:03 -0400
X-MC-Unique: wZXuCH_wMUyJcDWsg-GRCw-1
Received: by mail-ej1-f54.google.com with SMTP id
 a640c23a62f3a-96fc07d7e6bso84821366b.1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 11:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684867022; x=1687459022;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=FOckud4CsGpi42vHzY/iN1xEHfyZzu8tYLlnQmf3XXU=;
 b=Wb2vMPOcLhvriVx8uk0HQrTYmOCCMPJqUetmSgFb8v4vpRoknioPitT4uENYTSU3Gp
 UNu+zmJaulTg39P0RyajkMKqiwQOOYcUAmX7PD9o4oVGmxfRSrmOuQzVwkrqbiiMbhNg
 R+VzYPPmoimWzNOnIkb/QdvtxMGi5F6Z1tloHjYi4MbzKm+lU9c8uSNYHZq15bKaPObQ
 7GUezaxImViynqCXR8Ahor4bQ6VORxEMcy07W7gvLJmkJ2w739D3VvnXB5zTmtXk0Cnk
 CHTcbrXuUxv45oh25akp8n5diw/7mR3q3hlBhn1p2SbInpypmi5SM0bbZd2Va5t2xUZ+
 74Hw==
X-Gm-Message-State: AC+VfDwWGDlDT2lclp8A45fwg7iy4/5vRcZAhCaCvYRnv1NZsmw3C7Ji
 W5kKB/r80o6i7dVltNJxIbHGEpDTQFo9jhRSjGI=
X-Google-Smtp-Source: ACHHUZ6nbFDPqkJycDJLopbKTUzhoYKAgpRsCSCy+ygpw6i+jItGXHdrxW/6BlRArGGvUIQ7qUgo8pqVVYhtrNaQv8U=
X-Received: by 2002:a17:906:6495:b0:966:2210:4065 with SMTP id
 e21-20020a170906649500b0096622104065mr14890560ejm.4.1684867022285; Tue, 23
 May 2023 11:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-22-hch@lst.de>
In-Reply-To: <20230523074535.249802-22-hch@lst.de>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 23 May 2023 20:36:51 +0200
Message-ID: <CAJZ5v0grAY02dx__4=ezxT=HuPU=2gD6bErV2fYTQiv5mRL1yg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
Subject: Re: [dm-devel] [PATCH 21/24] PM: hibernate: don't use
 early_lookup_bdev in resume_store
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Joern Engel <joern@lazybastard.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMjMsIDIwMjMgYXQgOTo0NuKAr0FNIENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPiB3cm90ZToKPgo+IHJlc3VtZV9zdG9yZSBpcyBhIHN5c2ZzIGF0dHJpYnV0ZSB3cml0
dGVuIGR1cmluZyBub3JtYWwga2VybmVsIHJ1bnRpbWUsCj4gYW5kIGl0IHNob3VsZCBub3QgdXNl
IHRoZSBlYXJseV9sb29rdXBfYmRldiBBUEkgdGhhdCBieXBhc3NlcyBhbGwgbm9ybWFsCj4gcGF0
aCBiYXNlZCBwZXJtaXNzaW9uIGNoZWNraW5nLCBhbmQgbWlnaHQgY2F1c2UgcHJvYmxlbXMgd2l0
aCBjZXJ0YWluCj4gY29udGFpbmVyIGVudmlyb25tZW50cyByZW5hbWluZyBkZXZpY2VzLgo+Cj4g
U3dpdGNoIHRvIGxvb2t1cF9iZGV2LCB3aGljaCBkb2VzIGEgbm9ybWFsIHBhdGggbG9va3VwIGlu
c3RlYWQsIGFuZCBmYWxsCj4gYmFjayB0byB0cnlpbmcgdG8gcGFyc2UgYSBudW1lcmljIGRldl90
IGp1c3QgbGlrZSBlYXJseV9sb29rdXBfYmRldiBkaWQuCj4KPiBOb3RlIHRoYXQgdGhpcyBzdHJp
Y3RseSBzcGVha2luZyBjaGFuZ2VzIHRoZSBrZXJuZWwgQUJJIGFzIHRoZSBQQVJUVVVJRD0KPiBh
bmQgUEFSVExBQkVMPSBzdHlsZSBzeW50YXggaXMgbm93IG5vdCBhdmFpbGFibGUgZHVyaW5nIGEg
cnVubmluZwo+IHN5c3RlbXMuICBUaGV5IG5ldmVyIHdlcmUgaW50ZW5kZWQgZm9yIHRoYXQsIGJ1
dCB0aGlzIGJyZWFrcyB0aGluZ3MKPiB3ZSdsbCBoYXZlIHRvIGZpZ3VyZSBvdXQgYSB3YXkgdG8g
bWFrZSB0aGVtIGF2YWlsYWJsZSBhZ2Fpbi4gIEJ1dCBpZgo+IGF2b2lkYWJsZSBpbiBhbnkgd2F5
IEknZCByYXRoZXIgYXZvaWQgdGhhdC4KPgo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxs
d2lnIDxoY2hAbHN0LmRlPgo+IEZpeGVzOiA0MjFhNWZhMWE2Y2YgKCJQTSAvIGhpYmVybmF0ZTog
dXNlIG5hbWVfdG9fZGV2X3QgdG8gcGFyc2UgcmVzdW1lIikKCkFja2VkLWJ5OiBSYWZhZWwgSi4g
V3lzb2NraSA8cmFmYWVsQGtlcm5lbC5vcmc+Cgo+IC0tLQo+ICBrZXJuZWwvcG93ZXIvaGliZXJu
YXRlLmMgfCAxOCArKysrKysrKysrKysrKysrKy0KPiAgMSBmaWxlIGNoYW5nZWQsIDE3IGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9rZXJuZWwvcG93ZXIvaGli
ZXJuYXRlLmMgYi9rZXJuZWwvcG93ZXIvaGliZXJuYXRlLmMKPiBpbmRleCBjNTJkZWRiOWY3Yzhl
OC4uN2FlOTVlYzcyZjk5MDIgMTAwNjQ0Cj4gLS0tIGEva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5j
Cj4gKysrIGIva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jCj4gQEAgLTExNzgsNyArMTE3OCwyMyBA
QCBzdGF0aWMgc3NpemVfdCByZXN1bWVfc3RvcmUoc3RydWN0IGtvYmplY3QgKmtvYmosIHN0cnVj
dCBrb2JqX2F0dHJpYnV0ZSAqYXR0ciwKPiAgICAgICAgIGlmICghbmFtZSkKPiAgICAgICAgICAg
ICAgICAgcmV0dXJuIC1FTk9NRU07Cj4KPiAtICAgICAgIGVycm9yID0gZWFybHlfbG9va3VwX2Jk
ZXYobmFtZSwgJmRldik7Cj4gKyAgICAgICBlcnJvciA9IGxvb2t1cF9iZGV2KG5hbWUsICZkZXYp
Owo+ICsgICAgICAgaWYgKGVycm9yKSB7Cj4gKyAgICAgICAgICAgICAgIHVuc2lnbmVkIG1haiwg
bWluLCBvZmZzZXQ7Cj4gKyAgICAgICAgICAgICAgIGNoYXIgKnAsIGR1bW15Owo+ICsKPiArICAg
ICAgICAgICAgICAgaWYgKHNzY2FuZihuYW1lLCAiJXU6JXUlYyIsICZtYWosICZtaW4sICZkdW1t
eSkgPT0gMiB8fAo+ICsgICAgICAgICAgICAgICAgICAgc3NjYW5mKG5hbWUsICIldToldToldTol
YyIsICZtYWosICZtaW4sICZvZmZzZXQsCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAmZHVtbXkpID09IDMpIHsKPiArICAgICAgICAgICAgICAgICAgICAgICBkZXYgPSBNS0RFViht
YWosIG1pbik7Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKG1haiAhPSBNQUpPUihkZXYp
IHx8IG1pbiAhPSBNSU5PUihkZXYpKQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ZXJyb3IgPSAtRUlOVkFMOwo+ICsgICAgICAgICAgICAgICB9IGVsc2Ugewo+ICsgICAgICAgICAg
ICAgICAgICAgICAgIGRldiA9IG5ld19kZWNvZGVfZGV2KHNpbXBsZV9zdHJ0b3VsKG5hbWUsICZw
LCAxNikpOwo+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmICgqcCkKPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGVycm9yID0gLUVJTlZBTDsKPiArICAgICAgICAgICAgICAgfQo+
ICsgICAgICAgfQo+ICAgICAgICAga2ZyZWUobmFtZSk7Cj4gICAgICAgICBpZiAoZXJyb3IpCj4g
ICAgICAgICAgICAgICAgIHJldHVybiBlcnJvcjsKPiAtLQo+IDIuMzkuMgo+CgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

