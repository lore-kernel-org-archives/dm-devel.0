Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9712B777
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 16:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SivUPDWx"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B431218E9;
	Tue, 24 Oct 2023 16:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698166187; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uX6XiWMoxrNL1oP6k1xsGfasm5/UKeVHbvAKjEsmkvs=;
	b=SivUPDWxeSob5aS6Efiu8T0ICY5/nUOiuWvwdD4kW1Vr8mV6/cQ3ZAprWQPYU/sy2Y0CUi
	S23Dfq7kJZ4Ne3Y4CJys6GaRUlxd8OQpUDDG7A8hZ+cGn7heUhLBZPIVV3JvHzRo5mO8ye
	oifBe55UPnJWdm9gsPdA2m9HBkQRFPo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ED212134F5;
	Tue, 24 Oct 2023 16:49:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id KAJrOKr1N2VadQAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 24 Oct 2023 16:49:46 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/6] libmultipath: directio: don't reset ct->running after io_cancel()
Date: Tue, 24 Oct 2023 18:49:33 +0200
Message-ID: <20231024164937.14684-3-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024164937.14684-1-mwilck@suse.com>
References: <20231024164937.14684-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.10
X-Spamd-Result: default: False [-3.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[6];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[22.92%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

io_cancel() never succeeds, and even if it did, io_getevents() must
still be called to reclaim the IO resources from the kernel.
Don't pretend the opposite by resetting ct->running, or freeing the
memory, before io_getevents() has indicated that the request is finished.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/directio.c | 13 ++-----------
 tests/directio.c                 | 10 +---------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 25b2383..71ce4cb 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -216,7 +216,6 @@ out:
 void libcheck_free (struct checker * c)
 {
 	struct directio_context * ct = (struct directio_context *)c->context;
-	struct io_event event;
 	long flags;
 
 	if (!ct)
@@ -232,9 +231,7 @@ void libcheck_free (struct checker * c)
 		}
 	}
 
-	if (ct->running &&
-	    (ct->req->state != PATH_PENDING ||
-	     io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event) == 0))
+	if (ct->running && ct->req->state != PATH_PENDING)
 		ct->running = 0;
 	if (!ct->running) {
 		free(ct->req->buf);
@@ -351,13 +348,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 
 		LOG(3, "abort check on timeout");
 
-		r = io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
-		/*
-		 * Only reset ct->running if we really
-		 * could abort the pending I/O
-		 */
-		if (!r)
-			ct->running = 0;
+		io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
 		rc = PATH_DOWN;
 	} else {
 		LOG(4, "async io pending");
diff --git a/tests/directio.c b/tests/directio.c
index db9643e..b340498 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -501,13 +501,8 @@ static void test_free_with_pending(void **state)
 	check_aio_grp(aio_grp, 2, 0);
         libcheck_free(&c[0]);
 	check_aio_grp(aio_grp, 1, 0);
-        will_return(__wrap_io_cancel, 0);
         libcheck_free(&c[1]);
-#ifdef DIO_TEST_DEV
-	check_aio_grp(aio_grp, 1, 1); /* real cancel doesn't remove request */
-#else
-        check_aio_grp(aio_grp, 0, 0);
-#endif
+	check_aio_grp(aio_grp, 1, 1); /* cancel doesn't remove request */
         do_libcheck_reset(1);
 }
 
@@ -533,7 +528,6 @@ static void test_orphaned_aio_group(void **state)
 	assert_int_equal(i, 1);
 	for (i = 0; i < AIO_GROUP_SIZE; i++) {
 		assert_true(is_checker_running(&c[i]));
-		will_return(__wrap_io_cancel, -1);
 		if (i == AIO_GROUP_SIZE - 1) {
 			/* remove the orphaned group and create a new one */
 			will_return(__wrap_io_destroy, 0);
@@ -637,7 +631,6 @@ static void test_orphan_checker_cleanup(void **state)
 	aio_grp = get_aio_grp(c);
 	return_io_getevents_none();
 	do_check_state(&c[0], 0, 30, PATH_PENDING);
-	will_return(__wrap_io_cancel, -1);
 	check_aio_grp(aio_grp, 2, 0);
 	libcheck_free(&c[0]);
 	check_aio_grp(aio_grp, 2, 1);
@@ -662,7 +655,6 @@ static void test_orphan_reset_cleanup(void **state)
 	orphan_aio_grp = get_aio_grp(&c);
 	return_io_getevents_none();
 	do_check_state(&c, 0, 30, PATH_PENDING);
-	will_return(__wrap_io_cancel, -1);
 	check_aio_grp(orphan_aio_grp, 1, 0);
 	libcheck_free(&c);
 	check_aio_grp(orphan_aio_grp, 1, 1);
-- 
2.42.0

