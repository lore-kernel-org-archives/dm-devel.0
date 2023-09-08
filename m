Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123F7EE57CA
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 06:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694153628;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bZdWLzH/u/5d0vfIVYRgvHzFJKc0gd0rShKfyMxorPQ=;
	b=WDF+cHITzbHf7v/GNWsxHNND3JLo6OaI4E6RUA5BtlN0ISBT/0B04nB3TtAmVyhvQVxLDE
	KQ3jw0aqcfn2HH2rdjBgcDQuvvgAARpcxepx3F1pc1gadLeQyD7GJsKyj/nkZBStSEWPxe
	JeCVU/oRh5OviMhsnr7Kp7csQUG0Hro=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-5f3LNg7XPUaYTByobcdgwQ-1; Fri, 08 Sep 2023 02:13:45 -0400
X-MC-Unique: 5f3LNg7XPUaYTByobcdgwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 655593813F48;
	Fri,  8 Sep 2023 06:13:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E7BA61121314;
	Fri,  8 Sep 2023 06:13:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7C1C194658F;
	Fri,  8 Sep 2023 06:13:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1C59194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 06:13:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B0D7D1121318; Fri,  8 Sep 2023 06:13:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A91ED1121314
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:13:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8934D8030B1
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:13:41 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-496-OpMzvde4NHG8BQHo6n3jcg-1; Fri,
 08 Sep 2023 02:13:39 -0400
X-MC-Unique: OpMzvde4NHG8BQHo6n3jcg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8DB54218E9;
 Fri,  8 Sep 2023 06:13:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A170131FD;
 Fri,  8 Sep 2023 06:13:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id kbvpCJK7+mSabAAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 08 Sep 2023 06:13:38 +0000
Message-ID: <cb767dc9-1732-4e31-bcc6-51c187750d66@suse.de>
Date: Fri, 8 Sep 2023 08:13:37 +0200
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
 <CGME20230906164407epcas5p3f9e9f33e15d7648fd1381cdfb97d11f2@epcas5p3.samsung.com>
 <20230906163844.18754-10-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-10-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v15 09/12] dm: Add support for copy offload
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
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, mcgrof@kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IEJlZm9yZSBlbmFibGluZyBj
b3B5IGZvciBkbSB0YXJnZXQsIGNoZWNrIGlmIHVuZGVybHlpbmcgZGV2aWNlcyBhbmQKPiBkbSB0
YXJnZXQgc3VwcG9ydCBjb3B5LiBBdm9pZCBzcGxpdCBoYXBwZW5pbmcgaW5zaWRlIGRtIHRhcmdl
dC4KPiBGYWlsIGVhcmx5IGlmIHRoZSByZXF1ZXN0IG5lZWRzIHNwbGl0LCBjdXJyZW50bHkgc3Bs
aXR0aW5nIGNvcHkKPiByZXF1ZXN0IGlzIG5vdCBzdXBwb3J0ZWQuCj4gCkFuZCBoZXJlIGlzIHdo
ZXJlIEkgd291bGQgaGF2ZSBleHBlY3RlZCB0aGUgZW11bGF0aW9uIHRvIHRha2UgcGxhY2U7CmRp
ZG4ndCB5b3UgaGF2ZSBpdCBpbiBvbmUgb2YgdGhlIGVhcmxpZXIgaXRlcmF0aW9ucz8KQWZ0ZXIg
YWxsLCBkZXZpY2UtbWFwcGVyIGFscmVhZHkgaGFzIHRoZSBpbmZyYXN0cnVjdHVyZSBmb3IgY29w
eWluZwpkYXRhIGJldHdlZW4gZGV2aWNlcywgc28gYWRkaW5nIGEgY29weS1vZmZsb2FkIGVtdWxh
dGlvbiBmb3IgCmRldmljZS1tYXBwZXIgc2hvdWxkIGJlIHRyaXZpYWwuCgpDaGVlcnMsCgpIYW5u
ZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2Ug
QXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5
MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUs
IDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xo
cmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91
ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

