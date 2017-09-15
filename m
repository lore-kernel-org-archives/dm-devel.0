From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 3/4] Add 'none' checker
Date: Fri, 15 Sep 2017 18:00:20 +0800
Message-ID: <4f3014b5-362c-896c-0da6-cf3b170159ee@huawei.com>
References: <1505457030-119611-1-git-send-email-hare@suse.de>
	<1505457030-119611-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505457030-119611-4-git-send-email-hare@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, "Shenhong (C)" <shenhong09@huawei.com>, niuhaoxin <niuhaoxin@huawei.com>
List-Id: dm-devel.ids

Looks good.

Reviewed-by: Guan Junxiong <guanjunxiong@huawei.com>


On 2017/9/15 14:30, Hannes Reinecke wrote:
> For NVMe we don't have a good way of checking the path state, so
> add a new checker 'none' which doesn't do any checking, but rely
> on the internal sysfs state for path checking.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmultipath/checkers.c    | 22 ++++++++++++++++------
>  libmultipath/checkers.h    |  3 ++-
>  libmultipath/discovery.c   | 10 ++++++----
>  libmultipath/discovery.h   |  2 +-
>  multipath/multipath.conf.5 |  3 +++
>  multipathd/main.c          |  2 +-
>  6 files changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index c32f727..cd6d6a3 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -19,6 +19,7 @@ char *checker_state_names[] = {
>  	"timeout",
>  	"removed",
>  	"delayed",
> +	"none",
>  };
>  
>  static LIST_HEAD(checkers);
> @@ -102,6 +103,8 @@ struct checker * add_checker (char *multipath_dir, char * name)
>  	if (!c)
>  		return NULL;
>  	snprintf(c->name, CHECKER_NAME_LEN, "%s", name);
> +	if (!strncmp(c->name, NONE, 4))
> +		goto done;
>  	snprintf(libname, LIB_CHECKER_NAMELEN, "%s/libcheck%s.so",
>  		 multipath_dir, name);
>  	if (stat(libname,&stbuf) < 0) {
> @@ -145,7 +148,7 @@ struct checker * add_checker (char *multipath_dir, char * name)
>  		condlog(0, "A dynamic linking error occurred: (%s)", errstr);
>  	if (!c->repair)
>  		goto out;
> -
> +done:
>  	c->fd = -1;
>  	c->sync = 1;
>  	list_add(&c->node, &checkers);
> @@ -195,14 +198,16 @@ int checker_init (struct checker * c, void ** mpctxt_addr)
>  	if (!c)
>  		return 1;
>  	c->mpcontext = mpctxt_addr;
> -	return c->init(c);
> +	if (c->init)
> +		return c->init(c);
> +	return 0;
>  }
>  
>  void checker_put (struct checker * dst)
>  {
>  	struct checker * src;
>  
> -	if (!dst || !dst->check)
> +	if (!dst || !strlen(dst->name))
>  		return;
>  	src = checker_lookup(dst->name);
>  	if (dst->free)
> @@ -221,11 +226,11 @@ void checker_repair (struct checker * c)
>  		MSG(c, "checker disabled");
>  		return;
>  	}
> -
> -	c->repair(c);
> +	if (c->repair)
> +		c->repair(c);
>  }
>  
> -int checker_check (struct checker * c)
> +int checker_check (struct checker * c, int path_state)
>  {
>  	int r;
>  
> @@ -237,6 +242,9 @@ int checker_check (struct checker * c)
>  		MSG(c, "checker disabled");
>  		return PATH_UNCHECKED;
>  	}
> +	if (!strncmp(c->name, NONE, 4))
> +		return path_state;
> +
>  	if (c->fd < 0) {
>  		MSG(c, "no usable fd");
>  		return PATH_WILD;
> @@ -250,6 +258,8 @@ int checker_selected (struct checker * c)
>  {
>  	if (!c)
>  		return 0;
> +	if (!strncmp(c->name, NONE, 4))
> +		return 1;
>  	return (c->check) ? 1 : 0;
>  }
>  
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index 1d225de..713399f 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -85,6 +85,7 @@ enum path_check_state {
>  #define EMC_CLARIION "emc_clariion"
>  #define READSECTOR0  "readsector0"
>  #define CCISS_TUR    "cciss_tur"
> +#define NONE         "none"
>  #define RBD          "rbd"
>  
>  #define ASYNC_TIMEOUT_SEC	30
> @@ -135,7 +136,7 @@ void checker_set_fd (struct checker *, int);
>  void checker_enable (struct checker *);
>  void checker_disable (struct checker *);
>  void checker_repair (struct checker *);
> -int checker_check (struct checker *);
> +int checker_check (struct checker *, int);
>  int checker_selected (struct checker *);
>  char * checker_name (struct checker *);
>  char * checker_message (struct checker *);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index a880f4b..225fd4d 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1550,7 +1550,7 @@ cciss_ioctl_pathinfo (struct path * pp, int mask)
>  }
>  
>  int
> -get_state (struct path * pp, struct config *conf, int daemon)
> +get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
>  {
>  	struct checker * c = &pp->checker;
>  	int state;
> @@ -1588,8 +1588,9 @@ get_state (struct path * pp, struct config *conf, int daemon)
>  	if (!conf->checker_timeout &&
>  	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
>  		c->timeout = DEF_TIMEOUT;
> -	state = checker_check(c);
> -	condlog(3, "%s: state = %s", pp->dev, checker_state_name(state));
> +	state = checker_check(c, oldstate);
> +	condlog(3, "%s: %s state = %s", pp->dev,
> +		checker_name(c), checker_state_name(state));
>  	if (state != PATH_UP && state != PATH_GHOST &&
>  	    strlen(checker_message(c)))
>  		condlog(3, "%s: checker msg is \"%s\"",
> @@ -1960,7 +1961,8 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  
>  	if (mask & DI_CHECKER) {
>  		if (path_state == PATH_UP) {
> -			pp->chkrstate = pp->state = get_state(pp, conf, 0);
> +			pp->chkrstate = pp->state = get_state(pp, conf, 0,
> +							      path_state);
>  			if (pp->state == PATH_UNCHECKED ||
>  			    pp->state == PATH_WILD)
>  				goto blank;
> diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
> index 51c23d6..6a54b78 100644
> --- a/libmultipath/discovery.h
> +++ b/libmultipath/discovery.h
> @@ -34,7 +34,7 @@ int path_discovery (vector pathvec, int flag);
>  
>  int do_tur (char *);
>  int path_offline (struct path *);
> -int get_state (struct path * pp, struct config * conf, int daemon);
> +int get_state (struct path * pp, struct config * conf, int daemon, int state);
>  int get_vpd_sgio (int fd, int pg, char * str, int maxlen);
>  int pathinfo (struct path * pp, struct config * conf, int mask);
>  int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index d9ac279..e0cada3 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -451,6 +451,9 @@ Please use \fItur\fR instead.
>  (Hardware-dependent)
>  Check the path state for HP/COMPAQ Smart Array(CCISS) controllers.
>  .TP
> +.I none
> +Do not check the device, fallback to use the values retrieved from sysfs
> +.TP
>  .I rbd
>  Check if the path is in the Ceph blacklist and remap the path if it is.
>  .TP
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4be2c57..657ff83 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1623,7 +1623,7 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  
>  	if (newstate == PATH_UP) {
>  		conf = get_multipath_config();
> -		newstate = get_state(pp, conf, 1);
> +		newstate = get_state(pp, conf, 1, newstate);
>  		put_multipath_config(conf);
>  	} else
>  		checker_clear_message(&pp->checker);
> 
