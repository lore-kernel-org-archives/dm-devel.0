Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20252C0729B
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 06:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691477636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GvLWEzHAIWezI8DYtJZgjDN+30HEdnGzzCwmf9orwSw=;
	b=Y/pT3WZqYd2OO8qoU3AqYAQMPEncWnYxH2EMb8bVtVp/tUSht6bBSzdf0+xDBF2Sx9PfTq
	CBBevueO9PIENuxwKTeut3quHxBIJqw5s+tSXwQlgi0c5QrwFm84Fh+uuTmM6Ca/ROwbZL
	u7UZ3l+p2DzdvhFLTivIPzkrNuoBsy8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-RfVrfOLHP8mT79_1SXVbnw-1; Tue, 08 Aug 2023 02:53:52 -0400
X-MC-Unique: RfVrfOLHP8mT79_1SXVbnw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 016F318E6C69;
	Tue,  8 Aug 2023 06:53:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6963112132D;
	Tue,  8 Aug 2023 06:53:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F39219452C2;
	Tue,  8 Aug 2023 06:53:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5E48B1946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Aug 2023 11:19:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 405C2C15BAE; Mon,  7 Aug 2023 11:19:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 38762C15BAD
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:19:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15C023810D2C
 for <dm-devel@redhat.com>; Mon,  7 Aug 2023 11:19:50 +0000 (UTC)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-q0R6LcNTNlujUe6TNeP_-w-1; Mon, 07 Aug 2023 07:19:48 -0400
X-MC-Unique: q0R6LcNTNlujUe6TNeP_-w-1
Received: by mail-pg1-f170.google.com with SMTP id
 41be03b00d2f7-5648fca18b9so575742a12.0
 for <dm-devel@redhat.com>; Mon, 07 Aug 2023 04:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1691407187; x=1692011987;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kfKKsEp61SZUnTy00HUcIO/dAXsDrrCBrc1q4f5gA2g=;
 b=IIrZKaIkC7LLtO0h4SZQBULszXUVrnFCaHDpzPa9TVYoshXbySL6kQCYb64yrB9cKx
 CM2la0h00/b77aiw0mCP/IXOh9XLiAI9r7SueYjMVs5Hg4XtD/gOsxtVIVqPygOfnvPk
 iGH1lRXGeIe3KRmPIvoyLJ5Zb84GLa4IcUKxTp0XWVeV8QaJ/YVxir1Q5TRsw3suRWZZ
 AbiVKr26inl3wk+lnscaO83txvaL1l6kPDdNtKQJcr6pfbzwAOrPucY37Q9Cr/5rSmka
 TUeDSA8jxpRGcveEJ8pItTYqOPQ6FOWyhJRX3+IgtOlr6QWmALWZUA1lYFIUn1BbHxjj
 A6tg==
X-Gm-Message-State: ABy/qLZz1jSMBtEe6KKfNfriAlTcyPBaKu1Rnp4cXXW7NhRCFBUNBPNL
 z2eUc8GrpiS6Q2NNrrTW1oJdhw==
X-Google-Smtp-Source: APBJJlGG6pz8UXODUVvMLzBj3hYH8JYeumw11e9YZ9plh8RnP0KuzfFyuRP+T7CTu9v0n/nCJMsqhQ==
X-Received: by 2002:a17:90a:1090:b0:268:126c:8a8b with SMTP id
 c16-20020a17090a109000b00268126c8a8bmr24580285pja.3.1691407187287; 
 Mon, 07 Aug 2023 04:19:47 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
 by smtp.gmail.com with ESMTPSA id
 y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.19.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Aug 2023 04:19:46 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
 steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
 yujie.liu@intel.com, gregkh@linuxfoundation.org, muchun.song@linux.dev,
 simon.horman@corigine.com, dlemoal@kernel.org
Date: Mon,  7 Aug 2023 19:09:34 +0800
Message-Id: <20230807110936.21819-47-zhengqi.arch@bytedance.com>
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 08 Aug 2023 06:53:24 +0000
Subject: [dm-devel] [PATCH v4 46/48] mm: shrinker: make memcg slab shrink
 lockless
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Like global slab shrink, this commit also uses refcount+RCU method to make
memcg slab shrink lockless.

Use the following script to do slab shrink stress test:

```

DIR="/root/shrinker/memcg/mnt"

do_create()
{
    mkdir -p /sys/fs/cgroup/memory/test
    echo 4G > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
    for i in `seq 0 $1`;
    do
        mkdir -p /sys/fs/cgroup/memory/test/$i;
        echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
        mkdir -p $DIR/$i;
    done
}

do_mount()
{
    for i in `seq $1 $2`;
    do
        mount -t tmpfs $i $DIR/$i;
    done
}

do_touch()
{
    for i in `seq $1 $2`;
    do
        echo $$ > /sys/fs/cgroup/memory/test/$i/cgroup.procs;
        dd if=/dev/zero of=$DIR/$i/file$i bs=1M count=1 &
    done
}

case "$1" in
  touch)
    do_touch $2 $3
    ;;
  test)
    do_create 4000
    do_mount 0 4000
    do_touch 0 3000
    ;;
  *)
    exit 1
    ;;
esac
```

Save the above script, then run test and touch commands. Then we can use
the following perf command to view hotspots:

perf top -U -F 999

1) Before applying this patchset:

  40.44%  [kernel]            [k] down_read_trylock
  17.59%  [kernel]            [k] up_read
  13.64%  [kernel]            [k] pv_native_safe_halt
  11.90%  [kernel]            [k] shrink_slab
   8.21%  [kernel]            [k] idr_find
   2.71%  [kernel]            [k] _find_next_bit
   1.36%  [kernel]            [k] shrink_node
   0.81%  [kernel]            [k] shrink_lruvec
   0.80%  [kernel]            [k] __radix_tree_lookup
   0.50%  [kernel]            [k] do_shrink_slab
   0.21%  [kernel]            [k] list_lru_count_one
   0.16%  [kernel]            [k] mem_cgroup_iter

2) After applying this patchset:

  60.17%  [kernel]           [k] shrink_slab
  20.42%  [kernel]           [k] pv_native_safe_halt
   3.03%  [kernel]           [k] do_shrink_slab
   2.73%  [kernel]           [k] shrink_node
   2.27%  [kernel]           [k] shrink_lruvec
   2.00%  [kernel]           [k] __rcu_read_unlock
   1.92%  [kernel]           [k] mem_cgroup_iter
   0.98%  [kernel]           [k] __rcu_read_lock
   0.91%  [kernel]           [k] osq_lock
   0.63%  [kernel]           [k] mem_cgroup_calculate_protection
   0.55%  [kernel]           [k] shrinker_put
   0.46%  [kernel]           [k] list_lru_count_one

We can see that the first perf hotspot becomes shrink_slab, which is what
we expect.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/shrinker.c | 80 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 26 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index d318f5621862..fee6f62904fb 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -107,6 +107,12 @@ static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
 					 lockdep_is_held(&shrinker_rwsem));
 }
 
+static struct shrinker_info *shrinker_info_rcu(struct mem_cgroup *memcg,
+					       int nid)
+{
+	return rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+}
+
 static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 				    int old_size, int new_nr_max)
 {
@@ -198,7 +204,7 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 		struct shrinker_info_unit *unit;
 
 		rcu_read_lock();
-		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+		info = shrinker_info_rcu(memcg, nid);
 		unit = info->unit[shriner_id_to_index(shrinker_id)];
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
 			/* Pairs with smp mb in shrink_slab() */
@@ -211,7 +217,7 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 
 static DEFINE_IDR(shrinker_idr);
 
-static int prealloc_memcg_shrinker(struct shrinker *shrinker)
+static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
 	int id, ret = -ENOMEM;
 
@@ -219,7 +225,6 @@ static int prealloc_memcg_shrinker(struct shrinker *shrinker)
 		return -ENOSYS;
 
 	down_write(&shrinker_rwsem);
-	/* This may call shrinker, so it must use down_read_trylock() */
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
@@ -237,7 +242,7 @@ static int prealloc_memcg_shrinker(struct shrinker *shrinker)
 	return ret;
 }
 
-static void unregister_memcg_shrinker(struct shrinker *shrinker)
+static void shrinker_memcg_remove(struct shrinker *shrinker)
 {
 	int id = shrinker->id;
 
@@ -253,10 +258,15 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 {
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
+	long nr_deferred;
 
-	info = shrinker_info_protected(memcg, nid);
+	rcu_read_lock();
+	info = shrinker_info_rcu(memcg, nid);
 	unit = info->unit[shriner_id_to_index(shrinker->id)];
-	return atomic_long_xchg(&unit->nr_deferred[shriner_id_to_offset(shrinker->id)], 0);
+	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shriner_id_to_offset(shrinker->id)], 0);
+	rcu_read_unlock();
+
+	return nr_deferred;
 }
 
 static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
@@ -264,10 +274,16 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 {
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
+	long nr_deferred;
 
-	info = shrinker_info_protected(memcg, nid);
+	rcu_read_lock();
+	info = shrinker_info_rcu(memcg, nid);
 	unit = info->unit[shriner_id_to_index(shrinker->id)];
-	return atomic_long_add_return(nr, &unit->nr_deferred[shriner_id_to_offset(shrinker->id)]);
+	nr_deferred =
+		atomic_long_add_return(nr, &unit->nr_deferred[shriner_id_to_offset(shrinker->id)]);
+	rcu_read_unlock();
+
+	return nr_deferred;
 }
 
 void reparent_shrinker_deferred(struct mem_cgroup *memcg)
@@ -299,12 +315,12 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 	up_read(&shrinker_rwsem);
 }
 #else
-static int prealloc_memcg_shrinker(struct shrinker *shrinker)
+static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
 	return -ENOSYS;
 }
 
-static void unregister_memcg_shrinker(struct shrinker *shrinker)
+static void shrinker_memcg_remove(struct shrinker *shrinker)
 {
 }
 
@@ -464,18 +480,23 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	if (!mem_cgroup_online(memcg))
 		return 0;
 
-	if (!down_read_trylock(&shrinker_rwsem))
-		return 0;
-
-	info = shrinker_info_protected(memcg, nid);
+again:
+	rcu_read_lock();
+	info = shrinker_info_rcu(memcg, nid);
 	if (unlikely(!info))
 		goto unlock;
 
-	for (; index < shriner_id_to_index(info->map_nr_max); index++) {
+	if (index < shriner_id_to_index(info->map_nr_max)) {
 		struct shrinker_info_unit *unit;
 
 		unit = info->unit[index];
 
+		/*
+		 * The shrinker_info_unit will not be freed, so we can
+		 * safely release the RCU lock here.
+		 */
+		rcu_read_unlock();
+
 		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) {
 			struct shrink_control sc = {
 				.gfp_mask = gfp_mask,
@@ -485,12 +506,14 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			struct shrinker *shrinker;
 			int shrinker_id = calc_shrinker_id(index, offset);
 
+			rcu_read_lock();
 			shrinker = idr_find(&shrinker_idr, shrinker_id);
-			if (unlikely(!shrinker || !(shrinker->flags & SHRINKER_REGISTERED))) {
-				if (!shrinker)
-					clear_bit(offset, unit->map);
+			if (unlikely(!shrinker || !shrinker_try_get(shrinker))) {
+				clear_bit(offset, unit->map);
+				rcu_read_unlock();
 				continue;
 			}
+			rcu_read_unlock();
 
 			/* Call non-slab shrinkers even though kmem is disabled */
 			if (!memcg_kmem_online() &&
@@ -523,15 +546,20 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 					set_shrinker_bit(memcg, nid, shrinker_id);
 			}
 			freed += ret;
-
-			if (rwsem_is_contended(&shrinker_rwsem)) {
-				freed = freed ? : 1;
-				goto unlock;
-			}
+			shrinker_put(shrinker);
 		}
+
+		/*
+		 * We have already exited the read-side of rcu critical section
+		 * before calling do_shrink_slab(), the shrinker_info may be
+		 * released in expand_one_shrinker_info(), so reacquire the
+		 * shrinker_info.
+		 */
+		index++;
+		goto again;
 	}
 unlock:
-	up_read(&shrinker_rwsem);
+	rcu_read_unlock();
 	return freed;
 }
 #else /* !CONFIG_MEMCG */
@@ -638,7 +666,7 @@ struct shrinker *shrinker_alloc(unsigned int flags, const char *fmt, ...)
 	shrinker->flags = flags | SHRINKER_ALLOCATED;
 
 	if (flags & SHRINKER_MEMCG_AWARE) {
-		err = prealloc_memcg_shrinker(shrinker);
+		err = shrinker_memcg_alloc(shrinker);
 		if (err == -ENOSYS)
 			shrinker->flags &= ~SHRINKER_MEMCG_AWARE;
 		else if (err == 0)
@@ -731,7 +759,7 @@ void shrinker_free(struct shrinker *shrinker)
 	}
 
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
-		unregister_memcg_shrinker(shrinker);
+		shrinker_memcg_remove(shrinker);
 	up_write(&shrinker_rwsem);
 
 	if (debugfs_entry)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

