From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 1/6] multipathd: fix daemon not really
	shutdown
Date: Wed, 16 Jan 2019 18:05:45 -0600
Message-ID: <20190117000545.GW11315@octiron.msp.redhat.com>
References: <20190104175914.22784-1-mwilck@suse.com>
	<20190104175914.22784-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190104175914.22784-2-mwilck@suse.com>
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
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 04, 2019 at 06:59:09PM +0100, Martin Wilck wrote:
> From: Chongyun Wu <wu.chongyun@h3c.com>
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
> (2) [this part removed by mwilck]
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 99145293..6a5d105a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -247,7 +247,7 @@ int set_config_state(enum daemon_status state)
>  			rc = pthread_cond_timedwait(&config_cond,
>  						    &config_lock, &ts);
>  		}
> -		if (!rc) {
> +		if (!rc && (running_state != DAEMON_SHUTDOWN)) {
>  			running_state = state;
>  			pthread_cond_broadcast(&config_cond);
>  #ifdef USE_SYSTEMD
> -- 
> 2.19.2
