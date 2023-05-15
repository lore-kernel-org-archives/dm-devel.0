Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E0D2C77B7D
	for <dm-devel@archiver.kernel.org>; Mon, 15 May 2023 21:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684186328;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nAZbPclfm67QBdyppVw2K39DWvbTJIL5Piard+AnF/4=;
	b=d6qVVsO0mPPrR3phJFDjhN9ViORXu3SS5CkKCgTX4AgGpyYQMYJIGOwa2b8UGwAkeziVrN
	rF3IVe5R7hzWjypn1Cm8KpBqvXplNYcm7luqbjQ1S7NjcwGJB10ol/hoeoZgsxy7eGFFRX
	iyOyx9O+hW/G7L17gpXcphXc4YVZAsk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-411-T5pK6iyXPdOSWZxmf4IUzQ-1; Mon, 15 May 2023 17:32:05 -0400
X-MC-Unique: T5pK6iyXPdOSWZxmf4IUzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95EA5870820;
	Mon, 15 May 2023 21:32:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31DA3140E917;
	Mon, 15 May 2023 21:32:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D5391946595;
	Mon, 15 May 2023 21:32:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D647194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 15 May 2023 21:32:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EBFC94078906; Mon, 15 May 2023 21:31:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E4A4740C6EC4
 for <dm-devel@redhat.com>; Mon, 15 May 2023 21:31:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C956385A588
 for <dm-devel@redhat.com>; Mon, 15 May 2023 21:31:59 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-WBX13iQTOFOpoClMTk5a_g-1; Mon, 15 May 2023 17:31:52 -0400
X-MC-Unique: WBX13iQTOFOpoClMTk5a_g-1
Received: by mail-ed1-f41.google.com with SMTP id
 4fb4d7f45d1cf-50c8d87c775so18485934a12.3
 for <dm-devel@redhat.com>; Mon, 15 May 2023 14:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684186311; x=1686778311;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=0+97QIKHZALmFiK8g1VXhuSr7RLu+60+zvsYBuHgbGg=;
 b=itCBAfLIUahs7D9eeEaSvSj8/zHwCiKjzXTq1Dnqh2kOSv4dH4U02+MAO1+HoZdPgv
 sTwjJNCiARHA5+MyTRpjBryv5D50kB+WlpYI+8JDMx+yMO8y2HZbVP6FujCYzCtJTpg7
 N4Q1B8oLh48an4ArfBLN+bLwNtW+QkRNRRQpPDL/0hoOAhhd4tlOABZRt7UIzMp87spE
 u7KSrZvxMIvxgxRFpZrV5/j7Spv4QOQnRpIfll5oI9eX7UXbR/SBBzpKdV9pQKtS+4lv
 HpvLUlgXVsxo0vuNa95QKD18OEle0EexfMjY9BgzyAqsfuobEAgN7F8zkMoNeLgFqsUR
 2UTQ==
X-Gm-Message-State: AC+VfDz+b4oaXhF4ccl/NprjR9heZYskQsP1/7bjmT/NlCN1G2cn5QP1
 muBfD8bHZCnipXrouhZXp23wrAFRhnuqYQD/B7y0TA==
X-Google-Smtp-Source: ACHHUZ7Hc5oE5ND/9/QiL+Zn8CNn3DUPNRrptIElw6wI0GM9IDTcdOqoMTas5ig/h8ZcZwS+0kIdU23YGzZrwmE+F1M=
X-Received: by 2002:a17:907:728e:b0:96a:e7cc:b8b1 with SMTP id
 dt14-20020a170907728e00b0096ae7ccb8b1mr8614530ejc.56.1684186311425; Mon, 15
 May 2023 14:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-6-sarthakkukreti@chromium.org>
 <ZGIoKi7d5bKcMWw4@bfoster>
In-Reply-To: <ZGIoKi7d5bKcMWw4@bfoster>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Mon, 15 May 2023 14:31:40 -0700
Message-ID: <CAG9=OMMPphcFMeyge_5pa=-j=fNtDBQTK2bQaDwFWhTs3_pJjw@mail.gmail.com>
To: Brian Foster <bfoster@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v6 5/5] loop: Add support for provision
 requests
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBNYXkgMTUsIDIwMjMgYXQgNTozN+KAr0FNIEJyaWFuIEZvc3RlciA8YmZvc3RlckBy
ZWRoYXQuY29tPiB3cm90ZToKPgo+IE9uIEZyaSwgTWF5IDA1LCAyMDIzIGF0IDExOjI5OjA5UE0g
LTA3MDAsIFNhcnRoYWsgS3VrcmV0aSB3cm90ZToKPiA+IEFkZCBzdXBwb3J0IGZvciBwcm92aXNp
b24gcmVxdWVzdHMgdG8gbG9vcGJhY2sgZGV2aWNlcy4KPiA+IExvb3AgZGV2aWNlcyB3aWxsIGNv
bmZpZ3VyZSBwcm92aXNpb24gc3VwcG9ydCBiYXNlZCBvbgo+ID4gd2hldGhlciB0aGUgdW5kZXJs
eWluZyBibG9jayBkZXZpY2UvZmlsZSBjYW4gc3VwcG9ydAo+ID4gdGhlIHByb3Zpc2lvbiByZXF1
ZXN0IGFuZCB1cG9uIHJlY2VpdmluZyBhIHByb3Zpc2lvbiBiaW8sCj4gPiB3aWxsIG1hcCBpdCB0
byB0aGUgYmFja2luZyBkZXZpY2Uvc3RvcmFnZS4gRm9yIGxvb3AgZGV2aWNlcwo+ID4gb3ZlciBm
aWxlcywgYSBSRVFfT1BfUFJPVklTSU9OIHJlcXVlc3Qgd2lsbCB0cmFuc2xhdGUgdG8KPiA+IGFu
IGZhbGxvY2F0ZSBtb2RlIDAgY2FsbCBvbiB0aGUgYmFja2luZyBmaWxlLgo+ID4KPiA+IFNpZ25l
ZC1vZmYtYnk6IFNhcnRoYWsgS3VrcmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPgo+
ID4gLS0tCj4gPiAgZHJpdmVycy9ibG9jay9sb29wLmMgfCA0MiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysKPiA+ICAxIGZpbGUgY2hhbmdlZCwgNDIgaW5zZXJ0aW9u
cygrKQo+ID4KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2Jsb2NrL2xvb3AuYyBiL2RyaXZlcnMv
YmxvY2svbG9vcC5jCj4gPiBpbmRleCBiYzMxYmI3MDcyYTIuLjEzYzRiNGY4YjljMSAxMDA2NDQK
PiA+IC0tLSBhL2RyaXZlcnMvYmxvY2svbG9vcC5jCj4gPiArKysgYi9kcml2ZXJzL2Jsb2NrL2xv
b3AuYwo+ID4gQEAgLTMyNyw2ICszMjcsMjQgQEAgc3RhdGljIGludCBsb19mYWxsb2NhdGUoc3Ry
dWN0IGxvb3BfZGV2aWNlICpsbywgc3RydWN0IHJlcXVlc3QgKnJxLCBsb2ZmX3QgcG9zLAo+ID4g
ICAgICAgcmV0dXJuIHJldDsKPiA+ICB9Cj4gPgo+ID4gK3N0YXRpYyBpbnQgbG9fcmVxX3Byb3Zp
c2lvbihzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvLCBzdHJ1Y3QgcmVxdWVzdCAqcnEsIGxvZmZfdCBw
b3MpCj4gPiArewo+ID4gKyAgICAgc3RydWN0IGZpbGUgKmZpbGUgPSBsby0+bG9fYmFja2luZ19m
aWxlOwo+ID4gKyAgICAgc3RydWN0IHJlcXVlc3RfcXVldWUgKnEgPSBsby0+bG9fcXVldWU7Cj4g
PiArICAgICBpbnQgcmV0Owo+ID4gKwo+ID4gKyAgICAgaWYgKCFxLT5saW1pdHMubWF4X3Byb3Zp
c2lvbl9zZWN0b3JzKSB7Cj4gPiArICAgICAgICAgICAgIHJldCA9IC1FT1BOT1RTVVBQOwo+ID4g
KyAgICAgICAgICAgICBnb3RvIG91dDsKPiA+ICsgICAgIH0KPiA+ICsKPiA+ICsgICAgIHJldCA9
IGZpbGUtPmZfb3AtPmZhbGxvY2F0ZShmaWxlLCAwLCBwb3MsIGJsa19ycV9ieXRlcyhycSkpOwo+
ID4gKyAgICAgaWYgKHVubGlrZWx5KHJldCAmJiByZXQgIT0gLUVJTlZBTCAmJiByZXQgIT0gLUVP
UE5PVFNVUFApKQo+ID4gKyAgICAgICAgICAgICByZXQgPSAtRUlPOwo+ID4gKyBvdXQ6Cj4gPiAr
ICAgICByZXR1cm4gcmV0Owo+ID4gK30KPiA+ICsKPiA+ICBzdGF0aWMgaW50IGxvX3JlcV9mbHVz
aChzdHJ1Y3QgbG9vcF9kZXZpY2UgKmxvLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCj4gPiAgewo+ID4g
ICAgICAgaW50IHJldCA9IHZmc19mc3luYyhsby0+bG9fYmFja2luZ19maWxlLCAwKTsKPiA+IEBA
IC00ODgsNiArNTA2LDggQEAgc3RhdGljIGludCBkb19yZXFfZmlsZWJhY2tlZChzdHJ1Y3QgbG9v
cF9kZXZpY2UgKmxvLCBzdHJ1Y3QgcmVxdWVzdCAqcnEpCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBGQUxMT0NfRkxfUFVOQ0hfSE9MRSk7Cj4gPiAgICAgICBjYXNlIFJFUV9PUF9E
SVNDQVJEOgo+ID4gICAgICAgICAgICAgICByZXR1cm4gbG9fZmFsbG9jYXRlKGxvLCBycSwgcG9z
LCBGQUxMT0NfRkxfUFVOQ0hfSE9MRSk7Cj4gPiArICAgICBjYXNlIFJFUV9PUF9QUk9WSVNJT046
Cj4gPiArICAgICAgICAgICAgIHJldHVybiBsb19yZXFfcHJvdmlzaW9uKGxvLCBycSwgcG9zKTsK
Pgo+IEhpIFNhcnRoYWssCj4KPiBUaGUgb25seSB0aGluZyB0aGF0IHN0YW5kcyBvdXQgdG8gbWUg
aXMgdGhlIHNlcGFyYXRlIGxvX3JlcV9wcm92aXNpb24oKQo+IGhlbHBlciBoZXJlLiBJdCBzZWVt
cyBpdCBtaWdodCBiZSBhIGxpdHRsZSBjbGVhbmVyIHRvIGV4dGVuZCBhbmQgcmV1c2UKPiBsb19y
ZXFfZmFsbG9jYXRlKCkuLj8gQnV0IHRoYXQncyBub3Qgc29tZXRoaW5nIEkgZmVlbCBzdHJvbmds
eSBhYm91dCwgc28KPiB0aGlzIGFsbCBsb29rcyBwcmV0dHkgZ29vZCB0byBtZSBlaXRoZXIgd2F5
LCBGV0lXLgo+CkZhaXIgcG9pbnQsIEkgdGhpbmsgdGhhdCBzaG91bGQgc2hvcnRlbiB0aGUgcGF0
Y2ggKGFuZCBmb3IKY29ycmVjdG5lc3MsIHdlJ2Qgd2FudCB0byBhZGQgRkFMTE9DX0ZMX0tFRVBf
U0laRSBmb3IgUkVRX09QX1BST1ZJU0lPTgp0b28pLiBJJ2xsIGZpeCB0aGlzIHVwIGluIHY3LgoK
QmVzdApTYXJ0aGFrCgo+IEJyaWFuCj4KPiA+ICAgICAgIGNhc2UgUkVRX09QX1dSSVRFOgo+ID4g
ICAgICAgICAgICAgICBpZiAoY21kLT51c2VfYWlvKQo+ID4gICAgICAgICAgICAgICAgICAgICAg
IHJldHVybiBsb19yd19haW8obG8sIGNtZCwgcG9zLCBJVEVSX1NPVVJDRSk7Cj4gPiBAQCAtNzU0
LDYgKzc3NCwyNSBAQCBzdGF0aWMgdm9pZCBsb29wX3N5c2ZzX2V4aXQoc3RydWN0IGxvb3BfZGV2
aWNlICpsbykKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICZsb29wX2F0dHJp
YnV0ZV9ncm91cCk7Cj4gPiAgfQo+ID4KPiA+ICtzdGF0aWMgdm9pZCBsb29wX2NvbmZpZ19wcm92
aXNpb24oc3RydWN0IGxvb3BfZGV2aWNlICpsbykKPiA+ICt7Cj4gPiArICAgICBzdHJ1Y3QgZmls
ZSAqZmlsZSA9IGxvLT5sb19iYWNraW5nX2ZpbGU7Cj4gPiArICAgICBzdHJ1Y3QgaW5vZGUgKmlu
b2RlID0gZmlsZS0+Zl9tYXBwaW5nLT5ob3N0Owo+ID4gKwo+ID4gKyAgICAgLyoKPiA+ICsgICAg
ICAqIElmIHRoZSBiYWNraW5nIGRldmljZSBpcyBhIGJsb2NrIGRldmljZSwgbWlycm9yIGl0cyBw
cm92aXNpb25pbmcKPiA+ICsgICAgICAqIGNhcGFiaWxpdHkuCj4gPiArICAgICAgKi8KPiA+ICsg
ICAgIGlmIChTX0lTQkxLKGlub2RlLT5pX21vZGUpKSB7Cj4gPiArICAgICAgICAgICAgIGJsa19x
dWV1ZV9tYXhfcHJvdmlzaW9uX3NlY3RvcnMobG8tPmxvX3F1ZXVlLAo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgIGJkZXZfbWF4X3Byb3Zpc2lvbl9zZWN0b3JzKElfQkRFVihpbm9kZSkpKTsKPiA+
ICsgICAgIH0gZWxzZSBpZiAoZmlsZS0+Zl9vcC0+ZmFsbG9jYXRlKSB7Cj4gPiArICAgICAgICAg
ICAgIGJsa19xdWV1ZV9tYXhfcHJvdmlzaW9uX3NlY3RvcnMobG8tPmxvX3F1ZXVlLCBVSU5UX01B
WCA+PiA5KTsKPiA+ICsgICAgIH0gZWxzZSB7Cj4gPiArICAgICAgICAgICAgIGJsa19xdWV1ZV9t
YXhfcHJvdmlzaW9uX3NlY3RvcnMobG8tPmxvX3F1ZXVlLCAwKTsKPiA+ICsgICAgIH0KPiA+ICt9
Cj4gPiArCj4gPiAgc3RhdGljIHZvaWQgbG9vcF9jb25maWdfZGlzY2FyZChzdHJ1Y3QgbG9vcF9k
ZXZpY2UgKmxvKQo+ID4gIHsKPiA+ICAgICAgIHN0cnVjdCBmaWxlICpmaWxlID0gbG8tPmxvX2Jh
Y2tpbmdfZmlsZTsKPiA+IEBAIC0xMDkyLDYgKzExMzEsNyBAQCBzdGF0aWMgaW50IGxvb3BfY29u
ZmlndXJlKHN0cnVjdCBsb29wX2RldmljZSAqbG8sIGZtb2RlX3QgbW9kZSwKPiA+ICAgICAgIGJs
a19xdWV1ZV9pb19taW4obG8tPmxvX3F1ZXVlLCBic2l6ZSk7Cj4gPgo+ID4gICAgICAgbG9vcF9j
b25maWdfZGlzY2FyZChsbyk7Cj4gPiArICAgICBsb29wX2NvbmZpZ19wcm92aXNpb24obG8pOwo+
ID4gICAgICAgbG9vcF91cGRhdGVfcm90YXRpb25hbChsbyk7Cj4gPiAgICAgICBsb29wX3VwZGF0
ZV9kaW8obG8pOwo+ID4gICAgICAgbG9vcF9zeXNmc19pbml0KGxvKTsKPiA+IEBAIC0xMzA0LDYg
KzEzNDQsNyBAQCBsb29wX3NldF9zdGF0dXMoc3RydWN0IGxvb3BfZGV2aWNlICpsbywgY29uc3Qg
c3RydWN0IGxvb3BfaW5mbzY0ICppbmZvKQo+ID4gICAgICAgfQo+ID4KPiA+ICAgICAgIGxvb3Bf
Y29uZmlnX2Rpc2NhcmQobG8pOwo+ID4gKyAgICAgbG9vcF9jb25maWdfcHJvdmlzaW9uKGxvKTsK
PiA+Cj4gPiAgICAgICAvKiB1cGRhdGUgZGlvIGlmIGxvX29mZnNldCBvciB0cmFuc2ZlciBpcyBj
aGFuZ2VkICovCj4gPiAgICAgICBfX2xvb3BfdXBkYXRlX2RpbyhsbywgbG8tPnVzZV9kaW8pOwo+
ID4gQEAgLTE4MzAsNiArMTg3MSw3IEBAIHN0YXRpYyBibGtfc3RhdHVzX3QgbG9vcF9xdWV1ZV9y
cShzdHJ1Y3QgYmxrX21xX2h3X2N0eCAqaGN0eCwKPiA+ICAgICAgIGNhc2UgUkVRX09QX0ZMVVNI
Ogo+ID4gICAgICAgY2FzZSBSRVFfT1BfRElTQ0FSRDoKPiA+ICAgICAgIGNhc2UgUkVRX09QX1dS
SVRFX1pFUk9FUzoKPiA+ICsgICAgIGNhc2UgUkVRX09QX1BST1ZJU0lPTjoKPiA+ICAgICAgICAg
ICAgICAgY21kLT51c2VfYWlvID0gZmFsc2U7Cj4gPiAgICAgICAgICAgICAgIGJyZWFrOwo+ID4g
ICAgICAgZGVmYXVsdDoKPiA+IC0tCj4gPiAyLjQwLjEuNTIxLmdmMWUyMThmY2Q4LWdvb2cKPiA+
Cj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

