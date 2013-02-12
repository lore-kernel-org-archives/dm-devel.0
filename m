From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/8] [dm-cache] cache target
Date: Tue, 12 Feb 2013 15:27:33 +0000
Message-ID: <20130212152733.GH12499@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-9-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1355429956-22785-9-git-send-email-ejt@redhat.com>
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

[Although I'm replying to this old email, I'm looking at
updated code taken from the all-caches branch of 
git://github.com/jthornber/linux-2.6 ]

On Thu, Dec 13, 2012 at 08:19:16PM +0000, Joe Thornber wrote:
>  drivers/md/Kconfig                            |   22 +

>  drivers/md/dm-cache-policy-cleaner.c          |  482 +++++
>  drivers/md/dm-cache-policy-mq.c               | 1254 +++++++++++++

> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig

> +config DM_CACHE
> +       tristate "Cache target (EXPERIMENTAL)"
> +       depends on BLK_DEV_DM
> +       default n
> +       select DM_PERSISTENT_DATA
> +       select DM_PRISON
> +       ---help---
> +         Use an SSD to speed up a slower device.

Can we allow for other non-SSD uses too?
"Use a faster device like an SSD to speed up a slower device." perhaps?

> +         dm-cache attempts to improve performance of a block device by
> +         moving frequently used data to a smaller, higher performance
> +         device.  Different 'policy' plugins can be used to change the
> +         algorithms used to select which blocks are promoted, demoted,
> +         cleaned etc.  It supports writeback and writethrough modes.


> +++ b/drivers/md/dm-cache-policy-cleaner.c
> @@ -0,0 +1,482 @@

> +#include "dm-cache-policy.h"
> +#include "dm.h"
> +
> +#include <linux/hash.h>
> +#include <linux/list.h>

list.h already included by dm.h

> +#include <linux/module.h>
> +#include <linux/slab.h>
> +
> +/*----------------------------------------------------------------*/
> +

#define DM_MSG_PREFIX "cache cleaner"
#define CLEANER_VERSION "1.0.0"


> +static int alloc_cache_blocks_with_hash(struct policy *p, dm_cblock_t cache_size)
> +{
> +	int r;

int r = -ENOMEM ?

> +
> +	p->cblocks = vzalloc(sizeof(*p->cblocks) * from_cblock(cache_size));
> +	if (p->cblocks) {
> +		unsigned u = from_cblock(cache_size);
> +
> +		while (u--)
> +			list_add(&p->cblocks[u].list, &p->free);
> +
> +		p->nr_cblocks_allocated = 0;
> +
> +		/* Cache entries hash. */
> +		r = alloc_hash(&p->chash, from_cblock(cache_size));
> +		if (r)
> +			vfree(p->cblocks);
> +
> +	} else
> +		r = -ENOMEM;

Initialise instead.

> +}
> +
> +
> +static void __set_clear_dirty(struct dm_cache_policy *pe, dm_oblock_t oblock, bool set)

Extra blank line

> +#if 0
> +static int wb_status(struct dm_cache_policy *pe, status_type_t type, unsigned status_flags, char *result, unsigned maxlen)
> +{
> +	ssize_t sz = 0;
> +	struct policy *p = to_policy(pe);
> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +		DMEMIT("%u", from_cblock(p->nr_dirty));
> +		break;
> +
> +	case STATUSTYPE_TABLE:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +#endif

Provide a documented stable status or drop this for now?

> +#if 0
> +	p->policy.status = wb_status;
> +	p->policy.message = NULL;
> +#endif

> +static int __init wb_init(void)
> +{
> +	return dm_cache_policy_register(&wb_policy_type);
> +}

Log like other modules (e.g. dm-queue-length.c):
	DMINFO("version " CLEANER_VERSION " loaded");

Similar DMINFO changes in dm-cache-policy-mq.c.

Alasdair
