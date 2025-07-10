Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4C32FC3CF
	for <dm-devel@lists.linux.dev>; Thu, 10 Jul 2025 18:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752171073; cv=none; b=hg0VIrm4Qq8hY1lreTNPpSNh4rO+l99+mRAJ5TMiFk0wWlbwDN/z0Hzr7zifFSAEnYFdRiYIeg+RnUYCkihGUK1TB+T2jOrNMdyPGPNyvYC35lcmP6psdG0yfG1WPCpg3Jh7ZsMK4kEWSQjWsLs7vhgUOffsx5lwYGkbj3HoUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752171073; c=relaxed/simple;
	bh=aEqrjZH2pdH1tonn58ShJpHswyLUyrjRM9hr+C/kOME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Vwube9VWps7ptS9Z8xFQ3OLaxKFaO/znpT/5T50Aps4E9d8mq7KDTMn8BXGzRNRUoRgQedjlOJ9Q3QtGm6Re5Y4bCYxCMJOK+Yasphrf7kSB3KWqkP5GNKA3bNvm4OJen42t+skZe4YYaQ39IsL8PHMtjv54XfLv4Z/pAGTzlN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZBIcXaKV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBIcXaKV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752171070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WffuVOmsjSIysT/bZoTK6FuJfbQTKW9v/vcJShJ9fGk=;
	b=ZBIcXaKV32irbWy3gL6QFNoNdkqUfpuobnYVFlzZOzh86eOR4ZHZOB3h8BFLtaOigRIRV7
	ZKTfSSE78Zg/IQfv7nYdRvur1DnnRUnRmFygdWN6RaFYBefCDzT1V+wLV2XEUtAtLD5VSV
	Vja9b6Qr85sTbw0wVHQ1en1oEakt9Kc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-382-WpF92lg4PjamwDgaFxH4hA-1; Thu,
 10 Jul 2025 14:11:04 -0400
X-MC-Unique: WpF92lg4PjamwDgaFxH4hA-1
X-Mimecast-MFC-AGG-ID: WpF92lg4PjamwDgaFxH4hA_1752171063
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F92D195608A;
	Thu, 10 Jul 2025 18:11:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E75131800288;
	Thu, 10 Jul 2025 18:11:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56AIB1Wd3997787
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 14:11:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56AIB1PM3997786;
	Thu, 10 Jul 2025 14:11:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 01/15] multipathd: remove thread from mpath_pr_event_handle
Date: Thu, 10 Jul 2025 14:10:46 -0400
Message-ID: <20250710181100.3997759-2-bmarzins@redhat.com>
In-Reply-To: <20250710181100.3997759-1-bmarzins@redhat.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -yRVt6q30q-XFYTcmUfZtHojZ80U0cfMhyM4T74_MHM_1752171063
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

mpath_pr_event_handle() creates a separate thread to do the persistent
reservation work, but it doesn't take any advantage of the work being
done in another thread. Merge mpath_pr_event_handle() and
mpath_pr_event_handler_fn() into a single function with no separate
thread.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 50 +++++++++++------------------------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2d5c146d..46eef222 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -89,8 +89,7 @@
 #define CMDSIZE 160
 #define MSG_SIZE 32
 
-int mpath_pr_event_handle(struct path *pp);
-void * mpath_pr_event_handler_fn (void * );
+static void mpath_pr_event_handle(struct path *pp);
 
 #define LOG_MSG(lvl, pp)					\
 do {								\
@@ -4229,17 +4228,24 @@ main (int argc, char *argv[])
 		return (child(NULL));
 }
 
-void *  mpath_pr_event_handler_fn (void * pathp )
+static void mpath_pr_event_handle(struct path *pp)
 {
 	struct multipath * mpp;
 	unsigned int i;
 	int ret, isFound;
-	struct path * pp = (struct path *)pathp;
 	struct prout_param_descriptor *param;
 	struct prin_resp *resp;
 
-	rcu_register_thread();
 	mpp = pp->mpp;
+	if (pp->bus != SYSFS_BUS_SCSI) {
+		mpp->prflag = PRFLAG_UNSET;
+		return;
+	}
+
+	if (!get_be64(mpp->reservation_key)) {
+		mpp->prflag = PRFLAG_UNSET;
+		return;
+	}
 
 	resp = mpath_alloc_prin_response(MPATH_PRIN_RKEY_SA);
 	if (!resp){
@@ -4306,38 +4312,4 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 out:
 	if (resp)
 		free(resp);
-	rcu_unregister_thread();
-	return NULL;
-}
-
-int mpath_pr_event_handle(struct path *pp)
-{
-	pthread_t thread;
-	int rc;
-	pthread_attr_t attr;
-	struct multipath * mpp;
-
-	if (pp->bus != SYSFS_BUS_SCSI)
-		goto no_pr;
-
-	mpp = pp->mpp;
-
-	if (!get_be64(mpp->reservation_key))
-		goto no_pr;
-
-	pthread_attr_init(&attr);
-	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
-
-	rc = pthread_create(&thread, NULL , mpath_pr_event_handler_fn, pp);
-	if (rc) {
-		condlog(0, "%s: ERROR; return code from pthread_create() is %d", pp->dev, rc);
-		return -1;
-	}
-	pthread_attr_destroy(&attr);
-	rc = pthread_join(thread, NULL);
-	return 0;
-
-no_pr:
-	pp->mpp->prflag = PRFLAG_UNSET;
-	return 0;
 }
-- 
2.48.1

