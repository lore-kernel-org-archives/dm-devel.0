Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CC7C7EE43
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120547;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jeMpnE7bU7+4sFX9XlH9bx6wvvNg5nT5hWbFxahcjpw=;
	b=VZ0G+kdDkVN5BbQWZY0B65WkVMdU5ZY8XPlxhshyvlAmzj0unkKH9err3LQ+8jnFIJackc
	Y3eR9e6PRNeHmQh+32y3ChCZ5x9SG6H/yNW3hp+TI1TnHoTGM7F3FumftqkhuMOH+i8ggG
	2J9y9rOu2oEfH2SlB3gAo2OE20kf8+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-X5qv6U16OD-83IjzAKDw2A-1; Wed, 07 Jun 2023 02:49:04 -0400
X-MC-Unique: X5qv6U16OD-83IjzAKDw2A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 264478060C8;
	Wed,  7 Jun 2023 06:49:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 14B4F400F4E;
	Wed,  7 Jun 2023 06:49:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C4E7B19452C4;
	Wed,  7 Jun 2023 06:49:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CE831946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 08:29:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 51295400F4E; Tue,  6 Jun 2023 08:29:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 490F3403367
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:29:49 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED0B51C0A580
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:29:48 +0000 (UTC)
Received: from lithops.sigma-star.at (lithops.sigma-star.at
 [195.201.40.130]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-k4E0gbF5MKKvBTG2Nom9CQ-1; Tue, 06 Jun 2023 04:29:45 -0400
X-MC-Unique: k4E0gbF5MKKvBTG2Nom9CQ-1
Received: from localhost (localhost [127.0.0.1])
 by lithops.sigma-star.at (Postfix) with ESMTP id 89E7C63CC135;
 Tue,  6 Jun 2023 10:20:47 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
 by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
 with ESMTP id w2bdPD93IvhE; Tue,  6 Jun 2023 10:20:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
 by lithops.sigma-star.at (Postfix) with ESMTP id 14A1D616B2CD;
 Tue,  6 Jun 2023 10:20:47 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
 by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id X5LSD106M-YC; Tue,  6 Jun 2023 10:20:46 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
 by lithops.sigma-star.at (Postfix) with ESMTP id D62D563CC135;
 Tue,  6 Jun 2023 10:20:46 +0200 (CEST)
Date: Tue, 6 Jun 2023 10:20:46 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: hch <hch@lst.de>
Message-ID: <766259639.3687124.1686039646763.JavaMail.zimbra@nod.at>
In-Reply-To: <20230606073950.225178-26-hch@lst.de>
References: <20230606073950.225178-1-hch@lst.de>
 <20230606073950.225178-26-hch@lst.de>
MIME-Version: 1.0
X-Originating-IP: [195.201.40.130]
Thread-Topic: remove commented out code in ubd_open
Thread-Index: XkjrL/wptcQ24bQlPJHDQOJLYTpcmQ==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:49:00 +0000
Subject: Re: [dm-devel] [PATCH 25/31] ubd: remove commented out code in
 ubd_open
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
 dm-devel <dm-devel@redhat.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 Jack Wang <jinpu.wang@ionos.com>, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-pm <linux-pm@vger.kernel.org>,
 linux-um <linux-um@lists.infradead.org>, Josef Bacik <josef@toxicpanda.com>,
 Coly Li <colyli@suse.de>, linux-block <linux-block@vger.kernel.org>,
 linux-bcache@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-mtd <linux-mtd@lists.infradead.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nod.at
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

LS0tLS0gVXJzcHLDvG5nbGljaGUgTWFpbCAtLS0tLQo+IFZvbjogImhjaCIgPGhjaEBsc3QuZGU+
Cj4gVGhpcyBjb2RlIGhhcyBiZWVuIGRlYWQgZm9yZXZlciwgbWFrZSBzdXJlIGl0IGRvZXNuJ3Qg
c2hvdyB1cCBpbiBjb2RlCj4gc2VhcmNoZXMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3Bo
IEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gYXJjaC91bS9kcml2ZXJzL3ViZF9rZXJuLmMg
fCA3IC0tLS0tLS0KPiAxIGZpbGUgY2hhbmdlZCwgNyBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0t
Z2l0IGEvYXJjaC91bS9kcml2ZXJzL3ViZF9rZXJuLmMgYi9hcmNoL3VtL2RyaXZlcnMvdWJkX2tl
cm4uYwo+IGluZGV4IDhiNzk1NTQ5NjhhZGRiLi4yMGMxYTE2MTk5YzUwMyAxMDA2NDQKPiAtLS0g
YS9hcmNoL3VtL2RyaXZlcnMvdWJkX2tlcm4uYwo+ICsrKyBiL2FyY2gvdW0vZHJpdmVycy91YmRf
a2Vybi5jCj4gQEAgLTExNzAsMTMgKzExNzAsNiBAQCBzdGF0aWMgaW50IHViZF9vcGVuKHN0cnVj
dCBnZW5kaXNrICpkaXNrLCBmbW9kZV90IG1vZGUpCj4gCX0KPiAJdWJkX2Rldi0+Y291bnQrKzsK
PiAJc2V0X2Rpc2tfcm8oZGlzaywgIXViZF9kZXYtPm9wZW5mbGFncy53KTsKPiAtCj4gLQkvKiBU
aGlzIHNob3VsZCBubyBtb3JlIGJlIG5lZWRlZC4gQW5kIGl0IGRpZG4ndCB3b3JrIGFueXdheSB0
byBleGNsdWRlCj4gLQkgKiByZWFkLXdyaXRlIHJlbW91bnRpbmcgb2YgZmlsZXN5c3RlbXMuKi8K
PiAtCS8qaWYoKG1vZGUgJiBGTU9ERV9XUklURSkgJiYgIXViZF9kZXYtPm9wZW5mbGFncy53KXsK
PiAtCSAgICAgICAgaWYoLS11YmRfZGV2LT5jb3VudCA9PSAwKSB1YmRfY2xvc2VfZGV2KHViZF9k
ZXYpOwo+IC0JICAgICAgICBlcnIgPSAtRVJPRlM7Cj4gLQl9Ki8KCkFja2VkLWJ5OiBSaWNoYXJk
IFdlaW5iZXJnZXIgPHJpY2hhcmRAbm9kLmF0PgoKVGhhbmtzLAovL3JpY2hhcmQKCi0tCmRtLWRl
dmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRo
YXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

