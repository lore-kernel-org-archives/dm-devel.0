From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath-tools libmultipath/config.h libmulti ...
Date: Sat, 24 Apr 2010 09:29:58 +0200
Message-ID: <1272094198.8221.1.camel@localhost>
References: <20100424052813.1042.qmail@sourceware.org>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100424052813.1042.qmail@sourceware.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ben,

you have a spelling error in the help message (nor/not).

I like this approach better indeed.

Bye

On sam., 2010-04-24 at 05:28 +0000, bmarzins@sourceware.org wrote:
> CVSROOT:	/cvs/dm
> Module name:	multipath-tools
> Branch: 	RHEL5_FC6
> Changes by:	bmarzins@sourceware.org	2010-04-24 05:28:07
> 
> Modified files:
> 	libmultipath   : config.h configure.c 
> 	multipath      : main.c 
> 
> Log message:
> 	Changed the fix for 579789.  Multipath now checks if multipathd is running and
> 	automatically acts accordingly by default.  The -q option overrides this.
> 
> Patches:
> http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.10&r2=1.18.2.11
> http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.7&r2=1.2.2.8
> http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.9&r2=1.44.2.10
> 
> --- multipath-tools/libmultipath/config.h	2010/04/08 19:31:49	1.18.2.10
> +++ multipath-tools/libmultipath/config.h	2010/04/24 05:28:06	1.18.2.11
> @@ -78,7 +78,7 @@
>  	int flush_on_last_del;
>  	int queue_without_daemon;
>  	int checker_timeout;
> -	int override_queueing;
> +	int allow_queueing;
>  	uid_t uid;
>  	gid_t gid;
>  	mode_t mode;
> --- multipath-tools/libmultipath/configure.c	2010/04/08 19:31:49	1.2.2.7
> +++ multipath-tools/libmultipath/configure.c	2010/04/24 05:28:06	1.2.2.8
> @@ -13,6 +13,7 @@
>  #include <sys/file.h>
>  #include <errno.h>
>  #include <libdevmapper.h>
> +#include <fcntl.h>
>  
>  #include <checkers.h>
>  
> @@ -438,6 +439,35 @@
>  	return 1; /* dead */
>  }
>  
> +int
> +pidfile_check(const char *file)
> +{
> +	int fd;
> +	struct flock lock;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0) {
> +		if (errno == ENOENT)
> +			return 0;
> +		condlog(0, "Cannot open pidfile, %s : %s", file,
> +			strerror(errno));
> +		return -1;
> +	}
> +	lock.l_type = F_WRLCK;
> +	lock.l_start = 0;
> +	lock.l_whence = SEEK_SET;
> +	lock.l_len = 0;
> +
> +	if (fcntl(fd, F_GETLK, &lock) < 0) {
> +		condlog(0, "Cannot check lock on pidfile, %s : %s", file,
> +			strerror(errno));
> +		return -1;
> +	}
> +	if (lock.l_type == F_UNLCK)
> +		return 0;
> +	return 1;
> +}
> +
>  extern int
>  coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid)
>  {
> @@ -536,15 +566,17 @@
>  		}
>  		if (r == DOMAP_DRY)
>  			continue;
> -
> -		if (conf->override_queueing)
> +#ifndef DAEMON
> +		if (!conf->allow_queueing && !pidfile_check(DEFAULT_PIDFILE))
>  			dm_queue_if_no_path(mpp->alias, 0);
> -		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
> -			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
> -				dm_queue_if_no_path(mpp->alias, 0);
> -			else
> -				dm_queue_if_no_path(mpp->alias, 1);
> -		}
> +		else
> +#endif
> +			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
> +				if (mpp->no_path_retry == NO_PATH_RETRY_FAIL)
> +					dm_queue_if_no_path(mpp->alias, 0);
> +				else
> +					dm_queue_if_no_path(mpp->alias, 1);
> +			}
>  		if (mpp->pg_timeout != PGTIMEOUT_UNDEF) {
>  			if (mpp->pg_timeout == -PGTIMEOUT_NONE)
>  				dm_set_pg_timeout(mpp->alias,  0);
> --- multipath-tools/multipath/main.c	2010/04/16 22:08:03	1.44.2.9
> +++ multipath-tools/multipath/main.c	2010/04/24 05:28:06	1.44.2.10
> @@ -1,7 +1,7 @@
>  /*
>   * Soft:        multipath device mapper target autoconfig
>   *
> - * Version:     $Id: main.c,v 1.44.2.9 2010/04/16 22:08:03 bmarzins Exp $
> + * Version:     $Id: main.c,v 1.44.2.10 2010/04/24 05:28:06 bmarzins Exp $
>   *
>   * Author:      Christophe Varoqui
>   *
> @@ -72,7 +72,7 @@
>  usage (char * progname)
>  {
>  	fprintf (stderr, VERSION_STRING);
> -	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F|-r]\n",
> +	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F|-r|-q]\n",
>  		progname);
>  	fprintf (stderr,
>  		"\t\t\t[-p failover|multibus|group_by_serial|group_by_prio]\n" \
> @@ -84,7 +84,7 @@
>  		"\t   2\t\t\tdefault verbosity\n" \
>  		"\t   3\t\t\tprint debug information\n" \
>  		"\t-h\t\tprint this usage text\n" \
> -		"\t-q\t\tforce all maps to turn off queue_if_no_path\n"\
> +		"\t-q\t\tallow queue_if_no_path when multipathd is nor running\n"\
>  		"\t-b file\t\tbindings file location\n" \
>  		"\t-d\t\tdry run, do not create or update devmaps\n" \
>  		"\t-l\t\tshow multipath topology (sysfs and DM info)\n" \
> @@ -337,7 +337,7 @@
>  			conf->verbosity = atoi(optarg);
>  			break;
>  		case 'q':
> -			conf->override_queueing = 1;
> +			conf->allow_queueing = 1;
>  			break;
>  		case 'b':
>  			if (conf->bindings_file)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
