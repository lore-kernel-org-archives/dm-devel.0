Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA8EC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D82DD61A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:20:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D82DD61A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-PVfeSd2CMbyMt_yk6tEFMw-1; Thu, 18 Nov 2021 18:20:33 -0500
X-MC-Unique: PVfeSd2CMbyMt_yk6tEFMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 317F087D542;
	Thu, 18 Nov 2021 23:20:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 14412100EBBE;
	Thu, 18 Nov 2021 23:20:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE0524EA37;
	Thu, 18 Nov 2021 23:20:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AINE90C005143 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 18:14:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 64AE9404727A; Thu, 18 Nov 2021 23:14:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6093C4047279
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4803B181E065
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 23:14:09 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-275-5vmyg8-yMh2buCFcFjSt8Q-1; Thu, 18 Nov 2021 18:14:05 -0500
X-MC-Unique: 5vmyg8-yMh2buCFcFjSt8Q-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1AE871FD2F;
	Thu, 18 Nov 2021 23:14:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C6D9813AA8;
	Thu, 18 Nov 2021 23:14:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id KHMsLjvelmGAQAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 23:14:03 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 19 Nov 2021 00:13:32 +0100
Message-Id: <20211118231338.22358-16-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AINE90C005143
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 15/21] kpartx: use opened loop device immediately
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

The code in find_unused_loop_device() goes through circles to
get an unused device, but it takes no care not to race with a different
process opening the same loop device. Use the once-opened
loop device for setup immediately instead of closing and re-opening it.

While at it, simplify the code somewhat.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c |  4 +--
 kpartx/lopart.c | 83 ++++++++++++++++++++-----------------------------
 kpartx/lopart.h |  3 +-
 3 files changed, 35 insertions(+), 55 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 7bc6454..3c49999 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -359,9 +359,7 @@ main(int argc, char **argv){
 			exit (0);
 
 		if (!loopdev) {
-			loopdev = find_unused_loop_device();
-
-			if (set_loop(loopdev, rpath, 0, &ro)) {
+			if (set_loop(&loopdev, rpath, 0, &ro)) {
 				fprintf(stderr, "can't set up loop\n");
 				exit (1);
 			}
diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index 2661940..7041ddf 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -39,24 +39,6 @@
 #define LOOP_CTL_GET_FREE       0x4C82
 #endif
 
-static char *
-xstrdup (const char *s)
-{
-	char *t;
-
-	if (s == NULL)
-		return NULL;
-
-	t = strdup (s);
-
-	if (t == NULL) {
-		fprintf(stderr, "not enough memory");
-		exit(1);
-	}
-
-	return t;
-}
-
 #define SIZE(a) (sizeof(a)/sizeof(a[0]))
 
 char *find_loop_by_file(const char *filename)
@@ -157,9 +139,9 @@ char *find_loop_by_file(const char *filename)
 	return found;
 }
 
-char *find_unused_loop_device(void)
+static char *find_unused_loop_device(int mode, int *loop_fd)
 {
-	char dev[21], *next_loop_dev = NULL;
+	char dev[21];
 	int fd, next_loop = 0, somedev = 0, someloop = 0, loop_known = 0;
 	int next_loop_fd;
 	struct stat statbuf;
@@ -168,45 +150,48 @@ char *find_unused_loop_device(void)
 
 	next_loop_fd = open("/dev/loop-control", O_RDWR);
 	if (next_loop_fd < 0)
-		return NULL;
+		goto no_loop_fd;
 
-	if (!(fstat(next_loop_fd, &statbuf) == 0 && S_ISCHR(statbuf.st_mode))) {
-		close(next_loop_fd);
-		return NULL;
-	}
+	if (!(fstat(next_loop_fd, &statbuf) == 0 && S_ISCHR(statbuf.st_mode)))
+		goto nothing_found;
 
-	while (next_loop_dev == NULL) {
+	for (;;) {
 		next_loop = ioctl(next_loop_fd, LOOP_CTL_GET_FREE);
-		if (next_loop < 0) {
-			close(next_loop_fd);
-			return NULL;
-		}
+		if (next_loop < 0)
+			goto nothing_found;
+
 		sprintf(dev, "/dev/loop%d", next_loop);
 
-		fd = open (dev, O_RDONLY);
+		fd = open (dev, mode);
 		if (fd >= 0) {
 			if (fstat (fd, &statbuf) == 0 &&
 			    S_ISBLK(statbuf.st_mode)) {
 				somedev++;
 				if(ioctl (fd, LOOP_GET_STATUS, &loopinfo) == 0)
 					someloop++;		/* in use */
-				else if (errno == ENXIO)
-					next_loop_dev = xstrdup(dev);
+				else if (errno == ENXIO) {
+					char *name = strdup(dev);
+
+					if (name == NULL)
+						close(fd);
+					else
+						*loop_fd = fd;
+					close(next_loop_fd);
+					return name;
+				}
 
 			}
 			close (fd);
 
 			/* continue trying as long as devices exist */
-			continue;
-		}
-		break;
+		} else
+			break;
 	}
 
+nothing_found:
 	close(next_loop_fd);
 
-	if (next_loop_dev)
-		return next_loop_dev;
-
+no_loop_fd:
 	/* Nothing found. Why not? */
 	if ((procdev = fopen(PROC_DEVICES, "r")) != NULL) {
 		char line[100];
@@ -248,10 +233,10 @@ char *find_unused_loop_device(void)
 	return NULL;
 }
 
-int set_loop(const char *device, const char *file, int offset, int *loopro)
+int set_loop(char **device, const char *file, int offset, int *loopro)
 {
 	struct loop_info loopinfo;
-	int fd, ffd, mode;
+	int fd = -1, ret = 1, ffd, mode;
 
 	mode = (*loopro ? O_RDONLY : O_RDWR);
 
@@ -266,9 +251,9 @@ int set_loop(const char *device, const char *file, int offset, int *loopro)
 		}
 	}
 
-	if ((fd = open (device, mode)) < 0) {
+	*device = find_unused_loop_device(mode, &fd);
+	if (!*device) {
 		close(ffd);
-		perror (device);
 		return 1;
 	}
 
@@ -282,22 +267,20 @@ int set_loop(const char *device, const char *file, int offset, int *loopro)
 
 	if (ioctl(fd, LOOP_SET_FD, (void*)(uintptr_t)(ffd)) < 0) {
 		perror ("ioctl: LOOP_SET_FD");
-		close (fd);
-		close (ffd);
-		return 1;
+		goto out;
 	}
 
 	if (ioctl (fd, LOOP_SET_STATUS, &loopinfo) < 0) {
 		(void) ioctl (fd, LOOP_CLR_FD, 0);
 		perror ("ioctl: LOOP_SET_STATUS");
-		close (fd);
-		close (ffd);
-		return 1;
+		goto out;
 	}
+	ret = 0;
 
+out:
 	close (fd);
 	close (ffd);
-	return 0;
+	return ret;
 }
 
 int del_loop(const char *device)
diff --git a/kpartx/lopart.h b/kpartx/lopart.h
index d3bad10..c73ab23 100644
--- a/kpartx/lopart.h
+++ b/kpartx/lopart.h
@@ -1,5 +1,4 @@
 extern int verbose;
-extern int set_loop (const char *, const char *, int, int *);
+extern int set_loop (char **, const char *, int, int *);
 extern int del_loop (const char *);
-extern char * find_unused_loop_device (void);
 extern char * find_loop_by_file (const char *);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

