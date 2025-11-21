Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEB030B511
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 22:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763765487; cv=none; b=RmL9hidAgkZc5p67hJ0UqO8k9+w7fLnoDvtJWoa1wUX5Zi1lpnrcACD8Trd7vIl0x6Mvl5FwLOJLeaEqUofiU8Mpm5Mdegm2EycGW83sZ467XGyAsWEZWC6YYF53Meh53Jbz831qleXP9ubJ9DVU/H3BUJLVgjiQpuYFMGCmRWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763765487; c=relaxed/simple;
	bh=FsILYpbBWBZhLy05gqJ8Lk2FZVEoxLCXx3RfggsVWy8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=ZriNyHlgHcVlUnP2jKPOrvIrX4fMvJw4U6AN6DdDWqwjIeJ6dZEddt3ld18Qlhd/GtK9LyEOIuU7LIeQjTjJFCuW3n25yeomYwuv4Oau3r69xT27//1Jljp7OsOjuX+ff6Axq6VMJuTo6EoIQsQaU4WDH+jHjyISatGj4GR+kl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bSqdFoSG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSqdFoSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763765474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DipzMi4mtEIj4pfTDXTqhobuQPo/d3IU8i+Di3Iofow=;
	b=bSqdFoSGAjeSiWkTt5pmipHYoh+W+n2FYZ/sgo/6xDEMMXN6cA6d5/jV98gtTsnpUNvSsx
	cPF5qRb+qBpHvcUqs53sIwwsqnmd5s370r/8FzZwfGYqjysHpgUVCivEkAw80ruc1E0Kbo
	V+Gf0wmSQibp3zEh2wne36qII/fDEa4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-82-DZgiKsPxOnSE1AsULWRaeQ-1; Fri,
 21 Nov 2025 17:51:11 -0500
X-MC-Unique: DZgiKsPxOnSE1AsULWRaeQ-1
X-Mimecast-MFC-AGG-ID: DZgiKsPxOnSE1AsULWRaeQ_1763765470
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 816421956052
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 22:51:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 38BF31956045;
	Fri, 21 Nov 2025 22:51:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 8503D1196B0; Fri, 21 Nov 2025 17:51:04 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: fix kerneldoc warnings
Date: Fri, 21 Nov 2025 17:51:04 -0500
Message-ID: <ced1e2737e0d316fd44570ca5985066a7369747f.1763765019.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mvN5sElQVu51igrGOSXvDV6Bs1Akzh5QYiChdMdBp60_1763765470
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Fix kerneldoc warnings across the dm-vdo target. Also
remove some unhelpful or inaccurate doc comments, and fix
some format inconsistencies that did not produce warnings.

No functional changes.

Suggested-by: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/action-manager.c   |  2 +-
 drivers/md/dm-vdo/admin-state.c      | 75 ++++++++++++++--------
 drivers/md/dm-vdo/block-map.c        | 51 ++++++++++++---
 drivers/md/dm-vdo/completion.c       |  5 ++
 drivers/md/dm-vdo/data-vio.c         | 34 +++++++++-
 drivers/md/dm-vdo/dedupe.c           | 42 ++++++------
 drivers/md/dm-vdo/dm-vdo-target.c    |  5 +-
 drivers/md/dm-vdo/encodings.c        | 26 +++++++-
 drivers/md/dm-vdo/flush.c            |  6 +-
 drivers/md/dm-vdo/funnel-workqueue.c |  7 ++
 drivers/md/dm-vdo/io-submitter.c     | 26 ++++----
 drivers/md/dm-vdo/logical-zone.c     | 20 ++----
 drivers/md/dm-vdo/packer.c           | 15 ++---
 drivers/md/dm-vdo/physical-zone.c    |  5 +-
 drivers/md/dm-vdo/recovery-journal.c | 30 +++++----
 drivers/md/dm-vdo/slab-depot.c       | 96 ++++++++++++++++------------
 drivers/md/dm-vdo/vdo.c              |  9 ++-
 drivers/md/dm-vdo/vdo.h              |  4 +-
 drivers/md/dm-vdo/vio.c              |  3 +-
 drivers/md/dm-vdo/vio.h              |  6 +-
 20 files changed, 298 insertions(+), 169 deletions(-)

diff --git a/drivers/md/dm-vdo/action-manager.c b/drivers/md/dm-vdo/action-manager.c
index a0e5e7077d13..e3bba0b28aad 100644
--- a/drivers/md/dm-vdo/action-manager.c
+++ b/drivers/md/dm-vdo/action-manager.c
@@ -43,7 +43,7 @@ struct action {
  * @actions: The two action slots.
  * @current_action: The current action slot.
  * @zones: The number of zones in which an action is to be applied.
- * @Scheduler: A function to schedule a default next action.
+ * @scheduler: A function to schedule a default next action.
  * @get_zone_thread_id: A function to get the id of the thread on which to apply an action to a
  *                      zone.
  * @initiator_thread_id: The ID of the thread on which actions may be initiated.
diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
index 3f9dba525154..da153fef085e 100644
--- a/drivers/md/dm-vdo/admin-state.c
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -149,7 +149,8 @@ const struct admin_state_code *VDO_ADMIN_STATE_RESUMING = &VDO_CODE_RESUMING;
 /**
  * get_next_state() - Determine the state which should be set after a given operation completes
  *                    based on the operation and the current state.
- * @operation The operation to be started.
+ * @state: The current admin state.
+ * @operation: The operation to be started.
  *
  * Return: The state to set when the operation completes or NULL if the operation can not be
  *         started in the current state.
@@ -187,6 +188,8 @@ static const struct admin_state_code *get_next_state(const struct admin_state *s
 
 /**
  * vdo_finish_operation() - Finish the current operation.
+ * @state: The current admin state.
+ * @result: The result of the operation.
  *
  * Will notify the operation waiter if there is one. This method should be used for operations
  * started with vdo_start_operation(). For operations which were started with vdo_start_draining(),
@@ -214,8 +217,10 @@ bool vdo_finish_operation(struct admin_state *state, int result)
 
 /**
  * begin_operation() - Begin an operation if it may be started given the current state.
- * @waiter A completion to notify when the operation is complete; may be NULL.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The current admin state.
+ * @operation: The operation to be started.
+ * @waiter: A completion to notify when the operation is complete; may be NULL.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: VDO_SUCCESS or an error.
  */
@@ -259,8 +264,10 @@ static int __must_check begin_operation(struct admin_state *state,
 
 /**
  * start_operation() - Start an operation if it may be started given the current state.
- * @waiter     A completion to notify when the operation is complete.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The current admin state.
+ * @operation: The operation to be started.
+ * @waiter: A completion to notify when the operation is complete; may be NULL.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: true if the operation was started.
  */
@@ -274,10 +281,10 @@ static inline bool __must_check start_operation(struct admin_state *state,
 
 /**
  * check_code() - Check the result of a state validation.
- * @valid true if the code is of an appropriate type.
- * @code The code which failed to be of the correct type.
- * @what What the code failed to be, for logging.
- * @waiter The completion to notify of the error; may be NULL.
+ * @valid: True if the code is of an appropriate type.
+ * @code: The code which failed to be of the correct type.
+ * @what: What the code failed to be, for logging.
+ * @waiter: The completion to notify of the error; may be NULL.
  *
  * If the result failed, log an invalid state error and, if there is a waiter, notify it.
  *
@@ -301,7 +308,8 @@ static bool check_code(bool valid, const struct admin_state_code *code, const ch
 
 /**
  * assert_vdo_drain_operation() - Check that an operation is a drain.
- * @waiter The completion to finish with an error if the operation is not a drain.
+ * @operation: The operation to check.
+ * @waiter: The completion to finish with an error if the operation is not a drain.
  *
  * Return: true if the specified operation is a drain.
  */
@@ -313,9 +321,10 @@ static bool __must_check assert_vdo_drain_operation(const struct admin_state_cod
 
 /**
  * vdo_start_draining() - Initiate a drain operation if the current state permits it.
- * @operation The type of drain to initiate.
- * @waiter The completion to notify when the drain is complete.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The current admin state.
+ * @operation: The type of drain to initiate.
+ * @waiter: The completion to notify when the drain is complete.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: true if the drain was initiated, if not the waiter will be notified.
  */
@@ -345,6 +354,7 @@ bool vdo_start_draining(struct admin_state *state,
 
 /**
  * vdo_finish_draining() - Finish a drain operation if one was in progress.
+ * @state: The current admin state.
  *
  * Return: true if the state was draining; will notify the waiter if so.
  */
@@ -355,6 +365,8 @@ bool vdo_finish_draining(struct admin_state *state)
 
 /**
  * vdo_finish_draining_with_result() - Finish a drain operation with a status code.
+ * @state: The current admin state.
+ * @result: The result of the drain operation.
  *
  * Return: true if the state was draining; will notify the waiter if so.
  */
@@ -365,7 +377,8 @@ bool vdo_finish_draining_with_result(struct admin_state *state, int result)
 
 /**
  * vdo_assert_load_operation() - Check that an operation is a load.
- * @waiter The completion to finish with an error if the operation is not a load.
+ * @operation: The operation to check.
+ * @waiter: The completion to finish with an error if the operation is not a load.
  *
  * Return: true if the specified operation is a load.
  */
@@ -377,9 +390,10 @@ bool vdo_assert_load_operation(const struct admin_state_code *operation,
 
 /**
  * vdo_start_loading() - Initiate a load operation if the current state permits it.
- * @operation The type of load to initiate.
- * @waiter The completion to notify when the load is complete (may be NULL).
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The current admin state.
+ * @operation: The type of load to initiate.
+ * @waiter: The completion to notify when the load is complete; may be NULL.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: true if the load was initiated, if not the waiter will be notified.
  */
@@ -393,6 +407,7 @@ bool vdo_start_loading(struct admin_state *state,
 
 /**
  * vdo_finish_loading() - Finish a load operation if one was in progress.
+ * @state: The current admin state.
  *
  * Return: true if the state was loading; will notify the waiter if so.
  */
@@ -403,7 +418,8 @@ bool vdo_finish_loading(struct admin_state *state)
 
 /**
  * vdo_finish_loading_with_result() - Finish a load operation with a status code.
- * @result The result of the load operation.
+ * @state: The current admin state.
+ * @result: The result of the load operation.
  *
  * Return: true if the state was loading; will notify the waiter if so.
  */
@@ -414,7 +430,8 @@ bool vdo_finish_loading_with_result(struct admin_state *state, int result)
 
 /**
  * assert_vdo_resume_operation() - Check whether an admin_state_code is a resume operation.
- * @waiter The completion to notify if the operation is not a resume operation; may be NULL.
+ * @operation: The operation to check.
+ * @waiter: The completion to notify if the operation is not a resume operation; may be NULL.
  *
  * Return: true if the code is a resume operation.
  */
@@ -427,9 +444,10 @@ static bool __must_check assert_vdo_resume_operation(const struct admin_state_co
 
 /**
  * vdo_start_resuming() - Initiate a resume operation if the current state permits it.
- * @operation The type of resume to start.
- * @waiter The completion to notify when the resume is complete (may be NULL).
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The current admin state.
+ * @operation: The type of resume to start.
+ * @waiter: The completion to notify when the resume is complete; may be NULL.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: true if the resume was initiated, if not the waiter will be notified.
  */
@@ -443,6 +461,7 @@ bool vdo_start_resuming(struct admin_state *state,
 
 /**
  * vdo_finish_resuming() - Finish a resume operation if one was in progress.
+ * @state: The current admin state.
  *
  * Return: true if the state was resuming; will notify the waiter if so.
  */
@@ -453,7 +472,8 @@ bool vdo_finish_resuming(struct admin_state *state)
 
 /**
  * vdo_finish_resuming_with_result() - Finish a resume operation with a status code.
- * @result The result of the resume operation.
+ * @state: The current admin state.
+ * @result: The result of the resume operation.
  *
  * Return: true if the state was resuming; will notify the waiter if so.
  */
@@ -465,6 +485,7 @@ bool vdo_finish_resuming_with_result(struct admin_state *state, int result)
 /**
  * vdo_resume_if_quiescent() - Change the state to normal operation if the current state is
  *                             quiescent.
+ * @state: The current admin state.
  *
  * Return: VDO_SUCCESS if the state resumed, VDO_INVALID_ADMIN_STATE otherwise.
  */
@@ -479,6 +500,8 @@ int vdo_resume_if_quiescent(struct admin_state *state)
 
 /**
  * vdo_start_operation() - Attempt to start an operation.
+ * @state: The current admin state.
+ * @operation: The operation to attempt to start.
  *
  * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
  */
@@ -490,8 +513,10 @@ int vdo_start_operation(struct admin_state *state,
 
 /**
  * vdo_start_operation_with_waiter() - Attempt to start an operation.
- * @waiter the completion to notify when the operation completes or fails to start; may be NULL.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The current admin state.
+ * @operation: The operation to attempt to start.
+ * @waiter: The completion to notify when the operation completes or fails to start; may be NULL.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
  */
diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index baf683cabb1b..a7db5b41155e 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -174,6 +174,7 @@ static inline struct vdo_page_completion *page_completion_from_waiter(struct vdo
 
 /**
  * initialize_info() - Initialize all page info structures and put them on the free list.
+ * @cache: The page cache.
  *
  * Return: VDO_SUCCESS or an error.
  */
@@ -209,6 +210,7 @@ static int initialize_info(struct vdo_page_cache *cache)
 /**
  * allocate_cache_components() - Allocate components of the cache which require their own
  *                               allocation.
+ * @cache: The page cache.
  *
  * The caller is responsible for all clean up on errors.
  *
@@ -238,6 +240,8 @@ static int __must_check allocate_cache_components(struct vdo_page_cache *cache)
 /**
  * assert_on_cache_thread() - Assert that a function has been called on the VDO page cache's
  *                            thread.
+ * @cache: The page cache.
+ * @function_name: The funtion name to report if the assertion fails.
  */
 static inline void assert_on_cache_thread(struct vdo_page_cache *cache,
 					  const char *function_name)
@@ -271,6 +275,7 @@ static void report_cache_pressure(struct vdo_page_cache *cache)
 
 /**
  * get_page_state_name() - Return the name of a page state.
+ * @state: The page state to describe.
  *
  * If the page state is invalid a static string is returned and the invalid state is logged.
  *
@@ -342,6 +347,8 @@ static void update_lru(struct page_info *info)
 /**
  * set_info_state() - Set the state of a page_info and put it on the right list, adjusting
  *                    counters.
+ * @info: The page info to update.
+ * @new_state: The new state to set.
  */
 static void set_info_state(struct page_info *info, enum vdo_page_buffer_state new_state)
 {
@@ -416,6 +423,7 @@ static int reset_page_info(struct page_info *info)
 
 /**
  * find_free_page() - Find a free page.
+ * @cache: The page cache.
  *
  * Return: A pointer to the page info structure (if found), NULL otherwise.
  */
@@ -433,6 +441,7 @@ static struct page_info * __must_check find_free_page(struct vdo_page_cache *cac
 
 /**
  * find_page() - Find the page info (if any) associated with a given pbn.
+ * @cache: The page cache.
  * @pbn: The absolute physical block number of the page.
  *
  * Return: The page info for the page if available, or NULL if not.
@@ -449,6 +458,7 @@ static struct page_info * __must_check find_page(struct vdo_page_cache *cache,
 
 /**
  * select_lru_page() - Determine which page is least recently used.
+ * @cache: The page cache.
  *
  * Picks the least recently used from among the non-busy entries at the front of each of the lru
  * list. Since whenever we mark a page busy we also put it to the end of the list it is unlikely
@@ -523,6 +533,8 @@ static void complete_waiter_with_page(struct vdo_waiter *waiter, void *page_info
 
 /**
  * distribute_page_over_waitq() - Complete a waitq of VDO page completions with a page result.
+ * @info: The loaded page info.
+ * @waitq: The list of waiting data_vios.
  *
  * Upon completion the waitq will be empty.
  *
@@ -548,7 +560,9 @@ static unsigned int distribute_page_over_waitq(struct page_info *info,
 
 /**
  * set_persistent_error() - Set a persistent error which all requests will receive in the future.
+ * @cache: The page cache.
  * @context: A string describing what triggered the error.
+ * @result: The error result to set on the cache.
  *
  * Once triggered, all enqueued completions will get this error. Any future requests will result in
  * this error as well.
@@ -581,6 +595,7 @@ static void set_persistent_error(struct vdo_page_cache *cache, const char *conte
 /**
  * validate_completed_page() - Check that a page completion which is being freed to the cache
  *                             referred to a valid page and is in a valid state.
+ * @completion: The page completion to check.
  * @writable: Whether a writable page is required.
  *
  * Return: VDO_SUCCESS if the page was valid, otherwise as error
@@ -758,6 +773,8 @@ static void load_cache_page_endio(struct bio *bio)
 
 /**
  * launch_page_load() - Begin the process of loading a page.
+ * @info: The page info to launch.
+ * @pbn: The absolute physical block number of the page to load.
  *
  * Return: VDO_SUCCESS or an error code.
  */
@@ -836,6 +853,7 @@ static void save_pages(struct vdo_page_cache *cache)
 
 /**
  * schedule_page_save() - Add a page to the outgoing list of pages waiting to be saved.
+ * @info: The page info to save.
  *
  * Once in the list, a page may not be used until it has been written out.
  */
@@ -854,6 +872,7 @@ static void schedule_page_save(struct page_info *info)
 /**
  * launch_page_save() - Add a page to outgoing pages waiting to be saved, and then start saving
  * pages if another save is not in progress.
+ * @info: The page info to save.
  */
 static void launch_page_save(struct page_info *info)
 {
@@ -864,6 +883,7 @@ static void launch_page_save(struct page_info *info)
 /**
  * completion_needs_page() - Determine whether a given vdo_page_completion (as a waiter) is
  *                           requesting a given page number.
+ * @waiter: The page completion waiter to check.
  * @context: A pointer to the pbn of the desired page.
  *
  * Implements waiter_match_fn.
@@ -880,6 +900,7 @@ static bool completion_needs_page(struct vdo_waiter *waiter, void *context)
 /**
  * allocate_free_page() - Allocate a free page to the first completion in the waiting queue, and
  *                        any other completions that match it in page number.
+ * @info: The page info to allocate a page for.
  */
 static void allocate_free_page(struct page_info *info)
 {
@@ -925,6 +946,7 @@ static void allocate_free_page(struct page_info *info)
 
 /**
  * discard_a_page() - Begin the process of discarding a page.
+ * @cache: The page cache.
  *
  * If no page is discardable, increments a count of deferred frees so that the next release of a
  * page which is no longer busy will kick off another discard cycle. This is an indication that the
@@ -955,10 +977,6 @@ static void discard_a_page(struct vdo_page_cache *cache)
 	launch_page_save(info);
 }
 
-/**
- * discard_page_for_completion() - Helper used to trigger a discard so that the completion can get
- *                                 a different page.
- */
 static void discard_page_for_completion(struct vdo_page_completion *vdo_page_comp)
 {
 	struct vdo_page_cache *cache = vdo_page_comp->cache;
@@ -1132,6 +1150,7 @@ static void write_pages(struct vdo_completion *flush_completion)
 
 /**
  * vdo_release_page_completion() - Release a VDO Page Completion.
+ * @completion: The page completion to release.
  *
  * The page referenced by this completion (if any) will no longer be held busy by this completion.
  * If a page becomes discardable and there are completions awaiting free pages then a new round of
@@ -1172,10 +1191,6 @@ void vdo_release_page_completion(struct vdo_completion *completion)
 	}
 }
 
-/**
- * load_page_for_completion() - Helper function to load a page as described by a VDO Page
- *                              Completion.
- */
 static void load_page_for_completion(struct page_info *info,
 				     struct vdo_page_completion *vdo_page_comp)
 {
@@ -1319,6 +1334,7 @@ int vdo_get_cached_page(struct vdo_completion *completion,
 
 /**
  * vdo_invalidate_page_cache() - Invalidate all entries in the VDO page cache.
+ * @cache: The page cache.
  *
  * There must not be any dirty pages in the cache.
  *
@@ -1345,6 +1361,10 @@ int vdo_invalidate_page_cache(struct vdo_page_cache *cache)
 
 /**
  * get_tree_page_by_index() - Get the tree page for a given height and page index.
+ * @forest: The block map forest.
+ * @root_index: The root index of the tree to search.
+ * @height: The height in the tree.
+ * @page_index: The page index.
  *
  * Return: The requested page.
  */
@@ -2211,6 +2231,7 @@ static void allocate_block_map_page(struct block_map_zone *zone,
 /**
  * vdo_find_block_map_slot() - Find the block map slot in which the block map entry for a data_vio
  *                             resides and cache that result in the data_vio.
+ * @data_vio: The data vio.
  *
  * All ancestors in the tree will be allocated or loaded, as needed.
  */
@@ -2435,6 +2456,7 @@ static void deforest(struct forest *forest, size_t first_page_segment)
 /**
  * make_forest() - Make a collection of trees for a block_map, expanding the existing forest if
  *                 there is one.
+ * @map: The block map.
  * @entries: The number of entries the block map will hold.
  *
  * Return: VDO_SUCCESS or an error.
@@ -2476,6 +2498,7 @@ static int make_forest(struct block_map *map, block_count_t entries)
 
 /**
  * replace_forest() - Replace a block_map's forest with the already-prepared larger forest.
+ * @map: The block map.
  */
 static void replace_forest(struct block_map *map)
 {
@@ -2492,6 +2515,7 @@ static void replace_forest(struct block_map *map)
 /**
  * finish_cursor() - Finish the traversal of a single tree. If it was the last cursor, finish the
  *                   traversal.
+ * @cursor: The cursor to complete.
  */
 static void finish_cursor(struct cursor *cursor)
 {
@@ -2549,6 +2573,7 @@ static void traversal_endio(struct bio *bio)
 
 /**
  * traverse() - Traverse a single block map tree.
+ * @cursor: A cursor tracking traversal progress.
  *
  * This is the recursive heart of the traversal process.
  */
@@ -2619,6 +2644,7 @@ static void traverse(struct cursor *cursor)
 /**
  * launch_cursor() - Start traversing a single block map tree now that the cursor has a VIO with
  *                   which to load pages.
+ * @waiter: The parent of the cursor to launch.
  * @context: The pooled_vio just acquired.
  *
  * Implements waiter_callback_fn.
@@ -2636,6 +2662,8 @@ static void launch_cursor(struct vdo_waiter *waiter, void *context)
 
 /**
  * compute_boundary() - Compute the number of pages used at each level of the given root's tree.
+ * @map: The block map.
+ * @root_index: The tree root index.
  *
  * Return: The list of page counts as a boundary structure.
  */
@@ -2668,6 +2696,7 @@ static struct boundary compute_boundary(struct block_map *map, root_count_t root
 
 /**
  * vdo_traverse_forest() - Walk the entire forest of a block map.
+ * @map: The block map.
  * @callback: A function to call with the pbn of each allocated node in the forest.
  * @completion: The completion to notify on each traversed PBN, and when traversal completes.
  */
@@ -2707,6 +2736,9 @@ void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
 
 /**
  * initialize_block_map_zone() - Initialize the per-zone portions of the block map.
+ * @map: The block map.
+ * @zone_number: The zone to initialize.
+ * @cache_size: The total block map cache size.
  * @maximum_age: The number of journal blocks before a dirtied page is considered old and must be
  *               written out.
  */
@@ -3091,6 +3123,7 @@ static void fetch_mapping_page(struct data_vio *data_vio, bool modifiable,
 
 /**
  * clear_mapped_location() - Clear a data_vio's mapped block location, setting it to be unmapped.
+ * @data_vio: The data vio.
  *
  * This indicates the block map entry for the logical block is either unmapped or corrupted.
  */
@@ -3104,6 +3137,8 @@ static void clear_mapped_location(struct data_vio *data_vio)
 /**
  * set_mapped_location() - Decode and validate a block map entry, and set the mapped location of a
  *                         data_vio.
+ * @data_vio: The data vio.
+ * @entry: The new mapped entry to set.
  *
  * Return: VDO_SUCCESS or VDO_BAD_MAPPING if the map entry is invalid or an error code for any
  *         other failure
diff --git a/drivers/md/dm-vdo/completion.c b/drivers/md/dm-vdo/completion.c
index 5ad85334632d..2f00acbb3b2b 100644
--- a/drivers/md/dm-vdo/completion.c
+++ b/drivers/md/dm-vdo/completion.c
@@ -65,6 +65,8 @@ static inline void assert_incomplete(struct vdo_completion *completion)
 
 /**
  * vdo_set_completion_result() - Set the result of a completion.
+ * @completion: The completion to update.
+ * @result: The result to set.
  *
  * Older errors will not be masked.
  */
@@ -77,6 +79,7 @@ void vdo_set_completion_result(struct vdo_completion *completion, int result)
 
 /**
  * vdo_launch_completion_with_priority() - Run or enqueue a completion.
+ * @completion: The completion to launch.
  * @priority: The priority at which to enqueue the completion.
  *
  * If called on the correct thread (i.e. the one specified in the completion's callback_thread_id
@@ -125,6 +128,8 @@ void vdo_enqueue_completion(struct vdo_completion *completion,
 
 /**
  * vdo_requeue_completion_if_needed() - Requeue a completion if not called on the specified thread.
+ * @completion: The completion to requeue.
+ * @callback_thread_id: The thread on which to requeue the completion.
  *
  * Return: True if the completion was requeued; callers may not access the completion in this case.
  */
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 89e4398a2836..0d5ec69154c0 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -227,6 +227,7 @@ static inline u64 get_arrival_time(struct bio *bio)
 /**
  * check_for_drain_complete_locked() - Check whether a data_vio_pool has no outstanding data_vios
  *				       or waiters while holding the pool's lock.
+ * @pool: The data_vio pool.
  */
 static bool check_for_drain_complete_locked(struct data_vio_pool *pool)
 {
@@ -387,6 +388,7 @@ struct data_vio_compression_status advance_data_vio_compression_stage(struct dat
 
 /**
  * cancel_data_vio_compression() - Prevent this data_vio from being compressed or packed.
+ * @data_vio: The data_vio.
  *
  * Return: true if the data_vio is in the packer and the caller was the first caller to cancel it.
  */
@@ -483,6 +485,8 @@ static void attempt_logical_block_lock(struct vdo_completion *completion)
 /**
  * launch_data_vio() - (Re)initialize a data_vio to have a new logical block number, keeping the
  *		       same parent and other state and send it on its way.
+ * @data_vio: The data_vio to launch.
+ * @lbn: The logical block number.
  */
 static void launch_data_vio(struct data_vio *data_vio, logical_block_number_t lbn)
 {
@@ -641,6 +645,7 @@ static void update_limiter(struct limiter *limiter)
 
 /**
  * schedule_releases() - Ensure that release processing is scheduled.
+ * @pool: The data_vio pool.
  *
  * If this call switches the state to processing, enqueue. Otherwise, some other thread has already
  * done so.
@@ -768,6 +773,8 @@ static void initialize_limiter(struct limiter *limiter, struct data_vio_pool *po
 
 /**
  * initialize_data_vio() - Allocate the components of a data_vio.
+ * @data_vio: The data_vio to initialize.
+ * @vdo: The vdo containing the data_vio.
  *
  * The caller is responsible for cleaning up the data_vio on error.
  *
@@ -880,6 +887,7 @@ int make_data_vio_pool(struct vdo *vdo, data_vio_count_t pool_size,
 
 /**
  * free_data_vio_pool() - Free a data_vio_pool and the data_vios in it.
+ * @pool: The data_vio pool to free.
  *
  * All data_vios must be returned to the pool before calling this function.
  */
@@ -944,6 +952,8 @@ static void wait_permit(struct limiter *limiter, struct bio *bio)
 
 /**
  * vdo_launch_bio() - Acquire a data_vio from the pool, assign the bio to it, and launch it.
+ * @pool: The data_vio pool.
+ * @bio: The bio to launch.
  *
  * This will block if data_vios or discard permits are not available.
  */
@@ -994,6 +1004,7 @@ static void assert_on_vdo_cpu_thread(const struct vdo *vdo, const char *name)
 
 /**
  * drain_data_vio_pool() - Wait asynchronously for all data_vios to be returned to the pool.
+ * @pool: The data_vio pool.
  * @completion: The completion to notify when the pool has drained.
  */
 void drain_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *completion)
@@ -1005,6 +1016,7 @@ void drain_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *comp
 
 /**
  * resume_data_vio_pool() - Resume a data_vio pool.
+ * @pool: The data_vio pool.
  * @completion: The completion to notify when the pool has resumed.
  */
 void resume_data_vio_pool(struct data_vio_pool *pool, struct vdo_completion *completion)
@@ -1024,6 +1036,7 @@ static void dump_limiter(const char *name, struct limiter *limiter)
 
 /**
  * dump_data_vio_pool() - Dump a data_vio pool to the log.
+ * @pool: The data_vio pool.
  * @dump_vios: Whether to dump the details of each busy data_vio as well.
  */
 void dump_data_vio_pool(struct data_vio_pool *pool, bool dump_vios)
@@ -1114,6 +1127,7 @@ static void perform_cleanup_stage(struct data_vio *data_vio,
 /**
  * release_allocated_lock() - Release the PBN lock and/or the reference on the allocated block at
  *			      the end of processing a data_vio.
+ * @completion: The data_vio holding the lock.
  */
 static void release_allocated_lock(struct vdo_completion *completion)
 {
@@ -1194,6 +1208,7 @@ static void transfer_lock(struct data_vio *data_vio, struct lbn_lock *lock)
 /**
  * release_logical_lock() - Release the logical block lock and flush generation lock at the end of
  *			    processing a data_vio.
+ * @completion: The data_vio holding the lock.
  */
 static void release_logical_lock(struct vdo_completion *completion)
 {
@@ -1228,6 +1243,7 @@ static void clean_hash_lock(struct vdo_completion *completion)
 
 /**
  * finish_cleanup() - Make some assertions about a data_vio which has finished cleaning up.
+ * @data_vio: The data_vio.
  *
  * If it is part of a multi-block discard, starts on the next block, otherwise, returns it to the
  * pool.
@@ -1342,6 +1358,7 @@ void handle_data_vio_error(struct vdo_completion *completion)
 /**
  * get_data_vio_operation_name() - Get the name of the last asynchronous operation performed on a
  *				   data_vio.
+ * @data_vio: The data_vio.
  */
 const char *get_data_vio_operation_name(struct data_vio *data_vio)
 {
@@ -1355,7 +1372,7 @@ const char *get_data_vio_operation_name(struct data_vio *data_vio)
 
 /**
  * data_vio_allocate_data_block() - Allocate a data block.
- *
+ * @data_vio: The data_vio.
  * @write_lock_type: The type of write lock to obtain on the block.
  * @callback: The callback which will attempt an allocation in the current zone and continue if it
  *	      succeeds.
@@ -1379,6 +1396,7 @@ void data_vio_allocate_data_block(struct data_vio *data_vio,
 
 /**
  * release_data_vio_allocation_lock() - Release the PBN lock on a data_vio's allocated block.
+ * @data_vio: The data_vio.
  * @reset: If true, the allocation will be reset (i.e. any allocated pbn will be forgotten).
  *
  * If the reference to the locked block is still provisional, it will be released as well.
@@ -1399,6 +1417,7 @@ void release_data_vio_allocation_lock(struct data_vio *data_vio, bool reset)
 
 /**
  * uncompress_data_vio() - Uncompress the data a data_vio has just read.
+ * @data_vio: The data_vio.
  * @mapping_state: The mapping state indicating which fragment to decompress.
  * @buffer: The buffer to receive the uncompressed data.
  */
@@ -1519,6 +1538,7 @@ static void complete_zero_read(struct vdo_completion *completion)
 
 /**
  * read_block() - Read a block asynchronously.
+ * @completion: The data_vio doing the read.
  *
  * This is the callback registered in read_block_mapping().
  */
@@ -1675,6 +1695,7 @@ static void journal_remapping(struct vdo_completion *completion)
 
 /**
  * read_old_block_mapping() - Get the previous PBN/LBN mapping of an in-progress write.
+ * @completion: The data_vio doing the read.
  *
  * Gets the previous PBN mapped to this LBN from the block map, so as to make an appropriate
  * journal entry referencing the removal of this LBN->PBN mapping.
@@ -1704,6 +1725,7 @@ void update_metadata_for_data_vio_write(struct data_vio *data_vio, struct pbn_lo
 
 /**
  * pack_compressed_data() - Attempt to pack the compressed data_vio into a block.
+ * @completion: The data_vio.
  *
  * This is the callback registered in launch_compress_data_vio().
  */
@@ -1725,6 +1747,7 @@ static void pack_compressed_data(struct vdo_completion *completion)
 
 /**
  * compress_data_vio() - Do the actual work of compressing the data on a CPU queue.
+ * @completion: The data_vio.
  *
  * This callback is registered in launch_compress_data_vio().
  */
@@ -1754,6 +1777,7 @@ static void compress_data_vio(struct vdo_completion *completion)
 
 /**
  * launch_compress_data_vio() - Continue a write by attempting to compress the data.
+ * @data_vio: The data_vio.
  *
  * This is a re-entry point to vio_write used by hash locks.
  */
@@ -1796,7 +1820,8 @@ void launch_compress_data_vio(struct data_vio *data_vio)
 /**
  * hash_data_vio() - Hash the data in a data_vio and set the hash zone (which also flags the record
  *		     name as set).
-
+ * @completion: The data_vio.
+ *
  * This callback is registered in prepare_for_dedupe().
  */
 static void hash_data_vio(struct vdo_completion *completion)
@@ -1832,6 +1857,7 @@ static void prepare_for_dedupe(struct data_vio *data_vio)
 /**
  * write_bio_finished() - This is the bio_end_io function registered in write_block() to be called
  *			  when a data_vio's write to the underlying storage has completed.
+ * @bio: The bio to update.
  */
 static void write_bio_finished(struct bio *bio)
 {
@@ -1884,6 +1910,7 @@ void write_data_vio(struct data_vio *data_vio)
 
 /**
  * acknowledge_write_callback() - Acknowledge a write to the requestor.
+ * @completion: The data_vio.
  *
  * This callback is registered in allocate_block() and continue_write_with_block_map_slot().
  */
@@ -1909,6 +1936,7 @@ static void acknowledge_write_callback(struct vdo_completion *completion)
 
 /**
  * allocate_block() - Attempt to allocate a block in the current allocation zone.
+ * @completion: The data_vio.
  *
  * This callback is registered in continue_write_with_block_map_slot().
  */
@@ -1941,6 +1969,7 @@ static void allocate_block(struct vdo_completion *completion)
 
 /**
  * handle_allocation_error() - Handle an error attempting to allocate a block.
+ * @completion: The data_vio.
  *
  * This error handler is registered in continue_write_with_block_map_slot().
  */
@@ -1970,6 +1999,7 @@ static int assert_is_discard(struct data_vio *data_vio)
 
 /**
  * continue_data_vio_with_block_map_slot() - Read the data_vio's mapping from the block map.
+ * @completion: The data_vio to continue.
  *
  * This callback is registered in launch_read_data_vio().
  */
diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 4d983092a152..75a26f3f4461 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -917,6 +917,8 @@ static int __must_check acquire_lock(struct hash_zone *zone,
 
 /**
  * enter_forked_lock() - Bind the data_vio to a new hash lock.
+ * @waiter: The data_vio's waiter link.
+ * @context: The new hash lock.
  *
  * Implements waiter_callback_fn. Binds the data_vio that was waiting to a new hash lock and waits
  * on that lock.
@@ -971,7 +973,7 @@ static void fork_hash_lock(struct hash_lock *old_lock, struct data_vio *new_agen
  *                   path.
  * @lock: The hash lock.
  * @data_vio: The data_vio to deduplicate using the hash lock.
- * @has_claim: true if the data_vio already has claimed an increment from the duplicate lock.
+ * @has_claim: True if the data_vio already has claimed an increment from the duplicate lock.
  *
  * If no increments are available, this will roll over to a new hash lock and launch the data_vio
  * as the writing agent for that lock.
@@ -996,7 +998,7 @@ static void launch_dedupe(struct hash_lock *lock, struct data_vio *data_vio,
  *                    true copy of their data on disk.
  * @lock: The hash lock.
  * @agent: The data_vio acting as the agent for the lock.
- * @agent_is_done: true only if the agent has already written or deduplicated against its data.
+ * @agent_is_done: True only if the agent has already written or deduplicated against its data.
  *
  * If the agent itself needs to deduplicate, an increment for it must already have been claimed
  * from the duplicate lock, ensuring the hash lock will still have a data_vio holding it.
@@ -2146,8 +2148,8 @@ static void start_expiration_timer(struct dedupe_context *context)
 /**
  * report_dedupe_timeouts() - Record and eventually report that some dedupe requests reached their
  *                            expiration time without getting answers, so we timed them out.
- * @zones: the hash zones.
- * @timeouts: the number of newly timed out requests.
+ * @zones: The hash zones.
+ * @timeouts: The number of newly timed out requests.
  */
 static void report_dedupe_timeouts(struct hash_zones *zones, unsigned int timeouts)
 {
@@ -2509,6 +2511,8 @@ static void initiate_suspend_index(struct admin_state *state)
 
 /**
  * suspend_index() - Suspend the UDS index prior to draining hash zones.
+ * @context: Not used.
+ * @completion: The completion for the suspend operation.
  *
  * Implements vdo_action_preamble_fn
  */
@@ -2521,21 +2525,13 @@ static void suspend_index(void *context, struct vdo_completion *completion)
 			   initiate_suspend_index);
 }
 
-/**
- * initiate_drain() - Initiate a drain.
- *
- * Implements vdo_admin_initiator_fn.
- */
+/** Implements vdo_admin_initiator_fn. */
 static void initiate_drain(struct admin_state *state)
 {
 	check_for_drain_complete(container_of(state, struct hash_zone, state));
 }
 
-/**
- * drain_hash_zone() - Drain a hash zone.
- *
- * Implements vdo_zone_action_fn.
- */
+/** Implements vdo_zone_action_fn. */
 static void drain_hash_zone(void *context, zone_count_t zone_number,
 			    struct vdo_completion *parent)
 {
@@ -2572,6 +2568,8 @@ static void launch_dedupe_state_change(struct hash_zones *zones)
 
 /**
  * resume_index() - Resume the UDS index prior to resuming hash zones.
+ * @context: Not used.
+ * @parent: The completion for the resume operation.
  *
  * Implements vdo_action_preamble_fn
  */
@@ -2602,11 +2600,7 @@ static void resume_index(void *context, struct vdo_completion *parent)
 	vdo_finish_completion(parent);
 }
 
-/**
- * resume_hash_zone() - Resume a hash zone.
- *
- * Implements vdo_zone_action_fn.
- */
+/** Implements vdo_zone_action_fn. */
 static void resume_hash_zone(void *context, zone_count_t zone_number,
 			     struct vdo_completion *parent)
 {
@@ -2634,7 +2628,7 @@ void vdo_resume_hash_zones(struct hash_zones *zones, struct vdo_completion *pare
 /**
  * get_hash_zone_statistics() - Add the statistics for this hash zone to the tally for all zones.
  * @zone: The hash zone to query.
- * @tally: The tally
+ * @tally: The tally.
  */
 static void get_hash_zone_statistics(const struct hash_zone *zone,
 				     struct hash_lock_statistics *tally)
@@ -2680,8 +2674,8 @@ static void get_index_statistics(struct hash_zones *zones,
 
 /**
  * vdo_get_dedupe_statistics() - Tally the statistics from all the hash zones and the UDS index.
- * @zones: The hash zones to query
- * @stats: A structure to store the statistics
+ * @zones: The hash zones to query.
+ * @stats: A structure to store the statistics.
  *
  * Return: The sum of the hash lock statistics from all hash zones plus the statistics from the UDS
  *         index
@@ -2856,9 +2850,9 @@ void vdo_set_dedupe_index_min_timer_interval(unsigned int value)
 
 /**
  * acquire_context() - Acquire a dedupe context from a hash_zone if any are available.
- * @zone: the hash zone
+ * @zone: The hash zone.
  *
- * Return: A dedupe_context or NULL if none are available
+ * Return: A dedupe_context or NULL if none are available.
  */
 static struct dedupe_context * __must_check acquire_context(struct hash_zone *zone)
 {
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index 0e04c2021682..6af40d40f255 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -1144,6 +1144,7 @@ static bool vdo_uses_device(struct vdo *vdo, const void *context)
 /**
  * get_thread_id_for_phase() - Get the thread id for the current phase of the admin operation in
  *                             progress.
+ * @vdo: The vdo.
  */
 static thread_id_t __must_check get_thread_id_for_phase(struct vdo *vdo)
 {
@@ -1188,9 +1189,9 @@ static struct vdo_completion *prepare_admin_completion(struct vdo *vdo,
 /**
  * advance_phase() - Increment the phase of the current admin operation and prepare the admin
  *                   completion to run on the thread for the next phase.
- * @vdo: The on which an admin operation is being performed
+ * @vdo: The vdo on which an admin operation is being performed.
  *
- * Return: The current phase
+ * Return: The current phase.
  */
 static u32 advance_phase(struct vdo *vdo)
 {
diff --git a/drivers/md/dm-vdo/encodings.c b/drivers/md/dm-vdo/encodings.c
index b7cc0f41caca..dd59691be840 100644
--- a/drivers/md/dm-vdo/encodings.c
+++ b/drivers/md/dm-vdo/encodings.c
@@ -432,7 +432,10 @@ static void encode_block_map_state_2_0(u8 *buffer, size_t *offset,
 /**
  * vdo_compute_new_forest_pages() - Compute the number of pages which must be allocated at each
  *                                  level in order to grow the forest to a new number of entries.
+ * @root_count: The number of block map roots.
+ * @old_sizes: The sizes of the old tree segments.
  * @entries: The new number of entries the block map must address.
+ * @new_sizes: The sizes of the new tree segments.
  *
  * Return: The total number of non-leaf pages required.
  */
@@ -462,6 +465,9 @@ block_count_t vdo_compute_new_forest_pages(root_count_t root_count,
 
 /**
  * encode_recovery_journal_state_7_0() - Encode the state of a recovery journal.
+ * @buffer: A buffer to store the encoding.
+ * @offset: The offset in the buffer at which to encode.
+ * @state: The recovery journal state to encode.
  *
  * Return: VDO_SUCCESS or an error code.
  */
@@ -484,6 +490,7 @@ static void encode_recovery_journal_state_7_0(u8 *buffer, size_t *offset,
 /**
  * decode_recovery_journal_state_7_0() - Decode the state of a recovery journal saved in a buffer.
  * @buffer: The buffer containing the saved state.
+ * @offset: The offset to start decoding from.
  * @state: A pointer to a recovery journal state to hold the result of a successful decode.
  *
  * Return: VDO_SUCCESS or an error code.
@@ -544,6 +551,9 @@ const char *vdo_get_journal_operation_name(enum journal_operation operation)
 
 /**
  * encode_slab_depot_state_2_0() - Encode the state of a slab depot into a buffer.
+ * @buffer: A buffer to store the encoding.
+ * @offset: The offset in the buffer at which to encode.
+ * @state: The slab depot state to encode.
  */
 static void encode_slab_depot_state_2_0(u8 *buffer, size_t *offset,
 					struct slab_depot_state_2_0 state)
@@ -570,6 +580,9 @@ static void encode_slab_depot_state_2_0(u8 *buffer, size_t *offset,
 
 /**
  * decode_slab_depot_state_2_0() - Decode slab depot component state version 2.0 from a buffer.
+ * @buffer: The buffer being decoded.
+ * @offset: The offset to start decoding from.
+ * @state: A pointer to a slab depot state to hold the decoded result.
  *
  * Return: VDO_SUCCESS or an error code.
  */
@@ -1156,6 +1169,9 @@ static struct vdo_component unpack_vdo_component_41_0(struct packed_vdo_componen
 
 /**
  * decode_vdo_component() - Decode the component data for the vdo itself out of the super block.
+ * @buffer: The buffer being decoded.
+ * @offset: The offset to start decoding from.
+ * @component: The vdo component structure to decode into.
  *
  * Return: VDO_SUCCESS or an error.
  */
@@ -1290,7 +1306,7 @@ void vdo_destroy_component_states(struct vdo_component_states *states)
  *                       understand.
  * @buffer: The buffer being decoded.
  * @offset: The offset to start decoding from.
- * @geometry: The vdo geometry
+ * @geometry: The vdo geometry.
  * @states: An object to hold the successfully decoded state.
  *
  * Return: VDO_SUCCESS or an error.
@@ -1329,7 +1345,7 @@ static int __must_check decode_components(u8 *buffer, size_t *offset,
 /**
  * vdo_decode_component_states() - Decode the payload of a super block.
  * @buffer: The buffer containing the encoded super block contents.
- * @geometry: The vdo geometry
+ * @geometry: The vdo geometry.
  * @states: A pointer to hold the decoded states.
  *
  * Return: VDO_SUCCESS or an error.
@@ -1383,6 +1399,9 @@ int vdo_validate_component_states(struct vdo_component_states *states,
 
 /**
  * vdo_encode_component_states() - Encode the state of all vdo components in the super block.
+ * @buffer: A buffer to store the encoding.
+ * @offset: The offset into the buffer to start the encoding.
+ * @states: The component states to encode.
  */
 static void vdo_encode_component_states(u8 *buffer, size_t *offset,
 					const struct vdo_component_states *states)
@@ -1402,6 +1421,8 @@ static void vdo_encode_component_states(u8 *buffer, size_t *offset,
 
 /**
  * vdo_encode_super_block() - Encode a super block into its on-disk representation.
+ * @buffer: A buffer to store the encoding.
+ * @states: The component states to encode.
  */
 void vdo_encode_super_block(u8 *buffer, struct vdo_component_states *states)
 {
@@ -1426,6 +1447,7 @@ void vdo_encode_super_block(u8 *buffer, struct vdo_component_states *states)
 
 /**
  * vdo_decode_super_block() - Decode a super block from its on-disk representation.
+ * @buffer: The buffer to decode from.
  */
 int vdo_decode_super_block(u8 *buffer)
 {
diff --git a/drivers/md/dm-vdo/flush.c b/drivers/md/dm-vdo/flush.c
index dd4fdee2ca0c..82a259ef1601 100644
--- a/drivers/md/dm-vdo/flush.c
+++ b/drivers/md/dm-vdo/flush.c
@@ -522,11 +522,7 @@ static void vdo_complete_flush(struct vdo_flush *flush)
 	vdo_enqueue_completion(completion, BIO_Q_FLUSH_PRIORITY);
 }
 
-/**
- * initiate_drain() - Initiate a drain.
- *
- * Implements vdo_admin_initiator_fn.
- */
+/** Implements vdo_admin_initiator_fn. */
 static void initiate_drain(struct admin_state *state)
 {
 	check_for_drain_complete(container_of(state, struct flusher, state));
diff --git a/drivers/md/dm-vdo/funnel-workqueue.c b/drivers/md/dm-vdo/funnel-workqueue.c
index 0613c82bbe8e..8a79b33b8b09 100644
--- a/drivers/md/dm-vdo/funnel-workqueue.c
+++ b/drivers/md/dm-vdo/funnel-workqueue.c
@@ -372,6 +372,13 @@ static int make_simple_work_queue(const char *thread_name_prefix, const char *na
 /**
  * vdo_make_work_queue() - Create a work queue; if multiple threads are requested, completions will
  *                         be distributed to them in round-robin fashion.
+ * @thread_name_prefix: A prefix for the thread names to identify them as a vdo thread.
+ * @name: A base name to identify this queue.
+ * @owner: The vdo_thread structure to manage this queue.
+ * @type: The type of queue to create.
+ * @thread_count: The number of actual threads handling this queue.
+ * @thread_privates: An array of private contexts, one for each thread; may be NULL.
+ * @queue_ptr: A pointer to return the new work queue.
  *
  * Each queue is associated with a struct vdo_thread which has a single vdo thread id. Regardless
  * of the actual number of queues and threads allocated here, code outside of the queue
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 11d47770b54d..e26d75f8366d 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -118,6 +118,7 @@ static void send_bio_to_device(struct vio *vio, struct bio *bio)
 /**
  * vdo_submit_vio() - Submits a vio's bio to the underlying block device. May block if the device
  *		      is busy. This callback should be used by vios which did not attempt to merge.
+ * @completion: The vio to submit.
  */
 void vdo_submit_vio(struct vdo_completion *completion)
 {
@@ -133,7 +134,7 @@ void vdo_submit_vio(struct vdo_completion *completion)
  * The list will always contain at least one entry (the bio for the vio on which it is called), but
  * other bios may have been merged with it as well.
  *
- * Return: bio  The head of the bio list to submit.
+ * Return: The head of the bio list to submit.
  */
 static struct bio *get_bio_list(struct vio *vio)
 {
@@ -158,6 +159,7 @@ static struct bio *get_bio_list(struct vio *vio)
 /**
  * submit_data_vio() - Submit a data_vio's bio to the storage below along with
  *		       any bios that have been merged with it.
+ * @completion: The vio to submit.
  *
  * Context: This call may block and so should only be called from a bio thread.
  */
@@ -184,7 +186,7 @@ static void submit_data_vio(struct vdo_completion *completion)
  * There are two types of merging possible, forward and backward, which are distinguished by a flag
  * that uses kernel elevator terminology.
  *
- * Return: the vio to merge to, NULL if no merging is possible.
+ * Return: The vio to merge to, NULL if no merging is possible.
  */
 static struct vio *get_mergeable_locked(struct int_map *map, struct vio *vio,
 					bool back_merge)
@@ -262,7 +264,7 @@ static int merge_to_next_head(struct int_map *bio_map, struct vio *vio,
  *
  * Currently this is only used for data_vios, but is broken out for future use with metadata vios.
  *
- * Return: whether or not the vio was merged.
+ * Return: Whether or not the vio was merged.
  */
 static bool try_bio_map_merge(struct vio *vio)
 {
@@ -306,7 +308,7 @@ static bool try_bio_map_merge(struct vio *vio)
 
 /**
  * vdo_submit_data_vio() - Submit I/O for a data_vio.
- * @data_vio: the data_vio for which to issue I/O.
+ * @data_vio: The data_vio for which to issue I/O.
  *
  * If possible, this I/O will be merged other pending I/Os. Otherwise, the data_vio will be sent to
  * the appropriate bio zone directly.
@@ -321,13 +323,13 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
 
 /**
  * __submit_metadata_vio() - Submit I/O for a metadata vio.
- * @vio: the vio for which to issue I/O
- * @physical: the physical block number to read or write
- * @callback: the bio endio function which will be called after the I/O completes
- * @error_handler: the handler for submission or I/O errors (may be NULL)
- * @operation: the type of I/O to perform
- * @data: the buffer to read or write (may be NULL)
- * @size: the I/O amount in bytes
+ * @vio: The vio for which to issue I/O.
+ * @physical: The physical block number to read or write.
+ * @callback: The bio endio function which will be called after the I/O completes.
+ * @error_handler: The handler for submission or I/O errors; may be NULL.
+ * @operation: The type of I/O to perform.
+ * @data: The buffer to read or write; may be NULL.
+ * @size: The I/O amount in bytes.
  *
  * The vio is enqueued on a vdo bio queue so that bio submission (which may block) does not block
  * other vdo threads.
@@ -441,7 +443,7 @@ int vdo_make_io_submitter(unsigned int thread_count, unsigned int rotation_inter
 
 /**
  * vdo_cleanup_io_submitter() - Tear down the io_submitter fields as needed for a physical layer.
- * @io_submitter: The I/O submitter data to tear down (may be NULL).
+ * @io_submitter: The I/O submitter data to tear down; may be NULL.
  */
 void vdo_cleanup_io_submitter(struct io_submitter *io_submitter)
 {
diff --git a/drivers/md/dm-vdo/logical-zone.c b/drivers/md/dm-vdo/logical-zone.c
index 026f031ffc9e..0a27e60a9dfd 100644
--- a/drivers/md/dm-vdo/logical-zone.c
+++ b/drivers/md/dm-vdo/logical-zone.c
@@ -159,21 +159,13 @@ static void check_for_drain_complete(struct logical_zone *zone)
 	vdo_finish_draining(&zone->state);
 }
 
-/**
- * initiate_drain() - Initiate a drain.
- *
- * Implements vdo_admin_initiator_fn.
- */
+/** Implements vdo_admin_initiator_fn. */
 static void initiate_drain(struct admin_state *state)
 {
 	check_for_drain_complete(container_of(state, struct logical_zone, state));
 }
 
-/**
- * drain_logical_zone() - Drain a logical zone.
- *
- * Implements vdo_zone_action_fn.
- */
+/** Implements vdo_zone_action_fn. */
 static void drain_logical_zone(void *context, zone_count_t zone_number,
 			       struct vdo_completion *parent)
 {
@@ -192,11 +184,7 @@ void vdo_drain_logical_zones(struct logical_zones *zones,
 			       parent);
 }
 
-/**
- * resume_logical_zone() - Resume a logical zone.
- *
- * Implements vdo_zone_action_fn.
- */
+/** Implements vdo_zone_action_fn. */
 static void resume_logical_zone(void *context, zone_count_t zone_number,
 				struct vdo_completion *parent)
 {
@@ -356,7 +344,7 @@ struct physical_zone *vdo_get_next_allocation_zone(struct logical_zone *zone)
 
 /**
  * vdo_dump_logical_zone() - Dump information about a logical zone to the log for debugging.
- * @zone: The zone to dump
+ * @zone: The zone to dump.
  *
  * Context: the information is dumped in a thread-unsafe fashion.
  *
diff --git a/drivers/md/dm-vdo/packer.c b/drivers/md/dm-vdo/packer.c
index f70f5edabc10..666be6d557e1 100644
--- a/drivers/md/dm-vdo/packer.c
+++ b/drivers/md/dm-vdo/packer.c
@@ -35,10 +35,10 @@ static const struct version_number COMPRESSED_BLOCK_1_0 = {
 /**
  * vdo_get_compressed_block_fragment() - Get a reference to a compressed fragment from a compressed
  *                                       block.
- * @mapping_state [in] The mapping state for the look up.
- * @compressed_block [in] The compressed block that was read from disk.
- * @fragment_offset [out] The offset of the fragment within a compressed block.
- * @fragment_size [out] The size of the fragment.
+ * @mapping_state: The mapping state describing the fragment.
+ * @block: The compressed block that was read from disk.
+ * @fragment_offset: The offset of the fragment within the compressed block.
+ * @fragment_size: The size of the fragment.
  *
  * Return: If a valid compressed fragment is found, VDO_SUCCESS; otherwise, VDO_INVALID_FRAGMENT if
  *         the fragment is invalid.
@@ -382,6 +382,7 @@ static void initialize_compressed_block(struct compressed_block *block, u16 size
  * @compression: The agent's compression_state to pack in to.
  * @data_vio: The data_vio to pack.
  * @offset: The offset into the compressed block at which to pack the fragment.
+ * @slot: The slot number in the compressed block.
  * @block: The compressed block which will be written out when batch is fully packed.
  *
  * Return: The new amount of space used.
@@ -705,11 +706,7 @@ void vdo_increment_packer_flush_generation(struct packer *packer)
 	vdo_flush_packer(packer);
 }
 
-/**
- * initiate_drain() - Initiate a drain.
- *
- * Implements vdo_admin_initiator_fn.
- */
+/** Implements vdo_admin_initiator_fn. */
 static void initiate_drain(struct admin_state *state)
 {
 	struct packer *packer = container_of(state, struct packer, state);
diff --git a/drivers/md/dm-vdo/physical-zone.c b/drivers/md/dm-vdo/physical-zone.c
index a43b5c45fab7..686eb7d714e6 100644
--- a/drivers/md/dm-vdo/physical-zone.c
+++ b/drivers/md/dm-vdo/physical-zone.c
@@ -60,7 +60,7 @@ static inline bool has_lock_type(const struct pbn_lock *lock, enum pbn_lock_type
  * vdo_is_pbn_read_lock() - Check whether a pbn_lock is a read lock.
  * @lock: The lock to check.
  *
- * Return: true if the lock is a read lock.
+ * Return: True if the lock is a read lock.
  */
 bool vdo_is_pbn_read_lock(const struct pbn_lock *lock)
 {
@@ -75,6 +75,7 @@ static inline void set_pbn_lock_type(struct pbn_lock *lock, enum pbn_lock_type t
 /**
  * vdo_downgrade_pbn_write_lock() - Downgrade a PBN write lock to a PBN read lock.
  * @lock: The PBN write lock to downgrade.
+ * @compressed_write: True if the written block was a compressed block.
  *
  * The lock holder count is cleared and the caller is responsible for setting the new count.
  */
@@ -582,7 +583,7 @@ static bool continue_allocating(struct data_vio *data_vio)
  *				  that fails try the next if possible.
  * @data_vio: The data_vio needing an allocation.
  *
- * Return: true if a block was allocated, if not the data_vio will have been dispatched so the
+ * Return: True if a block was allocated, if not the data_vio will have been dispatched so the
  *         caller must not touch it.
  */
 bool vdo_allocate_block_in_zone(struct data_vio *data_vio)
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index de58184f538f..9cc0f0ff1664 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -109,7 +109,7 @@ static atomic_t *get_decrement_counter(struct recovery_journal *journal,
  * @journal: The recovery journal.
  * @lock_number: The lock to check.
  *
- * Return: true if the journal zone is locked.
+ * Return: True if the journal zone is locked.
  */
 static bool is_journal_zone_locked(struct recovery_journal *journal,
 				   block_count_t lock_number)
@@ -217,7 +217,7 @@ static struct recovery_journal_block * __must_check pop_free_list(struct recover
  * Indicates it has any uncommitted entries, which includes both entries not written and entries
  * written but not yet acknowledged.
  *
- * Return: true if the block has any uncommitted entries.
+ * Return: True if the block has any uncommitted entries.
  */
 static inline bool __must_check is_block_dirty(const struct recovery_journal_block *block)
 {
@@ -228,7 +228,7 @@ static inline bool __must_check is_block_dirty(const struct recovery_journal_blo
  * is_block_empty() - Check whether a journal block is empty.
  * @block: The block to check.
  *
- * Return: true if the block has no entries.
+ * Return: True if the block has no entries.
  */
 static inline bool __must_check is_block_empty(const struct recovery_journal_block *block)
 {
@@ -239,7 +239,7 @@ static inline bool __must_check is_block_empty(const struct recovery_journal_blo
  * is_block_full() - Check whether a journal block is full.
  * @block: The block to check.
  *
- * Return: true if the block is full.
+ * Return: True if the block is full.
  */
 static inline bool __must_check is_block_full(const struct recovery_journal_block *block)
 {
@@ -260,6 +260,8 @@ static void assert_on_journal_thread(struct recovery_journal *journal,
 
 /**
  * continue_waiter() - Release a data_vio from the journal.
+ * @waiter: The data_vio waiting on journal activity.
+ * @context: The result of the journal operation.
  *
  * Invoked whenever a data_vio is to be released from the journal, either because its entry was
  * committed to disk, or because there was an error. Implements waiter_callback_fn.
@@ -273,7 +275,7 @@ static void continue_waiter(struct vdo_waiter *waiter, void *context)
  * has_block_waiters() - Check whether the journal has any waiters on any blocks.
  * @journal: The journal in question.
  *
- * Return: true if any block has a waiter.
+ * Return: True if any block has a waiter.
  */
 static inline bool has_block_waiters(struct recovery_journal *journal)
 {
@@ -296,7 +298,7 @@ static void notify_commit_waiters(struct recovery_journal *journal);
  * suspend_lock_counter() - Prevent the lock counter from notifying.
  * @counter: The counter.
  *
- * Return: true if the lock counter was not notifying and hence the suspend was efficacious.
+ * Return: True if the lock counter was not notifying and hence the suspend was efficacious.
  */
 static bool suspend_lock_counter(struct lock_counter *counter)
 {
@@ -416,7 +418,7 @@ sequence_number_t vdo_get_recovery_journal_current_sequence_number(struct recove
  *
  * The head is the lowest sequence number of the block map head and the slab journal head.
  *
- * Return: the head of the journal.
+ * Return: The head of the journal.
  */
 static inline sequence_number_t get_recovery_journal_head(const struct recovery_journal *journal)
 {
@@ -535,7 +537,7 @@ static void initialize_journal_state(struct recovery_journal *journal)
  * vdo_get_recovery_journal_length() - Get the number of usable recovery journal blocks.
  * @journal_size: The size of the recovery journal in blocks.
  *
- * Return: the number of recovery journal blocks usable for entries.
+ * Return: The number of recovery journal blocks usable for entries.
  */
 block_count_t vdo_get_recovery_journal_length(block_count_t journal_size)
 {
@@ -1078,6 +1080,8 @@ static void update_usages(struct recovery_journal *journal, struct data_vio *dat
 
 /**
  * assign_entry() - Assign an entry waiter to the active block.
+ * @waiter: The data_vio.
+ * @context: The recovery journal block.
  *
  * Implements waiter_callback_fn.
  */
@@ -1165,6 +1169,8 @@ static void recycle_journal_block(struct recovery_journal_block *block)
 /**
  * continue_committed_waiter() - invoked whenever a VIO is to be released from the journal because
  *                               its entry was committed to disk.
+ * @waiter: The data_vio waiting on a journal write.
+ * @context: A pointer to the recovery journal.
  *
  * Implements waiter_callback_fn.
  */
@@ -1362,6 +1368,8 @@ static void add_queued_recovery_entries(struct recovery_journal_block *block)
 
 /**
  * write_block() - Issue a block for writing.
+ * @waiter: The recovery journal block to write.
+ * @context: Not used.
  *
  * Implements waiter_callback_fn.
  */
@@ -1611,11 +1619,7 @@ void vdo_release_journal_entry_lock(struct recovery_journal *journal,
 	smp_mb__after_atomic();
 }
 
-/**
- * initiate_drain() - Initiate a drain.
- *
- * Implements vdo_admin_initiator_fn.
- */
+/** Implements vdo_admin_initiator_fn. */
 static void initiate_drain(struct admin_state *state)
 {
 	check_for_drain_complete(container_of(state, struct recovery_journal, state));
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index f3d80ff7bef5..034ecaa51f48 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -40,7 +40,7 @@ static const bool NORMAL_OPERATION = true;
 
 /**
  * get_lock() - Get the lock object for a slab journal block by sequence number.
- * @journal: vdo_slab journal to retrieve from.
+ * @journal: The vdo_slab journal to retrieve from.
  * @sequence_number: Sequence number of the block.
  *
  * Return: The lock object for the given sequence number.
@@ -110,7 +110,7 @@ static void initialize_journal_state(struct slab_journal *journal)
  * block_is_full() - Check whether a journal block is full.
  * @journal: The slab journal for the block.
  *
- * Return: true if the tail block is full.
+ * Return: True if the tail block is full.
  */
 static bool __must_check block_is_full(struct slab_journal *journal)
 {
@@ -127,10 +127,11 @@ static void release_journal_locks(struct vdo_waiter *waiter, void *context);
 
 /**
  * is_slab_journal_blank() - Check whether a slab's journal is blank.
+ * @slab: The slab to check.
  *
  * A slab journal is blank if it has never had any entries recorded in it.
  *
- * Return: true if the slab's journal has never been modified.
+ * Return: True if the slab's journal has never been modified.
  */
 static bool is_slab_journal_blank(const struct vdo_slab *slab)
 {
@@ -227,6 +228,7 @@ static u8 __must_check compute_fullness_hint(struct slab_depot *depot,
 
 /**
  * check_summary_drain_complete() - Check whether an allocators summary has finished draining.
+ * @allocator: The allocator to check.
  */
 static void check_summary_drain_complete(struct block_allocator *allocator)
 {
@@ -349,7 +351,7 @@ static void launch_write(struct slab_summary_block *block)
 
 /**
  * update_slab_summary_entry() - Update the entry for a slab.
- * @slab: The slab whose entry is to be updated
+ * @slab: The slab whose entry is to be updated.
  * @waiter: The waiter that is updating the summary.
  * @tail_block_offset: The offset of the slab journal's tail block.
  * @load_ref_counts: Whether the reference counts must be loaded from disk on the vdo load.
@@ -654,6 +656,7 @@ static void update_tail_block_location(struct slab_journal *journal)
 
 /**
  * reopen_slab_journal() - Reopen a slab's journal by emptying it and then adding pending entries.
+ * @slab: The slab to reopen.
  */
 static void reopen_slab_journal(struct vdo_slab *slab)
 {
@@ -839,8 +842,6 @@ static void commit_tail(struct slab_journal *journal)
  * @sbn: The slab block number of the entry to encode.
  * @operation: The type of the entry.
  * @increment: True if this is an increment.
- *
- * Exposed for unit tests.
  */
 static void encode_slab_journal_entry(struct slab_journal_block_header *tail_header,
 				      slab_journal_payload *payload,
@@ -951,7 +952,7 @@ static inline block_count_t journal_length(const struct slab_journal *journal)
  * @parent: The completion to notify when there is space to add the entry if the entry could not be
  *          added immediately.
  *
- * Return: true if the entry was added immediately.
+ * Return: True if the entry was added immediately.
  */
 bool vdo_attempt_replay_into_slab(struct vdo_slab *slab, physical_block_number_t pbn,
 				  enum journal_operation operation, bool increment,
@@ -1003,7 +1004,7 @@ bool vdo_attempt_replay_into_slab(struct vdo_slab *slab, physical_block_number_t
  * requires_reaping() - Check whether the journal must be reaped before adding new entries.
  * @journal: The journal to check.
  *
- * Return: true if the journal must be reaped.
+ * Return: True if the journal must be reaped.
  */
 static bool requires_reaping(const struct slab_journal *journal)
 {
@@ -1275,6 +1276,8 @@ static void dirty_block(struct reference_block *block)
 
 /**
  * get_reference_block() - Get the reference block that covers the given block index.
+ * @slab: The slab containing the references.
+ * @index: The index of the physical block.
  */
 static struct reference_block * __must_check get_reference_block(struct vdo_slab *slab,
 								 slab_block_number index)
@@ -1379,7 +1382,8 @@ static void prioritize_slab(struct vdo_slab *slab)
 
 /**
  * adjust_free_block_count() - Adjust the free block count and (if needed) reprioritize the slab.
- * @incremented: true if the free block count went up.
+ * @slab: The slab.
+ * @incremented: True if the free block count went up.
  */
 static void adjust_free_block_count(struct vdo_slab *slab, bool incremented)
 {
@@ -1885,6 +1889,7 @@ static void add_entries(struct slab_journal *journal)
 /**
  * reset_search_cursor() - Reset the free block search back to the first reference counter in the
  *                         first reference block of a slab.
+ * @slab: The slab.
  */
 static void reset_search_cursor(struct vdo_slab *slab)
 {
@@ -1892,17 +1897,17 @@ static void reset_search_cursor(struct vdo_slab *slab)
 
 	cursor->block = cursor->first_block;
 	cursor->index = 0;
-	/* Unit tests have slabs with only one reference block (and it's a runt). */
 	cursor->end_index = min_t(u32, COUNTS_PER_BLOCK, slab->block_count);
 }
 
 /**
  * advance_search_cursor() - Advance the search cursor to the start of the next reference block in
- *                           a slab,
+ *                           a slab.
+ * @slab: The slab.
  *
  * Wraps around to the first reference block if the current block is the last reference block.
  *
- * Return: true unless the cursor was at the last reference block.
+ * Return: True unless the cursor was at the last reference block.
  */
 static bool advance_search_cursor(struct vdo_slab *slab)
 {
@@ -1933,6 +1938,9 @@ static bool advance_search_cursor(struct vdo_slab *slab)
 
 /**
  * vdo_adjust_reference_count_for_rebuild() - Adjust the reference count of a block during rebuild.
+ * @depot: The slab depot.
+ * @pbn: The physical block number to adjust.
+ * @operation: The type opf operation.
  *
  * Return: VDO_SUCCESS or an error.
  */
@@ -2038,9 +2046,7 @@ static inline slab_block_number find_zero_byte_in_word(const u8 *word_ptr,
  * @slab: The slab counters to scan.
  * @index_ptr: A pointer to hold the array index of the free block.
  *
- * Exposed for unit testing.
- *
- * Return: true if a free block was found in the specified range.
+ * Return: True if a free block was found in the specified range.
  */
 static bool find_free_block(const struct vdo_slab *slab, slab_block_number *index_ptr)
 {
@@ -2097,7 +2103,7 @@ static bool find_free_block(const struct vdo_slab *slab, slab_block_number *inde
  * @slab: The slab to search.
  * @free_index_ptr: A pointer to receive the array index of the zero reference count.
  *
- * Return: true if an unreferenced counter was found.
+ * Return: True if an unreferenced counter was found.
  */
 static bool search_current_reference_block(const struct vdo_slab *slab,
 					   slab_block_number *free_index_ptr)
@@ -2116,7 +2122,7 @@ static bool search_current_reference_block(const struct vdo_slab *slab,
  * counter index saved in the search cursor and searching up to the end of the last reference
  * block. The search does not wrap.
  *
- * Return: true if an unreferenced counter was found.
+ * Return: True if an unreferenced counter was found.
  */
 static bool search_reference_blocks(struct vdo_slab *slab,
 				    slab_block_number *free_index_ptr)
@@ -2136,6 +2142,8 @@ static bool search_reference_blocks(struct vdo_slab *slab,
 
 /**
  * make_provisional_reference() - Do the bookkeeping for making a provisional reference.
+ * @slab: The slab.
+ * @block_number: The index for the physical block to reference.
  */
 static void make_provisional_reference(struct vdo_slab *slab,
 				       slab_block_number block_number)
@@ -2155,6 +2163,7 @@ static void make_provisional_reference(struct vdo_slab *slab,
 
 /**
  * dirty_all_reference_blocks() - Mark all reference count blocks in a slab as dirty.
+ * @slab: The slab.
  */
 static void dirty_all_reference_blocks(struct vdo_slab *slab)
 {
@@ -2173,10 +2182,10 @@ static inline bool journal_points_equal(struct journal_point first,
 
 /**
  * match_bytes() - Check an 8-byte word for bytes matching the value specified
- * @input: A word to examine the bytes of
- * @match: The byte value sought
+ * @input: A word to examine the bytes of.
+ * @match: The byte value sought.
  *
- * Return: 1 in each byte when the corresponding input byte matched, 0 otherwise
+ * Return: 1 in each byte when the corresponding input byte matched, 0 otherwise.
  */
 static inline u64 match_bytes(u64 input, u8 match)
 {
@@ -2191,12 +2200,12 @@ static inline u64 match_bytes(u64 input, u8 match)
 
 /**
  * count_valid_references() - Process a newly loaded refcount array
- * @counters: the array of counters from a metadata block
+ * @counters: The array of counters from a metadata block.
  *
- * Scan a 8-byte-aligned array of counters, fixing up any "provisional" values that weren't
- * cleaned up at shutdown, changing them internally to "empty".
+ * Scan an 8-byte-aligned array of counters, fixing up any provisional values that
+ * weren't cleaned up at shutdown, changing them internally to zero.
  *
- * Return: the number of blocks that are referenced (counters not "empty")
+ * Return: The number of blocks with a non-zero reference count.
  */
 static unsigned int count_valid_references(vdo_refcount_t *counters)
 {
@@ -2351,6 +2360,7 @@ static void load_reference_block_group(struct vdo_waiter *waiter, void *context)
 /**
  * load_reference_blocks() - Load a slab's reference blocks from the underlying storage into a
  *                           pre-allocated reference counter.
+ * @slab: The slab.
  */
 static void load_reference_blocks(struct vdo_slab *slab)
 {
@@ -2375,6 +2385,7 @@ static void load_reference_blocks(struct vdo_slab *slab)
 
 /**
  * drain_slab() - Drain all reference count I/O.
+ * @slab: The slab.
  *
  * Depending upon the type of drain being performed (as recorded in the ref_count's vdo_slab), the
  * reference blocks may be loaded from disk or dirty reference blocks may be written out.
@@ -2564,6 +2575,7 @@ static void read_slab_journal_tail(struct vdo_waiter *waiter, void *context)
 
 /**
  * load_slab_journal() - Load a slab's journal by reading the journal's tail.
+ * @slab: The slab.
  */
 static void load_slab_journal(struct vdo_slab *slab)
 {
@@ -2663,11 +2675,7 @@ static void queue_slab(struct vdo_slab *slab)
 	prioritize_slab(slab);
 }
 
-/**
- * initiate_slab_action() - Initiate a slab action.
- *
- * Implements vdo_admin_initiator_fn.
- */
+/** Implements vdo_admin_initiator_fn. */
 static void initiate_slab_action(struct admin_state *state)
 {
 	struct vdo_slab *slab = container_of(state, struct vdo_slab, state);
@@ -2720,7 +2728,7 @@ static struct vdo_slab *get_next_slab(struct slab_scrubber *scrubber)
  * has_slabs_to_scrub() - Check whether a scrubber has slabs to scrub.
  * @scrubber: The scrubber to check.
  *
- * Return: true if the scrubber has slabs to scrub.
+ * Return: True if the scrubber has slabs to scrub.
  */
 static inline bool __must_check has_slabs_to_scrub(struct slab_scrubber *scrubber)
 {
@@ -2741,6 +2749,7 @@ static void uninitialize_scrubber_vio(struct slab_scrubber *scrubber)
  * finish_scrubbing() - Stop scrubbing, either because there are no more slabs to scrub or because
  *                      there's been an error.
  * @scrubber: The scrubber.
+ * @result: The result of the scrubbing operation.
  */
 static void finish_scrubbing(struct slab_scrubber *scrubber, int result)
 {
@@ -3132,11 +3141,13 @@ static struct vdo_slab *next_slab(struct slab_iterator *iterator)
 
 /**
  * abort_waiter() - Abort vios waiting to make journal entries when read-only.
+ * @waiter: A waiting data_vio.
+ * @context: Not used.
  *
  * This callback is invoked on all vios waiting to make slab journal entries after the VDO has gone
  * into read-only mode. Implements waiter_callback_fn.
  */
-static void abort_waiter(struct vdo_waiter *waiter, void *context __always_unused)
+static void abort_waiter(struct vdo_waiter *waiter, void __always_unused *context)
 {
 	struct reference_updater *updater =
 		container_of(waiter, struct reference_updater, waiter);
@@ -3536,7 +3547,7 @@ static void initiate_load(struct admin_state *state)
 /**
  * vdo_notify_slab_journals_are_recovered() - Inform a block allocator that its slab journals have
  *                                            been recovered from the recovery journal.
- * @completion The allocator completion
+ * @completion: The allocator completion.
  */
 void vdo_notify_slab_journals_are_recovered(struct vdo_completion *completion)
 {
@@ -3775,7 +3786,7 @@ static int initialize_slab_journal(struct vdo_slab *slab)
  *               in the slab.
  * @allocator: The block allocator to which the slab belongs.
  * @slab_number: The slab number of the slab.
- * @is_new: true if this slab is being allocated as part of a resize.
+ * @is_new: True if this slab is being allocated as part of a resize.
  * @slab_ptr: A pointer to receive the new slab.
  *
  * Return: VDO_SUCCESS or an error code.
@@ -3894,11 +3905,7 @@ void vdo_abandon_new_slabs(struct slab_depot *depot)
 	vdo_free(vdo_forget(depot->new_slabs));
 }
 
-/**
- * get_allocator_thread_id() - Get the ID of the thread on which a given allocator operates.
- *
- * Implements vdo_zone_thread_getter_fn.
- */
+/** Implements vdo_zone_thread_getter_fn. */
 static thread_id_t get_allocator_thread_id(void *context, zone_count_t zone_number)
 {
 	return ((struct slab_depot *) context)->allocators[zone_number].thread_id;
@@ -3911,7 +3918,7 @@ static thread_id_t get_allocator_thread_id(void *context, zone_count_t zone_numb
  * @recovery_lock: The sequence number of the recovery journal block whose locks should be
  *                 released.
  *
- * Return: true if the journal does hold a lock on the specified block (which it will release).
+ * Return: True if the journal released a lock on the specified block.
  */
 static bool __must_check release_recovery_journal_lock(struct slab_journal *journal,
 						       sequence_number_t recovery_lock)
@@ -3955,6 +3962,8 @@ static void release_tail_block_locks(void *context, zone_count_t zone_number,
 
 /**
  * prepare_for_tail_block_commit() - Prepare to commit oldest tail blocks.
+ * @context: The slab depot.
+ * @parent: The parent operation.
  *
  * Implements vdo_action_preamble_fn.
  */
@@ -3968,6 +3977,7 @@ static void prepare_for_tail_block_commit(void *context, struct vdo_completion *
 
 /**
  * schedule_tail_block_commit() - Schedule a tail block commit if necessary.
+ * @context: The slab depot.
  *
  * This method should not be called directly. Rather, call vdo_schedule_default_action() on the
  * depot's action manager.
@@ -4361,6 +4371,7 @@ struct slab_depot_state_2_0 vdo_record_slab_depot(const struct slab_depot *depot
 
 /**
  * vdo_allocate_reference_counters() - Allocate the reference counters for all slabs in the depot.
+ * @depot: The slab depot.
  *
  * Context: This method may be called only before entering normal operation from the load thread.
  *
@@ -4615,7 +4626,9 @@ static void load_summary_endio(struct bio *bio)
 }
 
 /**
- * load_slab_summary() - The preamble of a load operation.
+ * load_slab_summary() - Load the slab summary before the slab data.
+ * @context: The slab depot.
+ * @parent: The load operation.
  *
  * Implements vdo_action_preamble_fn.
  */
@@ -4731,7 +4744,7 @@ void vdo_update_slab_depot_size(struct slab_depot *depot)
  * vdo_prepare_to_grow_slab_depot() - Allocate new memory needed for a resize of a slab depot to
  *                                    the given size.
  * @depot: The depot to prepare to resize.
- * @partition: The new depot partition
+ * @partition: The new depot partition.
  *
  * Return: VDO_SUCCESS or an error.
  */
@@ -4781,6 +4794,7 @@ int vdo_prepare_to_grow_slab_depot(struct slab_depot *depot,
 /**
  * finish_registration() - Finish registering new slabs now that all of the allocators have
  *                         received their new slabs.
+ * @context: The slab depot.
  *
  * Implements vdo_action_conclusion_fn.
  */
diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 80b608674022..09fd0628d18c 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -181,6 +181,8 @@ static void assign_thread_ids(struct thread_config *config,
 
 /**
  * initialize_thread_config() - Initialize the thread mapping
+ * @counts: The number and types of threads to create.
+ * @config: The thread_config to initialize.
  *
  * If the logical, physical, and hash zone counts are all 0, a single thread will be shared by all
  * three plus the packer and recovery journal. Otherwise, there must be at least one of each type,
@@ -884,6 +886,7 @@ const struct admin_state_code *vdo_get_admin_state(const struct vdo *vdo)
 
 /**
  * record_vdo() - Record the state of the VDO for encoding in the super block.
+ * @vdo: The vdo.
  */
 static void record_vdo(struct vdo *vdo)
 {
@@ -1277,7 +1280,7 @@ void vdo_enter_read_only_mode(struct vdo *vdo, int error_code)
  * vdo_is_read_only() - Check whether the VDO is read-only.
  * @vdo: The vdo.
  *
- * Return: true if the vdo is read-only.
+ * Return: True if the vdo is read-only.
  *
  * This method may be called from any thread, as opposed to examining the VDO's state field which
  * is only safe to check from the admin thread.
@@ -1291,7 +1294,7 @@ bool vdo_is_read_only(struct vdo *vdo)
  * vdo_in_read_only_mode() - Check whether a vdo is in read-only mode.
  * @vdo: The vdo to query.
  *
- * Return: true if the vdo is in read-only mode.
+ * Return: True if the vdo is in read-only mode.
  */
 bool vdo_in_read_only_mode(const struct vdo *vdo)
 {
@@ -1302,7 +1305,7 @@ bool vdo_in_read_only_mode(const struct vdo *vdo)
  * vdo_in_recovery_mode() - Check whether the vdo is in recovery mode.
  * @vdo: The vdo to query.
  *
- * Return: true if the vdo is in recovery mode.
+ * Return: True if the vdo is in recovery mode.
  */
 bool vdo_in_recovery_mode(const struct vdo *vdo)
 {
diff --git a/drivers/md/dm-vdo/vdo.h b/drivers/md/dm-vdo/vdo.h
index 483ae873e002..1aaba73997b7 100644
--- a/drivers/md/dm-vdo/vdo.h
+++ b/drivers/md/dm-vdo/vdo.h
@@ -279,8 +279,10 @@ static inline bool vdo_uses_bio_ack_queue(struct vdo *vdo)
 
 /**
  * typedef vdo_filter_fn - Method type for vdo matching methods.
+ * @vdo: The vdo to match.
+ * @context: A parameter for the filter to use.
  *
- * A filter function returns false if the vdo doesn't match.
+ * Return: True if the vdo matches the filter criteria, false if it doesn't.
  */
 typedef bool (*vdo_filter_fn)(struct vdo *vdo, const void *context);
 
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index e7f4153e55e3..9b5a9ec08b2b 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -398,8 +398,9 @@ void free_vio_pool(struct vio_pool *pool)
 
 /**
  * is_vio_pool_busy() - Check whether an vio pool has outstanding entries.
+ * @pool: The vio pool.
  *
- * Return: true if the pool is busy.
+ * Return: True if the pool is busy.
  */
 bool is_vio_pool_busy(struct vio_pool *pool)
 {
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index 4bfcb21901f1..7a8a6819aec4 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -156,8 +156,7 @@ static inline enum vdo_completion_priority get_metadata_priority(struct vio *vio
 /**
  * continue_vio() - Enqueue a vio to run its next callback.
  * @vio: The vio to continue.
- *
- * Return: The result of the current operation.
+ * @result: The result of the current operation.
  */
 static inline void continue_vio(struct vio *vio, int result)
 {
@@ -172,6 +171,9 @@ void vdo_count_completed_bios(struct bio *bio);
 
 /**
  * continue_vio_after_io() - Continue a vio now that its I/O has returned.
+ * @vio: The vio to continue.
+ * @callback: The next operation for this vio.
+ * @thread: Which thread to run the next operation on.
  */
 static inline void continue_vio_after_io(struct vio *vio, vdo_action_fn callback,
 					 thread_id_t thread)
-- 
2.48.1

