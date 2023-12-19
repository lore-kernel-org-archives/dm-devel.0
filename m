Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EB83D0D9
	for <dm-devel@lists.linux.dev>; Tue, 19 Dec 2023 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RW8sVZQB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703026318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yN1VY9xITRnSAnDD6dTFun2aRmBgbGeJQbXSUymOb8I=;
	b=RW8sVZQBizElOilIpOenIbGFw2myenX2iwBjuOFTmO5ccnHy2Hk/Ct9jGFgfi2Dv6U6wA2
	EeoG7D2U21u2UqvzsbubovpzFA4fDV1Ea/zm+cYbA56gR9a1lRb6R0Qiu2EJyzu2QLauPf
	sV0ILmaLWHH9gCRrvfgfyVlPvkHhaDw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-H7tuor2fOKS0lLTq9k2biw-1; Tue, 19 Dec 2023 17:51:53 -0500
X-MC-Unique: H7tuor2fOKS0lLTq9k2biw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD1FE88F2EA;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A6C821C060AF;
	Tue, 19 Dec 2023 22:51:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 3BJMpqfD787555
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 17:51:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 3BJMpqaO787554;
	Tue, 19 Dec 2023 17:51:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v3 5/5] multipathd: only restore queueing if it has been disabled first
Date: Tue, 19 Dec 2023 17:51:51 -0500
Message-ID: <20231219225151.787521-6-bmarzins@redhat.com>
In-Reply-To: <20231219225151.787521-1-bmarzins@redhat.com>
References: <20231219225151.787521-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Make the restorequeueing command only do something if disablequeueing
has first been run on the map. Also update the man page to explain
what restorequeuing actually does.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c  | 40 ++++++++++++++++----------------------
 multipathd/multipathd.8.in | 12 ++++++++++--
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b1dff202..cf448b67 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -928,22 +928,15 @@ cli_restore_queueing(void *v, struct strbuf *reply, void *data)
 		return 1;
 	}
 
-	mpp->disable_queueing = 0;
-	conf = get_multipath_config();
-	pthread_cleanup_push(put_multipath_config, conf);
-	select_no_path_retry(conf, mpp);
-	pthread_cleanup_pop(1);
-
-	/*
-	 * Don't call set_no_path_retry() for the NO_PATH_RETRY_FAIL case.
-	 * That would disable queueing when "restorequeueing" is called,
-	 * and the code never behaved that way. Users might not expect it.
-	 * In almost all cases, queueing will be disabled anyway when we
-	 * are here.
-	 */
-	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
-	    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
+	if (mpp->disable_queueing) {
+		mpp->disable_queueing = 0;
+		conf = get_multipath_config();
+		pthread_cleanup_push(put_multipath_config, conf);
+		select_no_path_retry(conf, mpp);
+		pthread_cleanup_pop(1);
 		set_no_path_retry(mpp);
+	} else
+		condlog(2, "%s: queueing not disabled. Nothing to do", mapname);
 
 	return 0;
 }
@@ -957,15 +950,16 @@ cli_restore_all_queueing(void *v, struct strbuf *reply, void *data)
 
 	condlog(2, "restore queueing (operator)");
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
-		mpp->disable_queueing = 0;
-		struct config *conf = get_multipath_config();
-		pthread_cleanup_push(put_multipath_config, conf);
-		select_no_path_retry(conf, mpp);
-		pthread_cleanup_pop(1);
-		/* See comment in cli_restore_queueing() */
-		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
-		    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
+		if (mpp->disable_queueing) {
+			mpp->disable_queueing = 0;
+			struct config *conf = get_multipath_config();
+			pthread_cleanup_push(put_multipath_config, conf);
+			select_no_path_retry(conf, mpp);
+			pthread_cleanup_pop(1);
 			set_no_path_retry(mpp);
+		} else
+			condlog(2, "%s: queueing not disabled. Nothing to do",
+				mpp->alias);
 	}
 	return 0;
 }
diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index e98c27fd..f1cab3ff 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -251,7 +251,11 @@ Disable queueing on all multipath devices.
 .
 .TP
 .B restorequeueing maps|multipaths
-Restore queueing on all multipath devices.
+Restore queueing to the configured \fIno_path_retry\fR setting on all multipath
+devices whose queueing has been previously disabled by the \fIdisablequeueing\fR
+command. \fBNote:\fR If \fIno_path_path_retry\fR is set to queue for a limited
+number of retries after all paths have failed, this will not enable queueing if
+there are no active paths.
 .
 .TP
 .B disablequeueing map|multipath $map
@@ -259,7 +263,11 @@ Disable queuing on multipathed map $map.
 .
 .TP
 .B restorequeueing map|multipath $map
-Restore queuing on multipahted map $map.
+restore queueing to the configured \fIno_path_retry\fR setting on multipathed
+map $map whose queueing has been previously disabled by the
+\fIdisablequeueing\fR command. \fBNote:\fR If \fIno_path_path_retry\fR is set to
+queue for a limited number of retries after all paths have failed, this will not
+enable queueing if there are no active paths.
 .
 .TP
 .B forcequeueing daemon
-- 
2.41.0

