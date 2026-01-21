Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496E1426682
	for <dm-devel@lists.linux.dev>; Wed, 21 Jan 2026 21:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769029403; cv=none; b=eciPyU8eMC9tgt5bKSWPs69WU56WDeNj/a0CAJ3V5AObwkJ60vECPhJNzDKLQeGEesPDaMhTMQLEnJSbyHj1bUj+zXx4n0OVSB10oqoEBgLw0tqckyc8HF6fwhE046RfSzqX88LNXv9teKK9edEtC3PpygyLhuECIO0MjK2zb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769029403; c=relaxed/simple;
	bh=5nfARB1VILrYKYfPgvISJkVCoqH6PFdAZDInBQejb+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=isRHTtbkkZ0v8gRx3c/ZsVKzepK/RmQB/OCaBMEfDlAY1Oi2/r/Zv+QLyMWdqmXY6SgDCQF2X20cUtJ7EjchYE8bTJK09G55OUKlg5PSIEnwq+5tt71nEhUId0mzTLhF+DuGBW67StDGab0Aia41IC9cXWnl21+cnZT81fhKY9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U8wY2l2k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U8wY2l2k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769029400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=adH7fBTTgbaDNwmo+SYzsfGw2/BuLy4ALzU5wkqhsJc=;
	b=U8wY2l2k0E8YRPxWe2Vcvb1qQt+gh3wEtwWoZwlq+wYeAwrsomNSPWgvc4J+SKkXvqYP4j
	ktIk0ZX7yCqv5UZLnLKVoQZSBbFngk3zDVy5oW2DjuVNCszvYCzf/Lgfgn11SSmLqwXW3V
	O9/lFF8v6JcoQmN0T08XH+5T0/DZcZM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-1oZW5omvOdqeCo6uAsTW1w-1; Wed,
 21 Jan 2026 16:03:16 -0500
X-MC-Unique: 1oZW5omvOdqeCo6uAsTW1w-1
X-Mimecast-MFC-AGG-ID: 1oZW5omvOdqeCo6uAsTW1w_1769029395
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EBEB195608A;
	Wed, 21 Jan 2026 21:03:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AE361800998;
	Wed, 21 Jan 2026 21:03:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60LL3E2q3942752
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Jan 2026 16:03:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60LL3EHv3942751;
	Wed, 21 Jan 2026 16:03:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 3/4] multipathd: make "multipathd show status" busy checker better
Date: Wed, 21 Jan 2026 16:03:12 -0500
Message-ID: <20260121210313.3942727-4-bmarzins@redhat.com>
In-Reply-To: <20260121210313.3942727-1-bmarzins@redhat.com>
References: <20260121210313.3942727-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4n-MF98pny4o21zEsbTPIA6Vf4CwUkW3_IqKYyo6MaU_1769029395
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
 libmultipath/uevent.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index be199af0..3409ec9c 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -52,6 +52,7 @@ static pthread_cond_t *uev_condp = &uev_cond;
 static uev_trigger *my_uev_trigger;
 static void *my_trigger_data;
 static int servicing_uev;
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
 	servicing = servicing_uev;
+	adding = uatomic_read(&adding_uev);
 	pthread_mutex_unlock(uevq_lockp);
-	return (!empty || servicing);
+	return (!empty || servicing || adding);
 }
 
 struct uevent * alloc_uevent (void)
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

