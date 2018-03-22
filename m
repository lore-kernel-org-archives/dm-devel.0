From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/2] multipathd: handle errors in uxlsnr as
	fatal
Date: Thu, 22 Mar 2018 18:31:54 -0500
Message-ID: <20180322233154.GD3103@octiron.msp.redhat.com>
References: <20180320165010.15259-1-mwilck@suse.com>
	<20180320165010.15259-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180320165010.15259-2-mwilck@suse.com>
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

On Tue, Mar 20, 2018 at 05:50:10PM +0100, Martin Wilck wrote:
> The ppoll() calls of the uxlsnr thread are vital for proper functioning of
> multipathd. If the uxlsnr thread can't open the socket or fails to call ppoll()
> for other reasons, quit the daemon. If we don't do that, multipathd may
> hang in a state where it can't be terminated any more, because the uxlsnr
> thread is responsible for handling all signals. This happens e.g. if
> systemd's multipathd.socket is running in and multipathd is started from
> outside systemd.
> 
> 24f2844 "multipathd: fix signal blocking logic" has made this problem more
> severe. Before that patch, the signals weren't actually blocked in any thread.
> That's not to say 24f2844 was wrong. I still think it's correct, we just
> need this one on top.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/uxlsnr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index cdafd82943e7..6f666663fc6f 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -178,7 +178,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
>  
>  	if (ux_sock == -1) {
>  		condlog(1, "could not create uxsock: %d", errno);
> -		return NULL;
> +		exit_daemon();
>  	}
>  
>  	pthread_cleanup_push(uxsock_cleanup, (void *)ux_sock);
> @@ -187,7 +187,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
>  	polls = (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct pollfd));
>  	if (!polls) {
>  		condlog(0, "uxsock: failed to allocate poll fds");
> -		return NULL;
> +		exit_daemon();
>  	}
>  	sigfillset(&mask);
>  	sigdelset(&mask, SIGINT);
> @@ -249,6 +249,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
>  
>  			/* something went badly wrong! */
>  			condlog(0, "uxsock: poll failed with %d", errno);
> +			exit_daemon();
>  			break;
>  		}
>  
> -- 
> 2.16.1
