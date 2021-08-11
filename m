Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3B1C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:43:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 451D360041
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 451D360041
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-JCwYX-kpOsm3INXW29rqzg-1; Wed, 11 Aug 2021 11:43:38 -0400
X-MC-Unique: JCwYX-kpOsm3INXW29rqzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B820D87D541;
	Wed, 11 Aug 2021 15:43:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 971D519D9D;
	Wed, 11 Aug 2021 15:43:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A7A24A7CB;
	Wed, 11 Aug 2021 15:43:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BFgDGx010108 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 11:42:13 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 28B811032B2; Wed, 11 Aug 2021 15:42:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F71A10329C
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53A3918A01AF
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:06 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-97-VVgj3yHFONu9GDF8gr0UUA-1; Wed, 11 Aug 2021 11:42:04 -0400
X-MC-Unique: VVgj3yHFONu9GDF8gr0UUA-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0519720183;
	Wed, 11 Aug 2021 15:42:03 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id C4F9913969;
	Wed, 11 Aug 2021 15:42:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id OBEuLsrvE2H/XQAAGKfGzw
	(envelope-from <mwilck@suse.com>); Wed, 11 Aug 2021 15:42:02 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 11 Aug 2021 17:41:42 +0200
Message-Id: <20210811154150.24714-2-mwilck@suse.com>
In-Reply-To: <20210811154150.24714-1-mwilck@suse.com>
References: <20210811154150.24714-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17BFgDGx010108
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/9] libmultipath: variable-size parameters in
	dm_get_map()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

We've seen a crash of multipath in disassemble_map because of a params
string exceeding PARAMS_SIZE. While the crash could have been fixed by
a simple error check, I believe multipath should be able to work with
arbitrary long parameter strings passed from the kernel.

The parameter list of dm_get_map() has changed. Bumped ABI version and
removed dm_get_map() and some functions from the ABI, which are only
called from libmultipath itself.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c          | 44 ++++++++++++++++++++-----------
 libmultipath/devmapper.h          |  4 +--
 libmultipath/libmultipath.version |  6 +----
 libmultipath/structs_vec.c        | 11 +++++---
 4 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 945e625..c05dc20 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -648,7 +648,7 @@ int dm_map_present(const char * str)
 	return (do_get_info(str, &info) == 0);
 }
 
-int dm_get_map(const char *name, unsigned long long *size, char *outparams)
+int dm_get_map(const char *name, unsigned long long *size, char **outparams)
 {
 	int r = DMP_ERR;
 	struct dm_task *dmt;
@@ -682,12 +682,13 @@ int dm_get_map(const char *name, unsigned long long *size, char *outparams)
 	if (size)
 		*size = length;
 
-	if (!outparams) {
+	if (!outparams)
 		r = DMP_OK;
-		goto out;
+	else {
+		*outparams = strdup(params);
+		r = *outparams ? DMP_OK : DMP_ERR;
 	}
-	if (snprintf(outparams, PARAMS_SIZE, "%s", params) <= PARAMS_SIZE)
-		r = DMP_OK;
+
 out:
 	dm_task_destroy(dmt);
 	return r;
@@ -761,7 +762,7 @@ is_mpath_part(const char *part_name, const char *map_name)
 	return 0;
 }
 
-int dm_get_status(const char *name, char *outstatus)
+int dm_get_status(const char *name, char **outstatus)
 {
 	int r = DMP_ERR;
 	struct dm_task *dmt;
@@ -799,8 +800,12 @@ int dm_get_status(const char *name, char *outstatus)
 		goto out;
 	}
 
-	if (snprintf(outstatus, PARAMS_SIZE, "%s", status) <= PARAMS_SIZE)
+	if (!outstatus)
 		r = DMP_OK;
+	else {
+		*outstatus = strdup(status);
+		r = *outstatus ? DMP_OK : DMP_ERR;
+	}
 out:
 	if (r != DMP_OK)
 		condlog(0, "%s: error getting map status string", name);
@@ -1049,7 +1054,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 	int queue_if_no_path = 0;
 	int udev_flags = 0;
 	unsigned long long mapsize;
-	char params[PARAMS_SIZE] = {0};
+	char *params = NULL;
 
 	if (dm_is_mpath(mapname) != 1)
 		return 0; /* nothing to do */
@@ -1065,7 +1070,7 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 			return 1;
 
 	if (need_suspend &&
-	    dm_get_map(mapname, &mapsize, params) == DMP_OK &&
+	    dm_get_map(mapname, &mapsize, &params) == DMP_OK &&
 	    strstr(params, "queue_if_no_path")) {
 		if (!dm_queue_if_no_path(mapname, 0))
 			queue_if_no_path = 1;
@@ -1073,6 +1078,8 @@ int _dm_flush_map (const char * mapname, int need_sync, int deferred_remove,
 			/* Leave queue_if_no_path alone if unset failed */
 			queue_if_no_path = -1;
 	}
+	free(params);
+	params = NULL;
 
 	if (dm_remove_partmaps(mapname, need_sync, deferred_remove))
 		return 1;
@@ -1431,7 +1438,7 @@ do_foreach_partmaps (const char * mapname,
 	struct dm_task *dmt;
 	struct dm_names *names;
 	unsigned next = 0;
-	char params[PARAMS_SIZE];
+	char *params = NULL;
 	unsigned long long size;
 	char dev_t[32];
 	int r = 1;
@@ -1474,7 +1481,7 @@ do_foreach_partmaps (const char * mapname,
 		    /*
 		     * and we can fetch the map table from the kernel
 		     */
-		    dm_get_map(names->name, &size, &params[0]) == DMP_OK &&
+		    dm_get_map(names->name, &size, &params) == DMP_OK &&
 
 		    /*
 		     * and the table maps over the multipath map
@@ -1486,12 +1493,15 @@ do_foreach_partmaps (const char * mapname,
 				goto out;
 		}
 
+		free(params);
+		params = NULL;
 		next = names->next;
 		names = (void *) names + next;
 	} while (next);
 
 	r = 0;
 out:
+	free(params);
 	dm_task_destroy (dmt);
 	return r;
 }
@@ -1620,17 +1630,19 @@ struct rename_data {
 static int
 rename_partmap (const char *name, void *data)
 {
-	char buff[PARAMS_SIZE];
+	char *buff = NULL;
 	int offset;
 	struct rename_data *rd = (struct rename_data *)data;
 
 	if (strncmp(name, rd->old, strlen(rd->old)) != 0)
 		return 0;
 	for (offset = strlen(rd->old); name[offset] && !(isdigit(name[offset])); offset++); /* do nothing */
-	snprintf(buff, PARAMS_SIZE, "%s%s%s", rd->new, rd->delim,
-		 name + offset);
-	dm_rename(name, buff, rd->delim, SKIP_KPARTX_OFF);
-	condlog(4, "partition map %s renamed", name);
+	if (asprintf(&buff, "%s%s%s", rd->new, rd->delim, name + offset) >= 0) {
+		dm_rename(name, buff, rd->delim, SKIP_KPARTX_OFF);
+		free(buff);
+		condlog(4, "partition map %s renamed", name);
+	} else
+		condlog(1, "failed to rename partition map %s", name);
 	return 0;
 }
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index e29b4d4..45a676d 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -44,8 +44,8 @@ int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
 int dm_map_present (const char *);
 int dm_map_present_by_uuid(const char *uuid);
-int dm_get_map(const char *, unsigned long long *, char *);
-int dm_get_status(const char *, char *);
+int dm_get_map(const char *, unsigned long long *, char **);
+int dm_get_status(const char *, char **);
 int dm_type(const char *, char *);
 int dm_is_mpath(const char *);
 int _dm_flush_map (const char *, int, int, int, int);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 0cff311..7567837 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_5.0.0 {
+LIBMULTIPATH_6.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -58,8 +58,6 @@ global:
 	count_active_paths;
 	delete_all_foreign;
 	delete_foreign;
-	disassemble_map;
-	disassemble_status;
 	dlog;
 	dm_cancel_deferred_remove;
 	dm_enablegroup;
@@ -70,10 +68,8 @@ global:
 	dm_geteventnr;
 	dm_get_info;
 	dm_get_major_minor;
-	dm_get_map;
 	dm_get_maps;
 	dm_get_multipath;
-	dm_get_status;
 	dm_get_uuid;
 	dm_is_mpath;
 	dm_mapname;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7539019..24d6fd2 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -416,12 +416,12 @@ int
 update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 {
 	int r = DMP_ERR;
-	char params[PARAMS_SIZE] = {0};
+	char *params = NULL;
 
 	if (!mpp)
 		return r;
 
-	r = dm_get_map(mpp->alias, &mpp->size, params);
+	r = dm_get_map(mpp->alias, &mpp->size, &params);
 	if (r != DMP_OK) {
 		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
 		return r;
@@ -429,14 +429,17 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 
 	if (disassemble_map(pathvec, params, mpp)) {
 		condlog(2, "%s: cannot disassemble map", mpp->alias);
+		free(params);
 		return DMP_ERR;
 	}
 
-	*params = '\0';
-	if (dm_get_status(mpp->alias, params) != DMP_OK)
+	free(params);
+	params = NULL;
+	if (dm_get_status(mpp->alias, &params) != DMP_OK)
 		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
 	else if (disassemble_status(params, mpp))
 		condlog(2, "%s: cannot disassemble status", mpp->alias);
+	free(params);
 
 	/* FIXME: we should deal with the return value here */
 	update_pathvec_from_dm(pathvec, mpp, flags);
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

