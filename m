Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4E4C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 02:42:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D496221FF
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 02:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D496221FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-SgN6iGZaPbuqZbEqvAAbAg-1; Sun, 01 Nov 2020 21:41:57 -0500
X-MC-Unique: SgN6iGZaPbuqZbEqvAAbAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E8861084D62;
	Mon,  2 Nov 2020 02:41:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1129319C78;
	Mon,  2 Nov 2020 02:41:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BBD0B1800B72;
	Mon,  2 Nov 2020 02:41:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A22fj5B024648 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 21:41:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C523D2156A54; Mon,  2 Nov 2020 02:41:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C02A32156A53
	for <dm-devel@redhat.com>; Mon,  2 Nov 2020 02:41:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB1E9858294
	for <dm-devel@redhat.com>; Mon,  2 Nov 2020 02:41:41 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-364-8Cs5dgJ8ODmO_WconiuM2g-1; Sun, 01 Nov 2020 21:41:36 -0500
X-MC-Unique: 8Cs5dgJ8ODmO_WconiuM2g-1
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CPccV1VlJzhfZD;
	Mon,  2 Nov 2020 10:41:30 +0800 (CST)
Received: from [10.174.178.210] (10.174.178.210) by
	DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server
	id 14.3.487.0; Mon, 2 Nov 2020 10:41:22 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <fd96f23b-63ff-4933-b112-667e5adce0b5@huawei.com>
Date: Mon, 2 Nov 2020 10:41:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.178.210]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH v3] libmultipath: fix memory leaks in
	coalesce_paths
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When multipath -F are executed first and multipath -v2 or
-d are executed later, asan will warn memory leaks. The
reason is that the mpp allocated in coalesce_paths isn't
freed. Here we use newmp to store mpp. If mpvec is NULL,
we free newmp at the end of the func.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/configure.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 6fb477fc..649002c3 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1132,7 +1132,7 @@ out:
  * FORCE_RELOAD_WEAK: existing maps are compared to the current conf and only
  * reloaded in DM if there's a difference. This is useful during startup.
  */
-int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
+int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 		    int force_reload, enum mpath_cmds cmd)
 {
 	int ret = CP_FAIL;
@@ -1144,10 +1144,20 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 	struct path * pp2;
 	vector curmp = vecs->mpvec;
 	vector pathvec = vecs->pathvec;
+	vector newmp;
 	struct config *conf;
 	int allow_queueing;
 	struct bitfield *size_mismatch_seen;

+	if (mpvec)
+		newmp = mpvec;
+	else
+		newmp = vector_alloc();
+	if (!newmp) {
+		condlog(0, "can not allocate newmp");
+		return ret;
+	}
+
 	/* ignore refwwid if it's empty */
 	if (refwwid && !strlen(refwwid))
 		refwwid = NULL;
@@ -1270,8 +1280,14 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 				goto out;
 			}
 		}
-		if (r == DOMAP_DRY)
+		if (r == DOMAP_DRY) {
+			if (!vector_alloc_slot(newmp)) {
+				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
+				goto out;
+			}
+			vector_set_slot(newmp, mpp);
 			continue;
+		}

 		if (r == DOMAP_EXIST && mpp->action == ACT_NOTHING &&
 		    force_reload == FORCE_RELOAD_WEAK)
@@ -1307,22 +1323,22 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 			print_multipath_topology(mpp, verbosity);
 		}

-		if (newmp) {
-			if (mpp->action != ACT_REJECT) {
-				if (!vector_alloc_slot(newmp))
-					goto out;
-				vector_set_slot(newmp, mpp);
+		if (mpp->action != ACT_REJECT) {
+			if (!vector_alloc_slot(newmp)) {
+				remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
+				goto out;
 			}
-			else
-				remove_map(mpp, vecs->pathvec, vecs->mpvec,
-					   KEEP_VEC);
+			vector_set_slot(newmp, mpp);
 		}
+		else
+			remove_map(mpp, vecs->pathvec, vecs->mpvec,
+				   KEEP_VEC);
 	}
 	/*
 	 * Flush maps with only dead paths (ie not in sysfs)
 	 * Keep maps with only failed paths
 	 */
-	if (newmp) {
+	if (mpvec) {
 		vector_foreach_slot (newmp, mpp, i) {
 			char alias[WWID_SIZE];

@@ -1345,6 +1361,8 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
 	ret = CP_OK;
 out:
 	free(size_mismatch_seen);
+	if (!mpvec)
+		free_multipathvec(newmp, KEEP_PATHS);
 	return ret;
 }

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

