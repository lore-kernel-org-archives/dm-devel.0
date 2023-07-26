Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4EDC001E0
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jul 2023 19:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690400707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BuETpG1THTiMfqpBIdY4YuzqJJ7TFmjtUhYWIYqIg9k=;
	b=OdKtxFDIwNXNGw+F2NdLgGrP1UK+JLWlNYPn8l3girsMBgKqT/KiwzNGNaVJzzuq7WUNZF
	KxX95d+oEtuzf6vatzGd+4tQq+ae/rWw3U8UUhkZOTI9Q/iwD2Zk7DTC88VeHIfx7hF+4E
	SOIABcXp8eh9djO8+YTg9nP1Ty0Rx+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-zflLNfPENO2VcPtqaE23SQ-1; Wed, 26 Jul 2023 15:45:03 -0400
X-MC-Unique: zflLNfPENO2VcPtqaE23SQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF442104458D;
	Wed, 26 Jul 2023 19:45:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 00F792166B25;
	Wed, 26 Jul 2023 19:44:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 139671946A6E;
	Wed, 26 Jul 2023 19:44:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B8631946A6C
 for <dm-devel@listman.corp.redhat.com>; Wed, 26 Jul 2023 19:40:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8CCE145414E; Wed, 26 Jul 2023 19:39:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C02691454147
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 19:39:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1F773C0C48F
 for <dm-devel@redhat.com>; Wed, 26 Jul 2023 19:39:59 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-OMw1m14KPL2pqL7Rek1Ulw-1; Wed, 26 Jul 2023 15:39:58 -0400
X-MC-Unique: OMw1m14KPL2pqL7Rek1Ulw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2AFA561CA5;
 Wed, 26 Jul 2023 19:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEC3C433C8;
 Wed, 26 Jul 2023 19:30:46 +0000 (UTC)
Date: Wed, 26 Jul 2023 12:30:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Message-Id: <20230726123046.a001b6963da19ca883045271@linux-foundation.org>
In-Reply-To: <CACVXFVM8rcGJu-f+6zOgY8t4KPPR0J=giYD5dnCLL8_XVo234w@mail.gmail.com>
References: <4919.1690365747@warthog.procyon.org.uk>
 <CACVXFVM8rcGJu-f+6zOgY8t4KPPR0J=giYD5dnCLL8_XVo234w@mail.gmail.com>
Mime-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] Processes hung in "D" state in ext4, mm,
 md and dmcrypt
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
Cc: linux-block <linux-block@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ming Lei <ming.lei@redhat.com>, David Howells <dhowells@redhat.com>,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org,
 linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux-foundation.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCAyNiBKdWwgMjAyMyAyMzoyOTo1MSArMDgwMCBNaW5nIExlaSA8dG9tLmxlaW1pbmdA
Z21haWwuY29tPiB3cm90ZToKCj4gT24gV2VkLCBKdWwgMjYsIDIwMjMgYXQgNjowMuKAr1BNIERh
dmlkIEhvd2VsbHMgPGRob3dlbGxzQHJlZGhhdC5jb20+IHdyb3RlOgo+ID4KPiA+IEhpLAo+ID4K
PiA+IFdpdGggNi41LXJjMiAoNi41LjAtMC5yYzIuMjAyMzA3MjFnaXRmN2UzYTFiYWZkZWEuMjAu
ZmMzOS54ODZfNjQpLCBJJ20gc2VlaW5nCj4gPiBhIGJ1bmNoIG9mIHByb2Nlc3NlcyBnZXR0aW5n
IHN0dWNrIGluIHRoZSBEIHN0YXRlIG9uIG15IGRlc2t0b3AgYWZ0ZXIgYSBmZXcKPiA+IGhvdXJz
IG9mIHJlYWRpbmcgZW1haWwgYW5kIGNvbXBpbGluZyBzdHVmZi4gIEl0J3MgaGFwcGVuZWQgZXZl
cnkgZGF5IHRoaXMgd2Vlawo+ID4gc28gZmFyIGFuZCBJIG1hbmFnZWQgdG8gZ3JhYiBzdGFjayB0
cmFjZXMgb2YgdGhlIHN0dWNrIHByb2Nlc3NlcyB0aGlzIG1vcm5pbmcKPiA+IChzZWUgYXR0YWNo
ZWQpLgo+ID4KPiA+IFRoZXJlIGFyZSB0d28gYmxvY2tkZXZzIGludm9sdmVkIGJlbG93LCAvZGV2
L21kMiBhbmQgL2Rldi9tZDMuICBtZDMgaXMgYSByYWlkMQo+ID4gYXJyYXkgd2l0aCB0d28gcGFy
dGl0aW9ucyB3aXRoIGFuIGV4dDQgcGFydGl0aW9uIG9uIGl0LiAgbWQyIGlzIHNpbWlsYXIgYnV0
Cj4gPiBpdCdzIGRtLWNyeXB0ZWQgYW5kIGV4dDQgaXMgb24gdG9wIG9mIHRoYXQuCj4gPgo+IC4u
Lgo+IAo+ID4gPT09MTE3NTQ3PT09Cj4gPiAgICAgUElEIFRUWSAgICAgIFNUQVQgICBUSU1FIENP
TU1BTkQKPiA+ICAxMTc1NDcgPyAgICAgICAgRCAgICAgIDU6MTIgW2t3b3JrZXIvdTE2OjgrZmx1
c2gtOTozXQo+ID4gWzwwPl0gYmxrX21xX2dldF90YWcrMHgxMWUvMHgyYjAKPiA+IFs8MD5dIF9f
YmxrX21xX2FsbG9jX3JlcXVlc3RzKzB4MWJjLzB4MzUwCj4gPiBbPDA+XSBibGtfbXFfc3VibWl0
X2JpbysweDJjNy8weDY4MAo+ID4gWzwwPl0gX19zdWJtaXRfYmlvKzB4OGIvMHgxNzAKPiA+IFs8
MD5dIHN1Ym1pdF9iaW9fbm9hY2N0X25vY2hlY2srMHgxNTkvMHgzNzAKPiA+IFs8MD5dIF9fYmxv
Y2tfd3JpdGVfZnVsbF9mb2xpbysweDFlMS8weDQwMAo+ID4gWzwwPl0gd3JpdGVwYWdlX2NiKzB4
MWEvMHg3MAo+ID4gWzwwPl0gd3JpdGVfY2FjaGVfcGFnZXMrMHgxNDQvMHgzYjAKPiA+IFs8MD5d
IGRvX3dyaXRlcGFnZXMrMHgxNjQvMHgxZTAKPiA+IFs8MD5dIF9fd3JpdGViYWNrX3NpbmdsZV9p
bm9kZSsweDNkLzB4MzYwCj4gPiBbPDA+XSB3cml0ZWJhY2tfc2JfaW5vZGVzKzB4MWVkLzB4NGIw
Cj4gPiBbPDA+XSBfX3dyaXRlYmFja19pbm9kZXNfd2IrMHg0Yy8weGYwCj4gPiBbPDA+XSB3Yl93
cml0ZWJhY2srMHgyOTgvMHgzMTAKPiA+IFs8MD5dIHdiX3dvcmtmbisweDM1Yi8weDUxMAo+ID4g
WzwwPl0gcHJvY2Vzc19vbmVfd29yaysweDFkZS8weDNmMAo+ID4gWzwwPl0gd29ya2VyX3RocmVh
ZCsweDUxLzB4MzkwCj4gPiBbPDA+XSBrdGhyZWFkKzB4ZTUvMHgxMjAKPiA+IFs8MD5dIHJldF9m
cm9tX2ZvcmsrMHgzMS8weDUwCj4gPiBbPDA+XSByZXRfZnJvbV9mb3JrX2FzbSsweDFiLzB4MzAK
PiAKPiBCVFcsIC1yYzMgZml4ZXMgb25lIHNpbWlsYXIgaXNzdWUgb24gdGhlIGFib3ZlIGNvZGUg
cGF0aCwgc28gcGxlYXNlIHRyeSAtcmMzLgo+IAo+IDEwNjM5NzM3NmMwMyBzYml0bWFwOiBmaXgg
YmF0Y2hpbmcgd2FrZXVwCgpUaGF0IHBhdGNoIHJlYWxseSBuZWVkcyBhIEZpeGVzOiwgcGxlYXNl
LiAgQW5kIGNvbnNpZGVyYXRpb24gZm9yIGEKLXN0YWJsZSBiYWNrcG9ydC4KCkxvb2tpbmcgYXQg
d2hhdCBoYXMgY2hhbmdlZCByZWNlbnRseSBpbiBzYml0bWFwLCBpdCBzZWVtcyB1bmxpa2VseSB0
aGF0CjEwNjM5NzM3NmMwMyBmaXhlcyBhbiBpc3N1ZSB0aGF0IGp1c3QgYXBwZWFyZWQgaW4gNi41
LXJjWC4gIEJ1dCBtYXliZQp0aGUgaXNzdWUgeW91IGhhdmUgaWRlbnRpZmllZCBoYXMgcmVjZW50
bHkgYmVjb21lIGVhc2llciB0byBoaXQ7IHdlJ2xsCnNlZS4KCi0tCmRtLWRldmVsIG1haWxpbmcg
bGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxt
YW4vbGlzdGluZm8vZG0tZGV2ZWwK

