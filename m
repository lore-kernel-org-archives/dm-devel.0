Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35B41C001B1
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 05:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687497962;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zCK+ZC/AIJ+8E/oA/hr86bTM6jvZVvYxyXod3TYDL9k=;
	b=Zbb0YHQQpwfaB3dhZ10edfpE++f4Kt58/LHv60Jf9aJWys7vDnOvfLveyLIgw3IRbC73XW
	+Ew/v0BOBRkXYNpzGUWXWIQsvFuL7/bfF6vr/V68EAyxMgKZ43TPHlVbsN/Z6JRAKi8Q1t
	LdZLks6ygNVeu8ezWHNmsHF0E2O9Dw8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-wn6OnhL1MgeBdXbiJWbkkQ-1; Fri, 23 Jun 2023 01:25:58 -0400
X-MC-Unique: wn6OnhL1MgeBdXbiJWbkkQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7AD082808B35;
	Fri, 23 Jun 2023 05:25:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68F8C492CAD;
	Fri, 23 Jun 2023 05:25:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2F8A619451C0;
	Fri, 23 Jun 2023 05:25:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 232F31946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 08:55:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12E48492B02; Thu, 22 Jun 2023 08:55:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AFF8492B01
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:55:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E23CE858290
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 08:55:58 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-W1QE3a-kOF-3TKBn_xIoEQ-3; Thu, 22 Jun 2023 04:55:56 -0400
X-MC-Unique: W1QE3a-kOF-3TKBn_xIoEQ-3
Received: by mail-pg1-f169.google.com with SMTP id
 41be03b00d2f7-51f64817809so680081a12.1
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 01:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687424156; x=1690016156;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=YV1TxBHonYX3pT+e4dDoFW63Wrih64tWAHWeaspLQMY=;
 b=QEa8d9wYwVw8EvVF8MXJQAk1O6SpMbEZ89XdZ6DVkiGTdPvQzwoBbIaJXnrc8/PDHp
 4xWHvjXz7urTtkqV6JkLRS9p+MVNUGzUllKwXS1iENPnRQdGR+iMWa+s156epD52r2su
 K7Lpmm7VJhhDhAKyIuKbFH1SSxcDu5vQr5dz2o8bFy6Lz8X+Oa9XYtIQCchcPYxjCJEG
 hRXfj54kbWHBgxnh2YUSKMfW9qXTq1xb3lVGIQD/VzQI/clvE+PIAJd30SUm6ZQuUAWM
 i20GB58FGQ1PsB5msOKMOb2HVkEWI/1T0tIIb4+D73zZEYDM6zBpg7As0WyfHQec2EgO
 JaCQ==
X-Gm-Message-State: AC+VfDyw/iYBXRf5TVVAITpmUfYjN9D2zJGO5syiiHWOaXg+V2DeMFka
 T/VvtY6kr00W4fAfWwh9yXoFOA==
X-Google-Smtp-Source: ACHHUZ6yC2snRIv6FqrsdGDMg/3uXpE9V6V7JpWahZzREljgaxmC3AuzAW6pVJNk/nQXbwoLHaAThg==
X-Received: by 2002:a17:903:2451:b0:1b0:34c6:3bf2 with SMTP id
 l17-20020a170903245100b001b034c63bf2mr21540756pls.5.1687424156178; 
 Thu, 22 Jun 2023 01:55:56 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
 by smtp.gmail.com with ESMTPSA id
 h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.55.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 01:55:55 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
 vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
 brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Date: Thu, 22 Jun 2023 16:53:20 +0800
Message-Id: <20230622085335.77010-15-zhengqi.arch@bytedance.com>
In-Reply-To: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 23 Jun 2023 05:25:40 +0000
Subject: [dm-devel] [PATCH 14/29] jbd2,
 ext4: dynamically allocate the jbd2-journal shrinker
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
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: bytedance.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In preparation for implementing lockless slab shrink,
we need to dynamically allocate the jbd2-journal shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct journal_s.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/jbd2/journal.c    | 32 +++++++++++++++++++-------------
 include/linux/jbd2.h |  2 +-
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index eee3c0ae349a..92a2f4360b5f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1301,7 +1301,7 @@ static int jbd2_min_tag_size(void)
 static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
 					      struct shrink_control *sc)
 {
-	journal_t *journal = container_of(shrink, journal_t, j_shrinker);
+	journal_t *journal = shrink->private_data;
 	unsigned long nr_to_scan = sc->nr_to_scan;
 	unsigned long nr_shrunk;
 	unsigned long count;
@@ -1327,7 +1327,7 @@ static unsigned long jbd2_journal_shrink_scan(struct shrinker *shrink,
 static unsigned long jbd2_journal_shrink_count(struct shrinker *shrink,
 					       struct shrink_control *sc)
 {
-	journal_t *journal = container_of(shrink, journal_t, j_shrinker);
+	journal_t *journal = shrink->private_data;
 	unsigned long count;
 
 	count = percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
@@ -1415,21 +1415,27 @@ static journal_t *journal_init_common(struct block_device *bdev,
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
 
 	journal->j_shrink_transaction = NULL;
-	journal->j_shrinker.scan_objects = jbd2_journal_shrink_scan;
-	journal->j_shrinker.count_objects = jbd2_journal_shrink_count;
-	journal->j_shrinker.seeks = DEFAULT_SEEKS;
-	journal->j_shrinker.batch = journal->j_max_transaction_buffers;
 
 	if (percpu_counter_init(&journal->j_checkpoint_jh_count, 0, GFP_KERNEL))
 		goto err_cleanup;
 
-	if (register_shrinker(&journal->j_shrinker, "jbd2-journal:(%u:%u)",
-			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev))) {
-		percpu_counter_destroy(&journal->j_checkpoint_jh_count);
-		goto err_cleanup;
-	}
+	journal->j_shrinker = shrinker_alloc_and_init(jbd2_journal_shrink_count,
+						      jbd2_journal_shrink_scan,
+						      journal->j_max_transaction_buffers,
+						      DEFAULT_SEEKS, 0, journal);
+	if (!journal->j_shrinker)
+		goto err_shrinker;
+
+	if (register_shrinker(journal->j_shrinker, "jbd2-journal:(%u:%u)",
+			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev)))
+		goto err_register;
+
 	return journal;
 
+err_register:
+	shrinker_free(journal->j_shrinker);
+err_shrinker:
+	percpu_counter_destroy(&journal->j_checkpoint_jh_count);
 err_cleanup:
 	brelse(journal->j_sb_buffer);
 	kfree(journal->j_wbuf);
@@ -2190,9 +2196,9 @@ int jbd2_journal_destroy(journal_t *journal)
 		brelse(journal->j_sb_buffer);
 	}
 
-	if (journal->j_shrinker.flags & SHRINKER_REGISTERED) {
+	if (journal->j_shrinker->flags & SHRINKER_REGISTERED) {
 		percpu_counter_destroy(&journal->j_checkpoint_jh_count);
-		unregister_shrinker(&journal->j_shrinker);
+		unregister_and_free_shrinker(journal->j_shrinker);
 	}
 	if (journal->j_proc_entry)
 		jbd2_stats_proc_exit(journal);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 44c298aa58d4..beb4c4586320 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -891,7 +891,7 @@ struct journal_s
 	 * Journal head shrinker, reclaim buffer's journal head which
 	 * has been written back.
 	 */
-	struct shrinker		j_shrinker;
+	struct shrinker		*j_shrinker;
 
 	/**
 	 * @j_checkpoint_jh_count:
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

