Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FDAEEAA65
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 19:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694719103;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lPWEKQOku7jXS4uxiHfhwwG7HCKI2xeZNtGF3xNpXc4=;
	b=OvqeXkgLvQbGMQGoPg9jIHEXkjCwivLm4MpP64+f+9YEBUIqePjnmf3pVizUWJIrMEnBqt
	Lzg6Gu1YsuRGJBPJ0XyJENGfyOPeLST85DNoM1vw1nSqMJft7hz5Khs6lKdTHDzws1tAn9
	0gPGKciS0vNr3k3JtZBHtiLAIZrZxx8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-EqKF_DRJPG2V72I3bHUmoQ-1; Thu, 14 Sep 2023 15:18:19 -0400
X-MC-Unique: EqKF_DRJPG2V72I3bHUmoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABF8A81D88C;
	Thu, 14 Sep 2023 19:18:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 979C640C2070;
	Thu, 14 Sep 2023 19:18:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 99EB91946A52;
	Thu, 14 Sep 2023 19:17:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9676019465BA
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 19:17:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 857EE40C6EC0; Thu, 14 Sep 2023 19:17:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DD5540C6EBF
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57273829DFA
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 19:17:16 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
 [209.85.222.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-378NMh_yOA2VW7_6bbgvQw-1; Thu, 14 Sep 2023 15:17:14 -0400
X-MC-Unique: 378NMh_yOA2VW7_6bbgvQw-1
Received: by mail-qk1-f170.google.com with SMTP id
 af79cd13be357-76dbe786527so85626885a.2
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 12:17:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694719032; x=1695323832;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=NOanK+6QkdNsqUL6a6+y1/apG/Q+FdyNgqLyFH3YYeE=;
 b=jsIWHVK1HXpnW6eYQzHu251W0ycT9C3fj2icZ1N+39j9qXWJTDO5oXv/J1QdhGWIim
 NN9sdj6YPbJxTQV60Y+EhcJ+7Oz9ofk56wJZbuJWo6pspTMnt7jTdO6IjqnUi7088AIu
 xUZQTM3P+TAlFfWBWeWjJ0/m7NZgK9o35H7DztOVWRsR9qgFjL10A48yBmwHpRoWGjbU
 3ruzT6wzb4+AExF3XlQ42pO/gm2rLvxX4cd22UDvjbZcLFnqmMVM1+aGemEbzB9L8ahW
 tmpI1VXpBjdOtkplSD9gV7N9muGAASrxAiAAydh+57clagWi1MyTPUb3jTL968MlxKAt
 ljcA==
X-Gm-Message-State: AOJu0YzpdzIadV7ZEquObI2v1V18PvfUdyCq9XvBwW3S0lp4sa0qwN52
 jg2atk9FBzSPkl1LJWJdjz+6CgrYuVhcdI51RVsCAeMsvpHIeua3yMmcebYDu/mkGuYuFz9XfV1
 om2sMFitzoHKN1Rk0P9kKl1rMv3B2TrbS4yjXf9Eh9xTVKi4keoDQpaLU08UTEug26gnyUpRO
X-Google-Smtp-Source: AGHT+IG7a6Kv02Jvdl2UyoyO9F687wf4ZOUapu3eoNdRXPQVMjK/8S6KXVJxp52yaJCjUsQAzo6Y0A==
X-Received: by 2002:a05:620a:f05:b0:76d:a9a0:5a20 with SMTP id
 v5-20020a05620a0f0500b0076da9a05a20mr6925364qkl.28.1694719031332; 
 Thu, 14 Sep 2023 12:17:11 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net.
 [68.160.141.91]) by smtp.gmail.com with ESMTPSA id
 x6-20020a05620a14a600b0076eed604793sm666890qkj.130.2023.09.14.12.17.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Sep 2023 12:17:10 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Thu, 14 Sep 2023 15:16:13 -0400
Message-Id: <20230914191635.39805-18-snitzer@kernel.org>
In-Reply-To: <20230914191635.39805-1-snitzer@kernel.org>
References: <20230914191635.39805-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v3 17/39] dm vdo: add administrative state and
 action manager
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Matthew Sakai <msakai@redhat.com>

Add the admin_state structures which are used to track the states of
individual vdo components for handling of operations like suspend and
resume. It also adds the action manager which is used to schedule and
manage cross-thread administrative and internal operations.

Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-vdo/action-manager.c | 410 +++++++++++++++++++++++
 drivers/md/dm-vdo/action-manager.h | 117 +++++++
 drivers/md/dm-vdo/admin-state.c    | 512 +++++++++++++++++++++++++++++
 drivers/md/dm-vdo/admin-state.h    | 180 ++++++++++
 4 files changed, 1219 insertions(+)
 create mode 100644 drivers/md/dm-vdo/action-manager.c
 create mode 100644 drivers/md/dm-vdo/action-manager.h
 create mode 100644 drivers/md/dm-vdo/admin-state.c
 create mode 100644 drivers/md/dm-vdo/admin-state.h

diff --git a/drivers/md/dm-vdo/action-manager.c b/drivers/md/dm-vdo/action-manager.c
new file mode 100644
index 000000000000..fb3586a4140c
--- /dev/null
+++ b/drivers/md/dm-vdo/action-manager.c
@@ -0,0 +1,410 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "action-manager.h"
+
+#include "memory-alloc.h"
+#include "permassert.h"
+
+#include "admin-state.h"
+#include "completion.h"
+#include "status-codes.h"
+#include "types.h"
+#include "vdo.h"
+
+/**
+ * struct action - An action to be performed in each of a set of zones.
+ * @in_use: Whether this structure is in use.
+ * @operation: The admin operation associated with this action.
+ * @preamble: The method to run on the initiator thread before the action is applied to each zone.
+ * @zone_action: The action to be performed in each zone.
+ * @conclusion: The method to run on the initiator thread after the action is applied to each zone.
+ * @parent: The object to notify when the action is complete.
+ * @context: The action specific context.
+ * @next: The action to perform after this one.
+ */
+struct action {
+	bool in_use;
+	const struct admin_state_code *operation;
+	vdo_action_preamble *preamble;
+	vdo_zone_action *zone_action;
+	vdo_action_conclusion *conclusion;
+	struct vdo_completion *parent;
+	void *context;
+	struct action *next;
+};
+
+/**
+ * struct action_manager - Definition of an action manager.
+ * @completion: The completion for performing actions.
+ * @state: The state of this action manager.
+ * @actions: The two action slots.
+ * @current_action: The current action slot.
+ * @zones: The number of zones in which an action is to be applied.
+ * @Scheduler: A function to schedule a default next action.
+ * @get_zone_thread_id: A function to get the id of the thread on which to apply an action to a
+ *                      zone.
+ * @initiator_thread_id: The ID of the thread on which actions may be initiated.
+ * @context: Opaque data associated with this action manager.
+ * @acting_zone: The zone currently being acted upon.
+ */
+struct action_manager {
+	struct vdo_completion completion;
+	struct admin_state state;
+	struct action actions[2];
+	struct action *current_action;
+	zone_count_t zones;
+	vdo_action_scheduler *scheduler;
+	vdo_zone_thread_getter *get_zone_thread_id;
+	thread_id_t initiator_thread_id;
+	void *context;
+	zone_count_t acting_zone;
+};
+
+static inline struct action_manager *as_action_manager(struct vdo_completion *completion)
+{
+	vdo_assert_completion_type(completion, VDO_ACTION_COMPLETION);
+	return container_of(completion, struct action_manager, completion);
+}
+
+/* Implements vdo_action_scheduler. */
+static bool no_default_action(void *context __always_unused)
+{
+	return false;
+}
+
+/* Implements vdo_action_preamble. */
+static void no_preamble(void *context __always_unused,
+			struct vdo_completion *completion)
+{
+	vdo_finish_completion(completion);
+}
+
+/* Implements vdo_action_conclusion. */
+static int no_conclusion(void *context __always_unused)
+{
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_make_action_manager() - Make an action manager.
+ * @zones: The number of zones to which actions will be applied.
+ * @get_zone_thread_id: A function to get the thread id associated with a zone.
+ * @initiator_thread_id: The thread on which actions may initiated.
+ * @context: The object which holds the per-zone context for the action.
+ * @scheduler: A function to schedule a next action after an action concludes if there is no
+ *             pending action (may be NULL).
+ * @vdo: The vdo used to initialize completions.
+ * @manager_ptr: A pointer to hold the new action manager.
+ *
+ * Return: VDO_SUCCESS or an error code.
+ */
+int vdo_make_action_manager(zone_count_t zones,
+			    vdo_zone_thread_getter *get_zone_thread_id,
+			    thread_id_t initiator_thread_id,
+			    void *context,
+			    vdo_action_scheduler *scheduler,
+			    struct vdo *vdo,
+			    struct action_manager **manager_ptr)
+{
+	struct action_manager *manager;
+	int result = UDS_ALLOCATE(1, struct action_manager, __func__, &manager);
+
+	if (result != VDO_SUCCESS)
+		return result;
+
+	*manager = (struct action_manager) {
+		.zones = zones,
+		.scheduler =
+			((scheduler == NULL) ? no_default_action : scheduler),
+		.get_zone_thread_id = get_zone_thread_id,
+		.initiator_thread_id = initiator_thread_id,
+		.context = context,
+	};
+
+	manager->actions[0].next = &manager->actions[1];
+	manager->current_action = manager->actions[1].next =
+		&manager->actions[0];
+	vdo_set_admin_state_code(&manager->state,
+				 VDO_ADMIN_STATE_NORMAL_OPERATION);
+	vdo_initialize_completion(&manager->completion, vdo,
+				  VDO_ACTION_COMPLETION);
+	*manager_ptr = manager;
+	return VDO_SUCCESS;
+}
+
+const struct admin_state_code *vdo_get_current_manager_operation(struct action_manager *manager)
+{
+	return vdo_get_admin_state_code(&manager->state);
+}
+
+void *vdo_get_current_action_context(struct action_manager *manager)
+{
+	return manager->current_action->in_use ? manager->current_action->context : NULL;
+}
+
+static void finish_action_callback(struct vdo_completion *completion);
+static void apply_to_zone(struct vdo_completion *completion);
+
+static thread_id_t get_acting_zone_thread_id(struct action_manager *manager)
+{
+	return manager->get_zone_thread_id(manager->context, manager->acting_zone);
+}
+
+static void preserve_error(struct vdo_completion *completion)
+{
+	if (completion->parent != NULL)
+		vdo_set_completion_result(completion->parent, completion->result);
+
+	vdo_reset_completion(completion);
+	vdo_run_completion(completion);
+}
+
+static void prepare_for_next_zone(struct action_manager *manager)
+{
+	vdo_prepare_completion_for_requeue(&manager->completion,
+					   apply_to_zone,
+					   preserve_error,
+					   get_acting_zone_thread_id(manager),
+					   manager->current_action->parent);
+}
+
+static void prepare_for_conclusion(struct action_manager *manager)
+{
+	vdo_prepare_completion_for_requeue(&manager->completion,
+					   finish_action_callback,
+					   preserve_error,
+					   manager->initiator_thread_id,
+					   manager->current_action->parent);
+}
+
+static void apply_to_zone(struct vdo_completion *completion)
+{
+	zone_count_t zone;
+	struct action_manager *manager = as_action_manager(completion);
+
+	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == get_acting_zone_thread_id(manager)),
+			"%s() called on acting zones's thread",
+			__func__);
+
+	zone = manager->acting_zone++;
+	if (manager->acting_zone == manager->zones)
+		/*
+		 * We are about to apply to the last zone. Once that is finished, we're done, so go
+		 * back to the initiator thread and finish up.
+		 */
+		prepare_for_conclusion(manager);
+	else
+		/* Prepare to come back on the next zone */
+		prepare_for_next_zone(manager);
+
+	manager->current_action->zone_action(manager->context, zone, completion);
+}
+
+static void handle_preamble_error(struct vdo_completion *completion)
+{
+	/* Skip the zone actions since the preamble failed. */
+	completion->callback = finish_action_callback;
+	preserve_error(completion);
+}
+
+static void launch_current_action(struct action_manager *manager)
+{
+	struct action *action = manager->current_action;
+	int result = vdo_start_operation(&manager->state, action->operation);
+
+	if (result != VDO_SUCCESS) {
+		if (action->parent != NULL)
+			vdo_set_completion_result(action->parent, result);
+
+		/* We aren't going to run the preamble, so don't run the conclusion */
+		action->conclusion = no_conclusion;
+		finish_action_callback(&manager->completion);
+		return;
+	}
+
+	if (action->zone_action == NULL) {
+		prepare_for_conclusion(manager);
+	} else {
+		manager->acting_zone = 0;
+		vdo_prepare_completion_for_requeue(&manager->completion,
+						   apply_to_zone,
+						   handle_preamble_error,
+						   get_acting_zone_thread_id(manager),
+						   manager->current_action->parent);
+	}
+
+	action->preamble(manager->context, &manager->completion);
+}
+
+/**
+ * vdo_schedule_default_action() - Attempt to schedule the default action.
+ * @manager: The action manager.
+ *
+ * If the manager is not operating normally, the action will not be scheduled.
+ *
+ * Return: true if an action was scheduled.
+ */
+bool vdo_schedule_default_action(struct action_manager *manager)
+{
+	/* Don't schedule a default action if we are operating or not in normal operation. */
+	const struct admin_state_code *code = vdo_get_current_manager_operation(manager);
+
+	return ((code == VDO_ADMIN_STATE_NORMAL_OPERATION) &&
+		manager->scheduler(manager->context));
+}
+
+static void finish_action_callback(struct vdo_completion *completion)
+{
+	bool has_next_action;
+	int result;
+	struct action_manager *manager = as_action_manager(completion);
+	struct action action = *(manager->current_action);
+
+	manager->current_action->in_use = false;
+	manager->current_action = manager->current_action->next;
+
+	/*
+	 * We need to check this now to avoid use-after-free issues if running the conclusion or
+	 * notifying the parent results in the manager being freed.
+	 */
+	has_next_action =
+		(manager->current_action->in_use || vdo_schedule_default_action(manager));
+	result = action.conclusion(manager->context);
+	vdo_finish_operation(&manager->state, VDO_SUCCESS);
+	if (action.parent != NULL)
+		vdo_continue_completion(action.parent, result);
+
+	if (has_next_action)
+		launch_current_action(manager);
+}
+
+/**
+ * vdo_schedule_action() - Schedule an action to be applied to all zones.
+ * @manager: The action manager to schedule the action on.
+ * @preamble: A method to be invoked on the initiator thread once this action is started but before
+ *            applying to each zone; may be NULL.
+ * @action: The action to apply to each zone; may be NULL.
+ * @conclusion: A method to be invoked back on the initiator thread once the action has been
+ *              applied to all zones; may be NULL.
+ * @parent: The object to notify once the action is complete or if the action can not be scheduled;
+ *          may be NULL.
+ *
+ * The action will be launched immediately if there is no current action, or as soon as the current
+ * action completes. If there is already a pending action, this action will not be scheduled, and,
+ * if it has a parent, that parent will be notified. At least one of the preamble, action, or
+ * conclusion must not be NULL.
+ *
+ * Return: true if the action was scheduled.
+ */
+bool vdo_schedule_action(struct action_manager *manager,
+			 vdo_action_preamble *preamble,
+			 vdo_zone_action *action,
+			 vdo_action_conclusion *conclusion,
+			 struct vdo_completion *parent)
+{
+	return vdo_schedule_operation(manager,
+				      VDO_ADMIN_STATE_OPERATING,
+				      preamble,
+				      action,
+				      conclusion,
+				      parent);
+}
+
+/**
+ * vdo_schedule_operation() - Schedule an operation to be applied to all zones.
+ * @manager: The action manager to schedule the action on.
+ * @operation: The operation this action will perform
+ * @preamble: A method to be invoked on the initiator thread once this action is started but before
+ *            applying to each zone; may be NULL.
+ * @action: The action to apply to each zone; may be NULL.
+ * @conclusion: A method to be invoked back on the initiator thread once the action has been
+ *              applied to all zones; may be NULL.
+ * @parent: The object to notify once the action is complete or if the action can not be scheduled;
+ *          may be NULL.
+ *
+ * The operation's action will be launched immediately if there is no current action, or as soon as
+ * the current action completes. If there is already a pending action, this operation will not be
+ * scheduled, and, if it has a parent, that parent will be notified. At least one of the preamble,
+ * action, or conclusion must not be NULL.
+ *
+ * Return: true if the action was scheduled.
+ */
+bool vdo_schedule_operation(struct action_manager *manager,
+			    const struct admin_state_code *operation,
+			    vdo_action_preamble *preamble,
+			    vdo_zone_action *action,
+			    vdo_action_conclusion *conclusion,
+			    struct vdo_completion *parent)
+{
+	return vdo_schedule_operation_with_context(manager,
+						   operation,
+						   preamble,
+						   action,
+						   conclusion,
+						   NULL,
+						   parent);
+}
+
+/**
+ * vdo_schedule_operation_with_context() - Schedule an operation on all zones.
+ * @manager: The action manager to schedule the action on.
+ * @operation: The operation this action will perform.
+ * @preamble: A method to be invoked on the initiator thread once this action is started but before
+ *            applying to each zone; may be NULL.
+ * @action: The action to apply to each zone; may be NULL.
+ * @conclusion: A method to be invoked back on the initiator thread once the action has been
+ *              applied to all zones; may be NULL.
+ * @context: An action-specific context which may be retrieved via
+ *           vdo_get_current_action_context(); may be NULL.
+ * @parent: The object to notify once the action is complete or if the action can not be scheduled;
+ *          may be NULL.
+ *
+ * The operation's action will be launched immediately if there is no current action, or as soon as
+ * the current action completes. If there is already a pending action, this operation will not be
+ * scheduled, and, if it has a parent, that parent will be notified. At least one of the preamble,
+ * action, or conclusion must not be NULL.
+ *
+ * Return: true if the action was scheduled
+ */
+bool vdo_schedule_operation_with_context(struct action_manager *manager,
+					 const struct admin_state_code *operation,
+					 vdo_action_preamble *preamble,
+					 vdo_zone_action *action,
+					 vdo_action_conclusion *conclusion,
+					 void *context,
+					 struct vdo_completion *parent)
+{
+	struct action *current_action;
+
+	ASSERT_LOG_ONLY((vdo_get_callback_thread_id() == manager->initiator_thread_id),
+			"action initiated from correct thread");
+	if (!manager->current_action->in_use) {
+		current_action = manager->current_action;
+	} else if (!manager->current_action->next->in_use) {
+		current_action = manager->current_action->next;
+	} else {
+		if (parent != NULL)
+			vdo_continue_completion(parent, VDO_COMPONENT_BUSY);
+
+		return false;
+	}
+
+	*current_action = (struct action) {
+		.in_use = true,
+		.operation = operation,
+		.preamble = (preamble == NULL) ? no_preamble : preamble,
+		.zone_action = action,
+		.conclusion = (conclusion == NULL) ? no_conclusion : conclusion,
+		.context = context,
+		.parent = parent,
+		.next = current_action->next,
+	};
+
+	if (current_action == manager->current_action)
+		launch_current_action(manager);
+
+	return true;
+}
diff --git a/drivers/md/dm-vdo/action-manager.h b/drivers/md/dm-vdo/action-manager.h
new file mode 100644
index 000000000000..b97bb2eec145
--- /dev/null
+++ b/drivers/md/dm-vdo/action-manager.h
@@ -0,0 +1,117 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_ACTION_MANAGER_H
+#define VDO_ACTION_MANAGER_H
+
+#include "admin-state.h"
+#include "types.h"
+
+/*
+ * An action_manager provides a generic mechanism for applying actions to multi-zone entities (such
+ * as the block map or slab depot). Each action manager is tied to a specific context for which it
+ * manages actions. The manager ensures that only one action is active on that context at a time,
+ * and supports at most one pending action. Calls to schedule an action when there is already a
+ * pending action will result in VDO_COMPONENT_BUSY errors. Actions may only be submitted to the
+ * action manager from a single thread (which thread is determined when the action manager is
+ * constructed).
+ *
+ * A scheduled action consists of four components:
+ *
+ *   preamble
+ *     an optional method to be run on the initiator thread before applying the action to all zones
+ *   zone_action
+ *     an optional method to be applied to each of the zones
+ *   conclusion
+ *     an optional method to be run on the initiator thread once the per-zone method has been
+ *     applied to all zones
+ *   parent
+ *     an optional completion to be finished once the conclusion is done
+ *
+ * At least one of the three methods must be provided.
+ */
+
+/*
+ * A function which is to be applied asynchronously to a set of zones.
+ * @context: The object which holds the per-zone context for the action
+ * @zone_number: The number of zone to which the action is being applied
+ * @parent: The object to notify when the action is complete
+ */
+typedef void vdo_zone_action(void *context,
+			     zone_count_t zone_number,
+			     struct vdo_completion *parent);
+
+/*
+ * A function which is to be applied asynchronously on an action manager's initiator thread as the
+ * preamble of an action.
+ * @context: The object which holds the per-zone context for the action
+ * @parent: The object to notify when the action is complete
+ */
+typedef void vdo_action_preamble(void *context, struct vdo_completion *parent);
+
+/*
+ * A function which will run on the action manager's initiator thread as the conclusion of an
+ * action.
+ * @context: The object which holds the per-zone context for the action
+ *
+ * Return: VDO_SUCCESS or an error
+ */
+typedef int vdo_action_conclusion(void *context);
+
+/*
+ * A function to schedule an action.
+ * @context: The object which holds the per-zone context for the action
+ *
+ * Return: true if an action was scheduled
+ */
+typedef bool vdo_action_scheduler(void *context);
+
+/*
+ * A function to get the id of the thread associated with a given zone.
+ * @context: The action context
+ * @zone_number: The number of the zone for which the thread ID is desired
+ */
+typedef thread_id_t vdo_zone_thread_getter(void *context, zone_count_t zone_number);
+
+struct action_manager;
+
+int __must_check
+vdo_make_action_manager(zone_count_t zones,
+			vdo_zone_thread_getter *get_zone_thread_id,
+			thread_id_t initiator_thread_id,
+			void *context,
+			vdo_action_scheduler *scheduler,
+			struct vdo *vdo,
+			struct action_manager **manager_ptr);
+
+const struct admin_state_code *__must_check
+vdo_get_current_manager_operation(struct action_manager *manager);
+
+void * __must_check vdo_get_current_action_context(struct action_manager *manager);
+
+bool vdo_schedule_default_action(struct action_manager *manager);
+
+bool vdo_schedule_action(struct action_manager *manager,
+			 vdo_action_preamble *preamble,
+			 vdo_zone_action *action,
+			 vdo_action_conclusion *conclusion,
+			 struct vdo_completion *parent);
+
+bool vdo_schedule_operation(struct action_manager *manager,
+			    const struct admin_state_code *operation,
+			    vdo_action_preamble *preamble,
+			    vdo_zone_action *action,
+			    vdo_action_conclusion *conclusion,
+			    struct vdo_completion *parent);
+
+bool vdo_schedule_operation_with_context(struct action_manager *manager,
+					 const struct admin_state_code *operation,
+					 vdo_action_preamble *preamble,
+					 vdo_zone_action *action,
+					 vdo_action_conclusion *conclusion,
+					 void *context,
+					 struct vdo_completion *parent);
+
+#endif /* VDO_ACTION_MANAGER_H */
diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
new file mode 100644
index 000000000000..e2ba354508b2
--- /dev/null
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -0,0 +1,512 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#include "admin-state.h"
+
+#include "logger.h"
+#include "memory-alloc.h"
+#include "permassert.h"
+
+#include "completion.h"
+#include "types.h"
+
+static const struct admin_state_code VDO_CODE_NORMAL_OPERATION = {
+	.name = "VDO_ADMIN_STATE_NORMAL_OPERATION",
+	.normal = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_NORMAL_OPERATION = &VDO_CODE_NORMAL_OPERATION;
+static const struct admin_state_code VDO_CODE_OPERATING = {
+	.name = "VDO_ADMIN_STATE_OPERATING",
+	.normal = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_OPERATING = &VDO_CODE_OPERATING;
+static const struct admin_state_code VDO_CODE_FORMATTING = {
+	.name = "VDO_ADMIN_STATE_FORMATTING",
+	.operating = true,
+	.loading = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_FORMATTING = &VDO_CODE_FORMATTING;
+static const struct admin_state_code VDO_CODE_PRE_LOADING = {
+	.name = "VDO_ADMIN_STATE_PRE_LOADING",
+	.operating = true,
+	.loading = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_PRE_LOADING = &VDO_CODE_PRE_LOADING;
+static const struct admin_state_code VDO_CODE_PRE_LOADED = {
+	.name = "VDO_ADMIN_STATE_PRE_LOADED",
+};
+const struct admin_state_code *VDO_ADMIN_STATE_PRE_LOADED = &VDO_CODE_PRE_LOADED;
+static const struct admin_state_code VDO_CODE_LOADING = {
+	.name = "VDO_ADMIN_STATE_LOADING",
+	.normal = true,
+	.operating = true,
+	.loading = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_LOADING = &VDO_CODE_LOADING;
+static const struct admin_state_code VDO_CODE_LOADING_FOR_RECOVERY = {
+	.name = "VDO_ADMIN_STATE_LOADING_FOR_RECOVERY",
+	.operating = true,
+	.loading = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_LOADING_FOR_RECOVERY =
+	&VDO_CODE_LOADING_FOR_RECOVERY;
+static const struct admin_state_code VDO_CODE_LOADING_FOR_REBUILD = {
+	.name = "VDO_ADMIN_STATE_LOADING_FOR_REBUILD",
+	.operating = true,
+	.loading = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_LOADING_FOR_REBUILD = &VDO_CODE_LOADING_FOR_REBUILD;
+static const struct admin_state_code VDO_CODE_WAITING_FOR_RECOVERY = {
+	.name = "VDO_ADMIN_STATE_WAITING_FOR_RECOVERY",
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_WAITING_FOR_RECOVERY =
+	&VDO_CODE_WAITING_FOR_RECOVERY;
+static const struct admin_state_code VDO_CODE_NEW = {
+	.name = "VDO_ADMIN_STATE_NEW",
+	.quiescent = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_NEW = &VDO_CODE_NEW;
+static const struct admin_state_code VDO_CODE_INITIALIZED = {
+	.name = "VDO_ADMIN_STATE_INITIALIZED",
+};
+const struct admin_state_code *VDO_ADMIN_STATE_INITIALIZED = &VDO_CODE_INITIALIZED;
+static const struct admin_state_code VDO_CODE_RECOVERING = {
+	.name = "VDO_ADMIN_STATE_RECOVERING",
+	.draining = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_RECOVERING = &VDO_CODE_RECOVERING;
+static const struct admin_state_code VDO_CODE_REBUILDING = {
+	.name = "VDO_ADMIN_STATE_REBUILDING",
+	.draining = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_REBUILDING = &VDO_CODE_REBUILDING;
+static const struct admin_state_code VDO_CODE_SAVING = {
+	.name = "VDO_ADMIN_STATE_SAVING",
+	.draining = true,
+	.quiescing = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_SAVING = &VDO_CODE_SAVING;
+static const struct admin_state_code VDO_CODE_SAVED = {
+	.name = "VDO_ADMIN_STATE_SAVED",
+	.quiescent = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_SAVED = &VDO_CODE_SAVED;
+static const struct admin_state_code VDO_CODE_SCRUBBING = {
+	.name = "VDO_ADMIN_STATE_SCRUBBING",
+	.draining = true,
+	.loading = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_SCRUBBING = &VDO_CODE_SCRUBBING;
+static const struct admin_state_code VDO_CODE_SAVE_FOR_SCRUBBING = {
+	.name = "VDO_ADMIN_STATE_SAVE_FOR_SCRUBBING",
+	.draining = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_SAVE_FOR_SCRUBBING = &VDO_CODE_SAVE_FOR_SCRUBBING;
+static const struct admin_state_code VDO_CODE_STOPPING = {
+	.name = "VDO_ADMIN_STATE_STOPPING",
+	.draining = true,
+	.quiescing = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_STOPPING = &VDO_CODE_STOPPING;
+static const struct admin_state_code VDO_CODE_STOPPED = {
+	.name = "VDO_ADMIN_STATE_STOPPED",
+	.quiescent = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_STOPPED = &VDO_CODE_STOPPED;
+static const struct admin_state_code VDO_CODE_SUSPENDING = {
+	.name = "VDO_ADMIN_STATE_SUSPENDING",
+	.draining = true,
+	.quiescing = true,
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_SUSPENDING = &VDO_CODE_SUSPENDING;
+static const struct admin_state_code VDO_CODE_SUSPENDED = {
+	.name = "VDO_ADMIN_STATE_SUSPENDED",
+	.quiescent = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_SUSPENDED = &VDO_CODE_SUSPENDED;
+static const struct admin_state_code VDO_CODE_SUSPENDED_OPERATION = {
+	.name = "VDO_ADMIN_STATE_SUSPENDED_OPERATION",
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_SUSPENDED_OPERATION = &VDO_CODE_SUSPENDED_OPERATION;
+static const struct admin_state_code VDO_CODE_RESUMING = {
+	.name = "VDO_ADMIN_STATE_RESUMING",
+	.operating = true,
+};
+const struct admin_state_code *VDO_ADMIN_STATE_RESUMING = &VDO_CODE_RESUMING;
+
+/**
+ * get_next_state() - Determine the state which should be set after a given operation completes
+ *                    based on the operation and the current state.
+ * @operation The operation to be started.
+ *
+ * Return: The state to set when the operation completes or NULL if the operation can not be
+ *         started in the current state.
+ */
+static const struct admin_state_code *
+get_next_state(const struct admin_state *state, const struct admin_state_code *operation)
+{
+	const struct admin_state_code *code = vdo_get_admin_state_code(state);
+
+	if (code->operating)
+		return NULL;
+
+	if (operation == VDO_ADMIN_STATE_SAVING)
+		return (code == VDO_ADMIN_STATE_NORMAL_OPERATION ? VDO_ADMIN_STATE_SAVED : NULL);
+
+	if (operation == VDO_ADMIN_STATE_SUSPENDING)
+		return (code == VDO_ADMIN_STATE_NORMAL_OPERATION
+			? VDO_ADMIN_STATE_SUSPENDED
+			: NULL);
+
+	if (operation == VDO_ADMIN_STATE_STOPPING)
+		return (code == VDO_ADMIN_STATE_NORMAL_OPERATION ? VDO_ADMIN_STATE_STOPPED : NULL);
+
+	if (operation == VDO_ADMIN_STATE_PRE_LOADING)
+		return (code == VDO_ADMIN_STATE_INITIALIZED ? VDO_ADMIN_STATE_PRE_LOADED : NULL);
+
+	if (operation == VDO_ADMIN_STATE_SUSPENDED_OPERATION)
+		return (((code == VDO_ADMIN_STATE_SUSPENDED) ||
+			 (code == VDO_ADMIN_STATE_SAVED)) ? code : NULL);
+
+	return VDO_ADMIN_STATE_NORMAL_OPERATION;
+}
+
+/**
+ * vdo_finish_operation() - Finish the current operation.
+ *
+ * Will notify the operation waiter if there is one. This method should be used for operations
+ * started with vdo_start_operation(). For operations which were started with vdo_start_draining(),
+ * use vdo_finish_draining() instead.
+ *
+ * Return: true if there was an operation to finish.
+ */
+bool vdo_finish_operation(struct admin_state *state, int result)
+{
+	if (!vdo_get_admin_state_code(state)->operating)
+		return false;
+
+	state->complete = state->starting;
+	if (state->waiter != NULL)
+		vdo_set_completion_result(state->waiter, result);
+
+	if (!state->starting) {
+		vdo_set_admin_state_code(state, state->next_state);
+		if (state->waiter != NULL)
+			vdo_launch_completion(UDS_FORGET(state->waiter));
+	}
+
+	return true;
+}
+
+/**
+ * begin_operation() - Begin an operation if it may be started given the current state.
+ * @waiter A completion to notify when the operation is complete; may be NULL.
+ * @initiator The vdo_admin_initiator to call if the operation may begin; may be NULL.
+ *
+ * Return: VDO_SUCCESS or an error.
+ */
+static int __must_check begin_operation(struct admin_state *state,
+					const struct admin_state_code *operation,
+					struct vdo_completion *waiter,
+					vdo_admin_initiator *initiator)
+{
+	int result;
+	const struct admin_state_code *next_state = get_next_state(state, operation);
+
+	if (next_state == NULL) {
+		result = uds_log_error_strerror(VDO_INVALID_ADMIN_STATE,
+						"Can't start %s from %s",
+						operation->name,
+						vdo_get_admin_state_code(state)->name);
+	} else if (state->waiter != NULL) {
+		result = uds_log_error_strerror(VDO_COMPONENT_BUSY,
+						"Can't start %s with extant waiter",
+						operation->name);
+	} else {
+		state->waiter = waiter;
+		state->next_state = next_state;
+		vdo_set_admin_state_code(state, operation);
+		if (initiator != NULL) {
+			state->starting = true;
+			initiator(state);
+			state->starting = false;
+			if (state->complete)
+				vdo_finish_operation(state, VDO_SUCCESS);
+		}
+
+		return VDO_SUCCESS;
+	}
+
+	if (waiter != NULL)
+		vdo_continue_completion(waiter, result);
+
+	return result;
+}
+
+/**
+ * start_operation() - Start an operation if it may be started given the current state.
+ * @waiter     A completion to notify when the operation is complete.
+ * @initiator The vdo_admin_initiator to call if the operation may begin; may be NULL.
+ *
+ * Return: true if the operation was started.
+ */
+static inline bool __must_check start_operation(struct admin_state *state,
+						const struct admin_state_code *operation,
+						struct vdo_completion *waiter,
+						vdo_admin_initiator *initiator)
+{
+	return (begin_operation(state, operation, waiter, initiator) == VDO_SUCCESS);
+}
+
+/**
+ * check_code() - Check the result of a state validation.
+ * @valid true if the code is of an appropriate type.
+ * @code The code which failed to be of the correct type.
+ * @what What the code failed to be, for logging.
+ * @waiter The completion to notify of the error; may be NULL.
+ *
+ * If the result failed, log an invalid state error and, if there is a waiter, notify it.
+ *
+ * Return: The result of the check.
+ */
+static bool check_code(bool valid,
+		       const struct admin_state_code *code,
+		       const char *what,
+		       struct vdo_completion *waiter)
+{
+	int result;
+
+	if (valid)
+		return true;
+
+	result = uds_log_error_strerror(VDO_INVALID_ADMIN_STATE,
+					"%s is not a %s", code->name, what);
+	if (waiter != NULL)
+		vdo_continue_completion(waiter, result);
+
+	return false;
+}
+
+/**
+ * vdo_drain_operation() - Check that an operation is a drain.
+ * @waiter The completion to finish with an error if the operation is not a drain.
+ *
+ * Return: true if the specified operation is a drain.
+ */
+static bool __must_check
+assert_vdo_drain_operation(const struct admin_state_code *operation, struct vdo_completion *waiter)
+{
+	return check_code(operation->draining, operation, "drain operation", waiter);
+}
+
+/**
+ * vdo_start_draining() - Initiate a drain operation if the current state permits it.
+ * @operation The type of drain to initiate.
+ * @waiter The completion to notify when the drain is complete.
+ * @initiator The vdo_admin_initiator to call if the operation may begin; may be NULL.
+ *
+ * Return: true if the drain was initiated, if not the waiter will be notified.
+ */
+bool vdo_start_draining(struct admin_state *state,
+			const struct admin_state_code *operation,
+			struct vdo_completion *waiter,
+			vdo_admin_initiator *initiator)
+{
+	const struct admin_state_code *code = vdo_get_admin_state_code(state);
+
+	if (!assert_vdo_drain_operation(operation, waiter))
+		return false;
+
+	if (code->quiescent) {
+		vdo_launch_completion(waiter);
+		return false;
+	}
+
+	if (!code->normal) {
+		uds_log_error_strerror(VDO_INVALID_ADMIN_STATE,
+				       "can't start %s from %s",
+				       operation->name,
+				       code->name);
+		vdo_continue_completion(waiter, VDO_INVALID_ADMIN_STATE);
+		return false;
+	}
+
+	return start_operation(state, operation, waiter, initiator);
+}
+
+/**
+ * vdo_finish_draining() - Finish a drain operation if one was in progress.
+ *
+ * Return: true if the state was draining; will notify the waiter if so.
+ */
+bool vdo_finish_draining(struct admin_state *state)
+{
+	return vdo_finish_draining_with_result(state, VDO_SUCCESS);
+}
+
+/**
+ * vdo_finish_draining_with_result() - Finish a drain operation with a status code.
+ *
+ * Return: true if the state was draining; will notify the waiter if so.
+ */
+bool vdo_finish_draining_with_result(struct admin_state *state, int result)
+{
+	return (vdo_is_state_draining(state) && vdo_finish_operation(state, result));
+}
+
+/**
+ * vdo_assert_load_operation() - Check that an operation is a load.
+ * @waiter The completion to finish with an error if the operation is not a load.
+ *
+ * Return: true if the specified operation is a load.
+ */
+bool vdo_assert_load_operation(const struct admin_state_code *operation,
+			       struct vdo_completion *waiter)
+{
+	return check_code(operation->loading, operation, "load operation", waiter);
+}
+
+/**
+ * vdo_start_loading() - Initiate a load operation if the current state permits it.
+ * @operation The type of load to initiate.
+ * @waiter The completion to notify when the load is complete (may be NULL).
+ * @initiator The vdo_admin_initiator to call if the operation may begin; may be NULL.
+ *
+ * Return: true if the load was initiated, if not the waiter will be notified.
+ */
+bool vdo_start_loading(struct admin_state *state,
+		       const struct admin_state_code *operation,
+		       struct vdo_completion *waiter,
+		       vdo_admin_initiator *initiator)
+{
+	return (vdo_assert_load_operation(operation, waiter) &&
+		start_operation(state, operation, waiter, initiator));
+}
+
+/**
+ * vdo_finish_loading() - Finish a load operation if one was in progress.
+ *
+ * Return: true if the state was loading; will notify the waiter if so.
+ */
+bool vdo_finish_loading(struct admin_state *state)
+{
+	return vdo_finish_loading_with_result(state, VDO_SUCCESS);
+}
+
+/**
+ * vdo_finish_loading_with_result() - Finish a load operation with a status code.
+ * @result The result of the load operation.
+ *
+ * Return: true if the state was loading; will notify the waiter if so.
+ */
+bool vdo_finish_loading_with_result(struct admin_state *state, int result)
+{
+	return (vdo_is_state_loading(state) && vdo_finish_operation(state, result));
+}
+
+/**
+ * assert_vdo_resume_operation() - Check whether an admin_state_code is a resume operation.
+ * @waiter The completion to notify if the operation is not a resume operation; may be NULL.
+ *
+ * Return: true if the code is a resume operation.
+ */
+static bool __must_check assert_vdo_resume_operation(const struct admin_state_code *operation,
+						     struct vdo_completion *waiter)
+{
+	return check_code(operation == VDO_ADMIN_STATE_RESUMING,
+			  operation,
+			  "resume operation",
+			  waiter);
+}
+
+/**
+ * vdo_start_resuming() - Initiate a resume operation if the current state permits it.
+ * @operation The type of resume to start.
+ * @waiter The completion to notify when the resume is complete (may be NULL).
+ * @initiator The vdo_admin_initiator to call if the operation may begin; may be NULL.
+ *
+ * Return: true if the resume was initiated, if not the waiter will be notified.
+ */
+bool vdo_start_resuming(struct admin_state *state,
+			const struct admin_state_code *operation,
+			struct vdo_completion *waiter,
+			vdo_admin_initiator *initiator)
+{
+	return (assert_vdo_resume_operation(operation, waiter) &&
+		start_operation(state, operation, waiter, initiator));
+}
+
+/**
+ * vdo_finish_resuming() - Finish a resume operation if one was in progress.
+ *
+ * Return: true if the state was resuming; will notify the waiter if so.
+ */
+bool vdo_finish_resuming(struct admin_state *state)
+{
+	return vdo_finish_resuming_with_result(state, VDO_SUCCESS);
+}
+
+/**
+ * vdo_finish_resuming_with_result() - Finish a resume operation with a status code.
+ * @result The result of the resume operation.
+ *
+ * Return: true if the state was resuming; will notify the waiter if so.
+ */
+bool vdo_finish_resuming_with_result(struct admin_state *state, int result)
+{
+	return (vdo_is_state_resuming(state) && vdo_finish_operation(state, result));
+}
+
+/**
+ * vdo_resume_if_quiescent() - Change the state to normal operation if the current state is
+ *                             quiescent.
+ *
+ * Return: VDO_SUCCESS if the state resumed, VDO_INVALID_ADMIN_STATE otherwise.
+ */
+int vdo_resume_if_quiescent(struct admin_state *state)
+{
+	if (!vdo_is_state_quiescent(state))
+		return VDO_INVALID_ADMIN_STATE;
+
+	vdo_set_admin_state_code(state, VDO_ADMIN_STATE_NORMAL_OPERATION);
+	return VDO_SUCCESS;
+}
+
+/**
+ * vdo_start_operation() - Attempt to start an operation.
+ *
+ * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
+ */
+int vdo_start_operation(struct admin_state *state, const struct admin_state_code *operation)
+{
+	return vdo_start_operation_with_waiter(state, operation, NULL, NULL);
+}
+
+/**
+ * vdo_start_operation_with_waiter() - Attempt to start an operation.
+ * @waiter the completion to notify when the operation completes or fails to start; may be NULL.
+ * @initiator The vdo_admin_initiator to call if the operation may begin; may be NULL.
+ *
+ * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
+ */
+int vdo_start_operation_with_waiter(struct admin_state *state,
+				    const struct admin_state_code *operation,
+				    struct vdo_completion *waiter,
+				    vdo_admin_initiator *initiator)
+{
+	return (check_code(operation->operating, operation, "operation", waiter) ?
+		begin_operation(state, operation, waiter, initiator) :
+		VDO_INVALID_ADMIN_STATE);
+}
diff --git a/drivers/md/dm-vdo/admin-state.h b/drivers/md/dm-vdo/admin-state.h
new file mode 100644
index 000000000000..550e9084662d
--- /dev/null
+++ b/drivers/md/dm-vdo/admin-state.h
@@ -0,0 +1,180 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2023 Red Hat
+ */
+
+#ifndef VDO_ADMIN_STATE_H
+#define VDO_ADMIN_STATE_H
+
+#include "completion.h"
+#include "types.h"
+
+struct admin_state_code {
+	const char *name;
+	/* Normal operation, data_vios may be active */
+	bool normal;
+	/* I/O is draining, new requests should not start */
+	bool draining;
+	/* This is a startup time operation */
+	bool loading;
+	/* The next state will be quiescent */
+	bool quiescing;
+	/* The VDO is quiescent, there should be no I/O */
+	bool quiescent;
+	/* Whether an operation is in progress and so no other operation may be started */
+	bool operating;
+};
+
+extern const struct admin_state_code *VDO_ADMIN_STATE_NORMAL_OPERATION;
+extern const struct admin_state_code *VDO_ADMIN_STATE_OPERATING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_FORMATTING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_PRE_LOADING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_PRE_LOADED;
+extern const struct admin_state_code *VDO_ADMIN_STATE_LOADING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_LOADING_FOR_RECOVERY;
+extern const struct admin_state_code *VDO_ADMIN_STATE_LOADING_FOR_REBUILD;
+extern const struct admin_state_code *VDO_ADMIN_STATE_WAITING_FOR_RECOVERY;
+extern const struct admin_state_code *VDO_ADMIN_STATE_NEW;
+extern const struct admin_state_code *VDO_ADMIN_STATE_INITIALIZED;
+extern const struct admin_state_code *VDO_ADMIN_STATE_RECOVERING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_REBUILDING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_SAVING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_SAVED;
+extern const struct admin_state_code *VDO_ADMIN_STATE_SCRUBBING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_SAVE_FOR_SCRUBBING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_STOPPING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_STOPPED;
+extern const struct admin_state_code *VDO_ADMIN_STATE_SUSPENDING;
+extern const struct admin_state_code *VDO_ADMIN_STATE_SUSPENDED;
+extern const struct admin_state_code *VDO_ADMIN_STATE_SUSPENDED_OPERATION;
+extern const struct admin_state_code *VDO_ADMIN_STATE_RESUMING;
+
+struct admin_state {
+	const struct admin_state_code *current_state;
+	/* The next administrative state (when the current operation finishes) */
+	const struct admin_state_code *next_state;
+	/* A completion waiting on a state change */
+	struct vdo_completion *waiter;
+	/* Whether an operation is being initiated */
+	bool starting;
+	/* Whether an operation has completed in the initiator */
+	bool complete;
+};
+
+/**
+ * typedef vdo_admin_initiator - A method to be called once an admin operation may be initiated.
+ */
+typedef void vdo_admin_initiator(struct admin_state *state);
+
+static inline const struct admin_state_code * __must_check
+vdo_get_admin_state_code(const struct admin_state *state)
+{
+	return READ_ONCE(state->current_state);
+}
+
+/**
+ * vdo_set_admin_state_code() - Set the current admin state code.
+ *
+ * This function should be used primarily for initialization and by adminState internals. Most uses
+ * should go through the operation interfaces.
+ */
+static inline void
+vdo_set_admin_state_code(struct admin_state *state, const struct admin_state_code *code)
+{
+	WRITE_ONCE(state->current_state, code);
+}
+
+static inline bool __must_check vdo_is_state_normal(const struct admin_state *state)
+{
+	return vdo_get_admin_state_code(state)->normal;
+}
+
+static inline bool __must_check vdo_is_state_suspending(const struct admin_state *state)
+{
+	return (vdo_get_admin_state_code(state) == VDO_ADMIN_STATE_SUSPENDING);
+}
+
+static inline bool __must_check vdo_is_state_saving(const struct admin_state *state)
+{
+	return (vdo_get_admin_state_code(state) == VDO_ADMIN_STATE_SAVING);
+}
+
+static inline bool __must_check vdo_is_state_saved(const struct admin_state *state)
+{
+	return (vdo_get_admin_state_code(state) == VDO_ADMIN_STATE_SAVED);
+}
+
+static inline bool __must_check vdo_is_state_draining(const struct admin_state *state)
+{
+	return vdo_get_admin_state_code(state)->draining;
+}
+
+static inline bool __must_check vdo_is_state_loading(const struct admin_state *state)
+{
+	return vdo_get_admin_state_code(state)->loading;
+}
+
+static inline bool __must_check vdo_is_state_resuming(const struct admin_state *state)
+{
+	return (vdo_get_admin_state_code(state) == VDO_ADMIN_STATE_RESUMING);
+}
+
+static inline bool __must_check vdo_is_state_clean_load(const struct admin_state *state)
+{
+	const struct admin_state_code *code = vdo_get_admin_state_code(state);
+
+	return ((code == VDO_ADMIN_STATE_FORMATTING) || (code == VDO_ADMIN_STATE_LOADING));
+}
+
+static inline bool __must_check vdo_is_state_quiescing(const struct admin_state *state)
+{
+	return vdo_get_admin_state_code(state)->quiescing;
+}
+
+static inline bool __must_check vdo_is_state_quiescent(const struct admin_state *state)
+{
+	return vdo_get_admin_state_code(state)->quiescent;
+}
+
+bool __must_check
+vdo_assert_load_operation(const struct admin_state_code *operation, struct vdo_completion *waiter);
+
+bool vdo_start_loading(struct admin_state *state,
+		       const struct admin_state_code *operation,
+		       struct vdo_completion *waiter,
+		       vdo_admin_initiator *initiator);
+
+bool vdo_finish_loading(struct admin_state *state);
+
+bool vdo_finish_loading_with_result(struct admin_state *state, int result);
+
+bool vdo_start_resuming(struct admin_state *state,
+			const struct admin_state_code *operation,
+			struct vdo_completion *waiter,
+			vdo_admin_initiator *initiator);
+
+bool vdo_finish_resuming(struct admin_state *state);
+
+bool vdo_finish_resuming_with_result(struct admin_state *state, int result);
+
+int vdo_resume_if_quiescent(struct admin_state *state);
+
+bool vdo_start_draining(struct admin_state *state,
+			const struct admin_state_code *operation,
+			struct vdo_completion *waiter,
+			vdo_admin_initiator *initiator);
+
+bool vdo_finish_draining(struct admin_state *state);
+
+bool vdo_finish_draining_with_result(struct admin_state *state, int result);
+
+int vdo_start_operation(struct admin_state *state, const struct admin_state_code *operation);
+
+int vdo_start_operation_with_waiter(struct admin_state *state,
+				    const struct admin_state_code *operation,
+				    struct vdo_completion *waiter,
+				    vdo_admin_initiator *initiator);
+
+bool vdo_finish_operation(struct admin_state *state, int result);
+
+#endif /* VDO_ADMIN_STATE_H */
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

