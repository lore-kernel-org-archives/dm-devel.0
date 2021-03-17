Return-Path: <SRS0=F0YI=IP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B46C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 17:28:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90A9D64EE7
	for <dm-devel@archiver.kernel.org>; Wed, 17 Mar 2021 17:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90A9D64EE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-BeLb9BgXOZqmRHgHNxevTA-1; Wed, 17 Mar 2021 13:28:12 -0400
X-MC-Unique: BeLb9BgXOZqmRHgHNxevTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5333107ACCD;
	Wed, 17 Mar 2021 17:28:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1E2310016F8;
	Wed, 17 Mar 2021 17:28:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 47DD31809C83;
	Wed, 17 Mar 2021 17:28:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12HHRrMC003209 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Mar 2021 13:27:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5519D2026980; Wed, 17 Mar 2021 17:27:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F7DD2026D48
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 17:27:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7ED5780B928
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 17:27:50 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-430-pmuKdXjJOemZtb1c0HUv5Q-1;
	Wed, 17 Mar 2021 13:27:45 -0400
X-MC-Unique: pmuKdXjJOemZtb1c0HUv5Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 22546AC75;
	Wed, 17 Mar 2021 17:27:44 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 17 Mar 2021 18:27:26 +0100
Message-Id: <20210317172727.8364-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12HHRrMC003209
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/2] libmultipath: merge update_multipath_table()
	and update_multipath_status()
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

Since 378cb66 ("multipath: use update_pathvec_from_dm()"),
we remove paths and even pathgroups from multipathd's data structures
in update_multipath_table() if these paths are found to be non-existent.
But update_multipath_status() is called afterwards, and it
uses the kernel's mapping of pathgroups and paths, which won't match
any more if any members had been removed. disassemble_status() returns
an error if the number of path groups doesn't match, causing the
entire structure setup to fail. And because disassemble_status()
doesn't check the dev_t against the corresponding values in multipathd's
data structures, it may assign wrong DM state to paths.

Fix this by calling disassemble_status() before making any changes to
the data structure in update_pathvec_from_dm(). This can be easily
done, because every call to update_multipath_status() is preceded
by a call to update_multipath_table() anyway, and vice versa. So
we simply merge the two functions into one. This actually simplifies
the code for all callers.

As we remove a symbol, the major library version must be bumped.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_persist.c   |  1 -
 libmultipath/libmultipath.version | 30 ++++++++-----------------
 libmultipath/structs_vec.c        | 37 ++++++-------------------------
 multipath/main.c                  |  6 ++---
 multipathd/main.c                 |  5 +----
 5 files changed, 19 insertions(+), 60 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 5c95af2..190e970 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -408,7 +408,6 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
 			continue;
 
 		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
-		    update_multipath_status(mpp) != DMP_OK ||
 		    update_mpp_paths(mpp, pathvec)) {
 			condlog(1, "error parsing map %s", mpp->wwid);
 			remove_map(mpp, pathvec, curmp, PURGE_VEC);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index e9b4608..0cff311 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_4.0.0 {
+LIBMULTIPATH_5.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -198,7 +198,6 @@ global:
 	uevent_is_mpath;
 	uevent_listen;
 	update_mpp_paths;
-	update_multipath_status;
 	update_multipath_strings;
 	update_multipath_table;
 	update_pathvec_from_dm;
@@ -256,33 +255,22 @@ global:
 	libmultipath_init;
 	libmultipath_exit;
 
-local:
-	*;
-};
-
-LIBMULTIPATH_4.1.0 {
-global:
+	/* added in 4.1.0 */
 	libmp_verbosity;
-} LIBMULTIPATH_4.0.0;
 
-LIBMULTIPATH_4.2.0 {
-global:
+	/* added in 4.2.0 */
 	dm_prereq;
 	skip_libmp_dm_init;
-} LIBMULTIPATH_4.1.0;
 
-LIBMULTIPATH_4.3.0 {
-global:
+	/* added in 4.3.0 */
 	start_checker_thread;
-} LIBMULTIPATH_4.2.0;
 
-LIBMULTIPATH_4.4.0 {
-global:
+	/* added in 4.4.0 */
 	get_next_string;
-} LIBMULTIPATH_4.3.0;
 
-LIBMULITIPATH_4.5.0 {
-global:
+	/* added in 4.5.0 */
 	get_vpd_sgio;
 	trigger_partitions_udev_change;
-} LIBMULTIPATH_4.4.0;
+local:
+	*;
+};
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 57cd88a..33c522f 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -432,31 +432,14 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 		return DMP_ERR;
 	}
 
-	/* FIXME: we should deal with the return value here */
-	update_pathvec_from_dm(pathvec, mpp, flags);
-
-	return DMP_OK;
-}
-
-int
-update_multipath_status (struct multipath *mpp)
-{
-	int r = DMP_ERR;
-	char status[PARAMS_SIZE] = {0};
-
-	if (!mpp)
-		return r;
-
-	r = dm_get_status(mpp->alias, status);
-	if (r != DMP_OK) {
+	*params = '\0';
+	if (dm_get_status(mpp->alias, params) != DMP_OK)
 		condlog(3, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
-		return r;
-	}
-
-	if (disassemble_status(status, mpp)) {
+	else if (disassemble_status(params, mpp))
 		condlog(3, "%s: cannot disassemble status", mpp->alias);
-		return DMP_ERR;
-	}
+
+	/* FIXME: we should deal with the return value here */
+	update_pathvec_from_dm(pathvec, mpp, flags);
 
 	return DMP_OK;
 }
@@ -536,19 +519,13 @@ update_multipath_strings(struct multipath *mpp, vector pathvec)
 	mpp->pg = NULL;
 
 	r = update_multipath_table(mpp, pathvec, 0);
-	if (r != DMP_OK)
-		return r;
 	sync_paths(mpp, pathvec);
 
-	r = update_multipath_status(mpp);
-	if (r != DMP_OK)
-		return r;
-
 	vector_foreach_slot(mpp->pg, pgp, i)
 		if (pgp->paths)
 			path_group_prio_update(pgp);
 
-	return DMP_OK;
+	return r;
 }
 
 static void enter_recovery_mode(struct multipath *mpp)
diff --git a/multipath/main.c b/multipath/main.c
index 3f97582..ef89c7c 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -196,8 +196,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
 			continue;
 		}
 
-		if (update_multipath_table(mpp, pathvec, flags) != DMP_OK ||
-		    update_multipath_status(mpp) != DMP_OK) {
+		if (update_multipath_table(mpp, pathvec, flags) != DMP_OK) {
 			condlog(1, "error parsing map %s", mpp->wwid);
 			remove_map(mpp, pathvec, curmp, PURGE_VEC);
 			i--;
@@ -263,8 +262,7 @@ static int check_usable_paths(struct config *conf,
 	if (mpp == NULL)
 		goto free;
 
-	if (update_multipath_table(mpp, pathvec, 0) != DMP_OK ||
-		    update_multipath_status(mpp) != DMP_OK)
+	if (update_multipath_table(mpp, pathvec, 0) != DMP_OK)
 		    goto free;
 
 	vector_foreach_slot (mpp->pg, pg, i) {
diff --git a/multipathd/main.c b/multipathd/main.c
index e0797cc..154a4ee 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -559,8 +559,6 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 
 	if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK)
 		goto out;
-	if (update_multipath_status(mpp) != DMP_OK)
-		goto out;
 
 	if (!vector_alloc_slot(vecs->mpvec))
 		goto out;
@@ -1469,8 +1467,7 @@ map_discovery (struct vectors * vecs)
 		return 1;
 
 	vector_foreach_slot (vecs->mpvec, mpp, i)
-		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK ||
-		    update_multipath_status(mpp) != DMP_OK) {
+		if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK) {
 			remove_map(mpp, vecs->pathvec, vecs->mpvec, PURGE_VEC);
 			i--;
 		}
-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

