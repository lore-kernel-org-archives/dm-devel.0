From: malahal@us.ibm.com
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Tue, 24 Nov 2009 11:17:04 -0800
Message-ID: <20091124191704.GB7971@us.ibm.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
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
> Yes, writes after the failed request are processed, but it is not a 
> problem --- if the write succeeded on all legs, it is returned as success 
> --- in this case, resychronization can't corrupt written data. If the 
> write succeeded only on some legs, it is held again.
> 
> So in practice, if some leg fails completely, all writes will be held.

I need to look at the code again, but I thought any new writes to a
failed region go to a surviving leg. In that case, we end up returning
I/O's to the application after writing to a single leg.
 
> > Also, we do need to do the above work only if "primary" leg fails. We
> > can continue to work just like the old code if "secondary" legs fail,
> > right? Not sure if this is worth optimizing though, but I would like to
> > see it implemented as it is just a few extra checks. We can have
> > primary_failure field like log_failure field.
 
> I thought about it too, but concluded that we need to hold bios even if 
> the primary leg fails.
> 
> Imagine this scenario:
> * secondary leg fails
> * write fails on the secondaty leg and succeeds on the primary leg 
> and is successfully complete
> * the computer crashes
> * after a reboot, the primary leg is inaccessible and the secondary leg is 
> back online --- now raid1 would be returning stale data.

The software can detect this case. We can fail this completely or use
the data from the secondary that could be "stale" with help from admin. 
Let us call this method 1.

> If we hold the bios if the secondary leg fails (as the patch does), one of 
> these two scenarios happen:
> 
> * secondary leg fails
> * write succeeds on the primary leg and is held
> * the computer crashes
> * after a reboot, the primary leg is inaccessible and the secondary leg is
> back online --- but we haven't completed the write, so the transaction 
> wasn't reported as committed
> 
> or
> 
> * secondary leg fails
> * write succeeds on the primary leg and is held
> * dmeventd removes the secondary leg and the write succeeds
> * the computer crashes
> * after a reboot, the primary leg is inaccessible, the secondary leg was 
> already removed by dmeventd, so the array is considered inaccessible. So 
> it doesn't work but at least it doesn't revert already committed 
> transaction.

How is this latter case (it doesn't need a crash anyway)
different/better from the case where we detect that 'primary' is missing
and ask admin if he wants to use the data on the secondary or not. At
least, the admin has a choice with "method 1" and this doesn't have that
choice.

Thanks, Malahal.
