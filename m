From: malahal@us.ibm.com
Subject: Re: [PATCH 7/7] Hold all write bios when errors are handled
Date: Wed, 25 Nov 2009 12:23:46 -0800
Message-ID: <20091125202346.GB1673@us.ibm.com>
References: <Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180712340.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180713150.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180718540.21358@hs20-bc2-1.build.redhat.com>
	<20091123055835.GA28981@us.ibm.com>
	<Pine.LNX.4.64.0911240638250.27545@hs20-bc2-1.build.redhat.com>
	<20091124191704.GB7971@us.ibm.com>
	<Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911250807500.14481@hs20-bc2-1.build.redhat.com>
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
> 
> > > Imagine this scenario:
> > > * secondary leg fails
> > > * write fails on the secondaty leg and succeeds on the primary leg 
> > > and is successfully complete
> > > * the computer crashes
> > > * after a reboot, the primary leg is inaccessible and the secondary leg is 
> > > back online --- now raid1 would be returning stale data.
> > 
> > The software can detect this case. We can fail this completely or use
> > the data from the secondary that could be "stale" with help from admin. 
> > Let us call this method 1.
> 
> You can't detect it because the computer crashed *before* you write the 
> information that the secondary leg failed to the metadata.
> 
> So, after a reboot, you can't tell if any mirror leg failed some requests 
> before the crash.

My definition of 'primary' is the first leg. Now on, I will use "first
leg" to avoid confusion.  On a reboot, LVM can find if its first leg is
missing. If it is missing, it can ask the admin whether to use the
'second' leg or not. When I said, "software" can detect, I really meant
that LVM can detect that the "first leg" is missing.

> > > If we hold the bios if the secondary leg fails (as the patch does), one of 
> > > these two scenarios happen:
> > > 
> > > * secondary leg fails
> > > * write succeeds on the primary leg and is held
> > > * the computer crashes
> > > * after a reboot, the primary leg is inaccessible and the secondary leg is
> > > back online --- but we haven't completed the write, so the transaction 
> > > wasn't reported as committed
> > > 
> > > or
> > > 
> > > * secondary leg fails
> > > * write succeeds on the primary leg and is held
> > > * dmeventd removes the secondary leg and the write succeeds
> > > * the computer crashes
> > > * after a reboot, the primary leg is inaccessible, the secondary leg was 
> > > already removed by dmeventd, so the array is considered inaccessible. So 
> > > it doesn't work but at least it doesn't revert already committed 
> > > transaction.
> > 
> > How is this latter case (it doesn't need a crash anyway)
> > different/better from the case where we detect that 'primary' is missing
> > and ask admin if he wants to use the data on the secondary or not. At
> > least, the admin has a choice with "method 1" and this doesn't have that
> > choice.
> 
> If you ask the admin always if primary leg failed and wait for his action, 
> you lose fault-tolerance --- the computer would wait until the admin does 
> an action.

Well, we are talking one time admin help at reboot [actually activation
time] if and only if the "state of the mirror" changed during reboot!
This is not applicable at run time. Most of the time, dmeventd will have
a chance to change the mirror to linear anyway.

> The requirements are:
> * if one of legs fail or log fails, you must automatically continue 
> without human intervention

This is satisfied. I was saying for the admin input only at reboot time.
What happens if first leg fails now? I think, activation fails and needs
to specify "--partial" or so.

> * if both legs fail, you must shut it down and not pretend that something 
> was written when it wasn't (this would break durability requirement of 
> transactions).

True.
