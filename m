Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C1FC77B7D
	for <dm-devel@archiver.kernel.org>; Mon, 15 May 2023 21:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684185583;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/bdm8g41SmEIgn/W+ny/UVKp7ojOn0L5GY0qIX8jVug=;
	b=Rb31c3J37w9hVFO3RgeZ7XDm7/tYXQF/E+SSIWrcMsOgtRuXMwXSjIy/aRcEvug3LtMAJR
	u5oWd2Putuu/f+N1KtgSbTSMVvp5Gx7t95fF65lY9hwHoHh1w/jdVHLKCsGA5JTggayvle
	6+liNpVSzjq8qRhH4Y0IULKT+J8JcEs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-BVo3XSUlP_qlDuDk6OMt5Q-1; Mon, 15 May 2023 17:19:40 -0400
X-MC-Unique: BVo3XSUlP_qlDuDk6OMt5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 363E884AF32;
	Mon, 15 May 2023 21:19:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A1EB40C2063;
	Mon, 15 May 2023 21:19:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25E221946595;
	Mon, 15 May 2023 21:19:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AD0B5194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 15 May 2023 21:19:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71630492B01; Mon, 15 May 2023 21:19:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69706492B00
 for <dm-devel@redhat.com>; Mon, 15 May 2023 21:19:34 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DC9A1C060CD
 for <dm-devel@redhat.com>; Mon, 15 May 2023 21:19:34 +0000 (UTC)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com
 [209.85.218.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-ht2i7ZG6PvOr2ccIRkTE1g-1; Mon, 15 May 2023 17:19:32 -0400
X-MC-Unique: ht2i7ZG6PvOr2ccIRkTE1g-1
Received: by mail-ej1-f50.google.com with SMTP id
 a640c23a62f3a-96aae59bbd6so792349266b.3
 for <dm-devel@redhat.com>; Mon, 15 May 2023 14:19:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1684185571; x=1686777571;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=iCAGJRSZlOdbZk8TJO2+IV5B/w81wFfW9jtMkWpTH+M=;
 b=ijfiTUTA0nUtB3Tmz4O2VQ2ABj6C6xxxAdNYFXyG9JrkmYkTrb00oYtZhGgy2ukN1Y
 koB5TufdiqhqqVJrzBDpOSEoh5LDRVxWQSZNdq6pQXUYQtA0AlR4lHGXsnzuyqZyNI51
 s/sx4aSI0Jqjg9ie7dOjLA3iFfLZZxfnUx+IxtBdNT0K/Rh0IXDlMXmAxZevnZDbG0OM
 H4qDY2a7OFFxaP9jE55mGcTKBMRD5Ne4XyxSqS2puGInOFK7aDGLuw/Ma55uy+F/rsD8
 E6dAlDt+AI1eYzMa7SvHTHNlEsH6ESQdoznaK4VP3jjoCvWUOYOW/dkEzasqtmCItruS
 wLXA==
X-Gm-Message-State: AC+VfDxVz+qZHvkrjFP1Mm6Siq4BMltS+kbBhodyD3J8eJBczDacVdUk
 PnxwJz9LYRZzrRhy20pgMcRNg0jFJm8/mCNWXtXYSg==
X-Google-Smtp-Source: ACHHUZ4NVNi7naSU30mEHscyRmFftvi4fhFnmiYSDcSrg9y4ApnJuNxOMdtq7yH9l565H4qJkeCcSkHBc3YRcSzTMNU=
X-Received: by 2002:a17:907:9485:b0:96a:b12d:2fdf with SMTP id
 dm5-20020a170907948500b0096ab12d2fdfmr10487913ejc.12.1684185571480; Mon, 15
 May 2023 14:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-1-sarthakkukreti@chromium.org>
 <20230506062909.74601-5-sarthakkukreti@chromium.org>
 <ZF54OH8hZTTko4c3@redhat.com>
In-Reply-To: <ZF54OH8hZTTko4c3@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Mon, 15 May 2023 14:19:20 -0700
Message-ID: <CAG9=OMMj+xNNNFR6JJbsbzjb=9oVScg+BYdAq68hBRzw3q81ZA@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v6 4/5] dm-thin: Add REQ_OP_PROVISION support
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
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBNYXkgMTIsIDIwMjMgYXQgMTA6MzLigK9BTSBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJA
a2VybmVsLm9yZz4gd3JvdGU6Cj4KPiBPbiBTYXQsIE1heSAwNiAyMDIzIGF0ICAyOjI5UCAtMDQw
MCwKPiBTYXJ0aGFrIEt1a3JldGkgPHNhcnRoYWtrdWtyZXRpQGNocm9taXVtLm9yZz4gd3JvdGU6
Cj4KPiA+IGRtLXRoaW5wb29sIHVzZXMgdGhlIHByb3Zpc2lvbiByZXF1ZXN0IHRvIHByb3Zpc2lv
bgo+ID4gYmxvY2tzIGZvciBhIGRtLXRoaW4gZGV2aWNlLiBkbS10aGlucG9vbCBjdXJyZW50bHkg
ZG9lcyBub3QKPiA+IHBhc3MgdGhyb3VnaCBSRVFfT1BfUFJPVklTSU9OIHRvIHVuZGVybHlpbmcg
ZGV2aWNlcy4KPiA+Cj4gPiBGb3Igc2hhcmVkIGJsb2NrcywgcHJvdmlzaW9uIHJlcXVlc3RzIHdp
bGwgYnJlYWsgc2hhcmluZyBhbmQgY29weSB0aGUKPiA+IGNvbnRlbnRzIG9mIHRoZSBlbnRpcmUg
YmxvY2suIEFkZGl0aW9uYWxseSwgaWYgJ3NraXBfYmxvY2tfemVyb2luZycKPiA+IGlzIG5vdCBz
ZXQsIGRtLXRoaW4gd2lsbCBvcHQgdG8gemVybyBvdXQgdGhlIGVudGlyZSByYW5nZSBhcyBhIHBh
cnQKPiA+IG9mIHByb3Zpc2lvbmluZy4KPiA+Cj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXJ0aGFrIEt1
a3JldGkgPHNhcnRoYWtrdWtyZXRpQGNocm9taXVtLm9yZz4KPiA+IC0tLQo+ID4gIGRyaXZlcnMv
bWQvZG0tdGhpbi5jIHwgNzAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNjYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMo
LSkKPiA+Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS10aGluLmMgYi9kcml2ZXJzL21k
L2RtLXRoaW4uYwo+ID4gaW5kZXggMmIxM2M5NDliZDcyLi4zZjk0ZjUzYWM5NTYgMTAwNjQ0Cj4g
PiAtLS0gYS9kcml2ZXJzL21kL2RtLXRoaW4uYwo+ID4gKysrIGIvZHJpdmVycy9tZC9kbS10aGlu
LmMKPiAuLi4KPiA+IEBAIC00MTE0LDYgKzQxNzEsOCBAQCBzdGF0aWMgdm9pZCBwb29sX2lvX2hp
bnRzKHN0cnVjdCBkbV90YXJnZXQgKnRpLCBzdHJ1Y3QgcXVldWVfbGltaXRzICpsaW1pdHMpCj4g
PiAgICAgICAgKiBUaGUgcG9vbCB1c2VzIHRoZSBzYW1lIGRpc2NhcmQgbGltaXRzIGFzIHRoZSB1
bmRlcmx5aW5nIGRhdGEKPiA+ICAgICAgICAqIGRldmljZS4gIERNIGNvcmUgaGFzIGFscmVhZHkg
c2V0IHRoaXMgdXAuCj4gPiAgICAgICAgKi8KPiA+ICsKPiA+ICsgICAgIGxpbWl0cy0+bWF4X3By
b3Zpc2lvbl9zZWN0b3JzID0gcG9vbC0+c2VjdG9yc19wZXJfYmxvY2s7Cj4KPiBKdXN0IG5vdGlj
ZWQgdGhhdCBzZXR0aW5nIGxpbWl0cy0+bWF4X3Byb3Zpc2lvbl9zZWN0b3JzIG5lZWRzIHRvIG1v
dmUKPiBhYm92ZSBwb29sX2lvX2hpbnRzIGNvZGUgdGhhdCBzZXRzIHVwIGRpc2NhcmRzIC0tIG90
aGVyd2lzZSB0aGUgZWFybHkKPiByZXR1cm4gZnJvbSBpZiAoIXB0LT5hZGp1c3RlZF9wZi5kaXNj
YXJkX2VuYWJsZWQpIHdpbGwgY2F1c2Ugc2V0dGluZwo+IG1heF9wcm92aXNpb25fc2VjdG9ycyB0
byBiZSBza2lwcGVkLgo+Cj4gSGVyZSBpcyBhIHJvbGwgdXAgb2YgdGhlIGZpeGVzIHRoYXQgbmVl
ZCB0byBiZSBmb2xkZWQgaW50byB0aGlzIHBhdGNoOgo+CkFoIHJpZ2h0LCB0aGFua3MgZm9yIHBv
aW50aW5nIHRoYXQgb3V0ISBJJ2xsIGZvbGQgdGhpcyBpbnRvIHY3LgoKQmVzdApTYXJ0aGFrCgo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXRoaW4uYyBiL2RyaXZlcnMvbWQvZG0tdGhpbi5j
Cj4gaW5kZXggM2Y5NGY1M2FjOTU2Li45MGM4ZTM2Y2IzMjcgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVy
cy9tZC9kbS10aGluLmMKPiArKysgYi9kcml2ZXJzL21kL2RtLXRoaW4uYwo+IEBAIC00MTUxLDYg
KzQxNTEsOCBAQCBzdGF0aWMgdm9pZCBwb29sX2lvX2hpbnRzKHN0cnVjdCBkbV90YXJnZXQgKnRp
LCBzdHJ1Y3QgcXVldWVfbGltaXRzICpsaW1pdHMpCj4gICAgICAgICAgICAgICAgIGJsa19saW1p
dHNfaW9fb3B0KGxpbWl0cywgcG9vbC0+c2VjdG9yc19wZXJfYmxvY2sgPDwgU0VDVE9SX1NISUZU
KTsKPiAgICAgICAgIH0KPgo+ICsgICAgICAgbGltaXRzLT5tYXhfcHJvdmlzaW9uX3NlY3RvcnMg
PSBwb29sLT5zZWN0b3JzX3Blcl9ibG9jazsKPiArCj4gICAgICAgICAvKgo+ICAgICAgICAgICog
cHQtPmFkanVzdGVkX3BmIGlzIGEgc3RhZ2luZyBhcmVhIGZvciB0aGUgYWN0dWFsIGZlYXR1cmVz
IHRvIHVzZS4KPiAgICAgICAgICAqIFRoZXkgZ2V0IHRyYW5zZmVycmVkIHRvIHRoZSBsaXZlIHBv
b2wgaW4gYmluZF9jb250cm9sX3RhcmdldCgpCj4gQEAgLTQxNzEsOCArNDE3Myw2IEBAIHN0YXRp
YyB2b2lkIHBvb2xfaW9faGludHMoc3RydWN0IGRtX3RhcmdldCAqdGksIHN0cnVjdCBxdWV1ZV9s
aW1pdHMgKmxpbWl0cykKPiAgICAgICAgICAqIFRoZSBwb29sIHVzZXMgdGhlIHNhbWUgZGlzY2Fy
ZCBsaW1pdHMgYXMgdGhlIHVuZGVybHlpbmcgZGF0YQo+ICAgICAgICAgICogZGV2aWNlLiAgRE0g
Y29yZSBoYXMgYWxyZWFkeSBzZXQgdGhpcyB1cC4KPiAgICAgICAgICAqLwo+IC0KPiAtICAgICAg
IGxpbWl0cy0+bWF4X3Byb3Zpc2lvbl9zZWN0b3JzID0gcG9vbC0+c2VjdG9yc19wZXJfYmxvY2s7
Cj4gIH0KPgo+ICBzdGF0aWMgc3RydWN0IHRhcmdldF90eXBlIHBvb2xfdGFyZ2V0ID0gewo+IEBA
IC00MzQ5LDYgKzQzNDksNyBAQCBzdGF0aWMgaW50IHRoaW5fY3RyKHN0cnVjdCBkbV90YXJnZXQg
KnRpLCB1bnNpZ25lZCBpbnQgYXJnYywgY2hhciAqKmFyZ3YpCj4KPiAgICAgICAgIHRpLT5udW1f
cHJvdmlzaW9uX2Jpb3MgPSAxOwo+ICAgICAgICAgdGktPnByb3Zpc2lvbl9zdXBwb3J0ZWQgPSB0
cnVlOwo+ICsgICAgICAgdGktPm1heF9wcm92aXNpb25fZ3JhbnVsYXJpdHkgPSB0cnVlOwo+Cj4g
ICAgICAgICBtdXRleF91bmxvY2soJmRtX3RoaW5fcG9vbF90YWJsZS5tdXRleCk7Cj4KCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

