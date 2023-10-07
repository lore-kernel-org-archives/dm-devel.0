Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C2BE9413E
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 01:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696642241;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eY1NVUVRMuQ9ejggDjrLuI8Pr/DenZIr8bGIF7FcDLM=;
	b=eiF/682fGKmASqKkCRVMz5migD6sG1naLpr/R4tFgSaAr/OQFi3sre3ul6+ZQRWW5h0Hek
	oqLdtWJIt73bLhr2QiIVFkVlbdDkiEgtKFnzEimI61zoSj7FLLoai2uf5glV5PSZ3tLPP1
	ZMxowxmEnhiJOtxMxJCBqgOb61UIm0k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-4lJufVyZMaSZhKsOsVzM4A-1; Fri, 06 Oct 2023 21:30:39 -0400
X-MC-Unique: 4lJufVyZMaSZhKsOsVzM4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C784581163A;
	Sat,  7 Oct 2023 01:30:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B3E84C15BB8;
	Sat,  7 Oct 2023 01:30:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8212F1946589;
	Sat,  7 Oct 2023 01:30:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 270891946588
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 01:30:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EF4C82027019; Sat,  7 Oct 2023 01:30:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E73802026D37
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:30:36 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC226803D6A
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 01:30:36 +0000 (UTC)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com
 [209.85.218.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-OUjMhzizOx-e9DLdjvs3nw-1; Fri, 06 Oct 2023 21:30:34 -0400
X-MC-Unique: OUjMhzizOx-e9DLdjvs3nw-1
Received: by mail-ej1-f49.google.com with SMTP id
 a640c23a62f3a-9b1ebc80d0aso475051166b.0
 for <dm-devel@redhat.com>; Fri, 06 Oct 2023 18:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696642233; x=1697247033;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=IF4QfWNaA43XRLFWp4IMKch1uhvVZ0qlp9xdhdkNJ44=;
 b=Cy1al/PlpUhqOIvbFJv6Oi2ujYyBfA9mAg4cawh8bW4+Vc4DcykxYc2MJ41+ktWrJP
 9IK3LOTQJjr1lc1HZwECk1n24/m5v/m68dp4HFLvZLSmCEqUNd0aqxYDLo8B6WkbeWJF
 Ai8Duki6IWRsMd0Svimhf48+2GwVftL89p06bOTz8QpbBm+7eWoNjAHuHHKQWp5HjN0i
 rBcX3y7PGabNrjVp5maI9uPeJBzp4lkNziEvDeMVrJBpJMSfoO68fFNgJtK8MvuAvyxQ
 SRV8yGQx1dFhHxE3QAoJGBTal+eFql3dKyUg6WtdZN8GLAhm98kLZIx6Sw1pLFK3FKcw
 +n0w==
X-Gm-Message-State: AOJu0Yxt2xThhPOj4aPwPk8culfy7e9w8KfI05WzlwIm0UlBDRlhq+r8
 uIwWUhBcb3uSuZMmEveedp7yyXrQvLjcLK0U3LPRBQ==
X-Google-Smtp-Source: AGHT+IGkSJj0mtqaOVe5wcCfMcCmFe6Tgpzeqmz0eI2dsh3Q9Ib7QP0au+a6EA1F28rIWShFnSAVw+4uLntty8zEul4=
X-Received: by 2002:a17:907:2704:b0:9ae:961a:de81 with SMTP id
 w4-20020a170907270400b009ae961ade81mr7780096ejk.27.1696642233743; Fri, 06 Oct
 2023 18:30:33 -0700 (PDT)
MIME-Version: 1.0
References: <ZHFEfngPyUOqlthr@dread.disaster.area>
 <CAJ0trDZJQwvAzngZLBJ1hB0XkQ1HRHQOdNQNTw9nK-U5i-0bLA@mail.gmail.com>
 <ZHYB/6l5Wi+xwkbQ@redhat.com>
 <CAJ0trDaUOevfiEpXasOESrLHTCcr=oz28ywJU+s+YOiuh7iWow@mail.gmail.com>
 <ZHYWAGmKhwwmTjW/@redhat.com>
 <CAG9=OMMnDfN++-bJP3jLmUD6O=Q_ApV5Dr392_5GqsPAi_dDkg@mail.gmail.com>
 <ZHqOvq3ORETQB31m@dread.disaster.area> <ZHti/MLnX5xGw9b7@redhat.com>
 <CAG9=OMNv80fOyVixEY01XESnOFzYyfj9j8etHMq_Ap52z4UWNQ@mail.gmail.com>
 <ZIESXNF5anyvJEjm@redhat.com> <ZIOMLfMjugGf4C2T@redhat.com>
In-Reply-To: <ZIOMLfMjugGf4C2T@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Fri, 6 Oct 2023 18:30:22 -0700
Message-ID: <CAG9=OMPqGmX75ZmK=Fc7DNE7dcxS+t-UPkjtCVDF+dPN+xkrNg@mail.gmail.com>
To: Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v7 0/5] Introduce provisioning primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 Joe Thornber <thornber@redhat.com>, dm-devel@redhat.com,
 "Michael S. Tsirkin" <mst@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>, Joe Thornber <ejt@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Brian Foster <bfoster@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBKdW4gOSwgMjAyMyBhdCAxOjMx4oCvUE0gTWlrZSBTbml0emVyIDxzbml0emVyQHJl
ZGhhdC5jb20+IHdyb3RlOgo+Cj4gT24gV2VkLCBKdW4gMDcgMjAyMyBhdCAgNzoyN1AgLTA0MDAs
Cj4gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+Cj4gPiBPbiBNb24s
IEp1biAwNSAyMDIzIGF0ICA1OjE0UCAtMDQwMCwKPiA+IFNhcnRoYWsgS3VrcmV0aSA8c2FydGhh
a2t1a3JldGlAY2hyb21pdW0ub3JnPiB3cm90ZToKPiA+Cj4gPiA+IE9uIFNhdCwgSnVuIDMsIDIw
MjMgYXQgODo1N+KAr0FNIE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwub3JnPiB3cm90ZToK
PiA+ID4gPgo+ID4gPiA+IFdlIGFsbCBqdXN0IG5lZWQgdG8gZm9jdXMgb24geW91ciBwcm9wb3Nh
bCBhbmQgSm9lJ3MgZG0tdGhpbgo+ID4gPiA+IHJlc2VydmF0aW9uIGRlc2lnbi4uLgo+ID4gPiA+
Cj4gPiA+ID4gW1NhcnRoYWs6IEZZSSwgdGhpcyBpbXBsaWVzIHRoYXQgaXQgZG9lc24ndCByZWFs
bHkgbWFrZSBzZW5zZSB0byBhZGQKPiA+ID4gPiBkbS10aGlucCBzdXBwb3J0IGJlZm9yZSBKb2Un
cyBkZXNpZ24gaXMgaW1wbGVtZW50ZWQuICBPdGhlcndpc2Ugd2UnbGwKPiA+ID4gPiBoYXZlIDIg
ZGlmZmVyZW50IHJlc3BvbnNlcyB0byBSRVFfT1BfUFJPVklTSU9OLiAgVGhlIG9uZSB0aGF0IGlz
Cj4gPiA+ID4gY2FwdHVyZWQgaW4geW91ciBwYXRjaHNldCBpc24ndCBhZGVxdWF0ZSB0byBwcm9w
ZXJseSBoYW5kbGUgZW5zdXJpbmcKPiA+ID4gPiB1cHBlciBsYXllciAobGlrZSBYRlMpIGNhbiBk
ZXBlbmQgb24gdGhlIHNwYWNlIGJlaW5nIGF2YWlsYWJsZSBhY3Jvc3MKPiA+ID4gPiBzbmFwc2hv
dCBib3VuZGFyaWVzLl0KPiA+ID4gPgo+ID4gPiBBY2suIFdvdWxkIGl0IGJlIHByZW1hdHVyZSBm
b3IgdGhlIHJlc3Qgb2YgdGhlIHNlcmllcyB0byBnbyB0aHJvdWdoCj4gPiA+IChSRVFfT1BfUFJP
VklTSU9OICsgc3VwcG9ydCBmb3IgbG9vcCBhbmQgbm9uLWRtLXRoaW5wIGRldmljZS1tYXBwZXIK
PiA+ID4gdGFyZ2V0cyk/IEknZCBsaWtlIHRvIHN0YXJ0IHVzaW5nIHRoaXMgYXMgYSByZWZlcmVu
Y2UgdG8gc3VnZ2VzdAo+ID4gPiBhZGRpdGlvbnMgdG8gdGhlIHZpcnRpby1zcGVjIGZvciB2aXJ0
aW8tYmxrIHN1cHBvcnQgYW5kIHN0YXJ0IGxvb2tpbmcKPiA+ID4gYXQgd2hhdCBhbiBleHQ0IGlt
cGxlbWVudGF0aW9uIHdvdWxkIGxvb2sgbGlrZS4KPiA+Cj4gPiBQbGVhc2UgZHJvcCB0aGUgZG0t
dGhpbi5jIGFuZCBkbS1zbmFwLmMgY2hhbmdlcy4gIGRtLXNuYXAuYyB3b3VsZCBuZWVkCj4gPiBt
b3JlIHdvcmsgdG8gcHJvdmlkZSB0aGUgdHlwZSBvZiBndWFyYW50ZWUgWEZTIHJlcXVpcmVzIGFj
cm9zcwo+ID4gc25hcHNob3QgYm91bmRhcmllcy4gSSdtIGluY2xpbmVkIHRvIF9ub3RfIGFkZCBk
bS1zbmFwLmMgc3VwcG9ydAo+ID4gYmVjYXVzZSBpdCBpcyBiZXN0IHRvIGp1c3QgdXNlIGRtLXRo
aW4uCj4gPgo+ID4gQW5kIEZZSSBldmVuIHlvdXIgZG0tdGhpbiBwYXRjaCB3aWxsIGJlIHRoZSBz
dGFydGluZyBwb2ludCBmb3IgdGhlCj4gPiBkbS10aGluIHN1cHBvcnQgKHdlJ2xsIGtlZXAgYXR0
cmlidXRpb24gdG8geW91IGZvciBhbGwgdGhlIGNvZGUgaW4gYQo+ID4gc2VwYXJhdGUgcGF0Y2gp
Lgo+ID4KPiA+ID4gRmFpciBwb2ludHMsIEkgY2VydGFpbmx5IGRvbid0IHdhbnQgdG8gZGVyYWls
IHRoaXMgY29udmVyc2F0aW9uOyBJJ2QKPiA+ID4gYmUgaGFwcHkgdG8gc2VlIHRoaXMgd29yayBt
ZXJnZWQgc29vbmVyIHJhdGhlciB0aGFuIGxhdGVyLgo+ID4KPiA+IE9uY2UgdGhvc2UgZG0gdGFy
Z2V0IGNoYW5nZXMgYXJlIGRyb3BwZWQgSSB0aGluayB0aGUgcmVzdCBvZiB0aGUKPiA+IHNlcmll
cyBpcyBmaW5lIHRvIGdvIHVwc3RyZWFtIG5vdy4gIEZlZWwgZnJlZSB0byBwb3N0IGEgdjguCj4K
PiBGWUksIEkndmUgbWFkZSBteSBsYXRlc3QgY29kZSBhdmFpbGFibGUgaW4gdGhpcwo+ICdkbS02
LjUtcHJvdmlzaW9uLXN1cHBvcnQnIGJyYW5jaCAoYmFzZWQgb24gJ2RtLTYuNScpOgo+IGh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RldmljZS1tYXBwZXIv
bGludXgtZG0uZ2l0L2xvZy8/aD1kbS02LjUtcHJvdmlzaW9uLXN1cHBvcnQKPgo+IEl0J3Mgd2hh
dCB2OCBzaG91bGQgYmUgcGx1cyB0aGUgMiBkbS10aGluIHBhdGNoZXMgKHRoYXQgSSBkb24ndCB0
aGluawo+IHNob3VsZCBnbyB1cHN0cmVhbSB5ZXQsIGJ1dCBhcmUgdGhlb3JldGljYWxseSB1c2Vm
dWwgZm9yIERhdmUgYW5kCj4gSm9lKS4KPgpDaGVlcnMhIEFwb2xvZ2llcyBmb3IgZHJvcHBpbmcg
dGhlIGJhbGwgb24gdGhpcywgSSBqdXN0IHNlbnQgb3V0IHY4CndpdGggdGhlIGRtLXRoaW4gcGF0
Y2hlcyBkcm9wcGVkLgoKCi0gU2FydGhhawoKPiBUaGUgImRtIHRoaW46IGNvbXBsZXRlIGludGVy
ZmFjZSBmb3IgUkVRX09QX1BST1ZJU0lPTiBzdXBwb3J0IiBjb21taXQKPiBlc3RhYmxpc2hlcyBh
bGwgdGhlIGRtLXRoaW4gaW50ZXJmYWNlIEkgdGhpbmsgaXMgbmVlZGVkLiAgVGhlIEZJWE1FIGlu
Cj4gcHJvY2Vzc19wcm92aXNpb25fYmlvKCkgKGFuZCB0aGUgcGF0Y2ggaGVhZGVyKSBjYXV0aW9u
cyBhZ2FpbnN0IHVwcGVyCj4gbGF5ZXJzIGxpa2UgWEZTIHVzaW5nIHRoaXMgZG0tdGhpbnAgc3Vw
cG9ydCBxdWl0ZSB5ZXQuCj4KPiBPdGhlcndpc2Ugd2UnbGwgaGF2ZSB0aGUgaXNzdWUgd2hlcmUg
ZG0tdGhpbnAncyBSRVFfT1BfUFJPVklTSU9OCj4gc3VwcG9ydCBpbml0aWFsbHkgZG9lc24ndCBw
cm92aWRlIHRoZSBndWFyYW50ZWUgdGhhdCBYRlMgbmVlZHMgYWNyb3NzCj4gc25hcHNob3RzICh3
aGljaCBpczogc25hcHNob3RzIGluaGVyaXQgYWxsIHByZXZpb3VzIFJFUV9PUF9QUk9WSVNJT04p
Lgo+Cj4gTWlrZQo+CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

