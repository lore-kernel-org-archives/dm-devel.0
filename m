Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF847C678D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319334;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C6e6exifQ/TYIfddDtzgQ9/jVYKfTFFXaEGjYQg7VLc=;
	b=BXHvvkreEFuP7AaF9aXEZ/HNa4JWFPH2wKpunl2KFT5HnLiqC46Omy3H0bSp2UhBZb7+nL
	/H/JubEye6EyjuT4CwnNO0NkHCDptZtnxNOh28UCEUeIsDv4idacfg3IVO+Dtlw/iFDr/y
	jTZjz/6LU7QgzcP8vV9CVfLWp00ZxhY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-ArrC3396ObGHpEb-K7EYeg-1; Mon, 13 Feb 2023 15:15:30 -0500
X-MC-Unique: ArrC3396ObGHpEb-K7EYeg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E1C5800DAA;
	Mon, 13 Feb 2023 20:15:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A9A918EC7;
	Mon, 13 Feb 2023 20:15:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7B9D71946588;
	Mon, 13 Feb 2023 20:15:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 973C81946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8964C400D927; Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 824B140C83B6
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D980629AB45E
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:11 +0000 (UTC)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com
 [209.85.160.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-370-N2XI3eDoNMypEDUhZD_qQQ-1; Mon, 13 Feb 2023 15:15:05 -0500
X-MC-Unique: N2XI3eDoNMypEDUhZD_qQQ-1
Received: by mail-qt1-f172.google.com with SMTP id g18so15181013qtb.6
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=P1MQ3uMUmAtxBpc8seThRyZ7Rqd2CNx0PV9T2FA5cYs=;
 b=ePiXx8CI65reFkvAXKX+bTyW6fgUNeSg8xZR6hvLFCiZdG4AD9vbRkOnQfjwt03UsQ
 sMo2D/xhkdENtRWF+TpRxxrRsOUGV9chfedDSbSQBsrbb4TmdF4P5h4RZ6vJinwpjm7s
 tEGy2fp9KxoLCtalG8F8li7NbxjTYIAwvhP3JVsUVK2AO+UCur115aARQCzwhWp8tCeI
 QTVrTJe3qgPUbNXoQAgAkGEPXPQwKVMctPrmGvNbw1cvI//rjCjN9ZUkz4W6Zki13fM5
 Kj7eJh0/DgT1E5/ufPomQAfH6jxEdyQFI/T5cgFpLfXCmEkYQtDxLcp3QUGpO2Kdh0TQ
 NozQ==
X-Gm-Message-State: AO0yUKWII3varn8L48zRwa+jqW+NVnzPaNPuEr+VnkCaBCdpiN8wvn9L
 wTyoJ/35h8YQJl+npGnyhXlXET3bHBQFx/3AxSbBw1hno3i2NPq0bNkGbWyjxpnV7j90Ph3aroO
 WVpPxYXEIKYdGWb9dKOpQ5iyYik50sCDC54JDcZVoRe+qZbNG4DnKIIeagOSyF8D361KdqA==
X-Google-Smtp-Source: AK7set/PmPrHkVjKk1CsW2BlXL2Q3WbTjYPa0ZNTYhaBOmUbjbHz2NFnYRA3ECcB+IBlQz1iHI0Mhg==
X-Received: by 2002:ac8:5dcf:0:b0:3b9:b1eb:ad38 with SMTP id
 e15-20020ac85dcf000000b003b9b1ebad38mr41598541qtx.50.1676319304703; 
 Mon, 13 Feb 2023 12:15:04 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b20-20020ac86794000000b003b2957fb45bsm9937019qtp.8.2023.02.13.12.15.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:04 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:44 -0500
Message-Id: <20230213201401.45973-23-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 22/39] dm: avoid using symbolic permissions
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c         | 16 ++++++++--------
 drivers/md/dm-kcopyd.c        |  2 +-
 drivers/md/dm-mpath.c         |  3 +--
 drivers/md/dm-rq.c            |  8 ++++----
 drivers/md/dm-stats.c         |  2 +-
 drivers/md/dm-sysfs.c         |  4 ++--
 drivers/md/dm-thin.c          |  2 +-
 drivers/md/dm-verity-target.c |  2 +-
 drivers/md/dm.c               |  6 +++---
 9 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index af310bed6ba9..a5d7f8555aa0 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2165,28 +2165,28 @@ static void __exit dm_bufio_exit(void)
 module_init(dm_bufio_init)
 module_exit(dm_bufio_exit)
 
-module_param_named(max_cache_size_bytes, dm_bufio_cache_size, ulong, S_IRUGO | S_IWUSR);
+module_param_named(max_cache_size_bytes, dm_bufio_cache_size, ulong, 0644);
 MODULE_PARM_DESC(max_cache_size_bytes, "Size of metadata cache");
 
-module_param_named(max_age_seconds, dm_bufio_max_age, uint, S_IRUGO | S_IWUSR);
+module_param_named(max_age_seconds, dm_bufio_max_age, uint, 0644);
 MODULE_PARM_DESC(max_age_seconds, "Max age of a buffer in seconds");
 
-module_param_named(retain_bytes, dm_bufio_retain_bytes, ulong, S_IRUGO | S_IWUSR);
+module_param_named(retain_bytes, dm_bufio_retain_bytes, ulong, 0644);
 MODULE_PARM_DESC(retain_bytes, "Try to keep at least this many bytes cached in memory");
 
-module_param_named(peak_allocated_bytes, dm_bufio_peak_allocated, ulong, S_IRUGO | S_IWUSR);
+module_param_named(peak_allocated_bytes, dm_bufio_peak_allocated, ulong, 0644);
 MODULE_PARM_DESC(peak_allocated_bytes, "Tracks the maximum allocated memory");
 
-module_param_named(allocated_kmem_cache_bytes, dm_bufio_allocated_kmem_cache, ulong, S_IRUGO);
+module_param_named(allocated_kmem_cache_bytes, dm_bufio_allocated_kmem_cache, ulong, 0444);
 MODULE_PARM_DESC(allocated_kmem_cache_bytes, "Memory allocated with kmem_cache_alloc");
 
-module_param_named(allocated_get_free_pages_bytes, dm_bufio_allocated_get_free_pages, ulong, S_IRUGO);
+module_param_named(allocated_get_free_pages_bytes, dm_bufio_allocated_get_free_pages, ulong, 0444);
 MODULE_PARM_DESC(allocated_get_free_pages_bytes, "Memory allocated with get_free_pages");
 
-module_param_named(allocated_vmalloc_bytes, dm_bufio_allocated_vmalloc, ulong, S_IRUGO);
+module_param_named(allocated_vmalloc_bytes, dm_bufio_allocated_vmalloc, ulong, 0444);
 MODULE_PARM_DESC(allocated_vmalloc_bytes, "Memory allocated with vmalloc");
 
-module_param_named(current_allocated_bytes, dm_bufio_current_allocated, ulong, S_IRUGO);
+module_param_named(current_allocated_bytes, dm_bufio_current_allocated, ulong, 0444);
 MODULE_PARM_DESC(current_allocated_bytes, "Memory currently used by the cache");
 
 MODULE_AUTHOR("Mikulas Patocka <dm-devel@redhat.com>");
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 0027349aa6be..81bc33a3581d 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -37,7 +37,7 @@
 
 static unsigned int kcopyd_subjob_size_kb = DEFAULT_SUB_JOB_SIZE_KB;
 
-module_param(kcopyd_subjob_size_kb, uint, S_IRUGO | S_IWUSR);
+module_param(kcopyd_subjob_size_kb, uint, 0644);
 MODULE_PARM_DESC(kcopyd_subjob_size_kb, "Sub-job size for dm-kcopyd clients");
 
 static unsigned int dm_get_kcopyd_subjob_size(void)
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c15cc7f54bd2..2524ac702145 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2258,8 +2258,7 @@ static void __exit dm_multipath_exit(void)
 module_init(dm_multipath_init);
 module_exit(dm_multipath_exit);
 
-module_param_named(queue_if_no_path_timeout_secs,
-		   queue_if_no_path_timeout_secs, ulong, S_IRUGO | S_IWUSR);
+module_param_named(queue_if_no_path_timeout_secs, queue_if_no_path_timeout_secs, ulong, 0644);
 MODULE_PARM_DESC(queue_if_no_path_timeout_secs, "No available paths queue IO timeout in seconds");
 
 MODULE_DESCRIPTION(DM_NAME " multipath target");
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index d5f368965d3b..fec63b2a907d 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -584,16 +584,16 @@ void dm_mq_cleanup_mapped_device(struct mapped_device *md)
 	}
 }
 
-module_param(reserved_rq_based_ios, uint, S_IRUGO | S_IWUSR);
+module_param(reserved_rq_based_ios, uint, 0644);
 MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools");
 
 /* Unused, but preserved for userspace compatibility */
 static bool use_blk_mq = true;
-module_param(use_blk_mq, bool, S_IRUGO | S_IWUSR);
+module_param(use_blk_mq, bool, 0644);
 MODULE_PARM_DESC(use_blk_mq, "Use block multiqueue for request-based DM devices");
 
-module_param(dm_mq_nr_hw_queues, uint, S_IRUGO | S_IWUSR);
+module_param(dm_mq_nr_hw_queues, uint, 0644);
 MODULE_PARM_DESC(dm_mq_nr_hw_queues, "Number of hardware queues for request-based dm-mq devices");
 
-module_param(dm_mq_queue_depth, uint, S_IRUGO | S_IWUSR);
+module_param(dm_mq_queue_depth, uint, 0644);
 MODULE_PARM_DESC(dm_mq_queue_depth, "Queue depth for request-based dm-mq devices");
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 12d17b1a83a9..5e49e02ee174 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -1247,5 +1247,5 @@ void dm_statistics_exit(void)
 		DMCRIT("shared_memory_amount leaked: %lu", shared_memory_amount);
 }
 
-module_param_named(stats_current_allocated_bytes, shared_memory_amount, ulong, S_IRUGO);
+module_param_named(stats_current_allocated_bytes, shared_memory_amount, ulong, 0444);
 MODULE_PARM_DESC(stats_current_allocated_bytes, "Memory currently used by statistics");
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index c090cb184093..914c0e767a3c 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -18,7 +18,7 @@ struct dm_sysfs_attr {
 
 #define DM_ATTR_RO(_name) \
 struct dm_sysfs_attr dm_attr_##_name = \
-	__ATTR(_name, S_IRUGO, dm_attr_##_name##_show, NULL)
+	__ATTR(_name, 0444, dm_attr_##_name##_show, NULL)
 
 static ssize_t dm_attr_show(struct kobject *kobj, struct attribute *attr,
 			    char *page)
@@ -43,7 +43,7 @@ static ssize_t dm_attr_show(struct kobject *kobj, struct attribute *attr,
 
 #define DM_ATTR_RW(_name) \
 struct dm_sysfs_attr dm_attr_##_name = \
-	__ATTR(_name, S_IRUGO | S_IWUSR, dm_attr_##_name##_show, dm_attr_##_name##_store)
+	__ATTR(_name, 0644, dm_attr_##_name##_show, dm_attr_##_name##_store)
 
 static ssize_t dm_attr_store(struct kobject *kobj, struct attribute *attr,
 			     const char *page, size_t count)
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e2ff22e79367..c8d3b20401f4 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4532,7 +4532,7 @@ static void dm_thin_exit(void)
 module_init(dm_thin_init);
 module_exit(dm_thin_exit);
 
-module_param_named(no_space_timeout, no_space_timeout_secs, uint, S_IRUGO | S_IWUSR);
+module_param_named(no_space_timeout, no_space_timeout_secs, uint, 0644);
 MODULE_PARM_DESC(no_space_timeout, "Out of data space queue IO timeout in seconds");
 
 MODULE_DESCRIPTION(DM_NAME " thin provisioning target");
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 1db64a24623d..0f9814099d1b 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -43,7 +43,7 @@
 
 static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
-module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
+module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, 0644);
 
 static DEFINE_STATIC_KEY_FALSE(use_tasklet_enabled);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 16f29a60a64f..a54700b6c9eb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3394,13 +3394,13 @@ module_exit(dm_exit);
 module_param(major, uint, 0);
 MODULE_PARM_DESC(major, "The major number of the device mapper");
 
-module_param(reserved_bio_based_ios, uint, S_IRUGO | S_IWUSR);
+module_param(reserved_bio_based_ios, uint, 0644);
 MODULE_PARM_DESC(reserved_bio_based_ios, "Reserved IOs in bio-based mempools");
 
-module_param(dm_numa_node, int, S_IRUGO | S_IWUSR);
+module_param(dm_numa_node, int, 0644);
 MODULE_PARM_DESC(dm_numa_node, "NUMA node for DM device memory allocations");
 
-module_param(swap_bios, int, S_IRUGO | S_IWUSR);
+module_param(swap_bios, int, 0644);
 MODULE_PARM_DESC(swap_bios, "Maximum allowed inflight swap IOs");
 
 MODULE_DESCRIPTION(DM_NAME " driver");
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

