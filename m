From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 15/20] libmultipath: implement
	find_multipaths_timeout
Date: Thu, 12 Apr 2018 13:35:47 -0500
Message-ID: <20180412183547.GQ3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-16-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180404161627.6244-16-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Wed, Apr 04, 2018 at 06:16:22PM +0200, Martin Wilck wrote:
> This makes the timeout for "find_multipaths smart" configurable.
> If the timeout has a negative value (default), it's applied only
> to "known" hardware which is either in the hwtable or in a "device" section in
> multipath.conf. For typical non-multipath hardware, which is not in the
> hwtable, a short timeout of 1s is used, so that boot delays caused by
> pointlessly waiting e.g. for SATA devices will be minimal.
> 
> It's expected that a "reasonable" timeout value depends less on the storage
> hardware itself but on other properties of the data center such as network
> latencies or distances. find_multipaths_timeout is therefore just a "defaults"
> section setting.
> 

This patch adds trailing whitespace, but otherwise,

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.h      |  1 +
>  libmultipath/defaults.h    |  2 ++
>  libmultipath/dict.c        |  6 ++++++
>  libmultipath/propsel.c     | 25 +++++++++++++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     |  1 +
>  multipath/multipath.conf.5 | 18 ++++++++++++++++++
>  7 files changed, 54 insertions(+)
> 
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index c71d972..6e69a37 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -174,6 +174,7 @@ struct config {
>  	int remove_retries;
>  	int max_sectors_kb;
>  	int ghost_delay;
> +	int find_multipaths_timeout;
>  	unsigned int version[3];
>  
>  	char * multipath_dir;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 19ad2bf..d7b87b4 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -41,6 +41,8 @@
>  #define DEFAULT_DISABLE_CHANGED_WWIDS 1
>  #define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF
>  #define DEFAULT_GHOST_DELAY GHOST_DELAY_OFF
> +#define DEFAULT_FIND_MULTIPATHS_TIMEOUT -10
> +#define DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT 1
>  
>  #define DEFAULT_CHECKINT	5
>  #define MAX_CHECKINT(a)		(a << 2)
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index e695fdc..4be808d 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -485,6 +485,10 @@ declare_hw_snprint(max_sectors_kb, print_nonzero)
>  declare_mp_handler(max_sectors_kb, set_int)
>  declare_mp_snprint(max_sectors_kb, print_nonzero)
>  
> +declare_def_handler(find_multipaths_timeout, set_int)
> +declare_def_snprint_defint(find_multipaths_timeout, print_int,
> +			   DEFAULT_FIND_MULTIPATHS_TIMEOUT)
> +
>  static int
>  def_config_dir_handler(struct config *conf, vector strvec)
>  {
> @@ -1519,6 +1523,8 @@ init_keywords(vector keywords)
>  	install_keyword("remove_retries", &def_remove_retries_handler, &snprint_def_remove_retries);
>  	install_keyword("max_sectors_kb", &def_max_sectors_kb_handler, &snprint_def_max_sectors_kb);
>  	install_keyword("ghost_delay", &def_ghost_delay_handler, &snprint_def_ghost_delay);
> +	install_keyword("find_multipaths_timeout", &def_find_multipaths_timeout_handler,
> +			&snprint_def_find_multipaths_timeout);
>  	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
>  	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
>  	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 93974a4..70fb997 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -912,3 +912,28 @@ out:
>  	condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
>  	return 0;
>  }
> +
> +int select_find_multipaths_timeout(struct config *conf, struct path *pp)
> +{
> +	char *origin;
> +
> +	pp_set_conf(find_multipaths_timeout);
> +	pp_set_default(find_multipaths_timeout,
> +		       DEFAULT_FIND_MULTIPATHS_TIMEOUT);
> +out:
> +	/*
> +	 * If configured value is negative, and this "unkown" hardware
> +	 * (no hwentry), use very small timeout to avoid delays.
> +	 */
> +	if (pp->find_multipaths_timeout < 0) {
> +		pp->find_multipaths_timeout = - pp->find_multipaths_timeout;
> +		if (!pp->hwe) {
> +			pp->find_multipaths_timeout =
> +				DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEOUT;
> +			origin = "(default for unkown hardware)";
> +		}
> +	}
> +	condlog(3, "%s: timeout for find_multipaths \"smart\" = %ds %s",
> +		pp->dev, pp->find_multipaths_timeout, origin);
> +	return 0;
> +}
> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> index 136f906..b6475d0 100644
> --- a/libmultipath/propsel.h
> +++ b/libmultipath/propsel.h
> @@ -8,6 +8,7 @@ int select_hwhandler (struct config *conf, struct multipath * mp);
>  int select_checker(struct config *conf, struct path *pp);
>  int select_getuid (struct config *conf, struct path * pp);
>  int select_prio (struct config *conf, struct path * pp);
> +int select_find_multipaths_timeout(struct config *conf, struct path * pp);
>  int select_no_path_retry(struct config *conf, struct multipath *mp);
>  int select_flush_on_last_del(struct config *conf, struct multipath *mp);
>  int select_minio(struct config *conf, struct multipath *mp);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 1d3a34f..eb6a178 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -281,6 +281,7 @@ struct path {
>  	int io_err_disable_reinstate;
>  	int io_err_pathfail_cnt;
>  	int io_err_pathfail_starttime;
> +	int find_multipaths_timeout;
>  	/* configlet pointers */
>  	struct hwentry * hwe;
>  	struct gen_path generic_path;
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 6965dac..94c419a 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -983,6 +983,24 @@ The default is: \fBstrict\fR
>  .
>  .
>  .TP
> +.B find_multipaths_timeout
> +Timeout, in seconds, to wait for additional paths after detecting the first
> +one, if \fIfind_multipaths
> +"smart"\fR (see above) is set. If the value is \fBpositive\fR, this timeout is used for all
> +unkown, non-blacklisted devices encountered. If the value is \fBnegative\fR
> +(recommended), it's only
> +applied to "known" devices that have an entry in multipath's hardware table,
> +either in the built-in table or in a \fIdevice\fR section; other ("unknown") devices will
> +use a timeout of only 1 second to avoid booting delays. The value 0 means
> +"use the built-in default". If \fIfind_multipath\fR has a value
> +other than \fIsmart\fR, this option has no effect. 
> +.RS
> +.TP
> +The default is: \fB-10\fR (10s for known and 1s for unknown hardware)
> +.RE
> +.
> +.
> +.TP
>  .B uxsock_timeout
>  CLI receive timeout in milliseconds. For larger systems CLI commands
>  might timeout before the multipathd lock is released and the CLI command
> -- 
> 2.16.1
