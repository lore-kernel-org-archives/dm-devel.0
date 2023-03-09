Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D58C64EC4
	for <dm-devel@archiver.kernel.org>; Thu,  9 Mar 2023 11:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678360904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yk4cIj+hF8u01xggLrFZ/w4I7GOYDhOjjUwOXAqnUEw=;
	b=UkZhh37mZdsaDTl0RYOr7aAtt69DJezZMKohG3W/IEDHRaB3j8GcNELdxfEjNrgIq6C6F7
	/MHO1wIagEIka9uUut/ZDAGLRCgfKylVEA1NqtrwsKGPtTj2WmYdJydj2W7lCng6MlDf1d
	GyqME5DBrzU5OPnvqagttu/4fGvxdrk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-KlvfBw3uOkyhTVclmq2gCQ-1; Thu, 09 Mar 2023 06:21:41 -0500
X-MC-Unique: KlvfBw3uOkyhTVclmq2gCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 752FB857A87;
	Thu,  9 Mar 2023 11:21:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D953A140EBF4;
	Thu,  9 Mar 2023 11:21:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F9DD19465B5;
	Thu,  9 Mar 2023 11:21:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C4C6419465B3
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 11:21:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9447440DE; Thu,  9 Mar 2023 11:21:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B1230440DD
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 11:21:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9278B87B2A2
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 11:21:33 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-LywWJ3BfOuCufAeQPCACOQ-1; Thu, 09 Mar 2023 06:21:32 -0500
X-MC-Unique: LywWJ3BfOuCufAeQPCACOQ-1
Received: by mail-pl1-f180.google.com with SMTP id u5so1593297plq.7
 for <dm-devel@redhat.com>; Thu, 09 Mar 2023 03:21:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678360891;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=HaCiOLBaUQCB6rPGv3z9wu2mPDg4Zl36GLz0U5k8XAQ=;
 b=eSFanF24I/oKAu9vL3JfQH5bj+88gDI1CXP2jBMeQ3U7V22rwkbJRBfjZFsxYhMUET
 lMyQtFdEvxiHcXHnxX790+a8Ix4Ut+s6pFPg8zMx1sQaPkw+7JG6eGFibz+Jo3yhzJeJ
 2vb841RW5x07tll5ikxcp9Bb1ImBcsoGHCSItu2RLl8I1fBUOFgw2w5au/frScWo0DHl
 V+GRY8XN4jJxbvsh/FrFngfwUlLqttcQMg8A4J3gO8HNPdUDMOTQWclLz1YWayWNY8hR
 VyO79AVONFbikyY4WX/abXKhR4effzJzbqdsVE6tqAgzdRElyvR3v2f81dTIb4xS34mj
 oR4Q==
X-Gm-Message-State: AO0yUKXxlJH8O0Iji1seOKnCFuMOPQqooHt09lOf32b6WxFSpieC3Xe0
 A84EHTFu9b+e5bukMronVO8vUolC/NBO3skpxQXi2w==
X-Google-Smtp-Source: AK7set+CuIIqqJROsYxcY7Tk1FGy3KI4MAQNFEaxBD6fKKyxioLzKZ0vb809U2RO6bCc/jCNZK7EeIMf4RiDS1WCnzA=
X-Received: by 2002:a17:90a:8a82:b0:234:b4ad:d598 with SMTP id
 x2-20020a17090a8a8200b00234b4add598mr7996136pjn.7.1678360890807; Thu, 09 Mar
 2023 03:21:30 -0800 (PST)
MIME-Version: 1.0
References: <20230306134930.2878660-1-houtao@huaweicloud.com>
 <ZAY/o9ew9AtrCLE5@redhat.com>
 <e9b61952-98a8-6e3b-2d85-6aaf07208a7b@huaweicloud.com>
 <ZAdOgUdqwLpUyPlc@redhat.com>
 <6c2d07bf-828e-3aeb-3c02-6cdfd6e36ff3@huaweicloud.com>
 <CALrw=nFrbWF2ZhQtK9gx5ZFHK4Cd9outwEQqByJgmb7ryOoCgA@mail.gmail.com>
 <ZAjfu0R7rv45J3Dr@redhat.com>
In-Reply-To: <ZAjfu0R7rv45J3Dr@redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 9 Mar 2023 11:21:19 +0000
Message-ID: <CALrw=nG5Q_5i6eMbyt0_ZemT+EGgYpSDAg5-tUPC+SmxrPkNUQ@mail.gmail.com>
To: Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] dm crypt: initialize tasklet in crypt_io_init()
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
Cc: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org,
 dm-devel@redhat.com, mpatocka@redhat.com, houtao1@huawei.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgOCwgMjAyMyBhdCA3OjE54oCvUE0gTWlrZSBTbml0emVyIDxzbml0emVyQGtl
cm5lbC5vcmc+IHdyb3RlOgo+Cj4gT24gV2VkLCBNYXIgMDggMjAyMyBhdCAgODo1NVAgLTA1MDAs
Cj4gSWduYXQgS29yY2hhZ2luIDxpZ25hdEBjbG91ZGZsYXJlLmNvbT4gd3JvdGU6Cj4KPiA+IE9u
IFdlZCwgTWFyIDgsIDIwMjMgYXQgMjo1NuKAr0FNIEhvdSBUYW8gPGhvdXRhb0BodWF3ZWljbG91
ZC5jb20+IHdyb3RlOgo+ID4gPgo+ID4gPiBIaSwKPiA+ID4KPiA+ID4gT24gMy83LzIwMjMgMTA6
NDcgUE0sIE1pa2UgU25pdHplciB3cm90ZToKPiA+ID4gPiBPbiBNb24sIE1hciAwNiAyMDIzIGF0
ICA5OjEyUCAtMDUwMCwKPiA+ID4gPiBIb3UgVGFvIDxob3V0YW9AaHVhd2VpY2xvdWQuY29tPiB3
cm90ZToKPiA+ID4gPgo+ID4gPiA+PiBIaSwKPiA+ID4gPj4KPiA+ID4gPj4gT24gMy83LzIwMjMg
MzozMSBBTSwgTWlrZSBTbml0emVyIHdyb3RlOgo+ID4gPiA+Pj4gT24gTW9uLCBNYXIgMDYgMjAy
MyBhdCAgODo0OVAgLTA1MDAsCj4gPiA+ID4+PiBIb3UgVGFvIDxob3V0YW9AaHVhd2VpY2xvdWQu
Y29tPiB3cm90ZToKPiA+ID4gPj4+Cj4gPiA+ID4+Pj4gRnJvbTogSG91IFRhbyA8aG91dGFvMUBo
dWF3ZWkuY29tPgo+ID4gPiA+Pj4+Cj4gPiA+ID4+Pj4gV2hlbiBuZWl0aGVyIG5vX3JlYWRfd29y
a3F1ZXVlIG5vciBub193cml0ZV93b3JrcXVldWUgYXJlIGVuYWJsZWQsCj4gPiA+ID4+Pj4gdGFz
a2xldF90cnlsb2NrKCkgaW4gY3J5cHRfZGVjX3BlbmRpbmcoKSBtYXkgc3RpbGwgcmV0dXJuIGZh
bHNlIGR1ZSB0bwo+ID4gPiA+Pj4+IGFuIHVuaW5pdGlhbGl6ZWQgc3RhdGUsIGFuZCBkbS1jcnlw
dCB3aWxsIGRvIGlvIGNvbXBsZXRpb24gaW4gaW9fcXVldWUKPiA+ID4gPj4+PiBpbnN0ZWFkIG9m
IGN1cnJlbnQgY29udGV4dCB1bm5lY2Vzc2FyaWx5Lgo+ID4gPiA+Pj4gSGF2ZSB5b3UgYWN0dWFs
bHkgZXhwZXJpZW5jZWQgdGhpcz8KPiA+ID4gPj4gWWVzLiBJIGhhZCB3cml0dGVuIGEgYnBmdHJh
Y2Ugc2NyaXB0IHRvIGNoZWNrIHRoZSBjb21wbGV0aW9uIGNvbnRleHQgb2YKPiA+ID4gPj4gYmxr
ZGV2X2Jpb19lbmRfaW9fc2ltcGxlKCkgd2hlbiBkb2luZyBkaXJlY3QgaW8gcmVhZCBvbiBkbS1j
cnlwdCBkZXZpY2UuIFRoZQo+ID4gPiA+PiBleHBlY3RlZCBjb250ZXh0IHNob3VsZCBiZSB1bmJv
dW5kIHdvcmtlcnMgb2YgY3J5cHRfcXVldWUsIGJ1dCBzb21ldGltZXMgdGhlCj4gPiA+ID4+IGNv
bnRleHQgaXMgdGhlIGJvdW5kIHdvcmtlciBvZiBpb19xdWV1ZS4KPiA+ID4gPiBPSywgdGhhbmtz
IGZvciBjbGFyaWZ5aW5nLiAgQ3VyaW91cyB0byBrbm93IHRoZSBjaXJjdW1zdGFuY2UgKEkKPiA+
ID4gPiB0aG91Z2h0IHBlci1iaW8tZGF0YSBpcyB6ZXJvJ2QgLS0gYnV0IGl0IG1heSBiZSBJJ20g
bWlzdGFrZW4pLgo+ID4gPiBUaGUgY2lyY3Vtc3RhbmNlIGlzIGp1c3QgYSBub3JtYWwgcWVtdSBW
TSBydW5uaW5nIHRoZSB2YW5pbGxhIGtlcm5lbCBmb3IgdGVzdAo+ID4gPiBwdXJwb3NlLiBBY2Nv
cmRpbmcgdG8gdGhlIGltcGxlbWVudGF0aW9uIG9mIGJpb19hbGxvY19iaW9zZXQoKSwgdGhlIGZy
b250IHBhZCBvZgo+ID4gPiBiaW8gaXMgbm90IGluaXRpYWxpemVkIGFuZCBvbmx5IGJpbyBpdHNl
bGYgaXMgaW5pdGlhbGl6ZWQuIEFGQUlLIGlmCj4gPiA+IENPTkZJR19JTklUX09OX0FMTE9DX0RF
RkFVTFRfT04gaXMgZW5hYmxlZCwgcGVyLWJpby1kYXRhIG1heSBiZSB6ZXJvZWQuCj4KPiBPSy4K
Pgo+ID4gPiA+IEZyb206IE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwub3JnPgo+ID4gPiA+
IERhdGU6IE1vbiwgNiBNYXIgMjAyMyAxNTo1ODozMyAtMDUwMAo+ID4gPiA+IFN1YmplY3Q6IFtQ
QVRDSF0gZG0gY3J5cHQ6IGNvbmRpdGlvbmFsbHkgZW5hYmxlIGNvZGUgbmVlZGVkIGZvciB0YXNr
bGV0IHVzZWNhc2VzCj4gPiA+ID4KPiA+ID4gPiBVc2UganVtcF9sYWJlbCB0byBsaW1pdCB0aGUg
bmVlZCBmb3IgYnJhbmNoaW5nLCBhbmQgdGFza2xldF9pbml0KCksCj4gPiA+ID4gdW5sZXNzIGVp
dGhlciBvZiB0aGUgb3B0aW9uYWwgIm5vX3JlYWRfd29ya3F1ZXVlIiBhbmQvb3IKPiA+ID4gPiAi
bm9fd3JpdGVfd29ya3F1ZXVlIiBmZWF0dXJlcyBhcmUgdXNlZC4KPiA+ID4gPgo+ID4gPiA+IFNp
Z25lZC1vZmYtYnk6IE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwub3JnPgo+ID4gPiA+IC0t
LQo+ID4gPiA+ICBkcml2ZXJzL21kL2RtLWNyeXB0LmMgfCAzNSArKysrKysrKysrKysrKysrKysr
KysrKysrKystLS0tLS0tLQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygr
KSwgOCBkZWxldGlvbnMoLSkKPiA+ID4gPgo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2RtLWNyeXB0LmMgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPiA+ID4gPiBpbmRleCA2NDE0NTdl
NzI2MDMuLjJkMDMwOWNhMDdmNSAxMDA2NDQKPiA+ID4gPiAtLS0gYS9kcml2ZXJzL21kL2RtLWNy
eXB0LmMKPiA+ID4gPiArKysgYi9kcml2ZXJzL21kL2RtLWNyeXB0LmMKPiA+ID4gPiBAQCAtNDAs
NiArNDAsNyBAQAo+ID4gPiA+ICAjaW5jbHVkZSA8a2V5cy91c2VyLXR5cGUuaD4KPiA+ID4gPiAg
I2luY2x1ZGUgPGtleXMvZW5jcnlwdGVkLXR5cGUuaD4KPiA+ID4gPiAgI2luY2x1ZGUgPGtleXMv
dHJ1c3RlZC10eXBlLmg+Cj4gPiA+ID4gKyNpbmNsdWRlIDxsaW51eC9qdW1wX2xhYmVsLmg+Cj4g
PiA+ID4KPiA+ID4gPiAgI2luY2x1ZGUgPGxpbnV4L2RldmljZS1tYXBwZXIuaD4KPiA+ID4gPgo+
ID4gPiA+IEBAIC04NSw2ICs4Niw4IEBAIHN0cnVjdCBkbV9jcnlwdF9pbyB7Cj4gPiA+ID4gICAg
ICAgc3RydWN0IHJiX25vZGUgcmJfbm9kZTsKPiA+ID4gPiAgfSBDUllQVE9fTUlOQUxJR05fQVRU
UjsKPiA+ID4gPgo+ID4gPiA+ICtzdGF0aWMgREVGSU5FX1NUQVRJQ19LRVlfRkFMU0UodXNlX3Rh
c2tsZXRfZW5hYmxlZCk7Cj4gPiA+ID4gKwo+ID4gPiA+ICBzdHJ1Y3QgZG1fY3J5cHRfcmVxdWVz
dCB7Cj4gPiA+ID4gICAgICAgc3RydWN0IGNvbnZlcnRfY29udGV4dCAqY3R4Owo+ID4gPiA+ICAg
ICAgIHN0cnVjdCBzY2F0dGVybGlzdCBzZ19pbls0XTsKPiA+ID4gPiBAQCAtMTczMCwxMiArMTcz
MywxNSBAQCBzdGF0aWMgdm9pZCBjcnlwdF9pb19pbml0KHN0cnVjdCBkbV9jcnlwdF9pbyAqaW8s
IHN0cnVjdCBjcnlwdF9jb25maWcgKmNjLAo+ID4gPiA+ICAgICAgIGlvLT5zZWN0b3IgPSBzZWN0
b3I7Cj4gPiA+ID4gICAgICAgaW8tPmVycm9yID0gMDsKPiA+ID4gPiAgICAgICBpby0+Y3R4LnIu
cmVxID0gTlVMTDsKPiA+ID4gPiAtICAgICAvKgo+ID4gPiA+IC0gICAgICAqIHRhc2tsZXRfaW5p
dCgpIGhlcmUgdG8gZW5zdXJlIGNyeXB0X2RlY19wZW5kaW5nKCkncwo+ID4gPiA+IC0gICAgICAq
IHRhc2tsZXRfdHJ5bG9jaygpIGRvZXNuJ3QgaW5jb3JyZWN0bHkgcmV0dXJuIGZhbHNlCj4gPiA+
ID4gLSAgICAgICogZXZlbiB3aGVuIHRhc2tsZXQgaXNuJ3QgaW4gdXNlLgo+ID4gPiA+IC0gICAg
ICAqLwo+ID4gPiA+IC0gICAgIHRhc2tsZXRfaW5pdCgmaW8tPnRhc2tsZXQsIGtjcnlwdGRfY3J5
cHRfdGFza2xldCwgKHVuc2lnbmVkIGxvbmcpJmlvLT53b3JrKTsKPiA+ID4gPiArICAgICBpZiAo
c3RhdGljX2JyYW5jaF91bmxpa2VseSgmdXNlX3Rhc2tsZXRfZW5hYmxlZCkpIHsKPiA+ID4gPiAr
ICAgICAgICAgICAgIC8qCj4gPiA+ID4gKyAgICAgICAgICAgICAgKiB0YXNrbGV0X2luaXQoKSBo
ZXJlIHRvIGVuc3VyZSBjcnlwdF9kZWNfcGVuZGluZygpJ3MKPiA+ID4gPiArICAgICAgICAgICAg
ICAqIHRhc2tsZXRfdHJ5bG9jaygpIGRvZXNuJ3QgaW5jb3JyZWN0bHkgcmV0dXJuIGZhbHNlCj4g
PiA+ID4gKyAgICAgICAgICAgICAgKiBldmVuIHdoZW4gdGFza2xldCBpc24ndCBpbiB1c2UuCj4g
PiA+ID4gKyAgICAgICAgICAgICAgKi8KPiA+ID4gPiArICAgICAgICAgICAgIHRhc2tsZXRfaW5p
dCgmaW8tPnRhc2tsZXQsIGtjcnlwdGRfY3J5cHRfdGFza2xldCwKPiA+ID4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAodW5zaWduZWQgbG9uZykmaW8tPndvcmspOwo+ID4gPiA+ICsgICAg
IH0KPiA+ID4gPiAgICAgICBpby0+aW50ZWdyaXR5X21ldGFkYXRhID0gTlVMTDsKPiA+ID4gPiAg
ICAgICBpby0+aW50ZWdyaXR5X21ldGFkYXRhX2Zyb21fcG9vbCA9IGZhbHNlOwo+ID4gPiA+ICAg
ICAgIGF0b21pY19zZXQoJmlvLT5pb19wZW5kaW5nLCAwKTsKPiA+ID4gPiBAQCAtMTc3NSw2ICsx
NzgxLDEwIEBAIHN0YXRpYyB2b2lkIGNyeXB0X2RlY19wZW5kaW5nKHN0cnVjdCBkbV9jcnlwdF9p
byAqaW8pCj4gPiA+ID4gICAgICAgICAgICAgICBrZnJlZShpby0+aW50ZWdyaXR5X21ldGFkYXRh
KTsKPiA+ID4gPgo+ID4gPiA+ICAgICAgIGJhc2VfYmlvLT5iaV9zdGF0dXMgPSBlcnJvcjsKPiA+
ID4gPiArICAgICBpZiAoIXN0YXRpY19icmFuY2hfdW5saWtlbHkoJnVzZV90YXNrbGV0X2VuYWJs
ZWQpKSB7Cj4gPiA+ID4gKyAgICAgICAgICAgICBiaW9fZW5kaW8oYmFzZV9iaW8pOwo+ID4gPiA+
ICsgICAgICAgICAgICAgcmV0dXJuOwo+ID4gPiA+ICsgICAgIH0KPiA+ID4gQmVjYXVzZSB1c2Vf
dGFza2xldF9lbmFibGVkIGNhbiBiZSBlbmFibGVkIGNvbmN1cnJlbnRseSwgc28gSSB0aGluayBp
dCBpcyBzdGlsbAo+ID4gPiBwb3NzaWJsZSB0aGF0IGNyeXB0X2RlY19wZW5kaW5nIHdpbGwgdHJ5
LWxvY2sgYW4gdW5pdGlhbGl6ZWQgdGFza2xldCBpZgo+ID4gPiB1c2VfdGFza2xldF9lbmFibGVk
IGlzIGVuYWJsZWQgd2hlbiBpbnZva2luZyBjcnlwdF9kZWNfcGVuZGluZygpLgo+Cj4gR29vZCBw
b2ludCwgd2hpbGUgSSB0aGluayBpdCBpcyBwcm9iYWJseSBhY2NlcHRhYmxlIGdpdmVuIHRoZSB3
b3JzdAo+IGNhc2UgaXMgcHVudGluZyB0aGUgYmlvX2VuZGlvIHRvIGEgd29ya3F1ZXVlIGZvciBh
IHRpbWUgLi4uCj4KPiA+IFBlcmhhcHMgaW5zdGVhZCB3ZSBjYW4ganVzdCBwYXNzIGFuIGFkZGl0
aW9uYWwgZmxhZyBmcm9tCj4gPiB0YXNrbGV0X3NjaGVkdWxlIHRvIGluZGljYXRlIHRvIHRoZSBm
dW5jdGlvbiB0aGF0IHdlJ3JlIHJ1bm5pbmcgaW4gYQo+ID4gdGFza2xldC4gSSBvcmlnaW5hbGx5
IGhhdmUgY2hvc2VuIHRoZSB0YXNrbGV0X3RyeWxvY2svdW5sb2NrIGhhY2sgdG8KPiA+IGF2b2lk
IHBhc3NpbmcgYW4gZXh0cmEgZmxhZy4gQnV0IHVuaXRpYWxpemVkIG1lbW9yeSBtYWtlcyBzZW5z
ZSBhcwo+ID4gd2VsbCBhcyB0aGUgZGVzaXJlIHRvIGF2b2lkIGNhbGxpbmcgdGFza2xldF9pbml0
IHVuY29uZGl0aW9uYWxseS4gU28KPiA+IGFuIGV4dHJhIG1lbWJlciBpbiBkbV9jcnlwdF9pbyBt
aWdodCBiZSB0aGUgbW9zdCBzdHJhaWdodGZvcndhcmQgaGVyZS4KPgo+IC4uLiBJIHRoaW5rIHdl
IHNob3VsZCBjZXJ0YWlubHkgZXZhbHVhdGUgdGhlIHVzZSBvZiBhbiBleHRyYSBmbGFnLgo+Cj4g
SWduYXQ6IEknbGwgaGF2ZSBhIGxvb2sgYXQgaW1wbGVtZW50aW5nIGl0IGJ1dCBpZiB5b3UgaGF2
ZSBhIHBhdGNoCj4gYWxyZWFkeSBkZXZlbG9wZWQgcGxlYXNlIGRvIHNoYXJlLgoKSSBkb24ndCBo
YXZlIGJ1dCBpdCBzZWVtcyB5b3VyIGxhdGVzdCBwYXRjaCBpcyBleGFjdGx5IHdoYXQgSSBoYWQg
aW4gbWluZC4KCj4gVGhhbmtzLAo+IE1pa2UKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1k
ZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWwK

