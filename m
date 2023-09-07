Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B71EE14D4
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 05:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694065780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=alpNarrSqkJJqQn9NFC+uVUcsQmvtsWWHOMn53elDZ4=;
	b=IrSilxeENwPK7vQrkOBaGx5hKuh1xpjFlLukdsDry8YWHu0uMrjoHF7XibX0xctNSuEug2
	f4u36A3lq3O7TpZLRoS+2v0tKdZlE8GlA9QyY3M2kz4dj3a3voVQAibZ6qFT8b9Y7NRMcE
	JCqJh65MUJQa4jZu8pisb60bGnyUFyY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-7JxNBJ5oMGu7rlf9ZgKIlA-1; Thu, 07 Sep 2023 01:49:37 -0400
X-MC-Unique: 7JxNBJ5oMGu7rlf9ZgKIlA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DCDA29A9CA5;
	Thu,  7 Sep 2023 05:49:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECEDD404119;
	Thu,  7 Sep 2023 05:49:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B931C194658F;
	Thu,  7 Sep 2023 05:49:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E374194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 05:49:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 25F29C03299; Thu,  7 Sep 2023 05:49:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CE5BC03292
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 05:49:31 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F197F29AA2CC
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 05:49:30 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-elMHCDMhPOSMHX9IXD7ETQ-1; Thu,
 07 Sep 2023 01:49:29 -0400
X-MC-Unique: elMHCDMhPOSMHX9IXD7ETQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 2C08A1F459;
 Thu,  7 Sep 2023 05:39:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7AB0513458;
 Thu,  7 Sep 2023 05:39:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id r6UMGwNi+WQ6XAAAMHmgww
 (envelope-from <hare@suse.de>); Thu, 07 Sep 2023 05:39:15 +0000
Message-ID: <d2c3a257-0505-4d3e-ae71-28015952cef6@suse.de>
Date: Thu, 7 Sep 2023 07:39:14 +0200
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
 <CGME20230906164303epcas5p1c2d3ec21feac347f0f1d68adc97c61f5@epcas5p1.samsung.com>
 <20230906163844.18754-3-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-3-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v15 02/12] Add infrastructure for copy
 offload in block and request layer.
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IFdlIGFkZCB0d28gbmV3IG9w
Y29kZSBSRVFfT1BfQ09QWV9TUkMsIFJFUV9PUF9DT1BZX0RTVC4KPiBTaW5jZSBjb3B5IGlzIGEg
Y29tcG9zaXRlIG9wZXJhdGlvbiBpbnZvbHZpbmcgc3JjIGFuZCBkc3Qgc2VjdG9ycy9sYmEsCj4g
ZWFjaCBuZWVkcyB0byBiZSByZXByZXNlbnRlZCBieSBhIHNlcGFyYXRlIGJpbyB0byBtYWtlIGl0
IGNvbXBhdGlibGUKPiB3aXRoIGRldmljZSBtYXBwZXIuCj4gV2UgZXhwZWN0IGNhbGxlciB0byB0
YWtlIGEgcGx1ZyBhbmQgc2VuZCBiaW8gd2l0aCBzb3VyY2UgaW5mb3JtYXRpb24sCj4gZm9sbG93
ZWQgYnkgYmlvIHdpdGggZGVzdGluYXRpb24gaW5mb3JtYXRpb24uCj4gT25jZSB0aGUgc3JjIGJp
byBhcnJpdmVzIHdlIGZvcm0gYSByZXF1ZXN0IGFuZCB3YWl0IGZvciBkZXN0aW5hdGlvbgo+IGJp
by4gVXBvbiBhcnJpdmFsIG9mIGRlc3RpbmF0aW9uIHdlIG1lcmdlIHRoZXNlIHR3byBiaW8ncyBh
bmQgc2VuZAo+IGNvcnJlc3BvbmRpbmcgcmVxdWVzdCBkb3duIHRvIGRldmljZSBkcml2ZXIuCj4g
Cj4gU2lnbmVkLW9mZi1ieTogTml0ZXNoIFNoZXR0eSA8bmouc2hldHR5QHNhbXN1bmcuY29tPgo+
IFNpZ25lZC1vZmYtYnk6IEFudWogR3VwdGEgPGFudWoyMC5nQHNhbXN1bmcuY29tPgo+IC0tLQo+
ICAgYmxvY2svYmxrLWNvcmUuYyAgICAgICAgICB8ICA3ICsrKysrKysKPiAgIGJsb2NrL2Jsay1t
ZXJnZS5jICAgICAgICAgfCA0MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysKPiAgIGJsb2NrL2Jsay5oICAgICAgICAgICAgICAgfCAxNiArKysrKysrKysrKysrKysKPiAg
IGJsb2NrL2VsZXZhdG9yLmggICAgICAgICAgfCAgMSArCj4gICBpbmNsdWRlL2xpbnV4L2Jpby5o
ICAgICAgIHwgIDYgKy0tLS0tCj4gICBpbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oIHwgMTAgKysr
KysrKysrKwo+ICAgNiBmaWxlcyBjaGFuZ2VkLCA3NiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQo+IApIYXZpbmcgdHdvIHNlcGFyYXRlIGJpb3MgaXMgb2theSwgYW5kIHdoYXQgb25lIHdv
dWxkIGV4cGVjdC4KV2hhdCBpcyBzbGlnaHRseSBzdHJhbmdlIGlzIHRoZSBtZXJnaW5nIGZ1bmN0
aW9uYWxpdHk7ClRoYXQgY291bGQgZG8gd2l0aCBzb21lIG1vcmUgZXhwbGFuYXRpb24gd2h5IHRo
aXMgYXBwcm9hY2ggd2FzIHRha2VuLgpBbmQgYWxzbyBzb21lIGNoZWNrcyBpbiB0aGUgbWVyZ2lu
ZyBjb2RlIHRvIGF2b2lkIG1lcmdpbmcgbm9uLWNvcHkgCm9mZmxvYWQgIGJpb3MuCgpDaGVlcnMs
CgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0
b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRz
dHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6Rm
dHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0
amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVk
aGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVsCg==

