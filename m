From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipathd daemon: Fix incorrect use of
 CLOCK_MONOTONIC in pthread
Date: Wed, 9 Aug 2017 15:03:00 +0000
Message-ID: <1502290980.2356.1.camel@wdc.com>
References: <20170809132214.3081-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170809132214.3081-1-fge@redhat.com>
Content-Language: en-US
Content-ID: <472FE497FE28CE4385C29E6A0201B14E@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "fge@redhat.com" <fge@redhat.com>
List-Id: dm-devel.ids

On Wed, 2017-08-09 at 21:22 +0800, Gris Ge wrote:
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index 32d49766..002abe61 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -475,7 +475,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
>  	/*
>  	 * execute handler
>  	 */
> -	if (clock_gettime(CLOCK_MONOTONIC, &tmo) == 0) {
> +	if (clock_gettime(CLOCK_REALTIME, &tmo) == 0) {
>  		tmo.tv_sec += timeout;
>  	} else {
>  		tmo.tv_sec = 0;

Hello Gris,

This is a good catch. Thanks for this fix.

> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4be2c579..67997d08 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -198,7 +198,7 @@ int set_config_state(enum daemon_status state)
>  		if (running_state != DAEMON_IDLE) {
>  			struct timespec ts;
>  
> -			clock_gettime(CLOCK_MONOTONIC, &ts);
> +			clock_gettime(CLOCK_REALTIME, &ts);
>  			ts.tv_sec += 1;
>  			rc = pthread_cond_timedwait(&config_cond,
>  						    &config_lock, &ts);

But this change looks wrong to me. Have you noticed that
pthread_condattr_setclock(&attr, CLOCK_MONOTONIC) is used to make
config_cond use the monotonic clock? See also libmultipath/time-util.c.

Bart.
