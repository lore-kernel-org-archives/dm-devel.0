Return-Path: <SRS0=KxaR=D6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D000C388F9
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 21:21:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88A35208E4
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 21:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zr+NymEK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88A35208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603488076;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uHHIhzeFidDNdJlxJ05btU03mRI+iLk8FaHrkzHIq8Y=;
	b=Zr+NymEKd4t82L+Cqisx5TaZ7/McOzqvni7Fld0P5fm4u8SD8yr0LrvjZ0EcyQ/WKiVz78
	xWHNbJcQqLC1IpRtIJcHnnRkwbYwuLy+ZirwofOMubhuBMs6MD07BO1yLFyAyHiVR5cYS3
	7j8X5g7qs23OTrk3w7bR5/7pWOv/D8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-wZOcGW0hMgGritsaaM0WHQ-1; Fri, 23 Oct 2020 17:21:14 -0400
X-MC-Unique: wZOcGW0hMgGritsaaM0WHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BEBB805EF2;
	Fri, 23 Oct 2020 21:21:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7BE473661;
	Fri, 23 Oct 2020 21:21:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 76FBB180B657;
	Fri, 23 Oct 2020 21:21:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NLFJlb027815 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 17:15:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C7EA855793; Fri, 23 Oct 2020 21:15:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04BE755785;
	Fri, 23 Oct 2020 21:15:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09NLFFPT012605; 
	Fri, 23 Oct 2020 16:15:15 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09NLFF6n012604;
	Fri, 23 Oct 2020 16:15:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 23 Oct 2020 16:15:08 -0500
Message-Id: <1603487708-12547-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 5/5] libmultipath: don't dlclose tur checker DSO
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

The multipathd tur checker thread is designed to be able to finish at
any time, even after the tur checker itself has been freed. The
multipathd shutdown code makes sure all the checkers have been freed
before freeing the checker_class and calling dlclose() to unload the
DSO, but this doesn't guarantee that the checker threads have finished.
If one hasn't, the DSO will get unloaded while the thread still running
code from it, causing a segfault. Unfortunately, it's not possible to be
sure that all tur checker threads have ended during shutdown, without
making them joinable.

However, since libmultipath will never be reinitialized after it has
been uninitialzed, not dlclosing the tur checker DSO once a thread is
started has minimal cost (keeping the DSO code around until the program
exits, which usually happens right after freeing the checkers).

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c     | 10 +++++++++-
 libmultipath/checkers.h     |  1 +
 libmultipath/checkers/tur.c |  1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 18b1f5eb..35a17f8c 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -22,6 +22,7 @@ struct checker_class {
 	void (*reset)(void);		     /* to reset the global variables */
 	const char **msgtable;
 	short msgtable_size;
+	int keep_dso;
 };
 
 static const char *checker_state_names[PATH_MAX_STATE] = {
@@ -74,7 +75,7 @@ void free_checker_class(struct checker_class *c)
 	list_del(&c->node);
 	if (c->reset)
 		c->reset();
-	if (c->handle) {
+	if (c->handle && !c->keep_dso) {
 		if (dlclose(c->handle) != 0) {
 			condlog(0, "Cannot unload checker %s: %s",
 				c->name, dlerror());
@@ -197,6 +198,13 @@ out:
 	return NULL;
 }
 
+void checker_keep_dso(struct checker * c)
+{
+	if (!c || !c->cls)
+		return;
+	c->cls->keep_dso = 1;
+}
+
 void checker_set_fd (struct checker * c, int fd)
 {
 	if (!c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 9d5f90b9..af5a4006 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -146,6 +146,7 @@ void checker_reset (struct checker *);
 void checker_set_sync (struct checker *);
 void checker_set_async (struct checker *);
 void checker_set_fd (struct checker *, int);
+void checker_keep_dso(struct checker *c);
 void checker_enable (struct checker *);
 void checker_disable (struct checker *);
 int checker_check (struct checker *, int);
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index e886fcf8..fd58d62a 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -394,6 +394,7 @@ int libcheck_check(struct checker * c)
 		uatomic_set(&ct->running, 1);
 		tur_set_async_timeout(c);
 		setup_thread_attr(&attr, 32 * 1024, 1);
+		checker_keep_dso(c);
 		r = pthread_create(&ct->thread, &attr, tur_thread, ct);
 		pthread_attr_destroy(&attr);
 		if (r) {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

