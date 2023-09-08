Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DACEE57CA
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 06:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694153480;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a82yiicdLVPMSWKvopqqsqS6zN4JKoL9Ezt1k4O7zXA=;
	b=Itysl4pXsUYGCDoSDlPqEAb9vQlDW8GNf4qEI9qdvC1lJotF2u/KloerfkDDL+vRwsm+f0
	r9sBtGo/60bertfXa409aib0z4kMJwb8v4pAWXHFe4lOmTuzurcgEVL0Q0C4HsUh0w9Oej
	AmPdENmnC5R9gNOig0a36IIu8KPJzEY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-691-KRZvEkNPOSCHEP8pkjqsrA-1; Fri, 08 Sep 2023 02:11:17 -0400
X-MC-Unique: KRZvEkNPOSCHEP8pkjqsrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DD9A181792A;
	Fri,  8 Sep 2023 06:11:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC4D2026D2B;
	Fri,  8 Sep 2023 06:11:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4C5DE194658F;
	Fri,  8 Sep 2023 06:11:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13E11194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 06:11:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C396D4024322; Fri,  8 Sep 2023 06:11:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BC45A40C2070
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:11:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A60E101A529
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:11:13 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-eyTyyPAANKCfTArs9cpXqg-1; Fri,
 08 Sep 2023 02:11:10 -0400
X-MC-Unique: eyTyyPAANKCfTArs9cpXqg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A5672218EE;
 Fri,  8 Sep 2023 06:11:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 35602131FD;
 Fri,  8 Sep 2023 06:11:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id iNHICv26+mQYaQAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 08 Sep 2023 06:11:09 +0000
Message-ID: <5e0271d9-d3a3-45cf-8ba7-fd4617fb6557@suse.de>
Date: Fri, 8 Sep 2023 08:11:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164359epcas5p326df3257e93d1f5454b8c6b6c642e61c@epcas5p3.samsung.com>
 <20230906163844.18754-9-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-9-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v15 08/12] nvmet: add copy command support
 for bdev and file ns
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
Cc: martin.petersen@oracle.com, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 Anuj Gupta <anuj20.g@samsung.com>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, mcgrof@kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IEFkZCBzdXBwb3J0IGZvciBo
YW5kbGluZyBudm1lX2NtZF9jb3B5IGNvbW1hbmQgb24gdGFyZ2V0Lgo+IAo+IEZvciBiZGV2LW5z
IGlmIGJhY2tpbmcgZGV2aWNlIHN1cHBvcnRzIGNvcHkgb2ZmbG9hZCB3ZSBjYWxsIGRldmljZSBj
b3B5Cj4gb2ZmbG9hZCAoYmxrZGV2X2NvcHlfb2ZmbG9hZCkuCj4gSW4gY2FzZSBvZiBwYXJ0aWFs
IGNvbXBsZXRpb24gZnJvbSBhYm92ZSBvciBhYnNlbmNlIG9mIGRldmljZSBjb3B5IG9mZmxvYWQK
PiBjYXBhYmlsaXR5LCB3ZSBmYWxsYmFjayB0byBjb3B5IGVtdWxhdGlvbiAoYmxrZGV2X2NvcHlf
ZW11bGF0aW9uKQo+IAo+IEZvciBmaWxlLW5zIHdlIGNhbGwgdmZzX2NvcHlfZmlsZV9yYW5nZSB0
byBzZXJ2aWNlIG91ciByZXF1ZXN0Lgo+IAo+IEN1cnJlbnRseSB0YXJnZXQgYWx3YXlzIHNob3dz
IGNvcHkgY2FwYWJpbGl0eSBieSBzZXR0aW5nCj4gTlZNRV9DVFJMX09OQ1NfQ09QWSBpbiBjb250
cm9sbGVyIE9OQ1MuCj4gCj4gbG9vcCB0YXJnZXQgaGFzIGNvcHkgc3VwcG9ydCwgd2hpY2ggY2Fu
IGJlIHVzZWQgdG8gdGVzdCBjb3B5IG9mZmxvYWQuCj4gdHJhY2UgZXZlbnQgc3VwcG9ydCBmb3Ig
bnZtZV9jbWRfY29weS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBOaXRlc2ggU2hldHR5IDxuai5zaGV0
dHlAc2Ftc3VuZy5jb20+Cj4gU2lnbmVkLW9mZi1ieTogQW51aiBHdXB0YSA8YW51ajIwLmdAc2Ft
c3VuZy5jb20+Cj4gLS0tCj4gICBkcml2ZXJzL252bWUvdGFyZ2V0L2FkbWluLWNtZC5jICAgfCAg
OSArKy0KPiAgIGRyaXZlcnMvbnZtZS90YXJnZXQvaW8tY21kLWJkZXYuYyB8IDk3ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysKPiAgIGRyaXZlcnMvbnZtZS90YXJnZXQvaW8tY21kLWZp
bGUuYyB8IDUwICsrKysrKysrKysrKysrKysKPiAgIGRyaXZlcnMvbnZtZS90YXJnZXQvbnZtZXQu
aCAgICAgICB8ICA0ICsrCj4gICBkcml2ZXJzL252bWUvdGFyZ2V0L3RyYWNlLmMgICAgICAgfCAx
OSArKysrKysKPiAgIDUgZmlsZXMgY2hhbmdlZCwgMTc3IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNo
ZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJu
ZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4
ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2Vz
Y2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQs
IE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

