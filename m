Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA97A1BDC7
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HBrY3LM3"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 357251FE7C;
	Thu, 26 Oct 2023 17:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVUifE9GdreKsv0TSuTQRLKs6LiDzXMwh5uQb+OIcQQ=;
	b=HBrY3LM374Bq/FRx56hCej8CHoK+SxAbVLpSpv5b2bwfGqr7m4opr8DzxmYVgB5C5EAkEP
	utxAL0jT/FziXXH3A9wdSsJeVOaCANadoaB+g2789e8jPWnukFhAiJbMKy/dgxb1O+DhLT
	A+CcWwtcUBC/j8iedoTQRe1+D3VPcns=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8E3321358F;
	Thu, 26 Oct 2023 17:42:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id cFk1HwWlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:29 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/14] libmultipath: io_err_stat: fix error handling
Date: Thu, 26 Oct 2023 19:41:46 +0200
Message-ID: <20231026174153.1133-8-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026174153.1133-1-mwilck@suse.com>
References: <20231026174153.1133-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -6.10
X-Spamd-Result: default: False [-6.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

libaio uses a different error return convention than glibc. The error code is
not returned in errno, but as the negated return value of the function.
Adapt the error handling code in io_err_stat.c. Don't print an error message
for failure of io_cancel(), which always returns -EINPRPOGRESS.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/io_err_stat.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 5749003..1c59445 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -19,7 +19,6 @@
 #include <sys/ioctl.h>
 #include <linux/fs.h>
 #include <libaio.h>
-#include <errno.h>
 #include <sys/mman.h>
 #include <sys/select.h>
 
@@ -469,7 +468,7 @@ static void end_io_err_stat(struct io_err_stat_path *pp)
 
 static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
 {
-	int rc = -1;
+	int rc;
 
 	if (ct->io_starttime.tv_nsec == 0 &&
 			ct->io_starttime.tv_sec == 0) {
@@ -477,15 +476,15 @@ static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
 
 		get_monotonic_time(&ct->io_starttime);
 		io_prep_pread(&ct->io, fd, ct->buf, ct->blksize, 0);
-		if (io_submit(ioctx, 1, ios) != 1) {
-			io_err_stat_log(2, "%s: io_submit error %i",
-					dev, errno);
-			return rc;
+		if ((rc = io_submit(ioctx, 1, ios)) != 1) {
+			io_err_stat_log(2, "%s: io_submit error %s",
+					dev, strerror(-rc));
+			return -1;
 		}
-		rc = 0;
+		return 0;
 	}
 
-	return rc;
+	return -1;
 }
 
 static void send_batch_async_ios(struct io_err_stat_path *pp)
@@ -530,8 +529,8 @@ static int try_to_cancel_timeout_io(struct dio_ctx *ct, struct timespec *t,
 		io_err_stat_log(5, "%s: abort check on timeout", dev);
 		r = io_cancel(ioctx, ios[0], &event);
 		if (r)
-			io_err_stat_log(5, "%s: io_cancel error %i",
-					dev, errno);
+			io_err_stat_log(5, "%s: io_cancel error %s",
+					dev, strerror(-r));
 		rc = PATH_TIMEOUT;
 	} else {
 		rc = PATH_PENDING;
@@ -560,7 +559,7 @@ static void poll_async_io_timeout(void)
 static void cancel_inflight_io(struct io_err_stat_path *pp)
 {
 	struct io_event event;
-	int i, r;
+	int i;
 
 	for (i = 0; i < CONCUR_NR_EVENT; i++) {
 		struct dio_ctx *ct = pp->dio_ctx_array + i;
@@ -571,10 +570,7 @@ static void cancel_inflight_io(struct io_err_stat_path *pp)
 			continue;
 		io_err_stat_log(5, "%s: abort infligh io",
 				pp->devname);
-		r = io_cancel(ioctx, ios[0], &event);
-		if (r)
-			io_err_stat_log(5, "%s: io_cancel error %d, %i",
-					pp->devname, r, errno);
+		io_cancel(ioctx, ios[0], &event);
 	}
 }
 
@@ -610,12 +606,11 @@ static void process_async_ios_event(int timeout_nsecs, char *dev)
 	int		i, n;
 	struct timespec	timeout = { .tv_nsec = timeout_nsecs };
 
-	errno = 0;
 	pthread_testcancel();
 	n = io_getevents(ioctx, 1L, CONCUR_NR_EVENT, events, &timeout);
 	if (n < 0) {
-		io_err_stat_log(3, "%s: async io events returned %d (errno=%s)",
-				dev, n, strerror(errno));
+		io_err_stat_log(3, "%s: io_getevents returned %s",
+				dev, strerror(-n));
 	} else {
 		for (i = 0; i < n; i++)
 			handle_async_io_done_event(&events[i]);
@@ -704,8 +699,9 @@ int start_io_err_stat_thread(void *data)
 	if (uatomic_read(&io_err_thread_running) == 1)
 		return 0;
 
-	if (io_setup(CONCUR_NR_EVENT * NR_IOSTAT_PATHS, &ioctx) != 0) {
-		io_err_stat_log(1, "io_setup failed - increase /proc/sys/fs/aio-nr ?");
+	if ((ret = io_setup(NR_IOSTAT_PATHS * CONCUR_NR_EVENT, &ioctx)) != 0) {
+		io_err_stat_log(1, "io_setup failed: %s, increase /proc/sys/fs/aio-nr ?",
+				strerror(-ret));
 		return 1;
 	}
 
-- 
2.42.0

