From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 07/10] libmultipath: handle TUR threads
 that can't be cancelled
Date: Tue, 23 Oct 2018 14:28:49 -0500
Message-ID: <20181023192849.GA7100@octiron.msp.redhat.com>
References: <20181023134348.17915-1-mwilck@suse.com>
	<20181023134348.17915-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181023134348.17915-2-mwilck@suse.com>
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

On Tue, Oct 23, 2018 at 03:43:45PM +0200, Martin Wilck wrote:
> When the tur checker code determines that a hanging TUR thread
> couldn't be cancelled, rather than simply returning, reallocate
> the checker context and start a new thread. This will leak some
> memory if the hanging thread never wakes up again, but well, in
> that highly unlikely case we're leaking threads anyway.

The thing about PATH_UNCHECKED is that we do mark the path as failed.
We just don't tell device-mapper. If we get PATH_UNCHECKED in
pathinfo(), we set the state to PATH_DOWN. If we get a PATH_UNCHECKED in
check_path(), we immediately call pathinfo(), making it likely that we
will get PATH_UNCHECKED there as well. The consequence of this is that
if the path later changes to PATH_DOWN, which seems likely, we still
won't tell device-mapper, since as far as multipathd is concerned, the
path hasn't changed state.  Looking at most of the code, the way we
treat PATH_UNCHECKED really only makes sense when we use it to mean we
haven't ever gotten a result from get_state() before.

If you want a return code that does just does nothing with the path,
except wait, that's PATH_PENDING. It leaves the paths state exactly the
same as before. The only issue there is that we schedule another path
checker for a second later, which might not be the right answer to an
out-of-memory issue.

If you've reviewed the code paths that we follow on PATH_UNCHECKED, and
still feel that it is the right answer, I won't block it, because this
is a pretty remote corner case. But I don't like how PATH_UNCHECKED
works like PATH_DOWN, but without actually keeping the state synced with
the kernel, since the rest of the multipathd code is expecting the state
to be synced.
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers/tur.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 41210892..a6c88eb2 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -349,11 +349,29 @@ int libcheck_check(struct checker * c)
>  		}
>  	} else {
>  		if (uatomic_read(&ct->holders) > 1) {
> -			/* The thread has been cancelled but hasn't
> -			 * quit. exit with timeout. */
> +			/*
> +			 * The thread has been cancelled but hasn't quit.
> +			 * We have to prevent it from interfering with the new
> +			 * thread. We create a new context and leave the old
> +			 * one with the stale thread, hoping it will clean up
> +			 * eventually.
> +			 */
>  			condlog(3, "%d:%d : tur thread not responding",
>  				major(ct->devt), minor(ct->devt));
> -			return PATH_TIMEOUT;
> +
> +			/*
> +			 * libcheck_init will replace c->context.
> +			 * It fails only in OOM situations. In this case, return
> +			 * PATH_UNCHECKED to avoid prematurely failing the path.
> +			 */
> +			if (libcheck_init(c) != 0)
> +				return PATH_UNCHECKED;
> +
> +			if (!uatomic_sub_return(&ct->holders, 1))
> +				/* It did terminate, eventually */
> +				cleanup_context(ct);
> +
> +			ct = c->context;
>  		}
>  		/* Start new TUR checker */
>  		pthread_mutex_lock(&ct->lock);
> -- 
> 2.19.1
