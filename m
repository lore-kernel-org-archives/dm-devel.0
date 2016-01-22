From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm pref-path: provides preferred path load
 balance policy
Date: Fri, 22 Jan 2016 11:06:01 -0600
Message-ID: <20160122170601.GP24960@octiron.msp.redhat.com>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: snitzer@redhat.com, agk@redhat.com, Ravikanth Nalla <ravikanth.nalla@hpe.com>, linux-kernel@vger.kernel.org, corbet@lwn.net
List-Id: dm-devel.ids

On Fri, Jan 22, 2016 at 06:31:42AM -0700, Ravikanth Nalla wrote:
> v2:
>   - changes merged with latest mainline and functionality re-verified.
>   - performed additional tests to illustrate performance benefits of
>     using this feature in certain configuration.
> 
> In a dm multipath environment, providing end user with an option of
> selecting preferred path for an I/O in the SAN based on path speed,
> health status and user preference is found to be useful. This allows
> a user to select a reliable path over flakey/bad paths thereby
> achieving higher I/O success rate. The specific scenario in which
> it is found to be useful is where a user has a need to eliminate
> the paths experiencing frequent I/O errors due to SAN failures and
> use the best performing path for I/O whenever it is available.
> 
> Another scenario where it is found to be useful is in providing
> option for user to select a high speed path (say 16GB/8GB FC)
> over alternative low speed paths (4GB/2GB FC).
> 
> A new dm path selector kernel loadable module named "dm_pref_path"
> is introduced to handle preferred path load balance policy
> (pref-path) operations. The key operations of this policy is to
> select and return user specified path from the current discovered
> online/ healthy paths. If the user specified path do not exist in
> the online/ healthy paths list due to path being currently in
> failed state or user has mentioned wrong device information, it
> will fall back to round-robin policy, where all the online/ healthy
> paths are given equal preference.

This seems like a problem that has already been solved with path groups.
If the path(s) in your preferred path group are there, multipath will
use them.  If not, then it will use your less preferred path(s), and
load balance across them how ever you choose with the path_selectors.

I admit that we don't have a path prioritizer that does a good job of
allowing users to manually pick a specific path to prefer.  But it seems
to me that there is where we should be solving the issue.

-Ben
 
> Functionality provided in this module is verified on wide variety
> of servers ( with 2 CPU sockets, 4 CPU sockets and 8 CPU sockets).
> Additionally in some specific multipathing configurations involving
> varied path speeds, proposed preferred path policy provided some
> performance improvements over existing round-robin and service-time
> load balance policies.
> 
> Signed-off-by: Ravikanth Nalla <ravikanth.nalla@hpe.com>
> ---
>  Documentation/device-mapper/dm-pref-path.txt |  52 ++++++
>  drivers/md/Makefile                          |   6 +-
>  drivers/md/dm-pref-path.c                    | 249 +++++++++++++++++++++++++++
>  3 files changed, 304 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/device-mapper/dm-pref-path.txt
>  create mode 100644 drivers/md/dm-pref-path.c
> 
> diff --git a/Documentation/device-mapper/dm-pref-path.txt b/Documentation/device-mapper/dm-pref-path.txt
> new file mode 100644
> index 0000000..0efb156b
> --- /dev/null
> +++ b/Documentation/device-mapper/dm-pref-path.txt
> @@ -0,0 +1,52 @@
> +dm-pref-path
> +============
> +
> +dm-pref-path is a path selector module for device-mapper targets, which
> +selects a user specified path for the incoming I/O.
> +
> +The key operations of this policy to select and return user specified
> +path from the current discovered online/ healthy paths. If the user
> +specified path do not exist in the online/ healthy path list due to
> +path being currently in failed state or user has mentioned wrong device
> +information, it will fall back to round-robin policy, where all the
> +online/ healthy paths are given equal preference.
> +
> +The path selector name is 'pref-path'.
> +
> +Table parameters for each path: [<repeat_count>]
> +
> +Status for each path: <status> <fail-count>
> +	<status>: 'A' if the path is active, 'F' if the path is failed.
> +	<fail-count>: The number of path failures.
> +
> +Algorithm
> +=========
> +User is provided with an option to specify preferred path in DM
> +Multipath configuration file (/etc/multipath.conf) under multipath{}
> +section with a syntax "path_selector "pref-path 1 <device major>:<device minor>"".
> +
> +	1. The pref-path selector would search and return the matching user
> +        preferred path from the online/ healthy path list for incoming I/O.
> +
> +	2. If the user preferred path do not exist in the online/ healthy
> +        path list due to path being currently in failed state or user
> +        has mentioned wrong device information, it will fall back to
> +        round-robin policy, where all the online/ healthy paths are given
> +        equal preference.
> +
> +	3. If the user preferred path comes back online/ healthy, pref-path
> +        selector would find and return this path for incoming I/O.
> +
> +Examples
> +========
> +Consider 4 paths sdq, sdam, sdbh and sdcc, if user prefers path sdbh
> +with major:minor number 67:176 which has throughput of 8GB/s over other
> +paths of 4GB/s, pref-path policy will chose this sdbh path for all the
> +incoming I/O's.
> +
> +# dmsetup table Test_Lun_2
> +0 20971520 multipath 0 0 1 1 pref-path 0 4 1 66:80 10000 67:160 10000
> +68:240 10000 8:240 10000
> +
> +# dmsetup status Test_Lun_2
> +0 20971520 multipath 2 0 0 0 1 1 A 0 4 0 66:80 A 0 67:160 A 0 68:240 A
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index f34979c..5c9f4e9 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -20,8 +20,8 @@ md-mod-y	+= md.o bitmap.o
>  raid456-y	+= raid5.o raid5-cache.o
>  
>  # Note: link order is important.  All raid personalities
> -# and must come before md.o, as they each initialise 
> -# themselves, and md.o may use the personalities when it 
> +# and must come before md.o, as they each initialise
> +# themselves, and md.o may use the personalities when it
>  # auto-initialised.
>  
>  obj-$(CONFIG_MD_LINEAR)		+= linear.o
> @@ -41,7 +41,7 @@ obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
>  obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
>  obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
>  obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
> -obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
> +obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o dm-pref-path.o
>  obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
>  obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
>  obj-$(CONFIG_DM_SWITCH)		+= dm-switch.o
> diff --git a/drivers/md/dm-pref-path.c b/drivers/md/dm-pref-path.c
> new file mode 100644
> index 0000000..6bf1c76
> --- /dev/null
> +++ b/drivers/md/dm-pref-path.c
> @@ -0,0 +1,249 @@
> +/*
> + * (C) Copyright 2015 Hewlett Packard Enterprise Development LP.
> + *
> + * dm-pref-path.c
> + *
> + * Module Author: Ravikanth Nalla
> + *
> + * This program is free software; you can redistribute it
> + * and/or modify it under the terms of the GNU General Public
> + * License, version 2 as published by the Free Software Foundation;
> + * either version 2 of the License, or (at your option) any later
> + * version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + *
> + * dm-pref-path path selector:
> + * Handles preferred path load balance policy operations. The key
> + * operations of this policy is to select and return user specified
> + * path from the current discovered online/ healthy paths(valid_paths).
> + * If the user specified path do not exist in the valid_paths list due
> + * to path being currently in failed state or user has mentioned wrong
> + * device information, it will fall back to round-robin policy, where
> + * all the valid-paths are given equal preference.
> + *
> + */
> +
> +#include "dm.h"
> +#include "dm-path-selector.h"
> +
> +#include <linux/slab.h>
> +#include <linux/ctype.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/atomic.h>
> +
> +#define DM_MSG_PREFIX	"multipath pref-path"
> +#define PP_MIN_IO       10000
> +#define PP_VERSION	"1.0.0"
> +#define BUFF_LEN         16
> +
> +/* Flag for pref_path enablement */
> +unsigned pref_path_enabled;
> +
> +/* pref_path major:minor number */
> +char pref_path[BUFF_LEN];
> +
> +struct selector {
> +	struct list_head	valid_paths;
> +	struct list_head	failed_paths;
> +};
> +
> +struct path_info {
> +	struct list_head	list;
> +	struct dm_path		*path;
> +	unsigned		repeat_count;
> +};
> +
> +static struct selector *alloc_selector(void)
> +{
> +	struct selector *s = kmalloc(sizeof(*s), GFP_KERNEL);
> +
> +	if (s) {
> +		INIT_LIST_HEAD(&s->valid_paths);
> +		INIT_LIST_HEAD(&s->failed_paths);
> +	}
> +
> +	return s;
> +}
> +
> +static int pf_create(struct path_selector *ps, unsigned argc, char
> +**argv) {
> +	struct selector *s = alloc_selector();
> +
> +	if (!s)
> +		return -ENOMEM;
> +
> +	if ((argc == 1) && strlen(argv[0]) < BUFF_LEN) {
> +		pref_path_enabled = 1;
> +		snprintf(pref_path, (BUFF_LEN-1), "%s", argv[0]);
> +	}
> +
> +	ps->context = s;
> +	return 0;
> +}
> +
> +static void pf_free_paths(struct list_head *paths)
> +{
> +	struct path_info *pi, *next;
> +
> +	list_for_each_entry_safe(pi, next, paths, list) {
> +		list_del(&pi->list);
> +		kfree(pi);
> +	}
> +}
> +
> +static void pf_destroy(struct path_selector *ps)
> +{
> +	struct selector *s = ps->context;
> +
> +	pf_free_paths(&s->valid_paths);
> +	pf_free_paths(&s->failed_paths);
> +	kfree(s);
> +	ps->context = NULL;
> +}
> +
> +static int pf_status(struct path_selector *ps, struct dm_path *path,
> +		     status_type_t type, char *result, unsigned maxlen) {
> +	unsigned sz = 0;
> +	struct path_info *pi;
> +
> +	/* When called with NULL path, return selector status/args. */
> +	if (!path)
> +		DMEMIT("0 ");
> +	else {
> +		pi = path->pscontext;
> +
> +		if (type == STATUSTYPE_TABLE)
> +			DMEMIT("%u ", pi->repeat_count);
> +	}
> +
> +	return sz;
> +}
> +
> +static int pf_add_path(struct path_selector *ps, struct dm_path *path,
> +		       int argc, char **argv, char **error) {
> +	struct selector *s = ps->context;
> +	struct path_info *pi;
> +
> +	/*
> +	 * Arguments: [<pref-path>]
> +	 */
> +	if (argc > 1) {
> +		*error = "pref-path ps: incorrect number of arguments";
> +		return -EINVAL;
> +	}
> +
> +	/* Allocate the path information structure */
> +	pi = kmalloc(sizeof(*pi), GFP_KERNEL);
> +	if (!pi) {
> +		*error = "pref-path ps: Error allocating path information";
> +		return -ENOMEM;
> +	}
> +
> +	pi->path = path;
> +	pi->repeat_count = PP_MIN_IO;
> +
> +	path->pscontext = pi;
> +
> +	list_add_tail(&pi->list, &s->valid_paths);
> +
> +	return 0;
> +}
> +
> +static void pf_fail_path(struct path_selector *ps, struct dm_path
> +*path) {
> +	struct selector *s = ps->context;
> +	struct path_info *pi = path->pscontext;
> +
> +	list_move(&pi->list, &s->failed_paths); }
> +
> +static int pf_reinstate_path(struct path_selector *ps, struct dm_path
> +*path) {
> +	struct selector *s = ps->context;
> +	struct path_info *pi = path->pscontext;
> +
> +	list_move_tail(&pi->list, &s->valid_paths);
> +
> +	return 0;
> +}
> +
> +/*
> + * Return user preferred path for an I/O.
> + */
> +static struct dm_path *pf_select_path(struct path_selector *ps,
> +				      unsigned *repeat_count, size_t nr_bytes) {
> +	struct selector *s = ps->context;
> +	struct path_info *pi = NULL, *best = NULL;
> +
> +	if (list_empty(&s->valid_paths))
> +		return NULL;
> +
> +	if (pref_path_enabled) {
> +		/* search for preferred path in the
> +		*  valid list and then return.
> +		*/
> +		list_for_each_entry(pi, &s->valid_paths, list) {
> +			if (!strcmp(pi->path->dev->name, pref_path)) {
> +				best = pi;
> +				*repeat_count = best->repeat_count;
> +				break;
> +			}
> +		}
> +	}
> +
> +	/* If preferred path is not enabled/ not available/
> +	*  offline chose the next path in the list.
> +	*/
> +	if (best == NULL && !list_empty(&s->valid_paths)) {
> +		pi = list_entry(s->valid_paths.next,
> +			struct path_info, list);
> +		list_move_tail(&pi->list, &s->valid_paths);
> +		best = pi;
> +		*repeat_count = best->repeat_count;
> +	}
> +
> +	return best ? best->path : NULL;
> +}
> +
> +static struct path_selector_type pf_ps = {
> +	.name		= "pref-path",
> +	.module		= THIS_MODULE,
> +	.table_args	= 1,
> +	.info_args	= 0,
> +	.create		= pf_create,
> +	.destroy	= pf_destroy,
> +	.status		= pf_status,
> +	.add_path	= pf_add_path,
> +	.fail_path	= pf_fail_path,
> +	.reinstate_path	= pf_reinstate_path,
> +	.select_path	= pf_select_path,
> +};
> +
> +static int __init dm_pf_init(void)
> +{
> +	int r = dm_register_path_selector(&pf_ps);
> +
> +	if (r < 0) {
> +		DMERR("register failed %d", r);
> +		return r;
> +	}
> +
> +	DMINFO("version " PP_VERSION " loaded");
> +	return r;
> +}
> +
> +static void __exit dm_pf_exit(void)
> +{
> +	dm_unregister_path_selector(&pf_ps);
> +}
> +
> +module_init(dm_pf_init);
> +module_exit(dm_pf_exit);
> +
> +MODULE_DESCRIPTION(DM_NAME "pref-path multipath path selector");
> +MODULE_AUTHOR("ravikanth.nalla@hpe.com");
> +MODULE_LICENSE("GPL");
> -- 
> 1.8.3.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
