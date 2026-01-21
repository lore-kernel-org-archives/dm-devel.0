Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300C2366552
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 04:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768969413; cv=none; b=EW94J/N+pbTzmGrv1xFWOwjY+BIcBHAPOXvTv4b/7PwL4zkQuWADnOJ32rl8IXn2w/Ce+V4Pz0B4KvG3mjQwUfuGRPe1om7V7U1wphx0e+MPPE8k6UwZ7GetpggEJZiHMwuaCwYe/9Vf1zeJs/hUy8HUnELdh5NdCemvELe/Ov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768969413; c=relaxed/simple;
	bh=rIqaQtH6TluXirZ5d6MnnkdqN0Exc2KdLK9lRxm/eUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oWe8Isatf8HsxMbsxHKnd9X0Am1US84zTEbH316reYPLAHc19Qjiwx1sUzHwQAaJh1GinFx24Y78sveb0APxFhIPYlblVKNEvjk5UKCi7jkKqe8dSY+qX2TnJ8wrc+COszDbr5yNvh2+dqElqFoJedxCkSdTMsggXMSXSaSIXic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CKex/0Y9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CKex/0Y9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768969400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s0tMBSTqE1IoIflIgpeRj3fn8xhq9xi4uowSg4g0jOE=;
	b=CKex/0Y96ZJYBfPBsDLigGbuNTl9Rvh3R9a25zRk0HA5wpPlBr9MLH5k9hvpRkVGx4By34
	wzyqNJAbNQzbtRdiuBtjMRTsQ9dOfeVfpnOJqdnGbJP2I3vSK9LnLPeq3NC6XxLRmjxy0x
	Khtld7z3WeOnAAdloMQrK0S/SVTHR/U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-RIH-xfw9PnKk2y0TbJeuIQ-1; Tue,
 20 Jan 2026 23:23:18 -0500
X-MC-Unique: RIH-xfw9PnKk2y0TbJeuIQ-1
X-Mimecast-MFC-AGG-ID: RIH-xfw9PnKk2y0TbJeuIQ_1768969397
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 576621956094;
	Wed, 21 Jan 2026 04:23:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09D7530001A8;
	Wed, 21 Jan 2026 04:23:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60L4NFcK3914732
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 20 Jan 2026 23:23:16 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60L4NFxv3914731;
	Tue, 20 Jan 2026 23:23:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 3/4] multipathd: make "multipathd show status" busy checker better
Date: Tue, 20 Jan 2026 23:23:14 -0500
Message-ID: <20260121042315.3914707-4-bmarzins@redhat.com>
In-Reply-To: <20260121042315.3914707-1-bmarzins@redhat.com>
References: <20260121042315.3914707-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c-51899zZ-Xz69nHeSGFJjDHHf1LgQiyPAQAM2Wdq-A_1768969397
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

while uevent_listen() was grabbing new uevents, "multipathd show status"
would still show show busy as "False". Add a check there, to make catch
multipathd's uevent processing earlier. Also, access servicing_uev (as
well as the new variable, adding_uev) atomically, just to make sure that
the compiler doesn't do stupid things trying to optimize them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/uevent.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index be199af0..7eae2859 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -51,7 +51,8 @@ static pthread_cond_t uev_cond = PTHREAD_COND_INITIALIZER;
 static pthread_cond_t *uev_condp = &uev_cond;
 static uev_trigger *my_uev_trigger;
 static void *my_trigger_data;
-static int servicing_uev;
+static int servicing_uev; /* uatomic access only */
+static int adding_uev;	  /* uatomic access only */
 
 struct uevent_filter_state {
 	struct list_head uevq;
@@ -70,13 +71,14 @@ static void reset_filter_state(struct uevent_filter_state *st)
 
 int is_uevent_busy(void)
 {
-	int empty, servicing;
+	int empty, servicing, adding;
 
 	pthread_mutex_lock(uevq_lockp);
 	empty = list_empty(&uevq);
-	servicing = servicing_uev;
+	servicing = uatomic_read(&servicing_uev);
+	adding = uatomic_read(&adding_uev);
 	pthread_mutex_unlock(uevq_lockp);
-	return (!empty || servicing);
+	return (!empty || servicing || adding);
 }
 
 struct uevent * alloc_uevent (void)
@@ -536,7 +538,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 		pthread_cleanup_push(cleanup_mutex, uevq_lockp);
 		pthread_mutex_lock(uevq_lockp);
 
-		servicing_uev = !list_empty(&filter_state.uevq);
+		uatomic_set(&servicing_uev, !list_empty(&filter_state.uevq));
 
 		while (list_empty(&filter_state.uevq) && list_empty(&uevq)) {
 			condlog(4, "%s: waiting for events", __func__);
@@ -544,7 +546,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 			condlog(4, "%s: waking up", __func__);
 		}
 
-		servicing_uev = 1;
+		uatomic_set(&servicing_uev, 1);
 		/*
 		 * "old_tail" is the list element towards which merge_uevq()
 		 * will iterate: the last element of uevq before
@@ -730,6 +732,7 @@ int uevent_listen(struct udev *udev)
 		int fdcount, events;
 		struct pollfd ev_poll = { .fd = fd, .events = POLLIN, };
 
+		uatomic_set(&adding_uev, 0);
 		fdcount = poll(&ev_poll, 1, -1);
 		if (fdcount < 0) {
 			if (errno == EINTR)
@@ -739,6 +742,8 @@ int uevent_listen(struct udev *udev)
 			err = -errno;
 			break;
 		}
+		uatomic_set(&adding_uev, 1);
+
 		events = uevent_receive_events(fd, &uevlisten_tmp, monitor);
 		if (events <= 0)
 			continue;
-- 
2.50.1

