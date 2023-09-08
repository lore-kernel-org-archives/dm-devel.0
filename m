Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1538EEE57CB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 05:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694152571;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=erfdKH/yWrO3Hawggr9GdGVQkRogld1giN09hRFcND8=;
	b=iyti1OxYlNNKSjGKJRirrckgNH2wW8FzBde3oQBDjvI/g/Xop7OUp/lj9KLHrmavlPGwhd
	tQSXaZTbglpnMEy0/gKG5g6nkkprlq4F1Wo5s0WzJjcvFyTVNTFeryjbYwRdh3V8rggJaA
	5n8TL7Ild6z+/ZEz9rJ0INTolJ4mnjk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-BTaRPNMiNiCl0B21kFabjQ-1; Fri, 08 Sep 2023 01:56:08 -0400
X-MC-Unique: BTaRPNMiNiCl0B21kFabjQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC77238149C5;
	Fri,  8 Sep 2023 05:56:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3DB991121314;
	Fri,  8 Sep 2023 05:56:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6FD0194658F;
	Fri,  8 Sep 2023 05:56:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8031A194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 05:56:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6925063F78; Fri,  8 Sep 2023 05:56:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6165F7B62
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 05:56:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3ED1D3C100C6
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 05:56:02 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-455-FXT2oTWpMzizP0wf7D8nIA-1; Fri,
 08 Sep 2023 01:55:59 -0400
X-MC-Unique: FXT2oTWpMzizP0wf7D8nIA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A5A4F1F749;
 Fri,  8 Sep 2023 05:55:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2DE78131FD;
 Fri,  8 Sep 2023 05:55:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id EJUhCm63+mSyZAAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 08 Sep 2023 05:55:58 +0000
Message-ID: <9b524f00-35f1-4f6c-896e-40f2879040d2@suse.de>
Date: Fri, 8 Sep 2023 07:55:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3@epcas5p3.samsung.com>
 <20230906163844.18754-4-nj.shetty@samsung.com>
 <b0f3d320-047b-4bd8-a6fc-25b468caf5b3@suse.de>
 <20230907071611.rgukw7fory2xh5sy@green245>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230907071611.rgukw7fory2xh5sy@green245>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v15 03/12] block: add copy offload support
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 mcgrof@kernel.org, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS83LzIzIDA5OjE2LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IE9uIDA3LzA5LzIzIDA3OjQ5
QU0sIEhhbm5lcyBSZWluZWNrZSB3cm90ZToKPj4gT24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hl
dHR5IHdyb3RlOgo+Pgo+PiBIbW0uIFRoYXQgbG9va3MgYSBiaXQgb2RkLiBXaHkgZG8geW91IGhh
dmUgdG8gdXNlIHdhaXRfZm9yX2NvbXBsZXRpb24/Cj4gCj4gd2FpdF9mb3JfY29tcGxldGlvbiBp
cyB3YWl0aW5nIGZvciBhbGwgdGhlIGNvcHkgSU9zIHRvIGNvbXBsZXRlLAo+IHdoZW4gY2FsbGVy
IGRvZXMgbm90IHBhc3MgZW5kaW8gaGFuZGxlci4KPiBDb3B5IElPIHN1Ym1pc3Npb25zIGFyZSBz
dGlsbCBhc3luYywgYXMgaW4gcHJldmlvdXMgcmV2aXNpb25zLgo+IAo+PiBDYW4ndCB5b3Ugc3Vi
bWl0IHRoZSAnc3JjJyBiaW8sIGFuZCB0aGVuIHN1Ym1pdCB0aGUgJ2RzdCcgYmlvIGZyb20gdGhl
IAo+PiBlbmRpbyBoYW5kbGVyIG9mIHRoZSAnc3JjJyBiaW8/Cj4gV2UgY2FuJ3QgZG8gdGhpcyB3
aXRoIHRoZSBjdXJyZW50IGJpbyBtZXJnaW5nIGFwcHJvYWNoLgo+ICdzcmMnIGJpbyB3YWl0cyBm
b3IgdGhlICdkc3QnIGJpbyB0byBhcnJpdmUgaW4gcmVxdWVzdCBsYXllci4KPiBOb3RlIHRoYXQg
Ym90aCBiaW8ncyBzaG91bGQgYmUgcHJlc2VudCBpbiByZXF1ZXN0IHJlYWNoaW5nIHRoZSBkcml2
ZXIsCj4gdG8gZm9ybSB0aGUgY29weS1jbWQuCj4gCkhtbS4gSSBndWVzcyBpdCB3b3VsZCBiZSBw
b3NzaWJsZSwgYnV0IGluIHRoZSBlbmQgd2UgY2FuIGFsd2F5cyBjaGFuZ2UKaXQgbGF0ZXIgb25j
ZSB0aGUgaW5mcmFzdHJ1Y3R1cmUgaXMgaW4uCgpTbzoKClJldmlld2VkLWJ5OiBIYW5uZXMgUmVp
bmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWlu
ZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRl
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0
d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAz
NjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3
Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

