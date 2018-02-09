From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Fri, 9 Feb 2018 16:15:34 +0000
Message-ID: <1518192932.2871.11.camel@wdc.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518134167-15938-2-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <5E9E04875CAD8B41928C89B64C5820CD@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "mwilck@suse.com" <mwilck@suse.com>
List-Id: dm-devel.ids

On Thu, 2018-02-08 at 17:56 -0600, Benjamin Marzinski wrote:
>  static void cleanup_func(void *data)
>  {
> -	int holders;
> +	int running, holders;
>  	struct tur_checker_context *ct = data;
> -	pthread_spin_lock(&ct->hldr_lock);
> -	ct->holders--;
> -	holders = ct->holders;
> -	ct->thread = 0;
> -	pthread_spin_unlock(&ct->hldr_lock);
> +
> +	running = uatomic_xchg(&ct->running, 0);
> +	holders = uatomic_sub_return(&ct->holders, 1);
>  	if (!holders)
>  		cleanup_context(ct);
> +	if (!running)
> +		pause();
>  }

Hello Ben,

Why has the pause() call been added? I think it is safe to call pthread_cancel()
for a non-detached thread that has finished so I don't think that pause() call
is necessary.
 
>  static int tur_running(struct tur_checker_context *ct)
>  {
> -	pthread_t thread;
> -
> -	pthread_spin_lock(&ct->hldr_lock);
> -	thread = ct->thread;
> -	pthread_spin_unlock(&ct->hldr_lock);
> -
> -	return thread != 0;
> +	return (uatomic_read(&ct->running) != 0);
>  }

Is such a one line function really useful? I think the code will be easier to read
if this function is inlined into its callers.

> @@ -418,8 +396,12 @@ int libcheck_check(struct checker * c)
>  		    (tur_status == PATH_PENDING || tur_status == PATH_UNCHECKED)) {
>  			condlog(3, "%s: tur checker still running",
>  				tur_devt(devt, sizeof(devt), ct));
> -			ct->running = 1;
>  			tur_status = PATH_PENDING;
> +		} else {
> +			int running = uatomic_xchg(&ct->running, 0);
> +			if (running)
> +				pthread_cancel(ct->thread);
> +			ct->thread = 0;
>  		}
>  	}

Why has this pthread_cancel() call been added? I think that else clause can only be
reached if ct->running == 0 so I don't think that the pthread_cancel() call will ever
be reached.

Thanks,

Bart.
