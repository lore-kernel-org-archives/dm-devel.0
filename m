From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 3/6] multipathd: adopt static char* arr in
 sd_notify_status func
Date: Mon, 17 Aug 2020 10:35:40 +0200
Message-ID: <e5de8fe451462738776acb8c4107e729828e87a2.camel@suse.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
	<2d7cd13e-d1df-5fc7-9403-1f845faf64d7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2d7cd13e-d1df-5fc7-9403-1f845faf64d7@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, bmarzins@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

On Sun, 2020-08-16 at 09:44 +0800, Zhiqiang Liu wrote:
> We adopt static char* array (sd_notify_status_msg) in
> sd_notify_status func, so it looks more simpler and easier
> to expand.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  multipathd/main.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index cab1d0d..a09ccd1 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -177,23 +177,21 @@ daemon_status(void)
>   * I love you too, systemd ...
>   */
>  #ifdef USE_SYSTEMD
> +static const char *sd_notify_status_msg[DAEMON_STATUS_SIZE] = {
> +	[DAEMON_INIT] = "STATUS=init",
> +	[DAEMON_START] = "STATUS=startup",
> +	[DAEMON_CONFIGURE] = "STATUS=configure",
> +	[DAEMON_IDLE] = "STATUS=up",
> +	[DAEMON_RUNNING] = "STATUS=up",
> +	[DAEMON_SHUTDOWN] = "STATUS=shutdown",
> +};
> +

This repetition of "STATUS=" looks clumsy. It's not your fault, because
the current code does the same thing. But if you want to clean this up,
please create the notification string in a dynamic buffer, and use
daemon_status() for those cases where it applies.

Regards
Martin

>  static const char *
>  sd_notify_status(enum daemon_status state)
>  {
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
> +	if (state < DAEMON_INIT || state >= DAEMON_STATUS_SIZE)
> +		return NULL;
> +	return sd_notify_status_msg[state];
>  }
> 
>  static void do_sd_notify(enum daemon_status old_state,
