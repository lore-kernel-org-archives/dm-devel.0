From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Wed, 18 Dec 2013 15:28:52 +0000
Message-ID: <FB8A412F33166C4A930D37BD63236C902AD4A54A@SACEXCMBX02-PRD.hq.netapp.com>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <52B1B046.3040301@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "Stewart, Sean" <Sean.Stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> From: dm-devel-bounces@redhat.com [mailto:dm-devel-
> bounces@redhat.com] On Behalf Of Hannes Reinecke
> Sent: Wednesday, December 18, 2013 8:25 AM
> To: Mike Snitzer
> Cc: dm-devel@redhat.com; Stewart, Sean; Alasdair Kergon
> Subject: Re: [dm-devel] dm-multipath: Accept failed paths for multipath
> maps
> =

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
> =

> > Why can't we just rely on userspace eventually figuring out which paths
> > are failed and pushing a valid map down?
> >
> Oh, you can. This is what we're doing now :-)
> =

> But it will lead to spurious error during failover when multipathd
> is trying to push down maps with invalid devices.
> =

> You are also running into a race window between checking the path in
> multipathd and pushing down the map; if the device disappears during
> that time you won't be able to push down the map.
> If that happens during boot multipathd won't be able to create the
> map at all, so you might not be able to boot here.
> With that patch you at least have the device-mapper device, allowing
> booting to continue.
> =

> > Are there favorable reports that this new behavior actually helps?
> > Please quantify how.
> >
> NetApp will have; they've been pushing me to forward this patch.
> Sean?
Yes, we have been seeing these issues with RHEL where table-load fails if
not able to open at least one device in the map. This might be due to trans=
ient errors and
device being in offline state. Due to this add-path events fail and new pat=
hs will not be added to the map.
When we reboot the alternate controllers we see all path failures. We saw t=
his with IB and SAS configs.  =

This is much needed fix for us during controller firmware upgrade tests.
> =

> BTW, SUSE / SLES is running happily with this patch for years now.
> So it can't be at all bad ...
> =

> Cheers,
> =

> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
