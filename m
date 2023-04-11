Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB152C7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 21:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681249561;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7AbewGFHv/PCkDYAbw8XK3NvQggRJAAl45pl9/PVraA=;
	b=TLA9ISOSetyBr5DLPgcxq7cY6wlFZSYhPCjE7esLd2FEV4D3kUelMQfGnSBq8mzvHXBRBO
	J4EW0B/h3dALUCQP0Mw+54whyqFghozDSdHcU0aIJ65Tfb96SHHAEIGoJUr7pHy/0+jMlk
	P47VsQzw3RBmHI1ncJeTB+p7ZzyoA6Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-1KkxEGx6PbSBlIqBtJKFPw-1; Tue, 11 Apr 2023 17:46:00 -0400
X-MC-Unique: 1KkxEGx6PbSBlIqBtJKFPw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29BA03C02B85;
	Tue, 11 Apr 2023 21:45:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4801F492C13;
	Tue, 11 Apr 2023 21:45:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15B601946A41;
	Tue, 11 Apr 2023 21:45:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02C4119466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 21:45:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86342492C14; Tue, 11 Apr 2023 21:45:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DEBB492C13
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 21:45:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62D0A855300
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 21:45:54 +0000 (UTC)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com
 [209.85.219.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-x7W9vSKFOoCY4pn3vi9J2w-1; Tue, 11 Apr 2023 17:45:52 -0400
X-MC-Unique: x7W9vSKFOoCY4pn3vi9J2w-1
Received: by mail-yb1-f173.google.com with SMTP id y186so9824905yby.13
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 14:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1681249552; x=1683841552;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=QJHIYVc0csC12SHK/J/mtXalsO4pjHKd97C3GIyBGPs=;
 b=o5LprTfj0qRnMY3r9EyMlwFF8+UcdmkInxFbqppbv5tis9Ke+8YbVq0uhbYldZ4x+V
 GDLH6JmVlMb2AIm3FygeMYYBTlMORSYmCUJjEhLool+alFhcKXi0qz9W6LB3H+F/vP9/
 o+ssNuKZRXZGOLFcIdNou6qLjIfcNtChqgUQIZCSYNcdyx316f4+X7Fe2M8PVN3unPls
 lCxSL360DgJNMoMNc+BhLLofqgwBTsEeTQkOI2NwDGI/Cu56PGbtp3mnqpZ1mOxzXSg9
 HSDHUJkA0Qxi32fVfhV+FsJMN4OLaDp9th/uz51pGP5fDsVCs0MiJZ4KsDYugZ6O81zm
 wu+g==
X-Gm-Message-State: AAQBX9cB2K4PRJ+0Ku0tBPj43EIOshNVYopfwxzwUUvWigtoHTN4RLH+
 8uYzQ2obOIl3z/wDcDQN6SXxcUfPPX4Hg5jalrSY
X-Google-Smtp-Source: AKy350Yy44JQPhqwIxfCYnzm9J8mBAXlzIsXMzsUvsaWbKpTAmHS32TjoXQQ8RK1Y2npGScPRJOP30cnOuG8gOZrT1A=
X-Received: by 2002:a25:e0c5:0:b0:b8b:fd23:5028 with SMTP id
 x188-20020a25e0c5000000b00b8bfd235028mr2609635ybg.3.1681249552097; Tue, 11
 Apr 2023 14:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
 <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230410191035.GB18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 11 Apr 2023 17:45:41 -0400
Message-ID: <CAHC9VhQDvWDshaZvJrHmjcwyHFxv9oYTN9bn0xiTtFZQRp+GPg@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBcHIgMTAsIDIwMjMgYXQgMzoxMOKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4gT24gVGh1LCBNYXIgMDIsIDIwMjMgYXQgMDI6MDQ6NDJQTSAt
MDUwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+IE9uIE1vbiwgSmFuIDMwLCAyMDIzIGF0IDU6NTg/
Pz9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgo+ID4gPgo+ID4g
PiBGcm9tOiBEZXZlbiBCb3dlcnMgPGRldmVuLmRlc2FpQGxpbnV4Lm1pY3Jvc29mdC5jb20+Cj4g
PiA+Cj4gPiA+IEFzIGlzIHR5cGljYWwgd2l0aCBMU01zLCBJUEUgdXNlcyBzZWN1cml0eWZzIGFz
IGl0cyBpbnRlcmZhY2Ugd2l0aAo+ID4gPiB1c2Vyc3BhY2UuIGZvciBhIGNvbXBsZXRlIGxpc3Qg
b2YgdGhlIGludGVyZmFjZXMgYW5kIHRoZSByZXNwZWN0aXZlCj4gPiA+IGlucHV0cy9vdXRwdXRz
LCBwbGVhc2Ugc2VlIHRoZSBkb2N1bWVudGF0aW9uIHVuZGVyCj4gPiA+IGFkbWluLWd1aWRlL0xT
TS9pcGUucnN0Cj4gPiA+Cj4gPiA+IFNpZ25lZC1vZmYtYnk6IERldmVuIEJvd2VycyA8ZGV2ZW4u
ZGVzYWlAbGludXgubWljcm9zb2Z0LmNvbT4KPiA+ID4gU2lnbmVkLW9mZi1ieTogRmFuIFd1IDx3
dWZhbkBsaW51eC5taWNyb3NvZnQuY29tPgo+ID4KPiA+IC4uLgo+ID4KPiA+ID4gLS0tCj4gPiA+
ICBzZWN1cml0eS9pcGUvTWFrZWZpbGUgICAgfCAgIDIgKwo+ID4gPiAgc2VjdXJpdHkvaXBlL2Zz
LmMgICAgICAgIHwgMTAxICsrKysrKysrKwo+ID4gPiAgc2VjdXJpdHkvaXBlL2ZzLmggICAgICAg
IHwgIDE3ICsrCj4gPiA+ICBzZWN1cml0eS9pcGUvaXBlLmMgICAgICAgfCAgIDMgKwo+ID4gPiAg
c2VjdXJpdHkvaXBlL2lwZS5oICAgICAgIHwgICAyICsKPiA+ID4gIHNlY3VyaXR5L2lwZS9wb2xp
Y3kuYyAgICB8IDEzNSArKysrKysrKysrKysKPiA+ID4gIHNlY3VyaXR5L2lwZS9wb2xpY3kuaCAg
ICB8ICAgNyArCj4gPiA+ICBzZWN1cml0eS9pcGUvcG9saWN5X2ZzLmMgfCA0NTkgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gPiA+ICA4IGZpbGVzIGNoYW5nZWQsIDcy
NiBpbnNlcnRpb25zKCspCj4gPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgc2VjdXJpdHkvaXBlL2Zz
LmMKPiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBzZWN1cml0eS9pcGUvZnMuaAo+ID4gPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9wb2xpY3lfZnMuYwoKLi4uCgo+ID4gPiArLyoq
Cj4gPiA+ICsgKiBpcGVfdXBkYXRlX3BvbGljeSAtIHBhcnNlIGEgbmV3IHBvbGljeSBhbmQgcmVw
bGFjZSBAb2xkIHdpdGggaXQuCj4gPiA+ICsgKiBAYWRkcjogU3VwcGxpZXMgYSBwb2ludGVyIHRv
IHRoZSBpX3ByaXZhdGUgZm9yIHNhdmluZyBwb2xpY3kuCj4gPiA+ICsgKiBAdGV4dDogU3VwcGxp
ZXMgYSBwb2ludGVyIHRvIHRoZSBwbGFpbiB0ZXh0IHBvbGljeS4KPiA+ID4gKyAqIEB0ZXh0bGVu
OiBTdXBwbGllcyB0aGUgbGVuZ3RoIG9mIEB0ZXh0Lgo+ID4gPiArICogQHBrY3M3OiBTdXBwbGll
cyBhIHBvaW50ZXIgdG8gYSBidWZmZXIgY29udGFpbmluZyBhIHBrY3M3IG1lc3NhZ2UuCj4gPiA+
ICsgKiBAcGtjczdsZW46IFN1cHBsaWVzIHRoZSBsZW5ndGggb2YgQHBrY3M3bGVuLgo+ID4gPiAr
ICoKPiA+ID4gKyAqIEB0ZXh0L0B0ZXh0bGVuIGlzIG11dHVhbGx5IGV4Y2x1c2l2ZSB3aXRoIEBw
a2NzNy9AcGtjczdsZW4gLSBzZWUKPiA+ID4gKyAqIGlwZV9uZXdfcG9saWN5Lgo+ID4gPiArICoK
PiA+ID4gKyAqIFJldHVybjoKPiA+ID4gKyAqICogIUlTX0VSUiAgIC0gT0sKPiA+ID4gKyAqICog
LUVOT0VOVCAgIC0gUG9saWN5IGRvZXNuJ3QgZXhpc3QKPiA+ID4gKyAqICogLUVJTlZBTCAgIC0g
TmV3IHBvbGljeSBpcyBpbnZhbGlkCj4gPiA+ICsgKi8KPiA+ID4gK3N0cnVjdCBpcGVfcG9saWN5
ICppcGVfdXBkYXRlX3BvbGljeShzdHJ1Y3QgaXBlX3BvbGljeSBfX3JjdSAqKmFkZHIsCj4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICp0ZXh0LCBz
aXplX3QgdGV4dGxlbiwKPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGNvbnN0IGNoYXIgKnBrY3M3LCBzaXplX3QgcGtjczdsZW4pCj4gPiA+ICt7Cj4gPiA+ICsgICAg
ICAgaW50IHJjID0gMDsKPiA+ID4gKyAgICAgICBzdHJ1Y3QgaXBlX3BvbGljeSAqb2xkLCAqbmV3
Owo+ID4gPiArCj4gPiA+ICsgICAgICAgb2xkID0gaXBlX2dldF9wb2xpY3lfcmN1KCphZGRyKTsK
PiA+ID4gKyAgICAgICBpZiAoIW9sZCkgewo+ID4gPiArICAgICAgICAgICAgICAgcmMgPSAtRU5P
RU5UOwo+ID4gPiArICAgICAgICAgICAgICAgZ290byBlcnI7Cj4gPiA+ICsgICAgICAgfQo+ID4g
PiArCj4gPiA+ICsgICAgICAgbmV3ID0gaXBlX25ld19wb2xpY3kodGV4dCwgdGV4dGxlbiwgcGtj
czcsIHBrY3M3bGVuKTsKPiA+ID4gKyAgICAgICBpZiAoSVNfRVJSKG5ldykpIHsKPiA+ID4gKyAg
ICAgICAgICAgICAgIHJjID0gUFRSX0VSUihuZXcpOwo+ID4gPiArICAgICAgICAgICAgICAgZ290
byBlcnI7Cj4gPiA+ICsgICAgICAgfQo+ID4gPiArCj4gPiA+ICsgICAgICAgaWYgKHN0cmNtcChu
ZXctPnBhcnNlZC0+bmFtZSwgb2xkLT5wYXJzZWQtPm5hbWUpKSB7Cj4gPiA+ICsgICAgICAgICAg
ICAgICByYyA9IC1FSU5WQUw7Cj4gPiA+ICsgICAgICAgICAgICAgICBnb3RvIGVycjsKPiA+ID4g
KyAgICAgICB9Cj4gPiA+ICsKPiA+ID4gKyAgICAgICBpZiAodmVyX3RvX3U2NChvbGQpID4gdmVy
X3RvX3U2NChuZXcpKSB7Cj4gPiA+ICsgICAgICAgICAgICAgICByYyA9IC1FSU5WQUw7Cj4gPiA+
ICsgICAgICAgICAgICAgICBnb3RvIGVycjsKPiA+ID4gKyAgICAgICB9Cj4gPiA+ICsKPiA+ID4g
KyAgICAgICBpZiAoaXBlX2lzX3BvbGljeV9hY3RpdmUob2xkKSkgewo+ID4KPiA+IEkgZG9uJ3Qg
dW5kZXJzdGFuZCB0aGUgaXMtYWN0aXZlIGNoZWNrLCB5b3Ugd2FudCB0byBtYWtlIEBuZXcgdGhl
IG5ldwo+ID4gYWN0aXZlIHBvbGljeSByZWdhcmRsZXNzLCByaWdodD8gIENvdWxkIHRoaXMgaXMt
YWN0aXZlIGNoZWNrIGV2ZXIgYmUKPiA+IGZhbHNlPwo+Cj4gQWN0dWFsbHkgdGhpcyBpcyBuZWVk
ZWQuIFBvbGljeSB1cGRhdGVzIGNhbiBiZSBhcHBsaWVkIHRvIGFueSBkZXBsb3llZAo+IHBvbGlj
eSwgd2hpY2ggbWF5IGJlIHNhdmVkIGluIHR3byBwbGFjZXM6IHRoZSBzZWN1cml0eWZzIGZpbGUg
bm9kZQo+IGFuZCB0aGUgaXBlX2FjdGl2ZV9wb2xpY3kgcG9pbnRlci4gVG8gdXBkYXRlIGEgcG9s
aWN5LCB0aGlzIGZ1bmN0aW9uIGZpcnN0Cj4gY2hlY2tzIGlmIHRoZSBwb2xpY3kgc2F2ZWQgaW4g
dGhlIHNlY3VyaXR5ZnMgZmlsZSBub2RlIGlzIGN1cnJlbnRseSBhY3RpdmUuCj4gSWYgc28sIGl0
IHVwZGF0ZXMgdGhlIGlwZV9hY3RpdmVfcG9saWN5IHBvaW50ZXIgdG8gcG9pbnQgdG8gdGhlIG5l
dyBwb2xpY3ksCj4gYW5kIGZpbmFsbHkgdXBkYXRlcyB0aGUgcG9saWN5IHBvaW50ZXIgaW4gdGhl
IHNlY3VyaXR5ZnMgdG8gdGhlIG5ldyBwb2xpY3kuCgpBaCwgb2theS4gIEkgbXVzdCBoYXZlIGZv
cmdvdHRlbiwgb3Igbm90IHJlYWxpemVkLCB0aGF0IG11bHRpcGxlCnBvbGljaWVzIGNvdWxkIGJl
IGxvYWRlZCBhbmQgbm90IGFjdGl2ZS4KCkkgZ3Vlc3MgdGhpcyBkb2VzIG1ha2UgbWUgd29uZGVy
IGFib3V0IGtlZXBpbmcgYSBub24tYWN0aXZlIHBvbGljeQpsb2FkZWQgaW4gdGhlIGtlcm5lbCwg
d2hhdCBwdXJwb3NlIGRvZXMgdGhhdCBzZXJ2ZT8KCi0tIApwYXVsLW1vb3JlLmNvbQoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

