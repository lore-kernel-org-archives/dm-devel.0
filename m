Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00FE1C7EE23
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 02:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677724433;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5/msHZhMDAgvtr3VExwomYPHho2VPuyzRnd4UU9m+0Q=;
	b=SHNZBiogpm1ijIW0VoK4p20sj7Vb/xtx08XHRanpc5+jamQYVzke7jIj9XlD8LXH2AbKbc
	b3HXF9ipPXDMdlDIHrZvUn5ABXSunXKMyMBwBLXGLslqAi4lZ8KTg3eretqu05yniBqEf4
	SV6isPV0LaDlSArn3xDpDzV9aABnxGw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-VnPO9kpeN2yCAzFE_1-cKg-1; Wed, 01 Mar 2023 21:33:52 -0500
X-MC-Unique: VnPO9kpeN2yCAzFE_1-cKg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C35A8037AF;
	Thu,  2 Mar 2023 02:33:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB2F21121315;
	Thu,  2 Mar 2023 02:33:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1166219452CD;
	Thu,  2 Mar 2023 02:33:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 79E9019472FC
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Mar 2023 02:33:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5D95C140EBF6; Thu,  2 Mar 2023 02:33:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 55C50140EBF4
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 02:33:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A3B585A5A3
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 02:33:34 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-2bMPQ4mSPhCvdVV6l4s1mQ-1; Wed, 01 Mar 2023 21:33:31 -0500
X-MC-Unique: 2bMPQ4mSPhCvdVV6l4s1mQ-1
Received: by mail-pj1-f46.google.com with SMTP id
 p3-20020a17090ad30300b0023a1cd5065fso1320591pju.0
 for <dm-devel@redhat.com>; Wed, 01 Mar 2023 18:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677724410;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=b0lZNoVt9lJ6J8uwaJdMmpDSpbdScMq/0KTuhIjVkUQ=;
 b=Ltb4n0dPFG9QiiZNKrl+CxYYJ8ztE2aCPvFYLaud5+QUdgq+2TVjDVwMrWXxTL00ej
 1MnUj57jPlaJNyWvlcI8wHFcpNA4VuoGy3Q9DjSupPic1U0aFx6LnjVY/3a6caCPMjgh
 /u5S4JEQYPNCDTsvSSguQXauuRk1T9rahL2al8CKk00qmQD2XrTE6crJaVTZzbUMj/iL
 VqqU9oAfF4HLZSpBsa//R/bs/0McNdTKrB95MUbbjAWP84nhcAZC+u98X2Ncesy9DS53
 3DgN2GnCJmzpx02MiU2NXwte9PYKNMljjqUuc2IXm7eUrww8MSembrz5yFxt0omBP/Qg
 1CAQ==
X-Gm-Message-State: AO0yUKVB1LdCZp8FZa+WGw0azLt0aur6I9nrafUFZ8cy1YxmxjxGuHnI
 z+efHYIq0xvOz5YjPqyO51YvNrfWWTZqkSC8dVYh
X-Google-Smtp-Source: AK7set+xzLCM6twBgJCibMqi0G3TLp91UnzEQU5FoUMwEXykcRoWlNU/HbsG/K6w+XprDCA87nJQJ5CJfxasDk2ZryU=
X-Received: by 2002:a17:903:2782:b0:19b:373:94ad with SMTP id
 jw2-20020a170903278200b0019b037394admr3206594plb.3.1677724410550; Wed, 01 Mar
 2023 18:33:30 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
 <061df661004a06ef1e8790d48157c7ba4ecfc009.camel@huaweicloud.com>
 <20230210232154.GA17962@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20230210232154.GA17962@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 1 Mar 2023 21:33:19 -0500
Message-ID: <CAHC9VhShcgFtdxxoFX9x+QOM3Qb7xWa-AJuJGrHgaK_N8nKtzQ@mail.gmail.com>
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
 Roberto Sassu <roberto.sassu@huaweicloud.com>, eparis@redhat.com,
 linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org, agk@redhat.com,
 serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBGZWIgMTAsIDIwMjMgYXQgNjoyMeKAr1BNIEZhbiBXdSA8d3VmYW5AbGludXgubWlj
cm9zb2Z0LmNvbT4gd3JvdGU6Cj4gT24gVHVlLCBKYW4gMzEsIDIwMjMgYXQgMDQ6NDk6NDRQTSAr
MDEwMCwgUm9iZXJ0byBTYXNzdSB3cm90ZToKPiA+IE9uIE1vbiwgMjAyMy0wMS0zMCBhdCAxNDo1
NyAtMDgwMCwgRmFuIFd1IHdyb3RlOgo+ID4gPiBGcm9tOiBEZXZlbiBCb3dlcnMgPGRldmVuLmRl
c2FpQGxpbnV4Lm1pY3Jvc29mdC5jb20+Cj4gPiA+Cj4gPiA+IElQRSBtdXN0IGhhdmUgYSBjZW50
cmFsaXplZCBmdW5jdGlvbiB0byBldmFsdWF0ZSBpbmNvbWluZyBjYWxsZXJzCj4gPiA+IGFnYWlu
c3QgSVBFJ3MgcG9saWN5LiBUaGlzIGl0ZXJhdGlvbiBvZiB0aGUgcG9saWN5IGFnYWluc3QgdGhl
IHJ1bGVzCj4gPiA+IGZvciB0aGF0IHNwZWNpZmljIGNhbGxlciBpcyBrbm93biBhcyB0aGUgZXZh
bHVhdGlvbiBsb29wLgo+ID4KPiA+IE5vdCBzdXJlIGlmIHlvdSBjaGVjayB0aGUgcHJvcGVydGll
cyBhdCBldmVyeSBhY2Nlc3MuCj4gPgo+ID4gPkZyb20gbXkgcHJldmlvdXMgY29tbWVudHMgKGFs
c28gZm9yIHByZXZpb3VzIHZlcnNpb25zIG9mIHRoZSBwYXRjaGVzKQo+ID4geW91IGNvdWxkIGV2
YWx1YXRlIHRoZSBwcm9wZXJ0eSBvbmNlLCBieSBjYWxsaW5nIHRoZSByZXNwZWN0aXZlCj4gPiBm
dW5jdGlvbnMgaW4gdGhlIG90aGVyIHN1YnN5c3RlbXMuCj4gPgo+ID4gVGhlbiwgeW91IHJlc2Vy
dmUgc3BhY2UgaW4gdGhlIHNlY3VyaXR5IGJsb2IgZm9yIGlub2RlcyBhbmQgc3VwZXJibG9ja3MK
PiA+IHRvIGNhY2hlIHRoZSBkZWNpc2lvbi4gVGhlIGZvcm1hdCBjb3VsZCBiZSBhIHBvbGljeSBz
ZXF1ZW5jZSBudW1iZXIsIHRvCj4gPiBlbnN1cmUgdGhhdCB0aGUgY2FjaGUgaXMgdmFsaWQgb25s
eSBmb3IgdGhlIGN1cnJlbnQgcG9saWN5LCBhbmQgYSBiaXQKPiA+IGZvciBldmVyeSBob29rIHlv
dSBlbmZvcmNlLgo+Cj4gVGhhbmtzIGZvciByYWlzaW5nIHRoaXMgaWRlYS4gSSBhZ3JlZSB0aGF0
IGlmIHRoZSBwcm9wZXJ0eSBldmFsdWF0aW9uCj4gbGVhZHMgdG8gYSBwZXJmb3JtYW5jZSBpc3N1
ZSwgaXQgd2lsbCBiZSBiZXR0ZXIgdG8gY2FjaGUgdGhlIGV2YWx1YXRpb24KPiByZXN1bHQuIEJ1
dCBmb3IgdGhpcyB2ZXJzaW9uLCBhbGwgdGhlIHByb3BlcnR5IGV2YWx1YXRpb25zIGFyZSBzaW1w
bGUsCj4gc28gaXQgaXMganVzdCBhcyBmYXN0IGFzIGFjY2Vzc2luZyBhIGNhY2hlLiBBbHNvLCBm
b3IgdGhlIGluaXRpYWwKPiB2ZXJzaW9uIHdlIHByZWZlciB0byBrZWVwIHRoZSBwYXRjaCBhcyBt
aW5pbWFsIGFzIHBvc3NpYmxlLgoKRldJVywgSSB0aGluayB0aGF0IGlzIHRoZSByaWdodCBkZWNp
c2lvbi4gIEtlZXBpbmcgdGhlIGluaXRpYWwKc3VibWlzc2lvbiByZWxhdGl2ZWx5IHNtYWxsIGFu
ZCBmb2N1c2VkIGhhcyBhIGxvdCBvZiBhZHZhbnRhZ2VzIHdoZW4KaXQgY29tZXMgYm90aCB0byBy
ZXZpZXcgYW5kIHByZW1hdHVyZWx5IG9wdGltaXppbmcgdGhpbmdzIHRoYXQgbWlnaHQKbm90IG5l
ZWQgb3B0aW1pemF0aW9uLgoKLS0gCnBhdWwtbW9vcmUuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

