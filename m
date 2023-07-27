Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E08C04FE1
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jul 2023 17:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690480527;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Kdl9lhknYYaVuLRxDc1csyt567Id+peY9k3xWc0s5hY=;
	b=Dd8f0eiHvlT23ysavCd+aki/vimIqYEg6eBjELBpyTNqxoLvoKJ0NfDK1yAJ+IOmqHXePi
	cHyFmFssNYIRSa6hCPz0vBZEIZ9xWCFsGc1ryzX0e7+eLfFG2q0YJXfPUtFPeSyLqY9eJ/
	UeMUJwx8IbCnAsfvRjL7yTS3e65l9Rk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-692-EU8GARR8P-OVQBy8UaRF_A-1; Thu, 27 Jul 2023 13:55:22 -0400
X-MC-Unique: EU8GARR8P-OVQBy8UaRF_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC75C3811F40;
	Thu, 27 Jul 2023 17:55:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D74A6200BA73;
	Thu, 27 Jul 2023 17:55:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5D194193759D;
	Thu, 27 Jul 2023 17:54:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8D391946A6C
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Jul 2023 08:15:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9192E1121339; Thu, 27 Jul 2023 08:15:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89CC51121330
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:15:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1E61104458B
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 08:15:02 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-gvug-mMaM1622ZfY_6CCRw-1; Thu, 27 Jul 2023 04:14:59 -0400
X-MC-Unique: gvug-mMaM1622ZfY_6CCRw-1
Received: by mail-pf1-f175.google.com with SMTP id
 d2e1a72fcca58-6862d4a1376so189958b3a.0
 for <dm-devel@redhat.com>; Thu, 27 Jul 2023 01:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1690445698; x=1691050498;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=hyLc13iHrkV+klh05yD71xFAgQY4jD2CPzn+LZNOh3k=;
 b=dSDX1znxyrVvGYDlipvjP2N2BPPZaT0aq/r3o31G/fjszqolYeLTOCh1kAkq0jSpGK
 GxKHoAODHtqu3i0+Q1eL/qAOfLpnQf+pQKoAMFQnEk05xj+v4gqOBVuMa3+X4tgSJnux
 7OtyPCWaivCg1xx7pX/Zy5dW+k0SMLSAw9t4WCwB9GH6U621krp0es3MKEcjtOxByrRG
 DPGby+O7BH82omR0XVrDan5KOYBSnJGb4oTryJLxjLLHBLbMVMvBEoephumm/aZ9HE+3
 26QTTw10HdDMyF8IWjfqBItJv0v4dzmlBzAwBnKqnJpa+iAJE9xsANCy7X/ZWqSaRd4P
 3BLg==
X-Gm-Message-State: ABy/qLafVpNYzCdp7mZhx39m7B/LCAn6c8+Bvomn7P1dBjKi+sZzbR35
 AJbddvRNdvqa30uNqrYq4HNUSg==
X-Google-Smtp-Source: APBJJlHHYMtR97FgZwPKg/I4FvBtMIi/WenRh8r+QxTKT4uZnBzRavnMRN782PTiMjlEUg18pWA/Fw==
X-Received: by 2002:a05:6a20:8f23:b0:137:8ddf:4647 with SMTP id
 b35-20020a056a208f2300b001378ddf4647mr5934103pzk.2.1690445698478; 
 Thu, 27 Jul 2023 01:14:58 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
 by smtp.gmail.com with ESMTPSA id
 j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.14.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 27 Jul 2023 01:14:58 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev
Date: Thu, 27 Jul 2023 16:04:58 +0800
Message-Id: <20230727080502.77895-46-zhengqi.arch@bytedance.com>
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 27 Jul 2023 17:54:53 +0000
Subject: [dm-devel] [PATCH v3 45/49] mm: shrinker: add a secondary array for
 shrinker_info::{map, nr_deferred}
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
 Muchun Song <songmuchun@bytedance.com>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, we maintain two linear arrays per node per memcg, which are
shrinker_info::map and shrinker_info::nr_deferred. And we need to resize
them when the shrinker_nr_max is exceeded, that is, allocate a new array,
and then copy the old array to the new array, and finally free the old
array by RCU.

For shrinker_info::map, we do set_bit() under the RCU lock, so we may set
the value into the old map which is about to be freed. This may cause the
value set to be lost. The current solution is not to copy the old map when
resizing, but to set all the corresponding bits in the new map to 1. This
solves the data loss problem, but bring the overhead of more pointless
loops while doing memcg slab shrink.

For shrinker_info::nr_deferred, we will only modify it under the read lock
of shrinker_rwsem, so it will not run concurrently with the resizing. But
after we make memcg slab shrink lockless, there will be the same data loss
problem as shrinker_info::map, and we can't work around it like the map.

For such resizable arrays, the most straightforward idea is to change it
to xarray, like we did for list_lru [1]. We need to do xa_store() in the
list_lru_add()-->set_shrinker_bit(), but this will cause memory
allocation, and the list_lru_add() doesn't accept failure. A possible
solution is to pre-allocate, but the location of pre-allocation is not
well determined.

Therefore, this commit chooses to introduce a secondary array for
shrinker_info::{map, nr_deferred}, so that we only need to copy this
secondary array every time the size is resized. Then even if we get the
old secondary array under the RCU lock, the found map and nr_deferred are
also true, so no data is lost.

[1]. https://lore.kernel.org/all/20220228122126.37293-13-songmuchun@bytedance.com/

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memcontrol.h |  12 +-
 include/linux/shrinker.h   |  17 +++
 mm/shrinker.c              | 250 +++++++++++++++++++++++--------------
 3 files changed, 172 insertions(+), 107 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e765d1ff9cbb..2c9327d27c3b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -21,6 +21,7 @@
 #include <linux/vmstat.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
+#include <linux/shrinker.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -88,17 +89,6 @@ struct mem_cgroup_reclaim_iter {
 	unsigned int generation;
 };
 
-/*
- * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
- * shrinkers, which have elements charged to this memcg.
- */
-struct shrinker_info {
-	struct rcu_head rcu;
-	atomic_long_t *nr_deferred;
-	unsigned long *map;
-	int map_nr_max;
-};
-
 struct lruvec_stats_percpu {
 	/* Local (CPU and cgroup) state */
 	long state[NR_VM_NODE_STAT_ITEMS];
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 025c8070dd86..eb342994675a 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -5,6 +5,23 @@
 #include <linux/atomic.h>
 #include <linux/types.h>
 
+#define SHRINKER_UNIT_BITS	BITS_PER_LONG
+
+/*
+ * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
+ * shrinkers, which have elements charged to the memcg.
+ */
+struct shrinker_info_unit {
+	atomic_long_t nr_deferred[SHRINKER_UNIT_BITS];
+	DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
+};
+
+struct shrinker_info {
+	struct rcu_head rcu;
+	int map_nr_max;
+	struct shrinker_info_unit *unit[];
+};
+
 /*
  * This struct is used to pass information from page reclaim to the shrinkers.
  * We consolidate the values for easier extension later.
diff --git a/mm/shrinker.c b/mm/shrinker.c
index a27779ed3798..1911c06b8af5 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -12,15 +12,50 @@ DECLARE_RWSEM(shrinker_rwsem);
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
 
-/* The shrinker_info is expanded in a batch of BITS_PER_LONG */
-static inline int shrinker_map_size(int nr_items)
+static inline int shrinker_unit_size(int nr_items)
 {
-	return (DIV_ROUND_UP(nr_items, BITS_PER_LONG) * sizeof(unsigned long));
+	return (DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * sizeof(struct shrinker_info_unit *));
 }
 
-static inline int shrinker_defer_size(int nr_items)
+static inline void shrinker_unit_free(struct shrinker_info *info, int start)
 {
-	return (round_up(nr_items, BITS_PER_LONG) * sizeof(atomic_long_t));
+	struct shrinker_info_unit **unit;
+	int nr, i;
+
+	if (!info)
+		return;
+
+	unit = info->unit;
+	nr = DIV_ROUND_UP(info->map_nr_max, SHRINKER_UNIT_BITS);
+
+	for (i = start; i < nr; i++) {
+		if (!unit[i])
+			break;
+
+		kvfree(unit[i]);
+		unit[i] = NULL;
+	}
+}
+
+static inline int shrinker_unit_alloc(struct shrinker_info *new,
+				       struct shrinker_info *old, int nid)
+{
+	struct shrinker_info_unit *unit;
+	int nr = DIV_ROUND_UP(new->map_nr_max, SHRINKER_UNIT_BITS);
+	int start = old ? DIV_ROUND_UP(old->map_nr_max, SHRINKER_UNIT_BITS) : 0;
+	int i;
+
+	for (i = start; i < nr; i++) {
+		unit = kvzalloc_node(sizeof(*unit), GFP_KERNEL, nid);
+		if (!unit) {
+			shrinker_unit_free(new, start);
+			return -ENOMEM;
+		}
+
+		new->unit[i] = unit;
+	}
+
+	return 0;
 }
 
 void free_shrinker_info(struct mem_cgroup *memcg)
@@ -32,6 +67,7 @@ void free_shrinker_info(struct mem_cgroup *memcg)
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
 		info = rcu_dereference_protected(pn->shrinker_info, true);
+		shrinker_unit_free(info, 0);
 		kvfree(info);
 		rcu_assign_pointer(pn->shrinker_info, NULL);
 	}
@@ -40,28 +76,27 @@ void free_shrinker_info(struct mem_cgroup *memcg)
 int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	struct shrinker_info *info;
-	int nid, size, ret = 0;
-	int map_size, defer_size = 0;
+	int nid, ret = 0;
+	int array_size = 0;
 
 	down_write(&shrinker_rwsem);
-	map_size = shrinker_map_size(shrinker_nr_max);
-	defer_size = shrinker_defer_size(shrinker_nr_max);
-	size = map_size + defer_size;
+	array_size = shrinker_unit_size(shrinker_nr_max);
 	for_each_node(nid) {
-		info = kvzalloc_node(sizeof(*info) + size, GFP_KERNEL, nid);
-		if (!info) {
-			free_shrinker_info(memcg);
-			ret = -ENOMEM;
-			break;
-		}
-		info->nr_deferred = (atomic_long_t *)(info + 1);
-		info->map = (void *)info->nr_deferred + defer_size;
+		info = kvzalloc_node(sizeof(*info) + array_size, GFP_KERNEL, nid);
+		if (!info)
+			goto err;
 		info->map_nr_max = shrinker_nr_max;
+		if (shrinker_unit_alloc(info, NULL, nid))
+			goto err;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
 	up_write(&shrinker_rwsem);
 
 	return ret;
+
+err:
+	free_shrinker_info(memcg);
+	return -ENOMEM;
 }
 
 static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
@@ -71,15 +106,12 @@ static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
 					 lockdep_is_held(&shrinker_rwsem));
 }
 
-static int expand_one_shrinker_info(struct mem_cgroup *memcg,
-				    int map_size, int defer_size,
-				    int old_map_size, int old_defer_size,
-				    int new_nr_max)
+static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
+				    int old_size, int new_nr_max)
 {
 	struct shrinker_info *new, *old;
 	struct mem_cgroup_per_node *pn;
 	int nid;
-	int size = map_size + defer_size;
 
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
@@ -92,21 +124,18 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg,
 		if (new_nr_max <= old->map_nr_max)
 			continue;
 
-		new = kvmalloc_node(sizeof(*new) + size, GFP_KERNEL, nid);
+		new = kvmalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);
 		if (!new)
 			return -ENOMEM;
 
-		new->nr_deferred = (atomic_long_t *)(new + 1);
-		new->map = (void *)new->nr_deferred + defer_size;
 		new->map_nr_max = new_nr_max;
 
-		/* map: set all old bits, clear all new bits */
-		memset(new->map, (int)0xff, old_map_size);
-		memset((void *)new->map + old_map_size, 0, map_size - old_map_size);
-		/* nr_deferred: copy old values, clear all new values */
-		memcpy(new->nr_deferred, old->nr_deferred, old_defer_size);
-		memset((void *)new->nr_deferred + old_defer_size, 0,
-		       defer_size - old_defer_size);
+		/* copy old values, allocate all new values */
+		memcpy(new->unit, old->unit, old_size);
+		if (shrinker_unit_alloc(new, old, nid)) {
+			kvfree(new);
+			return -ENOMEM;
+		}
 
 		rcu_assign_pointer(pn->shrinker_info, new);
 		kvfree_rcu(old, rcu);
@@ -118,9 +147,8 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg,
 static int expand_shrinker_info(int new_id)
 {
 	int ret = 0;
-	int new_nr_max = round_up(new_id + 1, BITS_PER_LONG);
-	int map_size, defer_size = 0;
-	int old_map_size, old_defer_size = 0;
+	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
+	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 
 	if (!root_mem_cgroup)
@@ -128,15 +156,12 @@ static int expand_shrinker_info(int new_id)
 
 	lockdep_assert_held(&shrinker_rwsem);
 
-	map_size = shrinker_map_size(new_nr_max);
-	defer_size = shrinker_defer_size(new_nr_max);
-	old_map_size = shrinker_map_size(shrinker_nr_max);
-	old_defer_size = shrinker_defer_size(shrinker_nr_max);
+	new_size = shrinker_unit_size(new_nr_max);
+	old_size = shrinker_unit_size(shrinker_nr_max);
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		ret = expand_one_shrinker_info(memcg, map_size, defer_size,
-					       old_map_size, old_defer_size,
+		ret = expand_one_shrinker_info(memcg, new_size, old_size,
 					       new_nr_max);
 		if (ret) {
 			mem_cgroup_iter_break(NULL, memcg);
@@ -150,17 +175,34 @@ static int expand_shrinker_info(int new_id)
 	return ret;
 }
 
+static inline int shriner_id_to_index(int shrinker_id)
+{
+	return shrinker_id / SHRINKER_UNIT_BITS;
+}
+
+static inline int shriner_id_to_offset(int shrinker_id)
+{
+	return shrinker_id % SHRINKER_UNIT_BITS;
+}
+
+static inline int calc_shrinker_id(int index, int offset)
+{
+	return index * SHRINKER_UNIT_BITS + offset;
+}
+
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
 		struct shrinker_info *info;
+		struct shrinker_info_unit *unit;
 
 		rcu_read_lock();
 		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+		unit = info->unit[shriner_id_to_index(shrinker_id)];
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
 			/* Pairs with smp mb in shrink_slab() */
 			smp_mb__before_atomic();
-			set_bit(shrinker_id, info->map);
+			set_bit(shriner_id_to_offset(shrinker_id), unit->map);
 		}
 		rcu_read_unlock();
 	}
@@ -209,26 +251,31 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 				   struct mem_cgroup *memcg)
 {
 	struct shrinker_info *info;
+	struct shrinker_info_unit *unit;
 
 	info = shrinker_info_protected(memcg, nid);
-	return atomic_long_xchg(&info->nr_deferred[shrinker->id], 0);
+	unit = info->unit[shriner_id_to_index(shrinker->id)];
+	return atomic_long_xchg(&unit->nr_deferred[shriner_id_to_offset(shrinker->id)], 0);
 }
 
 static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 				  struct mem_cgroup *memcg)
 {
 	struct shrinker_info *info;
+	struct shrinker_info_unit *unit;
 
 	info = shrinker_info_protected(memcg, nid);
-	return atomic_long_add_return(nr, &info->nr_deferred[shrinker->id]);
+	unit = info->unit[shriner_id_to_index(shrinker->id)];
+	return atomic_long_add_return(nr, &unit->nr_deferred[shriner_id_to_offset(shrinker->id)]);
 }
 
 void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 {
-	int i, nid;
+	int nid, index, offset;
 	long nr;
 	struct mem_cgroup *parent;
 	struct shrinker_info *child_info, *parent_info;
+	struct shrinker_info_unit *child_unit, *parent_unit;
 
 	parent = parent_mem_cgroup(memcg);
 	if (!parent)
@@ -239,9 +286,13 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
-		for (i = 0; i < child_info->map_nr_max; i++) {
-			nr = atomic_long_read(&child_info->nr_deferred[i]);
-			atomic_long_add(nr, &parent_info->nr_deferred[i]);
+		for (index = 0; index < shriner_id_to_index(child_info->map_nr_max); index++) {
+			child_unit = child_info->unit[index];
+			parent_unit = parent_info->unit[index];
+			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
+				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
+				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
+			}
 		}
 	}
 	up_read(&shrinker_rwsem);
@@ -407,7 +458,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 {
 	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
-	int i;
+	int offset, index = 0;
 
 	if (!mem_cgroup_online(memcg))
 		return 0;
@@ -419,56 +470,63 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	if (unlikely(!info))
 		goto unlock;
 
-	for_each_set_bit(i, info->map, info->map_nr_max) {
-		struct shrink_control sc = {
-			.gfp_mask = gfp_mask,
-			.nid = nid,
-			.memcg = memcg,
-		};
-		struct shrinker *shrinker;
+	for (; index < shriner_id_to_index(info->map_nr_max); index++) {
+		struct shrinker_info_unit *unit;
 
-		shrinker = idr_find(&shrinker_idr, i);
-		if (unlikely(!shrinker || !(shrinker->flags & SHRINKER_REGISTERED))) {
-			if (!shrinker)
-				clear_bit(i, info->map);
-			continue;
-		}
+		unit = info->unit[index];
 
-		/* Call non-slab shrinkers even though kmem is disabled */
-		if (!memcg_kmem_online() &&
-		    !(shrinker->flags & SHRINKER_NONSLAB))
-			continue;
+		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) {
+			struct shrink_control sc = {
+				.gfp_mask = gfp_mask,
+				.nid = nid,
+				.memcg = memcg,
+			};
+			struct shrinker *shrinker;
+			int shrinker_id = calc_shrinker_id(index, offset);
 
-		ret = do_shrink_slab(&sc, shrinker, priority);
-		if (ret == SHRINK_EMPTY) {
-			clear_bit(i, info->map);
-			/*
-			 * After the shrinker reported that it had no objects to
-			 * free, but before we cleared the corresponding bit in
-			 * the memcg shrinker map, a new object might have been
-			 * added. To make sure, we have the bit set in this
-			 * case, we invoke the shrinker one more time and reset
-			 * the bit if it reports that it is not empty anymore.
-			 * The memory barrier here pairs with the barrier in
-			 * set_shrinker_bit():
-			 *
-			 * list_lru_add()     shrink_slab_memcg()
-			 *   list_add_tail()    clear_bit()
-			 *   <MB>               <MB>
-			 *   set_bit()          do_shrink_slab()
-			 */
-			smp_mb__after_atomic();
-			ret = do_shrink_slab(&sc, shrinker, priority);
-			if (ret == SHRINK_EMPTY)
-				ret = 0;
-			else
-				set_shrinker_bit(memcg, nid, i);
-		}
-		freed += ret;
+			shrinker = idr_find(&shrinker_idr, shrinker_id);
+			if (unlikely(!shrinker || !(shrinker->flags & SHRINKER_REGISTERED))) {
+				if (!shrinker)
+					clear_bit(offset, unit->map);
+				continue;
+			}
 
-		if (rwsem_is_contended(&shrinker_rwsem)) {
-			freed = freed ? : 1;
-			break;
+			/* Call non-slab shrinkers even though kmem is disabled */
+			if (!memcg_kmem_online() &&
+			    !(shrinker->flags & SHRINKER_NONSLAB))
+				continue;
+
+			ret = do_shrink_slab(&sc, shrinker, priority);
+			if (ret == SHRINK_EMPTY) {
+				clear_bit(offset, unit->map);
+				/*
+				 * After the shrinker reported that it had no objects to
+				 * free, but before we cleared the corresponding bit in
+				 * the memcg shrinker map, a new object might have been
+				 * added. To make sure, we have the bit set in this
+				 * case, we invoke the shrinker one more time and reset
+				 * the bit if it reports that it is not empty anymore.
+				 * The memory barrier here pairs with the barrier in
+				 * set_shrinker_bit():
+				 *
+				 * list_lru_add()     shrink_slab_memcg()
+				 *   list_add_tail()    clear_bit()
+				 *   <MB>               <MB>
+				 *   set_bit()          do_shrink_slab()
+				 */
+				smp_mb__after_atomic();
+				ret = do_shrink_slab(&sc, shrinker, priority);
+				if (ret == SHRINK_EMPTY)
+					ret = 0;
+				else
+					set_shrinker_bit(memcg, nid, shrinker_id);
+			}
+			freed += ret;
+
+			if (rwsem_is_contended(&shrinker_rwsem)) {
+				freed = freed ? : 1;
+				goto unlock;
+			}
 		}
 	}
 unlock:
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

