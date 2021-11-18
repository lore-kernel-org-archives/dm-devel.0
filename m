Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42EE1C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:18:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D270E61A86
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:18:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D270E61A86
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-XiPgjL2KNQKo3vllX702Rg-1; Thu, 18 Nov 2021 18:18:40 -0500
X-MC-Unique: XiPgjL2KNQKo3vllX702Rg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6D5D87D543;
	Thu, 18 Nov 2021 23:18:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CCE2100EBBE;
	Thu, 18 Nov 2021 23:18:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 756D41832DD5;
	Thu, 18 Nov 2021 23:18:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINE8Ap005129 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E265540CFD14; Thu, 18 Nov 2021 23:14:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCFBA4010E98
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3D9F1066694
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:07 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-549-vBBnISd2OJur9OXX4yR2Dw-1; Thu, 18 Nov 2021 18:14:06 -0500
X-MC-Unique: vBBnISd2OJur9OXX4yR2Dw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C341A1FD3C;
	Thu, 18 Nov 2021 23:14:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7949913AA8;
	Thu, 18 Nov 2021 23:14:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id OOY+GzzelmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:04 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:34 +0100
Message-Id: <20211118231338.22358-18-mwilck@suse.com>
In-Reply-To: <20211118231338.22358-1-mwilck@suse.com>
References: <20211118231338.22358-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINE8Ap005129
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 17/21] multipathd (coverity): daemonize(): use
	dup2
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Modify the file descriptors atomically usign dup2(), and make
sure to cleanup properly even in case of an error, and to not
close stdout/in/err if the program had been started with any of
them closed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index b8d4fcf..8bd680d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3341,11 +3341,18 @@ failed:
 	return sd_notify_exit(exit_code);
 }
 
+static void cleanup_close(int *pfd)
+{
+	if (*pfd != -1 && *pfd != STDIN_FILENO && *pfd != STDOUT_FILENO &&
+	    *pfd != STDERR_FILENO)
+		close(*pfd);
+}
+
 static int
 daemonize(void)
 {
 	int pid;
-	int dev_null_fd;
+	int dev_null_fd __attribute__((cleanup(cleanup_close))) = -1;
 
 	if( (pid = fork()) < 0){
 		fprintf(stderr, "Failed first fork : %s\n", strerror(errno));
@@ -3371,25 +3378,21 @@ daemonize(void)
 		_exit(0);
 	}
 
-	close(STDIN_FILENO);
-	if (dup(dev_null_fd) < 0) {
-		fprintf(stderr, "cannot dup /dev/null to stdin : %s\n",
+	if (dup2(dev_null_fd, STDIN_FILENO) < 0) {
+		fprintf(stderr, "cannot dup2 /dev/null to stdin : %s\n",
 			strerror(errno));
 		_exit(0);
 	}
-	close(STDOUT_FILENO);
-	if (dup(dev_null_fd) < 0) {
-		fprintf(stderr, "cannot dup /dev/null to stdout : %s\n",
+	if (dup2(dev_null_fd, STDOUT_FILENO) < 0) {
+		fprintf(stderr, "cannot dup2 /dev/null to stdout : %s\n",
 			strerror(errno));
 		_exit(0);
 	}
-	close(STDERR_FILENO);
-	if (dup(dev_null_fd) < 0) {
+	if (dup2(dev_null_fd, STDERR_FILENO) < 0) {
 		fprintf(stderr, "cannot dup /dev/null to stderr : %s\n",
 			strerror(errno));
 		_exit(0);
 	}
-	close(dev_null_fd);
 	daemon_pid = getpid();
 	return 0;
 }
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

