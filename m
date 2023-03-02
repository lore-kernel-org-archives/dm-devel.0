Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A02C6FA8E
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 19:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677783901;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zhAvRO862kEV6w/eyzxi+GCUK35G9vVEO127mlySM4Q=;
	b=CpRO7YGKGngr/Tg7GNVRJZMIzRQ29mdznghbP2futsTKNulJK7qhUGIxeGxsddpzY1bZ5R
	HPcnM6HnfK84Vwmcq+zdMRlyti5yhKIVvCOcFD90QR/Qa0dIM9QyvBelkcwHsLTwg6kG/Z
	VfConxoqZn+AXmgtd0lIQsK+jqBKFsE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-cHT1gp55OnSAhhKJzLx-EQ-1; Thu, 02 Mar 2023 14:04:59 -0500
X-MC-Unique: cHT1gp55OnSAhhKJzLx-EQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4F3D858F0E;
	Thu,  2 Mar 2023 19:04:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE8BC140EBF6;
	Thu,  2 Mar 2023 19:04:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AFD6419452CE;
	Thu,  2 Mar 2023 19:04:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 98F5619452CD
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Mar 2023 19:04:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8A6C22026D76; Thu,  2 Mar 2023 19:04:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 826122026D4B
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:04:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 635CC85CBE5
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:04:56 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-aohGUafqPkOfJDINNgxrXQ-1; Thu, 02 Mar 2023 14:04:54 -0500
X-MC-Unique: aohGUafqPkOfJDINNgxrXQ-1
Received: by mail-pl1-f180.google.com with SMTP id p6so371429plf.0
 for <dm-devel@redhat.com>; Thu, 02 Mar 2023 11:04:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677783893;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=LRVimYCKhvDiUDPfm5kwf3o6VQDi4G7m6HXxXYMXUFM=;
 b=jHHLsty7K0nr0AUsinBmtnBzx14OdGXSVpMrzACan63ZbvvCHWQtNg0Io5OTZukeUb
 O5BYF4ZxhClMvYrs9W5PxZiuvpNIBFBrcqZ8/Re104EeD7tN3oJ1nWgzmmhDgJwA4CXg
 eHkWd9M8gGf8357hGiBcXtCtPy//vtnKcsB8Wf2X55owsAGgOvixIuKcj1GkuYsP85S0
 jEHcy0lWQzfL/xP9/9jLeJa3LhuDZoYpJaq0OPFmelT43M8hEEFEdbMth121jMC02BS9
 V6PoBHPC9uEmxdwfxSh9RkmGKEibpmXkR4dRpBb+bc3kUkPNLuZBHts7VmxWv5X3JuPE
 4fTg==
X-Gm-Message-State: AO0yUKV9QkFHVFivw2QVx/+/wYQzNIFtEMnfPGf2srouNg09adTQ+Lx1
 OWzrva25fqnWXrtcL8MtHz6RrgiflFbtliWx27zj
X-Google-Smtp-Source: AK7set8jr8w++GEdWwicBErVrQxXYcvRZv+4pkR2mJOP8drvGUq4551NSSMlqb/wqBBEjbF+WJsHq3GFxyqHmReivT0=
X-Received: by 2002:a17:902:f7d1:b0:19a:f9d9:28d4 with SMTP id
 h17-20020a170902f7d100b0019af9d928d4mr4094339plw.3.1677783893526; Thu, 02 Mar
 2023 11:04:53 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 2 Mar 2023 14:04:42 -0500
Message-ID: <CAHC9VhRa+NwKzLfQBmHfMgUp6_d5soQG7JBq-Vn=MUeUAt4tuQ@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKYW4gMzAsIDIwMjMgYXQgNTo1OOKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4KPiBGcm9tOiBEZXZlbiBCb3dlcnMgPGRldmVuLmRlc2FpQGxp
bnV4Lm1pY3Jvc29mdC5jb20+Cj4KPiBBcyBpcyB0eXBpY2FsIHdpdGggTFNNcywgSVBFIHVzZXMg
c2VjdXJpdHlmcyBhcyBpdHMgaW50ZXJmYWNlIHdpdGgKPiB1c2Vyc3BhY2UuIGZvciBhIGNvbXBs
ZXRlIGxpc3Qgb2YgdGhlIGludGVyZmFjZXMgYW5kIHRoZSByZXNwZWN0aXZlCj4gaW5wdXRzL291
dHB1dHMsIHBsZWFzZSBzZWUgdGhlIGRvY3VtZW50YXRpb24gdW5kZXIKPiBhZG1pbi1ndWlkZS9M
U00vaXBlLnJzdAo+Cj4gU2lnbmVkLW9mZi1ieTogRGV2ZW4gQm93ZXJzIDxkZXZlbi5kZXNhaUBs
aW51eC5taWNyb3NvZnQuY29tPgo+IFNpZ25lZC1vZmYtYnk6IEZhbiBXdSA8d3VmYW5AbGludXgu
bWljcm9zb2Z0LmNvbT4KCi4uLgoKPiAtLS0KPiAgc2VjdXJpdHkvaXBlL01ha2VmaWxlICAgIHwg
ICAyICsKPiAgc2VjdXJpdHkvaXBlL2ZzLmMgICAgICAgIHwgMTAxICsrKysrKysrKwo+ICBzZWN1
cml0eS9pcGUvZnMuaCAgICAgICAgfCAgMTcgKysKPiAgc2VjdXJpdHkvaXBlL2lwZS5jICAgICAg
IHwgICAzICsKPiAgc2VjdXJpdHkvaXBlL2lwZS5oICAgICAgIHwgICAyICsKPiAgc2VjdXJpdHkv
aXBlL3BvbGljeS5jICAgIHwgMTM1ICsrKysrKysrKysrKwo+ICBzZWN1cml0eS9pcGUvcG9saWN5
LmggICAgfCAgIDcgKwo+ICBzZWN1cml0eS9pcGUvcG9saWN5X2ZzLmMgfCA0NTkgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4gIDggZmlsZXMgY2hhbmdlZCwgNzI2IGlu
c2VydGlvbnMoKykKPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9mcy5jCj4gIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBzZWN1cml0eS9pcGUvZnMuaAo+ICBjcmVhdGUgbW9kZSAxMDA2NDQg
c2VjdXJpdHkvaXBlL3BvbGljeV9mcy5jCgouLi4KCj4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5L2lw
ZS9wb2xpY3kuYyBiL3NlY3VyaXR5L2lwZS9wb2xpY3kuYwo+IGluZGV4IDc3MmQ4NzZiMTA4Ny4u
YTVlOWM2ZTU2OTFiIDEwMDY0NAo+IC0tLSBhL3NlY3VyaXR5L2lwZS9wb2xpY3kuYwo+ICsrKyBi
L3NlY3VyaXR5L2lwZS9wb2xpY3kuYwo+IEBAIC00LDEyICs0LDM5IEBACj4gICAqLwo+Cj4gICNp
bmNsdWRlICJpcGUuaCIKPiArI2luY2x1ZGUgImV2YWwuaCIKPiArI2luY2x1ZGUgImZzLmgiCj4g
ICNpbmNsdWRlICJwb2xpY3kuaCIKPiAgI2luY2x1ZGUgInBvbGljeV9wYXJzZXIuaCIKPiAgI2lu
Y2x1ZGUgImRpZ2VzdC5oIgo+Cj4gICNpbmNsdWRlIDxsaW51eC92ZXJpZmljYXRpb24uaD4KPgo+
ICsvKiBsb2NrIGZvciBzeW5jaHJvbml6aW5nIHdyaXRlcnMgYWNyb3NzIGlwZSBwb2xpY3kgKi8K
PiArREVGSU5FX1NQSU5MT0NLKGlwZV9wb2xpY3lfbG9jayk7Cj4gKwo+ICsvKioKPiArICogdmVy
X3RvX3U2NCAtIENvbnZlcnQgYW4gaW50ZXJuYWwgaXBlX3BvbGljeV92ZXJzaW9uIHRvIGEgdTY0
Lgo+ICsgKiBAcDogUG9saWN5IHRvIGV4dHJhY3QgdGhlIHZlcnNpb24gZnJvbS4KPiArICoKPiAr
ICogQml0cyAoTFNCIGlzIGluZGV4IDApOgo+ICsgKiAgICAgWzQ4LDMyXSAtPiBNYWpvcgo+ICsg
KiAgICAgWzMyLDE2XSAtPiBNaW5vcgo+ICsgKiAgICAgWzE2LCAwXSAtPiBSZXZpc2lvbgo+ICsg
Kgo+ICsgKiBSZXR1cm46IHU2NCB2ZXJzaW9uIG9mIHRoZSBlbWJlZGRlZCB2ZXJzaW9uIHN0cnVj
dHVyZS4KPiArICovCj4gK3N0YXRpYyBpbmxpbmUgdTY0IHZlcl90b191NjQoY29uc3Qgc3RydWN0
IGlwZV9wb2xpY3kgKmNvbnN0IHApCj4gK3sKPiArICAgICAgIHU2NCByID0gMDsKCk5vIG5lZWQg
dG8gc2V0IEByIHRvIDAgc2luY2UgeW91IHNldCBpdCB0byB0aGUgdmVyc2lvbiBpbW1lZGlhdGVs
eSBiZWxvdy4KCj4gKyAgICAgICByID0gKCgodTY0KXAtPnBhcnNlZC0+dmVyc2lvbi5tYWpvcikg
PDwgMzIpCj4gKyAgICAgICAgIHwgKCgodTY0KXAtPnBhcnNlZC0+dmVyc2lvbi5taW5vcikgPDwg
MTYpCj4gKyAgICAgICAgIHwgKCh1NjQpKHAtPnBhcnNlZC0+dmVyc2lvbi5yZXYpKTsKPiArCj4g
KyAgICAgICByZXR1cm4gcjsKPiArfQo+ICsKPiAgLyoqCj4gICAqIGlwZV9mcmVlX3BvbGljeSAt
IERlYWxsb2NhdGUgYSBnaXZlbiBJUEUgcG9saWN5Lgo+ICAgKiBAcDogU3VwcGxpZXMgdGhlIHBv
bGljeSB0byBmcmVlLgo+IEBAIC0yMSw2ICs0OCw3IEBAIHZvaWQgaXBlX2ZyZWVfcG9saWN5KHN0
cnVjdCBpcGVfcG9saWN5ICpwKQo+ICAgICAgICAgaWYgKElTX0VSUl9PUl9OVUxMKHApKQo+ICAg
ICAgICAgICAgICAgICByZXR1cm47Cj4KPiArICAgICAgIGlwZV9kZWxfcG9saWN5ZnNfbm9kZShw
KTsKPiAgICAgICAgIGZyZWVfcGFyc2VkX3BvbGljeShwLT5wYXJzZWQpOwo+ICAgICAgICAgaWYg
KCFwLT5wa2NzNykKPiAgICAgICAgICAgICAgICAga2ZyZWUocC0+dGV4dCk7Cj4gQEAgLTM5LDYg
KzY3LDcwIEBAIHN0YXRpYyBpbnQgc2V0X3BrY3M3X2RhdGEodm9pZCAqY3R4LCBjb25zdCB2b2lk
ICpkYXRhLCBzaXplX3QgbGVuLAo+ICAgICAgICAgcmV0dXJuIDA7Cj4gIH0KPgo+ICsvKioKPiAr
ICogaXBlX3VwZGF0ZV9wb2xpY3kgLSBwYXJzZSBhIG5ldyBwb2xpY3kgYW5kIHJlcGxhY2UgQG9s
ZCB3aXRoIGl0Lgo+ICsgKiBAYWRkcjogU3VwcGxpZXMgYSBwb2ludGVyIHRvIHRoZSBpX3ByaXZh
dGUgZm9yIHNhdmluZyBwb2xpY3kuCj4gKyAqIEB0ZXh0OiBTdXBwbGllcyBhIHBvaW50ZXIgdG8g
dGhlIHBsYWluIHRleHQgcG9saWN5Lgo+ICsgKiBAdGV4dGxlbjogU3VwcGxpZXMgdGhlIGxlbmd0
aCBvZiBAdGV4dC4KPiArICogQHBrY3M3OiBTdXBwbGllcyBhIHBvaW50ZXIgdG8gYSBidWZmZXIg
Y29udGFpbmluZyBhIHBrY3M3IG1lc3NhZ2UuCj4gKyAqIEBwa2NzN2xlbjogU3VwcGxpZXMgdGhl
IGxlbmd0aCBvZiBAcGtjczdsZW4uCj4gKyAqCj4gKyAqIEB0ZXh0L0B0ZXh0bGVuIGlzIG11dHVh
bGx5IGV4Y2x1c2l2ZSB3aXRoIEBwa2NzNy9AcGtjczdsZW4gLSBzZWUKPiArICogaXBlX25ld19w
b2xpY3kuCj4gKyAqCj4gKyAqIFJldHVybjoKPiArICogKiAhSVNfRVJSICAgLSBPSwo+ICsgKiAq
IC1FTk9FTlQgICAtIFBvbGljeSBkb2Vzbid0IGV4aXN0Cj4gKyAqICogLUVJTlZBTCAgIC0gTmV3
IHBvbGljeSBpcyBpbnZhbGlkCj4gKyAqLwo+ICtzdHJ1Y3QgaXBlX3BvbGljeSAqaXBlX3VwZGF0
ZV9wb2xpY3koc3RydWN0IGlwZV9wb2xpY3kgX19yY3UgKiphZGRyLAo+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBjaGFyICp0ZXh0LCBzaXplX3QgdGV4dGxlbiwK
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3QgY2hhciAqcGtjczcs
IHNpemVfdCBwa2NzN2xlbikKPiArewo+ICsgICAgICAgaW50IHJjID0gMDsKPiArICAgICAgIHN0
cnVjdCBpcGVfcG9saWN5ICpvbGQsICpuZXc7Cj4gKwo+ICsgICAgICAgb2xkID0gaXBlX2dldF9w
b2xpY3lfcmN1KCphZGRyKTsKPiArICAgICAgIGlmICghb2xkKSB7Cj4gKyAgICAgICAgICAgICAg
IHJjID0gLUVOT0VOVDsKPiArICAgICAgICAgICAgICAgZ290byBlcnI7Cj4gKyAgICAgICB9Cj4g
Kwo+ICsgICAgICAgbmV3ID0gaXBlX25ld19wb2xpY3kodGV4dCwgdGV4dGxlbiwgcGtjczcsIHBr
Y3M3bGVuKTsKPiArICAgICAgIGlmIChJU19FUlIobmV3KSkgewo+ICsgICAgICAgICAgICAgICBy
YyA9IFBUUl9FUlIobmV3KTsKPiArICAgICAgICAgICAgICAgZ290byBlcnI7Cj4gKyAgICAgICB9
Cj4gKwo+ICsgICAgICAgaWYgKHN0cmNtcChuZXctPnBhcnNlZC0+bmFtZSwgb2xkLT5wYXJzZWQt
Pm5hbWUpKSB7Cj4gKyAgICAgICAgICAgICAgIHJjID0gLUVJTlZBTDsKPiArICAgICAgICAgICAg
ICAgZ290byBlcnI7Cj4gKyAgICAgICB9Cj4gKwo+ICsgICAgICAgaWYgKHZlcl90b191NjQob2xk
KSA+IHZlcl90b191NjQobmV3KSkgewo+ICsgICAgICAgICAgICAgICByYyA9IC1FSU5WQUw7Cj4g
KyAgICAgICAgICAgICAgIGdvdG8gZXJyOwo+ICsgICAgICAgfQo+ICsKPiArICAgICAgIGlmIChp
cGVfaXNfcG9saWN5X2FjdGl2ZShvbGQpKSB7CgpJIGRvbid0IHVuZGVyc3RhbmQgdGhlIGlzLWFj
dGl2ZSBjaGVjaywgeW91IHdhbnQgdG8gbWFrZSBAbmV3IHRoZSBuZXcKYWN0aXZlIHBvbGljeSBy
ZWdhcmRsZXNzLCByaWdodD8gIENvdWxkIHRoaXMgaXMtYWN0aXZlIGNoZWNrIGV2ZXIgYmUKZmFs
c2U/Cgo+ICsgICAgICAgICAgICAgICBzcGluX2xvY2soJmlwZV9wb2xpY3lfbG9jayk7Cj4gKyAg
ICAgICAgICAgICAgIHJjdV9hc3NpZ25fcG9pbnRlcihpcGVfYWN0aXZlX3BvbGljeSwgbmV3KTsK
PiArICAgICAgICAgICAgICAgc3Bpbl91bmxvY2soJmlwZV9wb2xpY3lfbG9jayk7Cj4gKyAgICAg
ICAgICAgICAgIHN5bmNocm9uaXplX3JjdSgpOwo+ICsgICAgICAgfQo+ICsKPiArICAgICAgIHJj
dV9hc3NpZ25fcG9pbnRlcigqYWRkciwgbmV3KTsKPiArCj4gKyAgICAgICBzd2FwKG5ldy0+cG9s
aWN5ZnMsIG9sZC0+cG9saWN5ZnMpOwo+ICsgICAgICAgaXBlX2ZyZWVfcG9saWN5KG9sZCk7Cj4g
Kwo+ICsgICAgICAgZ290byBvdXQ7Cj4gK2VycjoKPiArICAgICAgIGlwZV9mcmVlX3BvbGljeShu
ZXcpOwo+ICtvdXQ6Cj4gKyAgICAgICByZXR1cm4gKHJjIDwgMCkgPyBFUlJfUFRSKHJjKSA6IG5l
dzsKPiArfQo+ICsKPiAgLyoqCj4gICAqIGlwZV9uZXdfcG9saWN5IC0gQWxsb2NhdGUgYW5kIHBh
cnNlIGFuIGlwZV9wb2xpY3kgc3RydWN0dXJlLgo+ICAgKgo+IEBAIC0xMTcsMyArMjA5LDQ2IEBA
IHN0cnVjdCBpcGVfcG9saWN5ICppcGVfZ2V0X3BvbGljeV9yY3Uoc3RydWN0IGlwZV9wb2xpY3kg
X19yY3UgKnApCj4KPiAgICAgICAgIHJldHVybiBydjsKPiAgfQo+ICsKPiArLyoqCj4gKyAqIGlw
ZV9zZXRfYWN0aXZlX3BvbCAtIE1ha2UgQHAgdGhlIGFjdGl2ZSBwb2xpY3kuCj4gKyAqIEBwOiBT
dXBwbGllcyBhIHBvaW50ZXIgdG8gdGhlIHBvbGljeSB0byBtYWtlIGFjdGl2ZS4KPiArICovCj4g
K2ludCBpcGVfc2V0X2FjdGl2ZV9wb2woY29uc3Qgc3RydWN0IGlwZV9wb2xpY3kgKnApCj4gK3sK
PiArICAgICAgIGludCByYyA9IDA7Cj4gKyAgICAgICBzdHJ1Y3QgaXBlX3BvbGljeSAqYXAgPSBO
VUxMOwo+ICsKPiArICAgICAgIGFwID0gaXBlX2dldF9wb2xpY3lfcmN1KGlwZV9hY3RpdmVfcG9s
aWN5KTsKPiArICAgICAgIGlmIChhcCAmJiB2ZXJfdG9fdTY0KGFwKSA+IHZlcl90b191NjQocCkp
IHsKPiArICAgICAgICAgICAgICAgcmMgPSAtRUlOVkFMOwo+ICsgICAgICAgICAgICAgICBnb3Rv
IG91dDsKPiArICAgICAgIH0KPiArCj4gKyAgICAgICBzcGluX2xvY2soJmlwZV9wb2xpY3lfbG9j
ayk7Cj4gKyAgICAgICByY3VfYXNzaWduX3BvaW50ZXIoaXBlX2FjdGl2ZV9wb2xpY3ksIHApOwo+
ICsgICAgICAgc3Bpbl91bmxvY2soJmlwZV9wb2xpY3lfbG9jayk7Cj4gKyAgICAgICBzeW5jaHJv
bml6ZV9yY3UoKTsKPiArCj4gK291dDoKPiArICAgICAgIHJldHVybiByYzsKPiArfQo+ICsKPiAr
LyoqCj4gKyAqIGlwZV9pc19wb2xpY3lfYWN0aXZlIC0gRGV0ZXJtaW5lIHdlaHRoZXIgQHAgaXMg
dGhlIGFjdGl2ZSBwb2xpY3kuCj4gKyAqIEBwOiBTdXBwbGllcyBhIHBvaW50ZXIgdG8gdGhlIHBv
bGljeSB0byBjaGVjay4KPiArICoKPiArICogUmV0dXJuOgo+ICsgKiAqIHRydWUgICAgICAtIEBw
IGlzIHRoZSBhY3RpdmUgcG9saWN5Cj4gKyAqICogZmFsc2UgICAgIC0gQHAgaXMgbm90IHRoZSBh
Y3RpdmUgcG9saWN5Cj4gKyAqLwo+ICtib29sIGlwZV9pc19wb2xpY3lfYWN0aXZlKGNvbnN0IHN0
cnVjdCBpcGVfcG9saWN5ICpwKQo+ICt7Cj4gKyAgICAgICBib29sIHJ2Owo+ICsKPiArICAgICAg
IHJjdV9yZWFkX2xvY2soKTsKPiArICAgICAgIHJ2ID0gcmN1X2FjY2Vzc19wb2ludGVyKGlwZV9h
Y3RpdmVfcG9saWN5KSA9PSBwOwo+ICsgICAgICAgcmN1X3JlYWRfdW5sb2NrKCk7Cj4gKwo+ICsg
ICAgICAgcmV0dXJuIHJ2Owo+ICt9CgotLQpwYXVsLW1vb3JlLmNvbQoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

