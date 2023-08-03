Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25F6C04A6A
	for <dm-devel@archiver.kernel.org>; Fri,  4 Aug 2023 05:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691126906;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZbQkOWOKbXdJUz9xRglo2IhVJPedUou1C+DAvbwGXUo=;
	b=TOS2XVILZMoBTCwJk2DgiYokdZV18ntJBrLpszR4IW+0GRqDi+WWdhF55s52OrM9no440T
	KGdmuOO7nZ5IMrnW/NxT1zMS9gUt+kcRJ9Y8d5DyuD9SPVGGbIe7EP9sqpJNyZTo2NmZK4
	5G+utUsn9UF93bTj7NbKpXhXblaAIek=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-C4u_59ViNRuc4rmFk7f6hA-1; Fri, 04 Aug 2023 01:28:23 -0400
X-MC-Unique: C4u_59ViNRuc4rmFk7f6hA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BBFB3806738;
	Fri,  4 Aug 2023 05:28:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8D0A6F7837;
	Fri,  4 Aug 2023 05:28:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 61BC31946A79;
	Fri,  4 Aug 2023 05:28:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9D26D1946A45
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Aug 2023 08:37:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 599782166B26; Thu,  3 Aug 2023 08:37:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50BAC2166B25
 for <dm-devel@redhat.com>; Thu,  3 Aug 2023 08:37:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CBD7381AE58
 for <dm-devel@redhat.com>; Thu,  3 Aug 2023 08:37:32 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-NCtKIeuDMZarLBRdJhpCJA-1; Thu,
 03 Aug 2023 04:37:30 -0400
X-MC-Unique: NCtKIeuDMZarLBRdJhpCJA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8718521990;
 Thu,  3 Aug 2023 08:27:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 45FCC134B0;
 Thu,  3 Aug 2023 08:27:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id oHFOEP5ky2SfUgAAMHmgww
 (envelope-from <vbabka@suse.cz>); Thu, 03 Aug 2023 08:27:42 +0000
Message-ID: <2cfa5f55-1d68-8a4f-d049-13f42e0d1484@suse.cz>
Date: Thu, 3 Aug 2023 10:27:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20230531125535.676098-1-hch@lst.de>
 <20230531125535.676098-5-hch@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230531125535.676098-5-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 04 Aug 2023 05:28:11 +0000
Subject: Re: [dm-devel] [PATCH 04/24] PM: hibernate: move finding the resume
 device out of software_resume
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
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org,
 Linux regressions mailing list <regressions@lists.linux.dev>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.cz
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/31/23 14:55, Christoph Hellwig wrote:
> software_resume can be called either from an init call in the boot code,
> or from sysfs once the system has finished booting, and the two
> invocation methods this can't race with each other.
> 
> For the latter case we did just parse the suspend device manually, while
> the former might not have one.  Split software_resume so that the search
> only happens for the boot case, which also means the special lockdep
> nesting annotation can go away as the system transition mutex can be
> taken a little later and doesn't have the sysfs locking nest inside it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Rafael J. Wysocki <rafael@kernel.org>

This caused a regression for me in 6.5-rc1+, fix below.

----8<----
From 95a310ae6cfae9b3cab61e54a1bce488c3ab93a1 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 2 Aug 2023 15:46:18 +0200
Subject: [PATCH] PM: hibernate: fix resume_store() return value when
 hibernation not available

On a laptop with hibernation set up but not actively used, and with
secure boot and lockdown enabled kernel, 6.5-rc1 gets stuck on boot with
the following repeated messages:

  A start job is running for Resume from hibernation using device /dev/system/swap (24s / no limit)
  lockdown_is_locked_down: 25311154 callbacks suppressed
  Lockdown: systemd-hiberna: hibernation is restricted; see man kernel_lockdown.7
  ...

Checking the resume code leads to commit cc89c63e2fe3 ("PM: hibernate:
move finding the resume device out of software_resume") which
inadvertently changed the return value from resume_store() to 0 when
!hibernation_available(). This apparently translates to userspace
write() returning 0 as in number of bytes written, and userspace looping
indefinitely in the attempt to write the intended value.

Fix this by returning the full number of bytes that were to be written,
as that's what was done before the commit.

Fixes: cc89c63e2fe3 ("PM: hibernate: move finding the resume device out of software_resume")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 kernel/power/hibernate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e1b4bfa938dd..2b4a946a6ff5 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -1166,7 +1166,7 @@ static ssize_t resume_store(struct kobject *kobj, struct kobj_attribute *attr,
 	int error;
 
 	if (!hibernation_available())
-		return 0;
+		return n;
 
 	if (len && buf[len-1] == '\n')
 		len--;
-- 
2.41.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

