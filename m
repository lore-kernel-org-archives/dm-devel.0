From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [DRAFT] Snapshot boot design document
Date: Thu, 8 Jun 2017 15:32:22 +0100
Message-ID: <20170608143222.GA32358@dhcp-24-191.fab.redhat.com>
References: <20170601204734.GB3619@localhost.localdomain>
	<20170607162330.GA10393@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170607162330.GA10393@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thorsten Kukuk <kukuk@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Thorsten,

Thanks for looking at the proposal, and taking time to give feedback:
it's very much appreciated.

On Wed, Jun 07, 2017 at 06:23:30PM +0200, Thorsten Kukuk wrote:
> We use snapshots currently for another use case: transactional updates.
> Means, create a snapshot, update the system inside of the snapshot and
> if no error occurs, mark this snapshot as the new default root filesystem
> for the next reboot.

I think this is a sub-case of use case (4) on page 4 of v0.55. I'll
definitely add some text to make this clear though, as there are
different ways of using the snapshot in this case (update in snap,
and then switch or merge, or update in main and rollback).

> About Future extensions: I see 
> 1.4.1 Goal: Simplify management of large numbers of snapshots 
> 
> The biggest roblems we see with our customers are already very good
> summarized there, that's why I think this is something important
> for the tools, the one taking the snapshot and the boot manager.
> And should be for that reason not only be a future extension.

Agreed: I am pushing to include these future plans asap. The fact
they are listed separately is really more a consequence of how
the proposal came about (to address the booting problem), rather
than how we view their relative importance.

> Wish from me for a future extension:
> Automatic rollback on boot failure. If this happens after the root
> filesystem is mounted, it is pretty trivial. But if the problem is
> that the harddisk cannot be found, maybe because the kernel update
> has problems with the harddisk controller, this needs help of the
> boot manager.

This is a good point, and some boot loaders (grub2 e.g.) do have the
ability to record success or failure for a boot attempt, and to
modify behaviour on the next boot. Where possible we should make use
of this type of facility.

> 2 Linux boot process management
> 
> Isn't there "gummiboot" missing? To my knowledge this is needed
> for the Rasperry PI 3.

A very good point: if nothing else, gummiboot/systemd-boot is now
the reference implementation of the BootLoader Specification, which
is really key to the work that we are planning.

I'll add a section on this.
 
> Between, it's openSUSE, lower O, upper U, since the beginning.
> Same for SUSE, it's upper U since 18 years or so.

Ugh. Thank you for the correction - I have been writing these marks
wrongly for many, many years apparently. I'll get these fixed.

> 2.3.2 perl-Bootlaoder
> Support for anything else beside grub2 is, if not already removed,
> outdated and no longer official supported.

Ack, thanks. I'll add a note.

> 5.3.3 Support expiry of snapshots by user specified policy
> You should consider something like priorisation for snapshots. Else the
> result of a lot of small changes to config files can lead to deletion
> of snapshots with the real big changes.
> For that reason we had to introduce this for SLES, else a rollback
> wouldn't have been possible too fast.

Yes, this is something I've thought about, but didn't really have
a clear enough idea of to include so far. I'll think some more about
it - even just a quick summary as you've written might do for now,
so that the need does not get lost.

Thanks again for taking the time to look at this.

Regards,
Bryn.
