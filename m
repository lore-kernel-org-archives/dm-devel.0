From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] Don't print failure messages for callouts
	by default
Date: Wed, 30 Apr 2008 18:53:37 -0400 (EDT)
Message-ID: <20080430.185337.115902447.k-ueda@ct.jp.nec.com>
References: <20080430090426.D2B4718C6FF@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080430090426.D2B4718C6FF@pentland.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de
Cc: dm-devel@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Hi Hannes,

On Wed, 30 Apr 2008 11:04:26 +0200, hare@suse.de (Hannes Reinecke) wrote:
> Calling 'multipath -ll' on devices with paths results in
> lots of error messages; they really should be suppressed
> for the normal output. The user can always have them printed
> out by increasing verbosity.

In general, serious error messages should be printed by default.
Otherwise, the users (even developers) may overlook serious errors.

Please see the detailed comments below.
 
> @@ -32,7 +33,7 @@ int execute_program(char *path, char *value, int len)
>  	int retval;
>  	int count;
>  	int status;
> -	int fds[2];
> +	int fds[2], null_fd;
>  	pid_t pid;
>  	char *pos;
>  	char arg[PROGRAM_SIZE];
> @@ -75,7 +76,16 @@ int execute_program(char *path, char *value, int len)
>  		close(STDOUT_FILENO);
>  
>  		/* dup write side of pipe to STDOUT */
> -		dup(fds[1]);
> +		if (dup(fds[1]) < 0)
> +			return -1;
> +
> +		/* Ignore writes to stderr */
> +		null_fd = open("/dev/null", O_WRONLY);
> +		if (null_fd > 0) {
> +			close(STDERR_FILENO);
> +			dup(null_fd);
> +			close(null_fd);
> +		}
>  
>  		retval = execv(argv[0], argv);
>  

This looks discarding all error messages from callouts anyway,
even if we want to get them.
Can you use the verbosity setting here, too?


> @@ -642,7 +642,7 @@ get_prio (struct path * pp)
>  	}
>  	pp->priority = prio_getprio(pp->prio, pp);
>  	if (pp->priority < 0) {
> -		condlog(0, "%s: %s prio error", pp->dev, prio_name(pp->prio));
> +		condlog(3, "%s: %s prio error", pp->dev, prio_name(pp->prio));
>  		pp->priority = PRIO_UNDEF;
>  		return 1;
>  	}

When prio_getprio() fails, that path is not used for multipath.
I think that it is a kind of serious error and the verbosity should
be "2" at least.

Why do you need to suppress this message by default?


> @@ -663,7 +663,7 @@ get_uid (struct path * pp)
>  		condlog(0, "error formatting uid callout command");
>  		memset(pp->wwid, 0, WWID_SIZE);
>  	} else if (execute_program(buff, pp->wwid, WWID_SIZE)) {
> -		condlog(0, "error calling out %s", buff);
> +		condlog(3, "error calling out %s", buff);
>  		memset(pp->wwid, 0, WWID_SIZE);
>  		return 1;
>  	}

ditto.

Thanks,
Kiyoshi Ueda
