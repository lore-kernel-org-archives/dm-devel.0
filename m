From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Make the mq policy an alias for smq
Date: Wed, 10 Feb 2016 21:13:05 -0500
Message-ID: <20160211021305.GB4481@redhat.com>
References: <1455100523-16922-1-git-send-email-ejt@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1455100523-16922-1-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 10 2016 at  5:35am -0500,
Joe Thornber <ejt@redhat.com> wrote:

> smq seems to be performing better than the old mq policy in all
> situations, as well as using a quarter of the memory.
> 
> This patch makes 'mq' and alias for 'smq' when choosing a cache
> policy.  The tunables that were present for the old mq are faked, and
> have no effect.  mq should be considered deprecated now.
> ---
>  drivers/md/Kconfig               |   11 +-
>  drivers/md/Makefile              |    2 -
>  drivers/md/dm-cache-policy-mq.c  | 1472 --------------------------------------
>  drivers/md/dm-cache-policy-smq.c |   93 ++-
>  drivers/md/dm-cache-policy.c     |    6 +-
>  5 files changed, 97 insertions(+), 1487 deletions(-)
>  delete mode 100644 drivers/md/dm-cache-policy-mq.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index b871928..9ea570b 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -295,14 +295,11 @@ config DM_CACHE
>           cleaned etc.  It supports writeback and writethrough modes.
>  
>  config DM_CACHE_MQ
> -       tristate "MQ Cache Policy (EXPERIMENTAL)"
> -       depends on DM_CACHE
> -       default y
> +       tristate "MQ Cache Policy (DEPRECATED)"
> +       depends on DM_CACHE_SMQ
> +       default n
>         ---help---
> -         A cache policy that uses a multiqueue ordered by recent hit
> -         count to select which blocks should be promoted and demoted.
> -         This is meant to be a general purpose policy.  It prioritises
> -         reads over writes.
> +         This policy is now an alias for the SMQ policy.
>  
>  config DM_CACHE_SMQ
>         tristate "Stochastic MQ Cache Policy (EXPERIMENTAL)"
...
> diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
> deleted file mode 100644
> index dbdabdf..0000000
> --- a/drivers/md/dm-cache-policy-mq.c
> +++ /dev/null

<snip delete of dm-cache-policy-mq.c>

> diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
> index 1ffbeb1..8ad6b22 100644
> --- a/drivers/md/dm-cache-policy-smq.c
> +++ b/drivers/md/dm-cache-policy-smq.c
...

> @@ -1716,6 +1781,15 @@ static struct dm_cache_policy_type smq_policy_type = {
>  	.create = smq_create
>  };
>  
> +static struct dm_cache_policy_type mq_policy_type = {
> +	.name = "mq",
> +	.version = {1, 4, 0},
> +	.hint_size = 4,
> +	.owner = THIS_MODULE,
> +	.create = mq_create,
> +	.real = &mq_policy_type
> +};
> +
>  static struct dm_cache_policy_type default_policy_type = {
>  	.name = "default",
>  	.version = {1, 4, 0},
> @@ -1735,9 +1809,17 @@ static int __init smq_init(void)
>  		return -ENOMEM;
>  	}
>  
> +	r = dm_cache_policy_register(&mq_policy_type);
> +	if (r) {
> +		DMERR("register failed %d", r);
> +		dm_cache_policy_unregister(&smq_policy_type);
> +		return -ENOMEM;
> +	}
> +
>  	r = dm_cache_policy_register(&default_policy_type);
>  	if (r) {
>  		DMERR("register failed (as default) %d", r);
> +		dm_cache_policy_unregister(&mq_policy_type);
>  		dm_cache_policy_unregister(&smq_policy_type);
>  		return -ENOMEM;
>  	}
> @@ -1748,6 +1830,7 @@ static int __init smq_init(void)
>  static void __exit smq_exit(void)
>  {
>  	dm_cache_policy_unregister(&smq_policy_type);
> +	dm_cache_policy_unregister(&mq_policy_type);
>  	dm_cache_policy_unregister(&default_policy_type);
>  }
>  
> diff --git a/drivers/md/dm-cache-policy.c b/drivers/md/dm-cache-policy.c
> index c1a3cee..829f3af 100644
> --- a/drivers/md/dm-cache-policy.c
> +++ b/drivers/md/dm-cache-policy.c
> @@ -62,7 +62,11 @@ static struct dm_cache_policy_type *get_policy(const char *name)
>  	if (t)
>  		return t;
>  
> -	request_module("dm-cache-%s", name);
> +	/* hack; mq is in the smq module */
> +	if (!strcmp(name, "mq"))
> +		request_module("dm-cache-smq");
> +	else
> +		request_module("dm-cache-%s", name);
>  
>  	t = get_policy_once(name);
>  	if (IS_ERR(t))
> -- 
> 2.5.0

I don't think we need this get_policy() hack.  We just want "mq" to be
an alias for "smq" no?  Same as "default".

The new call to dm_cache_policy_register(&mq_policy_type) will add the
mq_policy_type to dm-cache-policy.c:register_list

Shouldn't get_policy()'s call to get_policy_once() resolve "mq" to be
"smq" if we just add this to the bottom of dm-cache-policy-smq?:

MODULE_ALIAS("dm-cache-mq");

I'm also missing why mq_policy_type's .real points to itself via
&mq_policy_type -- shouldn't it be &smq_policy_type (like "default"
does)?

Or is this some subtle compatability so that "mq" is always displayed
in cache status output?
