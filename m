Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC054C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-Bl5njKc5MiG_kJTHjl-wMg-1; Sat, 27 Nov 2021 10:20:30 -0500
X-MC-Unique: Bl5njKc5MiG_kJTHjl-wMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB0211006AA2;
	Sat, 27 Nov 2021 15:20:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A384160C4A;
	Sat, 27 Nov 2021 15:20:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 816681809CB7;
	Sat, 27 Nov 2021 15:20:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJmgf032669 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7DF59404727A; Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A1744047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63F3E80122B
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-308-im3oicqtPkur90ISi8SZvg-1; Sat, 27 Nov 2021 10:19:44 -0500
X-MC-Unique: im3oicqtPkur90ISi8SZvg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B6900212CB;
	Sat, 27 Nov 2021 15:19:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A3C413AAD;
	Sat, 27 Nov 2021 15:19:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 8JLOF45MomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:42 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:18:56 +0100
Message-Id: <20211127151929.7727-4-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJmgf032669
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 03/35] libmultipath: add optional wakeup
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 13 +++++++------
 libmultipath/lock.c               | 12 +++++++++++-
 libmultipath/lock.h               |  6 +++++-
 libmultipath/structs_vec.h        |  2 +-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index c98cf7f..83aaa83 100644
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
+	/* added in 10.0.0 */
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

