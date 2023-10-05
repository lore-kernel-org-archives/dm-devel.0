Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3DEE936ED
	for <dm-devel@archiver.kernel.org>; Thu,  5 Oct 2023 04:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696478435;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kSRSj2y6sUsWOWpJKTRiy60RIh2x/zYxC3tS2YvPbDA=;
	b=dtt76QfJ2MFDx6QYYNeYC00TUtwkzZCTTPQw91Ljn0geqylzGUQ85M/n5Bi7aTu6A5fn2p
	RSA7D2Sl1ilnpMzJ4RrUfzwgig8UlqKx8OXYbFzIRvbluVWLxwLnmV9jUOCC4VPJcYN8Fj
	0xNti4VWbQFOr2O178OQUNwyA/Rg5Q8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-vqME_E67OqyDtKcqwAGZpg-1; Thu, 05 Oct 2023 00:00:32 -0400
X-MC-Unique: vqME_E67OqyDtKcqwAGZpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4548D858280;
	Thu,  5 Oct 2023 04:00:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A78DE140E950;
	Thu,  5 Oct 2023 04:00:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 620681946597;
	Thu,  5 Oct 2023 04:00:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD2B2194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 04:00:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD45A140E953; Thu,  5 Oct 2023 04:00:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A5D94140E950
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 04:00:28 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A318803D6A
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 04:00:28 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-46-A3a9er_NO1GmdAZLQtjOAA-1; Thu,
 05 Oct 2023 00:00:26 -0400
X-MC-Unique: A3a9er_NO1GmdAZLQtjOAA-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by sin.source.kernel.org (Postfix) with ESMTP id BA1BDCE200D;
 Thu,  5 Oct 2023 04:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099EFC433CC;
 Thu,  5 Oct 2023 04:00:22 +0000 (UTC)
Received: by mail-lj1-f179.google.com with SMTP id
 38308e7fff4ca-2c1807f3400so6858431fa.1; 
 Wed, 04 Oct 2023 21:00:21 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw90xUp5LSVBBRMA68iHoxctZzM6xH10oooEUf5mNk5t89IiwP0
 1O32dO51mk3qiGBtfbmjN1Xhrqyrci0llTVSdio=
X-Google-Smtp-Source: AGHT+IFrweThNcOJampPvgPU+EwndkFznX8xeRJ6i/Tv4bnoHj/MpBOiktX/l28+v82Jez83Uz14NbrE9GegQdAU6UI=
X-Received: by 2002:a2e:b4b3:0:b0:2c1:86da:3f61 with SMTP id
 q19-20020a2eb4b3000000b002c186da3f61mr116977ljm.9.1696478420086; Wed, 04 Oct
 2023 21:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <20230928061543.1845742-4-yukuai1@huaweicloud.com>
 <CAPhsuW4tQ9A+ddpxGhfza3WSdkL+FXmS-4NLUUN7MNk0TOY0WA@mail.gmail.com>
 <0ae441ba-68db-b823-b48c-76e953d22067@huaweicloud.com>
In-Reply-To: <0ae441ba-68db-b823-b48c-76e953d22067@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Oct 2023 21:00:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6ru-Chofq8ki6Xh9U0utH6+_mo0dd3Ty8fZPHGtJ1xvQ@mail.gmail.com>
Message-ID: <CAPhsuW6ru-Chofq8ki6Xh9U0utH6+_mo0dd3Ty8fZPHGtJ1xvQ@mail.gmail.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH -next v3 03/25] md: add new helpers to
 suspend/resume array
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBPY3QgNCwgMjAyMyBhdCA3OjU54oCvUE0gWXUgS3VhaSA8eXVrdWFpMUBodWF3ZWlj
bG91ZC5jb20+IHdyb3RlOgo+Cj4gSGksCj4KPiDlnKggMjAyMy8wOS8yOSAyOjQ1LCBTb25nIExp
dSDlhpnpgZM6Cj4gPiBPbiBXZWQsIFNlcCAyNywgMjAyMyBhdCAxMToyMuKAr1BNIFl1IEt1YWkg
PHl1a3VhaTFAaHVhd2VpY2xvdWQuY29tPiB3cm90ZToKPiA+Pgo+ID4+IEZyb206IFl1IEt1YWkg
PHl1a3VhaTNAaHVhd2VpLmNvbT4KPiA+Pgo+ID4+IEFkdmFudGFnZXMgZm9yIG5ldyBhcGlzOgo+
ID4+ICAgLSByZWNvbmZpZ19tdXRleCBpcyBub3QgcmVxdWlyZWQ7Cj4gPj4gICAtIHRoZSB3ZWly
ZCBsb2dpY2FsIHRoYXQgc3VzcGVuZCBhcnJheSBob2xkICdyZWNvbmZpZ19tdXRleCcgZm9yCj4g
Pj4gICAgIG1kZGV2X2NoZWNrX3JlY292ZXJ5KCkgdG8gdXBkYXRlIHN1cGVyYmxvY2sgaXMgbm90
IG5lZWRlZDsKPiA+PiAgIC0gdGhlIHNwZWNhaWwgaGFuZGxpbmcsICdwZXJzLT5wcmVwYXJlX3N1
c3BlbmQnLCBmb3IgcmFpZDQ1NiBpcyBub3QKPiA+PiAgICAgbmVlZGVkOwo+ID4+ICAgLSBJdCdz
IHNhZmUgdG8gYmUgY2FsbGVkIGF0IGFueSB0aW1lIG9uY2UgbWRkZXYgaXMgYWxsb2NhdGVkLCBh
bmQgaXQncwo+ID4+ICAgICBkZXNpZ25lZCB0byBiZSB1c2VkIGZyb20gc2xvdyBwYXRoIHdoZXJl
IGFycmF5IGNvbmZpZ3VyYXRpb24gaXMgY2hhbmdlZDsKPiA+PiAgIC0gdGhlIG5ldyBoZWxwZXJz
IGlzIGRlc2lnbmVkIHRvIGJlIGNhbGxlZCBiZWZvcmUgbWRkZXZfbG9jaygpLCBoZW5jZQo+ID4+
ICAgICBpdCBzdXBwb3J0IHRvIGJlIGludGVycnVwdGVkIGJ5IHVzZXIgYXMgd2VsbC4KPiA+Pgo+
ID4+IFNpZ25lZC1vZmYtYnk6IFl1IEt1YWkgPHl1a3VhaTNAaHVhd2VpLmNvbT4KPiA+PiAtLS0K
PiA+PiAgIGRyaXZlcnMvbWQvbWQuYyB8IDEwMiArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0KPiA+PiAgIGRyaXZlcnMvbWQvbWQuaCB8ICAgMyArKwo+ID4+
ICAgMiBmaWxlcyBjaGFuZ2VkLCAxMDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiA+
Pgo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21kL21kLmMgYi9kcml2ZXJzL21kL21kLmMKPiA+
PiBpbmRleCBlNDYwYjM4MDE0M2QuLmEwNzVkMDNkMDNkMyAxMDA2NDQKPiA+PiAtLS0gYS9kcml2
ZXJzL21kL21kLmMKPiA+PiArKysgYi9kcml2ZXJzL21kL21kLmMKPiA+PiBAQCAtNDQzLDEyICs0
NDMsMjIgQEAgdm9pZCBtZGRldl9zdXNwZW5kKHN0cnVjdCBtZGRldiAqbWRkZXYpCj4gPj4gICAg
ICAgICAgICAgICAgICAgICAgICAgIGxvY2tkZXBfaXNfaGVsZCgmbWRkZXYtPnJlY29uZmlnX211
dGV4KSk7Cj4gPj4KPiA+PiAgICAgICAgICBXQVJOX09OX09OQ0UodGhyZWFkICYmIGN1cnJlbnQg
PT0gdGhyZWFkLT50c2spOwo+ID4+IC0gICAgICAgaWYgKG1kZGV2LT5zdXNwZW5kZWQrKykKPiA+
PiArCj4gPj4gKyAgICAgICAvKiBjYW4ndCBjb25jdXJyZW50IHdpdGggX19tZGRldl9zdXNwZW5k
KCkgYW5kIF9fbWRkZXZfcmVzdW1lKCkgKi8KPiA+PiArICAgICAgIG11dGV4X2xvY2soJm1kZGV2
LT5zdXNwZW5kX211dGV4KTsKPiA+PiArICAgICAgIGlmIChtZGRldi0+c3VzcGVuZGVkKyspIHsK
PiA+PiArICAgICAgICAgICAgICAgbXV0ZXhfdW5sb2NrKCZtZGRldi0+c3VzcGVuZF9tdXRleCk7
Cj4gPj4gICAgICAgICAgICAgICAgICByZXR1cm47Cj4gPgo+ID4gQ2FuIHdlIG1ha2UgbWRkZXYt
PnN1c3BlbmRlZCBhdG9taWNfdCwgYW5kIHVzZSBhdG9taWNfaW5jX3JldHVybigpCj4gPiBoZXJl
Pwo+Cj4gJ3N1c3BlbmRfbXV0ZXgnIGlzIG5lZWRlZCwgYmVjYXVzZSBjb25jdXJyZW50IGNhbGxl
ciBvZgo+IG1kZGV2X3N1c3BlbmQoKSBzaG91bmQgYmUgb3JkZXJlZCwgdGhleSBuZWVkIHRvIHdh
aXQgZm9yIHRoZSBmaXJzdAo+IG1kZGV2X3N1c3BlbmQoKSB0byBiZSBkb25lLgo+Cj4gVXBkYXRp
bmcgc3VzcGVuZGVkIGlzIHByb3RlY3RlZCBieSAnc3VzcGVuZF9tdXRleCcgaW4gdGhlIG5ldyBh
cGksIHNvIEkKPiB0aGluayBpdCdzIG5vdCBuZWNlc3NhcnkgdG8gdXNlIGF0b21pYywgV1JJVEUv
UkVBRF9PTkNFKCkgc2hvdWxkIGJlCj4gZW5vdWdoLgoKVGhhbmtzIGZvciB0aGUgZXhwbGFuYXRp
b24uCgpTb25nCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpo
dHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

