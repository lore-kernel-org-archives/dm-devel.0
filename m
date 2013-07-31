From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH v2] dm-lc.c: Audit return values of functions
 invoked in module init routine
Date: Wed, 31 Jul 2013 19:03:04 +0900
Message-ID: <51F8E0D8.7050706@gmail.com>
References: <1375261784-9030-1-git-send-email-gmate.amit@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1375261784-9030-1-git-send-email-gmate.amit@gmail.com>
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

Thanks, Kumar.
The patch is fine now, applied.

Akira

On 7/31/13 6:09 PM, Kumar Amit Mehta wrote:
> Add missing checks for values returned by various functions for
> graceful exit in the event of failure.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
> ---
>  Driver/dm-lc.c | 61 +++++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 43 insertions(+), 18 deletions(-)
> 
> diff --git a/Driver/dm-lc.c b/Driver/dm-lc.c
> index 6644115..4a65042 100644
> --- a/Driver/dm-lc.c
> +++ b/Driver/dm-lc.c
> @@ -2924,14 +2924,7 @@ static struct target_type lc_mgr_target = {
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
> @@ -2942,18 +2935,9 @@ static int __init lc_module_init(void)
>  	r = dm_register_target(&lc_mgr_target);
>  	if (r < 0) {
>  		DMERR("register lc-mgr failed %d", r);
> -		return r;
> +		goto bad_register_mgr_target;
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
> @@ -2961,10 +2945,51 @@ static int __init lc_module_init(void)
>  
>  	struct module *mod = THIS_MODULE;
>  	struct kobject *lc_kobj = &(mod->mkobj.kobj);
> +
>  	devices_kobj = kobject_create_and_add("devices", lc_kobj);
> +	if (!devices_kobj)
> +		goto bad_kobj_devices;
> +
>  	caches_kobj = kobject_create_and_add("caches", lc_kobj);
> +	if (!caches_kobj)
> +		goto bad_kobj_caches;
> +
> +	safe_io_wq = alloc_workqueue("safeiowq",
> +				     WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
> +	if (!safe_io_wq) {
> +		DMERR("failed to create workqueue safeiowq");
> +		goto bad_wq;
> +	}
> +
> +	lc_io_client = dm_io_client_create();
> +	if (IS_ERR(lc_io_client)) {
> +		r = PTR_ERR(lc_io_client);
> +		goto bad_io_client;
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
> +bad_io_client:
> +	destroy_workqueue(safe_io_wq);
> +bad_wq:
> +	kobject_put(caches_kobj);
> +bad_kobj_caches:
> +	kobject_put(devices_kobj);
> +bad_kobj_devices:
> +	dm_unregister_target(&lc_mgr_target);
> +bad_register_mgr_target:
> +	dm_unregister_target(&lc_target);
> +
> +	return ERR_PTR(r);
>  }
>  
>  static void __exit lc_module_exit(void)
> 
