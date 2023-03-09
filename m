Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9F2C61DA4
	for <dm-devel@archiver.kernel.org>; Thu,  9 Mar 2023 11:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678361259;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=efwJICuM6E3Rqq3aYVMN3b9L/1Qstt682+/59b8HaSU=;
	b=SdTL25d5GHkvQCc6PhEazZC7sQh2liI7BWhFmYwrhCgydQ5XGqFC4eb/7pmw8jOz49NuoQ
	OQ3Ee1hKWeV22ZZCf9YP8hcCW1DjayY5vkRwAUAZ6S64Kd5bcHpQAeWTw4KEysVF53Dto3
	lQDbwjtKsLcKkX9TKRBzFbyi9+sJ0sg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-geVIX3Z3NiKaFLyfx7EnBg-1; Thu, 09 Mar 2023 06:27:38 -0500
X-MC-Unique: geVIX3Z3NiKaFLyfx7EnBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF04D1C05AB0;
	Thu,  9 Mar 2023 11:27:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73114440DD;
	Thu,  9 Mar 2023 11:27:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C6E419465B5;
	Thu,  9 Mar 2023 11:27:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B5FB019465B3
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 11:27:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A3B01440DE; Thu,  9 Mar 2023 11:27:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B8AA440DD
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 11:27:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77E47101A521
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 11:27:33 +0000 (UTC)
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com
 [209.85.214.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-V0ecjoZZMcGB_30Y5PgH8w-1; Thu, 09 Mar 2023 06:27:31 -0500
X-MC-Unique: V0ecjoZZMcGB_30Y5PgH8w-1
Received: by mail-pl1-f171.google.com with SMTP id n6so1621225plf.5
 for <dm-devel@redhat.com>; Thu, 09 Mar 2023 03:27:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678361250;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=sTkd/ocqzqHF903X3l/TIbGxupeKtrhJgXkaQqPp9AE=;
 b=xVre8WlJ6PLy6oUj/dgpEJTxnfhpZXqDfbyedJPYoChLdTIyS5M8ggbfX6GiaJ7sak
 76CiMD0lSXLh+KfV1oU7QmX1TrBKQd+d7xePTh6qgpxH7ULoR4S7+YmVnTcJl8bgAy3d
 u5q9c6rc6RxebyHcUm7zVtbnhYc+B335LUx/NIdsbyuJbTZmdgCnJzCBh5pb9nNNnWOP
 dbgECM8RoLMQcBI/Yt3q09WjBOO+4GAgOTVbis2CkD13MCKllL5R2+HvNf64HYWRxvxn
 MBF94iitZbQz2DiggSKi2mMZDv1+WL+QekhuXeeRc8jUgexy5dAtBbac2qsmrWXRXYi9
 mjjg==
X-Gm-Message-State: AO0yUKWaGUs7N0j4jFDI7SCcQiM2kaz4ZGHQRyUG4ZA6ym+hbBcYwYTA
 lIxmAa26tchr+7aGeButTKHof4PLXkTj666RN2LASQ==
X-Google-Smtp-Source: AK7set+0WkaHZixQx2+BsrO0fjzkrnjGjfnSiMls2OdnOe3y7QaAQFzS8mLzCHTib255JUwIjmIJF9xJP/D1hhZ4HWo=
X-Received: by 2002:a17:90a:c217:b0:234:b8cb:5133 with SMTP id
 e23-20020a17090ac21700b00234b8cb5133mr8017870pjt.7.1678361250400; Thu, 09 Mar
 2023 03:27:30 -0800 (PST)
MIME-Version: 1.0
References: <20230306134930.2878660-1-houtao@huaweicloud.com>
 <ZAY/o9ew9AtrCLE5@redhat.com>
 <e9b61952-98a8-6e3b-2d85-6aaf07208a7b@huaweicloud.com>
 <ZAdOgUdqwLpUyPlc@redhat.com>
 <6c2d07bf-828e-3aeb-3c02-6cdfd6e36ff3@huaweicloud.com>
 <CALrw=nFrbWF2ZhQtK9gx5ZFHK4Cd9outwEQqByJgmb7ryOoCgA@mail.gmail.com>
 <ZAjfu0R7rv45J3Dr@redhat.com> <ZAjvqz5pWf8aSkJ7@redhat.com>
In-Reply-To: <ZAjvqz5pWf8aSkJ7@redhat.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 9 Mar 2023 11:27:19 +0000
Message-ID: <CALrw=nGXQ__cL_AX7SccNYZ=BKpHatXeh4nd_wjK2EbBTVm4Pg@mail.gmail.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBNYXIgOCwgMjAyMyBhdCA4OjI34oCvUE0gTWlrZSBTbml0emVyIDxzbml0emVyQGtl
cm5lbC5vcmc+IHdyb3RlOgo+Cj4gT24gV2VkLCBNYXIgMDggMjAyMyBhdCAgMjoxOVAgLTA1MDAs
Cj4gTWlrZSBTbml0emVyIDxzbml0emVyQGtlcm5lbC5vcmc+IHdyb3RlOgo+Cj4gPiBPbiBXZWQs
IE1hciAwOCAyMDIzIGF0ICA4OjU1UCAtMDUwMCwKPiA+IElnbmF0IEtvcmNoYWdpbiA8aWduYXRA
Y2xvdWRmbGFyZS5jb20+IHdyb3RlOgo+ID4KPiA+ID4gUGVyaGFwcyBpbnN0ZWFkIHdlIGNhbiBq
dXN0IHBhc3MgYW4gYWRkaXRpb25hbCBmbGFnIGZyb20KPiA+ID4gdGFza2xldF9zY2hlZHVsZSB0
byBpbmRpY2F0ZSB0byB0aGUgZnVuY3Rpb24gdGhhdCB3ZSdyZSBydW5uaW5nIGluIGEKPiA+ID4g
dGFza2xldC4gSSBvcmlnaW5hbGx5IGhhdmUgY2hvc2VuIHRoZSB0YXNrbGV0X3RyeWxvY2svdW5s
b2NrIGhhY2sgdG8KPiA+ID4gYXZvaWQgcGFzc2luZyBhbiBleHRyYSBmbGFnLiBCdXQgdW5pdGlh
bGl6ZWQgbWVtb3J5IG1ha2VzIHNlbnNlIGFzCj4gPiA+IHdlbGwgYXMgdGhlIGRlc2lyZSB0byBh
dm9pZCBjYWxsaW5nIHRhc2tsZXRfaW5pdCB1bmNvbmRpdGlvbmFsbHkuIFNvCj4gPiA+IGFuIGV4
dHJhIG1lbWJlciBpbiBkbV9jcnlwdF9pbyBtaWdodCBiZSB0aGUgbW9zdCBzdHJhaWdodGZvcndh
cmQgaGVyZS4KPiA+Cj4gPiAuLi4gSSB0aGluayB3ZSBzaG91bGQgY2VydGFpbmx5IGV2YWx1YXRl
IHRoZSB1c2Ugb2YgYW4gZXh0cmEgZmxhZy4KPiA+Cj4gPiBJZ25hdDogSSdsbCBoYXZlIGEgbG9v
ayBhdCBpbXBsZW1lbnRpbmcgaXQgYnV0IGlmIHlvdSBoYXZlIGEgcGF0Y2gKPiA+IGFscmVhZHkg
ZGV2ZWxvcGVkIHBsZWFzZSBkbyBzaGFyZS4KPgo+IEkndmUgc3RhZ2VkIHRoZSBmb2xsb3dpbmcg
aW4gbGludXgtbmV4dCBmb3IgNi4zIHZpYSB0aGUgbGludXgtZG0uZ2l0LAo+IGJ1dCBpZiB5b3Ug
c2VlIGFueXRoaW5nIHdyb25nIHdpdGggaXQgSSBjYW4gb2J2aW91c2x5IGZpeDoKPgo+IEZyb206
IE1pa2UgU25pdHplciA8c25pdHplckBrZXJuZWwub3JnPgo+IERhdGU6IFdlZCwgOCBNYXIgMjAy
MyAxNDozOTo1NCAtMDUwMAo+IFN1YmplY3Q6IFtQQVRDSF0gZG0gY3J5cHQ6IGF2b2lkIGFjY2Vz
c2luZyB1bmluaXRpYWxpemVkIHRhc2tsZXQKPgo+IFdoZW4gbmVpdGhlciAibm9fcmVhZF93b3Jr
cXVldWUiIG5vciAibm9fd3JpdGVfd29ya3F1ZXVlIiBhcmUgZW5hYmxlZCwKPiB0YXNrbGV0X3Ry
eWxvY2soKSBpbiBjcnlwdF9kZWNfcGVuZGluZygpIG1heSBzdGlsbCByZXR1cm4gZmFsc2UgZHVl
IHRvCj4gYW4gdW5pbml0aWFsaXplZCBzdGF0ZSwgYW5kIGRtLWNyeXB0IHdpbGwgdW5uZWNlc3Nh
cmlseSBkbyBpbyBjb21wbGV0aW9uCj4gaW4gaW9fcXVldWUgd29ya3F1ZXVlIGluc3RlYWQgb2Yg
Y3VycmVudCBjb250ZXh0Lgo+Cj4gRml4IHRoaXMgYnkgYWRkaW5nIGFuICdpbl90YXNrbGV0JyBm
bGFnIHRvIGRtX2NyeXB0X2lvIHN0cnVjdCBhbmQKPiBpbml0aWFsaXplIGl0IHRvIGZhbHNlIGlu
IGNyeXB0X2lvX2luaXQoKS4gU2V0IHRoaXMgZmxhZyB0byB0cnVlIGluCj4ga2NyeXB0ZF9xdWV1
ZV9jcnlwdCgpIGJlZm9yZSBjYWxsaW5nIHRhc2tsZXRfc2NoZWR1bGUoKS4gSWYgc2V0Cj4gY3J5
cHRfZGVjX3BlbmRpbmcoKSB3aWxsIHB1bnQgaW8gY29tcGxldGlvbiB0byBhIHdvcmtxdWV1ZS4K
Pgo+IFRoaXMgYWxzbyBuaWNlbHkgYXZvaWRzIHRoZSB0YXNrbGV0X3RyeWxvY2svdW5sb2NrIGhh
Y2sgd2hlbiB0YXNrbGV0cwo+IGFyZW4ndCBpbiB1c2UuCj4KPiBGaXhlczogOGUxNGY2MTAxNTlk
ICgiZG0gY3J5cHQ6IGRvIG5vdCBjYWxsIGJpb19lbmRpbygpIGZyb20gdGhlIGRtLWNyeXB0IHRh
c2tsZXQiKQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gUmVwb3J0ZWQtYnk6IEhvdSBU
YW8gPGhvdXRhbzFAaHVhd2VpLmNvbT4KPiBTdWdnZXN0ZWQtYnk6IElnbmF0IEtvcmNoYWdpbiA8
aWduYXRAY2xvdWRmbGFyZS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWlrZSBTbml0emVyIDxzbml0
emVyQGtlcm5lbC5vcmc+Cj4gLS0tCj4gIGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDkgKysrKysr
LS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCj4K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS1jcnlwdC5jIGIvZHJpdmVycy9tZC9kbS1jcnlw
dC5jCj4gaW5kZXggZmFiYTFiZTU3MmY5Li5kZTA4ZmY0ZjdjOTggMTAwNjQ0Cj4gLS0tIGEvZHJp
dmVycy9tZC9kbS1jcnlwdC5jCj4gKysrIGIvZHJpdmVycy9tZC9kbS1jcnlwdC5jCj4gQEAgLTcy
LDcgKzcyLDkgQEAgc3RydWN0IGRtX2NyeXB0X2lvIHsKPiAgICAgICAgIHN0cnVjdCBjcnlwdF9j
b25maWcgKmNjOwo+ICAgICAgICAgc3RydWN0IGJpbyAqYmFzZV9iaW87Cj4gICAgICAgICB1OCAq
aW50ZWdyaXR5X21ldGFkYXRhOwo+IC0gICAgICAgYm9vbCBpbnRlZ3JpdHlfbWV0YWRhdGFfZnJv
bV9wb29sOwo+ICsgICAgICAgYm9vbCBpbnRlZ3JpdHlfbWV0YWRhdGFfZnJvbV9wb29sOjE7Cj4g
KyAgICAgICBib29sIGluX3Rhc2tsZXQ6MTsKPiArCj4gICAgICAgICBzdHJ1Y3Qgd29ya19zdHJ1
Y3Qgd29yazsKPiAgICAgICAgIHN0cnVjdCB0YXNrbGV0X3N0cnVjdCB0YXNrbGV0Owo+Cj4gQEAg
LTE3MzEsNiArMTczMyw3IEBAIHN0YXRpYyB2b2lkIGNyeXB0X2lvX2luaXQoc3RydWN0IGRtX2Ny
eXB0X2lvICppbywgc3RydWN0IGNyeXB0X2NvbmZpZyAqY2MsCj4gICAgICAgICBpby0+Y3R4LnIu
cmVxID0gTlVMTDsKPiAgICAgICAgIGlvLT5pbnRlZ3JpdHlfbWV0YWRhdGEgPSBOVUxMOwo+ICAg
ICAgICAgaW8tPmludGVncml0eV9tZXRhZGF0YV9mcm9tX3Bvb2wgPSBmYWxzZTsKPiArICAgICAg
IGlvLT5pbl90YXNrbGV0ID0gZmFsc2U7Cj4gICAgICAgICBhdG9taWNfc2V0KCZpby0+aW9fcGVu
ZGluZywgMCk7Cj4gIH0KPgo+IEBAIC0xNzc3LDggKzE3ODAsNyBAQCBzdGF0aWMgdm9pZCBjcnlw
dF9kZWNfcGVuZGluZyhzdHJ1Y3QgZG1fY3J5cHRfaW8gKmlvKQo+ICAgICAgICAgICogb3VyIHRh
c2tsZXQuIEluIHRoaXMgY2FzZSB3ZSBuZWVkIHRvIGRlbGF5IGJpb19lbmRpbygpCj4gICAgICAg
ICAgKiBleGVjdXRpb24gdG8gYWZ0ZXIgdGhlIHRhc2tsZXQgaXMgZG9uZSBhbmQgZGVxdWV1ZWQu
Cj4gICAgICAgICAgKi8KPiAtICAgICAgIGlmICh0YXNrbGV0X3RyeWxvY2soJmlvLT50YXNrbGV0
KSkgewo+IC0gICAgICAgICAgICAgICB0YXNrbGV0X3VubG9jaygmaW8tPnRhc2tsZXQpOwo+ICsg
ICAgICAgaWYgKCFpby0+aW5fdGFza2xldCkgewoKbml0cGljazogbWF5YmUgaW52ZXJ0IHRoZSBs
b2dpYyBoZXJlIGZvciBiZXR0ZXIgcmVhZGFiaWxpdHk/IChzbyBpdApiZWNvbWVzICJpZiAoaW5f
dGFza2xldCkgcXVldWUuLi4iIGVsc2UganVzdCBmYWxscyB0aHJvdWdoIGJpb19lbmRpbygpCikK
Cj4gICAgICAgICAgICAgICAgIGJpb19lbmRpbyhiYXNlX2Jpbyk7Cj4gICAgICAgICAgICAgICAg
IHJldHVybjsKPiAgICAgICAgIH0KPiBAQCAtMjIzMyw2ICsyMjM1LDcgQEAgc3RhdGljIHZvaWQg
a2NyeXB0ZF9xdWV1ZV9jcnlwdChzdHJ1Y3QgZG1fY3J5cHRfaW8gKmlvKQo+ICAgICAgICAgICAg
ICAgICAgKiBpdCBpcyBiZWluZyBleGVjdXRlZCB3aXRoIGlycXMgZGlzYWJsZWQuCj4gICAgICAg
ICAgICAgICAgICAqLwo+ICAgICAgICAgICAgICAgICBpZiAoaW5faGFyZGlycSgpIHx8IGlycXNf
ZGlzYWJsZWQoKSkgewo+ICsgICAgICAgICAgICAgICAgICAgICAgIGlvLT5pbl90YXNrbGV0ID0g
dHJ1ZTsKPiAgICAgICAgICAgICAgICAgICAgICAgICB0YXNrbGV0X2luaXQoJmlvLT50YXNrbGV0
LCBrY3J5cHRkX2NyeXB0X3Rhc2tsZXQsICh1bnNpZ25lZCBsb25nKSZpby0+d29yayk7Cj4gICAg
ICAgICAgICAgICAgICAgICAgICAgdGFza2xldF9zY2hlZHVsZSgmaW8tPnRhc2tsZXQpOwo+ICAg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybjsKPiAtLQo+IDIuMzcuMSAoQXBwbGUgR2l0LTEz
Ny4xKQo+CgpSZXZpZXdlZC1ieTogSWduYXQgS29yY2hhZ2luIDxpZ25hdEBjbG91ZGZsYXJlLmNv
bT4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

