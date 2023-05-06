Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57273C77B75
	for <dm-devel@archiver.kernel.org>; Sat,  6 May 2023 06:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683354750;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A9iQMN7trXESrAnCWtxClsyW4/Ww1Emm+q1aJGgP8b8=;
	b=g9IEocYOhOho5ziVZgKeWtsoqIv7P3o/GhZnWXQxV9hpkjP/3PxRDF8NCFSVUTDhWC9K/a
	lAyqhFyN3mgpHFnPupLlml9gjOo4bC+dIAHqQLsAsRvPEoOnJjt0HOn9c3Uu2ZjhB+pOM1
	jgzWhpifKYL0++vFM67lWpv7wtL5c4k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-a0TCVh5oOJWqpO4cUMYirw-1; Sat, 06 May 2023 02:32:27 -0400
X-MC-Unique: a0TCVh5oOJWqpO4cUMYirw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A12AB84AF30;
	Sat,  6 May 2023 06:32:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CED4C15BA0;
	Sat,  6 May 2023 06:32:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 716DA1946588;
	Sat,  6 May 2023 06:32:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DEC321946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  6 May 2023 06:32:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CD19EC16024; Sat,  6 May 2023 06:32:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4CE5C15BA0
 for <dm-devel@redhat.com>; Sat,  6 May 2023 06:32:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 828E81C06EE7
 for <dm-devel@redhat.com>; Sat,  6 May 2023 06:32:18 +0000 (UTC)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com
 [209.85.208.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-W1VFC2tTPfm-WZ2D5SuAwg-1; Sat, 06 May 2023 02:32:14 -0400
X-MC-Unique: W1VFC2tTPfm-WZ2D5SuAwg-1
Received: by mail-ed1-f41.google.com with SMTP id
 4fb4d7f45d1cf-50b37f3e664so4618957a12.1
 for <dm-devel@redhat.com>; Fri, 05 May 2023 23:32:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1683354734; x=1685946734;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=dh+rLv64T/XKdExtopYbn1p2e3mwdhjXoRnI90UeXPc=;
 b=JZCoOPVw80ZscfHYJe3wHLvPBpjc1RKQOrFR4UUO8QLDCak+cKjdj9j4E5jug6H90k
 gqYQoUbF0gM5frFcdvhLDEGw2+tAw2oEELwZg8GGBVNOwQ4rHRtLrzhq5UOHc1cl4pZu
 dW2z870iYyWDXWhq3buMD/2Dv24OIZH4s9Id+aoMU6xkxw4gYqojVPhA01qPUldrbU+Y
 uI5BARtLnbH1043ZL9PiwO5iNquP9BSYzXvCG4hH3PDhrx1o84P3CL4h1bzkp6BdTvkX
 sVLBgcrOlbjiXmWCUUwTp8KzykgcDsJSva2LP+Qy0/N6DgZMWcimiIDvmxwh4PsAXT8d
 kUNw==
X-Gm-Message-State: AC+VfDzPnGguwBW1T+jk1ILSrOSeFXR3h3aINn52LVdjDm+trXqaHMsv
 qVm5YdAmwNb5cFmOoYlzerlKzXjXxyzPqDwIcoV8JQ==
X-Google-Smtp-Source: ACHHUZ49lLaiO0buFBePac28VZVZZ5J4y63mNd4+sXRBHhN0wwrJ6PD3jFK0pFSF8IgYJk2lmVOifSuBIwb8CLlZkRk=
X-Received: by 2002:a17:907:9605:b0:93e:fa12:aa1a with SMTP id
 gb5-20020a170907960500b0093efa12aa1amr3601469ejc.1.1683354733732; Fri, 05 May
 2023 23:32:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-5-sarthakkukreti@chromium.org>
 <ZFAP5yQ0mwE4F6Vg@redhat.com>
In-Reply-To: <ZFAP5yQ0mwE4F6Vg@redhat.com>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Fri, 5 May 2023 23:32:02 -0700
Message-ID: <CAG9=OMNh8w9hmkU6ZHBm8bN0NGCL4NaKv7XAEQrFvTKKNcXLLg@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v5 4/5] dm-thin: Add REQ_OP_PROVISION support
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
 ejt@redhat.com, linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBNYXkgMSwgMjAyMyBhdCAxMjoxNeKAr1BNIE1pa2UgU25pdHplciA8c25pdHplckBr
ZXJuZWwub3JnPiB3cm90ZToKPgo+IE9uIFdlZCwgQXByIDE5IDIwMjMgYXQgIDg6NDhQIC0wNDAw
LAo+IFNhcnRoYWsgS3VrcmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPiB3cm90ZToK
Pgo+ID4gZG0tdGhpbnBvb2wgdXNlcyB0aGUgcHJvdmlzaW9uIHJlcXVlc3QgdG8gcHJvdmlzaW9u
Cj4gPiBibG9ja3MgZm9yIGEgZG0tdGhpbiBkZXZpY2UuIGRtLXRoaW5wb29sIGN1cnJlbnRseSBk
b2VzIG5vdAo+ID4gcGFzcyB0aHJvdWdoIFJFUV9PUF9QUk9WSVNJT04gdG8gdW5kZXJseWluZyBk
ZXZpY2VzLgo+ID4KPiA+IEZvciBzaGFyZWQgYmxvY2tzLCBwcm92aXNpb24gcmVxdWVzdHMgd2ls
bCBicmVhayBzaGFyaW5nIGFuZCBjb3B5IHRoZQo+ID4gY29udGVudHMgb2YgdGhlIGVudGlyZSBi
bG9jay4gQWRkaXRpb25hbGx5LCBpZiAnc2tpcF9ibG9ja196ZXJvaW5nJwo+ID4gaXMgbm90IHNl
dCwgZG0tdGhpbiB3aWxsIG9wdCB0byB6ZXJvIG91dCB0aGUgZW50aXJlIHJhbmdlIGFzIGEgcGFy
dAo+ID4gb2YgcHJvdmlzaW9uaW5nLgo+ID4KPiA+IFNpZ25lZC1vZmYtYnk6IFNhcnRoYWsgS3Vr
cmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0ub3JnPgo+ID4gLS0tCj4gPiAgZHJpdmVycy9t
ZC9kbS10aGluLmMgfCA3MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0tLQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA2OCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygt
KQo+ID4KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2RtLXRoaW4uYyBiL2RyaXZlcnMvbWQv
ZG0tdGhpbi5jCj4gPiBpbmRleCAyYjEzYzk0OWJkNzIuLjU4ZDYzM2Y1YzkyOCAxMDA2NDQKPiA+
IC0tLSBhL2RyaXZlcnMvbWQvZG0tdGhpbi5jCj4gPiArKysgYi9kcml2ZXJzL21kL2RtLXRoaW4u
Ywo+ID4gQEAgLTE4OTEsNyArMTg5Myw4IEBAIHN0YXRpYyB2b2lkIHByb2Nlc3Nfc2hhcmVkX2Jp
byhzdHJ1Y3QgdGhpbl9jICp0Yywgc3RydWN0IGJpbyAqYmlvLAo+ID4KPiA+ICAgICAgIGlmIChi
aW9fZGF0YV9kaXIoYmlvKSA9PSBXUklURSAmJiBiaW8tPmJpX2l0ZXIuYmlfc2l6ZSkgewo+ID4g
ICAgICAgICAgICAgICBicmVha19zaGFyaW5nKHRjLCBiaW8sIGJsb2NrLCAma2V5LCBsb29rdXBf
cmVzdWx0LCBkYXRhX2NlbGwpOwo+ID4gLSAgICAgICAgICAgICBjZWxsX2RlZmVyX25vX2hvbGRl
cih0YywgdmlydF9jZWxsKTsKPiA+ICsgICAgICAgICAgICAgaWYgKGJpb19vcChiaW8pICE9IFJF
UV9PUF9QUk9WSVNJT04pCj4gPiArICAgICAgICAgICAgICAgICAgICAgY2VsbF9kZWZlcl9ub19o
b2xkZXIodGMsIHZpcnRfY2VsbCk7Cj4KPiBDYW4geW91IHBsZWFzZSBleHBsYWluIHdoeSBjZWxs
X2RlZmVyX25vX2hvbGRlcigpIGlzIHNraXBwZWQgZm9yIFJFUV9PUF9QUk9WSVNJT04gaGVyZT8K
PgpJIHJlY2FsbGVkIHNlZWluZyBhIEJVRyBpbiBkbS1wcmlzb24tdjEgaWYgSSBhbGxvd2VkCmNl
bGxfZGVmZXJfbm9faG9sZGVyKCkgZm9yIFJFUV9PUF9QUk9WSVNJT04sIGJ1dCBmcm9tIGFkZGl0
aW9uYWwKdGVzdGluZywgaXQgbG9va3MgbGlrZSBpdCB3YXMgbGVmdCBiZWhpbmQgZnJvbSBhIGNs
ZWFudXAgaW4gdjQuCkRyb3BwZWQgaW4gdjYuCgpUaGFua3MKU2FydGhhawoKPiBUaGFua3MsCj4g
TWlrZQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

