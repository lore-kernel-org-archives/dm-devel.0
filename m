Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A0EC77B74
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681198245;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Q+hDepwxcP1e2DPN+qEeTTLXvaDJDaOmOrBseuihzns=;
	b=egTWrt1HDp3ABcRaZHFSyiqkyHtSkfLwGzRK4BuyYaRN0Ccf4YlkzPPU0JwrLnFBaf3xT2
	yaDQwW9qDm2KEHJwm2o4WIn9Yi6Cbx5uWZHG12+fpEbEUL0KFzJv7RnqQ182q7AIK9ZSdP
	2d0L5AwGmWc7jyNgnQYhFd2yqI/4/1M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-4t8PZ2QKOL6C34XsAJ0WQw-1; Tue, 11 Apr 2023 03:30:42 -0400
X-MC-Unique: 4t8PZ2QKOL6C34XsAJ0WQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15E453C10683;
	Tue, 11 Apr 2023 07:30:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0137A1121320;
	Tue, 11 Apr 2023 07:30:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B3D241946588;
	Tue, 11 Apr 2023 07:30:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E3FB1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:30:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 40E85492B01; Tue, 11 Apr 2023 07:30:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39814492B00
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:30:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F13A1C05AAA
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:30:39 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-619-0bXssT9lNZ6n_5uXkHGVEQ-1; Tue,
 11 Apr 2023 03:30:37 -0400
X-MC-Unique: 0bXssT9lNZ6n_5uXkHGVEQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 5B5A421A4F;
 Tue, 11 Apr 2023 07:30:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A55C13638;
 Tue, 11 Apr 2023 07:30:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ETXYAJwMNWQUZgAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:30:36 +0000
Message-ID: <2803b786-2573-699b-9f71-46854d0958b5@suse.de>
Date: Tue, 11 Apr 2023 09:30:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
 hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-15-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-15-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v6 14/18] scsi: target: Rename sbc_ops to
 exec_cmd_ops
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IFRoZSBuZXh0IHBhdGNoZXMg
YWxsb3cgdXMgdG8gY2FsbCB0aGUgYmxvY2sgbGF5ZXIncyBwcl9vcHMgZnJvbSB0aGUKPiBiYWNr
ZW5kcy4gVGhpcyB3aWxsIHJlcXVpcmUgYWxsb3dpbmcgdGhlIGJhY2tlbmRzIHRvIGhvb2sgaW50
byB0aGUgY21kCj4gcHJvY2Vzc2luZyBmb3IgU1BDIGNvbW1hbmRzLCBzbyB0aGlzIHJlbmFtZXMg
c2JjX29wcyB0byBhIG1vcmUgZ2VuZXJpYwo+IGV4ZWNfY21kX29wcy4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBNaWtlIENocmlzdGllIDxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20+Cj4gUmV2aWV3
ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgo+IC0tLQo+ICAgZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfZmlsZS5jICAgIHwgIDQgKystLQo+ICAgZHJpdmVycy90YXJnZXQv
dGFyZ2V0X2NvcmVfaWJsb2NrLmMgIHwgIDQgKystLQo+ICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0
X2NvcmVfcmQuYyAgICAgIHwgIDQgKystLQo+ICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVf
c2JjLmMgICAgIHwgMTMgKysrKysrKy0tLS0tLQo+ICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0X2Nv
cmVfc3BjLmMgICAgIHwgIDQgKystLQo+ICAgaW5jbHVkZS90YXJnZXQvdGFyZ2V0X2NvcmVfYmFj
a2VuZC5oIHwgIDQgKystLQo+ICAgNiBmaWxlcyBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAx
NiBkZWxldGlvbnMoLSkKPiAKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNl
LmRlPgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAg
ICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBH
bWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJl
cmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2LCBBbmRyZXcKTXllcnMsIEFuZHJldyBN
Y0RvbmFsZCwgTWFydGplIEJvdWRpZW4gTW9lcm1hbgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0
CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9s
aXN0aW5mby9kbS1kZXZlbAo=

