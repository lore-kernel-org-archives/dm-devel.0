Return-Path: <SRS0=U3zJ=MH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DF7C07E96
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:54:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8FA706128C
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FA706128C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-l3WYwTqANN6R3QKbCB01WQ-1; Thu, 15 Jul 2021 06:54:49 -0400
X-MC-Unique: l3WYwTqANN6R3QKbCB01WQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBC81101C8A8;
	Thu, 15 Jul 2021 10:54:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBD2E60BF1;
	Thu, 15 Jul 2021 10:54:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 780851809C9A;
	Thu, 15 Jul 2021 10:54:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16FAqiGu015568 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Jul 2021 06:52:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9727910CD776; Thu, 15 Jul 2021 10:52:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 921AC10CD899
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD8B0800182
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:41 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-412-HEuunFzuMty_ZyvljR-WgQ-1; Thu, 15 Jul 2021 06:52:38 -0400
X-MC-Unique: HEuunFzuMty_ZyvljR-WgQ-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 88E392266F;
	Thu, 15 Jul 2021 10:52:37 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 4943813AB7;
	Thu, 15 Jul 2021 10:52:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id OEhHEHUT8GDQIAAAGKfGzw
	(envelope-from <mwilck@suse.com>); Thu, 15 Jul 2021 10:52:37 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 15 Jul 2021 12:52:15 +0200
Message-Id: <20210715105223.30463-2-mwilck@suse.com>
In-Reply-To: <20210715105223.30463-1-mwilck@suse.com>
References: <20210715105223.30463-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16FAqiGu015568
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/9] libmultipath: variable-size parameters in
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index 945e625..a5194d8 100644
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
+		r = outstatus ? DMP_OK : DMP_ERR;
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

