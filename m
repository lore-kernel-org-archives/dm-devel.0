Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B4CC4363A
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 13:55:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 447402071A
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 13:55:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 447402071A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-IX2ZVwMEM5uPGAz3L2loDQ-1; Fri, 30 Oct 2020 09:55:54 -0400
X-MC-Unique: IX2ZVwMEM5uPGAz3L2loDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01AEC101F003;
	Fri, 30 Oct 2020 13:55:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA55F5C1C4;
	Fri, 30 Oct 2020 13:55:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7457D181A06B;
	Fri, 30 Oct 2020 13:55:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09UBKpcI007420 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 07:20:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0EA57F00FB; Fri, 30 Oct 2020 11:20:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09439F00F2
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 11:20:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1939185A794
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 11:20:48 +0000 (UTC)
Received: from mail-yb1-f193.google.com (mail-yb1-f193.google.com
	[209.85.219.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-583-2qgwF75PNH-NyHCz-PrM5A-1; Fri, 30 Oct 2020 07:20:46 -0400
X-MC-Unique: 2qgwF75PNH-NyHCz-PrM5A-1
Received: by mail-yb1-f193.google.com with SMTP id a12so4777992ybg.9
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 04:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc:content-transfer-encoding;
	bh=G9dXGMHL3LoWEWUdy1Ms+BhIgQ35oL2d5aGD3k8A1UE=;
	b=RdngovMvt0/LV+oM/06FhkPeufmEOBfQeZNDGegQu6qCX2quRoiL8n7FxcZxaD4NKP
	HB4FGmmIfY/+201afLniiDwXUmZge7haytTj9D+KIsfb3oiOhPlVz/AIGU4dtB2gJSqa
	QZKCen9TdvdOujMClXXPlTDSgCaDzVpVSwo5JuavrODtoqHKIlBvz35O7fOMw/pxJnTL
	FnUomkk8BllpIXDbWih1FR3wbJJaEfdUaShyAkrGTjaHa24c0bAkAkswnUQzYm45GVM5
	zhDj7fkd8szuckynobLGJs4luRODoDzVxz6lPIL8GAls7+Q3DDcDmrdBMQfDPpsTENvB
	DzHg==
X-Gm-Message-State: AOAM530dVfT2giIt66pJDfYqnjSNBvWk3H6lLRu5uiaEUH3PNwjiVIFV
	vBFkgtsuUpndrTNbHacxsWLOGHriwXeYMO9awNOUiQ==
X-Google-Smtp-Source: ABdhPJzra1pMG5DWzyNsqxZMtv8L71QZ9N4kNvy1uCXEHLUKRwFRdAqW8KJMoQPn5ok9GmGGT6GuLe6CgauTI6lkDu8=
X-Received: by 2002:a5b:389:: with SMTP id k9mr2590084ybp.75.1604056845834;
	Fri, 30 Oct 2020 04:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201029100546.28686-1-gilad@benyossef.com>
	<20201029100546.28686-2-gilad@benyossef.com>
	<3a4804a5-5d5c-1216-1503-c241cc24f3c2@gmail.com>
In-Reply-To: <3a4804a5-5d5c-1216-1503-c241cc24f3c2@gmail.com>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Fri, 30 Oct 2020 13:20:41 +0200
Message-ID: <CAOtvUMdJxVSFhN4QMNL+eiF6OB2LevThcgDK34M-=JDXCoDXMA@mail.gmail.com>
To: Milan Broz <gmazyland@gmail.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09UBKpcI007420
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 30 Oct 2020 09:55:39 -0400
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Mike Snitzer <snitzer@redhat.com>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Ofir Drang <ofir.drang@arm.com>
Subject: Re: [dm-devel] [PATCH v3 1/4] crypto: add eboiv as a crypto API
	template
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

SGksCgpPbiBGcmksIE9jdCAzMCwgMjAyMCBhdCAxMjozMyBQTSBNaWxhbiBCcm96IDxnbWF6eWxh
bmRAZ21haWwuY29tPiB3cm90ZToKPgo+IE9uIDI5LzEwLzIwMjAgMTE6MDUsIEdpbGFkIEJlbi1Z
b3NzZWYgd3JvdGU6Cj4gPgo+ID4gK2NvbmZpZyBDUllQVE9fRUJPSVYKPiA+ICsgICAgIHRyaXN0
YXRlICJFQk9JViBzdXBwb3J0IGZvciBibG9jayBlbmNyeXB0aW9uIgo+ID4gKyAgICAgZGVmYXVs
dCBETV9DUllQVAo+ID4gKyAgICAgc2VsZWN0IENSWVBUT19DQkMKPiA+ICsgICAgIGhlbHAKPiA+
ICsgICAgICAgRW5jcnlwdGVkIGJ5dGUtb2Zmc2V0IGluaXRpYWxpemF0aW9uIHZlY3RvciAoRUJP
SVYpIGlzIGFuIElWCj4gPiArICAgICAgIGdlbmVyYXRpb24gbWV0aG9kIHRoYXQgaXMgdXNlZCBp
biBzb21lIGNhc2VzIGJ5IGRtLWNyeXB0IGZvcgo+ID4gKyAgICAgICBzdXBwb3J0aW5nIHRoZSBC
aXRMb2NrZXIgdm9sdW1lIGVuY3J5cHRpb24gdXNlZCBieSBXaW5kb3dzIDgKPiA+ICsgICAgICAg
YW5kIG9ud2FyZHMgYXMgYSBiYWNrd2FyZHMgY29tcGF0aWJsZSB2ZXJzaW9uIGluIGxpZXUgb2Yg
WFRTCj4gPiArICAgICAgIHN1cHBvcnQuCj4gPiArCj4gPiArICAgICAgIEl0IHVzZXMgdGhlIGJs
b2NrIGVuY3J5cHRpb24ga2V5IGFzIHRoZSBzeW1tZXRyaWMga2V5IGZvciBhCj4gPiArICAgICAg
IGJsb2NrIGVuY3J5cHRpb24gcGFzcyBhcHBsaWVkIHRvIHRoZSBzZWN0b3Igb2Zmc2V0IG9mIHRo
ZSBibG9jay4KPiA+ICsgICAgICAgQWRkaXRpb25hbCBkZXRhaWxzIGNhbiBiZSBmb3VuZCBhdAo+
ID4gKyAgICAgICBodHRwczovL3d3dy5qZWRlYy5vcmcvc2l0ZXMvZGVmYXVsdC9maWxlcy9kb2Nz
L0pFU0QyMjNDLnBkZgo+Cj4gVGhpcyBwYWdlIGlzIG5vdCBhdmFpbGFibGUuIEFyZSB5b3Ugc3Vy
ZSB0aGlzIGlzIHRoZSBwcm9wZXIgZG9jdW1lbnRhdGlvbj8KCllvdSBuZWVkIHRvIHJlZ2lzdGVy
IGF0IHRoZSBKRURFQyB3ZWIgc2l0ZSB0byBnZXQgdGhlIFBERi4gVGhlCnJlZ2lzdHJhdGlvbiBp
cyBmcmVlIHRob3VnaC4KCkl0J3MgdGhlIG9ubHkgc3RhbmRhcmQgSSBhbSBhd2FyZSBvZiB0aGF0
IGRlc2NyaWJlIHRoaXMgbW9kZSwgYXMKb3Bwb3NlZCB0byBhIHBhcGVyLgoKPgo+IEkgdGhpbmsg
dGhlIG9ubHkgZGVzY3JpcHRpb24gd2UgdXNlZCAoZm9yIGRtLWNyeXB0KSB3YXMgb3JpZ2luYWwg
RmVyZ3Vzb24ncyBCaXRsb2NrZXIgZG9jOgo+IGh0dHBzOi8vZG93bmxvYWQubWljcm9zb2Z0LmNv
bS9kb3dubG9hZC8wLzIvMy8wMjM4YWNhZi1kM2JmLTRhNmQtYjNkNi0wYTBiZTRiYmIzNmUvYml0
bG9ja2VyY2lwaGVyMjAwNjA4LnBkZgoKClllcywgdGhlIEpFREVDIGhhcyBhIHJlZmVyZW5jZSB0
byB0aGF0IGFzIHdlbGwsIGJ1dCB0aGUgd2hpdGUgcGFwZXIKZG9lc24ndCBhY3R1YWxseSBkZXNj
cmliZSB0aGUgb3B0aW9uIHdpdGhvdXQgdGhlIGRpZmZ1c2VyLgoKPgo+IElJUkMgRUJPSVYgd2Fz
IGEgc2hvcnRjdXQgSSBhZGRlZCB0byBkbS1jcnlwdCBiZWNhdXNlIHdlIGZvdW5kIG5vIG9mZmlj
aWFsIHRlcm1pbm9sb2d5IGZvciB0aGlzIElWLgo+IEFuZCBhZnRlciBsdW5jaHRpbWUsIG5vYm9k
eSBpbnZlbnRlZCBhbnl0aGluZyBiZXR0ZXIsIHNvIGl0IHN0YXllZCBhcyBpdCBpcyBub3cgOi0p
CgpXZWxsLCBJIHN0aWxsIGRvbid0IGhhdmUgYW55IGJldHRlciBuYW1lIHRvIG9mZmVyLCBMT0wg
Oi0pCgpHaWxhZAoKCgotLSAKR2lsYWQgQmVuLVlvc3NlZgpDaGllZiBDb2ZmZWUgRHJpbmtlcgoK
dmFsdWVzIG9mIM6yIHdpbGwgZ2l2ZSByaXNlIHRvIGRvbSEKCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWw=

