Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF323C00528
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690501737;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hlFKWwzd+apCNscqEeoR/iLw6BrwkMj0frNNdLepRLg=;
	b=IVTw0TRyTGWNHSngXwIiXclUhYQTfjrZtsPhT8HxJNlzJ5Hd2qikpXRRuJRZFQ5x70EoAi
	qGv6rfRjxFTRNH8oVb+XmW+R2IUbDmoE/QmzPefeSu1vf0teg4F4oN1CafATv9eszRY3SS
	+WtTVqtOSBSy3tMgxJeqb8GRfCZUTc0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-7-WnzDKAP3SORkdymdkPWg-1; Thu, 27 Jul 2023 19:48:54 -0400
X-MC-Unique: 7-WnzDKAP3SORkdymdkPWg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA841830EFF;
	Thu, 27 Jul 2023 23:48:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 24703492B02;
	Thu, 27 Jul 2023 23:48:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 009591946A6A;
	Thu, 27 Jul 2023 23:48:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 52D7B1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 23:48:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F1759F782A; Thu, 27 Jul 2023 23:48:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA0C3F7825
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 23:48:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB6C5858F1E
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 23:48:50 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-30PFEky1NSSRBWXQy0mdzg-1; Thu, 27 Jul 2023 19:48:46 -0400
X-MC-Unique: 30PFEky1NSSRBWXQy0mdzg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id CA7BB61F8A;
 Thu, 27 Jul 2023 23:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5FDC433C7;
 Thu, 27 Jul 2023 23:48:39 +0000 (UTC)
Message-ID: <217f3a7e-7681-0da6-aaa7-252a1451f7ba@kernel.org>
Date: Fri, 28 Jul 2023 08:48:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Dave Chinner <david@fromorbit.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-29-zhengqi.arch@bytedance.com>
 <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
 <56ee1d92-28ee-81cb-9c41-6ca7ea6556b0@bytedance.com>
 <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
 <ZML22YJi5vPBDEDj@dread.disaster.area>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZML22YJi5vPBDEDj@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v3 28/49] dm zoned: dynamically allocate the
 dm-zoned-meta shrinker
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
Cc: kvm@vger.kernel.org, djwong@kernel.org, roman.gushchin@linux.dev,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, brauner@kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Muchun Song <songmuchun@bytedance.com>, yujie.liu@intel.com, vbabka@suse.cz,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 netdev@vger.kernel.org, muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNy8yOC8yMyAwNzo1OSwgRGF2ZSBDaGlubmVyIHdyb3RlOgo+IE9uIFRodSwgSnVsIDI3LCAy
MDIzIGF0IDA3OjIwOjQ2UE0gKzA5MDAsIERhbWllbiBMZSBNb2FsIHdyb3RlOgo+PiBPbiA3LzI3
LzIzIDE3OjU1LCBRaSBaaGVuZyB3cm90ZToKPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8g
ZXJyOwo+Pj4+PiDCoMKgwqDCoMKgIH0KPj4+Pj4gwqAgK8KgwqDCoCB6bWQtPm1ibGtfc2hyaW5r
ZXItPmNvdW50X29iamVjdHMgPSBkbXpfbWJsb2NrX3Nocmlua2VyX2NvdW50Owo+Pj4+PiArwqDC
oMKgIHptZC0+bWJsa19zaHJpbmtlci0+c2Nhbl9vYmplY3RzID0gZG16X21ibG9ja19zaHJpbmtl
cl9zY2FuOwo+Pj4+PiArwqDCoMKgIHptZC0+bWJsa19zaHJpbmtlci0+c2Vla3MgPSBERUZBVUxU
X1NFRUtTOwo+Pj4+PiArwqDCoMKgIHptZC0+bWJsa19zaHJpbmtlci0+cHJpdmF0ZV9kYXRhID0g
em1kOwo+Pj4+PiArCj4+Pj4+ICvCoMKgwqAgc2hyaW5rZXJfcmVnaXN0ZXIoem1kLT5tYmxrX3No
cmlua2VyKTsKPj4+Pgo+Pj4+IEkgZmFpbCB0byBzZWUgaG93IHRoaXMgbmV3IHNocmlua2VyIEFQ
SSBpcyBiZXR0ZXIuLi4gV2h5IGlzbid0IHRoZXJlIGEKPj4+PiBzaHJpbmtlcl9hbGxvY19hbmRf
cmVnaXN0ZXIoKSBmdW5jdGlvbiA/IFRoYXQgd291bGQgYXZvaWQgYWRkaW5nIGFsbCB0aGlzIGNv
ZGUKPj4+PiBhbGwgb3ZlciB0aGUgcGxhY2UgYXMgdGhlIG5ldyBBUEkgY2FsbCB3b3VsZCBiZSB2
ZXJ5IHNpbWlsYXIgdG8gdGhlIGN1cnJlbnQKPj4+PiBzaHJpbmtlcl9yZWdpc3RlcigpIGNhbGwg
d2l0aCBzdGF0aWMgYWxsb2NhdGlvbi4KPj4+Cj4+PiBJbiBzb21lIHJlZ2lzdHJhdGlvbiBzY2Vu
YXJpb3MsIG1lbW9yeSBuZWVkcyB0byBiZSBhbGxvY2F0ZWQgaW4gYWR2YW5jZS4KPj4+IFNvIHdl
IGNvbnRpbnVlIHRvIHVzZSB0aGUgcHJldmlvdXMgcHJlYWxsb2MvcmVnaXN0ZXJfcHJlcGFyZWQo
KQo+Pj4gYWxnb3JpdGhtLiBUaGUgc2hyaW5rZXJfYWxsb2NfYW5kX3JlZ2lzdGVyKCkgaXMganVz
dCBhIGhlbHBlciBmdW5jdGlvbgo+Pj4gdGhhdCBjb21iaW5lcyB0aGUgdHdvLCBhbmQgdGhpcyBp
bmNyZWFzZXMgdGhlIG51bWJlciBvZiBBUElzIHRoYXQKPj4+IHNocmlua2VyIGV4cG9zZXMgdG8g
dGhlIG91dHNpZGUsIHNvIEkgY2hvb3NlIG5vdCB0byBhZGQgdGhpcyBoZWxwZXIuCj4+Cj4+IEFu
ZCB0aGF0IHJlc3VsdHMgaW4gbW9yZSBjb2RlIGluIG1hbnkgcGxhY2VzIGluc3RlYWQgb2YgbGVz
cyBjb2RlICsgYSBzaW1wbGUKPj4gaW5saW5lIGhlbHBlciBpbiB0aGUgc2hyaW5rZXIgaGVhZGVy
IGZpbGUuLi4KPiAKPiBJdCdzIG5vdCBqdXN0IGEgInNpbXBsZSBoZWxwZXIiIC0gaXQncyBhIGZ1
bmN0aW9uIHRoYXQgaGFzIHRvIHRha2UgNgo+IG9yIDcgcGFyYW1ldGVycyB3aXRoIGEgcmV0dXJu
IHZhbHVlIHRoYXQgbXVzdCBiZSBjaGVja2VkIGFuZAo+IGhhbmRsZWQuCj4gCj4gVGhpcyB3YXMg
ZG9uZSBpbiB0aGUgZmlyc3QgdmVyc2lvbnMgb2YgdGhlIHBhdGNoIHNldCAtIHRoZSBhbW91bnQg
b2YKPiBjb2RlIGluIGVhY2ggY2FsbGVyIGRvZXMgbm90IGdvIGRvd24gYW5kLCBJTU8sIHdhcyBt
dWNoIGhhcmRlciB0bwo+IHJlYWQgYW5kIGRldGVybWluZSAidGhpcyBpcyBvYnZpb3VzbHkgY29y
cmVjdCIgdGhhdCB3aGF0IHdlIGhhdmUKPiBub3cuCj4gCj4+IFNvIG5vdCBhZGRpbmcgdGhhdCBz
dXBlciBzaW1wbGUKPj4gaGVscGVyIGlzIG5vdCBleGFjdGx5IHRoZSBiZXN0IGNob2ljZSBpbiBt
eSBvcGluaW9uLgo+IAo+IEVhY2ggdG8gdGhlaXIgb3duIC0gSSBtdWNoIHByZWZlciB0aGUgZXhp
c3Rpbmcgc3R5bGUvQVBJIG92ZXIgaGF2aW5nCj4gdG8gZ28gbG9vayB1cCBhIGhlbHBlciBmdW5j
dGlvbiBldmVyeSB0aW1lIEkgd2FudCB0byBjaGVjayBzb21lCj4gcmFuZG9tIHNocmlua2VyIGhh
cyBiZWVuIHNldCB1cCBjb3JyZWN0bHkuLi4uCgpPSy4gQWxsIGZhaXIgcG9pbnRzLgoKCi0tIApE
YW1pZW4gTGUgTW9hbApXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gKCi0tCmRtLWRldmVsIG1haWxp
bmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

