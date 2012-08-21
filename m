From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: and wwids_file multipath.conf
	option
Date: Tue, 21 Aug 2012 19:40:50 +0200
Message-ID: <1345570850.21991.2.camel@lapoo.opensvc.com>
References: <20120820221926.GX5299@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120820221926.GX5299@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On lun., 2012-08-20 at 17:19 -0500, Benjamin Marzinski wrote:
> This patch adds a wwids_file multipath.conf option, so that users can
> move the wwids file from its default location at /etc/multipath/wwids.
> It also corrects the default bindings file location in the multipath.conf
> manpage and makes the bindings_file value always print out when you 
> display the configuration, like is done with the other default values.
> 
Applied.

Thanks.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |    6 +++++-
>  libmultipath/config.h      |    1 +
>  libmultipath/dict.c        |   24 ++++++++++++++++++++----
>  libmultipath/wwids.c       |    3 ++-
>  multipath/multipath.conf.5 |    8 +++++++-
>  5 files changed, 35 insertions(+), 7 deletions(-)
> 
> Index: multipath-tools-120817/libmultipath/config.c
> ===================================================================
> --- multipath-tools-120817.orig/libmultipath/config.c
> +++ multipath-tools-120817/libmultipath/config.c
> @@ -455,6 +455,8 @@ free_config (struct config * conf)
>  	if (conf->bindings_file)
>  		FREE(conf->bindings_file);
>  
> +	if (conf->wwids_file)
> +		FREE(conf->wwids_file);
>  	if (conf->prio_name)
>  		FREE(conf->prio_name);
>  
> @@ -505,6 +507,7 @@ load_config (char * file)
>  	conf->minio_rq = DEFAULT_MINIO_RQ;
>  	get_sys_max_fds(&conf->max_fds);
>  	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
> +	conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
>  	conf->bindings_read_only = 0;
>  	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
>  	conf->features = set_default(DEFAULT_FEATURES);
> @@ -603,7 +606,8 @@ load_config (char * file)
>  	if (conf->bindings_file == NULL)
>  		conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
>  
> -	if (!conf->multipath_dir || !conf->bindings_file)
> +	if (!conf->multipath_dir || !conf->bindings_file ||
> +	    !conf->wwids_file)
>  		goto out;
>  
>  	return 0;
> Index: multipath-tools-120817/libmultipath/config.h
> ===================================================================
> --- multipath-tools-120817.orig/libmultipath/config.h
> +++ multipath-tools-120817/libmultipath/config.h
> @@ -117,6 +117,7 @@ struct config {
>  	char * features;
>  	char * hwhandler;
>  	char * bindings_file;
> +	char * wwids_file;
>  	char * prio_name;
>  	char * prio_args;
>  	char * checker_name;
> Index: multipath-tools-120817/libmultipath/dict.c
> ===================================================================
> --- multipath-tools-120817.orig/libmultipath/dict.c
> +++ multipath-tools-120817/libmultipath/dict.c
> @@ -618,6 +618,17 @@ bindings_file_handler(vector strvec)
>  	return 0;
>  }
>  
> +static int
> +wwids_file_handler(vector strvec)
> +{
> +	conf->wwids_file = set_value(strvec);
> +
> +	if (!conf->wwids_file)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  /*
>   * blacklist block handlers
>   */
> @@ -2570,14 +2581,18 @@ snprint_def_bindings_file (char * buff,
>  {
>  	if (conf->bindings_file == NULL)
>  		return 0;
> -	if (strlen(conf->bindings_file) == strlen(DEFAULT_BINDINGS_FILE) &&
> -	    !strcmp(conf->bindings_file, DEFAULT_BINDINGS_FILE))
> -		return 0;
> -
>  	return snprintf(buff, len, "%s", conf->bindings_file);
>  }
>  
>  static int
> +snprint_def_wwids_file (char * buff, int len, void * data)
> +{
> +	if (conf->wwids_file == NULL)
> +		return 0;
> +	return snprintf(buff, len, "%s", conf->wwids_file);
> +}
> +
> +static int
>  snprint_def_reservation_key(char * buff, int len, void * data)
>  {
>  	return snprintf(buff, len, "%s", conf->reservation_key);
> @@ -2644,6 +2659,7 @@ init_keywords(void)
>  	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
>  	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
>  	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
> +	install_keyword("wwids_file", &wwids_file_handler, &snprint_def_wwids_file);
>  	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
>  	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
>  	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
> Index: multipath-tools-120817/libmultipath/wwids.c
> ===================================================================
> --- multipath-tools-120817.orig/libmultipath/wwids.c
> +++ multipath-tools-120817/libmultipath/wwids.c
> @@ -13,6 +13,7 @@
>  #include "file.h"
>  #include "wwids.h"
>  #include "defaults.h"
> +#include "config.h"
>  
>  /*
>   * Copyright (c) 2010 Benjamin Marzinski, Redhat
> @@ -85,7 +86,7 @@ check_wwids_file(char *wwid, int write_w
>  {
>  	int fd, can_write, found, ret;
>  	FILE *f;
> -	fd = open_file(DEFAULT_WWIDS_FILE, &can_write, WWIDS_FILE_HEADER);
> +	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
>  	if (fd < 0)
>  		return -1;
>  
> Index: multipath-tools-120817/multipath/multipath.conf.5
> ===================================================================
> --- multipath-tools-120817.orig/multipath/multipath.conf.5
> +++ multipath-tools-120817/multipath/multipath.conf.5
> @@ -353,7 +353,13 @@ cannot be told to stop queueing IO. Sett
>  .TP
>  .B bindings_file
>  The full pathname of the binding file to be used when the user_friendly_names option is set. Defaults to
> -.I /var/lib/multipath/bindings
> +.I /etc/multipath/bindings
> +.TP
> +.B wwids_file
> +The full pathname of the wwids file, which is used by multipath to keep track
> +of the wwids for LUNs it has created multipath devices on in the past.
> +Defaults to
> +.I /etc/multipath/wwids
>  .TP
>  .B log_checker_err
>  If set to
