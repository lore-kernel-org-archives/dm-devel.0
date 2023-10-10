Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81867CD98CB
	for <dm-devel@archiver.kernel.org>; Tue, 10 Oct 2023 22:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696977795;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PEF4j3yFx7Xb8+9W5K79RQmggtdvdWVEYyoIWCDd6CI=;
	b=I+jD3jwXcHlGJ0RI7NhRR0DHzVLxw70RfB0jjN3YA+Ym0HVK6Au9y0naE+2Bj0kdw1xy8E
	5IJsfekiozskfdrr2VjzSfnTvlFRhT4HsTjyKKFRdEGVwVj7om34o+vHjHYRzlB89231w2
	LQC//RdefARdp1oV0PfDv3UndpR6kYo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-OUkrszlqPtS2KJUlFMsv8Q-1; Tue, 10 Oct 2023 18:43:12 -0400
X-MC-Unique: OUkrszlqPtS2KJUlFMsv8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9FBC28EC100;
	Tue, 10 Oct 2023 22:43:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9536B2029296;
	Tue, 10 Oct 2023 22:43:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 61A0919465B8;
	Tue, 10 Oct 2023 22:43:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D517319465B8
 for <dm-devel@listman.corp.redhat.com>; Tue, 10 Oct 2023 22:43:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A97DD40C6CA1; Tue, 10 Oct 2023 22:43:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F8B140C6CA0
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 22:43:08 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AC29101A59B
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 22:43:08 +0000 (UTC)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-NJQCgXpXNZezRp_BfIHkyg-1; Tue, 10 Oct 2023 18:43:06 -0400
X-MC-Unique: NJQCgXpXNZezRp_BfIHkyg-1
Received: by mail-ej1-f52.google.com with SMTP id
 a640c23a62f3a-9b2cee40de8so68077466b.1
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 15:43:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696977785; x=1697582585;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=ZiiBrXOxoUPtOhsPD+IILs+FkUT2KdEPOOeHI47Xduo=;
 b=tdCzsFsm/pd76L/iIwHC5TRvHYKcqk3z9EPMn9Rfg9YfAPSfkMGimyeMRiAj6VPcVU
 FOrJ4QdfCUopKfP8lrOMYAYuWssBj1lDAxbWfWuWvHUWepYHP5EYVIDrWPvpRr1VLevB
 GxLWkbXEbdqFXZ+ABIbo/H3zNaIjiAZmHYOu/Di4cb5QP0VNrus1FNO4VWs4i8H9OYdk
 8Te+XjlUWHT2joJMx1v1hmdP34oqeyjfePeN9mGVjaZ4QhbNSdLN3jHiwLo+VbZtiMCq
 z8W313jlvH7hmy/4WYqv9n/09vca+BkX9hptBfoTc+1y97t0wdJV/hWLhCfBI9/TUGYN
 OWqw==
X-Gm-Message-State: AOJu0YwYzxxd2rwvz0Y485GO4ihM7IhyxMpG32IW0CN2ealNDW9BtGFQ
 2ggw2sXPezOJQYCYQu7kZrXFR/2PLrNuczViz2mlTw==
X-Google-Smtp-Source: AGHT+IFotSdmS/weR8N0yeiFGDMN5c3jV8goT8FK1+WcHfetybABPHYPGgBblpU1FPb+bHDpyd0PwqqzLwRCp1nlk34=
X-Received: by 2002:a17:907:9491:b0:9a5:962c:cb6c with SMTP id
 dm17-20020a170907949100b009a5962ccb6cmr15511476ejc.31.1696977785597; Tue, 10
 Oct 2023 15:43:05 -0700 (PDT)
MIME-Version: 1.0
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <ZSNANlreccIVXuo+@dread.disaster.area>
In-Reply-To: <ZSNANlreccIVXuo+@dread.disaster.area>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Tue, 10 Oct 2023 15:42:53 -0700
Message-ID: <CAG9=OMMM3S373Y6UEeXxnOyvMvA9wmAVd4Jrdjt3gzkz9d2yUg@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v8 0/5] Introduce provisioning primitives
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
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gU3VuLCBPY3QgOCwgMjAyMyBhdCA0OjUw4oCvUE0gRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9t
b3JiaXQuY29tPiB3cm90ZToKPgo+IE9uIEZyaSwgT2N0IDA2LCAyMDIzIGF0IDA2OjI4OjEyUE0g
LTA3MDAsIFNhcnRoYWsgS3VrcmV0aSB3cm90ZToKPiA+IEhpLAo+ID4KPiA+IFRoaXMgcGF0Y2gg
c2VyaWVzIGlzIHZlcnNpb24gOCBvZiB0aGUgcGF0Y2ggc2VyaWVzIHRvIGludHJvZHVjZQo+ID4g
YmxvY2stbGV2ZWwgcHJvdmlzaW9uaW5nIG1lY2hhbmlzbSAob3JpZ2luYWwgWzFdKSwgd2hpY2gg
aXMgdXNlZnVsIGZvciBwcm92aXNpb25pbmcKPiA+IHNwYWNlIGFjcm9zcyB0aGlubHkgcHJvdmlz
aW9uZWQgc3RvcmFnZSBhcmNoaXRlY3R1cmVzIChsb29wIGRldmljZXMKPiA+IGJhY2tlZCBieSBz
cGFyc2UgZmlsZXMsIGRtLXRoaW4gZGV2aWNlcywgdmlydGlvLWJsaykuIFRoaXMgc2VyaWVzIGhh
cwo+ID4gbWluaW1hbCBjaGFuZ2VzIG92ZXIgdjdbMl0uCj4gPgo+ID4gVGhpcyBwYXRjaCBzZXJp
ZXMgaXMgcmViYXNlZCBmcm9tIHRoZSBsaW51eC1kbS9kbS02LjUtcHJvdmlzaW9uLXN1cHBvcnQg
WzFdIG9uIHRvCj4gPiAoY2FjNDA1YTNiZmEyIE1lcmdlIHRhZyAnZm9yLTYuNi1yYzMtdGFnJyku
IEluIGFkZGl0aW9uLCB0aGVyZSdzIGFuCj4gPiBhZGRpdGlvbmFsIHBhdGNoIHRvIGFsbG93IHBh
c3NpbmcgdGhyb3VnaCBhbiB1bnNoYXJlIGludGVudCB2aWEgUkVRX09QX1BST1ZJU0lPTgo+ID4g
KHN1Z2dlc3RlZCBieSBEYXJyaWNrIGluIFs0XSkuCj4KPiBUaGUgWEZTIHBhdGNoZXMgSSBqdXN0
IHBvc3RlZCB3ZXJlIHNtb2tlIHRlc3RlZCBhIHdoaWxlIGJhY2sgYWdhaW5zdAo+IGxvb3AgZGV2
aWNlcyBhbmQgdGhlbiBmb3J3YXJkIHBvcnRlZCB0byB0aGlzIHBhdGNoc2V0LiBHb29kIGZvcgo+
IHRlc3RpbmcgdGhhdCB1c2Vyc3BhY2UgZHJpdmVuIGZpbGUgcHJlYWxsb2NhdGlvbiBnZXRzIHBy
b3BhZ2F0ZWQgYnkKPiB0aGUgZmlsZXN5c3RlbSBkb3duIHRvIHRoZSBiYWNraW5nIGRldmljZSBj
b3JyZWN0bHkgYW5kIHRoYXQKPiBzdWJzZXF1ZW50IElPIHRvIHRoZSBmaWxlIHRoZW4gZG9lcyB0
aGUgcmlnaHQgdGhpbmcgKGUuZy4gZmlvCj4gdGVzdGluZyB1c2luZyBmYWxsb2NhdGUoKSB0byBz
ZXQgdXAgdGhlIGZpbGVzIGJlaW5nIHdyaXR0ZW4gdG8pLi4uLgo+CgpUaGFua3MhIEkndmUgYmVl
biB0ZXN0aW5nIHdpdGggYSBXSVAgcGF0Y2ggZm9yIGV4dDQsIEknbGwgZ2l2ZSB5b3VyCnBhdGNo
ZXMgYSB0cnkuIE9uY2Ugd2UgYXJlIGNsb3NlciB0byBzdWJtaXR0aW5nIHRoZSBmaWxlc3lzdGVt
CnN1cHBvcnQsIHdlIGNhbiBmb3JtYWxpemUgdGhlIHRlc3QgaW50byBhbiB4ZnN0ZXN0IChzcGFy
c2UgZmlsZSArIGxvb3AKKyBmaWxlc3lzdGVtLCBmYWxsb2NhdGUoKSBmaWxlLCBjaGVjayB0aGUg
c2l6ZSBvZiB0aGUgdW5kZXJseWluZwpzcGFyc2UgZmlsZSkuCgpCZXN0ClNhcnRoYWsKCgotIFNh
cnRoYWsKCj4gLURhdmUuCj4gLS0KPiBEYXZlIENoaW5uZXIKPiBkYXZpZEBmcm9tb3JiaXQuY29t
CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xp
c3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

