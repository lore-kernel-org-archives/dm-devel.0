Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7241C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8021861B62
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8021861B62
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637184101;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OgR+pjUhdX0mTVW7yra40IOAU9S08nnJR8keLP/yHkw=;
	b=QR5c0SMaCGCiTLwhxgZZ5/F+ZI4o8spyYtgsTXOvCh4we+3ha/Xc8Z5Qv/+YvlQ2aiW7SY
	GYxNltSO3KP+zwaKZomVHcfoNX6ZiMpr8U1/tNy1n5YM2SFrD5F4bnZOZ5SG91fZwZMBtS
	kgAKhbfMnUkHyoXNUDgSlalvksDMp00=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575---t799LNMCyijN_-yKEtKg-1; Wed, 17 Nov 2021 16:21:37 -0500
X-MC-Unique: --t799LNMCyijN_-yKEtKg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53F0A106F71E;
	Wed, 17 Nov 2021 21:21:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 334435F4F5;
	Wed, 17 Nov 2021 21:21:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C37F5181A1CF;
	Wed, 17 Nov 2021 21:21:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHLLVRj025233 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 16:21:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 353285C22B; Wed, 17 Nov 2021 21:21:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B96D5C1BB;
	Wed, 17 Nov 2021 21:21:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHLLQM6004923; 
	Wed, 17 Nov 2021 15:21:27 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHLLQ9K004922;
	Wed, 17 Nov 2021 15:21:26 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 15:21:16 -0600
Message-Id: <1637184084-4882-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/9] multipathd: remove missing paths on
	startup
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If a path device was removed from the system while multipathd was not
running, multipathd would not remove the path from the multipath table
on start-up, or on a weak reconfigure. update_pathvec_from_dm() would
return that a reload was necessary, but that information wasn't
propigated back to where it could be used to reload the device.

Multipath devices now remember if they need to be reloaded, and if so,
force_reload is set in select_action().  This means that even when
configure is called with FORCE_RELOAD_WEAK, these devices will still be
reloaded.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c   | 2 ++
 libmultipath/devmapper.c   | 2 ++
 libmultipath/structs.h     | 1 +
 libmultipath/structs_vec.c | 1 +
 4 files changed, 6 insertions(+)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index eb8ec1bd..f1a890af 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -715,6 +715,8 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 
 	cmpp = find_mp_by_wwid(curmp, mpp->wwid);
 	cmpp_by_name = find_mp_by_alias(curmp, mpp->alias);
+	if (mpp->need_reload || (cmpp && cmpp->need_reload))
+		force_reload = 1;
 
 	if (!cmpp_by_name) {
 		if (cmpp) {
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c05dc201..3e1a7260 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -522,6 +522,8 @@ freeout:
 addout:
 	dm_task_destroy (dmt);
 
+	if (r)
+		mpp->need_reload = false;
 	return r;
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 399540e7..d0b266b7 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -355,6 +355,7 @@ struct multipath {
 	int retain_hwhandler;
 	int deferred_remove;
 	bool in_recovery;
+	bool need_reload;
 	int san_path_err_threshold;
 	int san_path_err_forget_rate;
 	int san_path_err_recovery_time;
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 85d97ac1..e52db0c4 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -237,6 +237,7 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
 		free_pathgroup(pgp, KEEP_PATHS);
 		must_reload = true;
 	}
+	mpp->need_reload = mpp->need_reload || must_reload;
 	return must_reload;
 }
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

