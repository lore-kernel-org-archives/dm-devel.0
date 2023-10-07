Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 927F2E94139
	for <dm-devel@archiver.kernel.org>; Sat,  7 Oct 2023 02:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696646489;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0R+uYfOAHxLh6XJUT3QaJ60MQdTj6tv1k5jfPFNlbf8=;
	b=TTq7pOGc/brnubr+GsIGHUdHpU7/8tq16qdzBJmj8OTJRJEDsvuwTYiaFXkALovj4H5hwg
	EBagy/IdxFYVrqw248zWLqdkcohy6XP17g7LlB+SGTFhJAKP7ILu39snskT+Xwvr+7UnNc
	lMAMgaBAHW+OExRYl1fplBl3R6OuKZU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-DVgUJF5yOhGWfbXBEvEptA-1; Fri, 06 Oct 2023 22:41:26 -0400
X-MC-Unique: DVgUJF5yOhGWfbXBEvEptA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B66858039CB;
	Sat,  7 Oct 2023 02:41:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5FA3C215670B;
	Sat,  7 Oct 2023 02:41:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 248C91946588;
	Sat,  7 Oct 2023 02:41:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7ECBC1946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  7 Oct 2023 02:41:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F8BFC154CB; Sat,  7 Oct 2023 02:41:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3799FC15BB8
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 02:41:22 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 191F8802C1A
 for <dm-devel@redhat.com>; Sat,  7 Oct 2023 02:41:22 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-275-MV851b7BOIyCglD5nmnWVQ-1; Fri,
 06 Oct 2023 22:41:11 -0400
X-MC-Unique: MV851b7BOIyCglD5nmnWVQ-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by sin.source.kernel.org (Postfix) with ESMTP id 5F211CE2571;
 Sat,  7 Oct 2023 02:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D61C433C8;
 Sat,  7 Oct 2023 02:41:06 +0000 (UTC)
Received: by mail-lf1-f48.google.com with SMTP id
 2adb3069b0e04-5056ca2b6d1so3360487e87.1; 
 Fri, 06 Oct 2023 19:41:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YznslaYcDe2lkjxJVCAU3RozMxQ0y2VEzOmXxCmTGNZN3Kev0I2
 3YZl/tddnviOmmlk8N6K2UqisW0JASyUHYWV3fw=
X-Google-Smtp-Source: AGHT+IFZKXFMDdbJlrwzbWL763LgpyNh7kR9JWexcBVJPWIm2fnTDvq0yf/QIAKmPc6vXoFQVrJuE1yWYhbC0z4c0N4=
X-Received: by 2002:a05:6512:3995:b0:4f8:586a:d6ca with SMTP id
 j21-20020a056512399500b004f8586ad6camr4814291lfu.9.1696646464789; Fri, 06 Oct
 2023 19:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <CAPhsuW5cUgqy9fqj+Z4nGPQrAok-eQ=NipNxb0TL_kuCFaPMcw@mail.gmail.com>
 <f59cbb99-33dd-c427-2e43-5a07ab9fbf51@huaweicloud.com>
 <CAPhsuW7TRODsR_N95AmXJCZvpTuSKgbOjnYGxMGAWtmt3x9Vkw@mail.gmail.com>
 <eb4ea24d-f7b4-899b-9259-2d48dc83e48f@huaweicloud.com>
In-Reply-To: <eb4ea24d-f7b4-899b-9259-2d48dc83e48f@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Fri, 6 Oct 2023 19:40:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW72zSALeSk96QAdq4cHf=y_n13MOBmxH-dTUKjkbc_jig@mail.gmail.com>
Message-ID: <CAPhsuW72zSALeSk96QAdq4cHf=y_n13MOBmxH-dTUKjkbc_jig@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH -next v3 00/25] md: synchronize io with array
 reconfiguration
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBPY3QgNiwgMjAyMyBhdCA3OjMy4oCvUE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWlj
bG91ZC5jb20+IHdyb3RlOgo+Cj4gSGksCj4KPiDlnKggMjAyMy8xMC8wNSAxMTo1NSwgU29uZyBM
aXUg5YaZ6YGTOgo+ID4gT24gV2VkLCBPY3QgNCwgMjAyMyBhdCA4OjQy4oCvUE0gWXUgS3VhaSA8
eXVrdWFpMUBodWF3ZWljbG91ZC5jb20+IHdyb3RlOgo+ID4+Cj4gPj4gSGksCj4gPj4KPiA+PiDl
nKggMjAyMy8wOS8yOSAzOjE1LCBTb25nIExpdSDlhpnpgZM6Cj4gPj4+IEhpIEt1YWksCj4gPj4+
Cj4gPj4+IFRoYW5rcyBmb3IgdGhlIHBhdGNoc2V0IQo+ID4+Pgo+ID4+PiBBIGZldyBoaWdoIGxl
dmVsIHF1ZXN0aW9ucy9zdWdnZXN0aW9uczoKPiA+Pgo+ID4+IFRoYW5rcyBhIGxvdCBmb3IgdGhl
c2UhCj4gPj4+Cj4gPj4+IDEuIFRoaXMgaXMgYSBiaWcgY2hhbmdlIHRoYXQgbmVlZHMgYSBsb3Qg
b2YgZXhwbGFuYXRpb24uIFdoaWxlIHlvdSBtYW5hZ2VkIHRvCj4gPj4+IGtlZXAgZWFjaCBwYXRj
aCByZWxhdGl2ZWx5IHNtYWxsIChncmVhdCBqb2IgYnR3KSwgaXQgaXMgbm90IHZlcnkgY2xlYXIg
d2h5IHdlCj4gPj4+IG5lZWQgdGhlc2UgY2hhbmdlcy4gU3BlY2lmaWNhbGx5LCB3ZSBhcmUgYWRk
aW5nIGEgbmV3IG11dGV4LCBpdCBpcyB3b3J0aAo+ID4+PiBtZW50aW9uaW5nIHdoeSB3ZSBjYW5u
b3QgYWNoaWV2ZSB0aGUgc2FtZSBnb2FsIHdpdGhvdXQgaXQuIFBsZWFzZSBhZGQKPiA+Pj4gbW9y
ZSBpbmZvcm1hdGlvbiBpbiB0aGUgY292ZXIgbGV0dGVyLiBXZSB3aWxsIHB1dCBwYXJ0IG9mIHRo
ZSBjb3ZlciBsZXR0ZXIgaW4KPiA+Pj4gdGhlIG1lcmdlIGNvbW1pdC4KPiA+Pgo+ID4+IFllYWgs
IEkgcmVhbGl6ZSB0aGF0IEkgZXhwbGFpbiB0b28gbGl0dGxlLiBJIHdpbGwgYWRkIGJhY2tncm91
bmQgYW5kCj4gPj4gZGVzaWduLgo+ID4+Pgo+IENhbiB5b3UgdGFrZSBhIGxvb2sgYWJvdXQgdGhp
cyBuZXcgY292ZXIgbGV0dGVyPwoKSSBkb24ndCBoYXZlIHRpbWUgcmlnaHQgbm93IHRvIGxvb2sg
aW50byBhbGwgdGhlIGRldGFpbHMsIGJ1dCBpdCBsb29rcwpncmVhdCBhdCBmaXJzdCBnbGFuY2Uu
IFdlIGNhbiBzdGlsbCBlZGl0IGl0IGEgbGl0dGxlIGJpdCB3aGVuIGFwcGx5aW5nIHRoZQpwYXRj
aHNldCwgYnV0IHRoYXQgbWF5IG5vdCBiZSBuZWNlc3NhcnkuCgpUaGFua3MsClNvbmcKCj4KPiAj
IyMjIyBCYWNrZ3JvdWQKPgo+IE91ciB0ZXN0ZXJzIHN0YXJ0ZWQgdG8gdGVzdCByYWlkMTAgbGFz
dCB5ZWFyLCBhbmQgd2UgZm91bmQgdGhhdCB0aGVyZQo+IGFyZSBsb3RzIG9mIHByb2JsZW0gaW4g
dGhlIGZvbGxvd2luZyB0ZXN0IHNjZW5hcmlvOgo+Cj4gLSBhZGQgb3IgcmVtb3ZlIGRpc2tzIHRv
IHRoZSBhcnJheQo+IC0gaXNzdWUgaW8gdG8gdGhlIGFycmF5CgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

