Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87423C4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 09:41:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD0B7223EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 09:41:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD0B7223EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-BpcnEZYHM32u1UiaaR18hA-1; Mon, 26 Oct 2020 05:41:27 -0400
X-MC-Unique: BpcnEZYHM32u1UiaaR18hA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFFDA80B730;
	Mon, 26 Oct 2020 09:41:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3A1B5B4B4;
	Mon, 26 Oct 2020 09:41:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5BD4792F2A;
	Mon, 26 Oct 2020 09:41:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09Q9PlgO001709 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 05:25:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AEC452166B27; Mon, 26 Oct 2020 09:25:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A957A2166B44
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 09:25:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11675800183
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 09:25:45 +0000 (UTC)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-80-Ncgko71eOjWwKkWO9s0_Cg-1; Mon, 26 Oct 2020 05:25:40 -0400
X-MC-Unique: Ncgko71eOjWwKkWO9s0_Cg-1
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CKTw614Ctz6xVX;
	Mon, 26 Oct 2020 17:25:42 +0800 (CST)
Received: from [10.174.178.210] (10.174.178.210) by
	DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server
	id 14.3.487.0; Mon, 26 Oct 2020 17:25:26 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <2a95503c-da40-391c-ce76-bdde19636b51@huawei.com>
Message-ID: <846ee6d8-f84b-263f-e97e-a0d2f4e82db1@huawei.com>
Date: Mon, 26 Oct 2020 17:25:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2a95503c-da40-391c-ce76-bdde19636b51@huawei.com>
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
Subject: [dm-devel] [PATCH 2/6] fix lun expansion failure when there is
	offline path
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

There are two paths for one multipath device; one path
is up and the other path is down. Expand the multipath
device in server. Scan the path size in client. It will
cause failure expansion in client. The reason:
When two different-size paths for one device pass to
kernel. Kerenl will return fail. Multipathd will try to
delete the multipath device but fail because the
device is used. Here we check the offline path; if its'
size is different with other path, delete it.

Signed-off-by: Yanfei Zhang <yanfei.zhang@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/configure.c   | 18 ++++++++++++++++++
 libmultipath/structs.c     |  1 +
 libmultipath/structs.h     |  1 +
 libmultipath/structs_vec.c |  6 ++++--
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 9d6eeba1..00c12929 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1176,6 +1176,7 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,

 	vector_foreach_slot (pathvec, pp1, k) {
 		int invalid;
+		condlog(3, "%s %s: start coalesce", pp1->dev, pp1->dev_t);
 		/* skip this path for some reason */

 		/* 1. if path has no unique id or wwid blacklisted */
@@ -1213,6 +1214,18 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
 			continue;
 		}

+		/* if path is offline */
+		if (pp1->state == PATH_DOWN) {
+			orphan_path(pp1, "skip offline path");
+			continue;
+		}
+
+		/* if path is handled before */
+		if (pp1->handled) {
+			condlog(3, "%s: skip handled path.", pp1->dev_t);
+			continue;
+		}
+
 		/*
 		 * at this point, we know we really got a new mp
 		 */
@@ -1230,10 +1243,15 @@ int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,

 		for (i = k + 1; i < VECTOR_SIZE(pathvec); i++) {
 			pp2 = VECTOR_SLOT(pathvec, i);
+			if (pp2->handled)
+				continue;

 			if (strcmp(pp1->wwid, pp2->wwid))
 				continue;

+			if (!pp2->size || pp2->state == PATH_DOWN)
+				continue;
+
 			if (!mpp->size && pp2->size)
 				mpp->size = pp2->size;

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 464596fc..e5de0a7d 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -101,6 +101,7 @@ alloc_path (void)
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
 		pp->priority = PRIO_UNDEF;
+		pp->handled = 0;
 		pp->checkint = CHECKINT_UNDEF;
 		checker_clear(&pp->checker);
 		dm_path_to_gen(pp)->ops = &dm_gen_path_ops;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 7de93d6c..022ba126 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -280,6 +280,7 @@ struct path {
 	struct checker checker;
 	struct multipath * mpp;
 	int fd;
+	int handled;
 	int initialized;
 	int retriggers;
 	unsigned int path_failures;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8895fa77..5a73d4ce 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -738,11 +738,13 @@ int verify_paths(struct multipath *mpp)
 		return 0;

 	vector_foreach_slot (mpp->paths, pp, i) {
+		pp->handled = 1;
 		/*
 		 * see if path is in sysfs
 		 */
-		if (!pp->udev || sysfs_attr_get_value(pp->udev, "dev",
-					 pp->dev_t, BLK_DEV_SIZE) < 0) {
+		if ((!pp->udev || sysfs_attr_get_value(pp->udev, "dev",
+		    pp->dev_t, BLK_DEV_SIZE) < 0) ||
+		    (pp->state == PATH_DOWN && pp->size != mpp->size)) {
 			if (pp->state != PATH_DOWN) {
 				condlog(1, "%s: removing valid path %s in state %d",
 					mpp->alias, pp->dev, pp->state);
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

