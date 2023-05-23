Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86EC1C7EE2A
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903837;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EMkC20q8SuOU3EiYJ5PrwiHEXeFBcaUyD6W5B23q9eY=;
	b=UuggriLDxPPvl58+C0NKVtAIFbNUKQxPtzho6+zeTpQIavHb9PpIy835Sqc6lAUd1F7b4E
	b+A0c/6Gpqvr5DewbQrpU7e0AFQskk3Q7wyC/l8nd3uhZXcRqAjSziHLNU7VYqmv5vQdwk
	vf+8cHxg1nknZoqxyvf09AbJJzBVSgs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-1mY-HqSfMdCxF1fyU3tF_g-1; Wed, 24 May 2023 00:50:33 -0400
X-MC-Unique: 1mY-HqSfMdCxF1fyU3tF_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A2F4800B35;
	Wed, 24 May 2023 04:50:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDEA32166B25;
	Wed, 24 May 2023 04:50:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A80F919465B6;
	Wed, 24 May 2023 04:50:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB72919465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 18:25:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FD25140E961; Tue, 23 May 2023 18:25:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6793F140E95D
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:25:21 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4AEFA3C13A02
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:25:21 +0000 (UTC)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
 [209.85.208.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671--WzXLdwmPbq9qcTNLAFe8g-1; Tue, 23 May 2023 14:25:19 -0400
X-MC-Unique: -WzXLdwmPbq9qcTNLAFe8g-1
Received: by mail-ed1-f45.google.com with SMTP id
 4fb4d7f45d1cf-510f866ce78so40821a12.1
 for <dm-devel@redhat.com>; Tue, 23 May 2023 11:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684866318; x=1687458318;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=qNBtaQFevQ/ylnGP2LIVhsaLMMYO1oXGQ/WUEPR0bCM=;
 b=Y4eSSRLnUyaKtdP4D6giA4mQNqd28dNf9IUy4t042LVTcst6tobl+WPj8mQLdGSUI2
 3hvIJmu9QHOOc8IdicAQ0IGax5gpZK9232AVIGg+TkpW9rgtYpFeUxyx3kJvyylDO0fT
 qLzeaJXtSewo7trD16sIEqXxRbpxNdIIKmVS3eNa+KeyeM6V14AUiTtKTOnhc0k1VIIE
 Cn0TjOoFVqVtLeMXVpSy/ORWz8mXfJFSDrNVHAd0Ci8V6U9D8LXBMoUZGrTcf2sXq6FG
 kxPrumcOVUZqmfamX7iFDpEkYumdt6DPa2ZMHKG1gRdcXoNQx+B8aeRfZBlmZFIFg7v5
 TtCg==
X-Gm-Message-State: AC+VfDywr55F/73wE4e8yAQ0Hj0t8FhKBrJUrNbFLOhpFVmSxRZvyzVp
 qPj5po+90VugQxZ12diuHHFINWMlqiJ0HLby7CA=
X-Google-Smtp-Source: ACHHUZ6gJY/Um7fOx7eNZKmYsbI52dpazWi4mSyNnBLr8xAnhL3tvrxqwLCwiKib75/UOF7I96GahuJGbNIY2CxoOCM=
X-Received: by 2002:a17:906:778b:b0:96f:56ab:c6a5 with SMTP id
 s11-20020a170906778b00b0096f56abc6a5mr11986106ejm.3.1684866318116; Tue, 23
 May 2023 11:25:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-3-hch@lst.de>
In-Reply-To: <20230523074535.249802-3-hch@lst.de>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 23 May 2023 20:25:06 +0200
Message-ID: <CAJZ5v0j2N7Cdih0B66-w3ig=2E=MHNt=71mdT5O3OUmq_jsULQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
Subject: Re: [dm-devel] [PATCH 02/24] PM: hibernate: factor out a helper to
 find the resume device
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMjMsIDIwMjMgYXQgOTo0NeKAr0FNIENocmlzdG9waCBIZWxsd2lnIDxoY2hA
bHN0LmRlPiB3cm90ZToKPgo+IFNwbGl0IHRoZSBsb2dpYyB0byBmaW5kIHRoZSByZXN1bWUgZGV2
aWNlIG91dCBzb2Z0d2FyZV9yZXN1bWUgYW5kIGludG8KPiBhIHNlcGFyYXRlIGhlbHBlciB0byBz
dGFydCB1bndpbmRpZyB0aGUgY29udm9sdXRlZCBnb3RvIGxvZ2ljLgo+Cj4gU2lnbmVkLW9mZi1i
eTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+CgpBY2tlZC1ieTogUmFmYWVsIEouIFd5
c29ja2kgPHJhZmFlbEBrZXJuZWwub3JnPgoKPiAtLS0KPiAga2VybmVsL3Bvd2VyL2hpYmVybmF0
ZS5jIHwgNzIgKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQo+ICAxIGZp
bGUgY2hhbmdlZCwgMzcgaW5zZXJ0aW9ucygrKSwgMzUgZGVsZXRpb25zKC0pCj4KPiBkaWZmIC0t
Z2l0IGEva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jIGIva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5j
Cj4gaW5kZXggMzBkMTI3NGYwM2Y2MjUuLjA3Mjc5NTA2MzY2MjU1IDEwMDY0NAo+IC0tLSBhL2tl
cm5lbC9wb3dlci9oaWJlcm5hdGUuYwo+ICsrKyBiL2tlcm5lbC9wb3dlci9oaWJlcm5hdGUuYwo+
IEBAIC05MTAsNiArOTEwLDQxIEBAIGludCBoaWJlcm5hdGVfcXVpZXRfZXhlYyhpbnQgKCpmdW5j
KSh2b2lkICpkYXRhKSwgdm9pZCAqZGF0YSkKPiAgfQo+ICBFWFBPUlRfU1lNQk9MX0dQTChoaWJl
cm5hdGVfcXVpZXRfZXhlYyk7Cj4KPiArc3RhdGljIGludCBmaW5kX3Jlc3VtZV9kZXZpY2Uodm9p
ZCkKPiArewo+ICsgICAgICAgaWYgKCFzdHJsZW4ocmVzdW1lX2ZpbGUpKQo+ICsgICAgICAgICAg
ICAgICByZXR1cm4gLUVOT0VOVDsKPiArCj4gKyAgICAgICBwbV9wcl9kYmcoIkNoZWNraW5nIGhp
YmVybmF0aW9uIGltYWdlIHBhcnRpdGlvbiAlc1xuIiwgcmVzdW1lX2ZpbGUpOwo+ICsKPiArICAg
ICAgIGlmIChyZXN1bWVfZGVsYXkpIHsKPiArICAgICAgICAgICAgICAgcHJfaW5mbygiV2FpdGlu
ZyAlZHNlYyBiZWZvcmUgcmVhZGluZyByZXN1bWUgZGV2aWNlIC4uLlxuIiwKPiArICAgICAgICAg
ICAgICAgICAgICAgICByZXN1bWVfZGVsYXkpOwo+ICsgICAgICAgICAgICAgICBzc2xlZXAocmVz
dW1lX2RlbGF5KTsKPiArICAgICAgIH0KPiArCj4gKyAgICAgICAvKiBDaGVjayBpZiB0aGUgZGV2
aWNlIGlzIHRoZXJlICovCj4gKyAgICAgICBzd3N1c3BfcmVzdW1lX2RldmljZSA9IG5hbWVfdG9f
ZGV2X3QocmVzdW1lX2ZpbGUpOwo+ICsgICAgICAgaWYgKHN3c3VzcF9yZXN1bWVfZGV2aWNlKQo+
ICsgICAgICAgICAgICAgICByZXR1cm4gMDsKPiArCj4gKyAgICAgICAvKgo+ICsgICAgICAgICog
U29tZSBkZXZpY2UgZGlzY292ZXJ5IG1pZ2h0IHN0aWxsIGJlIGluIHByb2dyZXNzOyB3ZSBuZWVk
IHRvIHdhaXQgZm9yCj4gKyAgICAgICAgKiB0aGlzIHRvIGZpbmlzaC4KPiArICAgICAgICAqLwo+
ICsgICAgICAgd2FpdF9mb3JfZGV2aWNlX3Byb2JlKCk7Cj4gKyAgICAgICBpZiAocmVzdW1lX3dh
aXQpIHsKPiArICAgICAgICAgICAgICAgd2hpbGUgKCEoc3dzdXNwX3Jlc3VtZV9kZXZpY2UgPSBu
YW1lX3RvX2Rldl90KHJlc3VtZV9maWxlKSkpCj4gKyAgICAgICAgICAgICAgICAgICAgICAgbXNs
ZWVwKDEwKTsKPiArICAgICAgICAgICAgICAgYXN5bmNfc3luY2hyb25pemVfZnVsbCgpOwo+ICsg
ICAgICAgfQo+ICsKPiArICAgICAgIHN3c3VzcF9yZXN1bWVfZGV2aWNlID0gbmFtZV90b19kZXZf
dChyZXN1bWVfZmlsZSk7Cj4gKyAgICAgICBpZiAoIXN3c3VzcF9yZXN1bWVfZGV2aWNlKQo+ICsg
ICAgICAgICAgICAgICByZXR1cm4gLUVOT0RFVjsKPiArICAgICAgIHJldHVybiAwOwo+ICt9Cj4g
Kwo+ICAvKioKPiAgICogc29mdHdhcmVfcmVzdW1lIC0gUmVzdW1lIGZyb20gYSBzYXZlZCBoaWJl
cm5hdGlvbiBpbWFnZS4KPiAgICoKPiBAQCAtOTQ5LDQ1ICs5ODQsMTIgQEAgc3RhdGljIGludCBz
b2Z0d2FyZV9yZXN1bWUodm9pZCkKPgo+ICAgICAgICAgc25hcHNob3RfdGVzdCA9IGZhbHNlOwo+
Cj4gLSAgICAgICBpZiAoc3dzdXNwX3Jlc3VtZV9kZXZpY2UpCj4gLSAgICAgICAgICAgICAgIGdv
dG8gQ2hlY2tfaW1hZ2U7Cj4gLQo+IC0gICAgICAgaWYgKCFzdHJsZW4ocmVzdW1lX2ZpbGUpKSB7
Cj4gLSAgICAgICAgICAgICAgIGVycm9yID0gLUVOT0VOVDsKPiAtICAgICAgICAgICAgICAgZ290
byBVbmxvY2s7Cj4gLSAgICAgICB9Cj4gLQo+IC0gICAgICAgcG1fcHJfZGJnKCJDaGVja2luZyBo
aWJlcm5hdGlvbiBpbWFnZSBwYXJ0aXRpb24gJXNcbiIsIHJlc3VtZV9maWxlKTsKPiAtCj4gLSAg
ICAgICBpZiAocmVzdW1lX2RlbGF5KSB7Cj4gLSAgICAgICAgICAgICAgIHByX2luZm8oIldhaXRp
bmcgJWRzZWMgYmVmb3JlIHJlYWRpbmcgcmVzdW1lIGRldmljZSAuLi5cbiIsCj4gLSAgICAgICAg
ICAgICAgICAgICAgICAgcmVzdW1lX2RlbGF5KTsKPiAtICAgICAgICAgICAgICAgc3NsZWVwKHJl
c3VtZV9kZWxheSk7Cj4gLSAgICAgICB9Cj4gLQo+IC0gICAgICAgLyogQ2hlY2sgaWYgdGhlIGRl
dmljZSBpcyB0aGVyZSAqLwo+IC0gICAgICAgc3dzdXNwX3Jlc3VtZV9kZXZpY2UgPSBuYW1lX3Rv
X2Rldl90KHJlc3VtZV9maWxlKTsKPiAgICAgICAgIGlmICghc3dzdXNwX3Jlc3VtZV9kZXZpY2Up
IHsKPiAtICAgICAgICAgICAgICAgLyoKPiAtICAgICAgICAgICAgICAgICogU29tZSBkZXZpY2Ug
ZGlzY292ZXJ5IG1pZ2h0IHN0aWxsIGJlIGluIHByb2dyZXNzOyB3ZSBuZWVkCj4gLSAgICAgICAg
ICAgICAgICAqIHRvIHdhaXQgZm9yIHRoaXMgdG8gZmluaXNoLgo+IC0gICAgICAgICAgICAgICAg
Ki8KPiAtICAgICAgICAgICAgICAgd2FpdF9mb3JfZGV2aWNlX3Byb2JlKCk7Cj4gLQo+IC0gICAg
ICAgICAgICAgICBpZiAocmVzdW1lX3dhaXQpIHsKPiAtICAgICAgICAgICAgICAgICAgICAgICB3
aGlsZSAoKHN3c3VzcF9yZXN1bWVfZGV2aWNlID0gbmFtZV90b19kZXZfdChyZXN1bWVfZmlsZSkp
ID09IDApCj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBtc2xlZXAoMTApOwo+IC0g
ICAgICAgICAgICAgICAgICAgICAgIGFzeW5jX3N5bmNocm9uaXplX2Z1bGwoKTsKPiAtICAgICAg
ICAgICAgICAgfQo+IC0KPiAtICAgICAgICAgICAgICAgc3dzdXNwX3Jlc3VtZV9kZXZpY2UgPSBu
YW1lX3RvX2Rldl90KHJlc3VtZV9maWxlKTsKPiAtICAgICAgICAgICAgICAgaWYgKCFzd3N1c3Bf
cmVzdW1lX2RldmljZSkgewo+IC0gICAgICAgICAgICAgICAgICAgICAgIGVycm9yID0gLUVOT0RF
VjsKPiArICAgICAgICAgICAgICAgZXJyb3IgPSBmaW5kX3Jlc3VtZV9kZXZpY2UoKTsKPiArICAg
ICAgICAgICAgICAgaWYgKGVycm9yKQo+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gVW5s
b2NrOwo+IC0gICAgICAgICAgICAgICB9Cj4gICAgICAgICB9Cj4KPiAtIENoZWNrX2ltYWdlOgo+
ICAgICAgICAgcG1fcHJfZGJnKCJIaWJlcm5hdGlvbiBpbWFnZSBwYXJ0aXRpb24gJWQ6JWQgcHJl
c2VudFxuIiwKPiAgICAgICAgICAgICAgICAgTUFKT1Ioc3dzdXNwX3Jlc3VtZV9kZXZpY2UpLCBN
SU5PUihzd3N1c3BfcmVzdW1lX2RldmljZSkpOwo+Cj4gLS0KPiAyLjM5LjIKPgoKLS0KZG0tZGV2
ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhh
dC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

