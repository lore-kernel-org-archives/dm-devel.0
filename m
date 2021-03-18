Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E74C433E9
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:14:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 95FCB64F30
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95FCB64F30
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-fafn-WRzPMCRF7G4FQtMZQ-1; Thu, 18 Mar 2021 05:14:51 -0400
X-MC-Unique: fafn-WRzPMCRF7G4FQtMZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABD80814315;
	Thu, 18 Mar 2021 09:14:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09EE46F983;
	Thu, 18 Mar 2021 09:14:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9A2571809C84;
	Thu, 18 Mar 2021 09:14:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12I9EfvC005119 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 05:14:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1B88E2024CD1; Thu, 18 Mar 2021 09:14:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15B2E2026D64
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 09:14:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89D8D185A7B2
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 09:14:38 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-209-f68HORl-OieuzdfCHC3Neg-1;
	Thu, 18 Mar 2021 05:14:34 -0400
X-MC-Unique: f68HORl-OieuzdfCHC3Neg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 75A29AD20;
	Thu, 18 Mar 2021 09:14:32 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Mar 2021 10:14:11 +0100
Message-Id: <20210318091413.28027-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12I9EfvC005119
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/3] libmultipath: merge
	update_multipath_table() and update_multipath_status()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
Changes v1 -> v2:
 - log errors at -v2 in update_multipath_table() (Ben)
 - return error in update_multipath_strings() if
   update_multipath_table() fails (Ben)

---
 libmpathpersist/mpath_persist.c   |  1 -
 libmultipath/libmultipath.version | 30 ++++++++----------------
 libmultipath/structs_vec.c        | 38 ++++++++-----------------------
 multipath/main.c                  |  6 ++---
 multipathd/main.c                 |  5 +---
 5 files changed, 21 insertions(+), 59 deletions(-)

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
index 57cd88a..0b069f4 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -423,44 +423,27 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 
 	r = dm_get_map(mpp->alias, &mpp->size, params);
 	if (r != DMP_OK) {
-		condlog(3, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
+		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
 		return r;
 	}
 
 	if (disassemble_map(pathvec, params, mpp)) {
-		condlog(3, "%s: cannot disassemble map", mpp->alias);
+		condlog(2, "%s: cannot disassemble map", mpp->alias);
 		return DMP_ERR;
 	}
 
+	*params = '\0';
+	if (dm_get_status(mpp->alias, params) != DMP_OK)
+		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
+	else if (disassemble_status(params, mpp))
+		condlog(2, "%s: cannot disassemble status", mpp->alias);
+
 	/* FIXME: we should deal with the return value here */
 	update_pathvec_from_dm(pathvec, mpp, flags);
 
 	return DMP_OK;
 }
 
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
-		condlog(3, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
-		return r;
-	}
-
-	if (disassemble_status(status, mpp)) {
-		condlog(3, "%s: cannot disassemble status", mpp->alias);
-		return DMP_ERR;
-	}
-
-	return DMP_OK;
-}
-
 static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
 					    const char *dev_t)
 {
@@ -538,11 +521,8 @@ update_multipath_strings(struct multipath *mpp, vector pathvec)
 	r = update_multipath_table(mpp, pathvec, 0);
 	if (r != DMP_OK)
 		return r;
-	sync_paths(mpp, pathvec);
 
-	r = update_multipath_status(mpp);
-	if (r != DMP_OK)
-		return r;
+	sync_paths(mpp, pathvec);
 
 	vector_foreach_slot(mpp->pg, pgp, i)
 		if (pgp->paths)
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

