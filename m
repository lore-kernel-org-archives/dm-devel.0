From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH v3] multipath: don't set queue_if_no_path
 without multipathd
Date: Mon, 26 Sep 2011 21:01:02 +0200
Message-ID: <1317063662.26449.0.camel@lapoo.opensvc.com>
References: <20110926145058.GW24133@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110926145058.GW24133@ether.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On lun., 2011-09-26 at 09:50 -0500, Benjamin Marzinski wrote:
> If multipathd is not running, when all paths to a device have failed, there's
> no way for them to automatically get restored.  If the device is set to queue,
> whatever is accessing it will hang forever. This can lead to problems if it
> happens at boot-up.  This patch unsets queue_if_no_path for all devices created
> when multipathd is not running. When multipathd starts, it will automatically
> get reset queue_if_no_path to the proper value.  This new behaviour can be
> overridden using the new "-q" option to multipath.
> 
> This version of the patch contacts multipathd's client socket to tell if it's
> running.
> 
Applied.
Thanks for the refactoring.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.h    |    1 +
>  libmultipath/configure.c |   40 +++++++++++++++++++++++++++++++++++++++-
>  multipath/main.c         |    8 ++++++--
>  3 files changed, 46 insertions(+), 3 deletions(-)
> 
> Index: multipath-tools-110916/libmultipath/config.h
> ===================================================================
> --- multipath-tools-110916.orig/libmultipath/config.h
> +++ multipath-tools-110916/libmultipath/config.h
> @@ -92,6 +92,7 @@ struct config {
>  	int attribute_flags;
>  	int fast_io_fail;
>  	unsigned int dev_loss;
> +	int allow_queueing;
>  	uid_t uid;
>  	gid_t gid;
>  	mode_t mode;
> Index: multipath-tools-110916/libmultipath/configure.c
> ===================================================================
> --- multipath-tools-110916.orig/libmultipath/configure.c
> +++ multipath-tools-110916/libmultipath/configure.c
> @@ -35,6 +35,7 @@
>  #include "alias.h"
>  #include "prio.h"
>  #include "util.h"
> +#include "uxsock.h"
>  
>  extern int
>  setup_map (struct multipath * mpp, char * params, int params_size)
> @@ -448,6 +449,34 @@ deadmap (struct multipath * mpp)
>  	return 1; /* dead */
>  }
>  
> +int check_daemon(void)
> +{
> +	int fd;
> +	char *reply;
> +	size_t len;
> +	int ret = 0;
> +
> +	fd = ux_socket_connect(DEFAULT_SOCKET);
> +	if (fd == -1)
> +		return 0;
> +
> +	if (send_packet(fd, "show daemon", 12) != 0)
> +		goto out;
> +	if (recv_packet(fd, &reply, &len) != 0)
> +		goto out;
> +
> +	if (strstr(reply, "shutdown"))
> +		goto out_free;
> +
> +	ret = 1;
> +
> +out_free:
> +	FREE(reply);
> +out:
> +	close(fd);
> +	return ret;
> +}
> +
>  extern int
>  coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_reload)
>  {
> @@ -555,7 +584,16 @@ coalesce_paths (struct vectors * vecs, v
>  		if (r == DOMAP_DRY)
>  			continue;
>  
> -		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
> +		if (!conf->daemon && !conf->allow_queueing && !check_daemon()) {
> +			if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
> +			    mpp->no_path_retry != NO_PATH_RETRY_FAIL)
> +				condlog(3, "%s: multipathd not running, unset "
> +					"queue_if_no_path feature", mpp->alias);
> +			if (!dm_queue_if_no_path(mpp->alias, 0))
> +				remove_feature(&mpp->features,
> +					       "queue_if_no_path");
> +		}
> +		else if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF) {
>  			if (mpp->no_path_retry == NO_PATH_RETRY_FAIL) {
>  				condlog(3, "%s: unset queue_if_no_path feature",
>  					mpp->alias);
> Index: multipath-tools-110916/multipath/main.c
> ===================================================================
> --- multipath-tools-110916.orig/multipath/main.c
> +++ multipath-tools-110916/multipath/main.c
> @@ -79,7 +79,7 @@ usage (char * progname)
>  {
>  	fprintf (stderr, VERSION_STRING);
>  	fprintf (stderr, "Usage:\n");
> -	fprintf (stderr, "  %s [-d] [-r] [-v lvl] [-p pol] [-b fil] [dev]\n", progname);
> +	fprintf (stderr, "  %s [-d] [-r] [-v lvl] [-p pol] [-b fil] [-q] [dev]\n", progname);
>  	fprintf (stderr, "  %s -l|-ll|-f [-v lvl] [-b fil] [dev]\n", progname);
>  	fprintf (stderr, "  %s -F [-v lvl]\n", progname);
>  	fprintf (stderr, "  %s -t\n", progname);
> @@ -92,6 +92,7 @@ usage (char * progname)
>  		"  -ll     show multipath topology (maximum info)\n" \
>  		"  -f      flush a multipath device map\n" \
>  		"  -F      flush all multipath device maps\n" \
> +		"  -q      allow queue_if_no_path when multipathd is not running\n"\
>  		"  -d      dry run, do not create or update devmaps\n" \
>  		"  -t      dump internal hardware table\n" \
>  		"  -r      force devmap reload\n" \
> @@ -397,7 +398,7 @@ main (int argc, char *argv[])
>  		condlog(0, "multipath tools need sysfs mounted");
>  		exit(1);
>  	}
> -	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:Brt")) != EOF ) {
> +	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:Brtq")) != EOF ) {
>  		switch(arg) {
>  		case 1: printf("optarg : %s\n",optarg);
>  			break;
> @@ -414,6 +415,9 @@ main (int argc, char *argv[])
>  		case 'B':
>  			conf->bindings_read_only = 1;
>  			break;
> +		case 'q':
> +			conf->allow_queueing = 1;
> +			break;
>  		case 'd':
>  			conf->dry_run = 1;
>  			break;
