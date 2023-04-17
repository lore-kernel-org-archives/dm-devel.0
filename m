Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7BDC77B7C
	for <dm-devel@archiver.kernel.org>; Mon, 17 Apr 2023 21:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681767091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EW5C6kIXxze8Ip+n1j+LWSe4b8As2aeHDTi4QL0he2M=;
	b=b6IkzODvXlOtQIluYCo/HGAy+ShBOgCCHsDeI3bH1rGv5v4LYI1pNDD0iqnH63MUwGqxAZ
	VO2ZQspt0jHsWenjB6peZFi1y3/bHHmgIw7UZ9VbKpTxOJJW4P89LyLSRVRVgR+Y6bQD8w
	RQbXCktT3N9JKd5ylazJvcEx9wkfOp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-ZR-mv2Z5M_qDOrCuDMbASA-1; Mon, 17 Apr 2023 17:31:29 -0400
X-MC-Unique: ZR-mv2Z5M_qDOrCuDMbASA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E588B185A78F;
	Mon, 17 Apr 2023 21:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9754D40C6E6F;
	Mon, 17 Apr 2023 21:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 43902194658C;
	Mon, 17 Apr 2023 21:31:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 633601946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Apr 2023 21:31:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1305640C6E70; Mon, 17 Apr 2023 21:31:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BEBB40C6E6E
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 21:31:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3E463C0ED60
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 21:31:24 +0000 (UTC)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com
 [209.85.128.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-JcHAtg_LOGuOxAiLUhcCXA-1; Mon, 17 Apr 2023 17:31:23 -0400
X-MC-Unique: JcHAtg_LOGuOxAiLUhcCXA-1
Received: by mail-yw1-f174.google.com with SMTP id
 00721157ae682-54fbee98814so185289317b3.8
 for <dm-devel@redhat.com>; Mon, 17 Apr 2023 14:31:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681767083; x=1684359083;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=BCzVu2UsKp7hdLDjLx5y43eqwBluLCZhJw8zkmfWK7s=;
 b=JPLIMCtc+EBFakyPTBO1fkE7mtGsWMje6wxyfwOzkGOftTEAL/ec5Jft9rGagihFya
 M6WHj3TVJ/BREs3TELN7ZEyC25yNEDUjYfbm+Jj/aCcEAnwd6rQFZF0dWd0xZZEBRFS9
 t8GZfE0DMba0ney9H8hjeddPmi2rB1znT9LCRtaKHF7lMRyQ/QftLGlmjUxumKwF836p
 PddRUitiGBED79AG6tlhbEtZWS3RQwZGQHHFqLh+X1OR4QSiEptY3ZHukex9NOMcWT/C
 TLH8H1CZZIj2m6tIWijYOZp0UqCm4IO1ZB0L4psaXPYj0GB9nsAOQKlJcgp9HkIyhPRr
 SlhQ==
X-Gm-Message-State: AAQBX9cyIphsRDsPSWjlXtLSjbvBCgKUWwEejbIUaxwAwT3GUx5NpRow
 JlwVARx+px+HU/sCxGgRLkt/Ey6o+MoMgC8+BCrt
X-Google-Smtp-Source: AKy350bgu9ZFLZmYkOlWaVpVvG9J/JdkBbU14XNGAtkoY2ENWGlUCNYD5NN6A3BCb0Ne4rd9gsfKQgsCVLB08+3wRKo=
X-Received: by 2002:a81:c649:0:b0:54f:2b65:a865 with SMTP id
 q9-20020a81c649000000b0054f2b65a865mr10208390ywj.8.1681767082657; Mon, 17 Apr
 2023 14:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
 <20230412233606.GA16658@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhTs3Njfg=1baQ6=58rPLBmyB3cW0R-MfAaEcRF-jAaYBw@mail.gmail.com>
 <20230417180605.GA402@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhSnKbhtgFxOAY7NYZyOkV4kEA0=mVsCyogLBSCJs0r_ig@mail.gmail.com>
 <20230417211826.GA6475@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230417211826.GA6475@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 17 Apr 2023 17:31:11 -0400
Message-ID: <CAHC9VhT9uTYrtEsXUvj5qaTpNL2ix762dE5AzUaSqzas8-frXA@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBcHIgMTcsIDIwMjMgYXQgNToxOOKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4gT24gTW9uLCBBcHIgMTcsIDIwMjMgYXQgMDQ6MTY6MjlQTSAt
MDQwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+IE9uIE1vbiwgQXByIDE3LCAyMDIzIGF0IDI6MDY/
Pz9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgo+ID4gPiBPbiBU
aHUsIEFwciAxMywgMjAyMyBhdCAwMjo0NTowN1BNIC0wNDAwLCBQYXVsIE1vb3JlIHdyb3RlOgo+
ID4gPiA+IE9uIFdlZCwgQXByIDEyLCAyMDIzIGF0IDc6MzY/Pz9QTSBGYW4gV3UgPHd1ZmFuQGxp
bnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgo+ID4gPiA+ID4gT24gVHVlLCBBcHIgMTEsIDIwMjMg
YXQgMDU6NDU6NDFQTSAtMDQwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+ID4gPiA+ID4gT24gTW9u
LCBBcHIgMTAsIDIwMjMgYXQgMzoxMD8/P1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWljcm9zb2Z0
LmNvbT4gd3JvdGU6Cj4gPiA+ID4gPiA+ID4gT24gVGh1LCBNYXIgMDIsIDIwMjMgYXQgMDI6MDQ6
NDJQTSAtMDUwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+ID4gPiA+ID4gPiA+IE9uIE1vbiwgSmFu
IDMwLCAyMDIzIGF0IDU6NTg/Pz9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+
IHdyb3RlOgo+ID4gPiA+Cj4gPiA+ID4gLi4uCj4gPiA+ID4KPiA+ID4gPiA+ID4gSSBndWVzcyB0
aGlzIGRvZXMgbWFrZSBtZSB3b25kZXIgYWJvdXQga2VlcGluZyBhIG5vbi1hY3RpdmUgcG9saWN5
Cj4gPiA+ID4gPiA+IGxvYWRlZCBpbiB0aGUga2VybmVsLCB3aGF0IHB1cnBvc2UgZG9lcyB0aGF0
IHNlcnZlPwo+ID4gPiA+ID4gPgo+ID4gPiA+ID4KPiA+ID4gPiA+IFRoZSBub24tYWN0aXZlIHBv
bGljeSBkb2Vzbid0IHNlcnZlIGFueXRoaW5nIHVubGVzcyBpdCBpcyBhY3RpdmF0ZWQuIFVzZXIg
Y2FuCj4gPiA+ID4gPiBldmVuIGRlbGV0ZSBhIHBvbGljeSBpZiB0aGF0IGlzIG5vIGxvbmdlciBu
ZWVkZWQuIE5vbi1hY3RpdmUgaXMganVzdCB0aGUgZGVmYXVsdAo+ID4gPiA+ID4gc3RhdGUgd2hl
biBhIG5ldyBwb2xpY3kgaXMgbG9hZGVkLgo+ID4gPiA+ID4KPiA+ID4gPiA+IElmIElQRSBzdXBw
b3J0cyBuYW1lc3BhY2UsIHRoZXJlIGlzIGFub3RoZXIgdXNlIGNhc2Ugd2hlcmUgZGlmZmVyZW50
IGNvbnRhaW5lcnMKPiA+ID4gPiA+IGNhbiBzZWxlY3QgZGlmZmVyZW50IHBvbGljaWVzIGFzIHRo
ZSBhY3RpdmUgcG9saWN5IGZyb20gYW1vbmcgbXVsdGlwbGUgbG9hZGVkCj4gPiA+ID4gPiBwb2xp
Y2llcy4gRGV2ZW4gaGFzIHByZXNlbnRlZCBhIGRlbW8gb2YgdGhpcyBkdXJpbmcgTFNTIDIwMjEu
IEJ1dCB0aGlzIGdvZXMKPiA+ID4gPiA+IGJleW9uZCB0aGUgc2NvcGUgb2YgdGhpcyB2ZXJzaW9u
Lgo+ID4gPiA+Cj4gPiA+ID4gRG8geW91IHBsYW4gdG8gYWRkIG5hbWVzcGFjZSBzdXBwb3J0IGF0
IHNvbWUgcG9pbnQgaW4gdGhlCj4gPiA+ID4gbm90LXRvby1kaXN0YW50IGZ1dHVyZT8gIElmIHNv
LCBJJ20gb2theSB3aXRoIGtlZXBpbmcgc3VwcG9ydCBmb3IKPiA+ID4gPiBtdWx0aXBsZSBwb2xp
Y2llcywgYnV0IGlmIHlvdSB0aGluayB5b3UncmUgb25seSBnb2luZyB0byBzdXBwb3J0IG9uZQo+
ID4gPiA+IGFjdGl2ZSBwb2xpY3kgYXQgYSB0aW1lLCBpdCBtaWdodCBiZSBiZXR0ZXIgdG8gcmVt
b3ZlIHN1cHBvcnQgZm9yCj4gPiA+ID4gbXVsdGlwbGUgKGluYWN0aXZlKSBwb2xpY2llcy4KPiA+
ID4gPgo+ID4gPiA+IC0tCj4gPiA+ID4gcGF1bC1tb29yZS5jb20KPiA+ID4KPiA+ID4gQW5vdGhl
ciBiZW5lZml0IG9mIGhhdmluZyBtdWx0aXBsZSBwb2xpY2llcyBpcyB0aGF0IGl0IHByb3ZpZGVz
IGlzb2xhdGlvbgo+ID4gPiBiZXR3ZWVuIGRpZmZlcmVudCBwb2xpY2llcy4gRm9yIGluc3RhbmNl
LCBpZiB3ZSBoYXZlIHR3byBwb2xpY2llcyBuYW1lZAo+ID4gPiAicG9saWN5X2EiIGFuZCAicG9s
aWN5X2IsIiB3ZSBjYW4gZW5zdXJlIHRoYXQgb25seSB0ZWFtIGEgY2FuIHVwZGF0ZSAicG9saWN5
X2EsIgo+ID4gPiBhbmQgb25seSB0ZWFtIGIgY2FuIHVwZGF0ZSAicG9saWN5X2IuIiBUaGlzIHdh
eSwgYm90aCB0ZWFtcyBjYW4gdXBkYXRlCj4gPiA+IHRoZWlyIHBvbGljeSB3aXRob3V0IGFmZmVj
dGluZyBvdGhlcnMuIEhvd2V2ZXIsIGlmIHRoZXJlIGlzIG9ubHkgb25lIHBvbGljeQo+ID4gPiBp
biB0aGUgc3lzdGVtLCBib3RoIHRlYW1zIHdpbGwgaGF2ZSB0byBvcGVyYXRlIG9uIHRoZSBzYW1l
IHBvbGljeSwgbWFraW5nIGl0Cj4gPiA+IGxlc3MgbWFuYWdlYWJsZS4KPiA+Cj4gPiBUaGF0IG9u
bHkgcmVhbGx5IG1hdHRlcnMgaWYgYm90aCBwb2xpY2llcyBhcmUgYWN0aXZlIGF0IHRoZSBzYW1l
IHRpbWU7Cj4gPiBpZiBvbmx5IG9uZSBwb2xpY3kgY2FuIGJlIGFjdGl2ZSBhdCBvbmUgcG9pbnQg
aW4gdGltZSB0aGUgb25seQo+ID4gcGVybWlzc2lvbiB0aGF0IG1hdHRlcnMgaXMgdGhlIG9uZSB3
aG8gY2FuIGxvYWQvYWN0aXZhdGUgYSBwb2xpY3kuCj4gPgo+ID4gQWxsb3dpbmcgZm9yIG11bHRp
cGxlIHBvbGljaWVzIGNvbXBsaWNhdGVzIHRoZSBjb2RlLiAgSWYgdGhlcmUgaXMKPiA+IGFub3Ro
ZXIgZmVhdHVyZSB0aGF0IHJlcXVpcmVzIG11bHRpcGxlIHBvbGljaWVzLCBlLmcuIElQRSBuYW1l
c3BhY2VzLAo+ID4gdGhlbiB0aGF0IGlzIG9rYXkuICBIb3dldmVyLCBpZiB0aGVyZSBpcyBubyBm
ZWF0dXJlIHdoaWNoIHJlcXVpcmVzCj4gPiBtdWx0aXBsZSBhY3RpdmUgcG9saWNpZXMsIHN1cHBv
cnRpbmcgbXVsdGlwbGUgbG9hZGVkIHBvbGljaWVzIG9ubHkKPiA+IGluY3JlYXNlcyB0aGUgcmlz
ayBvZiBhbiBleHBsb2l0YWJsZSBidWcgaW4gdGhlIElQRSBjb2RlLgo+ID4KPiA+ID4gQmVzaWRl
cywgcmVtb3ZpbmcgbXVsdGlwbGUgKGluYWN0aXZlKSBwb2xpY2llcyBzdXBwb3J0IHdpbGwKPiA+
ID4gcmVuZGVyIHRoZSBwb2xpY3lfbmFtZSBmaWVsZCBtZWFuaW5nbGVzcywgYW5kIHdlIHNob3Vs
ZCBvbmx5IGF1ZGl0IHRoZSBwb2xpY3kKPiA+ID4gaGFzaC4gSSBhbSBmaW5lIGlmIHdlIGRlY2lk
ZSB0byBnbyBmb3IgdGhlIHNpbmdsZSBwb2xpY3kgb3B0aW9uLgo+ID4KPiA+IE9uY2UgYWdhaW4s
IEkgdGhpbmsgaXQgY29tZXMgYmFjayB0bzogZG8geW91IHN0aWxsIHdhbnQgdG8gc3VwcG9ydCBJ
UEUKPiA+IG5hbWVzcGFjZXMgYXQgc29tZSBwb2ludCBpbiB0aGUgZnV0dXJlLCBhbmQgaWYgc28s
IHdoZW4gZG8geW91IGV4cGVjdAo+ID4gdG8gd29yayBvbiB0aGF0Pwo+Cj4gWWVzLCBhYnNvbHV0
ZWx5ISBXZSBkZWZpbml0ZWx5IGhhdmUgcGxhbnMgdG8gc3VwcG9ydCBuYW1lc3BhY2VzIGluIHRo
ZSBmdXR1cmUuCj4gSG93ZXZlciwgaXQncyB3b3J0aCBtZW50aW9uaW5nIHRoYXQgdGhlcmUgYXJl
IG90aGVyIHRhc2tzIHRoYXQgd2UgbWF5IG5lZWQKPiB0byBwcmlvcml0aXplIGR1ZSB0byB0aGVp
ciByZWxhdGl2ZWx5IGxvd2VyIGNvbXBsZXhpdHkuIEZvciBleGFtcGxlLCBiZWZvcmUKPiB3ZSBj
YW4gZnVsbHkgaW1wbGVtZW50IG5hbWVzcGFjZXMsIHdlIG5lZWQgdG8gYWRkcmVzcyBzb21lIG90
aGVyIGltcG9ydGFudAo+IGFzcGVjdHMgb2YgdGhlIHN5c3RlbSwgc3VjaCBhcyBhZGRpbmcgYSBw
b2xpY3kgbGFuZ3VhZ2UgZm9yIGludGVncml0eQo+IGVuZm9yY2VtZW50IG9uIGNvbmZpZ3VyYXRp
b24gZmlsZXMgYW5kIGRlZmluaW5nIHRydXN0ZWQgY2VydGlmaWNhdGVzCj4gdGhhdCBjYW4gc2ln
biB0aGUgcm9vdCBoYXNoLiBUaGVyZWZvcmUsIHRoZSB0aW1lbGluZSBmb3IgaW1wbGVtZW50aW5n
Cj4gbmFtZXNwYWNlcyB3aWxsIGRlcGVuZCBvbiB0aGUgY29tcGxldGlvbiB0aW1lIG9mIHRoZXNl
IHRhc2tzLgo+Cj4gSSB1bmRlcnN0YW5kIHlvdXIgY29uY2VybnMsIGFuZCB3ZSBjYW4gcHJvY2Vl
ZCB3aXRoIGEgc2luZ2xlIHBvbGljeSBkZXNpZ24KPiBmb3IgdGhlIGluaXRpYWwgdmVyc2lvbi4K
CkkgdGhpbmsgaXQncyBva2F5IHRvIHN0aWNrIHdpdGggdGhlIG11bHRpLXBvbGljeSBjb2RlIGZv
ciB0aGUgaW5pdGlhbApzdWJtaXNzaW9uLCB5b3UndmUgZ290IHRoZSBjb2RlIG5vdywgYW5kIGl0
J3MgdGVzdGVkLiAgSSBqdXN0IHdhbnRlZAp0byBtYWtlIHN1cmUgdGhlcmUgd2VyZSBwbGFucyB0
byBtYWtlIHVzZSBvZiBpdCBhdCBzb21lIHBvaW50LCBpZiBub3QKd2UgbWlnaHQgYXMgd2VsbCBk
cm9wIGl0IG5vdy4gIEhvd2V2ZXIsIGl0IHNvdW5kcyBsaWtlIHlvdSd2ZSBnb3QgYQpwbGFuIHRv
IHV0aWxpemUgdGhlIG11bHRpLXBvbGljeSBzdXBwb3J0IHNvIHRoYXQncyBmaW5lIHdpdGggbWUu
CgotLSAKcGF1bC1tb29yZS5jb20KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEBy
ZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0t
ZGV2ZWwK

