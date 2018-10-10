From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v4 01/19] libmultipath: fix tur checker
	timeout
Date: Wed, 10 Oct 2018 09:05:17 +0200
Message-ID: <545437a12f7f7f0a3f2a2aa1217062b06fec089e.camel@suse.de>
References: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
	<1539126196-28926-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539126196-28926-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-10-09 at 18:02 -0500, Benjamin Marzinski wrote:
> The code previously was timing out mode if ct->thread was 0 but
> ct->running wasn't. This combination never happens.  The idea was to
> timeout if for some reason the path checker tried to cancel the
> thread,
> but it didn't die.  The correct thing to check for this is ct-
> >holders.
> ct->holders will always be at least one when libcheck_check() is
> called,
> since libcheck_free() won't get called until the device is no longer
> being checked. So, if ct->holders is 2, that means that the tur
> thread
> is has not shut down yet.
> 
> Also, instead of timing out, the tur checker will switch to
> synchronous
> mode.  The chance of this code path happening is very low.  I simply
> exists because the old thread must not interfere with a new thread
> starting up. But if something does go very wrong, and a thread does
> get
> stuck, this solution will keep the checker from just ignoring the
> device
> forever.

Well, the previous tur thread hanging means that future attempts might
hang as well, in which case the synchronous approach would block _all_
path checkers. Wouldn't the following reasoning apply here?

commit 05cbea354172be5507ac83c98bbac8e02aa8cf3c
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Dec 13 13:12:42 2013 +0100

    multipath: do not call tur in sync mode if pthread_cancel fails
    
    When pthread_cancel fails the thread is stuck, most likely
    during I/O submission. So it would be pointless to call the
    tur checker in sync mode here, as this would be stuck, too.

I argued before that the current PATH_TIMEOUT return code is wrong, but
I think it's better than falling back to synchronous mode.

I'm fine with this patch if the return PATH_TIMEOUT remains for now,
and we vow to fix this for good soon.

> s
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers/tur.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index bf8486d..3c5e236 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -355,12 +355,13 @@ int libcheck_check(struct checker * c)
>  		}
>  		pthread_mutex_unlock(&ct->lock);
>  	} else {
> -		if (uatomic_read(&ct->running) != 0) {
> -			/* pthread cancel failed. continue in sync mode
> */
> +		if (uatomic_read(&ct->holders) > 1) {
> +			/* The thread has been cancelled but hasn't
> +			 * quilt. Fail back to synchronous mode */

Typo.

>  			pthread_mutex_unlock(&ct->lock);
> -			condlog(3, "%s: tur thread not responding",
> +			condlog(3, "%s: tur checker failing back to
> sync",
>  				tur_devt(devt, sizeof(devt), ct));
> -			return PATH_TIMEOUT;
> +			return tur_check(c->fd, c->timeout,
> copy_msg_to_checker, c);
>  		}
>  		/* Start new TUR checker */
>  		ct->state = PATH_UNCHECKED;

Regards,
Martin
