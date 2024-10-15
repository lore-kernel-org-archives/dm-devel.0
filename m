Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5C1714B5
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962927; cv=none; b=eEEXY4STW8w7TpAdNlbCDhLZEisUB5RUkBaaIKLGuK293BSH2R/+Zzn0GY+rwVl0I8BgHd4zH5zZ5ETF7ZT/L7yyDvCjL8AsCS+22erk4gvpMohddEwfrjiDLRwy/XxwKg2yaipBCxBX/C731QKZHlIgcm+6h3NtnQvEmWNyo20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962927; c=relaxed/simple;
	bh=ag4LoPZGTQKSadSxgqREFDqvcz5GzuEwdtaJacB+dKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sRbp9dsR8xDO0lKjMesJUH3UKIFFK3rs0QsjAWDp8niFB4+fhz2wPmTbElkDoFf3Uuxdl7dA3XGig7ujiPxngDZ/uUTiNSUUNHtvPC7qTDb46R1ogT3cRmquGL10cUm0Igzpyy6aHBBXlYvBmV6j8q7PEbNRvbp7UwyZecmL+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qb/mp8GW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qb/mp8GW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3MeuiXHpoDkGrIha11WWIwSL5siHJTfu9lyMXGZ7iA=;
	b=Qb/mp8GW3TFHw7LUTfv8VqIfUdnIP22+nMu6YtNRrSUhx0euJpelalULOaWvsbplzexZR8
	Ktto7eJEMrgBkuktILqFBoG/TXdAP5IVuKDzgTNfmsdBjxt+pB5thvsVK9GF/PEAIKflRL
	eLAXnrT/j/iASHcXoDLKL4EcH38Uc4s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441--bIZUFyTMtm9175i4ZpSrw-1; Mon,
 14 Oct 2024 23:28:39 -0400
X-MC-Unique: -bIZUFyTMtm9175i4ZpSrw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFBC21956089;
	Tue, 15 Oct 2024 03:28:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A27E919560AE;
	Tue, 15 Oct 2024 03:28:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3SaDU2693299
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3SaoL2693298;
	Mon, 14 Oct 2024 23:28:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 05/23] multipath-tools tests: fix up directio tests
Date: Mon, 14 Oct 2024 23:28:17 -0400
Message-ID: <20241015032835.2693247-6-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Make the directio tests work with libcheck_pending() being separate from
libcheck_check

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/directio.c | 133 +++++++++++++++++++++++++++++------------------
 1 file changed, 82 insertions(+), 51 deletions(-)

diff --git a/tests/directio.c b/tests/directio.c
index 763929e5..2e22f831 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -219,13 +219,22 @@ static void return_io_getevents_nr(struct timespec *ts, int nr,
 	ev_off += i;
 }
 
-void do_check_state(struct checker *c, int sync, int timeout, int chk_state)
+void do_check_state(struct checker *c, int sync, int chk_state)
 {
 	struct directio_context * ct = (struct directio_context *)c->context;
 
 	if (!ct->running)
 		will_return(__wrap_io_submit, 1);
-	assert_int_equal(check_state(test_fd, ct, sync, timeout), chk_state);
+	assert_int_equal(check_state(test_fd, ct, sync, c->timeout), chk_state);
+	if (sync) {
+		assert_int_equal(ev_off, 0);
+		memset(mock_events, 0, sizeof(mock_events));
+	}
+}
+
+void do_libcheck_pending(struct checker *c, int chk_state)
+{
+	assert_int_equal(libcheck_pending(c), chk_state);
 	assert_int_equal(ev_off, 0);
 	memset(mock_events, 0, sizeof(mock_events));
 }
@@ -245,12 +254,13 @@ void do_libcheck_reset(int nr_aio_grps)
 	assert_int_equal(ioctx_count, 0);
 }
 
-static void do_libcheck_init(struct checker *c, int blocksize,
+static void do_libcheck_init(struct checker *c, int blocksize, int timeout,
 			     struct async_req **req)
 {
 	struct directio_context * ct;
 
 	c->fd = test_fd;
+	c->timeout = timeout;
 	wrap_will_return(WRAP_IOCTL, blocksize);
 	assert_int_equal(libcheck_init(c), 0);
 	ct = (struct directio_context *)c->context;
@@ -305,7 +315,7 @@ static void test_init_reset_init(void **state)
 
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
-	do_libcheck_init(&c, 4096, NULL);
+	do_libcheck_init(&c, 4096, 0, NULL);
 	aio_grp = get_aio_grp(&c);
 	check_aio_grp(aio_grp, 1, 0);
 	list_for_each_entry(tmp_grp, &aio_grp_list, node)
@@ -314,7 +324,7 @@ static void test_init_reset_init(void **state)
 	check_aio_grp(aio_grp, 0, 0);
 	do_libcheck_reset(1);
 	will_return(__wrap_io_setup, 0);
-	do_libcheck_init(&c, 4096, NULL);
+	do_libcheck_init(&c, 4096, 0, NULL);
 	aio_grp = get_aio_grp(&c);
 	check_aio_grp(aio_grp, 1, 0);
 	list_for_each_entry(tmp_grp, &aio_grp_list, node)
@@ -340,11 +350,11 @@ static void test_init_free(void **state)
 		struct directio_context * ct;
 
 		if (i % 3 == 0)
-			do_libcheck_init(&c[i], 512, NULL);
+			do_libcheck_init(&c[i], 512, 0, NULL);
 		else if (i % 3 == 1)
-			do_libcheck_init(&c[i], 1024, NULL);
+			do_libcheck_init(&c[i], 1024, 0, NULL);
 		else
-			do_libcheck_init(&c[i], 4096, NULL);
+			do_libcheck_init(&c[i], 4096, 0, NULL);
 		ct = (struct directio_context *)c[i].context;
 		assert_non_null(ct->aio_grp);
 		if ((i & 1023) == 0)
@@ -385,7 +395,7 @@ static void test_multi_init_free(void **state)
 	for (count = 0, i = 0; i < 4096; count++) {
 		/* usually init, but occasionally free checkers */
 		if (count == 0 || (count % 5 != 0 && count % 7 != 0)) {
-			do_libcheck_init(&c[i], 4096, NULL);
+			do_libcheck_init(&c[i], 4096, 0, NULL);
 			i++;
 		} else {
 			i--;
@@ -404,7 +414,7 @@ static void test_multi_init_free(void **state)
 			i--;
 			libcheck_free(&c[i]);
 		} else {
-			do_libcheck_init(&c[i], 4096, NULL);
+			do_libcheck_init(&c[i], 4096, 0, NULL);
 			i++;
 		}
 	}
@@ -420,9 +430,9 @@ static void test_check_state_simple(void **state)
 
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
-	do_libcheck_init(&c, 4096, &req);
+	do_libcheck_init(&c, 4096, 30, &req);
 	return_io_getevents_nr(NULL, 1, &req, &res);
-	do_check_state(&c, 1, 30, PATH_UP);
+	do_check_state(&c, 1, PATH_UP);
 	libcheck_free(&c);
 	do_libcheck_reset(1);
 }
@@ -435,10 +445,10 @@ static void test_check_state_timeout(void **state)
 
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
-	do_libcheck_init(&c, 4096, NULL);
+	do_libcheck_init(&c, 4096, 30, NULL);
 	aio_grp = get_aio_grp(&c);
 	return_io_getevents_none();
-	do_check_state(&c, 1, 30, PATH_DOWN);
+	do_check_state(&c, 1, PATH_DOWN);
 	check_aio_grp(aio_grp, 1, 0);
 	libcheck_free(&c);
 	do_libcheck_reset(1);
@@ -452,16 +462,20 @@ static void test_check_state_async_timeout(void **state)
 
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
-	do_libcheck_init(&c, 4096, NULL);
+	do_libcheck_init(&c, 4096, 3, NULL);
 	aio_grp = get_aio_grp(&c);
+	do_check_state(&c, 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c, 0, 3, PATH_PENDING);
+	do_libcheck_pending(&c, PATH_PENDING);
+	do_check_state(&c, 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c, 0, 3, PATH_PENDING);
+	do_libcheck_pending(&c, PATH_PENDING);
+	do_check_state(&c, 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c, 0, 3, PATH_PENDING);
+	do_libcheck_pending(&c, PATH_PENDING);
+	do_check_state(&c, 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c, 0, 3, PATH_DOWN);
+	do_libcheck_pending(&c, PATH_DOWN);
 	check_aio_grp(aio_grp, 1, 0);
 	libcheck_free(&c);
 	do_libcheck_reset(1);
@@ -477,14 +491,16 @@ static void test_free_with_pending(void **state)
 
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
-        do_libcheck_init(&c[0], 4096, &req);
-	do_libcheck_init(&c[1], 4096, NULL);
+        do_libcheck_init(&c[0], 4096, 30, &req);
+	do_libcheck_init(&c[1], 4096, 30, NULL);
         aio_grp = get_aio_grp(c);
+        do_check_state(&c[0], 0, PATH_PENDING);
+	do_check_state(&c[1], 0, PATH_PENDING);
         return_io_getevents_none();
-        do_check_state(&c[0], 0, 30, PATH_PENDING);
+	do_libcheck_pending(&c[0], PATH_PENDING);
 	return_io_getevents_nr(NULL, 1, &req, &res);
 	return_io_getevents_none();
-	do_check_state(&c[1], 0, 30, PATH_PENDING);
+	do_libcheck_pending(&c[1], PATH_PENDING);
 	assert_true(is_checker_running(&c[0]));
 	assert_true(is_checker_running(&c[1]));
 	check_aio_grp(aio_grp, 2, 0);
@@ -505,9 +521,10 @@ static void test_orphaned_aio_group(void **state)
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
 	for (i = 0; i < AIO_GROUP_SIZE; i++) {
-		do_libcheck_init(&c[i], 4096, NULL);
+		do_libcheck_init(&c[i], 4096, 30, NULL);
+		do_check_state(&c[i], 0, PATH_PENDING);
 		return_io_getevents_none();
-		do_check_state(&c[i], 0, 30, PATH_PENDING);
+		do_libcheck_pending(&c[i], PATH_PENDING);
 	}
 	aio_grp = get_aio_grp(c);
 	check_aio_grp(aio_grp, AIO_GROUP_SIZE, 0);
@@ -539,19 +556,19 @@ static void test_timeout_cancel_failed(void **state)
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
 	for (i = 0; i < 2; i++)
-		do_libcheck_init(&c[i], 4096, &reqs[i]);
+		do_libcheck_init(&c[i], 4096, 30, &reqs[i]);
 	aio_grp = get_aio_grp(c);
 	return_io_getevents_none();
-	do_check_state(&c[0], 1, 30, PATH_DOWN);
+	do_check_state(&c[0], 1, PATH_DOWN);
 	assert_true(is_checker_running(&c[0]));
 	check_aio_grp(aio_grp, 2, 0);
 	return_io_getevents_none();
-	do_check_state(&c[0], 1, 30, PATH_DOWN);
+	do_check_state(&c[0], 1, PATH_DOWN);
 	assert_true(is_checker_running(&c[0]));
 	return_io_getevents_nr(NULL, 1, &reqs[0], &res[0]);
 	return_io_getevents_nr(NULL, 1, &reqs[1], &res[1]);
-	do_check_state(&c[1], 1, 30, PATH_UP);
-	do_check_state(&c[0], 1, 30, PATH_UP);
+	do_check_state(&c[1], 1, PATH_UP);
+	do_check_state(&c[0], 1, PATH_UP);
 	for (i = 0; i < 2; i++) {
 		assert_false(is_checker_running(&c[i]));
 		libcheck_free(&c[i]);
@@ -571,28 +588,37 @@ static void test_async_timeout_cancel_failed(void **state)
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
 	for (i = 0; i < 2; i++)
-		do_libcheck_init(&c[i], 4096, &reqs[i]);
+		do_libcheck_init(&c[i], 4096, 2, &reqs[i]);
+	do_check_state(&c[0], 0, PATH_PENDING);
+	do_check_state(&c[1], 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c[0], 0, 2, PATH_PENDING);
+	do_libcheck_pending(&c[0], PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c[1], 0, 2, PATH_PENDING);
+	do_libcheck_pending(&c[1], PATH_PENDING);
+	do_check_state(&c[0], 0, PATH_PENDING);
+	do_check_state(&c[1], 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c[0], 0, 2, PATH_PENDING);
+	do_libcheck_pending(&c[0], PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c[1], 0, 2, PATH_PENDING);
+	do_libcheck_pending(&c[1], PATH_PENDING);
+	do_check_state(&c[0], 0, PATH_PENDING);
+	do_check_state(&c[1], 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c[0], 0, 2, PATH_DOWN);
+	do_libcheck_pending(&c[0], PATH_DOWN);
 	if (!test_dev) {
 		/* can't pick which even gets returned on real devices */
 		return_io_getevents_nr(NULL, 1, &reqs[1], &res[1]);
-		do_check_state(&c[1], 0, 2, PATH_UP);
+		do_libcheck_pending(&c[1], PATH_UP);
 	}
+	do_check_state(&c[0], 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c[0], 0, 2, PATH_DOWN);
+	do_libcheck_pending(&c[0], PATH_DOWN);
 	assert_true(is_checker_running(&c[0]));
+	do_check_state(&c[1], 0, PATH_PENDING);
+	do_check_state(&c[0], 0, PATH_PENDING);
 	return_io_getevents_nr(NULL, 2, reqs, res);
-	do_check_state(&c[1], 0, 2, PATH_UP);
-	do_check_state(&c[0], 0, 2, PATH_UP);
+	do_libcheck_pending(&c[1], PATH_UP);
+	do_libcheck_pending(&c[0], PATH_UP);
 	for (i = 0; i < 2; i++) {
 		assert_false(is_checker_running(&c[i]));
 		libcheck_free(&c[i]);
@@ -612,15 +638,17 @@ static void test_orphan_checker_cleanup(void **state)
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
 	for (i = 0; i < 2; i++)
-		do_libcheck_init(&c[i], 4096, &reqs[i]);
+		do_libcheck_init(&c[i], 4096, 30, &reqs[i]);
 	aio_grp = get_aio_grp(c);
+	do_check_state(&c[0], 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c[0], 0, 30, PATH_PENDING);
+	do_libcheck_pending(&c[0], PATH_PENDING);
 	check_aio_grp(aio_grp, 2, 0);
 	libcheck_free(&c[0]);
 	check_aio_grp(aio_grp, 2, 1);
+	do_check_state(&c[1], 0, PATH_PENDING);
 	return_io_getevents_nr(NULL, 2, reqs, res);
-	do_check_state(&c[1], 0, 2, PATH_UP);
+	do_libcheck_pending(&c[1], PATH_UP);
 	check_aio_grp(aio_grp, 1, 0);
 	libcheck_free(&c[1]);
 	check_aio_grp(aio_grp, 0, 0);
@@ -636,10 +664,11 @@ static void test_orphan_reset_cleanup(void **state)
 
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
-	do_libcheck_init(&c, 4096, NULL);
+	do_libcheck_init(&c, 4096, 30, NULL);
 	orphan_aio_grp = get_aio_grp(&c);
+	do_check_state(&c, 0, PATH_PENDING);
 	return_io_getevents_none();
-	do_check_state(&c, 0, 30, PATH_PENDING);
+	do_libcheck_pending(&c, PATH_PENDING);
 	check_aio_grp(orphan_aio_grp, 1, 0);
 	libcheck_free(&c);
 	check_aio_grp(orphan_aio_grp, 1, 1);
@@ -671,10 +700,10 @@ static void test_check_state_blksize(void **state)
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
 	for (i = 0; i < 3; i++)
-		do_libcheck_init(&c[i], blksize[i], &reqs[i]);
+		do_libcheck_init(&c[i], blksize[i], 30, &reqs[i]);
 	for (i = 0; i < 3; i++) {
 		return_io_getevents_nr(NULL, 1, &reqs[i], &res[i]);
-		do_check_state(&c[i], 1, 30, chk_state[i]);
+		do_check_state(&c[i], 1, chk_state[i]);
 	}
 	for (i = 0; i < 3; i++) {
 		assert_false(is_checker_running(&c[i]));
@@ -695,19 +724,21 @@ static void test_check_state_async(void **state)
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
 	for (i = 0; i < 257; i++)
-		do_libcheck_init(&c[i], 4096, &reqs[i]);
+		do_libcheck_init(&c[i], 4096, 30, &reqs[i]);
 	for (i = 0; i < 256; i++) {
+		do_check_state(&c[i], 0, PATH_PENDING);
 		return_io_getevents_none();
-		do_check_state(&c[i], 0, 30, PATH_PENDING);
+		do_libcheck_pending(&c[i], PATH_PENDING);
 		assert_true(is_checker_running(&c[i]));
 	}
+	do_check_state(&c[256], 0, PATH_PENDING);
 	return_io_getevents_nr(&full_timeout, 256, reqs, res);
 	return_io_getevents_nr(NULL, 1, &reqs[256], &res[256]);
-	do_check_state(&c[256], 0, 30, PATH_UP);
+	do_libcheck_pending(&c[256], PATH_UP);
 	assert_false(is_checker_running(&c[256]));
 	libcheck_free(&c[256]);
 	for (i = 0; i < 256; i++) {
-		do_check_state(&c[i], 0, 30, PATH_UP);
+		do_check_state(&c[i], 0, PATH_UP);
 		assert_false(is_checker_running(&c[i]));
 		libcheck_free(&c[i]);
 	}
-- 
2.45.0

