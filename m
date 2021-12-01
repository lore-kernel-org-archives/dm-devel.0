Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E6EC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 12:38:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-72Bg-KQ1Nhq2qEMH7A4xNA-1; Wed, 01 Dec 2021 07:38:00 -0500
X-MC-Unique: 72Bg-KQ1Nhq2qEMH7A4xNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14A631926DA3;
	Wed,  1 Dec 2021 12:37:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ECFD61F46C;
	Wed,  1 Dec 2021 12:37:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C77561806D03;
	Wed,  1 Dec 2021 12:37:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B1CbGew008826 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 07:37:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C6F5D51E4; Wed,  1 Dec 2021 12:37:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE53951E2
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB9061066682
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 12:37:14 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-425-ZAUg9jBvM2mh86QVnDCNWw-1; Wed, 01 Dec 2021 07:37:11 -0500
X-MC-Unique: ZAUg9jBvM2mh86QVnDCNWw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0149C1FD61;
	Wed,  1 Dec 2021 12:37:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BFA7B13FF5;
	Wed,  1 Dec 2021 12:37:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 0IvWLHVsp2GGKAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 01 Dec 2021 12:37:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  1 Dec 2021 13:36:48 +0100
Message-Id: <20211201123650.16240-20-mwilck@suse.com>
In-Reply-To: <20211201123650.16240-1-mwilck@suse.com>
References: <20211201123650.16240-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B1CbGew008826
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 19/21] libmultipath (coverity): Revert
	"setup_map: wait for pending path checkers to finish"
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

This reverts commit adf551f601596aac0774884c8a5b6b0f74721cfc.

Since 2b1fe13 ("libmultipath: allow force reload with no active paths"),
reloading maps with pending paths is no issue any more. The path checker
is going to set the correct status of the path quickly. If the paths are
down, I/O will eventually fail.

Sleeping with the vecs lock held is undesirable though, so avoid waiting
in setup_map().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 63 +---------------------------------------
 1 file changed, 1 insertion(+), 62 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7f32da2..6745976 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -43,10 +43,6 @@
 #include "sysfs.h"
 #include "io_err_stat.h"
 
-/* Time in ms to wait for pending checkers in setup_map() */
-#define WAIT_CHECKERS_PENDING_MS 10
-#define WAIT_ALL_CHECKERS_PENDING_MS 90
-
 /* group paths in pg by host adapter
  */
 int group_by_host_adapter(struct pathgroup *pgp, vector adapters)
@@ -260,42 +256,11 @@ int rr_optimize_path_order(struct pathgroup *pgp)
 	return 0;
 }
 
-static int wait_for_pending_paths(struct multipath *mpp,
-				  struct config *conf,
-				  int n_pending, int goal, int wait_ms)
-{
-	static const struct timespec millisec =
-		{ .tv_sec = 0, .tv_nsec = 1000*1000 };
-	int i, j;
-	struct path *pp;
-	struct pathgroup *pgp;
-	struct timespec ts;
-
-	do {
-		vector_foreach_slot(mpp->pg, pgp, i) {
-			vector_foreach_slot(pgp->paths, pp, j) {
-				if (pp->state != PATH_PENDING)
-					continue;
-				pp->state = get_state(pp, conf,
-						      0, PATH_PENDING);
-				if (pp->state != PATH_PENDING &&
-				    --n_pending <= goal)
-					return 0;
-			}
-		}
-		ts = millisec;
-		while (nanosleep(&ts, &ts) != 0 && errno == EINTR)
-			/* nothing */;
-	} while (--wait_ms > 0);
-
-	return n_pending;
-}
-
 int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 {
 	struct pathgroup * pgp;
 	struct config *conf;
-	int i, n_paths, marginal_pathgroups;
+	int i, marginal_pathgroups;
 	char *save_attr;
 
 	/*
@@ -394,7 +359,6 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	if (marginal_path_check_enabled(mpp))
 		start_io_err_stat_thread(vecs);
 
-	n_paths = VECTOR_SIZE(mpp->paths);
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
 	 * in mpp->paths
@@ -409,31 +373,6 @@ int setup_map(struct multipath *mpp, char **params, struct vectors *vecs)
 	if (group_paths(mpp, marginal_pathgroups))
 		return 1;
 
-	/*
-	 * If async state detection is used, see if pending state checks
-	 * have finished, to get nr_active right. We can't wait until the
-	 * checkers time out, as that may take 30s or more, and we are
-	 * holding the vecs lock.
-	 */
-	if (conf->force_sync == 0 && n_paths > 0) {
-		int n_pending = pathcount(mpp, PATH_PENDING);
-
-		if (n_pending > 0)
-			n_pending = wait_for_pending_paths(
-				mpp, conf, n_pending, 0,
-				WAIT_CHECKERS_PENDING_MS);
-		/* ALL paths pending - wait some more, but be satisfied
-		   with only some paths finished */
-		if (n_pending == n_paths)
-			n_pending = wait_for_pending_paths(
-				mpp, conf, n_pending,
-				n_paths >= 4 ? 2 : 1,
-				WAIT_ALL_CHECKERS_PENDING_MS);
-		if (n_pending > 0)
-			condlog(2, "%s: setting up map with %d/%d path checkers pending",
-				mpp->alias, n_pending, n_paths);
-	}
-
 	/*
 	 * ponders each path group and determine highest prio pg
 	 * to switch over (default to first)
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

