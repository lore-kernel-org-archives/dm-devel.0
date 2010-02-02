From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Don't lose writes if errors are not handled
 and log fails
Date: Tue, 2 Feb 2010 08:00:56 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1002020755100.30625@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1001311530280.13480@hs20-bc2-1.build.redhat.com>
	<4B670EB6.5000201@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4B670EB6.5000201@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 1 Feb 2010, Takahiro Yasui wrote:

> > This fixes bug https://bugzilla.redhat.com/show_bug.cgi?id=555197
> > 
> > Please submit this patch before 2.6.33 goes out. It fixes a bug when old 
> > LVM (<= 2.02.51) is used, that doesn't pass errors_handled flag to 
> > dm-raid1.
> > 
> > It doesn't need to be backported to RHEL 5.5, because lvm always passes a 
> > flag to handle errors there.
> 
> Don't we need to backport it to RHEL 5.5? If lvm is the only user of dm-raid1,
> we don't need to backport it to RHEL 5.5. But if not, we need to.
> 
> > Don't lose writes if errors are not handled and log fails
> > 
> > If the log fails and errors are not handled by dmeventd, the writes
> > are successfully finished without being actually written to the device.
> > 
> > This code path is taken:
> > do_writes:
> > 	bio_list_merge(&ms->failures, &sync);
> > do_failures:
> > 	if (!get_valid_mirror(ms)) (false)
> > 	else if (errors_handled(ms)) (false)
> > 	else bio_endio(bio, 0);
> > 
> > The logic in do_failures is based on presuming that the write was already
> > tried --- if it succeeded at least on one leg and errors are not handled,
> > it is reported as success.
> > 
> > However, bio can be added to the failures queue without being submitted, in
> > do_writes.
> > 
> > This patch changes it so that bios are added to the failures list only if
> > errors are handled --- then, they will be held with hold_bio() called from
> > do_failures.
> 
> I agree that bios should be issued by do_write() when ms->log_failures is set,
> but do we need to add bios to the failures queue? As you mentioned, the failures
> queue should be used to bios which are already handled. Therefore, I think
> bios are better to handled directly by hold_bio() instead of adding them to
> the failures queue as bios for nosync regions are done.
> 
> -	if (unlikely(ms->log_failure)) {
> -		spin_lock_irq(&ms->lock);
> -		bio_list_merge(&ms->failures, &sync);
> -		spin_unlock_irq(&ms->lock);
> -		wakeup_mirrord(ms);
> -	} else
> -		while ((bio = bio_list_pop(&sync)))
> +	while ((bio = bio_list_pop(&sync)))
> +		if (unlikely(ms->log_failure) && errors_handled(ms))
> +			hold_bio(ms, bio);
> +		else
>  			do_write(ms, bio);

I thought about this too, but I'd decided to put the bios on the failures 
queue rather than holding them for this reason: if all the legs fail, it 
is better to terminate the bio with -EIO than to hold it. If all the legs 
fail, you can't save anything anyway and the less things you are holding, 
the less possibility for deadlocks exists.

So I put the bios to the failure queue and do_failures will terminate them 
with -EIO if all the legs failred and hold them if we use dmeventd and 
there is at least one live leg.

Mikulas

> The policy to treat bios when ms->log_failures == 1 is different, but
> the above code is based on the following patch.
> 
> https://www.redhat.com/archives/dm-devel/2009-December/msg00211.html
> 
> Thanks,
> Taka
> 
