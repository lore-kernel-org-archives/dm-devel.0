Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315A939FD9
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 01:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728436536; cv=none; b=rBucLUFqFzxKsorwAEJ1MxvcclNRVaDHGq4aiuwr4WlEV1DQAdIW1mymcYwGpGWLVrS/NbR9F/xOPotR8dn/Z6+syEKphbZ6ARRyf4HfurXzSxzoYbrxvtfYQJt/I5DggsQxaqvZdCacqCg+z+PppSPNn5dcwZsDqXC5q6v+X/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728436536; c=relaxed/simple;
	bh=BzJngYBcYcGRH3T9avRonYEJrI9SngwMl5W5X84CrKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UoXcEn2JKkBbJrPpt4KF5T0Cn3MUrT+KY1YldQYJ2Yuwmppa3AoiSX61B74AxD5qN3QViBMG3Xwq1Z4tLv37bEE7G7Vi7Tah0OjZrJ0qZJJhMsDxSXz/KG1e4U9Wxojf5oJM3GmExz2wxBSY9JmzZLMBagMYXIR4aVPTPubF7kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OB45vMSu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OB45vMSu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728436533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQDEPPXMo3/Bb2SHhlH4+sI+igtzxVWyAt9dqVb547s=;
	b=OB45vMSuJvu9v6jOuq5TSY5n2F9dwDH/eYDhUjGe9woJwi6vkPP2qwBnWCmXMX9RsrSrWB
	PKn384jAnp+YCIoTCOBjNe+zFd9vFfzXZs3OUqTtzSB/PQGjX8wSeFaOvZ8n1meesbYlgK
	RXv9Qr9uGWaVRf0mliCBLsVroOKRgPc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-No6PzEhGPBCttxT_RhI9pA-1; Tue,
 08 Oct 2024 21:15:30 -0400
X-MC-Unique: No6PzEhGPBCttxT_RhI9pA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0CBA319560AF;
	Wed,  9 Oct 2024 01:15:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD7EC19560AA;
	Wed,  9 Oct 2024 01:15:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4991FRAp2381696
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Oct 2024 21:15:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4991FRQD2381695;
	Tue, 8 Oct 2024 21:15:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 22/22] multipath-tools tests: fix up directio tests
Date: Tue,  8 Oct 2024 21:15:23 -0400
Message-ID: <20241009011523.2381575-23-bmarzins@redhat.com>
In-Reply-To: <20241009011523.2381575-1-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
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

Make the directio tests work with no waiting in the libcheck_pending()
and the new libcheck_need_wait() call.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 tests/directio.c | 49 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/tests/directio.c b/tests/directio.c
index 2e22f831..5ee482a8 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -313,23 +313,28 @@ static void test_init_reset_init(void **state)
 	struct checker c = {.cls = NULL};
 	struct aio_group *aio_grp, *tmp_grp;
 
+	assert_int_equal(libcheck_need_wait(&c), false);
 	assert_true(list_empty(&aio_grp_list));
 	will_return(__wrap_io_setup, 0);
 	do_libcheck_init(&c, 4096, 0, NULL);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	aio_grp = get_aio_grp(&c);
 	check_aio_grp(aio_grp, 1, 0);
 	list_for_each_entry(tmp_grp, &aio_grp_list, node)
 		assert_ptr_equal(aio_grp, tmp_grp);
 	libcheck_free(&c);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	check_aio_grp(aio_grp, 0, 0);
 	do_libcheck_reset(1);
 	will_return(__wrap_io_setup, 0);
 	do_libcheck_init(&c, 4096, 0, NULL);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	aio_grp = get_aio_grp(&c);
 	check_aio_grp(aio_grp, 1, 0);
 	list_for_each_entry(tmp_grp, &aio_grp_list, node)
 		assert_ptr_equal(aio_grp, tmp_grp);
 	libcheck_free(&c);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	check_aio_grp(aio_grp, 0, 0);
 	do_libcheck_reset(1);
 }
@@ -433,6 +438,7 @@ static void test_check_state_simple(void **state)
 	do_libcheck_init(&c, 4096, 30, &req);
 	return_io_getevents_nr(NULL, 1, &req, &res);
 	do_check_state(&c, 1, PATH_UP);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	libcheck_free(&c);
 	do_libcheck_reset(1);
 }
@@ -465,17 +471,25 @@ static void test_check_state_async_timeout(void **state)
 	do_libcheck_init(&c, 4096, 3, NULL);
 	aio_grp = get_aio_grp(&c);
 	do_check_state(&c, 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), true);
 	return_io_getevents_none();
 	do_libcheck_pending(&c, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	do_check_state(&c, 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	return_io_getevents_none();
 	do_libcheck_pending(&c, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	do_check_state(&c, 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	return_io_getevents_none();
 	do_libcheck_pending(&c, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	do_check_state(&c, 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	return_io_getevents_none();
 	do_libcheck_pending(&c, PATH_DOWN);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	check_aio_grp(aio_grp, 1, 0);
 	libcheck_free(&c);
 	do_libcheck_reset(1);
@@ -496,11 +510,16 @@ static void test_free_with_pending(void **state)
         aio_grp = get_aio_grp(c);
         do_check_state(&c[0], 0, PATH_PENDING);
 	do_check_state(&c[1], 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[0]), true);
+	assert_int_equal(libcheck_need_wait(&c[1]), true);
         return_io_getevents_none();
 	do_libcheck_pending(&c[0], PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
+	assert_int_equal(libcheck_need_wait(&c[1]), true);
 	return_io_getevents_nr(NULL, 1, &req, &res);
-	return_io_getevents_none();
 	do_libcheck_pending(&c[1], PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
+	assert_int_equal(libcheck_need_wait(&c[1]), false);
 	assert_true(is_checker_running(&c[0]));
 	assert_true(is_checker_running(&c[1]));
 	check_aio_grp(aio_grp, 2, 0);
@@ -523,8 +542,10 @@ static void test_orphaned_aio_group(void **state)
 	for (i = 0; i < AIO_GROUP_SIZE; i++) {
 		do_libcheck_init(&c[i], 4096, 30, NULL);
 		do_check_state(&c[i], 0, PATH_PENDING);
+		assert_int_equal(libcheck_need_wait(&c[i]), true);
 		return_io_getevents_none();
 		do_libcheck_pending(&c[i], PATH_PENDING);
+		assert_int_equal(libcheck_need_wait(&c[i]), false);
 	}
 	aio_grp = get_aio_grp(c);
 	check_aio_grp(aio_grp, AIO_GROUP_SIZE, 0);
@@ -560,15 +581,19 @@ static void test_timeout_cancel_failed(void **state)
 	aio_grp = get_aio_grp(c);
 	return_io_getevents_none();
 	do_check_state(&c[0], 1, PATH_DOWN);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
 	assert_true(is_checker_running(&c[0]));
 	check_aio_grp(aio_grp, 2, 0);
 	return_io_getevents_none();
 	do_check_state(&c[0], 1, PATH_DOWN);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
 	assert_true(is_checker_running(&c[0]));
 	return_io_getevents_nr(NULL, 1, &reqs[0], &res[0]);
 	return_io_getevents_nr(NULL, 1, &reqs[1], &res[1]);
 	do_check_state(&c[1], 1, PATH_UP);
+	assert_int_equal(libcheck_need_wait(&c[1]), false);
 	do_check_state(&c[0], 1, PATH_UP);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
 	for (i = 0; i < 2; i++) {
 		assert_false(is_checker_running(&c[i]));
 		libcheck_free(&c[i]);
@@ -590,11 +615,15 @@ static void test_async_timeout_cancel_failed(void **state)
 	for (i = 0; i < 2; i++)
 		do_libcheck_init(&c[i], 4096, 2, &reqs[i]);
 	do_check_state(&c[0], 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[0]), true);
 	do_check_state(&c[1], 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[1]), true);
 	return_io_getevents_none();
 	do_libcheck_pending(&c[0], PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
 	return_io_getevents_none();
 	do_libcheck_pending(&c[1], PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[1]), false);
 	do_check_state(&c[0], 0, PATH_PENDING);
 	do_check_state(&c[1], 0, PATH_PENDING);
 	return_io_getevents_none();
@@ -605,10 +634,12 @@ static void test_async_timeout_cancel_failed(void **state)
 	do_check_state(&c[1], 0, PATH_PENDING);
 	return_io_getevents_none();
 	do_libcheck_pending(&c[0], PATH_DOWN);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
 	if (!test_dev) {
 		/* can't pick which even gets returned on real devices */
 		return_io_getevents_nr(NULL, 1, &reqs[1], &res[1]);
 		do_libcheck_pending(&c[1], PATH_UP);
+		assert_int_equal(libcheck_need_wait(&c[1]), false);
 	}
 	do_check_state(&c[0], 0, PATH_PENDING);
 	return_io_getevents_none();
@@ -641,14 +672,19 @@ static void test_orphan_checker_cleanup(void **state)
 		do_libcheck_init(&c[i], 4096, 30, &reqs[i]);
 	aio_grp = get_aio_grp(c);
 	do_check_state(&c[0], 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[0]), true);
 	return_io_getevents_none();
 	do_libcheck_pending(&c[0], PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
 	check_aio_grp(aio_grp, 2, 0);
 	libcheck_free(&c[0]);
+	assert_int_equal(libcheck_need_wait(&c[0]), false);
 	check_aio_grp(aio_grp, 2, 1);
 	do_check_state(&c[1], 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c[1]), true);
 	return_io_getevents_nr(NULL, 2, reqs, res);
 	do_libcheck_pending(&c[1], PATH_UP);
+	assert_int_equal(libcheck_need_wait(&c[1]), false);
 	check_aio_grp(aio_grp, 1, 0);
 	libcheck_free(&c[1]);
 	check_aio_grp(aio_grp, 0, 0);
@@ -667,8 +703,10 @@ static void test_orphan_reset_cleanup(void **state)
 	do_libcheck_init(&c, 4096, 30, NULL);
 	orphan_aio_grp = get_aio_grp(&c);
 	do_check_state(&c, 0, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), true);
 	return_io_getevents_none();
 	do_libcheck_pending(&c, PATH_PENDING);
+	assert_int_equal(libcheck_need_wait(&c), false);
 	check_aio_grp(orphan_aio_grp, 1, 0);
 	libcheck_free(&c);
 	check_aio_grp(orphan_aio_grp, 1, 1);
@@ -704,6 +742,7 @@ static void test_check_state_blksize(void **state)
 	for (i = 0; i < 3; i++) {
 		return_io_getevents_nr(NULL, 1, &reqs[i], &res[i]);
 		do_check_state(&c[i], 1, chk_state[i]);
+		assert_int_equal(libcheck_need_wait(&c[i]), false);
 	}
 	for (i = 0; i < 3; i++) {
 		assert_false(is_checker_running(&c[i]));
@@ -727,18 +766,22 @@ static void test_check_state_async(void **state)
 		do_libcheck_init(&c[i], 4096, 30, &reqs[i]);
 	for (i = 0; i < 256; i++) {
 		do_check_state(&c[i], 0, PATH_PENDING);
+		assert_int_equal(libcheck_need_wait(&c[i]), true);
 		return_io_getevents_none();
 		do_libcheck_pending(&c[i], PATH_PENDING);
+		assert_int_equal(libcheck_need_wait(&c[i]), false);
 		assert_true(is_checker_running(&c[i]));
 	}
 	do_check_state(&c[256], 0, PATH_PENDING);
-	return_io_getevents_nr(&full_timeout, 256, reqs, res);
-	return_io_getevents_nr(NULL, 1, &reqs[256], &res[256]);
+		assert_int_equal(libcheck_need_wait(&c[256]), true);
+	return_io_getevents_nr(&full_timeout, 257, reqs, res);
 	do_libcheck_pending(&c[256], PATH_UP);
+		assert_int_equal(libcheck_need_wait(&c[256]), false);
 	assert_false(is_checker_running(&c[256]));
 	libcheck_free(&c[256]);
 	for (i = 0; i < 256; i++) {
 		do_check_state(&c[i], 0, PATH_UP);
+		assert_int_equal(libcheck_need_wait(&c[i]), false);
 		assert_false(is_checker_running(&c[i]));
 		libcheck_free(&c[i]);
 	}
-- 
2.45.0

