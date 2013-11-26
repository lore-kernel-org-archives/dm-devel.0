From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 6/9] multipathd: Implement systemd watchdog
	integration
Date: Tue, 26 Nov 2013 12:41:10 -0600
Message-ID: <20131126184110.GO1661@dhcp80-209.msp.redhat.com>
References: <1385466090-24290-1-git-send-email-hare@suse.de>
	<1385466090-24290-7-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1385466090-24290-7-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Tue, Nov 26, 2013 at 12:41:27PM +0100, Hannes Reinecke wrote:
> In the past there have been several instances where multipathd
> would hang with the checkerloop as some path checker might not
> be able to return in time.
> This patch now activates the watchdog feature from systemd
> to shutdown (and possibly restart) multipathd in these
> situations.
> Due to a bug in systemd watchdog integration only works
> correctly with later version (> 206), so watchdog integration
> has been disabled per default on earlier implementations.

I'm still not sure what having multipath restarted gets us.  Is the hope
that on restart, multipath will simply be unable to access the path, and
it will fail there quicker that the checker would?  Otherwise, the
checker will likely get stuck in the same place on the restart. Also,
the checker can get stuck in uninterruptible sleep.  In this case,
systemd isn't going to be able to to restart multipathd until the issue
has already cleared up.

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  multipath/multipath.conf.5       |  7 +++++--
>  multipathd/Makefile              | 11 +++++++++--
>  multipathd/main.c                | 15 ++++++++++++++-
>  multipathd/multipathd.8          | 27 ++++++++++++++++++++++++++-
>  multipathd/multipathd.service    | 17 -----------------
>  multipathd/multipathd.service.in | 17 +++++++++++++++++
>  6 files changed, 71 insertions(+), 23 deletions(-)
>  delete mode 100644 multipathd/multipathd.service
>  create mode 100644 multipathd/multipathd.service.in
> 
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 0fd3035..cf5bec0 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -71,8 +71,11 @@ section recognizes the following keywords:
>  .B polling_interval
>  interval between two path checks in seconds. For properly functioning paths,
>  the interval between checks will gradually increase to
> -.B max_polling_interval;
> -default is
> +.B max_polling_interval.
> +This value will be overridden by the
> +.B WatchdogSec
> +setting in the multipathd.service definition if systemd is used.
> +Default is
>  .I 5
>  .TP
>  .B max_polling_interval
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 781122a..76b93fb 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -32,12 +32,19 @@ OBJS = main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
>  #
>  # directives
>  #
> -all : $(EXEC)
> +all : $(EXEC) $(EXEC).service
>  
>  $(EXEC): $(OBJS)
>  	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC)
>  	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
>  
> +$(EXEC).service: $(EXEC).service.in
> +ifeq ($(shell test $(SYSTEMD) -ge 207 && echo 1), 1)
> +	sed '/ExecReload.*/a WatchdogSec=5s\nRestart=on-failure\nRestartPreventExitStatus=1' $(EXEC).service.in > $(EXEC).service
> +else
> +	cp $(EXEC).service.in $(EXEC).service
> +endif
> +
>  install:
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
>  	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
> @@ -58,5 +65,5 @@ uninstall:
>  	rm -f $(DESTDIR)$(unitdir)/$(EXEC).socket
>  
>  clean:
> -	rm -f core *.o $(EXEC) *.gz
> +	rm -f core *.o $(EXEC) $(EXEC).service *.gz
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d8d1204..448ed39 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1288,6 +1288,7 @@ checkerloop (void *ap)
>  		lock(vecs->lock);
>  		pthread_testcancel();
>  		condlog(4, "tick");
> +		sd_notify(0, "WATCHDOG=1");
>  
>  		if (vecs->pathvec) {
>  			vector_foreach_slot (vecs->pathvec, pp, i) {
> @@ -1587,7 +1588,8 @@ child (void * param)
>  	pthread_attr_t log_attr, misc_attr, uevent_attr;
>  	struct vectors * vecs;
>  	struct multipath * mpp;
> -	int i;
> +	char *envp;
> +	int i, checkint;
>  	int rc, pid_rc;
>  
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
> @@ -1663,6 +1665,17 @@ child (void * param)
>  
>  	conf->daemon = 1;
>  	udev_set_sync_support(0);
> +	envp = getenv("WATCHDOG_USEC");
> +	if (envp && sscanf(envp, "%d", &checkint) == 1) {
> +		/* Value is in microseconds */
> +		checkint = checkint / 1000000;
> +		if (checkint > conf->max_checkint)
> +			conf->max_checkint = checkint;
> +		conf->checkint = checkint;
> +		condlog(3, "set checkint to %d max %d",
> +			conf->checkint, conf->max_checkint);
> +	}
> +
>  	/*
>  	 * Start uevent listener early to catch events
>  	 */
> diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
> index 2aea150..2ccf003 100644
> --- a/multipathd/multipathd.8
> +++ b/multipathd/multipathd.8
> @@ -128,10 +128,35 @@ Restore queuing on multipahted map $map
>  .B quit|exit
>  End interactive session.
>  
> +.SH "SYSTEMD INTEGRATION"
> +When compiled with systemd support two systemd service files are
> +installed,
> +.I multipathd.service
> +and
> +.I multipathd.socket
> +The
> +.I multipathd.socket
> +service instructs systemd to intercept the CLI command socket, so
> +that any call to the CLI interface will start-up the daemon if
> +required.
> +The
> +.I multipathd.service
> +file carries the definitions for controlling the multipath daemon.
> +The daemon itself uses the
> +.B sd_notify(3)
> +interface to communicate with systemd. The multipath daemon supports
> +the
> +.I WatchdogSec=
> +feature from systemd (see \fBsystemd.service(5)\fR).
> +Please note that systemd prior to version 207 has issues which prevent
> +the systemd-provided watchdog from working correctly. So for earlier
> +versions of systemd watchdog support will not be enabled per default.
> +
>  .SH "SEE ALSO"
>  .BR multipath (8)
>  .BR kpartx (8)
> -.BR hotplug (8)
> +.BR sd_notify (3)
> +.BR system.service (5)
>  .SH "AUTHORS"
>  .B multipathd
>  was developed by Christophe Varoqui, <christophe.varoqui@opensvc.com> and others.
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
> deleted file mode 100644
> index 3874bcb..0000000
> --- a/multipathd/multipathd.service
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -[Unit]
> -Description=Device-Mapper Multipath Device Controller
> -Before=iscsi.service iscsid.service lvm2-activation-early.service
> -After=syslog.target
> -DefaultDependencies=no
> -Conflicts=shutdown.target
> -
> -[Service]
> -Type=notify
> -NotifyAccess=main
> -ExecStartPre=/sbin/modprobe dm-multipath
> -ExecStart=/sbin/multipathd -d -s
> -ExecReload=/sbin/multipathd reconfigure
> -
> -[Install]
> -WantedBy=sysinit.target
> -Also=multipathd.socket
> diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
> new file mode 100644
> index 0000000..3874bcb
> --- /dev/null
> +++ b/multipathd/multipathd.service.in
> @@ -0,0 +1,17 @@
> +[Unit]
> +Description=Device-Mapper Multipath Device Controller
> +Before=iscsi.service iscsid.service lvm2-activation-early.service
> +After=syslog.target
> +DefaultDependencies=no
> +Conflicts=shutdown.target
> +
> +[Service]
> +Type=notify
> +NotifyAccess=main
> +ExecStartPre=/sbin/modprobe dm-multipath
> +ExecStart=/sbin/multipathd -d -s
> +ExecReload=/sbin/multipathd reconfigure
> +
> +[Install]
> +WantedBy=sysinit.target
> +Also=multipathd.socket
> -- 
> 1.8.1.4
