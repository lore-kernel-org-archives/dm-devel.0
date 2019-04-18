From: Martin Wilck <mwilck@suse.de>
Subject: Re: [RFC PATCH] multipath: check on multipathd without
	starting it
Date: Thu, 18 Apr 2019 22:30:40 +0200
Message-ID: <6a618273a647908773d832b3f71a08278379cc5d.camel@suse.de>
References: <1555609786-25156-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1555609786-25156-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, ematsumiya@suse.com
List-Id: dm-devel.ids

Hi Ben,

On Thu, 2019-04-18 at 12:49 -0500, Benjamin Marzinski wrote:
> When "multipath -u" is run, it checks if multipathd is running.
> Currently it does this by trying to connect to the mutipathd socket.
> This can cause problems during boot.  The multipathd.socket systemd
> unit
> file will cause "multipath -u" to wait until multipathd has been
> started
> before continuing.  

Thanks a lot for this. We were hunting several similar problems lately,
and were beginning to suspect exactly this. The main reason that we
haven't come up with a patch like this is that I refused to believe
this could happen - here is why.

We've had the patch d7188fc "multipathd: start daemon after udev
trigger" out in the field since November 2016. That patch moves
multipathd's start (but not the start of multipathd.socket!) to after
"udev settle" has finished. What we've been observing lately seems to
be this:

 - start multipathd.socket
 - start systemd-udev-trigger
 - start systemd-udev-settle
 - SCSI disk found, "add" uevent generated
 - multipath -u
   - opens socket
 - systemd queues a job to start multipathd, but doesn't start it
because "udev settle" isn't finished yet
   - now "multipath -u" hangs ...

... which is basically a deadlock situation which causes either the
uevent, or "udev settle" itself, or both, to time out before usable
devices are found. The system is almost certain to end up in emergency
mode. And it's not even a matter of lots of udev activity.

What I'm really puzzled about is that I have never observed this in the
last 2 years, and it'd be almost certain to generate dozens of bug
reports quickly, which it is currently doing.

 ** Is it possible that something has changed in the way systemd
handles opening the socket and starting the associated service? **

> >If there is a lot of activity on the system,
> multipathd may not start up immediately, causing block device
> initialization to be delayed, potentially until after systemd times
> waiting for the device.  To avoid this, multipath now checks if
> multipathd is running by reading /run/multipathd.pid and checking the
> /proc/<pid>/comm to verify that multipathd is really running with
> this
> pid. This avoids forcing "multipath -u" to wait on multipathd
> starting
> up.
> 
> As an alternative to this patch, multipath could simply switch the
> order
> of the calls to systemd_service_enabled() and mpath_connect().
>  This would
> make multipath only try to connect with multipathd if it wasn't
> enabled in
> systemd, so that it wouldn't autostart.

If my above analysis is correct, it'd be sufficient to revert d7188fc 
and start multipathd before udev trigger and udev settle again, as it
used to be. I've been thinking about this for some time, IMO it would
be actually the "Right Thing" in the long term. The problem is that we
need to be sure that multipathd would deal gracefully with encountering
multipath maps during startup where none of the constituent paths are
in the udev database (yet), and where it might take considerable time
until these paths appear.

> Another alternative is to do away with multipathd.socket. Since
> multipathd
> needs to always be running in order to get uevents, there isn't much
> value
> in having it autoactivate when it gets an interactive command.

Some people may still be running without the daemon and just work with
"multipath" commands. It "works", just that uevents aren't received and
paths aren't reinstated; we've never officially deprecated it. I think
we need the socket for the time being, for the "delegate dangerous
commands to user space" feature in multipath.

One of our customers worked around the problem by adding an
After=systemd-udev-settle.service to multipathd.socket, too. That
way socket activation doesn't happen; it seems to "work" too, but it
wouldn't be my preferred solution.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

The patch looks good to me. 

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>  multipath/main.c | 60 +++++++++++++++++++++++++++++++++++++++++++---
> --
>  1 file changed, 54 insertions(+), 6 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 69141dbc..008e3d3f 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -850,6 +850,58 @@ out:
>  	return r;
>  }
>  
> +int is_multipathd_running(void)
> +{
> +	FILE *f = NULL;
> +	char buf[16];
> +	char path[PATH_MAX];
> +	int pid;
> +	char *end;
> +
> +	f = fopen(DEFAULT_PIDFILE, "r");
> +	if (!f) {
> +		if (errno != ENOENT)
> +			condlog(4, "can't open " DEFAULT_PIDFILE ":
> %s",
> +				strerror(errno));
> +		return 0;
> +	}
> +	if (!fgets(buf, sizeof(buf), f)) {
> +		if (ferror(f))
> +			condlog(4, "read of " DEFAULT_PIDFILE " failed:
> %s",
> +				strerror(errno));
> +		fclose(f);
> +		return 0;
> +	}
> +	fclose(f);
> +	errno = 0;
> +	strchop(buf);
> +	pid = strtol(buf, &end, 10);
> +	if (errno != 0 || pid <= 0 || *end != '\0') {
> +		condlog(4, "invalid contents in " DEFAULT_PIDFILE ":
> '%s'",
> +			buf);
> +		return 0;
> +	}
> +	snprintf(path, sizeof(path), "/proc/%d/comm", pid);
> +	f = fopen(path, "r");
> +	if (!f) {
> +		if (errno != ENOENT)
> +			condlog(4, "can't open %s: %s", path,
> strerror(errno));artin
> +		return 0;
> +	}
> +	if (!fgets(buf, sizeof(buf), f)) {
> +		if (ferror(f))
> +			condlog(4, "read of %s failed: %s", path,
> +				strerror(errno));
> +		fclose(f);
> +		return 0;
> +	}
> +	fclose(f);
> +	strchop(buf);
> +	if (strcmp(buf, "multipathd") != 0)
> +		return 0;
> +	return 1;
> +}
> +
>  int
>  main (int argc, char *argv[])
>  {
> @@ -1028,17 +1080,13 @@ main (int argc, char *argv[])
>  	}
>  	if (cmd == CMD_VALID_PATH &&
>  	    dev_type == DEV_UEVENT) {
> -		int fd;
> -
> -		fd = mpath_connect();
> -		if (fd == -1) {
> +		if (!is_multipathd_running()) {
>  			condlog(3, "%s: daemon is not running", dev);
>  			if (!systemd_service_enabled(dev)) {
>  				r = print_cmd_valid(RTVL_NO, NULL,
> conf);
>  				goto out;
>  			}
> -		} else
> -			mpath_disconnect(fd);
> +		}
>  	}
>  
>  	if (cmd == CMD_REMOVE_WWID && !dev) {
