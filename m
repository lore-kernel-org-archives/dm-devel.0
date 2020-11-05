Return-Path: <SRS0=33od=EL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854A4C2D0A3
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 02:33:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C38A92074B
	for <dm-devel@archiver.kernel.org>; Thu,  5 Nov 2020 02:33:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C38A92074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=purestorage.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-lsjUEOEEOAWNbMMhp2KWfw-1; Wed, 04 Nov 2020 21:33:16 -0500
X-MC-Unique: lsjUEOEEOAWNbMMhp2KWfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61332107465D;
	Thu,  5 Nov 2020 02:33:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84C225C5DE;
	Thu,  5 Nov 2020 02:33:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8EC08180B658;
	Thu,  5 Nov 2020 02:33:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A52X5jb006429 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 21:33:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 405858364A; Thu,  5 Nov 2020 02:33:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B265C612B
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 02:33:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C24C7185A790
	for <dm-devel@redhat.com>; Thu,  5 Nov 2020 02:33:01 +0000 (UTC)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
	[209.85.215.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-472-n-cQrq8GNxiSkwZYsnJUoA-1; Wed, 04 Nov 2020 21:32:59 -0500
X-MC-Unique: n-cQrq8GNxiSkwZYsnJUoA-1
Received: by mail-pg1-f171.google.com with SMTP id u4so189650pgr.9
	for <dm-devel@redhat.com>; Wed, 04 Nov 2020 18:32:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:content-transfer-encoding:mime-version
	:subject:message-id:date:to;
	bh=I8LBTo18vknDJIgs75iUMpR5CjYULx8w03V8nJfwTm4=;
	b=f0t7JqFUeVC3z3SpJ8fjfY1wOJxnJTci8zUN7v7yEhjS/vtIhqMD2q6Uaqc7vMVOPX
	oQu/HJCshD052Sqqx2WwudHq3Pg8XepphLcUDtsMljBwd8ypmGGaCXzNO7MGYjPHBua1
	bq6tBxk1DpmDb+DlN5q4k40gtdyr7Czs8N3J9ULKOlq+zkEAlJZoP0X/p8UmtzMK+Xo3
	0gctbt/NpD1KZrJ3/rBlwFRqiolV7SSnRee57e3rM4123sSmmrTQell9O5nkiCkOOKUv
	09k2t0bsKbZyxPSJfg5E4cUqpRcIhJtXoJPDQ/OFplZuFJnebybIMEx5gwYyTvuuRAA7
	Qjag==
X-Gm-Message-State: AOAM530WVY9KIl7cTcsPFg15C3qf2WQI9Sg3++VDWbD16ML+ZWXjNPuV
	GwaPmYN9RnYvCNEXDeJItpP0hF+Zz5S/uWR8Kpvo7VLz2C2Rd6Wc5o5IwhGV2U8WyGBFiea9YE+
	R72HYSEzRpftFNLchQGLq+9zTspPhndjGwk1ORPA/b15YOlHkZIzFPYw3vdascu6NxtoRIA==
X-Google-Smtp-Source: ABdhPJwyC8vnGcOZNis9LNbnk3Yiv1+hJkz+2OhJ2F9IyImqzSFQmukYwGgPPZggBnrQcZBL19laXw==
X-Received: by 2002:a63:c00c:: with SMTP id h12mr300483pgg.237.1604543577802; 
	Wed, 04 Nov 2020 18:32:57 -0800 (PST)
Received: from [10.231.221.188] ([192.30.189.3])
	by smtp.gmail.com with ESMTPSA id b7sm208735pfr.171.2020.11.04.18.32.55
	for <dm-devel@redhat.com>
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 04 Nov 2020 18:32:56 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.1\))
Message-Id: <83E54997-B7F0-4A47-94B0-54BA6EE7FE37@purestorage.com>
Date: Wed, 4 Nov 2020 18:32:55 -0800
To: device-mapper development <dm-devel@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A52X5jb006429
X-loop: dm-devel@redhat.com
Subject: [dm-devel] A device existing in two different multpath devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8gYWxsLAoKV2UgaGF2ZSBydW4gaW50byBzaXR1YXRpb25zIGludGVybmFsbHkgd2hlcmUg
d2UgZW5kIHVwIHdpdGggU0NTSSBkZXZpY2VzIGVuZGluZyB1cCBpbiB0d28gbXVsdGlwYXRoIGRl
dmljZXM6CgozNjI0YTkzNzBjMDc4NzcxMDJiMTQzNjk5MDAwMTFmZDEgZG0tOSBQVVJFICAgICxG
bGFzaEFycmF5ICAgICAgCnNpemU9NTAwRyBmZWF0dXJlcz0nMCcgaHdoYW5kbGVyPScxIGFsdWEn
IHdwPXJ3CmAtKy0gcG9saWN5PSdzZXJ2aWNlLXRpbWUgMCcgcHJpbz01MCBzdGF0dXM9YWN0aXZl
CiAgfC0gMDowOjA6NiAgc2RlZyAxMjg6MTI4IGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gMDow
OjE6NiAgc2RlcSAxMjk6MzIgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gMDowOjI6NiAgc2Rm
YSAxMjk6MTkyIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gNzowOjA6NiAgc2R4ICA2NToxMTIg
IGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gNzowOjE6NiAgc2RhaCA2NjoxNiAgIGFjdGl2ZSBy
ZWFkeSBydW5uaW5nCiAgfC0gNzowOjI6NiAgc2RjaSA2OTo5NiAgIGFjdGl2ZSByZWFkeSBydW5u
aW5nCiAgfC0gNzowOjM6NiAgc2RuICA4OjIwOCAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0g
ODowOjA6NiAgc2RiYiA2Nzo4MCAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gODowOjE6NiAg
c2RidCA2ODoxMTIgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gODowOjI6NiAgc2RjeCA3MDo4
MCAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gODowOjM6NiAgc2RhciA2NjoxNzYgIGFjdGl2
ZSByZWFkeSBydW5uaW5nCiAgfC0gOTowOjA6NiAgc2RkaiA3MToxNiAgIGFjdGl2ZSByZWFkeSBy
dW5uaW5nCiAgfC0gOTowOjE6NiAgc2RjcSA2OToyMjQgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAg
fC0gOTowOjI6NiAgc2RkdCA3MToxNzYgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgfC0gOTowOjM6
NiAgc2RibyA2ODozMiAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCiAgYC0gMDowOjM6NiAgc2RnICA4
Ojk2ICAgIGFjdGl2ZSByZWFkeSBydW5uaW5nCgpBbmQgdGhpcyBvbmU6ClNQVVJFX0ZsYXNoQXJy
YXlfQzA3ODc3MTAyQjE0MzY5OTAwMDExRkQxIGRtLTEzIFBVUkUgICAgLEZsYXNoQXJyYXkgICAg
ICAKc2l6ZT01MDBHIGZlYXR1cmVzPScwJyBod2hhbmRsZXI9JzEgYWx1YScgd3A9cncKYC0rLSBw
b2xpY3k9J3NlcnZpY2UtdGltZSAwJyBwcmlvPTUwIHN0YXR1cz1hY3RpdmUKICBgLSAwOjA6Mzo2
ICBzZGcgIDg6OTYgICAgYWN0aXZlIHJlYWR5IHJ1bm5pbmcKCldoYXQgdGhpcyBjb21lcyBkb3du
IHRvIHNlZW1zIHRvIGxpZSB3aXRoIHRoZSBzY3NpX2lkIGFwcGxpY2F0aW9uIGluY2x1ZGVkIGlu
Y2x1ZGVkIHdpdGggdWRldi4gVGhpcyBydW5zIG91dCBvZiBhIHVkZXYgcnVsZSB3aGVuIFNDU0kg
ZGV2aWNlcyBhcmUgZGlzY292ZXJlZC4gV2hhdCBoYXBwZW5zIHNlZW1zIHRvIGJlIGEgZmFpbHVy
ZSBpbiBwYWdlIDB4ODMgSU5RVUlSWSBpbiBnZXR0aW5nIHRoZSBzZXJpYWwgbnVtYmVyIG9mIHRo
ZSBkZXZpY2UgdG8gdXNlIGluIG11bHRpcGF0aC4KCldoZW4gcGFnZSAweDgzIElOUVVJUlkgZmFp
bHMsIGluc3RlYWQgb2YgZ2V0dGluZyB0aGUgZXhwZWN0ZWQgMzYyNGE5MzcwYzA3ODc3MTAyYjE0
MzY5OTAwMDExZmQxIGl0IGZhbGxzIGJhY2sgdG8gYSBwYWdlIDB4ODAgSU5RVUlSWSB3aGVyZSBp
dCBzdGl0Y2hlcyB0b2dldGhlciDigJlT4oCZICsgdmVuZG9yIG5hbWUgKyBtb2RlbCBuYW1lICsg
TFVOIHNlcmlhbCBudW1iZXIgYW5kIHdlIGVuZCB1cCB3aXRoIHRoaXMgU1BVUkVfRmxhc2hBcnJh
eV9DMDc4NzcxMDJCMTQzNjk5MDAwMTFGRDEuCgpBIHF1aWNrIGxvb2sgc2hvd3MgdGhhdCB0aGUg
TFVOIHNlcmlhbCBudW1iZXIgaW4gYm90aCBjYXNlcyBpcyB0aGUgc2FtZSwgQzA3ODc3MTAyQjE0
MzY5OTAwMDExRkQxLiBXZSBlbmQgdXAgd2l0aCB0d28gbXVsdGlwYXRoIGRldmljZXMgc2luY2Ug
dGhlIG5hbWUgbXVsdGlwYXRoIHVzZXMgaXMgbm90IHRoZSBzYW1lLiBJIGNhbiBjcmVhdGUgdGhl
IHNpdHVhdGlvbiBtYW51YWxseSBieSByZXNjYW5uaW5nIGF0IGp1c3QgdGhlIHJpZ2h0IHRpbWUg
Zm9yY2luZyB0aGUgcGFnZSAweDgzIElOUVVJUlkgdG8gZmFpbCB3aGVuIG1hbnVhbGx5IHJ1bm5p
bmcgc2NzaV9pZC4gSSBhc3N1bWUgdGhhdCB0aGlzIGlzIHdoYXQgaGFwcGVucyBhcyB0aGUgZGV2
aWNlcyBhcnJpdmUgYW5kIHRoZSB1ZGV2IHJ1bGUgcnVucyBiYXNlZCBvbiB0aGUgbmFtZS4gSSBh
bSBub3QgZXhhY3RseSBzdXJlIHdoZXJlIGluIHRoZSBjaGFpbiB0byBibGFtZSBmb3IgdGhlIGNy
ZWF0aW9uIG9mIHRoZSB0d28gbXVsdGlwYXRoIGRldmljZXMuIEkgYW0gbm90IHN1cmUgdGhhdCBt
dWx0aXBhdGggaXMgbm90IGp1c3QgdGhlIHZpY3RpbSBvZiB1ZGV2LCBidXQgSSBleHBlY3QgdGhh
dCB0aGlzIGJlaGF2aW9yIGlzIG5vdCB3aGF0IG11bHRpcGF0aCB3b3VsZCBldmVyIHdhbnQgdG8g
ZG8gc2luY2UgaXQgaXMgYSBjZXJ0YWluIGNvcnJ1cHRpb24gd2hlbiBpdCBoYXBwZW5zLgoKQW55
IGlkZWFzIG9yIGluc2lnaHQgb24gd2hhdCBjb3VsZCBrZWVwIHVzIG91dCBvZiB0aGlzIHNpdHVh
dGlvbiB3b3VsZCBiZSBhcHByZWNpYXRlZC4KClRoYW5rcywKQnJpYW4KCkJyaWFuIEJ1bmtlcgpT
VyBFbmcKYnJpYW5AcHVyZXN0b3JhZ2UuY29tCgoKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGlu
Zm8vZG0tZGV2ZWw=

