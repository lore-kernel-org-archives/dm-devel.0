Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0200EEB64DD
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687498017;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Sc4Lo2ibnsvwUGwHXFO09DJu2+WMVGTd963bz+xC3b8=;
	b=Y3Q/ffZx/fgeAUpi1Z8sQm3C5nlrPU1CzFN2W0gcYNg/4NZrO/zOn4zfZXOjPIog9QqR73
	Nr0MPZhUXnDDEo1FmonndS31F/ZUpBzE7aIXa+qf/HNNN0Ok4Jz0gKC8/RbwBQOxYMwoC3
	EXulDX8D28fPzcgM2X+M1zHCAQc8SCc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-ybpJdPLfNt6wtl4bo0BVCw-1; Fri, 23 Jun 2023 01:26:52 -0400
X-MC-Unique: ybpJdPLfNt6wtl4bo0BVCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9406A280463E;
	Fri, 23 Jun 2023 05:26:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BA5640C2079;
	Fri, 23 Jun 2023 05:26:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8700E19376EE;
	Fri, 23 Jun 2023 05:25:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B0751946588
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:50:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0EA7FF5AC5; Thu, 22 Jun 2023 08:50:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07182440CB
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:50:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDBBA1C06ECC
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:50:24 +0000 (UTC)
Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com
 [95.215.58.60]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-JXXr9Ll0MnCvcnXyeLlK3A-1; Thu, 22 Jun 2023 04:50:22 -0400
X-MC-Unique: JXXr9Ll0MnCvcnXyeLlK3A-1
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 08:39:05 +0000
Message-Id: <20230622083932.4090339-3-qi.zheng@linux.dev>
In-Reply-To: <20230622083932.4090339-1-qi.zheng@linux.dev>
References: <20230622083932.4090339-1-qi.zheng@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: [dm-devel] [PATCH 02/29] mm: vmscan: introduce some helpers for
 dynamically allocating shrinker
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
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 linux-raid@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Qi Zheng <zhengqi.arch@bytedance.com>

Introduce some helpers for dynamically allocating shrinker instance,
and their uses are as follows:

1. shrinker_alloc_and_init()

Used to allocate and initialize a shrinker instance, the priv_data
parameter is used to pass the pointer of the previously embedded
structure of the shrinker instance.

2. shrinker_free()

Used to free the shrinker instance when the registration of shrinker
fails.

3. unregister_and_free_shrinker()

Used to unregister and free the shrinker instance, and the kfree()
will be changed to kfree_rcu() later.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/shrinker.h | 12 ++++++++++++
 mm/vmscan.c              | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 43e6fcabbf51..8e9ba6fa3fcc 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -107,6 +107,18 @@ extern void unregister_shrinker(struct shrinker *shrinker);
 extern void free_prealloced_shrinker(struct shrinker *shrinker);
 extern void synchronize_shrinkers(void);
 
+typedef unsigned long (*count_objects_cb)(struct shrinker *s,
+					  struct shrink_control *sc);
+typedef unsigned long (*scan_objects_cb)(struct shrinker *s,
+					 struct shrink_control *sc);
+
+struct shrinker *shrinker_alloc_and_init(count_objects_cb count,
+					 scan_objects_cb scan, long batch,
+					 int seeks, unsigned flags,
+					 void *priv_data);
+void shrinker_free(struct shrinker *shrinker);
+void unregister_and_free_shrinker(struct shrinker *shrinker);
+
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
 extern struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 45d17c7cc555..64ff598fbad9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -809,6 +809,41 @@ void unregister_shrinker(struct shrinker *shrinker)
 }
 EXPORT_SYMBOL(unregister_shrinker);
 
+struct shrinker *shrinker_alloc_and_init(count_objects_cb count,
+					 scan_objects_cb scan, long batch,
+					 int seeks, unsigned flags,
+					 void *priv_data)
+{
+	struct shrinker *shrinker;
+
+	shrinker = kzalloc(sizeof(struct shrinker), GFP_KERNEL);
+	if (!shrinker)
+		return NULL;
+
+	shrinker->count_objects = count;
+	shrinker->scan_objects = scan;
+	shrinker->batch = batch;
+	shrinker->seeks = seeks;
+	shrinker->flags = flags;
+	shrinker->private_data = priv_data;
+
+	return shrinker;
+}
+EXPORT_SYMBOL(shrinker_alloc_and_init);
+
+void shrinker_free(struct shrinker *shrinker)
+{
+	kfree(shrinker);
+}
+EXPORT_SYMBOL(shrinker_free);
+
+void unregister_and_free_shrinker(struct shrinker *shrinker)
+{
+	unregister_shrinker(shrinker);
+	kfree(shrinker);
+}
+EXPORT_SYMBOL(unregister_and_free_shrinker);
+
 /**
  * synchronize_shrinkers - Wait for all running shrinkers to complete.
  *
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

