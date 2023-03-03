Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A85C7EE32
	for <dm-devel@archiver.kernel.org>; Fri,  3 Mar 2023 17:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677863964;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2h4GuUULQ2InRysNwVK2f/8+aYf5lFWFPAxaIBMDyEM=;
	b=GRqr+PtKztP8RI6TJAm/K6oE+CQK6MueVDF8Dl1BkZD+j461G2CAC4/MVYhFF08+Cf7zzf
	0LWee+k6cSQW11+8U0PBKJ2e7MH07m/wy7+3qqfR/cRUhNQPe1hBKtvra8A1+pEDX3Gy7q
	6ZXdaeNoiE1meXQhJzXJnjQWDS/nsd4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-DeAL6iXmOtaso9zETCVNLg-1; Fri, 03 Mar 2023 12:19:18 -0500
X-MC-Unique: DeAL6iXmOtaso9zETCVNLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FB2D1871D9B;
	Fri,  3 Mar 2023 17:18:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 575B31121315;
	Fri,  3 Mar 2023 17:18:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0CF8219452CD;
	Fri,  3 Mar 2023 17:18:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7FE8019465A0
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Mar 2023 17:18:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6246D492B00; Fri,  3 Mar 2023 17:18:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ABB4492C3E
 for <dm-devel@redhat.com>; Fri,  3 Mar 2023 17:18:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CFE285A5B1
 for <dm-devel@redhat.com>; Fri,  3 Mar 2023 17:18:32 +0000 (UTC)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-JGU7FsrEM1u_iUsqXvs5uA-1; Fri, 03 Mar 2023 12:18:30 -0500
X-MC-Unique: JGU7FsrEM1u_iUsqXvs5uA-1
Received: by mail-pj1-f48.google.com with SMTP id l1so3236719pjt.2
 for <dm-devel@redhat.com>; Fri, 03 Mar 2023 09:18:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677863909;
 h=to:references:message-id:content-transfer-encoding:cc:date
 :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=K2gkbSyui6NI31xJNvKOjMiWZIht1fU1O2ZlrqbSWvk=;
 b=8DGf+e6F8vIbd1nTh/NKuGGjUEPWWB1H+JNKyNs0JIt/sa8OafuCo+6drMsOEtHS44
 OFx0aMPeQQAw52bRkqo6JS5bNNGoXYd5Ny/qXJ+bwOzrTJhAfLxl5sW6GZiUV/uOcqh7
 G6RPwAUX9aoAAyhloqZEiHLMTceEvLr/KyQhnS+KEJEVXfORcL05Is5mSFr7gtpvVBHK
 ckJkkzW9vbT0byiKBXSjRP9k1LlebfOjE2Gib6YGK9oRXbLge0vqWaaM5+ln/1Yr7cjv
 eBDRGrRU9IpP5L2VNkIUyY5XkvczPt1OHIob6nqlrx1idqavSQ3tBLFy4kntDg0HwPCQ
 U2Bw==
X-Gm-Message-State: AO0yUKXhunjSj37DwfDn9+AYvvvlmyZNaBDVMg/d1m09iAMFsnXAeF+u
 tK7OylIAMxeTSBVhURng+vMfvw==
X-Google-Smtp-Source: AK7set+CHpGBKw2Q8IpJGP7KAhgenARy6wxmfCJ1l9SgSOMdv+9TwuAXs7rYMbcRyDnAqsXpVa3O0Q==
X-Received: by 2002:a17:903:22cc:b0:19c:d5a5:1f52 with SMTP id
 y12-20020a17090322cc00b0019cd5a51f52mr3368844plg.18.1677863909199; 
 Fri, 03 Mar 2023 09:18:29 -0800 (PST)
Received: from smtpclient.apple ([2600:1700:6970:bea0:2c12:90e1:5bab:1d14])
 by smtp.gmail.com with ESMTPSA id
 lf4-20020a170902fb4400b0019b4ee071ddsm1756713plb.209.2023.03.03.09.18.26
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 03 Mar 2023 09:18:27 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
From: Brian Bunker <brian@purestorage.com>
In-Reply-To: <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
Date: Fri, 3 Mar 2023 09:18:15 -0800
Message-Id: <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
To: Martin Wilck <mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBPbiBNYXIgMiwgMjAyMywgYXQgMTE6NDYgUE0sIE1hcnRpbiBXaWxjayA8bXdpbGNrQHN1c2Uu
Y29tPiB3cm90ZToKPiAKPiBPbiBUdWUsIDIwMjMtMDItMjEgYXQgMTI6NTYgLTA4MDAsIEJyaWFu
IEJ1bmtlciB3cm90ZToKPj4gQSB0ZXN0IHVuaXQgcmVhZHkgY29tbWFuZCBzZW50IG9uIGEgcGF0
aCBpbiBzdGFuZGJ5IHN0YXRlIHdpbGwgbm90Cj4+IHJlc3VsdAo+PiBpbiBhIGZhaWxlZCBwYXRo
LiBUaGUgc2FtZSBzaG91bGQgYmUgdHJ1ZSBmb3IgYSBwYXRoIGluIHRoZQo+PiB0cmFuc2l0aW9u
aW5nIHN0YXRlLgo+PiAKPj4gU2lnbmVkLW9mZi1ieTogQnJpYW4gQnVua2VyIGJyaWFuQHB1cmVz
dG9yYWdlLmNvbQo+IAo+IEluIGdlbmVyYWwsIEknbSBzb21ld2hhdCByZWx1Y3RhbnQgdG8gY2hh
bmdlIHRoaW5ncyBpbiB0aGlzIGFyZWEuCj4gR0hPU1Qgc3RhdGUgaXMgbm90IGNsZWFybHkgZGVm
aW5lZCwgdW5mb3J0dW5hdGVseTsgaXQgaGFzIGV2b2x2ZWQgCj4gZnJvbSB0aGUgb3JpZ2luYWwg
ImlucSBzdWNjZWVkcyBidXQgdHVyIGZhaWxzIiB0byBhIHNvbWV3aGF0IGhhbmQtCj4gd2F2aW5n
ICJzb21ldGhpbmcgaW4gYmV0d2VlbiBmYWlsZWQgYW5kIHVwIiBzZW1hbnRpY3MuIAo+IAo+IElu
dGVybmFsbHksIG11bHRpcGF0aGQgdHJlYXRzIEdIT1NUIHBhdGhzIGFsbW9zdCBleGFjdGx5IGxp
a2UgVVAgcGF0aHMsCj4gZXhjZXB0IHRoYXQgdGhleSBnZXQgYSBkaWZmZXJlbnQgcHJpb3JpdHkg
YXNzaWduZWQuIElmIGZvciB3aGF0ZXZlcgo+IHJlYXNvbiBtdWx0aXBhdGhkIHN3aXRjaGVzIHRv
IGEgUEcgaW4gdGhpcyBzdGF0ZSwgdGhlIHBhdGggc3RhdGUgaXMKPiBoaWdobHkgbGlrZWx5IHRv
IHN3aXRjaCB0byBGQUlMRUQgc29vbiBhZnRlciwgYXMgcmVndWxhciBJTyB3aWxsIGZhaWwKPiBv
biB0aGVzZSBwYXRoczsgYXQgbGVhc3Qgd2l0aG91dCBleHBsaWNpdCBBTFVBLiBJcyB0aGF0IHdo
YXQgd2Ugd2FudCB0bwo+IHNlZSBmb3IgVFJBTlNJVElPTklORyBzdGF0ZT8KPiAKPiBCdXQgeWVz
LCB0aGlzIGNoYW5nZSBpcyBpbiB0aGUgc3Bpcml0IG9mIDVkYTY0MmYgKCJSZXR1cm4gJ2dob3N0
JyBzdGF0ZQo+IHdoZW4gcG9ydCBpcyBpbiBzdGFuZGJ5IikuCj4gCj4gQ0MnaW5nIEJlbiBmb3Ig
Y29uZmlybWF0aW9uLgo+IAo+IFJldmlld2VkLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNl
LmNvbT4KSGVsbG8gTWFydGluLCAKCkRvZXNu4oCZdCAic29tZXRoaW5nIGluIGJldHdlZW4gZmFp
bGVkIGFuZCB1cOKAnSBzZW1hbnRpY3MgZGVzY3JpYmUgQUxVQSBzdGF0ZSB0cmFuc2l0aW9uaW5n
IHByZXR0eSB3ZWxsPwoKVGhhbmtzLApCcmlhbgo+IAo+IAo+IAo+PiAtLS0KPj4gIGxpYm11bHRp
cGF0aC9jaGVja2Vycy90dXIuYyB8IDUgKysrLS0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+IAo+PiBkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRo
L2NoZWNrZXJzL3R1ci5jCj4+IGIvbGlibXVsdGlwYXRoL2NoZWNrZXJzL3R1ci5jCj4+IGluZGV4
IDU1MWRjNGYwLi5mZmY3OTg3YiAxMDA2NDQKPj4gLS0tIGEvbGlibXVsdGlwYXRoL2NoZWNrZXJz
L3R1ci5jCj4+ICsrKyBiL2xpYm11bHRpcGF0aC9jaGVja2Vycy90dXIuYwo+PiBAQCAtMTc5LDEw
ICsxNzksMTEgQEAgcmV0cnk6Cj4+ICAgICAgICAgICAgICAgICBlbHNlIGlmIChrZXkgPT0gMHgy
KSB7Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgIC8qIE5vdCBSZWFkeSAqLwo+PiAgICAgICAg
ICAgICAgICAgICAgICAgICAvKiBOb3RlOiBPdGhlciBBTFVBIHN0YXRlcyBhcmUgZWl0aGVyIFVQ
IG9yCj4+IERPV04gKi8KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgaWYoIGFzYyA9PSAweDA0
ICYmIGFzY3EgPT0gMHgwYil7Cj4+ICsgICAgICAgICAgICAgICAgICAgICAgIGlmIChhc2MgPT0g
MHgwNCAmJgo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgKGFzY3EgPT0gMHgwYiB8fCBh
c2NxID09IDB4MGEpKSB7Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLyoKPj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBMT0dJQ0FMIFVOSVQgTk9UIEFDQ0VT
U0lCTEUsCj4+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogVEFSR0VUIFBPUlQg
SU4gU1RBTkRCWSBTVEFURQo+PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIFRB
UkdFVCBQT1JUIElOIFNUQU5EQlkgT1IKPj4gVFJBTlNJVElPTiBTVEFURQo+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAqLwo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICptc2dpZCA9IENIRUNLRVJfTVNHSURfR0hPU1Q7Cj4+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcmV0dXJuIFBBVEhfR0hPU1Q7Cj4+IC0tCj4+IAo+PiAtLQo+PiBkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKPj4gZG0tZGV2ZWxAcmVkaGF0LmNvbQo+PiBodHRwczovL2xpc3RtYW4u
cmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCgoKLS0KZG0tZGV2ZWwgbWFpbGlu
ZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFp
bG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

