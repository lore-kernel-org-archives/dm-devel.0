Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD56EE57CA
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 06:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694153212;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kn3b4y7WIqdwJjaIwL2dIncjFgzDYMxpcvm62pt3LQY=;
	b=dZXH5GmOfwrbBlY9D07D8Dqahel7RsqDNN6I4wwtYCo3lVd0+Y5HtuoqMS/8IInG5f2Leb
	JH8XvZThe/l5efR36dHDjC/93+0tBZgaIkmchoa3ubKRWC8e/rrMiHareWw9mgAdG6fZit
	mN79xtbE7+DPCv38sSRNonaAdLgMSZw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-93LS6MwoNpGoRsvkqDCfbA-1; Fri, 08 Sep 2023 02:06:49 -0400
X-MC-Unique: 93LS6MwoNpGoRsvkqDCfbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C58F52812950;
	Fri,  8 Sep 2023 06:06:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 571A82026D76;
	Fri,  8 Sep 2023 06:06:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EB37194658F;
	Fri,  8 Sep 2023 06:06:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 85198194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 06:06:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7579F40C84A5; Fri,  8 Sep 2023 06:06:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6ED8840C2070
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:06:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F7883C10159
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:06:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-7Q_pB3XbPVyN6DlXGLd3xQ-1; Fri,
 08 Sep 2023 02:06:41 -0400
X-MC-Unique: 7Q_pB3XbPVyN6DlXGLd3xQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A5880218E0;
 Fri,  8 Sep 2023 06:06:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 25CF2131FD;
 Fri,  8 Sep 2023 06:06:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id o2HgB++5+mQYaQAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 08 Sep 2023 06:06:39 +0000
Message-ID: <e6fc7e65-ad31-4ca2-8b1b-4d97ba32926e@suse.de>
Date: Fri, 8 Sep 2023 08:06:38 +0200
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
 <CGME20230906164321epcas5p4dad5b1c64fcf85e2c4f9fc7ddb855ea7@epcas5p4.samsung.com>
 <20230906163844.18754-5-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-5-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v15 04/12] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, martin.petersen@oracle.com,
 linux-doc@vger.kernel.org, gost.dev@samsung.com,
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

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IEZvciB0aGUgZGV2aWNlcyB3
aGljaCBkb2VzIG5vdCBzdXBwb3J0IGNvcHksIGNvcHkgZW11bGF0aW9uIGlzIGFkZGVkLgo+IEl0
IGlzIHJlcXVpcmVkIGZvciBpbi1rZXJuZWwgdXNlcnMgbGlrZSBmYWJyaWNzLCB3aGVyZSBmaWxl
IGRlc2NyaXB0b3IgaXMKPiBub3QgYXZhaWxhYmxlIGFuZCBoZW5jZSB0aGV5IGNhbid0IHVzZSBj
b3B5X2ZpbGVfcmFuZ2UuCj4gQ29weS1lbXVsYXRpb24gaXMgaW1wbGVtZW50ZWQgYnkgcmVhZGlu
ZyBmcm9tIHNvdXJjZSBpbnRvIG1lbW9yeSBhbmQKPiB3cml0aW5nIHRvIHRoZSBjb3JyZXNwb25k
aW5nIGRlc3RpbmF0aW9uLgo+IEFsc28gZW11bGF0aW9uIGNhbiBiZSB1c2VkLCBpZiBjb3B5IG9m
ZmxvYWQgZmFpbHMgb3IgcGFydGlhbGx5IGNvbXBsZXRlcy4KPiBBdCBwcmVzZW50IGluIGtlcm5l
bCB1c2VyIG9mIGVtdWxhdGlvbiBpcyBOVk1lIGZhYnJpY3MuCj4gCkxlYXZlIG91dCB0aGUgbGFz
dCBzZW50ZW5jZTsgSSByZWFsbHkgd291bGQgbGlrZSB0byBzZWUgaXQgZW5hYmxlZCBmb3IgClND
U0ksIHRvbyAod2UgZG8gaGF2ZSBjb3B5IG9mZmxvYWQgY29tbWFuZHMgZm9yIFNDU0kgLi4uKS4K
CkFuZCBpdCByYWlzZXMgYWxsIHRoZSBxdWVzdGlvbnMgd2hpY2ggaGF2ZSBib2dnZWQgdXMgZG93
biByaWdodCBmcm9tIHRoZSAKc3RhcnQ6IHdoZXJlIGlzIHRoZSBwb2ludCBpbiBjYWxsaW5nIGNv
cHkgb2ZmbG9hZCBpZiBjb3B5IG9mZmxvYWQgaXMgbm90IAppbXBsZW1lbnRlZCBvciBzbG93ZXIg
dGhhbiBjb3B5aW5nIGl0IGJ5IGhhbmQ/CkFuZCBob3cgY2FuIHRoZSBjYWxsZXIgZGlmZmVyZW50
aWF0ZSB3aGV0aGVyIGNvcHkgb2ZmbG9hZCBicmluZyBhIApiZW5lZml0IHRvIGhpbT8KCklPVzog
d291bGRuJ3QgaXQgYmUgYmV0dGVyIHRvIHJldHVybiAtRU9QTk9UU1VQUCBpZiBjb3B5IG9mZmxv
YWQgaXMgbm90IAphdmFpbGFibGU/CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVp
bmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5k
ZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJl
dwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1k
ZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVk
aGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

