Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59716C05052
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=799ylPU4sJXd+DHq0cCnBuKhE27cvnrBnzeVkfyeVzc=;
	b=S26yziPeXbWAAPhoUA/avg7XbdPAeCQOh/MXagz1inGsZd38oerL5CCTpAC0PAziDDo0Cj
	TkC5KxE3VBg3UCxYsYORr9uHrDnDsNvOeVIMorMKdGGub7c286IUHCTYOwKVO+SeD7Cv1J
	xSEPPSQCNpp9qF7Jc2I+gVCjc73qiTo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-7ksMIn2yNaeTHxjEzk2RWQ-1; Thu, 27 Jul 2023 13:55:27 -0400
X-MC-Unique: 7ksMIn2yNaeTHxjEzk2RWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A44E4835229;
	Thu, 27 Jul 2023 17:55:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9183A1121330;
	Thu, 27 Jul 2023 17:55:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88F1E19376C4;
	Thu, 27 Jul 2023 17:54:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D980B1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 10:20:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4DC2145414B; Thu, 27 Jul 2023 10:20:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC27D140E949
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 10:20:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FF5A88D4E2
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 10:20:57 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-5PtYu4sKOoyC6YvyWfxbbA-1; Thu, 27 Jul 2023 06:20:53 -0400
X-MC-Unique: 5PtYu4sKOoyC6YvyWfxbbA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 44B6761DD3;
 Thu, 27 Jul 2023 10:20:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9266C433C8;
 Thu, 27 Jul 2023 10:20:47 +0000 (UTC)
Message-ID: <ba0868b2-9f90-3d81-1c91-8810057fb3ce@kernel.org>
Date: Thu, 27 Jul 2023 19:20:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To: Qi Zheng <zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
 <20230727080502.77895-29-zhengqi.arch@bytedance.com>
 <baaf7de4-9a0e-b953-2b6a-46e60c415614@kernel.org>
 <56ee1d92-28ee-81cb-9c41-6ca7ea6556b0@bytedance.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <56ee1d92-28ee-81cb-9c41-6ca7ea6556b0@bytedance.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 27 Jul 2023 17:54:53 +0000
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
 david@fromorbit.com, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, cel@kernel.org,
 x86@kernel.org, steven.price@arm.com, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, brauner@kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 yujie.liu@intel.com, vbabka@suse.cz, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, tytso@mit.edu, netdev@vger.kernel.org,
 muchun.song@linux.dev, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 senozhatsky@chromium.org, gregkh@linuxfoundation.org,
 linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gNy8yNy8yMyAxNzo1NSwgUWkgWmhlbmcgd3JvdGU6Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
Z290byBlcnI7Cj4+PiDCoMKgwqDCoMKgIH0KPj4+IMKgICvCoMKgwqAgem1kLT5tYmxrX3Nocmlu
a2VyLT5jb3VudF9vYmplY3RzID0gZG16X21ibG9ja19zaHJpbmtlcl9jb3VudDsKPj4+ICvCoMKg
wqAgem1kLT5tYmxrX3Nocmlua2VyLT5zY2FuX29iamVjdHMgPSBkbXpfbWJsb2NrX3Nocmlua2Vy
X3NjYW47Cj4+PiArwqDCoMKgIHptZC0+bWJsa19zaHJpbmtlci0+c2Vla3MgPSBERUZBVUxUX1NF
RUtTOwo+Pj4gK8KgwqDCoCB6bWQtPm1ibGtfc2hyaW5rZXItPnByaXZhdGVfZGF0YSA9IHptZDsK
Pj4+ICsKPj4+ICvCoMKgwqAgc2hyaW5rZXJfcmVnaXN0ZXIoem1kLT5tYmxrX3Nocmlua2VyKTsK
Pj4KPj4gSSBmYWlsIHRvIHNlZSBob3cgdGhpcyBuZXcgc2hyaW5rZXIgQVBJIGlzIGJldHRlci4u
LiBXaHkgaXNuJ3QgdGhlcmUgYQo+PiBzaHJpbmtlcl9hbGxvY19hbmRfcmVnaXN0ZXIoKSBmdW5j
dGlvbiA/IFRoYXQgd291bGQgYXZvaWQgYWRkaW5nIGFsbCB0aGlzIGNvZGUKPj4gYWxsIG92ZXIg
dGhlIHBsYWNlIGFzIHRoZSBuZXcgQVBJIGNhbGwgd291bGQgYmUgdmVyeSBzaW1pbGFyIHRvIHRo
ZSBjdXJyZW50Cj4+IHNocmlua2VyX3JlZ2lzdGVyKCkgY2FsbCB3aXRoIHN0YXRpYyBhbGxvY2F0
aW9uLgo+IAo+IEluIHNvbWUgcmVnaXN0cmF0aW9uIHNjZW5hcmlvcywgbWVtb3J5IG5lZWRzIHRv
IGJlIGFsbG9jYXRlZCBpbiBhZHZhbmNlLgo+IFNvIHdlIGNvbnRpbnVlIHRvIHVzZSB0aGUgcHJl
dmlvdXMgcHJlYWxsb2MvcmVnaXN0ZXJfcHJlcGFyZWQoKQo+IGFsZ29yaXRobS4gVGhlIHNocmlu
a2VyX2FsbG9jX2FuZF9yZWdpc3RlcigpIGlzIGp1c3QgYSBoZWxwZXIgZnVuY3Rpb24KPiB0aGF0
IGNvbWJpbmVzIHRoZSB0d28sIGFuZCB0aGlzIGluY3JlYXNlcyB0aGUgbnVtYmVyIG9mIEFQSXMg
dGhhdAo+IHNocmlua2VyIGV4cG9zZXMgdG8gdGhlIG91dHNpZGUsIHNvIEkgY2hvb3NlIG5vdCB0
byBhZGQgdGhpcyBoZWxwZXIuCgpBbmQgdGhhdCByZXN1bHRzIGluIG1vcmUgY29kZSBpbiBtYW55
IHBsYWNlcyBpbnN0ZWFkIG9mIGxlc3MgY29kZSArIGEgc2ltcGxlCmlubGluZSBoZWxwZXIgaW4g
dGhlIHNocmlua2VyIGhlYWRlciBmaWxlLi4uIFNvIG5vdCBhZGRpbmcgdGhhdCBzdXBlciBzaW1w
bGUKaGVscGVyIGlzIG5vdCBleGFjdGx5IHRoZSBiZXN0IGNob2ljZSBpbiBteSBvcGluaW9uLgoK
LS0gCkRhbWllbiBMZSBNb2FsCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

