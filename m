Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19A2C28D13
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 11:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661427682;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3a8BH+4IPNqqv8W3uMYdqU7qiIGTJ/rEjgxeBf0G/bM=;
	b=CDq0tOGLxHLFTko78f8e+HPNCOId6Og6hnP+lJd0MhnuSJbnBwnU0ZVAaPX9SOKZbJptXj
	IKotI3I/PNMqctoVx5IR9e7a8IGn33FTGGyDQCWnBVtBgTYbuJ5/HHccHOQx+OtrZTZ+xn
	q1Clwpil49g14DWByXpF8a8mGLBziZE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-Mqb2Ht0yNPmhQw7NPUmnfg-1; Thu, 25 Aug 2022 07:41:19 -0400
X-MC-Unique: Mqb2Ht0yNPmhQw7NPUmnfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB3229AB3F3;
	Thu, 25 Aug 2022 11:41:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 138591410DD5;
	Thu, 25 Aug 2022 11:41:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F09D51946A5A;
	Thu, 25 Aug 2022 11:41:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BCDDE1946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 11:41:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BC069458A; Thu, 25 Aug 2022 11:41:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 87AB14C816
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 11:41:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C637185A794
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 11:41:15 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-203-BHcEQqmlMGi_yyDQT9d6_w-1; Thu, 25 Aug 2022 07:41:13 -0400
X-MC-Unique: BHcEQqmlMGi_yyDQT9d6_w-1
Received: by mail-wr1-f52.google.com with SMTP id bq11so17671350wrb.12;
 Thu, 25 Aug 2022 04:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc;
 bh=1Donf+mHcSCf2M87dtl8AjDvGfXVcRmbdY8bbdzOjfg=;
 b=CIrdoumODGJyZp67mcdZkuSnA3R6UxkkR79fM08ufU0GrIdJ0VKKLNoW3ckWmzRvm9
 Bi9Ogv3s5VP9noaZ0mf5KzGqEn60PkdY/cmRbN66GdetuXtnFTcgcfhouG214Vosfy9k
 9mlYTpJynagLu7T8ERDc7A8bJ1qfWh7U0NwWXOveYRvku7wahlVtO+2q6GbSpUIEzBIv
 loGNrx2mPb+2nFBuq9HCGjEMwSURw2g0S3Feh6GzM9ItWaZandoXSpQERtsKVRYukD0s
 SB6Ol8vMgaelejpoafMhqTyDsEf4GmduxDwxF6Wmyhu1dyab4L2zrpBF1vQX98cx400j
 44JQ==
X-Gm-Message-State: ACgBeo3qVFe6oX8CUhp7d+TjrWdrd6cauIXPZCl8MeK7VVgkErqFm0fm
 /5Tc7aM9FSVjiZYdsfjbBLdcowxvpwaS0Q==
X-Google-Smtp-Source: AA6agR4ajXgpfhDGHBe96biiYt90v4FW2OVpd0T+rQE/kyZlDxQI0sR8gytj2Fy2j2uukMr+nOJqrQ==
X-Received: by 2002:a5d:4571:0:b0:225:6191:779d with SMTP id
 a17-20020a5d4571000000b002256191779dmr2014769wrc.325.1661427672152; 
 Thu, 25 Aug 2022 04:41:12 -0700 (PDT)
Received: from [10.43.17.48] (nat-pool-brq-t.redhat.com. [213.175.37.10])
 by smtp.gmail.com with ESMTPSA id
 s7-20020a5d6a87000000b0021ef34124ebsm19621714wru.11.2022.08.25.04.41.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Aug 2022 04:41:11 -0700 (PDT)
Message-ID: <790dbd9d-bc22-9814-2823-8882a95ec57c@gmail.com>
Date: Thu, 25 Aug 2022 13:41:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
To: Mikulas Patocka <mpatocka@redhat.com>, Coly Li <colyli@suse.de>,
 Alasdair G Kergon <agk@redhat.com>
References: <120284F5-514F-4EA0-A0AE-8B759FF78931@suse.de>
 <alpine.LRH.2.02.2208241530300.1585@file01.intranet.prod.int.rdu2.redhat.com>
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <alpine.LRH.2.02.2208241530300.1585@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] A kernel panic (or soft lockup) due to stack
 overflow by recursive dm-table reload
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

RG5lIDI0LiAwOC4gMjIgdiAyMTo0MiBNaWt1bGFzIFBhdG9ja2EgbmFwc2FsKGEpOgo+IAo+IAo+
IE9uIFRodSwgMjUgQXVnIDIwMjIsIENvbHkgTGkgd3JvdGU6Cj4gCj4+IEhpIGZvbGtzLAo+Pgo+
PiBSZWNlbnRseSBJIHJlY2VpdmVkIGEgYnVnIHJlcG9ydCBmcm9tIEludGVsIGRldmVsb3BlcnMg
KGJpZyB0aGFua3MpLCB0aGUKPj4ga2VybmVsIHBhbmljIGlzIGNhdXNlZCBieSBhIGtlcm5lbCBz
dGFjayBvdmVyZmxvdyBhbmQgaXQgc2VlbXMgZnJvbSBhCj4+IHJlY3Vyc2l2ZSBkbS10YWJsZSBy
ZWxvYWQuCj4+Cj4+IEhlcmUgaXMgdGhlIHNpbXBsaWZpZWQgcHJvY2VzcyB0byByZXByb2R1Y2Ug
dGhlIHBhbmljLCBJIHVzZSB0aHJlZSA5NjBHQiBuYW1lIFNTRHMuCj4+Cj4+IDEsIGNyZWF0ZSAy
IGRtIGRldmljZXMsCj4+ICMgZWNobyAnMCAxODEwNjU1NjcgbGluZWFyIC9kZXYvbnZtZTJuMSAw
JyB8IGRtc2V0dXAgY3JlYXRlIG52bWUybjFiYm0KPj4gIyBlY2hvICcwIDE5NjYxNjcwOSBsaW5l
YXIgL2Rldi9udm1lM24xIDAnIHwgZG1zZXR1cCBjcmVhdGUgbnZtM24xYmJtCj4+Cj4+IDIsIGNy
ZWF0ZSBhIHJhaWQgd2l0aCB0aGVzZSBkbSBkZXZpY2VzIGFuZCBhbm90aGVyIG52bWUgU1NELAo+
PiAjIG1kYWRtIC1DIC9kZXYvbWQwIC1sIDUgLW4gMyAvZGV2L252bWU0bjEgL2Rldi9kbS0wIC9k
ZXYvZG0tMQo+Pgo+PiAzLCB3YWl0IGZvciByZXN5bmMgdG8gZmluaXNoCj4+Cj4+IDQsIHN0b3Ag
dGhlIG1kIGFycmF5Cj4+ICMgbWRhZG0g4oCUbWFuYWdlIOKAlHN0b3AgL2Rldi9tZDAKPj4KPj4g
NSwgcmVsb2FkIGRtIHRhYmxlIGZvciBkbS0wCj4+ICMgY2F0IGRtLXRhYmxlLXJlbG9hZCB8IGRt
c2V0dXAgcmVsb2FkIC9kZXYvZG0tMAo+PiBBbmQgdGhlIGNvbnRlbnQgb2YgZG0tdGFibGUtcmVs
b2FkIGlzLAo+PiAJMCAxIGxpbmVhciAvZGV2L2RtLTAgMAo+PiAJMSAxODEwNjU1NjYgbGluZWFy
IC9kZXYvZG0tMCAxCj4+Cj4+IDYsIHN1c3BlbmQgYW5kIHJlc3VtZSBkbS0wCj4+ICMgZG1zZXR1
cCBzdXNwZW5kIC9kZXYvZG0tMAo+PiAjIGRtc2V0dXAgcmVzdW1lIC9kZXYvZG0tMAo+Pgo+PiBU
aGUgcGFuaWMgY2FuIGJlIHJlcHJvZHVjZWQgaW4gTGludXgtdjUuMyBrZXJuZWxbMV0sIGFuZCBp
dCBjaGFuZ2VzIHRvCj4+IHNpbGVudCBkZWFkbG9jayBhZnRlciBtaW51dGVzIGluIExpbnV4IHY2
LjAtcmMyLiBTbyB0aGUgcHJvYmxlbSBzaG91bGQKPj4gc3RpbGwgZXhpc3QgaW4gdXBzdHJlYW0g
a2VybmVsLgo+Pgo+PiBNeSBxdWVzdGlvbiBhcmUsCj4+IDEpIERvZXMgYW55b25lIG9ic2VydmUg
b3IgZW5jb3VudGVyIHN1Y2ggcGFuaWMgb3IgZGVhZGxvY2sgYmVmb3JlPwo+PiAyKSBUbyBwZXJt
aXQgcmVjdXJzaXZlIGRtLXRhYmxlIHJlbG9hZCwgaXMgaXQgYSBidWcgb3IganVzdCBhcy1kZXNp
Z25lZCA/Cj4+Cj4+IFRoYW5rcyBpbiBhZHZhbmNlLgo+Pgo+PiBDb2x5IExpCj4gCj4gSGkKPiAK
PiBJIHdvdWxkIGp1c3Qgc2F5ICJkb24ndCBkbyB0aGlzIi4KPiAKPiBOb3RlIHRoYXQgb25seSBy
b290IGNhbiByZWxvYWQgZG0gdGFibGUsIHNvIHRoZXJlIGFyZSBubyBzZWN1cml0eQo+IGltcGxp
Y2F0aW9ucyBpbiB0aGlzLiBBbmQgaWYgc29tZW9uZSBoYXMgcm9vdCwgaGUgY2FuIGRvIG11Y2gg
bW9yZSBoYXJtCj4gdGhhbiBjcmFzaGluZyB0aGUgc3lzdGVtIHdpdGgga2VybmVsIHN0YWNrIG92
ZXJmbG93Lgo+IAo+IFJlY3Vyc2l2ZSB0YWJsZSBtYXBwaW5ncyBvciB2ZXJ5IGRlZXAgbm9uLXJl
Y3Vyc2l2ZSBtYXBwaW5ncyBhcmVuJ3QKPiBzdXBwb3NlZCB0byB3b3JrLgo+IAoKU2luY2UgcmVw
cm9kdWNpbmcgdGhpcyBpc3N1ZSBpcyByYXRoZXIgJ3RyaXZhbCcgLSBzaW5jZSBjcmVhdGlvbiBv
ZiBzaW1wbGUgCmxpbmVhciBETSBkZXZpY2UgYW5kIHJlbG9hZGluZyBpdCB3aXRoICdzZWxmLXJl
ZmVyZW5jZScgdGFibGUgbGluZSBpcyBlYXN5IEknZCAKYWR2b2NhdGUgZm9yIHNvbWUgc2ltcGxp
c3RpYyBjaGVjayBvbiBrZXJuZWwgc2lkZSAtIGFzIHN1Y2ggJ2NyYXNoJyBjYW4ndCBiZSAKZXZl
biByZWJvb3RlZCB3aXRoIFN5c1JRK0IgKG9uIG15IGxhcHRvcCkuCgpJIGd1ZXNzIHNvbWUgJ2Jp
dG1hcC90cmVlJyBvZiBhbHJlYWR5IHZpc2l0ZWQgZGV2aWNlIGR1cmluZyBzb21lIGNoZWNrIG1p
Z2h0IAphdm9pZCBlbmRsZXNzIGxvb3AgYWx0aG91Z2ggaXQncyBxdWl0ZSAndWdseScgdGhpcyBj
aGVjayBuZWVkcyB0byBoYXBwZW4gb24gCidyZXN1bWUnIHBoYXNlIC0gc28gdGhlIGZhaWx1cmUg
aGVyZSBpcyBoYXJkIHRvIGRlYWwgd2l0aCAtIHN0aWxsIGJldHRlciB0aGFuIAp0aGlzIGtlcm5l
bCBidXN5IGxvb3AuCgoKWmRlbmVrCgoKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

