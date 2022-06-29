Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E444C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 20:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656536296;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Tsq8ZH+9z848g8mTdOvcpkRT2yNeOTyN2b4OUKL8GXE=;
	b=gqPaRuYS787a/YK4B54LNPxbVgcOAYlekVS3qzJP0i9x2DkSHKVheVo9MGVjiq5h/brp4T
	+3xGUHl9vU9JOC5rVQ8aLyicpvz3wV35s3Lp1hkHkdAPnHWNepp9zejqdGvm9e4ey4QgXZ
	iNKXY0AyJmhyAj4AkOGlPW5RYkXZObM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-pTTCrqZ3NaW6I5ke_8ROXg-1; Wed, 29 Jun 2022 16:58:11 -0400
X-MC-Unique: pTTCrqZ3NaW6I5ke_8ROXg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18AEB293249D;
	Wed, 29 Jun 2022 20:58:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EA4E9D7F;
	Wed, 29 Jun 2022 20:58:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05B2D194705B;
	Wed, 29 Jun 2022 20:58:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3DF181947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 20:51:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18E1617452; Wed, 29 Jun 2022 20:51:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 148099D63
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 20:51:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDFDD185A7A4
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 20:51:54 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-haPrxdKIM2y4OiUIigMdIQ-1; Wed, 29 Jun 2022 16:51:51 -0400
X-MC-Unique: haPrxdKIM2y4OiUIigMdIQ-1
Received: by mail-pl1-f180.google.com with SMTP id c4so15181346plc.8
 for <dm-devel@redhat.com>; Wed, 29 Jun 2022 13:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:content-transfer-encoding:from:mime-version
 :subject:date:message-id:references:cc:in-reply-to:to;
 bh=QzwBZ8MiKHCkHQs6ubFBUeLJm2aPz3uAJ0SJNl3Iybc=;
 b=w8S085TzTlC1HYzB0wc9QG9e46+G4VCng4X22KOthPX+OxrhJ1ZAVBfWtwiv/qc8Fe
 YKMkKLzfea+wepIg+MIwb+tDJPjuqZ+y+vl8BT8jN6gJsd89uijvbyeNNkHSCK/Pkx9c
 qo0ZU4ApZpkKR62P1/L3hmF2MDUn6KeWaSzTFRbS64scAjpfLAWxulTEMcJGSg5myTUB
 ZSsjDcIfhj96t3gEd9OCu7AhRR6XPCbHOZAHpXyc1VJ4jP8M5eT/kV5r6KkNQJjml2VR
 fqWBVgDZKEU/fqVEs1zor0fi8M8Y07dFH5UZYHoBJwaFItD7azKKJ6V1KwfJVTp1MQSe
 qKmA==
X-Gm-Message-State: AJIora9MXvSxY9YO/0mjNmUOGdfGah9H5jmCCO840vzAyRrOoYQBEKQ7
 C0S4quMZr37r/mrQHmxPdRjO8A==
X-Google-Smtp-Source: AGRyM1v1OkLy4OUlV7ZRW9VidqYwr1vCmgGeLPlNdNyB/wtkvJBb7FkK3KxiVGvVDMaUmxrLSBvU+A==
X-Received: by 2002:a17:90b:1753:b0:1ef:2e75:8811 with SMTP id
 jf19-20020a17090b175300b001ef2e758811mr2120687pjb.22.1656535910048; 
 Wed, 29 Jun 2022 13:51:50 -0700 (PDT)
Received: from smtpclient.apple ([2600:380:b421:9fb9:5830:e8f6:f44a:f844])
 by smtp.gmail.com with ESMTPSA id
 s9-20020a62e709000000b00527ab697c6asm6035747pfh.18.2022.06.29.13.51.49
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 29 Jun 2022 13:51:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Date: Wed, 29 Jun 2022 14:51:48 -0600
Message-Id: <788DCE4B-8992-436B-B0D4-D101E9176345@kernel.dk>
References: <20220629192646.aoj5c7xdqkifwjdg@moria.home.lan>
In-Reply-To: <20220629192646.aoj5c7xdqkifwjdg@moria.home.lan>
To: Kent Overstreet <kent.overstreet@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 5.20 1/4] block: add bio_rewind() API
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
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gSnVuIDI5LCAyMDIyLCBhdCAxOjI2IFBNLCBLZW50IE92ZXJzdHJlZXQgPGtlbnQub3ZlcnN0
cmVldEBnbWFpbC5jb20+IHdyb3RlOgo+IAo+IO+7v09uIFdlZCwgSnVuIDI5LCAyMDIyIGF0IDAx
OjAwOjUyUE0gLTA2MDAsIEplbnMgQXhib2Ugd3JvdGU6Cj4+PiBPbiA2LzI5LzIyIDEyOjQwIFBN
LCBLZW50IE92ZXJzdHJlZXQgd3JvdGU6Cj4+PiBPbiBXZWQsIEp1biAyOSwgMjAyMiBhdCAxMTox
NjoxMEFNIC0wNjAwLCBKZW5zIEF4Ym9lIHdyb3RlOgo+Pj4+IE5vdCBzdXJlIHdoYXQgQ2hyaXN0
b3BoIGNoYW5nZSB5b3UgYXJlIHJlZmVycmluZyB0bywgYnV0IGFsbCB0aGUgb25lcwo+Pj4+IHRo
YXQgSSBkaWQgdG8gaW1wcm92ZSB0aGUgaW5pdCBzaWRlIHdlcmUgYWxsIGJhY2tlZCBieSBudW1i
ZXJzIEkgcmFuIGF0Cj4+Pj4gdGhhdCB0aW1lIChhbmQgbW9zdC9hbGwgb2YgdGhlIGNvbW1pdCBt
ZXNzYWdlcyB3aWxsIGhhdmUgdGhhdCBkYXRhKS4gU28KPj4+PiB5ZXMsIGl0IGlzIGluZGVlZCBz
dGlsbCB2ZXJ5IG5vdGljZWFibGUuIE1heWJlIG5vdCBhdCAxMDBLIElPUFMsIGJ1dCBhdAo+Pj4+
IDEwTSBvbiBhIGNvcmUgaXQgbW9zdCBjZXJ0YWlubHkgaXMuCj4+PiAKPj4+IEkgd2FzIHJlZmVy
cmluZyB0byA2MDliZTEwNjY3MzFmZWE4NjQzNmY1ZjkxMDIyZjgyZTU5MmFiNDU2LiBZb3UKPj4+
IHNpZ25lZCBvZmYgb24gaXQsIHlvdSBtdXN0IHJlbWVtYmVyIGl0Li4uPwo+PiAKPj4gSSdtIHN1
cmUgd2UgYWxsIHJlbWVtYmVyIGVhY2ggYW5kIGV2ZXJ5IGNvbW1pdCB0aGF0IGdldHMgYXBwbGll
ZCwKPj4gcGFydGljdWxhcmx5IHdpdGggc3VjaCBhIHByZWNpc2UgZGVzY3JpcHRpb24gb2YgdGhl
IGNoYW5nZS4KPj4gCj4+Pj4gSSdtIGFsbCBmb3IgaGF2aW5nIHNvbGlkIGFuZCBtYWludGFpbmFi
bGUgY29kZSwgb2J2aW91c2x5LCBidXQgZnJpdm9sb3VzCj4+Pj4gYmxvYXRpbmcgb2Ygc3RydWN0
dXJlcyBhbmQgbW9yZSBleHBlbnNpdmUgc2V0dXAgY2Fubm90IGJlIGhhbmQgd2F2ZWQKPj4+PiBh
d2F5IHdpdGggIml0IGRvZXNuJ3QgbWF0dGVyIGlmIHdlIHRvdWNoIDMgb3IgNiBjYWNoZWxpbmVz
IiBiZWNhdXNlIHdlCj4+Pj4gb2J2aW91c2x5IGhhdmUgYSBkaXNhZ3JlZW1lbnQgb24gdGhhdC4K
Pj4+IAo+Pj4gSSB3b3VsZG4ndCBwcm9wb3NlIGluZmxhdGluZyBzdHJ1Y3QgX2Jpb18gbGlrZSB0
aGF0LiBCdXQgSmVucywgdG8gYmUKPj4+IGJsdW50IC0gSSBrbm93IHdlIGhhdmUgZGlmZmVyZW50
IHByaW9yaXRpZXMgaW4gdGhlIHdheSB3ZSB3cml0ZSBjb2RlLgo+Pj4gWW91ciB3cml0ZWJhY2sg
dGhyb3R0bGluZyBjb2RlIHdhcyBidWdneSBmb3IgX2FnZXNfIGFuZCBJIGhhZCB1c2Vycwo+Pj4g
aGl0dGluZyBkZWFkbG9ja3MgdGhlcmUgdGhhdCBJIHBpbmdlZCB5b3UgYWJvdXQsIGFuZCBJIGNv
dWxkIG5vdCBtYWtlCj4+PiBoZWFkcyBvciB0YWlscyBvZiBob3cgdGhhdCBjb2RlIHdhcyBzdXBw
b3NlZCB0byB3b3JrIGFuZCBub3QgZm9yIGxhY2sKPj4+IG9mIHRpbWUgc3BlbnQgdHJ5aW5nIQo+
PiAKPj4gT0sgS2VudCwgeW91IGp1c3Qgd2FzdGVkIHlvdXIgMm5kIGNoYW5jZSBoZXJlLiBQbG9u
ay4gVGhlcmUgYXJlIG1hbnkKPj4gcmVidXR0YWxzIHRoYXQgY291bGQgYmUgbWFkZSBoZXJlLCBi
dXQgSSB3b24ndCB3YXN0ZSBteSB0aW1lIG9uIGl0LCBub3IKPj4gd291bGQgaXQgYmUgYXBwcm9w
cmlhdGUuCj4+IAo+PiBDb21lIGJhY2sgd2hlbiB5b3Uga25vdyBob3cgdG8gYWN0IHByb2Zlc3Np
b25hbGx5LiBPciBkb24ndCBjb21lIGJhY2sKPj4gYXQgYWxsLgo+IAo+IEplbnMsIHlvdSdyZSBq
dXN0IGFjdGluZyBsaWtlIHlvdXIgY29kZSBpcyBpbW11bmUgdG8gY3JpdGljaXNtLCBhbmQgSSBk
b24ndCBoYXZlCj4gYW4gZXllcm9sbCBiaWcgZW5vdWdoIGZvciB0aGF0LiBXZSBhbGwga25vdyBo
b3cgeW91IGNhcmUgYWJvdXQgY2hhc2luZyBldmVyeQo+IGxhc3Qgb2YgdGhvc2UgMTAgbWlsbGlv
biBpb3BzIC0gYW5kIG5vdCBtdWNoIGVsc2UuCgpLZW50LCB0aGUgdGltZSBmb3IgeW91ciB1bnNv
bGljaXRlZCBvcGluaW9ucyBhbmQgYXR0YWNrcyBoYXZlIHBhc3NlZC4gSnVzdCBnbyBhd2F5LCBu
b3QgaW50ZXJlc3RlZCBpbiBpbnRlcmFjdGluZyB3aXRoIHlvdS4gWW91IGhhdmUgbm8gaWRlYSB3
aGF0IHlvdeKAmXJlIHRhbGtpbmcgYWJvdXQuIAoKCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=

