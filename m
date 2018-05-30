From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] Provide more fine grained control over multipathing
Date: Wed, 30 May 2018 15:59:42 -0400
Message-ID: <20180530195942.GC6568@redhat.com>
References: <20180525130535.GA24239@lst.de>
 <20180525135813.GB9591@redhat.com>
 <20180525141211.GA25971@lst.de>
 <20180525145056.GD9591@redhat.com>
 <yq1muwj45sg.fsf@oracle.com>
 <20180529030236.GA28895@redhat.com>
 <20180529072240.np5c62akbr7jqelr@linux-x5ow.site>
 <20180529080952.GA1369@lst.de>
 <20180529232718.GA1730@redhat.com>
 <f4951571-d37d-73cd-1d6c-0ca84647d5ac@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f4951571-d37d-73cd-1d6c-0ca84647d5ac@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux NVMe Mailinglist <linux-nvme@lists.infradead.org>, Laurence Oberman <loberman@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, Ewan Milne <emilne@redhat.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Keith Busch <keith.busch@intel.com>, Hannes Reinecke <hare@suse.de>, Martin George <marting@netapp.com>, John Meneghini <John.Meneghini@netapp.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 30 2018 at  3:05pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 5/29/18 5:27 PM, Mike Snitzer wrote:
> > On Tue, May 29 2018 at  4:09am -0400,
> > Christoph Hellwig <hch@lst.de> wrote:
> > 
> >> On Tue, May 29, 2018 at 09:22:40AM +0200, Johannes Thumshirn wrote:
> >>> For a "Plan B" we can still use the global knob that's already in
> >>> place (even if this reminds me so much about scsi-mq which at least we
> >>> haven't turned on in fear of performance regressions).
> >>>
> >>> Let's drop the discussion here, I don't think it leads to something
> >>> else than flamewars.
> >>
> >> If our plan A doesn't work we can go back to these patches.  For now
> >> I'd rather have everyone spend their time on making Plan A work then
> >> preparing for contingencies.  Nothing prevents anyone from using these
> >> patches already out there if they really want to, but I'd recommend
> >> people are very careful about doing so as you'll lock yourself into
> >> a long-term maintainance burden.
> > 
> > Restating (for others): this patchset really isn't about contingencies.
> > It is about choice.
> > 
> > Since we're at an impasse, in the hopes of soliciting definitive
> > feedback from Jens and Linus, I'm going to attempt to reset the
> > discussion for their entry.
> > 
> > In summary, we have a classic example of a maintainer stalemate here:
> > 1) Christoph, as NVMe co-maintainer, doesn't want to allow native NVMe
> >    multipath to actively coexist with dm-multipath's NVMe support on the
> >    same host.
> > 2) I, as DM maintainer, would like to offer this flexibility to users --
> >    by giving them opt-in choice to continue using existing dm-multipath
> >    with NVMe. (also, both Red Hat and SUSE would like to offer this).
> > 
> > There is no technical reason why they cannot coexist.  Hence this simple
> > patchset that was originally offered by Johannes Thumshirn with
> > contributions from myself.
> 
> Here's what I think - flag days tend to suck. They may be more convenient
> for developers, but they inflict pain on users. Sometimes they prevent
> them from moving forward, since updates are now gated on external
> dependencies. Moving forward with a new architecture is great, but
> proper care has to be given to existing users of multipath, regardless
> of how few they may be.

As I mentioned at the end of my summary (and in my first reply to this
0th header): it is on the "other" multipath toolchain to deal with
switching from "native" to "other" (by writing to 'mpath_personality').
For dm-multipath, it is multipathd that would trigger the switch from
"native" to "other" iff user opts-in by configuring multipath.conf to
own a particular NVMe subsystem's multipathing.

So users very likely won't ever have a need to write to
'mpath_personality'.  And as such, they'll just default to using
"native" NVMe multipath.

> This patchset seems pretty clean and minimalist. Realistically, I'm
> guessing that SUSE and RH will ship it regardless of upstream status.

TBD really.  We are keen to enable CONFIG_NVME_MULTIPATH to allow users
to use native (as the default!).  But we won't be able to do that unless
we have this patchset.  Because we really do _need_ to give our users
the option of continuing to use dm-multipath.

And as the Red Hat employee who would have to port it to each kernel (as
long as there is a need): _please_ don't make me do that.

PLEASE! ;)

Mike
