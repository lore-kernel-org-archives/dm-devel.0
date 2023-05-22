Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFB1C7EE23
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684772971;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xsngXS09jHXP2XVyVpuK/6lyvD/dLZbI8p3tds7UWt8=;
	b=Haj7X9dXp9FfiMDw6Ia9CIGQgZTA4thJyH33z5lYxeyM6gKGuoDwKRw8t4QKxqSB9oMqpS
	CbNUg3oGHlguN850QRcKnOAxz2m/xB3n0kCdMsBA01UkEagyextHHrzYsJ2LVC1N4LcQXR
	nIVG3bJKcUfLG+9bI6bkwPP2tSaIMko=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-DX1yxRFHMgaUDR3Ch8Vntg-1; Mon, 22 May 2023 12:29:28 -0400
X-MC-Unique: DX1yxRFHMgaUDR3Ch8Vntg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2620385A5AA;
	Mon, 22 May 2023 16:29:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EE3D492B0B;
	Mon, 22 May 2023 16:29:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76DD819466DF;
	Mon, 22 May 2023 16:29:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2C225194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 10:49:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BC7EE407DEC3; Mon, 22 May 2023 10:49:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5465407DEC0
 for <dm-devel@redhat.com>; Mon, 22 May 2023 10:49:51 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99F472A59543
 for <dm-devel@redhat.com>; Mon, 22 May 2023 10:49:51 +0000 (UTC)
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
 by relay.mimecast.com with ESMTP id us-mta-38-0FGQRJUQPzKVBJQs7WxDmQ-1;
 Mon, 22 May 2023 06:49:49 -0400
X-MC-Unique: 0FGQRJUQPzKVBJQs7WxDmQ-1
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
 by vmicros1.altlinux.org (Postfix) with ESMTP id 9E89B72C90B;
 Mon, 22 May 2023 13:49:47 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
 id 779C67CFDFA; Mon, 22 May 2023 13:49:47 +0300 (IDT)
Date: Mon, 22 May 2023 13:49:47 +0300
From: "Dmitry V. Levin" <ldv@strace.io>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230522104947.GA2575@altlinux.org>
References: <20230519223356.GA32042@altlinux.org>
 <d5c31607bd92583c8a487e74bd43542b6d7f1a70.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <d5c31607bd92583c8a487e74bd43542b6d7f1a70.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 22 May 2023 16:29:19 +0000
Subject: Re: [dm-devel] [PATCH] 11-dm-mpath.rules: fix warnings reported by
 udevadm verify
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: strace.io
Content-Disposition: inline
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: base64

T24gTW9uLCBNYXkgMjIsIDIwMjMgYXQgMTI6MTk6MDRQTSArMDIwMCwgTWFydGluIFdpbGNrIHdy
b3RlOgo+IE9uIFNhdCwgMjAyMy0wNS0yMCBhdCAwMTozMyArMDMwMCwgRG1pdHJ5IFYuIExldmlu
IHdyb3RlOgo+ID4gRml4IHRoZSBmb2xsb3dpbmcgd2FybmluZ3MgcmVwb3J0ZWQgYnkgdWRldmFk
bSB2ZXJpZnk6Cj4gPiAKPiA+IG11bHRpcGF0aC8xMS1kbS1tcGF0aC5ydWxlczoxOCBXaGl0ZXNw
YWNlIGFmdGVyIGNvbW1hIGlzIGV4cGVjdGVkLgo+ID4gbXVsdGlwYXRoLzExLWRtLW1wYXRoLnJ1
bGVzOjczIFdoaXRlc3BhY2UgYWZ0ZXIgY29tbWEgaXMgZXhwZWN0ZWQuCj4gPiBtdWx0aXBhdGgv
MTEtZG0tbXBhdGgucnVsZXM6NzMgV2hpdGVzcGFjZSBhZnRlciBjb21tYSBpcyBleHBlY3RlZC4K
PiA+IG11bHRpcGF0aC8xMS1kbS1tcGF0aC5ydWxlczo3OCBXaGl0ZXNwYWNlIGFmdGVyIGNvbW1h
IGlzIGV4cGVjdGVkLgo+ID4gbXVsdGlwYXRoLzExLWRtLW1wYXRoLnJ1bGVzOjc4IFdoaXRlc3Bh
Y2UgYWZ0ZXIgY29tbWEgaXMgZXhwZWN0ZWQuCj4gPiBtdWx0aXBhdGgvMTEtZG0tbXBhdGgucnVs
ZXM6NzggV2hpdGVzcGFjZSBhZnRlciBjb21tYSBpcyBleHBlY3RlZC4KPiA+IG11bHRpcGF0aC8x
MS1kbS1tcGF0aC5ydWxlczogdWRldiBydWxlcyBjaGVjayBmYWlsZWQKPiA+IAo+ID4gU2lnbmVk
LW9mZi1ieTogRG1pdHJ5IFYuIExldmluIDxsZHZAc3RyYWNlLmlvPgo+IAo+IE1heWJlIHlvdSBz
aG91bGQgaGF2ZSBtZW50aW9uZWQgdGhhdCB5b3UndmUganVzdCBpbnZlbnRlZCB0aGlzIHN5bnRh
eAo+IHJ1bGUgeW91cnNlbGYgKGh0dHBzOi8vZ2l0aHViLmNvbS9zeXN0ZW1kL3N5c3RlbWQvcHVs
bC8yNjk4MCkuCj4gSSBzZWUgbm8gcmVxdWlyZW1lbnQgZm9yIGFkZGluZyB3aGl0ZXNwYWNlIGFm
dGVyIGEgY29tbWEgaW4gdGhlIHVkZXYKPiBtYW4gcGFnZS6aCj4gCj4gSXMgdGhpcyBhbiBhdHRl
bXB0IHRvIGNoYW5nZSB0aGUgdWRldiBydWxlIHN5bnRheCByZXRyb2FjdGl2ZWx5PwoKQXMgeW91
IHByb2JhYmx5IGtub3csIHVkZXZkIHNpbGVudGx5IGFjY2VwdHMgbXVjaCBicm9hZGVyIHN5bnRh
eCwgZm9yCmV4YW1wbGUsIGl0IGRvZXNuJ3QgbmVlZCBuZWl0aGVyIGNvbW1hIG5vIHdoaXRlc3Bh
Y2UgYmV0d2VlbiBLRVk9VkFMVUUKZXhwcmVzc2lvbnMsIGFuZCBJIGRvdWJ0IHRoaXMgd2lsbCBl
dmVyIGNoYW5nZSBpbiB0aGUgZnV0dXJlLgoKSW4gY29udHJhc3QsIGB1ZGV2YWRtIHZlcmlmeWAg
aXMgYSB0b29sIHRoYXQgY2hlY2tzIHN5bnRhY3RpYywgc2VtYW50aWMsCmFuZCBzdHlsZSBjb3Jy
ZWN0bmVzcyBvZiB1ZGV2IHJ1bGVzIGZpbGVzLiAgSXQgaW5kZWVkIGV4cGVjdHMgd2hpdGVzcGFj
ZQphZnRlciBhIGNvbW1hIGluIHVkZXYgcnVsZXMgLSBhIHN0eWxlIG1vc3Qgb2YgZXhpc3Rpbmcg
dWRldiBydWxlcyBmb2xsb3cuCgo+IEZ1cnRoZXJtb3JlLCB0aGVyZSBpcyBhY3R1YWxseSB3aGl0
ZXNwYWNlIGFmdGVyIHRoZSBjb21tYSBpbiB0aGUgY29kZQo+IHRoaXMgcGF0Y2ggY2hhbmdlcywg
aXQganVzdCBoYXBwZW5zIHRvIGJlIGF0IHRoZSBiZWdpbm5pbmcgb2YgdGhlCj4gZm9sbG93aW5n
IGxpbmUsIHdoaWNoIHlvdXIgc3ludGF4IGNoZWNrIGlnbm9yZXMuCgpXaGVuIEkgc2F3IHRoZSBw
YXJzZXIgb2YgdWRldiBydWxlcyB1c2VkIGJ5IHVkZXZkIGZvciB0aGUgZmlyc3QgdGltZSwKSSB3
YXMgYWxzbyBzdXJwcmlzZWQgdG8gZmluZCBvdXQgdGhhdCBpdCBkaXNjYXJkcyBhbGwgbGVhZGlu
ZyB3aGl0ZXNwYWNlCnJlZ2FyZGxlc3Mgb2YgbGluZSBjb250aW51YXRpb25zLiAgQXMgcmVzdWx0
LCB0aGF0IHdoaXRlc3BhY2UgaXMgbm90CnZpc2libGUgdG8gdGhlIHN5bnRheCBjaGVjayBhdCBh
bGwuICBTbyB5ZXMsIHlvdSBhcmUgbGl0ZXJhbGx5IGNvcnJlY3QsCnRoZXJlIGlzIHdoaXRlc3Bh
Y2UgdGhlcmUsIGJ1dCBtb3N0IG9mIGV4aXN0aW5nIHVkZXYgcnVsZXMgYWRkIHdoaXRlc3BhY2UK
YmV0d2VlbiBhIGNvbW1hIGFuZCBhIGJhY2tzbGFzaC4KCgotLSAKbGR2CgotLQpkbS1kZXZlbCBt
YWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNv
bS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

