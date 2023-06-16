Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA9DCEB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Jun 2023 20:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686948264;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=711yLe1SkgED7cF3mwRzdOpvjBodye5fs7cT6BOMmOs=;
	b=Y4NP0djl5slSNqxmLnv7ey+e7CKTniAgfS/Sha8NJsjXAuDVH08obhgQAU5I54DbktD7c7
	4/pEJIaCIWVCoos24Bdn0A17qWVlzP2AIFHHG4gBbitOge8qMCL01DeRUzfgY9HoHDwXGU
	3CDpV/mFP+Zhf4HTdYbVuu1qgJ9Fsz8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-RRqBslr-PMGhNypjk6WIaQ-1; Fri, 16 Jun 2023 16:44:23 -0400
X-MC-Unique: RRqBslr-PMGhNypjk6WIaQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 501A9803DBE;
	Fri, 16 Jun 2023 20:44:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57CFB17586;
	Fri, 16 Jun 2023 20:44:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2EF801946594;
	Fri, 16 Jun 2023 20:44:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 36AAB1946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Jun 2023 20:44:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 273B5141510A; Fri, 16 Jun 2023 20:44:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F64C1415102
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 20:44:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1ECE4185A78F
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 20:44:02 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-vE6y9bNoNtSjouKDAo4mXw-1; Fri, 16 Jun 2023 16:44:00 -0400
X-MC-Unique: vE6y9bNoNtSjouKDAo4mXw-1
Received: by mail-pj1-f48.google.com with SMTP id
 98e67ed59e1d1-25ea1b6b659so807555a91.2
 for <dm-devel@redhat.com>; Fri, 16 Jun 2023 13:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686948239; x=1689540239;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=fDBvN/G/XVt3AApxLKnljmBEnEGXzbOrk5RIvU0800k=;
 b=OKc7CtnhI+rSQ6QutQaGOvGeOqj8/6hwIoTwKJLfoXHBQJdWqfWJL7rikpE5TCQ9m5
 SSL4U4jOJMVHhnB386xUiCBWWnFqIyNdbq7iIBRlRIUgrtOxNltfFXRE1qIot8bn2kxC
 m3duZN1aj1Vj2sz8b1HwwLAwj2sVAEWpzu1kG5g+xSLqnFX7AK7U0wK8ThRr9jYIE8x9
 +0as495M6cW2I7f+cgpk9Xit9WOoaRy/370WpeLtTwDrRPY/GJQK1L9Hf2nDXlf0VIrg
 iJgbH1vux1v3UlqwmtN2kg38Pv/ASIJr9wBnSJjyO70yYOsyZ4b0Sw0xeG76x3gjrzdc
 yIHA==
X-Gm-Message-State: AC+VfDzZjN1b6c/GSMZFUmSEWML4VgcpMBpR6cERkitCjrr1KrydkufQ
 VvQAQ8UDZ7hOacjuxqn9M+g3N6HRwxO96qVq5tbMDCz7
X-Google-Smtp-Source: ACHHUZ6vCphMcKJWK1gJZ7ngm1JBbk4jT1Id9QUhaOcEJ/q9NyTwTydMEqB9p86QIbV5KXPL+dNIYBk5HMxmMtiivx8=
X-Received: by 2002:a17:90a:b38e:b0:25b:b3f3:81d9 with SMTP id
 e14-20020a17090ab38e00b0025bb3f381d9mr2507846pjr.11.1686948239208; Fri, 16
 Jun 2023 13:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+heB57N4StY-Nhs+QV+Z8UkD8x8K+C1T-NVbsz55fT+kfg@mail.gmail.com>
 <20230616183310.66b9734c@mobian.usb.local>
In-Reply-To: <20230616183310.66b9734c@mobian.usb.local>
From: Marc Smith <msmith626@gmail.com>
Date: Fri, 16 Jun 2023 16:43:47 -0400
Message-ID: <CAH6h+he=Q+5bV777PDyCsGpxbd68kSt5R6ORqu3y9my+=P=ysw@mail.gmail.com>
To: Lukas Straub <lukasstraub2@web.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] dm-writecache - Unexpected Data After Host Crash
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBKdW4gMTYsIDIwMjMgYXQgMTI6MzPigK9QTSBMdWthcyBTdHJhdWIgPGx1a2Fzc3Ry
YXViMkB3ZWIuZGU+IHdyb3RlOgo+Cj4gT24gV2VkLCAxNCBKdW4gMjAyMyAxNzoyOToxNyAtMDQw
MAo+IE1hcmMgU21pdGggPG1zbWl0aDYyNkBnbWFpbC5jb20+IHdyb3RlOgo+Cj4gPiBIaSwKPiA+
Cj4gPiBJJ20gdXNpbmcgZG0td3JpdGVjYWNoZSB2aWEgJ2x2bWNhY2hlJyBvbiBMaW51eCA1LjQu
MjI5ICh2YW5pbGxhCj4gPiBrZXJuZWwub3JnIHNvdXJjZSkuIEkndmUgYmVlbiB0ZXN0aW5nIG15
IHN0b3JhZ2Ugc2VydmVyIC0tIEknbSB1c2luZyBhCj4gPiBjb3VwbGUgTlZNZSBkcml2ZXMgaW4g
YW4gTUQgUkFJRDEgYXJyYXkgdGhhdCBpcyB0aGUgY2FjaGUgKGZhc3QpCj4gPiBkZXZpY2UsIGFu
ZCB1c2luZyBhIDEyLWRyaXZlIE1EIFJBSUQ2IGFycmF5IGFzIHRoZSBvcmlnaW4gKGJhY2tpbmcp
Cj4gPiBkZXZpY2UuCj4gPgo+ID4gSSBub3RpY2VkIHRoYXQgd2hlbiB0aGUgaG9zdCBjcmFzaGVz
IChwb3dlciBsb3NzLCBmb3JjZWZ1bGx5IHJlc2V0LAo+ID4gZXRjLikgaXQgc2VlbXMgdGhlIGNh
Y2hlZCAodmlhIGRtLXdyaXRlY2FjaGUpIExWTSBsb2dpY2FsIHZvbHVtZSBkb2VzCj4gPiBub3Qg
Y29udGFpbiB0aGUgYml0cyBJIGV4cGVjdC4gT3IgcGVyaGFwcyBJJ20gbWlzc2luZyBzb21ldGhp
bmcgaW4gaG93Cj4gPiBJIHVuZGVyc3RhbmQvZXhwZWN0IGRtLXdyaXRlY2FjaGUgdG8gZnVuY3Rp
b24uLi4KPiA+Cj4gPiBJIGNoYW5nZSB0aGUgYXV0by1jb21taXQgc2V0dGluZ3MgdG8gbGFyZ2Vy
IHZhbHVlcyBzbyB0aGUgZGF0YSBvbiB0aGUKPiA+IGNhY2hlIGRldmljZSBpcyBub3QgZmx1c2hl
ZCB0byB0aGUgb3JpZ2luIGRldmljZToKPiA+ICMgbHZjaGFuZ2UgLS1jYWNoZXNldHRpbmdzICJh
dXRvY29tbWl0X2Jsb2Nrcz0xMDAwMDAwMDAwMDAwIgo+ID4gLS1jYWNoZXNldHRpbmdzICJhdXRv
Y29tbWl0X3RpbWU9MzYwMDAwMCIgZGV2XzFfZGVmYXVsdC9zeXNfZGV2XzAxCj4gPgo+ID4gVGhl
biBwb3B1bGF0ZSB0aGUgc3RhcnQgb2YgdGhlIGRldmljZSAoY2FjaGVkIExWKSB3aXRoIHplcm9z
Ogo+ID4gIyBkZCBpZj0vZGV2L3plcm8gb2Y9L2Rldi9kZXZfMV9kZWZhdWx0L3N5c19kZXZfMDEg
YnM9MU0gY291bnQ9MTAgb2ZsYWc9ZGlyZWN0Cj4KPiBNaXNzaW5nIGZsdXNoL2ZzeW5jLgo+Cj4g
PiBGb3JjZSBhIGZsdXNoIGZyb20gdGhlIGNhY2hlIGRldmljZSB0byB0aGUgYmFja2luZyBkZXZp
Y2UgKGFsbCB6ZXJvJ3MKPiA+IGluIHRoZSBmaXJzdCAxMCBNaUIpOgo+ID4gIyBkbXNldHVwIG1l
c3NhZ2UgZGV2XzFfZGVmYXVsdC1zeXNfZGV2XzAxIDAgZmx1c2gKPiA+Cj4gPiBOb3cgd3JpdGUg
YSBkaWZmZXJlbnQgcGF0dGVybiB0byB0aGUgZmlyc3QgMTAgTWlCOgo+ID4gIyBmaW8gLS1icz0x
bSAtLWRpcmVjdD0xIC0tcnc9d3JpdGUgLS1idWZmZXJfcGF0dGVybj0weGZmCj4gPiAtLWlvZW5n
aW5lPWxpYmFpbyAtLWlvZGVwdGg9MSAtLW51bWpvYnM9MSAtLXNpemU9MTBNCj4gPiAtLW91dHB1
dC1mb3JtYXQ9dGVyc2UgLS1uYW1lPS9kZXYvZGV2XzFfZGVmYXVsdC9zeXNfZGV2XzAxCj4KPiBB
Z2Fpbiwgbm8gZmx1c2gvZnN5bmMgaXMgaXNzdWVkLgoKSSdtIGRvaW5nIGRpcmVjdCBJL08gc28g
SSB3YXNuJ3QgYW50aWNpcGF0aW5nIHRoZSBuZWVkIGZvciBhIGZsdXNoL2ZzeW5jLgoKCj4KPiA+
IEFuZCB0aGVuIGluZHVjZSBhIHJlc2V0Ogo+ID4gIyBlY2hvIGIgPiAvcHJvYy9zeXNycS10cmln
Z2VyCj4gPgo+ID4gTm93IGFmdGVyIHRoZSBzeXN0ZW0gYm9vdHMgYmFjayB1cCwgYXNzZW1ibGUg
dGhlIFJBSUQgYXJyYXlzIGFuZAo+ID4gYWN0aXZhdGUgdGhlIFZHLCB0aGVuIGV4YW1pbmUgdGhl
IGRhdGE6Cj4gPiAjIHZnY2hhbmdlIC1heSBkZXZfMV9kZWZhdWx0Cj4gPiAjIGRkIGlmPS9kZXYv
ZGV2XzFfZGVmYXVsdC9zeXNfZGV2XzAxIGJzPTFNIGlmbGFnPWRpcmVjdCBjb3VudD0xMAo+ID4g
c3RhdHVzPW5veGZlciB8IG9kIC10IHgyCj4gPiAwMDAwMDAwIDAwMDAgMDAwMCAwMDAwIDAwMDAg
MDAwMCAwMDAwIDAwMDAgMDAwMAo+ID4gKgo+ID4gMTArMCByZWNvcmRzIGluCj4gPiAxMCswIHJl
Y29yZHMgb3V0Cj4gPiA1MDAwMDAwMAo+ID4KPiA+Cj4gPiBTbyBJJ20gZXhwZWN0aW5nIGFsbCAi
ZmZmZiIgaW4gdGhlIGZpcnN0IDEwIE1pQiwgYnV0IGluc3RlYWQsIEknbQo+ID4gZ2V0dGluZyB3
aGF0J3Mgb24gdGhlIG9yaWdpbiBkZXZpY2UsIHplcm9zIChub3Qgd2hhdCB3YXMgd3JpdHRlbiB0
bwo+ID4gdGhlIGNhY2hlIGRldmljZSkuCj4gPgo+ID4gT2J2aW91c2x5IGluIGEgY3Jhc2ggc2Nl
bmFyaW8gKHBvd2VyIGxvc3MsIHJlc2V0LCBwYW5pYywgZXRjLikgdGhlCj4gPiBkaXJ0eSBkYXRh
IGluIHRoZSBjYWNoZSB3b24ndCBiZSBmbHVzaGVkIHRvIHRoZSBvcmlnaW4gZGV2aWNlLAo+ID4g
aG93ZXZlciwgSSB3YXMgZXhwZWN0aW5nIHdoZW4gdGhlIERNIGRldmljZSBzdGFydGVkIG9uIHRo
ZSBzdWJzZXF1ZW50Cj4gPiBib290ICh2aWEgYWN0aXZhdGluZyB0aGUgVkcpIHRoYXQgYWxsIG9m
IHRoZSBkaXJ0eSBkYXRhIHdvdWxkIGJlCj4gPiBwcmVzZW50IC0tIGl0IHNlZW1zIGxpa2UgaXQg
aXMgbm90Lgo+ID4KPiA+Cj4gPiBUaGFua3MgZm9yIGFueSBpbmZvcm1hdGlvbi9hZHZpY2UsIGl0
J3MgZ3JlYXRseSBhcHByZWNpYXRlZC4KPgo+IFRoaXMgaXMgdGhlIGV4cGVjdGVkIGJlaGF2aW9y
LiBJZiB5b3UgZG9uJ3QgaXNzdWUgZmx1c2hlcywgbm8gZ3VhcmFudGVlcwo+IGFyZSBtYWRlIGFi
b3V0IHRoZSBkdXJhYmlsaXR5IG9mIHRoZSBuZXdseSB3cml0dGVuIGRhdGEuCgpJbnRlcmVzdGlu
Zy4uLiB3YXMgbm90IGV4cGVjdGluZyB0aGF0LiBJIGd1ZXNzIEkgd2FzIHRocm93biBieSB0aGUg
dXNlCm9mIHBlcnNpc3RlbnQgbWVkaWEgKFNTRCAvIFBNRU0pLiBJZiBkbS13cml0ZWNhY2hlIGhh
cyBkaXJ0eSBkYXRhIHRoYXQKaXNuJ3QgZmx1c2hlZCB0byB0aGUgb3JpZ2luIGRldmljZSB5ZXQg
KG5vIGZsdXNoL2ZzeW5jIGZyb20gdGhlCmFwcGxpY2F0aW9uKSBhbmQgd2UgbG9zZSBwb3dlciwg
dGhlIGRhdGEgaXMgZ29uZS4uLiB3aHkgbm90IGp1c3QgdXNlCnZvbGF0aWxlIFJBTSBmb3IgdGhl
IGNhY2hlIHRoZW4/CgpJJ20gc3RpbGwgZXhwZXJpbWVudGluZyBhbmQgbGVhcm5pbmcgdGhlIGNv
ZGUsIGJ1dCBmcm9tIHdoYXQgSSd2ZSBzZWVuCnNvIGZhciwgdGhlIGRpcnR5IGRhdGEgYmxvY2tz
IGRvIHJlc2lkZSBvbiB0aGUgU1NEL1BNRU0gZGV2aWNlLCBpdCdzCmp1c3QgdGhlIGVudHJ5IG1h
cCB0aGF0IGxpdmVzIGluIG1ldGFkYXRhIHRoYXQgaXNuJ3QgdXAtdG8tZGF0ZSBpZiBhCmNyYXNo
IC8gcG93ZXIgbG9zcyBvY2N1cnMuIEkgYXNzdW1lIHdyaXRpbmcgb3V0IGFsbCBvZiB0aGUgbWV0
YWRhdGEgb24KZWFjaCBjYWNoZSBjaGFuZ2Ugd291bGQgYmUgdmVyeSBleHBlbnNpdmUgaW4gdGVy
bXMgb2YgSS9PIHBlcmZvcm1hbmNlLgoKCj4KPiA+Cj4gPiAtLU1hcmMKPiA+Cj4gPiAtLQo+ID4g
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0Cj4gPiBkbS1kZXZlbEByZWRoYXQuY29tCj4gPiBodHRwczov
L2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCj4gPgo+CgotLQpk
bS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

