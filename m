Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1266EC54EBC
	for <dm-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673534921;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=u54YFC0dR7r9553JHWiuUFQht2jHtOM415FZvsGiGGA=;
	b=JAZED/b7rLhUl5So1N07s2Fl4CrsEld+wG7VRSnuMLztNRngx+ha0In4RavrbbvXTsvwuw
	NQq9XNLvNZhpFf0IBkXOomastDToF7aepboUciUIQPQYaORlZr6BgMu9ym94iJHxAvqGxF
	9poBk3KG5b+TQWUOCF6lr01dIn6Szak=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-l7wFBZJWOCKa8nsuU9m0lQ-1; Thu, 12 Jan 2023 09:48:39 -0500
X-MC-Unique: l7wFBZJWOCKa8nsuU9m0lQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D162857D0D;
	Thu, 12 Jan 2023 14:48:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB806140EBF6;
	Thu, 12 Jan 2023 14:48:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B05851947049;
	Thu, 12 Jan 2023 14:48:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6966E1946A78
 for <dm-devel@listman.corp.redhat.com>; Thu, 12 Jan 2023 14:48:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0A58A1759E; Thu, 12 Jan 2023 14:48:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0290339D92
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 14:48:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4A38857A88
 for <dm-devel@redhat.com>; Thu, 12 Jan 2023 14:48:35 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-56-1pSDn02_PPSRZUh1HTV2eQ-1; Thu,
 12 Jan 2023 09:48:34 -0500
X-MC-Unique: 1pSDn02_PPSRZUh1HTV2eQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id BD0B03F0CB;
 Thu, 12 Jan 2023 14:48:32 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 836B913776;
 Thu, 12 Jan 2023 14:48:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id /6ZkH8AdwGOIEQAAMHmgww
 (envelope-from <hare@suse.de>); Thu, 12 Jan 2023 14:48:32 +0000
Message-ID: <20d7fde4-dd17-de97-53e8-aa808a325efd@suse.de>
Date: Thu, 12 Jan 2023 15:48:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
From: Hannes Reinecke <hare@suse.de>
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 James Smart <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>
References: <20230112115908.23662-1-nj.shetty@samsung.com>
 <CGME20230112120054epcas5p3ec5887c4e1de59f7529dafca1cd6aa65@epcas5p3.samsung.com>
 <20230112115908.23662-4-nj.shetty@samsung.com>
 <bfec42d1-a1bf-3b3a-10dd-8d3db0a6e6a0@suse.de>
In-Reply-To: <bfec42d1-a1bf-3b3a-10dd-8d3db0a6e6a0@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v6 3/9] block: add emulation for copy
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
Cc: p.raghav@samsung.com, Vincent Fu <vincent.fu@samsung.com>,
 joshi.k@samsung.com, gost.dev@samsung.com, anuj20.g@samsung.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMS8xMi8yMyAxNTo0NiwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOgo+IE9uIDEvMTIvMjMgMTI6
NTgsIE5pdGVzaCBTaGV0dHkgd3JvdGU6Cj4+IEZvciB0aGUgZGV2aWNlcyB3aGljaCBkb2VzIG5v
dCBzdXBwb3J0IGNvcHksIGNvcHkgZW11bGF0aW9uIGlzCj4+IGFkZGVkLiBDb3B5LWVtdWxhdGlv
biBpcyBpbXBsZW1lbnRlZCBieSByZWFkaW5nIGZyb20gc291cmNlIHJhbmdlcwo+PiBpbnRvIG1l
bW9yeSBhbmQgd3JpdGluZyB0byB0aGUgY29ycmVzcG9uZGluZyBkZXN0aW5hdGlvbiBhc3luY2hy
b25vdXNseS4KPj4gRm9yIHpvbmVkIGRldmljZSB3ZSBtYWludGFpbiBhIGxpbmtlZCBsaXN0IG9m
IHJlYWQgc3VibWlzc2lvbiBhbmQgdHJ5IHRvCj4+IHN1Ym1pdCBjb3JyZXNwb25kaW5nIHdyaXRl
IGluIHNhbWUgb3JkZXIuCj4+IEFsc28gZW11bGF0aW9uIGlzIHVzZWQsIGlmIGNvcHkgb2ZmbG9h
ZCBmYWlscyBvciBwYXJ0aWFsbHkgY29tcGxldGVzLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBOaXRl
c2ggU2hldHR5IDxuai5zaGV0dHlAc2Ftc3VuZy5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IFZpbmNl
bnQgRnUgPHZpbmNlbnQuZnVAc2Ftc3VuZy5jb20+Cj4+IFNpZ25lZC1vZmYtYnk6IEFudWogR3Vw
dGEgPGFudWoyMC5nQHNhbXN1bmcuY29tPgo+PiAtLS0KPj4gwqAgYmxvY2svYmxrLWxpYi5jwqDC
oMKgwqDCoMKgwqAgfCAyNDEgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Ky0KPj4gwqAgYmxvY2svYmxrLW1hcC5jwqDCoMKgwqDCoMKgwqAgfMKgwqAgNCArLQo+PiDCoCBp
bmNsdWRlL2xpbnV4L2Jsa2Rldi5oIHzCoMKgIDMgKwo+PiDCoCAzIGZpbGVzIGNoYW5nZWQsIDI0
NSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQo+Pgo+IEknbSBub3Qgc3VyZSBpZiBJIGFn
cmVlIHdpdGggdGhpcyBvbmUuCj4gCj4gWW91IGp1c3Qgc3VibWl0dGVkIGEgcGF0Y2ggZm9yIGRl
dmljZS1tYXBwZXIgdG8gaW1wbGVtZW50IGNvcHkgb2ZmbG9hZCwgCj4gd2hpY2ggKHRvIGFsbCBp
bnRlbnRzIGFuZCBwdXJwb3NlcykgX2lzXyBhbiBlbXVsYXRpb24uCj4gCj4gU28gd2h5IGRvIHdl
IG5lZWQgdG8gaW1wbGVtZW50IGl0IGluIHRoZSBibG9jayBsYXllciBhcyBhbiBlbXVsYXRpb24/
Cj4gT3IsIGlmIHdlIGhhdmUgdG8sIHdoeSBkbyB3ZSBuZWVkIHRoZSBkZXZpY2UtbWFwcGVyIGVt
dWxhdGlvbj8KPiBUaGlzIGVtdWxhdGlvbiB3aWxsIGJlIGRvaW5nIHRoZSBzYW1lIHRoaW5nLCBu
bz8KPiAKU2hlZXNoLiBPbmUgc2hvdWxkIHJlYWQgdGhlIGVudGlyZSBwYXRjaHNldC4KCkRpc3Jl
Z2FyZCB0aGUgYWJvdmUgY29tbWVudC4KCkNoZWVycywKCkhhbm5lcwoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

