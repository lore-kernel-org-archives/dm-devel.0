Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61B4ECAAD1
	for <dm-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662048619;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eFon/CK3BRwOcxGUkiW8WtiB72Ly9i2W5sv9jR6KKd8=;
	b=HPCyk/NpwNtOVUJ/F36stXk+zCtl5ObRN+4766BVD2e/hMOaYgEcJyfp8peI2jSDVesHY1
	r1/nWxXK3yzA3VPDBjMy7uJK4KpeRfWhXxrVfmaZ2QYVt8NDon2+1TyyeCuHGArTRwHHcX
	co0gNOl+1CwCwXuKjowJavdBkKbMIpM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-VBq41cT2OQm20IDBP3ytsQ-1; Thu, 01 Sep 2022 12:10:18 -0400
X-MC-Unique: VBq41cT2OQm20IDBP3ytsQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42F5A10111EA;
	Thu,  1 Sep 2022 16:10:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0E9B945D0;
	Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CE9991940342;
	Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50D67194322D
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2ED9D4C819; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B462945D0
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1260D80A0AE
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-227-83nMUIsdMNKrUCrg9utZmw-1; Thu,
 01 Sep 2022 12:10:11 -0400
X-MC-Unique: 83nMUIsdMNKrUCrg9utZmw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 7A6FA2021F;
 Thu,  1 Sep 2022 16:10:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C99F13A79;
 Thu,  1 Sep 2022 16:10:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id uB0UEWHZEGMPDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 16:10:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  1 Sep 2022 18:09:49 +0200
Message-Id: <20220901160952.2167-14-mwilck@suse.com>
In-Reply-To: <20220901160952.2167-1-mwilck@suse.com>
References: <20220901160952.2167-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 13/16] multipath:
 find_multipaths_check_timeout(): no need for pthread cleanup
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

multipath is not a multithreaded program, no pthread-cancel complexity
is necesssary here.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index fbff6b7..7b69a3c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -321,7 +321,7 @@ static int find_multipaths_check_timeout(const struct path *pp, long tmo,
 	char path[PATH_MAX];
 	struct timespec now, ftimes[2], tdiff;
 	struct stat st;
-	int fd = -1;
+	int fd;
 	int r, retries = 0;
 
 	clock_gettime(CLOCK_REALTIME, &now);
@@ -339,9 +339,8 @@ static int find_multipaths_check_timeout(const struct path *pp, long tmo,
 retry:
 	fd = open(path, O_RDONLY);
 	if (fd != -1) {
-		pthread_cleanup_push(cleanup_fd_ptr, &fd);
 		r = fstat(fd, &st);
-		pthread_cleanup_pop(1);
+		close(fd);
 
 	} else if (tmo > 0) {
 		if (errno == ENOENT)
@@ -355,7 +354,6 @@ retry:
 			return FIND_MULTIPATHS_ERROR;
 		};
 
-		pthread_cleanup_push(cleanup_fd_ptr, &fd);
 		/*
 		 * We just created the file. Set st_mtim to our desired
 		 * expiry time.
@@ -369,7 +367,7 @@ retry:
 				path, strerror(errno));
 		}
 		r = fstat(fd, &st);
-		pthread_cleanup_pop(1);
+		close(fd);
 	} else
 		return FIND_MULTIPATHS_NEVER;
 
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

