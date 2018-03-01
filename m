From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 08/20] libmultipath: fix compiler
 warnings for -Wcast-qual
Date: Wed, 28 Feb 2018 23:39:24 -0600
Message-ID: <20180301053924.GX14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180220132658.22295-9-mwilck@suse.com>
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

On Tue, Feb 20, 2018 at 02:26:46PM +0100, Martin Wilck wrote:
> Fix the warnings that were caused by adding the -Wcast-qual compiler
> flag in the previous patch.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  kpartx/devmapper.c          |  3 ++-
>  libmpathcmd/mpath_cmd.c     |  2 +-
>  libmultipath/checkers/rbd.c |  4 ++--
>  libmultipath/devmapper.c    |  3 ++-
>  libmultipath/discovery.c    | 12 ++++++------
>  libmultipath/list.h         |  4 ++--
>  libmultipath/memory.h       |  8 +++++++-
>  libmultipath/structs.c      |  2 +-
>  libmultipath/structs.h      |  2 +-
>  libmultipath/uevent.c       |  6 +++---
>  libmultipath/util.c         |  6 +++---
>  multipathd/main.c           | 10 +++++-----
>  12 files changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
> index 4469fa848de8..eb9dac639175 100644
> --- a/kpartx/devmapper.c
> +++ b/kpartx/devmapper.c
> @@ -11,6 +11,7 @@
>  #include <sys/sysmacros.h>
>  #include "devmapper.h"
>  
> +#define FREE_CONST(p) do { free((void*)(long)p); p = NULL; } while(0)
>  #define _UUID_PREFIX "part"
>  #define UUID_PREFIX _UUID_PREFIX "%d-"
>  #define _UUID_PREFIX_LEN (sizeof(_UUID_PREFIX) - 1)
> @@ -695,7 +696,7 @@ int dm_find_part(const char *parent, const char *delim, int part,
>  	} else
>  		*part_uuid = uuid;
>  out:
> -	free((void*)tmp);
> +	FREE_CONST(tmp);
>  	return r;
>  }
>  
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index af618cff917c..29d148ce8aff 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -64,7 +64,7 @@ static size_t write_all(int fd, const void *buf, size_t len)
>  		}
>  		if (!n)
>  			return total;
> -		buf = n + (char *)buf;
> +		buf = n + (const char *)buf;
>  		len -= n;
>  		total += n;
>  	}
> diff --git a/libmultipath/checkers/rbd.c b/libmultipath/checkers/rbd.c
> index 2c1800976e40..b1d99b4c81f6 100644
> --- a/libmultipath/checkers/rbd.c
> +++ b/libmultipath/checkers/rbd.c
> @@ -288,7 +288,7 @@ void libcheck_free(struct checker * c)
>  static int rbd_is_blacklisted(struct rbd_checker_context *ct, char *msg)
>  {
>  	char *addr_tok, *start, *save;
> -	char *cmd[2];
> +	const char *cmd[2];
>  	char *blklist, *stat;
>  	size_t blklist_len, stat_len;
>  	int ret;
> @@ -436,7 +436,7 @@ static int sysfs_write_rbd_remove(const char *buf, int buf_len)
>  
>  static int rbd_rm_blacklist(struct rbd_checker_context *ct)
>  {
> -	char *cmd[2];
> +	const char *cmd[2];
>  	char *stat, *cmd_str;
>  	size_t stat_len;
>  	int ret;
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index f61838cbe369..607aea8dc1fc 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -27,6 +27,7 @@
>  #include <sys/types.h>
>  #include <time.h>
>  
> +#define FREE_CONST(p) do { free((void*)(unsigned long)p); p = NULL; } while(0)
>  #define MAX_WAIT 5
>  #define LOOPS_PER_SEC 5
>  
> @@ -1426,7 +1427,7 @@ void dm_reassign_deps(char *table, const char *dep, const char *newdep)
>  	n += strlen(newdep);
>  	p += strlen(dep);
>  	strcat(n, p);
> -	free(newtable);
> +	FREE_CONST(newtable);
>  }
>  
>  int dm_reassign_table(const char *name, char *old, char *new)
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 98bddee52c8f..645224c1029c 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -121,7 +121,7 @@ path_discover (vector pathvec, struct config * conf,
>  	if (!devname)
>  		return PATHINFO_FAILED;
>  
> -	pp = find_path_by_dev(pathvec, (char *)devname);
> +	pp = find_path_by_dev(pathvec, devname);
>  	if (!pp) {
>  		char devt[BLK_DEV_SIZE];
>  		dev_t devnum = udev_device_get_devnum(udevice);
> @@ -905,12 +905,12 @@ static int
>  parse_vpd_pg83(const unsigned char *in, size_t in_len,
>  	       char *out, size_t out_len)
>  {
> -	unsigned char *d;
> -	unsigned char *vpd = NULL;
> +	const unsigned char *d;
> +	const unsigned char *vpd = NULL;
>  	int len = -ENODATA, vpd_type, vpd_len, prio = -1, i, naa_prio;
>  
> -	d = (unsigned char *)in + 4;
> -	while (d < (unsigned char *)in + in_len) {
> +	d = in + 4;
> +	while (d < in + in_len) {
>  		/* Select 'association: LUN' */
>  		if ((d[1] & 0x30) != 0) {
>  			d += d[3] + 4;
> @@ -1027,7 +1027,7 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
>  				out[len] = '\0';
>  			}
>  		} else if (vpd_type == 0x1) {
> -			unsigned char *p;
> +			const unsigned char *p;
>  			int p_len;
>  
>  			out[0] = '1';
> diff --git a/libmultipath/list.h b/libmultipath/list.h
> index 2b1dcf396695..c9110ac9de7e 100644
> --- a/libmultipath/list.h
> +++ b/libmultipath/list.h
> @@ -18,8 +18,8 @@
>   * @member:	the name of the member within the struct.
>   *
>   */
> -#define container_of(ptr, type, member) ({			\
> -	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
> +#define container_of(ptr, type, member) ({		\
> +	typeof( ((type *)0)->member ) *__mptr = (ptr);	\
>  	(type *)( (char *)__mptr - offsetof(type,member) );})
>  
>  /*
> diff --git a/libmultipath/memory.h b/libmultipath/memory.h
> index 927619b58a62..63f59d80584c 100644
> --- a/libmultipath/memory.h
> +++ b/libmultipath/memory.h
> @@ -43,6 +43,7 @@ int debug;
>  		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
>  #define STRDUP(n)    ( dbg_strdup((n), \
>  		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
> +#define FREE_CONST(p) do { FREE((void*)(unsigned long)p); } while(0)
>  
>  /* Memory debug prototypes defs */
>  extern void *dbg_malloc(unsigned long, char *, char *, int);
> @@ -54,7 +55,12 @@ extern void dbg_free_final(char *);
>  #else
>  
>  #define MALLOC(n)    (calloc(1,(n)))
> -#define FREE(p)      do { free((void*)p); p = NULL; } while(0)
> +#define FREE(p)      do { free(p); p = NULL; } while(0)
> +/*
> + * Double cast to avoid warnings with -Wcast-qual
> + * use this for valid free() operations on const pointers
> + */
> +#define FREE_CONST(p) do { free((void*)(unsigned long)p); p = NULL; } while(0)
>  #define REALLOC(p,n) (realloc((p),(n)))
>  #define STRDUP(n)    (strdup(n))
>  
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 1ade1a6705ad..4db08451824d 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -418,7 +418,7 @@ find_mp_by_str (vector mpvec, char * str)
>  }
>  
>  struct path *
> -find_path_by_dev (vector pathvec, char * dev)
> +find_path_by_dev (vector pathvec, const char * dev)
>  {
>  	int i;
>  	struct path * pp;
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 71b37cc20674..bccc845a1222 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -387,7 +387,7 @@ struct multipath * find_mp_by_str (vector mp, char * wwid);
>  struct multipath * find_mp_by_minor (vector mp, int minor);
>  
>  struct path * find_path_by_devt (vector pathvec, const char * devt);
> -struct path * find_path_by_dev (vector pathvec, char * dev);
> +struct path * find_path_by_dev (vector pathvec, const char * dev);
>  struct path * first_path (struct multipath * mpp);
>  
>  int pathcountgr (struct pathgroup *, int);
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 8f4129ca7fd0..685ef3362c6d 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -157,7 +157,7 @@ static int uevent_get_env_positive_int(const struct uevent *uev,
>  void
>  uevent_get_wwid(struct uevent *uev)
>  {
> -	char *uid_attribute;
> +	const char *uid_attribute;
>  	const char *val;
>  	struct config * conf;
>  
> @@ -167,8 +167,8 @@ uevent_get_wwid(struct uevent *uev)
>  
>  	val = uevent_get_env_var(uev, uid_attribute);
>  	if (val)
> -		uev->wwid = (char*)val;
> -	free(uid_attribute);
> +		uev->wwid = val;
> +	FREE_CONST(uid_attribute);
>  }
>  
>  bool
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 0b43d29d1236..d3dd3eb524d0 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -32,7 +32,7 @@ strchop(char *str)
>  int
>  basenamecpy (const char * str1, char * str2, int str2len)
>  {
> -	char *p;
> +	const char *p;
>  
>  	if (!str1 || !strlen(str1))
>  		return 0;
> @@ -43,7 +43,7 @@ basenamecpy (const char * str1, char * str2, int str2len)
>  	if (!str2)
>  		return 0;
>  
> -	p = (char *)str1 + (strlen(str1) - 1);
> +	p = str1 + (strlen(str1) - 1);
>  
>  	while (*--p != '/' && p != str1)
>  		continue;
> @@ -454,7 +454,7 @@ int safe_write(int fd, const void *buf, size_t count)
>  			return -errno;
>  		}
>  		count -= r;
> -		buf = (char *)buf + r;
> +		buf = (const char *)buf + r;
>  	}
>  	return 0;
>  }
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a8a0c302e8fe..b900bb3ec2e3 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -408,7 +408,7 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
>  	pthread_testcancel();
>  	rc = ev_add_map(uev->kernel, alias, vecs);
>  	lock_cleanup_pop(vecs->lock);
> -	FREE(alias);
> +	FREE_CONST(alias);
>  	return rc;
>  }
>  
> @@ -532,7 +532,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
>  	remove_map_and_stop_waiter(mpp, vecs, 1);
>  out:
>  	lock_cleanup_pop(vecs->lock);
> -	FREE(alias);
> +	FREE_CONST(alias);
>  	return 0;
>  }
>  
> @@ -1028,11 +1028,11 @@ uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
>  				pp->dev);
>  out_lock:
>  	lock_cleanup_pop(vecs->lock);
> -	FREE(devt);
> -	FREE(action);
> +	FREE_CONST(devt);
> +	FREE_CONST(action);
>  	return r;
>  out:
> -	FREE(action);
> +	FREE_CONST(action);
>  	return 1;
>  }
>  
> -- 
> 2.16.1
