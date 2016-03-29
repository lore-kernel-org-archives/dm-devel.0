From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH 01/17] multipathd: use /run instead of
	/var/run
Date: Tue, 29 Mar 2016 09:57:25 -0400
Message-ID: <22266.35269.520687.195696@quad.stoffel.home>
References: <1459221194-23222-1-git-send-email-bmarzins@redhat.com>
	<1459221194-23222-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1459221194-23222-2-git-send-email-bmarzins@redhat.com>
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


Benjamin> /var/run is now usually a symlink to /run.  If /var is on a separate
Benjamin> filesytem, when multipathd starts up, it might end up writing to
Benjamin> /var/run before the /var filesytem is mounted and thus not have its
Benjamin> pidfile accessible at /var/run afterwards.  On most distrubutions /run
Benjamin> is now a tmpfs and should always be available before multipathd is
Benjamin> started, so multipath should just write there directly, instead of
Benjamin> through the symlink.

I'm not sure I agree with this, it really smells more like a
distribution problem, than a multipathd problem.  If multipathd starts
up in an initramfs, how does it get reset to the proper /var/run or
/run directory then?

And especially if it's a symlink, we shouldn't care at all either.

What distros are using /run instead of /var/run these days?

John


Benjamin> If /var/run is not a symlink, continue using it.

Benjamin> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Benjamin> ---
Benjamin>  Makefile.inc                    | 10 +++++++++-
Benjamin>  libmultipath/defaults.h         |  2 +-
Benjamin>  multipathd/multipathd.init.suse |  2 +-
Benjamin>  3 files changed, 11 insertions(+), 3 deletions(-)

Benjamin> diff --git a/Makefile.inc b/Makefile.inc
Benjamin> index c3ed73f..357dd33 100644
Benjamin> --- a/Makefile.inc
Benjamin> +++ b/Makefile.inc
Benjamin> @@ -21,6 +21,14 @@ ifndef LIB
Benjamin>  	endif
Benjamin>  endif
 
Benjamin> +ifndef RUN
Benjamin> +	ifeq ($(shell test -L /var/run -o ! -d /var/run && echo 1),1)
Benjamin> +		RUN=run
Benjamin> +	else
Benjamin> +		RUN=var/run
Benjamin> +	endif
Benjamin> +endif
Benjamin> +
Benjamin>  ifndef SYSTEMD
Benjamin>  	ifeq ($(shell systemctl --version > /dev/null 2>&1 && echo 1), 1)
Benjamin>  		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\)/\1/p')
Benjamin> @@ -54,7 +62,7 @@ ifndef RPM_OPT_FLAGS
Benjamin>  endif
 
Benjamin>  OPTFLAGS     = $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
Benjamin> -CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\"
Benjamin> +CFLAGS	     = $(OPTFLAGS) -fPIC -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
Benjamin>  SHARED_FLAGS = -shared
 
Benjamin>  %.o:	%.c
Benjamin> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
Benjamin> index 8902f40..cf1d5be 100644
Benjamin> --- a/libmultipath/defaults.h
Benjamin> +++ b/libmultipath/defaults.h
Benjamin> @@ -26,7 +26,7 @@
Benjamin>  #define MAX_CHECKINT(a)		(a << 2)
 
Benjamin>  #define MAX_DEV_LOSS_TMO	0x7FFFFFFF
Benjamin> -#define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
Benjamin> +#define DEFAULT_PIDFILE		"/" RUN_DIR "/multipathd.pid"
Benjamin>  #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
Benjamin>  #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
Benjamin>  #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
Benjamin> diff --git a/multipathd/multipathd.init.suse b/multipathd/multipathd.init.suse
Benjamin> index d1319b1..ed699fa 100644
Benjamin> --- a/multipathd/multipathd.init.suse
Benjamin> +++ b/multipathd/multipathd.init.suse
Benjamin> @@ -17,7 +17,7 @@
 
Benjamin>  PATH=/bin:/usr/bin:/sbin:/usr/sbin
Benjamin>  DAEMON=/sbin/multipathd
Benjamin> -PIDFILE=/var/run/multipathd.pid
Benjamin> +PIDFILE=/run/multipathd.pid
Benjamin>  MPATH_INIT_TIMEOUT=10
Benjamin>  ARGS=""
 
Benjamin> -- 
Benjamin> 1.8.3.1

Benjamin> --
Benjamin> dm-devel mailing list
Benjamin> dm-devel@redhat.com
Benjamin> https://www.redhat.com/mailman/listinfo/dm-devel
