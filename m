Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 001DBC6FA82
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 16:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663171416;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zQmqxMJ3Q9hec20xvk0u3cUX60t+ulbmapjbd/ogIUk=;
	b=cxSZn2NZlmi8z6Un5kDEp/+cAoYYksaBDU7f34OEUIHN5C6LncRAgu0WCj5RAp777LZCCB
	1/BPGYpf2F3zC/GrMcSaSU77aP0OTHahzeEd6wDes2+yinz9uJdSD8DyFQAWiYiI1j8dXQ
	1GdPWYP52HfiMh5JOvTdqzJqu426diM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-9xDzo3byM0K-jiomZsxSRw-1; Wed, 14 Sep 2022 12:03:33 -0400
X-MC-Unique: 9xDzo3byM0K-jiomZsxSRw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C8BE3C1C999;
	Wed, 14 Sep 2022 16:03:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 94566492CA2;
	Wed, 14 Sep 2022 16:03:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6B69D1946A56;
	Wed, 14 Sep 2022 16:03:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1BE681946A53
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 15:58:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05F6749BB62; Wed, 14 Sep 2022 15:58:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0213049BB60
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 15:58:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EE353817A7F
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 15:58:25 +0000 (UTC)
Received: from forward502p.mail.yandex.net (forward502p.mail.yandex.net
 [77.88.28.112]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-3uNO6o7HMHqXYThKNmQDHg-1; Wed, 14 Sep 2022 11:58:17 -0400
X-MC-Unique: 3uNO6o7HMHqXYThKNmQDHg-1
Received: from sas2-1cbd504aaa99.qloud-c.yandex.net
 (sas2-1cbd504aaa99.qloud-c.yandex.net
 [IPv6:2a02:6b8:c14:7101:0:640:1cbd:504a])
 by forward502p.mail.yandex.net (Yandex) with ESMTP id 75689B82015
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 18:50:15 +0300 (MSK)
Received: by sas2-1cbd504aaa99.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA
 id uCX685uVqP-oEiGFr1S; Wed, 14 Sep 2022 18:50:14 +0300
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
 (Client certificate not present)
X-Yandex-Fwd: 1
Message-ID: <30937694b9880922fd6eeae37fd0b57797dc6898.camel@yandex.ru>
From: Konstantin Kharlamov <hi-angel@yandex.ru>
To: dm-devel@redhat.com
Date: Wed, 14 Sep 2022 18:50:14 +0300
In-Reply-To: <919bbae705f5a5351274292713dfacbf011971e6.camel@yandex.ru>
References: <919bbae705f5a5351274292713dfacbf011971e6.camel@yandex.ru>
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] 
 =?utf-8?q?How_to_debug_missing_devices_in_=60multipat?=
 =?utf-8?b?aCAtbGAgKGFuZCDigKZgLWxsYCk=?=
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDIyLTA5LTEzIGF0IDE3OjM3ICswMzAwLCBLb25zdGFudGluIEtoYXJsYW1vdiB3
cm90ZToKPiBIZWxsbyEgU29ycnkgaWYgaXQncyB0aGUgd3JvbmcgbGlzdCwgaXQgaXMgcmVmZXJy
ZWQgdG8gYnkgbXVsdGlwYXRoLXRvb2xzCj4gd2l0aG91dCBzYXlpbmcgaXQncyAiZGV2ZWwiLCBz
byBJIHByZXN1bWUgdXNlciBxdWVzdGlvbnMgYXJlIG9rYXnigKY/Cj4gCj4gSG93IHRvIGRlYnVn
IGEgbGFjayBvZiBkZXZpY2VzIGluIGBtdWx0aXBhdGggLWxgIGFuZCBg4oCmIC1sbGAgb3V0cHV0
cz8gSSdtCj4gc3R1ZHlpbmcgYG11bHRpcGF0aGQgLWR2NWAgbG9ncywgYnV0IGl0J3Mgbm90IGF0
IGFsbCBjbGVhciB0byBtZSBhcyB0byB3aGF0IHRvCj4gbG9vayBmb3IuCj4gCj4gQXQgJFdPUksg
SSdtIHRyeWluZyB0byByZXBsYWNlIHRoZSBvbGRlciBVYnVudHUgc2hpcHBlZCBtdWx0aXBhdGgt
dG9vbHMgd2l0aAo+IHRoZQo+IHVwc3RyZWFtIG9uZS4gVGhlbiwgZ2l2ZW4gYSBzeXN0ZW0gd2l0
aCB0aGUgdXBzdHJlYW0gYG11bHRpcGF0aC10b29sc2AKPiBwcmVpbnN0YWxsZWQgYW5kIGBtdWx0
aXBhdGhkYCBydW5uaW5nLCBub25lIG9mIHRoZSBgbXVsdGlwYXRoIC1sYCBvcgo+IGBtdWx0aXBh
dGgKPiAtbGxgIHNob3cgb3V0cHV0LiBUaGVuLCBpZiBJIGRvd25ncmFkZSBgbXVsdGlwYXRoLXRv
b2xzYCB0byB0aGUgb25lIGZyb20KPiBVYnVudHUKPiByZXBvc2l0b3J5IGFuZCByZXN0YXJ0IGBt
dWx0aXBhdGhkYCwgZGV2aWNlcyBkbyBhcHBlYXIuCj4gCj4gVGhlbiBpdCBnZXRzIHdlaXJkOiBp
ZiBJIHVwZ3JhZGUgYG11bHRpcGF0aC10b29sc2AgYmFjayB0byB0aGUgbGF0ZXN0IG9uZQo+IHVw
c3RyZWFtLCBhbmQgcmVib290LCBkZXZpY2VzIGFyZSBzdGlsbCB0aGVyZSEgSXQgc3RhcnRzIHdv
cmtpbmchCj4gCj4gQXQgdGhpcyBwb2ludCBJIGZvdW5kIHRoZSBgL2V0Yy9tdWx0aXBhdGgvd3dp
ZHNgIHdoaWNoIG1pZ2h0IGJlIHRoZSByZWFzb24uIEkKPiBwcmVzdW1lIGBtdWx0aXBhdGhkYCBw
dXRzIGRldmljZXMgdGhlcmUgdW5kZXIgc29tZSBjb25kaXRpb25zLiBCdXQgd2hlcmUgY2FuIEkK
PiBzZWUgaG93IGl0IGRlY2lkZXMgd2hldGhlciB0byB3b3JrIHdpdGggZGV2aWNlcyBvciB0byBp
Z25vcmUgdGhlbT8gSSdtIGxvb2tpbmcKPiB0aHJvdWdoIC12NSBzdGFydHVwIGxvZ3Mgd2hlbiBp
dCdzIHdvcmtpbmcgYW5kIHdoZW4gaXQgZG9lc24ndCwgdGhlcmUncyBhIGxvdAo+IG9mCj4gb3V0
cHV0LCBidXQgaXQncyBoYXJkIHRvIGBkaWZmYCB0aGUgb2xkZXIgKHdvcmtpbmcpIGFuZCB0aGUg
bmV3ZXIgKG5vdAo+IHdvcmtpbmcpCj4gb3V0cHV0IOKAlCBhIGxvdCBvZiBzdHlsZSBjaGFuZ2Vz
LiBFbnRyaWVzIEkgZmluZCBzdXNwaWNpb3VzIGFyZSByZXBlYXRlZCBpbgo+IGJvdGgKPiBjYXNl
cy4KPiAKPiBJIGZpZ3VyZWQsIGl0IG1pZ2h0IGFzayBoZXJlIGZvciBwb2ludGVycywgaXMgdGhl
cmUgc29tZXRoaW5nIHNwZWNpZmljIHRvIGxvb2sKPiBmb3I/CgpJIGZvdW5kIHRoZSBwcm9ibGVt
LCBhbmQgaW4gcmV0cm9zcGVjdGl2ZSBJIGRvdWJ0IHRoZSBsb2dzIHdvdWxkIGhhdmUgaGVscGVk
IG1lLgoKVGhlIHByb2JsZW0gd2FzIHRoYXQgd2UgcmVsaWVkIG9uIGRlZmF1bHQgdmFsdWUgb2Yg
YGZpbmRfbXVsdGlwYXRoc2AsIGJ1dCB0aGVuCnVwc3RyZWFtIGNoYW5nZWQgaXQsIHdoaWNoIG1h
ZGUgZXZlcnl0aGluZyBzaWxlbnRseSBicmVhayBvbiB1cGRhdGUuIE1heSBJCmdydW50OiB0aGF0
IHVwc3RyZWFtIGNoYW5nZSB3YXMgYSB0ZXJyaWJsZSBkZWNpc2lvbiwgYmVjYXVzZSBpZiB5b3Ug
aGF2ZSBhCnN5c3RlbSB3aXRoICJ3d2lkcyIgZmlsZSwgaXQgd2lsbCBhY3R1YWxseSBjb250aW51
ZSB3b3JraW5n4oCmIEZvciBzb21lIHRpbWUuClVudGlsIHByb2JsZW1zIHdpdGggbWlzc2luZyBk
ZXZpY2VzIHdvdWxkIHNpbGVudGx5IGNyZWVwIHVwIG9uIHlvdS4gV2UgZ290IHZlcnkKbHVja3kg
aGVyZSwgc2luY2Ugb3VyIGluZnJhc3RyY3R1cmUgYWxsb3dlZCB0byBzcG90IHRoYXQgaW1tZWRp
YXRlbHkuCgpBbnl3YXksIHdoYXQncyBkb25lIGlzIGRvbmUsIGFuZCB0aGUgY2hhbmdlIGlzIGRh
dGVkIGJ5IDIwMTggeWVhciwgc28gb2ggd2VsbOKApgpDJ2VzdCBsYSB2aWUuCgpTbywgYW55d2F5
LCByZXR1cm5pbmcgdG8gbXkgb3JpZ2luYWwgcXVlc3Rpb246IEknbSBub3Qgc3VyZSBJIGhhdmUg
aGFkIGFueQpjaGFuY2UgdG8gZmlndXJlIHRoYXQgcHJvYmxlbSBvdXQgZnJvbSB0aGUgbG9ncy4g
SSBtZWFuLCB0aGUgbG9ncyBkbyBtZW50aW9uCnNvbWV0aGluZyBsaWtlICJkZXZpY2UgZm9vIHdh
cyBza2lwcGVkIGFzIGl0J3Mgbm90IGluIHd3aWRzIGZpbGUiLCBidXQgYXQgdGhlCnNhbWUgdGlt
ZSBJIGtub3cgdGhhdCB0aGUgb2xkZXIgdmVyc2lvbiByZWNyZWF0ZXMgdGhlIHd3aWRzIGZpbGUu
IEFuZCBhY3R1YWxseSwKZXZlbiB0aGUgYHd3aWRzYCBmaWxlIHNheSBhdCB0aGUgdG9wIGEgIlRo
aXMgZmlsZSBpcyBhdXRvbWF0aWNhbGx5IGdlbmVyYXRlZCBhbmQKdGhvdSBzaGFsdCBub3QgdG91
Y2ggaXQiLiBTbyB0aGVyZSdzIG5vIHJlYXNvbiB0byBhc3N1bWUgd3dpZHMgZmlsZSBoYXMgYW55
dGhpbmcKdG8gZG8gd2l0aCB0aGUgcHJvYmxlbSB3aGF0c29ldmVyLgoKSW4gbXkgY2FzZSB3aGF0
IGhlbHBlZCB3YXMgdGhlIGdvb2Qgb2wnIGZyaWVuZCBnaXQtYmlzZWN0LgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

