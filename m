From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: access to snapshot deltas
Date: Fri, 8 Jun 2012 11:22:57 -0400
Message-ID: <20120608152257.GB11913@redhat.com>
References: <1339167366.25380.47.camel@pod.greynode.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1339167366.25380.47.camel@pod.greynode.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Benjamin S. Scarlet" <scarlet@alum.mit.edu>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jun 08 2012 at 10:56am -0400,
Benjamin S. Scarlet <scarlet@alum.mit.edu> wrote:

> Is there or could there be support for writing to a snapshot
> copy-on-write device from userspace? Are the bits contained therein
> portable between two snapshot instances with the same sizes of origin
> and copy-on-write devices?
> 
> I tried a simple experiment and caused Very Bad Things to happen (a
> kernel error claiming "BUG: Bad page state in process ..."), but I may
> have done something bogus. Before I proceeded with further experiments,
> I thought I'd ask what, if anything, ought to work.
> 
> My ultimate goal is to reduce downtime while migrating a virtual guest
> with its storage from one host to another. To that end what I'd like to
> do is:
> *) take a snapshot
> *) transfer the frozen view of the snapshot while the guest continues to
> run
> *) stop the guest on the original host
> *) transfer the deltas that have been written since the snapshot
> *) start the guest on the new host
> *) merge the deltas (assuming they weren't already merged during the
> transfer, depending on how that was done)
> 
> So please consider the following experiment, expressed mostly in terms
> of lvm tools rather than dmsetup, just because this way I think I'm
> giving myself fewer chances to mess up:
> 
> 1) create an LVM volume A to play the role of the original volume. Fill
> it up with some data.
> 2) create an LVM snapshot of A, A-snap.
> 3) create an LVM volume B to play the role of the destination volume,
> the same size as A.
> 4) copy (e.g. dd) from A into B, and simultaneously write some changes
> into A-snap.
> 5) create an LVM snapshot of B, B-snap.
> 5.5) cross your fingers 'cause here I'm heading into the unknown (for
> me)
> 6) dmsetup suspend something (if any variant would work, could someone
> tell me what?)
> 7) copy bits from A-snap-cow to B-snap-cow
> 8) dmsetup resume 
> 9) diff A-snap and B-snap and observe they're the same! (or so I would
> like)
> 10) proceed to use lvm to merge B-snap into B

Your best bet on a starting point for this will be to use the new
thin-provisioning target and its associated scalable snapshot support.

As of the latest Linux 3.5, it provides the ability to get a snapshot of
the metadata associated with snapshots, see this commit:
http://git.kernel.org/linus/cc8394d86f045b86ff303d3c9e4ce47d97148951

This allows you to have access to the incremental differences between
snapshots, etc.

Joe Thornber showed an example of how to do incremental backup -- in
terms of the thinp-test-suite (ruby) so there is a barrier to entry
there but it is a start on more details:
https://github.com/jthornber/thinp-test-suite/commit/4f126b48ebf73b392a507b3ccb58d12e28b81135

But the ability to merge the deltas from a snapshot into another
snapshot hasn't been exposed as a thinp primitive yet.
