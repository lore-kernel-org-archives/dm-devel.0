Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBED1C64EC4
	for <dm-devel@archiver.kernel.org>; Wed,  8 Mar 2023 19:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678303175;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=92dm1fKhP5P1L2yQDzi+meQDM9SM0BYzq747p1Mbbfo=;
	b=Dj+bTcbk1UR/OGJtmCAQvB9un6Wy0XsCi/oZM1oRVAsxvvbSH2BwQnDsCokBFkTVwBRFGE
	lal6I9nUYgt6577L7stNNMy4l0i4227Wig9lwIZHL8Zx8FUUtUxqbrHpx+TyI9KwTtCIAO
	V1Rv36A7gzCoYGvKyaN1t+c0Ticxkyg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-1g5te3rcMyqTQ6vTDwoLZg-1; Wed, 08 Mar 2023 14:19:32 -0500
X-MC-Unique: 1g5te3rcMyqTQ6vTDwoLZg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7221F1C12980;
	Wed,  8 Mar 2023 19:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 18F30492B04;
	Wed,  8 Mar 2023 19:19:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D783519465BD;
	Wed,  8 Mar 2023 19:19:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3642119465B5
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Mar 2023 19:19:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23169492B07; Wed,  8 Mar 2023 19:19:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BE84492B04
 for <dm-devel@redhat.com>; Wed,  8 Mar 2023 19:19:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCDD5811E9C
 for <dm-devel@redhat.com>; Wed,  8 Mar 2023 19:19:26 +0000 (UTC)
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com
 [209.85.160.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-RvlM_ETTMN-4jGq7D03qVQ-1; Wed, 08 Mar 2023 14:19:25 -0500
X-MC-Unique: RvlM_ETTMN-4jGq7D03qVQ-1
Received: by mail-qt1-f177.google.com with SMTP id r16so17658899qtx.9
 for <dm-devel@redhat.com>; Wed, 08 Mar 2023 11:19:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678303164;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=WkHirdjLx4oluQvgjjTo950cjCWQijRI8BJMtzeHk6M=;
 b=thp1A4GA1oTigrClk0JYXJqepwXOxmdn1RYmJqv6TsPINxjqw2BGQHpIPO8w98qgWr
 ZYjDto+SFHn9wUGtuHzBR1S8oHOlnccIzW5d+G+wOZJ6K8ADtRQ2KTixXYTKKdw85fZM
 55v8l75+GcOCeQnohLuxVNojK6hzP0wh+ZpsNPzQ+qVhNfk93yEwT1h72NXkhmTgUyCo
 f31Sk6NvFu0nXqFuHSPs2e8oYmD5xE6sgztMQ2OnBIEsJURlo+lzf3GX/zhJFiKTWTde
 sXsshpRocxFXV/kasU5eWQVF12YAuKVA+cyJCqjUFH1K4AouXxlr6IUInhfjQJXQltNK
 6qtQ==
X-Gm-Message-State: AO0yUKX9bw1QD7E3NDu4aHwpOlVsNoIa3ZAnpCEbXKJV1YbWaCF23Ik6
 Ofsk1j/4cZaXL3S3ZCbH0f2lXic=
X-Google-Smtp-Source: AK7set+gG0nocmMQ2Y25zUYYmfpN1pSJ3V/BZ+zhTG35XVfGet8HQOg/+TrAvZgfYlA4oFTiFmFb8Q==
X-Received: by 2002:a05:622a:1443:b0:3bf:c178:c6ea with SMTP id
 v3-20020a05622a144300b003bfc178c6eamr30040837qtx.56.1678303164749; 
 Wed, 08 Mar 2023 11:19:24 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b3-20020ac85bc3000000b003bfb820f17csm12392277qtb.63.2023.03.08.11.19.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Mar 2023 11:19:24 -0800 (PST)
Date: Wed, 8 Mar 2023 14:19:23 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Ignat Korchagin <ignat@cloudflare.com>,
	Hou Tao <houtao@huaweicloud.com>
Message-ID: <ZAjfu0R7rv45J3Dr@redhat.com>
References: <20230306134930.2878660-1-houtao@huaweicloud.com>
 <ZAY/o9ew9AtrCLE5@redhat.com>
 <e9b61952-98a8-6e3b-2d85-6aaf07208a7b@huaweicloud.com>
 <ZAdOgUdqwLpUyPlc@redhat.com>
 <6c2d07bf-828e-3aeb-3c02-6cdfd6e36ff3@huaweicloud.com>
 <CALrw=nFrbWF2ZhQtK9gx5ZFHK4Cd9outwEQqByJgmb7ryOoCgA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALrw=nFrbWF2ZhQtK9gx5ZFHK4Cd9outwEQqByJgmb7ryOoCgA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, houtao1@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgMDggMjAyMyBhdCAgODo1NVAgLTA1MDAsCklnbmF0IEtvcmNoYWdpbiA8aWdu
YXRAY2xvdWRmbGFyZS5jb20+IHdyb3RlOgoKPiBPbiBXZWQsIE1hciA4LCAyMDIzIGF0IDI6NTbi
gK9BTSBIb3UgVGFvIDxob3V0YW9AaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPiA+Cj4gPiBIaSwK
PiA+Cj4gPiBPbiAzLzcvMjAyMyAxMDo0NyBQTSwgTWlrZSBTbml0emVyIHdyb3RlOgo+ID4gPiBP
biBNb24sIE1hciAwNiAyMDIzIGF0ICA5OjEyUCAtMDUwMCwKPiA+ID4gSG91IFRhbyA8aG91dGFv
QGh1YXdlaWNsb3VkLmNvbT4gd3JvdGU6Cj4gPiA+Cj4gPiA+PiBIaSwKPiA+ID4+Cj4gPiA+PiBP
biAzLzcvMjAyMyAzOjMxIEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6Cj4gPiA+Pj4gT24gTW9uLCBN
YXIgMDYgMjAyMyBhdCAgODo0OVAgLTA1MDAsCj4gPiA+Pj4gSG91IFRhbyA8aG91dGFvQGh1YXdl
aWNsb3VkLmNvbT4gd3JvdGU6Cj4gPiA+Pj4KPiA+ID4+Pj4gRnJvbTogSG91IFRhbyA8aG91dGFv
MUBodWF3ZWkuY29tPgo+ID4gPj4+Pgo+ID4gPj4+PiBXaGVuIG5laXRoZXIgbm9fcmVhZF93b3Jr
cXVldWUgbm9yIG5vX3dyaXRlX3dvcmtxdWV1ZSBhcmUgZW5hYmxlZCwKPiA+ID4+Pj4gdGFza2xl
dF90cnlsb2NrKCkgaW4gY3J5cHRfZGVjX3BlbmRpbmcoKSBtYXkgc3RpbGwgcmV0dXJuIGZhbHNl
IGR1ZSB0bwo+ID4gPj4+PiBhbiB1bmluaXRpYWxpemVkIHN0YXRlLCBhbmQgZG0tY3J5cHQgd2ls
bCBkbyBpbyBjb21wbGV0aW9uIGluIGlvX3F1ZXVlCj4gPiA+Pj4+IGluc3RlYWQgb2YgY3VycmVu
dCBjb250ZXh0IHVubmVjZXNzYXJpbHkuCj4gPiA+Pj4gSGF2ZSB5b3UgYWN0dWFsbHkgZXhwZXJp
ZW5jZWQgdGhpcz8KPiA+ID4+IFllcy4gSSBoYWQgd3JpdHRlbiBhIGJwZnRyYWNlIHNjcmlwdCB0
byBjaGVjayB0aGUgY29tcGxldGlvbiBjb250ZXh0IG9mCj4gPiA+PiBibGtkZXZfYmlvX2VuZF9p
b19zaW1wbGUoKSB3aGVuIGRvaW5nIGRpcmVjdCBpbyByZWFkIG9uIGRtLWNyeXB0IGRldmljZS4g
VGhlCj4gPiA+PiBleHBlY3RlZCBjb250ZXh0IHNob3VsZCBiZSB1bmJvdW5kIHdvcmtlcnMgb2Yg
Y3J5cHRfcXVldWUsIGJ1dCBzb21ldGltZXMgdGhlCj4gPiA+PiBjb250ZXh0IGlzIHRoZSBib3Vu
ZCB3b3JrZXIgb2YgaW9fcXVldWUuCj4gPiA+IE9LLCB0aGFua3MgZm9yIGNsYXJpZnlpbmcuICBD
dXJpb3VzIHRvIGtub3cgdGhlIGNpcmN1bXN0YW5jZSAoSQo+ID4gPiB0aG91Z2h0IHBlci1iaW8t
ZGF0YSBpcyB6ZXJvJ2QgLS0gYnV0IGl0IG1heSBiZSBJJ20gbWlzdGFrZW4pLgo+ID4gVGhlIGNp
cmN1bXN0YW5jZSBpcyBqdXN0IGEgbm9ybWFsIHFlbXUgVk0gcnVubmluZyB0aGUgdmFuaWxsYSBr
ZXJuZWwgZm9yIHRlc3QKPiA+IHB1cnBvc2UuIEFjY29yZGluZyB0byB0aGUgaW1wbGVtZW50YXRp
b24gb2YgYmlvX2FsbG9jX2Jpb3NldCgpLCB0aGUgZnJvbnQgcGFkIG9mCj4gPiBiaW8gaXMgbm90
IGluaXRpYWxpemVkIGFuZCBvbmx5IGJpbyBpdHNlbGYgaXMgaW5pdGlhbGl6ZWQuIEFGQUlLIGlm
Cj4gPiBDT05GSUdfSU5JVF9PTl9BTExPQ19ERUZBVUxUX09OIGlzIGVuYWJsZWQsIHBlci1iaW8t
ZGF0YSBtYXkgYmUgemVyb2VkLgoKT0suCgo+ID4gPiBGcm9tOiBNaWtlIFNuaXR6ZXIgPHNuaXR6
ZXJAa2VybmVsLm9yZz4KPiA+ID4gRGF0ZTogTW9uLCA2IE1hciAyMDIzIDE1OjU4OjMzIC0wNTAw
Cj4gPiA+IFN1YmplY3Q6IFtQQVRDSF0gZG0gY3J5cHQ6IGNvbmRpdGlvbmFsbHkgZW5hYmxlIGNv
ZGUgbmVlZGVkIGZvciB0YXNrbGV0IHVzZWNhc2VzCj4gPiA+Cj4gPiA+IFVzZSBqdW1wX2xhYmVs
IHRvIGxpbWl0IHRoZSBuZWVkIGZvciBicmFuY2hpbmcsIGFuZCB0YXNrbGV0X2luaXQoKSwKPiA+
ID4gdW5sZXNzIGVpdGhlciBvZiB0aGUgb3B0aW9uYWwgIm5vX3JlYWRfd29ya3F1ZXVlIiBhbmQv
b3IKPiA+ID4gIm5vX3dyaXRlX3dvcmtxdWV1ZSIgZmVhdHVyZXMgYXJlIHVzZWQuCj4gPiA+Cj4g
PiA+IFNpZ25lZC1vZmYtYnk6IE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwub3JnPgo+ID4g
PiAtLS0KPiA+ID4gIGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDM1ICsrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0tCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjcgaW5zZXJ0aW9ucygr
KSwgOCBkZWxldGlvbnMoLSkKPiA+ID4KPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvZG0t
Y3J5cHQuYyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+ID4gPiBpbmRleCA2NDE0NTdlNzI2MDMu
LjJkMDMwOWNhMDdmNSAxMDA2NDQKPiA+ID4gLS0tIGEvZHJpdmVycy9tZC9kbS1jcnlwdC5jCj4g
PiA+ICsrKyBiL2RyaXZlcnMvbWQvZG0tY3J5cHQuYwo+ID4gPiBAQCAtNDAsNiArNDAsNyBAQAo+
ID4gPiAgI2luY2x1ZGUgPGtleXMvdXNlci10eXBlLmg+Cj4gPiA+ICAjaW5jbHVkZSA8a2V5cy9l
bmNyeXB0ZWQtdHlwZS5oPgo+ID4gPiAgI2luY2x1ZGUgPGtleXMvdHJ1c3RlZC10eXBlLmg+Cj4g
PiA+ICsjaW5jbHVkZSA8bGludXgvanVtcF9sYWJlbC5oPgo+ID4gPgo+ID4gPiAgI2luY2x1ZGUg
PGxpbnV4L2RldmljZS1tYXBwZXIuaD4KPiA+ID4KPiA+ID4gQEAgLTg1LDYgKzg2LDggQEAgc3Ry
dWN0IGRtX2NyeXB0X2lvIHsKPiA+ID4gICAgICAgc3RydWN0IHJiX25vZGUgcmJfbm9kZTsKPiA+
ID4gIH0gQ1JZUFRPX01JTkFMSUdOX0FUVFI7Cj4gPiA+Cj4gPiA+ICtzdGF0aWMgREVGSU5FX1NU
QVRJQ19LRVlfRkFMU0UodXNlX3Rhc2tsZXRfZW5hYmxlZCk7Cj4gPiA+ICsKPiA+ID4gIHN0cnVj
dCBkbV9jcnlwdF9yZXF1ZXN0IHsKPiA+ID4gICAgICAgc3RydWN0IGNvbnZlcnRfY29udGV4dCAq
Y3R4Owo+ID4gPiAgICAgICBzdHJ1Y3Qgc2NhdHRlcmxpc3Qgc2dfaW5bNF07Cj4gPiA+IEBAIC0x
NzMwLDEyICsxNzMzLDE1IEBAIHN0YXRpYyB2b2lkIGNyeXB0X2lvX2luaXQoc3RydWN0IGRtX2Ny
eXB0X2lvICppbywgc3RydWN0IGNyeXB0X2NvbmZpZyAqY2MsCj4gPiA+ICAgICAgIGlvLT5zZWN0
b3IgPSBzZWN0b3I7Cj4gPiA+ICAgICAgIGlvLT5lcnJvciA9IDA7Cj4gPiA+ICAgICAgIGlvLT5j
dHguci5yZXEgPSBOVUxMOwo+ID4gPiAtICAgICAvKgo+ID4gPiAtICAgICAgKiB0YXNrbGV0X2lu
aXQoKSBoZXJlIHRvIGVuc3VyZSBjcnlwdF9kZWNfcGVuZGluZygpJ3MKPiA+ID4gLSAgICAgICog
dGFza2xldF90cnlsb2NrKCkgZG9lc24ndCBpbmNvcnJlY3RseSByZXR1cm4gZmFsc2UKPiA+ID4g
LSAgICAgICogZXZlbiB3aGVuIHRhc2tsZXQgaXNuJ3QgaW4gdXNlLgo+ID4gPiAtICAgICAgKi8K
PiA+ID4gLSAgICAgdGFza2xldF9pbml0KCZpby0+dGFza2xldCwga2NyeXB0ZF9jcnlwdF90YXNr
bGV0LCAodW5zaWduZWQgbG9uZykmaW8tPndvcmspOwo+ID4gPiArICAgICBpZiAoc3RhdGljX2Jy
YW5jaF91bmxpa2VseSgmdXNlX3Rhc2tsZXRfZW5hYmxlZCkpIHsKPiA+ID4gKyAgICAgICAgICAg
ICAvKgo+ID4gPiArICAgICAgICAgICAgICAqIHRhc2tsZXRfaW5pdCgpIGhlcmUgdG8gZW5zdXJl
IGNyeXB0X2RlY19wZW5kaW5nKCkncwo+ID4gPiArICAgICAgICAgICAgICAqIHRhc2tsZXRfdHJ5
bG9jaygpIGRvZXNuJ3QgaW5jb3JyZWN0bHkgcmV0dXJuIGZhbHNlCj4gPiA+ICsgICAgICAgICAg
ICAgICogZXZlbiB3aGVuIHRhc2tsZXQgaXNuJ3QgaW4gdXNlLgo+ID4gPiArICAgICAgICAgICAg
ICAqLwo+ID4gPiArICAgICAgICAgICAgIHRhc2tsZXRfaW5pdCgmaW8tPnRhc2tsZXQsIGtjcnlw
dGRfY3J5cHRfdGFza2xldCwKPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgKHVuc2ln
bmVkIGxvbmcpJmlvLT53b3JrKTsKPiA+ID4gKyAgICAgfQo+ID4gPiAgICAgICBpby0+aW50ZWdy
aXR5X21ldGFkYXRhID0gTlVMTDsKPiA+ID4gICAgICAgaW8tPmludGVncml0eV9tZXRhZGF0YV9m
cm9tX3Bvb2wgPSBmYWxzZTsKPiA+ID4gICAgICAgYXRvbWljX3NldCgmaW8tPmlvX3BlbmRpbmcs
IDApOwo+ID4gPiBAQCAtMTc3NSw2ICsxNzgxLDEwIEBAIHN0YXRpYyB2b2lkIGNyeXB0X2RlY19w
ZW5kaW5nKHN0cnVjdCBkbV9jcnlwdF9pbyAqaW8pCj4gPiA+ICAgICAgICAgICAgICAga2ZyZWUo
aW8tPmludGVncml0eV9tZXRhZGF0YSk7Cj4gPiA+Cj4gPiA+ICAgICAgIGJhc2VfYmlvLT5iaV9z
dGF0dXMgPSBlcnJvcjsKPiA+ID4gKyAgICAgaWYgKCFzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZ1
c2VfdGFza2xldF9lbmFibGVkKSkgewo+ID4gPiArICAgICAgICAgICAgIGJpb19lbmRpbyhiYXNl
X2Jpbyk7Cj4gPiA+ICsgICAgICAgICAgICAgcmV0dXJuOwo+ID4gPiArICAgICB9Cj4gPiBCZWNh
dXNlIHVzZV90YXNrbGV0X2VuYWJsZWQgY2FuIGJlIGVuYWJsZWQgY29uY3VycmVudGx5LCBzbyBJ
IHRoaW5rIGl0IGlzIHN0aWxsCj4gPiBwb3NzaWJsZSB0aGF0IGNyeXB0X2RlY19wZW5kaW5nIHdp
bGwgdHJ5LWxvY2sgYW4gdW5pdGlhbGl6ZWQgdGFza2xldCBpZgo+ID4gdXNlX3Rhc2tsZXRfZW5h
YmxlZCBpcyBlbmFibGVkIHdoZW4gaW52b2tpbmcgY3J5cHRfZGVjX3BlbmRpbmcoKS4KCkdvb2Qg
cG9pbnQsIHdoaWxlIEkgdGhpbmsgaXQgaXMgcHJvYmFibHkgYWNjZXB0YWJsZSBnaXZlbiB0aGUg
d29yc3QKY2FzZSBpcyBwdW50aW5nIHRoZSBiaW9fZW5kaW8gdG8gYSB3b3JrcXVldWUgZm9yIGEg
dGltZSAuLi4KCj4gUGVyaGFwcyBpbnN0ZWFkIHdlIGNhbiBqdXN0IHBhc3MgYW4gYWRkaXRpb25h
bCBmbGFnIGZyb20KPiB0YXNrbGV0X3NjaGVkdWxlIHRvIGluZGljYXRlIHRvIHRoZSBmdW5jdGlv
biB0aGF0IHdlJ3JlIHJ1bm5pbmcgaW4gYQo+IHRhc2tsZXQuIEkgb3JpZ2luYWxseSBoYXZlIGNo
b3NlbiB0aGUgdGFza2xldF90cnlsb2NrL3VubG9jayBoYWNrIHRvCj4gYXZvaWQgcGFzc2luZyBh
biBleHRyYSBmbGFnLiBCdXQgdW5pdGlhbGl6ZWQgbWVtb3J5IG1ha2VzIHNlbnNlIGFzCj4gd2Vs
bCBhcyB0aGUgZGVzaXJlIHRvIGF2b2lkIGNhbGxpbmcgdGFza2xldF9pbml0IHVuY29uZGl0aW9u
YWxseS4gU28KPiBhbiBleHRyYSBtZW1iZXIgaW4gZG1fY3J5cHRfaW8gbWlnaHQgYmUgdGhlIG1v
c3Qgc3RyYWlnaHRmb3J3YXJkIGhlcmUuCgouLi4gSSB0aGluayB3ZSBzaG91bGQgY2VydGFpbmx5
IGV2YWx1YXRlIHRoZSB1c2Ugb2YgYW4gZXh0cmEgZmxhZy4KCklnbmF0OiBJJ2xsIGhhdmUgYSBs
b29rIGF0IGltcGxlbWVudGluZyBpdCBidXQgaWYgeW91IGhhdmUgYSBwYXRjaAphbHJlYWR5IGRl
dmVsb3BlZCBwbGVhc2UgZG8gc2hhcmUuCgpUaGFua3MsCk1pa2UKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

