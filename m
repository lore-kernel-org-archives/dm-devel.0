From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 6/8] libmultipath: test code for "zombie" TUR
	threads
Date: Fri, 12 Oct 2018 16:51:53 -0500
Message-ID: <20181012215153.GI29125@octiron.msp.redhat.com>
References: <20181010200506.15796-1-mwilck@suse.com>
	<20181010200506.15796-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181010200506.15796-7-mwilck@suse.com>
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

On Wed, Oct 10, 2018 at 10:05:04PM +0200, Martin Wilck wrote:
> This patch adds test code that simulates hanging, non-cancellable
> TUR threads, for testing multipathd's behavior in that situation.
> Compile libmultipath with CFLAGS=-DTUR_TEST_MAJOR=8 to activate
> the test code. Without that flag, the patch has no effect.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/tur.c | 45 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index b2a21707..a986a244 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -196,6 +196,50 @@ static void cleanup_func(void *data)
>  	rcu_unregister_thread();
>  }
>  
> +/*
> + * Test code for "zombie tur thread" handling.
> + * Compile e.g. with CFLAGS=-DTUR_TEST_MAJOR=8
> + * Additional parameters can be configure with the macros below.
> + *
> + * Everty nth started TUR thread will hang in non-cancellable state
> + * for given number of seconds, for device given by major/minor.
> + */
> +#ifdef TUR_TEST_MAJOR
> +
> +#ifndef TUR_TEST_MINOR
> +#define TUR_TEST_MINOR 0
> +#endif
> +#ifndef TUR_SLEEP_INTERVAL
> +#define TUR_SLEEP_INTERVAL 3
> +#endif
> +#ifndef TUR_SLEEP_SECS
> +#define TUR_SLEEP_SECS 60
> +#endif
> +
> +static void tur_deep_sleep(const struct tur_checker_context *ct)
> +{
> +	static int sleep_cnt;
> +	const struct timespec ts = { .tv_sec = TUR_SLEEP_SECS, .tv_nsec = 0 };
> +	int oldstate;
> +
> +	if (ct->devt != makedev(TUR_TEST_MAJOR, TUR_TEST_MINOR) ||
> +	    ++sleep_cnt % TUR_SLEEP_INTERVAL != 0)
> +		return;
> +
> +	condlog(1, "tur thread going to sleep for %ld seconds", ts.tv_sec);
> +	if (pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &oldstate) != 0)
> +		condlog(0, "pthread_setcancelstate: %m");
> +	if (nanosleep(&ts, NULL) != 0)
> +		condlog(0, "nanosleep: %m");
> +	condlog(1, "tur zombie thread woke up");
> +	if (pthread_setcancelstate(oldstate, NULL) != 0)
> +		condlog(0, "pthread_setcancelstate (2): %m");
> +	pthread_testcancel();
> +}
> +#else
> +#define tur_deep_sleep(x) do {} while (0)
> +#endif /* TUR_TEST_MAJOR */
> +
>  static void *tur_thread(void *ctx)
>  {
>  	struct tur_checker_context *ct = ctx;
> @@ -209,6 +253,7 @@ static void *tur_thread(void *ctx)
>  	condlog(3, "%d:%d : tur checker starting up", major(ct->devt),
>  		minor(ct->devt));
>  
> +	tur_deep_sleep(ct);
>  	state = tur_check(ct->fd, ct->timeout, msg);
>  	pthread_testcancel();
>  
> -- 
> 2.19.0
