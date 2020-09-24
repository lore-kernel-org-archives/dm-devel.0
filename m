From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 06/11] libmultipath: checkers/prio: allow
 non-lazy .so loading
Date: Thu, 24 Sep 2020 15:27:14 -0500
Message-ID: <20200924202714.GI11108@octiron.msp.redhat.com>
References: <20200924133644.14034-1-mwilck@suse.com>
	<20200924133644.14034-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-7-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:36:39PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If compiled with -DLOAD_ALL_SHARED_LIBS, all known prioritizers
> and checkers will be loaded immediately on startup. This is useful
> for determining symbol usage (start executables with LD_BIND_NOW=1).

It seems like you could avoid having to remember to update these arrays
when new checker or prio DSOs are added by just scanning multipath_dir
for all the existing checkers/prioritizers.  On the flip side, I'm not
sure that's worth the extra work, and this way has the benefit of
warning if any expected chekers/priotitizers are missing, so

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/checkers.c | 17 +++++++++++++++++
>  libmultipath/prio.c     | 22 ++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index f7ddd53..18b1f5e 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -7,6 +7,7 @@
>  #include "debug.h"
>  #include "checkers.h"
>  #include "vector.h"
> +#include "util.h"
>  
>  struct checker_class {
>  	struct list_head node;
> @@ -375,7 +376,23 @@ void checker_get(const char *multipath_dir, struct checker *dst,
>  
>  int init_checkers(const char *multipath_dir)
>  {
> +#ifdef LOAD_ALL_SHARED_LIBS
> +	static const char *const all_checkers[] = {
> +		DIRECTIO,
> +		TUR,
> +		HP_SW,
> +		RDAC,
> +		EMC_CLARIION,
> +		READSECTOR0,
> +		CCISS_TUR,
> +	};
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(all_checkers); i++)
> +		add_checker_class(multipath_dir, all_checkers[i]);
> +#else
>  	if (!add_checker_class(multipath_dir, DEFAULT_CHECKER))
>  		return 1;
> +#endif
>  	return 0;
>  }
> diff --git a/libmultipath/prio.c b/libmultipath/prio.c
> index 3a718ba..c92bde7 100644
> --- a/libmultipath/prio.c
> +++ b/libmultipath/prio.c
> @@ -20,8 +20,30 @@ unsigned int get_prio_timeout(unsigned int timeout_ms,
>  
>  int init_prio (const char *multipath_dir)
>  {
> +#ifdef LOAD_ALL_SHARED_LIBS
> +	static const char *const all_prios[] = {
> +		PRIO_ALUA,
> +		PRIO_CONST,
> +		PRIO_DATACORE,
> +		PRIO_EMC,
> +		PRIO_HDS,
> +		PRIO_HP_SW,
> +		PRIO_ONTAP,
> +		PRIO_RANDOM,
> +		PRIO_RDAC,
> +		PRIO_WEIGHTED_PATH,
> +		PRIO_SYSFS,
> +		PRIO_PATH_LATENCY,
> +		PRIO_ANA,
> +	};
> +	unsigned int i;
> +
> +	for  (i = 0; i < ARRAY_SIZE(all_prios); i++)
> +		add_prio(multipath_dir, all_prios[i]);
> +#else
>  	if (!add_prio(multipath_dir, DEFAULT_PRIO))
>  		return 1;
> +#endif
>  	return 0;
>  }
>  
> -- 
> 2.28.0
