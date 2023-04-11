Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52137C7619A
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 20:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681245183;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gviaLY5Y4BFER5sXVDqUqTrUOHzLCFtHGiYTBts2Abg=;
	b=WwT3tBBefNHe2cIBR9QveLpCMi9x/it2f96a9gqT7XXSNY5zc9ALyA49UITBmxZUlmnr3m
	nPDz3RPuZm0FRs1wHkMGnXdkBH7Zpu8MZ6JZJkr+j9CnXyfLI6PQ9XxitHWM5zMxgm3EdL
	HQTwTG/kpJtbBUgdZVZoUW22Uro+k+w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-qDfeqfuaNViLnicys_FICw-1; Tue, 11 Apr 2023 16:33:00 -0400
X-MC-Unique: qDfeqfuaNViLnicys_FICw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E41CA185A7AC;
	Tue, 11 Apr 2023 20:32:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 98DCF492B00;
	Tue, 11 Apr 2023 20:32:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 69EB91946A41;
	Tue, 11 Apr 2023 20:32:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C3BA19466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 20:32:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C81C14171D6; Tue, 11 Apr 2023 20:32:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2475214171D5
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 20:32:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04A113801F6F
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 20:32:55 +0000 (UTC)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com
 [209.85.219.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-3vByq01VMYmPDjfn7Pu9HQ-1; Tue, 11 Apr 2023 16:32:53 -0400
X-MC-Unique: 3vByq01VMYmPDjfn7Pu9HQ-1
Received: by mail-yb1-f175.google.com with SMTP id u13so9716456ybu.5
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 13:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1681245173; x=1683837173;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=ikdi+6xxj2kvpls/7KRBOAg0lIkRgRoVXw8KwuRi4Nc=;
 b=wY2qSvRTt55ue90l2Lzoci2+N5QrcS9EhlIQw0r45tV56duSG70ccNU9h/m94pJfNe
 rirZ5VBEAYCaWTKNZjy6YpcSwBX4UWmZM5Hyqfeu9x9Q5mmzrY1FLzVr7nCp5nOQ3NRo
 YDHMTw9yWTEuJ6H9E3l+Se6oigCsf5FdO+Utq3Ib0dD5KgjVg9U6UczDo8ix2IxAP6Jr
 wWFZiXvWmxc8ZT+RDdzUGBB+HdXS3bMG+zvvh3KrnF2J/jehjyQauLaib9/qwDdYtHyw
 v+F+Osbtq14CJNDGSbGCN44qP5y7y/eO3jykwVYjwINfhaQlJ6yANBdBecOndHdDOHjX
 Du5A==
X-Gm-Message-State: AAQBX9cWCGnM8E+FXVeANchUHV5nol2FZmkdnOHjkJYqAUjhP1IZrLKE
 UOQhqTUH1PGCJ48pGxYa2Lbj8kXi1XXz4M/NLr+A
X-Google-Smtp-Source: AKy350a8DI+fttqPGYGrYWlw3sZUgpf5kan6JSrYFZNA0OIQFLQ5A+goWX5p08tzzrk48yMapO6qwBhOBzk9Q/ypItw=
X-Received: by 2002:a25:d702:0:b0:b68:7a4a:5258 with SMTP id
 o2-20020a25d702000000b00b687a4a5258mr101812ybg.3.1681245172701; Tue, 11 Apr
 2023 13:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhS_EbT7ze4oSHwHfus91VWQfdgGagf=5O7_h+XJ2o79PA@mail.gmail.com>
 <20230410185334.GA18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230410185334.GA18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 11 Apr 2023 16:32:41 -0400
Message-ID: <CAHC9VhTRpDK74iL6A6wt2=--5LmrC7pHZY_BLnHDdfqboA2i1A@mail.gmail.com>
To: Fan Wu <wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [RFC PATCH v9 03/16] ipe: add evaluation loop and
 introduce 'boot_verified' as a trust provider
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBBcHIgMTAsIDIwMjMgYXQgMjo1M+KAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4gT24gVGh1LCBNYXIgMDIsIDIwMjMgYXQgMDI6MDM6MTFQTSAt
MDUwMCwgUGF1bCBNb29yZSB3cm90ZToKPiA+IE9uIE1vbiwgSmFuIDMwLCAyMDIzIGF0IDU6NTg/
Pz9QTSBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOgo+ID4gPgo+ID4g
PiBGcm9tOiBEZXZlbiBCb3dlcnMgPGRldmVuLmRlc2FpQGxpbnV4Lm1pY3Jvc29mdC5jb20+Cj4g
PiA+Cj4gPiA+IElQRSBtdXN0IGhhdmUgYSBjZW50cmFsaXplZCBmdW5jdGlvbiB0byBldmFsdWF0
ZSBpbmNvbWluZyBjYWxsZXJzCj4gPiA+IGFnYWluc3QgSVBFJ3MgcG9saWN5LiBUaGlzIGl0ZXJh
dGlvbiBvZiB0aGUgcG9saWN5IGFnYWluc3QgdGhlIHJ1bGVzCj4gPiA+IGZvciB0aGF0IHNwZWNp
ZmljIGNhbGxlciBpcyBrbm93biBhcyB0aGUgZXZhbHVhdGlvbiBsb29wLgo+ID4gPgo+ID4gPiBJ
biBhZGRpdGlvbiwgSVBFIGlzIGRlc2lnbmVkIHRvIHByb3ZpZGUgc3lzdGVtIGxldmVsIHRydXN0
IGd1YXJhbnRlZXMsCj4gPiA+IHRoaXMgdXN1YWxseSBpbXBsaWVzIHRoYXQgdHJ1c3Qgc3RhcnRz
IGZyb20gYm9vdHVwIHdpdGggYSBoYXJkd2FyZSByb290Cj4gPiA+IG9mIHRydXN0LCB3aGljaCB2
YWxpZGF0ZXMgdGhlIGJvb3Rsb2FkZXIuIEFmdGVyIHRoaXMsIHRoZSBib290bG9hZGVyCj4gPiA+
IHZlcmlmaWVzIHRoZSBrZXJuZWwgYW5kIHRoZSBpbml0cmFtZnMuCj4gPiA+Cj4gPiA+IEFzIHRo
ZXJlJ3Mgbm8gY3VycmVudGx5IHN1cHBvcnRlZCBpbnRlZ3JpdHkgbWV0aG9kIGZvciBpbml0cmFt
ZnMsIGFuZAo+ID4gPiBpdCdzIHR5cGljYWxseSBhbHJlYWR5IHZlcmlmaWVkIGJ5IHRoZSBib290
bG9hZGVyLCBpbnRyb2R1Y2UgYSBwcm9wZXJ0eQo+ID4gPiB0aGF0IGNhdXNlcyB0aGUgZmlyc3Qg
c3VwZXJibG9jayB0byBoYXZlIGFuIGV4ZWN1dGlvbiB0byBiZSAicGlubmVkIiwKPiA+ID4gd2hp
Y2ggaXMgdHlwaWNhbGx5IGluaXRyYW1mcy4KPiA+ID4KPiA+ID4gU2lnbmVkLW9mZi1ieTogRGV2
ZW4gQm93ZXJzIDxkZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29tPgo+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBGYW4gV3UgPHd1ZmFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+Cj4gPgo+ID4gLi4uCj4g
Pgo+ID4gPiAtLS0KPiA+ID4gIHNlY3VyaXR5L2lwZS9NYWtlZmlsZSAgICAgICAgfCAgIDEgKwo+
ID4gPiAgc2VjdXJpdHkvaXBlL2V2YWwuYyAgICAgICAgICB8IDE4MCArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKwo+ID4gPiAgc2VjdXJpdHkvaXBlL2V2YWwuaCAgICAgICAgICB8
ICAyOCArKysrKysKPiA+ID4gIHNlY3VyaXR5L2lwZS9ob29rcy5jICAgICAgICAgfCAgMjUgKysr
KysKPiA+ID4gIHNlY3VyaXR5L2lwZS9ob29rcy5oICAgICAgICAgfCAgMTQgKysrCj4gPiA+ICBz
ZWN1cml0eS9pcGUvaXBlLmMgICAgICAgICAgIHwgICAxICsKPiA+ID4gIHNlY3VyaXR5L2lwZS9w
b2xpY3kuYyAgICAgICAgfCAgMjAgKysrKwo+ID4gPiAgc2VjdXJpdHkvaXBlL3BvbGljeS5oICAg
ICAgICB8ICAgMyArCj4gPiA+ICBzZWN1cml0eS9pcGUvcG9saWN5X3BhcnNlci5jIHwgICA4ICst
Cj4gPiA+ICA5IGZpbGVzIGNoYW5nZWQsIDI3OSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
Cj4gPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgc2VjdXJpdHkvaXBlL2V2YWwuYwo+ID4gPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IHNlY3VyaXR5L2lwZS9ldmFsLmgKPiA+ID4gIGNyZWF0ZSBtb2RlIDEw
MDY0NCBzZWN1cml0eS9pcGUvaG9va3MuYwo+ID4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHNlY3Vy
aXR5L2lwZS9ob29rcy5oCgouLi4KCj4gPiA+IGRpZmYgLS1naXQgYS9zZWN1cml0eS9pcGUvZXZh
bC5jIGIvc2VjdXJpdHkvaXBlL2V2YWwuYwo+ID4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NAo+ID4g
PiBpbmRleCAwMDAwMDAwMDAwMDAuLjQ4YjUxMDRhMzQ2Mwo+ID4gPiAtLS0gL2Rldi9udWxsCj4g
PiA+ICsrKyBiL3NlY3VyaXR5L2lwZS9ldmFsLmMKPiA+ID4gQEAgLTAsMCArMSwxODAgQEAKPiA+
ID4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCj4gPiA+ICsvKgo+ID4gPiAr
ICogQ29weXJpZ2h0IChDKSBNaWNyb3NvZnQgQ29ycG9yYXRpb24uIEFsbCByaWdodHMgcmVzZXJ2
ZWQuCj4gPiA+ICsgKi8KPiA+ID4gKwo+ID4gPiArI2luY2x1ZGUgImlwZS5oIgo+ID4gPiArI2lu
Y2x1ZGUgImV2YWwuaCIKPiA+ID4gKyNpbmNsdWRlICJob29rcy5oIgo+ID4gPiArI2luY2x1ZGUg
InBvbGljeS5oIgo+ID4gPiArCj4gPiA+ICsjaW5jbHVkZSA8bGludXgvZnMuaD4KPiA+ID4gKyNp
bmNsdWRlIDxsaW51eC90eXBlcy5oPgo+ID4gPiArI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KPiA+
ID4gKyNpbmNsdWRlIDxsaW51eC9maWxlLmg+Cj4gPiA+ICsjaW5jbHVkZSA8bGludXgvc2NoZWQu
aD4KPiA+ID4gKyNpbmNsdWRlIDxsaW51eC9yY3VwZGF0ZS5oPgo+ID4gPiArI2luY2x1ZGUgPGxp
bnV4L3NwaW5sb2NrLmg+Cj4gPiA+ICsKPiA+ID4gK3N0cnVjdCBpcGVfcG9saWN5IF9fcmN1ICpp
cGVfYWN0aXZlX3BvbGljeTsKPiA+ID4gKwo+ID4gPiArc3RhdGljIHN0cnVjdCBzdXBlcl9ibG9j
ayAqcGlubmVkX3NiOwo+ID4gPiArc3RhdGljIERFRklORV9TUElOTE9DSyhwaW5fbG9jayk7Cj4g
PiA+ICsjZGVmaW5lIEZJTEVfU1VQRVJCTE9DSyhmKSAoKGYpLT5mX3BhdGgubW50LT5tbnRfc2Ip
Cj4gPiA+ICsKPiA+ID4gKy8qKgo+ID4gPiArICogcGluX3NiIC0gUGluIHRoZSB1bmRlcmx5aW5n
IHN1cGVyYmxvY2sgb2YgQGYsIG1hcmtpbmcgaXQgYXMgdHJ1c3RlZC4KPiA+ID4gKyAqIEBmOiBT
dXBwbGllcyBhIGZpbGUgc3RydWN0dXJlIHRvIHNvdXJjZSB0aGUgc3VwZXJfYmxvY2sgZnJvbS4K
PiA+ID4gKyAqLwo+ID4gPiArc3RhdGljIHZvaWQgcGluX3NiKGNvbnN0IHN0cnVjdCBmaWxlICpm
KQo+ID4gPiArewo+ID4gPiArICAgICAgIGlmICghZikKPiA+ID4gKyAgICAgICAgICAgICAgIHJl
dHVybjsKPiA+ID4gKyAgICAgICBzcGluX2xvY2soJnBpbl9sb2NrKTsKPiA+ID4gKyAgICAgICBp
ZiAocGlubmVkX3NiKQo+ID4gPiArICAgICAgICAgICAgICAgZ290byBvdXQ7Cj4gPiA+ICsgICAg
ICAgcGlubmVkX3NiID0gRklMRV9TVVBFUkJMT0NLKGYpOwo+ID4gPiArb3V0Ogo+ID4gPiArICAg
ICAgIHNwaW5fdW5sb2NrKCZwaW5fbG9jayk7Cj4gPiA+ICt9Cj4gPgo+ID4gU2luY2UgeW91IGRv
bid0IGFjdHVhbGx5IHVzZSBAZiwganVzdCB0aGUgc3VwZXJfYmxvY2ssIHlvdSBtaWdodAo+ID4g
Y29uc2lkZXIgcGFzc2luZyB0aGUgc3VwZXJfYmxvY2sgYXMgdGhlIHBhcmFtZXRlciBhbmQgbm90
IHRoZQo+ID4gYXNzb2NpYXRlZCBmaWxlLgo+ID4KPiA+IEknZCBwcm9iYWJseSBhbHNvIGZsaXAg
dGhlIGlmLXRoZW4gdG8gYXZvaWQgdGhlICdnb3RvJywgZm9yIGV4YW1wbGU6Cj4gPgo+ID4gICBz
dGF0aWMgdm9pZCBwaW5fc2IoY29uc3Qgc3RydWN0IHN1cGVyX2Jsb2NrICpzYikKPiA+ICAgewo+
ID4gICAgIGlmICghc2IpCj4gPiAgICAgICByZXR1cm47Cj4gPiAgICAgc3Bpbl9sb2NrKCZwaW5f
bG9jayk7Cj4gPiAgICAgaWYgKCFwaW5uZWRfc2IpCj4gPiAgICAgICBwaW5uZWRfc2IgPSBzYjsK
PiA+ICAgICBzcGluX3VubG9jaygmcGluX2xvY2spOwo+ID4gICB9Cj4gPgo+Cj4gU3VyZSwgSSBj
YW4gY2hhbmdlIHRoZSBjb2RlIGFjY29yZGluZ2x5Lgo+Cj4gPiBBbHNvLCBkbyB3ZSBuZWVkIHRv
IHdvcnJ5IGFib3V0IHRoZSBpbml0cmFtZnMnIGJlaW5nIHVubW91bnRlZCBhbmQgdGhlCj4gPiBz
dXBlcl9ibG9jayBnb2luZyBhd2F5Pwo+Cj4gSWYgaW5pdHJhbWZzIGlzIGJlaW5nIHVubW91bnRl
ZCwgdGhlIGJvb3RfdmVyaWZpZWQgcHJvcGVydHkgd2lsbCBuZXZlciBiZSBUUlVFLAo+IHdoaWNo
IGlzIGFuIGV4cGVjdGVkIGJlaGF2aW9yLiBJbiBhbiBhY3R1YWwgdXNlIGNhc2UsIHdlIGNhbiBs
ZXZlcmFnZSB0aGlzCj4gcHJvcGVydHkgdG8gb25seSBlbmFibGUgZmlsZXMgaW4gaW5pdHJhbWZz
IGR1cmluZyB0aGUgYm9vdGluZyBzdGFnZSwgYW5kIGxhdGVyIHN3aXRjaAo+IHRvIGFub3RoZXIg
cG9saWN5IHdpdGhvdXQgdGhlIGJvb3RfdmVyaWZpZWQgcHJvcGVydHkgYWZ0ZXIgdW5tb3VudGlu
ZyB0aGUgaW5pdHJhbWZzLgo+IFRoaXMgYXBwcm9hY2ggaGVscHMga2VlcCB0aGUgYWxsb3dlZCBz
ZXQgb2YgZmlsZXMgbWluaW11bSBhdCBlYWNoIHN0YWdlLgoKSSB0aGluayBJIHdhcyB3b3JyaWVk
IGFib3V0IG5vdCBjYXRjaGluZyB3aGVuIHRoZSBmcyB3YXMgdW5tb3VudGVkIGFuZAp0aGUgc3Vw
ZXJibG9jayBkaXNhcHBlYXJlZCwgYnV0IHlvdSd2ZSBnb3QgYSBob29rIGRlZmluZWQgZm9yIHRo
YXQgc28KaXQgc2hvdWxkIGJlIG9rYXkuICBJJ20gbm90IHN1cmUgd2hhdCBJIHdhcyB0aGlua2lu
ZyBoZXJlLCBzb3JyeSBmb3IKdGhlIG5vaXNlIC4uLgoKUmVnYXJkbGVzcyBvZiB0aGUgc291cmNl
IG9mIG15IGNvbmZ1c2lvbiwgeW91ciBwb2xpY3kvYm9vdF92ZXJpZmllZApkZXNjcmlwdGlvbiBh
bGwgc291bmRzIGdvb2QgdG8gbWUuCgotLSAKcGF1bC1tb29yZS5jb20KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

