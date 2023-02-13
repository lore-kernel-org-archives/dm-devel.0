Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27AD7C6379F
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319333;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qlgO/P9iKeaLAnpekdqFz+T61sCyFkLN4L5rG9MGnOc=;
	b=EAzosmgvmyNxrQrULhyX1s+4H7ftQOGktzABcn5lnXSrgsv4vMzzm1MlGHG57DhDa8CpRS
	N8zgzLKGcyYsDpZHeEy3t5SrkuXPUPxXrh+dr5GyvjVRdndTyeKZgEuhrTHsaGmRilOwRu
	Yq58cME3iq3TPT8dBbPm4bZ0RSPLQgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-CqyOiY3_MhWzcSqbqkyAHA-1; Mon, 13 Feb 2023 15:15:28 -0500
X-MC-Unique: CqyOiY3_MhWzcSqbqkyAHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E4C971089;
	Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C55C8140EBF4;
	Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B6FAA1946588;
	Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 056461946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF48E2026D68; Mon, 13 Feb 2023 20:14:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D65E32026D4B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B299C101B42B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:54 +0000 (UTC)
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com
 [209.85.160.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-450-oapyW8sLNX-idLzaq_8LLg-1; Mon, 13 Feb 2023 15:14:53 -0500
X-MC-Unique: oapyW8sLNX-idLzaq_8LLg-1
Received: by mail-qt1-f170.google.com with SMTP id cr22so15168711qtb.10
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=GWded1WwUhjuBej/7K62yQ0Rh5VzDzRiQ0yl+GTO7W4=;
 b=LZzObTFBJjB0EC1nep8wHPl2WfcWhFrjqiewFiJSs2eOXwXtmdlDjplSGfv3vvXpaP
 WbKbZf1Xzu1v20zgoiLGNxHIaWfjV+3an4LX3KZojTtaysut2DO4RLIR5L/YdWkoN/g7
 RJWrzpVSLL3mOvoBHrwGBTD22x2XKe7vUaZ5Mwb40ra2tBKKJdqji7RUDKAGZxEyxSig
 iEWoVuE/sYckwtL+tjpM8QeE1pBDI/jxYEXCzmuEtW+RAFMVCyZkLkBUNiTHchm6p1c8
 QoYEpwa7DxSd2t06rrV3MA3PpbKtZC6J1DeFzqUMelyGKnOVtjIRbcpK7qwHzlEZoWSO
 MwUg==
X-Gm-Message-State: AO0yUKXdiFagY3NAK+8FfoMYBY0fgokHx51Z4eip4XSihOCD+dqOUnh6
 y02RlqS57HrAkLFOE940yNXASs93p2+y2Nc0x5BXyOjm0QLnvk1yQerpgfEYV5hgcvJ8gHxo3pw
 Etbj13c5XMGnp1ixiZmbBPo3Sh3Ihu0P2IzeX12exbfEvylZBo4QXPzUSEIRoCQhb9Rx61Q==
X-Google-Smtp-Source: AK7set8M+EIYJUqIWE3rInkyrKsGmhFFgBOBpLo3Xx2WFwiON7Nv3ocxUakmP56gMJexltuAmck9oA==
X-Received: by 2002:a05:622a:1653:b0:3b9:c153:f169 with SMTP id
 y19-20020a05622a165300b003b9c153f169mr47904829qtj.0.1676319292282; 
 Mon, 13 Feb 2023 12:14:52 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m28-20020aed27dc000000b003b635a5d56csm9992617qtg.30.2023.02.13.12.14.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:51 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:37 -0500
Message-Id: <20230213201401.45973-16-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 15/39] dm: avoid spaces before function arguments
 or in favour of tabs
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c   |  6 ++--
 drivers/md/dm-cache-target.c    | 12 ++++----
 drivers/md/dm-ebs-target.c      |  2 +-
 drivers/md/dm-exception-store.h | 44 ++++++++++++++--------------
 drivers/md/dm-ioctl.c           | 52 ++++++++++++++++-----------------
 drivers/md/dm-kcopyd.c          |  2 +-
 drivers/md/dm-path-selector.h   | 27 +++++++++--------
 drivers/md/dm-ps-queue-length.c |  4 +--
 drivers/md/dm-ps-service-time.c |  8 ++---
 drivers/md/dm-raid1.c           |  2 +-
 drivers/md/dm-snap-persistent.c |  2 +-
 drivers/md/dm-snap-transient.c  |  2 +-
 drivers/md/dm-snap.c            |  6 ++--
 drivers/md/dm-uevent.c          |  2 +-
 14 files changed, 84 insertions(+), 87 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index aa58b0671a79..6ff559f436a2 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -78,9 +78,9 @@ static void __setup_new_cell(struct dm_cell_key *key,
 			     struct bio *holder,
 			     struct dm_bio_prison_cell *cell)
 {
-       memcpy(&cell->key, key, sizeof(cell->key));
-       cell->holder = holder;
-       bio_list_init(&cell->bios);
+	memcpy(&cell->key, key, sizeof(cell->key));
+	cell->holder = holder;
+	bio_list_init(&cell->bios);
 }
 
 static int cmp_keys(struct dm_cell_key *lhs,
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 816f0c5f139f..94170947e7fb 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -181,14 +181,14 @@ static void continue_after_commit(struct batcher *b, struct continuation *k)
  */
 static void issue_after_commit(struct batcher *b, struct bio *bio)
 {
-       bool commit_scheduled;
+	bool commit_scheduled;
 
-       spin_lock_irq(&b->lock);
-       commit_scheduled = b->commit_scheduled;
-       bio_list_add(&b->bios, bio);
-       spin_unlock_irq(&b->lock);
+	spin_lock_irq(&b->lock);
+	commit_scheduled = b->commit_scheduled;
+	bio_list_add(&b->bios, bio);
+	spin_unlock_irq(&b->lock);
 
-       if (commit_scheduled)
+	if (commit_scheduled)
 	       async_commit(b);
 }
 
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 8477e82a95c6..a371a2c177a9 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -242,7 +242,7 @@ static void __ebs_process_bios(struct work_struct *ws)
  * <offset>: offset in 512 bytes sectors into <dev_path>
  * <ebs>: emulated block size in units of 512 bytes exposed to the upper layer
  * [<ubs>]: underlying block size in units of 512 bytes imposed on the lower layer;
- * 	    optional, if not supplied, retrieve logical block size from underlying device
+ *	    optional, if not supplied, retrieve logical block size from underlying device
  */
 static int ebs_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index 5a143dc8d181..4bc57b63d347 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -44,36 +44,36 @@ struct dm_exception_store_type {
 	const char *name;
 	struct module *module;
 
-	int (*ctr) (struct dm_exception_store *store, char *options);
+	int (*ctr)(struct dm_exception_store *store, char *options);
 
 	/*
 	 * Destroys this object when you've finished with it.
 	 */
-	void (*dtr) (struct dm_exception_store *store);
+	void (*dtr)(struct dm_exception_store *store);
 
 	/*
 	 * The target shouldn't read the COW device until this is
 	 * called.  As exceptions are read from the COW, they are
 	 * reported back via the callback.
 	 */
-	int (*read_metadata) (struct dm_exception_store *store,
-			      int (*callback)(void *callback_context,
-					      chunk_t old, chunk_t new),
-			      void *callback_context);
+	int (*read_metadata)(struct dm_exception_store *store,
+			     int (*callback)(void *callback_context,
+					     chunk_t old, chunk_t new),
+			     void *callback_context);
 
 	/*
 	 * Find somewhere to store the next exception.
 	 */
-	int (*prepare_exception) (struct dm_exception_store *store,
-				  struct dm_exception *e);
+	int (*prepare_exception)(struct dm_exception_store *store,
+				 struct dm_exception *e);
 
 	/*
 	 * Update the metadata with this exception.
 	 */
-	void (*commit_exception) (struct dm_exception_store *store,
-				  struct dm_exception *e, int valid,
-				  void (*callback) (void *, int success),
-				  void *callback_context);
+	void (*commit_exception)(struct dm_exception_store *store,
+				 struct dm_exception *e, int valid,
+				 void (*callback)(void *, int success),
+				 void *callback_context);
 
 	/*
 	 * Returns 0 if the exception store is empty.
@@ -83,30 +83,30 @@ struct dm_exception_store_type {
 	 * still-to-be-merged chunk and returns the number of
 	 * consecutive previous ones.
 	 */
-	int (*prepare_merge) (struct dm_exception_store *store,
-			      chunk_t *last_old_chunk, chunk_t *last_new_chunk);
+	int (*prepare_merge)(struct dm_exception_store *store,
+			     chunk_t *last_old_chunk, chunk_t *last_new_chunk);
 
 	/*
 	 * Clear the last n exceptions.
 	 * nr_merged must be <= the value returned by prepare_merge.
 	 */
-	int (*commit_merge) (struct dm_exception_store *store, int nr_merged);
+	int (*commit_merge)(struct dm_exception_store *store, int nr_merged);
 
 	/*
 	 * The snapshot is invalid, note this in the metadata.
 	 */
-	void (*drop_snapshot) (struct dm_exception_store *store);
+	void (*drop_snapshot)(struct dm_exception_store *store);
 
-	unsigned int (*status) (struct dm_exception_store *store,
-				status_type_t status, char *result,
-				unsigned int maxlen);
+	unsigned int (*status)(struct dm_exception_store *store,
+			       status_type_t status, char *result,
+			       unsigned int maxlen);
 
 	/*
 	 * Return how full the snapshot is.
 	 */
-	void (*usage) (struct dm_exception_store *store,
-		       sector_t *total_sectors, sector_t *sectors_allocated,
-		       sector_t *metadata_sectors);
+	void (*usage)(struct dm_exception_store *store,
+		      sector_t *total_sectors, sector_t *sectors_allocated,
+		      sector_t *metadata_sectors);
 
 	/* For internal device-mapper use only. */
 	struct list_head list;
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index c00a1fe69846..e73615c57561 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -54,10 +54,10 @@ struct hash_cell {
 };
 
 struct vers_iter {
-    size_t param_size;
-    struct dm_target_versions *vers, *old_vers;
-    char *end;
-    uint32_t flags;
+	size_t param_size;
+	struct dm_target_versions *vers, *old_vers;
+	char *end;
+	uint32_t flags;
 };
 
 
@@ -661,36 +661,34 @@ static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_
 
 static void list_version_get_needed(struct target_type *tt, void *needed_param)
 {
-    size_t *needed = needed_param;
+	size_t *needed = needed_param;
 
-    *needed += sizeof(struct dm_target_versions);
-    *needed += strlen(tt->name) + 1;
-    *needed += ALIGN_MASK;
+	*needed += sizeof(struct dm_target_versions);
+	*needed += strlen(tt->name) + 1;
+	*needed += ALIGN_MASK;
 }
 
 static void list_version_get_info(struct target_type *tt, void *param)
 {
-    struct vers_iter *info = param;
+	struct vers_iter *info = param;
 
-    /* Check space - it might have changed since the first iteration */
-    if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 >
-	info->end) {
+	/* Check space - it might have changed since the first iteration */
+	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
+		info->flags = DM_BUFFER_FULL_FLAG;
+		return;
+	}
 
-	info->flags = DM_BUFFER_FULL_FLAG;
-	return;
-    }
+	if (info->old_vers)
+		info->old_vers->next = (uint32_t) ((void *)info->vers - (void *)info->old_vers);
 
-    if (info->old_vers)
-	info->old_vers->next = (uint32_t) ((void *)info->vers -
-					   (void *)info->old_vers);
-    info->vers->version[0] = tt->version[0];
-    info->vers->version[1] = tt->version[1];
-    info->vers->version[2] = tt->version[2];
-    info->vers->next = 0;
-    strcpy(info->vers->name, tt->name);
+	info->vers->version[0] = tt->version[0];
+	info->vers->version[1] = tt->version[1];
+	info->vers->version[2] = tt->version[2];
+	info->vers->next = 0;
+	strcpy(info->vers->name, tt->name);
 
-    info->old_vers = info->vers;
-    info->vers = align_ptr((void *)(info->vers + 1) + strlen(tt->name) + 1);
+	info->old_vers = info->vers;
+	info->vers = align_ptr((void *)(info->vers + 1) + strlen(tt->name) + 1);
 }
 
 static int __list_versions(struct dm_ioctl *param, size_t param_size, const char *name)
@@ -2088,9 +2086,9 @@ static const struct file_operations _ctl_fops = {
 
 static struct miscdevice _dm_misc = {
 	.minor		= MAPPER_CTRL_MINOR,
-	.name  		= DM_NAME,
+	.name		= DM_NAME,
 	.nodename	= DM_DIR "/" DM_CONTROL_NODE,
-	.fops  		= &_ctl_fops
+	.fops		= &_ctl_fops
 };
 
 MODULE_ALIAS_MISCDEV(MAPPER_CTRL_MINOR);
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 1b97a32faa4e..088746578e7b 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -608,7 +608,7 @@ static int run_pages_job(struct kcopyd_job *job)
  * of successful jobs.
  */
 static int process_jobs(struct list_head *jobs, struct dm_kcopyd_client *kc,
-			int (*fn) (struct kcopyd_job *))
+			int (*fn)(struct kcopyd_job *))
 {
 	struct kcopyd_job *job;
 	int r, count = 0;
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index f7390cb79a3c..18ca2769c793 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -53,44 +53,43 @@ struct path_selector_type {
 	/*
 	 * Constructs a path selector object, takes custom arguments
 	 */
-	int (*create) (struct path_selector *ps, unsigned int argc, char **argv);
-	void (*destroy) (struct path_selector *ps);
+	int (*create)(struct path_selector *ps, unsigned int argc, char **argv);
+	void (*destroy)(struct path_selector *ps);
 
 	/*
 	 * Add an opaque path object, along with some selector specific
 	 * path args (eg, path priority).
 	 */
-	int (*add_path) (struct path_selector *ps, struct dm_path *path,
-			 int argc, char **argv, char **error);
+	int (*add_path)(struct path_selector *ps, struct dm_path *path,
+			int argc, char **argv, char **error);
 
 	/*
 	 * Chooses a path for this io, if no paths are available then
 	 * NULL will be returned.
 	 */
-	struct dm_path *(*select_path) (struct path_selector *ps,
-					size_t nr_bytes);
+	struct dm_path *(*select_path)(struct path_selector *ps, size_t nr_bytes);
 
 	/*
 	 * Notify the selector that a path has failed.
 	 */
-	void (*fail_path) (struct path_selector *ps, struct dm_path *p);
+	void (*fail_path)(struct path_selector *ps, struct dm_path *p);
 
 	/*
 	 * Ask selector to reinstate a path.
 	 */
-	int (*reinstate_path) (struct path_selector *ps, struct dm_path *p);
+	int (*reinstate_path)(struct path_selector *ps, struct dm_path *p);
 
 	/*
 	 * Table content based on parameters added in ps_add_path_fn
 	 * or path selector status
 	 */
-	int (*status) (struct path_selector *ps, struct dm_path *path,
-		       status_type_t type, char *result, unsigned int maxlen);
+	int (*status)(struct path_selector *ps, struct dm_path *path,
+		      status_type_t type, char *result, unsigned int maxlen);
 
-	int (*start_io) (struct path_selector *ps, struct dm_path *path,
-			 size_t nr_bytes);
-	int (*end_io) (struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes, u64 start_time);
+	int (*start_io)(struct path_selector *ps, struct dm_path *path,
+			size_t nr_bytes);
+	int (*end_io)(struct path_selector *ps, struct dm_path *path,
+		      size_t nr_bytes, u64 start_time);
 };
 
 /* Register a path selector */
diff --git a/drivers/md/dm-ps-queue-length.c b/drivers/md/dm-ps-queue-length.c
index 4110142df66e..5e3db25acc79 100644
--- a/drivers/md/dm-ps-queue-length.c
+++ b/drivers/md/dm-ps-queue-length.c
@@ -123,8 +123,8 @@ static int ql_add_path(struct path_selector *ps, struct dm_path *path,
 
 	/*
 	 * Arguments: [<repeat_count>]
-	 * 	<repeat_count>: The number of I/Os before switching path.
-	 * 			If not given, default (QL_MIN_IO) is used.
+	 *	<repeat_count>: The number of I/Os before switching path.
+	 *			If not given, default (QL_MIN_IO) is used.
 	 */
 	if (argc > 1) {
 		*error = "queue-length ps: incorrect number of arguments";
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index 3c8f2e884a12..0138325484cd 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -121,11 +121,11 @@ static int st_add_path(struct path_selector *ps, struct dm_path *path,
 
 	/*
 	 * Arguments: [<repeat_count> [<relative_throughput>]]
-	 * 	<repeat_count>: The number of I/Os before switching path.
-	 * 			If not given, default (ST_MIN_IO) is used.
-	 * 	<relative_throughput>: The relative throughput value of
+	 *	<repeat_count>: The number of I/Os before switching path.
+	 *			If not given, default (ST_MIN_IO) is used.
+	 *	<relative_throughput>: The relative throughput value of
 	 *			the path among all paths in the path-group.
-	 * 			The valid range: 0-<ST_MAX_RELATIVE_THROUGHPUT>
+	 *			The valid range: 0-<ST_MAX_RELATIVE_THROUGHPUT>
 	 *			If not given, minimum value '1' is used.
 	 *			If '0' is given, the path isn't selected while
 	 *			other paths having a positive value are	available.
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 2b003fe536bc..a71c03591014 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -595,7 +595,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
  * We do different things with the write io depending on the
  * state of the region that it's in:
  *
- * SYNC: 	increment pending, use kcopyd to write to *all* mirrors
+ * SYNC:	increment pending, use kcopyd to write to *all* mirrors
  * RECOVERING:	delay the io until recovery completes
  * NOSYNC:	increment pending, just write to the default mirror
  *---------------------------------------------------------------------
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 0877285a0514..c511af93b5dc 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -695,7 +695,7 @@ static int persistent_prepare_exception(struct dm_exception_store *store,
 
 static void persistent_commit_exception(struct dm_exception_store *store,
 					struct dm_exception *e, int valid,
-					void (*callback) (void *, int success),
+					void (*callback)(void *, int success),
 					void *callback_context)
 {
 	unsigned int i;
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index 44dad7a56492..8e1e4b4e14b5 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -56,7 +56,7 @@ static int transient_prepare_exception(struct dm_exception_store *store,
 
 static void transient_commit_exception(struct dm_exception_store *store,
 				       struct dm_exception *e, int valid,
-				       void (*callback) (void *, int success),
+				       void (*callback)(void *, int success),
 				       void *callback_context)
 {
 	/* Just succeed */
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3357731c9db8..3ae7b6d7b210 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -123,11 +123,11 @@ struct dm_snapshot {
 	 * The merge operation failed if this flag is set.
 	 * Failure modes are handled as follows:
 	 * - I/O error reading the header
-	 *   	=> don't load the target; abort.
+	 *	=> don't load the target; abort.
 	 * - Header does not have "valid" flag set
-	 *   	=> use the origin; forget about the snapshot.
+	 *	=> use the origin; forget about the snapshot.
 	 * - I/O error when reading exceptions
-	 *   	=> don't load the target; abort.
+	 *	=> don't load the target; abort.
 	 *         (We can't use the intermediate origin state.)
 	 * - I/O error while merging
 	 *	=> stop merging; set merge_failed; process I/O normally.
diff --git a/drivers/md/dm-uevent.c b/drivers/md/dm-uevent.c
index a02b3f6ea47a..491738263292 100644
--- a/drivers/md/dm-uevent.c
+++ b/drivers/md/dm-uevent.c
@@ -3,7 +3,7 @@
  * Device Mapper Uevent Support (dm-uevent)
  *
  * Copyright IBM Corporation, 2007
- * 	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
+ *	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
  */
 #include <linux/list.h>
 #include <linux/slab.h>
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

