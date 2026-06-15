Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F156638AC99
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781550439; cv=none; b=gwCr03q7ZcpKLPUND99My221/u9+N9A06ayaJ0dbIB0DXPtiTX+tBXkoF2urNCpuC1/kd/uSQ3knbFuWnudawYhBWapZr0BKwwrQaMQyrDXPdoDftsnEmcKBHVEJ0mDE69TEqRkChXz2wIZWKjs7uKstYH/n/w5o4gAnDNR4QyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781550439; c=relaxed/simple;
	bh=vagMby69ADGqRdyCFcnUgjY+eUhIb1lSjqiIReSLDrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Wu9n425IuvG+vxIkTzpFJU5e41V1Ucw+1FKHhopNwDQll0WtGmUZtkJIcCMa9Qas9vP+ngZ8gkXaKAxFm6fh9lKhMGW7F6OiU5Yt58xXNlHwxxV8O3U14LQZ7vmDNnY8jH9Vp2ItDjMgRhVHjZvMoPNo+fgppHS8gWv+ist5OUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eeVnKg2i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eeVnKg2i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781550437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eubBclLQz2/wK3ElD+QehXTm1kDNzmBE0XXivvI7t5E=;
	b=eeVnKg2ikiFycdXqTwHqXaHhRTCjvzPeWlAiE/MXtVXAC6hFZ/9vGoLryKkJF0Qq6lQbFC
	dbH6Po0Bs76C20uzrkYfbiwFbJG1XGZ4vwEvMK6b82OnPaM0OGnmhCEX2rJPSoLoTN2su4
	KiA7HK5uvKbNfCI147NBZzh6vvxHpp8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-yvyRDIh6MjSLSO75c6Uoyw-1; Mon,
 15 Jun 2026 15:07:15 -0400
X-MC-Unique: yvyRDIh6MjSLSO75c6Uoyw-1
X-Mimecast-MFC-AGG-ID: yvyRDIh6MjSLSO75c6Uoyw_1781550433
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08CA619540DD;
	Mon, 15 Jun 2026 19:07:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB239180066F;
	Mon, 15 Jun 2026 19:07:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FJ7BOT797594
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 15:07:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FJ7Bg4797593;
	Mon, 15 Jun 2026 15:07:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 2/4] libmultipath: deprecate rr_min_io_rq, and make it do nothing
Date: Mon, 15 Jun 2026 15:07:09 -0400
Message-ID: <20260615190711.797573-3-bmarzins@redhat.com>
In-Reply-To: <20260615190711.797573-1-bmarzins@redhat.com>
References: <20260615190711.797573-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4JVpfXQU7eRnQptLG7T482ePbxuUhkkyhj7tGYVOlc4_1781550433
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Since the kernel now requires paths to have a minio of 1, rr_min_io_rq
is completely useless. Remove all the code for it, and deprecate the
option.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c  |  3 ---
 libmultipath/config.h  |  3 ---
 libmultipath/dict.c    | 18 +++++-------------
 libmultipath/hwtable.c |  1 -
 libmultipath/propsel.c | 20 ++++----------------
 tests/hwtable.c        | 13 +++----------
 6 files changed, 12 insertions(+), 46 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index c0be223a..0d877422 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -449,7 +449,6 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_num(pgfailback);
 	merge_num(no_path_retry);
 	merge_num(minio);
-	merge_num(minio_rq);
 	merge_num(flush_on_last_del);
 	merge_num(fast_io_fail);
 	merge_num(dev_loss);
@@ -506,7 +505,6 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 	merge_num(pgfailback);
 	merge_num(no_path_retry);
 	merge_num(minio);
-	merge_num(minio_rq);
 	merge_num(flush_on_last_del);
 	merge_num(attribute_flags);
 	merge_num(user_friendly_names);
@@ -616,7 +614,6 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->pgfailback = dhwe->pgfailback;
 	hwe->no_path_retry = dhwe->no_path_retry;
 	hwe->minio = dhwe->minio;
-	hwe->minio_rq = dhwe->minio_rq;
 	hwe->flush_on_last_del = dhwe->flush_on_last_del;
 	hwe->fast_io_fail = dhwe->fast_io_fail;
 	hwe->dev_loss = dhwe->dev_loss;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 3a08b701..ad3b2423 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -66,7 +66,6 @@ struct hwentry {
 	int pgfailback;
 	int no_path_retry;
 	int minio;
-	int minio_rq;
 	int flush_on_last_del;
 	int fast_io_fail;
 	unsigned int dev_loss;
@@ -115,7 +114,6 @@ struct mpentry {
 	int pgfailback;
 	int no_path_retry;
 	int minio;
-	int minio_rq;
 	int flush_on_last_del;
 	int attribute_flags;
 	int user_friendly_names;
@@ -144,7 +142,6 @@ struct config {
 	int pgpolicy_flag;
 	int pgpolicy;
 	int minio;
-	int minio_rq;
 	unsigned int checkint;
 	unsigned int max_checkint;
 	unsigned int adjust_int;
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 502f54b2..3b6584ec 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -755,15 +755,6 @@ declare_hw_snprint(minio, print_nonzero)
 declare_mp_range_handler(minio, 0, INT_MAX)
 declare_mp_snprint(minio, print_nonzero)
 
-declare_def_range_handler(minio_rq, 0, INT_MAX)
-declare_def_snprint_defint(minio_rq, print_int, DEFAULT_MINIO_RQ)
-declare_ovr_range_handler(minio_rq, 0, INT_MAX)
-declare_ovr_snprint(minio_rq, print_nonzero)
-declare_hw_range_handler(minio_rq, 0, INT_MAX)
-declare_hw_snprint(minio_rq, print_nonzero)
-declare_mp_range_handler(minio_rq, 0, INT_MAX)
-declare_mp_snprint(minio_rq, print_nonzero)
-
 declare_def_handler(queue_without_daemon, set_yes_no)
 static int
 snprint_def_queue_without_daemon(struct config *conf, struct strbuf *buff,
@@ -2117,6 +2108,7 @@ declare_deprecated_handler(pg_timeout, "(not set)")
 declare_deprecated_handler(bindings_file, DEFAULT_BINDINGS_FILE)
 declare_deprecated_handler(wwids_file, DEFAULT_WWIDS_FILE)
 declare_deprecated_handler(prkeys_file, DEFAULT_PRKEYS_FILE)
+declare_deprecated_handler(minio_rq, "1")
 declare_deprecated_handler(rr_weight, "uniform")
 
 /*
@@ -2144,7 +2136,7 @@ init_keywords(vector keywords)
 	install_keyword("alias_prefix", &def_alias_prefix_handler, &snprint_def_alias_prefix);
 	install_keyword("failback", &def_pgfailback_handler, &snprint_def_pgfailback);
 	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_minio);
-	install_keyword("rr_min_io_rq", &def_minio_rq_handler, &snprint_def_minio_rq);
+	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
@@ -2254,7 +2246,7 @@ init_keywords(vector keywords)
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
 	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_minio);
-	install_keyword("rr_min_io_rq", &hw_minio_rq_handler, &snprint_hw_minio_rq);
+	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &hw_fast_io_fail_handler, &snprint_hw_fast_io_fail);
@@ -2300,7 +2292,7 @@ init_keywords(vector keywords)
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &ovr_no_path_retry_handler, &snprint_ovr_no_path_retry);
 	install_keyword("rr_min_io", &ovr_minio_handler, &snprint_ovr_minio);
-	install_keyword("rr_min_io_rq", &ovr_minio_rq_handler, &snprint_ovr_minio_rq);
+	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &ovr_fast_io_fail_handler, &snprint_ovr_fast_io_fail);
 	install_keyword("dev_loss_tmo", &ovr_dev_loss_handler, &snprint_ovr_dev_loss);
@@ -2349,7 +2341,7 @@ init_keywords(vector keywords)
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_minio);
-	install_keyword("rr_min_io_rq", &mp_minio_rq_handler, &snprint_mp_minio_rq);
+	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
 	install_keyword("features", &mp_features_handler, &snprint_mp_features);
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 949ccb33..36646540 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -58,7 +58,6 @@
 		.pgfailback    = -FAILBACK_MANUAL,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 1000,
-		.minio_rq      = 1,
 		.flush_on_last_del = FLUSH_UNUSED,
 		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 		.fast_io_fail  = 5,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index bc5aae7d..cc3146fb 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -848,21 +848,6 @@ out:
 	return 0;
 }
 
-int
-select_minio_rq (struct config *conf, struct multipath * mp)
-{
-	const char *origin;
-
-	do_set(minio_rq, mp->mpe, mp->minio, multipaths_origin);
-	do_set(minio_rq, conf->overrides, mp->minio, overrides_origin);
-	do_set_from_hwe(minio_rq, mp, mp->minio, hwe_origin);
-	do_set(minio_rq, conf, mp->minio, conf_origin);
-	do_default(mp->minio, DEFAULT_MINIO_RQ);
-out:
-	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
-	return 0;
-}
-
 int
 select_minio_bio (struct config *conf, struct multipath * mp)
 {
@@ -880,13 +865,16 @@ out:
 
 int select_minio(struct config *conf, struct multipath *mp)
 {
+	const char *origin;
 	unsigned int minv_dmrq[3] = {1, 1, 0}, version[3];
 
 	if (!libmp_get_version(DM_MPATH_TARGET_VERSION, version)
 	    && VERSION_GE(version, minv_dmrq))
-		return select_minio_rq(conf, mp);
+		do_default(mp->minio, DEFAULT_MINIO_RQ);
 	else
 		return select_minio_bio(conf, mp);
+	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
+	return 0;
 }
 
 int select_fast_io_fail(struct config *conf, struct path *pp)
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 6021bfd3..eb135da1 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -406,7 +406,6 @@ static const char _checker[] = "path_checker";
 static const char _vpd_vnd[] = "vpd_vendor";
 static const char _uid_attr[] = "uid_attribute";
 static const char _bl_product[] = "product_blacklist";
-static const char _minio[] = "rr_min_io_rq";
 static const char _no_path_retry[] = "no_path_retry";
 
 /* Device identifiers */
@@ -441,7 +440,6 @@ static const struct key_value bl_bar = { _bl_product, "bar" };
 static const struct key_value bl_baz = { _bl_product, "baz" };
 static const struct key_value bl_barx = { _bl_product, "ba[[rxy]" };
 static const struct key_value bl_bazy = { _bl_product, "ba[zy]" };
-static const struct key_value minio_99 = { _minio, "99" };
 static const struct key_value npr_37 = { _no_path_retry, "37" };
 static const struct key_value npr_queue = { _no_path_retry, "queue" };
 
@@ -552,7 +550,6 @@ static void test_sanity_globals(void **state)
 	assert_string_not_equal(chk_hp.value, DEFAULT_CHECKER);
 	assert_int_not_equal(MULTIBUS, DEFAULT_PGPOLICY);
 	assert_int_not_equal(NO_PATH_RETRY_QUEUE, DEFAULT_NO_PATH_RETRY);
-	assert_int_not_equal(atoi(minio_99.value), DEFAULT_MINIO_RQ);
 	assert_int_not_equal(atoi(npr_37.value), DEFAULT_NO_PATH_RETRY);
 }
 
@@ -1566,7 +1563,6 @@ static void test_multipath_config(const struct hwt_state *hwt)
 	mp = mock_multipath(pp);
 	assert_ptr_not_equal(mp->mpe, NULL);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
-	assert_int_equal(mp->minio, atoi(minio_99.value));
 	TEST_PROP(pp->uid_attribute, uid_baz.value);
 
 	/* test different wwid */
@@ -1574,14 +1570,13 @@ static void test_multipath_config(const struct hwt_state *hwt)
 	mp = mock_multipath(pp);
 	// assert_ptr_equal(mp->mpe, NULL);
 	TEST_PROP(prio_name(&pp->prio), prio_emc.value);
-	assert_int_equal(mp->minio, DEFAULT_MINIO_RQ);
 	TEST_PROP(pp->uid_attribute, uid_baz.value);
 }
 
 static int setup_multipath_config(void **state)
 {
 	struct hwt_state *hwt = CHECK_STATE(state);
-	const struct key_value kvm[] = { wwid_test, prio_rdac, minio_99 };
+	const struct key_value kvm[] = { wwid_test, prio_rdac };
 	const struct key_value kvp[] = { vnd_foo, prd_bar, prio_emc, uid_baz };
 
 	begin_config(hwt);
@@ -1612,14 +1607,13 @@ static void test_multipath_config_2(const struct hwt_state *hwt)
 	assert_ptr_not_equal(mp, NULL);
 	assert_ptr_not_equal(mp->mpe, NULL);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
-	assert_int_equal(mp->minio, atoi(minio_99.value));
 	assert_int_equal(mp->no_path_retry, atoi(npr_37.value));
 }
 
 static int setup_multipath_config_2(void **state)
 {
 	const struct key_value kv1[] = { wwid_test, prio_rdac, npr_queue };
-	const struct key_value kv2[] = { wwid_test, minio_99, npr_37 };
+	const struct key_value kv2[] = { wwid_test, npr_37 };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	begin_config(hwt);
@@ -1647,14 +1641,13 @@ static void test_multipath_config_3(const struct hwt_state *hwt)
 	assert_ptr_not_equal(mp, NULL);
 	assert_ptr_not_equal(mp->mpe, NULL);
 	TEST_PROP(prio_name(&pp->prio), prio_rdac.value);
-	assert_int_equal(mp->minio, atoi(minio_99.value));
 	assert_int_equal(mp->no_path_retry, atoi(npr_37.value));
 }
 
 static int setup_multipath_config_3(void **state)
 {
 	const struct key_value kv1[] = { wwid_test, prio_rdac, npr_queue };
-	const struct key_value kv2[] = { wwid_test, minio_99, npr_37 };
+	const struct key_value kv2[] = { wwid_test, npr_37 };
 	struct hwt_state *hwt = CHECK_STATE(state);
 
 	begin_config(hwt);
-- 
2.53.0

