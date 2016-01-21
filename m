From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 20 Jan 2016 18:38:59 -0600
Message-ID: <20160121003859.GL24960@octiron.msp.redhat.com>
References: <56961493.5010901@suse.de>
	<20160113175239.GE24960@octiron.msp.redhat.com>
	<56974D80.2020803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56974D80.2020803@suse.de>
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
List-Id: dm-devel.ids

On Thu, Jan 14, 2016 at 08:25:52AM +0100, Hannes Reinecke wrote:
> On 01/13/2016 06:52 PM, Benjamin Marzinski wrote:
> >On Wed, Jan 13, 2016 at 10:10:43AM +0100, Hannes Reinecke wrote:
> >>b) leverage topology information from scsi_dh_alua (which we will
> >>    have once my ALUA handler update is in) to detect the multipath
> >>    topology. This removes the need of a 'prio' infrastructure
> >>    in multipath-tools
> >
> >What about devices that don't use alua? Or users who want to be able to
> >pick a specific path to prefer? While I definitely prefer simple, we
> >can't drop real funtionality to get there. Have you posted your
> >scsi_dh_alua update somewhere?
> >
> Yep. Check the linux-scsi mailing list.

But we still need to be able to handle non-alua devices.

> =

> >I've recently had requests from users to
> >1. make a path with the TPGS pref bit set be in its own path group with
> >the highest priority
> Isn't that always the case?
> Paths with TPGS pref bit set will have a different priority than those
> without the pref bit, and they should always have the highest priority.
> I would rather consider this an error in the prioritizer ...

For a while that was the case.

commit b330bf8a5e6a29b51af0d8b4088e0d8554e5cfb4

changed that, and you sent it. Now, if a the preferred path is
active/optimized, it will get placed in a priority group with other
active/optimized paths.  The SCSI spec is kind of unclear about how to
handle the preferred bit, so I can see either way making sense. When the
path with the preferred bit was all by itself, I had requests to group
it like this.  Now that it gets grouped, I have requests to make it in
its own priority group.  I'm pretty sure that the real answer is to
allow users to choose how to use the pref bit when grouping paths.

> >>c) implement block or scsi events whenever a remote port becomes
> >>    unavailable. This removes the need of the 'path_checker'
> >>    functionality in multipath-tools.
> >
> >I'm not convinced that we will be able to find out when paths come back
> >online in all cases without some sort of actual polling. Again, I'd love
> >this to be simpler, but asking all the types of storage we plan to
> >support to notify us when they are up and down may not be realistic.
> >
> Currently we have three main transports: FC, iSCSI, and SAS.
> FC has reliable path events via RSCN, as this is also what the drivers re=
ly
> on internally (hello, zfcp :-)
> If _that_ doesn't work we're in a deep hole anyway, cf the eh_deadline
> mechanism we had to implement.

I do remember issues over the years where paths have failed without a
RSCNs being generated (brocade switches come to mind, IIRC). And simply
because people are quicker to notice when a failed path isn't getting
dealt with, than they are about a path coming back isn't getting dealt
with, I do worry that we'll find instances where paths are coming back
without RSCNs. And while multipathd's preemptive path checking is nice
to have.  Finding out when the failed paths are usable again is the
really important thing it does.

> =


> iSCSI has the NOP mechanism, which in effect is polling on the iSCSI leve=
l.
> That would provide equivalent information; unfortunately not every target
> supports that.
> But even without iSCSI has it's own error recovery logic, which will kick=
 in
> whenever an error is detected. So we can as well hook into that and use it
> to send events.
> And for SAS we have a far better control over the attached fabric, so it
> should be possible to get reliable events there, too.
> =

> That only leaves the non-transport drivers like virtio or the various
> RAID-like cards, which indeed might not be able to provide us with events.
> =

> So I would propose to make that optional; if events are supported (which
> could be figured out via sysfs) we should be using them and don't insist =
on
> polling, but fall back to the original methods if we don't have them.

As long as there are failbacks that can be used for cases where we arent
getting the events that we need. I'm not against multipath leveraging
the layers beneath it for this information.
 =

> >>d) leverage these events to handle path-up/path-down events
> >>    in-kernel
> >
> >If polling is necessary, I'd rather it be done in userspace. Personally,
> >I think the checker code is probably the least obectionable part of the
> >multipath-tools (It's getting all the device information to set up the
> >devices in the first place and coordinating with uevents that's really
> >ugly, IMHO).
> >
> And this is where I do disagree.
> The checker code is causing massive lock congestion on large-scale systems
> as there is precisely _one_ checker thread, having to check all devices
> serially. If paths go down on a large system we're having a flood of udev
> events, which we cannot handle in-time as the checkerloop holds the lock
> trying to check all those paths.
> =

> So being able to do away with the checkerloop is a major improvement ther=
e.

But what replaces in for the cases where we do need to poll the device?

I'm not going to argue that multipathd's locking and threading are well
designed. Certainly, uevents *should* be able to continue to be
processed while the checker thread is running. We only need to lock the
vectors while we are changing or traversing them, and with the addition
of some in_use counters we would could get by with very minimal locking
on the paths/maps themselves.

My personal daydream has always been to get rid of the event waiter
threads, since we already get uevents for pretty much all the things
they care about.

-Ben

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
