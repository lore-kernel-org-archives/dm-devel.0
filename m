Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D676C1118D
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 06:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="vzTSxL5E"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5c68da9d639so2010697a12.3
        for <dm-devel@lists.linux.dev>; Tue, 05 Dec 2023 22:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701842798; x=1702447598; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fxgjHIY+i+wILRYpSYSEatYEwrJqDdx6PzPhkDcv2Y=;
        b=vzTSxL5Ef9h7yuQMKG1tE3hX89TOGHyXIsXAsx4dyYWgR3tnDytVdiVANaFThmu7ow
         Zqb5uyZrsgJNUGU9OpHO37ppuaOzyyaBhfmI/AnPA/H/1XrASeGbyj+507oZiD6lFocj
         zZOeX5JoZ9V9P4b8leP0LfB7bG4qDgsb9GEKEsuaV+J4lHNK6b37uczVMWsQxEHoHnkS
         DLkoWzdSkfZJRBOI25xHmY1I1BTea18mFZ0FC4eje5dl0RUlz1nCSm685Nujz8BaiV7a
         A8iBKUCy04kcr+ZR5i2UTpgLT1BDye3KVVAiHuBka7MUp2yBoxqGVAHCBnvD5vR8XBXH
         DFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701842798; x=1702447598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fxgjHIY+i+wILRYpSYSEatYEwrJqDdx6PzPhkDcv2Y=;
        b=e9UIFqhWIAFauy7IuqXgHiJBPAqu20QsbP1JJpukSJOUlRk8rii4LyCzgJPaBv0/1Z
         UnigD7gve62goIdGW/eAJH4yrSWUQnXE0ms3IiYj4XZAjR0UbQIjhmjzuc0CUysyH1GT
         m18fdG98rBlpxRY1Wfqr1e/izSCPKywmLqOI7o2CERwbDTre9HTxvFhVAwF8mtTBi1Jo
         Z+Oa4zJMkvXYmbKpy5jHFEN/f1GvmeGXYe1Qny9BvnKStsHQofnuvtshOLrcu0Y+Oyza
         9YzvhzdxmrclDBFKvc6L9KoLxSVgA8XQqOzrkgaBcPTkx2V7aEO8d8ICO7KwUuGkXGmj
         bYrQ==
X-Gm-Message-State: AOJu0Yw0waxEZtWJTxp7JAh7mU9SnvM93DtjYEG+f7H7EziQlBjWHfUI
	+FsGWk2xDUlvOJTaG9bVGnrv1A==
X-Google-Smtp-Source: AGHT+IFaRusOCnlTqKyhQX2TmiINjReQS73wsX4XhW7l8zr6yWbnE5nsO3OQlJ5zjUwEdtZUgvxNGw==
X-Received: by 2002:a05:6a20:a426:b0:18f:97c:823e with SMTP id z38-20020a056a20a42600b0018f097c823emr186921pzk.72.1701842797795;
        Tue, 05 Dec 2023 22:06:37 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id 13-20020a17090a08cd00b002868f5c2847sm2240355pjn.7.2023.12.05.22.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 22:06:34 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rAl3H-004VOm-3D;
	Wed, 06 Dec 2023 17:06:31 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rAl3H-0000000BrVG-2K9L;
	Wed, 06 Dec 2023 17:06:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-cachefs@redhat.com,
	dhowells@redhat.com,
	gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] lib/dlock-list: Make sibling CPUs share the same linked list
Date: Wed,  6 Dec 2023 17:05:33 +1100
Message-ID: <20231206060629.2827226-5-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231206060629.2827226-1-david@fromorbit.com>
References: <20231206060629.2827226-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

The dlock list needs one list for each of the CPUs available. However,
for sibling CPUs, they are sharing the L2 and probably L1 caches
too. As a result, there is not much to gain in term of avoiding
cacheline contention while increasing the cacheline footprint of the
L1/L2 caches as separate lists may need to be in the cache.

This patch makes all the sibling CPUs share the same list, thus
reducing the number of lists that need to be maintained in each
dlock list without having any noticeable impact on performance. It
also improves dlock list iteration performance as fewer lists need
to be iterated.

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 lib/dlock-list.c | 74 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 59 insertions(+), 15 deletions(-)

diff --git a/lib/dlock-list.c b/lib/dlock-list.c
index f64ea4cc5e79..e2860944ec9f 100644
--- a/lib/dlock-list.c
+++ b/lib/dlock-list.c
@@ -25,31 +25,65 @@
  * The distributed and locked list is a distributed set of lists each of
  * which is protected by its own spinlock, but acts like a single
  * consolidated list to the callers. For scaling purpose, the number of
- * lists used is equal to the number of possible CPUs in the system to
- * minimize contention.
+ * lists used is equal to the number of possible cores in the system to
+ * minimize contention. All threads of the same CPU core will share the
+ * same list.
  *
- * However, it is possible that individual CPU numbers may be equal to
- * or greater than the number of possible CPUs when there are holes in
- * the CPU number list. As a result, we need to map the CPU number to a
- * list index.
+ * We need to map each CPU number to a list index.
  */
 static DEFINE_PER_CPU_READ_MOSTLY(int, cpu2idx);
+static int nr_dlock_lists __read_mostly;
 
 /*
- * Initialize cpu2idx mapping table
+ * Initialize cpu2idx mapping table & nr_dlock_lists.
  *
  * It is possible that a dlock-list can be allocated before the cpu2idx is
  * initialized. In this case, all the cpus are mapped to the first entry
  * before initialization.
  *
+ * All the sibling CPUs of a sibling group will map to the same dlock list so
+ * as to reduce the number of dlock lists to be maintained while minimizing
+ * cacheline contention.
+ *
+ * As the sibling masks are set up in the core initcall phase, this function
+ * has to be done in the postcore phase to get the right data.
  */
 static int __init cpu2idx_init(void)
 {
 	int idx, cpu;
+	struct cpumask *sibling_mask;
+	static struct cpumask mask __initdata;
 
+	cpumask_clear(&mask);
 	idx = 0;
-	for_each_possible_cpu(cpu)
-		per_cpu(cpu2idx, cpu) = idx++;
+	for_each_possible_cpu(cpu) {
+		int scpu;
+
+		if (cpumask_test_cpu(cpu, &mask))
+			continue;
+		per_cpu(cpu2idx, cpu) = idx;
+		cpumask_set_cpu(cpu, &mask);
+
+		sibling_mask = topology_sibling_cpumask(cpu);
+		if (sibling_mask) {
+			for_each_cpu(scpu, sibling_mask) {
+				per_cpu(cpu2idx, scpu) = idx;
+				cpumask_set_cpu(scpu, &mask);
+			}
+		}
+		idx++;
+	}
+
+	/*
+	 * nr_dlock_lists can only be set after cpu2idx is properly
+	 * initialized.
+	 */
+	smp_mb();
+	nr_dlock_lists = idx;
+	WARN_ON(nr_dlock_lists > nr_cpu_ids);
+
+	pr_info("dlock-list: %d head entries per dlock list.\n",
+		nr_dlock_lists);
 	return 0;
 }
 postcore_initcall(cpu2idx_init);
@@ -67,19 +101,23 @@ postcore_initcall(cpu2idx_init);
  *
  * Dynamically allocated locks need to have their own special lock class
  * to avoid lockdep warning.
+ *
+ * Since nr_dlock_lists will always be <= nr_cpu_ids, having more lists
+ * than necessary allocated is not a problem other than some wasted memory.
+ * The extra lists will not be ever used as all the cpu2idx entries will be
+ * 0 before initialization.
  */
 int __alloc_dlock_list_heads(struct dlock_list_heads *dlist,
 			     struct lock_class_key *key)
 {
-	int idx;
+	int idx, cnt = nr_dlock_lists ? nr_dlock_lists : nr_cpu_ids;
 
-	dlist->heads = kcalloc(nr_cpu_ids, sizeof(struct dlock_list_head),
-			       GFP_KERNEL);
+	dlist->heads = kcalloc(cnt, sizeof(struct dlock_list_head), GFP_KERNEL);
 
 	if (!dlist->heads)
 		return -ENOMEM;
 
-	for (idx = 0; idx < nr_cpu_ids; idx++) {
+	for (idx = 0; idx < cnt; idx++) {
 		struct dlock_list_head *head = &dlist->heads[idx];
 
 		INIT_LIST_HEAD(&head->list);
@@ -117,7 +155,10 @@ bool dlock_lists_empty(struct dlock_list_heads *dlist)
 {
 	int idx;
 
-	for (idx = 0; idx < nr_cpu_ids; idx++)
+	/* Shouldn't be called before nr_dlock_lists is initialized */
+	WARN_ON_ONCE(!nr_dlock_lists);
+
+	for (idx = 0; idx < nr_dlock_lists; idx++)
 		if (!list_empty(&dlist->heads[idx].list))
 			return false;
 	return true;
@@ -199,6 +240,9 @@ struct dlock_list_node *__dlock_list_next_list(struct dlock_list_iter *iter)
 	struct dlock_list_node *next;
 	struct dlock_list_head *head;
 
+	/* Shouldn't be called before nr_dlock_lists is initialized */
+	WARN_ON_ONCE(!nr_dlock_lists);
+
 restart:
 	if (iter->entry) {
 		spin_unlock(&iter->entry->lock);
@@ -209,7 +253,7 @@ struct dlock_list_node *__dlock_list_next_list(struct dlock_list_iter *iter)
 	/*
 	 * Try next list
 	 */
-	if (++iter->index >= nr_cpu_ids)
+	if (++iter->index >= nr_dlock_lists)
 		return NULL;	/* All the entries iterated */
 
 	if (list_empty(&iter->head[iter->index].list))
-- 
2.42.0

