Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE90C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 06:24:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 55035207C4
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 06:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55035207C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-nu-VrQfHOmOvjhddwsrc_g-1; Fri, 16 Oct 2020 02:24:37 -0400
X-MC-Unique: nu-VrQfHOmOvjhddwsrc_g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00381186DD29;
	Fri, 16 Oct 2020 06:24:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C844676672;
	Fri, 16 Oct 2020 06:24:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ACB4A44A47;
	Fri, 16 Oct 2020 06:24:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09G6OMW9021814 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 02:24:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4F6DA13D2CE8; Fri, 16 Oct 2020 06:24:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BA1D13D2CE2
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 06:24:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E902858295
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 06:24:20 +0000 (UTC)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-102-zKcvwMB-Pj-HzfXcxNsD5w-1; Fri, 16 Oct 2020 02:24:17 -0400
X-MC-Unique: zKcvwMB-Pj-HzfXcxNsD5w-1
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
	by Forcepoint Email with ESMTP id 326EAA57381AFF5F5DA0;
	Fri, 16 Oct 2020 14:24:07 +0800 (CST)
Received: from [10.174.178.210] (10.174.178.210) by
	DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server
	id 14.3.487.0; Fri, 16 Oct 2020 14:23:59 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <6169bcfa-343d-adc8-a458-5e5c46aed737@huawei.com>
Date: Fri, 16 Oct 2020 14:23:58 +0800
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH] libmultipath: fix memory leaks in coalesce_paths
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When multipath -F are executed firstly and multipath -v2 or
-d are executed later, asan will warn memory leaks. The
reason is that the mpp allocated in coalesce_paths isn't
freed. Here we add newmp in configure(multipath) to store
mpp and free it.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Linfeilong <linfeilong@huawei.com>
---
 libmultipath/configure.c | 12 ++++++++++--
 multipath/main.c         |  7 +++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 6fb477fc..fb2c3f73 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1270,8 +1270,14 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
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
@@ -1309,8 +1315,10 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,

 		if (newmp) {
 			if (mpp->action != ACT_REJECT) {
-				if (!vector_alloc_slot(newmp))
+				if (!vector_alloc_slot(newmp)) {
+					remove_map(mpp, vecs->pathvec, vecs->mpvec, KEEP_VEC);
 					goto out;
+				}
 				vector_set_slot(newmp, mpp);
 			}
 			else
diff --git a/multipath/main.c b/multipath/main.c
index 9e920d89..5f5b435a 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -472,6 +472,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 {
 	vector curmp = NULL;
 	vector pathvec = NULL;
+	vector newmp = NULL;
 	struct vectors vecs;
 	int r = RTVL_FAIL, rc;
 	int di_flag = 0;
@@ -483,8 +484,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	 */
 	curmp = vector_alloc();
 	pathvec = vector_alloc();
+	newmp = vector_alloc();

-	if (!curmp || !pathvec) {
+	if (!curmp || !pathvec || !newmp) {
 		condlog(0, "can not allocate memory");
 		goto out;
 	}
@@ -586,7 +588,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	/*
 	 * core logic entry point
 	 */
-	rc = coalesce_paths(&vecs, NULL, refwwid,
+	rc = coalesce_paths(&vecs, newmp, refwwid,
 			   conf->force_reload, cmd);
 	r = rc == CP_RETRY ? RTVL_RETRY : rc == CP_OK ? RTVL_OK : RTVL_FAIL;

@@ -595,6 +597,7 @@ out:
 		FREE(refwwid);

 	free_multipathvec(curmp, KEEP_PATHS);
+	free_multipathvec(newmp, KEEP_PATHS);
 	free_pathvec(pathvec, FREE_PATHS);

 	return r;
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

