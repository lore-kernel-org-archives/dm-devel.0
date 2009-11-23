From: malahal@us.ibm.com
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Sun, 22 Nov 2009 21:58:35 -0800
Message-ID: <20091123055835.GA28981@us.ibm.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka [mpatocka@redhat.com] wrote:
> Index: linux-2.6.31.6-fast/drivers/md/dm-raid1.c
> -	if (unlikely(!uptodate)) {
> -		DMERR("All replicated volumes dead, failing I/O");
> -		/* None of the writes succeeded, fail the I/O. */
> -		ret = -EIO;
> -	} else if (errors_handled(ms)) {
> -		/*
> -		 * Need to raise event.  Since raising
> -		 * events can block, we need to do it in
> -		 * the main thread.
> -		 */
> -		spin_lock_irqsave(&ms->lock, flags);
> -		bio_list_add(&ms->failures, bio);
> -		spin_unlock_irqrestore(&ms->lock, flags);
> -		wakeup_mirrord(ms);
> -		return;
> -	}
> -out:
> -	bio_endio(bio, ret);
> +	/*
> +	 * In either case we must mark the region as NOSYNC.
> +	 * That would block, so do it in the thread.
> +	 */

What exactly you mean by "either case' here? "errors_handled" case or not?
Need to adjust the comment as we don't do that check here anymore.

> @@ -730,10 +719,25 @@ static void do_failures(struct mirror_se
>  		if (!ms->log_failure) {
>  			ms->in_sync = 0;
>  			dm_rh_mark_nosync(ms->rh, bio);
> +		}
> +		/*
> +		 * If all the legs are dead, fail the I/O.
> +		 *
> +		 * If we are not using dmeventd, we pretend that the I/O
> +		 * succeeded. This is wrong (the failed leg might come online
> +		 * again after reboot and it would be replicated back to
> +		 * the good leg) but it is consistent with current behavior.
> +		 * For proper behavior, dm-raid1 shouldn't be used without
> +		 * dmeventd at all.
> +		 *
> +		 * If we use dmeventd, hold the bio until dmeventd does its job.
> +		 */
> +		if (!get_valid_mirror(ms))
> +			bio_endio(bio, -EIO);
> +		else if (!errors_handled(ms))
>  			bio_endio(bio, 0);
> -		} else {
> +		else
>  			hold_bio(ms, bio);

You seem to be holding the I/O that has failed, but what about writes
that are issued after this failure. They seem to go through just fine.
Did I miss something? I think do_writes() needs to check for a leg
failure (just like it does for log_failure already), and put them on
failure/hold list, right?

Also, we do need to do the above work only if "primary" leg fails. We
can continue to work just like the old code if "secondary" legs fail,
right? Not sure if this is worth optimizing though, but I would like to
see it implemented as it is just a few extra checks. We can have
primary_failure field like log_failure field.

Thanks, Malahal.
