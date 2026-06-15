Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD72E309DB1
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 23:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566579; cv=none; b=i3KIweSUukng7UE9mZ8pdAujlW7k0A75ECSKZm1B/D/ntq5ONE0aXVEKuXgen9G36uVSMHxciHzQbhJ4DYtJFNr3GBo/FUhzOtf9ycIDH6wMkpMp3CAhBRUGaOLC1wl1xaZYbNrvrhQMG0JJ++dSoUyAIxTmC59hrHa+/MCiVF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566579; c=relaxed/simple;
	bh=bCMdKWUKy4o2cN37dmNCCd0pdReDMQEAeO/uWmrOmyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=czGGmHXPRxqQO+7BCVCXSbJcuKoDHHIpZDQdBHps6k7zjZlnNMSUKq8EqijXAZI15VW7vUXVKSr4YRf/c4g4qxev2JCNpsdskA0WJBGALefW+27wLSDsUIOw8VL9+vKQtY8Ge3Yb/lAg39SyjD2jQxq6NQEvorTThzj0WgyPKL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZgBFgHpQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZgBFgHpQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781566576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWXo50rraxO3YwKCxkNG1zMRoKxsqnW1e1wgDXEBgOs=;
	b=ZgBFgHpQ/9dYQosTkYndiBCaUnM5bHR+fm2i4pCCDQN8CxUjKCvbGQ4iTIzoQ+A4AAXqYx
	kKfMs0j5MRo69Boruc2WAl/rUlNHcttYgM2vbVsS/kurm0kcWlYiubnL29XLWAXat76APj
	4bo52XUbEFloZztDOCxn3K9KBylAldI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676-cT9lPP-fPcybaearftGLGQ-1; Mon,
 15 Jun 2026 19:36:14 -0400
X-MC-Unique: cT9lPP-fPcybaearftGLGQ-1
X-Mimecast-MFC-AGG-ID: cT9lPP-fPcybaearftGLGQ_1781566573
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1103195410D;
	Mon, 15 Jun 2026 23:36:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C2843008B35;
	Mon, 15 Jun 2026 23:36:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FNaC9p804993
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 19:36:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FNaCs7804992;
	Mon, 15 Jun 2026 19:36:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 3/4] libmultipath: deprecate rr_min_io
Date: Mon, 15 Jun 2026 19:36:10 -0400
Message-ID: <20260615233611.804954-4-bmarzins@redhat.com>
In-Reply-To: <20260615233611.804954-1-bmarzins@redhat.com>
References: <20260615233611.804954-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KvaXRzILMxpa3wX9bj3cry3Z7JLDDg4sy1dTIylft0I_1781566573
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Since the kernel now requires paths to have a minio of 1, rr_min_io is
currently useless. However, bio-based multipath performs significantly
worse than request-based multipath. Part of that is because bio-based
multipath will call the path selector to pick a new path for every bio,
making it very unlikely that adjacent bios will be merged. So this patch
leaves the bio-based minio code around, since we may revisit this in the
future. It does disable setting the value in multipath.conf, and changes
the default to 1. Also, it fixes select_minio() to actually check if the
multipath device is bio-based or request-based, and it takes out the
code for modifying the minio based on the status of the "least-pending"
path selector, because that no longer exists.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/defaults.h |  2 +-
 libmultipath/dict.c     | 18 +++++-------------
 libmultipath/dmparser.c | 12 +-----------
 libmultipath/hwtable.c  |  1 -
 libmultipath/propsel.c  |  8 +++-----
 tests/test-lib.c        |  2 --
 6 files changed, 10 insertions(+), 33 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index a6e808db..ea1fce0e 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -16,7 +16,7 @@
 #define DEFAULT_ALIAS_PREFIX	"mpath"
 #define DEFAULT_FEATURES	"0"
 #define DEFAULT_HWHANDLER	"0"
-#define DEFAULT_MINIO		1000
+#define DEFAULT_MINIO		1
 #define DEFAULT_MINIO_RQ	1
 #define DEFAULT_PGPOLICY	FAILOVER
 #define DEFAULT_FAILBACK	-FAILBACK_MANUAL
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 3b6584ec..0e947b1d 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -746,15 +746,6 @@ declare_ovr_snprint(checker_name, print_str)
 declare_hw_handler(checker_name, set_str)
 declare_hw_snprint(checker_name, print_str)
 
-declare_def_range_handler(minio, 0, INT_MAX)
-declare_def_snprint_defint(minio, print_int, DEFAULT_MINIO)
-declare_ovr_range_handler(minio, 0, INT_MAX)
-declare_ovr_snprint(minio, print_nonzero)
-declare_hw_range_handler(minio, 0, INT_MAX)
-declare_hw_snprint(minio, print_nonzero)
-declare_mp_range_handler(minio, 0, INT_MAX)
-declare_mp_snprint(minio, print_nonzero)
-
 declare_def_handler(queue_without_daemon, set_yes_no)
 static int
 snprint_def_queue_without_daemon(struct config *conf, struct strbuf *buff,
@@ -2108,6 +2099,7 @@ declare_deprecated_handler(pg_timeout, "(not set)")
 declare_deprecated_handler(bindings_file, DEFAULT_BINDINGS_FILE)
 declare_deprecated_handler(wwids_file, DEFAULT_WWIDS_FILE)
 declare_deprecated_handler(prkeys_file, DEFAULT_PRKEYS_FILE)
+declare_deprecated_handler(minio, "1")
 declare_deprecated_handler(minio_rq, "1")
 declare_deprecated_handler(rr_weight, "uniform")
 
@@ -2135,7 +2127,7 @@ init_keywords(vector keywords)
 	install_keyword("checker", &def_checker_name_handler, NULL);
 	install_keyword("alias_prefix", &def_alias_prefix_handler, &snprint_def_alias_prefix);
 	install_keyword("failback", &def_pgfailback_handler, &snprint_def_pgfailback);
-	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_minio);
+	install_keyword("rr_min_io", &deprecated_minio_handler, &snprint_deprecated);
 	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
@@ -2245,7 +2237,7 @@ init_keywords(vector keywords)
 	install_keyword("failback", &hw_pgfailback_handler, &snprint_hw_pgfailback);
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
-	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_minio);
+	install_keyword("rr_min_io", &deprecated_minio_handler, &snprint_deprecated);
 	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &hw_flush_on_last_del_handler, &snprint_hw_flush_on_last_del);
@@ -2291,7 +2283,7 @@ init_keywords(vector keywords)
 	install_keyword("failback", &ovr_pgfailback_handler, &snprint_ovr_pgfailback);
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &ovr_no_path_retry_handler, &snprint_ovr_no_path_retry);
-	install_keyword("rr_min_io", &ovr_minio_handler, &snprint_ovr_minio);
+	install_keyword("rr_min_io", &deprecated_minio_handler, &snprint_deprecated);
 	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &ovr_flush_on_last_del_handler, &snprint_ovr_flush_on_last_del);
 	install_keyword("fast_io_fail_tmo", &ovr_fast_io_fail_handler, &snprint_ovr_fast_io_fail);
@@ -2340,7 +2332,7 @@ init_keywords(vector keywords)
 	install_keyword("failback", &mp_pgfailback_handler, &snprint_mp_pgfailback);
 	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
-	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_minio);
+	install_keyword("rr_min_io", &deprecated_minio_handler, &snprint_deprecated);
 	install_keyword("rr_min_io_rq", &deprecated_minio_rq_handler, &snprint_deprecated);
 	install_keyword("pg_timeout", &deprecated_pg_timeout_handler, &snprint_deprecated);
 	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 97300668..83760e30 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -337,7 +337,6 @@ int disassemble_status(const char *params, struct multipath *mpp)
 	int num_pg;
 	int num_pg_args;
 	int num_paths;
-	int def_minio = 0;
 	struct path * pp;
 	struct pathgroup * pgp;
 
@@ -507,16 +506,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 			 * selector args
 			 */
 			for (k = 0; k < num_pg_args; k++) {
-				if (!strncmp(mpp->selector,
-					     "least-pending", 13)) {
-					p += get_word(p, &word);
-					if (sscanf(word,"%d:*d",
-						   &def_minio) == 1 &&
-					    def_minio != mpp->minio)
-							mpp->minio = def_minio;
-					free(word);
-				} else
-					p += get_word(p, NULL);
+				p += get_word(p, NULL);
 			}
 		}
 	}
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 36646540..a8fbfa70 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -57,7 +57,6 @@
 		.prio_args     = "",
 		.pgfailback    = -FAILBACK_MANUAL,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = 1000,
 		.flush_on_last_del = FLUSH_UNUSED,
 		.user_friendly_names = USER_FRIENDLY_NAMES_OFF,
 		.fast_io_fail  = 5,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 7f0b66ec..277214f6 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -866,13 +866,11 @@ out:
 int select_minio(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	unsigned int minv_dmrq[3] = {1, 1, 0}, version[3];
 
-	if (!libmp_get_version(DM_MPATH_TARGET_VERSION, version)
-	    && VERSION_GE(version, minv_dmrq))
-		mp_set_default(minio, DEFAULT_MINIO_RQ);
-	else
+	if (mp->queue_mode == QUEUE_MODE_BIO)
 		return select_minio_bio(conf, mp);
+
+	mp_set_default(minio, DEFAULT_MINIO_RQ);
 	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
 	return 0;
 }
diff --git a/tests/test-lib.c b/tests/test-lib.c
index ea99977f..9a229e47 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -398,7 +398,6 @@ struct multipath *mock_multipath__(struct vectors *vecs, struct path *pp)
 	struct multipath *mp;
 	struct config *conf;
 	struct mocked_path mop;
-	/* pretend new dm, use minio_rq,  */
 	static const unsigned int fake_dm_tgt_version[3] = { 1, 1, 1 };
 
 	mocked_path_from_path(&mop, pp);
@@ -414,7 +413,6 @@ struct multipath *mock_multipath__(struct vectors *vecs, struct path *pp)
 	select_no_path_retry(conf, mp);
 	will_return(__wrap_libmp_get_version, fake_dm_tgt_version);
 	select_retain_hwhandler(conf, mp);
-	will_return(__wrap_libmp_get_version, fake_dm_tgt_version);
 	select_minio(conf, mp);
 	put_multipath_config(conf);
 
-- 
2.53.0

