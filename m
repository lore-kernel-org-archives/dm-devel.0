From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] Provide more fine grained control over multipathing
Date: Tue, 29 May 2018 19:27:18 -0400
Message-ID: <20180529232718.GA1730@redhat.com>
References: <20180525125322.15398-1-jthumshirn@suse.de>
 <20180525130535.GA24239@lst.de>
 <20180525135813.GB9591@redhat.com>
 <20180525141211.GA25971@lst.de>
 <20180525145056.GD9591@redhat.com>
 <yq1muwj45sg.fsf@oracle.com>
 <20180529030236.GA28895@redhat.com>
 <20180529072240.np5c62akbr7jqelr@linux-x5ow.site>
 <20180529080952.GA1369@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529080952.GA1369@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>, Laurence Oberman <loberman@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Ewan Milne <emilne@redhat.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Keith Busch <keith.busch@intel.com>, Hannes Reinecke <hare@suse.de>, Martin George <marting@netapp.com>, John Meneghini <John.Meneghini@netapp.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, May 29 2018 at  4:09am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, May 29, 2018 at 09:22:40AM +0200, Johannes Thumshirn wrote:
> > For a "Plan B" we can still use the global knob that's already in
> > place (even if this reminds me so much about scsi-mq which at least we
> > haven't turned on in fear of performance regressions).
> > 
> > Let's drop the discussion here, I don't think it leads to something
> > else than flamewars.
> 
> If our plan A doesn't work we can go back to these patches.  For now
> I'd rather have everyone spend their time on making Plan A work then
> preparing for contingencies.  Nothing prevents anyone from using these
> patches already out there if they really want to, but I'd recommend
> people are very careful about doing so as you'll lock yourself into
> a long-term maintainance burden.

Restating (for others): this patchset really isn't about contingencies.
It is about choice.

Since we're at an impasse, in the hopes of soliciting definitive
feedback from Jens and Linus, I'm going to attempt to reset the
discussion for their entry.

In summary, we have a classic example of a maintainer stalemate here:
1) Christoph, as NVMe co-maintainer, doesn't want to allow native NVMe
   multipath to actively coexist with dm-multipath's NVMe support on the
   same host.
2) I, as DM maintainer, would like to offer this flexibility to users --
   by giving them opt-in choice to continue using existing dm-multipath
   with NVMe. (also, both Red Hat and SUSE would like to offer this).

There is no technical reason why they cannot coexist.  Hence this simple
patchset that was originally offered by Johannes Thumshirn with
contributions from myself.

With those basics established, I'd like to ask:

Are we, as upstream kernel maintainers, really willing to force a
needlessly all-or-nothing multipath infrastructure decision on Linux
NVMe users with dm-multipath expertise?  Or should we also give them an
opt-in choice to continue using the familiar, mature, dm-multipath
option -- in addition to the new default native NVMe multipath that may,
in the long-term, be easier to use and more performant?

A definitive answer to this would be very helpful.

As you can see above, Christoph is refusing to allow the opt-in option. 
This will force enterprise Linux distributions to consider carrying the
patches on our own, in order to meet existing customer needs.  The
maintenance burden of this is unnecessary, and it goes against our
"upstream first" mantra.

I'm well past the point for wanting to reach closure on this issue.  But
I do feel strong enough about it that I'd be remiss not to solicit
feedback that lets us have no doubt about what the future holds for
upstream Linux's NVMe multipathing.

Please advise, thanks.
Mike

--
Additional background (for the benefit of others who haven't been
following along):

Jens, as block maintainer, took Christoph's NVMe change to have NVMe
internalize multiple paths to an NVMe subsystem.  This is referred to as
"native NVMe multipath" (see: commit 32acab3181).  As DM maintainer,
I've consistently requested we have the ability to allow users to opt-in
to exposing the underlying NVMe devices so that dm-multipath could
continue to provide a single interface for multipath configuration and
monitoring, see:
http://lists.infradead.org/pipermail/linux-nvme/2017-February/008256.html

Christoph rejected this on the principle that he dislikes the
dm-multipath architecture (being split between DM in kernel,
dm-mpath.ko, and userspace via multipathd; exposure of underlying
devices, less performant, etc).  So instead, dm-multipath was prevented
from seeing these individual paths because the NVMe driver hid them.
That is, unless CONFIG_NVME_MULTIPATH isn't set or nvme_core.multipath=N
is set.  And if either is used, users then cannot make use of native
NVMe multipath.  So currently, native NVMe multipath vs dm-multipath is
all-or-nothing.

The feeling is we should afford users the ability to continue using
dm-multipath at their choosing.  Hannes summarized the need for this
nicely here: https://lkml.org/lkml/2018/5/29/95

Please also note this from my first reply to this thread (here:
https://lkml.org/lkml/2018/5/25/438):
The ability to switch between "native" and "other" multipath absolutely
does _not_ imply anything about the winning disposition of native vs
other.  It is purely about providing commercial flexibility to use
whatever solution makes sense for a given environment.  The default _is_
native NVMe multipath.  It is on userspace solutions for "other"
multipath (e.g. multipathd) to allow user's to whitelist an NVMe
subsystem to be switched to "other".
