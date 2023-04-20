Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34344C77B7E
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 01:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681955341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b8HdL+ykcwMsEB8BrTJWgYOIEN4wb+PTwpRA9U0h8oU=;
	b=fx1PIepfYElM6sMYkK0UeJKA7AV/I8OXbvhgKQmw9as2xb5Vf/OwedfQeBF54S7DBNpKbm
	MMnNYBRa2XwqVZhnOJo8yTv0B/LDsJoWKAaMZfdesA7bkgUnk3bFTzZRA9fQBfX2bjfelj
	6UENvQUOWU59rAgpQtjwfsiOntU5Kf8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-LjfL1zZ3OeGpk-l8BdEEog-1; Wed, 19 Apr 2023 21:49:00 -0400
X-MC-Unique: LjfL1zZ3OeGpk-l8BdEEog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFBB18996E0;
	Thu, 20 Apr 2023 01:48:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE1161121315;
	Thu, 20 Apr 2023 01:48:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BF7F919465B9;
	Thu, 20 Apr 2023 01:48:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B170619465B5
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 01:48:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 96C9D492B00; Thu, 20 Apr 2023 01:48:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F413492C3E
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 01:48:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73C222999B36
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 01:48:56 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-IBdXuqEYOGyMz9x97c5H1Q-1; Wed, 19 Apr 2023 21:48:54 -0400
X-MC-Unique: IBdXuqEYOGyMz9x97c5H1Q-1
Received: by mail-ed1-f54.google.com with SMTP id
 4fb4d7f45d1cf-5067736607fso503735a12.0
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 18:48:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681955333; x=1684547333;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=//w2KpKliRFtK58d1EJmwfMo5BWc/3hlHccBcm4S1F0=;
 b=Dc+tYZdI7Tm9TZjjDTVvv2snUPgtMuSkY3KZ1iwnch2o4cg8zGEQvt//36EG1/xWfn
 NqcKiDiMIAyboIkG7KHFp+0YkDO4XvlBowT+QNghnFguO636UfZCEUUp2FgorBjmoVaH
 HLSgwemybteKP8LgKgJIE8LWf/yPLX+ij/IG+HagJa4WSoeUCKHEcrOB8L8FHL1Q0xP5
 aauPZDAvVsDRRalASOMvBBMcpmXF5qsPHEQGQM/ISr1BbuUAtQUrIKE7RrQwQWeBrvwC
 a92P4Fhd2W028XvXKOO3kno4gu6rSKqifw7cjhMcRbagdJS2b/xStLh5/DUMUrQ4LN/n
 Keag==
X-Gm-Message-State: AAQBX9fKzsQQ5GkBXu4OadSqVCguelgrwZYQLvHNau+XTyj+pcqu6+92
 JqLYDoT+f0yQC9k3w3J9+xAfzimHfb75lEUTRubjaw==
X-Google-Smtp-Source: AKy350Z2wHZXrdLmCljCXZmXuQtTIZ6kMfErfzcZVLiPXa6Vv3hJOhOQDnwXcad0AaOBHDbgGBaLGi1H8St8LWJSs6w=
X-Received: by 2002:aa7:d60a:0:b0:506:833c:abcf with SMTP id
 c10-20020aa7d60a000000b00506833cabcfmr7313519edr.42.1681955333496; Wed, 19
 Apr 2023 18:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-2-sarthakkukreti@chromium.org>
 <20230420012243.GO360895@frogsfrogsfrogs>
In-Reply-To: <20230420012243.GO360895@frogsfrogsfrogs>
From: Sarthak Kukreti <sarthakkukreti@chromium.org>
Date: Wed, 19 Apr 2023 18:48:42 -0700
Message-ID: <CAG9=OMMqm6AsdxbGBJJs7DRH-AUtQj8ocC+UJmvVTMMKdVQDnw@mail.gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v5 1/5] block: Don't invalidate pagecache for
 invalid falloc modes
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
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

U29ycnkgSSB0cmllZCB0byBiZSB0b28gY29uY2lzZSA6KSBVcGRhdGVkIHdpdGggYSBmaXhlZCB1
cCBwYXRjaCEKCkJlc3QKU2FyaHRhawoKT24gV2VkLCBBcHIgMTksIDIwMjMgYXQgNjoyMuKAr1BN
IERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+IHdyb3RlOgo+Cj4gT24gV2VkLCBB
cHIgMTksIDIwMjMgYXQgMDU6NDg6NDZQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRpIHdyb3RlOgo+
ID4gT25seSBjYWxsIHRydW5jYXRlX2JkZXZfcmFuZ2UoKSBpZiB0aGUgZmFsbG9jYXRlIG1vZGUg
aXMKPiA+IHN1cHBvcnRlZC4gVGhpcyBmaXhlcyBhIGJ1ZyB3aGVyZSBkYXRhIGluIHRoZSBwYWdl
Y2FjaGUKPiA+IGNvdWxkIGJlIGludmFsaWRhdGVkIGlmIHRoZSBmYWxsb2NhdGUoKSB3YXMgY2Fs
bGVkIG9uIHRoZQo+ID4gYmxvY2sgZGV2aWNlIHdpdGggYW4gaW52YWxpZCBtb2RlLgo+ID4KPiA+
IEZpeGVzOiAyNWY0YzQxNDE1ZTUgKCJibG9jazogaW1wbGVtZW50IChzb21lIG9mKSBmYWxsb2Nh
dGUgZm9yIGJsb2NrIGRldmljZXMiKQo+ID4gU2lnbmVkLW9mZi1ieTogU2FydGhhayBLdWtyZXRp
IDxzYXJ0aGFra3VrcmV0aUBjaHJvbWl1bS5vcmc+Cj4gPiAtLS0KPiA+ICBibG9jay9mb3BzLmMg
fCAxOCArKysrKysrKysrLS0tLS0tLS0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9u
cygrKSwgOCBkZWxldGlvbnMoLSkKPiA+Cj4gPiBkaWZmIC0tZ2l0IGEvYmxvY2svZm9wcy5jIGIv
YmxvY2svZm9wcy5jCj4gPiBpbmRleCBkMmU2YmU0ZTNkMWMuLjJmZDdlOGI5YWI0OCAxMDA2NDQK
PiA+IC0tLSBhL2Jsb2NrL2ZvcHMuYwo+ID4gKysrIGIvYmxvY2svZm9wcy5jCj4gPiBAQCAtNjQ4
LDI1ICs2NDgsMjcgQEAgc3RhdGljIGxvbmcgYmxrZGV2X2ZhbGxvY2F0ZShzdHJ1Y3QgZmlsZSAq
ZmlsZSwgaW50IG1vZGUsIGxvZmZfdCBzdGFydCwKPiA+Cj4gPiAgICAgICBmaWxlbWFwX2ludmFs
aWRhdGVfbG9jayhpbm9kZS0+aV9tYXBwaW5nKTsKPiA+Cj4gPiAtICAgICAvKiBJbnZhbGlkYXRl
IHRoZSBwYWdlIGNhY2hlLCBpbmNsdWRpbmcgZGlydHkgcGFnZXMuICovCj4gPiAtICAgICBlcnJv
ciA9IHRydW5jYXRlX2JkZXZfcmFuZ2UoYmRldiwgZmlsZS0+Zl9tb2RlLCBzdGFydCwgZW5kKTsK
PiA+IC0gICAgIGlmIChlcnJvcikKPiA+IC0gICAgICAgICAgICAgZ290byBmYWlsOwo+ID4gLQo+
ID4gKyAgICAgLyoKPiA+ICsgICAgICAqIEludmFsaWRhdGUgdGhlIHBhZ2UgY2FjaGUsIGluY2x1
ZGluZyBkaXJ0eSBwYWdlcywgZm9yIHZhbGlkCj4gPiArICAgICAgKiBkZS1hbGxvY2F0ZSBtb2Rl
IGNhbGxzIHRvIGZhbGxvY2F0ZSgpLgo+ID4gKyAgICAgICovCj4gPiAgICAgICBzd2l0Y2ggKG1v
ZGUpIHsKPiA+ICAgICAgIGNhc2UgRkFMTE9DX0ZMX1pFUk9fUkFOR0U6Cj4gPiAgICAgICBjYXNl
IEZBTExPQ19GTF9aRVJPX1JBTkdFIHwgRkFMTE9DX0ZMX0tFRVBfU0laRToKPiA+IC0gICAgICAg
ICAgICAgZXJyb3IgPSBibGtkZXZfaXNzdWVfemVyb291dChiZGV2LCBzdGFydCA+PiBTRUNUT1Jf
U0hJRlQsCj4gPiArICAgICAgICAgICAgIGVycm9yID0gdHJ1bmNhdGVfYmRldl9yYW5nZShiZGV2
LCBmaWxlLT5mX21vZGUsIHN0YXJ0LCBlbmQpIHx8Cj4gPiArICAgICAgICAgICAgICAgICAgICAg
YmxrZGV2X2lzc3VlX3plcm9vdXQoYmRldiwgc3RhcnQgPj4gU0VDVE9SX1NISUZULAo+Cj4gSSdt
IHByZXR0eSBzdXJlIHdlJ3JlIHN1cHBvc2VkIHRvIHByZXNlcnZlIHRoZSBlcnJvciBjb2RlcyBy
ZXR1cm5lZCBieQo+IGJvdGggZnVuY3Rpb25zLgo+Cj4gICAgICAgICBlcnJvciA9IHRydW5jYXRl
X2JkZXZfcmFuZ2UoLi4uKTsKPiAgICAgICAgIGlmICghZXJyb3IpCj4gICAgICAgICAgICAgICAg
IGVycm9yID0gYmxrZGV2X2lzc3VlX3plcm9vdXQoLi4uKTsKPgo+IC0tRAo+Cj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGVuID4+IFNFQ1RPUl9TSElGVCwg
R0ZQX0tFUk5FTCwKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBCTEtERVZfWkVST19OT1VOTUFQKTsKPiA+ICAgICAgICAgICAgICAgYnJlYWs7Cj4gPiAgICAg
ICBjYXNlIEZBTExPQ19GTF9QVU5DSF9IT0xFIHwgRkFMTE9DX0ZMX0tFRVBfU0laRToKPiA+IC0g
ICAgICAgICAgICAgZXJyb3IgPSBibGtkZXZfaXNzdWVfemVyb291dChiZGV2LCBzdGFydCA+PiBT
RUNUT1JfU0hJRlQsCj4gPiArICAgICAgICAgICAgIGVycm9yID0gdHJ1bmNhdGVfYmRldl9yYW5n
ZShiZGV2LCBmaWxlLT5mX21vZGUsIHN0YXJ0LCBlbmQpIHx8Cj4gPiArICAgICAgICAgICAgICAg
ICAgICAgYmxrZGV2X2lzc3VlX3plcm9vdXQoYmRldiwgc3RhcnQgPj4gU0VDVE9SX1NISUZULAo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxlbiA+PiBTRUNU
T1JfU0hJRlQsIEdGUF9LRVJORUwsCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgQkxLREVWX1pFUk9fTk9GQUxMQkFDSyk7Cj4gPiAgICAgICAgICAgICAgIGJy
ZWFrOwo+ID4gICAgICAgY2FzZSBGQUxMT0NfRkxfUFVOQ0hfSE9MRSB8IEZBTExPQ19GTF9LRUVQ
X1NJWkUgfCBGQUxMT0NfRkxfTk9fSElERV9TVEFMRToKPiA+IC0gICAgICAgICAgICAgZXJyb3Ig
PSBibGtkZXZfaXNzdWVfZGlzY2FyZChiZGV2LCBzdGFydCA+PiBTRUNUT1JfU0hJRlQsCj4gPiAr
ICAgICAgICAgICAgIGVycm9yID0gdHJ1bmNhdGVfYmRldl9yYW5nZShiZGV2LCBmaWxlLT5mX21v
ZGUsIHN0YXJ0LCBlbmQpIHx8Cj4gPiArICAgICAgICAgICAgICAgICAgICAgYmxrZGV2X2lzc3Vl
X2Rpc2NhcmQoYmRldiwgc3RhcnQgPj4gU0VDVE9SX1NISUZULAo+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxlbiA+PiBTRUNUT1JfU0hJRlQsIEdGUF9LRVJO
RUwpOwo+ID4gICAgICAgICAgICAgICBicmVhazsKPiA+ICAgICAgIGRlZmF1bHQ6Cj4gPiAtLQo+
ID4gMi40MC4wLjYzNC5nNGNhM2VmMzIxMS1nb29nCj4gPgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

