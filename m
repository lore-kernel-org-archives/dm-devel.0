Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B0038FA1
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YYznBQSn"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE4A61FD97;
	Thu, 26 Oct 2023 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IuR3qOc2oYVX3UjWswkEGVz4xXETecNVZbfdzAqngH4=;
	b=YYznBQSnxENKN1IQSKiiumrj+fiAvIZdodrucLM3wTdI87XFOri6uvx3j759MxLr5kRRI0
	SrOOEM+2rKfJmKTc7HGOrUC/N/99BFf2+T6tqsoqRsZX8kfUhr5pz8KFCyMDvpyjq9+lOQ
	uHttqZDzoJhDAppndYsscn8euMgn9tg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5898B1358F;
	Thu, 26 Oct 2023 17:42:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id gAmCEgKlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:26 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 02/14] libmultipath: directio: don't reset ct->running after io_cancel()
Date: Thu, 26 Oct 2023 19:41:41 +0200
Message-ID: <20231026174153.1133-3-mwilck@suse.com>
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
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[5];
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

io_cancel() never succeeds, and even if it did, io_getevents() must
still be called to reclaim the IO resources from the kernel.
Don't pretend the opposite by resetting ct->running, or freeing the
memory, before io_getevents() has indicated that the request is finished.

In the test code, don't bother about the return value of __wrap_io_cancel().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers/directio.c | 14 ++++----------
 tests/directio.c                 | 27 ++-------------------------
 2 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 25b2383..83ab29f 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -232,15 +232,15 @@ void libcheck_free (struct checker * c)
 		}
 	}
 
-	if (ct->running &&
-	    (ct->req->state != PATH_PENDING ||
-	     io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event) == 0))
+	if (ct->running && ct->req->state != PATH_PENDING)
 		ct->running = 0;
 	if (!ct->running) {
 		free(ct->req->buf);
 		free(ct->req);
 		ct->aio_grp->holders--;
 	} else {
+		/* Currently a no-op */
+		io_cancel(ct->aio_grp->ioctx, &ct->req->io, &event);
 		ct->req->state = PATH_REMOVED;
 		list_add(&ct->req->node, &ct->aio_grp->orphans);
 		check_orphaned_group(ct->aio_grp);
@@ -351,13 +351,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 
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
index db9643e..5201d21 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -141,10 +141,9 @@ int __real_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt);
 int __wrap_io_cancel(io_context_t ctx, struct iocb *iocb, struct io_event *evt)
 {
 #ifdef DIO_TEST_DEV
-	mock_type(int);
 	return __real_io_cancel(ctx, iocb, evt);
 #else
-	return mock_type(int);
+	return 0;
 #endif
 }
 
@@ -439,14 +438,8 @@ static void test_check_state_timeout(void **state)
 	do_libcheck_init(&c, 4096, NULL);
 	aio_grp = get_aio_grp(&c);
 	return_io_getevents_none();
-	will_return(__wrap_io_cancel, 0);
 	do_check_state(&c, 1, 30, PATH_DOWN);
 	check_aio_grp(aio_grp, 1, 0);
-#ifdef DIO_TEST_DEV
-	/* io_cancel will return negative value on timeout, so it happens again
-	 * when freeing the checker */
-	will_return(__wrap_io_cancel, 0);
-#endif
 	libcheck_free(&c);
 	do_libcheck_reset(1);
 }
@@ -468,12 +461,8 @@ static void test_check_state_async_timeout(void **state)
 	return_io_getevents_none();
 	do_check_state(&c, 0, 3, PATH_PENDING);
 	return_io_getevents_none();
-	will_return(__wrap_io_cancel, 0);
 	do_check_state(&c, 0, 3, PATH_DOWN);
 	check_aio_grp(aio_grp, 1, 0);
-#ifdef DIO_TEST_DEV
-	will_return(__wrap_io_cancel, 0);
-#endif
 	libcheck_free(&c);
 	do_libcheck_reset(1);
 }
@@ -501,13 +490,8 @@ static void test_free_with_pending(void **state)
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
 
@@ -533,7 +517,6 @@ static void test_orphaned_aio_group(void **state)
 	assert_int_equal(i, 1);
 	for (i = 0; i < AIO_GROUP_SIZE; i++) {
 		assert_true(is_checker_running(&c[i]));
-		will_return(__wrap_io_cancel, -1);
 		if (i == AIO_GROUP_SIZE - 1) {
 			/* remove the orphaned group and create a new one */
 			will_return(__wrap_io_destroy, 0);
@@ -559,12 +542,10 @@ static void test_timeout_cancel_failed(void **state)
 		do_libcheck_init(&c[i], 4096, &reqs[i]);
 	aio_grp = get_aio_grp(c);
 	return_io_getevents_none();
-	will_return(__wrap_io_cancel, -1);
 	do_check_state(&c[0], 1, 30, PATH_DOWN);
 	assert_true(is_checker_running(&c[0]));
 	check_aio_grp(aio_grp, 2, 0);
 	return_io_getevents_none();
-	will_return(__wrap_io_cancel, -1);
 	do_check_state(&c[0], 1, 30, PATH_DOWN);
 	assert_true(is_checker_running(&c[0]));
 	return_io_getevents_nr(NULL, 1, &reqs[0], &res[0]);
@@ -600,7 +581,6 @@ static void test_async_timeout_cancel_failed(void **state)
 	return_io_getevents_none();
 	do_check_state(&c[1], 0, 2, PATH_PENDING);
 	return_io_getevents_none();
-	will_return(__wrap_io_cancel, -1);
 	do_check_state(&c[0], 0, 2, PATH_DOWN);
 #ifndef DIO_TEST_DEV
 	/* can't pick which even gets returned on real devices */
@@ -608,7 +588,6 @@ static void test_async_timeout_cancel_failed(void **state)
 	do_check_state(&c[1], 0, 2, PATH_UP);
 #endif
 	return_io_getevents_none();
-	will_return(__wrap_io_cancel, -1);
 	do_check_state(&c[0], 0, 2, PATH_DOWN);
 	assert_true(is_checker_running(&c[0]));
 	return_io_getevents_nr(NULL, 2, reqs, res);
@@ -637,7 +616,6 @@ static void test_orphan_checker_cleanup(void **state)
 	aio_grp = get_aio_grp(c);
 	return_io_getevents_none();
 	do_check_state(&c[0], 0, 30, PATH_PENDING);
-	will_return(__wrap_io_cancel, -1);
 	check_aio_grp(aio_grp, 2, 0);
 	libcheck_free(&c[0]);
 	check_aio_grp(aio_grp, 2, 1);
@@ -662,7 +640,6 @@ static void test_orphan_reset_cleanup(void **state)
 	orphan_aio_grp = get_aio_grp(&c);
 	return_io_getevents_none();
 	do_check_state(&c, 0, 30, PATH_PENDING);
-	will_return(__wrap_io_cancel, -1);
 	check_aio_grp(orphan_aio_grp, 1, 0);
 	libcheck_free(&c);
 	check_aio_grp(orphan_aio_grp, 1, 1);
-- 
2.42.0

