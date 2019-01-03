From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipathd: fix daemon not really shutdown
Date: Thu, 03 Jan 2019 11:23:02 +0100
Message-ID: <3ef4c4debc9b0e56134f45d4a18693e4e8e18c0c.camel@suse.de>
References: <CEB9978CF3252343BE3C67AC9F0086A3651A76AD@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A3651A76AD@H3CMLB14-EX.srv.huawei-3com.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

Chongyun, 

On Wed, 2018-12-26 at 06:34 +0000, Chongyun Wu wrote:
> Hi Martin and Ben,
> 
> Cloud you help to review this patch, thanks.
> 
> Test environment: 25 hosts, each host have more than 100 luns,
> each lun have two paths.
> Some times when we try to ceate new multipath will encounter "could
> not create uxsock:98" but the multipathd still running not shutdown
> and can't response any multipathd commands also.
> 
> After reproduce this issue and debug, found below fixes might work:
> (1) set_config_state() after pthread_cond_timedwait() other threads
> might changed the running_state from DAEMON_SHUTDOWN to other status
> like DAEMON_IDLE, which will make the shutdown process stopped.
> I found logs to prove this really happened, so we need add judgement
> here too.
> 
> (2) process exit signal as possible as we can.
> If we just set a flag and wait handle_signals to handle exit signal,
> there might have more 5s to wait because of ppoll maximal wait time.
> And there might haven't enouth time left for all threads to clean up
> and exit.
> 
> With this patch our tester not report this issue again.

please verify that you were using the latest upstream code,
in particular that f1c73962 "multipathd: make DAEMON_SHUTDOWN a
terminal state" and the predecessors 9de272eb, 234cab29 are
included in your code base. I made these patches
for the problem you are describing, and it worked for me.

Martin



> 
> Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> ---
>   multipathd/main.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 991452930433..620b8264c82f 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -141,7 +141,6 @@ struct udev * udev;
>   struct config *multipath_conf;
> 
>   /* Local variables */
> -static volatile sig_atomic_t exit_sig;
>   static volatile sig_atomic_t reconfig_sig;
>   static volatile sig_atomic_t log_reset_sig;
> 
> @@ -247,7 +246,7 @@ int set_config_state(enum daemon_status state)
>   			rc = pthread_cond_timedwait(&config_cond,
>   						    &config_lock, &ts);
>   		}
> -		if (!rc) {
> +		if (!rc && (running_state != DAEMON_SHUTDOWN)) {
>   			running_state = state;
>   			pthread_cond_broadcast(&config_cond);
>   #ifdef USE_SYSTEMD
> @@ -2517,11 +2516,6 @@ signal_set(int signo, void (*func) (int))
>   void
>   handle_signals(bool nonfatal)
>   {
> -	if (exit_sig) {
> -		condlog(2, "exit (signal)");
> -		exit_sig = 0;
> -		exit_daemon();
> -	}
>   	if (!nonfatal)
>   		return;
>   	if (reconfig_sig) {
> @@ -2546,7 +2540,8 @@ sighup (int sig)
>   static void
>   sigend (int sig)
>   {
> -	exit_sig = 1;
> +	condlog(2, "exit (signal)");
> +	exit_daemon();
>   }
> 
>   static void
