From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 4/4] dm: convert table_device.count from atomic_t to
 refcount_t
Date: Thu, 23 Nov 2017 16:19:21 +0100
Message-ID: <92f8c04f-ef1a-c41b-e82f-8d68a3ec84b5@redhat.com>
References: <1508485059-21881-1-git-send-email-elena.reshetova@intel.com>
 <1508485059-21881-5-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1508485059-21881-5-git-send-email-elena.reshetova@intel.com>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Elena Reshetova <elena.reshetova@intel.com>, dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, kent.overstreet@gmail.com, koverstreet@google.com, ejt@redhat.com, snitzer@redhat.com, shli@kernel.org, agk@redhat.com, peterz@infradead.org, keescook@chromium.org
List-Id: dm-devel.ids

Dne 20.10.2017 v 09:37 Elena Reshetova napsal(a):
> atomic_t variables are currently used to implement reference
> counters with the following properties:
>   - counter is initialized to 1 using atomic_set()
>   - a resource is freed upon counter reaching zero
>   - once counter reaches zero, its further
>     increments aren't allowed
>   - counter schema uses basic atomic operations
>     (set, inc, inc_not_zero, dec_and_test, etc.)
> 
> Such atomic variables should be converted to a newly provided
> refcount_t type and API that prevents accidental counter overflows
> and underflows. This is important since overflows and underflows
> can lead to use-after-free situation and be exploitable.
> 
> The variable table_device.count is used as pure reference counter.
> Convert it to refcount_t and fix up the operations.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: David Windsor <dwindsor@gmail.com>
> Reviewed-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>   drivers/md/dm.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 4be8532..be12f3f 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -24,6 +24,7 @@
>   #include <linux/delay.h>
>   #include <linux/wait.h>
>   #include <linux/pr.h>
> +#include <linux/refcount.h>
>   
>   #define DM_MSG_PREFIX "core"
>   
> @@ -98,7 +99,7 @@ struct dm_md_mempools {
>   
>   struct table_device {
>   	struct list_head list;
> -	atomic_t count;
> +	refcount_t count;
>   	struct dm_dev dm_dev;
>   };
>   
> @@ -685,10 +686,11 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
>   
>   		format_dev_t(td->dm_dev.name, dev);
>   
> -		atomic_set(&td->count, 0);
> +		refcount_set(&td->count, 1);
>   		list_add(&td->list, &md->table_devices);
> +	} else {
> +		refcount_inc(&td->count);
>   	}
> -	atomic_inc(&td->count);
>   	mutex_unlock(&md->table_devices_lock);
>   


NACK

This patch (2a0b4682e09d76466f7b8f5e347ae2ff02f033af) currently breaks 
accounting of opened devices.

I.e.   multisegment device  (target with 3 segments is not properly accounted)


Patch needs reworking and users of 'dm' and 4.15-rc0 kernel should rather 
switch back to 4.14 ATM as it's unclear which other parts can be affected.

Zdenek

>   	*result = &td->dm_dev;
> @@ -701,7 +703,7 @@ void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
>   	struct table_device *td = container_of(d, struct table_device, dm_dev);
>   
>   	mutex_lock(&md->table_devices_lock);
> -	if (atomic_dec_and_test(&td->count)) {
> +	if (refcount_dec_and_test(&td->count)) {
>   		close_table_device(td, md);
>   		list_del(&td->list);
>   		kfree(td);
> @@ -718,7 +720,7 @@ static void free_table_devices(struct list_head *devices)
>   		struct table_device *td = list_entry(tmp, struct table_device, list);
>   
>   		DMWARN("dm_destroy: %s still exists with %d references",
> -		       td->dm_dev.name, atomic_read(&td->count));
> +		       td->dm_dev.name, refcount_read(&td->count));
>   		kfree(td);
>   	}
>   }
> 
