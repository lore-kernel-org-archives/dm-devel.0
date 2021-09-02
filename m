Return-Path: <SRS0=Tx5l=NY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AD4C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:03:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EBB2B60F12
	for <dm-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:03:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EBB2B60F12
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1630620196;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Fk4r6J4P+ByDH0PGpc6NAPL1gn3a/hMimeKd5iNxLvw=;
	b=XjanLArL0W3zwfNq+YHK/dr4dN9vFcvbnPy1OVZXUNV3ZiMEwro518i0A25/FCKFNqJm5p
	jItHZxlVmQRdXo6xm7tYrOBiLG2P4ArwtQ8JVtVEZyFo3Tf7edaqD4DdGX9+0k0FLDwEq3
	DNb+jZXmieTJLQyU4TVoaJzF7ApWy0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-3iShAxGQOXqEQelpLWAkZw-1; Thu, 02 Sep 2021 18:03:14 -0400
X-MC-Unique: 3iShAxGQOXqEQelpLWAkZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47CE6100E407;
	Thu,  2 Sep 2021 22:03:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28C9A17A98;
	Thu,  2 Sep 2021 22:03:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C62631800FDD;
	Thu,  2 Sep 2021 22:03:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 182LvwrD013346 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Sep 2021 17:57:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6B25669322; Thu,  2 Sep 2021 21:57:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 054426A8FF;
	Thu,  2 Sep 2021 21:57:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 182Lvthh012303; 
	Thu, 2 Sep 2021 16:57:55 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 182LvsdK012302;
	Thu, 2 Sep 2021 16:57:54 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu,  2 Sep 2021 16:57:46 -0500
Message-Id: <1630619869-12251-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 3/6] multipath: print warning if multipathd is
	not running.
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If multipath notices that multipath devices exist or were created, and
multipathd is not running, it now prints a warning message, so users are
notified of the issue.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c          |  3 ++-
 libmultipath/configure.h          |  1 +
 libmultipath/libmultipath.version |  5 +++++
 multipath/main.c                  | 14 ++++++++++++--
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 12278640..2f417914 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1082,7 +1082,8 @@ deadmap (struct multipath * mpp)
 	return 1; /* dead */
 }
 
-int check_daemon(void)
+extern int
+check_daemon(void)
 {
 	int fd;
 	char *reply;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 92a5aba6..efe18b7d 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -59,3 +59,4 @@ struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
 void trigger_paths_udev_change(struct multipath *mpp, bool is_mpath);
 void trigger_partitions_udev_change(struct udev_device *dev, const char *action,
 				    int len);
+int check_daemon(void);
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 1d84d97c..7b48265f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -285,3 +285,8 @@ global:
 	print_strbuf;
 	truncate_strbuf;
 } LIBMULTIPATH_8.0.0;
+
+LIBMULTIPATH_8.2.0 {
+global:
+	check_daemon;
+} LIBMULTIPATH_8.1.0;
diff --git a/multipath/main.c b/multipath/main.c
index 8fc0e15f..6c70760f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -456,6 +456,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 {
 	vector curmp = NULL;
 	vector pathvec = NULL;
+	vector newmp = NULL;
 	int r = RTVL_FAIL, rc;
 	int di_flag = 0;
 	char * refwwid = NULL;
@@ -466,8 +467,9 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	 */
 	curmp = vector_alloc();
 	pathvec = vector_alloc();
+	newmp = vector_alloc();
 
-	if (!curmp || !pathvec) {
+	if (!curmp || !pathvec || !newmp) {
 		condlog(0, "can not allocate memory");
 		goto out;
 	}
@@ -569,16 +571,24 @@ configure (struct config *conf, enum mpath_cmds cmd,
 	/*
 	 * core logic entry point
 	 */
-	rc = coalesce_paths(&vecs, NULL, refwwid,
+	rc = coalesce_paths(&vecs, newmp, refwwid,
 			   conf->force_reload, cmd);
 	r = rc == CP_RETRY ? RTVL_RETRY : rc == CP_OK ? RTVL_OK : RTVL_FAIL;
 
 out:
+	if (r == RTVL_OK &&
+	    (cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG ||
+	     cmd == CMD_CREATE) &&
+	    (VECTOR_SIZE(curmp) > 0 || VECTOR_SIZE(newmp) > 0) &&
+	    !check_daemon())
+		condlog(2, "Warning: multipath devices exist, but multipathd service is not running");
+
 	if (refwwid)
 		FREE(refwwid);
 
 	free_multipathvec(curmp, KEEP_PATHS);
 	vecs.mpvec = NULL;
+	free_multipathvec(newmp, KEEP_PATHS);
 	free_pathvec(pathvec, FREE_PATHS);
 	vecs.pathvec = NULL;
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

