From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH v5 05/11] fs: add security blob and hooks for
 block_device
Date: Tue, 28 Jul 2020 15:22:59 -0700
Message-ID: <ef0fff6f-410a-6444-f1e3-03499a2f52b7@schaufler-ca.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
 <20200728213614.586312-6-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200728213614.586312-6-deven.desai@linux.microsoft.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Deven Bowers <deven.desai@linux.microsoft.com>, agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, viro@zeniv.linux.org.uk, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com
Cc: tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com, pasha.tatashin@soleen.com, Casey Schaufler <casey@schaufler-ca.com>
List-Id: dm-devel.ids

On 7/28/2020 2:36 PM, Deven Bowers wrote:
> Add a security blob and associated allocation, deallocation and set hooks
> for a block_device structure.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> ---
>  fs/block_dev.c                |  8 ++++
>  include/linux/fs.h            |  1 +
>  include/linux/lsm_hook_defs.h |  5 +++
>  include/linux/lsm_hooks.h     | 12 ++++++
>  include/linux/security.h      | 22 +++++++++++
>  security/security.c           | 74 +++++++++++++++++++++++++++++++++++
>  6 files changed, 122 insertions(+)
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 0ae656e022fd..8602dd62c3e2 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -34,6 +34,7 @@
>  #include <linux/falloc.h>
>  #include <linux/uaccess.h>
>  #include <linux/suspend.h>
> +#include <linux/security.h>
>  #include "internal.h"
>  
>  struct bdev_inode {
> @@ -768,11 +769,18 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
>  	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
>  	if (!ei)
>  		return NULL;
> +
> +	if (unlikely(security_bdev_alloc(&ei->bdev))) {
> +		kmem_cache_free(bdev_cachep, ei);
> +		return NULL;
> +	}
> +
>  	return &ei->vfs_inode;
>  }
>  
>  static void bdev_free_inode(struct inode *inode)
>  {
> +	security_bdev_free(&BDEV_I(inode)->bdev);
>  	kmem_cache_free(bdev_cachep, BDEV_I(inode));
>  }
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f5abba86107d..42d7e3ce7712 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -509,6 +509,7 @@ struct block_device {
>  	int			bd_fsfreeze_count;
>  	/* Mutex for freeze */
>  	struct mutex		bd_fsfreeze_mutex;
> +	void			*security;
>  } __randomize_layout;
>  
>  /* XArray tags, for tagging dirty and writeback pages in the pagecache. */
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index af998f93d256..f3c0da0db4e8 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -391,3 +391,8 @@ LSM_HOOK(void, LSM_RET_VOID, perf_event_free, struct perf_event *event)
>  LSM_HOOK(int, 0, perf_event_read, struct perf_event *event)
>  LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>  #endif /* CONFIG_PERF_EVENTS */
> +
> +LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
> +LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
> +LSM_HOOK(int, 0, bdev_setsecurity, struct block_device *bdev, const char *name,
> +	 const void *value, size_t size)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 95b7c1d32062..8670c19a8cef 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1507,6 +1507,17 @@
>   *
>   *     @what: kernel feature being accessed
>   *
> + * @bdev_alloc_security:
> + *	Initialize the security field inside a block_device structure.
> + *
> + * @bdev_free_security:
> + *	Cleanup the security information stored inside a block_device structure.
> + *
> + * @bdev_setsecurity:
> + *	Set a security property associated with @name for @bdev with
> + *	value @value. @size indicates the size of @value in bytes.
> + *	If a @name is not implemented, return -ENOSYS.
> + *
>   * Security hooks for perf events
>   *
>   * @perf_event_open:
> @@ -1553,6 +1564,7 @@ struct lsm_blob_sizes {
>  	int	lbs_ipc;
>  	int	lbs_msg_msg;
>  	int	lbs_task;
> +	int	lbs_bdev;
>  };
>  
>  /*
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 0a0a03b36a3b..8f83fdc6c65d 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -451,6 +451,11 @@ int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
>  int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
>  int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
>  int security_locked_down(enum lockdown_reason what);
> +int security_bdev_alloc(struct block_device *bdev);
> +void security_bdev_free(struct block_device *bdev);
> +int security_bdev_setsecurity(struct block_device *bdev,
> +			      const char *name, const void *value,
> +			      size_t size);
>  #else /* CONFIG_SECURITY */
>  
>  static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
> @@ -1291,6 +1296,23 @@ static inline int security_locked_down(enum lockdown_reason what)
>  {
>  	return 0;
>  }
> +
> +static inline int security_bdev_alloc(struct block_device *bdev)
> +{
> +	return 0;
> +}
> +
> +static inline void security_bdev_free(struct block_device *bdev)
> +{
> +}
> +
> +static inline int security_bdev_setsecurity(struct block_device *bdev,
> +					    const char *name,
> +					    const void *value, size_t size)
> +{
> +	return 0;
> +}
> +
>  #endif	/* CONFIG_SECURITY */
>  
>  #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)
> diff --git a/security/security.c b/security/security.c
> index 70a7ad357bc6..fff445eba400 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -28,6 +28,7 @@
>  #include <linux/string.h>
>  #include <linux/msg.h>
>  #include <net/flow.h>
> +#include <linux/fs.h>
>  
>  #define MAX_LSM_EVM_XATTR	2
>  
> @@ -202,6 +203,7 @@ static void __init lsm_set_blob_sizes(struct lsm_blob_sizes *needed)
>  	lsm_set_blob_size(&needed->lbs_ipc, &blob_sizes.lbs_ipc);
>  	lsm_set_blob_size(&needed->lbs_msg_msg, &blob_sizes.lbs_msg_msg);
>  	lsm_set_blob_size(&needed->lbs_task, &blob_sizes.lbs_task);
> +	lsm_set_blob_size(&needed->lbs_bdev, &blob_sizes.lbs_bdev);
>  }
>  
>  /* Prepare LSM for initialization. */
> @@ -337,6 +339,7 @@ static void __init ordered_lsm_init(void)
>  	init_debug("ipc blob size      = %d\n", blob_sizes.lbs_ipc);
>  	init_debug("msg_msg blob size  = %d\n", blob_sizes.lbs_msg_msg);
>  	init_debug("task blob size     = %d\n", blob_sizes.lbs_task);
> +	init_debug("bdev blob size     = %d\n", blob_sizes.lbs_bdev);
>  
>  	/*
>  	 * Create any kmem_caches needed for blobs
> @@ -654,6 +657,28 @@ static int lsm_msg_msg_alloc(struct msg_msg *mp)
>  	return 0;
>  }
>  
> +/**
> + * lsm_bdev_alloc - allocate a composite block_device blob
> + * @bdev: the block_device that needs a blob
> + *
> + * Allocate the block_device blob for all the modules
> + *
> + * Returns 0, or -ENOMEM if memory can't be allocated.
> + */
> +static int lsm_bdev_alloc(struct block_device *bdev)
> +{
> +	if (blob_sizes.lbs_bdev == 0) {
> +		bdev->security = NULL;
> +		return 0;
> +	}
> +
> +	bdev->security = kzalloc(blob_sizes.lbs_bdev, GFP_KERNEL);
> +	if (!bdev->security)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>  /**
>   * lsm_early_task - during initialization allocate a composite task blob
>   * @task: the task that needs a blob
> @@ -2516,6 +2541,55 @@ int security_locked_down(enum lockdown_reason what)
>  }
>  EXPORT_SYMBOL(security_locked_down);
>  
> +int security_bdev_alloc(struct block_device *bdev)
> +{
> +	int rc = 0;
> +
> +	rc = lsm_bdev_alloc(bdev);
> +	if (unlikely(rc))
> +		return rc;
> +
> +	rc = call_int_hook(bdev_alloc_security, 0, bdev);
> +	if (unlikely(rc))
> +		security_bdev_free(bdev);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(security_bdev_alloc);
> +
> +void security_bdev_free(struct block_device *bdev)
> +{
> +	if (!bdev->security)
> +		return;
> +
> +	call_void_hook(bdev_free_security, bdev);
> +
> +	kfree(bdev->security);
> +	bdev->security = NULL;
> +}
> +EXPORT_SYMBOL(security_bdev_free);
> +
> +int security_bdev_setsecurity(struct block_device *bdev,
> +			      const char *name, const void *value,
> +			      size_t size)
> +{
> +	int rc = 0;
> +	struct security_hook_list *p;
> +
> +	hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, list) {
> +		rc = p->hook.bdev_setsecurity(bdev, name, value, size);
> +
> +		if (rc == -ENOSYS)
> +			rc = 0;
> +
> +		if (rc != 0)

Perhaps:
		else if (rc != 0)

> +			break;
> +	}
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(security_bdev_setsecurity);
> +
>  #ifdef CONFIG_PERF_EVENTS
>  int security_perf_event_open(struct perf_event_attr *attr, int type)
>  {
