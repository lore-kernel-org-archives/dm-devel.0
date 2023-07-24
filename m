Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94014C05051
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jul 2023 06:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690267398;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=clSl7k9Wz7MTnZ2XaMSMEsCtTgxLkFXWUYufxBJI0kY=;
	b=Xlo40btrCEqaftghZKrqAeSQVRDArDsfTuuXfXdVFdK1Xb0kLz7XSn3FohEtJVYBtQgB9O
	FN9mNtpb60wBGrgubtomKWrH4aBEAkkocYVtSHT1UbKSYR5AWOlNEJH2Ui1xEbDSoYaf43
	1OHyRZtX1VN5papX5S08AZx64qe2I7E=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-gpPQRulhOGmPqfeNyyNZyw-1; Tue, 25 Jul 2023 02:43:14 -0400
X-MC-Unique: gpPQRulhOGmPqfeNyyNZyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE71D3C10171;
	Tue, 25 Jul 2023 06:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91978C2C860;
	Tue, 25 Jul 2023 06:42:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E0111937114;
	Tue, 25 Jul 2023 06:42:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D5E5A1946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Jul 2023 09:54:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6F6340C2063; Mon, 24 Jul 2023 09:54:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AFAA040C206F
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 09:54:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C5FD185A793
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 09:54:31 +0000 (UTC)
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com
 [209.85.214.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-208-CyjxRS_8OYerPysM_MvKwQ-1; Mon, 24 Jul 2023 05:54:29 -0400
X-MC-Unique: CyjxRS_8OYerPysM_MvKwQ-1
Received: by mail-pl1-f180.google.com with SMTP id
 d9443c01a7336-1bb91c20602so2238045ad.0
 for <dm-devel@redhat.com>; Mon, 24 Jul 2023 02:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690192469; x=1690797269;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=F/oK6bm2Afi7WKsfFLPLaSlUUie3UdhMRHX1z52bb4o=;
 b=BhYZyg2EW5Mk4SjIMCWn3MdGkVjFqoIEVZub9dWX9CnVjqF8lhwG+92lWON92V3xj+
 WgTuNy3dFFL47LWopVY2e589ghbN3fgh2TOIaODkfa2r88B8yLxbrDPy71AMFeqwDj83
 wSqe9CiaWbCO3mkDMyLeaE8VIXVXF4BUjIf1ZqmE8Yp3tFx/zeNmhC2UR8BxJfOT4Cyz
 y4gBWTM9bPNfxhywJQhkW8hb1uYnXPngtwanyjh5HCZKhZFDvNiv1/sYLiwZQ56fu/TU
 3oV3jvz5gk8QcyhrcNziLq56nzRkqBXisgpF8NWp8+M3jEUHlSq84gODQ+eJpzeVRGyX
 Fv4Q==
X-Gm-Message-State: ABy/qLY4wk7tw5S4Fc+LubCibIV85BKHJVUTSlRGEv0KuEEJ2f9nRk0P
 TfqV5qZv0x9Z8Iq28X91+qpyCw==
X-Google-Smtp-Source: APBJJlFeSJXGwKM1/4Fx4M034iEieIqp39l7VwM/I3gIgSntmWk50xYbsW/3q3bB2XT8c22SamI2Bg==
X-Received: by 2002:a17:902:dad2:b0:1b8:9fc4:2733 with SMTP id
 q18-20020a170902dad200b001b89fc42733mr12483608plx.3.1690192468770; 
 Mon, 24 Jul 2023 02:54:28 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.54.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 24 Jul 2023 02:54:28 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev
Date: Mon, 24 Jul 2023 17:43:54 +0800
Message-Id: <20230724094354.90817-48-zhengqi.arch@bytedance.com>
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 25 Jul 2023 06:42:42 +0000
Subject: [dm-devel] [PATCH v2 47/47] mm: shrinker: convert shrinker_rwsem to
 mutex
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
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-mtd@lists.infradead.org, x86@kernel.org,
 cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, linux-arm-msm@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 linux-raid@vger.kernel.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now there are no readers of shrinker_rwsem, so we can simply replace it
with mutex lock.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/md/dm-cache-metadata.c |  2 +-
 fs/super.c                     |  2 +-
 mm/shrinker.c                  | 16 ++++++++--------
 mm/shrinker_debug.c            | 14 +++++++-------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index acffed750e3e..9e0c69958587 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1828,7 +1828,7 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
 	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
 	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
-	 * - must take shrinker_rwsem without holding cmd->root_lock
+	 * - must take shrinker_mutex without holding cmd->root_lock
 	 */
 	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 CACHE_MAX_CONCURRENT_LOCKS);
diff --git a/fs/super.c b/fs/super.c
index 04643fd80886..602cf54eb7da 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -54,7 +54,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
- * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
+ * shrinker path and that leads to deadlock on the shrinker_mutex. Hence we
  * take a passive reference to the superblock to avoid this from occurring.
  */
 static unsigned long super_cache_scan(struct shrinker *shrink,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 90c045620fe3..5c4546d2c234 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -7,7 +7,7 @@
 #include <trace/events/vmscan.h>
 
 LIST_HEAD(shrinker_list);
-DECLARE_RWSEM(shrinker_rwsem);
+DEFINE_MUTEX(shrinker_mutex);
 DEFINE_SPINLOCK(shrinker_lock);
 
 #ifdef CONFIG_MEMCG
@@ -80,7 +80,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 	int nid, ret = 0;
 	int array_size = 0;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	array_size = shrinker_unit_size(shrinker_nr_max);
 	for_each_node(nid) {
 		info = kvzalloc_node(sizeof(*info) + array_size, GFP_KERNEL, nid);
@@ -91,7 +91,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 			goto err;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 
@@ -104,7 +104,7 @@ static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
 						     int nid)
 {
 	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 lockdep_is_held(&shrinker_rwsem));
+					 lockdep_is_held(&shrinker_mutex));
 }
 
 static struct shrinker_info *shrinker_info_rcu(struct mem_cgroup *memcg,
@@ -158,7 +158,7 @@ static int expand_shrinker_info(int new_id)
 	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 
 	if (!root_mem_cgroup)
 		goto out;
@@ -179,7 +179,7 @@ static int expand_shrinker_info(int new_id)
 	if (!ret)
 		shrinker_nr_max = new_nr_max;
 
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 }
@@ -303,7 +303,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -316,7 +316,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index badda35464c3..44b620b1919d 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -8,7 +8,7 @@
 #include <linux/rculist.h>
 
 /* defined in vmscan.c */
-extern struct rw_semaphore shrinker_rwsem;
+extern struct mutex shrinker_mutex;
 extern struct list_head shrinker_list;
 
 static DEFINE_IDA(shrinker_debugfs_ida);
@@ -168,7 +168,7 @@ int shrinker_debugfs_add(struct shrinker *shrinker)
 	if (!shrinker_debugfs_root)
 		return 0;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	if (shrinker->debugfs_entry)
 		goto fail;
 
@@ -196,7 +196,7 @@ int shrinker_debugfs_add(struct shrinker *shrinker)
 			    &shrinker_debugfs_scan_fops);
 
 fail:
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 	return ret;
 }
 
@@ -215,7 +215,7 @@ int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 	if (!new)
 		return -ENOMEM;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 
 	old = shrinker->name;
 	shrinker->name = new;
@@ -233,7 +233,7 @@ int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 			shrinker->debugfs_entry = entry;
 	}
 
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	kfree_const(old);
 
@@ -246,7 +246,7 @@ struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
 {
 	struct dentry *entry = shrinker->debugfs_entry;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
 
@@ -257,7 +257,7 @@ struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
 	 */
 	smp_wmb();
 	shrinker->debugfs_entry = NULL;
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return entry;
 }
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

