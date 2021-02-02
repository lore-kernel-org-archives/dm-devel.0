Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E94C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 08:14:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 51B5F64EE9
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 08:14:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51B5F64EE9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-H6KapeRHPLGU8LavFOHT9Q-1; Tue, 02 Feb 2021 03:14:21 -0500
X-MC-Unique: H6KapeRHPLGU8LavFOHT9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 709BA801AF5;
	Tue,  2 Feb 2021 08:14:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82C515F705;
	Tue,  2 Feb 2021 08:14:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B3EDC50039;
	Tue,  2 Feb 2021 08:14:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1128ECZe019568 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 03:14:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F525A9A0F; Tue,  2 Feb 2021 08:14:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19D28A9A0D
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 08:14:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9C73802A5B
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 08:14:09 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-233-k89tkck6PjyTsHQtovr0hQ-1; Tue, 02 Feb 2021 03:14:05 -0500
X-MC-Unique: k89tkck6PjyTsHQtovr0hQ-1
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DVHcR3KVVzjGhs;
	Tue,  2 Feb 2021 16:12:55 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server
	id 14.3.498.0; Tue, 2 Feb 2021 16:13:51 +0800
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
References: <d6652b08-2d6c-ac46-9d73-b252bc26f41a@huawei.com>
	<3992c887b6b9a00c4faad17c1d381d2afb4a2e86.camel@suse.com>
	<b9824ac2-7c64-95e0-d352-1aed99eacb12@huawei.com>
	<035279e085cb7e4f53b00755f491103b9c92ba67.camel@suse.com>
	<b7c44c2a-d401-36de-0384-52bd11e812f8@huawei.com>
	<299a237e5fd558b6f54a1934f4c8aed8aaf24f24.camel@suse.com>
	<20210202052636.GP15006@octiron.msp.redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <2d471f7e-82c3-f85a-c170-7d4a3fc98d65@huawei.com>
Date: Tue, 2 Feb 2021 16:13:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210202052636.GP15006@octiron.msp.redhat.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1128ECZe019568
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Subject: Re: [dm-devel] libmultipath: fix NULL dereference in get_be64
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgpPbiAyMDIxLzIvMiAxMzoyNiwgQmVuamFtaW4gTWFyemluc2tpIHdyb3RlOgo+IFNvLCBJIHRo
aW5rIHRoZSBtYWluIGlzc3VlIGhlcmUgaXMgdGhhdCBmaWx0ZXJfcHJvcGVydHkgYXBwZWFycyB0
byBiZQo+IGJyb2tlbi4gIEl0IG9ubHkgZmlsdGVycyBpZiB1aWRfYXR0cmlidXRlIGlzIHNldCwg
YnV0IHRoYXQgd2lsbCBuZXZlciBiZQo+IHNldCB0aGUgZmlyc3QgdGltZSBpdCdzIGNhbGxlZCBp
biBwYXRoaW5mby4gIFRoaXMgbWVhbnMgdGhhdCBpdCB3aWxsCj4gcGFzcyBpbiB0aGUgcGF0aGlu
Zm8gY2FsbCBpbiBjbGlfYWRkX3BhdGgsIGFuZCB0aGUgcGF0aCB3aWxsIGdldCBzdG9yZWQKPiBp
biB0aGUgcGF0aHZlYy4KPiAKCiAgWWVzISBUaGUgcGF0aGluZm8gcmV0dXJucyBQQVRISU5GT19P
SyBpbiBzdG9yZV9wYXRoaW5mbyBidXQgcmV0dXJucwpQQVRISU5GT19TS0lQUEVEIGluIGFkb3B0
X3BhdGhzLiBJJ20gc29ycnkgZm9yIG5vdCBtZW50aW9uaW5nIGl0IGluIHRoZQpwcmV2aW91cyBl
LW1haWxzLiBJIGp1c3QgZm9jdXMgb24gd2hlcmUgcmV0dXJuIFBBVEhJTkZPX1NLSVBQRUQgaW4g
c2Vjb25kCnBhdGhpbmZvLgoKR2RiIHNlY29uZCBwYXRoaW5mbyBpbiBhZG9wdF9wYXRoczoKKGdk
YikKMjEwNgkJCWlmIChoaWRkZW4gJiYgIXN0cmNtcChoaWRkZW4sICIxIikpIHsKKGdkYikKMjEw
MwkJCWNvbnN0IGNoYXIgKmhpZGRlbiA9CihnZGIpCjIxMDYJCQlpZiAoaGlkZGVuICYmICFzdHJj
bXAoaGlkZGVuLCAiMSIpKSB7CihnZGIpCjIxMTAJCQlpZiAoaXNfY2xhaW1lZF9ieV9mb3JlaWdu
KHBwLT51ZGV2KSB8fAooZ2RiKQoyMTExCQkJICAgIGZpbHRlcl9wcm9wZXJ0eShjb25mLCBwcC0+
dWRldiwgNCwgcHAtPnVpZF9hdHRyaWJ1dGUpID4gMCkKKGdkYikKMjExMAkJCWlmIChpc19jbGFp
bWVkX2J5X2ZvcmVpZ24ocHAtPnVkZXYpIHx8CihnZGIpCjIxNDYJCQkJcmV0dXJuIFBBVEhJTkZP
X1NLSVBQRUQ7CihnZGIpCjIyNjAJfQogIEknbSBub3Qgc3VyZSBmaWx0ZXJfcHJvcGVydHkgbWFr
ZXMgcGF0aGluZm8gcmV0dXJuIFBBVEhJTkZPX1NLSVBQRUQgZnJvbSBnZGIuCkJlbuKAmXMgYW5h
bHlzaXMgcmVzb2x2ZXMgbXkgZG91YnRzLgoKPiBIb3dldmVyLCBpdCB3aWxsIGZhaWwgaW4gdGhl
IHBhdGhpbmZvIGNhbGwgZnJvbSBhZG9wdF9wYXRocywgc28gdGhlIHBhdGgKPiB3b24ndCBiZSBh
ZGRlZCB0byB0aGUgbXVsdGlwYXRoIGRldmljZS4gIFRoaXMgbWVhbnMgYWRvcHQgcGF0aHMgZG9l
c24ndAo+IGFjdHVhbGx5IGFkb3B0IGFueSBwYXRocyBwb3RlbnRpYWxseSwgYnV0IHRoYXQgaW4g
aXRzZWxmIGRvZXNuJ3QgY2F1c2UKPiBpdCB0byBmYWlsLiBUaGlzIGNoZWNrCj4gCj4gICAgICAg
ICBpZiAoYWRvcHRfcGF0aHModmVjcy0+cGF0aHZlYywgbXBwKSB8fAo+ICAgICAgICAgICAgIGZp
bmRfc2xvdCh2ZWNzLT5wYXRodmVjLCBwcCkgPT0gLTEpCj4gICAgICAgICAgICAgICAgIGdvdG8g
b3V0Owo+IAo+IHBhc3Nlcywgc2luY2Ugd2Ugb25seSBjaGVjayBpZiB0aGUgcGF0aCBpcyBvbiB0
aGUgcGF0aHZlYywgbm90IHBhcnQgb2YKPiB0aGUgbXVsdGlwYXRoIGRldmljZSwgYW5kIHNpbmNl
IGZpbHRlcl9wcm9wZXJ0eSBsZXQgdGhlIHBhdGggcGFzdCB0aGUKPiBmaXJzdCB0aW1lLCBpdCBp
cy4gU28gYWRkX21hcF93aXRoX3BhdGgoKSB3aWxsIGNyZWF0ZSBhIG11bHRpcGF0aAo+IGRldmlj
ZSwgYnV0IHRoZSBwYXRoIHdvbid0IGJlIGFkZGVkIHRvIGl0LCBhbmQgcHAtPm1wcCA9PSBOVUxM
Lgo+IAo+IFNvLCBhZGRfbWFwX3dpdGhfcGF0aCgpIHNob3VsZCBwcm9iYWJseSBjaGVjayB0aGF0
IHdlIGFjdHVhbGx5IGNyZWF0ZWQgYQo+IG1hcCB0aGF0IGluY2x1ZGVkIHRoZSBwYXRoIHRoYXQg
Z290IGFkZGVkLiBCdXQgbW9yZSBpbXBvcnRhbnRseSwKPiBmaWx0ZXJfcHJvcGVydHkgc2hvdWxk
bid0IHJldHVybiBkaWZmZXJlbnQgcmVzdWx0cyB0aGUgd2hlbiBpdCdzIGNhbGxlZAo+IHRoZSBm
aXJzdCB0aW1lLiAgVGhhdCB3b3VsZCBoYXZlIGF2b2lkIHRoZSBlbnRpcmUgc2l0dWF0aW9uLgoJ
aWYgKGFkb3B0X3BhdGhzKHZlY3MtPnBhdGh2ZWMsIG1wcCkgfHwKCSAgICBmaW5kX3Nsb3QodmVj
cy0+cGF0aHZlYywgcHApID09IC0xIHx8CgkgICAgIXBwLT5tcHApCgkJZ290byBvdXQ7CgpUaGlz
IGlzIGJldHRlciB0aGFuIG15IGZpcnN0IHBhdGNoIHRvIGF2b2lkIHRoaXMgcHJvYmxlbS4gSG93
ZXZlciwgaXQKaXMgYmV5b25kIG15IGFiaWxpdHkgdG8gc2xvdmUgdGhlIHByb2JsZW0gb2YgZmls
dGVyX3Byb3BlcnR5IHJldHVybmluZwpkaWZmZXJlbnQgdmFsdWVzLgoKUmVnYXJkcywKTGl4aWFv
a2VuZwoKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRw
czovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

