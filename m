From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 12/20] libmultipath: "generic multipath"
	interface
Date: Wed, 28 Feb 2018 17:47:42 -0600
Message-ID: <20180228234742.GJ14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-13-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-13-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 20, 2018 at 02:26:50PM +0100, Martin Wilck wrote:
> This patch adds a simplified abstract interface to the multipath data structures.
> The idea is to allow "foreign" data structures to be treated by libmultipath
> if they implement the same interface. Currently, the intention is to use this
> only to provide formatted output about from this interface.
> 
> This interface assumes only that the data structure is organized in maps
> containing path groups containing paths, and that formatted printing (using
> the wildcards defined in libmultipath) is possible on each level of the data
> structure.
> 
> The patch also implements the interface for the internal dm_multipath data
> structure.
> 
> The style() method looks a bit exotic, but it's necessary because
> print_multipath_topology() uses different formats depending on the mpp
> properties. This needs to be in the generic interface, too, if we want to
> produce identical output.
>

I have one nit here. print.h now relies on dm-generic.h, since it uses
dm_multipath_to_gen() in its defines.  So shouldn't it simply include
dm-generic.h, which would allow configure.c, main.c, and cli_handlers.c
to not include dm-generic.h, since they only need it because they
include print.h?

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/Makefile     |   2 +-
>  libmultipath/dm-generic.c |  70 ++++++++++++++++++++++++
>  libmultipath/dm-generic.h |  41 ++++++++++++++
>  libmultipath/generic.c    |  39 +++++++++++++
>  libmultipath/generic.h    | 136 ++++++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/list.h       |   4 ++
>  libmultipath/print.c      |  34 ++++++++++++
>  libmultipath/print.h      |   7 +++
>  libmultipath/structs.c    |   4 ++
>  libmultipath/structs.h    |   4 ++
>  10 files changed, 340 insertions(+), 1 deletion(-)
>  create mode 100644 libmultipath/dm-generic.c
>  create mode 100644 libmultipath/dm-generic.h
>  create mode 100644 libmultipath/generic.c
>  create mode 100644 libmultipath/generic.h
> 
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 25b052729d48..0099d9d6cc39 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -43,7 +43,7 @@ OBJS = memory.o parser.o vector.o devmapper.o callout.o \
>  	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
>  	log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
>  	lock.o waiter.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
> -	io_err_stat.o
> +	io_err_stat.o dm-generic.o generic.o
>  
>  all: $(LIBS)
>  
> diff --git a/libmultipath/dm-generic.c b/libmultipath/dm-generic.c
> new file mode 100644
> index 000000000000..42a26085d087
> --- /dev/null
> +++ b/libmultipath/dm-generic.c
> @@ -0,0 +1,70 @@
> +/*
> +  Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
> +
> +  This program is free software; you can redistribute it and/or
> +  modify it under the terms of the GNU General Public License
> +  as published by the Free Software Foundation; either version 2
> +  of the License, or (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful,
> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  GNU General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program; if not, write to the Free Software
> +  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> +  USA.
> + */
> +
> +#include <stdint.h>
> +#include <sys/types.h>
> +#include "generic.h"
> +#include "dm-generic.h"
> +#include "structs.h"
> +#include "structs_vec.h"
> +#include "config.h"
> +#include "print.h"
> +
> +static const struct _vector*
> +dm_mp_get_pgs(const struct gen_multipath *gmp)
> +{
> +	return vector_convert(NULL, gen_multipath_to_dm(gmp)->pg,
> +			      struct pathgroup, dm_pathgroup_to_gen);
> +}
> +
> +static void dm_mp_rel_pgs(const struct gen_multipath *gmp,
> +			  const struct _vector* v)
> +{
> +	vector_free_const(v);
> +}
> +
> +static const struct _vector*
> +dm_pg_get_paths(const struct gen_pathgroup *gpg)
> +{
> +	return vector_convert(NULL, gen_pathgroup_to_dm(gpg)->paths,
> +			      struct path, dm_path_to_gen);
> +}
> +
> +static void dm_mp_rel_paths(const struct gen_pathgroup *gpg,
> +			    const struct _vector* v)
> +{
> +	vector_free_const(v);
> +}
> +
> +const struct gen_multipath_ops dm_gen_multipath_ops = {
> +	.get_pathgroups = dm_mp_get_pgs,
> +	.rel_pathgroups = dm_mp_rel_pgs,
> +	.snprint = snprint_multipath_attr,
> +	/* .style = snprint_multipath_style, TBD */
> +};
> +
> +const struct gen_pathgroup_ops dm_gen_pathgroup_ops = {
> +	.get_paths = dm_pg_get_paths,
> +	.rel_paths = dm_mp_rel_paths,
> +	.snprint = snprint_pathgroup_attr,
> +};
> +
> +const struct gen_path_ops dm_gen_path_ops = {
> +	.snprint = snprint_path_attr,
> +};
> diff --git a/libmultipath/dm-generic.h b/libmultipath/dm-generic.h
> new file mode 100644
> index 000000000000..5d5972406819
> --- /dev/null
> +++ b/libmultipath/dm-generic.h
> @@ -0,0 +1,41 @@
> +/*
> +  Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
> +
> +  This program is free software; you can redistribute it and/or
> +  modify it under the terms of the GNU General Public License
> +  as published by the Free Software Foundation; either version 2
> +  of the License, or (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful,
> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  GNU General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program; if not, write to the Free Software
> +  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> +  USA.
> + */
> +#ifndef _DM_GENERIC_H
> +#define _DM_GENERIC_H
> +#include "generic.h"
> +#include "list.h" /* for container_of */
> +#include "structs.h"
> +
> +#define dm_multipath_to_gen(mpp) (&((mpp)->generic_mp))
> +#define gen_multipath_to_dm(gm) \
> +	container_of_const((gm), struct multipath, generic_mp)
> +
> +#define dm_pathgroup_to_gen(pg) (&(pg->generic_pg))
> +#define gen_pathgroup_to_dm(gpg) \
> +	container_of_const((gpg), struct pathgroup, generic_pg)
> +
> +#define dm_path_to_gen(pp) (&((pp)->generic_path))
> +#define gen_path_to_dm(gp) \
> +	container_of_const((gp), struct path, generic_path)
> +
> +extern const struct gen_multipath_ops dm_gen_multipath_ops;
> +extern const struct gen_pathgroup_ops dm_gen_pathgroup_ops;
> +extern const struct gen_path_ops dm_gen_path_ops;
> +
> +#endif /* _DM_GENERIC_H */
> diff --git a/libmultipath/generic.c b/libmultipath/generic.c
> new file mode 100644
> index 000000000000..61cbffb708b6
> --- /dev/null
> +++ b/libmultipath/generic.c
> @@ -0,0 +1,39 @@
> +/*
> +  Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
> +
> +  This program is free software; you can redistribute it and/or
> +  modify it under the terms of the GNU General Public License
> +  as published by the Free Software Foundation; either version 2
> +  of the License, or (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful,
> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  GNU General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program; if not, write to the Free Software
> +  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> +  USA.
> + */
> +
> +
> +#include <string.h>
> +#include "generic.h"
> +#include "structs.h"
> +
> +int generic_style(const struct gen_multipath* gm,
> +		  char *buf, int len, int verbosity)
> +{
> +	char alias_buf[WWID_SIZE];
> +	char wwid_buf[WWID_SIZE];
> +	int n = 0;
> +
> +	gm->ops->snprint(gm, alias_buf, sizeof(alias_buf), 'n');
> +	gm->ops->snprint(gm, wwid_buf, sizeof(wwid_buf), 'w');
> +
> +	if (strcmp(alias_buf, wwid_buf))
> +		n = snprintf(buf, len, " (%%w)");
> +
> +	return (n < len ? n : len - 1);
> +}
> diff --git a/libmultipath/generic.h b/libmultipath/generic.h
> new file mode 100644
> index 000000000000..7f7fe6661c36
> --- /dev/null
> +++ b/libmultipath/generic.h
> @@ -0,0 +1,136 @@
> +/*
> +  Copyright (c) 2018 Martin Wilck, SUSE Linux GmbH
> +
> +  This program is free software; you can redistribute it and/or
> +  modify it under the terms of the GNU General Public License
> +  as published by the Free Software Foundation; either version 2
> +  of the License, or (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful,
> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  GNU General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program; if not, write to the Free Software
> +  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
> +  USA.
> + */
> +#ifndef _GENERIC_H
> +#define _GENERIC_H
> +#include "vector.h"
> +
> +struct gen_multipath;
> +struct gen_pathgroup;
> +struct gen_path;
> +
> +/**
> + * Methods implemented for gen_multipath "objects"
> + */
> +struct gen_multipath_ops {
> +	/**
> +	 * method: get_pathgroups(gmp)
> +	 * caller is responsible to returned data using rel_pathgroups()
> +	 * caller is also responsible to lock the gmp (directly or indirectly)
> +	 * while working with the return value.
> +	 * @param gmp: generic multipath object to act on
> +	 * @returns a vector of const struct gen_pathgroup*
> +	 */
> +	const struct _vector* (*get_pathgroups)(const struct gen_multipath*);
> +	/**
> +	 * method: rel_pathgroups(gmp, v)
> +	 * free data allocated by get_pathgroups(), if any
> +	 * @param gmp: generic multipath object to act on
> +	 * @param v the value returned by get_pathgroups()
> +	 */
> +	void (*rel_pathgroups)(const struct gen_multipath*,
> +			       const struct _vector*);
> +	/**
> +	 * method: snprint(gmp, buf, len, wildcard)
> +	 * prints the property of the multipath map matching
> +	 * the passed-in wildcard character into "buf",
> +	 * 0-terminated, no more than "len" characters including trailing '\0'.
> +	 *
> +	 * @param gmp: generic multipath object to act on
> +	 * @param buf: output buffer
> +	 * @param buflen: buffer size
> +	 * @param wildcard: the multipath wildcard (see print.c)
> +	 * @returns the number of characters printed (without trailing '\0').
> +	 */
> +	int (*snprint)(const struct gen_multipath*,
> +		       char *buf, int len, char wildcard);
> +	/**
> +	 * method: style(gmp, buf, len, verbosity)
> +	 * returns the format string to be used for the multipath object,
> +	 * defined with the wildcards as defined in print.c
> +	 * generic_style() should work well in most cases.
> +	 * @param gmp: generic multipath object to act on
> +	 * @param buf: output buffer
> +	 * @param buflen: buffer size
> +	 * @param verbosity: verbosity level
> +	 * @returns number of format chars printed
> +	 */
> +	int (*style)(const struct gen_multipath*,
> +		     char *buf, int len, int verbosity);
> +};
> +
> +/**
> + * Methods implemented for gen_pathgroup "objects"
> + */
> +struct gen_pathgroup_ops {
> +	/**
> +	 * method: get_paths(gpg)
> +	 * caller is responsible to returned data using rel_paths()
> +	 * @param gpg: generic pathgroup object to act on
> +	 * @returns a vector of const struct gen_path*
> +	 */
> +	const struct _vector* (*get_paths)(const struct gen_pathgroup*);
> +	/**
> +	 * method: rel_paths(gpg, v)
> +	 * free data allocated by get_paths(), if any
> +	 * @param gmp: generic pathgroup object to act on
> +	 * @param v the value returned by get_paths()
> +	 */
> +	void (*rel_paths)(const struct gen_pathgroup*, const struct _vector*);
> +	/**
> +	 * Method snprint()
> +	 * see gen_multipath_ops->snprint() above
> +	 */
> +	int (*snprint)(const struct gen_pathgroup*,
> +		       char *buf, int len, char wildcard);
> +};
> +
> +struct gen_path_ops {
> +	/**
> +	 * Method snprint()
> +	 * see gen_multipath_ops->snprint() above
> +	 */
> +	int (*snprint)(const struct gen_path*,
> +		       char *buf, int len, char wildcard);
> +};
> +
> +struct gen_multipath {
> +	const struct gen_multipath_ops *ops;
> +};
> +
> +struct gen_pathgroup {
> +	const struct gen_pathgroup_ops *ops;
> +};
> +
> +struct gen_path {
> +	const struct gen_path_ops *ops;
> +};
> +
> +/**
> + * Helper functions for setting up the various generic_X_ops
> + */
> +
> +/**
> + * generic_style()
> + * A simple style() method (see above) that should fit most
> + * foreign libraries.
> + */
> +int generic_style(const struct gen_multipath*,
> +		  char *buf, int len, int verbosity);
> +
> +#endif /* _GENERIC_H */
> diff --git a/libmultipath/list.h b/libmultipath/list.h
> index c9110ac9de7e..ced021f5a633 100644
> --- a/libmultipath/list.h
> +++ b/libmultipath/list.h
> @@ -18,6 +18,10 @@
>   * @member:	the name of the member within the struct.
>   *
>   */
> +#define container_of_const(ptr, type, member) ({		\
> +	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
> +	(const type *)( (const char *)__mptr - offsetof(type,member) );})
> +
>  #define container_of(ptr, type, member) ({		\
>  	typeof( ((type *)0)->member ) *__mptr = (ptr);	\
>  	(type *)( (char *)__mptr - offsetof(type,member) );})
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 594ca567e22a..e6f56381791f 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -29,6 +29,7 @@
>  #include "uevent.h"
>  #include "debug.h"
>  #include "discovery.h"
> +#include "dm-generic.h"
>  
>  #define MAX(x,y) (x > y) ? x : y
>  #define TAIL     (line + len - 1 - c)
> @@ -756,6 +757,17 @@ mpd_lookup(char wildcard)
>  	return NULL;
>  }
>  
> +int snprint_multipath_attr(const struct gen_multipath* gm,
> +			   char *buf, int len, char wildcard)
> +{
> +	const struct multipath *mpp = gen_multipath_to_dm(gm);
> +	struct multipath_data *mpd = mpd_lookup(wildcard);
> +
> +	if (mpd == NULL)
> +		return 0;
> +	return mpd->snprint(buf, len, mpp);
> +}
> +
>  static struct path_data *
>  pd_lookup(char wildcard)
>  {
> @@ -768,6 +780,17 @@ pd_lookup(char wildcard)
>  	return NULL;
>  }
>  
> +int snprint_path_attr(const struct gen_path* gp,
> +		      char *buf, int len, char wildcard)
> +{
> +	const struct path *pp = gen_path_to_dm(gp);
> +	struct path_data *pd = pd_lookup(wildcard);
> +
> +	if (pd == NULL)
> +		return 0;
> +	return pd->snprint(buf, len, pp);
> +}
> +
>  static struct pathgroup_data *
>  pgd_lookup(char wildcard)
>  {
> @@ -780,6 +803,17 @@ pgd_lookup(char wildcard)
>  	return NULL;
>  }
>  
> +int snprint_pathgroup_attr(const struct gen_pathgroup* gpg,
> +			   char *buf, int len, char wildcard)
> +{
> +	const struct pathgroup *pg = gen_pathgroup_to_dm(gpg);
> +	struct pathgroup_data *pdg = pgd_lookup(wildcard);
> +
> +	if (pdg == NULL)
> +		return 0;
> +	return pdg->snprint(buf, len, pg);
> +}
> +
>  int
>  snprint_multipath_header (char * line, int len, const char * format)
>  {
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index 02c5b072cc2b..c624d2bfe8d4 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -122,3 +122,10 @@ int snprint_tgt_wwpn (char *, size_t, const struct path *);
>  void print_multipath_topology (struct multipath * mpp, int verbosity);
>  void print_all_paths (vector pathvec, int banner);
>  void print_all_paths_custo (vector pathvec, int banner, char *fmt);
> +
> +int snprint_path_attr(const struct gen_path* gp,
> +		      char *buf, int len, char wildcard);
> +int snprint_pathgroup_attr(const struct gen_pathgroup* gpg,
> +			   char *buf, int len, char wildcard);
> +int snprint_multipath_attr(const struct gen_multipath* gm,
> +			   char *buf, int len, char wildcard);
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 4db08451824d..991095cb2bc1 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -18,6 +18,7 @@
>  #include "blacklist.h"
>  #include "prio.h"
>  #include "prioritizers/alua_spc3.h"
> +#include "dm-generic.h"
>  
>  struct adapter_group *
>  alloc_adaptergroup(void)
> @@ -100,6 +101,7 @@ alloc_path (void)
>  		pp->tpgs = TPGS_UNDEF;
>  		pp->priority = PRIO_UNDEF;
>  		checker_clear(&pp->checker);
> +		dm_path_to_gen(pp)->ops = &dm_gen_path_ops;
>  	}
>  	return pp;
>  }
> @@ -160,6 +162,7 @@ alloc_pathgroup (void)
>  		pgp = NULL;
>  	}
>  
> +	dm_pathgroup_to_gen(pgp)->ops = &dm_gen_pathgroup_ops;
>  	return pgp;
>  }
>  
> @@ -200,6 +203,7 @@ alloc_multipath (void)
>  		mpp->mpcontext = NULL;
>  		mpp->no_path_retry = NO_PATH_RETRY_UNDEF;
>  		mpp->fast_io_fail = MP_FAST_IO_FAIL_UNSET;
> +		dm_multipath_to_gen(mpp)->ops = &dm_gen_multipath_ops;
>  	}
>  	return mpp;
>  }
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index bccc845a1222..88a4b7862393 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -6,6 +6,7 @@
>  
>  #include "prio.h"
>  #include "byteorder.h"
> +#include "generic.h"
>  
>  #define WWID_SIZE		128
>  #define SERIAL_SIZE		65
> @@ -256,6 +257,7 @@ struct path {
>  	int io_err_pathfail_starttime;
>  	/* configlet pointers */
>  	struct hwentry * hwe;
> +	struct gen_path generic_path;
>  };
>  
>  typedef int (pgpolicyfn) (struct multipath *);
> @@ -332,6 +334,7 @@ struct multipath {
>  	int prkey_source;
>  	struct be64 reservation_key;
>  	unsigned char prflag;
> +	struct gen_multipath generic_mp;
>  };
>  
>  struct pathgroup {
> @@ -341,6 +344,7 @@ struct pathgroup {
>  	int enabled_paths;
>  	vector paths;
>  	struct multipath *mpp;
> +	struct gen_pathgroup generic_pg;
>  };
>  
>  struct adapter_group {
> -- 
> 2.16.1
