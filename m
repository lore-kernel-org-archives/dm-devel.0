Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3255EC433DF
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88CBB207F7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88CBB207F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-gDvIckowOFGbTO5apZzK3g-1; Fri, 16 Oct 2020 06:44:01 -0400
X-MC-Unique: gDvIckowOFGbTO5apZzK3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB627107B47B;
	Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF97C5C1D7;
	Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 974A2181A870;
	Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhqM9020140 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7C0832156A38; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 765FE2166B28
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C794811E79
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-491-9oJjohfEMTeFkedWRQMfig-1;
	Fri, 16 Oct 2020 06:43:49 -0400
X-MC-Unique: 9oJjohfEMTeFkedWRQMfig-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 14D37AF43;
	Fri, 16 Oct 2020 10:43:47 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:17 +0200
Message-Id: <20201016104329.8337-10-mwilck@suse.com>
In-Reply-To: <20201016104329.8337-1-mwilck@suse.com>
References: <20201016104329.8337-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhqM9020140
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 09/21] multipath-tools: don't call
	dm_lib_release() any more
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The purpose of dm_lib_release() is to release stacked device node
operations in libdevmapper. This is functionality we don't need and
use any more, as we rely on udev to set up device nodes and symlinks.

We always set DM_UDEV_DISABLE_LIBRARY_FALLBACK when we run dm tasks.
In the standard CREATE and REMOVE cases, libdevmapper doesn't
stack any operations if this flag is set. The only exceptions are

 a) RESUME operations with DM_ADD_NODE_ON_RESUME set. This happens
implicity when we create new maps
 b) RENAME operations

In both cases, we call dm_udev_wait() after the libdm operation, which
calls update_devs() and thus has the same effect as dm_lib_release(),
cleaning out stacked operations.

OTOH, dm_lib_releases() accesses static variables in libdevmapper, so
calling it might be racy.

Drop the calls to dm_lib_release().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c                 |  1 -
 libmpathpersist/mpath_persist.c |  1 -
 multipath/main.c                |  1 -
 multipathd/cli_handlers.c       |  2 --
 multipathd/main.c               | 15 ++-------------
 5 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 4a0aae9..6a7933f 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -681,7 +681,6 @@ main(int argc, char **argv){
 	}
 
 end:
-	dm_lib_release();
 	dm_lib_exit();
 
 	return r;
diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 4b3f3e0..cc4a088 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -56,7 +56,6 @@ mpath_lib_init (void)
 int
 mpath_lib_exit (struct config *conf)
 {
-	dm_lib_release();
 	dm_lib_exit();
 	cleanup_prio();
 	cleanup_checkers();
diff --git a/multipath/main.c b/multipath/main.c
index 9e920d8..dc4974b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -1063,7 +1063,6 @@ main (int argc, char *argv[])
 		condlog(3, "restart multipath configuration process");
 
 out:
-	dm_lib_release();
 	dm_lib_exit();
 
 	cleanup_foreign();
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 235e2a2..5463573 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -860,7 +860,6 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 				    != CP_OK)
 					condlog(2, "%s: coalesce_paths failed",
 									param);
-				dm_lib_release();
 				FREE(refwwid);
 			}
 		} /*we attempt to create device only once*/
@@ -1032,7 +1031,6 @@ cli_resize(void *v, char **reply, int *len, void *data)
 	if (resize_map(mpp, size, vecs) != 0)
 		return 1;
 
-	dm_lib_release();
 	if (setup_multipath(vecs, mpp) != 0)
 		return 1;
 	sync_map_state(mpp);
diff --git a/multipathd/main.c b/multipathd/main.c
index d1f8cc1..5cc3435 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -510,7 +510,6 @@ retry:
 		sleep(1);
 		goto retry;
 	}
-	dm_lib_release();
 
 fail:
 	if (new_map && (retries < 0 || wait_for_events(mpp, vecs))) {
@@ -611,10 +610,8 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 				vector_del_slot(ompv, i);
 				i--;
 			}
-			else {
-				dm_lib_release();
+			else
 				condlog(2, "%s devmap removed", ompp->alias);
-			}
 		} else if (reassign_maps) {
 			condlog(3, "%s: Reassign existing device-mapper"
 				" devices", ompp->alias);
@@ -660,10 +657,8 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 		}
 		return r;
 	}
-	else {
-		dm_lib_release();
+	else
 		condlog(2, "%s: map flushed", mpp->alias);
-	}
 
 	orphan_paths(vecs->pathvec, mpp, "map flushed");
 	remove_map_and_stop_waiter(mpp, vecs);
@@ -1080,7 +1075,6 @@ rescan:
 		else
 			goto fail_map;
 	}
-	dm_lib_release();
 
 	if ((mpp->action == ACT_CREATE ||
 	     (mpp->action == ACT_NOTHING && start_waiter && !mpp->waiter)) &&
@@ -1947,8 +1941,6 @@ int reload_and_sync_map(struct multipath *mpp,
 {
 	if (reload_map(vecs, mpp, refresh, 1))
 		return 1;
-
-	dm_lib_release();
 	if (setup_multipath(vecs, mpp) != 0)
 		return 2;
 	sync_map_state(mpp);
@@ -2631,8 +2623,6 @@ configure (struct vectors * vecs)
 		goto fail;
 	}
 
-	dm_lib_release();
-
 	if (should_exit())
 		goto fail;
 
@@ -3115,7 +3105,6 @@ child (__attribute__((unused)) void *param)
 	if (poll_dmevents)
 		cleanup_dmevent_waiter();
 
-	dm_lib_release();
 	dm_lib_exit();
 
 	/* We're done here */
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

