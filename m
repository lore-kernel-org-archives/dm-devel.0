From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/13] dm-mpath: Micro-optimize the hot path
Date: Thu, 27 Apr 2017 08:36:22 +0200
Message-ID: <9474724d-17e1-176a-fa3b-4ae857fa2e93@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-12-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-12-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> Instead of checking MPATHF_QUEUE_IF_NO_PATH,
> MPATHF_SAVED_QUEUE_IF_NO_PATH and the no_flush flag to decide whether
> or not to push back a request if there are no paths available, only
> clear MPATHF_QUEUE_IF_NO_PATH in queue_if_no_path() if no_flush has
> not been set. The result is that only a single bit has to be tested
> in the hot path to decide whether or not a request must be pushed
> back and also that m->lock does not have to be taken in the hot path.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-mpath.c | 70 ++++++++-------------------------------------=
------
>  1 file changed, 11 insertions(+), 59 deletions(-)
> =

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index adde8a51e020..0eafe7a2070b 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -442,47 +442,6 @@ static struct pgpath *choose_pgpath(struct multipath=
 *m, size_t nr_bytes)
>  }
>  =

>  /*
> - * Check whether bios must be queued in the device-mapper core rather
> - * than here in the target.
> - *
> - * If m->queue_if_no_path and m->saved_queue_if_no_path hold the
> - * same value then we are not between multipath_presuspend()
> - * and multipath_resume() calls and we have no need to check
> - * for the DMF_NOFLUSH_SUSPENDING flag.
> - */
> -static bool __must_push_back(struct multipath *m)
> -{
> -	return ((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=3D
> -		 test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> -		dm_noflush_suspending(m->ti));
> -}
> -
> -static bool must_push_back_rq(struct multipath *m)
> -{
> -	bool r;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&m->lock, flags);
> -	r =3D (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
> -	     __must_push_back(m));
> -	spin_unlock_irqrestore(&m->lock, flags);
> -
> -	return r;
> -}
> -
> -static bool must_push_back_bio(struct multipath *m)
> -{
> -	bool r;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&m->lock, flags);
> -	r =3D __must_push_back(m);
> -	spin_unlock_irqrestore(&m->lock, flags);
> -
> -	return r;
> -}
> -
> -/*
>   * Map cloned requests (request-based multipath)
>   */
>  static int multipath_clone_and_map(struct dm_target *ti, struct request =
*rq,
> @@ -503,7 +462,7 @@ static int multipath_clone_and_map(struct dm_target *=
ti, struct request *rq,
>  		pgpath =3D choose_pgpath(m, nr_bytes);
>  =

>  	if (!pgpath) {
> -		if (must_push_back_rq(m)) {
> +		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
>  			pr_debug("no path - requeueing\n");
>  			return DM_MAPIO_DELAY_REQUEUE;
>  		}
> @@ -581,9 +540,9 @@ static int __multipath_map_bio(struct multipath *m, s=
truct bio *bio, struct dm_m
>  	}
>  =

>  	if (!pgpath) {
> -		if (!must_push_back_bio(m))
> -			return -EIO;
> -		return DM_MAPIO_REQUEUE;
> +		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
> +			return DM_MAPIO_REQUEUE;
> +		return -EIO;
>  	}
>  =

>  	mpio->pgpath =3D pgpath;
> @@ -675,7 +634,7 @@ static int queue_if_no_path(struct multipath *m, bool=
 queue_if_no_path,
>  		else
>  			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
>  	}
> -	if (queue_if_no_path)
> +	if (queue_if_no_path || dm_noflush_suspending(m->ti))
>  		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
>  	else
>  		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> @@ -1523,12 +1482,9 @@ static int do_end_io(struct multipath *m, struct r=
equest *clone,
>  	if (mpio->pgpath)
>  		fail_path(mpio->pgpath);
>  =

> -	if (!atomic_read(&m->nr_valid_paths)) {
> -		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
> -			if (!must_push_back_rq(m))
> -				r =3D -EIO;
> -		}
> -	}
> +	if (atomic_read(&m->nr_valid_paths) =3D=3D 0 &&
> +	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
> +		r =3D -EIO;
>  =

>  	return r;
>  }
> @@ -1569,13 +1525,9 @@ static int do_end_io_bio(struct multipath *m, stru=
ct bio *clone,
>  	if (mpio->pgpath)
>  		fail_path(mpio->pgpath);
>  =

> -	if (!atomic_read(&m->nr_valid_paths)) {
> -		if (!test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
> -			if (!must_push_back_bio(m))
> -				return -EIO;
> -			return DM_ENDIO_REQUEUE;
> -		}
> -	}
> +	if (atomic_read(&m->nr_valid_paths) =3D=3D 0 &&
> +	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
> +		return -EIO;
>  =

>  	/* Queue for the daemon to resubmit */
>  	dm_bio_restore(get_bio_details_from_bio(clone), clone);
> =


_Looks_ okay.
But the entire 'must_push_back' stuff is so convoluted (plus not
actually required for rq-based multipathing) that I'll leave the final
decision to Mike.
But anyway:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
