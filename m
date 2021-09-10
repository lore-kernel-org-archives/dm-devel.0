Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF8EC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 20287611C1
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 20287611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-jXySqInTOzmyPTk1F_Tivw-1; Fri, 10 Sep 2021 07:43:29 -0400
X-MC-Unique: jXySqInTOzmyPTk1F_Tivw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C11E2802B9E;
	Fri, 10 Sep 2021 11:43:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A52A55453A;
	Fri, 10 Sep 2021 11:43:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D13C4EA39;
	Fri, 10 Sep 2021 11:43:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABh28i010269 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:43:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4BCB220807EA; Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46D4F2079761
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 304C78934E4
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:43:02 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-178-Hfna727xNbqSWlqz75FdFQ-1; Fri, 10 Sep 2021 07:42:59 -0400
X-MC-Unique: Hfna727xNbqSWlqz75FdFQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1C14822433;
	Fri, 10 Sep 2021 11:42:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C32B213ECA;
	Fri, 10 Sep 2021 11:42:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 8JdeLcFEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:57 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:41:07 +0200
Message-Id: <20210910114120.13665-23-mwilck@suse.com>
In-Reply-To: <20210910114120.13665-1-mwilck@suse.com>
References: <20210910114120.13665-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABh28i010269
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 22/35] multipathd: uxlsnr: remove check_timeout()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This function just prints a warning, anyway. If this warning
is printed, the client will see a timeout and print a warning, too.
A later patch will re-introduce this function with real functionality.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index cbbcb2c..147f81a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -168,25 +168,6 @@ static void free_polls (void)
 		FREE(polls);
 }
 
-static void check_timeout(struct timespec start_time, char *inbuf,
-		   unsigned int timeout)
-{
-	struct timespec diff_time, end_time;
-
-	if (start_time.tv_sec) {
-		unsigned long msecs;
-
-		get_monotonic_time(&end_time);
-		timespecsub(&end_time, &start_time, &diff_time);
-		msecs = diff_time.tv_sec * 1000 +
-			diff_time.tv_nsec / (1000 * 1000);
-		if (msecs > timeout)
-			condlog(2, "cli cmd '%s' timeout reached "
-				"after %ld.%06lu secs", inbuf,
-				(long)diff_time.tv_sec, diff_time.tv_nsec / 1000);
-	}
-}
-
 void uxsock_cleanup(void *arg)
 {
 	struct client *client_loop;
@@ -574,8 +555,6 @@ void *uxsock_listen(long ux_sock, void *trigger_data)
 					FREE(reply);
 					reply = NULL;
 				}
-				check_timeout(start_time, inbuf,
-					      uxsock_timeout);
 				FREE(inbuf);
 			}
 		}
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

