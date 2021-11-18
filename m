Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F93C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:02:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 66AF46128E
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:02:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 66AF46128E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-EKSlij92MUa_4kU_B1AIKA-1; Thu, 18 Nov 2021 18:02:50 -0500
X-MC-Unique: EKSlij92MUa_4kU_B1AIKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE4DE1018723;
	Thu, 18 Nov 2021 23:02:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF83D27061;
	Thu, 18 Nov 2021 23:02:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0AAF180BAD1;
	Thu, 18 Nov 2021 23:02:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx3Nv001998 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 31BD8218014B; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B65C218013A
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D92800C00
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-143-RwJpyJBXOwqQMw1mm0LXWg-1; Thu, 18 Nov 2021 17:58:59 -0500
X-MC-Unique: RwJpyJBXOwqQMw1mm0LXWg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D462D218B0;
	Thu, 18 Nov 2021 22:58:57 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8FD7C13B11;
	Thu, 18 Nov 2021 22:58:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id yJgjIbHalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:58:57 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:57:55 +0100
Message-Id: <20211118225840.19810-4-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx3Nv001998
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 03/48] libmultipath: add optional wakeup
	functionality to lock.c
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Have struct mutex_lock take an optional wakeup function.
unlock() is renamed to __unlock() in order to prevent it from
being called by mistake.

This changes offsets in "struct vectors", requiring a major
libmultipath version bump. While the strucure is already changed,
in order to avoid this in the future, move the lock to the end
of "struct vectors".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 13 +++++++------
 libmultipath/lock.c               | 12 +++++++++++-
 libmultipath/lock.h               |  6 +++++-
 libmultipath/structs_vec.h        |  2 +-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index c98cf7f..98ec502 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -31,7 +31,7 @@
  *   The new version inherits the previous ones.
  */
 
-LIBMULTIPATH_9.0.0 {
+LIBMULTIPATH_10.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
@@ -284,11 +284,12 @@ global:
 	/* added in 8.2.0 */
 	check_daemon;
 
+	/* added in 9.1.0 */
+	timespeccmp;
+
+	/* added in 9.2.0 */
+	set_wakeup_fn;
+
 local:
 	*;
 };
-
-LIBMULTIPATH_9.1.0 {
-global:
-	timespeccmp;
-} LIBMULTIPATH_9.0.0;
diff --git a/libmultipath/lock.c b/libmultipath/lock.c
index 72c70e3..93b48db 100644
--- a/libmultipath/lock.c
+++ b/libmultipath/lock.c
@@ -3,6 +3,16 @@
 void cleanup_lock (void * data)
 {
 	struct mutex_lock *lock = data;
+	wakeup_fn *fn = lock->wakeup;
 
-	unlock(lock);
+	__unlock(lock);
+	if (fn)
+		fn();
+}
+
+void set_wakeup_fn(struct mutex_lock *lck, wakeup_fn *fn)
+{
+	lock(lck);
+	lck->wakeup = fn;
+	__unlock(lck);
 }
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index d99eedb..d7b779e 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -3,8 +3,11 @@
 
 #include <pthread.h>
 
+typedef void (wakeup_fn)(void);
+
 struct mutex_lock {
 	pthread_mutex_t mutex;
+	wakeup_fn *wakeup;
 };
 
 static inline void lock(struct mutex_lock *a)
@@ -22,7 +25,7 @@ static inline int timedlock(struct mutex_lock *a, struct timespec *tmo)
 	return pthread_mutex_timedlock(&a->mutex, tmo);
 }
 
-static inline void unlock(struct mutex_lock *a)
+static inline void __unlock(struct mutex_lock *a)
 {
 	pthread_mutex_unlock(&a->mutex);
 }
@@ -30,5 +33,6 @@ static inline void unlock(struct mutex_lock *a)
 #define lock_cleanup_pop(a) pthread_cleanup_pop(1)
 
 void cleanup_lock (void * data);
+void set_wakeup_fn(struct mutex_lock *lock, wakeup_fn *fn);
 
 #endif /* _LOCK_H */
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index 29ede45..2a0cbd1 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -6,9 +6,9 @@
 #include "lock.h"
 
 struct vectors {
-	struct mutex_lock lock; /* defined in lock.h */
 	vector pathvec;
 	vector mpvec;
+	struct mutex_lock lock; /* defined in lock.h */
 };
 
 void __set_no_path_retry(struct multipath *mpp, bool check_features);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

