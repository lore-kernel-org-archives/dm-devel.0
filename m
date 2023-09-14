Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A11EEAA62
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xZgiiCsVSqJovtbHvg0y/+OIPf5WTPWZlmVahMmiBK0=;
	b=Qj9gYpYlncm3aNpqCrxYZBHI2I0/6VXQ0JHBhouQH5Fuf90lAdJTEpW/6o6o1DDCNoFNg+
	VZyPEu2R8HlUd6o/Hq6U4aZ3oo8+F2ywQpEKXZ7pfcoHbiL9Dr8eSrVCZY+k+e6lX6JLDl
	v+lK25R9sABHt/qYyXd+x8faNjlm1xY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-asarOdhtNLClmqEbmaTIQA-1; Thu, 14 Sep 2023 15:18:51 -0400
X-MC-Unique: asarOdhtNLClmqEbmaTIQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6521B805B36;
	Thu, 14 Sep 2023 19:18:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FE7540C6EA8;
	Thu, 14 Sep 2023 19:18:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A0AB91946A79;
	Thu, 14 Sep 2023 19:17:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B3861946A4D
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:17:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61F442027019; Thu, 14 Sep 2023 19:17:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59AA52027018
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:25 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35A25185A79B
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:25 +0000 (UTC)
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com
 [209.85.222.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-Rikp2yk4N5aaK23PGbs6Cw-1; Thu, 14 Sep 2023 15:17:23 -0400
X-MC-Unique: Rikp2yk4N5aaK23PGbs6Cw-1
Received: by mail-qk1-f172.google.com with SMTP id
 af79cd13be357-76f14d80ea6so87382585a.2
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719042; x=1695323842;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=56JtQvQ8veG/obkRS8dhwk+laaO6xZi+iXutS3LqeV4=;
 b=Xbq0W1rnSE76DVK7jQRMWkK+uNKMkQ3HiMcuJOlz9qH//w975UnG6olclSFNhzTNgZ
 f4Oujf6xlfRGvZr1oNm6AraGDF9Ha+fFYAv4E4n7B7f/tBojEYj6s/R9kb/eb73Z40Nl
 aSHdrehjL9pBzD3Ukjq9DnaU4WPy7QiR0QG4dZNNcm8QVgeqUdjhehVHgZvK77cINjSl
 IrvljG17BOaNEd7Ymj+7w+W5AqdElpekaXtdgHGM1tB/KZgDRC4KIl7zJ8mmpfgMcPIH
 u+E7IfELUJ9F74o9uCgn66FqNoiK6HmtLjxgNXUbWi3Tc+8nrFQnrFedQYEThSzg7ApN
 A/kw==
X-Gm-Message-State: AOJu0YzE+1VDyrZANWXc76WZFcZM454c776emWgJX31EwFWOA/0y4EkJ
 eirVo5SBYs8WeykfFi4DcOF1PNfXsOZjqnuzo9H2JdAAi3hDBFi9oaZ8L6KFI2qyVUgKFwVH5s0
 5wIpE1kwRlgTwQH07n2LqZq2udb/H9K4G7CkXnJyDo478AjX1/RGGt8b07g9bxTyMEUl7gTMv
X-Google-Smtp-Source: AGHT+IF22FxgKsFqlgP54N2O/Zf0TW5PgTeJjDX/FANlW+iPihkEAKhE90UOYhS+jEn5B68KzG3Y+A==
X-Received: by 2002:a05:620a:b5d:b0:76d:93e1:99f4 with SMTP id
 x29-20020a05620a0b5d00b0076d93e199f4mr6129905qkg.8.1694719042314; 
 Thu, 14 Sep 2023 12:17:22 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 x6-20020a05620a14a600b0076eed604793sm666974qkj.130.2023.09.14.12.17.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:21 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:19 -0400
Message-Id: <20230914191635.39805-24-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v3 23/39] dm vdo: add use of the deduplication
 index in hash zones
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
Cc: Matthew Sakai <msakai@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

Add the data and methods that manage queries to the deduplication
index and the responses from the index.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Co-developed-by: Michael Sclafani <vdo-devel@redhat.com>
Signed-off-by: Michael Sclafani <vdo-devel@redhat.com>
Co-developed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Co-developed-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Co-developed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/dedupe.c | 623 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm-vdo/dedupe.h |  26 ++
 2 files changed, 649 insertions(+)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 1d6774e8e546..cddfa3292306 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -143,6 +143,48 @@
 #include "vdo.h"
 #include "wait-queue.h"
 
+struct uds_attribute {
+	struct attribute attr;
+	const char *(*show_string)(struct hash_zones *hash_zones);
+};
+
+enum timer_state {
+	DEDUPE_QUERY_TIMER_IDLE,
+	DEDUPE_QUERY_TIMER_RUNNING,
+	DEDUPE_QUERY_TIMER_FIRED,
+};
+
+enum dedupe_context_state {
+	DEDUPE_CONTEXT_IDLE,
+	DEDUPE_CONTEXT_PENDING,
+	DEDUPE_CONTEXT_TIMED_OUT,
+	DEDUPE_CONTEXT_COMPLETE,
+	DEDUPE_CONTEXT_TIMED_OUT_COMPLETE,
+};
+
+/* Possible index states: closed, opened, or transitioning between those two. */
+enum index_state {
+	IS_CLOSED,
+	IS_CHANGING,
+	IS_OPENED,
+};
+
+static const char *CLOSED = "closed";
+static const char *CLOSING = "closing";
+static const char *ERROR = "error";
+static const char *OFFLINE = "offline";
+static const char *ONLINE = "online";
+static const char *OPENING = "opening";
+static const char *SUSPENDED = "suspended";
+static const char *UNKNOWN = "unknown";
+
+/* Version 2 uses the kernel space UDS index and is limited to 16 bytes */
+enum {
+	UDS_ADVICE_VERSION = 2,
+	/* version byte + state byte + 64-bit little-endian PBN */
+	UDS_ADVICE_SIZE = 1 + 1 + sizeof(u64),
+};
+
 enum hash_lock_state {
 	/* State for locks that are not in use or are being initialized. */
 	VDO_HASH_LOCK_INITIALIZING,
@@ -264,6 +306,13 @@ struct hash_zones {
 	struct hash_zone zones[];
 };
 
+/* These are in milliseconds. */
+unsigned int vdo_dedupe_index_timeout_interval = 5000;
+unsigned int vdo_dedupe_index_min_timer_interval = 100;
+/* Same two variables, in jiffies for easier consumption. */
+static u64 vdo_dedupe_index_timeout_jiffies;
+static u64 vdo_dedupe_index_min_timer_jiffies;
+
 static inline struct hash_zone *as_hash_zone(struct vdo_completion *completion)
 {
 	vdo_assert_completion_type(completion, VDO_HASH_ZONE_COMPLETION);
@@ -283,6 +332,16 @@ static inline void assert_in_hash_zone(struct hash_zone *zone, const char *name)
 			name);
 }
 
+static inline bool change_context_state(struct dedupe_context *context, int old, int new)
+{
+	return (atomic_cmpxchg(&context->state, old, new) == old);
+}
+
+static inline bool change_timer_state(struct hash_zone *zone, int old, int new)
+{
+	return (atomic_cmpxchg(&zone->timer_state, old, new) == old);
+}
+
 /**
  * return_hash_lock_to_pool() - (Re)initialize a hash lock and return it to its pool.
  * @zone: The zone from which the lock was borrowed.
@@ -1955,6 +2014,376 @@ static u32 hash_key(const void *key)
 	return get_unaligned_le32(&name->name[4]);
 }
 
+static void dedupe_kobj_release(struct kobject *directory)
+{
+	UDS_FREE(container_of(directory, struct hash_zones, dedupe_directory));
+}
+
+static ssize_t dedupe_status_show(struct kobject *directory, struct attribute *attr, char *buf)
+{
+	struct uds_attribute *ua = container_of(attr, struct uds_attribute, attr);
+	struct hash_zones *zones = container_of(directory, struct hash_zones, dedupe_directory);
+
+	if (ua->show_string != NULL)
+		return sprintf(buf, "%s\n", ua->show_string(zones));
+	else
+		return -EINVAL;
+}
+
+static ssize_t dedupe_status_store(struct kobject *kobj __always_unused,
+				   struct attribute *attr __always_unused,
+				   const char *buf __always_unused,
+				   size_t length __always_unused)
+{
+	return -EINVAL;
+}
+
+/*----------------------------------------------------------------------*/
+
+static const struct sysfs_ops dedupe_sysfs_ops = {
+	.show = dedupe_status_show,
+	.store = dedupe_status_store,
+};
+
+static struct uds_attribute dedupe_status_attribute = {
+	.attr = {.name = "status", .mode = 0444, },
+	.show_string = vdo_get_dedupe_index_state_name,
+};
+
+static struct attribute *dedupe_attrs[] = {
+	&dedupe_status_attribute.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(dedupe);
+
+static const struct kobj_type dedupe_directory_type = {
+	.release = dedupe_kobj_release,
+	.sysfs_ops = &dedupe_sysfs_ops,
+	.default_groups = dedupe_groups,
+};
+
+static void start_uds_queue(void *ptr)
+{
+	/*
+	 * Allow the UDS dedupe worker thread to do memory allocations. It will only do allocations
+	 * during the UDS calls that open or close an index, but those allocations can safely sleep
+	 * while reserving a large amount of memory. We could use an allocations_allowed boolean
+	 * (like the base threads do), but it would be an unnecessary embellishment.
+	 */
+	struct vdo_thread *thread = vdo_get_work_queue_owner(vdo_get_current_work_queue());
+
+	uds_register_allocating_thread(&thread->allocating_thread, NULL);
+}
+
+static void finish_uds_queue(void *ptr __always_unused)
+{
+	uds_unregister_allocating_thread();
+}
+
+static void close_index(struct hash_zones *zones)
+{
+	int result;
+
+	/*
+	 * Change the index state so that get_index_statistics() will not try to use the index
+	 * session we are closing.
+	 */
+	zones->index_state = IS_CHANGING;
+	/* Close the index session, while not holding the lock. */
+	spin_unlock(&zones->lock);
+	result = uds_close_index(zones->index_session);
+
+	if (result != UDS_SUCCESS)
+		uds_log_error_strerror(result, "Error closing index");
+	spin_lock(&zones->lock);
+	zones->index_state = IS_CLOSED;
+	zones->error_flag |= result != UDS_SUCCESS;
+	/* ASSERTION: We leave in IS_CLOSED state. */
+}
+
+static void open_index(struct hash_zones *zones)
+{
+	/* ASSERTION: We enter in IS_CLOSED state. */
+	int result;
+	bool create_flag = zones->create_flag;
+
+	zones->create_flag = false;
+	/*
+	 * Change the index state so that the it will be reported to the outside world as
+	 * "opening".
+	 */
+	zones->index_state = IS_CHANGING;
+	zones->error_flag = false;
+
+	/* Open the index session, while not holding the lock */
+	spin_unlock(&zones->lock);
+	result = uds_open_index(create_flag ? UDS_CREATE : UDS_LOAD,
+				&zones->parameters,
+				zones->index_session);
+	if (result != UDS_SUCCESS)
+		uds_log_error_strerror(result, "Error opening index");
+
+	spin_lock(&zones->lock);
+	if (!create_flag) {
+		switch (result) {
+		case -ENOENT:
+			/*
+			 * Either there is no index, or there is no way we can recover the index.
+			 * We will be called again and try to create a new index.
+			 */
+			zones->index_state = IS_CLOSED;
+			zones->create_flag = true;
+			return;
+		default:
+			break;
+		}
+	}
+	if (result == UDS_SUCCESS) {
+		zones->index_state = IS_OPENED;
+	} else {
+		zones->index_state = IS_CLOSED;
+		zones->index_target = IS_CLOSED;
+		zones->error_flag = true;
+		spin_unlock(&zones->lock);
+		uds_log_info("Setting UDS index target state to error");
+		spin_lock(&zones->lock);
+	}
+	/*
+	 * ASSERTION: On success, we leave in IS_OPENED state.
+	 * ASSERTION: On failure, we leave in IS_CLOSED state.
+	 */
+}
+
+static void change_dedupe_state(struct vdo_completion *completion)
+{
+	struct hash_zones *zones = as_hash_zones(completion);
+
+	spin_lock(&zones->lock);
+
+	/* Loop until the index is in the target state and the create flag is clear. */
+	while (vdo_is_state_normal(&zones->state) &&
+	       ((zones->index_state != zones->index_target) || zones->create_flag)) {
+		if (zones->index_state == IS_OPENED)
+			close_index(zones);
+		else
+			open_index(zones);
+	}
+
+	zones->changing = false;
+	spin_unlock(&zones->lock);
+}
+
+static void start_expiration_timer(struct dedupe_context *context)
+{
+	u64 start_time = context->submission_jiffies;
+	u64 end_time;
+
+	if (!change_timer_state(context->zone,
+				DEDUPE_QUERY_TIMER_IDLE,
+				DEDUPE_QUERY_TIMER_RUNNING))
+		return;
+
+	end_time = max(start_time + vdo_dedupe_index_timeout_jiffies,
+		       jiffies + vdo_dedupe_index_min_timer_jiffies);
+	mod_timer(&context->zone->timer, end_time);
+}
+
+/**
+ * report_dedupe_timeouts() - Record and eventually report that some dedupe requests reached their
+ *                            expiration time without getting answers, so we timed them out.
+ * @zones: the hash zones.
+ * @timeouts: the number of newly timed out requests.
+ */
+static void report_dedupe_timeouts(struct hash_zones *zones, unsigned int timeouts)
+{
+	atomic64_add(timeouts, &zones->timeouts);
+	spin_lock(&zones->lock);
+	if (__ratelimit(&zones->ratelimiter)) {
+		u64 unreported = atomic64_read(&zones->timeouts);
+
+		unreported -= zones->reported_timeouts;
+		uds_log_debug("UDS index timeout on %llu requests",
+			      (unsigned long long) unreported);
+		zones->reported_timeouts += unreported;
+	}
+	spin_unlock(&zones->lock);
+}
+
+static int initialize_index(struct vdo *vdo, struct hash_zones *zones)
+{
+	int result;
+	off_t uds_offset;
+	struct volume_geometry geometry = vdo->geometry;
+	static const struct vdo_work_queue_type uds_queue_type = {
+		.start = start_uds_queue,
+		.finish = finish_uds_queue,
+		.max_priority = UDS_Q_MAX_PRIORITY,
+		.default_priority = UDS_Q_PRIORITY,
+	};
+
+	vdo_set_dedupe_index_timeout_interval(vdo_dedupe_index_timeout_interval);
+	vdo_set_dedupe_index_min_timer_interval(vdo_dedupe_index_min_timer_interval);
+
+	/*
+	 * Since we will save up the timeouts that would have been reported but were ratelimited,
+	 * we don't need to report ratelimiting.
+	 */
+	ratelimit_default_init(&zones->ratelimiter);
+	ratelimit_set_flags(&zones->ratelimiter, RATELIMIT_MSG_ON_RELEASE);
+	uds_offset = ((vdo_get_index_region_start(geometry) -
+		       geometry.bio_offset) * VDO_BLOCK_SIZE);
+	zones->parameters = (struct uds_parameters) {
+		.name = vdo->device_config->parent_device_name,
+		.offset = uds_offset,
+		.size = (vdo_get_index_region_size(geometry) * VDO_BLOCK_SIZE),
+		.memory_size = geometry.index_config.mem,
+		.sparse = geometry.index_config.sparse,
+		.nonce = (u64) geometry.nonce,
+	};
+
+	result = uds_create_index_session(&zones->index_session);
+	if (result != UDS_SUCCESS)
+		return result;
+
+	result = vdo_make_thread(vdo, vdo->thread_config.dedupe_thread, &uds_queue_type, 1, NULL);
+	if (result != VDO_SUCCESS) {
+		uds_destroy_index_session(UDS_FORGET(zones->index_session));
+		uds_log_error("UDS index queue initialization failed (%d)", result);
+		return result;
+	}
+
+	vdo_initialize_completion(&zones->completion, vdo, VDO_HASH_ZONES_COMPLETION);
+	vdo_set_completion_callback(&zones->completion,
+				    change_dedupe_state,
+				    vdo->thread_config.dedupe_thread);
+	kobject_init(&zones->dedupe_directory, &dedupe_directory_type);
+	return VDO_SUCCESS;
+}
+
+/**
+ * finish_index_operation() - This is the UDS callback for index queries.
+ * @request: The uds request which has just completed.
+ */
+static void finish_index_operation(struct uds_request *request)
+{
+	struct dedupe_context *context = container_of(request, struct dedupe_context, request);
+
+	if (change_context_state(context, DEDUPE_CONTEXT_PENDING, DEDUPE_CONTEXT_COMPLETE)) {
+		/*
+		 * This query has not timed out, so send its data_vio back to its hash zone to
+		 * process the results.
+		 */
+		continue_data_vio(context->requestor);
+		return;
+	}
+
+	/*
+	 * This query has timed out, so try to mark it complete and hence eligible for reuse. Its
+	 * data_vio has already moved on.
+	 */
+	if (!change_context_state(context,
+				  DEDUPE_CONTEXT_TIMED_OUT,
+				  DEDUPE_CONTEXT_TIMED_OUT_COMPLETE))
+		ASSERT_LOG_ONLY(false,
+				"uds request was timed out (state %d)",
+				atomic_read(&context->state));
+
+	uds_funnel_queue_put(context->zone->timed_out_complete, &context->queue_entry);
+}
+
+/**
+ * check_for_drain_complete() - Check whether this zone has drained.
+ * @zone: The zone to check.
+ */
+static void check_for_drain_complete(struct hash_zone *zone)
+{
+	data_vio_count_t recycled = 0;
+
+	if (!vdo_is_state_draining(&zone->state))
+		return;
+
+	if ((atomic_read(&zone->timer_state) == DEDUPE_QUERY_TIMER_IDLE) ||
+	    change_timer_state(zone, DEDUPE_QUERY_TIMER_RUNNING, DEDUPE_QUERY_TIMER_IDLE))
+		del_timer_sync(&zone->timer);
+	else
+		/*
+		 * There is an in flight time-out, which must get processed before we can continue.
+		 */
+		return;
+
+	for (;;) {
+		struct dedupe_context *context;
+		struct funnel_queue_entry *entry;
+
+		entry = uds_funnel_queue_poll(zone->timed_out_complete);
+		if (entry == NULL)
+			break;
+
+		context = container_of(entry, struct dedupe_context, queue_entry);
+		atomic_set(&context->state, DEDUPE_CONTEXT_IDLE);
+		list_add(&context->list_entry, &zone->available);
+		recycled++;
+	}
+
+	if (recycled > 0)
+		WRITE_ONCE(zone->active, zone->active - recycled);
+	ASSERT_LOG_ONLY(READ_ONCE(zone->active) == 0, "all contexts inactive");
+	vdo_finish_draining(&zone->state);
+}
+
+static void timeout_index_operations_callback(struct vdo_completion *completion)
+{
+	struct dedupe_context *context, *tmp;
+	struct hash_zone *zone = as_hash_zone(completion);
+	u64 timeout_jiffies = msecs_to_jiffies(vdo_dedupe_index_timeout_interval);
+	unsigned long cutoff = jiffies - timeout_jiffies;
+	unsigned int timed_out = 0;
+
+	atomic_set(&zone->timer_state, DEDUPE_QUERY_TIMER_IDLE);
+	list_for_each_entry_safe(context, tmp, &zone->pending, list_entry) {
+		if (cutoff <= context->submission_jiffies) {
+			/*
+			 * We have reached the oldest query which has not timed out yet, so restart
+			 * the timer.
+			 */
+			start_expiration_timer(context);
+			break;
+		}
+
+		if (!change_context_state(context,
+					  DEDUPE_CONTEXT_PENDING,
+					  DEDUPE_CONTEXT_TIMED_OUT))
+			/*
+			 * This context completed between the time the timeout fired, and now. We
+			 * can treat it as a a successful query, its requestor is already enqueued
+			 * to process it.
+			 */
+			continue;
+
+		/*
+		 * Remove this context from the pending list so we won't look at it again on a
+		 * subsequent timeout. Once the index completes it, it will be reused. Meanwhile,
+		 * send its requestor on its way.
+		 */
+		list_del_init(&context->list_entry);
+		continue_data_vio(context->requestor);
+		timed_out++;
+	}
+
+	if (timed_out > 0)
+		report_dedupe_timeouts(completion->vdo->hash_zones, timed_out);
+
+	check_for_drain_complete(zone);
+}
+
+static void timeout_index_operations(struct timer_list *t)
+{
+	struct hash_zone *zone = from_timer(zone, t, timer);
+
+	if (change_timer_state(zone, DEDUPE_QUERY_TIMER_RUNNING, DEDUPE_QUERY_TIMER_FIRED))
+		vdo_launch_completion(&zone->completion);
+}
+
 static int __must_check
 initialize_zone(struct vdo *vdo, struct hash_zones *zones, zone_count_t zone_number)
 {
@@ -2448,3 +2877,197 @@ void vdo_dump_hash_zones(struct hash_zones *zones)
 	for (zone = 0; zone < zones->zone_count; zone++)
 		dump_hash_zone(&zones->zones[zone]);
 }
+
+void vdo_set_dedupe_index_timeout_interval(unsigned int value)
+{
+	u64 alb_jiffies;
+
+	/* Arbitrary maximum value is two minutes */
+	if (value > 120000)
+		value = 120000;
+	/* Arbitrary minimum value is 2 jiffies */
+	alb_jiffies = msecs_to_jiffies(value);
+
+	if (alb_jiffies < 2) {
+		alb_jiffies = 2;
+		value = jiffies_to_msecs(alb_jiffies);
+	}
+	vdo_dedupe_index_timeout_interval = value;
+	vdo_dedupe_index_timeout_jiffies = alb_jiffies;
+}
+
+void vdo_set_dedupe_index_min_timer_interval(unsigned int value)
+{
+	u64 min_jiffies;
+
+	/* Arbitrary maximum value is one second */
+	if (value > 1000)
+		value = 1000;
+
+	/* Arbitrary minimum value is 2 jiffies */
+	min_jiffies = msecs_to_jiffies(value);
+
+	if (min_jiffies < 2) {
+		min_jiffies = 2;
+		value = jiffies_to_msecs(min_jiffies);
+	}
+
+	vdo_dedupe_index_min_timer_interval = value;
+	vdo_dedupe_index_min_timer_jiffies = min_jiffies;
+}
+
+/**
+ * acquire_context() - Acquire a dedupe context from a hash_zone if any are available.
+ * @zone: the hash zone
+ *
+ * Return: A dedupe_context or NULL if none are available
+ */
+static struct dedupe_context * __must_check acquire_context(struct hash_zone *zone)
+{
+	struct dedupe_context *context;
+	struct funnel_queue_entry *entry;
+
+	assert_in_hash_zone(zone, __func__);
+
+	if (!list_empty(&zone->available)) {
+		WRITE_ONCE(zone->active, zone->active + 1);
+		context = list_first_entry(&zone->available, struct dedupe_context, list_entry);
+		list_del_init(&context->list_entry);
+		return context;
+	}
+
+	entry = uds_funnel_queue_poll(zone->timed_out_complete);
+	return ((entry == NULL) ? NULL : container_of(entry, struct dedupe_context, queue_entry));
+}
+
+static void prepare_uds_request(struct uds_request *request,
+				struct data_vio *data_vio,
+				enum uds_request_type operation)
+{
+	request->record_name = data_vio->record_name;
+	request->type = operation;
+	if ((operation == UDS_POST) || (operation == UDS_UPDATE)) {
+		size_t offset = 0;
+		struct uds_record_data *encoding = &request->new_metadata;
+
+		encoding->data[offset++] = UDS_ADVICE_VERSION;
+		encoding->data[offset++] = data_vio->new_mapped.state;
+		put_unaligned_le64(data_vio->new_mapped.pbn, &encoding->data[offset]);
+		offset += sizeof(u64);
+		BUG_ON(offset != UDS_ADVICE_SIZE);
+	}
+}
+
+/*
+ * The index operation will inquire about data_vio.record_name, providing (if the operation is
+ * appropriate) advice from the data_vio's new_mapped fields. The advice found in the index (or
+ * NULL if none) will be returned via receive_data_vio_dedupe_advice(). dedupe_context.status is
+ * set to the return status code of any asynchronous index processing.
+ */
+static void query_index(struct data_vio *data_vio, enum uds_request_type operation)
+{
+	int result;
+	struct dedupe_context *context;
+	struct vdo *vdo = vdo_from_data_vio(data_vio);
+	struct hash_zone *zone = data_vio->hash_zone;
+
+	assert_data_vio_in_hash_zone(data_vio);
+
+	if (!READ_ONCE(vdo->hash_zones->dedupe_flag)) {
+		continue_data_vio(data_vio);
+		return;
+	}
+
+	context = acquire_context(zone);
+	if (context == NULL) {
+		atomic64_inc(&vdo->hash_zones->dedupe_context_busy);
+		continue_data_vio(data_vio);
+		return;
+	}
+
+	data_vio->dedupe_context = context;
+	context->requestor = data_vio;
+	context->submission_jiffies = jiffies;
+	prepare_uds_request(&context->request, data_vio, operation);
+	atomic_set(&context->state, DEDUPE_CONTEXT_PENDING);
+	list_add_tail(&context->list_entry, &zone->pending);
+	start_expiration_timer(context);
+	result = uds_launch_request(&context->request);
+	if (result != UDS_SUCCESS) {
+		context->request.status = result;
+		finish_index_operation(&context->request);
+	}
+}
+
+static void set_target_state(struct hash_zones *zones,
+			     enum index_state target,
+			     bool change_dedupe,
+			     bool dedupe,
+			     bool set_create)
+{
+	const char *old_state, *new_state;
+
+	spin_lock(&zones->lock);
+	old_state = index_state_to_string(zones, zones->index_target);
+	if (change_dedupe)
+		WRITE_ONCE(zones->dedupe_flag, dedupe);
+
+	if (set_create)
+		zones->create_flag = true;
+
+	zones->index_target = target;
+	launch_dedupe_state_change(zones);
+	new_state = index_state_to_string(zones, zones->index_target);
+	spin_unlock(&zones->lock);
+
+	if (old_state != new_state)
+		uds_log_info("Setting UDS index target state to %s", new_state);
+}
+
+const char *vdo_get_dedupe_index_state_name(struct hash_zones *zones)
+{
+	const char *state;
+
+	spin_lock(&zones->lock);
+	state = index_state_to_string(zones, zones->index_state);
+	spin_unlock(&zones->lock);
+
+	return state;
+}
+
+/* Handle a dmsetup message relevant to the index. */
+int vdo_message_dedupe_index(struct hash_zones *zones, const char *name)
+{
+	if (strcasecmp(name, "index-close") == 0) {
+		set_target_state(zones, IS_CLOSED, false, false, false);
+		return 0;
+	} else if (strcasecmp(name, "index-create") == 0) {
+		set_target_state(zones, IS_OPENED, false, false, true);
+		return 0;
+	} else if (strcasecmp(name, "index-disable") == 0) {
+		set_target_state(zones, IS_OPENED, true, false, false);
+		return 0;
+	} else if (strcasecmp(name, "index-enable") == 0) {
+		set_target_state(zones, IS_OPENED, true, true, false);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+int vdo_add_dedupe_index_sysfs(struct hash_zones *zones)
+{
+	int result = kobject_add(&zones->dedupe_directory,
+				 &zones->completion.vdo->vdo_directory,
+				 "dedupe");
+
+	if (result == 0)
+		vdo_set_admin_state_code(&zones->state, VDO_ADMIN_STATE_NORMAL_OPERATION);
+
+	return result;
+}
+
+/* If create_flag, create a new index without first attempting to load an existing index. */
+void vdo_start_dedupe_index(struct hash_zones *zones, bool create_flag)
+{
+	set_target_state(zones, IS_OPENED, true, true, create_flag);
+}
diff --git a/drivers/md/dm-vdo/dedupe.h b/drivers/md/dm-vdo/dedupe.h
index af329fb0fa68..01fdb9bc29c1 100644
--- a/drivers/md/dm-vdo/dedupe.h
+++ b/drivers/md/dm-vdo/dedupe.h
@@ -90,4 +90,30 @@ vdo_select_hash_zone(struct hash_zones *zones, const struct uds_record_name *nam
 
 void vdo_dump_hash_zones(struct hash_zones *zones);
 
+const char *vdo_get_dedupe_index_state_name(struct hash_zones *zones);
+
+u64 vdo_get_dedupe_index_timeout_count(struct hash_zones *zones);
+
+int vdo_message_dedupe_index(struct hash_zones *zones, const char *name);
+
+int vdo_add_dedupe_index_sysfs(struct hash_zones *zones);
+
+void vdo_start_dedupe_index(struct hash_zones *zones, bool create_flag);
+
+void vdo_resume_hash_zones(struct hash_zones *zones, struct vdo_completion *parent);
+
+void vdo_finish_dedupe_index(struct hash_zones *zones);
+
+/* Interval (in milliseconds) from submission until switching to fast path and skipping UDS. */
+extern unsigned int vdo_dedupe_index_timeout_interval;
+
+/*
+ * Minimum time interval (in milliseconds) between timer invocations to check for requests waiting
+ * for UDS that should now time out.
+ */
+extern unsigned int vdo_dedupe_index_min_timer_interval;
+
+void vdo_set_dedupe_index_timeout_interval(unsigned int value);
+void vdo_set_dedupe_index_min_timer_interval(unsigned int value);
+
 #endif /* VDO_DEDUPE_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

