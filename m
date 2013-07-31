From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH] dm-lc.c: Audit return values of functions
 invoked in module init routine
Date: Wed, 31 Jul 2013 17:09:52 +0900
Message-ID: <51F8C650.4080200@gmail.com>
References: <1375212580-6934-1-git-send-email-gmate.amit@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1375212580-6934-1-git-send-email-gmate.amit@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kumar Amit Mehta <gmate.amit@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Thanks for your patch, Kumar.

First of all, the code got clean
by reordering the initialization calls.
I fully agree with your patch at this point.
Thanks for your work.

But, I think there are a mistake to fix
before applying the patch.

What if registering lc_mgr_target failed
after registering lc_target succeeded?
I think we should unregister the lc_target in this case.
Am I wrong?

Looking for some code samples,
dm-snap.c and dm-thin.c have more than two targets to register
like dm-lc does.

Below is a code fragment from dm-snap.c .
It treats each failure in registering targets
independently with different labels.

// dm-snap.c
bad_exception_cache:
        exit_origin_hash();
bad_origin_hash:
        dm_unregister_target(&merge_target);
bad_register_merge_target:
        dm_unregister_target(&origin_target);
bad_register_origin_target:
        dm_unregister_target(&snapshot_target);
bad_register_snapshot_target:
        dm_exception_store_exit();

        return r;
}

Could you please fix this problem
and resend the patch again?
In addition, please rename the labels
from fail_ to bad_ .
The prefix bad_ seems to be the
code convention in device-mapper.

Akira

On 7/31/13 4:29 AM, Kumar Amit Mehta wrote:
> Add missing checks for values returned by various functions for
> graceful exit in the event of failure.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  Driver/dm-lc.c | 60 +++++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/Driver/dm-lc.c b/Driver/dm-lc.c
> index 9d394ee..3ac7173 100644
> --- a/Driver/dm-lc.c
> +++ b/Driver/dm-lc.c
> @@ -2959,14 +2959,7 @@ static struct target_type lc_mgr_target = {
>  
>  static int __init lc_module_init(void)
>  {
> -	int r;
> -
> -	safe_io_wq = alloc_workqueue("safeiowq",
> -				     WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
> -	if (!safe_io_wq)
> -		return -ENOMEM;
> -
> -	lc_io_client = dm_io_client_create();
> +	int r = -ENOMEM;
>  
>  	r = dm_register_target(&lc_target);
>  	if (r < 0) {
> @@ -2980,15 +2973,6 @@ static int __init lc_module_init(void)
>  		return r;
>  	}
>  
> -	cache_id_ptr = 0;
> -
> -	size_t i;
> -	for (i = 0; i < LC_NR_SLOTS; i++)
> -		lc_devices[i] = NULL;
> -
> -	for (i = 0; i < LC_NR_SLOTS; i++)
> -		lc_caches[i] = NULL;
> -
>  	/*
>  	 * /sys/module/dm_lc/devices
>  	 *                  /caches
> @@ -2996,10 +2980,52 @@ static int __init lc_module_init(void)
>  
>  	struct module *mod = THIS_MODULE;
>  	struct kobject *lc_kobj = &(mod->mkobj.kobj);
> +
>  	devices_kobj = kobject_create_and_add("devices", lc_kobj);
> +	if (!devices_kobj)
> +		goto fail_kobj_devices;
> +
>  	caches_kobj = kobject_create_and_add("caches", lc_kobj);
> +	if (!caches_kobj)
> +		goto fail_kobj_caches;
> +
> +	safe_io_wq = alloc_workqueue("safeiowq",
> +				     WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
> +	if (!safe_io_wq) {
> +		DMERR("failed to create workqueue safeiowq");
> +		goto fail_wq;
> +	}
> +
> +	lc_io_client = dm_io_client_create();
> +	if (IS_ERR(lc_io_client)) {
> +		r = PTR_ERR(lc_io_client);
> +		goto fail_io_client;
> +	}
> +
> +	cache_id_ptr = 0;
> +
> +	size_t i;
> +	for (i = 0; i < LC_NR_SLOTS; i++)
> +		lc_devices[i] = NULL;
> +
> +	for (i = 0; i < LC_NR_SLOTS; i++)
> +		lc_caches[i] = NULL;
>  
>  	return 0;
> +
> +fail_io_client:
> +	destroy_workqueue(safe_io_wq);
> +
> +fail_wq:
> +	kobject_put(caches_kobj);
> +
> +fail_kobj_caches:
> +	kobject_put(devices_kobj);
> +
> +fail_kobj_devices:
> +	dm_unregister_target(&lc_mgr_target);
> +	dm_unregister_target(&lc_target);
> +	return ERR_PTR(r);
>  }
>  
>  static void __exit lc_module_exit(void)
> 
