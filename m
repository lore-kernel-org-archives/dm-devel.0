From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipathd: fix SIGUSR2 handling
Date: Tue, 3 Jan 2017 12:59:09 -0600
Message-ID: <20170103185909.GB2732@octiron.msp.redhat.com>
References: <1482998174-11884-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1482998174-11884-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, bart.vanassche@sandisk.com, mwilck@suse.com
List-Id: dm-devel.ids

On Thu, Dec 29, 2016 at 03:56:14PM +0800, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> SIGUSR2 is not blocked by default, it would cause bellow conflict
> in removing of the last path:

ACK

-Ben

> -------------------------------------------------------------
> uevent processing thread                 | waiter thread
> -----------------------------------------|-------------------
> uev_remove_path()                        |   waiteventloop()
>   lock(&vecs->lock)                      |
>   ev_remove_path()                       |     
>     dm_queue_if_no_path()----------------|----> dm_task_run()	
>     flush_map()                          |      |
>       remove_map_and_stop_waiter()       |      -> pthread_cleanup_push(cleanup_lock, &waiter->vecs->lock);
>         _remove_map()                    |         lock(&waiter->vecs->lock)//wait for the locker	
>           stop_waiter_thread()           |         
>             pthread_cancel(thread)       |          
>             pthread_kill(thread,SIGUSR2)-|------> sigusr2 (int sig)
>                                          |          condlog()
>                                          |          fprintf() //it has test cancel point
>                                          |          cleanup_lock() //thread cancel, and pop, which unlock the 
>                                          |                           locker of uevent processing thread 
> --------------------------------------------------------------
> Since SIGUSR2 is only needed when waiter thread running in dm_task_run(),
> and it has already been unblocked before dm_task_run(), so this patch block 
> SIGUSR2 for other times.
> 
> Change-Id: I8c46292dc954415764ebbe054498b4f7ea53c1c6
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  multipathd/main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index adc3258..fe69abd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2181,6 +2181,12 @@ sigusr2 (int sig)
>  static void
>  signal_init(void)
>  {
> +	sigset_t set;
> +
> +	sigemptyset(&set);
> +	sigaddset(&set, SIGUSR2);
> +	pthread_sigmask(SIG_SETMASK, &set, NULL);
> +
>  	signal_set(SIGHUP, sighup);
>  	signal_set(SIGUSR1, sigusr1);
>  	signal_set(SIGUSR2, sigusr2);
> -- 
> 2.8.1.windows.1
> 
