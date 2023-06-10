Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2084C7EE2E
	for <dm-devel@archiver.kernel.org>; Sat, 10 Jun 2023 06:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686377587;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BeRrevQWTNvkUIxmNQ5FtDTSRouRcq6oUsY6LdgEvOs=;
	b=gIJKfYsCcUUOTsbP7DlgdegVye5PsxlkQbXzG9MIqK5hOjjSVT1Q8IVOTGp/fVWnTN6s+8
	AYZAsMxc3PNPyJRgsCVzbKIurIzYgROxm2fsw+QqLdKejFwZYHOJvm7Bax9M3p4WMzIfqe
	dkXvTxwX+Y60A0fDWTMx27kZMWoAYX0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-2619XAagPrG1V1oi8vj6dA-1; Sat, 10 Jun 2023 02:12:58 -0400
X-MC-Unique: 2619XAagPrG1V1oi8vj6dA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65A2E803791;
	Sat, 10 Jun 2023 06:12:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F1BA52166B25;
	Sat, 10 Jun 2023 06:12:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D305819451C1;
	Sat, 10 Jun 2023 06:12:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C5462194658C
 for <dm-devel@listman.corp.redhat.com>; Sat, 10 Jun 2023 06:12:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C77B400E400; Sat, 10 Jun 2023 06:12:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 45322400E6C6
 for <dm-devel@redhat.com>; Sat, 10 Jun 2023 06:12:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 299A8185A78F
 for <dm-devel@redhat.com>; Sat, 10 Jun 2023 06:12:52 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-kIePGqWsMkWNED1pdzoGrw-1; Sat, 10 Jun 2023 02:12:50 -0400
X-MC-Unique: kIePGqWsMkWNED1pdzoGrw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 74A45637DF;
 Sat, 10 Jun 2023 06:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF09C433D2;
 Sat, 10 Jun 2023 06:12:48 +0000 (UTC)
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org
Date: Fri,  9 Jun 2023 23:11:39 -0700
Message-Id: <20230610061139.212085-1-ebiggers@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] blk-crypto: use dynamic lock class for
 blk_crypto_profile::lock
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Bart Van Assche <bvanassche@acm.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Eric Biggers <ebiggers@google.com>

When a device-mapper device is passing through the inline encryption
support of an underlying device, calls to blk_crypto_evict_key() take
the blk_crypto_profile::lock of the device-mapper device, then take the
blk_crypto_profile::lock of the underlying device (nested).  This isn't
a real deadlock, but it causes a lockdep report because there is only
one lock class for all instances of this lock.

Lockdep subclasses don't really work here because the hierarchy of block
devices is dynamic and could have more than 2 levels.

Instead, register a dynamic lock class for each blk_crypto_profile, and
associate that with the lock.

This avoids false-positive lockdep reports like the following:

    ============================================
    WARNING: possible recursive locking detected
    6.4.0-rc5 #2 Not tainted
    --------------------------------------------
    fscryptctl/1421 is trying to acquire lock:
    ffffff80829ca418 (&profile->lock){++++}-{3:3}, at: __blk_crypto_evict_key+0x44/0x1c0

                   but task is already holding lock:
    ffffff8086b68ca8 (&profile->lock){++++}-{3:3}, at: __blk_crypto_evict_key+0xc8/0x1c0

                   other info that might help us debug this:
     Possible unsafe locking scenario:

           CPU0
           ----
      lock(&profile->lock);
      lock(&profile->lock);

                    *** DEADLOCK ***

     May be due to missing lock nesting notation

Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c         | 12 ++++++++++--
 include/linux/blk-crypto-profile.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 2a67d3fb63e5c..7fabc883e39f1 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -79,7 +79,14 @@ int blk_crypto_profile_init(struct blk_crypto_profile *profile,
 	unsigned int slot_hashtable_size;
 
 	memset(profile, 0, sizeof(*profile));
-	init_rwsem(&profile->lock);
+
+	/*
+	 * profile->lock of an underlying device can nest inside profile->lock
+	 * of a device-mapper device, so use a dynamic lock class to avoid
+	 * false-positive lockdep reports.
+	 */
+	lockdep_register_key(&profile->lockdep_key);
+	__init_rwsem(&profile->lock, "&profile->lock", &profile->lockdep_key);
 
 	if (num_slots == 0)
 		return 0;
@@ -89,7 +96,7 @@ int blk_crypto_profile_init(struct blk_crypto_profile *profile,
 	profile->slots = kvcalloc(num_slots, sizeof(profile->slots[0]),
 				  GFP_KERNEL);
 	if (!profile->slots)
-		return -ENOMEM;
+		goto err_destroy;
 
 	profile->num_slots = num_slots;
 
@@ -435,6 +442,7 @@ void blk_crypto_profile_destroy(struct blk_crypto_profile *profile)
 {
 	if (!profile)
 		return;
+	lockdep_unregister_key(&profile->lockdep_key);
 	kvfree(profile->slot_hashtable);
 	kvfree_sensitive(profile->slots,
 			 sizeof(profile->slots[0]) * profile->num_slots);
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index e6802b69cdd64..90ab33cb5d0ef 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -111,6 +111,7 @@ struct blk_crypto_profile {
 	 * keyslots while ensuring that they can't be changed concurrently.
 	 */
 	struct rw_semaphore lock;
+	struct lock_class_key lockdep_key;
 
 	/* List of idle slots, with least recently used slot at front */
 	wait_queue_head_t idle_slots_wait_queue;

base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

