From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Snapshot patches (cluster-aware, merge, and shared)
Date: Sat, 12 Sep 2009 02:25:57 -0400
Message-ID: <20090912062556.GA1804@redhat.com>
References: <1252698351.16497.7.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1252698351.16497.7.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 11 2009 at  3:45pm -0400,
Jonathan Brassow <jbrassow@redhat.com> wrote:

> I've made it through most of the patches that were in mike's directory
> regarding merging
> (http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.31).  Everything compiles and I believe I've moved all the logic to the right places.
> 
> At this point, I have yet to:
> 1) go over the merge patches and ensure I haven't missed/overlooked
> something
> 2) Include changes posted by Mike on 9/11/09 for merge speed-ups
> 3) test
> 4) update headers on my patches
> 5) request ACKs for my patches and put ACKs on remaining merge/shared
> patches
> 
> I'm getting these out a little early so you can see where I'm at and we
> can hopefully make the merge window.


Jon,

I did my best to audit the snapshot-merge patches now that they are
layered on your clusterized exception store patches.  I uncovered a few
things that were missing; can provide details later if you like but the
revised patches tell the tale.  I also ported the merge speed-up patch
(dm-snapshot-merge-use-larger-io-when-merging.patch). All snapshot-merge
patches were compile tested to be bisectable; meaning each patch
compiles and the resulting dm-snapshot.ko loads cleanly.

But unfortunately when I only apply all of your patches (everything up
to the start of the snapshot-merge patches) I'm left with a dm-snapshot
that fails to work properly: snapshot LV fails my ext3 mount LVM
testsuite test that I posted to lvm-devel some weeks ago (sans the 4K
aspect; I didn't actually use the test script; I did the mount/unmount
procedure manually on a 512b sector drive).

I've uploaded a revised copy of your quilt tree here:
http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel_unified/2.6.31/

Here is the diffstat of what I changed (started with your tarball):

 dm-bufio.patch                                                                   |   22 -
 dm-exception-store-merge-methods.patch                                           |    6
 dm-multisnap-fujita-daniel.patch                                                 |   32 +-
 dm-multisnap-mikulas.patch                                                       |  120 +++----
 dm-snapshot-find-merging-snapshot.patch                                          |    2
 dm-snapshot-find-min-chunksize-function.patch                                    |    2
 dm-snapshot-merge-interlock-writes.patch                                         |   57 ++-
 dm-snapshot-merge-make-exceptions-in-other-snapshots-if-remapped-to-origin.patch |    2
 dm-snapshot-merge-make-exceptions-in-other-snapshots-when-merging.patch          |   11
 dm-snapshot-merge-operation.patch                                                |   24 -
 dm-snapshot-merge-redirect-to-origin-if-invalidated.patch                        |    4
 dm-snapshot-merge-track-writes.patch                                             |   39 --
 dm-snapshot-merge-use-larger-io-when-merging.patch                               |  160 ++++++++++
 series                                                                           |    8
 14 files changed, 313 insertions(+), 176 deletions(-)
