From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2 2/5] multipathd: use daemon_status_msg to
 construct sd notify msg in do_sd_notify func
Date: Fri, 21 Aug 2020 13:12:55 +0200
Message-ID: <e5c780b4f6036eeffac94ada4e837972874a3c22.camel@suse.com>
References: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
	<8e3e5a81-dcd5-b3d5-41c7-2f443b854367@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8e3e5a81-dcd5-b3d5-41c7-2f443b854367@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

On Fri, 2020-08-21 at 18:59 +0800, Zhiqiang Liu wrote:
> sd_notify_status() is very similar with daemon_status(), except
> DAEMON_IDLE and DAEMON_RUNNING state. As suggested by Martin,
> we can create the sd notification string in a dynamic buffer,
> and treat DAEMON_IDLE and DAEMON_RUNNING cases first. Then,
> we can use daemon_status_msg[state] for other cases.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  multipathd/main.c | 36 ++++++++++++++++--------------------
>  1 file changed, 16 insertions(+), 20 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 62cf4ff4..4ba015bb 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -85,6 +85,7 @@
> 
>  #define FILE_NAME_SIZE 256
>  #define CMDSIZE 160
> +#define MSG_SIZE 64
> 
>  #define LOG_MSG(lvl, verb, pp)					
> \
>  do {								\
> @@ -177,28 +178,12 @@ daemon_status(void)
>   * I love you too, systemd ...
>   */
>  #ifdef USE_SYSTEMD
> -static const char *
> -sd_notify_status(enum daemon_status state)
> -{
> -	switch (state) {
> -	case DAEMON_INIT:
> -		return "STATUS=init";
> -	case DAEMON_START:
> -		return "STATUS=startup";
> -	case DAEMON_CONFIGURE:
> -		return "STATUS=configure";
> -	case DAEMON_IDLE:
> -	case DAEMON_RUNNING:
> -		return "STATUS=up";
> -	case DAEMON_SHUTDOWN:
> -		return "STATUS=shutdown";
> -	}
> -	return NULL;
> -}
> -
>  static void do_sd_notify(enum daemon_status old_state,
>  			 enum daemon_status new_state)
>  {
> +	char notify_msg[MSG_SIZE];
> +	const char prefix[] = "STATUS=";
> +	const char *msg = NULL;
>  	/*
>  	 * Checkerloop switches back and forth between idle and running
> state.
>  	 * No need to tell systemd each time.
> @@ -207,7 +192,18 @@ static void do_sd_notify(enum daemon_status
> old_state,
>  	if ((new_state == DAEMON_IDLE || new_state == DAEMON_RUNNING)
> &&
>  	    (old_state == DAEMON_IDLE || old_state == DAEMON_RUNNING))
>  		return;
> -	sd_notify(0, sd_notify_status(new_state));
> +
> +	if (new_state == DAEMON_IDLE || new_state == DAEMON_RUNNING)
> +		msg = "up";
> +	else
> +		msg = daemon_status_msg[new_state];
> +
> +	if (snprintf(notify_msg, MSG_SIZE, "%s%s", prefix, msg) >=
> MSG_SIZE) {
> +		condlog(2, "len of msg is should be shorter than %d",
> MSG_SIZE);

You can *prove* that this condition can never occur (actually, you'll
never need more than 17 bytes - it's ok to have some head room). The
compiler may force you to check the return value, but it's safe to
write simply

if (!safe_sprintf(notify_msg, "%s%s", prefix, msg))
       sd_notify(0, notify_msg);

No error message is necessary here.

Martin

> +		return;
> +	}
> +
> +	sd_notify(0, notify_msg);
>  }
>  #endif
> 
