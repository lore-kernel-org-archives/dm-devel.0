Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7695AC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 16 Dec 2021 12:55:47 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-InRTD0cOPu-UUMR1R-kmYQ-1; Thu, 16 Dec 2021 07:55:42 -0500
X-MC-Unique: InRTD0cOPu-UUMR1R-kmYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 947F619251A2;
	Thu, 16 Dec 2021 12:55:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A3205BD02;
	Thu, 16 Dec 2021 12:55:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 377994BB7C;
	Thu, 16 Dec 2021 12:55:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BGCtLfK020376 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Dec 2021 07:55:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7293FC33AE6; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D1C4C33AE3
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46D75800141
	for <dm-devel@redhat.com>; Thu, 16 Dec 2021 12:55:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-602-X7qxQkSrNJqBUeT--AkfQQ-1; Thu, 16 Dec 2021 07:55:17 -0500
X-MC-Unique: X7qxQkSrNJqBUeT--AkfQQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B7CD212C1;
	Thu, 16 Dec 2021 12:55:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C115013E3B;
	Thu, 16 Dec 2021 12:55:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id ONApLTM3u2FVYQAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 16 Dec 2021 12:55:15 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 16 Dec 2021 13:54:58 +0100
Message-Id: <20211216125502.15867-2-mwilck@suse.com>
In-Reply-To: <20211216125502.15867-1-mwilck@suse.com>
References: <20211216125502.15867-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BGCtLfK020376
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/5] libmpathpersist: split public and internal
	API
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The libmpathpersist library exports symbols that are not part
of the public API. Move the respective code into a separate
source file.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/Makefile                |   2 +-
 libmpathpersist/libmpathpersist.version |  27 +-
 libmpathpersist/mpath_persist.c         | 776 +----------------------
 libmpathpersist/mpath_persist_int.c     | 779 ++++++++++++++++++++++++
 libmpathpersist/mpath_persist_int.h     |  17 +
 libmpathpersist/mpathpr.h               |  12 -
 mpathpersist/main.c                     |   1 +
 multipathd/main.c                       |   1 +
 8 files changed, 818 insertions(+), 797 deletions(-)
 create mode 100644 libmpathpersist/mpath_persist_int.c
 create mode 100644 libmpathpersist/mpath_persist_int.h

diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 1e6399d..fbc401e 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -10,7 +10,7 @@ LDFLAGS += -L$(multipathdir) -L$(mpathcmddir)
 
 LIBDEPS += -lmultipath -lmpathcmd -ldevmapper -lpthread -ldl
 
-OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o
+OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o mpath_persist_int.o
 
 all: $(DEVLIB) man
 
diff --git a/libmpathpersist/libmpathpersist.version b/libmpathpersist/libmpathpersist.version
index fa312f6..a8c6aae 100644
--- a/libmpathpersist/libmpathpersist.version
+++ b/libmpathpersist/libmpathpersist.version
@@ -10,27 +10,28 @@
  *
  * See libmultipath.version for general policy about version numbers.
  */
-LIBMPATHPERSIST_2.0.0 {
+LIBMPATHPERSIST_2.1.0 {
 global:
-
-	__mpath_persistent_reserve_in;
-	__mpath_persistent_reserve_out;
-	dumpHex;
-	mpath_alloc_prin_response;
+	/* public API as defined in mpath_persist.h */
+	libmpathpersist_exit;
+	libmpathpersist_init;
 	mpath_lib_exit;
 	mpath_lib_init;
 	mpath_mx_alloc_len;
+	mpath_persistent_reserve_free_vecs;
+	__mpath_persistent_reserve_in;
 	mpath_persistent_reserve_in;
 	mpath_persistent_reserve_init_vecs;
+	__mpath_persistent_reserve_out;
 	mpath_persistent_reserve_out;
-	mpath_persistent_reserve_free_vecs;
+local: *;
+};
+
+__LIBMPATHPERSIST_INT_1.0.0 {
+	/* Internal use by multipath-tools */
+	dumpHex;
+	mpath_alloc_prin_response;
 	prin_do_scsi_ioctl;
 	prout_do_scsi_ioctl;
 	update_map_pr;
-
-	/* added in 1.1.0 */
-	libmpathpersist_init;
-	libmpathpersist_exit;
-
-local: *;
 };
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 3097c81..6cfcdde 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -1,39 +1,13 @@
 #include <libdevmapper.h>
-#include "defaults.h"
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <fcntl.h>
-#include "vector.h"
-#include "checkers.h"
-#include "structs.h"
-#include "structs_vec.h"
-#include <libudev.h>
 
-#include "prio.h"
-#include <unistd.h>
-#include "devmapper.h"
-#include "debug.h"
-#include "config.h"
-#include "switchgroup.h"
-#include "discovery.h"
-#include "configure.h"
-#include "dmparser.h"
-#include <ctype.h>
-#include "propsel.h"
 #include "util.h"
-#include "unaligned.h"
+#include "vector.h"
+#include "config.h"
+#include "debug.h"
+#include "devmapper.h"
 
 #include "mpath_persist.h"
-#include "mpathpr.h"
-#include "mpath_pr_ioctl.h"
-
-#include <pthread.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-
-#define __STDC_FORMAT_MACROS 1
+#include "mpath_persist_int.h"
 
 extern struct udev *udev;
 
@@ -97,42 +71,6 @@ int libmpathpersist_exit(void)
 	return 0;
 }
 
-int
-mpath_prin_activepath (struct multipath *mpp, int rq_servact,
-	struct prin_resp * resp, int noisy)
-{
-	int i,j, ret = MPATH_PR_DMMP_ERROR;
-	struct pathgroup *pgp = NULL;
-	struct path *pp = NULL;
-
-	vector_foreach_slot (mpp->pg, pgp, j){
-		vector_foreach_slot (pgp->paths, pp, i){
-			if (!((pp->state == PATH_UP) ||
-			      (pp->state == PATH_GHOST))){
-				condlog(2, "%s: %s not available. Skip.",
-					mpp->wwid, pp->dev);
-				condlog(3, "%s: status = %d.",
-					mpp->wwid, pp->state);
-				continue;
-			}
-
-			condlog(3, "%s: sending pr in command to %s ",
-				mpp->wwid, pp->dev);
-			ret = mpath_send_prin_activepath(pp->dev, rq_servact,
-							 resp, noisy);
-			switch(ret)
-			{
-				case MPATH_PR_SUCCESS:
-				case MPATH_PR_SENSE_INVALID_OP:
-					return ret;
-				default:
-					continue;
-			}
-		}
-	}
-	return ret;
-}
-
 static vector curmp;
 static vector pathvec;
 
@@ -182,83 +120,6 @@ int mpath_persistent_reserve_init_vecs(int verbose)
 	return __mpath_persistent_reserve_init_vecs(&curmp, &pathvec, verbose);
 }
 
-static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
-			 struct multipath **pmpp)
-{
-	int ret = MPATH_PR_DMMP_ERROR;
-	struct stat info;
-	int major, minor;
-	char *alias;
-	struct multipath *mpp;
-
-	if (fstat(fd, &info) != 0){
-		condlog(0, "stat error fd=%d", fd);
-		return MPATH_PR_FILE_ERROR;
-	}
-	if(!S_ISBLK(info.st_mode)){
-		condlog(3, "Failed to get major:minor. fd=%d", fd);
-		return MPATH_PR_FILE_ERROR;
-	}
-
-	major = major(info.st_rdev);
-	minor = minor(info.st_rdev);
-	condlog(4, "Device  %d:%d", major, minor);
-
-	/* get alias from major:minor*/
-	alias = dm_mapname(major, minor);
-	if (!alias){
-		condlog(0, "%d:%d failed to get device alias.", major, minor);
-		return MPATH_PR_DMMP_ERROR;
-	}
-
-	condlog(3, "alias = %s", alias);
-
-	if (dm_map_present(alias) && dm_is_mpath(alias) != 1){
-		condlog(3, "%s: not a multipath device.", alias);
-		goto out;
-	}
-
-	/* get info of all paths from the dm device     */
-	if (get_mpvec(curmp, pathvec, alias)){
-		condlog(0, "%s: failed to get device info.", alias);
-		goto out;
-	}
-
-	mpp = find_mp_by_alias(curmp, alias);
-
-	if (!mpp) {
-		condlog(0, "%s: devmap not registered.", alias);
-		goto out;
-	}
-
-	ret = MPATH_PR_SUCCESS;
-	if (pmpp)
-		*pmpp = mpp;
-	if (palias) {
-		*palias = alias;
-		alias = NULL;
-	}
-out:
-	free(alias);
-	return ret;
-}
-
-static int do_mpath_persistent_reserve_in (vector curmp, vector pathvec,
-	int fd, int rq_servact, struct prin_resp *resp, int noisy)
-{
-	struct multipath *mpp;
-	int ret;
-
-	ret = mpath_get_map(curmp, pathvec, fd, NULL, &mpp);
-	if (ret != MPATH_PR_SUCCESS)
-		return ret;
-
-	ret = mpath_prin_activepath(mpp, rq_servact, resp, noisy);
-
-	return ret;
-}
-
-
 int __mpath_persistent_reserve_in (int fd, int rq_servact,
 	struct prin_resp *resp, int noisy)
 {
@@ -266,86 +127,6 @@ int __mpath_persistent_reserve_in (int fd, int rq_servact,
 					      resp, noisy);
 }
 
-static int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
-	int rq_servact, int rq_scope, unsigned int rq_type,
-	struct prout_param_descriptor *paramp, int noisy)
-{
-	struct multipath *mpp;
-	char *alias;
-	int ret;
-	uint64_t prkey;
-	struct config *conf;
-
-	ret = mpath_get_map(curmp, pathvec, fd, &alias, &mpp);
-	if (ret != MPATH_PR_SUCCESS)
-		return ret;
-
-	conf = get_multipath_config();
-	select_reservation_key(conf, mpp);
-	select_all_tg_pt(conf, mpp);
-	put_multipath_config(conf);
-
-	memcpy(&prkey, paramp->sa_key, 8);
-	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
-	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
-	     (rq_servact == MPATH_PROUT_REG_SA &&
-	      (!get_be64(mpp->reservation_key) ||
-	       memcmp(paramp->key, &mpp->reservation_key, 8) == 0)))) {
-		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
-		if (update_prkey_flags(alias, get_be64(mpp->reservation_key),
-				       paramp->sa_flags)) {
-			condlog(0, "%s: failed to set prkey for multipathd.",
-				alias);
-			ret = MPATH_PR_DMMP_ERROR;
-			goto out1;
-		}
-	}
-
-	if (memcmp(paramp->key, &mpp->reservation_key, 8) &&
-	    memcmp(paramp->sa_key, &mpp->reservation_key, 8) &&
-	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
-		condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64, alias, get_be64(mpp->reservation_key));
-		ret = MPATH_PR_SYNTAX_ERROR;
-		goto out1;
-	}
-
-	switch(rq_servact)
-	{
-	case MPATH_PROUT_REG_SA:
-	case MPATH_PROUT_REG_IGN_SA:
-		ret= mpath_prout_reg(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
-		break;
-	case MPATH_PROUT_RES_SA :
-	case MPATH_PROUT_PREE_SA :
-	case MPATH_PROUT_PREE_AB_SA :
-	case MPATH_PROUT_CLEAR_SA:
-		ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
-		break;
-	case MPATH_PROUT_REL_SA:
-		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
-		break;
-	default:
-		ret = MPATH_PR_OTHER;
-		goto out1;
-	}
-
-	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
-				(rq_servact ==  MPATH_PROUT_REG_IGN_SA)))
-	{
-		if (prkey == 0) {
-			update_prflag(alias, 0);
-			update_prkey(alias, 0);
-		} else
-			update_prflag(alias, 1);
-	} else if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
-		update_prflag(alias, 0);
-		update_prkey(alias, 0);
-	}
-out1:
-	free(alias);
-	return ret;
-}
-
 
 int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy)
@@ -384,550 +165,3 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	__mpath_persistent_reserve_free_vecs(curmp, pathvec);
 	return ret;
 }
-
-int
-get_mpvec (vector curmp, vector pathvec, char * refwwid)
-{
-	int i;
-	struct multipath *mpp;
-
-	vector_foreach_slot (curmp, mpp, i){
-		/*
-		 * discard out of scope maps
-		 */
-		if (!mpp->alias) {
-			condlog(0, "%s: map with empty alias!", __func__);
-			continue;
-		}
-
-		if (mpp->pg != NULL)
-			/* Already seen this one */
-			continue;
-
-		if (refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE - 1))
-			continue;
-
-		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
-		    update_mpp_paths(mpp, pathvec)) {
-			condlog(1, "error parsing map %s", mpp->wwid);
-			remove_map(mpp, pathvec, curmp);
-			i--;
-		} else
-			extract_hwe_from_path(mpp);
-	}
-	return MPATH_PR_SUCCESS ;
-}
-
-int mpath_send_prin_activepath (char * dev, int rq_servact,
-				struct prin_resp * resp, int noisy)
-{
-
-	int rc;
-
-	rc = prin_do_scsi_ioctl(dev, rq_servact, resp,  noisy);
-
-	return (rc);
-}
-
-int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
-	unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
-{
-
-	int i, j, k;
-	struct pathgroup *pgp = NULL;
-	struct path *pp = NULL;
-	int rollback = 0;
-	int active_pathcount=0;
-	int rc;
-	int count=0;
-	int status = MPATH_PR_SUCCESS;
-	int all_tg_pt;
-	uint64_t sa_key = 0;
-
-	if (!mpp)
-		return MPATH_PR_DMMP_ERROR;
-
-	all_tg_pt = (mpp->all_tg_pt == ALL_TG_PT_ON ||
-		     paramp->sa_flags & MPATH_F_ALL_TG_PT_MASK);
-	active_pathcount = count_active_paths(mpp);
-
-	if (active_pathcount == 0) {
-		condlog (0, "%s: no path available", mpp->wwid);
-		return MPATH_PR_DMMP_ERROR;
-	}
-
-	struct threadinfo thread[active_pathcount];
-	int hosts[active_pathcount];
-
-	memset(thread, 0, sizeof(thread));
-
-	/* init thread parameter */
-	for (i =0; i< active_pathcount; i++){
-		hosts[i] = -1;
-		thread[i].param.rq_servact = rq_servact;
-		thread[i].param.rq_scope = rq_scope;
-		thread[i].param.rq_type = rq_type;
-		thread[i].param.paramp = paramp;
-		thread[i].param.noisy = noisy;
-		thread[i].param.status = MPATH_PR_SKIP;
-
-		condlog (3, "THREAD ID [%d] INFO]", i);
-		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
-		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope);
-		condlog (3, "rq_type=%d ", thread[i].param.rq_type);
-		condlog (3, "rkey=");
-		condlog (3, "paramp->sa_flags =%02x ",
-			 thread[i].param.paramp->sa_flags);
-		condlog (3, "noisy=%d ", thread[i].param.noisy);
-		condlog (3, "status=%d ", thread[i].param.status);
-	}
-
-	pthread_attr_t attr;
-	pthread_attr_init(&attr);
-	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
-
-	vector_foreach_slot (mpp->pg, pgp, j){
-		vector_foreach_slot (pgp->paths, pp, i){
-			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog (1, "%s: %s path not up. Skip.", mpp->wwid, pp->dev);
-				continue;
-			}
-			if (all_tg_pt && pp->sg_id.host_no != -1) {
-				for (k = 0; k < count; k++) {
-					if (pp->sg_id.host_no == hosts[k]) {
-						condlog(3, "%s: %s host %d matches skip.", pp->wwid, pp->dev, pp->sg_id.host_no);
-						break;
-					}
-				}
-				if (k < count)
-					continue;
-			}
-			strlcpy(thread[count].param.dev, pp->dev,
-				FILE_NAME_SIZE);
-
-			if (count && (thread[count].param.paramp->sa_flags & MPATH_F_SPEC_I_PT_MASK)){
-				/*
-				 * Clearing SPEC_I_PT as transportids are already registered by now.
-				 */
-				thread[count].param.paramp->sa_flags &= (~MPATH_F_SPEC_I_PT_MASK);
-			}
-
-			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
-
-			rc = pthread_create(&thread[count].id, &attr, mpath_prout_pthread_fn, (void *)(&thread[count].param));
-			if (rc){
-				condlog (0, "%s: failed to create thread %d", mpp->wwid, rc);
-				thread[count].param.status = MPATH_PR_THREAD_ERROR;
-			}
-			else
-				hosts[count] = pp->sg_id.host_no;
-			count = count + 1;
-		}
-	}
-	for( i=0; i < count ; i++){
-		if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
-			rc = pthread_join(thread[i].id, NULL);
-			if (rc){
-				condlog (0, "%s: Thread[%d] failed to join thread %d", mpp->wwid, i, rc);
-			}
-		}
-		if (!rollback && (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)){
-			rollback = 1;
-			sa_key = get_unaligned_be64(&paramp->sa_key[0]);
-			status = MPATH_PR_RESERV_CONFLICT ;
-		}
-		if (!rollback && (status == MPATH_PR_SUCCESS)){
-			status = thread[i].param.status;
-		}
-	}
-	if (rollback && ((rq_servact == MPATH_PROUT_REG_SA) && sa_key != 0 )){
-		condlog (3, "%s: ERROR: initiating pr out rollback", mpp->wwid);
-		memcpy(&paramp->key, &paramp->sa_key, 8);
-		memset(&paramp->sa_key, 0, 8);
-		for( i=0 ; i < count ; i++){
-			if(thread[i].param.status == MPATH_PR_SUCCESS) {
-				rc = pthread_create(&thread[i].id, &attr, mpath_prout_pthread_fn,
-						(void *)(&thread[i].param));
-				if (rc){
-					condlog (0, "%s: failed to create thread for rollback. %d",  mpp->wwid, rc);
-					thread[i].param.status = MPATH_PR_THREAD_ERROR;
-				}
-			} else
-				thread[i].param.status = MPATH_PR_SKIP;
-		}
-		for(i=0; i < count ; i++){
-			if (thread[i].param.status != MPATH_PR_SKIP &&
-			    thread[i].param.status != MPATH_PR_THREAD_ERROR) {
-				rc = pthread_join(thread[i].id, NULL);
-				if (rc){
-					condlog (3, "%s: failed to join thread while rolling back %d",
-						 mpp->wwid, i);
-				}
-			}
-		}
-	}
-
-	pthread_attr_destroy(&attr);
-	return (status);
-}
-
-void * mpath_prout_pthread_fn(void *p)
-{
-	int ret;
-	struct prout_param * param = (struct prout_param *)p;
-
-	ret = prout_do_scsi_ioctl( param->dev,param->rq_servact, param->rq_scope,
-			param->rq_type, param->paramp, param->noisy);
-	param->status = ret;
-	pthread_exit(NULL);
-}
-
-int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
-	unsigned int rq_type, struct prout_param_descriptor* paramp, int noisy)
-{
-	int i,j, ret;
-	struct pathgroup *pgp = NULL;
-	struct path *pp = NULL;
-
-	vector_foreach_slot (mpp->pg, pgp, j){
-		vector_foreach_slot (pgp->paths, pp, i){
-			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog (1, "%s: %s path not up. Skip",
-					 mpp->wwid, pp->dev);
-				continue;
-			}
-
-			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
-			ret = send_prout_activepath(pp->dev, rq_servact,
-						    rq_scope, rq_type,
-						    paramp, noisy);
-			return ret ;
-		}
-	}
-	condlog (0, "%s: no path available", mpp->wwid);
-	return MPATH_PR_DMMP_ERROR;
-}
-
-int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
-	unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
-{
-	struct prout_param param;
-	param.rq_servact = rq_servact;
-	param.rq_scope  = rq_scope;
-	param.rq_type   = rq_type;
-	param.paramp    = paramp;
-	param.noisy = noisy;
-	param.status = -1;
-
-	pthread_t thread;
-	pthread_attr_t attr;
-	int rc;
-
-	memset(&thread, 0, sizeof(thread));
-	strlcpy(param.dev, dev, FILE_NAME_SIZE);
-	/* Initialize and set thread joinable attribute */
-	pthread_attr_init(&attr);
-	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
-
-	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
-	if (rc){
-		condlog (3, "%s: failed to create thread %d", dev, rc);
-		return MPATH_PR_THREAD_ERROR;
-	}
-	/* Free attribute and wait for the other threads */
-	pthread_attr_destroy(&attr);
-	rc = pthread_join(thread, NULL);
-
-	return (param.status);
-}
-
-int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
-	unsigned int rq_type, struct prout_param_descriptor * paramp, int noisy)
-{
-	int i, j;
-	int num = 0;
-	struct pathgroup *pgp = NULL;
-	struct path *pp = NULL;
-	int active_pathcount = 0;
-	pthread_attr_t attr;
-	int rc, found = 0;
-	int count = 0;
-	int status = MPATH_PR_SUCCESS;
-	struct prin_resp resp;
-	struct prout_param_descriptor *pamp;
-	struct prin_resp *pr_buff;
-	int length;
-	struct transportid *pptr;
-
-	if (!mpp)
-		return MPATH_PR_DMMP_ERROR;
-
-	active_pathcount = count_active_paths(mpp);
-
-	if (active_pathcount == 0) {
-		condlog (0, "%s: no path available", mpp->wwid);
-		return MPATH_PR_DMMP_ERROR;
-	}
-
-	struct threadinfo thread[active_pathcount];
-	memset(thread, 0, sizeof(thread));
-	for (i = 0; i < active_pathcount; i++){
-		thread[i].param.rq_servact = rq_servact;
-		thread[i].param.rq_scope = rq_scope;
-		thread[i].param.rq_type = rq_type;
-		thread[i].param.paramp = paramp;
-		thread[i].param.noisy = noisy;
-		thread[i].param.status = MPATH_PR_SKIP;
-
-		condlog (3, " path count = %d", i);
-		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
-		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope);
-		condlog (3, "rq_type=%d ", thread[i].param.rq_type);
-		condlog (3, "noisy=%d ", thread[i].param.noisy);
-		condlog (3, "status=%d ", thread[i].param.status);
-	}
-
-	pthread_attr_init (&attr);
-	pthread_attr_setdetachstate (&attr, PTHREAD_CREATE_JOINABLE);
-
-	vector_foreach_slot (mpp->pg, pgp, j){
-		vector_foreach_slot (pgp->paths, pp, i){
-			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
-				condlog (1, "%s: %s path not up.", mpp->wwid, pp->dev);
-				continue;
-			}
-
-			strlcpy(thread[count].param.dev, pp->dev,
-				FILE_NAME_SIZE);
-			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
-			rc = pthread_create (&thread[count].id, &attr, mpath_prout_pthread_fn,
-					(void *) (&thread[count].param));
-			if (rc) {
-				condlog (0, "%s: failed to create thread. %d",  mpp->wwid, rc);
-				thread[count].param.status = MPATH_PR_THREAD_ERROR;
-			}
-			count = count + 1;
-		}
-	}
-	pthread_attr_destroy (&attr);
-	for (i = 0; i < count; i++){
-		if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
-			rc = pthread_join (thread[i].id, NULL);
-			if (rc){
-				condlog (1, "%s: failed to join thread.  %d",  mpp->wwid,  rc);
-			}
-		}
-	}
-
-	for (i = 0; i < count; i++){
-		/*  check thread status here and return the status */
-
-		if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
-			status = MPATH_PR_RESERV_CONFLICT;
-		else if (status == MPATH_PR_SUCCESS
-				&& thread[i].param.status != MPATH_PR_RESERV_CONFLICT)
-			status = thread[i].param.status;
-	}
-
-	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
-	if (status != MPATH_PR_SUCCESS){
-		condlog (0, "%s: pr in read reservation command failed.", mpp->wwid);
-		return MPATH_PR_OTHER;
-	}
-
-	num = resp.prin_descriptor.prin_readresv.additional_length / 8;
-	if (num == 0){
-		condlog (2, "%s: Path holding reservation is released.", mpp->wwid);
-		return MPATH_PR_SUCCESS;
-	}
-	condlog (2, "%s: Path holding reservation is not avialable.", mpp->wwid);
-
-	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
-	if (!pr_buff){
-		condlog (0, "%s: failed to  alloc pr in response buffer.", mpp->wwid);
-		return MPATH_PR_OTHER;
-	}
-
-	status = mpath_prin_activepath (mpp, MPATH_PRIN_RFSTAT_SA, pr_buff, noisy);
-
-	if (status != MPATH_PR_SUCCESS){
-		condlog (0,  "%s: pr in read full status command failed.",  mpp->wwid);
-		goto out;
-	}
-
-	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
-	if (0 == num){
-		goto out;
-	}
-	length = sizeof (struct prout_param_descriptor) + (sizeof (struct transportid *));
-
-	pamp = (struct prout_param_descriptor *)malloc (length);
-	if (!pamp){
-		condlog (0, "%s: failed to alloc pr out parameter.", mpp->wwid);
-		goto out1;
-	}
-
-	memset(pamp, 0, length);
-
-	pamp->trnptid_list[0] = (struct transportid *) malloc (sizeof (struct transportid));
-	if (!pamp->trnptid_list[0]){
-		condlog (0, "%s: failed to alloc pr out transportid.", mpp->wwid);
-		goto out1;
-	}
-
-	if (get_be64(mpp->reservation_key)){
-		memcpy (pamp->key, &mpp->reservation_key, 8);
-		condlog (3, "%s: reservation key set.", mpp->wwid);
-	}
-
-	status = mpath_prout_common (mpp, MPATH_PROUT_CLEAR_SA,
-				     rq_scope, rq_type, pamp, noisy);
-
-	if (status) {
-		condlog(0, "%s: failed to send CLEAR_SA", mpp->wwid);
-		goto out1;
-	}
-
-	pamp->num_transportid = 1;
-	pptr=pamp->trnptid_list[0];
-
-	for (i = 0; i < num; i++){
-		if (get_be64(mpp->reservation_key) &&
-			memcmp(pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key,
-			       &mpp->reservation_key, 8)){
-			/*register with tarnsport id*/
-			memset(pamp, 0, length);
-			pamp->trnptid_list[0] = pptr;
-			memset (pamp->trnptid_list[0], 0, sizeof (struct transportid));
-			memcpy (pamp->sa_key,
-					pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
-			pamp->sa_flags = MPATH_F_SPEC_I_PT_MASK;
-			pamp->num_transportid = 1;
-
-			memcpy (pamp->trnptid_list[0],
-					&pr_buff->prin_descriptor.prin_readfd.descriptors[i]->trnptid,
-					sizeof (struct transportid));
-			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
-					pamp, noisy);
-
-			pamp->sa_flags = 0;
-			memcpy (pamp->key, pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
-			memset (pamp->sa_key, 0, 8);
-			pamp->num_transportid = 0;
-			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
-					pamp, noisy);
-		}
-		else
-		{
-			if (get_be64(mpp->reservation_key))
-				found = 1;
-		}
-
-
-	}
-
-	if (found){
-		memset (pamp, 0, length);
-		memcpy (pamp->sa_key, &mpp->reservation_key, 8);
-		memset (pamp->key, 0, 8);
-		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);
-	}
-
-
-	free(pptr);
-out1:
-	free (pamp);
-out:
-	free (pr_buff);
-	return (status);
-}
-
-void * mpath_alloc_prin_response(int prin_sa)
-{
-	void * ptr = NULL;
-	int size=0;
-	switch (prin_sa)
-	{
-		case MPATH_PRIN_RKEY_SA:
-			size = sizeof(struct prin_readdescr);
-			break;
-		case MPATH_PRIN_RRES_SA:
-			size = sizeof(struct prin_resvdescr);
-			break;
-		case MPATH_PRIN_RCAP_SA:
-			size=sizeof(struct prin_capdescr);
-			break;
-		case MPATH_PRIN_RFSTAT_SA:
-			size = sizeof(struct print_fulldescr_list) +
-				sizeof(struct prin_fulldescr *)*MPATH_MX_TIDS;
-			break;
-	}
-	if (size > 0)
-	{
-		ptr = calloc(size, 1);
-	}
-	return ptr;
-}
-
-int update_map_pr(struct multipath *mpp)
-{
-	int noisy=0;
-	struct prin_resp *resp;
-	unsigned int i;
-	int ret, isFound;
-
-	if (!get_be64(mpp->reservation_key))
-	{
-		/* Nothing to do. Assuming pr mgmt feature is disabled*/
-		condlog(4, "%s: reservation_key not set in multipath.conf",
-			mpp->alias);
-		return MPATH_PR_SUCCESS;
-	}
-
-	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
-	if (!resp)
-	{
-		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
-		return MPATH_PR_OTHER;
-	}
-	ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
-
-	if (ret != MPATH_PR_SUCCESS )
-	{
-		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
-		free(resp);
-		return  ret;
-	}
-
-	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
-	{
-		condlog(3,"%s: No key found. Device may not be registered. ", mpp->alias);
-		free(resp);
-		return MPATH_PR_SUCCESS;
-	}
-
-	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias,
-		get_be64(mpp->reservation_key));
-
-	isFound =0;
-	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
-	{
-		condlog(2, "%s: PR IN READKEYS[%d]  reservation key:", mpp->alias, i);
-		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , 1);
-
-		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
-		{
-			condlog(2, "%s: reservation key found in pr in readkeys response", mpp->alias);
-			isFound =1;
-		}
-	}
-
-	if (isFound)
-	{
-		mpp->prflag = 1;
-		condlog(2, "%s: prflag flag set.", mpp->alias );
-	}
-
-	free(resp);
-	return MPATH_PR_SUCCESS;
-}
diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
new file mode 100644
index 0000000..7f6ac04
--- /dev/null
+++ b/libmpathpersist/mpath_persist_int.c
@@ -0,0 +1,779 @@
+#include <libdevmapper.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <libudev.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <ctype.h>
+
+#include "vector.h"
+#include "defaults.h"
+#include "checkers.h"
+#include "structs.h"
+#include "structs_vec.h"
+#include "prio.h"
+#include "devmapper.h"
+#include "debug.h"
+#include "config.h"
+#include "switchgroup.h"
+#include "discovery.h"
+#include "configure.h"
+#include "dmparser.h"
+#include "propsel.h"
+#include "util.h"
+#include "unaligned.h"
+
+#include "mpath_persist.h"
+#include "mpath_persist_int.h"
+#include "mpathpr.h"
+#include "mpath_pr_ioctl.h"
+
+
+#define __STDC_FORMAT_MACROS 1
+
+static int mpath_send_prin_activepath (char * dev, int rq_servact,
+				struct prin_resp * resp, int noisy)
+{
+
+	int rc;
+
+	rc = prin_do_scsi_ioctl(dev, rq_servact, resp,  noisy);
+
+	return (rc);
+}
+
+static int mpath_prin_activepath (struct multipath *mpp, int rq_servact,
+	struct prin_resp * resp, int noisy)
+{
+	int i,j, ret = MPATH_PR_DMMP_ERROR;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) ||
+			      (pp->state == PATH_GHOST))){
+				condlog(2, "%s: %s not available. Skip.",
+					mpp->wwid, pp->dev);
+				condlog(3, "%s: status = %d.",
+					mpp->wwid, pp->state);
+				continue;
+			}
+
+			condlog(3, "%s: sending pr in command to %s ",
+				mpp->wwid, pp->dev);
+			ret = mpath_send_prin_activepath(pp->dev, rq_servact,
+							 resp, noisy);
+			switch(ret)
+			{
+				case MPATH_PR_SUCCESS:
+				case MPATH_PR_SENSE_INVALID_OP:
+					return ret;
+				default:
+					continue;
+			}
+		}
+	}
+	return ret;
+}
+
+void *mpath_alloc_prin_response(int prin_sa)
+{
+	void * ptr = NULL;
+	int size=0;
+	switch (prin_sa)
+	{
+		case MPATH_PRIN_RKEY_SA:
+			size = sizeof(struct prin_readdescr);
+			break;
+		case MPATH_PRIN_RRES_SA:
+			size = sizeof(struct prin_resvdescr);
+			break;
+		case MPATH_PRIN_RCAP_SA:
+			size=sizeof(struct prin_capdescr);
+			break;
+		case MPATH_PRIN_RFSTAT_SA:
+			size = sizeof(struct print_fulldescr_list) +
+				sizeof(struct prin_fulldescr *)*MPATH_MX_TIDS;
+			break;
+	}
+	if (size > 0)
+	{
+		ptr = calloc(size, 1);
+	}
+	return ptr;
+}
+
+static int get_mpvec(vector curmp, vector pathvec, char *refwwid)
+{
+	int i;
+	struct multipath *mpp;
+
+	vector_foreach_slot (curmp, mpp, i){
+		/*
+		 * discard out of scope maps
+		 */
+		if (!mpp->alias) {
+			condlog(0, "%s: map with empty alias!", __func__);
+			continue;
+		}
+
+		if (mpp->pg != NULL)
+			/* Already seen this one */
+			continue;
+
+		if (refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE - 1))
+			continue;
+
+		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
+		    update_mpp_paths(mpp, pathvec)) {
+			condlog(1, "error parsing map %s", mpp->wwid);
+			remove_map(mpp, pathvec, curmp);
+			i--;
+		} else
+			extract_hwe_from_path(mpp);
+	}
+	return MPATH_PR_SUCCESS ;
+}
+
+static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
+			 struct multipath **pmpp)
+{
+	int ret = MPATH_PR_DMMP_ERROR;
+	struct stat info;
+	int major, minor;
+	char *alias;
+	struct multipath *mpp;
+
+	if (fstat(fd, &info) != 0){
+		condlog(0, "stat error fd=%d", fd);
+		return MPATH_PR_FILE_ERROR;
+	}
+	if(!S_ISBLK(info.st_mode)){
+		condlog(3, "Failed to get major:minor. fd=%d", fd);
+		return MPATH_PR_FILE_ERROR;
+	}
+
+	major = major(info.st_rdev);
+	minor = minor(info.st_rdev);
+	condlog(4, "Device  %d:%d", major, minor);
+
+	/* get alias from major:minor*/
+	alias = dm_mapname(major, minor);
+	if (!alias){
+		condlog(0, "%d:%d failed to get device alias.", major, minor);
+		return MPATH_PR_DMMP_ERROR;
+	}
+
+	condlog(3, "alias = %s", alias);
+
+	if (dm_map_present(alias) && dm_is_mpath(alias) != 1){
+		condlog(3, "%s: not a multipath device.", alias);
+		goto out;
+	}
+
+	/* get info of all paths from the dm device     */
+	if (get_mpvec(curmp, pathvec, alias)){
+		condlog(0, "%s: failed to get device info.", alias);
+		goto out;
+	}
+
+	mpp = find_mp_by_alias(curmp, alias);
+
+	if (!mpp) {
+		condlog(0, "%s: devmap not registered.", alias);
+		goto out;
+	}
+
+	ret = MPATH_PR_SUCCESS;
+	if (pmpp)
+		*pmpp = mpp;
+	if (palias) {
+		*palias = alias;
+		alias = NULL;
+	}
+out:
+	free(alias);
+	return ret;
+}
+
+int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
+				   int fd, int rq_servact,
+				   struct prin_resp *resp, int noisy)
+{
+	struct multipath *mpp;
+	int ret;
+
+	ret = mpath_get_map(curmp, pathvec, fd, NULL, &mpp);
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+
+	ret = mpath_prin_activepath(mpp, rq_servact, resp, noisy);
+
+	return ret;
+}
+
+static void *mpath_prout_pthread_fn(void *p)
+{
+	int ret;
+	struct prout_param * param = (struct prout_param *)p;
+
+	ret = prout_do_scsi_ioctl( param->dev,param->rq_servact, param->rq_scope,
+			param->rq_type, param->paramp, param->noisy);
+	param->status = ret;
+	pthread_exit(NULL);
+}
+
+static int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
+			   unsigned int rq_type,
+			   struct prout_param_descriptor * paramp, int noisy)
+{
+
+	int i, j, k;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	int rollback = 0;
+	int active_pathcount=0;
+	int rc;
+	int count=0;
+	int status = MPATH_PR_SUCCESS;
+	int all_tg_pt;
+	uint64_t sa_key = 0;
+
+	if (!mpp)
+		return MPATH_PR_DMMP_ERROR;
+
+	all_tg_pt = (mpp->all_tg_pt == ALL_TG_PT_ON ||
+		     paramp->sa_flags & MPATH_F_ALL_TG_PT_MASK);
+	active_pathcount = count_active_paths(mpp);
+
+	if (active_pathcount == 0) {
+		condlog (0, "%s: no path available", mpp->wwid);
+		return MPATH_PR_DMMP_ERROR;
+	}
+
+	struct threadinfo thread[active_pathcount];
+	int hosts[active_pathcount];
+
+	memset(thread, 0, sizeof(thread));
+
+	/* init thread parameter */
+	for (i =0; i< active_pathcount; i++){
+		hosts[i] = -1;
+		thread[i].param.rq_servact = rq_servact;
+		thread[i].param.rq_scope = rq_scope;
+		thread[i].param.rq_type = rq_type;
+		thread[i].param.paramp = paramp;
+		thread[i].param.noisy = noisy;
+		thread[i].param.status = MPATH_PR_SKIP;
+
+		condlog (3, "THREAD ID [%d] INFO]", i);
+		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
+		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope);
+		condlog (3, "rq_type=%d ", thread[i].param.rq_type);
+		condlog (3, "rkey=");
+		condlog (3, "paramp->sa_flags =%02x ",
+			 thread[i].param.paramp->sa_flags);
+		condlog (3, "noisy=%d ", thread[i].param.noisy);
+		condlog (3, "status=%d ", thread[i].param.status);
+	}
+
+	pthread_attr_t attr;
+	pthread_attr_init(&attr);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog (1, "%s: %s path not up. Skip.", mpp->wwid, pp->dev);
+				continue;
+			}
+			if (all_tg_pt && pp->sg_id.host_no != -1) {
+				for (k = 0; k < count; k++) {
+					if (pp->sg_id.host_no == hosts[k]) {
+						condlog(3, "%s: %s host %d matches skip.", pp->wwid, pp->dev, pp->sg_id.host_no);
+						break;
+					}
+				}
+				if (k < count)
+					continue;
+			}
+			strlcpy(thread[count].param.dev, pp->dev,
+				FILE_NAME_SIZE);
+
+			if (count && (thread[count].param.paramp->sa_flags & MPATH_F_SPEC_I_PT_MASK)){
+				/*
+				 * Clearing SPEC_I_PT as transportids are already registered by now.
+				 */
+				thread[count].param.paramp->sa_flags &= (~MPATH_F_SPEC_I_PT_MASK);
+			}
+
+			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
+
+			rc = pthread_create(&thread[count].id, &attr, mpath_prout_pthread_fn, (void *)(&thread[count].param));
+			if (rc){
+				condlog (0, "%s: failed to create thread %d", mpp->wwid, rc);
+				thread[count].param.status = MPATH_PR_THREAD_ERROR;
+			}
+			else
+				hosts[count] = pp->sg_id.host_no;
+			count = count + 1;
+		}
+	}
+	for( i=0; i < count ; i++){
+		if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+			rc = pthread_join(thread[i].id, NULL);
+			if (rc){
+				condlog (0, "%s: Thread[%d] failed to join thread %d", mpp->wwid, i, rc);
+			}
+		}
+		if (!rollback && (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)){
+			rollback = 1;
+			sa_key = get_unaligned_be64(&paramp->sa_key[0]);
+			status = MPATH_PR_RESERV_CONFLICT ;
+		}
+		if (!rollback && (status == MPATH_PR_SUCCESS)){
+			status = thread[i].param.status;
+		}
+	}
+	if (rollback && ((rq_servact == MPATH_PROUT_REG_SA) && sa_key != 0 )){
+		condlog (3, "%s: ERROR: initiating pr out rollback", mpp->wwid);
+		memcpy(&paramp->key, &paramp->sa_key, 8);
+		memset(&paramp->sa_key, 0, 8);
+		for( i=0 ; i < count ; i++){
+			if(thread[i].param.status == MPATH_PR_SUCCESS) {
+				rc = pthread_create(&thread[i].id, &attr, mpath_prout_pthread_fn,
+						(void *)(&thread[i].param));
+				if (rc){
+					condlog (0, "%s: failed to create thread for rollback. %d",  mpp->wwid, rc);
+					thread[i].param.status = MPATH_PR_THREAD_ERROR;
+				}
+			} else
+				thread[i].param.status = MPATH_PR_SKIP;
+		}
+		for(i=0; i < count ; i++){
+			if (thread[i].param.status != MPATH_PR_SKIP &&
+			    thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+				rc = pthread_join(thread[i].id, NULL);
+				if (rc){
+					condlog (3, "%s: failed to join thread while rolling back %d",
+						 mpp->wwid, i);
+				}
+			}
+		}
+	}
+
+	pthread_attr_destroy(&attr);
+	return (status);
+}
+
+static int send_prout_activepath(char *dev, int rq_servact, int rq_scope,
+				 unsigned int rq_type,
+				 struct prout_param_descriptor * paramp, int noisy)
+{
+	struct prout_param param;
+	param.rq_servact = rq_servact;
+	param.rq_scope  = rq_scope;
+	param.rq_type   = rq_type;
+	param.paramp    = paramp;
+	param.noisy = noisy;
+	param.status = -1;
+
+	pthread_t thread;
+	pthread_attr_t attr;
+	int rc;
+
+	memset(&thread, 0, sizeof(thread));
+	strlcpy(param.dev, dev, FILE_NAME_SIZE);
+	/* Initialize and set thread joinable attribute */
+	pthread_attr_init(&attr);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
+
+	rc = pthread_create(&thread, &attr, mpath_prout_pthread_fn, (void *)(&param));
+	if (rc){
+		condlog (3, "%s: failed to create thread %d", dev, rc);
+		return MPATH_PR_THREAD_ERROR;
+	}
+	/* Free attribute and wait for the other threads */
+	pthread_attr_destroy(&attr);
+	rc = pthread_join(thread, NULL);
+
+	return (param.status);
+}
+
+static int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
+			      unsigned int rq_type,
+			      struct prout_param_descriptor* paramp, int noisy)
+{
+	int i,j, ret;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog (1, "%s: %s path not up. Skip",
+					 mpp->wwid, pp->dev);
+				continue;
+			}
+
+			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
+			ret = send_prout_activepath(pp->dev, rq_servact,
+						    rq_scope, rq_type,
+						    paramp, noisy);
+			return ret ;
+		}
+	}
+	condlog (0, "%s: no path available", mpp->wwid);
+	return MPATH_PR_DMMP_ERROR;
+}
+
+static int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
+			   unsigned int rq_type,
+			   struct prout_param_descriptor * paramp, int noisy)
+{
+	int i, j;
+	int num = 0;
+	struct pathgroup *pgp = NULL;
+	struct path *pp = NULL;
+	int active_pathcount = 0;
+	pthread_attr_t attr;
+	int rc, found = 0;
+	int count = 0;
+	int status = MPATH_PR_SUCCESS;
+	struct prin_resp resp;
+	struct prout_param_descriptor *pamp;
+	struct prin_resp *pr_buff;
+	int length;
+	struct transportid *pptr;
+
+	if (!mpp)
+		return MPATH_PR_DMMP_ERROR;
+
+	active_pathcount = count_active_paths(mpp);
+
+	if (active_pathcount == 0) {
+		condlog (0, "%s: no path available", mpp->wwid);
+		return MPATH_PR_DMMP_ERROR;
+	}
+
+	struct threadinfo thread[active_pathcount];
+	memset(thread, 0, sizeof(thread));
+	for (i = 0; i < active_pathcount; i++){
+		thread[i].param.rq_servact = rq_servact;
+		thread[i].param.rq_scope = rq_scope;
+		thread[i].param.rq_type = rq_type;
+		thread[i].param.paramp = paramp;
+		thread[i].param.noisy = noisy;
+		thread[i].param.status = MPATH_PR_SKIP;
+
+		condlog (3, " path count = %d", i);
+		condlog (3, "rq_servact=%d ", thread[i].param.rq_servact);
+		condlog (3, "rq_scope=%d ", thread[i].param.rq_scope);
+		condlog (3, "rq_type=%d ", thread[i].param.rq_type);
+		condlog (3, "noisy=%d ", thread[i].param.noisy);
+		condlog (3, "status=%d ", thread[i].param.status);
+	}
+
+	pthread_attr_init (&attr);
+	pthread_attr_setdetachstate (&attr, PTHREAD_CREATE_JOINABLE);
+
+	vector_foreach_slot (mpp->pg, pgp, j){
+		vector_foreach_slot (pgp->paths, pp, i){
+			if (!((pp->state == PATH_UP) || (pp->state == PATH_GHOST))){
+				condlog (1, "%s: %s path not up.", mpp->wwid, pp->dev);
+				continue;
+			}
+
+			strlcpy(thread[count].param.dev, pp->dev,
+				FILE_NAME_SIZE);
+			condlog (3, "%s: sending pr out command to %s", mpp->wwid, pp->dev);
+			rc = pthread_create (&thread[count].id, &attr, mpath_prout_pthread_fn,
+					(void *) (&thread[count].param));
+			if (rc) {
+				condlog (0, "%s: failed to create thread. %d",  mpp->wwid, rc);
+				thread[count].param.status = MPATH_PR_THREAD_ERROR;
+			}
+			count = count + 1;
+		}
+	}
+	pthread_attr_destroy (&attr);
+	for (i = 0; i < count; i++){
+		if (thread[i].param.status != MPATH_PR_THREAD_ERROR) {
+			rc = pthread_join (thread[i].id, NULL);
+			if (rc){
+				condlog (1, "%s: failed to join thread.  %d",  mpp->wwid,  rc);
+			}
+		}
+	}
+
+	for (i = 0; i < count; i++){
+		/*  check thread status here and return the status */
+
+		if (thread[i].param.status == MPATH_PR_RESERV_CONFLICT)
+			status = MPATH_PR_RESERV_CONFLICT;
+		else if (status == MPATH_PR_SUCCESS
+				&& thread[i].param.status != MPATH_PR_RESERV_CONFLICT)
+			status = thread[i].param.status;
+	}
+
+	status = mpath_prin_activepath (mpp, MPATH_PRIN_RRES_SA, &resp, noisy);
+	if (status != MPATH_PR_SUCCESS){
+		condlog (0, "%s: pr in read reservation command failed.", mpp->wwid);
+		return MPATH_PR_OTHER;
+	}
+
+	num = resp.prin_descriptor.prin_readresv.additional_length / 8;
+	if (num == 0){
+		condlog (2, "%s: Path holding reservation is released.", mpp->wwid);
+		return MPATH_PR_SUCCESS;
+	}
+	condlog (2, "%s: Path holding reservation is not avialable.", mpp->wwid);
+
+	pr_buff =  mpath_alloc_prin_response(MPATH_PRIN_RFSTAT_SA);
+	if (!pr_buff){
+		condlog (0, "%s: failed to  alloc pr in response buffer.", mpp->wwid);
+		return MPATH_PR_OTHER;
+	}
+
+	status = mpath_prin_activepath (mpp, MPATH_PRIN_RFSTAT_SA, pr_buff, noisy);
+
+	if (status != MPATH_PR_SUCCESS){
+		condlog (0,  "%s: pr in read full status command failed.",  mpp->wwid);
+		goto out;
+	}
+
+	num = pr_buff->prin_descriptor.prin_readfd.number_of_descriptor;
+	if (0 == num){
+		goto out;
+	}
+	length = sizeof (struct prout_param_descriptor) + (sizeof (struct transportid *));
+
+	pamp = (struct prout_param_descriptor *)malloc (length);
+	if (!pamp){
+		condlog (0, "%s: failed to alloc pr out parameter.", mpp->wwid);
+		goto out1;
+	}
+
+	memset(pamp, 0, length);
+
+	pamp->trnptid_list[0] = (struct transportid *) malloc (sizeof (struct transportid));
+	if (!pamp->trnptid_list[0]){
+		condlog (0, "%s: failed to alloc pr out transportid.", mpp->wwid);
+		goto out1;
+	}
+
+	if (get_be64(mpp->reservation_key)){
+		memcpy (pamp->key, &mpp->reservation_key, 8);
+		condlog (3, "%s: reservation key set.", mpp->wwid);
+	}
+
+	status = mpath_prout_common (mpp, MPATH_PROUT_CLEAR_SA,
+				     rq_scope, rq_type, pamp, noisy);
+
+	if (status) {
+		condlog(0, "%s: failed to send CLEAR_SA", mpp->wwid);
+		goto out1;
+	}
+
+	pamp->num_transportid = 1;
+	pptr=pamp->trnptid_list[0];
+
+	for (i = 0; i < num; i++){
+		if (get_be64(mpp->reservation_key) &&
+			memcmp(pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key,
+			       &mpp->reservation_key, 8)){
+			/*register with tarnsport id*/
+			memset(pamp, 0, length);
+			pamp->trnptid_list[0] = pptr;
+			memset (pamp->trnptid_list[0], 0, sizeof (struct transportid));
+			memcpy (pamp->sa_key,
+					pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
+			pamp->sa_flags = MPATH_F_SPEC_I_PT_MASK;
+			pamp->num_transportid = 1;
+
+			memcpy (pamp->trnptid_list[0],
+					&pr_buff->prin_descriptor.prin_readfd.descriptors[i]->trnptid,
+					sizeof (struct transportid));
+			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
+					pamp, noisy);
+
+			pamp->sa_flags = 0;
+			memcpy (pamp->key, pr_buff->prin_descriptor.prin_readfd.descriptors[i]->key, 8);
+			memset (pamp->sa_key, 0, 8);
+			pamp->num_transportid = 0;
+			status = mpath_prout_common (mpp, MPATH_PROUT_REG_SA, 0, rq_type,
+					pamp, noisy);
+		}
+		else
+		{
+			if (get_be64(mpp->reservation_key))
+				found = 1;
+		}
+
+
+	}
+
+	if (found){
+		memset (pamp, 0, length);
+		memcpy (pamp->sa_key, &mpp->reservation_key, 8);
+		memset (pamp->key, 0, 8);
+		status = mpath_prout_reg(mpp, MPATH_PROUT_REG_SA, rq_scope, rq_type, pamp, noisy);
+	}
+
+
+	free(pptr);
+out1:
+	free (pamp);
+out:
+	free (pr_buff);
+	return (status);
+}
+
+int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
+				    int rq_servact, int rq_scope, unsigned int rq_type,
+				    struct prout_param_descriptor *paramp, int noisy)
+{
+	struct multipath *mpp;
+	char *alias;
+	int ret;
+	uint64_t prkey;
+	struct config *conf;
+
+	ret = mpath_get_map(curmp, pathvec, fd, &alias, &mpp);
+	if (ret != MPATH_PR_SUCCESS)
+		return ret;
+
+	conf = get_multipath_config();
+	select_reservation_key(conf, mpp);
+	select_all_tg_pt(conf, mpp);
+	put_multipath_config(conf);
+
+	memcpy(&prkey, paramp->sa_key, 8);
+	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
+	    (rq_servact == MPATH_PROUT_REG_IGN_SA ||
+	     (rq_servact == MPATH_PROUT_REG_SA &&
+	      (!get_be64(mpp->reservation_key) ||
+	       memcmp(paramp->key, &mpp->reservation_key, 8) == 0)))) {
+		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
+		if (update_prkey_flags(alias, get_be64(mpp->reservation_key),
+				       paramp->sa_flags)) {
+			condlog(0, "%s: failed to set prkey for multipathd.",
+				alias);
+			ret = MPATH_PR_DMMP_ERROR;
+			goto out1;
+		}
+	}
+
+	if (memcmp(paramp->key, &mpp->reservation_key, 8) &&
+	    memcmp(paramp->sa_key, &mpp->reservation_key, 8) &&
+	    (prkey || rq_servact != MPATH_PROUT_REG_IGN_SA)) {
+		condlog(0, "%s: configured reservation key doesn't match: 0x%" PRIx64, alias, get_be64(mpp->reservation_key));
+		ret = MPATH_PR_SYNTAX_ERROR;
+		goto out1;
+	}
+
+	switch(rq_servact)
+	{
+	case MPATH_PROUT_REG_SA:
+	case MPATH_PROUT_REG_IGN_SA:
+		ret= mpath_prout_reg(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		break;
+	case MPATH_PROUT_RES_SA :
+	case MPATH_PROUT_PREE_SA :
+	case MPATH_PROUT_PREE_AB_SA :
+	case MPATH_PROUT_CLEAR_SA:
+		ret = mpath_prout_common(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		break;
+	case MPATH_PROUT_REL_SA:
+		ret = mpath_prout_rel(mpp, rq_servact, rq_scope, rq_type, paramp, noisy);
+		break;
+	default:
+		ret = MPATH_PR_OTHER;
+		goto out1;
+	}
+
+	if ((ret == MPATH_PR_SUCCESS) && ((rq_servact == MPATH_PROUT_REG_SA) ||
+				(rq_servact ==  MPATH_PROUT_REG_IGN_SA)))
+	{
+		if (prkey == 0) {
+			update_prflag(alias, 0);
+			update_prkey(alias, 0);
+		} else
+			update_prflag(alias, 1);
+	} else if ((ret == MPATH_PR_SUCCESS) && (rq_servact == MPATH_PROUT_CLEAR_SA)) {
+		update_prflag(alias, 0);
+		update_prkey(alias, 0);
+	}
+out1:
+	free(alias);
+	return ret;
+}
+
+int update_map_pr(struct multipath *mpp)
+{
+	int noisy=0;
+	struct prin_resp *resp;
+	unsigned int i;
+	int ret, isFound;
+
+	if (!get_be64(mpp->reservation_key))
+	{
+		/* Nothing to do. Assuming pr mgmt feature is disabled*/
+		condlog(4, "%s: reservation_key not set in multipath.conf",
+			mpp->alias);
+		return MPATH_PR_SUCCESS;
+	}
+
+	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
+	if (!resp)
+	{
+		condlog(0,"%s : failed to alloc resp in update_map_pr", mpp->alias);
+		return MPATH_PR_OTHER;
+	}
+	ret = mpath_prin_activepath(mpp, MPATH_PRIN_RKEY_SA, resp, noisy);
+
+	if (ret != MPATH_PR_SUCCESS )
+	{
+		condlog(0,"%s : pr in read keys service action failed Error=%d", mpp->alias, ret);
+		free(resp);
+		return  ret;
+	}
+
+	if (resp->prin_descriptor.prin_readkeys.additional_length == 0 )
+	{
+		condlog(3,"%s: No key found. Device may not be registered. ", mpp->alias);
+		free(resp);
+		return MPATH_PR_SUCCESS;
+	}
+
+	condlog(2, "%s: Multipath  reservation_key: 0x%" PRIx64 " ", mpp->alias,
+		get_be64(mpp->reservation_key));
+
+	isFound =0;
+	for (i = 0; i < resp->prin_descriptor.prin_readkeys.additional_length/8; i++ )
+	{
+		condlog(2, "%s: PR IN READKEYS[%d]  reservation key:", mpp->alias, i);
+		dumpHex((char *)&resp->prin_descriptor.prin_readkeys.key_list[i*8], 8 , 1);
+
+		if (!memcmp(&mpp->reservation_key, &resp->prin_descriptor.prin_readkeys.key_list[i*8], 8))
+		{
+			condlog(2, "%s: reservation key found in pr in readkeys response", mpp->alias);
+			isFound =1;
+		}
+	}
+
+	if (isFound)
+	{
+		mpp->prflag = 1;
+		condlog(2, "%s: prflag flag set.", mpp->alias );
+	}
+
+	free(resp);
+	return MPATH_PR_SUCCESS;
+}
diff --git a/libmpathpersist/mpath_persist_int.h b/libmpathpersist/mpath_persist_int.h
new file mode 100644
index 0000000..58d9c33
--- /dev/null
+++ b/libmpathpersist/mpath_persist_int.h
@@ -0,0 +1,17 @@
+#ifndef _MPATH_PERSIST_INT_H
+#define _MPATH_PERSIST_INT_H
+
+struct multipath;
+
+void * mpath_alloc_prin_response(int prin_sa);
+int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
+				   int fd, int rq_servact,
+				   struct prin_resp *resp, int noisy);
+void *mpath_alloc_prin_response(int prin_sa);
+int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
+				    int rq_servact, int rq_scope,
+				    unsigned int rq_type,
+				    struct prout_param_descriptor *paramp,
+				    int noisy);
+
+#endif /* _MPATH_PERSIST_INT_H */
diff --git a/libmpathpersist/mpathpr.h b/libmpathpersist/mpathpr.h
index 5ea8cd6..59411e6 100644
--- a/libmpathpersist/mpathpr.h
+++ b/libmpathpersist/mpathpr.h
@@ -31,20 +31,8 @@ int prin_do_scsi_ioctl(char * dev, int rq_servact, struct prin_resp * resp, int
 int prout_do_scsi_ioctl( char * dev, int rq_servact, int rq_scope,
 		unsigned int rq_type, struct prout_param_descriptor *paramp, int noisy);
 void * _mpath_pr_update (void *arg);
-int mpath_send_prin_activepath (char * dev, int rq_servact, struct prin_resp * resp, int noisy);
-int get_mpvec (vector curmp, vector pathvec, char * refwwid);
-void * mpath_prout_pthread_fn(void *p);
 void dumpHex(const char* , int len, int no_ascii);
 
-int mpath_prout_reg(struct multipath *mpp,int rq_servact, int rq_scope,
-	unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
-int mpath_prout_common(struct multipath *mpp,int rq_servact, int rq_scope,
-	unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
-int mpath_prout_rel(struct multipath *mpp,int rq_servact, int rq_scope,
-	unsigned int rq_type,  struct prout_param_descriptor * paramp, int noisy);
-int send_prout_activepath(char * dev, int rq_servact, int rq_scope,
-	unsigned int rq_type,   struct prout_param_descriptor * paramp, int noisy);
-
 int update_prflag(char *mapname, int set);
 int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t sa_flags);
 #define update_prkey(mapname, prkey) update_prkey_flags(mapname, prkey, 0)
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index 14245cc..4bdd55c 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -10,6 +10,7 @@
 #include <getopt.h>
 #include <libudev.h>
 #include "mpath_persist.h"
+#include "mpath_persist_int.h"
 #include "main.h"
 #include "debug.h"
 #include <pthread.h>
diff --git a/multipathd/main.c b/multipathd/main.c
index 7a57a79..1db34ac 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -66,6 +66,7 @@
 
 #include "mpath_cmd.h"
 #include "mpath_persist.h"
+#include "mpath_persist_int.h"
 
 #include "prioritizers/alua_rtpg.h"
 
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

