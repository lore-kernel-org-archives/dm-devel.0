Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7172119343B
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 00:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757376011; cv=none; b=k7plAwJqwuHQMZjnekppw4SqlMBL0tUAuobdmNp/XY1zQshou5/ypUbEvPc2JTDVfa6uuUaNkSRFDlb/hLC/fChWrIUWDufcnX+aKogcLq7UhoISIpOgoAZWC6AlPnz5etEGIsv+xI9STyYtWwzPWd6YUdsZmNpuclU2SE2eJGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757376011; c=relaxed/simple;
	bh=1yOYHdsVRPAThmfK3MBBCV523i8TQ3tH+zvjG/4jQ8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=B7/DE2BqjBvSVZs8WWLteuT1uFuuRqFScK374JfLGgTwfey6anD2DXe2hUF2AbQ52g+YO7XJRc1WMJ9DaxUzR4hPNbSAQHTvdNrdyBy0U/SFQVbfVGfwPlcro38RNo4ASaxyizRvwhc7tOkxwKKQKLIOsxBixuH1YQjnOsufGis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IeC0koOL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IeC0koOL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757376008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+/qcj0VBJjuH1+vIMBd0b+GeQuJyd/FnwAyMZ0Aspk=;
	b=IeC0koOLaofJfRbU1ScrW8Yw9dxEsLWaiB2Cz8DowwepSEvQm9sdGQhT5NpXwX7wtye0BJ
	kpHE/o2wbH1Qhvml2/AspLL+pmD0EK+FnEHBrtsswfqT3eiGwq2v4UIt38oUoBS/XBmb1V
	kXlNOblYwLjGKntwMYsf+G50H17vVlI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-3eHTxie7OjSusCo-oQACRg-1; Mon,
 08 Sep 2025 20:00:06 -0400
X-MC-Unique: 3eHTxie7OjSusCo-oQACRg-1
X-Mimecast-MFC-AGG-ID: 3eHTxie7OjSusCo-oQACRg_1757376005
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65D1E1800370;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F68919560A2;
	Tue,  9 Sep 2025 00:00:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 589003PC751084
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 20:00:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 589003rE751083;
	Mon, 8 Sep 2025 20:00:03 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/32] multipathd: remove thread from mpath_pr_event_handle
Date: Mon,  8 Sep 2025 19:59:31 -0400
Message-ID: <20250909000002.751039-2-bmarzins@redhat.com>
In-Reply-To: <20250909000002.751039-1-bmarzins@redhat.com>
References: <20250909000002.751039-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XGFhwDV08y9By5scAwEVOzUp6Oy-wsmYOiRQrtbGLjM_1757376005
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

mpath_pr_event_handle() creates a separate thread to do the persistent
reservation work, but it doesn't take any advantage of the work being
done in another thread. Merge mpath_pr_event_handle() and
mpath_pr_event_handler_fn() into a single function with no separate
thread.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
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
2.50.1

