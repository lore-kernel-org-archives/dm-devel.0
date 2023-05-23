Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A429DC7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903840;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gyUrOdbi+423dwSiabnLvqm1r6mwGGF5kr0ijoPa9jY=;
	b=htH3i7usGsucRlpCTNTeNwQO8QPNHyF0bneAKqPNefz0fjw5umL2ytj/WoIvoNGTHL7TnR
	G7aTc623E1MGv0fibpnm/mBttNEdLTeT2p3MZWpPS8H8eC+MKTfb4uzc9kekkXRrpn2ATY
	E2hw4zRkA1gXLo0yFcpgkd69+MRAoaA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-siihQ7uROpi2xHKS39Cmag-1; Wed, 24 May 2023 00:50:38 -0400
X-MC-Unique: siihQ7uROpi2xHKS39Cmag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C15C3858280;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56CE92166B28;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3FFD71946A42;
	Wed, 24 May 2023 04:50:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D06DD19465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 18:33:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF6B540CFD47; Tue, 23 May 2023 18:33:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B896140CFD46
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:33:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DC33185A78B
 for <dm-devel@redhat.com>; Tue, 23 May 2023 18:33:59 +0000 (UTC)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com
 [209.85.218.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-6_Rc9BA-OdumSM7a-O5_4Q-1; Tue, 23 May 2023 14:33:57 -0400
X-MC-Unique: 6_Rc9BA-OdumSM7a-O5_4Q-1
Received: by mail-ej1-f44.google.com with SMTP id
 a640c23a62f3a-96ffba243b1so62410566b.0
 for <dm-devel@redhat.com>; Tue, 23 May 2023 11:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684866836; x=1687458836;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=i2+6ZeOuWaMysW6pOftnvqcNpFa0QK0NSRKjideDKrk=;
 b=alrOiO8hYm7RYCH5DJvCbyyX7nsp1z1J19xWu9dgcZ0XQirHF9npP2eYH/I/valQCb
 GIsoX7qAFx0YYHBykbrDifp+Ck4DrPU0MA4lEaoDZYkGwNFOE7QT4K52hUnUaRh331/Z
 rqnxrz9AgALL+IMev4n/ZOSJzGDGXAl4gSucolsGaqhFOS7880/kSuNiEW5UoZ9kCSeM
 yVaR7W1E3jALlpGO7zABDetiQV2sKX4elVAkeanhKp9ULfvVYc4nY5hmYJLvLCOC4yuS
 qWVgoMId4vw2bUsaciJYdPQkBHAL1LvHFsMBtFVxwtVMFfELzgFFbpHg6k7OHFSyMV8T
 +0Nw==
X-Gm-Message-State: AC+VfDwc76CVHXv8Txz8I5W/Bch3tTtWcasLYH4HMzzHRgibszAXJeG3
 07+Al5o1S6eo1qKlUdf9MhC4oP8rrb6gQLbbgmo=
X-Google-Smtp-Source: ACHHUZ74qE46raE7hGqKO0rIs0tcDFMUtKQ9FPO83vqo+TKQ8WKbpVYAKFIYoGywc2NBe5UcG4EZWgMxDbsnjHTCn2U=
X-Received: by 2002:a17:906:748c:b0:965:9c7d:df96 with SMTP id
 e12-20020a170906748c00b009659c7ddf96mr14578825ejl.1.1684866835592; Tue, 23
 May 2023 11:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-5-hch@lst.de>
In-Reply-To: <20230523074535.249802-5-hch@lst.de>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 23 May 2023 20:33:44 +0200
Message-ID: <CAJZ5v0jrj3PaC5oZt22DQoJARUcpXaerS-Cmx+34du7=p9WDSw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
Subject: Re: [dm-devel] [PATCH 04/24] PM: hibernate: move finding the resume
 device out of software_resume
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
bHN0LmRlPiB3cm90ZToKPgo+IHNvZnR3YXJlX3Jlc3VtZSBjYW4gYmUgY2FsbGVkIGVpdGhlciBm
cm9tIGFuIGluaXQgY2FsbCBpbiB0aGUgYm9vdCBjb2RlLAo+IG9yIGZyb20gc3lzZnMgb25jZSB0
aGUgc3lzdGVtIGhhcyBmaW5pc2hlZCBib290aW5nLCBhbmQgdGhlIHR3bwo+IGludm9jYXRpb24g
bWV0aG9kcyB0aGlzIGNhbid0IHJhY2Ugd2l0aCBlYWNoIG90aGVyLgo+Cj4gRm9yIHRoZSBsYXR0
ZXIgY2FzZSB3ZSBkaWQganVzdCBwYXJzZSB0aGUgc3VzcGVuZCBkZXZpY2UgbWFudWFsbHksIHdo
aWxlCj4gdGhlIGZvcm1lciBtaWdodCBub3QgaGF2ZSBvbmUuICBTcGxpdCBzb2Z0d2FyZV9yZXN1
bWUgc28gdGhhdCB0aGUgc2VhcmNoCj4gb25seSBoYXBwZW5zIGZvciB0aGUgYm9vdCBjYXNlLCB3
aGljaCBhbHNvIG1lYW5zIHRoZSBzcGVjaWFsIGxvY2tkZXAKPiBuZXN0aW5nIGFubm90YXRpb24g
Y2FuIGdvIGF3YXkgYXMgdGhlIHN5c3RlbSB0cmFuc2l0aW9uIG11dGV4IGNhbiBiZQo+IHRha2Vu
IGEgbGl0dGxlIGxhdGVyIGFuZCBkb2Vzbid0IGhhdmUgdGhlIHN5c2ZzIGxvY2tpbmcgbmVzdCBp
bnNpZGUgaXQuCj4KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5k
ZT4KCkFja2VkLWJ5OiBSYWZhZWwgSi4gV3lzb2NraSA8cmFmYWVsQGtlcm5lbC5vcmc+Cgo+IC0t
LQo+ICBrZXJuZWwvcG93ZXIvaGliZXJuYXRlLmMgfCA4MCArKysrKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLS0tLS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAzOSBpbnNlcnRpb25zKCspLCA0
MSBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9rZXJuZWwvcG93ZXIvaGliZXJuYXRlLmMg
Yi9rZXJuZWwvcG93ZXIvaGliZXJuYXRlLmMKPiBpbmRleCA3ODY5NmFhMDRmNWNhMy4uNDVlMjRi
MDJjZDUwYjYgMTAwNjQ0Cj4gLS0tIGEva2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jCj4gKysrIGIv
a2VybmVsL3Bvd2VyL2hpYmVybmF0ZS5jCj4gQEAgLTkwNyw3ICs5MDcsNyBAQCBpbnQgaGliZXJu
YXRlX3F1aWV0X2V4ZWMoaW50ICgqZnVuYykodm9pZCAqZGF0YSksIHZvaWQgKmRhdGEpCj4gIH0K
PiAgRVhQT1JUX1NZTUJPTF9HUEwoaGliZXJuYXRlX3F1aWV0X2V4ZWMpOwo+Cj4gLXN0YXRpYyBp
bnQgZmluZF9yZXN1bWVfZGV2aWNlKHZvaWQpCj4gK3N0YXRpYyBpbnQgX19pbml0IGZpbmRfcmVz
dW1lX2RldmljZSh2b2lkKQo+ICB7Cj4gICAgICAgICBpZiAoIXN0cmxlbihyZXN1bWVfZmlsZSkp
Cj4gICAgICAgICAgICAgICAgIHJldHVybiAtRU5PRU5UOwo+IEBAIC05NDIsNTMgKzk0MiwxNiBA
QCBzdGF0aWMgaW50IGZpbmRfcmVzdW1lX2RldmljZSh2b2lkKQo+ICAgICAgICAgcmV0dXJuIDA7
Cj4gIH0KPgo+IC0vKioKPiAtICogc29mdHdhcmVfcmVzdW1lIC0gUmVzdW1lIGZyb20gYSBzYXZl
ZCBoaWJlcm5hdGlvbiBpbWFnZS4KPiAtICoKPiAtICogVGhpcyByb3V0aW5lIGlzIGNhbGxlZCBh
cyBhIGxhdGUgaW5pdGNhbGwsIHdoZW4gYWxsIGRldmljZXMgaGF2ZSBiZWVuCj4gLSAqIGRpc2Nv
dmVyZWQgYW5kIGluaXRpYWxpemVkIGFscmVhZHkuCj4gLSAqCj4gLSAqIFRoZSBpbWFnZSByZWFk
aW5nIGNvZGUgaXMgY2FsbGVkIHRvIHNlZSBpZiB0aGVyZSBpcyBhIGhpYmVybmF0aW9uIGltYWdl
Cj4gLSAqIGF2YWlsYWJsZSBmb3IgcmVhZGluZy4gIElmIHRoYXQgaXMgdGhlIGNhc2UsIGRldmlj
ZXMgYXJlIHF1aWVzY2VkIGFuZCB0aGUKPiAtICogY29udGVudHMgb2YgbWVtb3J5IGlzIHJlc3Rv
cmVkIGZyb20gdGhlIHNhdmVkIGltYWdlLgo+IC0gKgo+IC0gKiBJZiB0aGlzIGlzIHN1Y2Nlc3Nm
dWwsIGNvbnRyb2wgcmVhcHBlYXJzIGluIHRoZSByZXN0b3JlZCB0YXJnZXQga2VybmVsIGluCj4g
LSAqIGhpYmVybmF0aW9uX3NuYXBzaG90KCkgd2hpY2ggcmV0dXJucyB0byBoaWJlcm5hdGUoKS4g
IE90aGVyd2lzZSwgdGhlIHJvdXRpbmUKPiAtICogYXR0ZW1wdHMgdG8gcmVjb3ZlciBncmFjZWZ1
bGx5IGFuZCBtYWtlIHRoZSBrZXJuZWwgcmV0dXJuIHRvIHRoZSBub3JtYWwgbW9kZQo+IC0gKiBv
ZiBvcGVyYXRpb24uCj4gLSAqLwo+ICBzdGF0aWMgaW50IHNvZnR3YXJlX3Jlc3VtZSh2b2lkKQo+
ICB7Cj4gICAgICAgICBpbnQgZXJyb3I7Cj4KPiAtICAgICAgIC8qCj4gLSAgICAgICAgKiBJZiB0
aGUgdXNlciBzYWlkICJub3Jlc3VtZSIuLiBiYWlsIG91dCBlYXJseS4KPiAtICAgICAgICAqLwo+
IC0gICAgICAgaWYgKG5vcmVzdW1lIHx8ICFoaWJlcm5hdGlvbl9hdmFpbGFibGUoKSkKPiAtICAg
ICAgICAgICAgICAgcmV0dXJuIDA7Cj4gLQo+IC0gICAgICAgLyoKPiAtICAgICAgICAqIG5hbWVf
dG9fZGV2X3QoKSBiZWxvdyB0YWtlcyBhIHN5c2ZzIGJ1ZmZlciBtdXRleCB3aGVuIHN5c2ZzCj4g
LSAgICAgICAgKiBpcyBjb25maWd1cmVkIGludG8gdGhlIGtlcm5lbC4gU2luY2UgdGhlIHJlZ3Vs
YXIgaGliZXJuYXRlCj4gLSAgICAgICAgKiB0cmlnZ2VyIHBhdGggaXMgdmlhIHN5c2ZzIHdoaWNo
IHRha2VzIGEgYnVmZmVyIG11dGV4IGJlZm9yZQo+IC0gICAgICAgICogY2FsbGluZyBoaWJlcm5h
dGUgZnVuY3Rpb25zICh3aGljaCB0YWtlIHN5c3RlbV90cmFuc2l0aW9uX211dGV4KQo+IC0gICAg
ICAgICogdGhpcyBjYW4gY2F1c2UgbG9ja2RlcCB0byBjb21wbGFpbiBhYm91dCBhIHBvc3NpYmxl
IEFCQkEgZGVhZGxvY2sKPiAtICAgICAgICAqIHdoaWNoIGNhbm5vdCBoYXBwZW4gc2luY2Ugd2Un
cmUgaW4gdGhlIGJvb3QgY29kZSBoZXJlIGFuZAo+IC0gICAgICAgICogc3lzZnMgY2FuJ3QgYmUg
aW52b2tlZCB5ZXQuIFRoZXJlZm9yZSwgd2UgdXNlIGEgc3ViY2xhc3MKPiAtICAgICAgICAqIGhl
cmUgdG8gYXZvaWQgbG9ja2RlcCBjb21wbGFpbmluZy4KPiAtICAgICAgICAqLwo+IC0gICAgICAg
bXV0ZXhfbG9ja19uZXN0ZWQoJnN5c3RlbV90cmFuc2l0aW9uX211dGV4LCBTSU5HTEVfREVQVEhf
TkVTVElORyk7Cj4gLQo+IC0gICAgICAgaWYgKCFzd3N1c3BfcmVzdW1lX2RldmljZSkgewo+IC0g
ICAgICAgICAgICAgICBlcnJvciA9IGZpbmRfcmVzdW1lX2RldmljZSgpOwo+IC0gICAgICAgICAg
ICAgICBpZiAoZXJyb3IpCj4gLSAgICAgICAgICAgICAgICAgICAgICAgZ290byBVbmxvY2s7Cj4g
LSAgICAgICB9Cj4gLQo+ICAgICAgICAgcG1fcHJfZGJnKCJIaWJlcm5hdGlvbiBpbWFnZSBwYXJ0
aXRpb24gJWQ6JWQgcHJlc2VudFxuIiwKPiAgICAgICAgICAgICAgICAgTUFKT1Ioc3dzdXNwX3Jl
c3VtZV9kZXZpY2UpLCBNSU5PUihzd3N1c3BfcmVzdW1lX2RldmljZSkpOwo+Cj4gICAgICAgICBw
bV9wcl9kYmcoIkxvb2tpbmcgZm9yIGhpYmVybmF0aW9uIGltYWdlLlxuIik7Cj4gKwo+ICsgICAg
ICAgbXV0ZXhfbG9jaygmc3lzdGVtX3RyYW5zaXRpb25fbXV0ZXgpOwo+ICAgICAgICAgZXJyb3Ig
PSBzd3N1c3BfY2hlY2soZmFsc2UpOwo+ICAgICAgICAgaWYgKGVycm9yKQo+ICAgICAgICAgICAg
ICAgICBnb3RvIFVubG9jazsKPiBAQCAtMTAzNSw3ICs5OTgsMzkgQEAgc3RhdGljIGludCBzb2Z0
d2FyZV9yZXN1bWUodm9pZCkKPiAgICAgICAgIGdvdG8gRmluaXNoOwo+ICB9Cj4KPiAtbGF0ZV9p
bml0Y2FsbF9zeW5jKHNvZnR3YXJlX3Jlc3VtZSk7Cj4gKy8qKgo+ICsgKiBzb2Z0d2FyZV9yZXN1
bWVfaW5pdGNhbGwgLSBSZXN1bWUgZnJvbSBhIHNhdmVkIGhpYmVybmF0aW9uIGltYWdlLgo+ICsg
Kgo+ICsgKiBUaGlzIHJvdXRpbmUgaXMgY2FsbGVkIGFzIGEgbGF0ZSBpbml0Y2FsbCwgd2hlbiBh
bGwgZGV2aWNlcyBoYXZlIGJlZW4KPiArICogZGlzY292ZXJlZCBhbmQgaW5pdGlhbGl6ZWQgYWxy
ZWFkeS4KPiArICoKPiArICogVGhlIGltYWdlIHJlYWRpbmcgY29kZSBpcyBjYWxsZWQgdG8gc2Vl
IGlmIHRoZXJlIGlzIGEgaGliZXJuYXRpb24gaW1hZ2UKPiArICogYXZhaWxhYmxlIGZvciByZWFk
aW5nLiAgSWYgdGhhdCBpcyB0aGUgY2FzZSwgZGV2aWNlcyBhcmUgcXVpZXNjZWQgYW5kIHRoZQo+
ICsgKiBjb250ZW50cyBvZiBtZW1vcnkgaXMgcmVzdG9yZWQgZnJvbSB0aGUgc2F2ZWQgaW1hZ2Uu
Cj4gKyAqCj4gKyAqIElmIHRoaXMgaXMgc3VjY2Vzc2Z1bCwgY29udHJvbCByZWFwcGVhcnMgaW4g
dGhlIHJlc3RvcmVkIHRhcmdldCBrZXJuZWwgaW4KPiArICogaGliZXJuYXRpb25fc25hcHNob3Qo
KSB3aGljaCByZXR1cm5zIHRvIGhpYmVybmF0ZSgpLiAgT3RoZXJ3aXNlLCB0aGUgcm91dGluZQo+
ICsgKiBhdHRlbXB0cyB0byByZWNvdmVyIGdyYWNlZnVsbHkgYW5kIG1ha2UgdGhlIGtlcm5lbCBy
ZXR1cm4gdG8gdGhlIG5vcm1hbCBtb2RlCj4gKyAqIG9mIG9wZXJhdGlvbi4KPiArICovCj4gK3N0
YXRpYyBpbnQgX19pbml0IHNvZnR3YXJlX3Jlc3VtZV9pbml0Y2FsbCh2b2lkKQo+ICt7Cj4gKyAg
ICAgICAvKgo+ICsgICAgICAgICogSWYgdGhlIHVzZXIgc2FpZCAibm9yZXN1bWUiLi4gYmFpbCBv
dXQgZWFybHkuCj4gKyAgICAgICAgKi8KPiArICAgICAgIGlmIChub3Jlc3VtZSB8fCAhaGliZXJu
YXRpb25fYXZhaWxhYmxlKCkpCj4gKyAgICAgICAgICAgICAgIHJldHVybiAwOwo+ICsKPiArICAg
ICAgIGlmICghc3dzdXNwX3Jlc3VtZV9kZXZpY2UpIHsKPiArICAgICAgICAgICAgICAgaW50IGVy
cm9yID0gZmluZF9yZXN1bWVfZGV2aWNlKCk7Cj4gKwo+ICsgICAgICAgICAgICAgICBpZiAoZXJy
b3IpCj4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIGVycm9yOwo+ICsgICAgICAgfQo+
ICsKPiArICAgICAgIHJldHVybiBzb2Z0d2FyZV9yZXN1bWUoKTsKPiArfQo+ICtsYXRlX2luaXRj
YWxsX3N5bmMoc29mdHdhcmVfcmVzdW1lX2luaXRjYWxsKTsKPgo+Cj4gIHN0YXRpYyBjb25zdCBj
aGFyICogY29uc3QgaGliZXJuYXRpb25fbW9kZXNbXSA9IHsKPiBAQCAtMTE3Niw2ICsxMTcxLDkg
QEAgc3RhdGljIHNzaXplX3QgcmVzdW1lX3N0b3JlKHN0cnVjdCBrb2JqZWN0ICprb2JqLCBzdHJ1
Y3Qga29ial9hdHRyaWJ1dGUgKmF0dHIsCj4gICAgICAgICBjaGFyICpuYW1lOwo+ICAgICAgICAg
ZGV2X3QgcmVzOwo+Cj4gKyAgICAgICBpZiAoIWhpYmVybmF0aW9uX2F2YWlsYWJsZSgpKQo+ICsg
ICAgICAgICAgICAgICByZXR1cm4gMDsKPiArCj4gICAgICAgICBpZiAobGVuICYmIGJ1ZltsZW4t
MV0gPT0gJ1xuJykKPiAgICAgICAgICAgICAgICAgbGVuLS07Cj4gICAgICAgICBuYW1lID0ga3N0
cm5kdXAoYnVmLCBsZW4sIEdGUF9LRVJORUwpOwo+IC0tCj4gMi4zOS4yCj4KCi0tCmRtLWRldmVs
IG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

