Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87A933E35B
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 23:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781566580; cv=none; b=kVyauReoi1wQd72brpQ4nSIJlMTsxiXXKx8zM11reNBVDQpkDoNbUDTqXRB7BqBx7JF36FT5yEc2f6mL6fj3HxbgIfHE3BHpY6oGtAMRXt2g7NW4Ns/co0VKWqYYWeGpX4ct1pk73aC17gG/LChrWpnozDQWgCQGOvOazR8yqjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781566580; c=relaxed/simple;
	bh=MorThJeecG0B+qfFy6K4lagXnoj7DaI2z92QKmxp9C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=DMgSccVX4fCQrqfJvVNfGMTnEUxPps14qadbxF6ymsxWHdiAJAHf7j7+7iXy0b2wO0t7s3vxePIqQLL6ALgw4CDxDWZjeFDVcOdFNi5T8EgqyOrPjqy0bOiPcQ1b6uVPqFfXueZab87xgsDablx6Z3t5CGg5TCi9hTx08iOQyRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAjuwvcG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAjuwvcG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781566578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4xLQ0VzfHHA9HOQ/cUu2qMcxrr4fCIW8rKNv6/E/kJM=;
	b=YAjuwvcGVdoWYxub5HUfkLAvwe7lwrxgv69PTkfZ/0kaEjUNykfBswMQO/phibDyIXZi+R
	GMYU8yWg0gd68TNvOt6YTIP6naFlJLxRagXd5FO8ZZzr8ibN79f6YyUcJ4FzrqyJsjJG4E
	vIkQKV5QcgUDkTSWlwBLcXBKMzgi+wY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-T32JFQP_PQOYP05xyL-CNA-1; Mon,
 15 Jun 2026 19:36:14 -0400
X-MC-Unique: T32JFQP_PQOYP05xyL-CNA-1
X-Mimecast-MFC-AGG-ID: T32JFQP_PQOYP05xyL-CNA_1781566573
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 635D2195609F;
	Mon, 15 Jun 2026 23:36:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3053B414;
	Mon, 15 Jun 2026 23:36:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65FNaCla804985
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 19:36:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65FNaC0q804984;
	Mon, 15 Jun 2026 19:36:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2 1/4] libmultipath: deprecate rr_weight, and make it do nothing
Date: Mon, 15 Jun 2026 19:36:08 -0400
Message-ID: <20260615233611.804954-2-bmarzins@redhat.com>
In-Reply-To: <20260615233611.804954-1-bmarzins@redhat.com>
References: <20260615233611.804954-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nBeU3Jab5qm9AMZkyz9-FkK5pzm0u_dDlXbFdd-aaEA_1781566573
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Since the kernel has required paths to have a minio of 1 for a long time
now, rr_weight is completely useless. Remove all the code for it, and
deprecate the option.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  3 ---
 libmultipath/config.h    |  3 ---
 libmultipath/configure.c |  1 -
 libmultipath/defaults.h  |  1 -
 libmultipath/dict.c      | 54 ++++------------------------------------
 libmultipath/dict.h      |  1 -
 libmultipath/dmparser.c  | 16 +-----------
 libmultipath/hwtable.c   |  1 -
 libmultipath/propsel.c   | 22 ----------------
 libmultipath/propsel.h   |  1 -
 libmultipath/structs.h   |  7 ------
 11 files changed, 6 insertions(+), 104 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index f9198d60..c0be223a 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -447,7 +447,6 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
 	merge_str(bl_product);
 	merge_num(pgpolicy);
 	merge_num(pgfailback);
-	merge_num(rr_weight);
 	merge_num(no_path_retry);
 	merge_num(minio);
 	merge_num(minio_rq);
@@ -505,7 +504,6 @@ merge_mpe(struct mpentry *dst, struct mpentry *src)
 
 	merge_num(pgpolicy);
 	merge_num(pgfailback);
-	merge_num(rr_weight);
 	merge_num(no_path_retry);
 	merge_num(minio);
 	merge_num(minio_rq);
@@ -616,7 +614,6 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 
 	hwe->pgpolicy = dhwe->pgpolicy;
 	hwe->pgfailback = dhwe->pgfailback;
-	hwe->rr_weight = dhwe->rr_weight;
 	hwe->no_path_retry = dhwe->no_path_retry;
 	hwe->minio = dhwe->minio;
 	hwe->minio_rq = dhwe->minio_rq;
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 618fa572..3a08b701 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -64,7 +64,6 @@ struct hwentry {
 
 	int pgpolicy;
 	int pgfailback;
-	int rr_weight;
 	int no_path_retry;
 	int minio;
 	int minio_rq;
@@ -114,7 +113,6 @@ struct mpentry {
 	uint8_t sa_flags;
 	int pgpolicy;
 	int pgfailback;
-	int rr_weight;
 	int no_path_retry;
 	int minio;
 	int minio_rq;
@@ -151,7 +149,6 @@ struct config {
 	unsigned int max_checkint;
 	unsigned int adjust_int;
 	int pgfailback;
-	int rr_weight;
 	int no_path_retry;
 	int user_friendly_names;
 	int bindings_read_only;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a954ca31..9d6aec4d 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -336,7 +336,6 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	else
 		free(save_attr);
 
-	select_rr_weight(conf, mpp);
 	select_minio(conf, mpp);
 	select_mode(conf, mpp);
 	select_uid(conf, mpp);
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index d80dd7d4..a6e808db 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -20,7 +20,6 @@
 #define DEFAULT_MINIO_RQ	1
 #define DEFAULT_PGPOLICY	FAILOVER
 #define DEFAULT_FAILBACK	-FAILBACK_MANUAL
-#define DEFAULT_RR_WEIGHT	RR_WEIGHT_NONE
 #define DEFAULT_NO_PATH_RETRY	NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	0
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 797707d9..502f54b2 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -1350,51 +1350,6 @@ snprint_max_fds (struct config *conf, struct strbuf *buff, const void *data)
 		return print_int(buff, conf->max_fds);
 }
 
-static int
-set_rr_weight(vector strvec, void *ptr, const char *file, int line_nr)
-{
-	int *int_ptr = (int *)ptr;
-	char * buff;
-
-	buff = set_value(strvec);
-
-	if (!buff)
-		return 1;
-
-	if (!strcmp(buff, "priorities"))
-		*int_ptr = RR_WEIGHT_PRIO;
-	else if (!strcmp(buff, "uniform"))
-		*int_ptr = RR_WEIGHT_NONE;
-	else
-		condlog(1, "%s line %d, invalid value for rr_weight: \"%s\"",
-			file, line_nr, buff);
-	free(buff);
-
-	return 0;
-}
-
-int
-print_rr_weight (struct strbuf *buff, long v)
-{
-	if (!v)
-		return 0;
-	if (v == RR_WEIGHT_PRIO)
-		return append_strbuf_quoted(buff, "priorities");
-	if (v == RR_WEIGHT_NONE)
-		return append_strbuf_quoted(buff, "uniform");
-
-	return 0;
-}
-
-declare_def_handler(rr_weight, set_rr_weight)
-declare_def_snprint_defint(rr_weight, print_rr_weight, DEFAULT_RR_WEIGHT)
-declare_ovr_handler(rr_weight, set_rr_weight)
-declare_ovr_snprint(rr_weight, print_rr_weight)
-declare_hw_handler(rr_weight, set_rr_weight)
-declare_hw_snprint(rr_weight, print_rr_weight)
-declare_mp_handler(rr_weight, set_rr_weight)
-declare_mp_snprint(rr_weight, print_rr_weight)
-
 static int
 set_pgfailback(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -2162,6 +2117,7 @@ declare_deprecated_handler(pg_timeout, "(not set)")
 declare_deprecated_handler(bindings_file, DEFAULT_BINDINGS_FILE)
 declare_deprecated_handler(wwids_file, DEFAULT_WWIDS_FILE)
 declare_deprecated_handler(prkeys_file, DEFAULT_PRKEYS_FILE)
+declare_deprecated_handler(rr_weight, "uniform")
 
 /*
  * If you add or remove a keyword also update multipath/multipath.conf.5
@@ -2190,7 +2146,7 @@ init_keywords(vector keywords)
 	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_minio);
 	install_keyword("rr_min_io_rq", &def_minio_rq_handler, &snprint_def_minio_rq);
 	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
-	install_keyword("rr_weight", &def_rr_weight_handler, &snprint_def_rr_weight);
+	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
 	install_keyword("queue_without_daemon", &def_queue_without_daemon_handler, &snprint_def_queue_without_daemon);
 	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
@@ -2295,7 +2251,7 @@ init_keywords(vector keywords)
 	install_keyword("prio", &hw_prio_name_handler, &snprint_hw_prio_name);
 	install_keyword("prio_args", &hw_prio_args_handler, &snprint_hw_prio_args);
 	install_keyword("failback", &hw_pgfailback_handler, &snprint_hw_pgfailback);
-	install_keyword("rr_weight", &hw_rr_weight_handler, &snprint_hw_rr_weight);
+	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &hw_no_path_retry_handler, &snprint_hw_no_path_retry);
 	install_keyword("rr_min_io", &hw_minio_handler, &snprint_hw_minio);
 	install_keyword("rr_min_io_rq", &hw_minio_rq_handler, &snprint_hw_minio_rq);
@@ -2341,7 +2297,7 @@ init_keywords(vector keywords)
 	install_keyword("prio", &ovr_prio_name_handler, &snprint_ovr_prio_name);
 	install_keyword("prio_args", &ovr_prio_args_handler, &snprint_ovr_prio_args);
 	install_keyword("failback", &ovr_pgfailback_handler, &snprint_ovr_pgfailback);
-	install_keyword("rr_weight", &ovr_rr_weight_handler, &snprint_ovr_rr_weight);
+	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &ovr_no_path_retry_handler, &snprint_ovr_no_path_retry);
 	install_keyword("rr_min_io", &ovr_minio_handler, &snprint_ovr_minio);
 	install_keyword("rr_min_io_rq", &ovr_minio_rq_handler, &snprint_ovr_minio_rq);
@@ -2390,7 +2346,7 @@ init_keywords(vector keywords)
 	install_keyword("prio", &mp_prio_name_handler, &snprint_mp_prio_name);
 	install_keyword("prio_args", &mp_prio_args_handler, &snprint_mp_prio_args);
 	install_keyword("failback", &mp_pgfailback_handler, &snprint_mp_pgfailback);
-	install_keyword("rr_weight", &mp_rr_weight_handler, &snprint_mp_rr_weight);
+	install_keyword("rr_weight", &deprecated_rr_weight_handler, &snprint_deprecated);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_minio);
 	install_keyword("rr_min_io_rq", &mp_minio_rq_handler, &snprint_mp_minio_rq);
diff --git a/libmultipath/dict.h b/libmultipath/dict.h
index 97c91c8e..3757f1ca 100644
--- a/libmultipath/dict.h
+++ b/libmultipath/dict.h
@@ -7,7 +7,6 @@ struct strbuf;
 
 void init_keywords(vector keywords);
 int get_sys_max_fds(int *);
-int print_rr_weight(struct strbuf *buff, long v);
 int print_pgfailback(struct strbuf *buff, long v);
 int print_pgpolicy(struct strbuf *buff, long v);
 int print_no_path_retry(struct strbuf *buff, long v);
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 3411bd00..97300668 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -89,16 +89,11 @@ int assemble_map(struct multipath *mp, char **params)
 			goto err;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			int tmp_minio = minio;
-
-			if (mp->rr_weight == RR_WEIGHT_PRIO
-			    && pp->priority > 0)
-				tmp_minio = minio * pp->priority;
 			if (!strlen(pp->dev_t) ) {
 				condlog(0, "dev_t not set for '%s'", pp->dev);
 				goto err;
 			}
-			if (print_strbuf(&buff, " %s %d", pp->dev_t, tmp_minio) < 0)
+			if (print_strbuf(&buff, " %s %d", pp->dev_t, minio) < 0)
 				goto err;
 		}
 	}
@@ -315,15 +310,6 @@ int disassemble_map(const struct vector_s *pathvec,
 					def_minio = atoi(word);
 					free(word);
 
-					if (!strncmp(mpp->selector,
-						     "round-robin", 11)) {
-
-						if (mpp->rr_weight == RR_WEIGHT_PRIO
-						    && pp->priority > 0)
-							def_minio /= pp->priority;
-
-					}
-
 					if (def_minio != mpp->minio)
 						mpp->minio = def_minio;
 				}
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 23c54933..949ccb33 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -56,7 +56,6 @@
 		.prio_name     = PRIO_CONST,
 		.prio_args     = "",
 		.pgfailback    = -FAILBACK_MANUAL,
-		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = 1000,
 		.minio_rq      = 1,
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 0c10ebc1..bc5aae7d 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -211,28 +211,6 @@ out:
 	return 0;
 }
 
-/*
- * selectors :
- * traverse the configuration layers from most specific to most generic
- * stop at first explicit setting found
- */
-int select_rr_weight(struct config *conf, struct multipath * mp)
-{
-	const char *origin;
-	STRBUF_ON_STACK(buff);
-
-	mp_set_mpe(rr_weight);
-	mp_set_ovr(rr_weight);
-	mp_set_hwe(rr_weight);
-	mp_set_conf(rr_weight);
-	mp_set_default(rr_weight, DEFAULT_RR_WEIGHT);
-out:
-	print_rr_weight(&buff, mp->rr_weight);
-	condlog(3, "%s: rr_weight = %s %s", mp->alias,
-		get_strbuf_str(&buff), origin);
-	return 0;
-}
-
 int select_pgfailback(struct config *conf, struct multipath * mp)
 {
 	const char *origin;
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index bd20e39e..056e841e 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -1,6 +1,5 @@
 #ifndef PROPSEL_H_INCLUDED
 #define PROPSEL_H_INCLUDED
-int select_rr_weight (struct config *conf, struct multipath * mp);
 int select_pgfailback (struct config *conf, struct multipath * mp);
 int select_detect_pgpolicy (struct config *conf, struct multipath * mp);
 int select_detect_pgpolicy_use_tpg (struct config *conf, struct multipath * mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9adedde2..bf56838c 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -43,12 +43,6 @@ enum free_path_mode {
 	FREE_PATHS
 };
 
-enum rr_weight_mode {
-	RR_WEIGHT_UNDEF,
-	RR_WEIGHT_NONE,
-	RR_WEIGHT_PRIO
-};
-
 enum failback_mode {
 	FAILBACK_UNDEF,
 	FAILBACK_MANUAL,
@@ -483,7 +477,6 @@ struct multipath {
 	int uev_wait_tick;
 	int pgfailback;
 	int failback_tick;
-	int rr_weight;
 	int no_path_retry; /* number of retries after all paths are down */
 	int retry_tick;    /* remaining times for retries */
 	int disable_queueing;
-- 
2.53.0

