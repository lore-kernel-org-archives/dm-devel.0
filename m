Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90D6C004D4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Jan 2023 14:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674137312;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3oGy0vf2qmdHAOD348LfXbuZ8TlK5Dw5NPFlgVxQBMM=;
	b=hbSasAKa8E4CtqHA3WplvwxUUKsLyd5nr2seqVWIlQpDs+VWCu+21a0lBSYD6sqraVoiwC
	+BzsutFKxNL9vQVFHgGE8h5F/V3B+1ISxuHWYt18yoOuQozcq5z1YZWv/FhXe9rs2XjJAo
	0Lvl2n/+jK7kB15Hgnib1SCBQPsSeaI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-n52bg2NxM0SqUoL98nDYpw-1; Thu, 19 Jan 2023 09:08:29 -0500
X-MC-Unique: n52bg2NxM0SqUoL98nDYpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8728C29DD998;
	Thu, 19 Jan 2023 14:08:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7596EC15BAD;
	Thu, 19 Jan 2023 14:08:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 35B9E1946A6E;
	Thu, 19 Jan 2023 14:08:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6881C1946A6D
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 Jan 2023 14:08:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 29D1D492C3F; Thu, 19 Jan 2023 14:08:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22288492C3C
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 14:08:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05DB6801779
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 14:08:24 +0000 (UTC)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-161-4OnrPU9HOnKQkbXeBxPhGw-1; Thu, 19 Jan 2023 09:08:22 -0500
X-MC-Unique: 4OnrPU9HOnKQkbXeBxPhGw-1
Received: by mail-wr1-f50.google.com with SMTP id b5so2028686wrn.0
 for <dm-devel@redhat.com>; Thu, 19 Jan 2023 06:08:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=UZU5lmBHf3CrDEK0b5KZ0enTWlODe62PhvpTd8ACqgU=;
 b=Ao3u1eFBuk9PjmGPx++5iGRFJzm7nj/l9En4LlzrSdTWcXSTXn8j7o3IGEv1aAZ2p6
 n9oelGlLZBzdDblq9t5XZkhqTzRECdS2Yd2fR6StO1uuHUjIJHu4MKyyy5Fyx7SpdMwe
 vhydxUTXXHqPJva1OnXp6U66A4uo3ZIYimoYVcGQND6nOoCKActvyKgpzQopBgGRnST+
 ej9qezdjWV7n+ZL3Bvx0NlW3CF+lQj4yX2DPS2zXwuP1PDRl+khWefnpan+bYtSFJzxK
 /PI8CZ2iwXCyjVO/ufsj5b6K3IT/VQbbBPQpYMeUoYMz5tu4iC9GFIsPalyPfVdIKnwg
 a7QQ==
X-Gm-Message-State: AFqh2kqw79xTUHE7ZnzCiJxN7jD4UqeBO24c/9am9J3mMR4U5hnx1ZLf
 /9i1em5UqqKtt3ZgtDxtvmPqmw==
X-Google-Smtp-Source: AMrXdXvYoqNL9Pw9sqE9ptR0i7svir4yyC/81qj/ISyZcFmHxQ1vtRuBWRHEFhdKETAAJmgu9dcvkA==
X-Received: by 2002:adf:d084:0:b0:2be:1eb:1f82 with SMTP id
 y4-20020adfd084000000b002be01eb1f82mr9100588wrh.6.1674137300726; 
 Thu, 19 Jan 2023 06:08:20 -0800 (PST)
Received: from [10.94.1.166] ([185.109.18.135])
 by smtp.gmail.com with ESMTPSA id
 c8-20020a5d4cc8000000b002bdeb0cf706sm14591691wrt.65.2023.01.19.06.08.19
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Jan 2023 06:08:19 -0800 (PST)
Message-ID: <b47632a4-54a5-95bf-caad-538bfe07492b@arrikto.com>
Date: Thu, 19 Jan 2023 16:08:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To: Zdenek Kabelac <zkabelac@redhat.com>, Mike Snitzer <snitzer@redhat.com>
References: <20230118122946.20435-1-ntsironis@arrikto.com>
 <Y8geIzYJ4dCeXpEI@redhat.com>
 <2f53c4ee-5bdf-e4e4-2dca-46ae4e22c312@arrikto.com>
 <87610279-d3f0-85cc-a340-06adf924b488@redhat.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <87610279-d3f0-85cc-a340-06adf924b488@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 0/2] dm era: avoid deadlock when swapping
 table with dm-era target
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
Cc: dm-devel@redhat.com, snitzer@kernel.org, ejt@redhat.com, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMS8xOS8yMyAxNDo1OCwgWmRlbmVrIEthYmVsYWMgd3JvdGU6Cj4gRG5lIDE5LiAwMS4gMjMg
diAxMDozNiBOaWtvcyBUc2lyb25pcyBuYXBzYWwoYSk6Cj4+IE9uIDEvMTgvMjMgMTg6MjgsIE1p
a2UgU25pdHplciB3cm90ZToKPj4+IE9uIFdlZCwgSmFuIDE4IDIwMjMgYXTCoCA3OjI5UCAtMDUw
MCwKPj4+IE5pa29zIFRzaXJvbmlzIDxudHNpcm9uaXNAYXJyaWt0by5jb20+IHdyb3RlOgo+Pj4K
Pj4+Cj4+Cj4+IEhpIE1pa2UsCj4+Cj4+IFRoYW5rcyBmb3IgdGhlIHF1aWNrIHJlcGx5Lgo+Pgo+
PiBJIGNvdWxkbid0IGZpbmQgdGhpcyBjb25zdHJhaW50IGRvY3VtZW50ZWQgYW55d2hlcmUgYW5k
IHNpbmNlIHRoZQo+PiB2YXJpb3VzIERNIHRhcmdldHMgc2VlbSB0byBhbGxvdyBtZXNzYWdlIG9w
ZXJhdGlvbnMgd2hpbGUgdGhlIGRldmljZSBpcwo+PiBzdXNwZW5kZWQgSSBkcmV3IHRoZSB3cm9u
ZyBjb25jbHVzaW9uLgo+IAo+IEhpwqAgTmlrb3MKPiAKPiAKPiBTb21lIG5vdGVzIGZyb20gbHZt
MiBkZXZlbG9wZXIgLSB3ZSB3b3JrIHdpdGggdGhlc2UgY29uc3RyYWluczoKPiAKPiBETSB0YXJn
ZXQgc2hvdWxkwqAgbm90IG5lZWQgdG8gYWxsb2NhdGUgYnVuY2ggb2YgbWVtb3J5IHdoaWxlIHN1
c3BlbmRlZCAodGFyZ2V0IHNob3VsZCBwcmVhbGxvY2F0ZWQgcG9vbCBvZiBzb21lIG1lbW9yeSBp
ZiBpdCByZWFsbHkgbmVlZHMgdG8gZG8gaXQgaW4gdGhpcyBjYXNlKS4KPiAKPiBETSB0YXJnZXQg
c2hvdWxkIGNoZWNrIGFuZCBhbGxvY2F0ZSBldmVyeXRoaW5nIGl0IGNhbiBpbiB0aGUgJ2xvYWQn
IHBoYXNlIGFuZCBlcnJvciBhcyBlYXJseSBhcyBwb3NzaWJseSAoc28gbG9hZGVkIGluYWN0aXZl
IHRhYmxlIGNhbiBiZSBjbGVhcmVkL2Ryb3BwZWQgYW5kICdyZXN1bWUnIHRhcmdldCBjYW4gY29u
dGludWUgaXRzIHdvcmspLgo+IAo+IEVycm9yIGluIHN1c3BlbmQgcGhhc2UgaXMgdHlwaWNhbGx5
IHRoZSBsYXN0IG1vbWVudCAtd2UgY2FuIGhhbmRsZSBmYWlsdXJlICdzb21laG93Jy4KPiAKPiBI
YW5kbGluZyBmYWlsdXJlIGluICdyZXN1bWUnIGlzIGEgY2FuIG9mIHdvcm0gd2l0aCBubyBnb29k
IHNvbHV0aW9uIC0gc28gcmVzdW1lIHJlYWxseSBzaG91bGQgZG8gYXMgbWluaW1hbCBhcyBwb3Nz
aWJsZSBhbmQgc2hvdWxkIHdvcmsgd2l0aCBldmVyeXRoaW5nIGFscmVhZHkgcHJlcGFyZWQgZnJv
bSBsb2FkICYgc3VzcGVuZC4KPiAKPiAnRE0gc3RhdHVzL2luZm8nwqAgc2hvdWxkIHdvcmsgd2hp
bGUgZGV2aWNlIGlzIHN1c3BlbmQgLSBidXQgbm8gYWxsb2NhdGlvbiBzaG91bGQgYmUgbmVlZGVk
IGluIHRoaXMgY2FzZSB0byBwcm9kdWNlIHJlc3VsdC4KPiAKPiBTZW5kaW5nIG1lc3NhZ2VzIHRv
IGEgc3VzcGVuZGVkIHRhcmdldCBzaG91bGQgbm90IGJlIG5lZWRlZCAtIGlmIGl0IGlzIC0gaXQg
c2hvdWxkIGJlIG1vc3QgbGlrZWx5IHNvbHZlZCB2aWHCoCAndGFibGUgcmVsb2FkJyBjaGFuZ2Ug
KHRhcmdldCBkZXNpZ24gY2hhbmdlKS4KPiAKPiBMb2FkaW5nIHRvIHRoZSBpbmFjdGl2ZSB0YWJs
ZSBzbG90IHNob3VsZCBub3QgYmUgYnJlYWsgYW55dGhpbmcgZm9yIHRoZSBhY3RpdmUgdGFibGUg
c2xvdMKgICh0YWJsZSBjbGVhciBzaGFsbCByZXN1bWUgYXQgc3VzcGVuZCBwb2ludCkuCj4gCj4g
U3VyZWx5IHRoZSBsaXN0IGNvdWxkIGdvIGxvbmdlciAtIGJ1dCB0aGVzZSBiYXNpY3MgYXJlIGNy
dWNpYWwuCj4gCgpIaSBaZGVuZWssCgpUaGF0J3MgZ3JlYXQgaW5mb3JtYXRpb24hIFRoYW5rcyBh
IGxvdCBmb3Igc2hhcmluZyBpdC4KClJlZ2FyZHMsCk5pa29zCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

