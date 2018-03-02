From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipathd: fix inverted signal blocking
	logic
Date: Fri, 2 Mar 2018 21:35:14 +0000
Message-ID: <1520026513.2855.30.camel@wdc.com>
References: <20180302200048.GJ14513@octiron.msp.redhat.com>
	<20180302211807.11434-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180302211807.11434-1-mwilck@suse.com>
Content-Language: en-US
Content-ID: <659FC65439BE3748B435862DF538B3A3@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2018-03-02 at 22:18 +0100, Martin Wilck wrote:
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 61739ac6ea59..85ee9b713d75 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2270,10 +2270,13 @@ signal_init(void)
>  {
>  	sigset_t set;
>  
> -	sigemptyset(&set);
> -	sigaddset(&set, SIGUSR2);
> +	/* block all signals */
> +	sigfillset(&set);
> +	/* SIGPIPE occurs if logging fails */
> +	sigdelset(&set, SIGPIPE);
>  	pthread_sigmask(SIG_SETMASK, &set, NULL);

The modified code was introduced by commit 90dd424afa65 ("multipathd:
fix SIGUSR2 handling"). This change looks fine to me.

> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index 98ac25a68c43..a2ca36ba1653 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -170,11 +170,11 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
>  		condlog(0, "uxsock: failed to allocate poll fds");
>  		return NULL;
>  	}
> -	sigemptyset(&mask);
> -	sigaddset(&mask, SIGINT);
> -	sigaddset(&mask, SIGTERM);
> -	sigaddset(&mask, SIGHUP);
> -	sigaddset(&mask, SIGUSR1);
> +	sigfillset(&mask);
> +	sigdelset(&mask, SIGINT);
> +	sigdelset(&mask, SIGTERM);
> +	sigdelset(&mask, SIGHUP);
> +	sigdelset(&mask, SIGUSR1);
>  	while (1) {
>  		struct client *c, *tmp;
>  		int i, poll_count, num_clients;

This change looks more complicated to me than necessary. Have you considered
to pass an empty signal set as the fourth ppoll() argument?

Thanks,

Bart.
