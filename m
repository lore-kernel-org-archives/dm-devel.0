Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3A9135412
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 18:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706207406; cv=none; b=l3Y3UErR7P2OOmqJr6kUOC6DiPDvLdribfc180HuvZopWqQeloFipOosL0f7y18SM4gzZq+Ka/b9xDIBYv8tBq0Y3qG9y6TaoNSJoOeoGsz3zzn6uFAodmOTjdBI5xWpEls9cS2TDtlS3SjUYxFm1CedEyJ0LurN7YaJU6sLyB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706207406; c=relaxed/simple;
	bh=OPA2cuzn5UAHEJ6wEIBW91lYRI0vxCC/ZWjzMFkOScQ=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=cAOajCMNFUchEBHuHA8lBYbiKxcLgkcX8ihcgwSr3MVtHywI1iC4fcE2HGuE+kqigDosD8bWjZ8R7rNwkX+/iNlQ+Rhj1INlEy4mZdP/LQE6ORGnpDbG4UsnYg8CwukqB1whSqBhO+Bu0r3l4KA6V7E/ra6zXFnNaFhlQ1zrBT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ah9cpo2i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ah9cpo2i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706207403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bB4BbgukWG92dKMqbQfPWgXExA2ppJqUrBLC6EqUHro=;
	b=Ah9cpo2ief1kDa9zsYE13HDLfWsrlEGRkQKIkykfA5ZXCnRC4dnzm4ZanEkyzZQF0YVdE/
	ASWxfHrpsBLTWhZQh8b6cPBG2IS6dqKLbzwu5SOnlRByvp6om4TsCkBZXgMJgbpXD/OvOd
	17ZSloHFsyigowzwhOPuNDrNWgpr7Rw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-102-hSV-gnCWM_6XREPhKZJG2A-1; Thu,
 25 Jan 2024 13:29:44 -0500
X-MC-Unique: hSV-gnCWM_6XREPhKZJG2A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD0753C1E9C5;
	Thu, 25 Jan 2024 18:29:43 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFC6A2166B32;
	Thu, 25 Jan 2024 18:29:42 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id A8F5830CAABD; Thu, 25 Jan 2024 18:29:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id A48F63FB4E;
	Thu, 25 Jan 2024 19:29:42 +0100 (CET)
Date: Thu, 25 Jan 2024 19:29:42 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, 
    Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
    Mike Snitzer <msnitzer@redhat.com>, Ignat Korchagin <ignat@cloudflare.com>, 
    Damien Le Moal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, 
    Hou Tao <houtao1@huawei.com>, Nathan Huckleberry <nhuck@google.com>, 
    Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] softirq: fix memory corruption when freeing tasklet_struct
Message-ID: <82b964f0-c2c8-a2c6-5b1f-f3145dc2c8e5@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Hi

There's a problem with the tasklet API - there is no reliable way how to
free a structure that contains tasklet_struct. The problem is that the
function tasklet_action_common calls task_unlock(t) after it called the
callback. If the callback does something that frees tasklet_struct,
task_unlock(t) would write into free memory.

dm-crypt does this - it schedules a tasklet with tasklet_schedule, it does
encryption inside the tasklet handler (because it performs better than
doing the encryption in a workqueue), then it submits a workqueue entry
and calls bio_endio from the workqueue entry.

However, if the workqueue preempts ksoftirqd, this race condition happens:

ksoftirqd:
* tasklet_action_common
* t->func(t->data)	(that points to kcryptd_crypt_tasklet)
* kcryptd_crypt_tasklet
* kcryptd_crypt
* kcryptd_crypt_read_convert
* crypt_dec_pending
* queue_work(cc->io_queue, &io->work);
now we switch to the workqueue process:
* kcryptd_io_bio_endio
* bio_endio(io->base_bio)	(this calls clone_endio)
* clone_endio
* free_tio
* bio_put(clone) - the bio is freed
now we switch back to ksoftirqd:
* tasklet_action_common calls task_unlock(t) 
* task_unlock(t) touches memory that was already freed when the bio was freed

dm-verity has a similar problem.

In order to fix this bug, I am proposing to add a new flag
TASKLET_STATE_ONESHOT. The flag indicates that the tasklet will be
submitted only once and it prevents tasklet_action_common from touching
the tasklet after the callback completed.

If you have another idea how to solve this bug, let me know.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Fixes: 5721d4e5a9cd ("dm verity: Add optional "try_verify_in_tasklet" feature")
Cc: stable@vger.kernel.org	# v5.9+

---
 drivers/md/dm-crypt.c         |    1 +
 drivers/md/dm-verity-target.c |    1 +
 include/linux/interrupt.h     |    9 ++++++++-
 kernel/softirq.c              |   22 +++++++++++++++-------
 4 files changed, 25 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2024-01-18 19:18:30.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2024-01-25 16:42:17.000000000 +0100
@@ -2265,6 +2265,7 @@ static void kcryptd_queue_crypt(struct d
 		if (in_hardirq() || irqs_disabled()) {
 			io->in_tasklet = true;
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
+			tasklet_set_oneshot(&io->tasklet);
 			tasklet_schedule(&io->tasklet);
 			return;
 		}
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h	2023-11-13 17:39:50.000000000 +0100
+++ linux-2.6/include/linux/interrupt.h	2024-01-25 16:41:52.000000000 +0100
@@ -684,7 +684,9 @@ struct tasklet_struct name = {				\
 enum
 {
 	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
-	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
+	TASKLET_STATE_ONESHOT	/* Don't unlock the tasklet after the callback
+				   to avoid writing to free memory */
 };
 
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
@@ -756,6 +758,11 @@ extern void tasklet_init(struct tasklet_
 extern void tasklet_setup(struct tasklet_struct *t,
 			  void (*callback)(struct tasklet_struct *));
 
+static inline void tasklet_set_oneshot(struct tasklet_struct *t)
+{
+	__set_bit(TASKLET_STATE_ONESHOT, &t->state);
+}
+
 /*
  * Autoprobing for irqs:
  *
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c	2023-10-31 15:31:42.000000000 +0100
+++ linux-2.6/kernel/softirq.c	2024-01-25 17:10:03.000000000 +0100
@@ -774,18 +774,26 @@ static void tasklet_action_common(struct
 
 		if (tasklet_trylock(t)) {
 			if (!atomic_read(&t->count)) {
+				/*
+				 * If oneshot is set, we must not touch the
+				 * tasklet after the callback.
+				 */
+				bool oneshot = test_bit(TASKLET_STATE_ONESHOT, &t->state);
 				if (tasklet_clear_sched(t)) {
 					if (t->use_callback) {
-						trace_tasklet_entry(t, t->callback);
-						t->callback(t);
-						trace_tasklet_exit(t, t->callback);
+						void (*callback)(struct tasklet_struct *) = t->callback;
+						trace_tasklet_entry(t, callback);
+						callback(t);
+						trace_tasklet_exit(t, callback);
 					} else {
-						trace_tasklet_entry(t, t->func);
-						t->func(t->data);
-						trace_tasklet_exit(t, t->func);
+						void (*func)(unsigned long) = t->func;
+						trace_tasklet_entry(t, func);
+						func(t->data);
+						trace_tasklet_exit(t, func);
 					}
 				}
-				tasklet_unlock(t);
+				if (!oneshot)
+					tasklet_unlock(t);
 				continue;
 			}
 			tasklet_unlock(t);
Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-01-18 19:18:30.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-01-25 18:12:09.000000000 +0100
@@ -676,6 +676,7 @@ static void verity_end_io(struct bio *bi
 
 	if (static_branch_unlikely(&use_tasklet_enabled) && io->v->use_tasklet) {
 		tasklet_init(&io->tasklet, verity_tasklet, (unsigned long)io);
+		tasklet_set_oneshot(&io->tasklet);
 		tasklet_schedule(&io->tasklet);
 	} else {
 		INIT_WORK(&io->work, verity_work);

