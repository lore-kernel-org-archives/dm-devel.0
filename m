Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7972EC0015E
	for <dm-devel@archiver.kernel.org>; Tue,  1 Aug 2023 19:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690918258;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aleWgLd5/C2BEn3Y8Pkiv3H2u/jfImqjQ52cvTxxZqI=;
	b=I3AGm38Ct1GfuTmBhNCvWMvQLoPvRvr5dSZJIM9ccIyjWrciT5wHvZr6WhBL6fKRW3wvRS
	kpxpongA498+AybImGHrTXhNXidu1kf8KF6dif5h5lRhDVpatsdFv9CaYHHRBlzYAfKPTj
	Y+nVEupHBymgdckbO1MXz5BEykuHNUU=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-RocRNQHDPAykYEbW0ZWMWg-1; Tue, 01 Aug 2023 15:30:55 -0400
X-MC-Unique: RocRNQHDPAykYEbW0ZWMWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E7BA1C0724F;
	Tue,  1 Aug 2023 19:30:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 479A01454143;
	Tue,  1 Aug 2023 19:30:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F4271946A43;
	Tue,  1 Aug 2023 19:30:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5104D1946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Aug 2023 19:29:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E6DEF7859; Tue,  1 Aug 2023 19:29:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 377F7F7821
 for <dm-devel@redhat.com>; Tue,  1 Aug 2023 19:29:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0320185A794
 for <dm-devel@redhat.com>; Tue,  1 Aug 2023 19:29:54 +0000 (UTC)
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com
 [209.85.210.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-uSs9gs36MGCuk8mC7gj31g-1; Tue, 01 Aug 2023 15:29:52 -0400
X-MC-Unique: uSs9gs36MGCuk8mC7gj31g-1
Received: by mail-ot1-f47.google.com with SMTP id
 46e09a7af769-6bc8d1878a0so3405034a34.1
 for <dm-devel@redhat.com>; Tue, 01 Aug 2023 12:29:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690918192; x=1691522992;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=9VoATP9NhH/kSJB8+YTj7ST63aExW0zMTg/FlvDeldU=;
 b=ZIF7WhpHk1HJZ7ZZWBLa3lFDEzQP5v72oHe6FmgVfw7Ly3QJy+9JdcBjd/FZZ+2g+3
 v/Fu+GOOIg/ZAF+cLkEZAYeEKIhptE6TRl9ObvvJokwFxbKfHF5F7HejIQH3SOdEtraZ
 O6RnJAJcWKfi8xgPKilUg585gNQDeAYY6qRScd6n16a408pDtDFsVP/dDXO8agew+r3A
 vJxD71pf+HvFV0Rf+vpWO46L4M3Y4eVexYwCgkB5DYDMK34f+4jAqoBjuiJGPlo5q39J
 G/g4bkErNJLDjJ0va3EZjO0pGl23v/ul16HUmSsuOHZpoglRt45X3WDUcqlxKLlMzKy6
 x7VA==
X-Gm-Message-State: ABy/qLak+ua6n8/tw8msbaNLVCsq/p7Ig/HdLuawf4oXGnAFR2Cx4oxY
 5A93xfw0pPyNnRG3C9w5QhcYnxNWQp1Tot40Nj2s
X-Google-Smtp-Source: APBJJlFeosTdRRNCzhw56R7pSQbCNwevBbiNXiMElbuinfE7oB7aWtWCFN6s8eGVLK4C+bFbpQT0m3cUoqudXbEH1L0=
X-Received: by 2002:a05:6830:10e:b0:6b9:1af3:3307 with SMTP id
 i14-20020a056830010e00b006b91af33307mr13348963otp.17.1690918192119; Tue, 01
 Aug 2023 12:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <1687986571-16823-8-git-send-email-wufan@linux.microsoft.com>
 <fcc5de3f153eb60b5acf799c159e6ec8.paul@paul-moore.com>
 <20230715032644.GF15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230715032644.GF15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 1 Aug 2023 15:29:40 -0400
Message-ID: <CAHC9VhQryLtJZ1W1ogyVuojnq0-ZAU-hfZLwpzUb=bobko9LsA@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH RFC v10 7/17] ipe: add userspace interface
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
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, audit@vger.kernel.org,
 linux-security-module@vger.kernel.org, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBKdWwgMTQsIDIwMjMgYXQgMTE6MjbigK9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1p
Y3Jvc29mdC5jb20+IHdyb3RlOgo+IE9uIFNhdCwgSnVsIDA4LCAyMDIzIGF0IDEyOjIzOjA0QU0g
LTA0MDAsIFBhdWwgTW9vcmUgd3JvdGU6Cj4gPiBPbiBKdW4gMjgsIDIwMjMgRmFuIFd1IDx3dWZh
bkBsaW51eC5taWNyb3NvZnQuY29tPiB3cm90ZToKPiA+ID4KPiA+ID4gQXMgaXMgdHlwaWNhbCB3
aXRoIExTTXMsIElQRSB1c2VzIHNlY3VyaXR5ZnMgYXMgaXRzIGludGVyZmFjZSB3aXRoCj4gPiA+
IHVzZXJzcGFjZS4gZm9yIGEgY29tcGxldGUgbGlzdCBvZiB0aGUgaW50ZXJmYWNlcyBhbmQgdGhl
IHJlc3BlY3RpdmUKPiA+ID4gaW5wdXRzL291dHB1dHMsIHBsZWFzZSBzZWUgdGhlIGRvY3VtZW50
YXRpb24gdW5kZXIKPiA+ID4gYWRtaW4tZ3VpZGUvTFNNL2lwZS5yc3QKPiA+ID4KPiA+ID4gU2ln
bmVkLW9mZi1ieTogRGV2ZW4gQm93ZXJzIDxkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29t
Pgo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+
Cj4gPiA+IC0tLQo+ID4gPiAgc2VjdXJpdHkvaXBlL01ha2VmaWxlICAgIHwgICAyICsKPiA+ID4g
IHNlY3VyaXR5L2lwZS9mcy5jICAgICAgICB8IDEwMSArKysrKysrKwo+ID4gPiAgc2VjdXJpdHkv
aXBlL2ZzLmggICAgICAgIHwgIDE2ICsrCj4gPiA+ICBzZWN1cml0eS9pcGUvaXBlLmMgICAgICAg
fCAgIDMgKwo+ID4gPiAgc2VjdXJpdHkvaXBlL2lwZS5oICAgICAgIHwgICAyICsKPiA+ID4gIHNl
Y3VyaXR5L2lwZS9wb2xpY3kuYyAgICB8IDExMSArKysrKysrKysKPiA+ID4gIHNlY3VyaXR5L2lw
ZS9wb2xpY3kuaCAgICB8ICAgOSArCj4gPiA+ICBzZWN1cml0eS9pcGUvcG9saWN5X2ZzLmMgfCA0
ODEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gPiA+ICA4IGZpbGVz
IGNoYW5nZWQsIDcyNSBpbnNlcnRpb25zKCspCj4gPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgc2Vj
dXJpdHkvaXBlL2ZzLmMKPiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBzZWN1cml0eS9pcGUvZnMu
aAo+ID4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9wb2xpY3lfZnMuYwoKLi4u
Cgo+ID4gPiBAQCAtMzksNiArNjcsNjUgQEAgc3RhdGljIGludCBzZXRfcGtjczdfZGF0YSh2b2lk
ICpjdHgsIGNvbnN0IHZvaWQgKmRhdGEsIHNpemVfdCBsZW4sCj4gPiA+ICAgICByZXR1cm4gMDsK
PiA+ID4gIH0KPiA+ID4KPiA+ID4gKy8qKgo+ID4gPiArICogaXBlX3VwZGF0ZV9wb2xpY3kgLSBw
YXJzZSBhIG5ldyBwb2xpY3kgYW5kIHJlcGxhY2UgQG9sZCB3aXRoIGl0Lgo+ID4KPiA+IFdoYXQg
ZG9lcyAiQG9sZCIgcmVmZXIgdG8/ICBJJ20gZ3Vlc3NpbmcgeW91IHdhbnQgdG8gZHJvcCB0aGUg
IkAiLgo+ID4KPiBZZXMgaXQgc2hvdWxkbid0IGJlIGhlcmUsIHNvcnJ5IGNvbmZ1c2lvbi4KPgo+
ID4gPiArICogQHJvb3Q6IFN1cHBsaWVzIGEgcG9pbnRlciB0byB0aGUgc2VjdXJpdHlmcyBpbm9k
ZSBzYXZlZCB0aGUgcG9saWN5Lgo+ID4gPiArICogQHRleHQ6IFN1cHBsaWVzIGEgcG9pbnRlciB0
byB0aGUgcGxhaW4gdGV4dCBwb2xpY3kuCj4gPiA+ICsgKiBAdGV4dGxlbjogU3VwcGxpZXMgdGhl
IGxlbmd0aCBvZiBAdGV4dC4KPiA+ID4gKyAqIEBwa2NzNzogU3VwcGxpZXMgYSBwb2ludGVyIHRv
IGEgYnVmZmVyIGNvbnRhaW5pbmcgYSBwa2NzNyBtZXNzYWdlLgo+ID4gPiArICogQHBrY3M3bGVu
OiBTdXBwbGllcyB0aGUgbGVuZ3RoIG9mIEBwa2NzN2xlbi4KPiA+ID4gKyAqCj4gPiA+ICsgKiBA
dGV4dC9AdGV4dGxlbiBpcyBtdXR1YWxseSBleGNsdXNpdmUgd2l0aCBAcGtjczcvQHBrY3M3bGVu
IC0gc2VlCj4gPiA+ICsgKiBpcGVfbmV3X3BvbGljeS4KPiA+ID4gKyAqCj4gPiA+ICsgKiBSZXR1
cm46Cj4gPiA+ICsgKiAqICFJU19FUlIgICAgICAgLSBUaGUgb2xkIHBvbGljeQo+ID4KPiA+ICJU
aGUgb2xkIHBvbGljeSIgaXMgd2hhdD8KPiA+Cj4gTGV0IG1lIHRyeSB0byBwaGFyc2UgaXQgaW4g
YW5vdGhlciB3YXksIGhvdyBhYm91dCB0aGUgZXhpc3RpbmcgcG9saWN5Cj4gc2F2ZWQgaW4gdGhl
IGlub2RlIGJlZm9yZSB1cGRhdGU/CgpUaGF0IHNvdW5kcyBiZXR0ZXIsIHRoYW5rcy4KCj4gPiA+
IGRpZmYgLS1naXQgYS9zZWN1cml0eS9pcGUvcG9saWN5X2ZzLmMgYi9zZWN1cml0eS9pcGUvcG9s
aWN5X2ZzLmMKPiA+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQKPiA+ID4gaW5kZXggMDAwMDAwMDAw
MDAwLi41MmExMjAxMThjZGEKPiA+ID4gLS0tIC9kZXYvbnVsbAo+ID4gPiArKysgYi9zZWN1cml0
eS9pcGUvcG9saWN5X2ZzLmMKPiA+ID4gQEAgLTAsMCArMSw0ODEgQEAKPiA+Cj4gPiAuLi4KPiA+
Cj4gPiA+ICsvKioKPiA+ID4gKyAqIGdldGFjdGl2ZSAtIFJlYWQgaGFuZGxlciBmb3IgImlwZS9w
b2xpY2llcy8kbmFtZS9hY3RpdmUiLgo+ID4gPiArICogQGY6IFN1cHBsaWVzIGEgZmlsZSBzdHJ1
Y3R1cmUgcmVwcmVzZW50aW5nIHRoZSBzZWN1cml0eWZzIG5vZGUuCj4gPiA+ICsgKiBAZGF0YTog
U3VwcGxlaXMgYSBidWZmZXIgcGFzc2VkIHRvIHRoZSB3cml0ZSBzeXNjYWxsLgo+ID4gPiArICog
QGxlbjogU3VwcGxpZXMgdGhlIGxlbmd0aCBvZiBAZGF0YS4KPiA+ID4gKyAqIEBvZmZzZXQ6IHVu
dXNlZC4KPiA+ID4gKyAqCj4gPiA+ICsgKiBAZGF0YSB3aWxsIGJlIHBvcHVsYXRlZCB3aXRoIHRo
ZSAxIG9yIDAgZGVwZW5kaW5nIG9uIGlmIHRoZQo+ID4gPiArICogY29ycmVzcG9uZGluZyBwb2xp
Y3kgaXMgYWN0aXZlLgo+ID4gPiArICoKPiA+ID4gKyAqIFJldHVybjoKPiA+ID4gKyAqICogPjAg
ICAgLSBTdWNjZXNzLCBMZW5ndGggb2YgYnVmZmVyIHdyaXR0ZW4KPiA+ID4gKyAqICogPDAgICAg
LSBFcnJvcgo+ID4gPiArICovCj4gPiA+ICtzdGF0aWMgc3NpemVfdCBnZXRhY3RpdmUoc3RydWN0
IGZpbGUgKmYsIGNoYXIgX191c2VyICpkYXRhLAo+ID4gPiArICAgICAgICAgICAgICAgICAgICBz
aXplX3QgbGVuLCBsb2ZmX3QgKm9mZnNldCkKPiA+ID4gK3sKPiA+ID4gKyAgIGludCByYyA9IDA7
Cj4gPiA+ICsgICBjb25zdCBjaGFyICpzdHI7Cj4gPiA+ICsgICBzdHJ1Y3QgaW5vZGUgKnJvb3Qg
PSBOVUxMOwo+ID4gPiArICAgY29uc3Qgc3RydWN0IGlwZV9wb2xpY3kgKnAgPSBOVUxMOwo+ID4g
PiArCj4gPiA+ICsgICByb290ID0gZF9pbm9kZShmLT5mX3BhdGguZGVudHJ5LT5kX3BhcmVudCk7
Cj4gPiA+ICsKPiA+ID4gKyAgIGlub2RlX2xvY2tfc2hhcmVkKHJvb3QpOwo+ID4gPiArICAgcCA9
IChzdHJ1Y3QgaXBlX3BvbGljeSAqKXJvb3QtPmlfcHJpdmF0ZTsKPiA+ID4gKyAgIGlmICghcCkg
ewo+ID4gPiArICAgICAgICAgICBpbm9kZV91bmxvY2tfc2hhcmVkKHJvb3QpOwo+ID4gPiArICAg
ICAgICAgICByZXR1cm4gLUVOT0VOVDsKPiA+ID4gKyAgIH0KPiA+ID4gKyAgIGlub2RlX3VubG9j
a19zaGFyZWQocm9vdCk7Cj4gPiA+ICsKPiA+ID4gKyAgIHN0ciA9IChwID09IHJjdV9hY2Nlc3Nf
cG9pbnRlcihpcGVfYWN0aXZlX3BvbGljeSkpID8gIjEiIDogIjAiOwo+ID4KPiA+IFRoZSBsaW5l
IGFib3ZlIHNob3VsZCBiZSB3cmFwcGVkIHdpdGggYSBSQ1UgbG9jay4KPgo+IFRoaXMgY2FsbCBv
bmx5IGNoZWNrcyB0aGUgdmFsdWUgaW5zaWRlIHRoZSBwb2ludGVyIGJ1dCBkb2Vzbid0IGRlcmVm
ZXJlbmNlIGl0Lgo+IEFsc28gZnJvbSBodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvNjUyMTU2LyBJ
IGZvdW5kIGl0IHNheXMgIlRoZSBjYWxsIHRvCj4gcmN1X2FjY2Vzc19wb2ludGVyKCkgbmVlZCBu
b3QgYmUgcHJvdGVjdGVkLiBJbiBjb250cmFzdCwgcmN1X2RlcmVmZXJlbmNlKCkgbXVzdAo+IGVp
dGhlciBiZSB3aXRoaW4gYW4gUkNVIHJlYWQtc2lkZSBjcml0aWNhbCBzZWN0aW9uIiwgc28gSSBk
aWRuJ3QgYWRkIHRoZSBsb2NrCj4gaGVyZSwgaXMgdGhpcyBhcnRpY2xlIG91dGRhdGVkPwoKTm8s
IEkgYmVsaWV2ZSB5b3UgYXJlIGNvcnJlY3QuICBUaGVyZSBpcyBhbHdheXMgc29tZXRoaW5nIG5l
dyB0byBsZWFybgp3aXRoIFJDVSwgdGhhbmtzIDspCgotLSAKcGF1bC1tb29yZS5jb20KCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

