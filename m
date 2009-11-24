From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Tue, 24 Nov 2009 06:51:39 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091123055835.GA28981@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> > -out:
> > -	bio_endio(bio, ret);
> > +	/*
> > +	 * In either case we must mark the region as NOSYNC.
> > +	 * That would block, so do it in the thread.
> > +	 */
> 
> What exactly you mean by "either case' here? "errors_handled" case or not?
> Need to adjust the comment as we don't do that check here anymore.

Yes. I mean both "errors_handled" case and "errors_not_handled".

> You seem to be holding the I/O that has failed, but what about writes
> that are issued after this failure. They seem to go through just fine.
> Did I miss something? I think do_writes() needs to check for a leg
> failure (just like it does for log_failure already), and put them on
> failure/hold list, right?

Yes, writes after the failed request are processed, but it is not a 
problem --- if the write succeeded on all legs, it is returned as success 
--- in this case, resychronization can't corrupt written data. If the 
write succeeded only on some legs, it is held again.

So in practice, if some leg fails completely, all writes will be held.

> Also, we do need to do the above work only if "primary" leg fails. We
> can continue to work just like the old code if "secondary" legs fail,
> right? Not sure if this is worth optimizing though, but I would like to
> see it implemented as it is just a few extra checks. We can have
> primary_failure field like log_failure field.
> 
> Thanks, Malahal.

I thought about it too, but concluded that we need to hold bios even if 
the primary leg fails.

Imagine this scenario:
* secondary leg fails
* write fails on the secondaty leg and succeeds on the primary leg 
and is successfully complete
* the computer crashes
* after a reboot, the primary leg is inaccessible and the secondary leg is 
back online --- now raid1 would be returning stale data.

In transaction processing applications, errorneous revert of committed 
transaction is worse problem than computer crash.


If we hold the bios if the secondary leg fails (as the patch does), one of 
these two scenarios happen:

* secondary leg fails
* write succeeds on the primary leg and is held
* the computer crashes
* after a reboot, the primary leg is inaccessible and the secondary leg is
back online --- but we haven't completed the write, so the transaction 
wasn't reported as committed

or

* secondary leg fails
* write succeeds on the primary leg and is held
* dmeventd removes the secondary leg and the write succeeds
* the computer crashes
* after a reboot, the primary leg is inaccessible, the secondary leg was 
already removed by dmeventd, so the array is considered inaccessible. So 
it doesn't work but at least it doesn't revert already committed 
transaction.

Mikulas
