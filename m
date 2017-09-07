From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/4] multipath: delegate dangerous commands
	to multipathd
Date: Thu, 7 Sep 2017 16:57:58 -0500
Message-ID: <20170907215758.GE3145@octiron.msp.redhat.com>
References: <20170828220536.13208-1-mwilck@suse.com>
	<20170828220536.13208-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170828220536.13208-4-mwilck@suse.com>
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

On Tue, Aug 29, 2017 at 12:05:36AM +0200, Martin Wilck wrote:
> Some multipath commands are dangerous to run while multipathd is running.
> For example, "multipath -r" may apply a modified configuration to the kernel,
> while multipathd is still using the old configuration, leading to
> inconsistent state between multipathd and the kernel.
> 
> It is safer to use equivalent multipathd client commands instead.
> For now, do this only for "multipath -r", but other invocations
> may be added in the future. Perhaps some day, all "multipath"
> commands will be mapped to multipathd actions.

Thanks. I've been meaning to do something like this forever.

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc     |  2 +-
>  multipath/main.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 29c290a2..d012b3d7 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -90,7 +90,7 @@ OPTFLAGS	= -O2 -g -pipe -Wall -Wextra -Wformat=2 -Werror=implicit-int \
>  		  -Wp,-D_FORTIFY_SOURCE=2 $(STACKPROT) \
>  		  --param=ssp-buffer-size=4
>  
> -CFLAGS		= $(OPTFLAGS) -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
> +CFLAGS		= $(OPTFLAGS) -D BIN_DIR=\"$(bindir)\" -DLIB_STRING=\"${LIB}\" -DRUN_DIR=\"${RUN}\"
>  BIN_CFLAGS	= -fPIE -DPIE
>  LIB_CFLAGS	= -fPIC
>  SHARED_FLAGS	= -shared
> diff --git a/multipath/main.c b/multipath/main.c
> index dede017e..b54aa9bb 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -502,6 +502,74 @@ get_dev_type(char *dev) {
>  	return DEV_NONE;
>  }
>  
> +/*
> + * Some multipath commands are dangerous to run while multipathd is running.
> + * For example, "multipath -r" may apply a modified configuration to the kernel,
> + * while multipathd is still using the old configuration, leading to
> + * inconsistent state.
> + *
> + * It is safer to use equivalent multipathd client commands instead.
> + */
> +int delegate_to_multipathd(enum mpath_cmds cmd, const struct config *conf)
> +{
> +#define DELEGATE_MAX_ARGS 5
> +	int fd = mpath_connect();
> +	char mpd_path[PATH_MAX];
> +	char *argv[DELEGATE_MAX_ARGS];
> +	char log[4096], *p;
> +	char verbosity[2] = { '0', '\0' };
> +	int idx = 1, cmd_idx, sz, n, i;
> +
> +	if (fd == -1)
> +		return 0;
> +	close(fd);
> +
> +	if (conf->verbosity > 0 && conf->verbosity < 8)
> +		verbosity[0] = '0' + conf->verbosity;
> +	argv[idx++] = "-v";
> +	argv[idx++] = verbosity;
> +
> +	cmd_idx = idx;
> +	if (cmd == CMD_CREATE && conf->force_reload == FORCE_RELOAD_YES) {
> +		argv[idx++] = "reconfigure";
> +	} /* Add other translations here */
> +
> +	if (idx == cmd_idx)
> +		/* No command found, no need to delegate */
> +		return 0;
> +	else if (idx >= DELEGATE_MAX_ARGS) {
> +		condlog(0, "internal error - argv overflow");
> +		exit(1);
> +	}

Why not just return 0 here, so that we can try the failing back to the
multipath code. In the longer term, it's definitely worth asking if that
code needs to exist at all, of if a large chunk of multipath code can
just turn into wrapped calls to multipathd.

> +
> +	argv[idx] = NULL;
> +	snprintf(mpd_path, sizeof(mpd_path), "%s/%s", BIN_DIR, "multipathd");
> +	argv[0] = mpd_path;
> +
> +	condlog(1, "delegating command to multipathd");
> +
> +	sz = sizeof(log);
> +	p = log;
> +	i = 0;
> +	n = snprintf(p, sz, "command: %s", argv[i++]);
> +	while (i < idx && n < sz) {
> +		sz -= n;
> +		p += n;
> +		n = snprintf(p, sz, " %s", argv[i++]);
> +	}
> +	condlog(2, "%s", log);
> +	if (n >= sz)
> +		condlog(2, "(command on previous line was truncated)");
> +
> +	if (execv(mpd_path, argv) == -1) {
> +		condlog(0, "failed to execute multipathd: %s", strerror(errno));
> +		exit(1);
> +	}

Why exec multipathd, instead of using the libmpathcmd api, like
mpathpersist, libdmmp, and the multipathd client do?

-Ben

> +
> +	/* not reached */
> +	return 1;
> +}
> +
>  int
>  main (int argc, char *argv[])
>  {
> @@ -695,10 +763,15 @@ main (int argc, char *argv[])
>  		} else
>  			mpath_disconnect(fd);
>  	}
> +
>  	if (cmd == CMD_REMOVE_WWID && !dev) {
>  		condlog(0, "the -w option requires a device");
>  		goto out;
>  	}
> +
> +	if (delegate_to_multipathd(cmd, conf))
> +		exit(0); /* not reached */
> +
>  	if (cmd == CMD_RESET_WWIDS) {
>  		struct multipath * mpp;
>  		int i;
> -- 
> 2.14.0
