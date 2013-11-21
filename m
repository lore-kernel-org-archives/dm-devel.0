From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 13/13] multipathd: no_map_shutdown option
Date: Thu, 21 Nov 2013 17:17:10 -0600
Message-ID: <20131121231710.GL1661@dhcp80-209.msp.redhat.com>
References: <1384511384-27642-1-git-send-email-hare@suse.de>
	<1384511384-27642-14-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1384511384-27642-14-git-send-email-hare@suse.de>
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

I don't understand this option?  When I played around with it, it seems
like it only causes problems.  For instance.  If I remove all the
multipath devices with "multipath -F", then multipathd stops.
Incidentally, this pisses off the watchdog timer.

This pops up in /var/log/messages

Nov 21 11:04:05 ask-08 systemd[1]: multipathd.service watchdog timeout!
Nov 21 11:04:05 ask-08 systemd[1]: Unit multipathd.service entered
failed state

and checking the status shows the service as failed.

# service multipathd status
multipathd.service - Device-Mapper Multipath Device Controller
   Loaded: loaded (/usr/lib/systemd/system/multipathd.service; enabled)
   Active: failed (Result: watchdog) since Thu 2013-11-21 11:04:00 CST; 3min 25s ago
  Process: 22687 ExecStart=/sbin/multipathd -d -s -n (code=exited, status=0/SUCCESS)
   Status: "shutdown"

But the bigger issue is that multipathd is now stopped, and running
"multipath" doesn't bring it back again. You will create the multipath
devices, but nothing will be monitoring them.  The same thing happens if
the multipathd service is started before the any multipathable devices
are discovered.  It starts up and then shuts back down (again tripping
the watchdog timer). When those devices finally get discovered, there is
nothing to listening for the uevents, so no multipath devices ever get
created.

I must be missing something here.

-Ben

On Fri, Nov 15, 2013 at 11:29:44AM +0100, Hannes Reinecke wrote:
> This patchs implements the 'no_map_shutdown' configuration option.
> Idea is that the daemon will exit if no maps are found, as then
> there's nothing to be done for the daemon anyway.
> The daemon will be restarted via socket activation for any CLI
> command.
> This this option the multipathd.socket unit can be activated always
> and won't add to the overall system load.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/config.h         |  1 +
>  libmultipath/dict.c           | 32 ++++++++++++++++++++++++++++++++
>  multipath.conf.annotated      |  9 +++++++++
>  multipath/multipath.conf.5    |  7 +++++++
>  multipathd/main.c             | 20 +++++++++++++++-----
>  multipathd/multipathd.8       |  4 ++++
>  multipathd/multipathd.service |  2 +-
>  7 files changed, 69 insertions(+), 6 deletions(-)
> 
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 9c467e8..590fb32 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -103,6 +103,7 @@ struct config {
>  	int fast_io_fail;
>  	unsigned int dev_loss;
>  	int log_checker_err;
> +	int no_map_shutdown;
>  	int allow_queueing;
>  	uid_t uid;
>  	gid_t gid;
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 0bf9587..da706f7 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -545,6 +545,25 @@ def_log_checker_err_handler(vector strvec)
>  }
>  
>  static int
> +def_no_map_shutdown_handler(vector strvec)
> +{
> +	char * buff;
> +
> +	buff = set_value(strvec);
> +	if (!buff)
> +		return 1;
> +
> +	if (!strncmp(buff, "on", 2) || !strncmp(buff, "yes", 3) ||
> +		 !strncmp(buff, "1", 1))
> +		conf->no_map_shutdown = 1;
> +	else
> +		conf->no_map_shutdown = 0;
> +
> +	free(buff);
> +	return 0;
> +}
> +
> +static int
>  def_reservation_key_handler(vector strvec)
>  {
>  	char *buff;
> @@ -2714,6 +2733,18 @@ snprint_def_log_checker_err (char * buff, int len, void * data)
>  }
>  
>  static int
> +snprint_def_no_map_shutdown (char * buff, int len, void * data)
> +{
> +	switch (conf->no_map_shutdown) {
> +	case 0:
> +		return snprintf(buff, len, "\"no\"");
> +	case 1:
> +		return snprintf(buff, len, "\"yes\"");
> +	}
> +	return 0;
> +}
> +
> +static int
>  snprint_def_user_friendly_names (char * buff, int len, void * data)
>  {
>  	if (conf->user_friendly_names  == USER_FRIENDLY_NAMES_ON)
> @@ -2850,6 +2881,7 @@ init_keywords(void)
>  	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
>  	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler_handler);
>  	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
> +	install_keyword("no_map_shutdown", &def_no_map_shutdown_handler, &snprint_def_no_map_shutdown);
>  	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
>  	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
>  	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
> diff --git a/multipath.conf.annotated b/multipath.conf.annotated
> index a20302c..4b56bc8 100644
> --- a/multipath.conf.annotated
> +++ b/multipath.conf.annotated
> @@ -215,6 +215,15 @@
>  #	user_friendly_names no
>  #
>  #	#
> +#	# name    : no_map_shutdown
> +#	# scope   : multipathd
> +#	# desc    : If set to "yes" the multipath daemon will terminate
> +#	#           if no multipath devices have been found.
> +#	# values  : yes|no
> +#	# default : no
> +#	no_map_shutdown no
> +#
> +#	#
>  #	# name    : mode
>  #	# scope   : multipath & multipathd
>  #	# desc    : The mode to use for the multipath device nodes, in octal.
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index cf5bec0..dba0027 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -409,6 +409,13 @@ will automatically use the
>  .I alua
>  prioritizer. If not, the prioritizer will be selected as usual. Default is
>  .I no
> +.TP
> +.B no_map_shutdown
> +If set to
> +.I yes
> +, the multipath daemon will terminate if no multipath devices are found.
> +Default is
> +.I no
>  .
>  .SH "blacklist section"
>  The
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d386e0a..d4a5809 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1026,11 +1026,11 @@ followover_should_failback(struct path * pp)
>  	return 1;
>  }
>  
> -static void
> +static int
>  defered_failback_tick (vector mpvec)
>  {
>  	struct multipath * mpp;
> -	unsigned int i;
> +	unsigned int i, mpp_count = 0;
>  
>  	vector_foreach_slot (mpvec, mpp, i) {
>  		/*
> @@ -1042,7 +1042,9 @@ defered_failback_tick (vector mpvec)
>  			if (!mpp->failback_tick && need_switch_pathgroup(mpp, 1))
>  				switch_pathgroup(mpp);
>  		}
> +		mpp_count++;
>  	}
> +	return mpp_count;
>  }
>  
>  static void
> @@ -1284,7 +1286,7 @@ checkerloop (void *ap)
>  
>  	while (1) {
>  		struct timeval diff_time, start_time, end_time;
> -		int num_paths = 0;
> +		int num_paths = 0, num_maps = 0;
>  
>  		if (gettimeofday(&start_time, NULL) != 0)
>  			start_time.tv_sec = 0;
> @@ -1300,7 +1302,7 @@ checkerloop (void *ap)
>  			}
>  		}
>  		if (vecs->mpvec) {
> -			defered_failback_tick(vecs->mpvec);
> +			num_maps = defered_failback_tick(vecs->mpvec);
>  			retry_count_tick(vecs->mpvec);
>  		}
>  		if (count)
> @@ -1320,6 +1322,11 @@ checkerloop (void *ap)
>  				num_paths, num_paths > 1 ? "s" : "",
>  				diff_time.tv_sec, diff_time.tv_usec);
>  		}
> +		if (!num_maps && conf->no_map_shutdown) {
> +			condlog(3, "terminating, no multipath devices");
> +			exit_daemon();
> +			break;
> +		}
>  		sleep(1);
>  	}
>  	return NULL;
> @@ -1891,7 +1898,7 @@ main (int argc, char *argv[])
>  	if (!conf)
>  		exit(1);
>  
> -	while ((arg = getopt(argc, argv, ":dsv:k::")) != EOF ) {
> +	while ((arg = getopt(argc, argv, ":dnsv:k::")) != EOF ) {
>  	switch(arg) {
>  		case 'd':
>  			logsink = 0;
> @@ -1904,6 +1911,9 @@ main (int argc, char *argv[])
>  
>  			conf->verbosity = atoi(optarg);
>  			break;
> +		case 'n':
> +			conf->no_map_shutdown = 1;
> +			break;
>  		case 's':
>  			logsink = -1;
>  			break;
> diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
> index 2aea150..eb39c9c 100644
> --- a/multipathd/multipathd.8
> +++ b/multipathd/multipathd.8
> @@ -22,6 +22,10 @@ devmap reconfiguration, so that it can refresh its failed path list.
>  .B \-d
>  Foreground Mode. Don't daemonize, and print all messages to stdout and stderr.
>  .TP
> +.B \-n
> +Oneshot Mode; daemon will terminate if no multipath devices are found.
> +Equivalent to set 'no_map_shutdown' to '1' in the configuration file.
> +.TP
>  .B \-s
>  Suppress timestamps. Do not prefix logging messages with a timestamp.
>  .TP
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
> index 6472dd5..b34667d 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service
> @@ -8,7 +8,7 @@ Conflicts=shutdown.target
>  [Service]
>  Type=notify
>  NotifyAccess=main
> -ExecStart=/sbin/multipathd -d -s
> +ExecStart=/sbin/multipathd -d -s -n
>  ExecReload=/sbin/multipathd reconfigure
>  WatchdogSec=5s
>  LimitCORE=infinity
> -- 
> 1.8.1.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
