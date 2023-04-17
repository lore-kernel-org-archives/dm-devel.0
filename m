Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87102C77B76
	for <dm-devel@archiver.kernel.org>; Mon, 17 Apr 2023 20:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681762609;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IE3oBgl6GWMFxR/3X3IBhRWLRgB1mE9MuoqGsNceM7A=;
	b=Hl3Pbpz6ZtPeyFhUE65ZaKevgxDApmNGC7SeBr/tEFdnO4DhHI4zkFBgf96n+PzqsRHhpI
	IIbmO4Kx8BuRGoeX0t9LcJKNh3o4ch2iJieqOcuQgYSxpwohzcmCeqrq34N0eJyzi/pYky
	LCME+CuCdaUfNm8kN5cOFCRtmQFhDWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-BW7BU1LVOVKzsXnCDhXMjg-1; Mon, 17 Apr 2023 16:16:48 -0400
X-MC-Unique: BW7BU1LVOVKzsXnCDhXMjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D80E85C6EA;
	Mon, 17 Apr 2023 20:16:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C607E2027062;
	Mon, 17 Apr 2023 20:16:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 80C25194658D;
	Mon, 17 Apr 2023 20:16:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 42CFF1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Apr 2023 20:16:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 251B940CFD3A; Mon, 17 Apr 2023 20:16:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DCA740CE2D4
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 20:16:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0309E1C0A589
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 20:16:43 +0000 (UTC)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com
 [209.85.128.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-yoFv9XH3PHOpoGU6bLu2Bw-1; Mon, 17 Apr 2023 16:16:41 -0400
X-MC-Unique: yoFv9XH3PHOpoGU6bLu2Bw-1
Received: by mail-yw1-f170.google.com with SMTP id
 00721157ae682-54fe3cd445aso125522957b3.5
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 13:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681762600; x=1684354600;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=mkFM4OddDI3MzXQTdAgqfF3VU3F/+LgzOjoA+7s8XA4=;
 b=LekqEi1hymEaFhWgWSNDu3nnX6Ub4usVnXNPggRqocut1Dt0CeFoVt5fBbmaTn2jdp
 UKSE/GWL0k5eHCldO5FjMC3AV6Sa7VwodIRtA12ksjS0EG2JqpoDqxzx/JQJVNokgBv1
 2a3Vtm1U6wT2pP5d0gqxD/zxyn5EXQOz4tIA2LKdam3gbx2Ox5RKJ+hLgiaMoMxyHjXq
 EsL7namHcVvFXlLzIQ8HiVBpht0qG5/uR5rzuHsLWydUSOecGN4MYwlbecbH902Ug7kQ
 1EcjKRLvcqQe2SEIbcRY8ic8i98z2uZXrZTYn8pQ8GLcRcpUYQAr3wqOsYl+hiyj6Ql5
 4VXg==
X-Gm-Message-State: AAQBX9cKxK8sLtvx71TgrYg2RFY2hmE2Zx5zk5WKiN/Pzg8SyD2uFOCO
 THUfOPLcDfdGqeHl/DiVRQtI5+y8qPm1V61frLyy
X-Google-Smtp-Source: AKy350ZxQlOfbob70cyzh//3Qo4gX/RJVSVzb07xLMzIeYlrCU36AjFdx5P2s2Fo1lBjmj4URw4Qp0a1MdAC8VUyDYc=
X-Received: by 2002:a81:4524:0:b0:54f:aa4b:100c with SMTP id
 s36-20020a814524000000b0054faa4b100cmr9804160ywa.8.1681762600389; Mon, 17 Apr
 2023 13:16:40 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
 <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 17 Apr 2023 16:16:29 -0400
Message-ID: <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH v9 05/16] ipe: add userspace interface
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 dm-devel@redhat.com, corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBcHIgMTcsIDIwMjMgYXQgMjowNuKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4gT24gVGh1LCBBcHIgMTMsIDIwMjMgYXQgMDI6NDU6MDdQTSAt
MDQwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+IE9uIFdlZCwgQXByIDEyLCAyMDIzIGF0IDc6MzY/
Pz9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgo+ID4gPiBPbiBU
dWUsIEFwciAxMSwgMjAyMyBhdCAwNTo0NTo0MVBNIC0wNDAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+
ID4gPiA+IE9uIE1vbiwgQXByIDEwLCAyMDIzIGF0IDM6MTA/Pz9QTSBGYW4gV3UgPHd1ZmFuQGxp
bnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgo+ID4gPiA+ID4gT24gVGh1LCBNYXIgMDIsIDIwMjMg
YXQgMDI6MDQ6NDJQTSAtMDUwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+ID4gPiA+ID4gT24gTW9u
LCBKYW4gMzAsIDIwMjMgYXQgNTo1OD8/P1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWljcm9zb2Z0
LmNvbT4gd3JvdGU6Cj4gPgo+ID4gLi4uCj4gPgo+ID4gPiA+IEkgZ3Vlc3MgdGhpcyBkb2VzIG1h
a2UgbWUgd29uZGVyIGFib3V0IGtlZXBpbmcgYSBub24tYWN0aXZlIHBvbGljeQo+ID4gPiA+IGxv
YWRlZCBpbiB0aGUga2VybmVsLCB3aGF0IHB1cnBvc2UgZG9lcyB0aGF0IHNlcnZlPwo+ID4gPiA+
Cj4gPiA+Cj4gPiA+IFRoZSBub24tYWN0aXZlIHBvbGljeSBkb2Vzbid0IHNlcnZlIGFueXRoaW5n
IHVubGVzcyBpdCBpcyBhY3RpdmF0ZWQuIFVzZXIgY2FuCj4gPiA+IGV2ZW4gZGVsZXRlIGEgcG9s
aWN5IGlmIHRoYXQgaXMgbm8gbG9uZ2VyIG5lZWRlZC4gTm9uLWFjdGl2ZSBpcyBqdXN0IHRoZSBk
ZWZhdWx0Cj4gPiA+IHN0YXRlIHdoZW4gYSBuZXcgcG9saWN5IGlzIGxvYWRlZC4KPiA+ID4KPiA+
ID4gSWYgSVBFIHN1cHBvcnRzIG5hbWVzcGFjZSwgdGhlcmUgaXMgYW5vdGhlciB1c2UgY2FzZSB3
aGVyZSBkaWZmZXJlbnQgY29udGFpbmVycwo+ID4gPiBjYW4gc2VsZWN0IGRpZmZlcmVudCBwb2xp
Y2llcyBhcyB0aGUgYWN0aXZlIHBvbGljeSBmcm9tIGFtb25nIG11bHRpcGxlIGxvYWRlZAo+ID4g
PiBwb2xpY2llcy4gRGV2ZW4gaGFzIHByZXNlbnRlZCBhIGRlbW8gb2YgdGhpcyBkdXJpbmcgTFNT
IDIwMjEuIEJ1dCB0aGlzIGdvZXMKPiA+ID4gYmV5b25kIHRoZSBzY29wZSBvZiB0aGlzIHZlcnNp
b24uCj4gPgo+ID4gRG8geW91IHBsYW4gdG8gYWRkIG5hbWVzcGFjZSBzdXBwb3J0IGF0IHNvbWUg
cG9pbnQgaW4gdGhlCj4gPiBub3QtdG9vLWRpc3RhbnQgZnV0dXJlPyAgSWYgc28sIEknbSBva2F5
IHdpdGgga2VlcGluZyBzdXBwb3J0IGZvcgo+ID4gbXVsdGlwbGUgcG9saWNpZXMsIGJ1dCBpZiB5
b3UgdGhpbmsgeW91J3JlIG9ubHkgZ29pbmcgdG8gc3VwcG9ydCBvbmUKPiA+IGFjdGl2ZSBwb2xp
Y3kgYXQgYSB0aW1lLCBpdCBtaWdodCBiZSBiZXR0ZXIgdG8gcmVtb3ZlIHN1cHBvcnQgZm9yCj4g
PiBtdWx0aXBsZSAoaW5hY3RpdmUpIHBvbGljaWVzLgo+ID4KPiA+IC0tCj4gPiBwYXVsLW1vb3Jl
LmNvbQo+Cj4gQW5vdGhlciBiZW5lZml0IG9mIGhhdmluZyBtdWx0aXBsZSBwb2xpY2llcyBpcyB0
aGF0IGl0IHByb3ZpZGVzIGlzb2xhdGlvbgo+IGJldHdlZW4gZGlmZmVyZW50IHBvbGljaWVzLiBG
b3IgaW5zdGFuY2UsIGlmIHdlIGhhdmUgdHdvIHBvbGljaWVzIG5hbWVkCj4gInBvbGljeV9hIiBh
bmQgInBvbGljeV9iLCIgd2UgY2FuIGVuc3VyZSB0aGF0IG9ubHkgdGVhbSBhIGNhbiB1cGRhdGUg
InBvbGljeV9hLCIKPiBhbmQgb25seSB0ZWFtIGIgY2FuIHVwZGF0ZSAicG9saWN5X2IuIiBUaGlz
IHdheSwgYm90aCB0ZWFtcyBjYW4gdXBkYXRlCj4gdGhlaXIgcG9saWN5IHdpdGhvdXQgYWZmZWN0
aW5nIG90aGVycy4gSG93ZXZlciwgaWYgdGhlcmUgaXMgb25seSBvbmUgcG9saWN5Cj4gaW4gdGhl
IHN5c3RlbSwgYm90aCB0ZWFtcyB3aWxsIGhhdmUgdG8gb3BlcmF0ZSBvbiB0aGUgc2FtZSBwb2xp
Y3ksIG1ha2luZyBpdAo+IGxlc3MgbWFuYWdlYWJsZS4KClRoYXQgb25seSByZWFsbHkgbWF0dGVy
cyBpZiBib3RoIHBvbGljaWVzIGFyZSBhY3RpdmUgYXQgdGhlIHNhbWUgdGltZTsKaWYgb25seSBv
bmUgcG9saWN5IGNhbiBiZSBhY3RpdmUgYXQgb25lIHBvaW50IGluIHRpbWUgdGhlIG9ubHkKcGVy
bWlzc2lvbiB0aGF0IG1hdHRlcnMgaXMgdGhlIG9uZSB3aG8gY2FuIGxvYWQvYWN0aXZhdGUgYSBw
b2xpY3kuCgpBbGxvd2luZyBmb3IgbXVsdGlwbGUgcG9saWNpZXMgY29tcGxpY2F0ZXMgdGhlIGNv
ZGUuICBJZiB0aGVyZSBpcwphbm90aGVyIGZlYXR1cmUgdGhhdCByZXF1aXJlcyBtdWx0aXBsZSBw
b2xpY2llcywgZS5nLiBJUEUgbmFtZXNwYWNlcywKdGhlbiB0aGF0IGlzIG9rYXkuICBIb3dldmVy
LCBpZiB0aGVyZSBpcyBubyBmZWF0dXJlIHdoaWNoIHJlcXVpcmVzCm11bHRpcGxlIGFjdGl2ZSBw
b2xpY2llcywgc3VwcG9ydGluZyBtdWx0aXBsZSBsb2FkZWQgcG9saWNpZXMgb25seQppbmNyZWFz
ZXMgdGhlIHJpc2sgb2YgYW4gZXhwbG9pdGFibGUgYnVnIGluIHRoZSBJUEUgY29kZS4KCj4gQmVz
aWRlcywgcmVtb3ZpbmcgbXVsdGlwbGUgKGluYWN0aXZlKSBwb2xpY2llcyBzdXBwb3J0IHdpbGwK
PiByZW5kZXIgdGhlIHBvbGljeV9uYW1lIGZpZWxkIG1lYW5pbmdsZXNzLCBhbmQgd2Ugc2hvdWxk
IG9ubHkgYXVkaXQgdGhlIHBvbGljeQo+IGhhc2guIEkgYW0gZmluZSBpZiB3ZSBkZWNpZGUgdG8g
Z28gZm9yIHRoZSBzaW5nbGUgcG9saWN5IG9wdGlvbi4KCk9uY2UgYWdhaW4sIEkgdGhpbmsgaXQg
Y29tZXMgYmFjayB0bzogZG8geW91IHN0aWxsIHdhbnQgdG8gc3VwcG9ydCBJUEUKbmFtZXNwYWNl
cyBhdCBzb21lIHBvaW50IGluIHRoZSBmdXR1cmUsIGFuZCBpZiBzbywgd2hlbiBkbyB5b3UgZXhw
ZWN0CnRvIHdvcmsgb24gdGhhdD8KCi0tIApwYXVsLW1vb3JlLmNvbQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

