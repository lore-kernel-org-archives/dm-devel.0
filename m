Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83DE5EE57CB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Sep 2023 06:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694153698;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9SA2wBp3n9hQe1WrVej5pZWeJWyUQ7BbgltunmW9EGA=;
	b=SZlg6I/K3uVKXmGoB7/35k2zmI+jvIGPsXAH6ywFA1/yzN2OXmr+r5s3l1Cj21A1GFTpBM
	YfVECC8g0TirquLODz0+mhXtaK87UMjUZWiO6N1F1YUmHQfjH06OGvbbLIDiBEyH/YhDXI
	QKo0woBQ8mx9JslNnOKyjlSlKn6ob+k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-_hgXbwNTOmOxGr85hfs9xA-1; Fri, 08 Sep 2023 02:14:55 -0400
X-MC-Unique: _hgXbwNTOmOxGr85hfs9xA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD837280FECE;
	Fri,  8 Sep 2023 06:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BBF24140E966;
	Fri,  8 Sep 2023 06:14:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79E36194658F;
	Fri,  8 Sep 2023 06:14:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 38CAB194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Sep 2023 06:14:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 221341121314; Fri,  8 Sep 2023 06:14:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B0001121318
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:14:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E92143814967
 for <dm-devel@redhat.com>; Fri,  8 Sep 2023 06:14:51 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-AtNf3KlMOjOENvGSmSoGNQ-1; Fri,
 08 Sep 2023 02:14:49 -0400
X-MC-Unique: AtNf3KlMOjOENvGSmSoGNQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 5D27B1F45A;
 Fri,  8 Sep 2023 06:14:48 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E3D10131FD;
 Fri,  8 Sep 2023 06:14:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id WLKONNe7+mSabAAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 08 Sep 2023 06:14:47 +0000
Message-ID: <bf2e8a17-fd95-4e48-92cd-382f7c8ee944@suse.de>
Date: Fri, 8 Sep 2023 08:14:47 +0200
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
 <CGME20230906164425epcas5p4275f672db2cfe129f666d8c929cbd095@epcas5p4.samsung.com>
 <20230906163844.18754-12-nj.shetty@samsung.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230906163844.18754-12-nj.shetty@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v15 11/12] null: Enable trace capability for
 null block
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gOS82LzIzIDE4OjM4LCBOaXRlc2ggU2hldHR5IHdyb3RlOgo+IFRoaXMgaXMgYSBwcmVwIHBh
dGNoIHRvIGVuYWJsZSBjb3B5IHRyYWNlIGNhcGFiaWxpdHkuCj4gQXQgcHJlc2VudCBvbmx5IHpv
bmVkIG51bGxfYmxvY2sgaXMgdXNpbmcgdHJhY2UsIHNvIHdlIGRlY291cGxlZCB0cmFjZQo+IGFu
ZCB6b25lZCBkZXBlbmRlbmN5IHRvIG1ha2UgaXQgdXNhYmxlIGluIG51bGxfYmxrIGRyaXZlciBh
bHNvLgo+IAo+IFNpZ25lZC1vZmYtYnk6IE5pdGVzaCBTaGV0dHkgPG5qLnNoZXR0eUBzYW1zdW5n
LmNvbT4KPiBTaWduZWQtb2ZmLWJ5OiBBbnVqIEd1cHRhIDxhbnVqMjAuZ0BzYW1zdW5nLmNvbT4K
PiAtLS0KPiAgIGRyaXZlcnMvYmxvY2svbnVsbF9ibGsvTWFrZWZpbGUgfCAyIC0tCj4gICBkcml2
ZXJzL2Jsb2NrL251bGxfYmxrL21haW4uYyAgIHwgMyArKysKPiAgIGRyaXZlcnMvYmxvY2svbnVs
bF9ibGsvdHJhY2UuaCAgfCAyICsrCj4gICBkcml2ZXJzL2Jsb2NrL251bGxfYmxrL3pvbmVkLmMg
IHwgMSAtCj4gICA0IGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJz
LAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBT
dG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxk
c3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOk
ZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJldyBNY0RvbmFsZCwgTWFy
dGplIEJvdWRpZW4gTW9lcm1hbgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJl
ZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1k
ZXZlbAo=

