From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] device-mapper cluster locking
Date: Thu, 15 Apr 2010 15:01:48 -0500
Message-ID: <1271361708.2648.22.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've attached the patch for simplified cluster locking (primarily meant
for device-mapper targets - and more specifically, cluster snapshots).
The API can be found in the header file of the attached patch.  I would
appreciate some feedback on the API.  I'm particularly interested in
people's response to:
- Do you like the shorthand functions?  (e.g. dmcl_read_lock)
- Should I get rid of the shorthand or long version of the functions or
keep them both?
- Do you need the non-blocking versions of the locking functions, or
should I get rid of them entirely?
- Should I cache locks by default, and have options to the allocation
function to /not/ cache?  (right now, it is the other way around)

Note that the following things do not work yet:
- Non-blocking versions of the lock functions (although the API is
presented).
- Proper return of '0' (no-one grabbed the lock EX since we held it
last) if the user is not caching the locks.

Thanks for any comments,
 brassow

This patch introduces a cluster locking module for device-mapper
(and other) applications.  It provides nothing that you can't do
with the DLM (linux/fs/dlm).  It does try to provide a simpler
interface and expose a couple of the more powerful features of the
DLM in a simple way.  Features include:
- locking calls return 1, 0, or -EXXX; where '1' means that another
  node in the cluster has acquired the lock exclusively since the
  last time the lock was held locally.  This gives the user quick
  insight into whether any cached copies of the resource for which
  they are acquiring the lock need to be invalidated/updated.
- lock caching.  When allocating a cluster lock you can specify whether
  you want read locks or write locks cached (or both).  The release of
  cached, not-in-use locks is handled automatically.

RFC: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-cluster-locking.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-cluster-locking.c
@@ -0,0 +1,630 @@
+/*
+ * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mempool.h>
+#include <linux/workqueue.h>
+#include <linux/dlm.h>
+#include <linux/device-mapper.h>
+#include <linux/fs.h>  /* For READ/WRITE macros only */
+
+#include "dm-cluster-locking.h"
+
+#define DM_MSG_PREFIX "dm-cluster-locking"
+#define DMCL_MEMPOOL_LOCK_COUNT 32 /* Arbitrary */
+
+#define lock_val2str(x) \
+	(x == DLM_LOCK_EX) ? "DLM_LOCK_EX" : \
+	(x == DLM_LOCK_CR) ? "DLM_LOCK_CR" : \
+	(x == DLM_LOCK_NL) ? "DLM_LOCK_NL" : "UNKNOWN"
+
+#define LOCK_RETURN_VALUE(_x) (_x)->lksb.sb_status
+
+struct dmcl_lockspace {
+	struct list_head list;
+
+	char *name;
+	uint32_t name_index;
+
+	dlm_lockspace_t *lockspace;
+};
+
+struct dmcl_lockspace *dmcl_default_lockspace = NULL;
+static LIST_HEAD(lockspace_list_head);
+static DEFINE_SPINLOCK(lockspace_list_lock);
+
+struct dmcl_lock {
+	struct list_head list;
+	struct dmcl_lockspace *ls;
+
+	char *name;
+	uint32_t name_index;
+
+	uint32_t flags; /* DMCL_CACHE_[READ|WRITE]_LOCKS */
+
+	struct mutex mutex;
+	int dlm_mode;
+	int local_mode;
+	int bast_mode;  /* The mode another machine is requesting */
+
+	struct dlm_lksb lksb;
+	struct completion dlm_completion;
+
+	void (*callback)(void *data, int rtn);
+	void *callback_data;
+};
+
+struct dmcl_bast_assist_s {
+	struct list_head bast_list;
+	spinlock_t lock;
+
+	struct work_struct ws;
+};
+static struct dmcl_bast_assist_s dmcl_bast_assist;
+
+struct dmcl_lockspace *dmcl_alloc_lockspace(char *name)
+{
+	int len, r;
+	struct dmcl_lockspace *ls, *tmp;
+
+	ls = kzalloc(sizeof(*ls), GFP_KERNEL);
+	if (!ls)
+		return ERR_PTR(-ENOMEM);
+
+	len = strlen(name) + 1;
+	ls->name = kzalloc(len, GFP_KERNEL);
+	if (!ls->name) {
+		kfree(ls);
+		return ERR_PTR(-ENOMEM);
+	}
+	strcpy(ls->name, name);
+
+	/*
+	 * We allow 'name' to be any length the user wants, but
+	 * with the DLM, we can only create a lockspace with a
+	 * name that is DLM_RESNAME_MAXLEN in size.  So, we will
+	 * use the last DLM_RESNAME_MAXLEN characters given as the
+	 * lockspace name and check for conflicts.
+	 */
+	ls->name_index = (len > DLM_RESNAME_MAXLEN) ?
+		len - DLM_RESNAME_MAXLEN : 0;
+
+	spin_lock(&lockspace_list_lock);
+	list_for_each_entry(tmp, &lockspace_list_head, list)
+		if (!strcmp(tmp->name + tmp->name_index,
+			    ls->name + ls->name_index)) {
+			kfree(ls->name);
+			kfree(ls);
+
+			spin_unlock(&lockspace_list_lock);
+			return ERR_PTR(-EBUSY);
+		}
+	list_add(&ls->list, &lockspace_list_head);
+	spin_unlock(&lockspace_list_lock);
+
+	r = dlm_new_lockspace(ls->name + ls->name_index,
+			      strlen(ls->name + ls->name_index),
+			      &ls->lockspace, 0, sizeof(uint64_t));
+	if (r) {
+		DMERR("Failed to create lockspace: %s", name);
+		spin_lock(&lockspace_list_lock);
+		list_del(&ls->list);
+		spin_unlock(&lockspace_list_lock);
+		kfree(ls->name);
+		kfree(ls);
+		return ERR_PTR(r);
+	}
+
+	return ls;
+}
+EXPORT_SYMBOL(dmcl_alloc_lockspace);
+
+void dmcl_free_lockspace(struct dmcl_lockspace *ls)
+{
+	spin_lock(&lockspace_list_lock);
+	list_del(&ls->list);
+	spin_unlock(&lockspace_list_lock);
+
+	dlm_release_lockspace(ls->lockspace, 1);
+	kfree(ls->name);
+	kfree(ls);
+}
+EXPORT_SYMBOL(dmcl_free_lockspace);
+
+/*
+ * dmcl_ast_callback
+ * @context: dmcl_lock ptr
+ *
+ * This function is called asynchronously by the DLM to
+ * notify the completion of a lock operation.
+ */
+static void dmcl_ast_callback(void *context)
+{
+	struct dmcl_lock *l = context;
+
+	BUG_ON(!l);
+
+	if (!l->callback)
+		complete(&l->dlm_completion);
+	else
+		l->callback(l->callback_data, LOCK_RETURN_VALUE(l));
+
+	l->callback = NULL;
+	l->callback_data = NULL;
+}
+
+/*
+ * dmcl_bast_callback
+ * @context: dmcl_lock ptr
+ * @mode: The mode needed by another node in the cluster
+ *
+ * This function is called asynchronously by the DLM when another
+ * node in the cluster is requesting a lock in such a way that
+ * our possession of the same lock is blocking that request.  (For
+ * example, the other node may want an EX lock and we are holding/caching
+ * it as SH.
+ */
+static void dmcl_bast_callback(void *context, int mode)
+{
+	struct dmcl_lock *l = context;
+
+	l->bast_mode = mode;
+
+	spin_lock(&(dmcl_bast_assist.lock));
+	list_add(&l->list, &(dmcl_bast_assist.bast_list));
+	spin_unlock(&(dmcl_bast_assist.lock));
+
+	/* FIXME: It might be better if we had our own work queue */
+	schedule_work(&(dmcl_bast_assist.ws));
+}
+
+/*
+ * release_cached_lock
+ * @l
+ * @mode
+ *
+ * This function down-converts a lock into a mode that is compatible
+ * with 'mode'.  (E.g.  If we are caching the lock EX and the lock
+ * has been requested SH, then we must at least down-convert to SH.)
+ */
+static int release_cached_lock(struct dmcl_lock *l, int mode)
+{
+	int r;
+	int old_mode;
+
+	mutex_lock(&l->mutex);
+	old_mode = l->dlm_mode;
+
+	/*
+	 * If the local representation of the lock is not DLM_LOCK_NL,
+	 * then we must set the dlm value to DLM_LOCK_NL.  This will
+	 * force us to put the dlm lock into DLM_LOCK_NL when the lock
+	 * is locally released later.
+	 */
+	if (l->local_mode != DLM_LOCK_NL) {
+		l->dlm_mode = DLM_LOCK_NL;
+		mutex_unlock(&l->mutex);
+		return 0;
+	}
+
+	/*
+	 * If the local representation of the lock is not
+	 * held (i.e. DLM_LOCK_NL), then we can down-convert the DLM
+	 * to whatever is compatible.  If compatible, I convert the
+	 * DLM lock to DLM_LOCK_CR - this way, we still have the lock
+	 * cached for reads.  It may prove to be better to simply drop
+	 * the lock entirely though...
+	 */
+	if (mode == DLM_LOCK_EX) {
+		/* Another machine needs EX, must drop lock */
+		r = dlm_lock(l->ls->lockspace, DLM_LOCK_NL, &l->lksb,
+			     DLM_LKF_CONVERT, l->name + l->name_index,
+			     strlen(l->name + l->name_index), 0,
+			     dmcl_ast_callback, l, dmcl_bast_callback);
+		if (unlikely(r)) {
+			DMERR("Failed to convert lock \"%s\" to DLM_LOCK_NL",
+			      l->name);
+			mutex_unlock(&l->mutex);
+			return r;
+		}
+		l->dlm_mode = DLM_LOCK_NL;
+	} else if (l->dlm_mode == DLM_LOCK_EX) {
+		/* Convert the lock to SH, and it will be compatible */
+		r = dlm_lock(l->ls->lockspace, DLM_LOCK_CR, &l->lksb,
+			     DLM_LKF_CONVERT, l->name + l->name_index,
+			     strlen(l->name + l->name_index), 0,
+			     dmcl_ast_callback, l, dmcl_bast_callback);
+		if (unlikely(r)) {
+			DMERR("Failed to convert lock \"%s\" to DLM_LOCK_CR",
+			      l->name);
+			mutex_unlock(&l->mutex);
+			return r;
+		}
+		l->dlm_mode = DLM_LOCK_CR;
+	} else {
+		DMERR("LOCK SHOULD ALREADY BE COMPATIBLE!");
+		BUG();
+	}
+
+	/*
+	 * FIXME: It would be better not to wait here.  The
+	 * calling function is processing a list.  Would be
+	 * better to use an async callback to put the lock
+	 * back on the bast list and reprocess in the event
+	 * of an unlikely failure.
+	 *
+	 * This would make the mutex handling a little more
+	 * complicated, but it would probably be worth it for
+	 * performance.
+	 */
+	wait_for_completion(&l->dlm_completion);
+
+	/*
+	 * Failure of the DLM to make the conversion means the lock
+	 * is still in the state we meant to change it from.  Reset that.
+	 */
+	if (LOCK_RETURN_VALUE(l))
+		l->dlm_mode = old_mode;
+
+	mutex_unlock(&l->mutex);
+	return LOCK_RETURN_VALUE(l);
+}
+
+/*
+ * dmcl_bast_process_requests
+ * @work
+ *
+ * This function processes the outstanding requests to release
+ * locks that we may have cached.
+ */
+static void dmcl_process_bast_requests(struct work_struct *work)
+{
+	int r, wake = 0;
+	LIST_HEAD(l);
+	struct dmcl_lock *lock, *tmp;
+	struct dmcl_bast_assist_s *bast_assist;
+
+	bast_assist = container_of(work, struct dmcl_bast_assist_s, ws);
+
+	spin_lock(&bast_assist->lock);
+	list_splice_init(&bast_assist->bast_list, &l);
+	spin_unlock(&bast_assist->lock);
+
+	list_for_each_entry_safe(lock, tmp, &l, list) {
+		r = release_cached_lock(lock, lock->bast_mode);
+		if (r) {
+			DMERR("Failed to complete 'bast' request on %s/%s",
+			      lock->ls->name, lock->name);
+
+			/*
+			 * Leave the lock on the list so we can attempt
+			 * to unlock it again later.
+			 */
+			wake = 1;
+			continue;
+		}
+		lock->bast_mode = 0;
+		list_del(&lock->list);
+	}
+
+	if (wake)
+		schedule_work(&bast_assist->ws);
+}
+
+static struct dmcl_lock *_allocate_lock(struct dmcl_lockspace *ls,
+					const char *lock_name, uint64_t flags)
+{
+	size_t len = strlen(lock_name);
+	struct dmcl_lock *new;
+
+	if (!ls) {
+		DMERR("No valid lockspace given!");
+		return NULL;
+	}
+
+	new = kzalloc(sizeof(*new), GFP_NOIO);
+	if (!new)
+		return NULL;
+
+	new->name = kzalloc(len + 1, GFP_NOIO);
+	if (!new->name) {
+		kfree(new);
+		return NULL;
+	}
+
+	INIT_LIST_HEAD(&new->list);
+	new->ls = ls;
+
+	strcpy(new->name, lock_name);
+	new->name_index = (len > DLM_RESNAME_MAXLEN) ?
+		len - DLM_RESNAME_MAXLEN : 0;
+
+	new->flags = flags;
+
+	mutex_init(&new->mutex);
+	new->dlm_mode = DLM_LOCK_NL;
+	new->local_mode = DLM_LOCK_NL;
+	init_completion(&new->dlm_completion);
+
+	return new;
+}
+
+struct dmcl_lock *dmcl_alloc_lock_via_lockspace(struct dmcl_lockspace *ls,
+						const char *lock_name,
+						uint64_t flags)
+{
+	int r;
+	struct dmcl_lock *l;
+
+	if (!ls) {
+		if (unlikely(!dmcl_default_lockspace)) {
+			ls = dmcl_alloc_lockspace(DM_MSG_PREFIX);
+			if (IS_ERR(ls))
+				return (void *)ls;
+			dmcl_default_lockspace = ls;
+		}
+		ls = dmcl_default_lockspace;
+	}
+	l = _allocate_lock(ls, lock_name, flags);
+	if (!l)
+		return ERR_PTR(-ENOMEM);
+
+	r = dlm_lock(ls->lockspace, DLM_LOCK_NL, &l->lksb, DLM_LKF_EXPEDITE,
+		     l->name + l->name_index, strlen(l->name + l->name_index),
+		     0, dmcl_ast_callback, l, dmcl_bast_callback);
+	if (r) {
+		DMERR("dlm_lock failure: %d", r);
+		return ERR_PTR(r);
+	}
+
+	wait_for_completion(&l->dlm_completion);
+	r = LOCK_RETURN_VALUE(l);
+	if (r) {
+		DMERR("Asynchronous dlm_lock failure: %d", r);
+		return ERR_PTR(r);
+	}
+	return l;
+}
+EXPORT_SYMBOL(dmcl_alloc_lock_via_lockspace);
+
+struct dmcl_lock *dmcl_alloc_lock(const char *lock_name, uint64_t flags)
+{
+	return dmcl_alloc_lock_via_lockspace(NULL, lock_name, flags);
+}
+EXPORT_SYMBOL(dmcl_alloc_lock);
+
+void dmcl_free_lock(struct dmcl_lock *l)
+{
+	int r;
+
+	BUG_ON(l->local_mode != DLM_LOCK_NL);
+
+	/*
+	 * Free all DLM lock structures.  Doesn't matter if the
+	 * dlm_mode is DLM_LOCK_NL, DLM_LOCK_CR, or DLM_LOCK_EX
+	 */
+	r = dlm_unlock(l->ls->lockspace, l->lksb.sb_lkid,
+		       DLM_LKF_FORCEUNLOCK, NULL, l);
+
+	/* Force release should never fail */
+	BUG_ON(r);
+
+	wait_for_completion(&l->dlm_completion);
+	if (LOCK_RETURN_VALUE(l) != -DLM_EUNLOCK)
+		DMERR("dlm_unlock failed on %s/%s: %d",
+		      l->ls->name, l->name, LOCK_RETURN_VALUE(l));
+
+	kfree(l->name);
+	kfree(l);
+}
+EXPORT_SYMBOL(dmcl_free_lock);
+
+/*
+ * FIXME: non-blocking version not complete... not setting modes till end
+ */
+static int _dmcl_lock(struct dmcl_lock *l, int rw,
+		      void (*callback)(void *data, int rtn), void *data)
+{
+	int r;
+	int mode;
+
+	if ((rw != WRITE) && (rw != READ)) {
+		DMERR("Lock attempt where mode != READ/WRITE");
+		BUG();
+	}
+	mode = (rw == WRITE) ? DLM_LOCK_EX : DLM_LOCK_CR;
+
+	if (l->local_mode != DLM_LOCK_NL) {
+		DMERR("Locks cannot be acquired multiple times");
+		BUG();
+	}
+
+	mutex_lock(&l->mutex);
+	/*
+	 * Is the lock already cached in the needed state?
+	 */
+	if (mode == l->dlm_mode) {
+		l->local_mode = mode;
+
+		if (callback)
+			callback(data, 0);
+		mutex_unlock(&l->mutex);
+		return 0;
+	}
+
+	l->callback = callback;
+	l->callback_data = data;
+
+	/*
+	 * At this point local_mode is DLM_LOCK_NL.  Given that the DLM
+	 * lock can be cached, we can have any of the following:
+	 * dlm_mode	(desired) mode	solution
+	 * ========	====		========
+	 * DLM_LOCK_NL	DLM_LOCK_CR	direct convert
+	 * DLM_LOCK_NL	DLM_LOCK_EX	direct convert
+	 * DLM_LOCK_CR	DLM_LOCK_CR	returned already
+	 * DLM_LOCK_CR	DLM_LOCK_EX	first convert to DLM_LOCK_NL
+	 * DLM_LOCK_EX	DLM_LOCK_CR	direct convert
+	 * DLM_LOCK_EX	DLM_LOCK_EX    	returned already
+	 */
+	if (l->dlm_mode == DLM_LOCK_CR) {
+		r = dlm_lock(l->ls->lockspace, DLM_LOCK_NL, &l->lksb,
+			     DLM_LKF_CONVERT, l->name + l->name_index,
+			     strlen(l->name + l->name_index),
+			     0, dmcl_ast_callback, l, dmcl_bast_callback);
+		if (r) {
+			DMERR("Failed CR->NL convertion for lock %s",
+			      l->name);
+			mutex_unlock(&l->mutex);
+			return r;
+		}
+	}
+	r = dlm_lock(l->ls->lockspace, mode, &l->lksb, DLM_LKF_CONVERT,
+		     l->name + l->name_index, strlen(l->name + l->name_index),
+		     0, dmcl_ast_callback, l, dmcl_bast_callback);
+	if (r) {
+		DMERR("Failed to issue DLM lock operation: %d", r);
+		mutex_unlock(&l->mutex);
+		return r;
+	}
+
+	if (l && !l->callback) {
+		wait_for_completion(&l->dlm_completion);
+		r = LOCK_RETURN_VALUE(l);
+		if (r) {
+			DMERR("DLM lock operation failed: %d", r);
+			return r;
+		}
+	}
+
+	l->local_mode = mode;
+	l->dlm_mode = mode;
+
+	mutex_unlock(&l->mutex);
+
+	return 0;
+}
+
+int dmcl_lock(struct dmcl_lock *l, int rw)
+{
+	return _dmcl_lock(l, rw, NULL, NULL);
+}
+EXPORT_SYMBOL(dmcl_lock);
+
+int dmcl_read_lock(struct dmcl_lock *l)
+{
+	return dmcl_lock(l, READ);
+}
+EXPORT_SYMBOL(dmcl_read_lock);
+
+int dmcl_write_lock(struct dmcl_lock *l)
+{
+	return dmcl_lock(l, WRITE);
+}
+EXPORT_SYMBOL(dmcl_write_lock);
+
+int dmcl_lock_non_blocking(struct dmcl_lock *l, int rw,
+			   void (*callback)(void *data, int rtn), void *data)
+{
+	/* FIXME: Sorry non-block version not finished/untested */
+	return -ENOSYS;
+	return _dmcl_lock(l, rw, callback, data);
+}
+EXPORT_SYMBOL(dmcl_lock_non_blocking);
+
+/*
+ * may block
+ */
+int dmcl_unlock(struct dmcl_lock *l)
+{
+	int r = 0;
+
+	mutex_lock(&l->mutex);
+
+	if (l->local_mode == DLM_LOCK_NL) {
+		DMERR("FATAL:  Lock %s/%s is already unlocked",
+		      l->ls->name, l->name);
+
+		/*
+		 * If you are hitting this bug, it is likely you have made
+		 * one of the two following mistakes:
+		 * 1) You have two locks with the same name in your lockspace
+		 * 2) You have unlocked the same lock twice in a row
+		 */
+		BUG();
+	}
+
+	l->local_mode = DLM_LOCK_NL;
+
+	if ((l->dlm_mode == DLM_LOCK_EX) && (l->flags & DMCL_CACHE_WRITE_LOCKS))
+		goto out;
+
+	if ((l->dlm_mode == DLM_LOCK_CR) && (l->flags & DMCL_CACHE_READ_LOCKS))
+		goto out;
+
+	/*
+	 * If no caching has been specified or the DLM lock is needed
+	 * elsewhere (indicated by dlm_mode == DLM_LOCK_NL), then
+	 * we immediately put the lock into a non-conflicting state.
+	 */
+	r = dlm_lock(l->ls->lockspace, DLM_LOCK_NL, &l->lksb, DLM_LKF_CONVERT,
+		     l->name + l->name_index, strlen(l->name + l->name_index),
+		     0, dmcl_ast_callback, l, dmcl_bast_callback);
+	if (r)
+		goto fail;
+
+	wait_for_completion(&l->dlm_completion);
+	r = LOCK_RETURN_VALUE(l);
+
+	if (r)
+		goto fail;
+
+	l->dlm_mode = DLM_LOCK_NL;
+
+out:
+	mutex_unlock(&l->mutex);
+	return 0;
+
+fail:
+	DMERR("dlm_lock conversion of %s/%s failed: %d",
+	      l->ls->name, l->name, r);
+	mutex_unlock(&l->mutex);
+	return r;
+}
+EXPORT_SYMBOL(dmcl_unlock);
+
+static int __init dm_cluster_lock_module_init(void)
+{
+	INIT_LIST_HEAD(&(dmcl_bast_assist.bast_list));
+	spin_lock_init(&(dmcl_bast_assist.lock));
+	INIT_WORK(&(dmcl_bast_assist.ws), dmcl_process_bast_requests);
+
+	dmcl_default_lockspace = dmcl_alloc_lockspace(DM_MSG_PREFIX);
+	if (IS_ERR(dmcl_default_lockspace)) {
+		if (PTR_ERR(dmcl_default_lockspace) == -ENOTCONN) {
+			DMWARN("DLM not ready yet.  Delaying initialization.");
+			dmcl_default_lockspace = NULL;
+		} else {
+			DMERR("Failed to create default lockspace: %d",
+			      (int)PTR_ERR(dmcl_default_lockspace));
+			return PTR_ERR(dmcl_default_lockspace);
+		}
+	}
+
+	return 0;
+}
+
+static void __exit dm_cluster_lock_module_exit(void)
+{
+	dmcl_free_lockspace(dmcl_default_lockspace);
+}
+
+module_init(dm_cluster_lock_module_init);
+module_exit(dm_cluster_lock_module_exit);
+
+MODULE_DESCRIPTION("DM Cluster Locking module");
+MODULE_AUTHOR("Jonathan Brassow");
+MODULE_LICENSE("GPL");
Index: linux-2.6/drivers/md/Kconfig
===================================================================
--- linux-2.6.orig/drivers/md/Kconfig
+++ linux-2.6/drivers/md/Kconfig
@@ -319,4 +319,13 @@ config DM_UEVENT
 	---help---
 	Generate udev events for DM events.
 
+config DM_CLUSTER_LOCKING
+	tristate "DM Cluster Locking module (EXPERIMENTAL)"
+	select DLM
+	---help---
+	The DM Cluster Locking module provides a simple set of
+	cluster locking commands.  It is a wrapper around the
+	more versatile (but more complex) DLM - which is also
+	found in the kernel.
+
 endif # MD
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_CLUSTER_LOCKING) += dm-cluster-locking.o
 
 quiet_cmd_unroll = UNROLL  $@
       cmd_unroll = $(AWK) -f$(srctree)/$(src)/unroll.awk -vN=$(UNROLL) \
Index: linux-2.6/drivers/md/dm-cluster-locking.h
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-cluster-locking.h
@@ -0,0 +1,146 @@
+/*
+ * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
+ *
+ * This file is released under the GPL.
+ */
+#ifndef __DM_CLUSTER_LOCKING_DOT_H__
+#define __DM_CLUSTER_LOCKING_DOT_H__
+
+#define DMCL_CACHE_READ_LOCKS  1
+#define DMCL_CACHE_WRITE_LOCKS 2
+
+struct dmcl_lockspace;
+struct dmcl_lock;
+
+/**
+ * dmcl_alloc_lockspace
+ * @uuid: The unique cluster-wide name given to this lockspace
+ *
+ * Create a new lockspace.  There is a default lockspace that is
+ * adequate for most situations - making this function unnecessary
+ * for most users.  Create a new lockspace if the names associated
+ * with the locks you are creating are generic and have the potential
+ * to overlap/conflict with other lock users.
+ *
+ * Returns: handle pointer on success, ERR_PTR(-EXXX) on failure
+ **/
+struct dmcl_lockspace *dmcl_alloc_lockspace(char *uuid);
+
+/**
+ * dmcl_free_lockspace
+ * @h: The handle returned from dm_cluster_lock_init
+ **/
+void dmcl_free_lockspace(struct dmcl_lockspace *ls);
+
+/**
+ * dmcl_alloc_lock_via_lockspace
+ * @ls: lockspace ptr gotten from 'dmcl_alloc_lockspace'
+ * @name: Unique cluster-wide name for lock
+ * @flags: DMCL_CACHE_READ_LOCKS | DMCL_CACHE_WRITE_LOCKS
+ *
+ * Allocate and initialize a new lock from the specified
+ * lockspace.  If the given lockspace - 'ls' - is NULL, then
+ * a default lockspace is used.
+ *
+ * Returns: ptr or ERR_PTR
+ **/
+struct dmcl_lock *dmcl_alloc_lock_via_lockspace(struct dmcl_lockspace *ls,
+						const char *lock_name,
+						uint64_t flags);
+
+/**
+ * dmcl_alloc_lock
+ * @name: Unique cluster-wide name for lock
+ * @flags: DMCL_CACHE_READ_LOCKS | DMCL_CACHE_WRITE_LOCKS
+ *
+ * Shorthand for 'dmcl_alloc_lock_via_lockspace(NULL, name, flags)'
+ *
+ * Returns: ptr or ERR_PTR
+ **/
+struct dmcl_lock *dmcl_alloc_lock(const char *name, uint64_t flags);
+
+/**
+ * dmcl_free_lock
+ * @l
+ *
+ * Free all associated memory for the given lock and sever
+ * all ties with the DLM.
+ **/
+void dmcl_free_lock(struct dmcl_lock *l);
+
+/**
+ * dmcl_lock
+ * @l
+ * @rw: specify READ or WRITE lock
+ *
+ * Acquire a lock READ/SHARED or WRITE/EXCLUSIVE.  Specify the
+ * distinction with the common 'READ' or 'WRITE' macros. Possible
+ * return values are:
+ *	1: The lock was acquired successfully /and/ the lock was
+ *	   granted in WRITE/EXLUSIVE mode to another machine since
+ *	   the last time the lock was held locally.
+ *	   Useful for determining the validity of a cached resource
+ *	   that is protected by the lock.
+ *	0: The lock was acquired successfully and no other machine
+ *	   had acquired the lock WRITE/EXCLUSIVE since the last time
+ *	   the lock was acquired.
+ *	-EXXX: Error acquiring the lock.
+ *
+ * Returns: 1, 0, -EXXX
+ **/
+int dmcl_lock(struct dmcl_lock *l, int rw);
+
+/**
+ * dmcl_read_lock
+ * @l
+ *
+ * Shorthand for dmcl_lock(l, READ)
+ *
+ * Returns: 1, 0, -EXXX
+ **/
+int dmcl_read_lock(struct dmcl_lock *l);
+
+/**
+ * dmcl_write_lock
+ * @l
+ *
+ * Shorthand for dmcl_lock(l, WRITE)
+ *
+ * Returns: 1, 0, -EXXX
+ **/
+int dmcl_write_lock(struct dmcl_lock *l);
+
+/**
+ * dmcl_lock_non_blocking
+ * @l
+ * @rw
+ * @callback: Function to call when lock operation is complete
+ * @data: User provided data to be included in the callback
+ *
+ * This function is the same as dmcl_lock, but it will not
+ * block.  Instead, the provided callback is used to notify
+ * the calling process asynchornously when the lock operation
+ * is complete.  The status of the lock operation is returned via
+ * the 'rtn' argument to the callback function.  The callback's
+ * 'rtn' argument will be the same as the return for the blocking
+ * lock operations: 1, 0, or -EXXX.
+ *
+ * Returns: 0, -EXXX
+ **/
+int dmcl_lock_non_blocking(struct dmcl_lock *l, int rw,
+			   void (*callback)(void *data, int rtn), void *data);
+/**
+ * dmcl_unlock
+ * @l
+ *
+ * Unlock a lock.  Whether the lock is continued to be held with
+ * respect to the DLM ("cached" unless needed by another machine),
+ * is determined by the flags used during the allocation of the
+ * lock.  It is possible that this action fail if the DLM fails
+ * to release the lock as needed.  This function may block.
+ *
+ * Returns: 0, -EXXX
+ **/
+int dmcl_unlock(struct dmcl_lock *l);
+
+#endif /* __DM_CLUSTER_LOCKING_DOT_H__ */
