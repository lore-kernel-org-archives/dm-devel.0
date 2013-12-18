From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Wed, 18 Dec 2013 15:28:19 +0000
Message-ID: <1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52B1B046.3040301@suse.de>
Content-Language: en-US
Content-ID: <B4327428188B8443AA89B21F3687A7F6@hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, "Stewart, Sean" <Sean.Stewart@netapp.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, 2013-12-18 at 15:25 +0100, Hannes Reinecke wrote:
> On 12/18/2013 03:08 PM, Mike Snitzer wrote:
> > On Wed, Dec 18 2013 at  2:52am -0500,
> > Hannes Reinecke <hare@suse.de> wrote:
> > 
> >> The multipath kernel module is rejecting any map with an invalid
> >> device. However, as the multipathd is processing the events serially
> >> it will try to push a map with invalid devices if more than one
> >> device failed at the same time.
> >> So we can as well accept those maps and make sure to mark the
> >> paths as down.
> > 
> > Why is it so desirable to do this?  Reduced latency to restore at least
> > one valid path when a bunch of paths go down?
> > 
> Without this patch multipathd cannot update the map as long is
> hasn't catched up with udev.
> During that time any scheduling decisions by the kernel part are
> necessarily wrong, as it has to rely on the old map.
> 
> > Why can't we just rely on userspace eventually figuring out which paths
> > are failed and pushing a valid map down?
> > 
> Oh, you can. This is what we're doing now :-)
> 
> But it will lead to spurious error during failover when multipathd
> is trying to push down maps with invalid devices.
> 
> You are also running into a race window between checking the path in
> multipathd and pushing down the map; if the device disappears during
> that time you won't be able to push down the map.
> If that happens during boot multipathd won't be able to create the
> map at all, so you might not be able to boot here.
> With that patch you at least have the device-mapper device, allowing
> booting to continue.
> 
> > Are there favorable reports that this new behavior actually helps?
> > Please quantify how.
> > 
> NetApp will have; they've been pushing me to forward this patch.
> Sean?
> 
Agree.  Internally, we have run into numerous cases with Red Hat where
the "failed in domap" error will occur, due to user space being behind,
or device detaching taking too long.  The most severe case is with
InfiniBand, where the LLD may place a device offline, then every single
reload that is trying to add a good path in will fail.  I will qualify
this by saying that I realize it is a problem that the device gets
placed offline in the first place, but this patch would allow it a
chance to continue on. The user still has to take manual steps to fix
the problem in this case, but it seems less disruptive to applications.

The device detaching case could be kind of disruptive to a user in the
scenario they are upgrading the firmware on a NetApp E-Series box, and
with this patch, at least a good path is able to be added in ASAP.

> BTW, SUSE / SLES is running happily with this patch for years now.
> So it can't be at all bad ...
> 
> Cheers,
> 
> Hannes

Also agreed.  We have seen this functionality in SLES for years, and
have not run into a problem with it.

Thanks,
Sean
