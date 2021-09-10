Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC58C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AE261611C0
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AE261611C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-DBHrjt1jM028hjG4vyCLgw-1; Fri, 10 Sep 2021 07:43:29 -0400
X-MC-Unique: DBHrjt1jM028hjG4vyCLgw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFFEB84A5F4;
	Fri, 10 Sep 2021 11:43:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9196C19C79;
	Fri, 10 Sep 2021 11:43:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 69C474EA39;
	Fri, 10 Sep 2021 11:43:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABgxv2010183 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:42:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 014CA10AF42D; Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0C5910CB269
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E040F800B24
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:55 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-125-WTfDauzJMwuyspxi8RNJ0A-1; Fri, 10 Sep 2021 07:42:52 -0400
X-MC-Unique: WTfDauzJMwuyspxi8RNJ0A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E514822432;
	Fri, 10 Sep 2021 11:42:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9A4C813D34;
	Fri, 10 Sep 2021 11:42:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +CO7I7pEO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:50 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:40:48 +0200
Message-Id: <20210910114120.13665-4-mwilck@suse.com>
In-Reply-To: <20210910114120.13665-1-mwilck@suse.com>
References: <20210910114120.13665-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABgxv2010183
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 03/35] libmultipath: add optional wakeup
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version |  5 +++++
 libmultipath/lock.c               | 12 +++++++++++-
 libmultipath/lock.h               |  6 +++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index c98cf7f..2107c51 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -292,3 +292,8 @@ LIBMULTIPATH_9.1.0 {
 global:
 	timespeccmp;
 } LIBMULTIPATH_9.0.0;
+
+LIBMULTIPATH_9.2.0 {
+global:
+	set_wakeup_fn;
+} LIBMULTIPATH_9.1.0;
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
-- 
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

