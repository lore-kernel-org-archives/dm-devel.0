Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795670684;
	b=EoS0JBYoVlfFdCNau64v2upl/t0OTLgCAVlGgs5JbHOH7qdiSUKduoiGDru5znT9O9i2
	 YjDAkgU88FKK40IJu5oPx8R6V05QcFhk83srr8LU3Xiy9W0njI3zhfRYADWFnl01iwCbZ
	 O1nTbQHrXhtrfreRHzU08veHxD3PQFvuM8sHfco7+PK+O2HOJ5p9sOYuMf/9j879kCShu
	 +u7Ra/4p1Rb2zZ5nZUgHrcoatnXRwsglWaqGQDAajRqxhp+OEmUc1zevHouH+SlYIwmul
	 iGwpP6o/0FBHEzA6h+4jAZ7mbFeWRMXeaWls48yjthia9vnQ+bUUVFc2Si69fPBuplg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795670684;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Transfer-Encoding:content-type;
	bh=UTtkxdnaFNxDX28PgCHwS6oF67POMqHljiccP6tEdoc=;
	b=vZtxFVO24LMaxoxgUA6Rinwp8sYCnKgDABH+FHkEzpGnnKeLRCUnVB9cKJUqtEbBW5CD
	 bzXe/ankr/4pjduaWejQ+2U1AGZn9XG55rFoAzOY0koQ2xPIbtboAK4H/iE/BDAgWtpEq
	 huuBPTfY+DTZ64PhyNLZ2IDxxaFcOGJXwcz+f33Ox39fTfkH116XxN3x0cE2kvg6UOEpb
	 6hnDMTIVSTxhomaemsYzDFDyino396Ex//zHrAsbg0a4P7IMfmWEOOZ5jRZe9gpACz4LR
	 /ous3MYRAZshPNmlY88RbUaK9cackSse2a/ppIB3TX+j/MEQ9bSAlgiWcZ1OKGVXFbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JKXNL9Nz;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C3A606A31E
	for <dm-devel@lists.linux.dev>; Thu, 26 Nov 2026 05:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55C3A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JKXNL9Nz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795670682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTtkxdnaFNxDX28PgCHwS6oF67POMqHljiccP6tEdoc=;
	b=JKXNL9Nz7IxRxKzqthsWHO13uW68hTGycGvzGDUYAgNkY6HHJ6xGa+1z2iCPUyffwxWSsg
	oA8j6Qu/6djgJI3Ws4+K1osyn5Nzco4mh+Htky9+FKwul7fvG2aBi5fxmTqknoXGQUBWr7
	q1B22dhVHfiFlBns7iSSXK8OlVUXz0k=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125--ILXVKH2Mh6LzTOnk3Dx9Q-1; Thu,
 26 Nov 2026 05:24:37 +0000
X-MC-Unique: -ILXVKH2Mh6LzTOnk3Dx9Q-1
X-Mimecast-MFC-AGG-ID: -ILXVKH2Mh6LzTOnk3Dx9Q_1795670676
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CA2A18004FB;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A9BC18004FC;
	Thu, 26 Nov 2026 05:24:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6AQ5OZIG725779
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 00:24:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6AQ5OZk2725778;
	Thu, 26 Nov 2026 00:24:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 1/4] multipathd: make the wakeup and drain idle_fd code generic
Date: Thu, 26 Nov 2026 00:24:31 -0500
Message-ID: <20261126052434.725762-2-bmarzins@redhat.com>
In-Reply-To: <20261126052434.725762-1-bmarzins@redhat.com>
References: <20261126052434.725762-1-bmarzins@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R31zZSaaS3VWmyT311J8ShdFaBPlTDHMxEblZLcsLuY_1795670676
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

A future patch will add a new eventfd. Make the code to wake up
and drain an eventfd generic, so it can be reused.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/uxlsnr.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index b8207306..e92784e5 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -384,21 +384,25 @@ static int execute_handler(struct client *c, struct vectors *vecs)
 	return c->handler->fn(c->cmdvec, &c->reply, vecs);
 }
 
-static void wakeup_listener(void)
+static void wakeup_listener(int event_fd)
 {
 	uint64_t one = 1;
 
-	if (idle_fd != -1 &&
-	    write(idle_fd, &one, sizeof(one)) != sizeof(one))
+	if (event_fd != -1 && write(event_fd, &one, sizeof(one)) != sizeof(one))
 		condlog(1, "%s: failed", __func__);
 }
 
-static void drain_idle_fd(int fd)
+static void wakeup_idle_listener(void)
+{
+	wakeup_listener(idle_fd);
+}
+
+static void drain_event_fd(int event_fd)
 {
 	uint64_t val;
 	int rc;
 
-	rc = read(fd, &val, sizeof(val));
+	rc = read(event_fd, &val, sizeof(val));
 	condlog(4, "%s: %d, %"PRIu64, __func__, rc, val);
 }
 
@@ -665,7 +669,7 @@ void *uxsock_listen(int n_socks, long *ux_sock_in, void *trigger_data)
 		condlog(1, "failed to create idle fd");
 		exit_daemon();
 	} else
-		set_wakeup_fn(&vecs->lock, wakeup_listener);
+		set_wakeup_fn(&vecs->lock, wakeup_idle_listener);
 
 	sigfillset(&mask);
 	sigdelset(&mask, SIGINT);
@@ -769,7 +773,7 @@ void *uxsock_listen(int n_socks, long *ux_sock_in, void *trigger_data)
 
 		if (polls[POLLFD_IDLE].fd != -1 &&
 		    polls[POLLFD_IDLE].revents & POLLIN)
-			drain_idle_fd(idle_fd);
+			drain_event_fd(idle_fd);
 
 		/* see if a client needs handling */
 		list_for_each_entry_safe(c, tmp, &clients, node) {
-- 
2.56.0

