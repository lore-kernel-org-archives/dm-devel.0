Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C3DC7EE2E
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686292674;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3tiQLrUQaD6qaZz9Qj/U8SyopOtKSSxx/RaRZl9zl54=;
	b=QEM5tpbf9e/WtJOboQqWdEwmDk1bSPYhSVYmsbTRsFTVz0JDQ9IWSNvBQvCOmf1N9TIxJn
	NGlgXFw8lfMa4Frc0DSQIN2fUttRmprULi3hfD/lz0OkLihztXGG7w0U3tr4I/cYbDT8G4
	iXmIErAxhq2IXrf7HUHreIaUiR+eGVo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-reOO-fhJOwC__Hrl4NFIyQ-1; Fri, 09 Jun 2023 02:37:51 -0400
X-MC-Unique: reOO-fhJOwC__Hrl4NFIyQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73B6B803DBC;
	Fri,  9 Jun 2023 06:37:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B987515540;
	Fri,  9 Jun 2023 06:37:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD65519451C0;
	Fri,  9 Jun 2023 06:37:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63C5E194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 06:37:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4387040CF8F6; Fri,  9 Jun 2023 06:37:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CB2640CF8EE
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 06:37:43 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23012185A791
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 06:37:43 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-443-EMGCHPIaPqix18zMupqnfA-1; Fri,
 09 Jun 2023 02:37:41 -0400
X-MC-Unique: EMGCHPIaPqix18zMupqnfA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id C5AB621A53;
 Fri,  9 Jun 2023 06:37:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2374A139C8;
 Fri,  9 Jun 2023 06:37:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id Jna4BrPIgmRfNwAAMHmgww
 (envelope-from <hare@suse.de>); Fri, 09 Jun 2023 06:37:39 +0000
Message-ID: <f398627e-f69f-de42-d55d-2d497d208ae5@suse.de>
Date: Fri, 9 Jun 2023 08:37:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-6-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230608110258.189493-6-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 05/30] cdrom: track if a cdrom_device_info
 was opened for data
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-nvme@lists.infradead.org,
 Phillip Potter <phil@philpotter.co.uk>, Chris Mason <clm@fb.com>,
 dm-devel@redhat.com, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 linux-pm@vger.kernel.org, linux-um@lists.infradead.org,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNi84LzIzIDEzOjAyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBTZXQgYSBmbGFnIHdo
ZW4gYSBjZHJvbV9kZXZpY2VfaW5mbyBpcyBvcGVuZWQgZm9yIHdyaXRpbmcsIGluc3RlYWQgb2YK
PiB0cnlpbmcgdG8gZmlndXJlIG91dCB0aGlzIGF0IHJlbGVhc2UgdGltZS4gIFRoaXMgd2lsbCBh
bGxvdyB0byBldmVudHVhbGx5Cj4gcmVtb3ZlIHRoZSBtb2RlIGFyZ3VtZW50IHRvIHRoZSAtPnJl
bGVhc2UgYmxvY2tfZGV2aWNlX29wZXJhdGlvbiBhcwo+IG5vdGhpbmcgYnV0IHRoZSBDRFJPTSBk
cml2ZXJzIHVzZXMgdGhhdCBhcmd1bWVudC4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGgg
SGVsbHdpZyA8aGNoQGxzdC5kZT4KPiBSZXZpZXdlZC1ieTogUGhpbGxpcCBQb3R0ZXIgPHBoaWxA
cGhpbHBvdHRlci5jby51az4KPiBBY2tlZC1ieTogQ2hyaXN0aWFuIEJyYXVuZXIgPGJyYXVuZXJA
a2VybmVsLm9yZz4KPiAtLS0KPiAgIGRyaXZlcnMvY2Ryb20vY2Ryb20uYyB8IDEyICsrKysrLS0t
LS0tLQo+ICAgaW5jbHVkZS9saW51eC9jZHJvbS5oIHwgIDEgKwo+ICAgMiBmaWxlcyBjaGFuZ2Vk
LCA2IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5OiBIYW5uZXMg
UmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBS
ZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZUBzdXNl
LmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBT
b2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhS
QiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5k
cmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCi0tCmRt
LWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5y
ZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

