Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59757C77B73
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682014657;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=resBc40TETnptnQewsu69X2etwqRk+my54SKJYB9EMM=;
	b=DoO4SOjVMSPCHk6qSftxt0i/5TaAL2CYXrg946fxSEM8s5WdqjLPNE60RBgFXzWZkPO0SI
	mwrcD56AH1MFA9OJAHJY+AWuPC2VRWGhpCnI+BAkydSfR9Lg2SfwsfVCCFr4FxwuiQjXiW
	2Vu6R98csS4s8LENuh24UZyaU/Sk+sQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-20-uT6Z8NnuNFWVfJI9gFg-1; Thu, 20 Apr 2023 14:17:33 -0400
X-MC-Unique: 20-uT6Z8NnuNFWVfJI9gFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AA5A8996FB;
	Thu, 20 Apr 2023 18:17:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6A2762166B33;
	Thu, 20 Apr 2023 18:17:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 19E1D1946A40;
	Thu, 20 Apr 2023 18:17:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17DD219466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 18:17:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E10111121319; Thu, 20 Apr 2023 18:17:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D897E1121315
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 18:17:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9CBB29AA2DD
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 18:17:29 +0000 (UTC)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com
 [209.85.208.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-qW1f9baOPEaO-FeFnBCoKQ-1; Thu, 20 Apr 2023 14:17:28 -0400
X-MC-Unique: qW1f9baOPEaO-FeFnBCoKQ-1
Received: by mail-ed1-f44.google.com with SMTP id
 4fb4d7f45d1cf-5051abd03a7so1067447a12.2
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 11:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682014646; x=1684606646;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=NzocEjSvrz85xEKE5MWcbLv/boctI2KKwjYq7LHKyz4=;
 b=aPrYsyqyjdkyWDIGvJj4pfN0RbfOlNT1dtXgyvByeCGZvxAZ8fDyBf4fU5frQdwB4n
 RyFFWkJ7PL2D0t7yPwa3CoOVBcm/QkCRXTDVsEdUfD5KODZ+pAFCr/LYh8Ow6+fXpZm2
 xeggSeWt+msAG1bITWBtYIhJXlhBQTtsSTVKOxzSZ7ODFkyT8+mEEopEqfiotzASX/Rb
 zalAK3C4Zp3yEJ4+UKBCPTfzfxTPwpbHCMVLSy4CCgp4b3/n5tJZCu6Egn6d32pwtuI5
 uZcxudDFie5qCFp2wIlsi6d6b2BQ2NlbCa70owXJG4oV/v+6VCU8zn0gSQ1rAjl/8Lmr
 pBpg==
X-Gm-Message-State: AAQBX9da8/oMm85+pCnd41lFunU5DR7gWPpm662ul/yDvYbDD0SA+P+5
 zfFGSQjq7J7sDYArrfSfggDT0cbZTvGeNEdhsdW6RzDgm+1cPJsl
X-Google-Smtp-Source: AKy350bUbgX+6BAetL35DQRlN+iICSaVw+B/jOXdxmTlFH/Y/a2lnx/qR3DkR104XRtbf49FVqzsbMMtZaekb6roEd8=
X-Received: by 2002:aa7:c592:0:b0:508:3f08:ea0f with SMTP id
 g18-20020aa7c592000000b005083f08ea0fmr2514672edq.28.1682014646672; Thu, 20
 Apr 2023 11:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <ZEFmS9h81Wwlv9+/@redhat.com>
 <20230420172807.323150-1-sarthakkukreti@chromium.org>
In-Reply-To: <20230420172807.323150-1-sarthakkukreti@chromium.org>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Thu, 20 Apr 2023 11:17:15 -0700
Message-ID: <CAG9=OMO7LtYRMurR4t4P5Tcb00-ob21eg4jm0aUXry2mcgOMfw@mail.gmail.com>
To: dm-devel@redhat.com, linux-block@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v5-fix 1/5] block: Don't invalidate pagecache
 for invalid falloc modes
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
Cc: Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, stable@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhpcyBwYXRjaCBoYWQgYSBzbGlnaHQgdHlwbzsgZml4ZWQgaW4gdGhlIG1vc3QgcmVjZW50IHBh
dGNoLgoKLSBTYXJ0aGFrCgpPbiBUaHUsIEFwciAyMCwgMjAyMyBhdCAxMDoyOOKAr0FNIFNhcnRo
YWsgS3VrcmV0aQo8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPiB3cm90ZToKPgo+IE9ubHkg
Y2FsbCB0cnVuY2F0ZV9iZGV2X3JhbmdlKCkgaWYgdGhlIGZhbGxvY2F0ZSBtb2RlIGlzCj4gc3Vw
cG9ydGVkLiBUaGlzIGZpeGVzIGEgYnVnIHdoZXJlIGRhdGEgaW4gdGhlIHBhZ2VjYWNoZQo+IGNv
dWxkIGJlIGludmFsaWRhdGVkIGlmIHRoZSBmYWxsb2NhdGUoKSB3YXMgY2FsbGVkIG9uIHRoZQo+
IGJsb2NrIGRldmljZSB3aXRoIGFuIGludmFsaWQgbW9kZS4KPgo+IEZpeGVzOiAyNWY0YzQxNDE1
ZTUgKCJibG9jazogaW1wbGVtZW50IChzb21lIG9mKSBmYWxsb2NhdGUgZm9yIGJsb2NrIGRldmlj
ZXMiKQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gUmVwb3J0ZWQtYnk6IERhcnJpY2sg
Si4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+Cj4gU2lnbmVkLW9mZi1ieTogU2FydGhhayBLdWty
ZXRpIDxzYXJ0aGFra3VrcmV0aUBjaHJvbWl1bS5vcmc+Cj4gLS0tCj4gIGJsb2NrL2ZvcHMuYyB8
IDIxICsrKysrKysrKysrKysrKystLS0tLQo+ICAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9u
cygrKSwgNSBkZWxldGlvbnMoLSkKPgo+IGRpZmYgLS1naXQgYS9ibG9jay9mb3BzLmMgYi9ibG9j
ay9mb3BzLmMKPiBpbmRleCBkMmU2YmU0ZTNkMWMuLjIwYjFlZGRjYmUyNSAxMDA2NDQKPiAtLS0g
YS9ibG9jay9mb3BzLmMKPiArKysgYi9ibG9jay9mb3BzLmMKPiBAQCAtNjQ4LDI0ICs2NDgsMzUg
QEAgc3RhdGljIGxvbmcgYmxrZGV2X2ZhbGxvY2F0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgaW50IG1v
ZGUsIGxvZmZfdCBzdGFydCwKPgo+ICAgICAgICAgZmlsZW1hcF9pbnZhbGlkYXRlX2xvY2soaW5v
ZGUtPmlfbWFwcGluZyk7Cj4KPiAtICAgICAgIC8qIEludmFsaWRhdGUgdGhlIHBhZ2UgY2FjaGUs
IGluY2x1ZGluZyBkaXJ0eSBwYWdlcy4gKi8KPiAtICAgICAgIGVycm9yID0gdHJ1bmNhdGVfYmRl
dl9yYW5nZShiZGV2LCBmaWxlLT5mX21vZGUsIHN0YXJ0LCBlbmQpOwo+IC0gICAgICAgaWYgKGVy
cm9yKQo+IC0gICAgICAgICAgICAgICBnb3RvIGZhaWw7Cj4gLQo+ICsgICAgICAgLyoKPiArICAg
ICAgICAqIEludmFsaWRhdGUgdGhlIHBhZ2UgY2FjaGUsIGluY2x1ZGluZyBkaXJ0eSBwYWdlcywg
Zm9yIHZhbGlkCj4gKyAgICAgICAgKiBkZS1hbGxvY2F0ZSBtb2RlIGNhbGxzIHRvIGZhbGxvY2F0
ZSgpLgo+ICsgICAgICAgICovCj4gICAgICAgICBzd2l0Y2ggKG1vZGUpIHsKPiAgICAgICAgIGNh
c2UgRkFMTE9DX0ZMX1pFUk9fUkFOR0U6Cj4gICAgICAgICBjYXNlIEZBTExPQ19GTF9aRVJPX1JB
TkdFIHwgRkFMTE9DX0ZMX0tFRVBfU0laRToKPiArICAgICAgICAgICAgICAgZXJyb3IgPSB0cnVu
Y2F0ZV9iZGV2X3JhbmdlKGJkZXYsIGZpbGUtPmZfbW9kZSwgc3RhcnQsIGVuZCk7Cj4gKyAgICAg
ICAgICAgICAgIGlmIChlcnJvcikKPiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGZhaWw7
Cj4gKwo+ICAgICAgICAgICAgICAgICBlcnJvciA9IGJsa2Rldl9pc3N1ZV96ZXJvb3V0KGJkZXYs
IHN0YXJ0ID4+IFNFQ1RPUl9TSElGVCwKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBsZW4gPj4gU0VDVE9SX1NISUZULCBHRlBfS0VSTkVMLAo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEJMS0RFVl9aRVJPX05PVU5NQVAp
Owo+ICAgICAgICAgICAgICAgICBicmVhazsKPiAgICAgICAgIGNhc2UgRkFMTE9DX0ZMX1BVTkNI
X0hPTEUgfCBGQUxMT0NfRkxfS0VFUF9TSVpFOgo+ICsgICAgICAgICAgICAgICBlcnJvciA9IHRy
dW5jYXRlX2JkZXZfcmFuZ2UoYmRldiwgZmlsZS0+Zl9tb2RlLCBzdGFydCwgZW5kKTsKPiArICAg
ICAgICAgICAgICAgaWYgKGVycm9yKQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZmFp
bDsKPiArCj4gICAgICAgICAgICAgICAgIGVycm9yID0gYmxrZGV2X2lzc3VlX3plcm9vdXQoYmRl
diwgc3RhcnQgPj4gU0VDVE9SX1NISUZULAo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGxlbiA+PiBTRUNUT1JfU0hJRlQsIEdGUF9LRVJORUwsCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQkxLREVWX1pFUk9fTk9GQUxM
QkFDSyk7Cj4gICAgICAgICAgICAgICAgIGJyZWFrOwo+ICAgICAgICAgY2FzZSBGQUxMT0NfRkxf
UFVOQ0hfSE9MRSB8IEZBTExPQ19GTF9LRUVQX1NJWkUgfCBGQUxMT0NfRkxfTk9fSElERV9TVEFM
RToKPiArICAgICAgICAgICAgICAgZXJyb3IgPSB0cnVuY2F0ZV9iZGV2X3JhbmdlKGJkZXYsIGZp
bGUtPmZfbW9kZSwgc3RhcnQsIGVuZCk7Cj4gKyAgICAgICAgICAgICAgIGlmICghZXJyb3IpCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgZ290byBmYWlsOwo+ICsKPiAgICAgICAgICAgICAgICAg
ZXJyb3IgPSBibGtkZXZfaXNzdWVfZGlzY2FyZChiZGV2LCBzdGFydCA+PiBTRUNUT1JfU0hJRlQs
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGVuID4+IFNF
Q1RPUl9TSElGVCwgR0ZQX0tFUk5FTCk7Cj4gICAgICAgICAgICAgICAgIGJyZWFrOwo+IC0tCj4g
Mi40MC4wLjM5Ni5nZmZmMTVlZmUwNS1nb29nCj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApk
bS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWwK

